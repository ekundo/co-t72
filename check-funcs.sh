#!/bin/sh
# Прогнать CO по его функциям и проверить каждую двумя мерками.
#
#   ./check-funcs.sh out/            [os-t72hx.rom]
#
# Первая мерка -- функция действительно отработала. Критерий объективный: у CO
# две таблицы «клавиша -> обработчик», по 05DB и 0638, и сценарий засчитывается
# только если адрес обработчика попал в карту исполнения. Без этого «тест»
# доказывал бы лишь то, что эмулятор не упал: нажатие, которое CO проглотил,
# выглядит точно так же, как отработавшее.
#
# Вторая колонка -- подэкранная область A000-DFFF: что CO успел положить туда
# за сценарий. Это справка, а не приговор: CO там и работает, увести его оттуда
# пока некуда. Колонка нужна для будущего диска D: -- по ней будет видно, какие
# функции ещё держат данные в окне. DFC9-DFFF не в счёт, это сама ОС.
#
# Клавиши шлются сканкодами SDL без модификаторов, поэтому «СС+цифра» набирается
# как Shift плюс клавиша: keytyper понимает префиксы \001 (нажать) и \002
# (отпустить).
#
# Раскладка Вектора не совпадает с хостовой, и вслепую тут не угадать. Коды
# сняты с живого Вектора -- слежением за ячейкой B693, куда CO кладёт код нажатой
# клавиши:
#
#     хостовая '='        -> 2D '-'   снять все метки
#     Shift + '='         -> 3D '='   отметить как на другой панели
#     Shift + ';'         -> 2B '+'   отметить по маске
#     хостовая '-'        -> 40 '@'
#     Shift + '/'         -> 3F '?'
#     Escape              -> АР2
#     F8                  -> СТР
#     Backspace           -> ЗБ,  Return -> ВК,  Tab -> ТАБ,  правый Alt -> ПС
#     F7                  -> стрелка влево-вверх (в просмотрщике -- на весь экран)
#
# И ещё: по справке CO часть клавиш действует только при пустой командной
# строке, поэтому сценарии, где до этого открывалось приглашение, надо
# разделять -- иначе ввод уходит в него.
#
# Чего тут нет: СС+7 (выбор дискеты НЖМД) -- v06x не эмулирует винчестер, эту
# функцию можно гонять только в Emu80.
set -e

OUT=${1:?каталог сборки, например out/}
HERE=$(cd "$(dirname "$0")" && pwd)
V06X=$HERE/tools/vector06sdl/build/v06x
ROM=${2:-$HERE/t72/os-t72hx.rom}
# путь к МикроДОС -- абсолютным, и проверить, что файл есть: прогон идёт со
# сменой каталога, относительный путь тут превращается в "файла нет". Эмулятор
# в этом случае поднимает свой загрузчик, CO не стартует вовсе, а прогон
# показывает "отработало" по всем сценариям -- ровно то, чего от него не ждут.
[ -f "$ROM" ] || { echo "нет МикроДОС: $ROM" >&2; exit 1; }
ROM=$(cd "$(dirname "$ROM")" && pwd)/$(basename "$ROM")
RUN=$HERE/run
OUT=$(cd "$OUT" && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$RUN"

# Куски, куда никто не должен писать: это наш дописанный код. Их адреса
# сборка записала в layout.txt, а сторож стека сидит в самом эмуляторе.
GUARD=$(python3 -c 'import sys,os; rows=[l.strip().split(",") for l in open(sys.argv[1])] if os.path.exists(sys.argv[1]) else []; print(",".join("%04X-%04X" % (int(r[1],16), int(r[1],16)+int(r[2])-1) for r in rows if len(r)>2 and r[0] in ("окно","стек")))' "$OUT/layout.txt")

ok=0; bad=0

# KDFIX=1 -- наложить в ОЗУ диагностическую правку драйвера квазидиска (см.
# scripts/kd2-patch.inc) до старта CO: с ней обмен с D: идёт из любого буфера.
# Нужна, чтобы отделить «буфер в окне A000-DFFF» от прочих причин.
KDPATCH=; KDCALL=
if [ -n "${KDFIX:-}" ]; then
    KDPATCH=$(cat "$HERE/scripts/kd2-patch.inc")
    KDCALL='if (frameno == 400) { kd_patch() }'
fi

# DRIVE=D -- гонять те же сценарии с панелью на втором квазидиске. Подключается
# второй --edd (копия сборочного, чтобы было с чем работать), и перед клавишами
# сценария панель переводится на D: обычным путём: 7-Диск, стрелка вправо, ВК.
# Сценарий в этом случае набирается позже: CO поднимается только к 1300-му кадру,
# а переключение надо успеть сделать после него.
#
# DRIVE=B -- то же самое с панелью на втором дисководе. Ему подключается вторая
# дискета (копия сборочной): каталог диска B: CO держит копией в ОЗУ по 4000, и
# всё, что сборка дописала по адресу загрузки, этим каталогом затирается. Без
# такого прогона это и проскочило в 2.2.2.
DRIVE=${DRIVE:-C}
SWITCH=; PROBEAT=1500; MAXFRAME=3200; EDD2=; FDD2=
if [ "$DRIVE" = "D" ]; then
    SWITCH='if (frameno == 1400) { keytyper.types([60, "7", 200, "Right", 60, "Return", 200]) }'
    PROBEAT=2100
    MAXFRAME=4200
elif [ "$DRIVE" = "B" ]; then
    SWITCH='if (frameno == 1400) { keytyper.types([60, "7", 200, "Left", 60, "Return", 200]) }'
    PROBEAT=2100
    MAXFRAME=4200
fi

probe() {   # имя, обработчик, клавиши для keytyper, [чужой]
    # Четвёртым словом «чужой» помечаются сценарии, которые доводят дело до
    # запуска программы с диска: дальше памятью распоряжается она, и сторож
    # целости нашего кода к ней не относится -- CO там уже нет, а когда
    # вернётся, загрузится заново.
    name=$1; want=$2; keys=$3; alien=${4:-}
    # ONLY=имя -- прогнать один сценарий: удобно, когда разбираешься с ним
    # по следу обращений, а не смотришь общую картину.
    [ -n "${ONLY:-}" ] && [ "$ONLY" != "$name" ] && return 0
    cat > "$TMP/$name.chai" <<EOF
$KDPATCH
def framefunc(frameno) {
    $KDCALL
    $SWITCH
    if (frameno == $PROBEAT) { keytyper.types([60, $keys]) }
    keytyper.onframe()
}
add_callback("frame", framefunc)
EOF
    cp "$OUT/co-t72.edd" "$TMP/$name.edd"
    # Панели в образе -- какими их оставил хозяин рабочего диска, а сценариям
    # нужна известная пара: меню дисков закольцовано, и "вправо" от разных букв
    # ведёт в разные места. Поэтому в копию кладём эталонный CO.PRM сборки.
    [ -f "$OUT/CO.PRM" ] && python3 "$HERE/tools/kdimg.py" put \
        "$TMP/$name.edd" "$OUT/CO.PRM" CO.PRM >/dev/null
    if [ "$DRIVE" = "D" ]; then
        cp "$OUT/co-t72.edd" "$TMP/$name-d.edd"
        EDD2="--edd $TMP/$name-d.edd"
    elif [ "$DRIVE" = "B" ]; then
        cp "$OUT/co-t72.fdd" "$TMP/$name-b.fdd"
        FDD2="--fdd $TMP/$name-b.fdd"
    fi
    { ( cd "$RUN" && V06X_COV_LO=0x0100 V06X_COV_HI=0xBFFF V06X_COV_FILE="$TMP/$name.cov" \
        V06X_DATA_LO=0xA000 V06X_DATA_HI=0xDFFF V06X_DATA_FILE="$TMP/$name.dat" \
        V06X_GUARD="$GUARD" V06X_RAM_SAVE="$TMP/$name.ram" \
        "$V06X" --rom "$ROM" --fdd "$OUT/co-t72.fdd" $FDD2 --edd "$TMP/$name.edd" $EDD2 \
        --script "$HERE/tools/vector06sdl/scripts/robotnik.chai" \
        --script "$TMP/$name.chai" \
        --max-frame $MAXFRAME --novideo --nosound >/dev/null 2>&1 ) || true; } 2>/dev/null
    # COVDIR -- куда складывать карты исполнения: по ним видно, какой код за
    # весь прогон ни разу не исполнялся (кандидаты в мёртвый).
    # имя с буквой диска: прогоны на C:, B: и D: идут по разным веткам кода,
    # и складывать их надо вместе, а не поверх друг друга
    [ -n "${COVDIR:-}" ] && { mkdir -p "$COVDIR"; cp "$TMP/$name.cov" "$COVDIR/${DRIVE:-C}-$name.cov"; }
    # DATDIR -- куда складывать карты окна A000-DFFF. Сам след обращений весит
    # десятки мегабайт, поэтому кладём не его, а сводку: по байту на адрес,
    # 1 -- читали, 2 -- писали, 3 -- и то и другое. Их сводит tools/winmap.py.
    [ -n "${DATDIR:-}" ] && { mkdir -p "$DATDIR"; [ -n "${RAWDAT:-}" ] && cp "$TMP/$name.dat" "$DATDIR/"; }
    res=$(python3 - "$TMP/$name.cov" "$TMP/$name.dat" "$want" "${DATDIR:+$DATDIR/$name.win}" "$OUT/layout.txt" "$alien" "$TMP/$name.ram" <<'PY'
import os, re, sys
cov = open(sys.argv[1], 'rb').read()
hurt = {}                       # куда писал не наш код: адрес -> pc
want = int(sys.argv[3], 16)
fired = 'да ' if cov[want - 0x100] else 'НЕТ'
# CO вообще стартовал? Проверяем по отрисовке панели (091B): без неё прогон
# ничего не проверил, и "отработало" у всех сценариев -- ложь. Точка входа для
# этого не годится: relocstub.py переставляет её на свой стаб.
if not cov[0x091B - 0x100]:
    fired = 'НЕ_СТАРТОВАЛ'
# обменные подпрограммы ОС: они и кладут в память прочитанное с диска
OSPC = {0xE415, 0xE418, 0xE41C, 0xE41F, 0xE3C8, 0xE3CA,
        0xE489, 0xE48C, 0xE490, 0xE493}
win = set()
depth = {}                      # последние строки следа: глубина стека и сторож
# Сводка по всему окну: 1 -- читали, 2 -- писали, 4 -- это делал сам CO, а не
# дописанный сборкой код. Четвёртый разряд и решает, куда можно класть своё:
# наши накладки трогают окно сами, и без разбора по pc они выглядели бы как
# чужая занятая память.
seen = bytearray(0x4000)
OURS = ((0x40DB, 0x40FF), (0x4100, 0x4FFF), (0xA448, 0xA78B),
        (0xB740, 0xBBFF))   # стаб стека, пусковое, накладки в окне, код под стеком
for ln in open(sys.argv[2]):
    if ln.startswith('stack_low='):
        depth['low'] = ln.strip().split('=', 1)[1]
        continue
    if ln.startswith('stack_guard='):
        depth['guard'] = ln.strip().split('=', 1)[1]
        continue
    m = re.match(r'([rw]) ([0-9a-f]{4})=[0-9a-f]{2} pc=([0-9a-f]{4}) bank=([0-9a-f]{2})', ln)
    if not m:
        continue
    a, pc, bank = int(m.group(2), 16), int(m.group(3), 16), int(m.group(4), 16)
    # A000-DFFF -- это либо ОЗУ квазидиска, либо видеопамять: решает разряд 20h
    # в порте 10h. Буферы CO живут в квазидиске, а рисование идёт по тем же
    # адресам при погашенном окне -- без этой проверки экран выглядел бы как
    # занятая память.
    if 0xA000 <= a <= 0xDFFF and bank & 0x20:
        bit = 1 if m.group(1) == 'r' else 2
        if not any(lo <= pc <= hi for lo, hi in OURS):
            bit |= 4
            if bit & 2:
                hurt.setdefault(a, pc)
        seen[a - 0xA000] |= bit
    if pc in OSPC and not 0xDFC9 <= a <= 0xDFFF:
        win.add(a)

if len(sys.argv) > 4 and sys.argv[4]:
    open(sys.argv[4], 'wb').write(bytes(seen))
clean = 'чисто' if not win else '%04X-%04X' % (min(win), max(win))

# Цел ли дописанный код. Где он лежит, сборка записала в layout.txt; сюда
# никто, кроме него самого, писать не должен. Проверка ловит ровно то, на чём
# мы уже обожглись: меню пользователя чистило свою таблицу поверх нашего кода,
# и это вылезло только зависанием в одном сценарии из сорока.
guard = 'цел'
alien = len(sys.argv) > 6 and sys.argv[6]
if alien:
    guard = 'чужая_программа'
elif len(sys.argv) > 5 and os.path.exists(sys.argv[5]):
    mine = []
    for ln in open(sys.argv[5]):
        where, addr, length, _ = ln.strip().split(',', 3)
        if where in ('окно', 'стек'):
            mine.append((int(addr, 16), int(addr, 16) + int(length) - 1))
    for a in sorted(hurt):
        if any(lo <= a <= hi for lo, hi in mine):
            guard = 'ЗАТЁРТ_%04X_из_%04X' % (a, hurt[a])
            break
# Вторая половина той же проверки -- стек. Стековые обращения в след не
# пишутся, поэтому за них отвечает сторож в самом эмуляторе: V06X_GUARD.
if guard == 'цел' and depth.get('guard'):
    guard = 'СТЕК_' + depth['guard'].replace(':', '_из_')
# Список панели: не завелось ли в нём двух строк с одним именем. Файл длиннее
# 16 КБ лежит в каталоге несколькими экстентами, и склейка сводит их в одну
# строку; если она перестанет работать, в списке появятся двойники, а сортировка
# CO на двух одинаковых строках лезет в соседние (см. tools/fix16k.py).
rows = 'нет_снимка'
if len(sys.argv) > 7 and os.path.exists(sys.argv[7]):
    ram = open(sys.argv[7], 'rb').read()
    rows = 'цел'
    seen = {}
    for i in range(ram[0xB689]):
        e = 0xA954 + i * 13
        key = bytes(ram[e:e + 8] + ram[e + 9:e + 12])
        if key in seen:
            rows = 'ДВОЙНИК_' + key.decode('koi8-r', 'replace').strip()
            break
        seen[key] = i
print('%s %s %s %s %s %d' % (fired, clean, guard, rows, depth.get('low', '----'),
                             sum(1 for b in cov if b)))
PY
)
    set -- $res
    printf '%-14s %-8s %-4s %-10s %-18s %-14s %-6s %s\n' "$name" "$want" "$1" "$2" "$3" "$4" "$5" "$6"
    case "$1:$3:$4" in
        да:цел:цел|да:чужая_программа:*|да:цел:нет_снимка) ok=$((ok+1)) ;;
        *) bad=$((bad+1)) ;;
    esac
}

printf '%-14s %-8s %-4s %-10s %-18s %-14s %-6s %s\n' функция обработчик было в_окне наш_код список стек адресов
printf '%-14s %-8s %-4s %-10s %-18s %-14s %-6s %s\n' -------------- -------- ---- ---------- ------------------ -------------- ------ --------

# Меню пользователя чистит у себя таблицу по B728-B755, а туда сборка
# кладёт свой код: после меню первое же перечитывание каталога с файлом
# длиннее 16 КБ уходит в затёртую склейку экстентов. Сценарий держит
# это место под присмотром -- см. docs/co-buffers.md.
probe менюпотом   045A '"2", 300, "Escape", 200, "7", 200, "Return", 400, "Down", 60, "Down", 60'
probe просмотрдлин 2870 '"Down", 30, "Down", 30, "3", 400, "Down", 30, "Down", 30, "Down", 30, "Down", 30, "Down", 30, "Down", 30, "Down", 30, "Down", 30, "Escape", 300, "7", 300'
probe вниз        045A '"Down", 40, "Down", 40'
probe вверх       0477 '"Down", 40, "Up", 40'
probe влево       0464 '"Left", 40'
probe вправо      0485 '"Right", 40'
probe панель      0BF7 '"Tab", 60'
probe пробел      036D '"Space", 60'
probe помощь      0616 '"1", 300'
probe меню        061C '"2", 300'
probe просмотр    06F7 '"Down", 40, "Down", 40, "3", 400'
probe редактор    068E '"4", 400'
probe копия       072E '"Tab", 80, "5", 250, "Return", 600'
probe имя         0688 '"6", 300'
probe диск        2870 '"7", 300'
probe убрать      06A6 '"Down", 40, "8", 300'
probe настройки   23AC '"9", 300'
probe экран       0498 '"0", 200'
probe отметить    22C7 '"\001Left Shift", 10, ";", 20, "\002Left Shift", 300'
probe снять       0344 '"=", 300'
probe какнасосед  37AD '"\001Left Shift", 10, "=", 20, "\002Left Shift", 300'
probe инверсия    3D69 '"/", 300'
probe поиск       0315 '";", 200, "C", 200'
probe запуск      06AC '"Down", 30, "Down", 30, "Down", 30, "Down", 30, "Down", 30, "Down", 60, "Return", 600' чужой
probe сс1         053C '"\001Left Shift", 10, "1", 20, "\002Left Shift", 300'
probe сс2         06A0 '"\001Left Shift", 10, "2", 20, "\002Left Shift", 300'
probe сс3         0700 '"\001Left Shift", 10, "3", 20, "\002Left Shift", 300'
probe сс4         0694 '"\001Left Shift", 10, "4", 20, "\002Left Shift", 300'
probe сс5         073A '"\001Left Shift", 10, "5", 20, "\002Left Shift", 300'
probe сс6         06EE '"\001Left Shift", 10, "6", 20, "\002Left Shift", 300'
probe сс8         213D '"\001Left Shift", 10, "8", 20, "\002Left Shift", 300'


# Глубокие сценарии: те же функции, но доведённые до конца. Мелкие пробы выше
# показывают, что обработчик вызвался; эти -- что он отработал целиком. Из них
# и набирается покрытие, на которое ловятся регрессии.
probe помощь2     0616 '"1", 300, "Down", 60, "Down", 60, "Up", 60, "Escape", 150'
probe наширину    3136 '"1", 300, "F7", 200, "Escape", 150'
probe просмотр2   06F7 '"Down", 40, "Down", 40, "3", 400, "Down", 60, "Down", 60, "F1", 60, "F4", 60, "Escape", 150'
probe меню2       061C '"2", 300, "Escape", 150'
probe копия2      072E '"Tab", 80, "5", 250, "Return", 700, "Return", 300'
probe имя2        0688 '"6", 250, "Z", 40, "Return", 500'
probe убрать2     06A6 '"Down", 40, "8", 250, "Return", 500'
probe диск2       2870 '"7", 250, "Right", 60, "Return", 500'
probe настройки2  23AC '"9", 250, "Right", 60, "Right", 60, "Return", 200, "Escape", 150'
probe строка      074A '"D", 40, "I", 40, "R", 40, "Return", 700'
probe маска       22C7 '"\001Left Shift", 10, ";", 20, "\002Left Shift", 250, "*", 40, "Return", 400'

echo
python3 - "$TMP" <<'PY'
import glob, os, sys
union = bytearray(0x4000)
for f in glob.glob(os.path.join(sys.argv[1], '*.cov')):
    c = open(f, 'rb').read()
    for i in range(min(len(c), len(union))):
        if c[i]:
            union[i] = 1
print('вместе исполнено адресов CO: %d' % sum(union))
PY
echo "отработало $ok, не отработало $bad"
