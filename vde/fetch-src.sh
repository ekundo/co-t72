#!/bin/sh
# Добыть авторский исходник VDE и распаковать его в work/vde/src.
#
# В репозитории исходника нет намеренно: Мейер публично говорил, что согласия
# на публикацию своего кода не давал. Здесь только то, что написано нами, --
# перевод на 8080 делается из добытого оригинала на месте.
#
# vde267sc.lbr -- VDE 2.67b от 14.10.1988 с Walnut Creek CD, 88 КБ, шесть
# файлов: vde/vdm (сборочные обвязки), vdx1..3 (сам редактор), vi (VINSTALL).
# Файлы внутри сжаты CRUNCH-ем, поэтому рядом собирается lbrate -- он умеет и
# разбирать .lbr, и распаковывать.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
WORK=$(cd "$HERE/.." && pwd)/work/vde
LBR=http://cpmarchives.classiccmp.org//cpm/Software/WalnutCD/enterprs/cpm/utils/s/vde267sc.lbr
LBRATE=https://www.ibiblio.org/pub/linux/utils/compress/lbrate-1.1.tar.gz

mkdir -p "$WORK/src"
cd "$WORK"

if [ ! -x lbrate ]; then
    echo "собираю lbrate"
    curl -sL --max-time 120 -o lbrate.tar.gz "$LBRATE"
    tar xzf lbrate.tar.gz
    cc -O2 -w -o lbrate lbrate-1.1/main.c lbrate-1.1/readlzw.c \
        lbrate-1.1/readhuff.c lbrate-1.1/readlzh.c lbrate-1.1/readrle.c
fi

if [ ! -f src/vdx1.asm ]; then
    echo "качаю $LBR"
    curl -sL --max-time 120 -o src/vde267sc.lbr "$LBR"
    (cd src && ../lbrate vde267sc.lbr)
fi

ls -l src/*.asm
echo "готово -- дальше vde/build.sh"
