#!/usr/bin/env python3
"""Relocate CO's work area out of the T-72 quasi-disk bank window.

Under T-72 the range A000-DFFF is the window where bank 0 of the quasi-disk is
mapped as RAM (MicroDOS itself lives at BE6C-DFFF there, and the BIOS screen
driver flips the bank on every character). CO keeps its variables and buffers at
A180-B73C, so they share physical RAM with the contents of drive C: -- disk
traffic and CO's own state overwrite each other.

This rewrites operands pointing into A000-BFFF by a fixed offset. References to
C000-DFFF are left alone: those are MicroDOS internals (DF15 = current drive,
DDF0 = disk operation descriptor, the C000 jump table), and they live at the
same addresses in both OS versions.

Which operands to rewrite is decided from a listing produced by dis8080.py --
only positions the disassembler decoded as instruction starts are touched, never
a byte pattern that merely looks like one.
"""

import argparse
import re
import sys

# three-byte instructions whose operand is an address
THREE = {0x01, 0x11, 0x21, 0x31, 0x22, 0x2A, 0x32, 0x3A, 0xC3, 0xCD,
         0xC2, 0xCA, 0xD2, 0xDA, 0xE2, 0xEA, 0xF2, 0xFA,
         0xC4, 0xCC, 0xD4, 0xDC, 0xE4, 0xEC, 0xF4, 0xFC}


def listing_starts(path):
    """Instruction start addresses from a dis8080.py listing."""
    starts = set()
    for line in open(path):
        m = re.match(r'^\S*\s+\S.*?;\s+([0-9A-F]{4})\s+((?:[0-9a-f]{2} ?)+)$', line)
        if not m or line.lstrip().startswith('.db'):
            continue
        starts.add(int(m.group(1), 16))
    return starts


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--listing', required=True, help='dis8080.py listing of infile')
    p.add_argument('--org', default='0x100')
    p.add_argument('--lo', default='0xA000')
    p.add_argument('--hi', default='0xBFFF')
    p.add_argument('--delta', default='-0x5000')
    p.add_argument('--dry-run', action='store_true')
    p.add_argument('--vars-only', action='store_true',
                   help='only LDA/STA/LHLD/SHLD operands -- true variable accesses. '
                        'LXI and MVI H load pointers that may address the screen, '
                        'which lives in the same window and must not move.')
    args = p.parse_args()

    org = int(args.org, 0)
    lo, hi = int(args.lo, 0), int(args.hi, 0)
    delta = int(args.delta, 0)
    data = bytearray(open(args.infile, 'rb').read())
    starts = listing_starts(args.listing)

    # MVI H,<page> loads the high byte of a work-area pointer directly; a
    # relocation that only rewrites three-byte operands leaves those pointing at
    # the old area, and the program keeps half its variables in the bank window.
    pages = []
    for off in range(len(data) - 1) if not args.vars_only else []:
        addr = org + off
        if data[off] != 0x26 or addr not in starts:
            continue
        page = data[off + 1]
        if not (lo >> 8 <= page <= hi >> 8):
            continue
        new_page = page + (delta >> 8)
        pages.append((addr, page, new_page))
        if not args.dry_run:
            data[off + 1] = new_page & 0xFF

    patched, skipped = [], []
    for off in range(len(data) - 2):
        addr = org + off
        ops = {0x3A, 0x32, 0x2A, 0x22} if args.vars_only else THREE
        if data[off] not in ops:
            continue
        tgt = data[off + 1] | (data[off + 2] << 8)
        if not (lo <= tgt <= hi):
            continue
        if addr not in starts:
            skipped.append((addr, tgt))
            continue
        new = tgt + delta
        if not (0 <= new <= 0xFFFF):
            sys.exit('relocated address out of range at %04X' % addr)
        if org <= new < org + len(data):
            sys.exit('relocated address %04X at %04X lands inside the image' %
                     (new, addr))
        patched.append((addr, tgt, new))
        if not args.dry_run:
            data[off + 1] = new & 0xFF
            data[off + 2] = new >> 8

    if not args.dry_run:
        open(args.outfile, 'wb').write(bytes(data))

    lows = [t for _, t, _ in patched]
    print('patched %d operands and %d MVI H page loads, %+d bytes' %
          (len(patched), len(pages), delta))
    for addr, old, new in pages:
        print('  %04X: MVI H,%02Xh -> %02Xh' % (addr, old, new))
    if lows:
        print('  work area %04X..%04X -> %04X..%04X' %
              (min(lows), max(lows), min(lows) + delta, max(lows) + delta))
    print('skipped %d byte patterns not decoded as instructions' % len(skipped))
    if skipped:
        print('  ' + ' '.join('%04X' % a for a, _ in skipped[:20]) +
              (' ...' if len(skipped) > 20 else ''))


if __name__ == '__main__':
    main()
