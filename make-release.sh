#!/bin/sh
# Собрать выпуск: по архиву и образу квазидиска на каждую сборку T-72.
#
#   ./make-release.sh work/co/co.com work/os-t72/os-t72.edd release/ [каталог образов системы]
#
# Четвёртым аргументом -- каталог с os-t72{f,h,hx,k}.rom; по умолчанию берутся
# из t72/ -- это сборка ImproverX от 15.09.2026, см. t72/README.md. Образ из
# клона T-72 не годится: там исходники 2022 года, без таблицы оборудования.
# В архивы образ кладётся как есть: сборка CO подстраивается
# под ту, с которой собрана, и подсунуть чужую нельзя -- см. README.
#
# На каждую сборку три файла: co-t72X.zip -- каталог co-t72X с CO и его
# комплектом, HDIR на двух языках, образом системы и README.txt; co-t72X.fdd --
# загрузочная дискета с системой и тем же комплектом; co-t72X.edd -- готовый
# квазидиск с системой, CO, HDIR и автозапуском.
set -e

CO=${1:?оригинальный co.com}
EDD=${2:?подлинный os-t72.edd как основа}
OUT=${3:-release}
HERE=$(cd "$(dirname "$0")" && pwd)
ROMS=${4:-$HERE/t72}
ROMS=$(cd "$ROMS" && pwd)
CO=$(cd "$(dirname "$CO")" && pwd)/$(basename "$CO")
EDD=$(cd "$(dirname "$EDD")" && pwd)/$(basename "$EDD")
CODIR=$(dirname "$CO")
mkdir -p "$OUT"
OUT=$(cd "$OUT" && pwd)
WORK=$OUT/.build
rm -rf "$WORK"; mkdir -p "$WORK"

VERSION=$(sed -n "s/^TEXT = \['Версия \([0-9.]*\).*/\1/p" "$HERE/tools/banner.py")
[ -n "$VERSION" ] || { echo "не понял версию из tools/banner.py" >&2; exit 1; }
echo "выпуск CO $VERSION"

# HDIR -- один на все сборки: адрес ОС в нём единственный и одинаковый.
python3 "$HERE/tools/asm8080.py" "$HERE/tools/hdir.asm"    -o "$WORK/HDIR.COM"   >/dev/null
python3 "$HERE/tools/asm8080.py" "$HERE/tools/hdir-en.asm" -o "$WORK/HDIREN.COM" >/dev/null
echo "HDIR: $(stat -f%z "$WORK/HDIR.COM") байт, HDIREN: $(stat -f%z "$WORK/HDIREN.COM") байт"

for v in f h hx k; do
    rom=$ROMS/os-t72$v.rom
    [ -f "$rom" ] || { echo "нет образа системы: $rom" >&2; exit 1; }
    name=co-t72$v
    echo
    echo "=== $name ==="
    "$HERE/patch-co.sh" "$CO" "$EDD" "$WORK/$v" "$rom" >"$WORK/$v.log" 2>&1 || {
        tail -20 "$WORK/$v.log" >&2; echo "сборка $v не удалась" >&2; exit 1; }
    grep -E 'обработчик БСВВ на|таблица дискет НЖМД на|перенос хвоста' "$WORK/$v.log" || true

    kit=$WORK/kit-$v/$name
    mkdir -p "$kit"
    cp "$WORK/$v/CO.COM" "$kit/"
    for f in co.prm co.mnu co.ext co.hlp co.zgr; do
        cp "$CODIR/$f" "$kit/$(echo "$f" | tr a-z A-Z)"
    done
    cp "$WORK/HDIR.COM" "$WORK/HDIREN.COM" "$kit/"
    cp "$rom" "$kit/"
    sh "$HERE/tools/relnote.sh" "$v" "$VERSION" > "$kit/README.txt"

    # HDIR кладём и на квазидиск: patch-co.sh собирает образ только с CO.
    python3 "$HERE/tools/kdimg.py" put "$WORK/$v/co-t72.edd" "$WORK/HDIR.COM"   >/dev/null
    python3 "$HERE/tools/kdimg.py" put "$WORK/$v/co-t72.edd" "$WORK/HDIREN.COM" >/dev/null

    ( cd "$WORK/kit-$v" && rm -f "$OUT/$name.zip" && zip -qr "$OUT/$name.zip" "$name" )
    cp "$WORK/$v/co-t72.fdd" "$OUT/$name.fdd"
    cp "$WORK/$v/co-t72.edd" "$OUT/$name.edd"
    echo "  $name: zip $(stat -f%z "$OUT/$name.zip") байт, fdd $(stat -f%z "$OUT/$name.fdd") байт, edd $(stat -f%z "$OUT/$name.edd") байт"
done

rm -rf "$WORK"
echo
echo "готово: $OUT"
ls -la "$OUT"
