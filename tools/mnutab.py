#!/usr/bin/env python3
"""Таблица меню пользователя не заполняется дальше своего края.

    ./mnutab.py CO.COM out.com [--at A601]

Сам код -- в mnutab.asm, там же и разбор. Врезка одна: по 3A1C, где CO
кладёт в таблицу очередной пункт и идёт за следующей строкой CO.MNU.
"""

import argparse
import os
import sys

import asm8080
import layout

ORG = 0x100
HOOK = 0x3A1C
# POP H / INX H / MOV M,A / INX H / PUSH H / JMP 39F0
OLD = bytes([0xE1, 0x23, 0x77, 0x23, 0xE5, 0xC3, 0xF0, 0x39])
# Край таблицы -- первый байт, который уже наш: ниже него у CO ничего нет,
# а с него начинается дописанный сборкой код под стеком.
TABEND = layout.STACK_LO


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
    asm.sym.update({'ORIGIN': run, 'TABHI': TABEND >> 8, 'TABLO': TABEND & 0xFF})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'mnutab.asm')
    _, body = asm.assemble(src)

    off = HOOK - ORG
    if bytes(d[off:off + len(OLD)]) != OLD:
        sys.exit('по %04X не запись пункта в таблицу, а %s -- это не тот CO'
                 % (HOOK, d[off:off + len(OLD)].hex()))
    d[off:off + 3] = bytes([0xC3, run & 0xFF, run >> 8])
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    where = ('%04X (в окне, исходник по %04X)' % (run, org)) if a.at \
        else '%04X (по адресу загрузки)' % org
    print('таблица меню: не дальше %04X (%d пунктов), %d байт по %s, '
          'врезка по %04X'
          % (TABEND, (TABEND - 0xB728) // 2, len(body), where, HOOK))
    if a.at:
        print('winnext=%04X' % (run + len(body)))
    # Для tools/layout.py: где эта врезка живёт и сколько занимает.
    layout.note('окно', run if a.at else org, len(body), 'предел таблицы меню')


if __name__ == '__main__':
    main()
