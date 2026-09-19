#!/usr/bin/env python3
"""Просмотрщик: шаг назад не уезжает за начало файла.

    ./viewtop.py CO.COM out.com [--at A798]

Сам код -- в viewtop.asm, там же и разбор, отчего CO виснет. Врезки две: оба
места в 32C3, где подкачивается предыдущая пара записей, -- "CZ 334E" по 32D0
и 32D7. Команда остаётся та же, меняется только адрес.
"""

import argparse
import os
import sys

import asm8080
import layout

ORG = 0x100
PREV = 0x334E
SITES = [(0x32D0, 'первый шаг назад'), (0x32D7, 'цикл поиска перевода строки')]
OLD = bytes([0xCC, PREV & 0xFF, PREV >> 8])         # CZ 334E


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--at', help='адрес, по которому накладка будет работать')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    org = ORG + len(d)
    run = int(a.at, 16) if a.at else org

    asm = asm8080.Asm()
    asm.sym.update({'ORIGIN': run})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'viewtop.asm')
    _, body = asm.assemble(src)

    for at, what in SITES:
        off = at - ORG
        if bytes(d[off:off + 3]) != OLD:
            sys.exit('по %04X не CZ %04X (%s), а %s -- это не тот CO'
                     % (at, PREV, what, d[off:off + 3].hex()))
        d[off + 1] = run & 0xFF
        d[off + 2] = run >> 8
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    where = ('%04X (в окне, исходник по %04X)' % (run, org)) if a.at \
        else '%04X (по адресу загрузки)' % org
    print('шаг назад в просмотрщике: %d байт по %s, врезки по %s'
          % (len(body), where, ' и '.join('%04X' % s[0] for s in SITES)))
    if a.at:
        print('winnext=%04X' % (run + len(body)))
    # Для tools/layout.py: где эта врезка живёт и сколько занимает.
    layout.note('окно', run if a.at else org, len(body), 'шаг назад в тексте')


if __name__ == '__main__':
    main()
