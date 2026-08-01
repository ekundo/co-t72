#!/bin/sh
# Собрать из оригинального CO v2.0 (Шишатский С.М., 1993, требует T-34) сборку,
# работающую под MDOS T-72, и положить её на образ квазидиска.
#
#   ./patch-co.sh work/co/co.com work/os-t72/os-t72.edd out/
#
# Правок три: две обязательные и одна косметическая. Список отвергнутых
# кандидатов -- в README, чтобы не проверять заново.
set -e

CO=${1:?оригинальный co.com}
EDD=${2:?подлинный os-t72.edd как основа}
OUT=${3:-out}
HERE=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$OUT"

# 1. Адрес дискового обработчика БСВВ. CO перехватывает вектор дисковых операций
#    (SHLD E213h), ставит свой фильтр по 0185 и пропускает вызовы дальше по
#    жёстко зашитому адресу. У T-34 обработчик на E2BD, у T-72 -- на E2ED.
#    Это единственный зашитый адрес БСВВ во всём CO.
python3 "$HERE/tools/patchaddr.py" "$CO" "$OUT/co1.com" \
    --listing "$HERE/co-cov.asm" --map E2BD:E2ED

# 2. Заставка хранится в КОИ-7 и переключает набор однобайтным кодом 0Eh.
#    У T-72 нет ни такого кода, ни шрифта КОИ-7 (на 1B 5C у него CP866).
#    КОИ-8 = КОИ-7 | 80h. Косметика, но без неё текст лезет латиницей.
python3 "$HERE/tools/koi7to8.py" "$OUT/co1.com" "$OUT/co2.com" \
    --at 0x3FB8 --len 0x67

# 3. Стек. CO ставит его по правилам CP/M -- на вершину TPA из ячейки 0006,
#    то есть на C000 вниз. Но T-72 держит килобайтный буфер дисковода по
#    BC00-BFFF (D_FD_B в Source/_E200h.asm; в исходной МикроДОС он был на EB00),
#    и вершину TPA при переносе не опустили. Каждое чтение сектора затирало
#    стек CO вместе с адресами возврата. Опускаем стек ниже буфера.
python3 - "$OUT/co2.com" "$OUT/CO.COM" <<'PY'
import sys
d = bytearray(open(sys.argv[1], 'rb').read())
O = 0x100
# 406A: LHLD 0006 / SPHL / SHLD 0009  ->  JMP 40DB
d[0x406A-O:0x4070-O] = bytes([0xC3, 0xDB, 0x40, 0x00, 0x00, 0x00])
# в свободном хвосте образа -- то же самое, но со стеком ниже буфера дисковода.
# [0006] нужен дважды: и как вершина стека, и как цель RST 1, поэтому просто
# заменить LHLD на LXI H,BC00 нельзя -- сломается вызов БДОС.
d[0x40DB-O:0x40E7-O] = bytes([0x2A, 0x06, 0x00,    # LHLD 0006
                              0x22, 0x09, 0x00,    # SHLD 0009  (RST 1 -> БДОС)
                              0x31, 0x00, 0xBC,    # LXI SP,BC00h
                              0xC3, 0x71, 0x40])   # JMP 4071
open(sys.argv[2], 'wb').write(bytes(d))
PY
rm -f "$OUT/co1.com" "$OUT/co2.com"

# 4. Установка: CO со служебными файлами и INITIALC.SUB (autoexec МикроДОС),
#    чтобы система стартовала прямо в менеджер.
cp "$EDD" "$OUT/co-t72.edd"
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/CO.COM" CO.COM
for f in prm mnu ext hlp zgr; do
    [ -f "$HERE/work/co/co.$f" ] && \
        python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$HERE/work/co/co.$f"
done
printf 'CO\r\n' > "$OUT/initialc.sub"
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/initialc.sub" INITIALC.SUB

echo
echo "готово: $OUT/co-t72.edd"
echo "запуск: v06x --rom os-t72f.rom --edd $OUT/co-t72.edd"
