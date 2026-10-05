#!/usr/bin/env python3
"""Логотип для заставки LOGO.SCR: картинка -> два плана экрана T-72.

    ./mklogo.py scr/logo.png -o scr/logo.inc [--preview logo-vec.png]

Картинка обрезается по жёлтой рамке (по яркому прямоугольнику), сжимается до
ширины в 316 точек режима 512x256 и делится на два цвета порогом яркости:
светлое -- цвет текста CO, тёмное -- её фон. Палитру заставка не трогает.

Высота считается с поправкой на форму точки: в режиме 512 на 256 точка вдвое
уже, чем строка развёртки высока, а на экране 4:3 её ширина -- две трети
высоты. Без поправки логотип вышел бы вдвое сплюснутым.

Вокруг -- кайма фона: по точке-паре слева и справа и по строке сверху и снизу.
Заставка двигает логотип на столько же за шаг, и кайма затирает след.

Под T-72 видны два плана, A000 и C000, и их точки на экране идут через одну:
чётная берётся из одного, нечётная из другого. Поэтому строка в 320 точек
лежит двумя рядами по 20 байт: сперва чётные точки, потом нечётные.
"""

import argparse

from PIL import Image

WIDTH = 316                 # точек, без каймы
ASPECT = 2 / 3              # ширина точки к высоте строки на экране 4:3
THRESH = 110                # порог яркости: светлее -- цвет текста


def convert(path):
    im = Image.open(path).convert('L')
    box = im.point(lambda v: 255 if v > THRESH else 0).getbbox()
    im = im.crop(box)
    w, h = im.size
    height = round(WIDTH * ASPECT * h / w)
    im = im.resize((WIDTH, height), Image.LANCZOS)
    bits = [[1 if im.getpixel((x, y)) > THRESH else 0 for x in range(WIDTH)]
            for y in range(height)]
    blank = [0] * (WIDTH + 4)
    return [blank] + [[0, 0] + row + [0, 0] for row in bits] + [blank]


def planes(rows):
    """Два плана построчно: (чётные, нечётные), по 20 байт на строку."""
    out = ([], [])
    for row in rows:
        for p in (0, 1):
            pts = row[p::2]
            for i in range(0, len(pts), 8):
                b = 0
                for bit in pts[i:i + 8]:
                    b = (b << 1) | bit
                out[p].append(b)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('image')
    ap.add_argument('-o', '--out', required=True)
    ap.add_argument('--preview')
    a = ap.parse_args()
    rows = convert(a.image)
    w, h = len(rows[0]), len(rows)
    even, odd = planes(rows)
    with open(a.out, 'w', encoding='utf-8') as f:
        f.write('; Собрано tools/mklogo.py из %s -- руками не править.\n' % a.image)
        f.write('LOGOW   EQU %d             ; байт в строке плана\n' % (w // 16))
        f.write('LOGOH   EQU %d             ; строк, с каймой\n' % h)
        for name, data in (('LOGOE', even), ('LOGOO', odd)):
            f.write('%s:\n' % name)
            for i in range(0, len(data), w // 16):
                f.write('        .db ' + ','.join('%03Xh' % b for b in data[i:i + w // 16]) + '\n')
    if a.preview:
        im = Image.new('L', (w, h * 2))
        for y, row in enumerate(rows):
            for x, v in enumerate(row):
                im.putpixel((x, 2 * y), 255 * v)
                im.putpixel((x, 2 * y + 1), 255 * v)
        im.resize((w * 3 // 2, h * 2)).save(a.preview)
    print('%s: %d x %d точек, %d байт' % (a.out, w, h, len(even) + len(odd)))


if __name__ == '__main__':
    main()
