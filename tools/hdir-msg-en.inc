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
msgwerr:DB 'Cannot write disk ',0
msgnodq:DB 'No such disk ',0
msgswap:DB 'Exchange disks ',0
msgand: DB ' and ',0
msgeras:DB 'Erase disk ',0
msgyn:  DB '? (Y/N) ',0
msgdone:DB 'Done',0
msgcanc:DB 'Cancelled',0
msgtwo: DB 'An exchange needs the numbers of two disks',0
msgone: DB 'A disk number is needed',0
msgsame:DB 'That is one and the same disk',0
msghalf:DB 'The exchange stopped halfway -- both disks are half rewritten',0
msgtotl:DB 'Disks with labels: ',0
msgask: DB 'Label: ',0
msghelp:DB 'HDIR -- HDD disk directories',CH_VK,0Ah
        DB '  HDIR *.*            directories of every disk',CH_VK,0Ah
        DB '  HDIR 5              disk 5 (hex number, as in command 9)',CH_VK,0Ah
        DB '  HDIR 5-1F 40        disks 5..1F and 40',CH_VK,0Ah
        DB '  HDIR *.COM          search every disk',CH_VK,0Ah
        DB '  HDIR 10-20 DIZ*     search disks 10..20',CH_VK,0Ah
        DB '  HDIR /L             list of labels: number and label',CH_VK,0Ah
        DB '  HDIR /X 5 9         exchange disks 5 and 9',CH_VK,0Ah
        DB '  HDIR /Z 5           erase disk 5 (file data is left alone)',CH_VK,0Ah
        DB '  HDIR /M 5           label of disk 5; asks for the text, CR removes',CH_VK,0Ah
        DB '  HDIR *.* /N         do not stop at every page',CH_VK,0Ah
        DB '  HDIR *.COM >F.TXT   to a file; stops are dropped there anyway',CH_VK,0Ah
        DB 0
