#!/usr/bin/env python3
"""Образ винчестера Вектора для стенда: собрать, посмотреть, положить файл.

    ./tools/mkhdd.py create /tmp/т.hdd --disks 2
    ./tools/mkhdd.py put /tmp/т.hdd 1 out/CO.COM
    ./tools/mkhdd.py label /tmp/т.hdd 1 'ПРОВЕРКА'
    ./tools/mkhdd.py list /tmp/т.hdd 1
    ./tools/mkhdd.py carve /tmp/т.hdd --from ~/Documents/vector.hdd --disks 3

Раскладка -- та же, что разбирает HDIR (tools/hdir-code.inc) и по которой
ходит сама T-72 (MDOS_T-72/Source/_E200h.asm, L_RWHD):

    сектор 0        заголовок; по смещению 84h -- число «дискет»
    секторы 2..81   системные дорожки, общие на весь винчестер
    дискета N       первый сектор 2 + (N-1)*622h, данные с него же плюс 80
                    (дорожки 0..7 у дискеты и есть те самые общие)
    сектор 1648     от начала данных дискеты -- метка (её пишет HDIR /M)

Файловая система «дискеты» -- обычный CP/M с блоком 2 КБ и каталогом на 128
записей, только без зарезервированных дорожек. Поэтому put и list просто
вырезают её кусок и отдают его tools/cpmimg.py с геометрией hdd.
"""

import argparse
import pathlib
import subprocess
import sys
import tempfile

SEC = 512
HEAD = 2                # секторов заголовка перед первой дискетой
SPD = 0x622             # секторов на одну «дискету»
SYS = 80                # общие системные дорожки: 8 дорожек по 10 секторов
FS = 1568               # секторов файловой системы дискеты
LABSEC = 1568           # сектор метки, от начала данных дискеты
LABSIGN = b'HDLB'       # подпись сектора метки (см. hdir-data.inc)
COUNT = 0x84            # где в заголовке лежит число дискет
HERE = pathlib.Path(__file__).resolve().parent


def data_lba(n):
    """Первый сектор данных дискеты n (нумерация с единицы)."""
    return HEAD + (n - 1) * SPD + SYS


def total_sectors(disks):
    return HEAD + disks * SPD + SYS


def read_count(img):
    return img[COUNT] | img[COUNT + 1] << 8


def load(path):
    return bytearray(pathlib.Path(path).read_bytes())


def cpmimg(*args):
    r = subprocess.run([sys.executable, str(HERE / 'cpmimg.py'), '--geom', 'hdd']
                       + [str(a) for a in args], capture_output=True, text=True)
    sys.stdout.write(r.stdout)
    if r.returncode:
        sys.stderr.write(r.stderr)
        sys.exit(r.returncode)


def slice_disk(img, n, path):
    off = data_lba(n) * SEC
    pathlib.Path(path).write_bytes(bytes(img[off:off + FS * SEC]))


def splice_disk(img, n, path):
    off = data_lba(n) * SEC
    img[off:off + FS * SEC] = pathlib.Path(path).read_bytes()


def cmd_create(a):
    img = bytearray(b'\xE5' * (total_sectors(a.disks) * SEC))
    img[COUNT] = a.disks & 0xFF
    img[COUNT + 1] = a.disks >> 8
    pathlib.Path(a.image).write_bytes(bytes(img))
    print('создан %s: дискет %d, секторов %d (%d байт)'
          % (a.image, a.disks, total_sectors(a.disks), len(img)))


def cmd_carve(a):
    src = pathlib.Path(a.source).read_bytes()
    need = total_sectors(a.disks) * SEC
    if len(src) < need:
        sys.exit('в образце всего %d байт, а нужно %d' % (len(src), need))
    img = bytearray(src[:need])
    img[COUNT] = a.disks & 0xFF
    img[COUNT + 1] = a.disks >> 8
    pathlib.Path(a.image).write_bytes(bytes(img))
    print('вырезано %d секторов из %s: дискет %d вместо %d'
          % (total_sectors(a.disks), a.source, a.disks,
             read_count(bytearray(src[:SEC]))))


def cmd_put(a):
    img = load(a.image)
    with tempfile.NamedTemporaryFile(suffix='.disk') as t:
        slice_disk(img, a.disk, t.name)
        cpmimg('put', t.name, a.file, *( [a.name] if a.name else [] ))
        splice_disk(img, a.disk, t.name)
    pathlib.Path(a.image).write_bytes(bytes(img))


def cmd_list(a):
    img = load(a.image)
    disks = read_count(img)
    print('дискет в заголовке: %d, секторов в образе: %d'
          % (disks, len(img) // SEC))
    for n in ([a.disk] if a.disk else range(1, disks + 1)):
        lab = label_of(img, n)
        print('--- дискета %d (сектор %d)%s'
              % (n, data_lba(n), ', метка «%s»' % lab if lab else ''))
        with tempfile.NamedTemporaryFile(suffix='.disk') as t:
            slice_disk(img, n, t.name)
            cpmimg('list', t.name)


def label_of(img, n):
    off = (data_lba(n) + LABSEC) * SEC
    if bytes(img[off:off + len(LABSIGN)]) != LABSIGN:
        return ''
    raw = bytes(img[off + len(LABSIGN):off + len(LABSIGN) + 32])
    return raw.decode('koi8-r', 'replace').rstrip()


def cmd_label(a):
    img = load(a.image)
    off = (data_lba(a.disk) + LABSEC) * SEC
    img[off:off + SEC] = b'\xE5' * SEC
    if a.text.strip():
        text = a.text.encode('koi8-r')[:32].ljust(32, b' ')
        img[off:off + len(LABSIGN)] = LABSIGN
        img[off + len(LABSIGN):off + len(LABSIGN) + 32] = text
    pathlib.Path(a.image).write_bytes(bytes(img))
    print('дискета %d: метка «%s»' % (a.disk, a.text.strip() or '--'))


def main():
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest='cmd', required=True)
    q = sub.add_parser('create'); q.add_argument('image')
    q.add_argument('--disks', type=int, default=2); q.set_defaults(fn=cmd_create)
    q = sub.add_parser('carve'); q.add_argument('image')
    q.add_argument('--from', dest='source', required=True)
    q.add_argument('--disks', type=int, default=2); q.set_defaults(fn=cmd_carve)
    q = sub.add_parser('put'); q.add_argument('image')
    q.add_argument('disk', type=int); q.add_argument('file')
    q.add_argument('name', nargs='?'); q.set_defaults(fn=cmd_put)
    q = sub.add_parser('list'); q.add_argument('image')
    q.add_argument('disk', type=int, nargs='?'); q.set_defaults(fn=cmd_list)
    q = sub.add_parser('label'); q.add_argument('image')
    q.add_argument('disk', type=int); q.add_argument('text')
    q.set_defaults(fn=cmd_label)
    a = p.parse_args()
    a.fn(a)


if __name__ == '__main__':
    main()
