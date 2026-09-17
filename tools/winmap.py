#!/usr/bin/env python3
"""Свести карты окна A000-DFFF в одну и показать, где там свободно.

    DATDIR=карты ./check-funcs.sh out/          # снять карты сценариев
    ./tools/winmap.py карты                     # свести и показать

Карту на сценарий пишет check-funcs.sh: по байту на адрес окна, 1 -- читали,
2 -- писали, 4 -- это делал сам CO, а не дописанный сборкой код. Сводим их все
вместе: адрес считается занятым, если хоть один сценарий его тронул. Чтения тут
не менее важны, чем записи: если CO оттуда читает, значит ждёт там свои данные,
и класть туда своё нельзя.

Свободным считается то, чего не трогает сам CO (четвёртый разряд). Иначе наши
же накладки выглядели бы как чужая занятая память: их переносчик пишет в окно
при старте, а потом они там работают.

Чего карта не видит: выборку команд. Код, который ничего не читает и не пишет,
в ней не проявится, -- поэтому наши накладки перечислены отдельной таблицей.
"""

import argparse
import pathlib
import sys

WIN = 0xA000
SIZE = 0x4000

# Кто в окне живёт по нашей воле: сборка переносит это туда при старте.
# Адреса печатает patch-co.sh, сверять по его выводу.
OURS = [
    (0xA448, 0xA4CB, 'обмен через буфер вне окна (dmawin)'),
    (0xA4CC, 0xA4EA, 'поиск по X: с диском D: (xdrive)'),
    (0xA4EB, 0xA54E, 'кодировки просмотрщика (koi)'),
    (0xA600, 0xA78B, 'номер и метка дискеты (hdinfo)'),
]

# Что в окне не наше и трогать нельзя ни при каких условиях.
THEIRS = [
    (0xBC00, 0xBFFF, 'буфер дисковода T-72'),
    (0xDFC9, 0xDFFF, 'ячейки ОС'),
]


def ranges(flags, want, gap):
    """Куски, где флаг стоит; дыры короче gap внутри куска не разрывают его."""
    out = []
    beg = None
    hole = 0
    for i in range(SIZE + 1):
        on = i < SIZE and (flags[i] & want)
        if on:
            if beg is None:
                beg = i
            hole = 0
        elif beg is not None:
            hole += 1
            if hole > gap or i == SIZE:
                out.append((beg + WIN, i - hole + WIN))
                beg = None
    return out


def name_of(lo, hi):
    """Чьё это место -- по спискам выше."""
    hits = [n for a, b, n in OURS + THEIRS if a <= hi and b >= lo]
    return ', '.join(hits)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('dir', help='каталог с картами *.win от check-funcs.sh')
    p.add_argument('--gap', type=int, default=16,
                   help='дыра короче этого не разрывает занятый кусок')
    p.add_argument('--hole', type=int, default=32,
                   help='свободные куски короче этого не показывать')
    p.add_argument('--without', default='',
                   help='сценарии, которые не считать (через запятую): например'
                        ' те, где CO запускает чужую программу и та распоряжается'
                        ' памятью уже сама')
    a = p.parse_args()
    skip = set(filter(None, a.without.split(',')))

    files = sorted(pathlib.Path(a.dir).glob('*.win'))
    if not files:
        sys.exit('карт нет: %s/*.win' % a.dir)
    files = [f for f in files if f.stem not in skip]
    all_ = bytearray(SIZE)
    who = {}                    # адрес -> какие сценарии его трогали
    for f in files:
        d = f.read_bytes()
        if len(d) != SIZE:
            sys.exit('%s: не карта окна (%d байт)' % (f, len(d)))
        for i, b in enumerate(d):
            all_[i] |= b
            if b & 4:
                who.setdefault(i, []).append(f.stem)

    touched = sum(1 for b in all_ if b & 4)
    written = sum(1 for b in all_ if b & 6 == 6)
    print('карт: %d, сам CO тронул %d байт из %d, из них записью %d'
          % (len(files), touched, SIZE, written))

    print('\nЗанято самим CO:')
    for lo, hi in ranges(all_, 4, a.gap):
        names = set()
        for i in range(lo - WIN, hi - WIN + 1):
            names.update(who.get(i, ()))
        short = ', '.join(sorted(names)[:4]) + ('...' if len(names) > 4 else '')
        print('  %04X-%04X  %5d  %-42s %s'
              % (lo, hi, hi - lo + 1, name_of(lo, hi), short))

    print('\nСвободно (куски от %d байт):' % a.hole)
    free = []
    prev = WIN - 1
    for lo, hi in ranges(all_, 4, a.gap):
        if lo - prev - 1 >= a.hole:
            free.append((prev + 1, lo - 1))
        prev = hi
    if SIZE + WIN - 1 - prev >= a.hole:
        free.append((prev + 1, WIN + SIZE - 1))
    for lo, hi in free:
        who = name_of(lo, hi)
        print('  %04X-%04X  %5d%s' % (lo, hi, hi - lo + 1,
                                      '  ' + who if who else ''))

    print('\nНаши накладки:')
    for lo, hi, what in OURS:
        busy = [i + WIN for i in range(lo - WIN, hi - WIN + 1) if all_[i] & 4]
        mark = 'чисто' if not busy else ('CO сюда ходит: %04X-%04X, %d байт'
                                         % (min(busy), max(busy), len(busy)))
        print('  %04X-%04X  %5d  %-38s %s'
              % (lo, hi, hi - lo + 1, what, mark))


if __name__ == '__main__':
    main()
