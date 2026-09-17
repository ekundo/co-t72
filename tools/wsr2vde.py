#!/usr/bin/env python3
"""Редактор на клавише «СС»-«4»: WSR -> VDE.

    ./wsr2vde.py CO.COM

WordStar (WSR.COM) заточен под КОИ-7 и под T-72 толком не работает, поэтому в
выпуске на этой клавише стоит VDE -- та же WordStar-раскладка команд, но
переведённая на 8080 и работающая в КОИ-8 (см. vde/README.md).

Меняются две вещи.

Имя запускаемой программы. Имена лежат в CO таблицей по 12 байт одно за другим:
MEDIT, WSR, SID. Поле имени там девять знаков, а не восемь, как в каталоге
CP/M, -- на это легко попасться. Длина у VDE та же, ничего не съезжает.

Подпись в нижней строке. Строка подсказки ровно 79 знаков, и укоротить её нельзя
-- уедет весь остаток. "4-WordStar" на пять знаков длиннее "4-VDE", поэтому пять
освободившихся возвращаются пробелами в ближайшие промежутки между подписями:
длина та же, а дыры в середине не видно. Соседей по строке при этом не называем
по именам -- на этом шаге там ещё "7-Печать", которую на "7-Hdd" меняет более
поздняя правка. Строка лежит в образе в двух копиях, правятся обе.
"""

import argparse
import re
import sys

OLD = b'WSR' + b' ' * 6 + b'COM'
NEW = b'VDE' + b' ' * 6 + b'COM'

BAR_OLD = b'4-WordStar'
BAR_NEW = b'4-VDE'
SPARE = len(BAR_OLD) - len(BAR_NEW)
GAP = re.compile(rb' (\d-)')            # промежуток перед следующей подписью


def fix_bar(d, i):
    """Поправить подпись в строке подсказки, что лежит по смещению i."""
    start = d.rfind(b'\0', 0, i) + 1
    end = d.find(b'\0', i)
    line = bytes(d[start:end])
    k = line.index(BAR_OLD)
    tail, n = GAP.subn(rb'  \1', line[k + len(BAR_OLD):], count=SPARE)
    fixed = line[:k] + BAR_NEW + tail
    if n != SPARE or len(fixed) != len(line):
        sys.exit('строка подсказки по %04X: не вышло вернуть пробелы '
                 '(%d из %d, длина %d вместо %d)'
                 % (0x100 + start, n, SPARE, len(fixed), len(line)))
    d[start:end] = fixed


def main():
    p = argparse.ArgumentParser(description='редактор на "СС"-"4": WSR -> VDE')
    p.add_argument('image', help='CO.COM (правится на месте)')
    p.add_argument('-o', '--out', help='куда записать (по умолчанию -- на место)')
    a = p.parse_args()

    d = bytearray(open(a.image, 'rb').read())
    n = d.count(OLD)
    if n != 1:
        sys.exit('имя WSR встречается %d раз -- ожидалось ровно одно' % n)
    i = d.index(OLD)
    d[i:i + len(OLD)] = NEW

    bars = []
    j = 0
    while True:
        j = d.find(BAR_OLD, j)
        if j < 0:
            break
        fix_bar(d, j)
        bars.append(0x100 + j)
        j += 1
    if not bars:
        sys.exit('подписи "4-WordStar" в нижней строке не нашлось')

    open(a.out or a.image, 'wb').write(bytes(d))
    print('редактор на "СС"-"4": WSR -> VDE (%04X), подпись в строке подсказки '
          '(%s)' % (0x100 + i, ', '.join('%04X' % b for b in bars)))


if __name__ == '__main__':
    main()
