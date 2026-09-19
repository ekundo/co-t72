#!/bin/sh
# Собрать из оригинального CO v2.0 (Шишатский С.М., 1993, требует T-34) сборку,
# работающую под MDOS T-72, и положить её на образ квазидиска.
#
#   ./patch-co.sh work/co/co.com work/os-t72/os-t72.edd out/ [os-t72f.rom]
#
# Четвёртый аргумент -- МикроДОС, под которую собираем: у сборок f/k/h/hx разные
# адреса в БСВВ, и адрес дискового обработчика скрипт снимает с живого Вектора,
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
[ -f "$ROM" ] || { echo "нет МикроДОС: $ROM" >&2; exit 1; }
ROM=$(cd "$(dirname "$ROM")" && pwd)/$(basename "$ROM")
mkdir -p "${3:-out}"
# все пути -- абсолютные: шаг записи ОС выполняется со сменой каталога, и
# относительный путь там молча превращается в «файла нет» (эмулятор в таком
# случае поднимается с пустым квазидиском, а не сообщает об ошибке)
OUT=$(cd "${3:-out}" && pwd)
# Раскладка дописанного кода: инструменты отмечаются в этом файле, а в конце
# сборки tools/layout.py печатает таблицу и проверяет, что никто никому не
# налез на ногу и что всё уместилось в отведённые места.
CO_LAYOUT=$OUT/layout.txt
export CO_LAYOUT
: > "$CO_LAYOUT"
CO=$(cd "$(dirname "$CO")" && pwd)/$(basename "$CO")
EDD=$(cd "$(dirname "$EDD")" && pwd)/$(basename "$EDD")
# подлинная системная дискета рядом с базовым квазидиском: с неё берём описатель
# диска для системных дорожек
SYSFDD=$(dirname "$EDD")/os-t72.fdd
CODIR=$(dirname "$CO")   # рядом с бинарником лежат и шаблоны образов
# Образы собираются не с нуля, а из рабочих дисков: в них, кроме CO, лежат
# MEDIT, SID и прочее, на что ссылаются CO.EXT и клавиши. Заменяем в шаблоне
# ровно четыре файла -- OS.COM под нужную сборку T-72, CO.COM, CO.HLP и HDIR,
# -- а дискете ещё и системные дорожки. Нет шаблона -- образ, как раньше,
# собирается с нуля из комплекта co.*.
TMPL_EDD=${TMPL_EDD:-$CODIR/co.edd}
TMPL_FDD=${TMPL_FDD:-$CODIR/co.fdd}

# 1. Адрес дискового обработчика БСВВ в образе не правится вовсе. CO
#    перехватывает вектор дисковых операций (SHLD E213h), ставит свой фильтр по
#    0185 и пропускает вызовы дальше по жёстко зашитому адресу -- у T-34 это
#    E2BD или E2C4, смотря какой выпуск CO. Раньше сборка снимала адрес с живой
#    Вектора и правила четыре ссылки; теперь это делает при старте сам CO --
#    tools/diskvec.py читает вектор E213 и раскладывает прочитанное по тем же
#    четырём операндам. Зашитое значение так и остаётся от T-34 и никого не
#    трогает, зато CO.COM выходит один на все сборки T-72.
# Начинаем не с подлинного образа, а со своего исходника: co-src/co.asm
# собирается в тот же байт, а заставка в нём уже своя и уже в КОИ-8. Поэтому
# двух прежних шагов -- перекодировки блока заставки (koi7to8.py) и подмены
# текста (banner.py) -- здесь больше нет. Подлинный co.com из первого аргумента
# нужен теперь только затем, чтобы рядом с ним взять комплект: CO.PRM и прочее.
python3 "$HERE/tools/asm8080.py" "$HERE/co-src/co.asm" -o "$OUT/co2.com" >/dev/null

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
#     добиваем образ до 4100h; сам код склейки дописывается позже, вместе с
#     остальными накладками в окно. Подробности -- в tools/fix16k.py.
python3 "$HERE/tools/fix16k.py" "$OUT/CO.COM" "$OUT/co3.com" --prepare
mv "$OUT/co3.com" "$OUT/CO.COM"

# 3aa. Квазидисковая проба CO переключает банк с разрешёнными прерываниями --
#      прилетело прерывание в это окно, и Вектор исполняет содержимое банка
#      вместо БСВВ. Подробности -- в tools/kdprobe.py.
python3 "$HERE/tools/kdprobe.py" "$OUT/CO.COM" "$OUT/co5.com"
mv "$OUT/co5.com" "$OUT/CO.COM"

# 3ab. Диск D: -- второй квазидиск. Входит в сборку всегда: пункт «D» в меню
#      появляется, только если система о втором квазидиске знает, а на Векторе с
#      одним он просто не показывается. Подробности -- в tools/dsel.py.
python3 "$HERE/tools/dsel.py" "$OUT/CO.COM" "$OUT/coD.com" >"$OUT/dsel.log"
grep -v '^dflag=\|^aflag=\|^pdtab=' "$OUT/dsel.log"
DFLAG=$(sed -n 's/^dflag=//p' "$OUT/dsel.log")
AFLAG=$(sed -n 's/^aflag=//p' "$OUT/dsel.log")
PDTAB=$(sed -n 's/^pdtab=//p' "$OUT/dsel.log")
rm -f "$OUT/dsel.log"
mv "$OUT/coD.com" "$OUT/CO.COM"

# 3b. СС+7 -- выбор дискеты НЖМД вместо печати файла. Подробности -- в
#     tools/hddsel.py; на стенде до конца не проверить, v06x не эмулирует НЖМД.
python3 "$HERE/tools/hddsel.py" "$OUT/CO.COM" "$OUT/co4.com" >"$OUT/hddsel.log"
grep -v '^slot=\|^old=\|^bar=' "$OUT/hddsel.log"
INIT=$(sed -n 's/^init=//p' "$OUT/hddsel.log")
HDDINIT=$INIT   # пусковая подпрограмма hddsel: hdprobe её выключит без НЖМД
HDSLOT=$(sed -n 's/^slot=//p' "$OUT/hddsel.log")
HDOLD=$(sed -n 's/^old=//p' "$OUT/hddsel.log")
HDBAR=$(sed -n 's/^bar=//p' "$OUT/hddsel.log")
rm -f "$OUT/hddsel.log"
mv "$OUT/co4.com" "$OUT/CO.COM"

# 3ba. Список CO.ZGR: не заводить на C: пустышки для файлов, которых нет на
# 3bb. Номер дискеты НЖМД и её метка -- в рамке панели. Адрес таблицы дискет
#      система сообщает сама, в таблице состава оборудования по FFCC, поэтому в
#      сборке он не зашит и CO.COM годится для любой сборки T-72.
python3 "$HERE/tools/hdinfo.py" "$OUT/CO.COM" "$OUT/co7.com" \
    --disk 0189 --init "$INIT" >"$OUT/hdinfo.log"
cat "$OUT/hdinfo.log"
INIT=$(sed -n 's/^init=//p' "$OUT/hdinfo.log")
KEEP=$(sed -n 's/^keep=//p' "$OUT/hdinfo.log")
rm -f "$OUT/hdinfo.log"
mv "$OUT/co7.com" "$OUT/CO.COM"

# 3bc. СС+7 переставлен на выбор дискеты НЖМД безусловно, а винчестера в Векторе
#      может и не быть. Проба при старте возвращает печать, если ОС говорит, что
#      дискет НЖМД ноль. Идёт ПОСЛЕ hdinfo: всё, что дописано после него,
#      остаётся по адресу загрузки и хвост под стеком не занимает.
if [ -n "$HDSLOT" ]; then
    python3 "$HERE/tools/hdprobe.py" "$OUT/CO.COM" "$OUT/co8.com" \
        --slot "$HDSLOT" --old "$HDOLD" --bar "$HDBAR" \
        ${DFLAG:+--dflag "$DFLAG"} ${AFLAG:+--aflag "$AFLAG"} ${PDTAB:+--pdtab "$PDTAB"} \
        --hddinit "$HDDINIT" --init "$INIT" >"$OUT/hdprobe.log"
    cat "$OUT/hdprobe.log"
    INIT=$(sed -n 's/^init=//p' "$OUT/hdprobe.log")
    rm -f "$OUT/hdprobe.log"
    mv "$OUT/co8.com" "$OUT/CO.COM"
fi

# 3be. Список CO.ZGR: не заводить на C: пустышки для файлов, которых нет на
#      исходном диске. Подробности -- в tools/zgrcheck.asm. Код остаётся по
#      адресу загрузки: под стеком места вместе с диском D: не хватает, а список
#      разбирается один раз при старте, до первого чтения каталога в 4100.
python3 "$HERE/tools/zgrcheck.py" "$OUT/CO.COM" "$OUT/co9.com" --inplace
mv "$OUT/co9.com" "$OUT/CO.COM"

# 3bd. Дисковый обработчик БСВВ -- из вектора E213 при старте, а не зашитый.
#      Подробности -- в tools/diskvec.py. Шаг идёт после hdinfo.py: тот задаёт
#      границу переноса хвоста (--keep), и всё, что дописано следом, остаётся
#      по адресу загрузки. Подпрограмма пусковая, под стеком ей не место.
python3 "$HERE/tools/diskvec.py" "$OUT/CO.COM" "$OUT/coA.com" --inplace --init "$INIT" >"$OUT/diskvec.log"
cat "$OUT/diskvec.log"
INIT=$(sed -n 's/^init=//p' "$OUT/diskvec.log")
rm -f "$OUT/diskvec.log"
mv "$OUT/coA.com" "$OUT/CO.COM"

# 3be1. Перенос файлов по CO.ZGR -- только при запуске с дискеты A:. При
#       запуске с B: он читает каталог стартового диска, а тот у CO лежит по
#       4000-4FFF -- ровно поверх работающего пускового кода. Подробности --
#       в tools/zgrfroma.py.
python3 "$HERE/tools/zgrfroma.py" "$OUT/CO.COM" "$OUT/coZgr.com"
mv "$OUT/coZgr.com" "$OUT/CO.COM"

# 3be2. Каталог архива .PK2 CO читает в окно, по A000, а с A448 там лежат
#       накладки сборки -- архив длиннее килобайта затирал их и вешал CO.
#       Уводим буфер каталога в буфер копирования. Подробности -- в
#       tools/arcbuf.py.
python3 "$HERE/tools/arcbuf.py" "$OUT/CO.COM" "$OUT/coArc.com"
mv "$OUT/coArc.com" "$OUT/CO.COM"

# 3bf. Обмен с диском -- только через буфер ниже A000. Второй квазидиск с первым
#      одновременно не работает, драйвер на время пересылки с D: гасит окно ОЗУ
#      A000-DFFF, и буфер в этом окне обменивается данными с видеопамятью. У CO
#      там просмотрщик (читает файл прямо в A000) и настройки CO.PRM. Подробности
#      -- в tools/dmawin.asm.
# Три постоянные накладки подряд -- обмен, поиск по дискам и кодировки -- едут
# в окно ОЗУ: по адресу загрузки их затирает каталог диска B:, который CO
# держит копией в 4000..4FFF. Подробности -- в tools/winmove.py.
WIN=A448
WINSRC=$(printf '%X' $((0x100 + $(wc -c < "$OUT/CO.COM"))))
win() {   # win <инструмент> <аргументы...> -- собрать накладку на адрес $WIN
    tool=$1; shift
    python3 "$HERE/tools/$tool" "$OUT/CO.COM" "$OUT/coW.com" --at "$WIN" "$@" \
        >"$OUT/win.log"
    grep -v '^winnext=' "$OUT/win.log"
    WIN=$(sed -n 's/^winnext=//p' "$OUT/win.log")
    rm -f "$OUT/win.log"
    mv "$OUT/coW.com" "$OUT/CO.COM"
}

# Склейка экстентов: работает при каждом чтении каталога, значит должна быть
# постоянной. Под стеком ей тесно -- туда же растёт сам стек, -- а в окне место
# есть, и обращений к нему CO в этом куске не делает.
win fix16k.py

win dmawin.py

# 3bg. Поиск программы по "X:" перебирает C:, A: и B:, а про второй квазидиск не
#      знает -- панели диск D: знают, а этот перебор мимо. Добавляем D: сразу за
#      C:, по признаку от пробы оборудования. Подробности -- в tools/xdrive.asm.
win xdrive.py --dflag "$DFLAG"

# 3bh. Кодировки в просмотрщике. Меню F2 переключало набор знакогенератора
#      командами T-34, которых у T-72 нет вовсе. Основной набор консоли T-72 --
#      КОИ-8, поэтому показать файл в нужной кодировке можно, ничего в системе
#      не переключая: CO пересчитывает код перед выводом знака. Подробности --
#      в tools/koi.asm.
win koi.py

# 3bi0. Просмотрщик у начала файла уходил в бесконечное чтение назад: шаг назад
#       (32C3) подкачивал предыдущую запись, не глядя, есть ли она. На файле
#       короче страницы «СТР -- перейти к строке» вешала CO намертво. Это не
#       порт, а сам CO: его же проверки по 318E и 31C5 это место обходят.
#       Подробности -- в tools/viewtop.asm.
win viewtop.py

# 3bi1. Списки CO.EXT и CO.MNU CO читает целиком и без предела -- в окно, с
#       A000, то есть прямо на накладки по A448. Пока эти файлы меньше 448h
#       байт, всё хорошо; больший CO.MNU затирает обмен через буфер вне окна,
#       и первое же обращение к диску уходит в мусор. Уводим чтение в буфер
#       копирования. Подробности -- в tools/extbuf.asm.
win extbuf.py

# 3bj. Переносчик накладок в окно: отрабатывает один раз при старте, в пусковой
#      цепочке, до первого чтения каталога. Сам остаётся по адресу загрузки.
WINLEN=$(( 0x100 + $(wc -c < "$OUT/CO.COM") - 0x$WINSRC ))
python3 "$HERE/tools/winmove.py" "$OUT/CO.COM" "$OUT/coX.com" \
    --src "$WINSRC" --len "$WINLEN" --dst A448 --init "$INIT" >"$OUT/win.log"
grep -v '^init=' "$OUT/win.log"
INIT=$(sed -n 's/^init=//p' "$OUT/win.log")
rm -f "$OUT/win.log"
mv "$OUT/coX.com" "$OUT/CO.COM"

# 3bh2. HDIR -- каталог винчестера, отдельная программа. Кладём в оба образа,
#       поэтому собираем здесь, а не только в make-release.sh.
python3 "$HERE/tools/asm8080.py" "$HERE/tools/hdir.asm" -o "$OUT/HDIR.COM" >/dev/null
echo "HDIR.COM: $(wc -c < "$OUT/HDIR.COM") байт"

# 3bi. Справка. Источник -- docs/co-help.md, оригинальный co.hlp больше не
#      берётся: в маркдауне тот же текст, и правки под T-72 (клавиша "F2" в
#      просмотрщике, символы в CO.EXT) живут там, а не заплаткой поверх файла.
python3 "$HERE/tools/mkhlp.py" "$HERE/docs/co-help.md" -o "$OUT/CO.HLP"

# 3c. Весь дописанный хвост исполняется не там, где лежит: по 4100 у CO буфер
#     каталога, он его затирает. Копируем хвост под стек при старте.
# Тело накладки остаётся на месте загрузки, под стек едет только то, что ниже.
python3 "$HERE/tools/relocstub.py" "$OUT/CO.COM" "$OUT/co6.com" --init "$INIT" \
    ${KEEP:+--keep "$KEEP"}
mv "$OUT/co6.com" "$OUT/CO.COM"

# 3d. Раскладка: всё ли уместилось. Проверка настоящая -- если кусок вылез за
#     своё место или налез на соседа, сборка тут и останавливается. Свободные
#     места в окне измерены прогоном, см. tools/winmap.py и docs/co-buffers.md.
python3 "$HERE/tools/layout.py" "$CO_LAYOUT"

# 4. На квазидиске должна лежать ТА ЖЕ сборка T-72, что и в .rom. Тёплый старт
#    (F12) перечитывает систему из C:OS.COM, и если там чужая сборка -- поднимется
#    она, а CO, пропатченный под нашу, начнёт сыпать ошибками диска. Подлинный
#    os-t72.edd несёт сборку 1995 года, поэтому переписываем OS.COM из памяти
#    командой МикроДОС "1 3C C:OS.COM" и забираем получившийся квазидиск.
#    На базовый образ перед этим кладём заглушку C:INITIALC.SUB: без неё система
#    ищет автозапуск на A:, а это винчестер (сборки h, hx, k), которого в v06x
#    нет -- ССР сыплет "Ошибка диска. Игнорировать (Y/N)?" и съедает набранную
#    команду. Потом заглушку убираем: на её место ляжет настоящая, с "CO".
BASE_EDD=$EDD
[ -f "$TMPL_EDD" ] && BASE_EDD=$TMPL_EDD
if [ -x "$V06X" ] && [ -f "$ROM" ]; then
    echo "переписываю OS.COM на квазидиске под текущую сборку T-72..."
    cp "$BASE_EDD" "$OUT/os-base.edd"
    printf '9 A:0\r\n' > "$OUT/initialc-boot.sub"
    python3 "$HERE/tools/kdimg.py" put "$OUT/os-base.edd" \
        "$OUT/initialc-boot.sub" INITIALC.SUB >/dev/null
    ( cd "$HERE/run" && V06X_EDD_SAVE="$OUT/co-t72.edd" "$V06X" --rom "$ROM" \
        --edd "$OUT/os-base.edd" --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" \
        --script "$HERE/scripts/write-os.chai" \
        --max-frame 1800 --novideo --nosound >/dev/null 2>&1 ) || true
    # Мало проверить, что OS.COM на месте: он есть и в подлинном образе. Пока
    # шаг выше молча не срабатывал, в сборку уезжала система 1995 года, а с ней
    # CO под T-72 не работает. Поэтому сверяем дату сборки с образом системы.
    python3 "$HERE/tools/kdimg.py" get "$OUT/co-t72.edd" OS.COM "$OUT/os-check.com"
    python3 - "$OUT/os-check.com" "$ROM" <<'PYCHK'
import pathlib, re, sys
def ver(path):
    m = re.search(rb'\d\d\.\d\d\.\d\d', pathlib.Path(path).read_bytes())
    return m.group().decode() if m else '?'
a, b = ver(sys.argv[1]), ver(sys.argv[2])
if a != b:
    sys.exit('OS.COM на квазидиске -- сборка %s, а образ системы %s: '
             'команда записи ОС не отработала' % (a, b))
print('OS.COM на квазидиске: сборка %s' % a)
PYCHK
    python3 "$HERE/tools/kdimg.py" del "$OUT/co-t72.edd" INITIALC.SUB >/dev/null
    rm -f "$OUT/os-base.edd" "$OUT/os-check.com" "$OUT/initialc-boot.sub"
else
    echo "v06x не собран -- беру базовый образ как есть" >&2
    cp "$BASE_EDD" "$OUT/co-t72.edd"
fi
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/CO.COM" CO.COM
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/CO.HLP" CO.HLP
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/HDIR.COM" HDIR.COM
if [ ! -f "$TMPL_EDD" ]; then
    # без шаблона комплект кладём сами
    for f in prm mnu ext zgr; do
        [ -f "$CODIR/co.$f" ] && python3 "$HERE/tools/kdimg.py" put \
            "$OUT/co-t72.edd" "$CODIR/co.$f" "CO.$(echo "$f" | tr a-z A-Z)"
    done
fi
printf 'CO\r\n' > "$OUT/initialc.sub"
python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$OUT/initialc.sub" INITIALC.SUB

# 5. Дискета A: с тем же комплектом и загрузочная: в её системные дорожки кладём
#    ту же сборку T-72, что и в образе системы. Брать за основу os-t34.fdd нельзя
#    -- в её дорожках останется T-34, под которой наш CO уже не работает.
#    INITIAL.SUB с командой "A:CO" -- автозапуск: система выполняет его сразу
#    после загрузки с дискеты, как INITIALC.SUB на квазидиске.
if [ -f "$TMPL_FDD" ]; then
    cp "$TMPL_FDD" "$OUT/co-t72.fdd"
    # Редакторские копии с рабочего диска в выпуск не едут.
    for junk in CO.BAK; do
        python3 "$HERE/tools/cpmimg.py" --geom fdd del "$OUT/co-t72.fdd" "$junk" \
            >/dev/null 2>&1 || true
    done
else
    python3 "$HERE/tools/cpmimg.py" --geom fdd create "$OUT/co-t72.fdd"
    for f in prm mnu ext zgr; do
        [ -f "$CODIR/co.$f" ] && python3 "$HERE/tools/cpmimg.py" --geom fdd put \
            "$OUT/co-t72.fdd" "$CODIR/co.$f" "CO.$(echo "$f" | tr a-z A-Z)"
    done
fi
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/CO.COM" CO.COM
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/CO.HLP" CO.HLP
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/HDIR.COM" HDIR.COM
# OS.COM на дискете -- та же сборка, что и на квазидиске: её туда только что
# записала сама система. Дискета с чужой OS.COM опасна ровно так же, как
# квазидиск: тёплый старт поднимет её, а не нашу.
if python3 "$HERE/tools/kdimg.py" get "$OUT/co-t72.edd" OS.COM "$OUT/OS.COM" >/dev/null 2>&1; then
    python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/OS.COM" OS.COM
    rm -f "$OUT/OS.COM"
fi
# Эталонные настройки -- для прогона по функциям, а не для образов: в образе
# лежит CO.PRM из шаблона, с панелями, как их оставил хозяин диска, а сценариям
# нужна известная пара панелей. check-funcs.sh кладёт этот файл в свою копию.
[ -f "$CODIR/co.prm" ] && cp "$CODIR/co.prm" "$OUT/CO.PRM"

printf 'A:CO\r\n' > "$OUT/initial.sub"
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/initial.sub" INITIAL.SUB
python3 "$HERE/tools/sysfdd.py" "$OUT/co-t72.fdd" "$ROM" --base "$SYSFDD"

echo
echo "готово: $OUT/co-t72.edd (квазидиск C:) и $OUT/co-t72.fdd (дискета A:)"
echo "запуск: v06x --rom $ROM --fdd $OUT/co-t72.fdd --edd $OUT/co-t72.edd"
echo
echo "Сброс: F12 (БЛК+СБР) поднимает систему заново из C:OS.COM -- работает."
echo "F11 (БЛК+ВВОД) ищет систему на дискете -- на её дорожках та же сборка."
