#!/usr/bin/env python3
"""Закрыть квазидисковую пробу CO от прерывания.

По `1CE7` CO щупает квазидиск: ставит стек на FFF0, переключает порт 10h в 3Fh,
читает слово и возвращает порт в 23h. Значение потом используется только как
задержка. Беда в том, что делается это с РАЗРЕШЁННЫМИ прерываниями, а 3Fh
подменяет банком не только экранные страницы, но и верх памяти E000-FFFF -- то
есть код БСВВ и обработчик прерывания. Прилетело прерывание в это окно --
процессор уходит исполнять то, что оказалось в банке: шрифт, каталог, что
угодно. Кончается это `HLT` где-нибудь в F000-х и мусором на экране, потому что
банк так и остался подставленным под экран.

Ловится это при обращении к диску B: под T-72 (там проба выполняется чаще), но
природа у отказа гоночная -- окно всего в несколько десятков тактов.

Правка ложится ровно на место, байт в байт:

    было                        стало
    31 F0 FF  LXI SP,FFF0h      31 F0 FF  LXI SP,FFF0h
    3E 40     MVI A,40h         F3        DI
    3D        DCR A             3E 3F     MVI A,3Fh
    D3 10     OUT 10h           D3 10     OUT 10h
    D1        POP D             D1        POP D
    3E 22     MVI A,22h         3E 23     MVI A,23h
    3C        INR A             D3 10     OUT 10h
    D3 10     OUT 10h           FB        EI
    F9        SPHL              F9        SPHL

EI стоит до SPHL: прерывание между ними безопасно -- банк уже отключён, и стек
на FFF0 лежит в обычном ОЗУ.
"""

import argparse
import sys

ORG = 0x100
AT = 0x1CEA

OLD = bytes([0x3E, 0x40, 0x3D, 0xD3, 0x10, 0xD1, 0x3E, 0x22, 0x3C, 0xD3, 0x10])
NEW = bytes([0xF3, 0x3E, 0x3F, 0xD3, 0x10, 0xD1, 0x3E, 0x23, 0xD3, 0x10, 0xFB])


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    args = p.parse_args()

    d = bytearray(open(args.infile, 'rb').read())
    if bytes(d[AT - ORG:AT - ORG + len(OLD)]) != OLD:
        sys.exit('по %04X не та проба квазидиска -- незнакомый выпуск CO' % AT)
    d[AT - ORG:AT - ORG + len(NEW)] = NEW
    open(args.outfile, 'wb').write(bytes(d))
    print('проба квазидиска по %04X закрыта DI/EI' % AT)


if __name__ == '__main__':
    main()
