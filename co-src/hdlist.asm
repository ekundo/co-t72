; ---------------------------------------------------------------------------
; Список дискет НЖМД -- накладка, которая живёт внутри самой CO.COM.
;
; Под стеком и в окне места на неё нет: там остаётся меньше четырёхсот байт на
; два куска, а списку нужно втрое больше -- одно чтение винчестера портами
; весит 211. Зато есть буфер копирования: шестнадцать килобайт, и во время
; списка они наши -- картинку панелей мы затираем, а на выходе панель
; перерисовывается заново, как после просмотра архива.
;
; Поэтому код списка дописан в конец CO.COM, за всё остальное, на границу
; записи. По «СС»-«7» резидентный кусок (co-src/hddsel.asm) открывает
; C:CO.COM, читает отсюда нужные записи в буфер копирования и передаёт сюда
; управление. Ни отдельного файла в выпуске, ни отдельной программы.
;
; Первые четыре байта -- подпись. Если на C: окажется CO.COM от другой сборки,
; подпись не сойдётся, и «СС»-«7» откатится на прежний ввод номера.
;
; Винчестер читаем сами, портами 50h..58h, в том же порядке, что и БСВВ.
; Иначе никак: дисковый вызов БСВВ читает по ДИСКУ, а диск указывает на ту
; дискету, которая ему назначена; ту, что не назначена никуда, через БСВВ не
; прочитать. Подпрограммы взяты из tools/hdir-code.inc -- там они проверены на
; живом винчестере.
; ---------------------------------------------------------------------------
        ORG  ORIGIN

; ---------------- раскладка винчестера -------------------------------------
SPD     EQU 1570                ; секторов на дискету
DIRSEC  EQU 82                  ; от начала дискеты до каталога
DIRLEN  EQU 8                   ; секторов в каталоге: 128 записей по 32 байта
NENT    EQU 128                 ; записей в каталоге
DATABL  EQU 390                 ; блоков под файлы, по 2 Кб
LABSEC  EQU 1568                ; сектор метки -- сразу за файловой системой
LABLEN  EQU 32                  ; знаков в метке
SIGNLEN EQU 4                   ; длина подписи в секторе метки
NDISKS  EQU 084h                ; в заголовке винчестера: сколько дискет

; ---------------- раскладка экрана -----------------------------------------
ROWS    EQU 20                  ; строк в поле панели
TOPROW  EQU 022h                ; первая строка списка в кодировке «ЭСК Y»
HDRROW  EQU 020h                ; строка шапки панели
FRMROW  EQU 021h                ; верхняя рамка панели
FRMCOL  EQU 3                   ; ... с четвёртой её колонки идёт надпись
FRMLEN  EQU 34                  ; ... и занимает 34 знака (co-src/hdinfo.asm)
FRMCH   EQU 08Dh                ; горизонталь рамки -- ею же и затираем
WIDTH   EQU 37                  ; знаков в строке списка
LABW    EQU 23                  ; ... из них под метку
; Раскладка строки: номер(4) пробел метка(LABW) пробел файлов(3) пробел
; занято(3) и «K» -- объём пишем так же, как CO пишет размер файла в режиме
; «60 файлов»: три знака с ведущими пробелами и латинская K впритык (шаблон по
; 10C8, печатает 0E1B).
COLFILE EQU 5+LABW+1            ; где в строке число файлов
COLSIZE EQU COLFILE+3+1         ; ... и занятое место

; ---------------- что берём у CO -------------------------------------------
PANEL   EQU 0B69Dh              ; номер активной панели, 1 или 2
GETKEY  EQU 00D44h              ; ждать клавишу
KEYGO   EQU 00562h              ; разобрать клавишу по таблице
ARCOUT  EQU 02DC3h              ; выход: перерисовать панель и вернуться
PANFLIP EQU 02A0Ah              ; переставить номер активной панели, 1<->2
PANCLR  EQU 0347Dh              ; очистить поле панели -- прямо в видеопамяти
HPANEL  EQU 03E91h              ; буквы дисков панелей
HSELPAN EQU 00E4Dh              ; HL += 1, если активна вторая панель
HREREAD EQU 028AEh              ; хвост «7-Диск»: буква из B и перечитать
INSTR   EQU 028D2h              ; ввод строки: DE -> предел, длина, текст

; ---------------- буферы в буфере копирования ------------------------------
SECBUF  EQU 06800h              ; один сектор винчестера, 512 байт
DIRBUF  EQU 06A00h              ; каталог дискеты целиком, 4 Кб
ROWBUF  EQU 07A00h              ; двадцать готовых строк по 40 знаков
LABBUF  EQU 07E00h              ; двадцать полных меток по 32 знака

        .db  'HDL1'             ; подпись: её сверяет загрузчик
HDLRUN: JMP  hdstart

; ===========================================================================
; ЧТЕНИЕ ВИНЧЕСТЕРА
; ===========================================================================

; Чтение сектора llba по адресу HL. Порядок работы с портами -- как в БСВВ.
lrdsec: SHLD lrdbuf
        MVI  A,020h             ; чтение
        CALL lrwcmd
        JZ   lrderr             ; буфер данных не открылся
        LHLD lrdbuf
        MVI  D,0
lrs1:   IN   050h
        MOV  M,A
        INX  H
        IN   058h
        MOV  M,A
        INX  H
        DCR  D
        JNZ  lrs1
        CALL lready
        ANI  0D5h
        SUI  050h               ; норма -- 50h или 58h
        RZ
lrderr: MVI  A,0FFh
        ORA  A
        RET

; Запись сектора llba из памяти по адресу HL. Байты уходят так же, как их
; посылает БСВВ: сначала старший в 58h, потом младший в 50h -- запись в 50h и
; отправляет слово.
lwrsec: SHLD lrdbuf
        MVI  A,030h             ; запись
        CALL lrwcmd
        JZ   lrderr
        LHLD lrdbuf
        MVI  D,0
lws1:   MOV  E,M
        INX  H
        MOV  A,M
        OUT  058h
        MOV  A,E
        OUT  050h
        INX  H
        DCR  D
        JNZ  lws1
        CALL lready
        ANI  0D5h
        SUI  050h
        RZ
        JMP  lrderr

; Выставить адрес и отдать команду из A. Z=1 -- диск не открыл буфер данных.
lrwcmd: PUSH PSW
        LDA  llba+2
        OUT  055h               ; LBA [23..16]
        LDA  llba
        OUT  053h               ; LBA [7..0]
        LDA  llba+1
        OUT  054h               ; LBA [15..8]
        MVI  A,0E0h             ; режим LBA
        OUT  056h
        MVI  A,1                ; один сектор
        OUT  052h
        POP  PSW
        OUT  057h
        CALL lready
        ANI  008h               ; буфер ждёт обмена?
        RET

; Ждать готовности. A=0 -- не дождались, иначе регистр состояния.
lready: PUSH B
        PUSH D
        MVI  D,5
        LXI  B,0
lrdy1:  IN   057h
        ANI  0C0h
        CPI  040h               ; готов и не занят
        JZ   lrdy2
        DCX  B
        MOV  A,B
        ORA  C
        JNZ  lrdy1
        DCR  D
        JNZ  lrdy1
        XRA  A
lrdy2:  ANA  A
        POP  D
        POP  B
        RZ
        IN   057h
        RET

; llba += DE
llbadd: LHLD llba
        DAD  D
        SHLD llba
        RNC
        LDA  llba+2
        INR  A
        STA  llba+2
        RET

; llba на первый сектор данных дискеты ldcur -- туда же, где её каталог:
; llba = SPD*(ldcur-1) + DIRSEC. Умножения нет, складываем, как это делает и
; сама система: дискет тут сотни, цикл ничего не стоит.
lseek:  LXI  H,0
        SHLD llba
        XRA  A
        STA  llba+2
        LHLD ldcur
        MOV  B,H
        MOV  C,L
        DCX  B
lsk1:   MOV  A,B
        ORA  C
        JZ   lsk2
        LXI  D,SPD
        CALL llbadd
        DCX  B
        JMP  lsk1
lsk2:   LXI  D,DIRSEC
        JMP  llbadd

; ===========================================================================
; СБОР СТРАНИЦЫ
; ===========================================================================

; Сектор метки дискеты ldcur в SECBUF. Возврат: A=0 -- метки нет.
lgetlab: CALL lseek
        LXI  D,LABSEC
        CALL llbadd
        LXI  H,SECBUF
        CALL lrdsec
        ORA  A
        JNZ  lgl2               ; не прочиталось -- считаем, что метки нет
        LXI  H,SECBUF
        LXI  D,llabsg
        MVI  B,SIGNLEN
lgl1:   LDAX D
        CMP  M
        JNZ  lgl2
        INX  H
        INX  D
        DCR  B
        JNZ  lgl1
        MVI  A,0FFh             ; подпись сошлась
        RET
lgl2:   XRA  A
        RET
llabsg: .db  'HDLB'

; Каталог дискеты ldcur в DIRBUF. Возврат: A=0 -- прочитан.
lgetdir: CALL lseek
        LXI  H,DIRBUF
        MVI  B,DIRLEN
lgd1:   PUSH B
        PUSH H
        CALL lrdsec
        POP  H
        POP  B
        ORA  A
        RNZ
        LXI  D,512
        DAD  D
        PUSH H
        LXI  D,1
        CALL llbadd
        POP  H
        DCR  B
        JNZ  lgd1
        XRA  A
        RET

; Пройти каталог: lnfile -- файлов (записей с нулевым экстентом), lnused --
; занятых блоков. Блок в CP/M принадлежит ровно одному файлу, поэтому занятое
; место -- это просто число ненулевых ссылок. Ссылки 16-битные: на дискете 390
; блоков, в байт номер не влезает.
lcount: XRA  A
        STA  lnfile
        LXI  H,0
        SHLD lnused
        LXI  H,DIRBUF
        MVI  C,NENT
lcn1:   MOV  A,M
        CPI  16
        JNC  lcn5               ; запись свободна
        PUSH H
        PUSH B
        LXI  D,12               ; нулевой ли экстент: биты 0-4 байта 12 и байт 14
        DAD  D
        MOV  A,M
        ANI  01Fh
        MOV  B,A
        INX  H
        INX  H
        MOV  A,M
        ORA  B
        JNZ  lcn2
        LDA  lnfile
        INR  A
        STA  lnfile
lcn2:   POP  B
        POP  H
        PUSH H
        PUSH B
        LXI  D,16               ; таблица блоков: восемь ссылок по два байта
        DAD  D
        MVI  B,8
lcn3:   MOV  A,M
        INX  H
        ORA  M
        INX  H
        JZ   lcn4
        PUSH H
        LHLD lnused
        INX  H
        SHLD lnused
        POP  H
lcn4:   DCR  B
        JNZ  lcn3
        POP  B
        POP  H
lcn5:   LXI  D,32
        DAD  D
        DCR  C
        JNZ  lcn1
        RET

; ===========================================================================
; СТРОКА СПИСКА
; ===========================================================================

; HL -> строка lrow в ROWBUF (по 40 знаков), DE -> её метка в LABBUF (по 32).
lraddr: LDA  lrow
        MOV  L,A
        MVI  H,0
        DAD  H
        DAD  H
        DAD  H                  ; *8
        PUSH H
        DAD  H
        DAD  H                  ; *32
        PUSH H
        LXI  D,LABBUF
        DAD  D
        XCHG                    ; DE -> метка
        POP  H                  ; *32
        POP  B                  ; *8
        DAD  B                  ; *40
        PUSH D
        LXI  D,ROWBUF
        DAD  D                  ; HL -> строка
        POP  D
        RET

; Строку -- пробелами, в конце ноль.
lblank: PUSH H
        MVI  B,WIDTH
        MVI  A,' '
lbl1:   MOV  M,A
        INX  H
        DCR  B
        JNZ  lbl1
        MVI  M,0
        POP  H
        RET

; Четыре 16-ричных знака числа HL по адресу DE; DE -> за числом.
lhex4:  MOV  A,H
        CALL lhex2
        MOV  A,L
lhex2:  PUSH PSW
        RRC
        RRC
        RRC
        RRC
        CALL lhex1
        POP  PSW
lhex1:  ANI  00Fh
        ADI  '0'
        CPI  '9'+1
        JC   lhx1
        ADI  7
lhx1:   STAX D
        INX  D
        RET

; Три десятичных знака числа HL по адресу DE, ведущие нули -- пробелами.
; DE -> за числом.
ldec3:  MOV  A,H                ; больше трёх знаков в поле не влезет
        CPI  4
        JC   ld0
        LXI  H,999
ld0:    MOV  A,H
        CPI  3
        JC   ld00
        MOV  A,L
        CPI  0E8h
        JC   ld00
        LXI  H,999
ld00:   PUSH D
        MVI  A,'0'-1
        LXI  B,0FF9Ch           ; -100
ld1:    INR  A
        DAD  B
        JC   ld1
        LXI  B,100              ; перелетели -- вернуть
        DAD  B
        STAX D
        INX  D
        MVI  A,'0'-1
        LXI  B,0FFF6h           ; -10
ld2:    INR  A
        DAD  B
        JC   ld2
        LXI  B,10
        DAD  B
        STAX D
        INX  D
        MOV  A,L
        ADI  '0'
        STAX D
        INX  D
        POP  H                  ; начало числа: ведущие нули -- пробелами
        MOV  A,M
        CPI  '0'
        RNZ
        MVI  M,' '
        INX  H
        MOV  A,M
        CPI  '0'
        RNZ
        MVI  M,' '
        RET

; Метку из LABBUF в строку: LABW знаков, длиннее -- с многоточием.
lputlab: CALL lraddr
        LXI  B,5                ; метка начинается с пятого знака строки
        DAD  B
        XCHG                    ; HL -> метка, DE -> место в строке
        MVI  B,LABW
lpl1:   MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  lpl1
        MVI  B,LABLEN-LABW      ; остаток метки -- одни пробелы?
lpl2:   MOV  A,M
        CPI  ' '
        JNZ  lpl3
        INX  H
        DCR  B
        JNZ  lpl2
        RET                     ; влезла целиком
lpl3:   DCX  D                  ; не влезла -- три точки в конец
        DCX  D
        DCX  D
        MVI  A,'.'
        STAX D
        INX  D
        STAX D
        INX  D
        STAX D
        RET

; Файлы и занятое место в строку.
lputnum: CALL lraddr
        LXI  B,COLFILE
        DAD  B
        XCHG                    ; DE -> место под число файлов
        LDA  lnfile
        MOV  L,A
        MVI  H,0
        CALL ldec3
        INX  D                  ; пробел между полями
        LHLD lnused             ; блоки по два килобайта
        DAD  H
        CALL ldec3
        MVI  A,'K'              ; как у размера файла в панели: латинская K
        STAX D
        RET

; Одна строка: номер, метка, файлы, занято.
lonerow: CALL lraddr
        XCHG                    ; HL -> метка, DE -> строка
        PUSH H
        LHLD ldcur
        CALL lhex4              ; номер -- четыре знака в начало строки
        POP  D                  ; DE -> метка
        PUSH D                  ; чтение сектора DE не бережёт
        CALL lgetlab
        POP  D
        ORA  A
        JZ   lor2
        LXI  H,SECBUF+SIGNLEN   ; метка есть -- к себе
        MVI  B,LABLEN
lor1:   MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  lor1
        JMP  lor3
lor2:   MVI  B,LABLEN           ; метки нет -- пробелы
        MVI  A,' '
lor2a:  STAX D
        INX  D
        DCR  B
        JNZ  lor2a
lor3:   CALL lputlab
        CALL lgetdir
        ORA  A
        RNZ                     ; каталог не читается -- файлы и объём пусты
        CALL lcount
        JMP  lputnum

; Собрать страницу: двадцать строк с lpgbase.
lloadpg: XRA A
        STA  lrow
llp1:   CALL lraddr
        CALL lblank
        CALL lsetno             ; номер дискеты этой строки -> ldcur
        LHLD ltotal
        XCHG
        LHLD ldcur
        MOV  A,E
        SUB  L
        MOV  A,D
        SBB  H
        JC   llp2               ; дискеты с таким номером нет
        CALL lonerow
llp2:   LDA  lrow
        INR  A
        STA  lrow
        CPI  ROWS
        JNZ  llp1
        RET

; ldcur = lpgbase + lrow
lsetno: LDA  lrow
        MOV  E,A
        MVI  D,0
        LHLD lpgbase
        DAD  D
        SHLD ldcur
        RET

; ===========================================================================
; ЭКРАН
; ===========================================================================

; Поставить курсор в строку A поля панели.
lgoto:  STA  lpos+2
        LXI  H,lpos
        RST  3
        RET
lpos:   .db  01Bh,'Y',TOPROW,020h,0
linv:   .db  01Bh,'b',0         ; выворотка
lnorm:  .db  01Bh,'a',0

; Затереть надпись в верхней рамке панели. Там висят номер и метка ТОЙ
; дискеты, что назначена сейчас, -- пока открыт список, они только сбивают с
; толку. Затираем самой рамкой, как это делает и накладка надписи, когда метка
; стала короче. Обратно надпись вернёт отрисовка панели на выходе: через 097E
; проходят все три её входа.
lframe: MVI  A,FRMROW
        STA  lpos+2
        LDA  lpos+3
        ADI  FRMCOL
        STA  lpos+3
        LXI  H,lpos
        RST  3
        LDA  lpos+3             ; колонку вернуть на место
        SUI  FRMCOL
        STA  lpos+3
        MVI  B,FRMLEN
        MVI  C,FRMCH
lfr1:   PUSH B
        RST  4
        POP  B
        DCR  B
        JNZ  lfr1
        RET

; Вся страница. Поле сперва чистим тем же способом, что и просмотр архива:
; вертикальные разделители колонок CO чертит прямо в видеопамяти, и печатью
; пробелов их не стереть. Номер активной панели вокруг чистки переставляется --
; так же, как это делает CO по 2B85.
ldraw:  CALL PANFLIP
        CALL PANCLR
        CALL PANFLIP
        CALL lframe
        XRA  A
        STA  lrow
ldr1:   LDA  lrow
        ADI  TOPROW
        CALL lgoto
        CALL lraddr
        RST  3
        LDA  lrow
        INR  A
        STA  lrow
        CPI  ROWS
        JNZ  ldr1
        RET

; Строка под курсором -- обычная и вывороткой. Вывороткой заодно обновляется
; шапка: в ней полная метка, та, что в строку не влезла.
lplain: LDA  lcur
        DCR  A
        STA  lrow
        ADI  TOPROW
        CALL lgoto
        CALL lraddr
        RST  3
        RET

lhi:    LDA  lcur
        DCR  A
        STA  lrow
        ADI  TOPROW
        CALL lgoto
        LXI  H,linv
        RST  3
        CALL lraddr
        RST  3
        LXI  H,lnorm
        RST  3
; Шапка: номер и полная метка той дискеты, на которой стоит курсор.
lhdr:   CALL lsetno
        LXI  D,lhbuf+1
        LHLD ldcur
        CALL lhex4
        INX  D                  ; пробел после номера
        PUSH D                  ; место под метку в шапке
        CALL lraddr
        XCHG                    ; HL -> метка
        POP  D
        MVI  B,LABLEN
lhd1:   MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  lhd1
        MVI  A,HDRROW
        CALL lgoto
        LXI  H,linv
        RST  3
        LXI  H,lhbuf
        RST  3
        LXI  H,lnorm
        RST  3
        RET
lhbuf:  .db  ' 0000 '
        .ds  LABLEN
        .db  '  ',0

; ===========================================================================
; КЛАВИШИ
; ===========================================================================

; Сколько строк на странице занято: min(ROWS, ltotal - lpgbase + 1).
lnrows: LHLD lpgbase
        XCHG
        LHLD ltotal
        MOV  A,L
        SUB  E
        MOV  L,A
        MOV  A,H
        SBB  D
        MOV  H,A                ; ltotal - lpgbase
        INX  H
        MOV  A,H
        ORA  A
        JNZ  lnr1
        MOV  A,L
        CPI  ROWS+1
        RC
lnr1:   MVI  A,ROWS
        RET

lup:    LDA  lcur
        DCR  A
        JZ   lupg               ; стоим на верхней строке
        CALL lplain
        LDA  lcur
        DCR  A
        STA  lcur
        JMP  lhi
lupg:   LHLD lpgbase            ; есть ли предыдущая страница
        MOV  A,H
        ORA  A
        JNZ  lupg1
        MOV  A,L
        CPI  ROWS+1
        RC                      ; первая страница -- ничего не делаем
lupg1:  LXI  D,-ROWS
        DAD  D
        SHLD lpgbase
        CALL lloadpg
        CALL ldraw
        MVI  A,ROWS
        STA  lcur
        JMP  lhi

ldn:    LDA  lcur
        MOV  B,A
        CALL lnrows
        CMP  B
        JZ   ldng               ; стоим на последней занятой строке
        CALL lplain
        LDA  lcur
        INR  A
        STA  lcur
        JMP  lhi
ldng:   LHLD lpgbase            ; есть ли следующая страница
        LXI  D,ROWS
        DAD  D
        XCHG
        LHLD ltotal
        MOV  A,L
        SUB  E
        MOV  A,H
        SBB  D
        RC                      ; дальше дискет нет
        XCHG
        SHLD lpgbase
        CALL lloadpg
        CALL ldraw
        MVI  A,1
        STA  lcur
        JMP  lhi

; ВК -- назначить выбранную дискету на диск панели. Дальше всё делает
; резидентная часть: docmd выполняет команду ОС «9» по набору в pend, prmsave
; запоминает выбор в C:CO.HDD, а хвост «7-Диск» перечитывает панель.
lsel:   CALL lsetno
        MVI  A,4                ; в набор -- четыре 16-ричных знака
        STA  pend
        LXI  D,pend+1
        LHLD ldcur
        CALL lhex4
        CALL docmd
        CALL prmsave
        LXI  H,HPANEL
        CALL HSELPAN
        MOV  B,M
        POP  H                  ; снять возврат в цикл клавиш
        JMP  HREREAD

; «6» -- метка дискеты под курсором; в панели на «6» переименование файла, так
; что рука помнит. Спрашиваем строку штатным вводом CO (28D2) и кладём её в тот
; же сектор и в том же виде, что пишет HDIR /M: подпись 'HDLB' и 32 знака.
;
; Пустой ответ -- АР2 или ВК, ничего не набрав -- ничего не меняет: отличить их
; друг от друга нечем (28D2 в обоих случаях отдаёт нулевую длину), а терять
; метку по случайному АР2 обидно. Чтобы метку СНЯТЬ, набирается пробел: метку
; из одних пробелов и рамка, и список считают за отсутствующую.
llabel: CALL lnrows
        MOV  B,A
        LDA  lcur
        CMP  B
        JZ   llb1
        RNC                     ; курсор за последней дискетой -- нечего метить
llb1:   LDA  lcur
        DCR  A
        STA  lrow
        CALL lsetno             ; ldcur -- дискета под курсором
        MVI  A,HDRROW           ; приглашение вместо шапки
        CALL lgoto
        LXI  H,lask
        RST  3
        MVI  A,LABLEN
        STA  linbuf
        LXI  D,linbuf
        CALL INSTR
        LDA  linbuf+1
        ORA  A
        JZ   llb9               ; ничего не набрали -- оставляем как было
; Сектор метки собираем с нуля: свободный сектор -- это E5 по всей длине,
; ровно так же его чистит HDIR перед записью.
        LXI  H,SECBUF
        MVI  A,0E5h
        MVI  B,0
llb2:   MOV  M,A
        INX  H
        DCR  B
        JNZ  llb2
        MVI  B,0
llb3:   MOV  M,A
        INX  H
        DCR  B
        JNZ  llb3
        LXI  H,llabsg           ; подпись
        LXI  D,SECBUF
        MVI  B,SIGNLEN
llb4:   MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  B
        JNZ  llb4
        LXI  H,linbuf+2         ; текст, добитый пробелами до LABLEN
        LDA  linbuf+1
        MOV  C,A
        MVI  B,LABLEN
llb5:   MOV  A,C
        ORA  A
        MVI  A,' '
        JZ   llb6
        MOV  A,M
        INX  H
        DCR  C
llb6:   STAX D
        INX  D
        DCR  B
        JNZ  llb5
        CALL lseek              ; и на диск
        LXI  D,LABSEC
        CALL llbadd
        LXI  H,SECBUF
        CALL lwrsec
        CALL lonerow            ; строку собрать заново -- уже с новой меткой
llb9:   JMP  lhi                ; шапку вернуть на место в любом случае
lask:   .db  'Метка: ',0

lkeys:  .db  5
        .db  019h
        .dw  lup                ; стрелка вверх
        .db  01Ah
        .dw  ldn                ; стрелка вниз
        .db  00Dh
        .dw  lsel               ; ВК -- выбрать
        .db  '6'
        .dw  llabel             ; «6» -- метка
        .db  01Bh
        .dw  ARCOUT             ; АР2 -- назад в панель
        .dw  lnone              ; прочее
lnone:  RET

; ===========================================================================
; ВХОД
; ===========================================================================
hdstart: LDA PANEL              ; колонка: первая панель с 0, вторая с 40
        DCR  A
        MVI  A,020h
        JZ   hds1
        MVI  A,048h
hds1:   STA  lpos+3
        LXI  H,0                ; заголовок винчестера -- сколько дискет
        SHLD llba
        XRA  A
        STA  llba+2
        LXI  H,SECBUF
        CALL lrdsec
        ORA  A
        RNZ                     ; винчестер не отвечает -- молча назад
        LHLD SECBUF+NDISKS
        SHLD ltotal
        MOV  A,H
        ORA  L
        RZ                      ; дискет нет вовсе
        LXI  H,1
        SHLD lpgbase
        MVI  A,1
        STA  lcur
        CALL lloadpg
        CALL ldraw
        CALL lhi
hdloop: CALL GETKEY
        LXI  H,lkeys
        CALL KEYGO
        JMP  hdloop

; ---------------- переменные -----------------------------------------------
llba:   .ds  3                  ; адрес сектора на винчестере
lrdbuf: .ds  2                  ; куда читать сектор
ldcur:  .ds  2                  ; номер дискеты, с которой работаем
ltotal: .ds  2                  ; сколько дискет на винчестере
lpgbase: .ds 2                  ; номер первой дискеты страницы
lrow:   .ds  1                  ; строка страницы, 0..19
lcur:   .ds  1                  ; строка под курсором, 1..20
lnfile: .ds  1                  ; файлов на дискете
lnused: .ds  2                  ; занятых блоков
linbuf: .ds  1                  ; ввод метки: предел длины
        .ds  1                  ; ... сколько набрали
        .ds  LABLEN+1           ; ... и сам текст
