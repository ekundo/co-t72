#!/bin/sh
# Собрать листинг CO и сверить с подлинным образом: каждое расхождение должно
# быть объявлено.
#
#   ./check-src.sh co-src/co.asm work/co/co.com
#
# Пока правки жили в tools/*.py, листинг собирался в тот же байт, что и
# оригинал, и сверка была простая: «расхождений нет». Теперь правки переезжают
# в сам листинг, и такой сверки больше не выйдет -- зато выходит лучше. Каждая
# правка помечена в строке словом «ПРАВКА», и проверка требует, чтобы ВСЕ
# отличия от подлинного образа лежали внутри помеченных строк. Изменил что-то
# молча -- сборка остановится и покажет, где.
#
# Адреса помеченных строк берутся из листинга сборки (asm8080.py -l): в нём у
# каждой строки свой адрес и свои байты.
set -e

SRC=${1:?листинг, например co-src/co.asm}
REF=${2:?образ для сверки, например work/co/co.com}
HERE=$(cd "$(dirname "$0")" && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

python3 "$HERE/tools/asm8080.py" "$SRC" -o "$TMP/out.com" -l "$TMP/out.lst" >/dev/null
python3 - "$TMP/out.com" "$REF" "$TMP/out.lst" <<'PY'
import re
import sys

a = open(sys.argv[1], 'rb').read()
b = open(sys.argv[2], 'rb').read()
if len(a) != len(b):
    sys.exit('размер разошёлся: собрано %d, образец %d' % (len(a), len(b)))

# Объявленные правки: строки листинга со словом «ПРАВКА», у которых есть байты.
# Докуда строка тянется, считаем по следующей: в столбце байтов у asm8080 их не
# больше пяти, а у .db строка бывает и длиннее.
LINE = re.compile(r'^([0-9A-F]{4}) ([0-9A-F]+)\s')
rows = []
for ln in open(sys.argv[3], encoding='utf-8'):
    m = LINE.match(ln)
    if m:
        rows.append([int(m.group(1), 16), 'ПРАВКА' in ln])
declared, places = set(), []
for i, (at, marked) in enumerate(rows):
    end = rows[i + 1][0] if i + 1 < len(rows) else 0x100 + len(a)
    if marked:
        declared.update(range(at, end))
        places.append((at, end - at))

bad = [0x100 + i for i in range(len(a)) if a[i] != b[i] and 0x100 + i not in declared]
changed = sum(1 for i in range(len(a)) if a[i] != b[i])
print('объявлено правок: %d строк, %d байт; расходится с подлинным образом '
      '%d байт' % (len(places), len(declared), changed))
if not bad:
    print('все расхождения объявлены')
else:
    print('НЕ ОБЪЯВЛЕНО расхождений: %d' % len(bad))
    for at in bad[:10]:
        print('  %04X: собрано %02X, в образце %02X'
              % (at, a[at - 0x100], b[at - 0x100]))
    sys.exit(1)
PY
