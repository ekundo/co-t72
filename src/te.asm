; TE -- экранный редактор для MDOS T-72 на ПК Вектор-06Ц.
;
; Первая веха: загрузить файл, показать его и дать ходить по тексту.
; Правка -- следующим заходом.
;
; Экран у T-72 80x25, курсор адресуется ESC Y <строка+20h> <столбец+20h>.
; Нижняя строка отдана под состояние, под текст остаётся 24.
;
; ВАЖНО про стек: T-72 держит килобайтный буфер дисковода на BC00-BFFF, а в
; ячейке 0006 по-прежнему обещает C000. Ставить стек по правилам CP/M нельзя --
; первое же чтение сектора его затрёт. Поэтому и стек, и текст держим ниже.

        ORG  0100h

BDOS    EQU  0005h
FCB     EQU  005Ch
DMA     EQU  0080h

; --- функции БДОС ---
B.CONOUT EQU 2
B.CONIO  EQU 6
B.PRINT  EQU 9
B.OPEN   EQU 15
B.READ   EQU 20
B.SETDMA EQU 26

; --- коды клавиш T-72 ---
K.LEFT  EQU  008h
K.RIGHT EQU  018h
K.UP    EQU  019h
K.DOWN  EQU  01Ah
K.AR2   EQU  01Bh               ; АР2 -- выход
K.CR    EQU  00Dh

ESCC    EQU  01Bh
ROWS    EQU  24                 ; строк под текст
COLS    EQU  80

TEXT    EQU  02000h             ; сюда грузится файл
TEXTMAX EQU  0B000h             ; потолок текста
STACK   EQU  0B800h             ; стек ниже буфера дисковода на BC00

;=======================================================================
start:  LXI  SP,STACK
        LXI  H,mkoi8            ; набор КОИ-8 и чистый экран
        CALL puts
        LDA  FCB+1              ; имя файла в командной строке?
        CPI  ' '
        JZ   nofile
        CALL load
        LXI  H,TEXT
        SHLD top
        SHLD cur
        CALL redraw
loop:   CALL getkey
        CPI  K.AR2
        JZ   quit
        CPI  K.DOWN
        JZ   godown
        CPI  K.UP
        JZ   goup
        JMP  loop

quit:   LXI  H,mbye
        CALL puts
        RET                     ; возврат в ССР

nofile: LXI  D,mnofile
        MVI  C,B.PRINT
        CALL BDOS
        RET

;=======================================================================
; Прокрутка на строку вниз: top переезжает на следующую строку, если она есть.
godown: LHLD top
        CALL nextln
        JC   loop               ; дальше текста нет
        SHLD top
        CALL redraw
        JMP  loop

; Прокрутка вверх.
goup:   LHLD top
        CALL prevln
        JC   loop               ; уже наверху
        SHLD top
        CALL redraw
        JMP  loop

;=======================================================================
; nextln: HL -- начало строки, вернуть начало следующей.
;         CY=1, если следующей нет.
nextln: PUSH B
nx1:    CALL atend
        JC   nxend
        MOV  A,M
        INX  H
        CPI  00Ah               ; ПС -- конец строки
        JNZ  nx1
        CALL atend
        JC   nxend
        POP  B
        ORA  A                  ; CY=0
        RET
nxend:  POP  B
        STC
        RET

; prevln: HL -- начало строки, вернуть начало предыдущей. CY=1, если её нет.
prevln: PUSH B
        LXI  B,TEXT
        MOV  A,H
        CMP  B
        JNZ  pv0
        MOV  A,L
        CMP  C
        JZ   pvend              ; уже на первой строке
pv0:    DCX  H                  ; перешагнуть ПС предыдущей строки
        DCX  H                  ; и ВК перед ним
pv1:    MOV  A,H                ; дошли до начала текста?
        CMP  B
        JNZ  pv2
        MOV  A,L
        CMP  C
        JZ   pvok
pv2:    DCX  H
        MOV  A,M
        CPI  00Ah
        JNZ  pv1
        INX  H                  ; встали сразу за ПС
pvok:   POP  B
        ORA  A
        RET
pvend:  POP  B
        STC
        RET

; atend: CY=1, если HL за концом текста
atend:  PUSH PSW
        PUSH D
        LDA  bufend+1
        MOV  D,A
        LDA  bufend
        MOV  E,A
        MOV  A,L
        SUB  E
        MOV  A,H
        SBB  D
        POP  D
        JNC  ate1
        POP  PSW
        ORA  A
        RET
ate1:   POP  PSW
        STC
        RET

;=======================================================================
; Перерисовать экран целиком.
redraw: LHLD top
        SHLD scan
        MVI  A,0
        STA  row
rd1:    LDA  row
        MOV  B,A
        MVI  C,0
        CALL gotoxy
        LHLD scan
        MVI  A,0
        STA  col
rd2:    CALL atend
        JC   rdeol
        MOV  A,M
        CPI  00Dh               ; ВК не печатаем
        JZ   rdskip
        CPI  00Ah
        JZ   rdeol
        PUSH H
        CALL putc
        POP  H
        LDA  col
        INR  A
        STA  col
        CPI  COLS
        JNC  rdeol2             ; строка длиннее экрана -- обрежем
rdskip: INX  H
        JMP  rd2
rdeol:  CALL atend              ; дочитать ПС, если он есть
        JC   rdeol2
        MOV  A,M
        CPI  00Ah
        JNZ  rdeol2
        INX  H
rdeol2: SHLD scan
        LXI  H,mclreol          ; погасить хвост строки
        CALL puts
        LDA  row
        INR  A
        STA  row
        CPI  ROWS
        JC   rd1
        CALL status
        RET

;=======================================================================
; Строка состояния: имя файла и номер строки, негативом.
status: MVI  B,ROWS
        MVI  C,0
        CALL gotoxy
        LXI  H,minv
        CALL puts
        LXI  H,mname
        CALL puts
        LXI  H,FCB+1            ; имя из ФУБ, 8+3
        MVI  B,8
        CALL putn
        MVI  A,'.'
        CALL putc
        LXI  H,FCB+9
        MVI  B,3
        CALL putn
        LXI  H,mkeys
        CALL puts
        LXI  H,mpos
        CALL puts
        RET

; putn: напечатать B байт из (HL)
putn:   MOV  A,M
        PUSH H
        PUSH B
        CALL putc
        POP  B
        POP  H
        INX  H
        DCR  B
        JNZ  putn
        RET

;=======================================================================
; gotoxy: B -- строка, C -- столбец
gotoxy: PUSH B
        MVI  A,ESCC
        CALL putc
        MVI  A,'Y'
        CALL putc
        POP  B
        PUSH B
        MOV  A,B
        ADI  020h
        CALL putc
        POP  B
        MOV  A,C
        ADI  020h
        CALL putc
        RET

; putc: символ из A на экран
putc:   PUSH B
        PUSH D
        PUSH H
        MOV  E,A
        MVI  C,B.CONOUT
        CALL BDOS
        POP  H
        POP  D
        POP  B
        RET

; puts: строка из (HL) до нуля
puts:   MOV  A,M
        ORA  A
        RZ
        PUSH H
        CALL putc
        POP  H
        INX  H
        JMP  puts

; getkey: ждать клавишу, код в A
getkey: PUSH B
        PUSH D
        PUSH H
gk1:    MVI  C,B.CONIO
        MVI  E,0FFh
        CALL BDOS
        ORA  A
        JZ   gk1
        POP  H
        POP  D
        POP  B
        RET

;=======================================================================
; Загрузка файла целиком в TEXT.
load:   LXI  D,FCB
        MVI  C,B.OPEN
        CALL BDOS
        INR  A                  ; FF -> 0, если не открылся
        JZ   noopen
        LXI  H,TEXT
        SHLD dmaptr
ld1:    LHLD dmaptr
        XCHG
        MVI  C,B.SETDMA
        CALL BDOS
        LXI  D,FCB
        MVI  C,B.READ
        CALL BDOS
        ORA  A
        JNZ  ldend              ; конец файла
        LHLD dmaptr
        LXI  D,128
        DAD  D
        SHLD dmaptr
        LXI  D,0-TEXTMAX        ; не переполнить буфер
        DAD  D
        JC   ldfull
        JMP  ld1
ldfull: LXI  H,TEXTMAX
        SHLD dmaptr
ldend:  LHLD dmaptr
        SHLD bufend
        LXI  D,DMA              ; вернуть ДМА на место
        MVI  C,B.SETDMA
        CALL BDOS
        RET

noopen: LXI  D,mnoopen
        MVI  C,B.PRINT
        CALL BDOS
        LXI  H,TEXT             ; пустой текст
        SHLD bufend
        RET

;=======================================================================
mkoi8:  DB   ESCC,'[',ESCC,'J',0        ; КОИ-8 и чистый экран
mclreol: DB  ESCC,'K',0
minv:   DB   ESCC,'b',0                 ; негатив
mbye:   DB   ESCC,'a',ESCC,'J',0        ; позитив и чистый экран
mname:  DB   ' ТЕ  ',0
mkeys:  DB   '   АР2-выход  стрелки-листать ',0
mpos:   DB   ESCC,'a',0
mnofile: DB  'Нужно имя файла: TE ИМЯ.РАСШ',13,10,'$'
mnoopen: DB  'Файл не открылся$'

row:    DS   1
col:    DS   1
scan:   DS   2
top:    DS   2
cur:    DS   2
bufend: DS   2
dmaptr: DS   2
