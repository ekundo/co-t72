#!/usr/bin/env python3
"""Recode a CO text block from KOI-7 to KOI-8 in place.

CO stores its banner in KOI-7 and selects the matching font with the single-byte
control 0Eh ("русский набор"). T-72's monitor has no 0Eh control and no KOI-7
font at all -- 1B 5C, which is KOI-7 on T-34, selects CP866 there. So the text
has to move to KOI-8, which both monitors support: KOI-8 = KOI-7 | 80h.

The block is stored complemented (the print loop at 3EB3 does CMA before each
character), so the transform works on ~byte. Bytes that are an argument of an
escape sequence are left alone -- they are not text.
"""

import argparse


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--at', required=True, help='address of the block, e.g. 0x3FB8')
    p.add_argument('--len', required=True, help='length in bytes, e.g. 0x67')
    p.add_argument('--org', default='0x100')
    args = p.parse_args()

    org = int(args.org, 0)
    at = int(args.at, 0) - org
    n = int(args.len, 0)
    d = bytearray(open(args.infile, 'rb').read())

    def shown(i):
        return (~d[at + i]) & 0xFF

    before = bytes(shown(i) for i in range(n))
    recoded = escaped = 0
    for i in range(n):
        c = shown(i)
        if i and shown(i - 1) == 0x1B:      # argument of an escape sequence
            escaped += 1
            continue
        if c == 0x0E:                       # "русский набор" -- no such control in T-72
            d[at + i] = (~0x0D) & 0xFF      # harmless second CR instead
            continue
        if 0x40 <= c <= 0x7F:               # Cyrillic in KOI-7
            d[at + i] &= 0x7F               # -> same letter in KOI-8
            recoded += 1

    open(args.outfile, 'wb').write(bytes(d))
    after = bytes(shown(i) for i in range(n))
    print('recoded %d characters, left %d escape arguments alone' % (recoded, escaped))
    print('  before: %r' % before.decode('koi8-r', 'replace')[:70])
    print('  after:  %r' % after.decode('koi8-r', 'replace')[:70])


if __name__ == '__main__':
    main()
