#!/usr/bin/env python3
"""Транслитератор Z80 -> Intel 8080 для исходника VDE.

    ./z80to8080.py work/vde/src/vdx1.asm ... -o work/vde/gen [-r отчёт.txt]

Вектор -- 8080, а VDE написана на Z80, и перевод делится надвое.

Что переводится машинно -- там, где у 8080 есть точный ответ: вся система команд
один в один (`LD A,B` -> `MOV A,B`), `JR` -> `JMP`, `DJNZ` -> `DCR B`/`JNZ`,
`LD (nn),DE` и прочие 16-битные обмены с памятью -- через `XCHG`/`SHLD` с
сохранением всех регистров, блочные `LDIR`/`CPIR` -- вызовами подпрограмм из
`blockops.asm`.

Что требует решения человека -- там, где ответ зависит от места: `BIT`/`SET`/`RES`
затирают A, `SBC HL,rr` затирает A и даёт Z только по старшему байту, IX/IY и
теневого набора у 8080 нет вовсе. Такие места переводятся только по записи в
файле правок (`overrides.asm`), иначе трансляция обрывается. Умолчание тоже
надо подписать -- строкой `=`; молча неверный код собраться не должен.

Условная сборка (`IF VDM`) раскрывается здесь же: нам нужен вариант для
терминала, экранной памяти со знакоместами у Вектора нет.
"""

import argparse
import os
import re
import sys

# ---------------------------------------------------------------- разбор

# Метка, мнемоника, операнды. Метка может стоять одна в строке. Комментарий
# отрезается заранее -- точка с запятой внутри кавычек комментария не начинает.
LINE = re.compile(r"""^(?P<label>[A-Za-z_?@][A-Za-z0-9_?@]*:?)?
                       (?:[ \t]+(?P<mnem>[A-Za-z][A-Za-z0-9']*)
                          (?:[ \t]+(?P<ops>.*))?)?
                       [ \t]*$""", re.X)


def cut_comment(line):
    """Разделить строку на код и комментарий, не путая `;` внутри кавычек.

    Апостроф не всегда кавычка: у Z80 им помечен теневой набор (`EX AF,AF'`).
    Отличить просто -- знак literal'а стоит после разделителя, а не вплотную к
    букве или цифре.
    """
    quote = None
    for i, ch in enumerate(line):
        if quote:
            if ch == quote:
                quote = None
        elif ch == '"' or (ch == '\'' and not (i and line[i - 1].isalnum())):
            quote = ch
        elif ch == ';':
            return line[:i], line[i:]
    return line, ''

R8 = {'A': 'A', 'B': 'B', 'C': 'C', 'D': 'D', 'E': 'E', 'H': 'H', 'L': 'L',
      '(HL)': 'M'}
RP_STACK = {'BC': 'B', 'DE': 'D', 'HL': 'H', 'AF': 'PSW'}
RP_WORD = {'BC': 'B', 'DE': 'D', 'HL': 'H', 'SP': 'SP'}
# Условия: Z80 -> суффикс команд 8080 (J../C../R..)
COND = {'NZ': 'NZ', 'Z': 'Z', 'NC': 'NC', 'C': 'C',
        'PO': 'PO', 'PE': 'PE', 'P': 'P', 'M': 'M'}
# Операторы Zilog -> питоновские: выражения считает eval внутри asm8080.py
OPERATORS = [(re.compile(r'\bNOT\b', re.I), '~'), (re.compile(r'\bAND\b', re.I), '&'),
             (re.compile(r'\bOR\b', re.I), '|'), (re.compile(r'\bXOR\b', re.I), '^'),
             (re.compile(r'\bSHL\b', re.I), '<<'), (re.compile(r'\bSHR\b', re.I), '>>'),
             (re.compile(r'\bMOD\b', re.I), '%')]


class Manual(Exception):
    """Место, которое машинно не переводится: нужна подпись в overrides.asm."""

    def __init__(self, kind, default=None):
        super().__init__(kind)
        self.kind = kind
        self.default = default          # умолчание, если оно вообще есть


class Warn(Exception):
    """Перевод есть, но флаги на выходе не те -- место идёт в отчёт на проверку."""


IXY = re.compile(r'^\(\s*(I[XY])\s*(?:([-+])\s*([0-9A-Fa-f]+[Hh]?|\d+))?\s*\)$', re.I)


def ixy_ptr(op):
    """`(IX+1)` -> ('IX', 1); `(IY)` -> ('IY', 0); иначе None."""
    m = IXY.match(op.strip())
    if not m:
        return None
    off = 0
    if m.group(3):
        off = int(expr(m.group(3)), 0)
        if m.group(2) == '-':
            off = -off
    return m.group(1).upper(), off


def ixy_addr(reg, off):
    """HL <- адрес (IXY+off), старый HL на стеке. Флаги не трогаются."""
    out = ['PUSH\tH', 'LHLD\tz%sp' % reg]
    if abs(off) > 4:
        raise Manual('смещение %+d велико' % off)
    out += ['INX\tH' if off > 0 else 'DCX\tH'] * abs(off)
    return out


# Написание меток: ВЕРХНИЙ РЕГИСТР -> как метка объявлена. Ассемблер Мейера к
# регистру был безразличен, и исходник этим пользуется: `ELine` объявлена, а
# ссылаются на неё как `Eline`. Наш asm8080 регистр различает (и правильно: в
# самом проекте `NRNG` и `nrng` -- разные метки), поэтому написание приводится
# к объявленному здесь, при переводе.
CANON = {}
IDENT = re.compile(r"[A-Za-z_?@][A-Za-z0-9_?@]*")


def canon(e):
    """Привести написание имён к объявленному, не трогая содержимое кавычек."""
    out, i = '', 0
    while i < len(e):
        ch = e[i]
        if ch in '\'"':
            j = e.find(ch, i + 1)
            j = len(e) - 1 if j < 0 else j
            out += e[i:j + 1]
            i = j + 1
            continue
        m = IDENT.match(e, i)
        if m and (i == 0 or not e[i - 1].isalnum()):
            out += CANON.get(m.group(0).upper(), m.group(0))
            i = m.end()
            continue
        out += ch
        i += 1
    return out


def expr(s):
    """Выражение Zilog -> выражение для asm8080: меняются только операторы."""
    out, i = '', 0
    while i < len(s):                   # строковые литералы не трогаем
        ch = s[i]
        if ch in '\'"':
            j = s.find(ch, i + 1)
            j = len(s) - 1 if j < 0 else j
            out += s[i:j + 1]
            i = j + 1
            continue
        out += ch
        i += 1
    for rx, rep in OPERATORS:
        out = rx.sub(rep, out)
    return canon(out).strip()


def split_ops(s):
    """Разбить операнды по запятым верхнего уровня."""
    out, cur, depth, quote = [], '', 0, None
    for ch in s:
        if quote:
            cur += ch
            if ch == quote:
                quote = None
            continue
        if ch in '\'"':
            quote = ch
        elif ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        elif ch == ',' and depth == 0:
            out.append(cur.strip())
            cur = ''
            continue
        cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def is_ix(op):
    return re.search(r'\bI[XY]\b', op, re.I) is not None


def mem(op):
    """`(что-то)` -> что-то, иначе None."""
    o = op.strip()
    if o.startswith('(') and o.endswith(')'):
        return o[1:-1].strip()
    return None


def bitmask(n):
    return 1 << int(n, 0)


def hexb(v):
    """Байт шестнадцатеричным. Начинаться с буквы такое число не может --
       ассемблер примет его за имя, поэтому впереди ноль: 0BFH."""
    t = '%02X' % (v & 0xFF)
    return ('0' + t if t[0] > '9' else t) + 'H'


# ---------------------------------------------------------------- перевод

def tr_ld(ops):
    dst, src = ops
    du, su = dst.upper(), src.upper()
    if is_ix(dst) or is_ix(src):
        return tr_ld_ixy(dst, src)
    # регистр <- регистр
    if du in R8 and su in R8:
        if du == 'M' and su == 'M':
            raise Manual('LD (HL),(HL)')
        return ['MOV\t%s,%s' % (R8[du], R8[su])]
    # регистр <- непосредственное
    if du in R8 and mem(src) is None and su not in RP_WORD:
        return ['MVI\t%s,%s' % (R8[du], expr(src))]
    # A <- (BC)/(DE)/(nn)
    if du == 'A' and mem(src) is not None:
        m = mem(src).upper()
        if m == 'BC':
            return ['LDAX\tB']
        if m == 'DE':
            return ['LDAX\tD']
        if m == 'HL':
            return ['MOV\tA,M']
        return ['LDA\t%s' % expr(mem(src))]
    # (BC)/(DE)/(nn) <- A
    if su == 'A' and mem(dst) is not None:
        m = mem(dst).upper()
        if m == 'BC':
            return ['STAX\tB']
        if m == 'DE':
            return ['STAX\tD']
        if m == 'HL':
            return ['MOV\tM,A']
        return ['STA\t%s' % expr(mem(dst))]
    # (HL) <- регистр/непосредственное уже разобрано выше через R8
    if mem(dst) and mem(dst).upper() == 'HL':
        return ['MVI\tM,%s' % expr(src)]
    # пара <- непосредственное
    if du in RP_WORD and mem(src) is None:
        if du == 'SP' and su == 'HL':
            return ['SPHL']
        return ['LXI\t%s,%s' % (RP_WORD[du], expr(src))]
    # HL <-> (nn): родные команды
    if du == 'HL' and mem(src) is not None:
        return ['LHLD\t%s' % expr(mem(src))]
    if mem(dst) is not None and su == 'HL':
        return ['SHLD\t%s' % expr(mem(dst))]
    # DE/BC <-> (nn): у 8080 только HL, но обойти можно ничего не потеряв
    if du == 'DE' and mem(src) is not None:
        return ['PUSH\tH', 'LHLD\t%s' % expr(mem(src)), 'XCHG', 'POP\tH']
    if mem(dst) is not None and su == 'DE':
        return ['XCHG', 'SHLD\t%s' % expr(mem(dst)), 'XCHG']
    if du == 'BC' and mem(src) is not None:
        return ['PUSH\tH', 'LHLD\t%s' % expr(mem(src)), 'MOV\tB,H', 'MOV\tC,L',
                'POP\tH']
    if mem(dst) is not None and su == 'BC':
        return ['PUSH\tH', 'MOV\tH,B', 'MOV\tL,C', 'SHLD\t%s' % expr(mem(dst)),
                'POP\tH']
    raise Manual('LD %s,%s' % (dst, src))


def tr_ld_ixy(dst, src):
    """Обмены с IX/IY. Сами регистры живут в ячейках zIXp/zIYp, адрес считается
       в HL, а старый HL на это время уходит на стек -- флаги и A целы."""
    du, su = dst.upper(), src.upper()
    if du in ('IX', 'IY'):
        if mem(src) is not None:                       # LD IX,(nn)
            return ['PUSH\tH', 'LHLD\t%s' % expr(mem(src)), 'SHLD\tz%sp' % du,
                    'POP\tH']
        return ['PUSH\tH', 'LXI\tH,%s' % expr(src), 'SHLD\tz%sp' % du, 'POP\tH']
    if su in ('IX', 'IY'):                             # LD (nn),IX
        if mem(dst) is None:
            raise Manual('LD %s,%s' % (dst, src))
        return ['PUSH\tH', 'LHLD\tz%sp' % su, 'SHLD\t%s' % expr(mem(dst)), 'POP\tH']
    p = ixy_ptr(dst)
    if p:                                              # LD (IX+d),r / n
        body = ixy_addr(*p)
        if su in R8:
            if su in ('H', 'L'):
                raise Manual('LD (%s),%s -- H/L заняты адресом' % (p[0], src))
            body.append('MOV\tM,%s' % R8[su])
        else:
            body.append('MVI\tM,%s' % expr(src))
        return body + ['POP\tH']
    p = ixy_ptr(src)
    if p:                                              # LD r,(IX+d)
        if du not in R8 or du in ('H', 'L'):
            raise Manual('LD %s,(%s)' % (dst, p[0]))
        return ixy_addr(*p) + ['MOV\t%s,M' % R8[du], 'POP\tH']
    raise Manual('LD %s,%s' % (dst, src))


def tr_alu(mnem, ops):
    """Арифметика и логика: у Zilog первый операнд A бывает опущен."""
    intel = {'ADD': ('ADD', 'ADI'), 'ADC': ('ADC', 'ACI'), 'SUB': ('SUB', 'SUI'),
             'SBC': ('SBB', 'SBI'), 'AND': ('ANA', 'ANI'), 'OR': ('ORA', 'ORI'),
             'XOR': ('XRA', 'XRI'), 'CP': ('CMP', 'CPI')}[mnem]
    if len(ops) == 2 and ops[0].upper() == 'A':
        ops = ops[1:]
    if len(ops) != 1:
        raise Manual('%s %s' % (mnem, ','.join(ops)))
    op = ops[0]
    p = ixy_ptr(op)
    if p:
        return ixy_addr(*p) + ['%s\tM' % intel[0], 'POP\tH']
    if is_ix(op):
        raise Manual('%s %s' % (mnem, op))
    u = op.upper()
    if u in R8:
        return ['%s\t%s' % (intel[0], R8[u])]
    return ['%s\t%s' % (intel[1], expr(op))]


def tr_incdec(mnem, ops):
    op = ops[0]
    u = op.upper()
    if u in ('IX', 'IY'):
        return ['PUSH\tH', 'LHLD\tz%sp' % u, 'INX\tH' if mnem == 'INC' else 'DCX\tH',
                'SHLD\tz%sp' % u, 'POP\tH']
    p = ixy_ptr(op)
    if p:
        return ixy_addr(*p) + ['%s\tM' % ('INR' if mnem == 'INC' else 'DCR'), 'POP\tH']
    if is_ix(op):
        raise Manual('%s %s' % (mnem, op))
    if u in RP_WORD:
        return ['%s\t%s' % ('INX' if mnem == 'INC' else 'DCX', RP_WORD[u])]
    if u in R8:
        return ['%s\t%s' % ('INR' if mnem == 'INC' else 'DCR', R8[u])]
    raise Manual('%s %s' % (mnem, op))


def tr_add16(ops):
    dst, src = ops[0].upper(), ops[1].upper()
    if dst in ('IX', 'IY'):
        return ['PUSH\tH', 'LHLD\tz%sp' % dst, 'DAD\t%s' % RP_WORD[src],
                'SHLD\tz%sp' % dst, 'POP\tH']
    if dst != 'HL':
        raise Manual('ADD %s,%s' % (ops[0], ops[1]))
    return ['DAD\t%s' % RP_WORD[src]]


def tr_jump(mnem, ops):
    if mnem in ('JP', 'JR'):
        if len(ops) == 1:
            if mem(ops[0]) and mem(ops[0]).upper() == 'HL':
                return ['PCHL']
            return ['JMP\t%s' % expr(ops[0])]
        return ['J%s\t%s' % (COND[ops[0].upper()], expr(ops[1]))]
    if mnem == 'CALL':
        if len(ops) == 1:
            return ['CALL\t%s' % expr(ops[0])]
        return ['C%s\t%s' % (COND[ops[0].upper()], expr(ops[1]))]
    if mnem == 'RET':
        return ['RET'] if not ops else ['R%s' % COND[ops[0].upper()]]
    if mnem == 'DJNZ':
        # у Z80 DJNZ флагов не трогает, у нас DCR B их ставит -- места, где это
        # может быть важно, транслятор помечает в отчёте отдельно
        return ['DCR\tB', 'JNZ\t%s' % expr(ops[0])]
    raise Manual(mnem)


def tr_stack(mnem, ops):
    u = ops[0].upper()
    if u not in RP_STACK:
        raise Manual('IX/IY' if is_ix(ops[0]) else '%s %s' % (mnem, ops[0]))
    return ['%s\t%s' % (mnem, RP_STACK[u])]


def tr_bitop(mnem, ops):
    """BIT/SET/RES. У 8080 их нет, обход идёт через A -- и A приходится спасать.

    SET/RES флагов не ставят, поэтому A и флаги уходят на стек целиком.
    BIT обязан вернуть Z, поэтому A прячется в ячейку: `LDA` флагов не трогает
    и возвращает A уже после того, как `ANI` выставил признак.
    """
    n, target = ops[0], ops[1]
    mask = bitmask(n)
    p = ixy_ptr(target)
    u = target.upper()
    if p:
        get, put, tail = ixy_addr(*p) + ['MOV\tA,M'], ['MOV\tM,A'], ['POP\tH']
    elif u in R8:
        get = [] if u == 'A' else ['MOV\tA,%s' % R8[u]]
        put, tail = ([] if u == 'A' else ['MOV\t%s,A' % R8[u]]), []
    else:
        raise Manual('%s %s,%s' % (mnem, n, target))
    if mnem == 'BIT':
        return ['STA\tztA'] + get + ['ANI\t%s' % hexb(mask)] + tail + ['LDA\tztA']
    if u == 'A':
        raise Manual('%s %s,A -- флаги не сохранить' % (mnem, n))
    op = 'ORI\t%s' % hexb(mask) if mnem == 'SET' else 'ANI\t%s' % hexb(~mask)
    return ['PUSH\tPSW'] + get + [op] + put + tail + ['POP\tPSW']


def tr_sbc16(ops):
    """SBC HL,rr: заём выходит верный, Z -- только по старшему байту."""
    hi, lo = {'BC': ('B', 'C'), 'DE': ('D', 'E'), 'HL': ('H', 'L')}[ops[1].upper()]
    return ['STA\tztA', 'MOV\tA,L', 'SBB\t%s' % lo, 'MOV\tL,A',
            'MOV\tA,H', 'SBB\t%s' % hi, 'MOV\tH,A', 'LDA\tztA']


SIMPLE = {'NOP': 'NOP', 'CPL': 'CMA', 'SCF': 'STC', 'CCF': 'CMC', 'HALT': 'HLT',
          'DI': 'DI', 'EI': 'EI', 'DAA': 'DAA', 'RLCA': 'RLC', 'RRCA': 'RRC',
          'RLA': 'RAL', 'RRA': 'RAR', 'EXX': None, 'RRD': None, 'RLD': None,
          'NEG': None, 'SRL': None}
BLOCK = {'LDIR': 'zLDIR', 'LDDR': 'zLDDR', 'CPIR': 'zCPIR', 'CPDR': 'zCPDR'}


def translate(mnem, ops):
    """Одна команда Z80 -> строки 8080. Manual -- если нужна подпись."""
    m = mnem.upper()
    if m in BLOCK:
        return ['CALL\t%s' % BLOCK[m]]
    if m == 'LD':
        return tr_ld(ops)
    if m in ('ADD', 'ADC') and len(ops) == 2 and ops[0].upper() in ('HL', 'IX', 'IY'):
        if m == 'ADC':
            raise Manual('ADC HL,rr')
        return tr_add16(ops)
    if m == 'SBC' and len(ops) == 2 and ops[0].upper() == 'HL':
        return tr_sbc16(ops)
    if m in ('ADD', 'ADC', 'SUB', 'SBC', 'AND', 'OR', 'XOR', 'CP'):
        return tr_alu(m, ops)
    if m in ('INC', 'DEC'):
        return tr_incdec(m, ops)
    if m in ('JP', 'JR', 'CALL', 'RET', 'DJNZ'):
        return tr_jump(m, ops)
    if m in ('PUSH', 'POP'):
        return tr_stack(m, ops)
    if m in ('BIT', 'SET', 'RES'):
        return tr_bitop(m, ops)
    if m == 'EX':
        pair = ','.join(o.upper().replace(' ', '') for o in ops)
        if pair == 'DE,HL':
            return ['XCHG']
        if pair == '(SP),HL':
            return ['XTHL']
        if pair.replace("'", '') == 'AF,AF':
            return ['CALL\tzEXAF']
        raise Manual('EX %s' % pair)
    if m == 'EXX':
        return ['CALL\tzEXX']
    if m == 'SRL':
        if ops and ops[0].upper() == 'A':
            # ORA A гасит перенос и ставит Z/S/P по A ДО сдвига -- если дальше
            # проверяют Z, место попадёт в отчёт по флагам
            return ['ORA\tA', 'RAR']
        raise Manual('SRL %s' % ','.join(ops))
    if m == 'NEG':
        return ['CMA', 'INR\tA']
    if m in ('RRD', 'RLD'):
        raise Manual(m)
    if m == 'IN':
        return ['IN\t%s' % expr(mem(ops[1]) or ops[1])]
    if m == 'OUT':
        return ['OUT\t%s' % expr(mem(ops[0]) or ops[0])]
    if m == 'RST':
        v = int(expr(ops[0]).replace('0x', ''), 16)
        return ['RST\t%d' % (v // 8)]
    if m in SIMPLE and SIMPLE[m]:
        return [SIMPLE[m]]
    raise Manual(mnem)


# ---------------------------------------------------------------- правки

def read_overrides(path):
    """Файл правок: заголовок `@файл:строка  исходная команда`, дальше тело.

    Тело `=` означает «умолчание транслятора годится».
    """
    if not path or not os.path.exists(path):
        return {}
    out, key, orig, body = {}, None, None, []
    for n, raw in enumerate(open(path, encoding='utf-8'), 1):
        line = raw.rstrip('\n')
        m = re.match(r'^@(\S+:\d+)\s*(.*)$', line)
        if m:
            if key:
                out[key] = (orig, body)
            key, orig, body = m.group(1), m.group(2).strip(), []
            continue
        if key is None:
            continue                      # шапка файла
        body.append(line)
    if key:
        out[key] = (orig, body)
    return {k: (o, [x for x in b if x.strip() and not x.lstrip().startswith(';')] or b)
            for k, (o, b) in out.items()}


# ---------------------------------------------------------------- проход

# какой признак читает условие и какие признаки команда перебивает
COND_FLAG = {'NZ': 'Z', 'Z': 'Z', 'NC': 'C', 'C': 'C',
             'PO': 'P', 'PE': 'P', 'P': 'S', 'M': 'S'}
ALL = {'Z', 'C', 'S', 'P'}
FLAG_WRITE = {
    'ADD': ALL, 'ADC': ALL, 'SUB': ALL, 'SBC': ALL, 'AND': ALL, 'OR': ALL,
    'XOR': ALL, 'CP': ALL, 'NEG': ALL, 'DAA': ALL, 'SRL': ALL, 'SLA': ALL,
    'RRD': {'Z', 'S', 'P'}, 'RLD': {'Z', 'S', 'P'},
    'INC': {'Z', 'S', 'P'}, 'DEC': {'Z', 'S', 'P'}, 'BIT': {'Z', 'S', 'P'},
    'CPIR': {'Z', 'S', 'P'}, 'CPDR': {'Z', 'S', 'P'}, 'CPI': {'Z', 'S', 'P'},
    'LDIR': {'P'}, 'LDDR': {'P'},
    'SCF': {'C'}, 'CCF': {'C'}, 'RLCA': {'C'}, 'RRCA': {'C'}, 'RLA': {'C'},
    'RRA': {'C'}, 'POP': ALL,          # POP AF -- флаги целиком; остальное ниже
}
# что у нас расходится с Z80 и по каким признакам это видно
RISK = {'BIT': {'S', 'P'}, 'SBC16': {'Z', 'S', 'P'}, 'DJNZ': ALL,
        'SRL': {'Z', 'S', 'P'}, 'NEG': {'C'}}


class Job:
    def __init__(self, overrides, defines):
        self.ov = overrides
        self.defines = defines
        self.todo = []          # места без подписи
        self.warn = []          # флаговые предупреждения
        self.used_ov = set()
        self.stats = {}
        self.src = {}           # исходные строки -- для показа соседей в отчёте
        self.spell = 0          # сколько имён написаны не так, как объявлены

    def next_insn(self, where, back=False):
        """Соседняя команда в исходнике: по ней видно, какие флаги нужны."""
        name, n = where.rsplit(':', 1)
        src = self.src.get(name, [])
        rng = range(int(n) - 2, -1, -1) if back else range(int(n), len(src))
        for i in rng:
            s = cut_comment(src[i])[0].strip()
            if s:
                return s
        return ''

    def flag_reader(self, where, flags):
        """Кто прочитает флаги после этого места.

        Идём вперёд по тексту, пока флаг не перебьёт другая команда. Если
        раньше встретится условный переход по интересующему нас признаку --
        вот оно, место требует внимания. Ветвления в расчёт не берём: ход
        линейный, поэтому ответ верен для того пути, что идёт следом, а
        входящие метки разбор обрывают -- туда можно прийти с чем угодно.
        """
        name, n = where.rsplit(':', 1)
        src = self.src.get(name, [])
        for i in range(int(n), min(int(n) + 12, len(src))):
            raw = src[i]
            if not cut_comment(raw)[0].strip():
                continue
            m = LINE.match(cut_comment(raw.rstrip())[0].rstrip())
            if not m or not m.group('mnem'):
                continue
            if m.group('label'):
                return None                       # сюда приходят и со стороны
            u = m.group('mnem').upper()
            ops = split_ops(m.group('ops') or '')
            cond = ops[0].upper() if ops else ''
            if u in ('JR', 'JP', 'CALL', 'RET') and cond in COND:
                if COND_FLAG[cond] in flags:
                    return '%s %s' % (u, ','.join(ops))
                continue                          # читают, но не наш признак
            if u in ('JP', 'JR', 'RET', 'CALL'):
                # безусловная передача управления: после вызова признак ставит
                # уже вызванная подпрограмма, наш он или нет -- не проследить
                return None
            hit = FLAG_WRITE.get(u, set())
            if u == 'POP' and cond != 'AF':
                hit = set()                       # флаги снимает только POP AF
            if u in ('ADD', 'ADC') and len(ops) == 2 and ops[0].upper() in (
                    'HL', 'IX', 'IY'):
                hit = {'C'}                       # 16-битное сложение трогает перенос
            if flags & hit == flags:
                return None                       # все наши флаги перебиты
            flags = flags - hit
            if not flags:
                return None
        return None

    def count(self, kind):
        self.stats[kind] = self.stats.get(kind, 0) + 1

    def collect(self, path):
        """Собрать объявленные в файле метки -- по ним выправляется написание."""
        text = open(path, encoding='latin-1').read()
        for raw in text.split('\x1a')[0].replace('\r\n', '\n').splitlines():
            m = LINE.match(cut_comment(raw.rstrip())[0].rstrip())
            if not m or not m.group('label'):
                continue
            name = m.group('label').rstrip(':')
            if CANON.setdefault(name.upper(), name) != name:
                self.spell += 1

    def file(self, path):
        name = os.path.basename(path)
        # файлы из CP/M: строки через CRLF, хвост добит 1Ah -- всё, что за первым
        # таким байтом, к тексту не относится
        text = open(path, encoding='latin-1').read()
        src = text.split('\x1a')[0].replace('\r\n', '\n').splitlines()
        self.src[name] = src
        out, cond = [], []               # cond -- стек условной сборки
        prev_out_idx = None
        for n, raw in enumerate(src, 1):
            where = '%s:%d' % (name, n)
            head = cut_comment(raw)[0].strip().split()
            direc = head[0].upper() if head else ''
            if direc == 'IF':
                cond.append(bool(self.value(' '.join(head[1:]))))
                continue
            if direc == 'ELSE':
                cond[-1] = not cond[-1]
                continue
            if direc == 'ENDIF':
                cond.pop()
                continue
            if not all(cond):
                continue
            lines, flagged = self.line(raw, where)
            for text in lines:
                out.append(text)
            if flagged is not None and prev_out_idx is not None:
                pass
            prev_out_idx = len(out)
        return name, out

    def value(self, e):
        try:
            return eval(expr(e), {'__builtins__': {}}, dict(self.defines))
        except Exception:
            sys.exit('не понял условие сборки: %s' % e)

    def line(self, raw, where):
        code, comment = cut_comment(raw.rstrip())
        m = LINE.match(code.rstrip())
        if not m:
            sys.exit('%s: не разобрать строку: %s' % (where, raw))
        label, mnem, ops = m.group('label'), m.group('mnem'), m.group('ops')
        if not mnem:
            return ([raw.rstrip()] if raw.strip() else ['']), None
        u = mnem.upper()
        # у Zilog метка в начале строки двоеточия не требует, asm8080 требует
        pre = (label + ':' if label and not label.endswith(':') else label or '')
        tail = ('\t' + comment) if comment else ''
        if u in ('DB', 'DW', 'DS', 'EQU', 'ORG', 'END', 'DEFB', 'DEFW', 'DEFS'):
            fixed = {'DEFB': 'DB', 'DEFW': 'DW', 'DEFS': 'DS'}.get(u, u)
            args = ', '.join(expr(o) for o in split_ops(ops or ''))
            got = self.ov.get(where)
            if got is None:
                return [('%s\t%s\t%s%s' % (pre, fixed, args, tail)).rstrip()], None
            # данные тоже правятся: так задаётся профиль терминала T-72, не
            # трогая машинный перевод
            self.used_ov.add(where)
            self.count('правка: данные')
            body = got[1]
            if body and body[0].strip() == '=':
                body = ['\t%s\t%s' % (fixed, args)]
            # метку исходной строки несёт первая строка правки -- но если она
            # там уже написана своими руками, второй раз её ставить не надо
            first = body[0] if body[0][:1].strip() else ('%s%s' % (pre, body[0]))
            return [first.rstrip()] + list(body[1:]), 'данные'
        args = split_ops(ops or '')
        default, kind = None, None
        try:
            default = translate(u, args)
        except Manual as ex:
            kind = ex.kind
            default = ex.default            # умолчание, если оно вообще есть
        got = self.ov.get(where)
        if got is not None:
            # ручная правка сильнее машинного перевода: иначе места, где он
            # переводит, но оставляет не те флаги, править было бы нечем
            orig, lines = got
            here = (mnem + ' ' + ','.join(args)) if args else mnem
            if orig and re.sub(r'\s+', '', orig).upper() != re.sub(
                    r'\s+', '', here).upper():
                # заголовок правки сверяется с исходником: при сдвиге строк
                # правка иначе молча уедет не на ту команду
                self.todo.append((where, raw.rstrip(),
                                  'правка не про эту команду: %s' % orig, None))
            self.used_ov.add(where)
            body = list(lines)
            if body and body[0].strip() == '=':
                if default is None:
                    self.todo.append((where, raw.rstrip(),
                                      'умолчания нет, нужен код', None))
                body = list(default or ['?НЕТ ПРАВКИ?'])
            self.count('правка: %s' % (kind or 'флаги').split('(')[0].strip())
            kind = kind or 'правка'
        elif kind is not None:
            self.todo.append((where, raw.rstrip(), kind, default))
            body = ['?НЕТ ПРАВКИ?\t%s' % kind]
        else:
            body = default
        if kind is None:
            self.count('машинно')
        # Машинный перевод пишется с отступом, метка исходника -- на первой
        # строке. Тело правки идёт как написано (там своя разметка и свои
        # метки), а метка исходника тогда встаёт отдельной строкой перед ним.
        if got is not None:
            res = ([pre] if pre else []) + [b.rstrip() for b in body]
            if tail:
                res[0] = (res[0] + tail).rstrip() if not pre else res[0]
        else:
            res = []
            for i, b in enumerate(body):
                lab = pre if i == 0 else ''
                cmt = tail if i == 0 else ''
                res.append(('%s\t%s%s' % (lab, b, cmt)).rstrip())
        # места, где флаги на выходе не такие, как у Z80
        risk = 'SBC16' if (u == 'SBC' and len(args) == 2
                           and args[0].upper() == 'HL') else u
        if risk in RISK and where not in self.ov:
            self.warn.append((where, raw.strip(), risk))
        return res, kind


def main():
    p = argparse.ArgumentParser(description='Z80 -> 8080 для VDE')
    p.add_argument('sources', nargs='+')
    p.add_argument('-o', '--outdir', required=True)
    p.add_argument('-v', '--overrides', action='append', default=[],
                   help='файл правок; можно несколько')
    p.add_argument('-r', '--report')
    p.add_argument('-s', '--symbols', action='append', default=[],
                   help='файл, откуда взять ещё объявления имён (наши EQU)')
    p.add_argument('-D', '--define', action='append', default=[],
                   help='имя=значение для условной сборки (по умолчанию VDM=0)')
    a = p.parse_args()

    defines = {'VDM': 0}
    for d in a.define:
        k, _, v = d.partition('=')
        defines[k.strip()] = int(v or 0, 0)

    ov = {}
    for path in a.overrides:
        ov.update(read_overrides(path))
    job = Job(ov, defines)
    os.makedirs(a.outdir, exist_ok=True)
    for path in list(a.symbols) + list(a.sources):
        job.collect(path)
    for path in a.sources:
        name, lines = job.file(path)
        out = os.path.join(a.outdir, os.path.splitext(name)[0] + '.a80')
        with open(out, 'w', encoding='utf-8') as f:
            f.write('; ПЕРЕВЕДЕНО МАШИННО из %s -- правь не здесь, а в overrides.asm\n'
                    % name)
            f.write('\n'.join(lines) + '\n')

    lines = []
    lines.append('Перевод Z80 -> 8080')
    lines.append('  объявлено меток %d' % len(CANON))
    for k in sorted(job.stats):
        lines.append('  %-40s %d' % (k, job.stats[k]))
    # Флаги: DJNZ/SRL/NEG/BIT/SBC HL оставляют не то, что оставил бы Z80.
    # Опасны только те места, где расходящийся признак кто-то читает.
    risky = []
    for w, raw, u in job.warn:
        who = job.flag_reader(w, set(RISK[u]))
        if who:
            risky.append((w, raw, u, who))
    lines.append('')
    lines.append('Флаги: мест с расхождением %d, из них признак читают в %d'
                 % (len(job.warn), len(risky)))
    for w, raw, u, who in risky:
        lines.append('  %-14s %-34s читает: %s' % (w, raw.replace('\t', ' '), who))

    unused = set(job.ov) - job.used_ov
    if unused:
        lines.append('')
        lines.append('Правки мимо кода (%d): %s' % (len(unused), ', '.join(sorted(unused))))
    if job.todo:
        lines.append('')
        lines.append('БЕЗ ПОДПИСИ -- %d мест:' % len(job.todo))
        by = {}
        for where, raw, kind, default in job.todo:
            by.setdefault(kind, []).append((where, raw, default))
        for kind in sorted(by, key=lambda k: -len(by[k])):
            lines.append('')
            lines.append('  == %s -- %d ==' % (kind, len(by[kind])))
            for where, raw, default in by[kind]:
                lines.append('  %-14s %s' % (where, raw.strip()))
                if default:
                    lines.append('  %14s   умолчание: %s' %
                                 ('', ' / '.join(x.replace('\t', ' ') for x in default)))
    text = '\n'.join(lines) + '\n'
    if a.report:
        open(a.report, 'w', encoding='utf-8').write(text)
    print(text)
    return 1 if job.todo else 0


if __name__ == '__main__':
    sys.exit(main())
