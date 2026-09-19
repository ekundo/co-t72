; VDE 2.67b (c)1988 Eric Meyer -- сборка под МикроДОС T-72 на Векторе-06Ц.
;
; Это верхний файл сборки: определения из авторского VDE.ASM, переведённые
; модули и заместители команд Z80. Сам перевод лежит в work/vde/gen и в
; репозиторий не входит -- его делает vde/z80to8080.py из авторского исходника,
; который добывает vde/fetch-src.sh.
;
; Порядок не случаен: заместители вставлены между вторым и третьим модулем.
; Раньше нельзя -- адреса 0100h-047Fh заняты областями настройки, позже тоже:
; в конце третьего модуля идёт сегмент данных, стек и начало текстового буфера.

VDM	EQU	0		; вариант для терминала, а не для экранной памяти
;
CR	EQU	0DH
LF	EQU	0AH
FF	EQU	0CH
BS	EQU	08H
TAB	EQU	09H
ESC	EQU	1BH
DEL	EQU	7FH
BEL	EQU	07H
EOF	EQU	1AH
X	EQU	80H		; старший бит
;
; Буфер дисковода T-72. В ячейке 0006 система его не учитывает и обещает C000,
; поэтому потолок текста приходится опускать сюда вручную -- см. overrides.asm.
T72BUF	EQU	0BC00H
;
; Ячейка монитора со сдвигом экрана: её же он выводит в порт 3 по прерыванию.
; Назначение ячеек FFA8-FFFF в МикроДОС объявлено сохранённым.
zFFAB	EQU	0FFABH
;
BDOSep	EQU	0005H		; МикроДОС -- как CP/M
FCB	EQU	005CH
FCB2	EQU	006CH
DMA	EQU	0080H
LSTO	EQU	5
UCON	EQU	6
CPMV	EQU	12
RSTD	EQU	13
SELD	EQU	14
FOPN	EQU	15
FCLO	EQU	16
SRCH	EQU	17
SRCN	EQU	18
FDEL	EQU	19
RSEQ	EQU	20
WSEQ	EQU	21
FMAK	EQU	22
FREN	EQU	23
GDRV	EQU	25
SDMA	EQU	26
USRN	EQU	32
RSTV	EQU	37
ERRM	EQU	45
;
	INCLUDE	vdx1.a80	; ядро
	INCLUDE	vdx2.a80	; функции
	INCLUDE	runtime.a80	; заместители команд Z80
	INCLUDE	vdx3.a80	; печать, экран, данные
;
	END
