#!/usr/bin/env python3
"""Intel 8080 disassembler with recursive traversal, for Vector-06C / MicroDOS .COM files.

Usage: dis8080.py <file.com> [--org 0x100] [--entry 0x100] [--out listing.asm]

Produces a listing plus a report of references that leave the image -- those are
the addresses that matter when moving a program between BIOS versions.
"""

import argparse
import sys
from collections import defaultdict

R = ['B', 'C', 'D', 'E', 'H', 'L', 'M', 'A']
RP = ['B', 'D', 'H', 'SP']
RP_PP = ['B', 'D', 'H', 'PSW']
ALU = ['ADD', 'ADC', 'SUB', 'SBB', 'ANA', 'XRA', 'ORA', 'CMP']
ALU_I = ['ADI', 'ACI', 'SUI', 'SBI', 'ANI', 'XRI', 'ORI', 'CPI']
CC = ['NZ', 'Z', 'NC', 'C', 'PO', 'PE', 'P', 'M']

# op -> (text, length, kind)
#   kind: 'n' normal, 'j' jump(abs), 'c' call(abs), 'r' return, 's' stop (no fallthrough)
OPS = {}


def _init():
    for op in range(256):
        OPS[op] = ('DB   %02Xh' % op, 1, 'n')
    for i, m in enumerate(['NOP'] * 8):
        OPS[i * 8] = (m, 1, 'n')  # 00,08,...,38 (08+ undocumented)
    for i in range(4):
        OPS[0x01 + i * 16] = ('LXI  %s,#' % RP[i], 3, 'n')
        OPS[0x09 + i * 16] = ('DAD  %s' % RP[i], 1, 'n')
        OPS[0x03 + i * 16] = ('INX  %s' % RP[i], 1, 'n')
        OPS[0x0B + i * 16] = ('DCX  %s' % RP[i], 1, 'n')
        OPS[0xC1 + i * 16] = ('POP  %s' % RP_PP[i], 1, 'n')
        OPS[0xC5 + i * 16] = ('PUSH %s' % RP_PP[i], 1, 'n')
    for r in range(8):
        OPS[0x04 + r * 8] = ('INR  %s' % R[r], 1, 'n')
        OPS[0x05 + r * 8] = ('DCR  %s' % R[r], 1, 'n')
        OPS[0x06 + r * 8] = ('MVI  %s,#' % R[r], 2, 'n')
    for d in range(8):
        for s in range(8):
            OPS[0x40 + d * 8 + s] = ('MOV  %s,%s' % (R[d], R[s]), 1, 'n')
    OPS[0x76] = ('HLT', 1, 's')
    for i, m in enumerate(ALU):
        for s in range(8):
            OPS[0x80 + i * 8 + s] = ('%-4s %s' % (m, R[s]), 1, 'n')
    for i, m in enumerate(ALU_I):
        OPS[0xC6 + i * 8] = ('%-4s #' % m, 2, 'n')
    OPS[0x02] = ('STAX B', 1, 'n')
    OPS[0x12] = ('STAX D', 1, 'n')
    OPS[0x0A] = ('LDAX B', 1, 'n')
    OPS[0x1A] = ('LDAX D', 1, 'n')
    OPS[0x22] = ('SHLD @', 3, 'n')
    OPS[0x2A] = ('LHLD @', 3, 'n')
    OPS[0x32] = ('STA  @', 3, 'n')
    OPS[0x3A] = ('LDA  @', 3, 'n')
    for op, m in [(0x07, 'RLC'), (0x0F, 'RRC'), (0x17, 'RAL'), (0x1F, 'RAR'),
                  (0x27, 'DAA'), (0x2F, 'CMA'), (0x37, 'STC'), (0x3F, 'CMC'),
                  (0xE3, 'XTHL'), (0xEB, 'XCHG'), (0xF3, 'DI'), (0xFB, 'EI'),
                  (0xF9, 'SPHL')]:
        OPS[op] = (m, 1, 'n')
    OPS[0xE9] = ('PCHL', 1, 's')
    OPS[0xD3] = ('OUT  #', 2, 'n')
    OPS[0xDB] = ('IN   #', 2, 'n')
    for i, c in enumerate(CC):
        OPS[0xC0 + i * 8] = ('R%-3s' % c, 1, 'n')
        OPS[0xC2 + i * 8] = ('J%-3s @' % c, 3, 'j')
        OPS[0xC4 + i * 8] = ('C%-3s @' % c, 3, 'c')
    OPS[0xC3] = ('JMP  @', 3, 'j')
    OPS[0xCB] = ('JMP  @', 3, 'j')          # undocumented alias
    OPS[0xCD] = ('CALL @', 3, 'c')
    for op in (0xDD, 0xED, 0xFD):
        OPS[op] = ('CALL @', 3, 'c')        # undocumented aliases
    OPS[0xC9] = ('RET', 1, 'r')
    OPS[0xD9] = ('RET', 1, 'r')             # undocumented alias
    for i in range(8):
        OPS[0xC7 + i * 8] = ('RST  %d' % i, 1, 'n')
    # unconditional jumps do not fall through
    for op in (0xC3, 0xCB):
        t, ln, _ = OPS[op]
        OPS[op] = (t, ln, 'j')


_init()


class Dis:
    def __init__(self, data, org, entries):
        self.d = data
        self.org = org
        self.end = org + len(data)
        self.code = set()          # addresses that start an instruction
        self.labels = {}           # addr -> kind ('code'/'data')
        self.xrefs = defaultdict(set)   # target -> {source addrs}
        self.entries = list(entries)

    def inside(self, a):
        return self.org <= a < self.end

    def byte(self, a):
        return self.d[a - self.org]

    def word(self, a):
        return self.d[a - self.org] | (self.d[a - self.org + 1] << 8)

    def seed_from_scan(self, min_hits=2):
        """Add likely entry points: targets of CALL/JMP byte patterns anywhere in the image.

        Indirect dispatch through jump tables leaves large regions unreachable from a
        pure recursive walk; a target referenced from several places is almost always
        real code, so it is worth tracing from.
        """
        hits = defaultdict(int)
        for off in range(len(self.d) - 2):
            op = self.d[off]
            if op in (0xC3, 0xCD, 0xC2, 0xCA, 0xD2, 0xDA, 0xE2, 0xEA, 0xF2, 0xFA,
                      0xC4, 0xCC, 0xD4, 0xDC, 0xE4, 0xEC, 0xF4, 0xFC):
                t = self.d[off + 1] | (self.d[off + 2] << 8)
                if self.inside(t):
                    hits[t] += 1
        added = [t for t, n in hits.items() if n >= min_hits and t not in self.code]
        self.entries.extend(added)
        return len(added)

    def byte_coverage(self):
        n = 0
        for a in self.code:
            n += OPS[self.byte(a)][1]
        return n

    def trace(self):
        todo = list(self.entries)
        seen = set(self.code)
        while todo:
            pc = todo.pop()
            while True:
                if pc in seen or not self.inside(pc):
                    break
                seen.add(pc)
                self.code.add(pc)
                op = self.byte(pc)
                text, ln, kind = OPS[op]
                if pc + ln > self.end:
                    break
                target = None
                if '@' in text and ln == 3:
                    target = self.word(pc + 1)
                    self.xrefs[target].add(pc)
                    if kind in ('j', 'c') and self.inside(target):
                        self.labels.setdefault(target, 'code')
                        todo.append(target)
                    elif kind == 'n' and self.inside(target):
                        self.labels.setdefault(target, 'data')
                if kind in ('r', 's'):
                    break
                if kind == 'j':
                    if target is not None and OPS[op][2] == 'j' and op in (0xC3, 0xCB):
                        pc = target if self.inside(target) else None
                        if pc is None:
                            break
                        continue
                pc += ln

    def render(self, out):
        # label names
        def lab(a):
            if self.inside(a):
                return 'L_%04X' % a
            return '%04Xh' % a

        w = out.write
        a = self.org
        while a < self.end:
            if a in self.code:
                op = self.byte(a)
                text, ln, kind = OPS[op]
                raw = self.d[a - self.org:a - self.org + ln]
                if '@' in text:
                    t = self.word(a + 1)
                    text = text.replace('@', lab(t))
                elif '#' in text:
                    text = text.replace('#', '%02Xh' % self.byte(a + 1) if ln == 2 else '')
                    if ln == 3:
                        text = OPS[op][0].replace('#', '%04Xh' % self.word(a + 1))
                name = ('L_%04X:' % a) if a in self.labels or a in self.entries else ''
                w('%-8s %-24s ; %04X %s\n' % (name, text, a, raw.hex(' ')))
                a += ln
            else:
                run = []
                start = a
                while a < self.end and a not in self.code:
                    run.append(self.byte(a))
                    a += 1
                self.dump_data(w, start, run)

    def dump_data(self, w, start, run):
        for i in range(0, len(run), 16):
            chunk = run[i:i + 16]
            addr = start + i
            name = ('L_%04X:' % addr) if addr in self.labels else ''
            txt = ''.join(chr(c) if 32 <= c < 127 else '.' for c in chunk)
            w('%-8s .db %-48s ; %04X |%s|\n' %
              (name, ','.join('%02Xh' % c for c in chunk), addr, txt))


def main():
    p = argparse.ArgumentParser()
    p.add_argument('file')
    p.add_argument('--org', default='0x100')
    p.add_argument('--entry', action='append', default=[])
    p.add_argument('--out', default=None)
    p.add_argument('--cov', default=None,
                   help='execution coverage bitmap (v06x V06X_COV_FILE): every '
                        'marked byte is a known instruction start and is used as '
                        'an entry point')
    p.add_argument('--auto', action='store_true',
                   help='also trace from branch targets found by scanning (jump tables)')
    p.add_argument('--min-hits', type=int, default=2,
                   help='how many references a scanned target needs before it is trusted')
    args = p.parse_args()

    data = open(args.file, 'rb').read()
    org = int(args.org, 0)
    entries = [int(e, 0) for e in args.entry] or [org]
    if args.cov:
        cov = open(args.cov, 'rb').read()
        entries += [org + i for i, b in enumerate(cov) if b]

    dis = Dis(data, org, entries)
    dis.trace()
    if args.auto:
        for _ in range(4):
            if not dis.seed_from_scan(args.min_hits):
                break
            dis.trace()

    out = open(args.out, 'w') if args.out else sys.stdout
    dis.render(out)
    if args.out:
        out.close()

    # report: references outside the image
    ext = defaultdict(set)
    for tgt, srcs in dis.xrefs.items():
        if not dis.inside(tgt):
            ext[tgt] |= srcs
    covered = len(dis.code)
    sys.stderr.write('image %04X-%04X  instructions=%d  bytes-as-code~%d/%d (%.0f%%)\n' %
                     (org, dis.end - 1, covered, covered, len(data),
                      100.0 * covered / len(data)))
    sys.stderr.write('\nexternal references (%d distinct targets):\n' % len(ext))
    for tgt in sorted(ext):
        srcs = sorted(ext[tgt])
        sys.stderr.write('  %04Xh  <- %s%s\n' % (
            tgt, ', '.join('%04X' % s for s in srcs[:8]),
            ' ...' if len(srcs) > 8 else ''))


if __name__ == '__main__':
    main()
