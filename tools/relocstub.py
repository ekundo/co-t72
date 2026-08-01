#!/usr/bin/env python3
"""Перенести добавленный код из хвоста образа под стек при старте CO.

Дописанное в хвост (склейка экстентов, выбор дискеты НЖМД) нельзя исполнять на
месте: по 4100 у CO буфер, куда ОС кладёт сектор каталога. При чтении чужого
диска буфер оживает, код затирается, и первый же вызов уходит в мусор -- ловится
это как «зависание с мусором на экране» при переходе на диск B.

Поэтому код собран по адресу B900 (под стеком CO на BC00, выше его буферов), а в
файле лежит с 4100. Этот стаб копирует его на место при входе в программу и
заодно ставит стек -- всё помещается в 40DB..40FF, где у позднего выпуска CO
была бесполезная проверка «смените ДОС».
"""

import argparse
import sys

ORG = 0x100
STUB = 0x40DB
FILE_AT = 0x4100
RUNTIME = 0xB900


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    args = p.parse_args()

    d = bytearray(open(args.infile, 'rb').read())
    n = len(d) - (FILE_AT - ORG)
    if n <= 0:
        sys.exit('в хвосте нечего переносить')

    loop = STUB + 9
    stub = bytes([0x21, FILE_AT & 0xFF, FILE_AT >> 8,      # LXI H,4100
                  0x11, RUNTIME & 0xFF, RUNTIME >> 8,      # LXI D,B900
                  0x01, n & 0xFF, n >> 8,                  # LXI B,длина
                  0x7E, 0x12, 0x23, 0x13,                  # MOV A,M/STAX D/INX H/INX D
                  0x0B, 0x78, 0xB1,                        # DCX B / MOV A,B / ORA C
                  0xC2, loop & 0xFF, loop >> 8,            # JNZ loop
                  0x2A, 0x06, 0x00,                        # LHLD 0006
                  0x22, 0x09, 0x00,                        # SHLD 0009 -- RST 1 в БДОС
                  0x31, 0x00, 0xBC,                        # LXI SP,BC00h
                  0xC3, 0x71, 0x40])                       # JMP 4071
    if STUB - ORG + len(stub) > 0x4100 - ORG:
        sys.exit('стаб не помещается до 4100h: %d байт' % len(stub))
    d[STUB - ORG:STUB - ORG + len(stub)] = stub
    d[0x0101 - ORG:0x0103 - ORG] = bytes([STUB & 0xFF, STUB >> 8])
    open(args.outfile, 'wb').write(bytes(d))
    print('перенос хвоста: %d байт с %04X на %04X, стаб %d байт по %04X'
          % (n, FILE_AT, RUNTIME, len(stub), STUB))


if __name__ == '__main__':
    main()
