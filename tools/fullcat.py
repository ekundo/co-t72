#!/usr/bin/env python3
"""Забить каталог дискеты до отказа -- образ для обмера буферов.

    ./tools/fullcat.py out/co-t72.fdd /tmp/полный.fdd [--keep 4]

Зачем. Список файлов панели CO занимает 680h байт на панель (128 строк по 13),
и лежат эти списки с A954. На обычном тестовом образе файлов два десятка, списки
заполнены на четверть, и карта окна (tools/winmap.py) показывает свободным то,
что на самом деле зарезервировано под список. Чтобы увидеть настоящие границы,
нужен образ, где каталог забит.

Дописываем в копию образа короткие файлы -- по одной записи каждый, -- пока не
кончатся места в каталоге. `--keep` оставляет несколько свободных: столько же
нужно самому CO, когда он туда что-нибудь пишет.
"""

import argparse
import pathlib
import shutil
import subprocess
import sys

HERE = pathlib.Path(__file__).resolve().parent


def used(img):
    out = subprocess.run([sys.executable, str(HERE / 'cpmimg.py'), 'list', str(img)],
                         capture_output=True, text=True).stdout
    for ln in out.split('\n'):
        if 'directory entries used' in ln:
            return tuple(int(x) for x in ln.split()[0].split('/'))
    sys.exit('не понял, сколько записей в каталоге: %s' % img)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('infile', help='образ дискеты, который берём за основу')
    p.add_argument('outfile', help='куда положить забитый')
    p.add_argument('--keep', type=int, default=4,
                   help='сколько записей каталога оставить свободными')
    a = p.parse_args()

    shutil.copy(a.infile, a.outfile)
    was, total = used(a.outfile)
    tmp = pathlib.Path(a.outfile).with_suffix('.заполнитель')
    tmp.write_bytes(b'\x1a' * 128)      # одна запись CP/M, меньше не бывает
    made = 0
    for i in range(total):
        now, _ = used(a.outfile)
        if now >= total - a.keep:
            break
        name = 'FILL%03d.TST' % i
        r = subprocess.run([sys.executable, str(HERE / 'cpmimg.py'), 'put',
                            str(a.outfile), str(tmp), name],
                           capture_output=True, text=True)
        if r.returncode:
            print(r.stdout + r.stderr, file=sys.stderr)
            break
        made += 1
    tmp.unlink()
    now, total = used(a.outfile)
    print('каталог забит: было %d записей, стало %d из %d (дописано %d файлов)'
          % (was, now, total, made))


if __name__ == '__main__':
    main()
