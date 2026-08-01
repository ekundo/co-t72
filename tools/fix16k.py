#!/usr/bin/env python3
"""Показать в панелях CO файлы, кратные 16 КБ.

Каталог CP/M хранит файл экстентами по 16 КБ. В записи экстента байт 15 -- это
RC, число 128-байтных записей в нём; у полного экстента RC = 80h. Размер файла
CO считает по последнему экстенту (`1A9E`: RC округляется до блока, плюс номер
экстента EX * 16 КБ), а все промежуточные пропускает по признаку RC = 80h
(`1A99: CPI 80h / JZ 1A78`).

У файла, длина которого кратна 16 КБ, ПОЛНЫЕ ВСЕ экстенты -- и файл пропадает
из панели целиком. Поэтому CO никогда не показывает ни самого себя (16384), ни,
например, ASC.COM с системной дискеты; а DBG.COM (18944) виден.

Чинится так: проверка RC снимается, и вместо неё перед добавлением строки в
список идёт сверка с предыдущей строкой. Совпало имя с типом -- строка не
добавляется, а перезаписывается: в списке остаётся последний экстент, то есть
верный размер. Экстенты одного файла МикроДОС кладёт в каталог подряд, так что
сравнения с предыдущей строкой достаточно.

Кода на это 65 байт; свободного места в образе нет, поэтому он уезжает в хвост
за 4100h. Проверено трассировкой обращений к памяти: выше 40FFh CO ничего не
пишет, а образ дочитывается загрузчиком как обычные записи файла.
"""

import argparse
import sys

ORG = 0x100
CODE = 0x4100          # первый байт за образом
ENTRY = 13             # длина строки списка: имя 8 + пробел + тип 3 + размер 1
A871, A873 = 0xA871, 0xA873   # счётчик файлов и хвост списка


def build(at):
    """Собрать подпрограмму дедупликации. Вход: DE -- запись каталога.
    Выход: HL -- куда писать строку; DE сохранён."""
    c = bytearray()
    c += bytes([0x3A, A871 & 0xFF, A871 >> 8])           # LDA  A871
    c += bytes([0x47])                                   # MOV  B,A
    c += bytes([0x3A, (A871 + 1) & 0xFF, (A871 + 1) >> 8])  # LDA A872
    c += bytes([0xB0])                                   # ORA  B
    c += bytes([0x2A, A873 & 0xFF, A873 >> 8])           # LHLD A873
    c += bytes([0xC8])                                   # RZ  -- список пуст
    c += bytes([0xD5, 0xE5])                             # PUSH D / PUSH H
    c += bytes([0x01, 0xF3, 0xFF, 0x09])                 # LXI B,-13 / DAD B
    c += bytes([0x13])                                   # INX  D  -> имя
    ne = []                                              # места ссылок на NE

    def cmp_loop(n, skip_space):
        nonlocal c
        if skip_space:
            c += bytes([0x23])                           # INX H -- пробел
        c += bytes([0x0E, n])                            # MVI  C,n
        top = at + len(c)
        c += bytes([0x1A, 0xBE])                         # LDAX D / CMP M
        ne.append(at + len(c) + 1)
        c += bytes([0xC2, 0, 0])                         # JNZ  NE
        c += bytes([0x23, 0x13, 0x0D])                   # INX H / INX D / DCR C
        c += bytes([0xC2, top & 0xFF, top >> 8])         # JNZ  top

    cmp_loop(8, False)                                   # имя
    cmp_loop(3, True)                                    # тип
    # совпало: вернуть указатель на предыдущую строку и отыграть счётчик назад,
    # потому что вызывающий его всё равно увеличит
    c += bytes([0xE1, 0xD1])                             # POP H / POP D
    c += bytes([0x01, 0xF3, 0xFF, 0x09])                 # LXI B,-13 / DAD B
    c += bytes([0xE5])                                   # PUSH H
    c += bytes([0x2A, A871 & 0xFF, A871 >> 8])           # LHLD A871
    c += bytes([0x2B])                                   # DCX  H
    c += bytes([0x22, A871 & 0xFF, A871 >> 8])           # SHLD A871
    c += bytes([0xE1, 0xC9])                             # POP H / RET
    target = at + len(c)                                 # NE:
    c += bytes([0xE1, 0xD1, 0xC9])                       # POP H / POP D / RET
    for p in ne:                                         # проставить ссылки
        c[p - at] = target & 0xFF
        c[p - at + 1] = target >> 8
    return bytes(c)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    args = p.parse_args()

    d = bytearray(open(args.infile, 'rb').read())
    if len(d) != 0x4000:
        sys.exit('ожидался образ CO в 16384 байта, а не %d' % len(d))
    if bytes(d[0x1A99 - ORG:0x1A9E - ORG]) != bytes([0xFE, 0x80, 0xCA, 0x78, 0x1A]):
        sys.exit('по 1A99 нет проверки RC=80h -- незнакомый выпуск CO')
    if bytes(d[0x1AD1 - ORG:0x1AD4 - ORG]) != bytes([0x2A, 0x73, 0xA8]):
        sys.exit('по 1AD1 нет LHLD A873 -- незнакомый выпуск CO')

    d[0x1A99 - ORG:0x1A9E - ORG] = bytes([0x00] * 5)     # снять пропуск
    d[0x1AD1 - ORG:0x1AD4 - ORG] = bytes([0xCD, CODE & 0xFF, CODE >> 8])
    code = build(CODE)
    d += bytes([0x1A] * (CODE - ORG - len(d)))           # добить до 4100h
    d += code
    d += bytes([0x1A] * (-len(d) % 128))                 # до границы записи
    open(args.outfile, 'wb').write(bytes(d))
    print('дедупликация экстентов: %d байт по %04X, образ вырос до %d байт'
          % (len(code), CODE, len(d)))


if __name__ == '__main__':
    main()
