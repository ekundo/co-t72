#!/usr/bin/env python3
"""MicroDOS / CP/M image tool for Vector-06C (T-34 / T-72 geometry).

Both geometries come from the T-72 BIOS disk parameter blocks
(MDOS_T-72/Source/_E200h.asm):

  floppy, D_E935:  SPT 0x28  BSH 4 BLM 15  DSM 0x187  DRM 0x7F  AL0 0xC0  OFF 8
                   -> 2048-byte blocks, 128 dir entries, 8 reserved tracks
                      (8 * 5120 = 0xA000), 16-bit block pointers (DSM >= 256)

  quasi-disk, D_E953: SPT 8  BSH 3 BLM 7  DSM 0xEB  DRM 0x3F  AL0 0xC0  OFF 0
                   -> 1024-byte blocks, 64 dir entries, no reserved area,
                      8-bit block pointers (DSM < 256)

Floppy tracks are laid out linearly, cylinder by cylinder, side 0 then side 1 --
the same mapping v06x uses (src/fsimage.cpp read_sector).

Commands:  list | put | get | create
"""

import argparse
import os
import sys

RECORD = 128


class Geom:
    def __init__(self, name, block, dir_entries, data_start, blocks, ptr16, size):
        self.name = name
        self.block = block
        self.dir_entries = dir_entries
        self.data_start = data_start
        self.blocks = blocks
        self.ptr16 = ptr16
        self.size = size

    @property
    def dir_blocks(self):
        return (self.dir_entries * 32 + self.block - 1) // self.block

    @property
    def ptrs_per_entry(self):
        return 8 if self.ptr16 else 16

    def blk_off(self, n):
        return self.data_start + n * self.block


FDD = Geom('fdd', block=2048, dir_entries=128, data_start=8 * 5120,
           blocks=390, ptr16=True, size=164 * 5120)
# Same CP/M parameters, but the 8 reserved "tracks" counted as whole cylinders
# (10 sectors) instead of single sides -- v06x maps a cylinder to 10240 bytes,
# and the two BIOSes disagree about which of the two a DPB track means.
FDD_CYL = Geom('fdd-cyl', block=2048, dir_entries=128, data_start=8 * 10240,
               blocks=(164 * 5120 - 8 * 10240) // 2048, ptr16=True,
               size=164 * 5120)
EDD = Geom('edd', block=1024, dir_entries=64, data_start=0,
           blocks=236, ptr16=False, size=256 * 1024)

GEOMS = {'fdd': FDD, 'fdd-cyl': FDD_CYL, 'edd': EDD}


def pick_geom(args):
    if args.geom:
        return GEOMS[args.geom]
    # infer from file size: quasi-disk images are 256K, floppies ~820K
    try:
        n = os.path.getsize(args.image)
    except OSError:
        return FDD
    return EDD if n <= 512 * 1024 else FDD


def parse_name(s):
    s = s.upper()
    nm, _, ex = s.partition('.')
    return nm[:8].ljust(8), ex[:3].ljust(3)


def fmt_name(e):
    nm = bytes(c & 0x7F for c in e[1:9]).decode('ascii', 'replace').rstrip()
    ex = bytes(c & 0x7F for c in e[9:12]).decode('ascii', 'replace').rstrip()
    return nm + ('.' + ex if ex else '')


def entry_blocks(e, g):
    out = []
    if g.ptr16:
        for i in range(16, 32, 2):
            b = e[i] | (e[i + 1] << 8)
            if b:
                out.append(b)
    else:
        for i in range(16, 32):
            if e[i]:
                out.append(e[i])
    return out


def live_entries(img, g):
    base = g.data_start
    for i in range(g.dir_entries):
        e = img[base + i * 32:base + i * 32 + 32]
        if e[0] != 0xE5:
            yield i, e


def cmd_list(args, g):
    img = bytearray(open(args.image, 'rb').read())
    files = {}
    for _, e in live_entries(img, g):
        files.setdefault((e[0], fmt_name(e)), 0)
        files[(e[0], fmt_name(e))] += e[15]
    print('# geometry: %s, block %d, dir %d entries, data at %#x' %
          (g.name, g.block, g.dir_entries, g.data_start))
    print('%-14s %-5s %8s' % ('name', 'user', 'bytes'))
    for (user, name), recs in sorted(files.items(), key=lambda kv: kv[0][1]):
        print('%-14s %-5d %8d' % (name, user, recs * RECORD))
    used = sum(1 for _ in live_entries(img, g))
    print('\n%d/%d directory entries used' % (used, g.dir_entries))


def cmd_put(args, g):
    img = bytearray(open(args.image, 'rb').read())
    data = open(args.file, 'rb').read()
    name, ext = parse_name(args.name or os.path.basename(args.file))
    if len(data) % RECORD:
        data += b'\x1a' * (RECORD - len(data) % RECORD)
    nrecords = len(data) // RECORD

    used = set(range(g.dir_blocks))
    for _, e in live_entries(img, g):
        used |= set(entry_blocks(e, g))
    free = [b for b in range(g.dir_blocks, g.blocks) if b not in used]
    need = (len(data) + g.block - 1) // g.block
    if need > len(free):
        sys.exit('not enough space: need %d blocks, %d free' % (need, len(free)))

    chosen = free[:need]
    for i, b in enumerate(chosen):
        chunk = data[i * g.block:(i + 1) * g.block].ljust(g.block, b'\x1a')
        img[g.blk_off(b):g.blk_off(b) + g.block] = chunk

    slots = [i for i in range(g.dir_entries)
             if img[g.data_start + i * 32] == 0xE5]
    per = g.ptrs_per_entry
    recs_per_extent = per * g.block // RECORD      # fdd: 128, edd: 128
    ptr = 0
    extent = 0
    while True:
        if not slots:
            sys.exit('directory full')
        slot = slots.pop(0)
        e = bytearray(32)
        e[0] = 0
        e[1:9] = name.encode('ascii')
        e[9:12] = ext.encode('ascii')
        e[12] = extent & 0x1F
        e[14] = (extent >> 5) & 0x3F
        e[15] = min(recs_per_extent, nrecords - extent * recs_per_extent)
        for i, b in enumerate(chosen[ptr:ptr + per]):
            if g.ptr16:
                e[16 + i * 2] = b & 0xFF
                e[17 + i * 2] = b >> 8
            else:
                e[16 + i] = b
        img[g.data_start + slot * 32:g.data_start + slot * 32 + 32] = e
        ptr += per
        extent += 1
        if ptr >= len(chosen):
            break

    open(args.image, 'wb').write(img)
    print('wrote %s.%s: %d bytes, %d records, blocks %s' %
          (name.strip(), ext.strip(), len(data), nrecords,
           ','.join(str(b) for b in chosen)))


def cmd_del(args, g):
    img = bytearray(open(args.image, 'rb').read())
    want = '%-8s%-3s' % parse_name(args.name)
    n = 0
    for i, e in live_entries(img, g):
        if bytes(c & 0x7F for c in e[1:12]).decode('ascii', 'replace') == want:
            img[g.data_start + i * 32] = 0xE5
            n += 1
    open(args.image, 'wb').write(bytes(img))
    print('deleted %s: %d entries' % (args.name, n))


def cmd_get(args, g):
    img = bytearray(open(args.image, 'rb').read())
    name, ext = parse_name(args.name)
    want = name + ext
    extents = []
    for _, e in live_entries(img, g):
        if bytes(c & 0x7F for c in e[1:12]).decode('ascii', 'replace') == want:
            extents.append((e[12] | (e[14] << 5), e))
    if not extents:
        sys.exit('not found: ' + args.name)
    out = bytearray()
    for _, e in sorted(extents):
        for b in entry_blocks(e, g):
            out += img[g.blk_off(b):g.blk_off(b) + g.block]
    total = sum(e[15] for _, e in extents) * RECORD
    open(args.outfile, 'wb').write(bytes(out[:total]))
    print('extracted %s -> %s (%d bytes)' % (args.name, args.outfile, total))


def cmd_create(args, g):
    open(args.image, 'wb').write(b'\xE5' * g.size)
    print('created %s: %d bytes, %s geometry, %d blocks' %
          (args.image, g.size, g.name, g.blocks))


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--geom', choices=sorted(GEOMS))
    sub = p.add_subparsers(dest='cmd', required=True)
    q = sub.add_parser('list'); q.add_argument('image'); q.set_defaults(fn=cmd_list)
    q = sub.add_parser('put')
    q.add_argument('image'); q.add_argument('file'); q.add_argument('name', nargs='?')
    q.set_defaults(fn=cmd_put)
    q = sub.add_parser('del')
    q.add_argument('image'); q.add_argument('name'); q.set_defaults(fn=cmd_del)
    q = sub.add_parser('get')
    q.add_argument('image'); q.add_argument('name'); q.add_argument('outfile')
    q.set_defaults(fn=cmd_get)
    q = sub.add_parser('create'); q.add_argument('image'); q.set_defaults(fn=cmd_create)
    args = p.parse_args()
    args.fn(args, pick_geom(args))


if __name__ == '__main__':
    main()
