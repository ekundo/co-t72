#!/usr/bin/env python3
"""Сделать дискету загрузочной: положить систему на её системные дорожки.

    ./sysfdd.py co-t72f.fdd os-t72f.rom --base work/os-t72/os-t72.fdd

Первые восемь дорожек дискеты МикроДОС под файлы не отданы (OFF 8 в описателе
диска, см. cpmimg.py): в них лежит описатель и образ системы, который загрузчик
Вектора поднимает при загрузке с дискеты. Раскладку берём с подлинной системной дискеты
T-72: по 0000 -- описатель диска, с 0080 -- образ системы, а он собран с 0100,
то есть смещение в файле на 80h меньше адреса в памяти.

Подменяем только образ: описатель и всё, что лежит за образом, переносим с
подлинной дискеты как есть. Каталог и файлы (с 0A000h) не трогаем вовсе.
"""

import argparse

DPB = 0x80              # описатель диска -- первые 128 байт
SYS = 0x80              # образ системы, собранный с 0100h
DATA = 8 * 5120         # с этого места каталог и файлы -- их не трогаем


def main():
    p = argparse.ArgumentParser()
    p.add_argument('image', help='дискета, которую делаем загрузочной')
    p.add_argument('system', help='образ системы (os-t72X.rom)')
    p.add_argument('--base', required=True, help='подлинная системная дискета T-72')
    a = p.parse_args()

    img = bytearray(open(a.image, 'rb').read())
    base = open(a.base, 'rb').read()
    sysimg = open(a.system, 'rb').read()

    if len(base) < DATA:
        raise SystemExit('подлинная дискета короче системных дорожек')
    if SYS + len(sysimg) > DATA:
        raise SystemExit('образ системы не влезает в системные дорожки')

    img[0:DATA] = base[0:DATA]
    img[SYS:SYS + len(sysimg)] = sysimg
    open(a.image, 'wb').write(bytes(img))
    print('системные дорожки: описатель с %04X, система %d байт с %04X'
          % (0, len(sysimg), SYS))


if __name__ == '__main__':
    main()
