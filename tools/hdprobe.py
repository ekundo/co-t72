#!/usr/bin/env python3
"""СС+7 остаётся выбором дискеты НЖМД, только если винчестер в системе есть.

    ./hdprobe.py CO.COM out.com --tdrva EBEA --slot 0658 --old 06E5 \
                 --bar 3A1C:313d34302f... [--init 0B8D5]

hddsel.py переставляет СС+7 с печати файла на выбор дискеты НЖМД безусловно, а
винчестера в машине может и не быть. Спросить об этом БСВВ нечем: у дисковода и
квазидиска есть штатный «выбрать диск», у дискет НЖМД -- ничего.

Единственный источник -- таблица, которую ImproverX завёл в T-72 от 15.09.2026:
по FFCA лежит количество дискет НЖМД, ноль -- винчестера нет. Признака у
таблицы нет, поэтому проверяем её сами: по FFCC она держит адрес T_DrvA, а его
мы и так знаем -- сборка находит его на живой машине по первым секторам дискет
1 и 5. Сошлось -- таблице верим; не сошлось -- значит ПЗУ старое, таблицы нет, и
всё остаётся как было.

Если винчестера нет, возвращаем на место и обработчик (запись в таблице
«клавиша -> адрес»), и строку подсказки: иначе внизу осталось бы «7-Hdd» при
работающей печати.

Код работает там, куда его положила загрузка, и под стек не едет: он нужен один
раз при старте, а к первому чтению каталога в 4100 уже отработает -- тем же
рассуждением, что и тело надписи в hdinfo.py.
"""

import argparse
import sys

ORG = 0x100
FILE_AT = 0x4100        # с этого адреса в файле лежит переносимый хвост
D_HDDD = 0xFFCA         # количество дискет НЖМД, 0 -- НЖМД нет
D_DrvA = 0xFFCC         # адрес таблицы дискет: по нему и проверяем таблицу


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--tdrva', required=True, help='адрес таблицы дискет НЖМД')
    p.add_argument('--slot', required=True, help='адрес записи в таблице клавиш')
    p.add_argument('--old', required=True, help='штатный обработчик печати')
    p.add_argument('--bar', required=True, help='адрес:шестнадцатеричная строка подсказки')
    p.add_argument('--init', help='адрес подпрограммы, которую позвать следом')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    if len(d) < FILE_AT - ORG:
        sys.exit('хвоста нет -- запускать после fix16k.py')
    org = ORG + len(d)          # работаем там, куда положила загрузка

    tdrva = int(a.tdrva, 16)
    slot = int(a.slot, 16)
    old = int(a.old, 16)
    bar_at, _, bar_hex = a.bar.partition(':')
    bar_at = int(bar_at, 16)
    bar = bytes.fromhex(bar_hex)
    nxt = int(a.init, 16) if a.init else 0

    def w(op, v):
        return bytes([op, v & 0xFF, v >> 8])

    # Тело собираем в два прохода: длина подсказки известна, но адреса меток
    # зависят от неё же, поэтому считаем смещения заранее.
    head = bytearray()
    head += w(0x2A, D_DrvA)                     # LHLD FFCC -- адрес таблицы дискет
    head += w(0x11, tdrva)                      # LXI D,T_DrvA -- как его нашла сборка
    head += bytes([0x7D, 0xBB])                 # MOV A,L / CMP E
    jz1 = len(head); head += b'\0\0\0'          # JNZ done
    head += bytes([0x7C, 0xBA])                 # MOV A,H / CMP D
    jz2 = len(head); head += b'\0\0\0'          # JNZ done
    head += w(0x2A, D_HDDD)                     # LHLD FFCA -- сколько дискет НЖМД
    head += bytes([0x7C, 0xB5])                 # MOV A,H / ORA L
    jz3 = len(head); head += b'\0\0\0'          # JNZ done -- есть, ничего не трогаем
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
    head += (w(0xC3, nxt) if nxt else bytes([0xC9]))
    saved = len(head)                           # тут ляжет прежняя подсказка

    for at in (jz1, jz2, jz3):
        head[at:at + 3] = w(0xC2, org + done)
    head[src:src + 3] = w(0x21, org + saved)

    body = bytes(head) + bar
    d += body
    open(a.outfile, 'wb').write(bytes(d))
    print('проба НЖМД: %d байт по %04X, СС+7 вернётся на %04X, если FFCA=0'
          % (len(body), org, old))
    print('init=%04X' % org)


if __name__ == '__main__':
    main()
