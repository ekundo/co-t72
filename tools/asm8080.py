#!/usr/bin/env python3
"""Ассемблер Intel 8080 для программ под МикроДОС.

    ./asm8080.py hdir.asm -o HDIR.COM [-l hdir.lst]

Синтаксис как в исходниках T-72 (TASM): метка в начале строки, точка с запятой
-- комментарий, числа `1234h` / `0FFh` / десятичные / `'A'`. Директивы:

    ORG, EQU, DB (.db), DW (.dw), DS (.ds), END

Строки в DB пишутся в UTF-8, а в файл идут в КОИ-8: это кодировка экрана
Вектора, других русских букв система не понимает.

Таблица мнемоник не набита руками, а вывернута из dis8080.py -- одна таблица на
ассемблер и дизассемблер, разойтись они не могут. Из неудокументированных
дублей (JMP CBh, CALL DDh и прочих) берётся младший код -- канонический.
"""

import argparse
import itertools
import re
import sys

from dis8080 import OPS

REGS = {'A', 'B', 'C', 'D', 'E', 'H', 'L', 'M', 'SP', 'PSW'}


def build_table():
    """(мнемоника, операнды) -> (код, длина). '#' -- непосредственное значение,
       '@' -- адрес; чем именно оно окажется, решает длина команды."""
    table = {}
    for op, (text, ln, _) in OPS.items():
        if text.startswith('DB'):
            continue                      # неиспользуемый код, не мнемоника
        head, _, tail = text.partition(' ')
        key = (head.strip(), tuple(x.strip() for x in tail.split(',') if x.strip()))
        if key not in table or op < table[key][0]:
            table[key] = (op, ln)
    return table


TABLE = build_table()
MNEMONICS = {m for m, _ in TABLE}


class Error(Exception):
    pass


def split_commas(s):
    """Разбить по запятым верхнего уровня -- в строковых литералах запятая своя."""
    out, cur, quote = [], '', None
    for ch in s:
        if quote:
            cur += ch
            if ch == quote:
                quote = None
        elif ch in '\'"':
            quote, cur = ch, cur + ch
        elif ch == ',':
            out.append(cur.strip())
            cur = ''
        else:
            cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def strip_comment(line):
    quote = None
    for i, ch in enumerate(line):
        if quote:
            if ch == quote:
                quote = None
        elif ch in '\'"':
            quote = ch
        elif ch == ';':
            return line[:i]
    return line


NUM_HEX = re.compile(r"\b([0-9][0-9A-Fa-f]*)[hH]\b")
NUM_BIN = re.compile(r"\b([01]+)[bB]\b")
CHAR = re.compile(r"'(.)'")


class Asm:
    def __init__(self):
        self.sym = {}
        self.pc = 0x100
        self.out = bytearray()
        self.org = None
        self.listing = []

    # ---------------- выражения ----------------

    def value(self, expr, pc):
        e = expr.strip()
        if not e:
            raise Error('пустое выражение')
        e = CHAR.sub(lambda m: str(ord(m.group(1).encode('koi8-r'))), e)
        e = NUM_HEX.sub(lambda m: '0x' + m.group(1), e)
        e = NUM_BIN.sub(lambda m: '0b' + m.group(1), e)
        e = e.replace('$', '__pc__')
        env = dict(self.sym, __pc__=pc)
        try:
            v = eval(e, {'__builtins__': {}}, env)          # noqa: S307 -- свой файл
        except NameError as ex:
            raise Error('неизвестное имя в "%s": %s' % (expr, ex))
        except Exception as ex:
            raise Error('не разобрать "%s": %s' % (expr, ex))
        return int(v) & 0xFFFF

    def data_bytes(self, args, pc):
        out = bytearray()
        for a in args:
            if a[:1] in ('"', "'") and len(a) > 2 and a[-1] == a[0]:
                out += a[1:-1].encode('koi8-r')
            else:
                out.append(self.value(a, pc) & 0xFF)
        return out

    # ---------------- команды ----------------

    def encode(self, mnem, args, pc, resolve):
        """Собрать команду. resolve=False -- первый проход, значения не нужны,
           важна только длина."""
        if mnem == 'RST':                 # номер вектора -- часть самой мнемоники
            args = [str(self.value(args[0], pc))]
        cands = []
        for a in args:
            u = a.upper()
            cands.append([u] if u in REGS else ['#', '@', u])
        for combo in itertools.product(*cands) if args else [()]:
            hit = TABLE.get((mnem, combo))
            if hit:
                break
        else:
            raise Error('нет такой команды: %s %s' % (mnem, ','.join(args)))
        op, ln = hit
        code = bytearray([op])
        if ln > 1:
            src = [a for a, c in zip(args, combo) if c in '#@'][0]
            v = self.value(src, pc) if resolve else 0
            code.append(v & 0xFF)
            if ln == 3:
                code.append(v >> 8)
        return code

    # ---------------- проходы ----------------

    def line(self, raw, resolve):
        """Вернуть байты строки; во время первого прохода значения не считаются."""
        line = strip_comment(raw).rstrip()
        if not line.strip():
            return b''
        # Метка -- имя с двоеточием либо имя перед EQU; без этого правила `MOV A,B`
        # с нулевой позиции не отличить от метки.
        label = None
        m = re.match(r'^([A-Za-z_?][A-Za-z0-9_?]*)\s*(:|\s+EQU\b)', line, re.I)
        if m:
            label = m.group(1)
            line = line[m.end(1):].lstrip(': \t')
        rest = line.strip()
        head, _, tail = rest.partition(' ')
        head_u = head.upper().lstrip('.')
        args = split_commas(tail)

        if head_u == 'EQU':
            self.sym[label] = self.value(tail, self.pc)
            return b''
        if label is not None:
            if resolve and self.sym.get(label) != self.pc:
                raise Error('метка %s разъехалась между проходами' % label)
            self.sym[label] = self.pc
        if not rest:
            return b''

        if head_u == 'ORG':
            self.pc = self.value(tail, self.pc)
            if self.org is None:
                self.org = self.pc
            return b''
        if head_u == 'END':
            return b''
        if head_u == 'DB':
            return bytes(self.data_bytes(args, self.pc))
        if head_u == 'DW':
            out = bytearray()
            for a in args:
                v = self.value(a, self.pc) if resolve else 0
                out += bytes([v & 0xFF, v >> 8])
            return bytes(out)
        if head_u == 'DS':
            return b'\0' * self.value(tail, self.pc)
        if head_u in MNEMONICS:
            return bytes(self.encode(head_u, args, self.pc, resolve))
        raise Error('не понял строку: %s' % raw.strip())

    def pass_over(self, lines, resolve):
        self.pc = self.org or 0x100
        self.out = bytearray()
        self.listing = []
        for n, raw in enumerate(lines, 1):
            try:
                code = self.line(raw, resolve)
            except Error as ex:
                sys.exit('строка %d: %s\n  %s' % (n, ex, raw.rstrip()))
            if resolve:
                self.listing.append('%04X %-14s %s' %
                                    (self.pc, code[:5].hex().upper(), raw.rstrip()))
            self.out += code
            self.pc += len(code)

    def assemble(self, text):
        lines = text.splitlines()
        self.pass_over(lines, False)
        start = self.org
        self.pass_over(lines, True)
        return start, bytes(self.out)


def main():
    p = argparse.ArgumentParser(description='ассемблер 8080')
    p.add_argument('source')
    p.add_argument('-o', '--out', required=True)
    p.add_argument('-l', '--listing')
    a = p.parse_args()

    asm = Asm()
    org, code = asm.assemble(open(a.source, encoding='utf-8').read())
    open(a.out, 'wb').write(code)
    if a.listing:
        open(a.listing, 'w', encoding='utf-8').write('\n'.join(asm.listing) + '\n')
    sys.stderr.write('%s: %04Xh..%04Xh, %d байт\n' %
                     (a.out, org, org + len(code) - 1, len(code)))


if __name__ == '__main__':
    main()
