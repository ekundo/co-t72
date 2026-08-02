#!/usr/bin/env python3
"""СС+7 в CO -- выбор дискеты НЖМД вместо печати файла.

Номер запоминается в файле CO.HDD рядом с CO.PRM. Именно в своём файле, а не в
хвосте CO.PRM: CO пишет CO.PRM целиком своей копией и затирает там что угодно
чужое.

Защита файла от записи работает как фиксация: если у CO.HDD стоит признак
«только чтение», номера из него применяются при старте, а новые не пишутся --
выбранное в этом сеансе живёт до перезагрузки.

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
DISPATCH = 0x05AA      # разбор клавиши, когда её нет в первой таблице
KEYCODE = 0xB693       # код нажатой клавиши
PANEL_CNT = 0xB689     # счётчик файлов панели -- по нему CO и отсекает клавиши
TABLE2 = 0x0637        # вторая таблица «клавиша -> адрес»
NOFILES = 0x0F86       # куда CO уходит при пустой панели
MAINCALL = 0x0583      # что делает CO в главном цикле (030F: CALL 0583)
OLD = 0x06E5           # штатный обработчик печати

# точки входа самого CO
SEL_PANEL = 0x0E4D     # HL += 1, если активна вторая панель
GETKEY = 0x0D44        # ждать клавишу, код в A
REDRAW = 0x0FE0        # перерисовать панели
REREAD = 0x28AE        # хвост «7-Диск»: записать букву из B и перечитать панель
MAINLOOP = 0x030F      # вернуться в главный цикл
BIOS_CMD = 0xE218      # БСВВ: выполнение цифровых команд, номер в A
PANEL_DRV = 0x3E91     # буквы дисков панелей
BDOS = 0x0005          # вызов БДОС напрямую: RST 1 к моменту старта ещё не готов
FCB = 0x005C           # рабочий ФУБ, он же вход команды 9
# Свой файл, а не CO.PRM: CO пишет CO.PRM целиком своей копией и затирает
# в нём что угодно чужое. Файл маленький, одна запись.
PRM_REC = 0            # единственная запись CO.HDD
PRM_OFF = 0            # подпись с самого начала, дальше два слота
SLOT = 5               # на диск: длина номера + четыре знака


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


build_init_addr = [0]
build_keyhook_addr = [0]


def build(at):
    """Собрать обработчик. Раскладка данных:
       pending -- набранный номер: длина + четыре знака;
       buf     -- запись CO.PRM целиком, в ней по PRM_OFF подпись 'HD' и два слота."""
    a = Asm(at)
    SIGN = 'sign'

    # ---------------- СС+7: диалог ----------------
    a.word(0x21, PANEL_DRV); a.word(0xCD, SEL_PANEL); a.db(0x7E)
    a.db(0xFE, 0x41); a.ref(0xCA, 'ok')                            # A: ?
    a.db(0xFE, 0x42); a.ref(0xC2, 'back')                          # B: ?  иначе молча
    a.label('ok')
    a.db(0xD6, 0x40); a.ref(0x32, 'drive')                         # номер диска 1/2
    a.ref(0xCD, 'clrpend')                                         # очистить набор
    a.ref(0x21, 'msg'); a.db(0xDF)                                 # приглашение
    a.ref(0x21, 'pending'); a.db(0x23)                             # HL -> знаки
    a.db(0x06, 0x00)                                               # B -- сколько набрано
    a.label('inp')
    a.db(0xC5, 0xE5); a.word(0xCD, GETKEY); a.db(0xE1, 0xC1)
    a.db(0xFE, 0x0D); a.ref(0xCA, 'done')                          # ВК
    a.db(0xFE, 0x1B); a.ref(0xCA, 'back')                          # АР2
    a.db(0x4F)
    a.db(0xFE, 0x30); a.ref(0xDA, 'inp')
    a.db(0xFE, 0x3A); a.ref(0xDA, 'take')
    a.db(0xFE, 0x41); a.ref(0xDA, 'inp')
    a.db(0xFE, 0x47); a.ref(0xD2, 'inp')
    a.label('take')
    a.db(0x78, 0xFE, 0x04); a.ref(0xCA, 'inp')                     # больше четырёх не берём
    a.db(0x71, 0x23, 0x04)
    a.db(0xC5, 0xE5, 0xE7, 0xE1, 0xC1); a.ref(0xC3, 'inp')         # эхо
    a.label('done')
    a.db(0x78, 0xB7); a.ref(0xCA, 'back')                          # ничего не набрано
    a.db(0x78); a.ref(0x32, 'pending')                             # длина в набор
    a.ref(0xCD, 'docmd')                                           # выполнить команду 9
    a.ref(0xCD, 'prmsave')                                         # запомнить в CO.PRM
    a.word(0x21, PANEL_DRV); a.word(0xCD, SEL_PANEL); a.db(0x46)
    a.word(0xC3, REREAD)                                           # перечитать панель
    a.label('back')
    a.word(0xCD, REDRAW); a.word(0xC3, MAINLOOP)

    # ---------------- пропустить СС+7 при пустой панели ----------------
    # CO отсекает клавиши второй таблицы, если в панели нет файлов
    # (05B1: CPI 0 / JZ 0F86), а выбор дискеты от файлов не зависит.
    a.label('keyhook'); build_keyhook_addr[0] = a.labels['keyhook']
    a.word(0x3A, KEYCODE); a.db(0xFE, KEY); a.ref(0xCA, 'totable')
    a.word(0x21, PANEL_CNT); a.word(0xCD, 0x0E47); a.db(0x7E, 0xB7)
    a.word(0xCA, NOFILES)                                          # пусто -- как было
    a.label('totable')
    a.word(0x3A, KEYCODE); a.word(0x21, TABLE2); a.word(0xC3, 0x0562)

    # ---------------- при старте: применить сохранённое ----------------
    # Главный цикл CO: 030F -- CALL 0583 / JMP 030F. Влезаем в этот CALL, чтобы
    # восстановление шло не из стаба (там ОС ещё не определилась с текущим
    # диском, и обращение уходило на несуществующий A:), а когда CO уже поднят.
    a.label('init'); build_init_addr[0] = a.labels['init']
    a.ref(0x3A, 'once'); a.db(0xB7); a.ref(0xC2, 'go')
    a.db(0x3C); a.ref(0x32, 'once')                                # больше не повторять
    a.db(0xC5, 0xD5, 0xE5)                                         # сохранить регистры CO
    a.ref(0xCD, 'restoreall')
    a.db(0xE1, 0xD1, 0xC1)
    a.ref(0x3A, 'applied'); a.db(0xB7); a.ref(0xC2, 'reread')
    a.label('go')
    a.word(0xC3, MAINCALL)                                         # и дальше как было

    a.label('reread')
    # Панели к этому моменту нарисованы прежней дискетой. Перечитываем активную
    # хвостом штатного «7-Диск»: он берёт букву из B и в конце уходит на 0FE0,
    # откуда возврат придёт туда же, куда пришёл бы от 0583 -- главный цикл
    # подмены не заметит.
    a.db(0xAF); a.ref(0x32, 'applied')                             # только один раз
    a.word(0x21, PANEL_DRV); a.word(0xCD, SEL_PANEL); a.db(0x46)
    a.word(0xC3, REREAD)

    a.label('restoreall')
    # запомнить диск, с которого запущен CO: там же лежит и CO.HDD
    a.word(0x3A, 0x0004); a.db(0x3C); a.ref(0x32, 'homedrv')
    a.ref(0xCD, 'prmload'); a.db(0xB7, 0xC8)   # ничего не сохранено -- выходим                             # нет файла/подписи
    a.db(0x3E, 0x01); a.ref(0xCD, 'restore')                       # диск A:
    a.db(0x3E, 0x02)                                               # диск B:
    a.label('restore')
    a.ref(0x32, 'drive')
    a.ref(0xCD, 'slotptr')
    a.db(0x7E, 0xB7, 0xC8)                                         # длина 0 -- нечего
    a.ref(0x11, 'pending'); a.db(0x0E, 0x05)                       # слот -> набор
    a.label('cps')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'cps')
    a.db(0x3E, 0xFF); a.ref(0x32, 'applied')                       # было что применять
    a.ref(0xC3, 'docmd')

    # ---------------- команда 9 по набранному номеру ----------------
    a.label('docmd')
    a.word(0x21, FCB); a.ref(0x11, 'save'); a.db(0x0E, 0x25)       # сохранить ФУБ CO
    a.label('sav')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'sav')
    a.ref(0x3A, 'drive'); a.word(0x32, FCB)                        # диск в ФУБ
    a.word(0x21, FCB + 1); a.db(0x06, 0x0B, 0x3E, 0x20)            # имя/тип пробелами
    a.label('clr2')
    a.db(0x77, 0x23, 0x05); a.ref(0xC2, 'clr2')
    a.ref(0x3A, 'pending'); a.db(0x4F)                             # C = длина
    a.ref(0x21, 'pending'); a.db(0x23); a.word(0x11, FCB + 1)
    a.label('cp')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'cp')          # знаки в ФУБ
    a.ref(0x3A, 'pending'); a.word(0x32, 0x0080)                   # длина хвоста
    a.db(0x06, 0x00)                                               # B=0 -- разбор делает DAD B
    a.db(0x3E, 0x09); a.word(0xCD, BIOS_CMD)                       # команда 9
    a.ref(0x21, 'save'); a.word(0x11, FCB); a.db(0x0E, 0x25)       # вернуть ФУБ CO
    a.label('rst')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'rst')
    a.db(0xC9)

    # ---------------- мелочи ----------------
    a.label('clrpend')                                             # длина 0, четыре пробела
    a.ref(0x21, 'pending'); a.db(0x36, 0x00, 0x23, 0x06, 0x04, 0x3E, 0x20)
    a.label('clr3')
    a.db(0x77, 0x23, 0x05); a.ref(0xC2, 'clr3')
    a.db(0xC9)

    a.label('slotptr')                                             # HL -> слот текущего диска
    a.ref(0x21, SIGN); a.db(0x23, 0x23)                            # за подписью -- слот A:
    a.ref(0x3A, 'drive'); a.db(0x3D, 0xC8)                         # диск A: -- готово
    a.word(0x11, SLOT); a.db(0x19, 0xC9)                           # иначе слот B:

    # ---------------- работа с CO.PRM ----------------
    a.label('prmopenw')                                            # открыть или создать
    a.ref(0xCD, 'openonly'); a.db(0xB7); a.ref(0xC2, 'prmread')
    a.db(0x0E, 0x16); a.ref(0x11, 'fcb'); a.word(0xCD, BDOS)       # создать
    a.db(0x3C, 0xC8)                                               # не вышло -- A=0
    a.ref(0xC3, 'prmread')

    a.label('prmopen')                                             # только открыть
    a.ref(0xCD, 'openonly'); a.db(0xB7, 0xC8)

    a.label('prmread')                                             # обмен и чтение записи
    a.ref(0x21, 'buf'); a.db(0x06, 0x80, 0xAF)                     # обнулить буфер
    a.label('zap')
    a.db(0x77, 0x23, 0x05); a.ref(0xC2, 'zap')
    a.db(0x0E, 0x1A); a.ref(0x11, 'buf'); a.word(0xCD, BDOS)       # адрес обмена
    a.db(0x3E, PRM_REC); a.ref(0x32, 'fcbr')
    a.db(0xAF); a.ref(0x32, 'fcbr1'); a.ref(0x32, 'fcbr2')
    a.db(0x0E, 0x21); a.ref(0x11, 'fcb'); a.word(0xCD, BDOS)       # чтение по номеру
    a.db(0x3E, 0xFF, 0xC9)     # ошибку не смотрим: у свежего файла буфер нулевой

    a.label('openonly')                                            # A=0, если файла нет
    a.ref(0x3A, 'homedrv'); a.ref(0x32, 'fcb')
    a.db(0x0E, 0x0F); a.ref(0x11, 'fcb'); a.word(0xCD, BDOS)
    a.db(0x3C, 0xC8)
    a.db(0x3E, 0xFF, 0xC9)

    a.label('prmload')                                             # A=0, если нечего брать
    a.ref(0xCD, 'prmopen'); a.db(0xB7, 0xC8)   # ORA A: RZ смотрит флаг, а не A
    a.ref(0x3A, SIGN); a.db(0xFE, 0x48, 0xC0)                      # подпись 'H'
    a.ref(0x21, SIGN); a.db(0x23, 0x7E, 0xFE, 0x44, 0xC0)          # и 'D'
    a.db(0x3E, 0xFF, 0xC9)

    a.label('prmsave')
    a.ref(0xCD, 'prmopenw'); a.db(0xB7, 0xC8)
    # Защита от записи -- это фича: закрыл файл, и выбранные дискеты
    # зафиксированы. Признак «только чтение» -- старший бит ПЕРВОГО знака типа
    # (fcb+9). Не третьего: туда БДОС ставит «архивный» после каждой записи, и
    # проверка по нему запрещала сохранение сразу после первого же раза.
    a.ref(0x3A, 'fcbro'); a.db(0xE6, 0x80, 0xC0)
    a.db(0x3E, 0x48); a.ref(0x32, SIGN)                            # проставить подпись
    a.ref(0x21, SIGN); a.db(0x23, 0x36, 0x44)
    a.ref(0xCD, 'slotptr'); a.db(0xEB)                             # DE -> слот
    a.ref(0x21, 'pending'); a.db(0x0E, 0x05)
    a.label('cpp')
    a.db(0x7E, 0x12, 0x23, 0x13, 0x0D); a.ref(0xC2, 'cpp')         # набор в слот
    a.db(0x0E, 0x22); a.ref(0x11, 'fcb'); a.word(0xCD, BDOS)       # запись по номеру
    a.db(0x0E, 0x10); a.ref(0x11, 'fcb'); a.word(0xCD, BDOS)       # закрыть
    a.db(0xC9)

    # ---------------- данные ----------------
    a.label('msg')
    a.code += ' Номер дискеты - '.encode('koi8-r') + b'\0'
    a.label('drive'); a.db(1)
    a.label('homedrv'); a.db(1)
    a.label('once'); a.db(0)
    a.label('applied'); a.db(0)
    a.label('pending'); a.code += bytes(5)
    a.label('save'); a.code += bytes(37)
    a.label('fcb'); a.code += bytes([0]) + b'CO      '
    a.label('fcbro'); a.code += b'HDD' + bytes(21)   # старший бит первого знака типа
    a.label('fcbr'); a.db(0)
    a.label('fcbr1'); a.db(0)
    a.label('fcbr2'); a.db(0)
    a.label('buf'); a.code += bytes(PRM_OFF)
    a.label(SIGN); a.code += bytes(128 - PRM_OFF)
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

    # код работает не там, где лежит: в файле он в хвосте, а исполняется по
    # B900 -- под стеком CO. В хвосте держать нельзя, 4100 это буфер каталога
    # самого CO, он его затирает при чтении чужого диска.
    if len(d) % 128:
        sys.exit('образ не выровнен по записи: %d байт' % len(d))
    at = 0xB700 + (len(d) - 0x4000)
    globals()['_at'] = at
    code = build(at)
    init_at = build_init_addr[0]
    d[slot] = at & 0xFF
    d[slot + 1] = at >> 8
    # и увести разбор клавиши на свою проверку
    hook = build_keyhook_addr[0]
    d[DISPATCH - ORG:DISPATCH - ORG + 3] = bytes([0xC3, hook & 0xFF, hook >> 8])
    # а восстановление -- на первый заход главного цикла
    d[0x030F - ORG:0x030F - ORG + 3] = bytes([0xCD, init_at & 0xFF, init_at >> 8])

    # Заодно поправить нижнюю строку второго набора. Строка сплошная, до нуля,
    # и её длина держит разметку -- «Атрибуты» ровно на столько же длиннее,
    # на сколько «Hdd» короче «Печати», так что суммарно ничего не съезжает.
    RENAME = [('2-Атриб.', '2-Атрибуты '), ('7-Печать', '7-Hdd'), ('0-Выйти', '0-Выход')]
    beg = d.find('1-40/60'.encode('koi8-r'))
    if beg < 0:
        sys.exit('не нашёл строку клавиш второго набора -- незнакомый выпуск CO')
    end = d.index(b'\0', beg)
    bar = bytes(d[beg:end])
    for old, new in RENAME:
        o, n = old.encode('koi8-r'), new.encode('koi8-r')
        if o not in bar:
            sys.exit('в строке клавиш нет «%s»' % old)
        bar = bar.replace(o, n)
    if len(bar) != end - beg:
        sys.exit('строка клавиш изменила длину: было %d, стало %d -- разметка съедет'
                 % (end - beg, len(bar)))
    d[beg:end] = bar
    d += code
    d += bytes([0x1A] * (-len(d) % 128))
    open(args.outfile, 'wb').write(bytes(d))
    print('выбор дискеты НЖМД: %d байт, работает по %04X, СС+7 переставлен с %04X'
          % (len(code), at, OLD))
    print('init=%04X' % init_at)


if __name__ == '__main__':
    main()
