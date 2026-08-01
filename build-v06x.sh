#!/bin/sh
# Сборка эмулятора v06x под macOS. Штатный `make` тут не работает: он берёт
# Makefile для линукса, а в нём boost ищется не там и в списке есть
# libboost_system, которой в современном boost уже нет.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
B=${BOOST_LIB_DIR:-$(brew --prefix)/lib}
cd "$HERE/tools/vector06sdl"
make -f Makefile.darwin -j8 build/v06x \
    MT= \
    BOOST_LIBRARY_PATH= \
    EXTRA_DEFS="-I$(brew --prefix)/include" \
    BOOST_LDFLAGS="$B/libboost_program_options.a $B/libboost_thread.a \
                   $B/libboost_chrono.a $B/libboost_filesystem.a"
echo "готово: tools/vector06sdl/build/v06x"
