#!/bin/sh
# Прогнать сборку CO по всем интересным конфигурациям и свести результат в таблицу.
# Нужно, чтобы правки из разных веток можно было сверять одной командой, а не
# разглядывая кадры по одному.
#
#   ./check.sh out/CO.COM
#
# Показатели снимаются из карты исполнения: сработала ли ловушка вывода (1248),
# дошло ли дело до отрисовки (0D99) и до сортировки списка (1B95), и сколько
# адресов CO вообще исполнил -- это самый чувствительный индикатор прогресса.
set -e

CO=${1:?путь к патченному CO.COM}
HERE=$(cd "$(dirname "$0")" && pwd)
V06X=$HERE/tools/vector06sdl/build/v06x
ROM=$HERE/tools/MDOS_T-72/BIN/os-t72f.rom
RUN=$HERE/run
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

probe() {  # имя, дискета, квазидиск, сценарий
    name=$1; fdd=$2; edd=$3; scr=$4
    cov=$TMP/$name.cov
    if [ -n "$edd" ]; then set -- --edd "$edd"; else set --; fi
    ( cd "$RUN" && V06X_COV_LO=0x0100 V06X_COV_HI=0x40FF V06X_COV_FILE="$cov" \
        "$V06X" --rom "$ROM" --fdd "$fdd" "$@" \
        --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" --script "$scr" \
        --max-frame 2500 --save-frame 2499 --novideo --nosound >"$TMP/$name.log" 2>&1 ) || true
    # эмулятор падает при выходе (atexit против разрушения SDL), но эмуляция к
    # этому моменту уже закончена и карта записана -- поэтому код возврата не смотрим
    [ -s "$cov" ] || { echo "$name: карта не снята"; return; }
    python3 - "$cov" "$name" <<'PY'
import sys
cov = open(sys.argv[1], 'rb').read()
def hit(a): return 'да ' if cov[a - 0x100] else 'нет'
print('%-22s %-8s %-8s %-8s %d' % (
    sys.argv[2], hit(0x1248), hit(0x0D99), hit(0x1B95),
    sum(1 for b in cov if b)))
PY
}

# положить проверяемый CO на дискету и на квазидиск
cp "$HERE/work/t34/T34/os-t34.fdd" "$TMP/t.fdd"
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$TMP/t.fdd" "$CO" CO.COM >/dev/null
cp "$HERE/work/os-t72/os-t72.edd" "$TMP/t.edd"
python3 "$HERE/tools/kdimg.py" put "$TMP/t.edd" "$CO" CO.COM >/dev/null
printf 'CO\r\n' > "$TMP/initialc.sub"
for f in prm mnu ext hlp zgr; do
    python3 "$HERE/tools/cpmimg.py" --geom fdd put "$TMP/t.fdd" "$HERE/work/co/co.$f" >/dev/null
    python3 "$HERE/tools/kdimg.py" put "$TMP/t.edd" "$HERE/work/co/co.$f" >/dev/null
done
python3 "$HERE/tools/kdimg.py" put "$TMP/t.edd" "$TMP/initialc.sub" INITIALC.SUB >/dev/null

printf '%-22s %-8s %-8s %-8s %s\n' конфигурация ловушка отрисовка сортировка адресов
printf '%-22s %-8s %-8s %-8s %s\n' ---------------------- -------- --------- ---------- --------
probe автозапуск-с-C   "$TMP/t.fdd" "$TMP/t.edd" "$RUN/t72-auto.chai"
probe запуск-с-A       "$TMP/t.fdd" "$TMP/t.edd" "$RUN/t72-fromA.chai"
probe без-квазидиска   "$TMP/t.fdd" ""           "$RUN/co-boot.chai"

echo
echo "кадры: run/out/os-t72f_2499.png (последняя конфигурация)"
