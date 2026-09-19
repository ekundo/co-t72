#!/usr/bin/env python3
"""Что было на панелях CO в конце прогона -- по снимку памяти.

    RAMDIR=/tmp/снимки ONLY=просмстр ./check-funcs.sh out-buf/
    ./tools/panel.py /tmp/снимки/C-просмстр.ram

Снимок памяти (V06X_RAM_SAVE) check-funcs.sh кладёт в RAMDIR рядом с образом
квазидиска. По нему видно то, чего не видно ни в карте исполнения, ни в следе
обращений: какой файл был под курсором, сколько строк набралось в списке, где
стоял просмотрщик. Без этого сценарии приходится писать вслепую -- «Down, Down»
на разных дисках приводят к разным файлам.

Списки панелей лежат с A954, по 680h байт на панель: 128 строк по 13 байт --
восемь знаков имени, признак метки, три знака расширения и размер.
"""

import argparse
import pathlib

ROWS = 0xA954           # список первой панели; вторая -- на 680h дальше
STEP = 0x680
WIDE = 13               # байт на строку списка
COUNT = 0xB689          # сколько строк в списке; у второй панели -- B68B
COUNT2 = 0xB68B         # переменные панелей лежат парами (см. 0E47 в co.asm)
CURSOR = 0xB69B         # номер строки под курсором
WHICH = 0xB69D          # какая панель активна: 1 или 2
LETTERS = 0x3E91        # буквы дисков обеих панелей
VIEW = {'A853': 'верхняя строка просмотра', 'A855': 'указатель в тексте',
        'A83E': 'номер записи файла', 'A840': 'строка, к которой едем'}


def main():
    p = argparse.ArgumentParser()
    p.add_argument('ram', help='снимок памяти от check-funcs.sh (RAMDIR)')
    p.add_argument('--rows', type=int, default=40, help='сколько строк показать')
    a = p.parse_args()

    r = pathlib.Path(a.ram).read_bytes()
    word = lambda x: r[x] | r[x + 1] << 8
    which = r[WHICH]
    print('панели: 1=%s: (%d строк) 2=%s: (%d строк), активна %d, курсор на %d'
          % (chr(r[LETTERS]), r[COUNT], chr(r[LETTERS + 1]), r[COUNT2],
             which, r[CURSOR]))
    print('просмотр: ' + ', '.join('%s=%04X (%s)' % (k, word(int(k, 16)), v)
                                   for k, v in VIEW.items()))
    for n in (1, 2):
        print('--- панель %d%s' % (n, ' (активная)' if n == which else ''))
        base = ROWS + (n - 1) * STEP
        for i in range(min(a.rows, r[COUNT if n == 1 else COUNT2])):
            e = base + i * WIDE
            name = r[e:e + 8].decode('koi8-r', 'replace')
            ext = r[e + 9:e + 12].decode('koi8-r', 'replace')
            if not name.strip() or r[e] in (0x00, 0xFF):
                break
            mark = '*' if r[e + 8] == 0x7F else ' '
            here = '<-' if n == which and i + 1 == r[CURSOR] else ''
            print('%3d %s%s.%s %4d %s' % (i + 1, mark, name, ext, r[e + 12], here))


if __name__ == '__main__':
    main()
