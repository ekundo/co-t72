; ---------------------------------------------------------------------------
; LOGO.SCR -- заставка для CO: логотип «ВЕКТОР 06Ц» летает по экрану и
; отскакивает от краёв. Любая клавиша -- выход в МикроДОС, а оттуда, если
; заставку запустила CO, обратно в CO.
;
; Цветов два, и оба -- CO: светлое на логотипе рисуется цветом текста, тёмное --
; фоном. Палитра не трогается.
;
; Картинку готовит tools/mklogo.py (scr/logo.png -> scr/logo.inc): два плана
; по 20 байт на строку, чётные точки и нечётные -- под T-72 видны планы A000 и
; C000, и точки на экране идут из них через одну. Вокруг картинки кайма фона,
; на шаг логотипа: ею и стирается след, отдельно стирать ничего не надо.
;
; Шаг по горизонтали -- пара точек, то есть один разряд байта плана. Сдвигать
; картинку по разрядам на каждом кадре дорого, поэтому при старте готовятся
; восемь сдвинутых копий (на это уходит около секунды), а в кадре остаётся
; только переписать нужную в экран. Копии лежат по столбцам, как сам экран:
; адрес в плане -- столбец*256 + строка.
;
; Рисуем с погашенным окном ОЗУ квазидиска (OUT 10h = 0): A000-DFFF под T-72
; -- окно, экран под ним. К БДОС -- только вернув окно (23h).
;
; Сборка:  python3 tools/asm8080.py scr/logo.asm -o LOGO.SCR
; Чтобы CO запускала её вместо гашения монитора -- положить на C: под именем
; CO.SCR. Годится и как обычная программа: переименовать в LOGO.COM.
; ---------------------------------------------------------------------------

BDOS    EQU 0005h
SCROLL  EQU 0FFABh              ; сдвиг экрана, его ставит в порт 03 сама T-72
CURBLK  EQU 0FFC6h              ; «пора мигнуть курсором», взводит прерывание
COLS    EQU LOGOW+1             ; столбцов в сдвинутой копии
BLOCK   EQU COLS*LOGOH          ; байт в копии одного плана
XMAX    EQU 256-COLS*8          ; правее -- и копия вылезет за 32-й столбец
YMAX    EQU 256-LOGOH

        ORG  0100h

START:  XRA  A
        OUT  10h
        CALL CLS
        MVI  A,23h
        OUT  10h
        CALL GEN

FRAME:  EI
        HLT
        XRA  A
        OUT  10h
        CALL DRAW
        MVI  A,23h
        OUT  10h
        ; Курсор T-72 мигает не сам: его перерисовывает опрос клавиатуры
        ; (L_FE57 в _F600h.asm), когда прерывание взвело флажок FFC6, -- и
        ; рисует прямо поверх картинки. Флажок снимаем перед каждым опросом.
        XRA  A
        STA  CURBLK
        MVI  C,6
        MVI  E,0FFh
        CALL BDOS               ; нажато что-нибудь?
        ORA  A
        JNZ  QUIT
        ; Шаг: разряд по горизонтали и строка по вертикали; у края -- назад.
        LXI  H,BX
        LDA  DX
        ADD  M
        MOV  M,A
        JZ   FLIPX
        CPI  XMAX
        JNZ  STEPY
FLIPX:  LDA  DX
        CMA
        INR  A
        STA  DX
STEPY:  LXI  H,BY
        LDA  DY
        ADD  M
        MOV  M,A
        JZ   FLIPY
        CPI  YMAX
        JNZ  FRAME
FLIPY:  LDA  DY
        CMA
        INR  A
        STA  DY
        JMP  FRAME

; Выход: экран чистим сами -- иначе приглашение ПКК мелькнёт поверх логотипа,
; пока CO не поднимется и не нарисует панели.
QUIT:   XRA  A
        OUT  10h
        CALL CLS
        MVI  A,23h
        OUT  10h
        JMP  0000h

; Очистить оба плана экрана. Окно должно быть погашено.
CLS:    LXI  H,0A000h
CLS1:   MVI  M,0
        INX  H
        MOV  A,H
        CPI  0E0h
        JNZ  CLS1
        RET

; ---------------------------------------------------------------------------
; Логотип в экран: копия по сдвигу BX&7, с столбца BX>>3, со строки BY.
; Чётные точки -- план C000, нечётные -- A000.
; ---------------------------------------------------------------------------
DRAW:   LDA  BX
        ANI  07h
        ADD  A
        MOV  E,A
        MVI  D,0
        LXI  H,TAB
        DAD  D
        MOV  E,M
        INX  H
        MOV  D,M                ; DE -- копия чётных точек; нечётные за ней
        LDA  BY
        MOV  B,A
        LDA  SCROLL
        SUB  B
        STA  ROW0               ; строка экрана, где верх логотипа
        LDA  BX
        RRC
        RRC
        RRC
        ANI  1Fh
        ADI  0C0h
        MOV  H,A                ; первый столбец, план C000
        MVI  C,COLS
        ; Столбец за столбцом, и каждый -- сразу в обоих планах: перепиши мы
        ; сперва один план целиком, а потом другой, луч застал бы их разными,
        ; и логотип на ходу рвался бы гребёнкой.
PL1:    PUSH B
        LDA  ROW0
        MOV  L,A
        CALL COPY               ; чётные точки столбца
        PUSH D
        XCHG
        LXI  B,BLOCK-LOGOH
        DAD  B                  ; тот же столбец у нечётных
        XCHG
        MOV  A,H
        XRI  60h                ; C0xx -> A0xx
        MOV  H,A
        LDA  ROW0
        MOV  L,A
        CALL COPY
        MOV  A,H
        XRI  60h
        MOV  H,A
        INR  H
        POP  D
        POP  B
        DCR  C
        JNZ  PL1
        RET

; Переписать столбец: LOGOH байт из DE в HL, вниз по экрану.
COPY:   MVI  B,LOGOH
CP1:    LDAX D
        MOV  M,A
        INX  D
        DCR  L
        DCR  B
        JNZ  CP1
        RET

; ---------------------------------------------------------------------------
; Восемь сдвинутых копий, одна за другой с BUF. Копия -- два плана, план --
; COLS столбцов по LOGOH байт сверху вниз. Байт копии со сдвигом s -- это пара
; соседних байт строки картинки, сдвинутая вправо на s разрядов. Адрес каждой
; копии -- в TAB.
; ---------------------------------------------------------------------------
GEN:    LXI  H,BUF
        SHLD DST
        LXI  H,TAB
        SHLD TABP
        XRA  A
        STA  SH
GS:     LHLD DST
        XCHG
        LHLD TABP
        MOV  M,E
        INX  H
        MOV  M,D
        INX  H
        SHLD TABP
        LXI  H,LOGOE
        SHLD PB
        CALL GENP
        LXI  H,LOGOO
        SHLD PB
        CALL GENP
        LDA  SH
        INR  A
        STA  SH
        CPI  8
        JNZ  GS
        RET

GENP:   XRA  A
        STA  COL
GC:     LHLD PB                 ; Q -- левый байт пары в верхней строке
        LDA  COL
        ADD  L
        MOV  L,A
        JNC  GC1
        INR  H
GC1:    DCX  H
        SHLD Q
        MVI  A,LOGOH
        STA  ROWS
GR:     LHLD Q
        MVI  D,0                ; левее картинки -- фон
        LDA  COL
        ORA  A
        JZ   GR1
        MOV  D,M
GR1:    INX  H
        MVI  E,0                ; правее -- тоже
        CPI  LOGOW
        JZ   GR2
        MOV  E,M
GR2:    LDA  SH
        ORA  A
        JZ   GR4
        MOV  B,A
GR3:    MOV  A,D
        ORA  A                  ; перенос -- в нуль
        RAR
        MOV  D,A
        MOV  A,E
        RAR
        MOV  E,A
        DCR  B
        JNZ  GR3
GR4:    LHLD DST
        MOV  M,E
        INX  H
        SHLD DST
        LHLD Q
        LXI  D,LOGOW
        DAD  D
        SHLD Q
        LDA  ROWS
        DCR  A
        STA  ROWS
        JNZ  GR
        LDA  COL
        INR  A
        STA  COL
        CPI  COLS
        JNZ  GC
        RET

BX:     .db  XMAX/2
BY:     .db  YMAX/2
DX:     .db  1
DY:     .db  1
ROW0:   .db  0
SH:     .db  0
COL:    .db  0
ROWS:   .db  0
PB:     .dw  0
Q:      .dw  0
DST:    .dw  0
TABP:   .dw  0
TAB:    .dw  0,0,0,0,0,0,0,0

#include "logo.inc"

; Сдвинутые копии -- сразу за программой: 8 * 2 * BLOCK байт, в файле их нет.
BUF     EQU  $
