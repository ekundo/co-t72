#!/usr/bin/env python3
"""Заменить заставку CO.

Блок по 3FB8 печатает цикл на 3EAE: ровно 0x67 байт, каждый перед выводом
инвертируется (`CMA`), поэтому в файле он лежит дополнением. Длина зашита в
`MVI B,67h` на 3EB1, так что блок надо заполнять целиком -- лишнее добиваем
пробелами перед хвостом.

Хвост -- `0D 0A 0D 0A 1B 5B` -- оставляем как был: `1B 5B` это ESC [, которым
CO переключает знакогенератор на КОИ-8, и без него дальше полезет не тот шрифт.
"""

import argparse
import sys

ORG = 0x100
AT = 0x3FB8
LEN = 0x67
TAIL = b'\r\n\r\n\x1b['

TEXT = ['Версия 2.0.1 от 02.08.2026',
        'Харьков 1993',
        'Шишатский С.М.']


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    args = p.parse_args()

    d = bytearray(open(args.infile, 'rb').read())
    body = b'\r\n' + b'\r\n'.join(t.encode('koi8-r') for t in TEXT)
    block = body + b' ' * (LEN - len(body) - len(TAIL)) + TAIL
    if len(block) != LEN:
        sys.exit('заставка не влезает: %d байт при пределе %d' % (len(body) + len(TAIL), LEN))
    d[AT - ORG:AT - ORG + LEN] = bytes((~c) & 0xFF for c in block)
    open(args.outfile, 'wb').write(bytes(d))
    print('заставка заменена: %d байт текста из %d' % (len(body), LEN))


if __name__ == '__main__':
    main()
