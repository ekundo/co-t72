#!/bin/sh
# Собрать VDE.COM под T-72 из авторского исходника.
#
#   vde/fetch-src.sh     -- один раз: добыть и распаковать исходник
#   vde/build.sh         -- собрать
#
# Авторского исходника в репозитории нет (см. fetch-src.sh), поэтому сборка
# идёт в work/vde: там распакованный оригинал, машинный перевод и результат.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
WORK=$ROOT/work/vde
SRC=$WORK/src
GEN=$WORK/gen

[ -f "$SRC/vdx1.asm" ] || { echo "нет исходника VDE -- запусти vde/fetch-src.sh" >&2; exit 1; }

mkdir -p "$GEN"
python3 "$HERE/z80to8080.py" "$SRC/vdx1.asm" "$SRC/vdx2.asm" "$SRC/vdx3.asm" \
    -o "$GEN" -v "$HERE/overrides.asm" -v "$HERE/t72-profile.asm" -v "$HERE/koi8.asm" \
    -s "$HERE/vde-t72.asm" -s "$HERE/runtime.asm" \
    -r "$WORK/report.txt" >"$WORK/translate.log"
tail -n +1 "$WORK/translate.log" | sed -n '1,6p'

# INCLUDE считается от файла, где он написан, -- кладём верхний файл рядом с переводом
cp "$HERE/vde-t72.asm" "$GEN/"
cp "$HERE/runtime.asm" "$GEN/runtime.a80"

python3 "$ROOT/tools/asm8080.py" "$GEN/vde-t72.asm" -o "$WORK/VDE.COM" -l "$WORK/vde.lst" >/dev/null
echo "VDE.COM: $(stat -f%z "$WORK/VDE.COM") байт"
