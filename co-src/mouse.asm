; ---------------------------------------------------------------------------
; Мышь: контроллер KTSerg на порту D4h (он же у ComboLite и в Emu80).
;
; Порт один. Запись выбирает регистр (разряды 3:0) и включает контроллер
; (разряд 5 -- ноль), чтение отдаёт выбранный регистр. Берём четыре:
;   1, 2 -- X и Y указателя, 0..255; Y растёт ВВЕРХ, верх экрана -- FFh;
;   3    -- шаги колеса с прошлого чтения, со знаком, от себя -- плюс;
;   8    -- кнопки: разряд 0 левая, 1 правая, 2 средняя.
; Есть ли мышь, пусковая проба узнаёт по регистру 15 (co-src/mousini.asm), и
; только тогда врезает опрос в CO. Нет мыши -- в CO не меняется ни байта.
;
; Опрос живёт в ожидании клавиши: 04C1 крутит цикл, в котором зовёт монитор
; F81B «есть ли клавиша», и врезка по 04F4 зовёт вместо него MPOLL. Что бы
; мышь ни сделала, CO получает обычный код клавиши, и дальше всё идёт по её
; же таблицам:
;   правая кнопка    -- АР2;
;   колесо           -- стрелки вверх и вниз, по одной на шаг;
;   левая над нижней строкой -- цифра той функции, на которую попали; какая
;                      строка на экране (обычная или по «СС»), помнит B68F;
;   левая над файлом -- курсор на файл; второй щелчок по нему вскоре -- ВК;
;   левая над файлом другой панели -- ТАБ, а на следующем обороте ожидания,
;                      когда панель уже переключилась, -- курсор на файл;
;   левая вне панелей (просмотр, меню, вопросы) -- ВК.
; Курсор на файл ставится не клавишей, а прямо: так же, как это делают
; стрелки (0477), -- погасить курсор (082D), новый номер в B69B, нарисовать
; (0890).
;
; Указатель -- вывороткой знакоместа под мышью: оба плана видеопамяти XOR по
; маске знака. Повторный XOR возвращает картинку, поэтому старое место гасится
; без копии. Но рисовать поверх указателя может только сама CO, и тогда XOR
; вывернул бы уже новый знак. Поэтому указатель виден только пока CO ждёт
; клавишу, а гасится перед любой её отрисовкой: перед возвратом кода, перед
; курсором файла, перед полосой подсказки, которую 04C1 перерисовывает при
; нажатии и отпускании «СС» (врезки по 04B6 и 04ED), и перед заставкой (0508).
;
; Экран консоли T-72: 80 знаков по 6 точек и 25 строк по 10 линий. Знак в
; колонке c занимает три точки в каждом из двух планов, начиная с точки 3c в
; масштабе 256; первый столбец байт (A0h) пуст, планы -- A1xx и C1xx. Верхняя
; линия строки r -- FFAB - 10r (FFAB -- сдвиг экрана, ячейка ОС). Так
; считает сама консоль: P_FB97 и P_FB77 в Source/_F600h.asm.
; ---------------------------------------------------------------------------
        ORG  ORIGIN

MPORT   EQU 0D4h                ; порт контроллера
MKEYWT  EQU 0A800h              ; CO: 1 -- ждём клавишу над панелями (0583)
MBARSW  EQU 0B68Fh              ; CO: какая полоса внизу, 1 или 2
MPANEL  EQU 0B69Dh              ; CO: активная панель, 1 или 2
MCURS   EQU 0B69Bh              ; CO: номер файла под курсором, с единицы
MCOLOFS EQU 0B681h              ; CO: сколько колонок панели прокручено
MMODE   EQU 03E93h              ; CO: вид панели, 'P' -- 40 файлов, иначе 60
MSEL1   EQU 00E4Dh              ; CO: HL += 1 для второй панели
MSEL2   EQU 00E47h              ; CO: то же для полей по два байта
MCUROFF EQU 0082Dh              ; CO: погасить курсор файла
MCURON  EQU 00890h              ; CO: курсор по B69B -- с прокруткой и пределом
MSCROLL EQU 0FFABh              ; ОС: сдвиг экрана
MDBLN   EQU 1500                ; оборотов ожидания на двойной щелчок

; ---------------- опрос: вместо монитора F81B ------------------------------
; Возврат как у F81B: код клавиши в A, FFh -- ничего. B, C и D у 04C1 --
; счётчики срока гашения монитора, их не трогаем.
MPOLL:  CALL 0F81Bh
        CPI  0FFh
        JNZ  mhidek             ; клавиша -- прятать указатель и отдать её
        PUSH B
        PUSH D
        PUSH H
        CALL mread
        POP  H
        POP  D
        POP  B
        CPI  0FFh
        RZ
mhidek: PUSH PSW
        CALL mhide
        POP  PSW
        RET

; Ожидание без срока: при нулевом сроке 04C1 не крутит цикл, а сразу ждёт
; клавишу монитором F803 (0536). Врезка туда.
MWAIT:  CALL MPOLL
        CPI  0FFh
        JZ   MWAIT
        RET

; Перед перерисовкой полосы (04B6, 04ED) и перед заставкой (0508).
MBAR:   CALL mhide
        JMP  L_0F9A
MSCR:   CALL mhide
        JMP  SCRSAV

; ---------------- чтение мыши ----------------------------------------------
mread:  LHLD mdbl               ; окно двойного щелчка тикает
        MOV  A,H
        ORA  L
        JZ   mr0
        DCX  H
        SHLD mdbl
mr0:    MVI  A,1                ; X -> колонка: (X-8)/3, не дальше 79
        CALL mreg
        SUI  8
        JNC  mr1
        XRA  A
mr1:    MVI  B,3
        CALL mdiv
        CPI  80
        JC   mr2
        MVI  A,79
mr2:    MOV  E,A
        MVI  A,2                ; Y -> строка: (255-Y)/10, не дальше 24
        CALL mreg
        CMA
        MVI  B,10
        CALL mdiv
        CPI  25
        JC   mr3
        MVI  A,24
mr3:    MOV  D,A
        LHLD mpos               ; сдвинулась ли
        MOV  A,L
        CMP  E
        JNZ  mmove
        MOV  A,H
        CMP  D
        JNZ  mmove
        LDA  mon
        ORA  A
        JNZ  mkeys
mmove:  PUSH D
        CALL mhide
        POP  H
        SHLD mpos
        CALL mxor               ; показать на новом месте
mkeys:  MVI  A,8                ; кнопки: что нажато с прошлого раза
        CALL mreg
        MOV  C,A
        LDA  mbtn
        CMA
        ANA  C
        MOV  B,A
        MOV  A,C
        STA  mbtn
        MVI  A,3                ; колесо копим: за оборот отдаём один шаг
        CALL mreg
        LXI  H,mwhl
        ADD  M
        MOV  M,A
        MOV  A,B
        ANI  2
        MVI  A,01Bh             ; правая -- АР2
        RNZ
        MOV  A,B
        RRC
        JC   mleft
        MOV  A,M                ; колесо
        ORA  A
        JZ   mpend0
        JM   mwdn
        DCR  M
        MVI  A,019h             ; от себя -- вверх
        RET
mwdn:   INR  M
        MVI  A,01Ah             ; на себя -- вниз
        RET
mpend0: LXI  H,mpend            ; щелчок, отложенный до смены панели
        MOV  A,M
        ORA  A
        MVI  A,0FFh
        RZ
        MVI  M,0
        LDA  MKEYWT
        DCR  A
        JZ   mpanel
mnone:  MVI  A,0FFh
        RET
mleft:  LDA  MKEYWT
        DCR  A
        MVI  A,00Dh             ; не над панелями -- ВК
        RNZ

; ---------------- щелчок над панелями --------------------------------------
mpanel: LHLD mpos               ; L -- колонка, H -- строка
        MOV  A,H
        CPI  24
        JZ   mbar
        SUI  2                  ; поле файлов -- строки 2..21
        CPI  20
        JNC  mnone
        MOV  D,A
        MOV  A,L
        MVI  C,1
        CPI  40
        JC   mp1
        SUI  40
        INR  C
mp1:    MOV  E,A                ; колонка внутри панели
        LDA  MPANEL
        CMP  C
        JZ   mp2
        MVI  A,1                ; другая панель: сперва ТАБ
        STA  mpend
        MVI  A,009h
        RET
mp2:    LXI  H,MMODE            ; ширина колонки: 19 при 40 файлах, 13 при 60
        CALL MSEL1
        MOV  A,M
        MVI  B,13
        CPI  'P'
        JNZ  mp3
        MVI  B,19
mp3:    MOV  A,E                ; колонка 0 -- рамка
        SUI  1
        JNC  mp4
        XRA  A
mp4:    CALL mdiv
        MOV  C,A
        LXI  H,MCOLOFS          ; номер = (прокрутка + колонка) * 20 + строка + 1
        CALL MSEL2
        MOV  A,M
        ADD  C
        MOV  C,A
        ADD  A
        ADD  A
        ADD  C
        ADD  A
        ADD  A
        ADD  D
        INR  A
        LXI  H,MCURS
        CMP  M
        JNZ  mset
        LHLD mdbl               ; тот же файл, и окно не закрылось -- ВК
        MOV  C,A
        MOV  A,H
        ORA  L
        MVI  A,00Dh
        RNZ
        MOV  A,C
mset:   LXI  H,MDBLN
        SHLD mdbl
        PUSH PSW
        CALL mhide
        CALL MCUROFF
        POP  PSW
        STA  MCURS
        CALL MCURON
        JMP  mnone

; Нижняя строка: цифра той подписи, в которую попали. Подписи вида «5-Копия»:
; идём по строке до колонки щелчка (и на знак дальше, чтобы щелчок по самой
; цифре брал её подпись) и запоминаем знак перед каждым «-».
mbar:   MOV  C,L
        INR  C
        INR  C
        LDA  MBARSW
        DCR  A
        LXI  H,BAR1+2           ; за «ЭСК b»
        JZ   mb0
        LXI  H,BAR2
mb0:    MVI  B,0FFh
mb1:    MOV  A,M
        CPI  '-'
        JNZ  mb2
        DCX  H
        MOV  B,M
        INX  H
mb2:    INX  H
        DCR  C
        JNZ  mb1
        MOV  A,B
        RET

; ---------------- мелочи ---------------------------------------------------
mreg:   OUT  MPORT              ; регистр A -- в A
        IN   MPORT
        RET

mdiv:   MVI  C,0FFh             ; A := A / B, портит C
md1:    INR  C
        SUB  B
        JNC  md1
        MOV  A,C
        RET

; ---------------- указатель ------------------------------------------------
mhide:  LDA  mon                ; погасить, если виден
        ORA  A
        RZ
; Вывернуть знакоместо по mpos -- и показать, и погасить. Видеопамять лежит
; под окном ОЗУ, и на время записи окно надо погасить (порт 10h), как это
; делает сама консоль. Но в окне лежит и весь этот код: погаси окно отсюда --
; и процессор пойдёт исполнять видеопамять. Поэтому сама запись (MXCODE)
; копируется в буфер обмена CP/M по 0080 и работает оттуда. Буфер этот CO
; занимает только на время обмена с диском, а опрос мыши идёт, пока CO ждёт
; клавишу, -- копируем при каждом вызове. Стек CO тоже в окне, поэтому, пока
; окно погашено, -- ни PUSH, ни CALL, а прерывания запрещены.
mxor:   LXI  H,mon
        MOV  A,M
        XRI  1
        MOV  M,A
        LXI  H,MXCODE
        LXI  D,MXRUN
        MVI  C,MXLEN
mxc:    MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  C
        JNZ  mxc
        LHLD mpos
        MOV  A,H                ; верхняя линия строки: FFAB - 10r
        ADD  A
        MOV  B,A
        ADD  A
        ADD  A
        ADD  B
        MOV  B,A
        LDA  MSCROLL
        SUB  B
        MOV  B,A
        MOV  A,L                ; точка 3c в масштабе 256
        ADD  A
        ADD  L
        MOV  C,A
        ANI  7
        MOV  H,A
        LXI  D,0E000h           ; маска знака: E000h >> (3c & 7)
mx1:    DCR  H
        JM   mx2
        ORA  A
        MOV  A,D
        RAR
        MOV  D,A
        MOV  A,E
        RAR
        MOV  E,A
        JMP  mx1
mx2:    MOV  A,C                ; столбец байт
        RRC
        RRC
        RRC
        ANI  01Fh
        ADI  0A1h
        MOV  H,A
        MOV  L,B
        MVI  B,10
        JMP  MXRUN

; Сама запись. Собрана на рабочий адрес 0080, лежит здесь. Вход: HL -- байт
; плана A на верхней линии, DE -- маска, B -- десять линий.
MXRUN   EQU 00080h
MXCODE  EQU $
        PHASE MXRUN
        DI
        XRA  A
        OUT  010h
mx3:    MOV  A,M                ; план A -- вниз по линиям
        XRA  D
        MOV  M,A
        INR  H
        MOV  A,M
        XRA  E
        MOV  M,A
        DCR  H
        DCR  L
        DCR  B
        JNZ  mx3
        MOV  A,H
        ADI  020h
        MOV  H,A
        MVI  B,10
mx4:    INR  L                  ; план B -- обратно вверх
        MOV  A,M
        XRA  D
        MOV  M,A
        INR  H
        MOV  A,M
        XRA  E
        MOV  M,A
        DCR  H
        DCR  B
        JNZ  mx4
        MVI  A,023h
        OUT  010h
        EI
        RET
MXLEN   EQU $ - MXRUN
        PHASE MXCODE + MXLEN
