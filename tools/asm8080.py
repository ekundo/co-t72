#!/usr/bin/env python3
"""Ассемблер 8080: из .asm в .COM.

Писать редактор, вбивая байты руками, невозможно, а тащить чужой ассемблер под
эту задачу дороже, чем написать свой: система команд у 8080 маленькая и ровная.

Поддерживается то, что нужно для дела:
  * метки, `EQU`, `ORG`, `DB` (числа и строки), `DW`, `DS`;
  * выражения с метками, `$`, скобками и `+ - * / & | << >>`;
  * числа: `1234`, `0FFh`, `0x1F`, `'A'`, `%1010`;
  * строки в `DB` — в КОИ-8, чтобы русский текст писался как есть.

Ошибка в метке или выражении -- это отказ сборки с номером строки, а не тихо
собранный мусор: на восьмибитке отладка такого стоит дорого.
"""

import argparse
import re
import sys

R8 = {'B': 0, 'C': 1, 'D': 2, 'E': 3, 'H': 4, 'L': 5, 'M': 6, 'A': 7}
RP = {'B': 0, 'D': 1, 'H': 2, 'SP': 3}
RPP = {'B': 0, 'D': 1, 'H': 2, 'PSW': 3}

NOARG = {
    'NOP': 0x00, 'RLC': 0x07, 'RRC': 0x0F, 'RAL': 0x17, 'RAR': 0x1F,
    'DAA': 0x27, 'CMA': 0x2F, 'STC': 0x37, 'CMC': 0x3F, 'HLT': 0x76,
    'RET': 0xC9, 'XCHG': 0xEB, 'XTHL': 0xE3, 'SPHL': 0xF9, 'PCHL': 0xE9,
    'EI': 0xFB, 'DI': 0xF3,
    'RNZ': 0xC0, 'RZ': 0xC8, 'RNC': 0xD0, 'RC': 0xD8,
    'RPO': 0xE0, 'RPE': 0xE8, 'RP': 0xF0, 'RM': 0xF8,
}
ARITH = {'ADD': 0x80, 'ADC': 0x88, 'SUB': 0x90, 'SBB': 0x98,
         'ANA': 0xA0, 'XRA': 0xA8, 'ORA': 0xB0, 'CMP': 0xB8}
IMM8 = {'ADI': 0xC6, 'ACI': 0xCE, 'SUI': 0xD6, 'SBI': 0xDE,
        'ANI': 0xE6, 'XRI': 0xEE, 'ORI': 0xF6, 'CPI': 0xFE,
        'IN': 0xDB, 'OUT': 0xD3}
JUMP = {'JMP': 0xC3, 'JNZ': 0xC2, 'JZ': 0xCA, 'JNC': 0xD2, 'JC': 0xDA,
        'JPO': 0xE2, 'JPE': 0xEA, 'JP': 0xF2, 'JM': 0xFA,
        'CALL': 0xCD, 'CNZ': 0xC4, 'CZ': 0xCC, 'CNC': 0xD4, 'CC': 0xDC,
        'CPO': 0xE4, 'CPE': 0xEC, 'CP': 0xF4, 'CM': 0xFC,
        'LDA': 0x3A, 'STA': 0x32, 'LHLD': 0x2A, 'SHLD': 0x22}


class AsmError(Exception):
    pass


def split_args(s):
    """Разделить операнды запятыми, не трогая запятые внутри кавычек."""
    out, cur, q = [], '', None
    for ch in s:
        if q:
            cur += ch
            if ch == q:
                q = None
        elif ch in '\'"':
            q = ch
            cur += ch
        elif ch == ',':
            out.append(cur.strip())
            cur = ''
        else:
            cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


class Asm:
    def __init__(self):
        self.sym = {}
        self.final = False
        self.pc = 0
        self.out = bytearray()
        self.org = None

    # --- выражения -------------------------------------------------------
    def value(self, expr, line):
        e = expr.strip()
        if not e:
            raise AsmError('пустое выражение')
        py = []
        i = 0
        while i < len(e):
            c = e[i]
            if c == '$' and (i + 1 >= len(e) or not e[i + 1].isalnum()):
                py.append(str(self.pc)); i += 1
            elif c == "'":
                j = e.index("'", i + 1)
                token = e[i + 1:j]
                if len(token) != 1:
                    raise AsmError('символьная константа должна быть одним знаком')
                py.append(str(ord(token.encode('koi8-r')))); i = j + 1
            elif c == '%':
                j = i + 1
                while j < len(e) and e[j] in '01':
                    j += 1
                py.append(str(int(e[i + 1:j], 2))); i = j
            elif c.isdigit():
                j = i
                while j < len(e) and (e[j].isalnum() or e[j] == 'x'):
                    j += 1
                t = e[i:j]
                if t.lower().endswith('h'):
                    py.append(str(int(t[:-1], 16)))
                elif t.lower().startswith('0x'):
                    py.append(str(int(t, 16)))
                elif t.lower().endswith('b') and set(t[:-1]) <= set('01'):
                    py.append(str(int(t[:-1], 2)))
                else:
                    py.append(str(int(t, 10)))
                i = j
            elif c.isalpha() or c == '_' or c == '.':
                j = i
                while j < len(e) and (e[j].isalnum() or e[j] in '_.'):
                    j += 1
                name = e[i:j].upper()
                if name not in self.sym:
                    # первый проход: метка ещё впереди. Подставляем ноль, но
                    # байты всё равно выпускаем -- иначе адреса уедут.
                    if self.final:
                        raise AsmError('неизвестная метка %s' % name)
                    py.append('0')
                else:
                    py.append(str(self.sym[name]))
                i = j
            else:
                py.append(c); i += 1
        try:
            return eval(''.join(py)) & 0xFFFF
        except AsmError:
            raise
        except Exception:
            raise AsmError('не понял выражение %r' % expr)

    def emit(self, *b):
        self.out += bytes(x & 0xFF for x in b)
        self.pc += len(b)

    def emit16(self, v):
        self.emit(v & 0xFF, (v >> 8) & 0xFF)

    # --- разбор одной строки ---------------------------------------------
    def line(self, raw, lineno, final):
        s = re.sub(r";.*$", '', raw).strip()
        if not s:
            return
        m = re.match(r'^([A-Za-z_.][A-Za-z0-9_.]*):\s*(.*)$', s)
        label = None
        if m:
            label, s = m.group(1).upper(), m.group(2).strip()
        if label and not final:
            if label in self.sym and self.sym[label] != self.pc:
                pass          # второй проход уточняет
            self.sym[label] = self.pc
        if not s:
            return
        parts = s.split(None, 1)
        op = parts[0].upper()
        rest = parts[1] if len(parts) > 1 else ''
        args = split_args(rest)

        if op == 'EQU':
            raise AsmError('EQU без метки')
        if len(args) >= 1 and op in ('EQU', '='):
            raise AsmError('EQU без метки')
        # метка EQU значение
        if op == 'ORG':
            v = self.value(args[0], lineno)
            if self.org is None:
                self.org = v
            else:
                while self.pc < v:
                    self.emit(0)
            self.pc = v
            return
        if op == 'DB':
            for a in args:
                a = a.strip()
                if a and a[0] in '\'"' and len(a) > 2:
                    self.out += a[1:-1].encode('koi8-r')
                    self.pc += len(a[1:-1].encode('koi8-r'))
                else:
                    self.emit(self.value(a, lineno))
            return
        if op == 'DW':
            for a in args:
                self.emit16(self.value(a, lineno))
            return
        if op == 'DS':
            n = self.value(args[0], lineno)
            self.emit(*([0] * n))
            return

        if op in NOARG:
            if args:
                raise AsmError('%s не берёт операндов' % op)
            return self.emit(NOARG[op])
        if op == 'MOV':
            d, s2 = args[0].upper(), args[1].upper()
            if d not in R8 or s2 not in R8:
                raise AsmError('MOV: неизвестный регистр')
            if d == 'M' and s2 == 'M':
                raise AsmError('MOV M,M не существует')
            return self.emit(0x40 + R8[d] * 8 + R8[s2])
        if op == 'MVI':
            d = args[0].upper()
            return self.emit(0x06 + R8[d] * 8, self.value(args[1], lineno))
        if op == 'LXI':
            rp = args[0].upper()
            self.emit(0x01 + RP[rp] * 16)
            return self.emit16(self.value(args[1], lineno))
        if op in ('INX', 'DCX', 'DAD'):
            rp = RP[args[0].upper()]
            base = {'INX': 0x03, 'DCX': 0x0B, 'DAD': 0x09}[op]
            return self.emit(base + rp * 16)
        if op in ('INR', 'DCR'):
            r = R8[args[0].upper()]
            return self.emit((0x04 if op == 'INR' else 0x05) + r * 8)
        if op in ('PUSH', 'POP'):
            rp = RPP[args[0].upper()]
            return self.emit((0xC5 if op == 'PUSH' else 0xC1) + rp * 16)
        if op in ('LDAX', 'STAX'):
            rp = {'B': 0, 'D': 1}[args[0].upper()]
            return self.emit((0x0A if op == 'LDAX' else 0x02) + rp * 16)
        if op in ARITH:
            return self.emit(ARITH[op] + R8[args[0].upper()])
        if op in IMM8:
            return self.emit(IMM8[op], self.value(args[0], lineno))
        if op in JUMP:
            self.emit(JUMP[op])
            return self.emit16(self.value(args[0], lineno))
        if op == 'RST':
            return self.emit(0xC7 + self.value(args[0], lineno) * 8)
        raise AsmError('неизвестная команда %s' % op)

    def assemble(self, text):
        lines = text.splitlines()
        for final in (False, True):
            self.final = final
            self.pc = self.org or 0
            self.out = bytearray()
            for n, raw in enumerate(lines, 1):
                s = re.sub(r";.*$", '', raw).strip()
                m = re.match(r'^([A-Za-z_.][A-Za-z0-9_.]*)\s+EQU\s+(.*)$', s, re.I)
                try:
                    if m:
                        self.sym[m.group(1).upper()] = self.value(m.group(2), n)
                        continue
                    self.line(raw, n, final)
                except AsmError as e:
                    raise AsmError('строка %d: %s\n  %s' % (n, e, raw.rstrip()))
        return bytes(self.out)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--map', help='куда выписать таблицу меток')
    args = p.parse_args()

    a = Asm()
    try:
        code = a.assemble(open(args.infile, encoding='utf-8').read())
    except AsmError as e:
        sys.exit('ассемблер: %s' % e)
    open(args.outfile, 'wb').write(code)
    if args.map:
        with open(args.map, 'w') as f:
            for k, v in sorted(a.sym.items(), key=lambda kv: kv[1]):
                f.write('%04X %s\n' % (v, k))
    print('собрано %d байт, ORG %04X, меток %d'
          % (len(code), a.org or 0, len(a.sym)))


if __name__ == '__main__':
    main()
