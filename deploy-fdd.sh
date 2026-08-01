#!/bin/sh
# Положить свежесобранные бинари CO на рабочую дискету эмулятора.
#
#   ./deploy-fdd.sh [~/v06x/test.fdd]
#
# Кладёт два варианта под разными именами, потому что адрес дискового
# обработчика БСВВ у сборок T-72 разный:
#   CO-F.COM   -- под os-t72f  (обработчик E2ED)
#   CO-HA.COM  -- под os-t72h и os-t72hx (обработчик E2FF)
# Прежние файлы с этими именами удаляются, иначе в каталоге останутся оба.
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
FDD=${1:-$HOME/v06x/test.fdd}
[ -f "$FDD" ] || { echo "нет дискеты: $FDD" >&2; exit 1; }

deploy() {   # откуда, под каким именем
    [ -f "$1" ] || { echo "нет сборки: $1 -- сначала patch-co.sh" >&2; exit 1; }
    python3 "$HERE/tools/cpmimg.py" --geom fdd del "$FDD" "$2" >/dev/null
    python3 "$HERE/tools/cpmimg.py" --geom fdd put "$FDD" "$1" "$2"
}

deploy "$HERE/out2/CO.COM"    CO-F.COM
deploy "$HERE/out2-hx/CO.COM" CO-HA.COM

echo
python3 "$HERE/tools/cpmimg.py" --geom fdd list "$FDD" | grep -E 'name|CO-|^[0-9]+/'
