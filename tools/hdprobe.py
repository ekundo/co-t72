#!/usr/bin/env python3
"""Проба состава оборудования при старте: НЖМД и второй квазидиск.

    ./hdprobe.py CO.COM out.com --slot 0658 --old 06E5 \
                 --bar 3A1C:313d34302f... [--init 0B8D5]

hddsel.py переставляет СС+7 с печати файла на выбор дискеты НЖМД безусловно, а
винчестера в Векторе может и не быть. Спросить об этом БСВВ нечем: у дисковода и
квазидиска есть штатный «выбрать диск», у дискет НЖМД -- ничего.

Единственный источник -- таблица, которую ImproverX завёл в T-72 от 15.09.2026:
по FFCA лежит количество дискет НЖМД, ноль -- винчестера нет. Признака у таблицы
нет, поэтому смотрим на сами значения: дисков в системе бывает три или четыре,
верх памяти BCh или C0h, а адрес записи дискеты обязан указывать в область ОС.
У старой сборки, где таблицы нет, по этим адресам просто верхушка памяти, и все
три разом совпадут едва ли. Не сошлось -- значит таблицы нет, и всё остаётся как
было.

Если винчестера нет, возвращаем на место и обработчик (запись в таблице
«клавиша -> адрес»), и строку подсказки: иначе внизу осталось бы «7-Hdd» при
работающей печати.

Код работает там, куда его положила загрузка, и под стек не едет: он нужен один
раз при старте, а к первому чтению каталога в 4100 уже отработает -- тем же
рассуждением, что и тело надписи в hdinfo.py.
"""

import argparse
import sys
import layout

ORG = 0x100
FILE_AT = 0x4100        # с этого адреса в файле лежит переносимый хвост
D_DISKS = 0xFFC9        # сколько дисков в системе: три или четыре
D_HDDD = 0xFFCA         # количество дискет НЖМД, 0 -- НЖМД нет
D_DrvA = 0xFFCC         # адрес таблицы дискет: по нему и проверяем таблицу
D_FRAM = 0xFFD0         # верх памяти: BCh -- драйверы флоповодов есть, C0h -- нет


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--slot', required=True, help='адрес записи в таблице клавиш')
    p.add_argument('--old', required=True, help='штатный обработчик печати')
    p.add_argument('--bar', required=True, help='адрес:шестнадцатеричная строка подсказки')
    p.add_argument('--dflag', help='адрес признака «второй квазидиск есть» (dsel.py)')
    p.add_argument('--aflag', help='адрес признака «дисководы или НЖМД есть» (dsel.py)')
    p.add_argument('--pdtab', help='адрес таблицы «слот CO.PRM -> буква» (dsel.py)')
    p.add_argument('--hddinit', help='адрес пусковой подпрограммы hddsel.py')
    p.add_argument('--init', help='адрес подпрограммы, которую позвать следом')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    if len(d) < FILE_AT - ORG:
        sys.exit('хвоста нет -- накладки листинга должны идти первыми')
    org = ORG + len(d)          # работаем там, куда положила загрузка

    slot = int(a.slot, 16)
    old = int(a.old, 16)
    bar_at, _, bar_hex = a.bar.partition(':')
    bar_at = int(bar_at, 16)
    bar = bytes.fromhex(bar_hex)
    nxt = int(a.init, 16) if a.init else 0
    dflag = int(a.dflag, 16) if a.dflag else 0
    hddinit = int(a.hddinit, 16) if a.hddinit else 0
    aflag = int(a.aflag, 16) if a.aflag else 0
    pdtab = int(a.pdtab, 16) if a.pdtab else 0

    def w(op, v):
        return bytes([op, v & 0xFF, v >> 8])

    # Тело собираем в два прохода: длина подсказки известна, но адреса меток
    # зависят от неё же, поэтому считаем смещения заранее.
    # Таблица состава оборудования на месте? Признака у неё нет, поэтому смотрим
    # на сами значения: дисков бывает три или четыре, верх памяти BCh или C0h, а
    # адрес записи дискеты обязан указывать в область ОС. У старой сборки, где
    # таблицы нет, по этим адресам просто верхушка памяти, и все три разом
    # совпадут едва ли. Не сошлось -- ничего не трогаем, всё остаётся как было.
    head = bytearray()
    head += w(0x3A, D_DISKS)                    # LDA FFC9
    head += bytes([0xFE, 0x03])
    jz1 = len(head); head += b'\0\0\0'          # JC done -- дисков меньше трёх
    head += bytes([0xFE, 0x05, 0x3F])           # CPI 5 / CMC
    jz1b = len(head); head += b'\0\0\0'         # JC done -- больше четырёх
    head += w(0x3A, D_FRAM)                     # LDA FFD0
    head += bytes([0xFE, 0xBC])
    jok = len(head); head += b'\0\0\0'          # JZ дальше
    head += bytes([0xFE, 0xC0])
    jz2 = len(head); head += b'\0\0\0'          # JNZ done
    hok = len(head)
    head += w(0x3A, D_DrvA + 1)                 # LDA FFCD -- старший байт адреса
    head += bytes([0xFE, 0xE0])
    jz2b = len(head); head += b'\0\0\0'         # JC done -- не в области ОС
    # A: и B: -- дисководы либо дискеты НЖМД. Драйверы флоповодов система
    # отмечает верхней границей памяти: BCh -- есть (килобайт под буфер
    # дисковода), C0h -- нет. Нет ни их, ни дискет НЖМД -- и оба диска надо
    # прятать: панель на них открывается с ошибкой диска.
    jz5 = jz6 = None
    if aflag:
        head += w(0x3A, D_FRAM)                 # LDA FFD0
        head += bytes([0xFE, 0xBC])             # драйверы флоповодов есть?
        jz5 = len(head); head += b'\0\0\0'      # JZ have
        head += w(0x2A, D_HDDD)                 # LHLD FFCA
        head += bytes([0x7C, 0xB5])             # MOV A,H / ORA L
        jz6 = len(head); head += b'\0\0\0'      # JNZ have
        head += bytes([0x3E, 0x4E])             # MVI A,'N'
        head += w(0x32, aflag)
        have = len(head)

    head += w(0x2A, D_HDDD)                     # LHLD FFCA -- сколько дискет НЖМД
    head += bytes([0x7C, 0xB5])                 # MOV A,H / ORA L
    jz3 = len(head); head += b'\0\0\0'          # JNZ done -- есть, ничего не трогаем
    # Заодно выключаем пусковое восстановление выбранной дискеты: оно открывает
    # C:CO.HDD и, если файл есть, раздаёт номера дискет командой ОС "9". Без
    # НЖМД раздавать нечего, а обращение к диску при пустом дисководе кончается
    # ошибкой диска ещё до панелей -- на сборке k, где дисковода нет вовсе, она
    # вылезает всегда. Пусковая подпрограмма hddsel.py начинается с перехода,
    # ставим на её место RET.
    if hddinit:
        head += bytes([0x3E, 0xC9])             # MVI A,0C9h -- RET
        head += w(0x32, hddinit)
    head += w(0x21, old)                        # LXI H,06E5 -- штатная печать
    head += w(0x22, slot)                       # SHLD запись в таблице клавиш
    src = len(head)                             # сюда встанет LXI H,строка
    head += b'\0\0\0'
    head += w(0x11, bar_at)                     # LXI D,подсказка в образе
    head += bytes([0x0E, len(bar)])             # MVI C,длина
    loop = len(head)
    head += bytes([0x7E, 0x12, 0x23, 0x13, 0x0D])       # MOV A,M/STAX D/INX H/INX D/DCR C
    head += bytes([0xC2, 0, 0])                 # JNZ loop
    head[-2:] = bytes([(org + loop) & 0xFF, (org + loop) >> 8])
    done = len(head)

    # Второй квазидиск: спрашиваем у самой ОС. БСВВ «выбрать диск» (C01B) с
    # номером 3 возвращает ноль, если диска нет; число дисков система
    # подставляет себе при старте, поэтому ответ верен на любой сборке T-72, а
    # не только на новой с таблицей по FFC9.
    #
    # Делать это надо именно при старте. Вызов «выбрать диск» кладёт номер в
    # описатель дисковой операции БСВВ, то есть меняет выбранный диск за спиной
    # БДОС; из работающей программы это уводит следующее чтение каталога не на
    # тот диск. Выбор всё равно возвращаем -- по младшей тетраде ячейки 0004.
    if dflag:
        head += bytes([0x0E, 0x03]) + w(0xCD, 0xC01B)   # MVI C,3 / CALL SELDSK
        head += bytes([0x7C, 0xB5])                     # MOV A,H / ORA L
        head += bytes([0x3E, 0x4E])                     # MVI A,'N'
        jz4 = len(head); head += b'\0\0\0'             # JZ set
        head += bytes([0x3E, 0x59])                     # MVI A,'Y'
        setp = len(head)
        head += w(0x32, dflag)
        head += w(0x3A, 0x0004) + bytes([0xE6, 0x0F, 0x4F])
        head += w(0xCD, 0xC01B)                         # вернуть выбор
        head[jz4:jz4 + 3] = w(0xCA, org + setp)

    # Таблица «слот CO.PRM -> буква». CO.PRM переносят с Вектора на Вектор, и
    # записанный в нём диск на этой может отсутствовать вовсе -- панель тогда
    # открывается с ошибкой диска. Недоступный заменяем первым доступным, а это
    # всегда C:: квазидиск есть в любом Векторе, с него система и грузится.
    if pdtab:
        head += bytes([0x3E, 0x43])             # MVI A,'C'
        head += w(0x32, pdtab + 0)              # слот 0 -- D:, пока C:
        head += w(0x32, pdtab + 1)              # слот 1 -- A:
        head += w(0x32, pdtab + 2)              # слот 2 -- B:
        if aflag:
            head += w(0x3A, aflag)
            head += bytes([0xFE, 0x59])         # дисководы или НЖМД есть?
            jz7 = len(head); head += b'\0\0\0'  # JNZ noab
            head += bytes([0x3E, 0x41]) + w(0x32, pdtab + 1)   # A:
            head += bytes([0x3E, 0x42]) + w(0x32, pdtab + 2)   # B:
            noab = len(head)
            head[jz7:jz7 + 3] = w(0xC2, org + noab)
        if dflag:
            head += w(0x3A, dflag)
            head += bytes([0xFE, 0x59])         # второй квазидиск есть?
            jz8 = len(head); head += b'\0\0\0'  # JNZ nod
            head += bytes([0x3E, 0x44]) + w(0x32, pdtab + 0)   # D:
            nod = len(head)
            head[jz8:jz8 + 3] = w(0xC2, org + nod)

    head += (w(0xC3, nxt) if nxt else bytes([0xC9]))
    saved = len(head)                           # тут ляжет прежняя подсказка

    head[jz1:jz1 + 3] = w(0xDA, org + done)
    head[jz1b:jz1b + 3] = w(0xDA, org + done)
    head[jok:jok + 3] = w(0xCA, org + hok)
    head[jz2:jz2 + 3] = w(0xC2, org + done)
    head[jz2b:jz2b + 3] = w(0xDA, org + done)
    head[jz3:jz3 + 3] = w(0xC2, org + done)
    if aflag:
        head[jz5:jz5 + 3] = w(0xCA, org + have)
        head[jz6:jz6 + 3] = w(0xC2, org + have)
    head[src:src + 3] = w(0x21, org + saved)

    body = bytes(head) + bar
    d += body
    open(a.outfile, 'wb').write(bytes(d))
    print('проба оборудования: %d байт по %04X, СС+7 вернётся на %04X при FFCA=0%s'
          % (len(body), org, old,
             ''.join((', признак D: по %04X' % dflag if dflag else '',
                      ', признак A:/B: по %04X' % aflag if aflag else '',
                      ', таблица дисков по %04X' % pdtab if pdtab else ''))))
    layout.note('загрузка', org, len(body), 'проба оборудования')
    print('init=%04X' % org)


if __name__ == '__main__':
    main()
