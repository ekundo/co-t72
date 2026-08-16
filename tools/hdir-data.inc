; ------------------------- переменные --------------------------------------

oldsp:  DW 0
ndisk:  DW 0                    ; сколько дискет на винчестере
phys:   DW 0                    ; секторов на дорожке и головок
phcyl:  DW 0                    ; цилиндров
dcur:   DW 0
dto:    DW 0
rptr:   DW 0
rleft:  DB 0
nrng:   DB 0
rng:    DS NRNG*4
tp:     DW 0                    ; разбор командной строки
tc:     DB 0
tfrom:  DW 0
tto:    DW 0
fptr:   DW 0
flen:   DB 0
pat:    DS 11
lba:    DB 0,0,0
rdbuf:  DW 0
bptr:   DW 0
bcnt:   DB 0
eptr:   DW 0
ecnt:   DB 0
sptr:   DW 0
scnt:   DB 0
used:   DW 0
recs:   DW 0
nall:   DB 0
nmatch: DB 0
curnam: DS 11
numbuf: DS 6
pwid:   DB 0
col:    DB 0
nopage: DB 0                    ; не останавливаться на страницах
mode:   DB 0                    ; 0 -- каталог, иначе буква ключа
label:  DB '                                '
sign:   DB 'HDLB'               ; подпись сектора метки
lbaa:   DB 0,0,0                ; адреса секторов при обмене
lbab:   DB 0,0,0
left:   DW 0
lines:  DB 0
totf:   DW 0
totd:   DW 0

stack:  EQU $+128               ; свой стек: у ПКК он лежит под буфером дисковода
dirbuf: EQU stack               ; каталог дискеты, 4 КБ; всё это уже за концом файла
sbuf1:  EQU dirbuf+4096         ; сектор: метка, очистка, обмен
sbuf2:  EQU sbuf1+512           ; второй сектор -- только для обмена
        END
