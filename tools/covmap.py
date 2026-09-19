#!/usr/bin/env python3
"""Что из кода CO прогон ни разу не исполнил -- список по подпрограммам.

    COVDIR=/tmp/карты ./check-funcs.sh out/     # снять карты исполнения
    ./tools/covmap.py /tmp/карты                # свести и показать

Карты исполнения снимает v06x, по одной на сценарий: в них отмечен каждый
адрес, с которого была взята команда. Отмечается только первый байт команды,
операнды остаются нулями, поэтому считать проценты по байтам нельзя -- в
знаменателе будет вдвое больше, чем вообще может быть отмечено. Считаем по
командам: сколько строк листинга исполнялось хоть раз.

Границы подпрограмм и их описания берутся из листинга co-src/co.asm: каждая
подпрограмма, к которой кто-то обращается, там снабжена пояснением, и в отчёт
идёт его первая строка.

Данные (строки .db) в счёт не идут: они и не должны исполняться. Не идут и
дыры образа -- нули, которые дизассемблер показал как NOP.
"""

import argparse
import glob
import pathlib
import re
import sys

ORG = 0x100
ADDR = re.compile(r';\s*([0-9A-F]{4})\s')
HERE = pathlib.Path(__file__).resolve().parent
ASM = HERE.parent / 'co-src' / 'co.asm'


def listing(com):
    """Строки листинга: (адрес, это команда?, метка?, пояснение над ней)."""
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
            a = int(m.group(1), 16)
            code = ('.db' not in ln and '.dw' not in ln
                    and a - ORG < len(com) and com[a - ORG] != 0)
            rows.append((a, code, ln.startswith('L_'), note))
        note = None
    return rows


def main():
    p = argparse.ArgumentParser()
    p.add_argument('dir', help='каталог с картами *.cov от check-funcs.sh')
    p.add_argument('com', nargs='?', default=str(HERE.parent / 'work' / 'co' / 'co.com'),
                   help='оригинальный co.com -- по нему видно, где в образе дыры')
    p.add_argument('--top', type=int, default=25,
                   help='сколько самых крупных непокрытых кусков показать')
    a = p.parse_args()

    files = sorted(pathlib.Path(a.dir).glob('*.cov'))
    if not files:
        sys.exit('карт нет: %s/*.cov' % a.dir)
    hot = bytearray(0x10000)
    for f in files:
        for i, b in enumerate(f.read_bytes()):
            if b:
                hot[i + ORG] = 1

    rows = listing(pathlib.Path(a.com).read_bytes())
    # подпрограммы: от метки до следующей метки, только команды
    parts = []
    cur = None
    for i, (addr, code, label, note) in enumerate(rows):
        if label:
            cur = [addr, [], note]
            parts.append(cur)
        if cur is not None and code:
            cur[1].append(addr)

    total = done = 0
    cold = []
    for beg, addrs, note in parts:
        if not addrs:
            continue
        hits = sum(1 for x in addrs if hot[x])
        total += len(addrs)
        done += hits
        if hits == 0:
            cold.append((len(addrs), beg, addrs[-1], note))

    print('карт: %d, команд в листинге %d, исполнялось %d (%d%%)'
          % (len(files), total, done, 100 * done // max(total, 1)))
    print('подпрограмм без единой исполненной команды: %d' % len(cold))
    print()
    for n, beg, end, note in sorted(cold, reverse=True)[:a.top]:
        print('  %04X-%04X %4d  %s' % (beg, end, n, (note or '')[:70]))


if __name__ == '__main__':
    main()
