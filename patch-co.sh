#!/bin/sh
# Turn the original CO v2.0 (co.com, Шишатский С.М., 1993, требует T-34)
# into a build that runs under MDOS T-72, and put it on a quasi-disk image.
#
#   ./patch-co.sh work/co/co.com work/os-t72/os-t72.edd out/
#
# Needs a dis8080.py listing of the original binary; the one checked in as
# co-cov.asm was produced with an execution-coverage map, see README.
set -e

CO=${1:?original co.com}
EDD=${2:?genuine os-t72.edd to use as a base}
OUT=${3:-out}
HERE=$(dirname "$0")
mkdir -p "$OUT"

# 1. BIOS disk handler moved: T-34 has it at E2BD, T-72 at E2ED. CO hooks the
#    disk vector at E213 with its own filter and passes calls through to a
#    hardcoded continuation, so the constant has to follow the handler.
python3 "$HERE/tools/patchaddr.py" "$CO" "$OUT/co1.com" \
    --listing "$HERE/co-cov.asm" --map E2BD:E2ED

# 2. The banner is stored in KOI-7 and selected with the single-byte control
#    0Eh. T-72 has neither that control nor a KOI-7 font, so the text moves to
#    KOI-8, which both monitors support.
python3 "$HERE/tools/koi7to8.py" "$OUT/co1.com" "$OUT/co2.com" \
    --at 0x3FB8 --len 0x67

# 3. CO's output trap saves the stack pointer at A838 and the screen vector at
#    A83A -- inside the quasi-disk bank window. The trap runs from inside the
#    T-72 screen driver, which switches that bank off, so the values read back
#    are video memory. Move both to page zero.
python3 "$HERE/tools/patchaddr.py" "$OUT/co2.com" "$OUT/CO.COM" \
    --listing "$HERE/co-cov.asm" --map A838:0040 --map A83A:0042

rm -f "$OUT/co1.com" "$OUT/co2.com"

# 4. Install onto the quasi-disk: CO plus its support files, and INITIALC.SUB
#    so MicroDOS starts it automatically.
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
