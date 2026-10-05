#!/bin/sh
# Проверить заставку вместо гашения монитора: C:CO.SCR, см. SCRSAV в листинге.
#
#   ./check-scr.sh out/            [os-t72f.rom]
#
# Три прогона на копии сборочного квазидиска, срок гашения -- самый короткий
# (единица в CO.PRM, около двух секунд):
#
#   звёзды, логотип -- на C: лежит CO.SCR. CO должна дойти до загрузчика в окне
#                      (SCRLD, адрес -- из layout.txt), на экране должно быть
#                      что-то, кроме панелей, а после клавиши -- снова панели,
#                      те же, что были до заставки;
#   без-заставки    -- CO.SCR нет: монитор гаснет, как раньше, -- кадр чёрный
#                      целиком, а загрузчик не исполнялся вовсе.
#
# Кадры: до заставки -- 600, заставка -- 1100, клавиша -- 1150, после -- 1700.
set -e

OUT=${1:?каталог сборки, например out/}
HERE=$(cd "$(dirname "$0")" && pwd)
V06X=$HERE/tools/vector06sdl/build/v06x
ROM=${2:-$HERE/t72/os-t72f.rom}
[ -f "$ROM" ] || { echo "нет МикроДОС: $ROM" >&2; exit 1; }
ROM=$(cd "$(dirname "$ROM")" && pwd)/$(basename "$ROM")
OUT=$(cd "$OUT" && pwd)
TMP=$(mktemp -d)
[ -n "${KEEPTMP:-}" ] && echo "рабочий каталог: $TMP" || trap 'rm -rf "$TMP"' EXIT

SCRLD=$(python3 -c 'import sys; print(next(l.split(",")[1] for l in open(sys.argv[1]) if l.strip().endswith("загрузчик заставки")))' "$OUT/layout.txt")

cat > "$TMP/key.chai" <<'CHAI'
def framefunc(frameno) {
    if (frameno == 1150) { keytyper.types([60, "Space", 60]) }
    keytyper.onframe()
}
add_callback("frame", framefunc)
CHAI

ok=0; bad=0
run() {   # имя, что положить в CO.SCR (пусто -- ничего)
    name=$1; scr=$2
    dir=$TMP/$name
    mkdir -p "$dir/out"
    cp "$OUT/co-t72.edd" "$dir/e.edd"
    python3 "$HERE/tools/kdimg.py" get "$dir/e.edd" CO.PRM "$dir/prm" >/dev/null
    python3 -c 'import sys; p=sys.argv[1]; b=bytearray(open(p,"rb").read()); b[14]=1; open(p,"wb").write(b)' "$dir/prm"
    python3 "$HERE/tools/kdimg.py" put "$dir/e.edd" "$dir/prm" CO.PRM >/dev/null
    # Сборка кладёт на квазидиск звёздное небо под именем CO.SCR -- его либо
    # подменяем проверяемой заставкой, либо убираем вовсе.
    python3 "$HERE/tools/kdimg.py" del "$dir/e.edd" CO.SCR >/dev/null 2>&1 || true
    [ -z "$scr" ] || python3 "$HERE/tools/kdimg.py" put "$dir/e.edd" "$scr" CO.SCR >/dev/null
    ( cd "$dir" && V06X_COV_LO=0x0100 V06X_COV_HI=0xBFFF V06X_COV_FILE="$dir/cov" \
        "$V06X" --rom "$ROM" --fdd "$OUT/co-t72.fdd" --edd e.edd --novideo --nosound \
        --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" --script "$TMP/key.chai" \
        --max-frame 1710 --save-frame 600 --save-frame 1100 --save-frame 1700 \
        >"$dir/log" 2>&1 ) || true
    [ -s "$dir/cov" ] || { echo "$name: карта не снята"; bad=$((bad+1)); return; }
    if python3 - "$dir" "$SCRLD" "$scr" <<'PY'
import sys, subprocess, os
d, scrld, scr = sys.argv[1], int(sys.argv[2], 16), sys.argv[3]
cov = open(d + '/cov', 'rb').read()
hit = lambda a: bool(cov[a - 0x100])
sys.path.insert(0, os.environ['TOOLS'])
import pngsame
def lit(f):
    w, h, rows = pngsame.read_png('%s/out/os-t72f_%d.png' % (d, f))
    return sum(1 for r in rows for i in range(0, len(r), 4) if any(r[i:i + 3]))
why = []
if scr:
    if not hit(scrld): why.append('загрузчик %04X не исполнялся' % scrld)
    if lit(1100) == 0: why.append('кадр 1100 чёрный')
    same = subprocess.run([sys.executable, os.environ['TOOLS'] + '/pngsame.py',
                           '%s/out/os-t72f_1100.png' % d, '%s/out/os-t72f_600.png' % d,
                           '--rows', '250'], capture_output=True).returncode == 0
    if same: why.append('в кадре 1100 всё ещё панели')
    back = subprocess.run([sys.executable, os.environ['TOOLS'] + '/pngsame.py',
                           '%s/out/os-t72f_600.png' % d, '%s/out/os-t72f_1700.png' % d,
                           '--rows', '250'], capture_output=True)
    if back.returncode: why.append('после клавиши панели не те: ' + back.stdout.decode().strip())
else:
    if hit(scrld): why.append('загрузчик исполнялся без CO.SCR')
    if lit(1100): why.append('кадр 1100 не чёрный: монитор не погас')
if why:
    print('; '.join(why)); sys.exit(1)
PY
    then echo "  $name: да"; ok=$((ok+1))
    else echo "  $name: НЕТ"; bad=$((bad+1)); fi
}

export TOOLS=$HERE/tools
run звёзды "$OUT/STARS.SCR"
run логотип "$OUT/LOGO.SCR"
run без-заставки ""
echo "прошло $ok, не прошло $bad"
[ "$bad" -eq 0 ]
