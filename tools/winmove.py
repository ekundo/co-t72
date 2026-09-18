#!/usr/bin/env python3
"""Перенос постоянных накладок в окно ОЗУ при старте CO.

    ./winmove.py CO.COM out.com --src 48C5 --len 107 --dst A448 [--init 0B8D5]

Зачем. Всё, что дописано после hdinfo.py, остаётся по адресу загрузки -- а там
CO держит буферы: каталог диска B: он кладёт копией в 4000..4FFF. Пусковым
накладкам (проба оборудования, проверка CO.ZGR) это безразлично, они своё дело
делают до первого чтения каталога. Постоянным -- нет: обмен через буфер вне
окна, поиск по дискам и кодировки просмотрщика затирались каталогом B: прямо
посреди работы, и CO уходил в никуда.

Свободного ОЗУ ниже A000 нет вовсе: 4000-5FFF заняты каталогами, 6000-9FFF --
буфером копирования, под стеком остаётся два десятка байт. Зато в окне
A000-DFFF, где у CO лежат его собственные буферы, есть незанятые куски --
A448-A5FF под телом надписи, и ещё два выше. Слежением за записью проверено:
туда не пишет ни просмотр файла с прокруткой, ни копирование, ни смена дисков.

Код в окне жить может: окно выключается только на время самой пересылки с
диском D:, а накладки в этот момент не исполняются -- они и вызывают обмен.

Подпрограмма-переносчик остаётся по адресу загрузки: она отрабатывает один раз
при старте, в пусковой цепочке, до того как CO прочитает хоть один каталог.
"""

import argparse
import sys
import layout

ORG = 0x100
LABEL = 0xA600          # тело надписи в рамке панели -- выше него не заходить


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--src', required=True, help='откуда переносить (адрес загрузки)')
    p.add_argument('--len', required=True, help='сколько байт')
    p.add_argument('--dst', required=True, help='куда переносить (окно ОЗУ)')
    p.add_argument('--init', help='адрес подпрограммы, которую позвать следом')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    src = int(a.src, 16)
    dst = int(a.dst, 16)
    n = int(a.len, 16) if a.len.lower().startswith('0x') else int(a.len)
    org = ORG + len(d)

    if n <= 0:
        sys.exit('нечего переносить')
    if src < ORG or src + n > ORG + len(d):
        sys.exit('исходник %04X..%04X вне образа' % (src, src + n - 1))
    if not 0xA000 <= dst or dst + n > LABEL:
        sys.exit('приёмник %04X..%04X не помещается в свободный кусок окна '
                 '(до %04X)' % (dst, dst + n - 1, LABEL))

    nxt = int(a.init, 16) if a.init else 0
    body = bytes([0x21, src & 0xFF, src >> 8,               # LXI H,src
                  0x11, dst & 0xFF, dst >> 8,               # LXI D,dst
                  0x01, n & 0xFF, n >> 8,                   # LXI B,len
                  0x7E,                                     # move: MOV A,M
                  0x12,                                     # STAX D
                  0x23, 0x13,                               # INX H / INX D
                  0x0B,                                     # DCX B
                  0x78, 0xB1,                               # MOV A,B / ORA C
                  0xC2, (org + 9) & 0xFF, (org + 9) >> 8])  # JNZ move
    body += bytes([0xC3, nxt & 0xFF, nxt >> 8]) if nxt else bytes([0xC9])

    d += body
    open(a.outfile, 'wb').write(bytes(d))
    layout.moved(dst, n, src, 'накладки в окно')
    print('перенос накладок в окно: %04X..%04X -> %04X, переносчик %d байт по %04X'
          % (src, src + n - 1, dst, len(body), org))
    layout.note('загрузка', org, len(body), 'переносчик накладок')
    print('init=%04X' % org)


if __name__ == '__main__':
    main()
