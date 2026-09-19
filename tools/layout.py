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

К месту можно дописать уточнение через дефис -- `стек-буфер`. Проверки от
этого не меняются (мерка берётся по части до дефиса), а вот сторож целости в
check-funcs.sh отличает буфер от кода: в буфер по нашей же просьбе пишет ОС,
и ругаться на такую запись не на что.
"""

import os
import sys

# Свободные куски памяти CO не задаются здесь числами, а выводятся из
# листинга: tools/winholes.py перечисляет ВСЕ адреса, которые CO вообще
# называет, раскладывает их по описанным областям и отдаёт то, что не
# покрыто ничем. Раньше границы брались прогоном -- «сюда ни один сценарий не
# писал», -- и доказывали они только про те сценарии, которые прогнали.
#
# Оттуда же берётся и нижняя граница места под стеком. Она, кстати, на шесть
# байт выше, чем стояла раньше: таблицу меню пользователя CO чистит на 2Eh
# байт (39DA), а перебирает на 1Ah записей, то есть 34h байт (3A46) -- и
# заполняет вообще без предела. Считать её краем надо по большему.
import winholes

_free = [h for h in winholes.holes() if h[0] >= 0xA000]
HOLES = [h for h in _free if h[1] < 0xB000]
STACK_LO, STACK_HI = next(h for h in _free if h[1] >= 0xB000)
LOAD_LO, LOAD_HI = 0x4100, 0x4FFF     # хвост по адресу загрузки


def base(where):
    """Место без уточнения: «стек-буфер» меряется как «стек»."""
    return where.split('-', 1)[0]


def note(where, addr, length, name):
    """Отметить кусок дописанного кода. Печатает строку и, если сборка просила,
    дописывает её в файл раскладки."""
    line = 'layout=%s,%04X,%d,%s' % (where, addr, length, name)
    print(line)
    path = os.environ.get('CO_LAYOUT')
    if path:
        with open(path, 'a') as f:
            f.write(line[len('layout='):] + '\n')


def moved(dst, length, src, name):
    """Отметить перенос: что при старте копируется из образа в память.

    По этим строкам проверка сверяет память после прогона с самим образом --
    так видно, цел ли перенесённый код к концу работы. Следа обращений для
    этого мало: стековые обращения в него не пишутся, а стек лежит как раз над
    дописанным кодом."""
    line = 'layout=перенос,%04X,%d,%04X,%s' % (dst, length, src, name)
    print(line)
    path = os.environ.get('CO_LAYOUT')
    if path:
        with open(path, 'a') as f:
            f.write(line[len('layout='):] + '\n')


def read(path):
    out, moves = [], []
    for ln in open(path):
        ln = ln.strip()
        if not ln:
            continue
        if ln.startswith('перенос,'):
            _, dst, length, src, name = ln.split(',', 4)
            moves.append((int(dst, 16), int(length), int(src, 16), name))
            continue
        where, addr, length, name = ln.split(',', 3)
        out.append((where, int(addr, 16), int(length), name))
    return out, moves


def main():
    if len(sys.argv) != 2:
        sys.exit('раскладка: ./layout.py out/layout.txt')
    items, moves = read(sys.argv[1])
    items.sort(key=lambda x: (x[0], x[1]))
    bad = []

    print('Раскладка дописанного:')
    for where, addr, length, name in items:
        print('  %-9s %04X-%04X %5d  %s'
              % (where, addr, addr + length - 1, length, name))

    # Перекрытия -- проверяем внутри каждого места отдельно: адреса «загрузки»
    # и «окна» живут в разное время и пересекаться им не запрещено.
    for place in sorted({base(x[0]) for x in items}):
        cur = [x for x in items if base(x[0]) == place]
        for (w1, a1, l1, n1), (w2, a2, l2, n2) in zip(cur, cur[1:]):
            if a1 + l1 > a2:
                bad.append('%s: «%s» (%04X..%04X) налезает на «%s» (%04X..)'
                           % (place, n1, a1, a1 + l1 - 1, n2, a2))

    # Под стеком: всё должно уместиться до BC00.
    st = [x for x in items if base(x[0]) == 'стек']
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
    win = [x for x in items if base(x[0]) == 'окно']
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
        if base(where) == 'загрузка' and not (LOAD_LO <= addr and
                                              addr + length - 1 <= LOAD_HI):
            bad.append('загрузка: «%s» (%04X..%04X) вне %04X..%04X'
                       % (name, addr, addr + length - 1, LOAD_LO, LOAD_HI))

    if moves:
        print('\nПереносится при старте:')
        for dst, length, src, name in sorted(moves):
            print('  %04X-%04X %5d  из %04X  %s'
                  % (dst, dst + length - 1, length, src, name))

    if bad:
        print('\nНе сходится:')
        for b in bad:
            print('  ' + b)
        sys.exit(1)


if __name__ == '__main__':
    main()
