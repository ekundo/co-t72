#!/usr/bin/env python3
"""Значение метки из листинга -- сборке, чтобы не держать адрес в двух местах.

    ./sym.py WINMOVE            -> 43A6
    ./sym.py CHAINOP --dec      -> 17318

Листинг собирается целиком, так что метка может быть любой -- хоть из хвоста,
хоть из тела.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import asm8080                                                  # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def main():
    p = argparse.ArgumentParser(description='значение метки из листинга')
    p.add_argument('name')
    p.add_argument('src', nargs='?', default=os.path.join(HERE, 'co-src', 'co.asm'))
    p.add_argument('--dec', action='store_true', help='печатать десятичным')
    a = p.parse_args()
    asm = asm8080.Asm()
    asm.assemble(a.src)
    if a.name not in asm.sym:
        sys.exit('в листинге нет метки %s' % a.name)
    print(asm.sym[a.name] if a.dec else '%04X' % asm.sym[a.name])


if __name__ == '__main__':
    main()
