#!/usr/bin/env python3
"""Накладки окна: сколько их и умещаются ли они в свою дыру.

    ./oknolen.py                 -- напечатать длину куска, который едет в окно
    ./oknolen.py --layout        -- то же и отметиться в раскладке сборки

Куски лежат в хвосте листинга (co-src/okno.asm) и переносятся на A448. Длину
сборке надо числом, а держать это число в двух местах -- верный способ однажды
их развести; поэтому она берётся из самого листинга, по меткам.

Заодно здесь та проверка, которую раньше делал layout.py по отметкам
инструментов: накладки не должны дорасти до надписи в рамке панели, она стоит
на A660.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import asm8080                                                  # noqa: E402
import layout                                                   # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WIN = 0xA448            # куда переносятся накладки
LABEL = 0xA660          # надпись в рамке панели -- дальше нельзя

# Метка -> как этот кусок называется в раскладке.
PIECES = [('FIX16K', 'склейка экстентов'),
          ('DMAWIN', 'обмен вне окна'),
          ('XDRIVE', 'поиск по X:'),
          ('KOI', 'кодировки просмотра'),
          ('VIEWTOP', 'шаг назад в тексте'),
          ('EXTBUF', 'списки в буфер'),
          ('MNUTAB', 'предел таблицы меню'),
          ('OKNOEND', None)]


def main():
    p = argparse.ArgumentParser(description='длина накладок окна')
    p.add_argument('src', nargs='?', default=os.path.join(HERE, 'co-src', 'co.asm'))
    p.add_argument('--layout', action='store_true',
                   help='отметить куски в раскладке сборки')
    a = p.parse_args()

    asm = asm8080.Asm()
    asm.assemble(a.src)
    for name, _ in PIECES:
        if name not in asm.sym:
            sys.exit('в листинге нет метки %s -- где накладки окна?' % name)
    if asm.sym['OKNOEND'] > LABEL:
        sys.exit('накладки окна доросли до %04X, а с %04X надпись в рамке'
                 % (asm.sym['OKNOEND'], LABEL))

    if a.layout:
        for (name, what), (nxt, _) in zip(PIECES, PIECES[1:]):
            layout.note('окно', asm.sym[name], asm.sym[nxt] - asm.sym[name], what)
    print(asm.sym['OKNOEND'] - WIN)


if __name__ == '__main__':
    main()
