#!/usr/bin/env python3
"""Add files to a Vector-06C quasi-disk (.edd) image for MicroDOS T-72.

The quasi-disk is not a flat filesystem image: the BIOS computes a sector's
address from track and sector (L_E3DB in MDOS_T-72/Source/_E200h.asm) and keeps a
per-sector checksum, so a hand-built flat image is rejected by the driver with a
disk error. Both mappings were derived from the genuine os-t72.edd by locating
the sectors of the OS.COM it contains:

    record r -> file offset   0x3EF80 - r*0x80        for r < 32  (tracks 0-3)
                              0x39F80 - (r-32)*0x80   for r >= 32
    checksum of record r      two identical bytes at 0x3F000 + r*2
                              (checksum = sum of the 128 data bytes, mod 256)

record = block*8 + sector; blocks 0 and 1 hold the 64-entry directory.
CP/M parameters come from the T-72 DPB D_E953: 1024-byte blocks, DSM 0xEB,
DRM 0x3F, 8-bit block pointers, no reserved tracks.
"""

import argparse
import os
import sys

RECORD = 128
BLOCK = 1024
RECS_PER_BLOCK = BLOCK // RECORD
DIR_ENTRIES = 64
DIR_BLOCKS = 2
BLOCKS = 236
CKS_BASE = 0x3F000


def rec_off(r):
    if r < 32:
        return 0x3EF80 - r * 0x80
    return 0x39F80 - (r - 32) * 0x80


def read_rec(img, r):
    o = rec_off(r)
    return img[o:o + RECORD]


def write_rec(img, r, data):
    data = bytes(data).ljust(RECORD, b'\x1a')[:RECORD]
    o = rec_off(r)
    img[o:o + RECORD] = data
    s = sum(data) & 0xFF
    img[CKS_BASE + r * 2] = s
    img[CKS_BASE + r * 2 + 1] = s


def dir_entries(img):
    for i in range(DIR_ENTRIES):
        r = i // 4
        off = rec_off(r) + (i % 4) * 32
        yield i, img[off:off + 32], off


def parse_name(s):
    s = s.upper()
    nm, _, ex = s.partition('.')
    return nm[:8].ljust(8), ex[:3].ljust(3)


def cmd_format(args):
    """Пустой размеченный квазидиск -- так же, как это делает команда ОС «8 D: F».

    Она пишет через обычный дисковый обмен сектор из 128 байт 0E5h на каждую
    дорожку и сектор, а БСВВ попутно считает и кладёт контрольную сумму. Здесь
    то же самое, только без эмулятора: перебрать все записи и заполнить.

    Нулевой образ, которым подмывает обойтись, по суммам сходится (сумма ста
    двадцати восьми нулей -- ноль), но каталог из нулей -- это не пустой
    каталог: нулевой первый байт для CP/M значит «запись занята, пользователь
    0», и на диске обнаруживается файл с пустым именем.
    """
    img = bytearray(0x40000)
    for r in range(BLOCKS * RECS_PER_BLOCK):
        write_rec(img, r, b'\xE5' * RECORD)
    open(args.image, 'wb').write(bytes(img))
    print('размечен %s: %d записей, %d блоков'
          % (args.image, BLOCKS * RECS_PER_BLOCK, BLOCKS))


def cmd_list(args):
    img = bytearray(open(args.image, 'rb').read())
    for i, e, _ in dir_entries(img):
        if e[0] == 0xE5:
            continue
        nm = bytes(c & 0x7F for c in e[1:9]).decode('ascii', 'replace').rstrip()
        ex = bytes(c & 0x7F for c in e[9:12]).decode('ascii', 'replace').rstrip()
        blocks = [b for b in e[16:32] if b]
        print('%-3d u%d %-8s.%-3s rc=%-3d blocks=%s' %
              (i, e[0], nm, ex, e[15], ','.join(str(b) for b in blocks)))


def cmd_put(args):
    img = bytearray(open(args.image, 'rb').read())
    data = open(args.file, 'rb').read()
    name, ext = parse_name(args.name or os.path.basename(args.file))
    if len(data) % RECORD:
        data += b'\x1a' * (RECORD - len(data) % RECORD)
    nrec = len(data) // RECORD

    used = set(range(DIR_BLOCKS))
    free_slots = []
    for i, e, off in dir_entries(img):
        if e[0] == 0xE5:
            free_slots.append(off)
        else:
            used |= {b for b in e[16:32] if b}
    free = [b for b in range(DIR_BLOCKS, BLOCKS) if b not in used]
    need = (len(data) + BLOCK - 1) // BLOCK
    if need > len(free):
        sys.exit('not enough space: need %d blocks, %d free' % (need, len(free)))
    chosen = free[:need]

    for i, b in enumerate(chosen):
        for s in range(RECS_PER_BLOCK):
            n = i * RECS_PER_BLOCK + s
            if n * RECORD >= len(data):
                break
            write_rec(img, b * RECS_PER_BLOCK + s,
                      data[n * RECORD:(n + 1) * RECORD])

    ptr = extent = 0
    while True:
        if not free_slots:
            sys.exit('directory full')
        slot = free_slots.pop(0)
        e = bytearray(32)
        e[1:9] = name.encode('ascii')
        e[9:12] = ext.encode('ascii')
        e[12] = extent & 0x1F
        e[14] = (extent >> 5) & 0x3F
        e[15] = min(128, nrec - extent * 128)
        for i, b in enumerate(chosen[ptr:ptr + 16]):
            e[16 + i] = b
        img[slot:slot + 32] = e
        # the directory sector this entry lives in needs its checksum refreshed
        r = (slot - 0x3EF80) // -0x80 if slot <= 0x3EF80 else 0
        for rr in range(16):
            if rec_off(rr) <= slot < rec_off(rr) + RECORD:
                write_rec(img, rr, img[rec_off(rr):rec_off(rr) + RECORD])
                break
        ptr += 16
        extent += 1
        if ptr >= len(chosen):
            break

    open(args.image, 'wb').write(bytes(img))
    print('wrote %s.%s: %d bytes, %d records, blocks %s' %
          (name.strip(), ext.strip(), len(data), nrec,
           ','.join(str(b) for b in chosen)))


def find_entries(img, name, ext):
    out = []
    for i, e, off in dir_entries(img):
        if e[0] == 0xE5:
            continue
        nm = bytes(c & 0x7F for c in e[1:9]).decode('ascii', 'replace')
        ex = bytes(c & 0x7F for c in e[9:12]).decode('ascii', 'replace')
        if nm == name and ex == ext:
            out.append((((e[14] & 0x3F) << 5) | (e[12] & 0x1F), bytes(e), off))
    out.sort()
    return out


def refresh_dir_sector(img, off):
    for r in range(DIR_BLOCKS * RECS_PER_BLOCK):
        if rec_off(r) <= off < rec_off(r) + RECORD:
            write_rec(img, r, img[rec_off(r):rec_off(r) + RECORD])
            return


def cmd_get(args):
    img = bytearray(open(args.image, 'rb').read())
    name, ext = parse_name(args.name)
    ents = find_entries(img, name, ext)
    if not ents:
        sys.exit('нет файла %s.%s в образе' % (name.strip(), ext.strip()))
    data = bytearray()
    for _, e, _off in ents:
        recs = [b * RECS_PER_BLOCK + s for b in e[16:32] if b
                for s in range(RECS_PER_BLOCK)]
        for r in recs[:e[15]]:
            data += read_rec(img, r)
    open(args.file, 'wb').write(bytes(data))
    print('прочитан %s.%s: %d байт' % (name.strip(), ext.strip(), len(data)))


def cmd_del(args):
    img = bytearray(open(args.image, 'rb').read())
    name, ext = parse_name(args.name)
    ents = find_entries(img, name, ext)
    if not ents:
        sys.exit('нет файла %s.%s в образе' % (name.strip(), ext.strip()))
    for _, _e, off in ents:
        img[off] = 0xE5
        refresh_dir_sector(img, off)
    open(args.image, 'wb').write(bytes(img))
    print('удалён %s.%s: записей каталога %d'
          % (name.strip(), ext.strip(), len(ents)))


def main():
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest='cmd', required=True)
    q = sub.add_parser('format'); q.add_argument('image')
    q.set_defaults(fn=cmd_format)
    q = sub.add_parser('list'); q.add_argument('image'); q.set_defaults(fn=cmd_list)
    q = sub.add_parser('put')
    q.add_argument('image'); q.add_argument('file'); q.add_argument('name', nargs='?')
    q.set_defaults(fn=cmd_put)
    q = sub.add_parser('get')
    q.add_argument('image'); q.add_argument('name'); q.add_argument('file')
    q.set_defaults(fn=cmd_get)
    q = sub.add_parser('del')
    q.add_argument('image'); q.add_argument('name')
    q.set_defaults(fn=cmd_del)
    args = p.parse_args()
    args.fn(args)


if __name__ == '__main__':
    main()
