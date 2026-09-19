#!/bin/sh
# Собрать выпуск: по архиву и образу квазидиска на каждую сборку T-72.
#
#   ./make-release.sh work/co/co.com work/os-t72/os-t72.edd release/ [каталог с МикроДОС]
#
# Четвёртым аргументом -- каталог с os-t72{f,h,hx,k}.rom; по умолчанию берутся
# из t72/ -- это сборка ImproverX от 16.09.2026, см. t72/README.md. Образ из
# клона T-72 не годится: в его BIN сборка от 31.08.2026, без таблицы оборудования.
# В архивы образ кладётся как есть: сборка CO подстраивается
# под ту, с которой собрана, и подсунуть чужую нельзя -- см. README.
#
# На каждую сборку три файла: co-t72X.zip -- каталог co-t72X с CO и его
# комплектом, HDIR на двух языках, самой МикроДОС и README.txt; co-t72X.fdd --
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

# Версия -- из заставки в исходнике: она и попадает в собранный CO.COM.
VERSION=$(sed -n "s/.*'Версия \([0-9.]*\) от.*/\1/p" "$HERE/co-src/co.asm")
[ -n "$VERSION" ] || { echo "не понял версию из co-src/co.asm" >&2; exit 1; }
echo "выпуск CO $VERSION"

# Редактор в выпуск. VDE собирается из авторского исходника, которого в
# репозитории нет: его добывает vde/fetch-src.sh. Без редактора выпуск не
# собираем -- на клавише "СС"-"4" в CO стоит именно он.
VDECOM=$HERE/work/vde/VDE.COM
[ -f "$HERE/work/vde/src/vdx1.asm" ] || {
    echo "нет исходника VDE -- запусти vde/fetch-src.sh" >&2; exit 1; }
sh "$HERE/vde/build.sh" >"$OUT/.vde.log" 2>&1 || {
    tail -5 "$OUT/.vde.log" >&2; echo "VDE не собралась" >&2; exit 1; }
rm -f "$OUT/.vde.log"
echo "VDE.COM: $(stat -f%z "$VDECOM") байт"

# HDIR -- один на все сборки: адрес ОС в нём единственный и одинаковый.
python3 "$HERE/tools/asm8080.py" "$HERE/tools/hdir.asm"    -o "$WORK/HDIR.COM"   >/dev/null
python3 "$HERE/tools/asm8080.py" "$HERE/tools/hdir-en.asm" -o "$WORK/HDIREN.COM" >/dev/null
echo "HDIR: $(stat -f%z "$WORK/HDIR.COM") байт, HDIREN: $(stat -f%z "$WORK/HDIREN.COM") байт"

for v in f h hx k; do
    rom=$ROMS/os-t72$v.rom
    [ -f "$rom" ] || { echo "нет МикроДОС: $rom" >&2; exit 1; }
    name=co-t72$v
    echo
    echo "=== $name ==="
    "$HERE/patch-co.sh" "$CO" "$EDD" "$WORK/$v" "$rom" "$VDECOM" >"$WORK/$v.log" 2>&1 || {
        tail -20 "$WORK/$v.log" >&2; echo "сборка $v не удалась" >&2; exit 1; }
    grep -E 'обработчик БСВВ на|таблица дискет НЖМД на|перенос хвоста|WSR -> VDE' "$WORK/$v.log" || true

    kit=$WORK/kit-$v/$name
    mkdir -p "$kit"
    cp "$WORK/$v/CO.COM" "$kit/"
    for f in co.prm co.mnu co.ext co.hlp co.zgr; do
        # CO.HLP и CO.ZGR берём собранные сборкой -- см. tools/mkhlp.py и
        # tools/mkzgr.py; в комплекте должен лежать тот же список, что и на
        # готовой дискете, а раньше это были два разных файла.
        src=$CODIR/$f
        [ "$f" = co.hlp ] && [ -f "$WORK/$v/CO.HLP" ] && src=$WORK/$v/CO.HLP
        [ "$f" = co.zgr ] && [ -f "$WORK/$v/CO.ZGR" ] && src=$WORK/$v/CO.ZGR
        cp "$src" "$kit/$(echo "$f" | tr a-z A-Z)"
    done
    cp "$WORK/HDIR.COM" "$WORK/HDIREN.COM" "$kit/"
    cp "$VDECOM" "$kit/VDE.COM"
    for doc in vde266.doc vde266.qrf; do
        [ -f "$HERE/work/vde/dist/$doc" ] && cp "$HERE/work/vde/dist/$doc" \
            "$kit/$(echo "$doc" | tr a-z A-Z)"
    done
    cp "$rom" "$kit/"
    sh "$HERE/tools/relnote.sh" "$v" "$VERSION" > "$kit/README.txt"

    ( cd "$WORK/kit-$v" && rm -f "$OUT/$name.zip" && zip -qr "$OUT/$name.zip" "$name" )
    cp "$WORK/$v/co-t72.fdd" "$OUT/$name.fdd"
    cp "$WORK/$v/co-t72.edd" "$OUT/$name.edd"
    echo "  $name: zip $(stat -f%z "$OUT/$name.zip") байт, fdd $(stat -f%z "$OUT/$name.fdd") байт, edd $(stat -f%z "$OUT/$name.edd") байт"
done

rm -rf "$WORK"
echo
echo "готово: $OUT"
ls -la "$OUT"
