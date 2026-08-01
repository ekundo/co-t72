#!/usr/bin/env python3
"""Rewrite hardcoded OS entry points in a .COM file: old address -> new address.

CO hooks the BIOS disk vector at E213 with its own filter and then passes calls
through to a hardcoded continuation inside the OS. Those constants are what tie
it to one particular BIOS build; this maps them to another one's.

Only operands at positions a dis8080.py listing decoded as instruction starts are
touched, so byte patterns that merely look like an address are left alone.
"""

import argparse
import re
import sys

THREE = {0x01, 0x11, 0x21, 0x31, 0x22, 0x2A, 0x32, 0x3A, 0xC3, 0xCD,
         0xC2, 0xCA, 0xD2, 0xDA, 0xE2, 0xEA, 0xF2, 0xFA,
         0xC4, 0xCC, 0xD4, 0xDC, 0xE4, 0xEC, 0xF4, 0xFC}


def listing_starts(path):
    starts = set()
    for line in open(path):
        m = re.match(r'^\S*\s+\S.*?;\s+([0-9A-F]{4})\s+((?:[0-9a-f]{2} ?)+)$', line)
        if m and not line.lstrip().startswith('.db'):
            starts.add(int(m.group(1), 16))
    return starts


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--listing', required=True)
    p.add_argument('--org', default='0x100')
    p.add_argument('--map', action='append', required=True,
                   help='OLD:NEW in hex, e.g. E2BD:E2ED (repeatable)')
    args = p.parse_args()

    org = int(args.org, 0)
    data = bytearray(open(args.infile, 'rb').read())
    starts = listing_starts(args.listing)
    mapping = {}
    for m in args.map:
        old, new = m.split(':')
        mapping[int(old, 16)] = int(new, 16)

    hits = []
    for off in range(len(data) - 2):
        addr = org + off
        if data[off] not in THREE or addr not in starts:
            continue
        tgt = data[off + 1] | (data[off + 2] << 8)
        if tgt not in mapping:
            continue
        new = mapping[tgt]
        hits.append((addr, tgt, new))
        data[off + 1] = new & 0xFF
        data[off + 2] = new >> 8

    open(args.outfile, 'wb').write(bytes(data))
    if not hits:
        sys.exit('nothing patched -- check the listing and the address map')
    for addr, old, new in hits:
        print('  %04X: %04X -> %04X' % (addr, old, new))
    print('patched %d references' % len(hits))


if __name__ == '__main__':
    main()
