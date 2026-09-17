#!/usr/bin/env python3
"""Что из кода CO прогон ни разу не исполнил -- список по подпрограммам.

    COVDIR=/tmp/карты ./check-funcs.sh out/     # снять карты исполнения
    ./tools/covmap.py /tmp/карты                # свести и показать

Карты исполнения (по байту на адрес, ненулевой -- исполнялся) снимает v06x, по
одной на сценарий. Здесь они складываются, а границы подпрограмм и их описания
берутся из листинга co-src/co.asm: каждая подпрограмма, к которой кто-то
обращается, там снабжена пояснением, и в отчёт идёт его первая строка.

Данные (строки .db) в счёт не идут: они и не должны исполняться.
"""

import argparse
import pathlib
import re
import sys

ORG = 0x100
ADDR = re.compile(r';\s*([0-9A-F]{4})\s')
ASM = pathlib.Path(__file__).resolve().parent.parent / 'co-src' / 'co.asm'


def listing():
    """Строки листинга: адрес -> (это команда?, метка?, пояснение над ней)."""
    rows = []
    note = None
    for ln in ASM.read_text().split('\n'):
        if ln.startswith(';'):
            txt = ln.lstrip('; ').rstrip()
            if txt and not set(txt) <= set('=-'):
                note = txt if note is None else note
            continue
        m = ADDR.search(ln)
        if m:
            is_data = '.db' in ln or '.dw' in ln
            label = ln.startswith('L_')
            rows.append((int(m.group(1), 16), is_data, label, note))
        note = None
    return rows


def main():
    p = argparse.ArgumentParser()
    p.add_argument('dir', help='каталог с картами *.cov от check-funcs.sh')
    p.add_argument('--top', type=int, default=25,
                   help='сколько самых крупных непокрытых кусков показать')
    a = p.parse_args()

    files = sorted(pathlib.Path(a.dir).glob('*.cov'))
    if not files:
        sys.exit('карт нет: %s/*.cov' % a.dir)
    cov = bytearray(len(files[0].read_bytes()))
    for f in files:
        d = f.read_bytes()
        for i, b in enumerate(d):
            if b:
                cov[i] = 1

    rows = listing()
    # подпрограммы: от метки до следующей метки, только команды
    parts = []
    cur = None
    for i, (addr, is_data, label, note) in enumerate(rows):
        nxt = rows[i + 1][0] if i + 1 < len(rows) else 0x4100
        if label:
            cur = [addr, addr, note]
            parts.append(cur)
        if cur is None:
            continue
        if is_data:
            continue
        cur[1] = nxt

    code = hit = 0
    cold = []
    for beg, end, note in parts:
        n = end - beg
        if n <= 0:
            continue
        done = sum(1 for x in range(beg, end) if cov[x - ORG])
        code += n
        hit += done
        if done == 0:
            cold.append((n, beg, end, note))

    print('карт: %d, кода в листинге %d байт, исполнялось %d (%d%%)'
          % (len(files), code, hit, 100 * hit // max(code, 1)))
    print('подпрограмм без единого исполненного байта: %d' % len(cold))
    print()
    for n, beg, end, note in sorted(cold, reverse=True)[:a.top]:
        print('  %04X-%04X %5d  %s' % (beg, end - 1, n, (note or '')[:70]))


if __name__ == '__main__':
    main()
