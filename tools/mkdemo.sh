#!/bin/sh
# Собрать показательный архив DEMO.PK2 -- тот, что лежит в выпуске рядом с
# архиватором.
#
#   ./tools/mkdemo.sh [work/co/ARC2.COM] [work/os-t72/os-t72.edd] [t72/os-t72hx.rom]
#
# Кладётся в work/co/DEMO.PK2, оттуда его берёт сборка.
#
# Зачем так сложно. Архив нужен настоящий: CO читает каталог .PK2 сам, а
# распаковывает его ARC2 («ARCHIVER V1.3 (C) V.KRUPSKY 1990»), и подделку он не
# распакует -- сжатие у него своё. Значит архив должен собрать сам ARC2, а он
# программа не пакетная: спрашивает всё с клавиатуры. Поэтому здесь Вектор в
# эмуляторе, а ответы шлются клавишами.
#
# Разговор с ARC2 -- по шагам (сняты с экрана, см. шапку строк в самом ARC2):
#
#   "(C)OMPRESSING OR (D)ECOMPRESSING ?"    -> C
#   "ENTER SOURSE DRIVE NAME"               -> B  (дискета с тем, что паковать)
#   "ENTER DESTINATION DRIVE NAME"          -> C
#   список файлов со звёздочками            -> ВК помечает, "вправо" переводит
#                                              на следующий, АР2 заканчивает
#   "DESTINATION FILE NAME - ?"             -> DEMO.PK2 и ВК
#
# Готовый архив ARC2 кладёт на дискету A:, а не туда, куда его просили; ищем
# его и там, и на квазидиске.
#
# Что внутри: HDIREN.COM -- та же HDIR, только по-английски (в образах её нет,
# лежит лишь в архиве выпуска, так что распаковка не упрётся в «файл уже
# есть»), и коротенькая записка DEMO.TXT.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
ARC2=${1:-$ROOT/work/co/ARC2.COM}
BASE=${2:-$ROOT/work/os-t72/os-t72.edd}
ROM=${3:-$ROOT/t72/os-t72hx.rom}
OUT=$ROOT/work/co/DEMO.PK2
V06X=$ROOT/tools/vector06sdl/build/v06x

for f in "$ARC2" "$BASE" "$ROM" "$V06X"; do
    [ -e "$f" ] || { echo "нет $f" >&2; exit 1; }
done

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Записка внутрь архива -- в КОИ-8, как и всё остальное на этих дисках.
python3 - "$TMP/DEMO.TXT" <<'PY'
import sys
text = '''Показательный архив.

Отсюда видно, как CO работает с .PK2: клавиша "3-Просм" на архиве открывает
его каталог, "ВК" на строке внутри -- распаковывает. Распаковкой занимается
ARC2, он должен лежать на одном из дисков.

Внутри этого архива HDIREN.COM -- каталог винчестера по-английски, то же
самое, что HDIR.COM, но сообщения латиницей.
'''
open(sys.argv[1], 'wb').write(text.replace('\n', '\r\n').encode('koi8-r') + b'\x1a')
PY
python3 "$HERE/asm8080.py" "$HERE/hdir-en.asm" -o "$TMP/HDIREN.COM" >/dev/null

# Дискета с тем, что паковать, -- она будет диском B:
python3 "$HERE/cpmimg.py" --geom fdd create "$TMP/src.fdd" >/dev/null
python3 "$HERE/cpmimg.py" --geom fdd put "$TMP/src.fdd" "$TMP/DEMO.TXT" DEMO.TXT >/dev/null
python3 "$HERE/cpmimg.py" --geom fdd put "$TMP/src.fdd" "$TMP/HDIREN.COM" HDIREN.COM >/dev/null

# Квазидиск: система, архиватор и автозапуск прямо в него.
cp "$BASE" "$TMP/c.edd"
python3 "$HERE/kdimg.py" put "$TMP/c.edd" "$ARC2" ARC2.COM >/dev/null
printf 'ARC2\r\n' > "$TMP/initialc.sub"
python3 "$HERE/kdimg.py" put "$TMP/c.edd" "$TMP/initialc.sub" INITIALC.SUB >/dev/null
# Дискета A: пустая -- на неё ARC2 и положит готовый архив.
python3 "$HERE/cpmimg.py" --geom fdd create "$TMP/a.fdd" >/dev/null

cat > "$TMP/keys.chai" <<'EOF'
def framefunc(frameno) {
    if (frameno == 1500) {
        keytyper.types([60,
            "C", 120,                       /* сжимать */
            "B", 120,                       /* откуда */
            "C", 300,                       /* куда */
            "Return", 120, "Right", 120, "Return", 120,   /* пометить оба файла */
            "Escape", 300,                  /* АР2 -- выбор закончен */
            "D", 25, "E", 25, "M", 25, "O", 25, ".", 25,
            "P", 25, "K", 25, "2", 25, "Return", 900])
    }
    keytyper.onframe()
}
add_callback("frame", framefunc)
EOF

mkdir -p "$ROOT/run"
( cd "$ROOT/run" && V06X_EDD_SAVE="$TMP/out.edd" "$V06X" --rom "$ROM" \
    --fdd "$TMP/a.fdd" --fdd "$TMP/src.fdd" --edd "$TMP/c.edd" \
    --script "$ROOT/tools/vector06sdl/scripts/robotnik.chai" \
    --script "$TMP/keys.chai" \
    --max-frame 3600 --novideo --nosound >/dev/null 2>&1 ) || true

# Архив мог лечь и на дискету, и на квазидиск -- берём, где нашёлся.
if python3 "$HERE/cpmimg.py" --geom fdd get "$TMP/a.fdd" DEMO.PK2 "$OUT" >/dev/null 2>&1; then
    :
elif python3 "$HERE/kdimg.py" get "$TMP/out.edd" DEMO.PK2 "$OUT" >/dev/null 2>&1; then
    :
else
    echo "ARC2 архива не сделал -- смотри кадры в run/out" >&2
    exit 1
fi

python3 - "$OUT" <<'PY'
import sys
d = open(sys.argv[1], 'rb').read()
print('%s: %d байт' % (sys.argv[1], len(d)))
i = 0
while i + 16 <= len(d):
    r = d[i:i + 16]
    name = bytes(b & 0x7F for b in r[1:9]).decode('koi8-r').rstrip()
    ext = bytes(b & 0x7F for b in r[9:12]).decode('koi8-r').rstrip()
    print('  %s.%s' % (name, ext))
    if r[0] & 0x80:
        break
    i += 16
PY
