; ---------------------------------------------------------------------------
; STARS.SCR -- заставка для CO: звёздное поле, как «Starfield» в Windows 3.1.
;
; Звёзды вылетают из середины экрана и разлетаются к краям, разгоняясь: за
; кадр каждая уходит от середины на шестнадцатую долю того, где она есть, --
; так и выходит перспектива без деления. У края звезда становится крупнее, а
; уйдя за край, рождается заново у середины. Любая клавиша -- выход в МикроДОС,
; а оттуда, если заставку запустила CO, обратно в CO.
;
; Палитра не трогается: звёзды рисуются цветом текста, по фону -- в цветах,
; которые оставила CO (по умолчанию белые на чёрном).
;
; Экран под T-72 -- режим 512x256, два плана: A000 и C000, их точки идут на
; экране через одну. Цвет текста -- у тех цветов палитры, где стоит бит хотя бы
; одного из них, поэтому прочие два плана нам безразличны. Оба плана лежат
; там, где T-72 держит окно ОЗУ квазидиска (A000-DFFF), и видны только при
; погашенном окне: рисуем с OUT 10h = 0, а к БДОС идём, вернув окно (23h).
; Стек при этом не должен лежать в A000-DFFF -- его ставит ПКК или CO, на E1D3.
;
; Сборка:  python3 tools/asm8080.py scr/stars.asm -o STARS.SCR
; Чтобы CO запускала её вместо гашения монитора -- положить на C: под именем
; CO.SCR. Годится и как обычная программа: переименовать в STARS.COM.
; ---------------------------------------------------------------------------

BDOS    EQU 0005h
SCROLL  EQU 0FFABh              ; сдвиг экрана, его ставит в порт 03 сама T-72
CURBLK  EQU 0FFC6h              ; «пора мигнуть курсором», взводит прерывание
NSTARS  EQU 80                  ; сколько звёзд
REC     EQU 8                   ; запись звезды, см. STARS ниже

        ORG  0100h

START:  LDA  0FFC7h             ; счётчик кадров T-72 -- на затравку
        ORI  1                  ; нулевая затравка дала бы одни нули
        STA  SEED
        XRA  A
        OUT  10h
        CALL CLS
        MVI  A,23h
        OUT  10h
        ; Первое поколение -- по всему экрану, чтобы небо не начиналось с
        ; пустоты; дальше звёзды рождаются у середины.
        LXI  H,STARS
        MVI  B,NSTARS
INIT:   PUSH B
        PUSH H
        SHLD RP
        CALL WIDE
        POP  H
        LXI  D,REC
        DAD  D
        POP  B
        DCR  B
        JNZ  INIT

FRAME:  EI
        HLT                     ; ждём кадр: и плавно, и прерывание отработано
        LDA  SCROLL
        STA  SCRL
        XRA  A
        OUT  10h                ; окно долой -- под ним экран
        LXI  H,STARS
        MVI  B,NSTARS
ONE:    PUSH B
        PUSH H
        CALL STEP
        POP  H
        LXI  D,REC
        DAD  D
        POP  B
        DCR  B
        JNZ  ONE
        MVI  A,23h
        OUT  10h                ; окно обратно -- к БДОС только так
        ; Курсор T-72 мигает не сам: его перерисовывает опрос клавиатуры
        ; (L_FE57 в _F600h.asm), когда прерывание взвело флажок FFC6, -- и
        ; рисует прямо поверх картинки. Флажок снимаем перед каждым опросом.
        XRA  A
        STA  CURBLK
        MVI  C,6
        MVI  E,0FFh
        CALL BDOS               ; нажато что-нибудь?
        ORA  A
        JZ   FRAME
        ; Выход: экран чистим сами -- иначе приглашение ПКК мелькнёт поверх
        ; звёзд, пока CO не поднимется и не нарисует панели.
        XRA  A
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
; Один кадр одной звезды: стереть, сдвинуть, нарисовать. HL -- её запись:
;   +0 x  -- от середины, в 1/128 точки: на экране x>>7, от -256 до 255
;   +2 y  -- от середины, в 1/256 точки: на экране y>>8, от -128 до 127
;   +4    -- адрес, по которому она нарисована (план A000 или C000)
;   +6    -- маска её точки в байте (0 -- не нарисована)
;   +7    -- 0 мелкая, точка; 1 крупная, два на два
; Точки по x вдвое уже, чем по y (512 на 256), поэтому и единицы у x вдвое
; мельче: разлёт выходит круглым.
; ---------------------------------------------------------------------------
STEP:   SHLD RP
        LXI  D,4
        DAD  D
        MOV  E,M
        INX  H
        MOV  D,M
        INX  H
        MOV  A,M
        INX  H
        MOV  B,M
        ORA  A
        JZ   MOVE
        CMA
        MOV  C,A
        XCHG
        CALL PIX                ; стереть -- И с обратной маской
MOVE:   LHLD RP
        MOV  E,M
        INX  H
        MOV  D,M
        XCHG                    ; HL = x, DE -> старший байт x
        CALL GROW
        JC   REBORN             ; ушла за край
        XCHG
        MOV  M,D
        DCX  H
        MOV  M,E
        INX  H
        INX  H
        MOV  E,M
        INX  H
        MOV  D,M
        XCHG                    ; HL = y
        CALL GROW
        JC   REBORN
        XCHG
        MOV  M,D
        DCX  H
        MOV  M,E
        JMP  DRAW
REBORN: CALL NEAR

; Нарисовать звезду по её x и y и запомнить, где нарисована.
DRAW:   LHLD RP
        MOV  E,M
        INX  H
        MOV  D,M
        INX  H
        INX  H
        MOV  B,M                ; B = точка по y со знаком
        XCHG
        DAD  H                  ; H = x>>7, перенос -- знак x
        MVI  D,10h              ; правая половина: столбцы 16..31
        JNC  DR1
        MVI  D,0                ; левая: 0..15
DR1:    MVI  E,0                ; мелкая, если |x| < 128 точек: старший
        MOV  A,H                ; бит H равен знаку x, то есть не равен
        RRC                     ; разряду 10h в D
        RRC
        RRC
        XRA  D
        ANI  10h
        JNZ  DR2
        INR  E
DR2:    MOV  A,B                ; ... и |y| < 64
        ADI  40h
        ANI  80h
        JZ   DR3
        MVI  E,1
DR3:    MOV  A,H                ; столбец: x>>4 от левого края
        RRC
        RRC
        RRC
        RRC
        ANI  0Fh
        ADD  D
        MOV  D,A
        MOV  A,H                ; точка в паре столбцов: план и бит
        ANI  0Fh
        RAR
        MVI  H,0C0h             ; чётная точка -- план C000 ...
        JNC  DR4
        MVI  H,0A0h             ; ... нечётная -- A000
DR4:    MVI  C,80h
        ORA  A
        JZ   DR6
        MOV  L,A
DR5:    MOV  A,C
        RRC
        MOV  C,A
        DCR  L
        JNZ  DR5
DR6:    MOV  A,H
        ADD  D
        MOV  H,A
        MOV  A,B                ; строка: сдвиг экрана минус Y от верха
        XRI  80h
        MOV  B,A
        LDA  SCRL
        SUB  B
        MOV  L,A
        MOV  B,E                ; B -- крупная ли, C -- маска
        PUSH H
        PUSH B
        CALL PIX0               ; нарисовать -- ИЛИ с маской
        POP  B
        POP  D
        LHLD RP
        INX  H
        INX  H
        INX  H
        INX  H
        MOV  M,E
        INX  H
        MOV  M,D
        INX  H
        MOV  M,C
        INX  H
        MOV  M,B
        RET

; Тронуть точку звезды по HL: B=0 -- одну, иначе четыре (два плана, две
; строки). PIX стирает (C -- обратная маска), PIX0 рисует (C -- маска).
PIX:    MOV  A,M
        ANA  C
        MOV  M,A
        DCR  B
        RM
        MOV  A,H
        XRI  60h                ; A0xx <-> C0xx: соседняя точка
        MOV  H,A
        MOV  A,M
        ANA  C
        MOV  M,A
        DCR  L
        MOV  A,M
        ANA  C
        MOV  M,A
        MOV  A,H
        XRI  60h
        MOV  H,A
        MOV  A,M
        ANA  C
        MOV  M,A
        RET
PIX0:   MOV  A,M
        ORA  C
        MOV  M,A
        DCR  B
        RM
        MOV  A,H
        XRI  60h
        MOV  H,A
        MOV  A,M
        ORA  C
        MOV  M,A
        DCR  L
        MOV  A,M
        ORA  C
        MOV  M,A
        MOV  A,H
        XRI  60h
        MOV  H,A
        MOV  A,M
        ORA  C
        MOV  M,A
        RET

; HL += HL>>4 со знаком. Перенос -- если вышло за край (знак сменился).
GROW:   PUSH D
        MOV  A,L
        RRC
        RRC
        RRC
        RRC
        ANI  0Fh
        MOV  E,A
        MOV  A,H
        RLC
        RLC
        RLC
        RLC
        MOV  D,A
        ANI  0F0h
        ORA  E
        MOV  E,A
        MOV  A,D
        ANI  0Fh
        MOV  D,A
        MOV  A,H
        ORA  A
        JP   GR1
        MOV  A,D
        ORI  0F0h
        MOV  D,A
GR1:    MOV  A,H
        DAD  D
        XRA  H
        POP  D
        RAL
        RET

; Новая звезда у середины, в квадрате шириной в тридцать две точки. Положительный
; x не бывает меньше 16: иначе HL>>4 даст нуль, и звезда так и застынет.
NEAR:   CALL RND
        ANI  1Fh
        SUI  10h
        MOV  D,A
        CALL RND
        ORI  10h
        MOV  E,A
        CALL RND
        ANI  1Fh
        SUI  10h
        MOV  B,A
        CALL RND
        MOV  C,A
        JMP  PUT
; Звезда где угодно на экране -- для первого поколения.
WIDE:   CALL RND
        MOV  D,A
        CALL RND
        ORI  10h
        MOV  E,A
        CALL RND
        MOV  B,A
        CALL RND
        MOV  C,A
; Записать x=DE, y=BC в запись по RP; нарисованной она пока не числится.
PUT:    LHLD RP
        MOV  M,E
        INX  H
        MOV  M,D
        INX  H
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        INX  H
        INX  H
        MVI  M,0
        RET

; Случайный байт: восемь шагов 16-разрядного сдвигового регистра. По шагу на
; байт соседние байты вышли бы сдвинутыми копиями друг друга, и звёзды
; выстроились бы по диагоналям.
RND:    PUSH B
        PUSH H
        LHLD SEED
        MVI  B,8
RN1:    MOV  A,H
        ORA  A                  ; перенос -- в нуль
        RAR
        MOV  H,A
        MOV  A,L
        RAR
        MOV  L,A
        JNC  RN2
        MOV  A,H
        XRI  0B4h
        MOV  H,A
RN2:    DCR  B
        JNZ  RN1
        SHLD SEED
        MOV  A,L
        POP  H
        POP  B
        RET

SEED:   .dw  0ACE1h
RP:     .dw  0
SCRL:   .db  0
; Записи звёзд -- сразу за программой. Не .ds: им не нужно лежать в файле,
; хватит и того, что ниже A000 места на них вдоволь.
STARS   EQU  $
