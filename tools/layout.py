#!/usr/bin/env python3
"""Раскладка дописанного кода: кто где лежит и не наступил ли кому на ногу.

    ./layout.py                     -- по co-src/co.asm
    ./layout.py co-src/co.asm out/layout.txt

Всё дописанное живёт теперь в самом листинге, поэтому и раскладка берётся
оттуда -- по меткам, которыми размечены куски. Раньше каждый инструмент
сборки отмечался сам, и число в таблице легко расходилось с тем, что он
на самом деле положил.

Печатается таблица и проверяются три вещи: куски не налезают друг на друга,
каждый лежит там, где ему положено, и запас до соседа не ушёл в минус.

Мест всего три, и у каждого своя мерка:

**стек** -- под стеком CO. Стек опущен на BC00, потому что T-72 держит буфер
дисковода по BC00-BFFF. Вылезти за BC00 нельзя: первое же чтение сектора
затрёт код, а до этого его затрёт сам стек. Снизу место подпирает таблица
меню пользователя.

**окно** -- квазидисковое ОЗУ A000-DFFF, где живут буферы самого CO. Свободны
там только куски, которые CO не трогает ни в одном сценарии; выводит их
tools/winholes.py по листингу.

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

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import asm8080                                                  # noqa: E402
# Свободные куски памяти CO не задаются здесь числами, а выводятся из
# листинга: tools/winholes.py перечисляет ВСЕ адреса, которые CO вообще
# называет, раскладывает их по описанным областям и отдаёт то, что не
# покрыто ничем. Раньше границы брались прогоном -- «сюда ни один сценарий не
# писал», -- и доказывали они только про те сценарии, которые прогнали.
#
# Оттуда же берётся и нижняя граница места под стеком.
import winholes                                                 # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(HERE, 'co-src', 'co.asm')

_free = [h for h in winholes.holes() if h[0] >= 0xA000]
HOLES = [h for h in _free if h[1] < 0xB000]
STACK_LO, STACK_HI = next(h for h in _free if h[1] >= 0xB000)
LOAD_LO, LOAD_HI = 0x4100, 0x4FFF     # хвост по адресу загрузки

# Куски: место, метка начала, метка конца, как назвать. Конец -- это метка
# следующего куска или своя; «стек-буфер» отмечен отдельно, чтобы сторож
# целости не считал записи БДОС в наши ФУБ чужой правкой кода.
PIECES = [
    ('окно', 'FIX16K', 'DMAWIN', 'склейка экстентов'),
    ('окно', 'DMAWIN', 'XDRIVE', 'обмен вне окна'),
    ('окно', 'XDRIVE', 'KOI', 'поиск по X:'),
    ('окно', 'KOI', 'VIEWTOP', 'кодировки просмотра'),
    ('окно', 'VIEWTOP', 'EXTBUF', 'шаг назад в тексте'),
    ('окно', 'EXTBUF', 'MNUTAB', 'списки в буфер'),
    ('окно', 'MNUTAB', 'MNUOUT', 'предел таблицы меню'),
    ('окно', 'MNUOUT', 'LSTOUT', 'выход из меню'),
    ('окно', 'LSTOUT', 'HDBODY', 'выход из списка'),
    ('окно', 'HDBODY', 'HDEND', 'номер и метка дискеты'),
    ('стек', 'DSEL', 'DSELEND', 'диск D:'),
    ('стек', 'SCRSTR', 'SCREND', 'строки экрана'),
    ('стек', 'HDDSEL', 'HDDATA', 'дискета НЖМД'),
    ('стек-буфер', 'HDDATA', 'HDDEND', 'дискета НЖМД: буферы'),
    ('загрузка', 'PROBA', 'PROBAEND', 'проба оборудования'),
]


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else SRC
    out = sys.argv[2] if len(sys.argv) > 2 else None
    asm = asm8080.Asm()
    asm.assemble(src)
    sym = asm.sym
    for _, a, b, what in PIECES:
        for name in (a, b):
            if name not in sym:
                sys.exit('в листинге нет метки %s -- где «%s»?' % (name, what))

    items = [(where, sym[a], sym[b] - sym[a], what) for where, a, b, what in PIECES]
    moves = [(sym['STKLO'], sym['STKEND'] - sym['STKLO'], sym['STKFILE'],
              'хвост под стек')]
    if out:
        with open(out, 'w') as f:
            for where, addr, length, name in items:
                f.write('%s,%04X,%d,%s\n' % (where, addr, length, name))
            for dst, length, s, name in moves:
                f.write('перенос,%04X,%d,%04X,%s\n' % (dst, length, s, name))

    items.sort(key=lambda x: (x[0], x[1]))
    bad = []
    print('Раскладка дописанного:')
    for where, addr, length, name in items:
        print('  %-9s %04X-%04X %5d  %s'
              % (where, addr, addr + length - 1, length, name))

    # Перекрытия -- проверяем внутри каждого места отдельно: адреса «загрузки»
    # и «окна» живут в разное время и пересекаться им не запрещено.
    for place in sorted({x[0].split('-', 1)[0] for x in items}):
        cur = [x for x in items if x[0].split('-', 1)[0] == place]
        for (w1, a1, l1, n1), (w2, a2, l2, n2) in zip(cur, cur[1:]):
            if a1 + l1 > a2:
                bad.append('%s: «%s» (%04X..%04X) налезает на «%s» (%04X..)'
                           % (place, n1, a1, a1 + l1 - 1, n2, a2))

    # Под стеком: всё должно уместиться до BC00. Меряем по переносу целиком --
    # в него попадает и то, что лежит между кусками.
    for dst, length, _, _ in moves:
        if dst < STACK_LO or dst + length - 1 > STACK_HI:
            bad.append('стек: занято %04X..%04X, а место только %04X..%04X'
                       % (dst, dst + length - 1, STACK_LO, STACK_HI))
        else:
            print('\nПод стеком занято %04X..%04X, до буфера дисковода (BC00) '
                  'остаётся %d байт' % (dst, dst + length - 1,
                                        STACK_HI + 1 - dst - length))

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
        if where.split('-', 1)[0] == 'загрузка' and not (
                LOAD_LO <= addr and addr + length - 1 <= LOAD_HI):
            bad.append('загрузка: «%s» (%04X..%04X) вне %04X..%04X'
                       % (name, addr, addr + length - 1, LOAD_LO, LOAD_HI))

    print('\nПереносится при старте:')
    for dst, length, s, name in sorted(moves):
        print('  %04X-%04X %5d  из %04X  %s'
              % (dst, dst + length - 1, length, s, name))

    if bad:
        print('\nНе сходится:')
        for b in bad:
            print('  ' + b)
        sys.exit(1)


if __name__ == '__main__':
    main()
