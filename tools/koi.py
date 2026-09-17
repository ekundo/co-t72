#!/usr/bin/env python3
"""Кодировки в просмотрщике CO -- своими силами.

    ./koi.py CO.COM out.com

Сам код -- в koi.asm, здесь только сборка и врезки. Накладка остаётся по адресу
загрузки, ниже A000.

Врезок две:
  328D -- цикл вывода знака в просмотрщике, было "CPI 20h / CC 331F";
  101B -- бывший переключатель набора, слал системе команды T-34.
"""

import argparse
import os
import sys

import asm8080

ORG = 0x100
PUT = 0x328D
PUT_OLD = bytes([0xFE, 0x20, 0xDC, 0x1F, 0x33])         # CPI 20h / CC 331F
INIT = 0x101B
INIT_OLD = bytes([0x3A, 0x8F, 0x3E, 0x0E, 0x0E])        # LDA 3E8F / MVI C,0Eh

# Запуск программ: CO ставил знакогенератор по разделителю из CO.EXT/CO.MNU
# ("L", "R", "k", "/") -- теми же командами T-34. Выкусываем: с 3A86 сразу на
# общий хвост запуска. Набор к этому времени уже поставлен вызовом по 3A83.
EXTFONT = 0x3A86
EXTFONT_OLD = bytes([0x21, 0x15, 0x3E])                 # LXI H,3E15h ("ESC \")
EXTFONT_NEW = bytes([0xC3, 0x26, 0x20])                 # JMP 2026h


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    org = ORG + len(d)

    asm = asm8080.Asm()
    asm.sym.update({'ORIGIN': org})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'koi.asm')
    _, body = asm.assemble(src)

    for addr, was, label in ((PUT, PUT_OLD, 'put'), (INIT, INIT_OLD, 'init')):
        off = addr - ORG
        if bytes(d[off:off + len(was)]) != was:
            sys.exit('по %04X не то, что ожидалось, а %s'
                     % (addr, d[off:off + len(was)].hex()))
        entry = asm.sym[label]
        d[off:off + len(was)] = bytes([0xCD, entry & 0xFF, entry >> 8, 0, 0])
    # бывший переключатель кончался возвратом -- он и остаётся за нашим вызовом
    d[INIT + 5 - ORG] = 0xC9

    off = EXTFONT - ORG
    if bytes(d[off:off + 3]) != EXTFONT_OLD:
        sys.exit('по %04X не установка знакогенератора, а %s'
                 % (EXTFONT, d[off:off + 3].hex()))
    d[off:off + 3] = EXTFONT_NEW
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    print('кодировки в просмотрщике: %d байт по %04X (по адресу загрузки), '
          'врезки по %04X и %04X, знакогенератор при запуске снят по %04X'
          % (len(body), org, PUT, INIT, EXTFONT))


if __name__ == '__main__':
    main()
