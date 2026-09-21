#!/usr/bin/env python3
"""Текст на диск Вектора: КОИ-8, CRLF, 1Ah в конце.

    ./mktxt.py vde/doc/vde.qrf.txt -o out/VDE.QRF

В репозитории тексты лежат как обычные файлы UTF-8 с переводом строки в один
знак; на дисках МикроДОС они должны быть в КОИ-8, со строками через CRLF и с
1Ah на конце -- так их читают и просмотрщик CO, и сама система.

У T-72 в кодах КОИ-8, где стоит «ё» (0B3h/0A3h), лежит псевдографика -- буквы
там нет; меняем её на «е», как это делает и сборка справки (tools/mkhlp.py).
"""
import argparse
import pathlib

YO = str.maketrans('ёЁ', 'еЕ')


def main():
    p = argparse.ArgumentParser(description='текст на диск: КОИ-8, CRLF, 1Ah')
    p.add_argument('src')
    p.add_argument('-o', '--out', required=True)
    a = p.parse_args()

    text = pathlib.Path(a.src).read_text(encoding='utf-8').translate(YO)
    text = text.replace('\r\n', '\n').replace('\n', '\r\n')
    data = text.encode('koi8-r') + b'\x1a'
    pathlib.Path(a.out).write_bytes(data)
    print('%s: %d байт' % (a.out, len(data)))


if __name__ == '__main__':
    main()
