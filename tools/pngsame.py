#!/usr/bin/env python3
"""Одинаковы ли два кадра -- целиком или по верхней части.

    ./pngsame.py было.png стало.png [--rows 250]

Возвращает 0, если совпадают, и 1, если нет; при расхождении печатает первую
строку и столбец, где картинки разошлись.

Зачем. Стенд смотрит в память, а мусор на экране в памяти не виден: картинку
панелей CO держит отдельной копией и возвращает её на экран целиком. Сравнение
кадров -- единственный способ поймать такое (см. tools/arcexit.py). `--rows`
отрезает низ кадра: командная строка и подсказка живут своей жизнью, а речь про
панели.

Кадры пишет сам эмулятор (`--save-frame`): 576x288, восемь разрядов на цвет,
RGBA без чересстрочности. Разбираем их здесь руками, чтобы стенду не
понадобилась чужая библиотека ради одного сравнения.
"""

import argparse
import struct
import sys
import zlib


def read_png(path):
    """Вернуть (ширина, высота, строки как bytes) -- по четыре байта на точку."""
    d = open(path, 'rb').read()
    if d[:8] != b'\x89PNG\r\n\x1a\n':
        sys.exit('%s -- не PNG' % path)
    pos, idat, hdr = 8, bytearray(), None
    while pos < len(d):
        ln, typ = struct.unpack('>I4s', d[pos:pos + 8])
        body = d[pos + 8:pos + 8 + ln]
        if typ == b'IHDR':
            hdr = struct.unpack('>IIBBBBB', body)
        elif typ == b'IDAT':
            idat += body
        elif typ == b'IEND':
            break
        pos += 12 + ln
    w, h, depth, color, comp, filt, interlace = hdr
    if (depth, color, interlace) != (8, 6, 0):
        sys.exit('%s: ожидался RGBA по восемь разрядов без чересстрочности' % path)
    raw = zlib.decompress(bytes(idat))
    stride = w * 4
    out, prev = [], bytes(stride)
    pos = 0
    for _ in range(h):
        ft = raw[pos]
        line = bytearray(raw[pos + 1:pos + 1 + stride])
        pos += 1 + stride
        # развернуть фильтр строки -- см. спецификацию PNG, раздел 9
        for i in range(stride):
            a = line[i - 4] if i >= 4 else 0
            b = prev[i]
            c = prev[i - 4] if i >= 4 else 0
            if ft == 1:
                line[i] = (line[i] + a) & 0xFF
            elif ft == 2:
                line[i] = (line[i] + b) & 0xFF
            elif ft == 3:
                line[i] = (line[i] + (a + b) // 2) & 0xFF
            elif ft == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                line[i] = (line[i] + pr) & 0xFF
            elif ft != 0:
                sys.exit('%s: неизвестный фильтр строки %d' % (path, ft))
        prev = bytes(line)
        out.append(prev)
    return w, h, out


def main():
    p = argparse.ArgumentParser(description='сравнить два кадра')
    p.add_argument('first')
    p.add_argument('second')
    p.add_argument('--rows', type=int, default=0,
                   help='сравнивать только первые N строк (0 -- весь кадр)')
    a = p.parse_args()

    w1, h1, r1 = read_png(a.first)
    w2, h2, r2 = read_png(a.second)
    if (w1, h1) != (w2, h2):
        print('кадры разного размера: %dx%d и %dx%d' % (w1, h1, w2, h2))
        return 1
    rows = min(a.rows or h1, h1)
    for y in range(rows):
        if r1[y] != r2[y]:
            x = next(i // 4 for i in range(len(r1[y])) if r1[y][i] != r2[y][i])
            print('кадры расходятся со строки %d, столбца %d' % (y, x))
            return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
