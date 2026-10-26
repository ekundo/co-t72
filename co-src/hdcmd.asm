; ---------------------------------------------------------------------------
; Работа с CO.HDD и команда ОС «9» -- часть накладки списка дискет.
;
; Жила под стеком (co-src/hddsel.asm), переехала в накладку, чтобы освободить
; место мыши (co-src/mouse.asm). Нужна она в трёх местах, и все три -- при
; накладке в буфере копирования: список дискет (hdlist.asm), ввод номера по
; «УС»-«СС»-«7» и пусковое восстановление (co-src/hdinit.asm) -- оно само
; читает накладку, пока CO ещё не заняла буфер.
; ---------------------------------------------------------------------------

; ---------------- при старте: применить сохранённое ------------------------
hdinit0: CALL prmload
        ORA  A
        RZ                      ; ничего не сохранено
        MVI  A,1                ; диск A:
        CALL hdrest
        MVI  A,2                ; диск B:
hdrest: STA  hdrive
        CALL slotptr
        MOV  A,M
        ORA  A
        RZ                      ; длина 0 -- нечего
        LXI  D,pend             ; слот -> набор
        MVI  C,HSLOTL
hdcps:  MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  C
        JNZ  hdcps
        JMP  docmd

; ---------------- команда 9 по набранному номеру ---------------------------
docmd:  LXI  H,HFCB             ; сохранить ФУБ самого CO
        LXI  D,hdsave
        MVI  C,025h
hdsav:  MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  C
        JNZ  hdsav
        LDA  hdrive             ; диск в ФУБ
        STA  HFCB
        LXI  H,HFCB+1           ; имя и тип -- пробелами
        MVI  B,00Bh
        MVI  A,' '
hdclr:  MOV  M,A
        INX  H
        DCR  B
        JNZ  hdclr
        LDA  pend
        MOV  C,A                ; длина набора
        LXI  H,pend
        INX  H
        LXI  D,HFCB+1
hdcp:   MOV  A,M                ; знаки в ФУБ
        STAX D
        INX  H
        INX  D
        DCR  C
        JNZ  hdcp
        LDA  pend
        STA  HBUF               ; длина хвоста командной строки
        MVI  B,0                ; разбор делает DAD B
        MVI  A,9
        CALL HBIOS              ; команда 9
        LXI  H,hdsave           ; вернуть ФУБ CO
        LXI  D,HFCB
        MVI  C,025h
hdrst:  MOV  A,M
        STAX D
        INX  H
        INX  D
        DCR  C
        JNZ  hdrst
        RET

; ---------------- мелочи ---------------------------------------------------
slotptr: LXI H,HSIGN            ; HL -> слот текущего диска
        INX  H
        INX  H                  ; за подписью -- слот A:
        LDA  hdrive
        DCR  A
        RZ
        LXI  D,HSLOTL
        DAD  D                  ; иначе слот B:
        RET

; ---------------- работа с CO.HDD ------------------------------------------
prmopnw: CALL prmopn0           ; открыть или создать
        ORA  A
        JNZ  prmread
        MVI  C,016h
        LXI  D,hdfcb
        CALL HBDOS
        INR  A
        RZ                      ; не вышло -- A=0
        JMP  prmread

prmopen: CALL prmopn0           ; только открыть
        ORA  A
        RZ

prmread: LXI  H,HBUF            ; обнулить буфер
        MVI  B,080h
        XRA  A
hdzap:  MOV  M,A
        INX  H
        DCR  B
        JNZ  hdzap
        MVI  C,01Ah             ; адрес обмена
        LXI  D,HBUF
        CALL HBDOS
        MVI  A,0                ; единственная запись файла
        STA  hdfcbr
        XRA  A
        STA  hdfcbr+1
        STA  hdfcbr+2
        MVI  C,021h             ; чтение по номеру
        LXI  D,hdfcb
        CALL HBDOS
        MVI  A,0FFh             ; ошибку не смотрим: у свежего файла буфер нулевой
        RET

prmopn0: LDA  hdhome            ; A=0, если файла нет
        STA  hdfcb
        MVI  C,00Fh
        LXI  D,hdfcb
        CALL HBDOS
        INR  A
        RZ
        MVI  A,0FFh
        RET

prmload: CALL usr0
        CALL prmload0
        PUSH PSW
        CALL usrback
        POP  PSW
        RET

prmsave: CALL usr0
        CALL prmsave0
        PUSH PSW
        CALL usrback
        POP  PSW
        RET

prmload0: CALL prmopen          ; A=0, если нечего брать
        ORA  A                  ; RZ смотрит флаг, а не A
        RZ
        LDA  HSIGN              ; подпись 'H'
        CPI  'H'
        RNZ
        LXI  H,HSIGN            ; и 'D'
        INX  H
        MOV  A,M
        CPI  'D'
        RNZ
        MVI  A,0FFh
        RET

prmsave0: CALL prmopnw
        ORA  A
        RZ
; Защита от записи -- это свойство, а не помеха: закрыл файл, и выбранные
; дискеты зафиксированы. Признак «только чтение» -- старший бит ПЕРВОГО знака
; типа (fcb+9). Не третьего: туда БДОС ставит «архивный» после каждой записи, и
; проверка по нему запрещала сохранение сразу после первого же раза.
        LDA  hdfcbt
        ANI  080h
        RNZ
        MVI  A,'H'              ; проставить подпись
        STA  HSIGN
        LXI  H,HSIGN
        INX  H
        MVI  M,'D'
        CALL slotptr
        XCHG                    ; DE -> слот
        LXI  H,pend
        MVI  C,HSLOTL
hdcpp:  MOV  A,M                ; набор в слот
        STAX D
        INX  H
        INX  D
        DCR  C
        JNZ  hdcpp
        MVI  C,022h             ; запись по номеру
        LXI  D,hdfcb
        CALL HBDOS
        MVI  C,010h             ; закрыть
        LXI  D,hdfcb
        CALL HBDOS
        RET

; ---------------- данные ---------------------------------------------------
pend:   .ds  5                  ; набранный номер: длина и четыре знака
hdfcb:  .db  0,'CO      '       ; ФУБ на C:CO.HDD
hdfcbt: .db  'HDD'              ; тип: в старшем бите первого знака -- «только чтение»
        .ds  21
hdfcbr: .ds  3                  ; номер записи для чтения и записи по номеру
