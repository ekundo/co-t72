#!/usr/bin/env python3
"""Текст для Вектора из UTF-8: vde/mkdoc.py vde/doc/vde.doc.txt -o work/vde/VDE.DOC

Соглашения те же, что у CO.HLP (tools/mkhlp.py): КОИ-8, CRLF, добивка до
границы записи знаком 1Ah. Раскладку по колонкам здесь не делаем -- исходник
уже свёрстан по ширине экрана, как у автора.
"""
import argparse, pathlib, sys

# У T-72 в кодах КОИ-8, где стоит "ё" (0B3h/0A3h), лежит псевдографика -- буквы
# там нет. В исходнике писать "ё" удобно, поэтому меняем её на выводе.
YO = str.maketrans('ёЁ', 'еЕ')
WIDTH = 79


def main():
    ap = argparse.ArgumentParser(description='текст для Вектора из UTF-8')
    ap.add_argument('src')
    ap.add_argument('-o', '--out', required=True)
    a = ap.parse_args()

    lines = pathlib.Path(a.src).read_text(encoding='utf-8').translate(YO).split('\n')
    while lines and not lines[-1]:
        lines.pop()
    long = [i for i, l in enumerate(lines, 1) if len(l) > WIDTH]
    if long:
        sys.exit('строки шире %d знаков: %s' % (WIDTH, long))

    data = ('\r\n'.join(lines) + '\r\n').encode('koi8-r')
    if len(data) % 128:
        data += b'\x1a' * (128 - len(data) % 128)
    pathlib.Path(a.out).write_bytes(data)
    print('%s: %d байт, %d строк' % (a.out, len(data), len(lines)))


if __name__ == '__main__':
    main()
