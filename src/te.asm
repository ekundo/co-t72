; TE -- экранный редактор для MDOS T-72 на ПК Вектор-06Ц.
;
; Вторая веха: файл любого размера. Целиком он в память не влезает -- под текст
; тут 48 КБ на всё, вместе с кодом, -- поэтому в памяти живёт только окно, а
; читается оно по номерам записей функцией БДОС 33 (чтение произвольной записи).
; Что она в МикроДОС есть, проверено на живой машине: функция 35 вернула размер
; файла, 33 -- прочитала запись 0 с кодом 0.
;
; Окно -- 8 КБ, сдвигается половинами. Указатель на верхнюю показанную строку
; при сдвиге правится ровно на 4096: содержимое окна съезжает на столько же, так
; что арифметика точная и строка не «прыгает».
;
; Экран у T-72 80x25, курсор адресуется ESC Y <строка+20h> <столбец+20h>.
; Нижняя строка отдана под состояние, под текст остаётся 24.
;
; ВАЖНО про стек: T-72 держит килобайтный буфер дисковода на BC00-BFFF, а в
; ячейке 0006 по-прежнему обещает C000. Ставить стек по правилам CP/M нельзя --
; первое же чтение сектора его затрёт. Поэтому стек держим ниже.
;
; И выходить надо через JMP 0, а не RET: свой стек уже поставлен, возвращаться
; в ССР по адресу возврата не по чему.

        ORG  0100h

BDOS    EQU  0005h
FCB     EQU  005Ch
DMA     EQU  0080h

; --- функции БДОС ---
B.CONOUT EQU 2
B.CONIO  EQU 6
B.PRINT  EQU 9
B.OPEN   EQU 15
B.SETDMA EQU 26
B.RDRAND EQU 33                 ; чтение записи по номеру
B.SIZE   EQU 35                 ; вычислить размер файла

; --- коды клавиш T-72 ---
K.LEFT  EQU  008h
K.RIGHT EQU  018h
K.UP    EQU  019h
K.DOWN  EQU  01Ah
K.AR2   EQU  01Bh               ; АР2 -- выход

ESCC    EQU  01Bh
ROWS    EQU  24                 ; строк под текст
COLS    EQU  80

WIN     EQU  02000h             ; окно текста
WINREC  EQU  64                 ; записей в окне (8 КБ)
WINLEN  EQU  WINREC*128
HALF    EQU  WINLEN/2           ; на столько сдвигаем окно
HALFREC EQU  WINREC/2
WINEND  EQU  WIN+WINLEN
STACK   EQU  0B800h             ; ниже буфера дисковода на BC00

;=======================================================================
start:  LXI  SP,STACK
        LXI  H,mkoi8
        CALL puts
        LDA  FCB+1
        CPI  ' '
        JZ   nofile
        CALL open
        LXI  H,0
        SHLD winrec
        CALL winload
        LXI  H,WIN
        SHLD top
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
        JMP  0

nofile: LXI  D,mnofile
        MVI  C,B.PRINT
        CALL BDOS
        JMP  0

;=======================================================================
; Вниз на строку. Если ушли за середину окна -- подтянуть следующую половину.
godown: LHLD top
        CALL nextln
        JC   loop               ; текст кончился
        SHLD top
        LXI  D,0-(WIN+HALF)     ; top >= середины окна? (перенос -- значит да)
        DAD  D
        JNC  gdshow             ; ещё не дошли -- ничего не двигаем
        LDA  eof                ; дальше читать нечего -- не двигаем окно
        ORA  A
        JNZ  gdshow
        LHLD winrec             ; окно вперёд на половину
        LXI  D,HALFREC
        DAD  D
        SHLD winrec
        CALL winload
        LHLD top                ; текст съехал ровно на HALF байт
        LXI  D,0-HALF
        DAD  D
        SHLD top
gdshow: CALL redraw
        JMP  loop

; Вверх на строку. У начала окна -- подтянуть предыдущую половину.
goup:   LHLD top
        LXI  D,0-(WIN+HALF)
        DAD  D
        JC   gu2                ; выше середины -- места хватает
        LHLD winrec             ; уже в самом начале файла?
        MOV  A,H
        ORA  L
        JZ   gu2
        LXI  D,0-HALFREC        ; окно назад на половину
        DAD  D
        SHLD winrec
        CALL winload
        LHLD top
        LXI  D,HALF
        DAD  D
        SHLD top
gu2:    LHLD top
        CALL prevln
        JC   loop
        SHLD top
        CALL redraw
        JMP  loop

;=======================================================================
; Загрузка окна: WINREC записей начиная с winrec.
winload: XRA A
        STA  eof
        LXI  H,WIN
        SHLD dmaptr
        LXI  H,0
        SHLD wcount
wl1:    LHLD winrec             ; номер записи = winrec + wcount
        XCHG
        LHLD wcount
        DAD  D
        MOV  A,L
        STA  FCB+33
        MOV  A,H
        STA  FCB+34
        XRA  A
        STA  FCB+35
        LHLD dmaptr
        XCHG
        MVI  C,B.SETDMA
        CALL BDOS
        LXI  D,FCB
        MVI  C,B.RDRAND
        CALL BDOS
        ORA  A
        JNZ  wlend              ; запись не прочиталась -- конец файла
        LHLD dmaptr
        LXI  D,128
        DAD  D
        SHLD dmaptr
        LHLD wcount
        INX  H
        SHLD wcount
        LXI  D,0-WINREC
        DAD  D
        JC   wldone             ; окно заполнено
        JMP  wl1
wlend:  MVI  A,1                ; дальше файла нет
        STA  eof
wldone: LHLD dmaptr
        SHLD bufend
        LXI  D,DMA
        MVI  C,B.SETDMA
        CALL BDOS
        RET

;=======================================================================
; nextln/prevln -- границы строк внутри окна.
nextln: PUSH B
nx1:    CALL atend
        JC   nxend
        MOV  A,M
        INX  H
        CPI  00Ah
        JNZ  nx1
        CALL atend
        JC   nxend
        POP  B
        ORA  A
        RET
nxend:  POP  B
        STC
        RET

prevln: PUSH B
        LXI  B,WIN
        MOV  A,H
        CMP  B
        JNZ  pv0
        MOV  A,L
        CMP  C
        JZ   pvend
pv0:    DCX  H
        DCX  H
pv1:    MOV  A,H
        CMP  B
        JNZ  pv2
        MOV  A,L
        CMP  C
        JZ   pvok
pv2:    DCX  H
        MOV  A,M
        CPI  00Ah
        JNZ  pv1
        INX  H
pvok:   POP  B
        ORA  A
        RET
pvend:  POP  B
        STC
        RET

; atend: CY=1, если HL за концом прочитанного
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
redraw: LHLD top
        SHLD scan
        XRA  A
        STA  row
rd1:    LDA  row
        MOV  B,A
        MVI  C,0
        CALL gotoxy
        LHLD scan
        XRA  A
        STA  col
rd2:    CALL atend
        JC   rdeol
        MOV  A,M
        CPI  00Dh
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
        JNC  rdeol2
rdskip: INX  H
        JMP  rd2
rdeol:  CALL atend
        JC   rdeol2
        MOV  A,M
        CPI  00Ah
        JNZ  rdeol2
        INX  H
rdeol2: SHLD scan
        LXI  H,mclreol
        CALL puts
        LDA  row
        INR  A
        STA  row
        CPI  ROWS
        JC   rd1
        CALL status
        RET

;=======================================================================
status: MVI  B,ROWS
        MVI  C,0
        CALL gotoxy
        LXI  H,minv
        CALL puts
        LXI  H,mname
        CALL puts
        LXI  H,FCB+1
        MVI  B,8
        CALL putn
        MVI  A,'.'
        CALL putc
        LXI  H,FCB+9
        MVI  B,3
        CALL putn
        LXI  H,mrec             ; окно: номер первой записи и размер файла
        CALL puts
        LHLD winrec
        CALL hex16
        MVI  A,'/'
        CALL putc
        LHLD fsize
        CALL hex16
        LXI  H,mkeys
        CALL puts
        LXI  H,mpos
        CALL puts
        RET

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

; hex16: HL шестнадцатеричным
hex16:  PUSH H
        MOV  A,H
        CALL hex8
        POP  H
        MOV  A,L
        JMP  hex8
hex8:   PUSH PSW
        RRC
        RRC
        RRC
        RRC
        CALL hex4
        POP  PSW
hex4:   ANI  0Fh
        ADI  '0'
        CPI  '9'+1
        JC   hx1
        ADI  7
hx1:    JMP  putc

;=======================================================================
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

puts:   MOV  A,M
        ORA  A
        RZ
        PUSH H
        CALL putc
        POP  H
        INX  H
        JMP  puts

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
; Открыть файл и узнать его размер в записях.
open:   LXI  D,FCB
        MVI  C,B.OPEN
        CALL BDOS
        INR  A
        JZ   noopen
        LXI  D,FCB              ; размер -> r0,r1
        MVI  C,B.SIZE
        CALL BDOS
        LDA  FCB+33
        MOV  L,A
        LDA  FCB+34
        MOV  H,A
        SHLD fsize
        RET
noopen: LXI  D,mnoopen
        MVI  C,B.PRINT
        CALL BDOS
        JMP  0

;=======================================================================
mkoi8:  DB   ESCC,'[',ESCC,'J',0
mclreol: DB  ESCC,'K',0
minv:   DB   ESCC,'b',0
mbye:   DB   ESCC,'a',ESCC,'J',0
mname:  DB   ' ТЕ  ',0
mrec:   DB   '  окно ',0
mkeys:  DB   '  АР2-выход  стрелки-листать ',0
mpos:   DB   ESCC,'a',0
mnofile: DB  'Нужно имя файла: TE ИМЯ.РАСШ',13,10,'$'
mnoopen: DB  'Файл не открылся',13,10,'$'

row:    DS   1
col:    DS   1
scan:   DS   2
top:    DS   2
winrec: DS   2
wcount: DS   2
bufend: DS   2
dmaptr: DS   2
fsize:  DS   2
eof:    DS   1
