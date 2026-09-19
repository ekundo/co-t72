#!/usr/bin/env python3
"""Нижние строки подсказки -- во всю ширину экрана.

    ./barwide.py CO.COM [-o out]

Обе строки у CO по 79 знаков, а строка консоли T-72 -- 80. Основная строка
выводится вывороткой, и одного знакоместа ей как раз не хватает: справа, у
самой рамки правой панели, остаётся тёмный зубец шириной в знак. Заодно и
теснота: «3-Просм.» слиплось с «4-Мedit», а во втором наборе «2-Атриб.» --
с «3-ПрК7». Одно с другим связано: пробела между ними нет ровно потому, что
строка упёрлась в свою длину.

Мешают этому две вещи.

**Перевод строки после восьмидесятого знака.** Напечатав знак в последней
колонке, консоль переводит строку, а строка подсказки -- последняя на
экране: экран прокручивается, панели уезжают вверх, подсказка садится на
командную строку. Проверено прогоном. Лечится выключателем автоматического
перевода: `ЭСК [ 7 l` -- после него курсор в последней колонке остаётся на
месте (`L_FE13` = 4Fh, обработчик конца строки в Source/_F600h.asm). Обратно
включает `ЭСК [ 7 h`; делаем это, когда CO отдаёт экран командной строке, --
дальше там работают ССР и чужие программы, и перевод строки им нужен.

**Место в образе.** Строки лежат встык, и удлинить их некуда: следом идёт
четырёхбайтовый буфер по `11ED` (в него CO переводит число, `0BEA`), а за ним
код. Зато в области нашлись два покойника -- строки `ЭСК [` и `ЭСК \\`,
которыми старый переключатель знакогенератора слал команды T-34. Сам
переключатель сборка заменяет своей подпрограммой (tools/koi.py), и строки
больше не нужны никому; вдобавок под T-72 `ЭСК [` -- это начало команды с
параметрами, и напечатанная одна она проглотила бы следующий знак. Ссылки на
них уводим на пустую строку, а освободившееся место отдаём подсказкам. Ещё
две строки -- приглашение командной строки и подвод курсора -- переезжают под
стек, к остальному дописанному.

Границу области ищем не по адресу: с одного конца это начало строки подвода
курсора перед подсказкой, с другого -- первый адрес в области, на который
ссылаются, но строкой он не начинается (это и есть буфер).
"""

import argparse
import sys

import barline
import layout

ORG = 0x100
WRAP_OFF = b'\x1b[7l'                           # автоперевод строки -- прочь
WRAP_ON = b'\x1b[7h'                            # и обратно
HEAD = b'\x1b\x62'                              # ЭСК b -- выворотка
TAIL = b'\x1b\x61'                              # ЭСК a -- обычный вывод
POS = b'\x1b\x59\x38\x20'                       # ЭСК Y -- строка 24, колонка 0
FIRST = HEAD + '1-Помощь'.encode('koi8-r')      # начало основной строки
DEAD = (b'\x1b[', b'\x1b\\')                    # команды T-34, набор знаков
CMDLINE = b'\x0c\x0a >'                         # приглашение командной строки


def refs(d, addr):
    """Где в образе лежит LXI H,addr."""
    want = bytes([0x21, addr & 0xFF, addr >> 8])
    out, i = [], 0
    while True:
        i = d.find(want, i)
        if i < 0:
            return out
        out.append(i)
        i += 1


def site(d, addr):
    """Единственное место, откуда на строку ссылаются, или None.

    Искать надо до правки образа: переложенная ссылка сама выглядит как
    ссылка, и следующий поиск нашёл бы уже её."""
    found = refs(d, addr)
    if len(found) > 1:
        sys.exit('на строку по %04X ссылаются из %d мест -- не берусь'
                 % (addr, len(found)))
    return found[0] if found else None


def main():
    p = argparse.ArgumentParser(description='строки подсказки на всю ширину экрана')
    p.add_argument('image', help='CO.COM (правится на месте)')
    p.add_argument('-o', '--out', help='куда записать (по умолчанию -- на место)')
    p.add_argument('-w', '--width', type=int, default=barline.WIDTH,
                   help='ширина строки (по умолчанию %d)' % barline.WIDTH)
    a = p.parse_args()

    d = bytearray(open(a.image, 'rb').read())
    bar = d.find(FIRST)
    if bar < 0:
        sys.exit('не нашёл основную строку подсказки -- незнакомый выпуск CO')
    # Перед ней -- подвод курсора в начало последней строки, с него и начнём.
    beg = d.rfind(POS, 0, bar)
    if beg < 0 or d[beg + len(POS)] != 0 or beg + len(POS) + 1 != bar:
        sys.exit('перед строкой подсказки нет подвода курсора «ЭСК Y 24,0»')

    # Разобрать область на строки, пока они разбираются.
    strings, i = [], beg
    while True:
        j = d.find(b'\0', i)
        if j < 0:
            sys.exit('строка без нуля на конце по %04X' % (i + ORG))
        strings.append([i + ORG, bytes(d[i:j])])
        i = j + 1
        if not d[i]:                    # дальше пошли нули -- это уже не строки
            break

    # Конец области -- первый адрес, на который ссылаются, но строки там не
    # начинается: это буфер, его трогать нельзя.
    starts = {s[0] for s in strings}
    end = i + ORG
    for addr in range(strings[-1][0] + len(strings[-1][1]) + 1, i + ORG + 8):
        if addr not in starts and refs(d, addr):
            end = addr
            break
    room = end - strings[0][0]

    # Ссылки на все строки области -- по нетронутому образу.
    sites = {addr: site(d, addr) for addr, _ in strings}

    named = {'подвод': 0, 'основная': 1, 'второй набор': 2}
    if len(strings) < 4:
        sys.exit('строк в области меньше, чем ожидалось: %d' % len(strings))
    pos_s, main_s, cc_s = (strings[named[k]][1] for k in named)
    if not main_s.startswith(HEAD) or not main_s.endswith(TAIL):
        sys.exit('основная строка не обёрнута в ЭСК b / ЭСК a')

    # Новые строки: подсказки во всю ширину, у подвода -- выключатель
    # перевода строки, у приглашения командной строки -- включатель обратно.
    wide = {
        named['подвод']: WRAP_OFF + pos_s,
        named['основная']: HEAD + barline.join(
            barline.split(main_s[len(HEAD):-len(TAIL)]), a.width) + TAIL,
        named['второй набор']: barline.join(barline.split(cc_s), a.width),
    }
    out, moves, dead, moved_out = bytearray(), [], [], []
    for k, (addr, s) in enumerate(strings):
        if k in wide:
            s = wide[k]
        elif s in DEAD:
            dead.append(addr)
            continue
        elif s == CMDLINE or s.startswith(b'\x1b\x59'):
            # Переезжают под стек: в области им места больше нет.
            moved_out.append([addr, WRAP_ON + s if s == CMDLINE else s])
            continue
        moves.append((addr, strings[0][0] + len(out)))
        out += s + b'\0'
    used = len(out)
    if used + 1 > room:                 # +1 -- пустая строка для покойников
        sys.exit('строки подсказки не умещаются: нужно %d байт, есть %d'
                 % (used + 1, room))
    empty = strings[0][0] + used        # первый байт набивки, он же пустая строка
    out += b'\0' * (room - used)
    d[strings[0][0] - ORG:end - ORG] = out

    # Переехавшие под стек -- в хвост образа, следом за уже дописанным.
    at = layout.STACK_LO + (len(d) - 0x4000)
    tail = bytearray()
    for item in moved_out:
        item.append(at + len(tail))
        tail += item[1] + b'\0'
    # Образ кладётся на диск записями по 128 байт, и следующие шаги сборки
    # ждут выровненной длины -- добиваем концом файла, как все.
    tail += bytes([0x1A] * (-(len(d) + len(tail)) % 128))
    d += tail

    for was, now in moves + [(addr, empty) for addr in dead] \
            + [(m[0], m[2]) for m in moved_out]:
        if was == now:
            continue
        at_ref = sites.get(was)
        if at_ref is None:
            print('  строка по %04X: ссылок не нашлось, переложена молча' % was)
            continue
        d[at_ref + 1] = now & 0xFF
        d[at_ref + 2] = now >> 8

    open(a.out or a.image, 'wb').write(bytes(d))
    if tail:
        layout.note('стек', at, len(tail), 'строки экрана')
    print('строки подсказки на %d знаков (%04X и %04X), в области свободно %d '
          'байт, под стек ушло %d'
          % (a.width, moves[1][1], moves[2][1], room - used, len(tail)))


if __name__ == '__main__':
    main()
