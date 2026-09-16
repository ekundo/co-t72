#!/bin/sh
# Собрать листинг CO и сверить с образом побайтно.
#
#   ./check-src.sh co-src/co.asm work/co/co.com
#
# Это основа переноса правок из tools/*.py в исходник: пока листинг собирается
# в тот же байт, что и оригинал, его можно править руками и не бояться, что
# разошлись. Когда правка переезжает в исходник, сверять надо уже не с
# оригиналом, а с тем, что даёт нынешняя цепочка патчей, -- см. patch-co.sh.
set -e

SRC=${1:?листинг, например co-src/co.asm}
REF=${2:?образ для сверки, например work/co/co.com}
HERE=$(cd "$(dirname "$0")" && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

python3 "$HERE/tools/asm8080.py" "$SRC" -o "$TMP/out.com" >/dev/null
python3 - "$TMP/out.com" "$REF" <<'PY'
import sys
a = open(sys.argv[1], 'rb').read()
b = open(sys.argv[2], 'rb').read()
if len(a) != len(b):
    sys.exit('размер разошёлся: собрано %d, образец %d' % (len(a), len(b)))
bad = [i for i in range(len(a)) if a[i] != b[i]]
if not bad:
    print('совпадает побайтно: %d байт' % len(a))
    raise SystemExit
print('расхождений: %d' % len(bad))
for i in bad[:10]:
    print('  %04X: собрано %02X, в образце %02X' % (0x100 + i, a[i], b[i]))
sys.exit(1)
PY
