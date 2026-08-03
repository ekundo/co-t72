#!/bin/sh
# Собрать Emu80 (вариант lite на SDL) под macOS -- он умеет НЖМД, чего нет у v06x.
#
# Штатный Makefile.lite под макось не идёт: заголовки GL лежат иначе, а типы
# расширений (PFNGL...) Apple не даёт -- их подкладывает SDL. Правка исходника --
# в patches/emu80-macos.diff.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$HERE/tools/emu80v4
[ -d "$SRC" ] || { echo "нет исходников: $SRC (git clone https://github.com/vpyk/emu80v4)" >&2; exit 1; }

cd "$SRC"
grep -q "__APPLE__" src/sdl/sdlPalWindow.h || patch -p1 < "$HERE/patches/emu80-macos.diff"
sed -i.bak 's|-lGL|-framework OpenGL|; s|CFLAGS = -c -Wall -std=c++11 `sdl2-config --cflags`|CFLAGS = -c -Wall -std=c++11 -I/opt/homebrew/include `sdl2-config --cflags`|' Makefile.lite
make -f Makefile.lite -j8

mkdir -p "$HERE/stand"
cp Emu80lite "$HERE/stand/"
for f in vector emu80.conf dbgfont.bin; do
    [ -e "$HERE/stand/$f" ] || cp -r "/Applications/Emu80qt.app/Contents/MacOS/$f" "$HERE/stand/"
done
# На стенде звук только мешает: МикроДОС щёлкает на каждую клавишу.
sed -i.bak 's/^emulation.volume = .*/emulation.volume = 0/' "$HERE/stand/emu80.conf"
rm -f "$HERE/stand/emu80.conf.bak"
echo "готово: stand/Emu80lite (конфиги взяты из установленного Emu80qt)"
echo
echo "прогон без окна:"
echo "  HDD=~/Documents/vector.hdd ./emu80.sh out-hx/co-t72.edd boot+900"
echo "посмотреть глазами:"
echo "  cd stand && ./Emu80lite --platform vector --edd ../out-hx/co-t72.edd --hdd ~/Documents/vector.hdd"
