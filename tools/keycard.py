#!/usr/bin/env python3
"""Карточка клавиш CO -- картинкой для README.

    python3 tools/keycard.py -o docs/co-keys.svg

Клавиши те же, что в справке (docs/co-help.md); здесь они разложены по группам,
чтобы держать перед глазами. Правится таблица ниже, картинка пересобирается.
"""
import argparse

W, H = 1260, 1000
BG = '#1414b4'          # синий экран Вектора
FG = '#e8e8f4'
DIM = '#9fa8e8'
CHIP = '#f2f2fa'
CHIPTX = '#14149b'
ACC = '#7ee081'

GROUPS = [
    ('Панели и командная строка', [
        ('ВК', 'выполнить набранную команду; если строка пуста -- сделать то,'
               ' что задано для этого расширения в CO.EXT, а на каталоге --'
               ' войти в него'),
        ('АР2', 'очистить командную строку; если пуста -- зафиксировать вторую'
                ' функцию цифр, ту же, что при удержании СС; что сейчас на'
                ' цифрах, видно в нижней строке экрана'),
        ('ТАБ  ↖', 'перейти на другую панель'),
        ('↑ ↓', 'двигать курсор по панели на строку вверх и вниз'),
        ('→ ←', 'двигать курсор по командной строке; если она пуста --'
                ' переходить в соседний столбец панели'),
        ('СС+→  СС+←', 'переводить курсор в соседний столбец панели -- даже'
                       ' когда в командной строке что-то набрано'),
        ('ЗБ', 'стереть знак перед курсором'),
        ('F3  F1', 'подставлять команды из истории: F3 -- шаг назад, F1 --'
                   ' вперёд; помнит 14 последних'),
        ('F4', 'подставить имя выделенного файла в командную строку'),
        ('F2', 'выбрать кодировку просмотра: К-8, РУС, ЛАТ, Р/Л'),
        (';', 'затем буква -- встать на файл, который с неё начинается'),
        ('ПС', 'дописать к команде ">C:CO.PTK"'),
        ('Пробел', 'показать системный экран'),
    ]),
    ('Метки', [
        ('СТР', 'отметить файл; если в командной строке что-то набрано --'
                ' дописать имя файла в неё'),
        ('+', 'отметить файлы по маске'),
        ('=', 'отметить те же, что на другой панели'),
        ('/', 'обратить метки'),
        ('-', 'снять все метки'),
        ('?', 'показать размер файла с точностью до 128 байт'),
    ]),
    ('Цифры -- при пустой командной строке', [
        ('1', 'показать помощь -- этот файл CO.HLP'),
        ('2', 'открыть меню пользователя из CO.MNU'),
        ('3', 'открыть файл в просмотрщике'),
        ('4', 'открыть файл в редакторе MEDIT'),
        ('5', 'копировать на другой диск'),
        ('6', 'переименовать'),
        ('7', 'сменить диск на панели'),
        ('8', 'удалить'),
        ('9', 'открыть настройки: диск B, режим DIR, экран, проверка при'
              ' копировании, сортировка'),
        ('0', 'погасить монитор'),
    ]),
    ('СС + цифра', [
        ('СС+1', 'переключить вид панели: 40 или 60 файлов'),
        ('СС+2', 'сменить атрибуты файла'),
        ('СС+3', 'открыть файл в просмотрщике со снятым 8-м битом -- так'
                 ' читаются тексты WordStar'),
        ('СС+4', 'открыть файл в WSR (WordStar; под T-72 не работает)'),
        ('СС+5', 'копировать с заменой имени, можно по маске'),
        ('СС+6', 'записать на магнитофон'),
        ('СС+7', 'выбрать дискету НЖМД; без винчестера -- напечатать файл'),
        ('СС+8', 'создать файл'),
        ('СС+9', 'загрузить файл в SID'),
    ]),
    ('Просмотрщик', [
        ('↑ ↓', 'листать экран назад и вперёд'),
        ('F1  F4', 'сдвинуть текст на строку вверх и вниз'),
        ('↖', 'развернуть окно на всю ширину экрана'),
        ('СТР', 'перейти к строке по номеру'),
        ('ПС', 'искать'),
        ('ВК', 'искать следующее'),
        ('F2', 'сменить кодировку: К-8, РУС, ЛАТ, Р/Л'),
        ('F3', 'напечатать'),
        ('АР2', 'вернуться к панелям'),
    ]),
    ('Ещё сочетания', [
        ('СС+ВК', 'выполнить вторую строку CO.EXT для этого расширения'),
        ('УС+ВК', 'выполнить третью'),
        ('СС+УС+ВК', 'выполнить четвёртую'),
        ('УС+4', 'создать файл и сразу открыть его в редакторе'),
    ]),
]

FOOT = ('CO 2.0 -- Шишатский С.М., Харьков 1993. Сборка под MDOS T-72: '
        'github.com/ekundo/co-t72')


def esc(t):
    return t.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')


COLW = 566              # ширина колонки
CHARW = 8.6             # ширина знака при font-size 13 -- с запасом на чужой шрифт
ROW = 25                # шаг строки
CONT = 18               # перенос внутри строки


PLUS = 13               # место под знак "+" между клавишами сочетания
GAP = 24                # просвет между разными клавишами -- заметно больше, чем у "+"


def parse_key(key):
    """Разобрать поле клавиш.

    Через пробел -- разные клавиши, делающие одно и то же. Через плюс --
    сочетание: жать вместе. И то и другое рисуется отдельными шапочками, у
    сочетания между ними ставится "+".
    """
    return [[a] if a == '+' else a.split('+') for a in key.split()]


def key_width(alts):
    w = 0
    for i, parts in enumerate(alts):
        if i:
            w += GAP
        for j, k in enumerate(parts):
            if j:
                w += PLUS
            w += max(30, 11 * len(k) + 14)
    return w


def layout(rows, x):
    """Разложить строки группы: шапочки клавиш и переносы описаний."""
    out = []
    for key, desc in rows:
        alts = parse_key(key)
        kw = key_width(alts)
        room = int((COLW - kw - 12) / CHARW)
        words, line, lines = desc.split(), '', []
        for w in words:
            t = (line + ' ' + w).strip()
            if len(t) > room and line:
                lines.append(line)
                line = w
            else:
                line = t
        lines.append(line)
        out.append((alts, kw, lines))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-o', '--out', required=True)
    a = ap.parse_args()

    # сперва раскладка: группы по двум колонкам, поровну по высоте
    prepared = [(title, layout(rows, 0)) for title, rows in GROUPS]
    heights = [30 + sum(ROW + CONT * (len(r[2]) - 1) for r in rows) + 22
               for _, rows in prepared]
    cols = [[], []]
    colh = [0, 0]
    for (title, rows), h in zip(prepared, heights):
        c = 0 if colh[0] <= colh[1] else 1
        cols[c].append((title, rows))
        colh[c] += h
    height = 110 + max(colh) + 46

    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {height}" '
           f'width="{W}" height="{height}" font-family="Menlo, Consolas, '
           f'&quot;DejaVu Sans Mono&quot;, monospace">',
           f'<rect width="{W}" height="{height}" fill="{BG}"/>',
           f'<rect x="8" y="8" width="{W-16}" height="{height-16}" fill="none" '
           f'stroke="{ACC}" stroke-width="2"/>',
           f'<text x="{W//2}" y="52" fill="{FG}" font-size="30" '
           f'text-anchor="middle" letter-spacing="2">КЛАВИШИ CO</text>',
           f'<text x="{W//2}" y="78" fill="{DIM}" font-size="15" '
           f'text-anchor="middle">файловая оболочка CO 2.0 под МикроДОС T-72</text>']

    for c, x in ((0, 40), (1, 654)):
        y = 118
        for title, rows in cols[c]:
            out.append(f'<text x="{x}" y="{y}" fill="{ACC}" font-size="17">'
                       f'{esc(title)}</text>')
            out.append(f'<line x1="{x}" y1="{y+8}" x2="{x+COLW}" y2="{y+8}" '
                       f'stroke="{ACC}" stroke-width="1" opacity="0.45"/>')
            y += 30
            for alts, kw, lines in rows:
                cx = x
                for i, parts in enumerate(alts):
                    if i:
                        # запятая между разными клавишами: "ТАБ", "↖" -- это
                        # две клавиши, а не одно сочетание
                        out.append(f'<text x="{cx + 5}" y="{y+1}" fill="{FG}" '
                                   f'font-size="13">,</text>')
                        cx += GAP
                    for j, k in enumerate(parts):
                        if j:
                            out.append(f'<text x="{cx + PLUS//2}" y="{y+1}" '
                                       f'fill="{FG}" font-size="13" '
                                       f'text-anchor="middle">+</text>')
                            cx += PLUS
                        kwi = max(30, 11 * len(k) + 14)
                        out.append(f'<rect x="{cx}" y="{y-14}" width="{kwi}" '
                                   f'height="21" rx="4" fill="{CHIP}"/>')
                        out.append(f'<text x="{cx + kwi//2}" y="{y+1}" '
                                   f'fill="{CHIPTX}" font-size="13" '
                                   f'text-anchor="middle">{esc(k)}</text>')
                        cx += kwi
                for i, ln in enumerate(lines):
                    out.append(f'<text x="{x + kw + 12}" y="{y + 1 + i*CONT}" '
                               f'fill="{FG}" font-size="13">{esc(ln)}</text>')
                y += ROW + CONT * (len(lines) - 1)
            y += 22

    out.append(f'<text x="{W//2}" y="{height-20}" fill="{DIM}" font-size="12" '
               f'text-anchor="middle">{esc(FOOT)}</text>')
    out.append('</svg>')
    open(a.out, 'w').write('\n'.join(out) + '\n')
    print('%s: %d байт, %dx%d' % (a.out, sum(len(l) for l in out), W, height))


if __name__ == '__main__':
    main()
