#!/usr/bin/env python3
"""Свободные куски памяти CO -- выведенные из листинга, а не измеренные.

    ./tools/winholes.py            таблица занятого и свободного
    ./tools/winholes.py --check    только проверка, молча при успехе

Раньше границы свободного места брались прогоном (DATDIR=... ./check-funcs.sh
и tools/winmap.py): что CO ни разу не тронул, то и считалось свободным. Мерка
честная, но доказывает она только про те сценарии, которые прогнали.

Здесь наоборот. Листинг co-src/co.asm описывает образ целиком, значит можно
перечислить ВСЕ адреса, которые CO вообще называет, и потребовать, чтобы
каждый попал в описанную область. Что не попало ни в одну -- свободно, и это
уже не наблюдение, а перебор: назвать адрес иначе, чем константой в команде,
8080 не умеет.

Две оговорки, обе важные:

* **Адреса, собранные из половинок.** `MVI H,9Fh` с посчитанным L -- это тоже
  адрес, но найти его поиском шестнадцатибитных констант нельзя. Такие места
  ищутся отдельно, по старшему байту, и в отчёт идут строкой «страница». На
  одном из них мы уже обожглись: метки архива по 9F80 ставились именно так.

* **Длины.** Листинг даёт начала буферов, а длину -- не всегда. Где она
  константа (шаг списка панели 680h по 20D4), там всё точно. Где буфер
  читается «сколько в файле» (18C3: с A000 до 80h записей), длина зависит от
  диска пользователя, и такая область помечена как БЕЗ ПРЕДЕЛА: свободное
  выше неё свободно лишь условно.
"""

import argparse
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent
ASM = HERE.parent / 'co-src' / 'co.asm'
LO, HI = 0x6000, 0xDFFF

# Шестнадцатибитные константы в операндах: LXI, LHLD, SHLD, LDA, STA.
LIT = re.compile(r'\b(?:LXI\s+[HDB],|LHLD|SHLD|LDA|STA)\s*0?([0-9A-F]{4})h')
# Старший байт адреса, положенный отдельно: MVI H,9Fh и родня.
HALF = re.compile(r'\bMVI\s+([HDB]),0?([0-9A-F]{2})h')

# Занятое. Каждая область -- (начало, конец, чем занято, откуда известна длина).
# «Конец» включительно. Области могут вкладываться друг в друга.
REGIONS = [
    (0x6100, 0x9FFF, 'буфер копирования, чтения файлов и обмена с квазидиском',
     '3216: LXI B,4000h -- шестнадцать килобайт с 6100; туда же кладут 15D5, '
     '161C и 18EE, а с 9100 собирается текст CO.MNU (3BE2)'),
    (0xA000, 0xA0FF, 'окно просмотрщика: две записи файла по 80h байт',
     '187A: LXI D,A000 и 1888: LXI D,A080'),
    (0xA100, 0xA1FF, 'два сектора, прочитанных БСВВ, и таблица по A101',
     '1C6D: LXI B,A100 и 1C9B: LXI B,A180 -- сектор по 80h байт; '
     '17AC ходит по таблице с A101'),
    (0xA800, 0xA953, 'переменные CO',
     'названы поимённо, от A800 до A88C и от A90D до A951'),
    (0xA954, 0xB653, 'списки панелей: два по 680h байт',
     '20D4 и 29E9: LXI D,0680h -- шаг между панелями; 0DB6: MVI B,80h -- '
     'строк в списке, по 13 байт'),
    (0xB654, 0xB727, 'рабочие ячейки и буфер строки по B6A8 на 80h байт',
     '3BAA: MVI B,80h -- сколько знаков берётся в буфер'),
    (0xB728, 0xB75B, 'таблица меню пользователя: 1Ah записей по два байта',
     '39DA чистит 2Eh байт, а перебор по 3A46 идёт по 1Ah записей -- 34h '
     'байт; берём большее, потому что заполняет её 3A1C без всякого предела'),
    (0xBC00, 0xBFFF, 'буфер дисковода T-72',
     'D_FD_B в MDOS_T-72/Source/_E200h.asm -- не CO, а система'),
    (0xC000, 0xDFFF, 'МикроДОС: ПКК, БДОС, БСВВ',
     'вызовы БСВВ по C01B..C02A, строка ПКК по DF14, переменные дискового '
     'драйвера по DDF0..DDF6'),
]

# Читатели без предела: начало известно, а докуда дойдут -- зависит от файла.
UNBOUNDED = [
    (0xA000, 0x80 * 128, 'чтение файла целиком с A000',
     '18C3: MVI C,00h и 18D8: CPI 80h -- до 80h записей по 80h байт. В нашей '
     'сборке так читается только CO.ZGR: CO.EXT и CO.MNU уведены в буфер '
     'копирования (tools/extbuf.asm)'),
]


def named():
    """Адреса, которые CO называет: (адрес -> строки листинга) и страницы."""
    whole, pages = {}, {}
    for ln in ASM.read_text().split('\n'):
        if ln.lstrip().startswith(';'):
            continue
        for m in LIT.finditer(ln):
            a = int(m.group(1), 16)
            if LO <= a <= HI:
                whole.setdefault(a, []).append(ln.strip()[:52])
        for m in HALF.finditer(ln):
            p = int(m.group(2), 16)
            if LO >> 8 <= p <= HI >> 8:
                pages.setdefault(p, []).append(ln.strip()[:52])
    return whole, pages


def covers(a):
    for lo, hi, what, _ in REGIONS:
        if lo <= a <= hi:
            return what
    return None


def holes():
    busy = bytearray(HI - LO + 1)
    for lo, hi, _, _ in REGIONS:
        for a in range(max(lo, LO), min(hi, HI) + 1):
            busy[a - LO] = 1
    out, a = [], LO
    while a <= HI:
        if busy[a - LO]:
            a += 1
            continue
        b = a
        while b <= HI and not busy[b - LO]:
            b += 1
        out.append((a, b - 1))
        a = b
    return out


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--check', action='store_true',
                   help='только проверка: молчит, пока всё сходится')
    a = p.parse_args()

    whole, pages = named()
    lost = [x for x in sorted(whole) if covers(x) is None]

    if not a.check:
        print('Адресов, которые CO называет в %04X-%04X: %d константой'
              % (LO, HI, len(whole)))
        if pages:
            print('Ещё %d старших байтов положены отдельно (MVI H и родня) -- '
                  'адрес собирается на ходу:' % len(pages))
            for pg in sorted(pages):
                print('   страница %02Xxx: %s' % (pg, pages[pg][0]))
        print()
        print('Занято:')
        for lo, hi, what, why in REGIONS:
            n = sum(1 for x in whole if lo <= x <= hi)
            print('  %04X-%04X %5d  %s' % (lo, hi, hi - lo + 1, what))
            print('  %14s  названо адресов: %d; %s' % ('', n, why))
        print()
        print('Без предела -- докуда дойдёт, зависит от файла:')
        for base, reach, what, why in UNBOUNDED:
            print('  с %04X и до %04X  %s' % (base, base + reach - 1, what))
            print('  %17s %s' % ('', why))
        print()
        print('Свободно -- ни одна область не покрывает, и никто не называет:')
        for lo, hi in holes():
            mark = ''
            for base, reach, _, _ in UNBOUNDED:
                if base <= lo < base + reach:
                    mark = '  (условно: сюда дотянется чтение с %04X)' % base
            print('  %04X-%04X %5d%s' % (lo, hi, hi - lo + 1, mark))

    if lost:
        print('\nНе сходится: CO называет адреса, которых нет ни в одной '
              'области:', file=sys.stderr)
        for x in lost:
            print('  %04X  %s' % (x, whole[x][0]), file=sys.stderr)
        sys.exit(1)
    if a.check:
        print('карта сходится: все %d названных адреса описаны' % len(whole))


if __name__ == '__main__':
    main()
