#!/bin/sh
# Собрать из оригинального CO v2.0 (Шишатский С.М., 1993, требует T-34) сборку,
# работающую под MDOS T-72, и положить её на образ квазидиска.
#
#   ./patch-co.sh work/co/co.com work/os-t72/os-t72.edd out/ [os-t72f.rom]
#
# Четвёртый аргумент -- ПЗУ, под которое собираем: у сборок f/k/h/hx разные
# адреса в БСВВ, и адрес дискового обработчика скрипт снимает с живой машины,
# а не берёт из таблицы.
#
# Правок три: две обязательные и одна косметическая. Список отвергнутых
# кандидатов -- в README, чтобы не проверять заново.
set -e

CO=${1:?оригинальный co.com}
EDD=${2:?подлинный os-t72.edd как основа}
HERE=$(cd "$(dirname "$0")" && pwd)
V06X=$HERE/tools/vector06sdl/build/v06x
ROM=${4:-$HERE/tools/MDOS_T-72/BIN/os-t72f.rom}
[ -f "$ROM" ] || { echo "нет ПЗУ: $ROM" >&2; exit 1; }
ROM=$(cd "$(dirname "$ROM")" && pwd)/$(basename "$ROM")
mkdir -p "${3:-out}"
# все пути -- абсолютные: шаг записи ОС выполняется со сменой каталога, и
# относительный путь там молча превращается в «файла нет» (эмулятор в таком
# случае поднимается с пустым квазидиском, а не сообщает об ошибке)
OUT=$(cd "${3:-out}" && pwd)
CO=$(cd "$(dirname "$CO")" && pwd)/$(basename "$CO")
EDD=$(cd "$(dirname "$EDD")" && pwd)/$(basename "$EDD")
CODIR=$(dirname "$CO")   # CO.PRM/MNU/EXT/HLP/ZGR берём рядом с бинарником

# 1. Адрес дискового обработчика БСВВ. CO перехватывает вектор дисковых операций
#    (SHLD E213h), ставит свой фильтр по 0185 и пропускает вызовы дальше по
#    жёстко зашитому адресу. У T-34 обработчик на E2BD; у T-72 он свой в каждой
#    сборке (f -- E2ED, h и hx -- E2FF), поэтому читаем его прямо из таблицы
#    переходов на живой машине: E212 -- это JMP, операнд лежит по E213.
#    Читать надо ПОСЛЕ первого обращения к диску -- см. scripts/dump-bios.chai.
#    Это единственный зашитый адрес БСВВ во всём CO.
( cd "$HERE/run" && rm -f bios-vectors.bin && "$V06X" --rom "$ROM" \
    --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" \
    --edd "$EDD" --script "$HERE/scripts/dump-bios.chai" \
    --max-frame 1200 --novideo --nosound >/dev/null 2>&1 ) || true
DISK=$(python3 - "$HERE/run/bios-vectors.bin" <<'PY'
import sys
d = open(sys.argv[1], 'rb').read()
assert d[0x12] == 0xC3, 'E212 не JMP -- сборка не похожа на T-72'
print('%04X' % (d[0x13] | d[0x14] << 8))
PY
)
echo "ПЗУ $(basename "$ROM"): дисковый обработчик БСВВ на $DISK"
# Выпусков CO два: в раннем зашит адрес T-34 E2BD, в позднем -- E2C4.
# Ссылки в обоих на одних и тех же местах (0189, 0206, 02F6, 205E).
OLDADDR=$(python3 - "$CO" <<'PY'
import sys
d = open(sys.argv[1], 'rb').read()
at = 0x0189 - 0x100
print('%02X%02X' % (d[at + 1], d[at]))
PY
)
python3 "$HERE/tools/patchaddr.py" "$CO" "$OUT/co1.com" \
    --listing "$HERE/co-cov.asm" --map "$OLDADDR:$DISK"

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
# [0006] нужен дважды: и как вершина стека, и как цель RST 1, поэтому просто
# заменить LHLD на LXI H,BC00 нельзя -- сломается вызов БДОС. Инструкции не
# помещаются на место исходных семи байт, поэтому уводим точку входа на 40DB.
STACK = bytes([0x2A, 0x06, 0x00,    # LHLD 0006
               0x22, 0x09, 0x00,    # SHLD 0009  (RST 1 -> БДОС)
               0x31, 0x00, 0xBC,    # LXI SP,BC00h
               0xC3, 0x71, 0x40])   # JMP 4071 -- дальше как было
entry = d[0x0101-O] | d[0x0102-O] << 8
if entry == 0x406A:
    # ранний выпуск: 0100 ведёт прямо на установку стека, а 40DB -- нули
    pass
elif entry == 0x40DB:
    # поздний выпуск: по 40DB стоит проверка верхней границы ОЗУ
    # (LDA 0002 / CPI C0 -> «смените ДОС»). От неё толку нет: T-72 сообщает
    # C000 и проверку проходит, а буфер дисковода всё равно на BC00.
    pass
else:
    sys.exit('незнакомая точка входа CO: %04X' % entry)
d[0x0101-O:0x0103-O] = bytes([0xDB, 0x40])
d[0x40DB-O:0x40DB-O+len(STACK)] = STACK
open(sys.argv[2], 'wb').write(bytes(d))
PY
rm -f "$OUT/co1.com" "$OUT/co2.com"

# 3a. Файлы, кратные 16 КБ, в панели не показываются: у них полны ВСЕ экстенты,
#     а CO пропускает полные экстенты как продолжение файла. Снимаем проверку и
#     склеиваем экстенты по имени. Подробности -- в tools/fix16k.py.
python3 "$HERE/tools/fix16k.py" "$OUT/CO.COM" "$OUT/co3.com"
mv "$OUT/co3.com" "$OUT/CO.COM"

# 3aa. Квазидисковая проба CO переключает банк с разрешёнными прерываниями --
#      прилетело прерывание в это окно, и машина исполняет содержимое банка
#      вместо БСВВ. Подробности -- в tools/kdprobe.py.
python3 "$HERE/tools/kdprobe.py" "$OUT/CO.COM" "$OUT/co5.com"
mv "$OUT/co5.com" "$OUT/CO.COM"

# 3b. СС+7 -- выбор дискеты НЖМД вместо печати файла. Подробности -- в
#     tools/hddsel.py; на стенде до конца не проверить, v06x не эмулирует НЖМД.
python3 "$HERE/tools/hddsel.py" "$OUT/CO.COM" "$OUT/co4.com"
mv "$OUT/co4.com" "$OUT/CO.COM"

# 3c. Весь дописанный хвост исполняется не там, где лежит: по 4100 у CO буфер
#     каталога, он его затирает. Копируем хвост под стек при старте.
python3 "$HERE/tools/relocstub.py" "$OUT/CO.COM" "$OUT/co6.com"
mv "$OUT/co6.com" "$OUT/CO.COM"

# 4. На квазидиске должна лежать ТА ЖЕ сборка T-72, что и в .rom. Тёплый старт
#    (F12) перечитывает систему из C:OS.COM, и если там чужая сборка -- поднимется
#    она, а CO, пропатченный под нашу, начнёт сыпать ошибками диска. Подлинный
#    os-t72.edd несёт сборку 1995 года, поэтому переписываем OS.COM из памяти
#    командой МикроДОС "1 3C C:OS.COM" и забираем получившийся квазидиск.
if [ -x "$V06X" ] && [ -f "$ROM" ]; then
    echo "переписываю OS.COM на квазидиске под текущую сборку T-72..."
    ( cd "$HERE/run" && V06X_EDD_SAVE="$OUT/co-t72.edd" "$V06X" --rom "$ROM" \
        --edd "$EDD" --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" \
        --script "$HERE/scripts/write-os.chai" \
        --max-frame 1800 --novideo --nosound >/dev/null 2>&1 ) || true
fi
# Без OS.COM образ бесполезен: тёплый старт поднимет мусор, а не систему.
# В подлинном образе ровно один файл, значит и после записи должен быть один:
# лишняя запись означает, что ССР потерял символы и команда приехала обкусанной.
if [ "$(python3 "$HERE/tools/kdimg.py" list "$OUT/co-t72.edd" 2>/dev/null | grep -c .)" != 1 ] ||
   ! python3 "$HERE/tools/kdimg.py" list "$OUT/co-t72.edd" 2>/dev/null | grep -q 'OS *\.COM'; then
    echo "не удалось переписать OS.COM -- беру подлинный образ как есть" >&2
    cp "$EDD" "$OUT/co-t72.edd"
fi
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/CO.COM" CO.COM
for f in prm mnu ext hlp zgr; do
    [ -f "$CODIR/co.$f" ] && \
        python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$CODIR/co.$f"
done
printf 'CO\r\n' > "$OUT/initialc.sub"
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/initialc.sub" INITIALC.SUB

# 5. Дискета A: с тем же комплектом -- НЕ загрузочная. Если взять за основу
#    os-t34.fdd, в её системных дорожках останется T-34, и после аппаратного
#    сброса ПЗУ поднимет с дискеты именно её, а наш CO под T-34 уже не работает.
python3 "$HERE/tools/cpmimg.py" --geom fdd create "$OUT/co-t72.fdd"
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/CO.COM" CO.COM
for f in prm mnu ext hlp zgr; do
    [ -f "$CODIR/co.$f" ] && \
        python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$CODIR/co.$f"
done

echo
echo "готово: $OUT/co-t72.edd (квазидиск C:) и $OUT/co-t72.fdd (дискета A:)"
echo "запуск: v06x --rom $ROM --fdd $OUT/co-t72.fdd --edd $OUT/co-t72.edd"
echo
echo "Сброс: F12 (БЛК+СБР) поднимает систему заново из C:OS.COM -- работает."
echo "F11 (БЛК+ВВОД) подключает ПЗУ и ищет систему на дискете, а дискета"
echo "намеренно не загрузочная -- после F11 эмулятор надо запустить заново."
