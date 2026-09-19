#!/usr/bin/env python3
"""CO.EXT и CO.MNU читаются в буфер копирования, а не в окно ОЗУ.

    ./extbuf.py CO.COM out.com [--at A5E3]

Сам код -- в extbuf.asm, там же и разбор, чем плохо чтение в окно. Врезка
одна: по 3BD3 стоит "JMP 158A", общий хвост всех трёх открывателей списков.
"""

import argparse
import os
import sys

import asm8080
import layout

ORG = 0x100
HOOK = 0x3BD3
OLD = bytes([0xC3, 0x8A, 0x15])         # JMP 158A
BUF = 0x6100
# Второе место, где адрес списка зашит: по нажатию клавиши в меню пользователя
# CO перечитывает CO.MNU с начала и ставит указатель разбора на A000 прямо
# командой. Без этой правки меню рисуется, а пункт не находится.
RESET = 0x3A56
RESET_OLD = bytes([0x21, 0x00, 0xA0])   # LXI H,A000


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
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'extbuf.asm')
    _, body = asm.assemble(src)

    off = HOOK - ORG
    if bytes(d[off:off + len(OLD)]) != OLD:
        sys.exit('по %04X не переход на чтение списка, а %s -- это не тот CO'
                 % (HOOK, d[off:off + len(OLD)].hex()))
    d[off:off + len(OLD)] = bytes([0xC3, run & 0xFF, run >> 8])

    off = RESET - ORG
    if bytes(d[off:off + len(RESET_OLD)]) != RESET_OLD:
        sys.exit('по %04X не LXI H,A000, а %s -- это не тот CO'
                 % (RESET, d[off:off + len(RESET_OLD)].hex()))
    d[off + 1] = BUF & 0xFF
    d[off + 2] = BUF >> 8
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    where = ('%04X (в окне, исходник по %04X)' % (run, org)) if a.at \
        else '%04X (по адресу загрузки)' % org
    print('CO.EXT и CO.MNU -- в буфер копирования: %d байт по %s, врезка по %04X'
          % (len(body), where, HOOK))
    print('  указатель разбора меню по %04X -- тоже на %04X' % (RESET, BUF))
    if a.at:
        print('winnext=%04X' % (run + len(body)))
    # Для tools/layout.py: где эта врезка живёт и сколько занимает.
    layout.note('окно', run if a.at else org, len(body), 'списки в буфер')


if __name__ == '__main__':
    main()
