#!/usr/bin/env python3
"""Раскладка дописанного кода: кто где лежит и не наступил ли кому на ногу.

Каждый инструмент сборки, который дописывает свой код, отмечается здесь --
`layout.note(где, адрес, длина, имя)`. Строки копятся в файле из переменной
окружения CO_LAYOUT (его заводит patch-co.sh), а в конце сборки

    ./tools/layout.py out/layout.txt

печатает таблицу и проверяет три вещи: куски не налезают друг на друга, каждый
лежит там, где ему положено, и запас до соседа не ушёл в минус.

Мест всего три, и у каждого своя мерка:

**стек** -- B756..BBFF, под стеком CO. Стек опущен на BC00, потому что T-72
держит буфер дисковода по BC00-BFFF. Вылезти за BC00 нельзя: первое же чтение
сектора затрёт код, а до этого его затрёт сам стек. Снизу место подпирает
таблица меню пользователя (B728-B755).

**окно** -- квазидисковое ОЗУ A000-DFFF, где живут буферы самого CO. Свободны
там только куски, которые CO не трогает ни в одном сценарии; они измерены
прогоном и записаны в HOLES. Как измерять -- см. tools/winmap.py и
docs/co-buffers.md.

**загрузка** -- адрес, по которому хвост образа лёг при запуске. Это место
живёт только до первого чтения каталога: копия каталога дискеты ложится с 4000
и накрывает 4000-4FFF целиком. Годится для пускового кода и ни для чего больше.
"""

import os
import sys

# Свободные куски окна. Мерка -- прогон сценариев (DATDIR=... ./check-funcs.sh
# и tools/winmap.py): что CO не тронул ни разу. Верхняя граница A7FF не из
# прогона, а из устройства CO: с A000 он читает файлы целиком (18E5), а с A954
# начинаются списки панелей -- по 680h на каждую. Значит A000..A7FF безопасны
# ровно до тех пор, пока CO.MNU и CO.EXT остаются меньше килобайта. Подробности
# и как перемерить -- в docs/co-buffers.md.
HOLES = [
    (0xA1ED, 0xA7FF),
]

# Куда relocstub.py уводит хвост образа и докуда там место. Ниже B756 --
# буферы самого CO: таблица меню пользователя (B728-B755, чистится при каждом
# открытии меню) и буфер строки (по B6A8, достаёт до B727). Выше BBFF --
# стек, он растёт вниз от BC00, а с BC00 начинается буфер дисковода T-72.
STACK_LO, STACK_HI = 0xB756, 0xBBFF
LOAD_LO, LOAD_HI = 0x4100, 0x4FFF     # хвост по адресу загрузки


def note(where, addr, length, name):
    """Отметить кусок дописанного кода. Печатает строку и, если сборка просила,
    дописывает её в файл раскладки."""
    line = 'layout=%s,%04X,%d,%s' % (where, addr, length, name)
    print(line)
    path = os.environ.get('CO_LAYOUT')
    if path:
        with open(path, 'a') as f:
            f.write(line[len('layout='):] + '\n')


def read(path):
    out = []
    for ln in open(path):
        ln = ln.strip()
        if not ln:
            continue
        where, addr, length, name = ln.split(',', 3)
        out.append((where, int(addr, 16), int(length), name))
    return out


def main():
    if len(sys.argv) != 2:
        sys.exit('раскладка: ./layout.py out/layout.txt')
    items = sorted(read(sys.argv[1]), key=lambda x: (x[0], x[1]))
    bad = []

    print('Раскладка дописанного:')
    for where, addr, length, name in items:
        print('  %-9s %04X-%04X %5d  %s'
              % (where, addr, addr + length - 1, length, name))

    # Перекрытия -- проверяем внутри каждого места отдельно: адреса «загрузки»
    # и «окна» живут в разное время и пересекаться им не запрещено.
    for place in sorted({x[0] for x in items}):
        cur = [x for x in items if x[0] == place]
        for (w1, a1, l1, n1), (w2, a2, l2, n2) in zip(cur, cur[1:]):
            if a1 + l1 > a2:
                bad.append('%s: «%s» (%04X..%04X) налезает на «%s» (%04X..)'
                           % (place, n1, a1, a1 + l1 - 1, n2, a2))

    # Под стеком: всё должно уместиться до BC00.
    st = [x for x in items if x[0] == 'стек']
    if st:
        end = max(a + l for _, a, l, _ in st)
        lo = min(a for _, a, _, _ in st)
        if lo < STACK_LO or end - 1 > STACK_HI:
            bad.append('стек: занято %04X..%04X, а место только %04X..%04X'
                       % (lo, end - 1, STACK_LO, STACK_HI))
        else:
            print('\nПод стеком занято %04X..%04X, до буфера дисковода (BC00) '
                  'остаётся %d байт' % (lo, end - 1, STACK_HI + 1 - end))

    # В окне: каждый кусок целиком внутри одной измеренной дыры.
    win = [x for x in items if x[0] == 'окно']
    if win:
        print('\nВ окне:')
        for where, addr, length, name in win:
            fit = [h for h in HOLES if h[0] <= addr and addr + length - 1 <= h[1]]
            if not fit:
                bad.append('окно: «%s» (%04X..%04X) не помещается ни в одну '
                           'свободную дыру' % (name, addr, addr + length - 1))
                continue
            h = fit[0]
            print('  %04X-%04X  %-28s дыра %04X-%04X, свободно ещё %d байт'
                  % (addr, addr + length - 1, name, h[0], h[1],
                     h[1] - (addr + length - 1)))

    # По адресу загрузки: только пусковое, и только выше 4100.
    for where, addr, length, name in items:
        if where == 'загрузка' and not (LOAD_LO <= addr and
                                        addr + length - 1 <= LOAD_HI):
            bad.append('загрузка: «%s» (%04X..%04X) вне %04X..%04X'
                       % (name, addr, addr + length - 1, LOAD_LO, LOAD_HI))

    if bad:
        print('\nНе сходится:')
        for b in bad:
            print('  ' + b)
        sys.exit(1)


if __name__ == '__main__':
    main()
