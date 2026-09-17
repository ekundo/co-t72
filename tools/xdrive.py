#!/usr/bin/env python3
"""Поиск программы по "X:" -- и на втором квазидиске.

    ./xdrive.py CO.COM out.com --dflag B843

Сам код -- в xdrive.asm, здесь только сборка и врезка. Накладка остаётся по
адресу загрузки, ниже A000, и хвост под стеком не занимает.

Врезка одна: по 104D в переборе дисков стоит "MVI A,'A' / STA B673" -- переход
от C: к A:. Пять байт меняются на вызов накладки и два NOP.
"""

import argparse
import os
import sys

import asm8080

ORG = 0x100
HOOK = 0x104D
HOOK_OLD = bytes([0x3E, 0x41, 0x32, 0x73, 0xB6])    # MVI A,'A' / STA B673


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--dflag', required=True,
                   help='адрес признака «второй квазидиск есть» (dsel.py)')
    p.add_argument('--at', help='адрес, по которому накладка будет работать')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    org = ORG + len(d)
    run = int(a.at, 16) if a.at else org

    asm = asm8080.Asm()
    asm.sym.update({'ORIGIN': run, 'DFLAG': int(a.dflag, 16)})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'xdrive.asm')
    _, body = asm.assemble(src)

    off = HOOK - ORG
    if bytes(d[off:off + len(HOOK_OLD)]) != HOOK_OLD:
        sys.exit('по %04X не переход к диску A:, а %s'
                 % (HOOK, d[off:off + len(HOOK_OLD)].hex()))
    d[off:off + len(HOOK_OLD)] = bytes([0xCD, run & 0xFF, run >> 8, 0, 0])
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    where = ('%04X (в окне, исходник по %04X)' % (run, org)) if a.at \
        else '%04X (по адресу загрузки)' % org
    print('поиск по X: с диском D:: %d байт по %s, врезка по %04X'
          % (len(body), where, HOOK))
    if a.at:
        print('winnext=%04X' % (run + len(body)))


if __name__ == '__main__':
    main()
