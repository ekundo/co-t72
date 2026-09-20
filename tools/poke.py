#!/usr/bin/env python3
"""Вписать слово в образ по адресу.

    ./poke.py CO.COM 4397 48A2       -- по 4397 лечь адресу 48A2, младшим вперёд

Нужно, пока пусковая цепочка переезжает в листинг по частям: та часть, что уже
в листинге, кончается слотом (CHAIN в co-src/pusk.asm), и сюда сборка вписывает
адрес следующей пусковой подпрограммы -- той, что всё ещё выкладывается
питоном. Когда переедет и она, слот станет обычным JMP на метку, а этот
инструмент пропадёт.
"""

import argparse
import sys

ORG = 0x100


def main():
    p = argparse.ArgumentParser(description='вписать слово в образ')
    p.add_argument('image')
    p.add_argument('at', help='адрес в образе, 16-рично')
    p.add_argument('value', help='что вписать, 16-рично')
    a = p.parse_args()

    d = bytearray(open(a.image, 'rb').read())
    at, val = int(a.at, 16) - ORG, int(a.value, 16)
    if not 0 <= at < len(d) - 1:
        sys.exit('адрес %s вне образа' % a.at)
    d[at], d[at + 1] = val & 0xFF, val >> 8
    open(a.image, 'wb').write(bytes(d))
    print('по %s легло %04X' % (a.at, val))


if __name__ == '__main__':
    main()
