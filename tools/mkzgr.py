#!/usr/bin/env python3
"""CO.ZGR -- список файлов, которые CO переносит на C: при запуске с дискеты.

    ./mkzgr.py -o out/CO.ZGR [--vde]

Запущенная не с `C:`, CO переносит туда свой обиход: читает этот список
строками и копирует файл за файлом (`3EDF`), пока не встретит строку с точкой.
Имён в списке может не быть на дискете -- такие строки сборка пропускает
(co-src/zgrcheck.asm), пустышек на `C:` они больше не заводят.

Список здесь, а не в образе, по двум причинам. Первая: в комплекте выпуска и
на готовой дискете лежали разные `CO.ZGR` -- на дискете список рабочего диска
на два десятка имён, а в архиве авторский на восемь, где половины файлов в
выпуске нет вовсе (`FORMATM.COM`), зато нет `HDIR.COM`, который есть. Вторая:
редактор. Его в списке не было, потому что и самого редактора не было.

Порядок -- как на рабочем диске: сперва всё чужое, потом обиход самой CO и
система. Он же и порядок переноса, а места на `C:` может не хватить.
"""

import argparse

# Чужие программы, на которые ссылаются CO.MNU и CO.EXT. ARC2 не ссылка, а
# нужда: распаковку архива CO отдаёт ему, и без него в .PK2 видно только
# список.
OTHER = ['SAVEASM.COM', 'SAVEBAS.COM', 'SAVEDOS.COM', 'SAVEMON.COM',
         'SAVEROM.COM', 'SYSGEN.COM', 'KOD.COM', 'RUND.COM', 'GO.COM',
         'SID.COM', 'ARC2.COM', 'MEDIT.HLP', 'MEDIT.COM']
# Редактор на «СС»-«4» и его краткая справка -- русская, та же, что лежит на
# готовом квазидиске. Руководств в списке нет нарочно: наше на 28 КБ, авторское
# VDE266.DOC на 51 КБ, а место на квазидиске не бесконечное.
VDE = ['VDE.COM', 'VDE.QRF']
# Своё: HDIR -- наш, остальное -- обиход CO и система.
OURS = ['HDIR.COM', 'CO.HLP', 'CO.PRM', 'CO.MNU', 'CO.EXT', 'CO.COM',
        'INITIALC.SUB', 'OS.COM']

RECORD = 128
PAD = 0x1A                      # конец текстового файла в CP/M


def build(with_vde=True):
    names = OTHER + (VDE if with_vde else []) + OURS
    out = bytearray()
    for n in names + ['.']:
        out += n.encode('ascii') + b'\r\n'
    out += bytes([PAD] * (-len(out) % RECORD))
    return bytes(out), names


def main():
    p = argparse.ArgumentParser(description='список переноса CO.ZGR')
    p.add_argument('-o', '--out', required=True, help='куда записать')
    p.add_argument('--vde', action='store_true',
                   help='с редактором VDE и его справкой')
    a = p.parse_args()
    data, names = build(a.vde)
    open(a.out, 'wb').write(data)
    print('CO.ZGR: %d имён, %d байт (%d запис%s)'
          % (len(names), len(data), len(data) // RECORD,
             'ь' if len(data) // RECORD == 1 else 'и'))


if __name__ == '__main__':
    main()
