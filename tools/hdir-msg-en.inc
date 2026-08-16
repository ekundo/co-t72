; ------------------------- сообщения, английские ---------------------------
;
; Английский набор: тот же код, другие строки. Здесь всё в ASCII -- знаков КОИ-8
; нет, так что текст читается и на машине с латинским знакогенератором.
;
; Строка msgclr затирает подсказку msgmore, поэтому пробелов в ней должно быть
; ровно столько же, сколько знаков в подсказке, -- иначе на экране остаётся хвост.

msghd:  DB 'HDD: ',0
msgx:   DB 'x',0
msgdsk: DB ', disks ',0
msgpar: DB ' (',0
msgpar2:DB 'h)',0
msgdisk:DB 'Disk ',0
msgfil: DB '  files ',0
msgfree:DB '  free ',0
msgk:   DB 'K',0
msgtot: DB 'Total: ',0
msgtot2:DB ' file(s) on ',0
msgtot3:DB ' disk(s)',0
msgerr: DB 'Cannot read disk ',0
msgnohd:DB 'HDD does not answer',0
msgnodk:DB 'No disks on the HDD',0
msgmore:DB 'Press a key, Esc to stop',0
msgclr: DB '                        ',0
msghelp:DB 'HDIR -- HDD disk directories',CH_VK,0Ah
        DB '  HDIR            every disk',CH_VK,0Ah
        DB '  HDIR 5          disk 5 (hex number, as in command 9)',CH_VK,0Ah
        DB '  HDIR 5-1F 40    disks 5..1F and 40',CH_VK,0Ah
        DB '  HDIR *.COM      search every disk',CH_VK,0Ah
        DB '  HDIR 10-20 DIZ* search disks 10..20',CH_VK,0Ah
        DB '  /N              do not stop at every page',CH_VK,0Ah
        DB '  HDIR *.COM >F.TXT   to a file; stops are dropped there anyway',CH_VK,0Ah
        DB 0
