#!/usr/bin/env python3
"""Обмен CO с диском через буфер вне окна A000-DFFF.

    ./dmawin.py CO.COM out.com

Сам код -- в dmawin.asm, здесь только сборка и врезки. Накладка остаётся по
адресу загрузки: она ниже A000, и хвост под стеком на неё не тратится.

Врезок пять, все одинаковые шесть байт: "CALL 17F4 / CALL 1922" -- установить
адрес буфера и прочитать запись (1496 -- чтение CO.PRM, 187D и 188B -- первые
записи файла, 18C8 -- цикл чтения в просмотрщике), и та же пара с 1947 по 1461
-- запись CO.PRM. Меняются на вызов накладки и три NOP.
"""

import argparse
import os
import sys

import asm8080

ORG = 0x100
PAIR = bytes([0xCD, 0xF4, 0x17])            # CALL SETDMA
READ = PAIR + bytes([0xCD, 0x22, 0x19])     # ... CALL чтения записи
WRITE = PAIR + bytes([0xCD, 0x47, 0x19])    # ... CALL записи
READS = [0x1496, 0x187D, 0x188B, 0x18C8]
WRITES = [0x1461]

# Быстрый путь CO мимо БДОС: прямые вызовы секторных подпрограмм БСВВ. Тут
# меняется только адрес в вызове -- три байта на три.
BIOS = [(0xC027, 'brd', [0x16D2, 0x1C35, 0x1C7F, 0x1CA1, 0x1DD3]),
        (0xC02A, 'bwr', [0x1770, 0x1DC2])]


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile')
    p.add_argument('outfile')
    p.add_argument('--at', help='адрес, по которому накладка будет работать')
    a = p.parse_args()

    d = bytearray(open(a.infile, 'rb').read())
    org = ORG + len(d)
    run = int(a.at, 16) if a.at else org

    asm = asm8080.Asm()
    asm.sym.update({'ORIGIN': run})
    src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'dmawin.asm')
    _, body = asm.assemble(src)

    for addrs, was, label in ((READS, READ, 'read'), (WRITES, WRITE, 'write')):
        entry = asm.sym[label]
        for addr in addrs:
            off = addr - ORG
            if bytes(d[off:off + 6]) != was:
                sys.exit('по %04X не та пара вызовов, а %s'
                         % (addr, d[off:off + 6].hex()))
            d[off:off + 6] = bytes([0xCD, entry & 0xFF, entry >> 8, 0, 0, 0])

    for target, label, addrs in BIOS:
        entry = asm.sym[label]
        for addr in addrs:
            off = addr - ORG
            if d[off] not in (0xCD, 0xC3) or d[off + 1] != (target & 0xFF) \
                    or d[off + 2] != target >> 8:
                sys.exit('по %04X не вызов %04X, а %s'
                         % (addr, target, d[off:off + 3].hex()))
            d[off + 1] = entry & 0xFF
            d[off + 2] = entry >> 8
    d += body

    open(a.outfile, 'wb').write(bytes(d))
    where = ('%04X (в окне, исходник по %04X)' % (run, org)) if a.at \
        else '%04X (по адресу загрузки)' % org
    print('обмен через буфер вне окна: %d байт по %s, '
          'врезок %d через БДОС и %d в БСВВ'
          % (len(body), where, len(READS) + len(WRITES),
             sum(len(x) for _, _, x in BIOS)))
    if a.at:
        print('winnext=%04X' % (run + len(body)))


if __name__ == '__main__':
    main()
