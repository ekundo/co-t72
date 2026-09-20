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
# Правок поверх образа здесь больше нет вовсе: и те, что ложатся на место байт
# в байт, и весь дописанный код живут в самом листинге (co-src/, правки помечены
# словом «ПРАВКА», сверяет их check-src.sh). Здесь остаётся сборка образов.
# Список отвергнутых кандидатов -- в README, чтобы не проверять заново.
set -e

CO=${1:?оригинальный co.com}
EDD=${2:?подлинный os-t72.edd как основа}
HERE=$(cd "$(dirname "$0")" && pwd)
V06X=$HERE/tools/vector06sdl/build/v06x
ROM=${4:-$HERE/tools/MDOS_T-72/BIN/os-t72f.rom}
# Пятый аргумент -- VDE.COM: редактор, который кладётся в оба образа. На
# клавише "СС"-"4" в CO стоит именно он (WordStar заточен под КОИ-7 и под T-72
# толком не работает, см. vde/README.md), и это зашито в листинге. Без пятого
# аргумента образы соберутся, но клавиша будет указывать на файл, которого на
# диске нет.
VDE=${5:-}
[ -z "$VDE" ] || VDE=$(cd "$(dirname "$VDE")" && pwd)/$(basename "$VDE")
[ -z "$VDE" ] || [ -f "$VDE" ] || { echo "нет редактора: $VDE" >&2; exit 1; }
# Авторская документация лежит рядом с редактором, в dist/ (её добывает
# vde/fetch-src.sh). Руководство большое: на дискету кладём и его, и краткую
# справку, а на квазидиск -- только справку, там 256 КБ на всё.
VDEDOC=
VDEQRF=
if [ -n "$VDE" ]; then
    [ -f "$(dirname "$VDE")/dist/vde266.doc" ] && VDEDOC=$(dirname "$VDE")/dist/vde266.doc
    [ -f "$(dirname "$VDE")/dist/vde266.qrf" ] && VDEQRF=$(dirname "$VDE")/dist/vde266.qrf
fi
[ -f "$ROM" ] || { echo "нет МикроДОС: $ROM" >&2; exit 1; }
ROM=$(cd "$(dirname "$ROM")" && pwd)/$(basename "$ROM")
mkdir -p "${3:-out}"
# все пути -- абсолютные: шаг записи ОС выполняется со сменой каталога, и
# относительный путь там молча превращается в «файла нет» (эмулятор в таком
# случае поднимается с пустым квазидиском, а не сообщает об ошибке)
OUT=$(cd "${3:-out}" && pwd)
# Раскладка дописанного кода: tools/layout.py выводит её из листинга, печатает
# таблицу и проверяет, что никто никому не налез на ногу и что всё уместилось
# в отведённые места. Файл потом читает check-funcs.sh -- он ставит по нему
# сторожа целости.
CO_LAYOUT=$OUT/layout.txt
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
#    пусковая цепочка листинга читает вектор E213 и раскладывает прочитанное
#    четырём операндам. Зашитое значение так и остаётся от T-34 и никого не
#    трогает, зато CO.COM выходит один на все сборки T-72.

# 2. Собираем CO из своего исходника: co-src/co.asm. Раньше здесь шла череда
# питоновских правок поверх подлинного co.com -- теперь всё, что сборка
# добавляет к CO, живёт в самом листинге:
#
#   co.asm     -- тело образа, 0100-40FF; каждое расхождение с подлинным
#                 помечено словом ПРАВКА и сверяется check-src.sh;
#   okno.asm   -- накладки, которые при старте переезжают в окно ОЗУ (A448);
#   pusk.asm   -- пусковая цепочка, работает по адресу загрузки;
#   stek.asm   -- то, что при старте переезжает под стек (B75C);
#   proba.asm  -- проба состава оборудования, тоже пусковая.
#
# Подлинный co.com из первого аргумента нужен теперь только затем, чтобы рядом
# с ним взять комплект: CO.PRM и прочее.
python3 "$HERE/tools/asm8080.py" "$HERE/co-src/co.asm" -o "$OUT/CO.COM" >/dev/null
echo "CO.COM: $(wc -c < "$OUT/CO.COM") байт"

# 2a. Раскладка дописанного: всё ли уместилось и не налез ли кто на соседа.
#     Куски берутся из листинга по меткам, свободные места в окне и под стеком
#     -- перебором по тому же листингу (tools/winholes.py).
python3 "$HERE/tools/winholes.py" --check
python3 "$HERE/tools/layout.py" "$HERE/co-src/co.asm" "$CO_LAYOUT"

# 3. HDIR -- каталог винчестера, отдельная программа. Кладём в оба образа,
#    поэтому собираем здесь, а не только в make-release.sh.
python3 "$HERE/tools/asm8080.py" "$HERE/tools/hdir.asm" -o "$OUT/HDIR.COM" >/dev/null
echo "HDIR.COM: $(wc -c < "$OUT/HDIR.COM") байт"

# 3a. Справка. Источник -- docs/co-help.md, оригинальный co.hlp больше не
#     берётся: в маркдауне тот же текст, и правки под T-72 (клавиша "F2" в
#     просмотрщике, символы в CO.EXT) живут там, а не заплаткой поверх файла.
python3 "$HERE/tools/mkhlp.py" "$HERE/docs/co-help.md" -o "$OUT/CO.HLP"

# 3b. Список переноса CO.ZGR. Раньше он брался готовым: на дискете лежал
#     список рабочего диска на два десятка имён, а в архиве выпуска --
#     авторский на восемь, где половины файлов в выпуске нет (FORMATM.COM),
#     зато нет HDIR. Собираем сам, одним списком на оба -- tools/mkzgr.py.
python3 "$HERE/tools/mkzgr.py" -o "$OUT/CO.ZGR" ${VDE:+--vde}

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
    # Предел кадров -- 3000. На 1800 шаг срывался через раз: сценарий печатает
    # команду неспешно (иначе ССР теряет знаки), и на медленной загрузке набор
    # не успевал закончиться до предела. Ловила это сверка даты системы ниже,
    # но выпуск при этом просто не собирался.
    #
    # каталог прогонов может и отсутствовать -- на свежем клоне или в worktree;
    # без него cd ниже молча срывается, и шаг записи ОС не выполняется вовсе
    mkdir -p "$HERE/run"
    ( cd "$HERE/run" && V06X_EDD_SAVE="$OUT/co-t72.edd" "$V06X" --rom "$ROM" \
        --edd "$OUT/os-base.edd" --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" \
        --script "$HERE/scripts/write-os.chai" \
        --max-frame 3000 --novideo --nosound >/dev/null 2>&1 ) || true
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
[ -z "$VDE" ] || python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$VDE" VDE.COM
[ -z "$VDEQRF" ] || python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" "$VDEQRF" VDE266.QRF
# Архиватор и показательный архив. CO каталог .PK2 читает сама, а распаковку
# отдаёт ARC2 -- без него в архиве видно только список. В репозитории его нет
# (чужая программа), берём из комплекта, если положили; архив собирает
# tools/mkdemo.sh -- им же, в эмуляторе, иначе распаковки не выйдет.
for f in ARC2.COM DEMO.PK2; do
    [ -f "$CODIR/$f" ] && python3 "$HERE/tools/kdimg.py" put "$OUT/co-t72.edd" \
        "$CODIR/$f" "$f"
done
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
# CO.ZGR -- только на дискете: список нужен CO, когда её подняли не с C:.
python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$OUT/CO.ZGR" CO.ZGR
[ -z "$VDE" ] || python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$VDE" VDE.COM
[ -z "$VDEQRF" ] || python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$VDEQRF" VDE266.QRF
[ -z "$VDEDOC" ] || python3 "$HERE/tools/cpmimg.py" --geom fdd put "$OUT/co-t72.fdd" "$VDEDOC" VDE266.DOC
for f in ARC2.COM DEMO.PK2; do
    [ -f "$CODIR/$f" ] && python3 "$HERE/tools/cpmimg.py" --geom fdd put \
        "$OUT/co-t72.fdd" "$CODIR/$f" "$f"
done
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
