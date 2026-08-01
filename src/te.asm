; TE -- экранный редактор для MDOS T-72 на ПК Вектор-06Ц.
;
; Что умеет: открыть файл любого размера, ходить по нему курсором, править и
; записать. Целиком файл в память не влезает (под всё 48 КБ вместе с кодом),
; поэтому в памяти живёт окно на 32 КБ, а читается оно по номерам записей
; функцией БДОС 33. Что произвольный доступ в МикроДОС есть -- проверено на
; живой машине: функция 35 вернула размер файла, 33 прочитала запись 0.
;
; Правка идёт внутри окна. Записать можно файл, который в окно поместился
; целиком; если он больше -- редактор об этом честно скажет, а не испортит файл
; молча. Дописать сквозную запись для больших файлов -- следующий заход.
;
; Экран 80x25, курсор -- ESC Y <строка+20h> <столбец+20h>. Нижняя строка отдана
; под состояние.
;
; Две грабли T-72, на которых уже спотыкался CO:
;   * буфер дисковода лежит на BC00-BFFF, а ячейка 0006 обещает C000 -- стек
;     ставим ниже сами, иначе его затрёт первым же чтением сектора;
;   * выходить надо через JMP 0: свой стек уже поставлен, возвращаться в ССР
;     по RET не по чему.

        ORG  0100h

BDOS    EQU  0005h
FCB     EQU  005Ch
DMA     EQU  0080h

B.CONOUT EQU 2
B.CONIO  EQU 6
B.PRINT  EQU 9
B.CONST  EQU 11                 ; есть ли нажатая клавиша
B.OPEN   EQU 15
B.CLOSE  EQU 16
B.DELETE EQU 19
B.WRSEQ  EQU 21
B.MAKE   EQU 22
B.SETDMA EQU 26
B.RDRAND EQU 33
B.SIZE   EQU 35

K.LEFT  EQU  008h
K.RIGHT EQU  018h
K.UP    EQU  019h
K.DOWN  EQU  01Ah
K.AR2   EQU  01Bh               ; выход
K.CR    EQU  00Dh
K.BS    EQU  07Fh               ; ЗБ
K.SAVE  EQU  00Fh               ; УС+O -- записать

ESCC    EQU  01Bh
ROWS    EQU  24
COLS    EQU  80

WIN     EQU  02000h             ; окно текста
WINREC  EQU  256                ; 32 КБ
WINLEN  EQU  WINREC*128
HALF    EQU  WINLEN/2
HALFREC EQU  WINREC/2
WINEND  EQU  WIN+WINLEN
LBUF    EQU  0A800h             ; буфер строки для вывода одним вызовом
STACK   EQU  0B800h

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
        SHLD cur
        CALL redraw

loop:   CALL getkey
        CPI  K.AR2
        JZ   quit
        CPI  K.DOWN
        JZ   godown
        CPI  K.UP
        JZ   goup
        CPI  K.LEFT
        JZ   goleft
        CPI  K.RIGHT
        JZ   goright
        CPI  K.BS
        JZ   dobs
        CPI  K.SAVE
        JZ   dosave
        CPI  K.CR
        JZ   dosplit
        CPI  ' '                ; всё печатное -- вставляем
        JC   loop
        JMP  doins

; После каждой клавиши перерисовываем, но если в буфере есть ещё нажатия --
; сначала разбираем их. Иначе при удержании стрелки половина нажатий теряется:
; полная перерисовка это 1920 символов через БДОС.
show:   CALL keyready
        JNZ  loop
        CALL redraw
        JMP  loop
showln  EQU  show               ; частичная перерисовка не оправдалась -- см. README

quit:   LDA  dirty
        ORA  A
        JZ   quit2
        CALL askquit            ; есть несохранённое -- переспросим
        JZ   loop
quit2:  LXI  H,mbye
        CALL puts
        JMP  0

nofile: LXI  D,mnofile
        MVI  C,B.PRINT
        CALL BDOS
        JMP  0

;=======================================================================
; Движение курсора.
goleft: LHLD cur
        LXI  D,0-WIN
        DAD  D
        MOV  A,H
        ORA  L
        JZ   show               ; уже в начале окна
        LHLD cur
        DCX  H
        MOV  A,M
        CPI  00Ah               ; перешагнули на предыдущую строку
        JNZ  gl1
        DCX  H
        MOV  A,M
        CPI  00Dh
        JZ   gl1
        INX  H
gl1:    SHLD cur
        CALL fixtop
        JMP  show

goright: LHLD cur
        CALL atend
        JC   show
        MOV  A,M
        INX  H
        CPI  00Dh               ; ВК+ПС проходим парой
        JNZ  gr1
        MOV  A,M
        CPI  00Ah
        JNZ  gr1
        INX  H
gr1:    SHLD cur
        CALL fixtop
        JMP  show

; Вниз/вверх: держим столбец, куда получится.
godown: CALL curcol             ; C = столбец курсора
        PUSH B
        LHLD cur
        CALL tolnstart
        CALL nextln
        JC   gdno
        POP  B
        CALL setcol
        CALL fixtop
        JMP  show
gdno:   POP  B
        JMP  show

goup:   CALL curcol
        PUSH B
        LHLD cur
        CALL tolnstart
        CALL prevln
        JC   guno
        POP  B
        CALL setcol
        CALL fixtop
        JMP  show
guno:   POP  B
        JMP  show

; setcol: HL -- начало строки, C -- желаемый столбец. Ставит cur.
setcol: MOV  A,C
        ORA  A
        JZ   sc2
sc1:    CALL atend
        JC   sc2
        MOV  A,M
        CPI  00Dh
        JZ   sc2
        CPI  00Ah
        JZ   sc2
        INX  H
        DCR  C
        JNZ  sc1
sc2:    SHLD cur
        RET

; curcol: C = столбец курсора (от начала строки)
curcol: PUSH H
        PUSH D
        LHLD cur
        XCHG                    ; DE = cur
        LHLD cur
        CALL tolnstart          ; HL = начало строки
        MVI  C,0
cc1:    MOV  A,H
        CMP  D
        JNZ  cc2
        MOV  A,L
        CMP  E
        JZ   cc3
cc2:    INX  H
        INR  C
        JMP  cc1
cc3:    POP  D
        POP  H
        RET

; tolnstart: HL внутри строки -> начало этой строки
tolnstart: PUSH B
        LXI  B,WIN
tl1:    MOV  A,H
        CMP  B
        JNZ  tl2
        MOV  A,L
        CMP  C
        JZ   tl3
tl2:    DCX  H
        MOV  A,M
        CPI  00Ah
        JZ   tl4
        JMP  tl1
tl4:    INX  H
tl3:    POP  B
        RET

;=======================================================================
; fixtop: подтянуть top так, чтобы курсор был на экране, и при нужде сдвинуть
; окно по файлу.
fixtop: LHLD cur                ; курсор выше top?
        XCHG
        LHLD top
        MOV  A,E
        SUB  L
        MOV  A,D
        SBB  H
        JNC  ft1
        XCHG                    ; да -- ставим top на строку курсора
        CALL tolnstart
        SHLD top
        JMP  ftwin
ft1:    LHLD top                ; считаем, на сколько строк курсор ниже top
        MVI  B,0
ft2:    CALL atend
        JC   ftwin
        XCHG
        LHLD cur
        MOV  A,E
        SUB  L
        MOV  A,D
        SBB  H
        XCHG
        JC   ftwin              ; дошли до строки курсора
        MOV  A,B
        CPI  ROWS-1
        JNC  ft3
        INR  B
        CALL nextln
        JC   ftwin
        JMP  ft2
ft3:    LHLD top                ; курсор ниже экрана -- листаем вниз
        CALL nextln
        JC   ftwin
        SHLD top
        JMP  ft1

; ftwin: если top уполз за половину окна -- подтянуть следующую/предыдущую
ftwin:  LHLD top
        LXI  D,0-(WIN+HALF)
        DAD  D
        JNC  ftw2
        LDA  eof
        ORA  A
        JNZ  ftw2
        LDA  dirty              ; правленое окно двигать нельзя -- потеряем правку
        ORA  A
        JNZ  ftw2
        LHLD winrec
        LXI  D,HALFREC
        DAD  D
        SHLD winrec
        CALL winload
        LHLD top
        LXI  D,0-HALF
        DAD  D
        SHLD top
        LHLD cur
        LXI  D,0-HALF
        DAD  D
        SHLD cur
ftw2:   LHLD top                ; и назад, если поднялись выше начала окна
        LXI  D,0-(WIN+128)
        DAD  D
        JC   ftw3
        LHLD winrec
        MOV  A,H
        ORA  L
        JZ   ftw3
        LDA  dirty
        ORA  A
        JNZ  ftw3
        LHLD winrec
        LXI  D,0-HALFREC
        DAD  D
        SHLD winrec
        CALL winload
        LHLD top
        LXI  D,HALF
        DAD  D
        SHLD top
        LHLD cur
        LXI  D,HALF
        DAD  D
        SHLD cur
ftw3:   RET

;=======================================================================
; Правка. Вставка символа из A на место курсора.
doins:  STA  pend               ; shiftup портит BC, поэтому символ -- в память
        LHLD bufend             ; место ещё есть?
        LXI  D,0-(WINEND-2)
        DAD  D
        JC   insfull
        CALL shiftup            ; раздвинуть на байт
        LHLD cur
        LDA  pend
        MOV  M,A
        INX  H
        SHLD cur
        MVI  A,1
        STA  dirty
        JMP  showln
insfull: JMP show

; ВК -- разрезать строку: вставляем ВК и ПС
dosplit: LHLD bufend
        LXI  D,0-(WINEND-3)
        DAD  D
        JC   show
        CALL shiftup
        LHLD cur
        MVI  M,00Dh
        INX  H
        SHLD cur
        CALL shiftup
        LHLD cur
        MVI  M,00Ah
        INX  H
        SHLD cur
        MVI  A,1
        STA  dirty
        JMP  show

; ЗБ -- убрать символ слева. На начале строки склеиваем со предыдущей.
dobs:   LHLD cur
        LXI  D,0-WIN
        DAD  D
        MOV  A,H
        ORA  L
        JZ   show
        LHLD cur
        DCX  H
        MOV  A,M
        CPI  00Ah               ; склейка строк -- убрать ПС и ВК
        JNZ  bs1
        SHLD cur
        CALL shiftdn
        LHLD cur
        DCX  H
        MOV  A,M
        CPI  00Dh
        JNZ  bs2
        SHLD cur
        CALL shiftdn
        JMP  bs2
bs1:    SHLD cur
        CALL shiftdn
bs2:    MVI  A,1
        STA  dirty
        JMP  show

; shiftup: раздвинуть текст на байт по cur, хвост уезжает вправо
shiftup: LHLD cur                ; BC = длина хвоста = bufend - cur
        XCHG
        LHLD bufend
        MOV  A,L
        SUB  E
        MOV  C,A
        MOV  A,H
        SBB  D
        MOV  B,A
        LHLD bufend             ; HL -- куда, DE -- откуда, идём сверху вниз
        MOV  D,H
        MOV  E,L
        DCX  D
su1:    MOV  A,B
        ORA  C
        JZ   su2
        LDAX D
        MOV  M,A
        DCX  H
        DCX  D
        DCX  B
        JMP  su1
su2:    LHLD bufend
        INX  H
        SHLD bufend
        RET

; shiftdn: убрать байт по cur, хвост сдвигается влево
shiftdn: LHLD cur
        XCHG
        LHLD bufend
        MOV  A,L
        SUB  E
        MOV  C,A
        MOV  A,H
        SBB  D
        MOV  B,A
        DCX  B                  ; сам убираемый байт не копируем
        LHLD cur
        MOV  D,H
        MOV  E,L
        INX  D
sd1:    MOV  A,B
        ORA  C
        JZ   sd2
        LDAX D
        MOV  M,A
        INX  H
        INX  D
        DCX  B
        JMP  sd1
sd2:    LHLD bufend
        DCX  H
        SHLD bufend
        RET

;=======================================================================
; Запись файла. Пишем только если файл целиком уместился в окно.
dosave: LHLD winrec
        MOV  A,H
        ORA  L
        JNZ  sbig
        LDA  eof
        ORA  A
        JZ   sbig
        LXI  D,FCB              ; старый файл долой
        MVI  C,B.DELETE
        CALL BDOS
        LXI  D,FCB
        MVI  C,B.MAKE
        CALL BDOS
        INR  A
        JZ   sbad
        XRA  A                  ; после случайных чтений в ФУБ остался счётчик
        STA  FCB+12             ; экстент
        STA  FCB+14
        STA  FCB+15
        STA  FCB+32             ; и текущая запись -- иначе допишем в хвост
        LXI  H,WIN
        SHLD dmaptr
sv1:    LHLD dmaptr             ; всё записали?
        XCHG
        LHLD bufend
        MOV  A,E
        SUB  L
        MOV  A,D
        SBB  H
        JNC  sv2
        LHLD dmaptr
        XCHG
        MVI  C,B.SETDMA
        CALL BDOS
        LXI  D,FCB
        MVI  C,B.WRSEQ
        CALL BDOS
        ORA  A
        JNZ  sbad
        LHLD dmaptr
        LXI  D,128
        DAD  D
        SHLD dmaptr
        JMP  sv1
sv2:    LXI  D,FCB
        MVI  C,B.CLOSE
        CALL BDOS
        LXI  D,DMA
        MVI  C,B.SETDMA
        CALL BDOS
        XRA  A
        STA  dirty
        LXI  H,msaved
        CALL note
        JMP  loop
sbig:   LXI  H,mbig
        CALL note
        JMP  loop
sbad:   LXI  H,mbad
        CALL note
        JMP  loop

;=======================================================================
; Загрузка окна.
winload: XRA A
        STA  eof
        LXI  H,WIN
        SHLD dmaptr
        LXI  H,0
        SHLD wcount
wl1:    LHLD winrec
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
        JNZ  wlend
        LHLD dmaptr
        LXI  D,128
        DAD  D
        SHLD dmaptr
        LHLD wcount
        INX  H
        SHLD wcount
        LXI  D,0-WINREC
        DAD  D
        JC   wldone
        JMP  wl1
wlend:  MVI  A,1
        STA  eof
wldone: LHLD dmaptr
        SHLD bufend
        LXI  D,DMA
        MVI  C,B.SETDMA
        CALL BDOS
        RET

;=======================================================================
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
; Полная перерисовка. Строка собирается в буфер и уходит одним вызовом БДОС --
; по символу через функцию 2 это втрое дольше.
redraw: LHLD top
        SHLD scan
        XRA  A
        STA  row
rd1:    LDA  row
        MOV  B,A
        MVI  C,0
        CALL gotoxy
        LHLD scan
        CALL putline
        SHLD scan
        LDA  row
        INR  A
        STA  row
        CPI  ROWS
        JC   rd1
        CALL status
        CALL curshow
        RET

; putline: вывести строку из (HL) до конца строки; HL -> начало следующей
putline: LXI D,LBUF
        MVI  C,0
pl1:    CALL atend
        JC   pl3
        MOV  A,M
        CPI  00Dh
        JZ   pl2
        CPI  00Ah
        JZ   pl3
        STAX D
        INX  D
        INX  H
        INR  C
        MOV  A,C
        CPI  COLS
        JNC  pl4
        JMP  pl1
pl2:    INX  H                  ; ВК не печатаем
        JMP  pl1
pl3:    CALL atend
        JC   pl4
        MOV  A,M
        CPI  00Ah
        JNZ  pl4
        INX  H
pl4:    PUSH H
        MVI  A,'$'              ; хвост строки гасим и печатаем разом
        STAX D
        LXI  D,LBUF
        MVI  C,B.PRINT
        CALL BDOS
        LXI  H,mclreol
        CALL puts
        POP  H
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
        LDA  dirty
        ORA  A
        JZ   st1
        LXI  H,mdirty
        CALL puts
st1:    LXI  H,mrec
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

; note: показать сообщение в строке состояния до нажатия клавиши
note:   PUSH H
        MVI  B,ROWS
        MVI  C,0
        CALL gotoxy
        LXI  H,minv
        CALL puts
        POP  H
        CALL puts
        LXI  H,mclreol
        CALL puts
        LXI  H,mpos
        CALL puts
        CALL getkey
        CALL status
        CALL curshow
        RET

; askquit: спросить про несохранённое. Z=1 -- остаёмся.
askquit: LXI H,mask
        PUSH H
        MVI  B,ROWS
        MVI  C,0
        CALL gotoxy
        LXI  H,minv
        CALL puts
        POP  H
        CALL puts
        LXI  H,mclreol
        CALL puts
        LXI  H,mpos
        CALL puts
        CALL getkey
        CPI  'Y'
        JZ   aqyes
        CPI  'y'
        JZ   aqyes
        CALL status             ; остаёмся
        CALL curshow
        XRA  A                  ; Z=1
        RET
aqyes:  MVI  A,1                ; Z=0 -- выходим
        ORA  A
        RET

;=======================================================================
; currow: B = экранная строка курсора. Идём от top построчно и смотрим, в какой
; строке оказался cur: сравнивать надо с началом СЛЕДУЮЩЕЙ строки.
currow: PUSH H
        PUSH D
        LHLD top
        SHLD tmp2
        MVI  B,0
cr1:    LHLD tmp2
        PUSH B
        CALL nextln
        POP  B
        JC   cr2                ; строк больше нет -- курсор здесь
        SHLD tmp2
        XCHG                    ; DE = начало следующей строки
        LHLD cur
        MOV  A,L
        SUB  E
        MOV  A,H
        SBB  D
        JC   cr2                ; cur < следующей -- значит в текущей
        INR  B
        MOV  A,B
        CPI  ROWS
        JC   cr1
cr2:    POP  D
        POP  H
        RET

; curshow: поставить курсор на экране
curshow: CALL currow
        PUSH B
        CALL curcol
        POP  B
        CALL gotoxy
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

; keyready: Z=0, если клавиша уже нажата
keyready: PUSH B
        PUSH D
        PUSH H
        MVI  C,B.CONST
        CALL BDOS
        POP  H
        POP  D
        POP  B
        ORA  A
        RET

;=======================================================================
open:   LXI  D,FCB
        MVI  C,B.OPEN
        CALL BDOS
        INR  A
        JZ   noopen
        LXI  D,FCB
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
mdirty: DB   ' *',0
mrec:   DB   '  окно ',0
mkeys:  DB   '  УС+O-записать  АР2-выход ',0
mpos:   DB   ESCC,'a',0
msaved: DB   ' Записано ',0
mbig:   DB   ' Файл больше окна -- запись пока не поддержана ',0
mbad:   DB   ' Не записалось ',0
mask:   DB   ' Есть несохранённое. Выйти? (Y/N) ',0
mnofile: DB  'Нужно имя файла: TE ИМЯ.РАСШ',13,10,'$'
mnoopen: DB  'Файл не открылся',13,10,'$'

row:    DS   1
scan:   DS   2
top:    DS   2
cur:    DS   2
winrec: DS   2
wcount: DS   2
bufend: DS   2
dmaptr: DS   2
fsize:  DS   2
eof:    DS   1
dirty:  DS   1
tmp2:   DS   2
pend:   DS   1
