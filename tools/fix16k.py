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

Чинится так: проверка RC снимается, и вместо неё перед добавлением строки CO
ищет в списке строку с тем же именем и типом. Нашлась -- строка выбрасывается
из списка, а новая дописывается в конец: в списке остаётся последний экстент,
то есть верный размер.

Искать надо по ВСЕМУ списку, а не только в предыдущей строке: экстенты одного
файла лежат в каталоге подряд не всегда -- при копировании поверх удалённого
файла первый экстент занимает освободившийся слот, а второй уходит в конец
каталога. Две одинаковые строки в списке смертельны: сортировка CO при
равенстве всех 12 байт (`1BA0` -> `1BA3`) отступает на 14 байт назад и
продолжает сравнение, залезая в соседние строки, и переставляет куски чужих.

Кода на это 87 байт; свободного места в образе нет, поэтому он уезжает в хвост
за 4100h. Проверено трассировкой обращений к памяти: выше 40FFh CO ничего не
пишет, а хвост дочитывается загрузчиком как обычные записи файла.
"""

import argparse
import sys

ORG = 0x100
RUNTIME = 0xB900       # где код работает: под стеком CO (BC00), выше буферов
FILE_AT = 0x4100       # где он лежит в файле -- в хвосте за образом
ROW = 13               # строка списка: имя 8 + пробел + тип 3 + размер 1
A842, A871, A873 = 0xA842, 0xA871, 0xA873   # начало списка, счётчик, хвост


class Asm:
    """Мини-ассемблер 8080 с метками -- иначе в ссылках легко ошибиться."""

    def __init__(self, org):
        self.org = org
        self.code = bytearray()
        self.labels = {}
        self.fixups = []

    def label(self, name):
        self.labels[name] = self.org + len(self.code)

    def db(self, *b):
        self.code += bytes(b)

    def ref(self, opcode, name):
        self.code += bytes([opcode])
        self.fixups.append((len(self.code), name))
        self.code += b'\0\0'

    def word(self, opcode, value):
        self.code += bytes([opcode, value & 0xFF, value >> 8])

    def bytes(self):
        out = bytearray(self.code)
        for at, name in self.fixups:
            a = self.labels[name]
            out[at] = a & 0xFF
            out[at + 1] = a >> 8
        return bytes(out)


def build(at):
    a = Asm(at)
    # Вход: DE -- запись каталога. Выход: HL -- куда писать строку, DE сохранён.
    a.db(0xEB); a.ref(0x22, 'ent'); a.db(0xEB)      # XCHG / SHLD ENT / XCHG
    a.word(0x2A, A873); a.ref(0x22, 'tail')         # LHLD A873 / SHLD TAIL
    a.word(0x2A, A842)                              # LHLD A842 -- начало списка

    a.label('loop')
    a.ref(0x3A, 'tail'); a.db(0xBD)                 # LDA TAIL / CMP L
    a.ref(0xC2, 'go')
    a.ref(0x3A, 'tail1'); a.db(0xBC)                # LDA TAIL+1 / CMP H
    a.ref(0xCA, 'notfound')

    a.label('go')
    a.db(0xE5)                                      # PUSH H -- начало строки
    a.ref(0x2A, 'ent'); a.db(0xEB)                  # LHLD ENT / XCHG -> DE
    a.db(0xE1, 0xE5)                                # POP H / PUSH H
    a.db(0x13)                                      # INX D -- имя записи
    for n, skip_space in ((8, False), (3, True)):
        if skip_space:
            a.db(0x23)                              # INX H -- пробел в строке
        a.db(0x06, n)                               # MVI B,n
        a.label('cmp%d' % n)
        a.db(0x1A, 0xBE)                            # LDAX D / CMP M
        a.ref(0xC2, 'next')
        a.db(0x23, 0x13, 0x05)                      # INX H / INX D / DCR B
        a.ref(0xC2, 'cmp%d' % n)

    # совпало: выбросить найденную строку из списка -- сдвинуть остаток на ROW
    a.db(0xE1)                                      # POP H -- начало строки
    a.db(0x44, 0x4D)                                # MOV B,H / MOV C,L
    a.word(0x21, ROW); a.db(0x09, 0xEB)             # LXI H,ROW / DAD B / XCHG
    a.db(0x60, 0x69)                                # MOV H,B / MOV L,C
    a.label('move')
    a.ref(0x3A, 'tail'); a.db(0xBB)                 # LDA TAIL / CMP E
    a.ref(0xC2, 'mv')
    a.ref(0x3A, 'tail1'); a.db(0xBA)                # LDA TAIL+1 / CMP D
    a.ref(0xCA, 'shrink')
    a.label('mv')
    a.db(0x1A, 0x77, 0x23, 0x13)                    # LDAX D / MOV M,A / INX H / INX D
    a.ref(0xC3, 'move')

    a.label('shrink')                               # список стал короче на строку
    a.word(0x2A, A871); a.db(0x2B); a.word(0x22, A871)   # LHLD A871 / DCX H / SHLD A871
    a.ref(0x2A, 'tail'); a.word(0x01, -ROW & 0xFFFF); a.db(0x09)  # LHLD TAIL / LXI B,-ROW / DAD B
    a.ref(0xC3, 'ret')

    a.label('next')                                 # не совпало -- следующая строка
    a.db(0xE1); a.word(0x01, ROW); a.db(0x09)       # POP H / LXI B,ROW / DAD B
    a.ref(0xC3, 'loop')

    a.label('notfound')                             # HL уже равен хвосту
    a.label('ret')
    a.db(0xE5); a.ref(0x2A, 'ent'); a.db(0xEB, 0xE1, 0xC9)  # вернуть DE и выйти

    a.label('ent'); a.db(0, 0)
    a.label('tail'); a.db(0)
    a.label('tail1'); a.db(0)
    return a.bytes()


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
    d[0x1AD1 - ORG:0x1AD4 - ORG] = bytes([0xCD, 0, 0])   # адрес проставим ниже
    d += bytes([0x1A] * (FILE_AT - ORG - len(d)))        # добить до 4100h
    at = RUNTIME + (len(d) - 0x4000)
    code = build(at)
    d[0x1AD1 - ORG + 1] = at & 0xFF
    d[0x1AD1 - ORG + 2] = at >> 8
    d += code
    d += bytes([0x1A] * (-len(d) % 128))                 # до границы записи
    open(args.outfile, 'wb').write(bytes(d))
    print('склейка экстентов: %d байт, работает по %04X, образ вырос до %d байт'
          % (len(code), at, len(d)))


if __name__ == '__main__':
    main()
