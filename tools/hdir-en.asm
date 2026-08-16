; ---------------------------------------------------------------------------
; HDIR.COM -- HDD "disk" directories and file search across the whole drive.
;
;   HDIR              directories of every disk that has something on it
;   HDIR 5            directory of disk 5
;   HDIR 5-1F 40      disks 5..1F and disk 40
;   HDIR *.COM        search every disk
;   HDIR 10-20 DIZ*   search disks 10..20
;   HDIR /N           do not stop at every page
;   HDIR ?            help
;
; Disk numbers are hexadecimal -- the same as in MicroDOS command "9" and in
; CO's SS+7. A word telling a pattern from a number by sight: one with ".",
; "*" or "?" is a pattern, anything else is a number. Patterns work as usual
; in MicroDOS: "*" fills the rest of the field with "?", "?" matches any
; character. With no dot the extension matches anything.
;
; When the output is redirected to a file (`HDIR *.COM >LIST.TXT`), the page
; stops are dropped by themselves.
;
; English build: the code is shared, only the message set differs. The Russian
; one is hdir.asm.
;
;   python3 asm8080.py hdir-en.asm -o HDIR.COM
; ---------------------------------------------------------------------------

        INCLUDE 'hdir-code.inc'
        INCLUDE 'hdir-msg-en.inc'
        INCLUDE 'hdir-data.inc'
