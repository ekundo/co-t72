#!/usr/bin/env python3
"""Непокрытые пробеги команд -- чем длиннее, тем крупнее незатронутая ветка.

    COVDIR=/tmp/карты ./check-funcs.sh out-buf/
    ./tools/covruns.py /tmp/карты [work/co/co.com] [сколько команд подряд]

covmap.py считает по подпрограммам листинга, а тут -- сплошными кусками: так
видно целые ветки, до которых сценарии не доходят, даже если внутри них по
десятку меток. Данные (.db в листинге) и дыры образа (нули) не в счёт.

Карта отмечает только первый байт команды, поэтому меряем в командах, а не в
байтах: операнды в карте нулевые всегда.
"""

import glob
import pathlib
import re
import sys

ORG = 0x100
ADDR = re.compile(r';\s*([0-9A-F]{4})\s')
HERE = pathlib.Path(__file__).resolve().parent
ASM = HERE.parent / 'co-src' / 'co.asm'


def main():
    covdir = sys.argv[1]
    com = pathlib.Path(sys.argv[2] if len(sys.argv) > 2
                       else HERE.parent / 'work' / 'co' / 'co.com').read_bytes()
    least = int(sys.argv[3]) if len(sys.argv) > 3 else 8

    code = []
    for ln in ASM.read_text().split('\n'):
        m = ADDR.search(ln)
        if not m:
            continue
        a = int(m.group(1), 16)
        if '.db' in ln or '.dw' in ln:
            continue
        if a - ORG >= len(com) or com[a - ORG] == 0:
            continue
        code.append(a)

    files = sorted(glob.glob(covdir + '/*.cov'))
    if not files:
        sys.exit('карт нет: %s/*.cov' % covdir)
    hot = bytearray(0x10000)
    for f in files:
        for i, b in enumerate(open(f, 'rb').read()):
            if b:
                hot[i + ORG] = 1

    runs = []
    i = 0
    while i < len(code):
        if hot[code[i]]:
            i += 1
            continue
        j = i
        while j < len(code) and not hot[code[j]]:
            j += 1
        if j - i >= least:
            runs.append((code[i], code[j - 1], j - i))
        i = j

    print('карт %d, непокрытых команд кусками от %d: %d в %d местах'
          % (len(files), least, sum(r[2] for r in runs), len(runs)))
    for a, b, n in sorted(runs, key=lambda r: -r[2]):
        print('  %04X-%04X %4d' % (a, b, n))


if __name__ == '__main__':
    main()
