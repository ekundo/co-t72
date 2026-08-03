#!/bin/sh
# Прогон стенда на Emu80 без окна и без человека.
#
#   ./emu80.sh out-hx/co-t72.edd [снимок ...]
#
# Поднимает T-72 с квазидиска, сам жмёт F12, отрабатывает заданное число кадров
# и выходит. Снимки указываются как `boot+900` (через 900 кадров после того, как
# система догрузилась) или просто номером кадра; каждый ложится в PNG рядом.
#
# Что можно поменять переменными окружения (полный список -- в шапке
# tools/emu80v4/src/sdl/emuAuto.cpp):
#
#   MAX=2500                   сколько кадров отработать
#   KEYS="boot+900:TAB,boot+1000:SS+7,boot+1100:3,boot+1160:ENTER"
#   HDD=~/Documents/vector.hdd образ винчестера
#   FDD=out-hx/co-t72.fdd      дискета в дисковод A
#
# Ни окна, ни звука нарочно: SDL берутся пустые драйверы, картинка снимается из
# буфера кадра. Смотреть глазами -- это Emu80qt, тут машина работает молча.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
STAND=$HERE/stand
[ -x "$STAND/Emu80lite" ] || { echo "нет стенда: сначала ./build-emu80.sh" >&2; exit 1; }

EDD=${1:?укажи образ квазидиска, например out-hx/co-t72.edd}
shift
abs() { echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"; }

OUT=${OUT:-$PWD/emu80-shot}
EMU80_FRAME_FILE=$OUT
EMU80_MAX_FRAME=${MAX:-2500}
EMU80_AUTOSTART=1
[ -n "$KEYS" ] && EMU80_KEYS=$KEYS
[ $# -gt 0 ] && EMU80_SAVE_FRAME=$(echo "$@" | tr ' ' ',')
export EMU80_FRAME_FILE EMU80_MAX_FRAME EMU80_AUTOSTART EMU80_KEYS EMU80_SAVE_FRAME
export SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy

set -- --platform vector --edd "$(abs "$EDD")"
[ -n "$FDD" ] && set -- "$@" --disk-a "$(abs "$FDD")"
[ -n "$HDD" ] && set -- "$@" --hdd "$(abs "$HDD")"

(cd "$STAND" && ./Emu80lite "$@")

# PPM -- чтобы обойтись без библиотек в самом эмуляторе; наружу отдаём PNG.
for ppm in "$OUT"-*.ppm; do
    [ -e "$ppm" ] || break
    sips -s format png "$ppm" --out "${ppm%.ppm}.png" >/dev/null
    rm "$ppm"
    echo "снимок: ${ppm%.ppm}.png"
done
