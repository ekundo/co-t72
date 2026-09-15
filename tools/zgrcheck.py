#!/usr/bin/env python3
"""Проверка наличия файла перед копированием по списку CO.ZGR.

    ./zgrcheck.py CO.COM out.com

Сам код -- в zgrcheck.asm, здесь только сборка и врезка.

Накладка живёт в хвосте образа и переезжает под стек вместе с остальным
дописанным кодом (relocstub.py). Места там немного -- 1216 байт от B740 до
буфера дисковода ОС, -- но после того как накладка с номером дискеты перестала
кататься под стек, свободного хватает.

Врезка одна: по 3F01 CO читает первый знак разобранной строки CO.ZGR, чтобы
решить, брать следующую или заканчивать. Меняем это чтение на вызов к себе, а
само чтение выполняем в конце -- см. шапку zgrcheck.asm.

Ключ --inplace оставляет код там, куда его положила загрузка, и хвост под стеком
не занимает. Так собирается вариант с диском D:: вдвоём они за BC00 не влезают.
Список CO.ZGR разбирается один раз при старте, до того как CO прочитает каталог
в 4100, -- тем же рассуждением, что и тело надписи в hdinfo.py.
"""

import argparse
import os
import sys

import asm8080

ORG = 0x100
FILE_AT = 0x4100        # с этого адреса в файле лежит переносимый хвост
RUNTIME = 0xB740        # ... а работает он отсюда, см. relocstub.py
CEILING = 0xBC00        # буфер дисковода ОС -- выше хвосту нельзя
HOOK = 0x3F01           # LDA B6A8 в цикле разбора CO.ZGR
HOOK_OLD = bytes([0x3A, 0xA8, 0xB6])


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--inplace', action='store_true',
                   help='работать по адресу загрузки, не занимая хвост под стеком')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    tail = len(d) - (FILE_AT - ORG)
    if tail < 0:
        sys.exit('хвоста нет -- запускать после fix16k.py')
    org = ORG + len(d) if a.inplace else RUNTIME + tail

    asm = asm8080.Asm()
    asm.sym.update({'ORIGIN': org})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'zgrcheck.asm')
    _, body = asm.assemble(src)
    if not a.inplace and org + len(body) > CEILING:
        sys.exit('хвост не помещается под стек: %04X..%04X при потолке %04X'
                 % (org, org + len(body) - 1, CEILING))

    at = HOOK - ORG
    if bytes(d[at:at + 3]) != HOOK_OLD:
        sys.exit('по %04X не LDA B6A8, а %s' % (HOOK, d[at:at + 3].hex()))
    d[at:at + 3] = bytes([0xCD, org & 0xFF, org >> 8])
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    print('проверка наличия файла: %d байт по %04X%s, врезка по %04X'
          % (len(body), org, ' (по адресу загрузки)' if a.inplace else '', HOOK))


if __name__ == '__main__':
    main()
