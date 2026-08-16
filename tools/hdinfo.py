#!/usr/bin/env python3
"""Номер дискеты НЖМД и её метка в рамке панели CO.

    ./hdinfo.py CO.COM out.com --tdrva EBDC --disk E2FF

Сам код -- в hdinfo.asm, здесь только сборка и врезка.

Живёт накладка не под стеком, где остальной дописанный код, а по A600: под
стеком места больше нет. Стек CO при старте уходит до BB66 (глубже всех
забирается клавиатурная часть БСВВ), и всё, что лежит выше, затирается. А
A480..A7FF -- дыра между буферами самого CO: за целую сессию -- запуск, смена
дисков, копирование, помощь, просмотр, меню -- CO не пишет туда ни байта.

В хвост образа кладётся копировщик и следом само тело. Хвост, как и прежде,
относит под стек стаб из relocstub.py; копировщик оттуда переносит тело на A600
и уходит в следующую пусковую подпрограмму. Что тело при этом лежит в области,
которую потом затопчет стек, неважно: к тому времени оно уже переехало.

Врезка одна: по 091B у CO начинается отрисовка панели, первой командой там
`CALL 19E8`. Меняем её на переход к себе, а затёртое выполняем сами. Панель
рисуется из десяти мест -- и при смене диска, и после команд, -- так что надпись
в рамке обновляется всюду, где надо, и нигде больше.

Адреса, разные у сборок T-72, приходят снаружи: таблица дискет и дисковый
обработчик БСВВ. Их находит patch-co.sh по дампу живой машины.
"""

import argparse
import os
import sys

import asm8080

ORG = 0x100
FILE_AT = 0x4100        # с этого адреса в файле лежит переносимый хвост
RUNTIME = 0xB740        # ... а работает он отсюда, см. relocstub.py
BODY = 0xA600           # а накладка -- вот отсюда, в дыре между буферами CO
HOOK = 0x091B           # отрисовка панели
HOOK_OLD = bytes([0xCD, 0xE8, 0x19])    # CALL 19E8 -- то, что там стоит

# Признак ">CO.PTK" (режим «ПС») CO рисует в нижней рамке двумя строками -- сам
# признак и девять горизонталей рамки, чтобы его стереть. Обе начинаются с
# «ESC Y строка колонка»; двигаем их на три знака левее, к самому уголку, --
# столько же добавляется нашей надписи справа.
PTK = (0x2932, 0x2940)  # байты колонки в этих строках
PTK_OLD = 0x20 + 5
PTK_NEW = 0x20 + 2


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--tdrva', required=True, help='таблица дискет НЖМД, 16-рично')
    p.add_argument('--disk', required=True, help='дисковый обработчик БСВВ, 16-рично')
    p.add_argument('--init', help='пусковая подпрограмма, которую звать следом')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    tail = len(d) - (FILE_AT - ORG)
    if tail < 0:
        sys.exit('хвоста нет -- запускать после hddsel.py')
    org = RUNTIME + tail

    asm = asm8080.Asm()
    asm.sym.update({'ORIGIN': BODY,
                    'TDRVA': int(a.tdrva, 16),
                    'DISK': int(a.disk, 16)})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'hdinfo.asm')
    _, body = asm.assemble(src)

    at = HOOK - ORG
    if bytes(d[at:at + 3]) != HOOK_OLD:
        sys.exit('по %04X не CALL 19E8, а %s -- это не тот CO'
                 % (HOOK, d[at:at + 3].hex()))
    d[at:at + 3] = bytes([0xC3, BODY & 0xFF, BODY >> 8])

    for at_ptk in PTK:
        if d[at_ptk - ORG] != PTK_OLD:
            sys.exit('по %04X не колонка признака >CO.PTK, а %02X'
                     % (at_ptk, d[at_ptk - ORG]))
        d[at_ptk - ORG] = PTK_NEW

    nxt = int(a.init, 16) if a.init else 0
    at_copy = org                       # копировщик встанет первым
    at_body = org + 22                  # ... а тело следом за ним
    loop = at_copy + 9
    copier = bytes([0x21, at_body & 0xFF, at_body >> 8,      # LXI H,тело
                    0x11, BODY & 0xFF, BODY >> 8,            # LXI D,A600
                    0x01, len(body) & 0xFF, len(body) >> 8,  # LXI B,длина
                    0x7E, 0x12, 0x23, 0x13,                  # MOV A,M/STAX D/INX H/INX D
                    0x0B, 0x78, 0xB1,                        # DCX B / MOV A,B / ORA C
                    0xC2, loop & 0xFF, loop >> 8])           # JNZ loop
    copier += bytes([0xC3, nxt & 0xFF, nxt >> 8]) if nxt else bytes([0xC9])
    assert len(copier) <= 22, len(copier)
    d += copier.ljust(22, b'\0') + body

    open(a.outfile, 'wb').write(bytes(d))
    print('номер и метка дискеты: тело %d байт по %04X, копировщик по %04X'
          % (len(body), BODY, at_copy))
    print('init=%04X' % at_copy)


if __name__ == '__main__':
    main()
