#!/bin/sh
# Собрать Emu80 (вариант lite на SDL) под macOS -- он умеет НЖМД, чего нет у v06x.
#
# Исходники -- форк https://github.com/ekundo/emu80v4, ветка patches. Поверх
# upstream там лежат сборка под мак и стенд EmuAuto (прогон без окна, снимки,
# нажатия по сценарию, трасса), которые раньше накладывались на upstream патчем.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$HERE/tools/emu80v4
[ -d "$SRC" ] || { echo "нет исходников: $SRC (git clone -b patches https://github.com/ekundo/emu80v4 tools/emu80v4)" >&2; exit 1; }
[ -f "$SRC/src/EmuAuto.h" ] || { echo "в $SRC нет стенда EmuAuto: нужна ветка patches форка ekundo/emu80v4" >&2; exit 1; }

cd "$SRC"
make -f Makefile.lite -j8

mkdir -p "$HERE/stand"
cp build_lite/Emu80lite "$HERE/stand/"
# Конфиги кладутся только в первый раз: у стенда свои платформы T-72 (vector/t72*.conf).
for f in vector emu80.conf dbgfont.bin; do
    [ -e "$HERE/stand/$f" ] || cp -R "dist/$f" "$HERE/stand/"
done
# На стенде звук только мешает: МикроДОС щёлкает на каждую клавишу.
sed -i.bak 's/^emulation.volume = .*/emulation.volume = 0/' "$HERE/stand/emu80.conf"
rm -f "$HERE/stand/emu80.conf.bak"
echo "готово: stand/Emu80lite"
echo
echo "прогон без окна:"
echo "  HDD=~/Documents/vector.hdd ./emu80.sh out-hx/co-t72.edd boot+900"
echo "посмотреть глазами:"
echo "  cd stand && ./Emu80lite --platform vector --edd ../out-hx/co-t72.edd --hdd ~/Documents/vector.hdd"
