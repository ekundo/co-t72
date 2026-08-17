; ---------------------------------------------------------------------------
; HDIR -- каталоги «дискет» НЖМД и поиск файла по всему винчестеру.
;
; Это общая часть: код без единого сообщения. Сообщения подключают hdir.asm
; (по-русски) и hdir-en.asm (по-английски) -- там же и описание команды.
;
; Программа не трогает назначение дискет на А: и Б: и вообще ничего не просит
; у системы: НЖМД она читает сама, теми же портами и в том же порядке, что и
; БСВВ (ПП L_RWHD в _E200h.asm). Раскладка винчестера:
;
;   сектор 0        заголовок: физика диска и число «дискет»
;   секторы 2..81   системная область (дорожки 0..7), общая на все дискеты
;   дискета N       первый сектор 0622h*(N-1)+2; каталог лежит восемью
;                   дорожками дальше, это +80 секторов: 128 записей, 8 секторов
;
; Число дискет не зашито в программу: оно читается из заголовка по смещению
; 84h -- ровно оттуда же его берёт при старте и сама система (L_IHDD). Рядом
; физика: 80h -- секторов на дорожке, 81h -- головок, 82h -- цилиндры. В
; цилиндрах, похоже, лежит номер последнего, а не количество: 20h * 10h *
; (3E1h+1) = 508928 секторов -- как раз под 144h дискет, на цилиндр меньше их
; помещается только 143h.
;
; Стек свой: у T-72 под BC00h буфер дисковода, и стек ПКК он затирает -- это
; та же ловушка, из-за которой не работал CO.
;
; Единственный адрес самой ОС -- байт REDIR: ПКК держит в нём признак того, что
; вывод перенаправлен в файл (`HDIR *.COM >SPISOK.TXT`). Разбирает `>` он сам,
; из хвоста командной строки эта часть уже вырезана, и заметить перенаправление
; иначе нельзя, а останавливаться на каждой странице при выводе в файл незачем:
; в файл попадёт подсказка, а программа встанет и будет ждать клавишу. БДОС у
; всех трёх сборок один и тот же, так что адрес общий; если он когда-нибудь
; переедет, вернётся всего лишь прежнее поведение -- и его снимает ключ /N.
; ---------------------------------------------------------------------------

BDOS    EQU 0005h               ; вход БДОС
TAIL    EQU 0080h               ; хвост командной строки: длина и знаки
REDIR   EQU 0E10Eh              ; ПКК: FFh -- вывод идёт в файл (L_C613 в _BE00h.asm)

SPD     EQU 0622h               ; секторов на одну «дискету»
DIRSEC  EQU 82                  ; от начала дискеты до каталога: 2 + 8 дорожек
DIRLEN  EQU 8                   ; секторов в каталоге (128 записей по 32 байта)
NENT    EQU 128                 ; записей в каталоге
DATABL  EQU 390                 ; блоков под файлы: 392 всего минус 2 под каталог

CH_VK   EQU 0Dh                 ; ВК
CH_AR2  EQU 1Bh                 ; АР2 -- «хватит»
PAGE    EQU 24                  ; строк на страницу: экран 80x25, и ещё строка
                                ; уходит под саму подсказку
NRNG    EQU 8                   ; сколько диапазонов помещается в командной строке
LABSEC  EQU 1568                ; сектор метки: сразу за файловой системой дискеты
LABLEN  EQU 32                  ; знаков в метке
SIGNLEN EQU 4                   ; длина подписи в секторе метки

        ORG 0100h

start:  LXI  H,0
        DAD  SP
        SHLD oldsp
        LXI  SP,stack
        CALL upcase             ; ПКК приводит хвост к заглавным, но не будем верить
        CALL ishelp
        JZ   help
        LDA  REDIR              ; вывод в файл -- значит, без остановок
        INR  A
        JNZ  st1
        DCR  A                  ; обратно FFh
        STA  nopage
st1:    CALL parse
        CALL hdinit             ; заголовок винчестера
        JNZ  nohdd
        LHLD ndisk
        MOV  A,H
        ORA  L
        JZ   nodisks
        CALL banner
        LDA  mode               ; обмен, очистка и метка -- вместо каталога
        CPI  'X'
        JZ   doswap
        CPI  'Z'
        JZ   doerase
        CPI  'M'
        JZ   dolabel
        LDA  nrng               ; диапазонов нет -- значит все дискеты
        ORA  A
        JNZ  go
        LXI  H,1
        SHLD rng
        LHLD ndisk
        SHLD rng+2
        MVI  A,1
        STA  nrng

; ------------------------- обход дискет ------------------------------------

go:     LXI  H,rng
        SHLD rptr
        LDA  nrng
        STA  rleft
rloop:  LDA  rleft
        ORA  A
        JZ   total
        DCR  A
        STA  rleft
        LHLD rptr
        MOV  E,M                ; начало диапазона
        INX  H
        MOV  D,M
        INX  H
        XCHG
        SHLD dcur
        XCHG
        MOV  E,M                ; конец диапазона
        INX  H
        MOV  D,M
        INX  H
        SHLD rptr
        XCHG
        SHLD dto
dloop:  LHLD dcur
        MOV  A,H                ; дискета 0 -- это флоповод, её тут нет
        ORA  L
        JZ   dnext
        XCHG
        LHLD ndisk              ; за последнюю дискету не заглядываем
        XCHG
        CALL cmp16
        JZ   dl1
        JNC  rloop
dl1:    XCHG
        LHLD dto
        XCHG
        CALL cmp16              ; dcur > dto -- диапазон кончился
        JZ   dgo
        JNC  rloop
dgo:    CALL brk                ; АР2 в любой момент прекращает работу
        CALL onedisk
dnext:  LHLD dcur
        INX  H
        SHLD dcur
        JMP  dloop

; Итог: сколько нашлось и на скольких дискетах.
total:  LDA  col
        ORA  A
        CNZ  crlf
        LDA  mode
        CPI  'L'
        JZ   totlab
        LXI  H,msgtot
        CALL puts
        LHLD totf
        MVI  A,1
        STA  pwid
        CALL pdec
        LXI  H,msgtot2
        CALL puts
        LHLD totd
        CALL pdec
        LXI  H,msgtot3
        CALL puts
        CALL crlf
        JMP  exit               ; ... и мимо итога для /L

totlab: LXI  H,msgtotl
        CALL puts
        LHLD totd
        MVI  A,1
        STA  pwid
        CALL pdec
        CALL crlf

exit:   LHLD oldsp
        SPHL
        RET

nohdd:  LXI  H,msgnohd
        CALL puts
        CALL crlf
        JMP  exit
nodisks:LXI  H,msgnodk
        CALL puts
        CALL crlf
        JMP  exit
help:   LXI  H,msghelp
        CALL puts
        JMP  exit

; ------------------------- одна дискета ------------------------------------

; Читает каталог дискеты dcur, считает и печатает. Дискету без совпадений
; не показывает вовсе -- иначе за пустыми дискетами не видно занятых.
onedisk:LDA  mode
        CPI  'L'
        JZ   onelab
        CALL rddir
        JNZ  oderr
        CALL count
        LDA  nmatch
        ORA  A
        RZ
        LHLD totd
        MOV  A,H                ; дискеты отделяем друг от друга пустой строкой
        ORA  L
        CNZ  crlf
        LHLD totd
        INX  H
        SHLD totd
        CALL diskhdr
        JMP  list
; Одна строка списка меток: номер и метка. Дискеты без метки пропускаем.
onelab: CALL getlab
        RNZ
        LHLD dcur
        CALL phex4
        CALL prlab
        LHLD totd
        INX  H
        SHLD totd
        JMP  crlf

oderr:  LXI  H,msgerr           ; «дискета NNNN -- ошибка НЖМД»
        CALL puts
        LHLD dcur
        CALL phex4
        CALL crlf
        RET

; Шапка дискеты: номер, сколько файлов, сколько свободно.
diskhdr:LXI  H,msgdisk
        CALL puts
        LHLD dcur
        CALL phex4
        LXI  H,msgfil
        CALL puts
        LDA  nall
        MOV  L,A
        MVI  H,0
        MVI  A,3
        STA  pwid
        CALL pdec
        LXI  H,msgfree
        CALL puts
        LHLD used               ; свободно = (390 - занято) * 2 килобайта
        XCHG
        LXI  H,DATABL
        MOV  A,L
        SUB  E
        MOV  L,A
        MOV  A,H
        SBB  D
        MOV  H,A
        JNC  dh1
        LXI  H,0                ; каталог с мусором -- лишь бы не отрицательное
dh1:    DAD  H
        MVI  A,4
        STA  pwid
        CALL pdec
        LXI  H,msgk
        CALL puts
        CALL putlab
        JMP  crlf

; Печать совпавших файлов в четыре колонки.
list:   XRA  A
        STA  col
        LXI  H,dirbuf
        SHLD eptr
        MVI  A,NENT
        STA  ecnt
li1:    LHLD eptr
        MOV  A,M
        CPI  16
        JNC  li8                ; свободная или неразмеченная запись
        CALL isfirst            ; печатаем только нулевой экстент
        JNZ  li8
        LHLD eptr
        CALL match
        JNZ  li8
        LHLD totf
        INX  H
        SHLD totf
        LHLD eptr
        CALL pname
        LHLD eptr
        CALL fsize              ; HL = записей во всём файле
        LXI  D,7                ; в килобайтах, с округлением вверх
        DAD  D
        MVI  B,3
li2:    MOV  A,H
        ORA  A
        RAR
        MOV  H,A
        MOV  A,L
        RAR
        MOV  L,A
        DCR  B
        JNZ  li2
        MVI  A,3
        STA  pwid
        CALL pdec
        LXI  H,msgk
        CALL puts
        CALL column
li8:    LHLD eptr
        LXI  D,32
        DAD  D
        SHLD eptr
        LDA  ecnt
        DCR  A
        STA  ecnt
        JNZ  li1
        LDA  col                ; хвост строки
        ORA  A
        RZ
        XRA  A
        STA  col
        JMP  crlf

; Разделитель колонок: три раза пробелы, на четвёртый -- перевод строки.
column: LDA  col
        INR  A
        CPI  4
        JZ   co1
        STA  col
        MVI  A,' '
        CALL putc
        MVI  A,' '
        JMP  putc
co1:    XRA  A
        STA  col
        JMP  crlf

; Имя записи (HL) как «ИМЯ     .РСШ».
pname:  INX  H
        MVI  B,8
pn1:    MOV  A,M
        ANI  7Fh
        PUSH H
        PUSH B
        CALL putc
        POP  B
        POP  H
        INX  H
        DCR  B
        JNZ  pn1
        MVI  A,'.'
        PUSH H
        CALL putc
        POP  H
        MVI  B,3
pn2:    MOV  A,M
        ANI  7Fh
        PUSH H
        PUSH B
        CALL putc
        POP  B
        POP  H
        INX  H
        DCR  B
        JNZ  pn2
        MVI  A,' '
        JMP  putc

; ------------------------- разбор каталога ---------------------------------

; Проход по каталогу: сколько файлов (nall), сколько подошло под шаблон
; (nmatch) и сколько блоков занято (used). Блок в CP/M принадлежит ровно
; одному файлу, поэтому занятое место -- это просто число ненулевых ссылок.
count:  XRA  A
        STA  nall
        STA  nmatch
        LXI  H,0
        SHLD used
        LXI  H,dirbuf
        SHLD eptr
        MVI  A,NENT
        STA  ecnt
cn1:    LHLD eptr
        MOV  A,M
        CPI  16
        JNC  cn8
        LHLD eptr
        CALL blocks
        LHLD eptr
        CALL isfirst
        JNZ  cn8
        LDA  nall
        INR  A
        STA  nall
        LHLD eptr
        CALL match
        JNZ  cn8
        LDA  nmatch
        INR  A
        STA  nmatch
cn8:    LHLD eptr
        LXI  D,32
        DAD  D
        SHLD eptr
        LDA  ecnt
        DCR  A
        STA  ecnt
        JNZ  cn1
        RET

; Нулевой ли это экстент (HL -- запись). Номер экстента -- это младшие пять
; битов байта 12 и байт 14.
isfirst:LXI  D,12
        DAD  D
        MOV  A,M
        ANI  1Fh
        MOV  C,A
        INX  H
        INX  H
        MOV  A,M
        ORA  C
        RET

; Прибавить к used число занятых блоков записи (HL). Ссылки 16-битные:
; на дискете 392 блока, в байт номер не влезает.
blocks: LXI  D,16
        DAD  D
        MVI  B,8
        MVI  C,0
bl1:    MOV  A,M
        INX  H
        ORA  M
        INX  H
        JZ   bl2
        INR  C
bl2:    DCR  B
        JNZ  bl1
        MVI  B,0
        LHLD used
        DAD  B
        SHLD used
        RET

; Подходит ли имя записи (HL) под шаблон. Z -- да.
match:  INX  H
        LXI  D,pat
        MVI  B,11
ma1:    LDAX D
        CPI  '?'
        JZ   ma2
        MOV  C,A
        MOV  A,M
        ANI  7Fh
        CMP  C
        RNZ
ma2:    INX  H
        INX  D
        DCR  B
        JNZ  ma1
        XRA  A
        RET

; Размер файла в 128-байтовых записях: сумма по всем экстентам с этим именем.
; HL -- запись нулевого экстента.
fsize:  INX  H
        LXI  D,curnam
        MVI  B,11
fs1:    MOV  A,M
        ANI  7Fh
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  fs1
        LXI  H,0
        SHLD recs
        LXI  H,dirbuf
        SHLD sptr
        MVI  A,NENT
        STA  scnt
fs2:    LHLD sptr
        MOV  A,M
        CPI  16
        JNC  fs8
        LHLD sptr
        CALL samename
        JNZ  fs8
        LHLD sptr
        LXI  D,15
        DAD  D
        MOV  C,M                ; записей в этом экстенте
        MVI  B,0
        LHLD recs
        DAD  B
        SHLD recs
fs8:    LHLD sptr
        LXI  D,32
        DAD  D
        SHLD sptr
        LDA  scnt
        DCR  A
        STA  scnt
        JNZ  fs2
        LHLD recs
        RET

samename:INX H
        LXI  D,curnam
        MVI  B,11
sn1:    LDAX D
        MOV  C,A
        MOV  A,M
        ANI  7Fh
        CMP  C
        RNZ
        INX  H
        INX  D
        DCR  B
        JNZ  sn1
        XRA  A
        RET

; ------------------------- чтение НЖМД -------------------------------------

; Заголовок винчестера: число дискет и физика. A=0 -- диск ответил.
hdinit: LXI  H,0
        SHLD lba
        XRA  A
        STA  lba+2
        LXI  H,dirbuf
        CALL rdsec
        RNZ
        LHLD dirbuf+84h
        SHLD ndisk
        LHLD dirbuf+80h         ; секторов на дорожке и головок
        SHLD phys
        LHLD dirbuf+82h         ; последний цилиндр
        INX  H
        SHLD phcyl
        XRA  A
        RET

; Каталог дискеты dcur -> dirbuf. A=0 -- прочиталось.
rddir:  CALL seek
        LXI  H,dirbuf
        SHLD bptr
        MVI  A,DIRLEN
        STA  bcnt
rd1:    LHLD bptr
        CALL rdsec
        RNZ
        LHLD bptr
        LXI  D,512
        DAD  D
        SHLD bptr
        CALL lbainc
        LDA  bcnt
        DCR  A
        STA  bcnt
        JNZ  rd1
        XRA  A
        RET

; lba = SPD*(dcur-1) + DIRSEC. Умножения нет -- складываем, как это делает и
; сама система (LaD96A); дискет тут сотни, цикл ничего не стоит.
seek:   LXI  H,0
        SHLD lba
        XRA  A
        STA  lba+2
        LHLD dcur
        MOV  B,H
        MOV  C,L
        DCX  B
sk1:    MOV  A,B
        ORA  C
        JZ   sk2
        LXI  D,SPD
        CALL lbaadd
        DCX  B
        JMP  sk1
sk2:    LXI  D,DIRSEC
lbaadd: LHLD lba
        DAD  D
        SHLD lba
        RNC
        LDA  lba+2
        INR  A
        STA  lba+2
        RET

lbainc: LXI  D,1
        JMP  lbaadd

; lba на сектор метки дискеты dcur. Файловая система занимает 392 блока по
; 2 КБ -- это 1568 секторов из 1570, и последние два не принадлежат никому:
; БДОС до них не добирается, потому что их нет в таблице блоков.
seeklab:CALL seek
        LXI  D,LABSEC
        JMP  lbaadd

; Три байта от HL к DE -- для копий lba.
mov3:   MVI  B,3
mv1:    MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  mv1
        RET

; Прибавить единицу к трёхбайтовому числу по HL.
inc3:   INR  M
        RNZ
        INX  H
        INR  M
        RNZ
        INX  H
        INR  M
        RET

; Чтение сектора lba по адресу HL. Порядок работы с портами -- как в БСВВ.
rdsec:  SHLD rdbuf
        MVI  A,20h              ; чтение
        CALL rwcmd
        JZ   rderr              ; буфер данных не открылся
        LHLD rdbuf
        MVI  D,0
rs1:    IN   50h
        MOV  M,A
        INX  H
        IN   58h
        MOV  M,A
        INX  H
        DCR  D
        JNZ  rs1
        JMP  rwend

; Запись сектора lba из памяти по адресу HL. Байты уходят так же, как их
; посылает БСВВ: сначала старший в 58h, потом младший в 50h -- запись в 50h и
; отправляет слово.
wrsec:  SHLD rdbuf
        MVI  A,30h              ; запись
        CALL rwcmd
        JZ   rderr
        LHLD rdbuf
        MVI  D,0
ws1:    MOV  E,M
        INX  H
        MOV  A,M
        OUT  58h
        MOV  A,E
        OUT  50h
        INX  H
        DCR  D
        JNZ  ws1
rwend:  CALL ready
        ANI  0D5h
        SUI  50h                ; норма -- 50h или 58h
        RZ
rderr:  MVI  A,0FFh
        ORA  A
        RET

; Выставить адрес и отдать команду из A. Возвращает признак Z=1, если диск так
; и не открыл буфер данных.
rwcmd:  PUSH PSW
        LDA  lba+2
        OUT  55h                ; LBA [23..16]
        LDA  lba
        OUT  53h                ; LBA [7..0]
        LDA  lba+1
        OUT  54h                ; LBA [15..8]
        MVI  A,0E0h             ; режим LBA
        OUT  56h
        MVI  A,1                ; один сектор
        OUT  52h
        POP  PSW
        OUT  57h
        CALL ready
        ANI  08h                ; буфер ждёт обмена?
        RET

; Ждать готовности НЖМД. A=0 -- не дождались, иначе регистр состояния.
ready:  PUSH B
        PUSH D
        MVI  D,5
        LXI  B,0
rdy1:   IN   57h
        ANI  0C0h
        CPI  40h                ; готов и не занят
        JZ   rdy2
        DCX  B
        MOV  A,B
        ORA  C
        JNZ  rdy1
        DCR  D
        JNZ  rdy1
        XRA  A
rdy2:   ANA  A
        POP  D
        POP  B
        RZ
        IN   57h
        RET

; ------------------------- обмен, очистка, метка ---------------------------

; Поменять две дискеты местами. Номер дискеты -- это её место на диске, никакой
; таблицы, через которую можно было бы переставить их одной записью, в системе
; нет: БСВВ считает адрес прямо из номера. Значит, переливаем посекторно, все
; 622h секторов, туда и обратно.
;
; Прервать обмен на середине нельзя -- получились бы две полудискеты, -- поэтому
; АР2 тут не спрашивается. Точка на экране за каждые 64 сектора: видно, что идёт.
doswap: LDA  nrng
        CPI  2
        JNZ  needtwo
        LHLD rng
        CALL chkdisk
        LHLD rng+4
        CALL chkdisk
        LHLD rng
        XCHG
        LHLD rng+4
        CALL cmp16              ; одна и та же дискета -- делать нечего
        JZ   swsame
        LXI  H,msgswap
        CALL puts
        LHLD rng
        CALL phex4
        LXI  H,msgand
        CALL puts
        LHLD rng+4
        CALL phex4
        CALL ask
        JNZ  cancel
        LHLD rng                ; адреса первых секторов обеих дискет
        SHLD dcur
        CALL seek
        LXI  H,lba
        LXI  D,lbaa
        CALL mov3
        LHLD rng+4
        SHLD dcur
        CALL seek
        LXI  H,lba
        LXI  D,lbab
        CALL mov3
        LXI  H,SPD
        SHLD left
sw1:    LXI  H,lbaa
        CALL useA
        LXI  H,sbuf1
        CALL rdsec
        JNZ  swrerr
        LXI  H,lbab
        CALL useA
        LXI  H,sbuf2
        CALL rdsec
        JNZ  swrerr
        LXI  H,lbaa             ; и крест-накрест обратно
        CALL useA
        LXI  H,sbuf2
        CALL wrsec
        JNZ  swwerr
        LXI  H,lbab
        CALL useA
        LXI  H,sbuf1
        CALL wrsec
        JNZ  swwerr
        LXI  H,lbaa
        CALL inc3
        LXI  H,lbab
        CALL inc3
        LHLD left
        DCX  H
        SHLD left
        MOV  A,H
        ORA  L
        JZ   swdone
        MOV  A,L
        ANI  3Fh
        JNZ  sw1
        MVI  A,'.'
        CALL putc
        JMP  sw1
swdone: CALL crlf
        CALL forget
        LXI  H,msgdone
        CALL puts
        CALL crlf
        JMP  exit
swrerr: CALL crlf
        LXI  H,msgerr
        JMP  swerr2
swwerr: CALL crlf
        LXI  H,msgwerr
swerr2: CALL puts
        CALL crlf
        LXI  H,msghalf          ; обмен встал на середине -- сказать об этом
        CALL puts
        CALL crlf
        JMP  exit

useA:   LXI  D,lba              ; взять в работу адрес, на который смотрит HL
        JMP  mov3

; Очистить дискету: восемь секторов каталога забиваются E5h. Данные файлов
; остаются лежать как лежали -- ровно так же поступает и разметка дискеты.
; Метка дискеты не трогается: она описывает саму дискету, а не то, что на ней.
doerase:LDA  nrng
        CPI  1
        JNZ  needone
        LHLD rng
        CALL chkdisk
        SHLD dcur
        LXI  H,msgeras
        CALL puts
        LHLD dcur
        CALL phex4
        CALL ask
        JNZ  cancel
        CALL fillE5
        CALL seek
        MVI  A,DIRLEN
        STA  bcnt
er1:    LXI  H,sbuf1
        CALL wrsec
        JNZ  erwerr
        CALL lbainc
        LDA  bcnt
        DCR  A
        STA  bcnt
        JNZ  er1
        CALL forget
        LXI  H,msgdone
        CALL puts
        CALL crlf
        JMP  exit
erwerr: LXI  H,msgwerr
        CALL puts
        LHLD dcur
        CALL phex4
        CALL crlf
        JMP  exit

; Метка дискеты. Лежит в первом из двух ничейных секторов в хвосте дискеты:
; подпись, а за ней LABLEN знаков. Пустой текст метку снимает.
dolabel:LDA  nrng
        CPI  1
        JNZ  needone
        LHLD rng
        CALL chkdisk
        SHLD dcur
        LDA  label              ; текста в строке нет -- спросим отдельно: ПКК
        CPI  ' '                ; приводит командную строку к заглавным, а через
        CZ   asklab             ; свой запрос метка вводится как набрана
        CALL fillE5             ; пустой сектор -- это и есть «метки нет»
        LDA  label              ; метка из одних пробелов считается пустой
        CPI  ' '
        JZ   dlb3
        LXI  H,sign             ; подпись
        LXI  D,sbuf1
        MVI  B,SIGNLEN
dlb1:   MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  dlb1
        LXI  H,label
        MVI  B,LABLEN
dlb2:   MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  dlb2
dlb3:   CALL seeklab
        LXI  H,sbuf1
        CALL wrsec
        JNZ  erwerr
        LXI  H,msgdone
        CALL puts
        CALL crlf
        JMP  exit

; Спросить текст метки. Ввод идёт через БДОС, а он, в отличие от ПКК, регистр
; не трогает -- так метка и сохраняет строчные буквы. Пустой ответ снимает метку.
asklab: LXI  H,msgask
        CALL puts
        MVI  A,LABLEN
        STA  inbuf
        PUSH B
        LXI  D,inbuf
        MVI  C,10
        CALL BDOS
        POP  B
        CALL crlf
        LXI  H,inbuf+2
        LXI  D,label
        LDA  inbuf+1            ; сколько набрали
        MOV  B,A
        MVI  A,LABLEN
        SUB  B                  ; ... и сколько добить пробелами
        MOV  C,A
        MOV  A,B
        ORA  A
        JZ   as2
as1:    MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  as1
as2:    MOV  A,C
        ORA  A
        RZ
        MVI  A,' '
as3:    STAX D
        INX  D
        DCR  C
        JNZ  as3
        RET

; Прочитать метку дискеты dcur в sbuf1. Z -- метка есть.
getlab: CALL seeklab
        LXI  H,sbuf1
        CALL rdsec
        RNZ
        LXI  H,sbuf1
        LXI  D,sign
        MVI  B,SIGNLEN
gl1:    LDAX D
        CMP  M
        RNZ
        INX  H
        INX  D
        DCR  B
        JNZ  gl1
        XRA  A
        RET

; Напечатать метку дискеты dcur, если она есть. Хвостовые пробелы съедаем.
putlab: CALL getlab
        RNZ
prlab:  LXI  H,sbuf1+SIGNLEN+LABLEN-1
        MVI  B,LABLEN
pl1:    MOV  A,M
        CPI  ' '
        JNZ  pl2
        DCX  H
        DCR  B
        JNZ  pl1
        RET
pl2:    MVI  A,' '
        CALL putc
        MVI  A,' '
        CALL putc
        LXI  H,sbuf1+SIGNLEN
pl3:    MOV  A,M
        PUSH H
        PUSH B
        CALL putc
        POP  B
        POP  H
        INX  H
        DCR  B
        JNZ  pl3
        RET

fillE5: LXI  H,sbuf1            ; сектор из одних E5h -- «пусто» по-цэпэмовски
        LXI  B,512
fe1:    MVI  M,0E5h
        INX  H
        DCX  B
        MOV  A,B
        ORA  C
        JNZ  fe1
        RET

; Сказать системе, что диски она больше не знает: свои каталоги мы правили
; мимо неё, и запомненное ею уже неверно.
forget: PUSH B
        MVI  C,13
        CALL BDOS
        POP  B
        RET

; Спросить согласия. Z -- ответили «да».
ask:    LXI  H,msgyn
        CALL puts
        CALL getkey
        ANI  5Fh                ; заглавную из любой
        PUSH PSW
        CALL putc
        CALL crlf
        POP  PSW
        CPI  'Y'
        RET

cancel: LXI  H,msgcanc
        CALL puts
        CALL crlf
        JMP  exit
needtwo:LXI  H,msgtwo
        JMP  saybad
needone:LXI  H,msgone
        JMP  saybad
swsame: LXI  H,msgsame
saybad: CALL puts
        CALL crlf
        JMP  exit

; Есть ли такая дискета. Нет -- ругаемся и выходим.
chkdisk:MOV  A,H
        ORA  L
        JZ   ckbad
        PUSH H
        XCHG
        LHLD ndisk
        XCHG
        CALL cmp16
        POP  H
        RZ
        RC
ckbad:  PUSH H
        LXI  H,msgnodq
        CALL puts
        POP  H
        CALL phex4
        CALL crlf
        JMP  exit

; ------------------------- командная строка --------------------------------

upcase: LDA  TAIL
        MOV  B,A
        ORA  A
        RZ
        LXI  H,TAIL+1
up1:    MOV  A,M
        CPI  'a'
        JC   up2
        CPI  'z'+1
        JNC  up2
        SUI  20h
        MOV  M,A
up2:    INX  H
        DCR  B
        JNZ  up1
        RET

; Одинокий вопросительный знак -- просьба о подсказке. Z -- да.
; Просьба о подсказке: пустая командная строка или одинокий вопросительный знак.
; Z -- да.
ishelp: LDA  TAIL
        ORA  A
        RZ
        MOV  B,A
        LXI  H,TAIL+1
hlp1:   MOV  A,M                ; одни пробелы -- всё равно что пусто
        CPI  ' '
        JNZ  hlp2
        INX  H
        DCR  B
        JNZ  hlp1
        XRA  A
        RET
hlp2:   CPI  '?'
        RNZ
        DCR  B                  ; и ничего после него
        RZ
        MVI  A,1
        ORA  A
        RET

parse:  LDA  TAIL
        STA  tc
        LXI  H,TAIL+1
        SHLD tp
        LXI  H,pat              ; шаблон по умолчанию -- всё подряд
        MVI  B,11
        MVI  A,'?'
pa0:    MOV  M,A
        INX  H
        DCR  B
        JNZ  pa0
pa1:    CALL skipsp
        LDA  tc
        ORA  A
        RZ
        CALL peek
        CPI  '/'
        JZ   pa3
        CALL iswild
        JZ   pa2
        CALL setpat
        JMP  pa1
pa2:    CALL setrng
        CALL skiptok            ; слово могло начаться не с цифры -- дочитаем,
        LDA  mode               ; иначе разбор топтался бы на месте
        CPI  'M'                ; после номера у /M идёт сама метка -- всё,
        JNZ  pa1                ; что осталось в строке, вместе с пробелами
        JMP  grablab

; Остаток строки -- в метку, добивая её пробелами до полной длины.
grablab:CALL skipsp
        LXI  H,label
        MVI  B,LABLEN
gr1:    CALL peek
        JC   gr2
        MOV  M,A
        INX  H
        CALL adv
        DCR  B
        JNZ  gr1
        RET
gr2:    MOV  A,B
        ORA  A
        RZ
        MVI  M,' '
        INX  H
        DCR  B
        JMP  gr2
pa3:    CALL adv                ; ключ
        CALL peek
        JC   pa4
        CPI  'N'                ; без остановок
        JNZ  pa3b
        MVI  A,0FFh
        STA  nopage
        JMP  pa4
pa3b:   CPI  'X'                ; обмен
        JZ   pa3c
        CPI  'Z'                ; очистка
        JZ   pa3c
        CPI  'L'                ; список меток
        JZ   pa3c
        CPI  'M'                ; метка
        JNZ  pa4
pa3c:   STA  mode
pa4:    CALL skiptok
        JMP  pa1

; Дочитать слово до пробела или до конца строки.
skiptok:CALL peek
        RC
        CPI  ' '
        RZ
        CALL adv
        JMP  skiptok

skipsp: CALL peek
        RC
        CPI  ' '
        RNZ
        CALL adv
        JMP  skipsp

; Есть ли в слове знаки шаблона. NZ -- шаблон, Z -- номер дискеты.
iswild: PUSH H
        PUSH B
        LHLD tp
        LDA  tc
        MOV  B,A
iw1:    MOV  A,B
        ORA  A
        JZ   iw3
        MOV  A,M
        CPI  ' '
        JZ   iw3
        CPI  '.'
        JZ   iw2
        CPI  '*'
        JZ   iw2
        CPI  '?'
        JZ   iw2
        INX  H
        DCR  B
        JMP  iw1
iw2:    POP  B
        POP  H
        MVI  A,1
        ORA  A
        RET
iw3:    POP  B
        POP  H
        XRA  A
        RET

; Знак под указателем -> A, CY=1 если строка кончилась.
peek:   PUSH H
        LDA  tc
        ORA  A
        JZ   pk9
        LHLD tp
        MOV  A,M
        POP  H
        ORA  A
        RET
pk9:    POP  H
        STC
        RET

adv:    PUSH H
        LHLD tp
        INX  H
        SHLD tp
        LDA  tc
        DCR  A
        STA  tc
        POP  H
        RET

; Диапазон дискет: «N», «N-M» или «N-» (до последней).
setrng: CALL rdhex
        SHLD tfrom
        SHLD tto
        CALL peek
        JC   sr9
        CPI  '-'
        JNZ  sr9
        CALL adv
        CALL peek
        JC   sropen
        CALL ishex
        JC   sropen
        CALL rdhex
        SHLD tto
        JMP  sr9
sropen: LXI  H,0FFFFh
        SHLD tto
sr9:    LDA  nrng
        CPI  NRNG
        RNC                     ; больше NRNG диапазонов не берём
        MOV  L,A
        MVI  H,0
        DAD  H
        DAD  H
        LXI  D,rng
        DAD  D
        XCHG
        LHLD tfrom
        MOV  A,L
        STAX D
        INX  D
        MOV  A,H
        STAX D
        INX  D
        LHLD tto
        MOV  A,L
        STAX D
        INX  D
        MOV  A,H
        STAX D
        LDA  nrng
        INR  A
        STA  nrng
        RET

rdhex:  LXI  H,0
rh1:    PUSH H
        CALL peek
        JC   rh8
        CALL ishex
        JC   rh8
        MOV  C,A
        POP  H
        DAD  H
        DAD  H
        DAD  H
        DAD  H
        MVI  B,0
        DAD  B
        CALL adv
        JMP  rh1
rh8:    POP  H
        RET

; 16-ричная цифра: CY=1 -- не цифра, иначе A -- значение.
ishex:  CPI  '0'
        JC   ih9
        CPI  '9'+1
        JNC  ih1
        SUI  '0'
        ORA  A
        RET
ih1:    CPI  'A'
        JC   ih9
        CPI  'F'+1
        JNC  ih9
        SUI  'A'-10
        ORA  A
        RET
ih9:    STC
        RET

; Разбор шаблона в pat: имя -- восемь знаков, расширение -- три.
setpat: LXI  H,pat
        MVI  B,8
        MVI  A,' '
sp0:    MOV  M,A
        INX  H
        DCR  B
        JNZ  sp0
        MVI  B,3                ; без точки расширение любое
        MVI  A,'?'
sp0b:   MOV  M,A
        INX  H
        DCR  B
        JNZ  sp0b
        LXI  H,pat
        SHLD fptr
        MVI  A,8
        STA  flen
        CALL field
        CALL peek
        JC   sp9
        CPI  '.'
        JNZ  sp9
        CALL adv
        LXI  H,pat+8            ; точка есть -- расширение задано явно
        MVI  B,3
        MVI  A,' '
sp1:    MOV  M,A
        INX  H
        DCR  B
        JNZ  sp1
        LXI  H,pat+8
        SHLD fptr
        MVI  A,3
        STA  flen
        CALL field
sp9:    JMP  skiptok            ; проглотить остаток слова

; Одно поле шаблона: fptr -- куда класть, flen -- сколько места.
field:  LHLD fptr
        LDA  flen
        MOV  B,A
fl1:    CALL peek
        RC
        CPI  ' '
        RZ
        CPI  '.'
        RZ
        CPI  '*'
        JZ   fl5
        MOV  C,A
        MOV  A,B
        ORA  A
        JZ   fl2                ; поле заполнено -- лишние знаки выбрасываем
        MOV  M,C
        INX  H
        DCR  B
fl2:    CALL adv
        JMP  fl1
fl5:    MOV  A,B                ; «*» -- добить поле вопросами
        ORA  A
        JZ   fl6
        MVI  M,'?'
        INX  H
        DCR  B
        JMP  fl5
fl6:    CALL adv
        JMP  fl1

; ------------------------- экран -------------------------------------------

banner: LXI  H,msghd
        CALL puts
        LDA  phys               ; секторов на дорожке
        MOV  L,A
        MVI  H,0
        MVI  A,1
        STA  pwid
        CALL pdec
        LXI  H,msgx
        CALL puts
        LDA  phys+1             ; головок
        MOV  L,A
        MVI  H,0
        CALL pdec
        LXI  H,msgx
        CALL puts
        LHLD phcyl              ; цилиндров
        CALL pdec
        LXI  H,msgdsk
        CALL puts
        LHLD ndisk
        CALL pdec
        LXI  H,msgpar
        CALL puts
        LHLD ndisk
        CALL phex4
        LXI  H,msgpar2
        CALL puts
        JMP  crlf

putc:   PUSH B
        PUSH D
        PUSH H
        MOV  E,A
        MVI  C,2
        CALL BDOS
        POP  H
        POP  D
        POP  B
        RET

puts:   MOV  A,M
        ORA  A
        RZ
        INX  H
        PUSH H
        CALL putc
        POP  H
        JMP  puts

crlf:   MVI  A,CH_VK
        CALL putc
        MVI  A,0Ah
        CALL putc
        LDA  lines
        INR  A
        STA  lines
        CPI  PAGE
        RNZ
        XRA  A
        STA  lines
        LDA  nopage             ; /N или вывод в файл -- не останавливаемся
        ORA  A
        RNZ
; Страница кончилась: ждём клавишу и стираем подсказку, чтобы она не осталась
; в листинге.
pause:  LXI  H,msgmore
        CALL puts
        CALL getkey
        PUSH PSW
        CALL unmore
        POP  PSW
        CPI  CH_AR2
        JZ   exit
        CPI  3
        JZ   exit
        RET
; Стереть подсказку: печатаем возврат каретки, пробелы поверх и снова возврат.
unmore: MVI  A,CH_VK
        CALL putc
        LXI  H,msgclr
        CALL puts
        MVI  A,CH_VK
        JMP  putc

; Не нажали ли АР2, пока мы читаем очередную дискету.
brk:    PUSH B
        PUSH D
        PUSH H
        MVI  C,11
        CALL BDOS
        POP  H
        POP  D
        POP  B
        ORA  A
        RZ
        CALL getkey
        CPI  CH_AR2
        JZ   exit
        CPI  3
        JZ   exit
        RET

getkey: PUSH B
        PUSH D
        PUSH H
        MVI  C,6
        MVI  E,0FFh
        CALL BDOS
        POP  H
        POP  D
        POP  B
        ORA  A
        JZ   getkey
        RET

phex4:  MOV  A,H
        CALL phex2
        MOV  A,L
phex2:  PUSH PSW
        RRC
        RRC
        RRC
        RRC
        CALL phnib
        POP  PSW
phnib:  ANI  0Fh
        ADI  '0'
        CPI  '9'+1
        JC   ph1
        ADI  7
ph1:    JMP  putc

; HL десятичным числом в поле шириной pwid.
pdec:   LXI  D,numbuf+5
        MVI  C,0
pd1:    DCX  D
        CALL div10
        ADI  '0'
        STAX D
        INR  C
        MOV  A,H
        ORA  L
        JNZ  pd1
        LDA  pwid
        SUB  C
        JC   pd3
        JZ   pd3
        MOV  B,A
pd2:    MVI  A,' '
        CALL putc
        DCR  B
        JNZ  pd2
pd3:    XCHG
        MOV  B,C
pd4:    MOV  A,M
        PUSH H
        PUSH B
        CALL putc
        POP  B
        POP  H
        INX  H
        DCR  B
        JNZ  pd4
        RET

; HL = HL/10, A -- остаток. Столбиком: делить вычитанием тут слишком дорого,
; размеров печатается много.
div10:  PUSH B
        MVI  B,16
        XRA  A
dv1:    DAD  H
        RAL
        CPI  10
        JC   dv2
        SUI  10
        INR  L
dv2:    DCR  B
        JNZ  dv1
        POP  B
        RET

; HL против DE: CY -- HL меньше, Z -- равны.
cmp16:  MOV  A,H
        CMP  D
        RNZ
        MOV  A,L
        CMP  E
        RET
