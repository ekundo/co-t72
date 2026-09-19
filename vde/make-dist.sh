#!/bin/sh
# Собрать выпуск VDE: архив с программой, заметкой и карточкой клавиш.
#
#   vde/build.sh        # сперва собрать VDE.COM
#   vde/make-dist.sh    # -> release/vde-t72.zip
#
# Комплекта у VDE нет: вся настройка лежит внутри самой программы, отдельных
# файлов рядом ей не нужно. Поэтому в архиве только VDE.COM, заметка и карточка.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
COM=$ROOT/work/vde/VDE.COM
OUT=${1:-$ROOT/release}

[ -f "$COM" ] || { echo "нет $COM -- сперва vde/build.sh" >&2; exit 1; }

mkdir -p "$OUT"
OUT=$(cd "$OUT" && pwd)
WORK=$OUT/.vde-dist
rm -rf "$WORK"
mkdir -p "$WORK/vde-t72"

cp "$COM" "$WORK/vde-t72/VDE.COM"
cp "$ROOT/docs/vde-keys.svg" "$WORK/vde-t72/VDE-KEYS.svg"
sh "$HERE/relnote.sh" "$COM" > "$WORK/vde-t72/README.txt"
# Авторская документация из выпуска VDE: руководство и краткая справка.
for doc in vde266.doc vde266.qrf vinst266.doc; do
    [ -f "$ROOT/work/vde/dist/$doc" ] && cp "$ROOT/work/vde/dist/$doc" \
        "$WORK/vde-t72/$(echo "$doc" | tr a-z A-Z)"
done

( cd "$WORK" && rm -f "$OUT/vde-t72.zip" && zip -qr "$OUT/vde-t72.zip" vde-t72 )
rm -rf "$WORK"

echo "vde-t72.zip: $(stat -f%z "$OUT/vde-t72.zip") байт"
unzip -l "$OUT/vde-t72.zip" | sed -n '4,9p'
