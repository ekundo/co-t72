#!/usr/bin/env python3
"""СС+7 в CO -- выбор дискеты НЖМД вместо печати файла.

Как это работает в CO. Второй набор цифровых клавиш -- это не отдельный режим,
а просто СС+цифра: `0574` вычитает у кода `10h`, так что СС+7 приходит как
`27h`. Дальше два уровня таблиц «клавиша -> адрес»: `05DA`, а по умолчанию
`05AA` -> таблица `0637`. Там и лежит запись `27 -> 06E5` -- «7-Печать».
Переставляем её на свой обработчик, два байта.

Обработчик:
  * берёт букву диска активной панели (`3E91` + `0E4D` -- выбор по номеру
    панели в `B69D`);
  * если это не A: и не B: -- молча возвращается, не спрашивая номер: назначать
    дискету НЖМД можно только на эти два диска (`P_Ex01`: `CPI 002 / JNC` ->
    «Неверное имя»);
  * иначе печатает приглашение и читает шестнадцатеричный номер (до четырёх
    цифр, ВК -- ввод, АР2 -- отмена);
  * заполняет ФУБ по `005C` (номер диска, номер дискеты текстом) и ставит
    ненулевую длину хвоста по `0080`;
  * выполняет команду МикроДОС «9» через вектор БСВВ `E218` -- индекс команды
    передаётся в A. Писать напрямую в таблицу `T_DrvA`/`T_DrvB` нельзя: её
    адрес у сборок разный, а мимо команды 9 потеряются сброс дискового буфера,
    обнуление прежнего назначения и пересчёт стартового сектора дискеты.

Панель после смены дискеты перечитывается хвостом штатного «7-Диск»: с `28AE`
он берёт букву диска из B, кладёт её в панель и перечитывает каталог. Звать
`2870` целиком нельзя -- он сначала спросит букву.

Проверить назначение до конца на v06x нельзя -- он не эмулирует НЖМД, и предел
числа дискет там выставлен в ноль. Поэтому годится только номер 0 (это
физический дисковод), на любом другом ОС ответит «Неверное имя» -- что само по
себе доказывает, что команда до неё дошла.
"""

import argparse
import sys

ORG = 0x100
TABLE = 0x0637         # таблица «клавиша -> адрес» второго уровня
KEY = 0x27             # СС+7
OLD = 0x06E5           # штатный обработчик печати

# точки входа самого CO
SEL_PANEL = 0x0E4D     # HL += 1, если активна вторая панель
GETKEY = 0x0D44        # ждать клавишу, код в A
REDRAW = 0x0FE0        # перерисовать панели
REREAD = 0x28AE        # хвост «7-Диск»: записать букву из B и перечитать панель
MAINLOOP = 0x030F      # вернуться в главный цикл
BIOS_CMD = 0xE218      # БСВВ: выполнение цифровых команд, номер в A
PANEL_DRV = 0x3E91     # буквы дисков панелей


class Asm:
    def __init__(self, org):
        self.org, self.code, self.labels, self.fixups = org, bytearray(), {}, []

    def label(self, name):
        self.labels[name] = self.org + len(self.code)

    def db(self, *b):
        self.code += bytes(b)

    def word(self, op, value):
        self.code += bytes([op, value & 0xFF, value >> 8])

    def ref(self, op, name):
        self.code += bytes([op])
        self.fixups.append((len(self.code), name))
        self.code += b'\0\0'

    def bytes(self):
        out = bytearray(self.code)
        for at, name in self.fixups:
            out[at] = self.labels[name] & 0xFF
            out[at + 1] = self.labels[name] >> 8
        return bytes(out)


def build(at):
    a = Asm(at)
    a.word(0x21, PANEL_DRV); a.word(0xCD, SEL_PANEL); a.db(0x7E)   # LXI H / CALL / MOV A,M
    a.db(0xFE, 0x41); a.ref(0xCA, 'ok')                            # CPI 'A' / JZ ok
    a.db(0xFE, 0x42); a.ref(0xC2, 'back')                          # CPI 'B' / JNZ back

    a.label('ok')
    # ФУБ по 005C и длина хвоста по 0080 -- рабочие ячейки самого CO, он в них
    # держит текущий файл. Затрёшь без спроса -- следующая же его операция
    # ответит «Неверное имя» (на это я и напоролся). Ячейки идут подряд,
    # 005C..0080 -- сохраняем все 37 и возвращаем после вызова.
    a.word(0x21, 0x005C); a.ref(0x11, 'save'); a.db(0x0E, 0x25)    # LXI H,005C / LXI D,save / MVI C,37
    a.db(0xF5)                                                     # PUSH PSW -- буква диска
    a.label('sav')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'sav')         # MOV A,M/STAX D/INX H/INX D/DCR C/JNZ
    a.db(0xF1)                                                     # POP PSW
    a.db(0xD6, 0x40)                                               # SUI 40h -> 1 или 2
    a.word(0x32, 0x005C)                                           # STA 005C -- диск в ФУБ
    a.word(0x21, 0x005D); a.db(0x06, 0x0B, 0x3E, 0x20)             # LXI H,005D / MVI B,11 / MVI A,' '
    a.label('clr')
    a.db(0x77, 0x23, 0x05); a.ref(0xC2, 'clr')                     # MOV M,A / INX H / DCR B / JNZ
    a.ref(0x21, 'msg'); a.db(0xDF)                                 # LXI H,msg / RST 3

    a.word(0x21, 0x005D); a.db(0x06, 0x00)                         # LXI H,005D / MVI B,0
    a.label('inp')
    a.db(0xC5, 0xE5); a.word(0xCD, GETKEY); a.db(0xE1, 0xC1)       # PUSH B/H / CALL GETKEY / POP H/B
    a.db(0xFE, 0x0D); a.ref(0xCA, 'done')                          # ВК
    a.db(0xFE, 0x1B); a.ref(0xCA, 'back')                          # АР2 -- отмена
    a.db(0x4F)                                                     # MOV C,A
    a.db(0xFE, 0x30); a.ref(0xDA, 'inp')                           # < '0'
    a.db(0xFE, 0x3A); a.ref(0xDA, 'take')                          # цифра
    a.db(0xFE, 0x41); a.ref(0xDA, 'inp')                           # между '9' и 'A'
    a.db(0xFE, 0x47); a.ref(0xD2, 'inp')                           # > 'F'
    a.label('take')
    a.db(0x78, 0xFE, 0x04); a.ref(0xCA, 'inp')                     # MOV A,B / CPI 4 / JZ inp
    a.db(0x71, 0x23, 0x04)                                         # MOV M,C / INX H / INR B
    a.db(0xC5, 0xE5, 0xE7, 0xE1, 0xC1); a.ref(0xC3, 'inp')         # эхо: RST 4 портит регистры

    a.label('done')
    a.db(0x78, 0xB7); a.ref(0xCA, 'back')                          # MOV A,B / ORA A / JZ back
    a.word(0x32, 0x0080)                                           # STA 0080 -- длина хвоста
    a.db(0x3E, 0x09); a.word(0xCD, BIOS_CMD)                       # MVI A,9 / CALL E218
    a.ref(0x21, 'save'); a.word(0x11, 0x005C); a.db(0x0E, 0x25)    # вернуть ФУБ на место
    a.label('rst')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'rst')
    # Дискета сменилась -- в панели остался каталог прежней. Перечитываем её
    # хвостом штатного «7-Диск»: с 28AE он берёт букву из B, кладёт её в панель
    # и перечитывает. Целиком 2870 звать нельзя -- он ещё и спросит букву.
    a.word(0x21, PANEL_DRV); a.word(0xCD, SEL_PANEL); a.db(0x46)   # LXI H / CALL / MOV B,M
    a.word(0xC3, REREAD)

    a.label('back')
    a.word(0xCD, REDRAW); a.word(0xC3, MAINLOOP)                   # CALL 0FE0 / JMP 030F

    a.label('msg')
    a.code += ' Дискета НЖМД: '.encode('koi8-r') + b'\0'
    a.label('save')
    a.code += bytes(37)          # 005C..0080 -- ФУБ целиком и длина хвоста, подряд
    return a.bytes()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    args = p.parse_args()

    d = bytearray(open(args.infile, 'rb').read())
    n = d[TABLE - ORG]
    slot = None
    for i in range(n):
        off = TABLE - ORG + 1 + i * 3
        if d[off] == KEY:
            slot = off + 1
    if slot is None:
        sys.exit('в таблице %04X нет записи для СС+7 -- незнакомый выпуск CO' % TABLE)
    if d[slot] | d[slot + 1] << 8 != OLD:
        sys.exit('СС+7 ведёт не на %04X -- обработчик уже переставлен?' % OLD)

    at = ORG + len(d)
    if at % 128:
        sys.exit('образ не выровнен по записи: %d байт' % len(d))
    code = build(at)
    d[slot] = at & 0xFF
    d[slot + 1] = at >> 8
    d += code
    d += bytes([0x1A] * (-len(d) % 128))
    open(args.outfile, 'wb').write(bytes(d))
    print('выбор дискеты НЖМД: %d байт по %04X, СС+7 переставлен с %04X'
          % (len(code), at, OLD))


if __name__ == '__main__':
    main()
