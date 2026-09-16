; ---------------------------------------------------------------------------
; CO v2.0 -- файловый менеджер для ПК "Вектор-06Ц".
; Шишатский С.М., Харьков, 1993. Писался под T-34.
;
; Это исходник, а не листинг: собирается ассемблером tools/asm8080.py и даёт
; ровно тот же образ, что и подлинный co.com, -- сверка одной командой:
;
;     ./check-src.sh co-src/co.asm work/co/co.com
;
; Получен разбором образа по карте исполнения, снятой прогоном CO по сценариям
; в эмуляторе (см. check-funcs.sh): где карта говорит "тут исполнялось" --
; разобрано как команды, остальное осталось байтами. Поэтому часть .db -- это
; не данные, а код, до которого сценарии не дошли; по мере роста покрытия такие
; места можно разбирать дальше, но правится файл теперь руками, а не заново
; генерируется.
;
; Правки, которые раньше делались скриптами из tools/, переезжают сюда по одной.
; Мерка при переносе одна: собранный CO.COM не должен измениться ни на байт.
; ---------------------------------------------------------------------------

         ORG  0100h

L_0100:  JMP  L_406A              ; 0100 c3 6a 40
         .db 0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh ; 0103 |................|
         .db 0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh ; 0113 |................|
         .db 0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,9Ah ; 0123 |................|
         .db 0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh ; 0133 |................|
         .db 0EEh,0A0h,0A1h,0E6h,0A4h,0A5h,0E4h,0A3h,0E5h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh ; 0143 |................|
         .db 0AFh,0EFh,0E0h,0E1h,0E2h,0E3h,0A6h,0A2h,0ECh,0EBh,0A7h,0E8h,0EDh,0E9h,0E7h,0EAh ; 0153 |................|
         .db 9Eh,80h,81h,96h,84h,85h,94h,83h,95h,88h,89h,8Ah,8Bh,8Ch,8Dh,8Eh ; 0163 |................|
         .db 8Fh,9Fh,90h,91h,92h,93h,86h,82h,9Ch,9Bh,87h,98h,9Dh,99h,97h,0FFh ; 0173 |................|
L_0183:  .db 00h                                              ; 0183 |.|
L_0184:  .db 00h,7Eh,0FEh,02h,0CAh,0BDh,0E2h,47h,54h,5Dh,23h,23h,4Eh,23h,23h ; 0184 |.~.....GT]##N##|
L_0193:  MOV  A,M                 ; 0193 7e
L_0194:  CPI  08h                 ; 0194 fe 08
         JNZ  L_0204              ; 0196 c2 04 02
L_0199:  MOV  A,B                 ; 0199 78
L_019A:  STA  L_0236              ; 019A 32 36 02
L_019D:  MOV  A,C                 ; 019D 79
         STA  L_0235              ; 019E 32 35 02
L_01A1:  INX  H                   ; 01A1 23
         MOV  A,M                 ; 01A2 7e
L_01A3:  CPI  21h                 ; 01A3 fe 21
         JNC  L_0204              ; 01A5 d2 04 02
L_01A8:  PUSH H                   ; 01A8 e5
L_01A9:  LXI  H,0183h             ; 01A9 21 83 01
         DCR  B                   ; 01AC 05
         JNZ  L_01B1              ; 01AD c2 b1 01
         INX  H                   ; 01B0 23
L_01B1:  MOV  A,M                 ; 01B1 7e
         ANA  A                   ; 01B2 a7
         CZ   L_02A3              ; 01B3 cc a3 02
         POP  H                   ; 01B6 e1
L_01B7:  DI                       ; 01B7 f3
L_01B8:  MOV  A,M                 ; 01B8 7e
         INX  H                   ; 01B9 23
         MOV  E,M                 ; 01BA 5e
         INX  H                   ; 01BB 23
L_01BC:  MOV  D,M                 ; 01BC 56
         STC                      ; 01BD 37
         CMC                      ; 01BE 3f
L_01BF:  RAR                      ; 01BF 1f
         MOV  B,A                 ; 01C0 47
L_01C1:  MVI  A,00h               ; 01C1 3e 00
         RAR                      ; 01C3 1f
         MOV  C,A                 ; 01C4 4f
         LXI  H,3F80h             ; 01C5 21 80 3f
L_01C8:  DAD  B                   ; 01C8 09
         LDA  L_0236              ; 01C9 3a 36 02
         DCR  A                   ; 01CC 3d
         JZ   L_01D4              ; 01CD ca d4 01
L_01D0:  LXI  B,1000h             ; 01D0 01 00 10
         DAD  B                   ; 01D3 09
L_01D4:  LDA  L_0235              ; 01D4 3a 35 02
         CPI  06h                 ; 01D7 fe 06
         XCHG                     ; 01D9 eb
         JNZ  L_0208              ; 01DA c2 08 02
         SHLD 01E8h               ; 01DD 22 e8 01
         LXI  H,0000h             ; 01E0 21 00 00
         DAD  SP                  ; 01E3 39
         SHLD L_0200              ; 01E4 22 00 02
         LXI  SP,0000h            ; 01E7 31 00 00
         XCHG                     ; 01EA eb
         MOV  A,L                 ; 01EB 7d
         INR  A                   ; 01EC 3c
         MVI  A,0F2h              ; 01ED 3e f2
         JP   L_01F4              ; 01EF f2 f4 01
         MVI  A,0FAh              ; 01F2 3e fa
L_01F4:  STA  L_01FC              ; 01F4 32 fc 01
L_01F7:  POP  D                   ; 01F7 d1
         MOV  M,E                 ; 01F8 73
         INR  L                   ; 01F9 2c
         MOV  M,D                 ; 01FA 72
         INR  L                   ; 01FB 2c
L_01FC:  JMP  L_01F7              ; 01FC c3 f7 01
         .db 31h                                              ; 01FF |1|
L_0200:  .db 00h,00h,0AFh,0C8h                                ; 0200 |....|
L_0204:  XCHG                     ; 0204 eb
L_0205:  JMP  0E2BDh              ; 0205 c3 bd e2
L_0208:  LXI  B,0080h             ; 0208 01 80 00
L_020B:  DAD  B                   ; 020B 09
L_020C:  SHLD 0217h               ; 020C 22 17 02
L_020F:  LXI  H,0000h             ; 020F 21 00 00
L_0212:  DAD  SP                  ; 0212 39
L_0213:  SHLD 0231h               ; 0213 22 31 02
L_0216:  LXI  SP,0000h            ; 0216 31 00 00
L_0219:  XCHG                     ; 0219 eb
L_021A:  DAD  B                   ; 021A 09
L_021B:  MOV  A,L                 ; 021B 7d
L_021C:  DCR  A                   ; 021C 3d
L_021D:  MVI  A,0F2h              ; 021D 3e f2
L_021F:  JP   L_0224              ; 021F f2 24 02
L_0222:  MVI  A,0FAh              ; 0222 3e fa
L_0224:  STA  L_022D              ; 0224 32 2d 02
L_0227:  DCX  H                   ; 0227 2b
L_0228:  MOV  D,M                 ; 0228 56
L_0229:  DCR  L                   ; 0229 2d
L_022A:  MOV  E,M                 ; 022A 5e
L_022B:  DCR  L                   ; 022B 2d
L_022C:  PUSH D                   ; 022C d5
L_022D:  JMP  L_0228              ; 022D c3 28 02
L_0230:  LXI  SP,0000h            ; 0230 31 00 00
L_0233:  XRA  A                   ; 0233 af
L_0234:  RZ                       ; 0234 c8
L_0235:  NOP                      ; 0235 00
L_0236:  NOP                      ; 0236 00
         ADD  B                   ; 0237 80
L_0238:  INR  B                   ; 0238 04
         LXI  B,0108h             ; 0239 01 08 01
L_023C:  NOP                      ; 023C 00
         NOP                      ; 023D 00
         NOP                      ; 023E 00
         NOP                      ; 023F 00
         NOP                      ; 0240 00
         NOP                      ; 0241 00
L_0242:  LXI  H,3E91h             ; 0242 21 91 3e
L_0245:  CALL L_0E4D              ; 0245 cd 4d 0e
L_0248:  MOV  A,M                 ; 0248 7e
L_0249:  SUI  41h                 ; 0249 d6 41
L_024B:  JZ   L_0252              ; 024B ca 52 02
L_024E:  XRA  A                   ; 024E af
L_024F:  STA  L_0183              ; 024F 32 83 01
L_0252:  MOV  A,M                 ; 0252 7e
L_0253:  CPI  42h                 ; 0253 fe 42
L_0255:  RZ                       ; 0255 c8
L_0256:  XRA  A                   ; 0256 af
L_0257:  STA  L_0184              ; 0257 32 84 01
L_025A:  RET                      ; 025A c9
L_025B:  LXI  H,3E91h             ; 025B 21 91 3e
L_025E:  CALL L_0E4D              ; 025E cd 4d 0e
L_0261:  MOV  A,M                 ; 0261 7e
L_0262:  CPI  43h                 ; 0262 fe 43
L_0264:  RZ                       ; 0264 c8
L_0265:  SUI  41h                 ; 0265 d6 41
L_0267:  JNZ  L_026E              ; 0267 c2 6e 02
L_026A:  STA  L_0183              ; 026A 32 83 01
L_026D:  RET                      ; 026D c9
L_026E:  XRA  A                   ; 026E af
L_026F:  STA  L_0184              ; 026F 32 84 01
L_0272:  RET                      ; 0272 c9
L_0273:  LXI  H,3E91h             ; 0273 21 91 3e
L_0276:  CALL L_0E4D              ; 0276 cd 4d 0e
L_0279:  MOV  A,M                 ; 0279 7e
L_027A:  CPI  43h                 ; 027A fe 43
L_027C:  RZ                       ; 027C c8
L_027D:  SUI  41h                 ; 027D d6 41
L_027F:  STA  L_0236              ; 027F 32 36 02
L_0282:  CALL L_028D              ; 0282 cd 8d 02
L_0285:  MVI  A,06h               ; 0285 3e 06
L_0287:  STA  L_0238              ; 0287 32 38 02
L_028A:  CALL L_02B5              ; 028A cd b5 02
L_028D:  MVI  A,09h               ; 028D 3e 09
L_028F:  STA  023Bh               ; 028F 32 3b 02
L_0292:  LXI  H,0080h             ; 0292 21 80 00
L_0295:  SHLD L_023C              ; 0295 22 3c 02
L_0298:  MVI  A,04h               ; 0298 3e 04
L_029A:  STA  L_0238              ; 029A 32 38 02
L_029D:  LXI  H,0236h             ; 029D 21 36 02
L_02A0:  JMP  L_02F1              ; 02A0 c3 f1 02
L_02A3:  MVI  A,04h               ; 02A3 3e 04
L_02A5:  STA  L_0238              ; 02A5 32 38 02
L_02A8:  LXI  H,0183h             ; 02A8 21 83 01
L_02AB:  LDA  L_0236              ; 02AB 3a 36 02
L_02AE:  DCR  A                   ; 02AE 3d
L_02AF:  JNZ  L_02B3              ; 02AF c2 b3 02
L_02B2:  INX  H                   ; 02B2 23
L_02B3:  MVI  M,59h               ; 02B3 36 59
L_02B5:  PUSH B                   ; 02B5 c5
L_02B6:  PUSH D                   ; 02B6 d5
L_02B7:  PUSH H                   ; 02B7 e5
L_02B8:  MVI  A,01h               ; 02B8 3e 01
L_02BA:  STA  023Bh               ; 02BA 32 3b 02
L_02BD:  LXI  D,0000h             ; 02BD 11 00 00
L_02C0:  LDA  L_0236              ; 02C0 3a 36 02
L_02C3:  DCR  A                   ; 02C3 3d
L_02C4:  JZ   L_02CA              ; 02C4 ca ca 02
L_02C7:  LXI  D,1000h             ; 02C7 11 00 10
L_02CA:  LXI  H,4000h             ; 02CA 21 00 40
L_02CD:  DAD  D                   ; 02CD 19
L_02CE:  SHLD L_023C              ; 02CE 22 3c 02
L_02D1:  LXI  H,0236h             ; 02D1 21 36 02
L_02D4:  CALL L_02F1              ; 02D4 cd f1 02
L_02D7:  LHLD L_023C              ; 02D7 2a 3c 02
L_02DA:  LXI  D,0080h             ; 02DA 11 80 00
L_02DD:  DAD  D                   ; 02DD 19
L_02DE:  SHLD L_023C              ; 02DE 22 3c 02
L_02E1:  LDA  023Bh               ; 02E1 3a 3b 02
L_02E4:  INR  A                   ; 02E4 3c
L_02E5:  STA  023Bh               ; 02E5 32 3b 02
L_02E8:  CPI  21h                 ; 02E8 fe 21
L_02EA:  JNZ  L_02D1              ; 02EA c2 d1 02
L_02ED:  POP  H                   ; 02ED e1
L_02EE:  POP  D                   ; 02EE d1
L_02EF:  POP  B                   ; 02EF c1
L_02F0:  RET                      ; 02F0 c9
L_02F1:  MVI  C,03h               ; 02F1 0e 03
L_02F3:  PUSH B                   ; 02F3 c5
L_02F4:  PUSH H                   ; 02F4 e5
L_02F5:  CALL 0E2BDh              ; 02F5 cd bd e2
L_02F8:  POP  H                   ; 02F8 e1
L_02F9:  POP  B                   ; 02F9 c1
L_02FA:  ORA  A                   ; 02FA b7
L_02FB:  RZ                       ; 02FB c8
L_02FC:  DCR  C                   ; 02FC 0d
L_02FD:  JNZ  L_02F3              ; 02FD c2 f3 02
         LDA  L_0236              ; 0300 3a 36 02
         MOV  C,A                 ; 0303 4f
         MVI  B,00h               ; 0304 06 00
         LXI  H,0183h             ; 0306 21 83 01
         DAD  H                   ; 0309 29
         XRA  A                   ; 030A af
         MOV  M,A                 ; 030B 77
         JMP  0F809h              ; 030C c3 09 f8
L_030F:  CALL L_0583              ; 030F cd 83 05
L_0312:  JMP  L_030F              ; 0312 c3 0f 03
L_0315:  CALL L_082D              ; 0315 cd 2d 08
L_0318:  CALL L_0FF3              ; 0318 cd f3 0f
L_031B:  CALL L_04C1              ; 031B cd c1 04
L_031E:  CALL L_20CA              ; 031E cd ca 20
L_0321:  LXI  H,0B689h            ; 0321 21 89 b6
L_0324:  CALL L_0E47              ; 0324 cd 47 0e
L_0327:  MOV  C,M                 ; 0327 4e
L_0328:  LHLD 0A842h              ; 0328 2a 42 a8
L_032B:  POP  D                   ; 032B d1
L_032C:  MOV  B,C                 ; 032C 41
L_032D:  MOV  A,E                 ; 032D 7b
L_032E:  DCR  A                   ; 032E 3d
L_032F:  LXI  D,000Dh             ; 032F 11 0d 00
L_0332:  CMP  M                   ; 0332 be
L_0333:  JC   L_033B              ; 0333 da 3b 03
L_0336:  DAD  D                   ; 0336 19
L_0337:  DCR  C                   ; 0337 0d
L_0338:  JNZ  L_0332              ; 0338 c2 32 03
L_033B:  MOV  A,B                 ; 033B 78
L_033C:  SUB  C                   ; 033C 91
L_033D:  INR  A                   ; 033D 3c
L_033E:  STA  0B69Bh              ; 033E 32 9b b6
L_0341:  JMP  L_0890              ; 0341 c3 90 08
L_0344:  CALL L_20CA              ; 0344 cd ca 20
L_0347:  LXI  B,2080h             ; 0347 01 80 20
L_034A:  LXI  D,0008h             ; 034A 11 08 00
L_034D:  DAD  D                   ; 034D 19
L_034E:  LXI  D,000Dh             ; 034E 11 0d 00
L_0351:  MOV  M,B                 ; 0351 70
L_0352:  DAD  D                   ; 0352 19
L_0353:  DCR  C                   ; 0353 0d
L_0354:  JNZ  L_0351              ; 0354 c2 51 03
L_0357:  LXI  H,0A943h            ; 0357 21 43 a9
L_035A:  CALL L_0E47              ; 035A cd 47 0e
L_035D:  MVI  M,00h               ; 035D 36 00
L_035F:  LXI  H,0A947h            ; 035F 21 47 a9
L_0362:  CALL L_0E47              ; 0362 cd 47 0e
L_0365:  MVI  M,00h               ; 0365 36 00
L_0367:  INX  H                   ; 0367 23
L_0368:  MVI  M,00h               ; 0368 36 00
L_036A:  JMP  L_090F              ; 036A c3 0f 09
L_036D:  LDA  0A801h              ; 036D 3a 01 a8
L_0370:  ANI  20h                 ; 0370 e6 20
L_0372:  JZ   L_05BF              ; 0372 ca bf 05
L_0375:  LDA  L_082B              ; 0375 3a 2b 08
L_0378:  ANA  A                   ; 0378 a7
L_0379:  RNZ                      ; 0379 c0
L_037A:  LHLD L_1F7D              ; 037A 2a 7d 1f
L_037D:  PUSH H                   ; 037D e5
L_037E:  LXI  H,0000h             ; 037E 21 00 00
L_0381:  CALL L_04A6              ; 0381 cd a6 04
L_0384:  HLT                      ; 0384 76
L_0385:  MVI  C,19h               ; 0385 0e 19
L_0387:  RST  4                   ; 0387 e7
L_0388:  DI                       ; 0388 f3
L_0389:  LDA  0A803h              ; 0389 3a 03 a8
L_038C:  STA  0FFABh              ; 038C 32 ab ff
L_038F:  CALL L_03B8              ; 038F cd b8 03
L_0392:  POP  H                   ; 0392 e1
L_0393:  PUSH H                   ; 0393 e5
L_0394:  CALL L_04A6              ; 0394 cd a6 04
L_0397:  MVI  C,0Bh               ; 0397 0e 0b
L_0399:  RST  4                   ; 0399 e7
L_039A:  CALL L_04C1              ; 039A cd c1 04
L_039D:  POP  H                   ; 039D e1
L_039E:  LXI  H,0000h             ; 039E 21 00 00
L_03A1:  CALL L_04A6              ; 03A1 cd a6 04
L_03A4:  HLT                      ; 03A4 76
L_03A5:  MVI  C,1Ah               ; 03A5 0e 1a
L_03A7:  RST  4                   ; 03A7 e7
L_03A8:  DI                       ; 03A8 f3
L_03A9:  MVI  A,0FFh              ; 03A9 3e ff
L_03AB:  STA  0FFABh              ; 03AB 32 ab ff
L_03AE:  CALL L_03B8              ; 03AE cd b8 03
L_03B1:  POP  H                   ; 03B1 e1
L_03B2:  CALL L_04A6              ; 03B2 cd a6 04
L_03B5:  JMP  L_0FF3              ; 03B5 c3 f3 0f
L_03B8:  XRA  A                   ; 03B8 af
L_03B9:  OUT  10h                 ; 03B9 d3 10
L_03BB:  LXI  H,9EFFh             ; 03BB 21 ff 9e
L_03BE:  LXI  D,0DEFFh            ; 03BE 11 ff de
L_03C1:  MVI  C,3Eh               ; 03C1 0e 3e
L_03C3:  LDAX D                   ; 03C3 1a
L_03C4:  MOV  B,A                 ; 03C4 47
L_03C5:  MOV  A,M                 ; 03C5 7e
L_03C6:  STAX D                   ; 03C6 12
L_03C7:  MOV  M,B                 ; 03C7 70
L_03C8:  DCX  D                   ; 03C8 1b
L_03C9:  DCR  L                   ; 03C9 2d
L_03CA:  JNZ  L_03C3              ; 03CA c2 c3 03
L_03CD:  LDAX D                   ; 03CD 1a
L_03CE:  MOV  B,A                 ; 03CE 47
L_03CF:  MOV  A,M                 ; 03CF 7e
L_03D0:  STAX D                   ; 03D0 12
L_03D1:  MOV  M,B                 ; 03D1 70
L_03D2:  DCX  D                   ; 03D2 1b
L_03D3:  DCX  H                   ; 03D3 2b
L_03D4:  DCR  C                   ; 03D4 0d
L_03D5:  JNZ  L_03C3              ; 03D5 c2 c3 03
L_03D8:  MVI  A,23h               ; 03D8 3e 23
L_03DA:  OUT  10h                 ; 03DA d3 10
L_03DC:  EI                       ; 03DC fb
L_03DD:  RET                      ; 03DD c9
L_03DE:  LDA  0FFABh              ; 03DE 3a ab ff
L_03E1:  STA  0A803h              ; 03E1 32 03 a8
L_03E4:  MVI  C,08h               ; 03E4 0e 08
L_03E6:  RST  4                   ; 03E6 e7
L_03E7:  LXI  H,0A000h            ; 03E7 21 00 a0
L_03EA:  LXI  D,0DFFFh            ; 03EA 11 ff df
L_03ED:  MVI  C,3Fh               ; 03ED 0e 3f
L_03EF:  DI                       ; 03EF f3
L_03F0:  PUSH H                   ; 03F0 e5
L_03F1:  LXI  H,0000h             ; 03F1 21 00 00
L_03F4:  DAD  SP                  ; 03F4 39
L_03F5:  SHLD 00F0h               ; 03F5 22 f0 00
L_03F8:  POP  H                   ; 03F8 e1
L_03F9:  XRA  A                   ; 03F9 af
L_03FA:  OUT  10h                 ; 03FA d3 10
L_03FC:  SPHL                     ; 03FC f9
L_03FD:  XCHG                     ; 03FD eb
L_03FE:  MOV  D,M                 ; 03FE 56
L_03FF:  DCR  L                   ; 03FF 2d
L_0400:  MOV  E,M                 ; 0400 5e
L_0401:  DCX  H                   ; 0401 2b
L_0402:  PUSH D                   ; 0402 d5
L_0403:  JNZ  L_03FE              ; 0403 c2 fe 03
L_0406:  DCR  C                   ; 0406 0d
L_0407:  JNZ  L_03FE              ; 0407 c2 fe 03
L_040A:  MVI  A,23h               ; 040A 3e 23
L_040C:  OUT  10h                 ; 040C d3 10
L_040E:  LHLD 00F0h               ; 040E 2a f0 00
L_0411:  SPHL                     ; 0411 f9
L_0412:  POP  H                   ; 0412 e1
L_0413:  EI                       ; 0413 fb
L_0414:  RET                      ; 0414 c9
L_0415:  LDA  0B69Dh              ; 0415 3a 9d b6
L_0418:  DCR  A                   ; 0418 3d
L_0419:  JZ   L_0444              ; 0419 ca 44 04
L_041C:  DCR  A                   ; 041C 3d
L_041D:  JZ   L_042E              ; 041D ca 2e 04
L_0420:  LXI  H,0E000h            ; 0420 21 00 e0
L_0423:  LXI  D,9FFFh             ; 0423 11 ff 9f
L_0426:  MVI  C,3Fh               ; 0426 0e 3f
L_0428:  CALL L_03EF              ; 0428 cd ef 03
L_042B:  JMP  L_2833              ; 042B c3 33 28
L_042E:  LXI  H,0D000h            ; 042E 21 00 d0
L_0431:  LXI  D,8FFFh             ; 0431 11 ff 8f
L_0434:  MVI  C,0Fh               ; 0434 0e 0f
L_0436:  CALL L_03EF              ; 0436 cd ef 03
L_0439:  LXI  H,0B000h            ; 0439 21 00 b0
L_043C:  LXI  D,6FFFh             ; 043C 11 ff 6f
L_043F:  MVI  C,0Fh               ; 043F 0e 0f
L_0441:  JMP  L_03EF              ; 0441 c3 ef 03
L_0444:  LXI  H,0E000h            ; 0444 21 00 e0
L_0447:  LXI  D,9FFFh             ; 0447 11 ff 9f
L_044A:  MVI  C,10h               ; 044A 0e 10
L_044C:  CALL L_03EF              ; 044C cd ef 03
L_044F:  LXI  H,0C000h            ; 044F 21 00 c0
L_0452:  LXI  D,7FFFh             ; 0452 11 ff 7f
L_0455:  MVI  C,10h               ; 0455 0e 10
L_0457:  JMP  L_0428              ; 0457 c3 28 04
L_045A:  CALL L_082D              ; 045A cd 2d 08
L_045D:  LXI  H,0B69Bh            ; 045D 21 9b b6
L_0460:  INR  M                   ; 0460 34
L_0461:  JMP  L_0890              ; 0461 c3 90 08
L_0464:  CALL L_082D              ; 0464 cd 2d 08
L_0467:  LDA  0B69Bh              ; 0467 3a 9b b6
L_046A:  SUI  15h                 ; 046A d6 15
L_046C:  JNC  L_0470              ; 046C d2 70 04
L_046F:  XRA  A                   ; 046F af
L_0470:  INR  A                   ; 0470 3c
L_0471:  STA  0B69Bh              ; 0471 32 9b b6
L_0474:  JMP  L_0890              ; 0474 c3 90 08
L_0477:  CALL L_082D              ; 0477 cd 2d 08
L_047A:  LXI  H,0B69Bh            ; 047A 21 9b b6
L_047D:  DCR  M                   ; 047D 35
L_047E:  JNZ  L_0890              ; 047E c2 90 08
L_0481:  INR  M                   ; 0481 34
L_0482:  JMP  L_0890              ; 0482 c3 90 08
L_0485:  CALL L_082D              ; 0485 cd 2d 08
L_0488:  LXI  H,0B69Bh            ; 0488 21 9b b6
L_048B:  MVI  A,14h               ; 048B 3e 14
L_048D:  ADD  M                   ; 048D 86
L_048E:  MOV  M,A                 ; 048E 77
L_048F:  JMP  L_0890              ; 048F c3 90 08
L_0492:  LXI  H,0622h             ; 0492 21 22 06
L_0495:  JMP  L_0562              ; 0495 c3 62 05
L_0498:  LHLD L_1F7D              ; 0498 2a 7d 1f
L_049B:  PUSH H                   ; 049B e5
L_049C:  LXI  H,0000h             ; 049C 21 00 00
L_049F:  CALL L_04A6              ; 049F cd a6 04
L_04A2:  CALL 0F803h              ; 04A2 cd 03 f8
L_04A5:  POP  H                   ; 04A5 e1
L_04A6:  PUSH PSW                 ; 04A6 f5
L_04A7:  SHLD L_1F7D              ; 04A7 22 7d 1f
L_04AA:  CALL L_151F              ; 04AA cd 1f 15
L_04AD:  POP  PSW                 ; 04AD f1
L_04AE:  RET                      ; 04AE c9
L_04AF:  LDA  L_082C              ; 04AF 3a 2c 08
L_04B2:  ANA  A                   ; 04B2 a7
L_04B3:  JNZ  L_04F4              ; 04B3 c2 f4 04
L_04B6:  CALL L_0F9A              ; 04B6 cd 9a 0f
L_04B9:  MVI  A,35h               ; 04B9 3e 35
L_04BB:  STA  L_082C              ; 04BB 32 2c 08
L_04BE:  JMP  L_04F4              ; 04BE c3 f4 04
L_04C1:  LDA  L_1F7F              ; 04C1 3a 7f 1f
L_04C4:  CPI  00h                 ; 04C4 fe 00
L_04C6:  JZ   L_0536              ; 04C6 ca 36 05
L_04C9:  LHLD 0FFBFh              ; 04C9 2a bf ff
L_04CC:  PUSH H                   ; 04CC e5
L_04CD:  MOV  D,A                 ; 04CD 57
L_04CE:  MVI  B,0FFh              ; 04CE 06 ff
L_04D0:  MVI  C,0FFh              ; 04D0 0e ff
L_04D2:  IN   01h                 ; 04D2 db 01
L_04D4:  STA  0A801h              ; 04D4 32 01 a8
L_04D7:  LDA  0A800h              ; 04D7 3a 00 a8
L_04DA:  DCR  A                   ; 04DA 3d
L_04DB:  JNZ  L_04F4              ; 04DB c2 f4 04
L_04DE:  LDA  0A801h              ; 04DE 3a 01 a8
L_04E1:  ANI  20h                 ; 04E1 e6 20
L_04E3:  JNZ  L_04AF              ; 04E3 c2 af 04
L_04E6:  LDA  0B68Fh              ; 04E6 3a 8f b6
L_04E9:  DCR  A                   ; 04E9 3d
L_04EA:  JNZ  L_04F4              ; 04EA c2 f4 04
L_04ED:  CALL L_0F9A              ; 04ED cd 9a 0f
L_04F0:  XRA  A                   ; 04F0 af
L_04F1:  STA  L_082C              ; 04F1 32 2c 08
L_04F4:  CALL 0F81Bh              ; 04F4 cd 1b f8
L_04F7:  CPI  0FFh                ; 04F7 fe ff
L_04F9:  JNZ  L_0522              ; 04F9 c2 22 05
L_04FC:  DCR  C                   ; 04FC 0d
L_04FD:  JNZ  L_04D2              ; 04FD c2 d2 04
L_0500:  DCR  B                   ; 0500 05
L_0501:  JNZ  L_04D0              ; 0501 c2 d0 04
L_0504:  DCR  D                   ; 0504 15
L_0505:  JNZ  L_04CE              ; 0505 c2 ce 04
         LXI  H,0000h             ; 0508 21 00 00
         CALL L_04A6              ; 050B cd a6 04
L_050E:  CALL 0F81Bh              ; 050E cd 1b f8
         CPI  0FFh                ; 0511 fe ff
         JZ   L_050E              ; 0513 ca 0e 05
         POP  H                   ; 0516 e1
         CALL L_04A6              ; 0517 cd a6 04
         MVI  C,06h               ; 051A 0e 06
         MVI  E,0FFh              ; 051C 1e ff
         RST  1                   ; 051E cf
         JMP  L_04C1              ; 051F c3 c1 04
L_0522:  POP  H                   ; 0522 e1
L_0523:  CALL L_04A6              ; 0523 cd a6 04
L_0526:  POP  H                   ; 0526 e1
L_0527:  MOV  C,A                 ; 0527 4f
L_0528:  MVI  B,00h               ; 0528 06 00
L_052A:  PUSH B                   ; 052A c5
L_052B:  PUSH H                   ; 052B e5
L_052C:  MVI  C,06h               ; 052C 0e 06
L_052E:  MVI  E,0FFh              ; 052E 1e ff
L_0530:  RST  1                   ; 0530 cf
L_0531:  ORA  A                   ; 0531 b7
L_0532:  JNZ  L_052C              ; 0532 c2 2c 05
L_0535:  RET                      ; 0535 c9
L_0536:  CALL 0F803h              ; 0536 cd 03 f8
         JMP  L_0526              ; 0539 c3 26 05
L_053C:  LXI  H,0B681h            ; 053C 21 81 b6
L_053F:  CALL L_0E47              ; 053F cd 47 0e
L_0542:  XRA  A                   ; 0542 af
L_0543:  MOV  M,A                 ; 0543 77
L_0544:  INR  A                   ; 0544 3c
L_0545:  STA  0B69Bh              ; 0545 32 9b b6
L_0548:  LXI  H,3E93h             ; 0548 21 93 3e
L_054B:  CALL L_0E4D              ; 054B cd 4d 0e
L_054E:  MVI  C,4Bh               ; 054E 0e 4b
L_0550:  MOV  A,M                 ; 0550 7e
L_0551:  CPI  50h                 ; 0551 fe 50
L_0553:  JZ   L_0558              ; 0553 ca 58 05
L_0556:  MVI  C,50h               ; 0556 0e 50
L_0558:  MOV  M,C                 ; 0558 71
L_0559:  CALL L_091E              ; 0559 cd 1e 09
L_055C:  CALL L_0CD9              ; 055C cd d9 0c
L_055F:  JMP  L_0FE0              ; 055F c3 e0 0f
L_0562:  MOV  C,M                 ; 0562 4e
L_0563:  INX  H                   ; 0563 23
L_0564:  CMP  M                   ; 0564 be
L_0565:  JZ   L_056E              ; 0565 ca 6e 05
L_0568:  INX  H                   ; 0568 23
L_0569:  INX  H                   ; 0569 23
L_056A:  DCR  C                   ; 056A 0d
L_056B:  JNZ  L_0563              ; 056B c2 63 05
L_056E:  INX  H                   ; 056E 23
L_056F:  MOV  E,M                 ; 056F 5e
L_0570:  INX  H                   ; 0570 23
L_0571:  MOV  D,M                 ; 0571 56
L_0572:  XCHG                     ; 0572 eb
L_0573:  PCHL                     ; 0573 e9
L_0574:  CPI  30h                 ; 0574 fe 30
L_0576:  JZ   L_05BF              ; 0576 ca bf 05
L_0579:  RC                       ; 0579 d8
L_057A:  CPI  3Ah                 ; 057A fe 3a
L_057C:  RNC                      ; 057C d0
L_057D:  SUI  10h                 ; 057D d6 10
L_057F:  STA  0B693h              ; 057F 32 93 b6
L_0582:  RET                      ; 0582 c9
L_0583:  MVI  A,01h               ; 0583 3e 01
L_0585:  STA  0A800h              ; 0585 32 00 a8
L_0588:  CALL L_04C1              ; 0588 cd c1 04
L_058B:  XRA  A                   ; 058B af
L_058C:  STA  0A800h              ; 058C 32 00 a8
L_058F:  POP  H                   ; 058F e1
L_0590:  MOV  A,L                 ; 0590 7d
L_0591:  STA  0B693h              ; 0591 32 93 b6
L_0594:  CPI  40h                 ; 0594 fe 40
L_0596:  JNC  L_074A              ; 0596 d2 4a 07
L_0599:  LDA  0B68Fh              ; 0599 3a 8f b6
L_059C:  CPI  02h                 ; 059C fe 02
L_059E:  LDA  0B693h              ; 059E 3a 93 b6
L_05A1:  CZ   L_0574              ; 05A1 cc 74 05
L_05A4:  LXI  H,05DAh             ; 05A4 21 da 05
L_05A7:  JMP  L_0562              ; 05A7 c3 62 05
L_05AA:  LXI  H,0B689h            ; 05AA 21 89 b6
         CALL L_0E47              ; 05AD cd 47 0e
         MOV  A,M                 ; 05B0 7e
         CPI  00h                 ; 05B1 fe 00
         JZ   L_0F86              ; 05B3 ca 86 0f
         LDA  0B693h              ; 05B6 3a 93 b6
         LXI  H,0637h             ; 05B9 21 37 06
         JMP  L_0562              ; 05BC c3 62 05
L_05BF:  LXI  H,0817h             ; 05BF 21 17 08
L_05C2:  CALL L_0D13              ; 05C2 cd 13 0d
L_05C5:  CALL L_1958              ; 05C5 cd 58 19
         JNZ  L_05D4              ; 05C8 c2 d4 05
         CALL L_101B              ; 05CB cd 1b 10
         CALL L_13CB              ; 05CE cd cb 13
         JMP  L_205D              ; 05D1 c3 5d 20
L_05D4:  CALL L_0FE0              ; 05D4 cd e0 0f
         JMP  L_030F              ; 05D7 c3 0f 03
         .db 11h,00h,4Ah,07h,02h,4Ah,07h,03h,4Ah,07h,3Ch,4Ah,07h,20h,6Dh,03h ; 05DA |..J..J..J.<J. m.|
         .db 01h,0FEh,27h,1Bh,9Ah,0Fh,0Ch,0F7h,0Bh,0Ah,0E1h,26h,31h,16h,06h,21h ; 05EA |..'........&1..!|
         .db 3Ch,05h,32h,1Ch,06h,37h,70h,28h,28h,3Dh,21h,39h,0ACh,23h,30h,98h ; 05FA |<.2..7p((=!9.#0.|
         .db 04h,09h,0F7h,0Bh,0AAh,05h                        ; 060A |......|
L_0610:  MVI  A,4Eh               ; 0610 3e 4e
L_0612:  STA  L_082B              ; 0612 32 2b 08
L_0615:  RET                      ; 0615 c9
L_0616:  CALL L_0610              ; 0616 cd 10 06
L_0619:  JMP  L_2E4E              ; 0619 c3 4e 2e
L_061C:  CALL L_0610              ; 061C cd 10 06
L_061F:  JMP  L_3AAB              ; 061F c3 ab 3a
         .db 06h,19h,77h,04h,1Ah,5Ah,04h,01h,0FEh,27h,08h,64h,04h,18h,85h,04h ; 0622 |..w..Z...'.d....|
         .db 0Ah,0E1h,26h,0DDh,03h,18h,19h,77h,04h,1Ah,5Ah,04h,08h,64h,04h,18h ; 0632 |..&....w..Z..d..|
         .db 85h,04h,1Fh,0FBh,26h,0Dh,0ACh,06h,3Bh,15h,03h,2Bh,0C7h,22h,2Dh,44h ; 0642 |....&...;..+."-D|
         .db 03h,3Dh,0ADh,37h,2Fh,69h,3Dh,22h,0A0h,06h,33h,0F7h,06h,23h,00h,07h ; 0652 |.=.7/i="..3..#..|
         .db 34h,8Eh,06h,24h,94h,06h,35h,2Eh,07h,25h,3Ah,07h,36h,88h,06h,26h ; 0662 |4..$..5..%:.6..&|
         .db 0EEh,06h,38h,0A6h,06h,27h,0E5h,06h,3Fh,82h,06h,29h,9Ah,06h,82h,05h ; 0672 |..8..'..?..)....|
         .db 0CDh,1Eh,07h,0C3h,0DAh,12h                       ; 0682 |......|
L_0688:  CALL L_0714              ; 0688 cd 14 07
L_068B:  JMP  L_218A              ; 068B c3 8a 21
         .db 0CDh,1Eh,07h,0C3h,7Dh,39h                        ; 068E |....}9|
L_0694:  CALL L_071E              ; 0694 cd 1e 07
L_0697:  JMP  L_39C3              ; 0697 c3 c3 39
L_069A:  CALL L_071E              ; 069A cd 1e 07
L_069D:  JMP  L_39BD              ; 069D c3 bd 39
L_06A0:  CALL L_0714              ; 06A0 cd 14 07
L_06A3:  JMP  L_23FE              ; 06A3 c3 fe 23
L_06A6:  CALL L_0714              ; 06A6 cd 14 07
L_06A9:  JMP  L_2840              ; 06A9 c3 40 28
L_06AC:  CALL L_29DF              ; 06AC cd df 29
L_06AF:  MOV  A,M                 ; 06AF 7e
L_06B0:  CPI  2Eh                 ; 06B0 fe 2e
L_06B2:  JNZ  L_3C3E              ; 06B2 c2 3e 3c
         LXI  B,0007h             ; 06B5 01 07 00
         DAD  B                   ; 06B8 09
         MOV  A,M                 ; 06B9 7e
         SUI  30h                 ; 06BA d6 30
         CPI  0Ah                 ; 06BC fe 0a
         JC   L_06C3              ; 06BE da c3 06
         SUI  07h                 ; 06C1 d6 07
L_06C3:  STA  0A889h              ; 06C3 32 89 a8
         PUSH PSW                 ; 06C6 f5
         LXI  H,0A887h            ; 06C7 21 87 a8
         CALL L_0E4D              ; 06CA cd 4d 0e
         POP  PSW                 ; 06CD f1
         MOV  M,A                 ; 06CE 77
         CALL L_091B              ; 06CF cd 1b 09
         MVI  A,01h               ; 06D2 3e 01
         STA  0B69Bh              ; 06D4 32 9b b6
         LXI  H,0B681h            ; 06D7 21 81 b6
         CALL L_0E47              ; 06DA cd 47 0e
         MVI  M,00h               ; 06DD 36 00
         CALL L_0C7E              ; 06DF cd 7e 0c
         JMP  L_0CD9              ; 06E2 c3 d9 0c
L_06E5:  CALL L_071E              ; 06E5 cd 1e 07
L_06E8:  CALL L_0610              ; 06E8 cd 10 06
L_06EB:  JMP  L_31F1              ; 06EB c3 f1 31
L_06EE:  CALL L_0714              ; 06EE cd 14 07
L_06F1:  CALL L_0610              ; 06F1 cd 10 06
L_06F4:  JMP  L_3ADA              ; 06F4 c3 da 3a
L_06F7:  CALL L_071E              ; 06F7 cd 1e 07
L_06FA:  CALL L_0610              ; 06FA cd 10 06
L_06FD:  JMP  L_2A17              ; 06FD c3 17 2a
L_0700:  CALL L_071E              ; 0700 cd 1e 07
L_0703:  CALL L_0610              ; 0703 cd 10 06
L_0706:  MVI  A,0E6h              ; 0706 3e e6
L_0708:  STA  0011h               ; 0708 32 11 00
L_070B:  CALL L_2A17              ; 070B cd 17 2a
L_070E:  MVI  A,0C9h              ; 070E 3e c9
L_0710:  STA  0011h               ; 0710 32 11 00
L_0713:  RET                      ; 0713 c9
L_0714:  LXI  H,0A943h            ; 0714 21 43 a9
L_0717:  CALL L_0E47              ; 0717 cd 47 0e
L_071A:  MOV  A,M                 ; 071A 7e
L_071B:  CPI  00h                 ; 071B fe 00
L_071D:  RNZ                      ; 071D c0
L_071E:  LXI  H,0A88Ah            ; 071E 21 8a a8
L_0721:  CALL L_0E4D              ; 0721 cd 4d 0e
L_0724:  MOV  A,M                 ; 0724 7e
L_0725:  INR  A                   ; 0725 3c
L_0726:  MOV  B,A                 ; 0726 47
L_0727:  LDA  0B69Bh              ; 0727 3a 9b b6
L_072A:  CMP  B                   ; 072A b8
L_072B:  RNC                      ; 072B d0
         POP  H                   ; 072C e1
         RET                      ; 072D c9
L_072E:  CALL L_0714              ; 072E cd 14 07
L_0731:  CALL L_0610              ; 0731 cd 10 06
L_0734:  CALL L_0B05              ; 0734 cd 05 0b
L_0737:  JMP  L_0743              ; 0737 c3 43 07
L_073A:  CALL L_0714              ; 073A cd 14 07
L_073D:  CALL L_0610              ; 073D cd 10 06
L_0740:  CALL L_220A              ; 0740 cd 0a 22
L_0743:  LDA  0A889h              ; 0743 3a 89 a8
L_0746:  STA  L_1FAA              ; 0746 32 aa 1f
L_0749:  RET                      ; 0749 c9
L_074A:  LDA  0B693h              ; 074A 3a 93 b6
L_074D:  CPI  7Fh                 ; 074D fe 7f
L_074F:  JZ   L_0FE0              ; 074F ca e0 0f
L_0752:  XRA  A                   ; 0752 af
L_0753:  STA  0DF14h              ; 0753 32 14 df
L_0756:  STA  0A802h              ; 0756 32 02 a8
L_0759:  LDA  0B693h              ; 0759 3a 93 b6
L_075C:  LXI  H,077Dh             ; 075C 21 7d 07
L_075F:  CALL L_0562              ; 075F cd 62 05
L_0762:  LDA  0A802h              ; 0762 3a 02 a8
L_0765:  MOV  L,A                 ; 0765 6f
L_0766:  LDA  0DF14h              ; 0766 3a 14 df
L_0769:  ADI  23h                 ; 0769 c6 23
L_076B:  SUB  L                   ; 076B 95
L_076C:  MOV  H,A                 ; 076C 67
L_076D:  MVI  L,17h               ; 076D 2e 17
L_076F:  CALL L_2071              ; 076F cd 71 20
L_0772:  CALL L_04C1              ; 0772 cd c1 04
L_0775:  POP  H                   ; 0775 e1
L_0776:  MOV  A,L                 ; 0776 7d
L_0777:  STA  0B693h              ; 0777 32 93 b6
L_077A:  JMP  L_075C              ; 077A c3 5c 07
         .db 0Fh,01h,0F5h,27h,00h,05h,08h,0Ah,0E1h,26h,02h,05h,08h,03h,0C2h,36h ; 077D |...'.....&.....6|
         .db 0Dh,0Fh,20h,1Ah,5Ah,04h,08h,0C0h,07h,18h,0ADh,07h,19h,77h,04h,0Ch ; 078D |.. .Z........w..|
         .db 0F7h,0Bh,09h,0F7h,0Bh,1Fh,0C8h,36h,7Fh,0F4h,07h,1Bh,0FCh,07h,0D7h,07h ; 079D |.......6........|
         .db 3Ah,01h,0A8h,0E6h,20h,0CAh,85h,04h,21h,02h,0A8h,7Eh,0FEh,00h,0CAh,85h ; 07AD |:... ...!..~....|
         .db 04h,35h,0C9h,3Ah,01h,0A8h,0E6h,20h,0CAh,64h,04h,3Ah,02h,0A8h,21h,14h ; 07BD |.5.:... .d.:..!.|
         .db 0DFh,0BEh,0CAh,64h,04h,3Ch,32h,02h,0A8h,0C9h     ; 07CD |...d.<2...|
L_07D7:  LDA  0B693h              ; 07D7 3a 93 b6
L_07DA:  MOV  C,A                 ; 07DA 4f
L_07DB:  RST  4                   ; 07DB e7
L_07DC:  LXI  H,0DF14h            ; 07DC 21 14 df
L_07DF:  LDA  0A802h              ; 07DF 3a 02 a8
L_07E2:  CPI  00h                 ; 07E2 fe 00
L_07E4:  JZ   L_3717              ; 07E4 ca 17 37
         MOV  C,A                 ; 07E7 4f
         MOV  A,M                 ; 07E8 7e
         SUB  C                   ; 07E9 91
         ADD  L                   ; 07EA 85
         INR  A                   ; 07EB 3c
         MOV  L,A                 ; 07EC 6f
         MOV  A,C                 ; 07ED 79
         CALL L_2A02              ; 07EE cd 02 2a
         JMP  L_3717              ; 07F1 c3 17 37
         .db 3Ah,14h,0DFh,0FEh,01h,0C2h,9Ah,26h,3Eh,0Eh,32h,51h,0A8h,0E1h,0C3h,0E0h ; 07F4 |:......&>.2Q....|
         .db 0Fh,0AFh,32h,02h,0A8h,0CDh,0E0h,0Fh,3Ah,93h,0B6h,0FEh,02h,0CAh,9Eh,13h ; 0804 |..2.....:.......|
         .db 0C3h,8Fh,13h,0F7h,0D9h,0CAh,0D4h,0C9h,20h,0D7h,20h,44h,4Fh,53h,20h,3Fh ; 0814 |........ . DOS ?|
         .db 20h,28h,59h,2Fh,4Eh,29h,00h                      ; 0824 | (Y/N).|
L_082B:  .db 00h                                              ; 082B |.|
L_082C:  .db 05h                                              ; 082C |.|
L_082D:  LXI  H,3E93h             ; 082D 21 93 3e
L_0830:  CALL L_0E4D              ; 0830 cd 4d 0e
L_0833:  MOV  A,M                 ; 0833 7e
L_0834:  CPI  50h                 ; 0834 fe 50
L_0836:  JZ   L_0844              ; 0836 ca 44 08
L_0839:  MVI  A,0Dh               ; 0839 3e 0d
L_083B:  STA  0865h               ; 083B 32 65 08
L_083E:  CALL L_084F              ; 083E cd 4f 08
L_0841:  JMP  L_0F70              ; 0841 c3 70 0f
L_0844:  MVI  A,14h               ; 0844 3e 14
L_0846:  STA  0865h               ; 0846 32 65 08
L_0849:  CALL L_084F              ; 0849 cd 4f 08
L_084C:  JMP  L_0F5C              ; 084C c3 5c 0f
L_084F:  LXI  H,0B681h            ; 084F 21 81 b6
L_0852:  CALL L_0E47              ; 0852 cd 47 0e
L_0855:  MVI  B,14h               ; 0855 06 14
L_0857:  MOV  C,M                 ; 0857 4e
L_0858:  CALL L_087E              ; 0858 cd 7e 08
L_085B:  MOV  C,A                 ; 085B 4f
L_085C:  LDA  0B69Bh              ; 085C 3a 9b b6
L_085F:  SUB  C                   ; 085F 91
L_0860:  DCR  A                   ; 0860 3d
L_0861:  CALL L_0887              ; 0861 cd 87 08
L_0864:  MVI  B,0Dh               ; 0864 06 0d
L_0866:  CALL L_087E              ; 0866 cd 7e 08
L_0869:  PUSH PSW                 ; 0869 f5
L_086A:  LDA  0B69Dh              ; 086A 3a 9d b6
L_086D:  MOV  C,A                 ; 086D 4f
L_086E:  MVI  B,28h               ; 086E 06 28
L_0870:  CALL L_087E              ; 0870 cd 7e 08
L_0873:  SUI  27h                 ; 0873 d6 27
L_0875:  MOV  C,A                 ; 0875 4f
L_0876:  POP  PSW                 ; 0876 f1
L_0877:  ADD  C                   ; 0877 81
L_0878:  STA  0B695h              ; 0878 32 95 b6
L_087B:  JMP  L_08F7              ; 087B c3 f7 08
L_087E:  INR  C                   ; 087E 0c
L_087F:  XRA  A                   ; 087F af
L_0880:  ADD  B                   ; 0880 80
L_0881:  DCR  C                   ; 0881 0d
L_0882:  JNZ  L_0880              ; 0882 c2 80 08
L_0885:  SUB  B                   ; 0885 90
L_0886:  RET                      ; 0886 c9
L_0887:  MVI  C,00h               ; 0887 0e 00
L_0889:  SUI  14h                 ; 0889 d6 14
L_088B:  RM                       ; 088B f8
         INR  C                   ; 088C 0c
         JMP  L_0889              ; 088D c3 89 08
L_0890:  LXI  H,0B689h            ; 0890 21 89 b6
L_0893:  CALL L_0E47              ; 0893 cd 47 0e
L_0896:  LDA  0B69Bh              ; 0896 3a 9b b6
L_0899:  CMP  M                   ; 0899 be
L_089A:  JC   L_08A1              ; 089A da a1 08
L_089D:  MOV  A,M                 ; 089D 7e
L_089E:  STA  0B69Bh              ; 089E 32 9b b6
L_08A1:  CALL L_08EB              ; 08A1 cd eb 08
L_08A4:  PUSH PSW                 ; 08A4 f5
L_08A5:  LXI  H,3E93h             ; 08A5 21 93 3e
L_08A8:  CALL L_0E4D              ; 08A8 cd 4d 0e
L_08AB:  MOV  A,M                 ; 08AB 7e
L_08AC:  MVI  C,28h               ; 08AC 0e 28
L_08AE:  CPI  50h                 ; 08AE fe 50
L_08B0:  JZ   L_08B5              ; 08B0 ca b5 08
L_08B3:  MVI  C,3Ch               ; 08B3 0e 3c
L_08B5:  LXI  H,0B681h            ; 08B5 21 81 b6
L_08B8:  CALL L_0E47              ; 08B8 cd 47 0e
L_08BB:  POP  PSW                 ; 08BB f1
L_08BC:  ADD  C                   ; 08BC 81
L_08BD:  MOV  C,A                 ; 08BD 4f
L_08BE:  LDA  0B69Bh              ; 08BE 3a 9b b6
L_08C1:  DCR  A                   ; 08C1 3d
L_08C2:  CMP  C                   ; 08C2 b9
L_08C3:  JC   L_08D3              ; 08C3 da d3 08
L_08C6:  INR  M                   ; 08C6 34
         SUI  14h                 ; 08C7 d6 14
         CMP  C                   ; 08C9 b9
         JNC  L_08C6              ; 08CA d2 c6 08
L_08CD:  CALL L_091E              ; 08CD cd 1e 09
         JMP  L_0CD9              ; 08D0 c3 d9 0c
L_08D3:  PUSH H                   ; 08D3 e5
L_08D4:  CALL L_08EB              ; 08D4 cd eb 08
L_08D7:  MOV  C,A                 ; 08D7 4f
L_08D8:  POP  H                   ; 08D8 e1
L_08D9:  LDA  0B69Bh              ; 08D9 3a 9b b6
L_08DC:  DCR  A                   ; 08DC 3d
L_08DD:  CMP  C                   ; 08DD b9
L_08DE:  JNC  L_0CD9              ; 08DE d2 d9 0c
L_08E1:  DCR  M                   ; 08E1 35
         ADI  14h                 ; 08E2 c6 14
         CMP  C                   ; 08E4 b9
         JC   L_08E1              ; 08E5 da e1 08
         JMP  L_08CD              ; 08E8 c3 cd 08
L_08EB:  LXI  H,0B681h            ; 08EB 21 81 b6
L_08EE:  CALL L_0E47              ; 08EE cd 47 0e
L_08F1:  MOV  C,M                 ; 08F1 4e
L_08F2:  MVI  B,14h               ; 08F2 06 14
L_08F4:  JMP  L_087E              ; 08F4 c3 7e 08
L_08F7:  LDA  0B695h              ; 08F7 3a 95 b6
L_08FA:  ADI  20h                 ; 08FA c6 20
L_08FC:  MOV  H,A                 ; 08FC 67
L_08FD:  LDA  0B69Bh              ; 08FD 3a 9b b6
L_0900:  DCR  A                   ; 0900 3d
L_0901:  SUI  14h                 ; 0901 d6 14
L_0903:  JNC  L_0901              ; 0903 d2 01 09
L_0906:  ADI  36h                 ; 0906 c6 36
L_0908:  MOV  L,A                 ; 0908 6f
L_0909:  CALL L_2071              ; 0909 cd 71 20
L_090C:  JMP  L_29DF              ; 090C c3 df 29
L_090F:  LXI  H,09A7h             ; 090F 21 a7 09
L_0912:  SHLD 0961h               ; 0912 22 61 09
L_0915:  CALL L_0927              ; 0915 cd 27 09
L_0918:  JMP  L_0CD9              ; 0918 c3 d9 0c
L_091B:  CALL L_19E8              ; 091B cd e8 19
L_091E:  CALL L_0D7B              ; 091E cd 7b 0d
L_0921:  LXI  H,09E7h             ; 0921 21 e7 09
L_0924:  SHLD 0961h               ; 0924 22 61 09
L_0927:  CALL L_0E54              ; 0927 cd 54 0e
L_092A:  LDA  0B69Bh              ; 092A 3a 9b b6
L_092D:  PUSH PSW                 ; 092D f5
L_092E:  LXI  H,0B681h            ; 092E 21 81 b6
L_0931:  CALL L_0E47              ; 0931 cd 47 0e
L_0934:  MOV  C,M                 ; 0934 4e
L_0935:  MVI  A,0EDh              ; 0935 3e ed
L_0937:  MVI  B,14h               ; 0937 06 14
L_0939:  INR  C                   ; 0939 0c
L_093A:  ADD  B                   ; 093A 80
L_093B:  DCR  C                   ; 093B 0d
L_093C:  JNZ  L_093A              ; 093C c2 3a 09
L_093F:  STA  0B69Bh              ; 093F 32 9b b6
L_0942:  LXI  H,0B689h            ; 0942 21 89 b6
L_0945:  CALL L_0E47              ; 0945 cd 47 0e
L_0948:  MOV  A,M                 ; 0948 7e
L_0949:  ORA  A                   ; 0949 b7
L_094A:  JZ   L_097A              ; 094A ca 7a 09
L_094D:  INR  A                   ; 094D 3c
L_094E:  STA  0A807h              ; 094E 32 07 a8
L_0951:  LXI  H,3E93h             ; 0951 21 93 3e
L_0954:  CALL L_0E4D              ; 0954 cd 4d 0e
L_0957:  MOV  A,M                 ; 0957 7e
L_0958:  STA  0A808h              ; 0958 32 08 a8
L_095B:  CALL L_29DF              ; 095B cd df 29
L_095E:  MVI  C,27h               ; 095E 0e 27
L_0960:  CALL L_09A7              ; 0960 cd a7 09
         LDA  0A808h              ; 0963 3a 08 a8
         CPI  50h                 ; 0966 fe 50
         JNZ  L_0970              ; 0968 c2 70 09
         MVI  C,0Bh               ; 096B 0e 0b
         JMP  L_0977              ; 096D c3 77 09
L_0970:  MVI  C,12h               ; 0970 0e 12
         CALL L_09AF              ; 0972 cd af 09
         MVI  C,05h               ; 0975 0e 05
L_0977:  CALL L_09AF              ; 0977 cd af 09
L_097A:  POP  PSW                 ; 097A f1
L_097B:  STA  0B69Bh              ; 097B 32 9b b6
L_097E:  JMP  L_0FF3              ; 097E c3 f3 0f
L_0981:  POP  H                   ; 0981 e1
L_0982:  JMP  L_097A              ; 0982 c3 7a 09
L_0985:  LDA  0B69Dh              ; 0985 3a 9d b6
L_0988:  MOV  B,A                 ; 0988 47
L_0989:  MVI  A,20h               ; 0989 3e 20
L_098B:  ADI  28h                 ; 098B c6 28
L_098D:  DCR  B                   ; 098D 05
L_098E:  JNZ  L_098B              ; 098E c2 8b 09
L_0991:  SUB  C                   ; 0991 91
L_0992:  STA  L_10D2              ; 0992 32 d2 10
L_0995:  MVI  A,22h               ; 0995 3e 22
L_0997:  STA  L_10D1              ; 0997 32 d1 10
L_099A:  PUSH H                   ; 099A e5
L_099B:  LXI  H,10CFh             ; 099B 21 cf 10
L_099E:  RST  3                   ; 099E df
L_099F:  POP  H                   ; 099F e1
L_09A0:  MVI  C,14h               ; 09A0 0e 14
L_09A2:  LDA  0A807h              ; 09A2 3a 07 a8
L_09A5:  MOV  B,A                 ; 09A5 47
L_09A6:  RET                      ; 09A6 c9
L_09A7:  LXI  D,0008h             ; 09A7 11 08 00
L_09AA:  DAD  D                   ; 09AA 19
L_09AB:  MOV  A,C                 ; 09AB 79
L_09AC:  SUI  08h                 ; 09AC d6 08
L_09AE:  MOV  C,A                 ; 09AE 4f
L_09AF:  CALL L_0985              ; 09AF cd 85 09
L_09B2:  LXI  D,000Dh             ; 09B2 11 0d 00
L_09B5:  PUSH B                   ; 09B5 c5
L_09B6:  MOV  C,M                 ; 09B6 4e
L_09B7:  RST  4                   ; 09B7 e7
L_09B8:  POP  B                   ; 09B8 c1
L_09B9:  DAD  D                   ; 09B9 19
L_09BA:  PUSH H                   ; 09BA e5
L_09BB:  LXI  H,10D4h             ; 09BB 21 d4 10
L_09BE:  RST  3                   ; 09BE df
L_09BF:  POP  H                   ; 09BF e1
L_09C0:  LDA  0B69Bh              ; 09C0 3a 9b b6
L_09C3:  INR  A                   ; 09C3 3c
L_09C4:  STA  0B69Bh              ; 09C4 32 9b b6
L_09C7:  CMP  B                   ; 09C7 b8
L_09C8:  JZ   L_0981              ; 09C8 ca 81 09
L_09CB:  DCR  C                   ; 09CB 0d
L_09CC:  JNZ  L_09B5              ; 09CC c2 b5 09
         RET                      ; 09CF c9
L_09D0:  CALL L_0A20              ; 09D0 cd 20 0a
L_09D3:  LDA  0B69Bh              ; 09D3 3a 9b b6
L_09D6:  ADD  D                   ; 09D6 82
L_09D7:  CMP  B                   ; 09D7 b8
L_09D8:  JP   L_09E3              ; 09D8 f2 e3 09
         LXI  D,00F7h             ; 09DB 11 f7 00
         DAD  D                   ; 09DE 19
         MVI  C,18h               ; 09DF 0e 18
         RST  4                   ; 09E1 e7
         RET                      ; 09E2 c9
L_09E3:  POP  PSW                 ; 09E3 f1
L_09E4:  JMP  L_0A01              ; 09E4 c3 01 0a
L_09E7:  CALL L_0985              ; 09E7 cd 85 09
L_09EA:  PUSH B                   ; 09EA c5
L_09EB:  PUSH H                   ; 09EB e5
L_09EC:  MVI  D,14h               ; 09EC 16 14
L_09EE:  CALL L_09D0              ; 09EE cd d0 09
         LDA  0A808h              ; 09F1 3a 08 a8
         CPI  50h                 ; 09F4 fe 50
         JZ   L_09FE              ; 09F6 ca fe 09
         MVI  D,28h               ; 09F9 16 28
         CALL L_09D0              ; 09FB cd d0 09
L_09FE:  CALL L_0A20              ; 09FE cd 20 0a
L_0A01:  LXI  H,10D1h             ; 0A01 21 d1 10
L_0A04:  INR  M                   ; 0A04 34
L_0A05:  DCX  H                   ; 0A05 2b
L_0A06:  DCX  H                   ; 0A06 2b
L_0A07:  RST  3                   ; 0A07 df
L_0A08:  POP  H                   ; 0A08 e1
L_0A09:  LXI  D,000Dh             ; 0A09 11 0d 00
L_0A0C:  DAD  D                   ; 0A0C 19
L_0A0D:  POP  B                   ; 0A0D c1
L_0A0E:  LDA  0B69Bh              ; 0A0E 3a 9b b6
L_0A11:  INR  A                   ; 0A11 3c
L_0A12:  STA  0B69Bh              ; 0A12 32 9b b6
L_0A15:  CMP  B                   ; 0A15 b8
L_0A16:  JP   L_0981              ; 0A16 f2 81 09
L_0A19:  DCR  C                   ; 0A19 0d
L_0A1A:  JNZ  L_09EA              ; 0A1A c2 ea 09
         JMP  L_0981              ; 0A1D c3 81 09
L_0A20:  CALL L_0A40              ; 0A20 cd 40 0a
L_0A23:  LDA  0A808h              ; 0A23 3a 08 a8
L_0A26:  CPI  50h                 ; 0A26 fe 50
L_0A28:  RNZ                      ; 0A28 c0
L_0A29:  PUSH H                   ; 0A29 e5
L_0A2A:  PUSH B                   ; 0A2A c5
L_0A2B:  DCX  H                   ; 0A2B 2b
L_0A2C:  MOV  A,M                 ; 0A2C 7e
L_0A2D:  LXI  H,10C9h             ; 0A2D 21 c9 10
L_0A30:  CALL L_0E1B              ; 0A30 cd 1b 0e
L_0A33:  LXI  H,10C8h             ; 0A33 21 c8 10
L_0A36:  MVI  E,07h               ; 0A36 1e 07
L_0A38:  MVI  A,20h               ; 0A38 3e 20
L_0A3A:  CALL L_0A44              ; 0A3A cd 44 0a
L_0A3D:  POP  B                   ; 0A3D c1
L_0A3E:  POP  H                   ; 0A3E e1
L_0A3F:  RET                      ; 0A3F c9
L_0A40:  MVI  A,20h               ; 0A40 3e 20
L_0A42:  MVI  E,0Ch               ; 0A42 1e 0c
L_0A44:  MOV  C,M                 ; 0A44 4e
L_0A45:  CMP  C                   ; 0A45 b9
L_0A46:  JNZ  L_0A4B              ; 0A46 c2 4b 0a
L_0A49:  MVI  C,18h               ; 0A49 0e 18
L_0A4B:  CALL 0F809h              ; 0A4B cd 09 f8
L_0A4E:  INX  H                   ; 0A4E 23
L_0A4F:  DCR  E                   ; 0A4F 1d
L_0A50:  JNZ  L_0A44              ; 0A50 c2 44 0a
L_0A53:  INX  H                   ; 0A53 23
L_0A54:  RET                      ; 0A54 c9
L_0A55:  LDA  L_10DE              ; 0A55 3a de 10
L_0A58:  JMP  L_0A86              ; 0A58 c3 86 0a
L_0A5B:  CALL L_0AA2              ; 0A5B cd a2 0a
L_0A5E:  LXI  H,0A887h            ; 0A5E 21 87 a8
L_0A61:  LDA  0B69Dh              ; 0A61 3a 9d b6
L_0A64:  DCR  A                   ; 0A64 3d
L_0A65:  JNZ  L_0A69              ; 0A65 c2 69 0a
L_0A68:  INX  H                   ; 0A68 23
L_0A69:  MOV  A,M                 ; 0A69 7e
L_0A6A:  CALL L_1D3B              ; 0A6A cd 3b 1d
L_0A6D:  STA  L_10DE              ; 0A6D 32 de 10
L_0A70:  LXI  H,10D7h             ; 0A70 21 d7 10
L_0A73:  RST  3                   ; 0A73 df
L_0A74:  CALL L_0D44              ; 0A74 cd 44 0d
L_0A77:  CPI  0Dh                 ; 0A77 fe 0d
L_0A79:  JZ   L_0A55              ; 0A79 ca 55 0a
         CPI  1Ah                 ; 0A7C fe 1a
         JZ   L_0A55              ; 0A7E ca 55 0a
         CPI  20h                 ; 0A81 fe 20
         JC   L_0B01              ; 0A83 da 01 0b
L_0A86:  MOV  C,A                 ; 0A86 4f
L_0A87:  RST  4                   ; 0A87 e7
L_0A88:  SUI  30h                 ; 0A88 d6 30
L_0A8A:  CPI  0Ah                 ; 0A8A fe 0a
L_0A8C:  JC   L_0A96              ; 0A8C da 96 0a
         SUI  07h                 ; 0A8F d6 07
         CPI  0Ah                 ; 0A91 fe 0a
         JC   L_0B01              ; 0A93 da 01 0b
L_0A96:  CPI  10h                 ; 0A96 fe 10
L_0A98:  JNC  L_0B01              ; 0A98 d2 01 0b
L_0A9B:  STA  L_1FAA              ; 0A9B 32 aa 1f
L_0A9E:  CALL L_0FE0              ; 0A9E cd e0 0f
L_0AA1:  RET                      ; 0AA1 c9
L_0AA2:  LXI  H,3E91h             ; 0AA2 21 91 3e
L_0AA5:  CALL L_0E4D              ; 0AA5 cd 4d 0e
L_0AA8:  MOV  A,M                 ; 0AA8 7e
L_0AA9:  STA  L_10BA              ; 0AA9 32 ba 10
L_0AAC:  LXI  H,3E91h             ; 0AAC 21 91 3e
L_0AAF:  LDA  0B69Dh              ; 0AAF 3a 9d b6
L_0AB2:  DCR  A                   ; 0AB2 3d
L_0AB3:  JNZ  L_0AB7              ; 0AB3 c2 b7 0a
L_0AB6:  INX  H                   ; 0AB6 23
L_0AB7:  MOV  A,M                 ; 0AB7 7e
L_0AB8:  STA  L_10BE              ; 0AB8 32 be 10
L_0ABB:  STA  0A806h              ; 0ABB 32 06 a8
L_0ABE:  LXI  H,10BAh             ; 0ABE 21 ba 10
L_0AC1:  RST  3                   ; 0AC1 df
L_0AC2:  CALL L_0D44              ; 0AC2 cd 44 0d
L_0AC5:  CPI  20h                 ; 0AC5 fe 20
L_0AC7:  JC   L_0ACC              ; 0AC7 da cc 0a
         MOV  C,A                 ; 0ACA 4f
         RST  4                   ; 0ACB e7
L_0ACC:  LXI  H,0AD2h             ; 0ACC 21 d2 0a
L_0ACF:  JMP  L_0562              ; 0ACF c3 62 05
         .db 05h,0Dh,0FCh,0Ah,1Ah,0FCh,0Ah,41h,0F1h,0Ah,42h,0E4h,0Ah,43h,0F6h,0Ah ; 0AD2 |.......A..B..C..|
         .db 00h,0Bh,3Ah,97h,3Eh,0FEh,59h,0C2h,01h,0Bh,3Eh,42h,0C3h,0F8h,0Ah,3Eh ; 0AE2 |..:.>.Y...>B...>|
         .db 41h,0C3h,0F8h,0Ah,3Eh,43h                        ; 0AF2 |A...>C|
L_0AF8:  STA  L_10BE              ; 0AF8 32 be 10
         RET                      ; 0AFB c9
L_0AFC:  MVI  C,18h               ; 0AFC 0e 18
L_0AFE:  RST  4                   ; 0AFE e7
L_0AFF:  RET                      ; 0AFF c9
L_0B00:  POP  H                   ; 0B00 e1
L_0B01:  POP  H                   ; 0B01 e1
L_0B02:  JMP  L_0FE0              ; 0B02 c3 e0 0f
L_0B05:  LXI  H,0A887h            ; 0B05 21 87 a8
L_0B08:  MOV  A,M                 ; 0B08 7e
L_0B09:  STA  L_1FAA              ; 0B09 32 aa 1f
L_0B0C:  CALL L_0A5B              ; 0B0C cd 5b 0a
L_0B0F:  LXI  H,10BEh             ; 0B0F 21 be 10
L_0B12:  MOV  A,M                 ; 0B12 7e
L_0B13:  STA  0A849h              ; 0B13 32 49 a8
L_0B16:  LDA  L_10BA              ; 0B16 3a ba 10
L_0B19:  STA  0A84Ah              ; 0B19 32 4a a8
L_0B1C:  CMP  M                   ; 0B1C be
L_0B1D:  JNZ  L_0B2C              ; 0B1D c2 2c 0b
         LXI  H,0A887h            ; 0B20 21 87 a8
         CALL L_0E4D              ; 0B23 cd 4d 0e
         MOV  C,M                 ; 0B26 4e
         LDA  L_1FAA              ; 0B27 3a aa 1f
         CMP  M                   ; 0B2A be
         RZ                       ; 0B2B c8
L_0B2C:  LDA  0A84Ah              ; 0B2C 3a 4a a8
L_0B2F:  CALL L_0B6B              ; 0B2F cd 6b 0b
L_0B32:  CALL L_0262              ; 0B32 cd 62 02
L_0B35:  LDA  0A849h              ; 0B35 3a 49 a8
L_0B38:  CALL L_0B5C              ; 0B38 cd 5c 0b
L_0B3B:  CALL L_0262              ; 0B3B cd 62 02
L_0B3E:  CALL L_1E7C              ; 0B3E cd 7c 1e
L_0B41:  LXI  H,10AFh             ; 0B41 21 af 10
L_0B44:  MVI  A,01h               ; 0B44 3e 01
L_0B46:  CALL L_0E1B              ; 0B46 cd 1b 0e
L_0B49:  LXI  H,10A5h             ; 0B49 21 a5 10
L_0B4C:  RST  3                   ; 0B4C df
L_0B4D:  LXI  H,0BE0h             ; 0B4D 21 e0 0b
L_0B50:  CALL L_0B7A              ; 0B50 cd 7a 0b
L_0B53:  LDA  0A849h              ; 0B53 3a 49 a8
L_0B56:  CALL L_027A              ; 0B56 cd 7a 02
L_0B59:  JMP  L_2254              ; 0B59 c3 54 22
L_0B5C:  LXI  H,178Fh             ; 0B5C 21 8f 17
L_0B5F:  CPI  43h                 ; 0B5F fe 43
         JZ   L_0B67              ; 0B61 ca 67 0b
L_0B64:  LXI  H,179Bh             ; 0B64 21 9b 17
L_0B67:  SHLD 1767h               ; 0B67 22 67 17
L_0B6A:  RET                      ; 0B6A c9
L_0B6B:  LXI  H,1713h             ; 0B6B 21 13 17
L_0B6E:  CPI  43h                 ; 0B6E fe 43
         JZ   L_0B76              ; 0B70 ca 76 0b
L_0B73:  LXI  H,1701h             ; 0B73 21 01 17
L_0B76:  SHLD 16C9h               ; 0B76 22 c9 16
L_0B79:  RET                      ; 0B79 c9
L_0B7A:  SHLD 0BB1h               ; 0B7A 22 b1 0b
L_0B7D:  SHLD 0BD9h               ; 0B7D 22 d9 0b
L_0B80:  LDA  0B69Bh              ; 0B80 3a 9b b6
L_0B83:  STA  0A950h              ; 0B83 32 50 a9
L_0B86:  XRA  A                   ; 0B86 af
L_0B87:  STA  0B69Bh              ; 0B87 32 9b b6
L_0B8A:  INR  A                   ; 0B8A 3c
L_0B8B:  STA  0A804h              ; 0B8B 32 04 a8
L_0B8E:  LXI  H,0B689h            ; 0B8E 21 89 b6
L_0B91:  CALL L_0E47              ; 0B91 cd 47 0e
L_0B94:  LDA  0B69Bh              ; 0B94 3a 9b b6
L_0B97:  CMP  M                   ; 0B97 be
L_0B98:  JZ   L_0BC8              ; 0B98 ca c8 0b
L_0B9B:  INR  A                   ; 0B9B 3c
L_0B9C:  STA  0B69Bh              ; 0B9C 32 9b b6
L_0B9F:  PUSH H                   ; 0B9F e5
L_0BA0:  CALL L_29DF              ; 0BA0 cd df 29
L_0BA3:  LXI  D,0008h             ; 0BA3 11 08 00
L_0BA6:  XCHG                     ; 0BA6 eb
L_0BA7:  DAD  D                   ; 0BA7 19
L_0BA8:  MOV  A,M                 ; 0BA8 7e
L_0BA9:  CPI  7Fh                 ; 0BA9 fe 7f
L_0BAB:  POP  H                   ; 0BAB e1
L_0BAC:  JNZ  L_0B94              ; 0BAC c2 94 0b
         PUSH H                   ; 0BAF e5
         CALL 0000h               ; 0BB0 cd 00 00
         LXI  H,0A804h            ; 0BB3 21 04 a8
         INR  M                   ; 0BB6 34
         CALL 0F81Bh              ; 0BB7 cd 1b f8
         CPI  1Bh                 ; 0BBA fe 1b
         POP  H                   ; 0BBC e1
         JZ   L_0BC8              ; 0BBD ca c8 0b
         LDA  0B68Dh              ; 0BC0 3a 8d b6
         CPI  03h                 ; 0BC3 fe 03
         JNZ  L_0B94              ; 0BC5 c2 94 0b
L_0BC8:  LDA  0A950h              ; 0BC8 3a 50 a9
L_0BCB:  STA  0B69Bh              ; 0BCB 32 9b b6
L_0BCE:  CALL L_29DF              ; 0BCE cd df 29
L_0BD1:  XCHG                     ; 0BD1 eb
L_0BD2:  MVI  A,01h               ; 0BD2 3e 01
L_0BD4:  LXI  H,0A804h            ; 0BD4 21 04 a8
L_0BD7:  CMP  M                   ; 0BD7 be
L_0BD8:  CZ   0000h               ; 0BD8 cc 00 00
L_0BDB:  XRA  A                   ; 0BDB af
L_0BDC:  STA  0B68Dh              ; 0BDC 32 8d b6
L_0BDF:  RET                      ; 0BDF c9
L_0BE0:  XCHG                     ; 0BE0 eb
L_0BE1:  SHLD 0A84Fh              ; 0BE1 22 4f a8
L_0BE4:  SHLD 0A84Dh              ; 0BE4 22 4d a8
L_0BE7:  LDA  0A804h              ; 0BE7 3a 04 a8
L_0BEA:  LXI  H,11EDh             ; 0BEA 21 ed 11
L_0BED:  CALL L_0E1B              ; 0BED cd 1b 0e
L_0BF0:  LXI  H,11E9h             ; 0BF0 21 e9 11
L_0BF3:  RST  3                   ; 0BF3 df
L_0BF4:  JMP  L_159A              ; 0BF4 c3 9a 15
L_0BF7:  LXI  H,0B689h            ; 0BF7 21 89 b6
L_0BFA:  CALL L_0E47              ; 0BFA cd 47 0e
L_0BFD:  XRA  A                   ; 0BFD af
L_0BFE:  CMP  M                   ; 0BFE be
L_0BFF:  CNZ  L_082D              ; 0BFF c4 2d 08
L_0C02:  LDA  0B69Dh              ; 0C02 3a 9d b6
L_0C05:  DCR  A                   ; 0C05 3d
L_0C06:  JNZ  L_0C0B              ; 0C06 c2 0b 0c
L_0C09:  MVI  A,02h               ; 0C09 3e 02
L_0C0B:  STA  0B69Dh              ; 0C0B 32 9d b6
L_0C0E:  LDA  0B69Bh              ; 0C0E 3a 9b b6
L_0C11:  MOV  C,A                 ; 0C11 4f
L_0C12:  LDA  0A94Dh              ; 0C12 3a 4d a9
L_0C15:  STA  0B69Bh              ; 0C15 32 9b b6
L_0C18:  MOV  A,C                 ; 0C18 79
L_0C19:  STA  0A94Dh              ; 0C19 32 4d a9
L_0C1C:  LXI  H,0A887h            ; 0C1C 21 87 a8
L_0C1F:  CALL L_0E4D              ; 0C1F cd 4d 0e
L_0C22:  MOV  A,M                 ; 0C22 7e
L_0C23:  STA  0A889h              ; 0C23 32 89 a8
L_0C26:  CALL L_13D3              ; 0C26 cd d3 13
L_0C29:  CALL L_0C7E              ; 0C29 cd 7e 0c
L_0C2C:  JMP  L_0CD9              ; 0C2C c3 d9 0c
L_0C2F:  CALL L_29DF              ; 0C2F cd df 29
L_0C32:  PUSH H                   ; 0C32 e5
L_0C33:  LXI  D,0B654h            ; 0C33 11 54 b6
L_0C36:  MVI  C,0Eh               ; 0C36 0e 0e
L_0C38:  RST  5                   ; 0C38 ef
L_0C39:  LXI  H,0C56h             ; 0C39 21 56 0c
L_0C3C:  PUSH H                   ; 0C3C e5
L_0C3D:  LDA  0A94Bh              ; 0C3D 3a 4b a9
L_0C40:  DCR  A                   ; 0C40 3d
L_0C41:  JZ   L_0C63              ; 0C41 ca 63 0c
L_0C44:  DCR  A                   ; 0C44 3d
L_0C45:  JZ   L_0C5D              ; 0C45 ca 5d 0c
L_0C48:  LXI  H,0B65Dh            ; 0C48 21 5d b6
L_0C4B:  MOV  A,M                 ; 0C4B 7e
L_0C4C:  ANI  7Fh                 ; 0C4C e6 7f
L_0C4E:  MOV  M,A                 ; 0C4E 77
L_0C4F:  INX  H                   ; 0C4F 23
L_0C50:  MOV  A,M                 ; 0C50 7e
L_0C51:  ANI  7Fh                 ; 0C51 e6 7f
L_0C53:  JMP  L_0C69              ; 0C53 c3 69 0c
L_0C56:  POP  D                   ; 0C56 d1
L_0C57:  LXI  H,0B654h            ; 0C57 21 54 b6
L_0C5A:  JMP  L_3979              ; 0C5A c3 79 39
L_0C5D:  LXI  H,0B65Eh            ; 0C5D 21 5e b6
         JMP  L_0C66              ; 0C60 c3 66 0c
L_0C63:  LXI  H,0B65Dh            ; 0C63 21 5d b6
L_0C66:  MOV  A,M                 ; 0C66 7e
L_0C67:  ORI  80h                 ; 0C67 f6 80
L_0C69:  MOV  M,A                 ; 0C69 77
L_0C6A:  LXI  H,3E91h             ; 0C6A 21 91 3e
L_0C6D:  CALL L_0E4D              ; 0C6D cd 4d 0e
L_0C70:  MOV  A,M                 ; 0C70 7e
L_0C71:  STA  0B673h              ; 0C71 32 73 b6
L_0C74:  CALL L_19B2              ; 0C74 cd b2 19
L_0C77:  MVI  C,1Eh               ; 0C77 0e 1e
L_0C79:  LXI  D,005Ch             ; 0C79 11 5c 00
L_0C7C:  RST  1                   ; 0C7C cf
L_0C7D:  RET                      ; 0C7D c9
L_0C7E:  MVI  C,0Bh               ; 0C7E 0e 0b
L_0C80:  RST  4                   ; 0C80 e7
L_0C81:  LDA  0B69Dh              ; 0C81 3a 9d b6
L_0C84:  DCR  A                   ; 0C84 3d
L_0C85:  JZ   L_0CBA              ; 0C85 ca ba 0c
L_0C88:  STA  0B69Dh              ; 0C88 32 9d b6
L_0C8B:  CALL L_0EB5              ; 0C8B cd b5 0e
L_0C8E:  MVI  A,02h               ; 0C8E 3e 02
L_0C90:  STA  0B69Dh              ; 0C90 32 9d b6
L_0C93:  CALL L_0CCD              ; 0C93 cd cd 0c
L_0C96:  LXI  H,3E91h             ; 0C96 21 91 3e
L_0C99:  CALL L_0E4D              ; 0C99 cd 4d 0e
L_0C9C:  MOV  A,M                 ; 0C9C 7e
L_0C9D:  STA  L_10A2              ; 0C9D 32 a2 10
L_0CA0:  SUI  41h                 ; 0CA0 d6 41
L_0CA2:  STA  0004h               ; 0CA2 32 04 00
L_0CA5:  LDA  0A889h              ; 0CA5 3a 89 a8
L_0CA8:  CALL L_1D3B              ; 0CA8 cd 3b 1d
L_0CAB:  CPI  30h                 ; 0CAB fe 30
L_0CAD:  JNZ  L_0CB2              ; 0CAD c2 b2 0c
L_0CB0:  MVI  A,20h               ; 0CB0 3e 20
L_0CB2:  STA  L_10A1              ; 0CB2 32 a1 10
L_0CB5:  LXI  H,109Dh             ; 0CB5 21 9d 10
L_0CB8:  RST  3                   ; 0CB8 df
L_0CB9:  RET                      ; 0CB9 c9
L_0CBA:  CALL L_0CCD              ; 0CBA cd cd 0c
L_0CBD:  MVI  A,02h               ; 0CBD 3e 02
L_0CBF:  STA  0B69Dh              ; 0CBF 32 9d b6
L_0CC2:  CALL L_0EB5              ; 0CC2 cd b5 0e
L_0CC5:  MVI  A,01h               ; 0CC5 3e 01
L_0CC7:  STA  0B69Dh              ; 0CC7 32 9d b6
L_0CCA:  JMP  L_0C96              ; 0CCA c3 96 0c
L_0CCD:  LXI  H,1097h             ; 0CCD 21 97 10
L_0CD0:  RST  3                   ; 0CD0 df
L_0CD1:  CALL L_0EB5              ; 0CD1 cd b5 0e
L_0CD4:  LXI  H,109Ah             ; 0CD4 21 9a 10
L_0CD7:  RST  3                   ; 0CD7 df
L_0CD8:  RET                      ; 0CD8 c9
L_0CD9:  LXI  H,0B689h            ; 0CD9 21 89 b6
L_0CDC:  CALL L_0E47              ; 0CDC cd 47 0e
L_0CDF:  MOV  A,M                 ; 0CDF 7e
L_0CE0:  CPI  00h                 ; 0CE0 fe 00
L_0CE2:  RZ                       ; 0CE2 c8
L_0CE3:  LXI  H,1097h             ; 0CE3 21 97 10
L_0CE6:  RST  3                   ; 0CE6 df
L_0CE7:  CALL L_082D              ; 0CE7 cd 2d 08
L_0CEA:  LXI  H,109Ah             ; 0CEA 21 9a 10
L_0CED:  RST  3                   ; 0CED df
L_0CEE:  JMP  L_0FF3              ; 0CEE c3 f3 0f
L_0CF1:  PUSH H                   ; 0CF1 e5
L_0CF2:  CALL L_0FF3              ; 0CF2 cd f3 0f
L_0CF5:  POP  H                   ; 0CF5 e1
L_0CF6:  PUSH H                   ; 0CF6 e5
L_0CF7:  MVI  C,00h               ; 0CF7 0e 00
L_0CF9:  CALL L_0D13              ; 0CF9 cd 13 0d
L_0CFC:  MOV  A,E                 ; 0CFC 7b
L_0CFD:  CMP  C                   ; 0CFD b9
L_0CFE:  JNZ  L_0CF9              ; 0CFE c2 f9 0c
L_0D01:  PUSH H                   ; 0D01 e5
L_0D02:  LXI  H,1097h             ; 0D02 21 97 10
L_0D05:  RST  3                   ; 0D05 df
L_0D06:  POP  H                   ; 0D06 e1
L_0D07:  CALL L_0D13              ; 0D07 cd 13 0d
L_0D0A:  PUSH H                   ; 0D0A e5
L_0D0B:  LXI  H,109Ah             ; 0D0B 21 9a 10
L_0D0E:  RST  3                   ; 0D0E df
L_0D0F:  POP  H                   ; 0D0F e1
L_0D10:  JMP  L_0D20              ; 0D10 c3 20 0d
L_0D13:  PUSH B                   ; 0D13 c5
L_0D14:  MVI  C,20h               ; 0D14 0e 20
L_0D16:  RST  4                   ; 0D16 e7
L_0D17:  RST  3                   ; 0D17 df
L_0D18:  RST  4                   ; 0D18 e7
L_0D19:  POP  B                   ; 0D19 c1
L_0D1A:  INX  H                   ; 0D1A 23
L_0D1B:  INR  C                   ; 0D1B 0c
L_0D1C:  RET                      ; 0D1C c9
L_0D1D:  CALL L_0D13              ; 0D1D cd 13 0d
L_0D20:  MOV  A,D                 ; 0D20 7a
L_0D21:  CMP  C                   ; 0D21 b9
L_0D22:  JNZ  L_0D1D              ; 0D22 c2 1d 0d
L_0D25:  CALL L_0D44              ; 0D25 cd 44 0d
L_0D28:  CPI  08h                 ; 0D28 fe 08
L_0D2A:  JZ   L_0D50              ; 0D2A ca 50 0d
L_0D2D:  CPI  18h                 ; 0D2D fe 18
L_0D2F:  JZ   L_0D5E              ; 0D2F ca 5e 0d
L_0D32:  CPI  0Dh                 ; 0D32 fe 0d
L_0D34:  JZ   L_0D6D              ; 0D34 ca 6d 0d
L_0D37:  CPI  1Ah                 ; 0D37 fe 1a
L_0D39:  JZ   L_0D6D              ; 0D39 ca 6d 0d
L_0D3C:  CPI  1Bh                 ; 0D3C fe 1b
L_0D3E:  JZ   L_0D72              ; 0D3E ca 72 0d
L_0D41:  JMP  L_0D25              ; 0D41 c3 25 0d
L_0D44:  PUSH H                   ; 0D44 e5
L_0D45:  PUSH D                   ; 0D45 d5
L_0D46:  PUSH B                   ; 0D46 c5
L_0D47:  CALL L_04C1              ; 0D47 cd c1 04
L_0D4A:  POP  B                   ; 0D4A c1
L_0D4B:  MOV  A,C                 ; 0D4B 79
L_0D4C:  POP  B                   ; 0D4C c1
L_0D4D:  POP  D                   ; 0D4D d1
L_0D4E:  POP  H                   ; 0D4E e1
L_0D4F:  RET                      ; 0D4F c9
L_0D50:  MOV  A,E                 ; 0D50 7b
L_0D51:  DCR  A                   ; 0D51 3d
L_0D52:  JZ   L_0D59              ; 0D52 ca 59 0d
L_0D55:  DCR  E                   ; 0D55 1d
L_0D56:  JMP  L_0CF2              ; 0D56 c3 f2 0c
L_0D59:  MOV  E,D                 ; 0D59 5a
L_0D5A:  DCR  E                   ; 0D5A 1d
L_0D5B:  JMP  L_0CF2              ; 0D5B c3 f2 0c
L_0D5E:  MOV  A,E                 ; 0D5E 7b
L_0D5F:  INR  A                   ; 0D5F 3c
L_0D60:  CMP  D                   ; 0D60 ba
L_0D61:  JZ   L_0D68              ; 0D61 ca 68 0d
L_0D64:  INR  E                   ; 0D64 1c
L_0D65:  JMP  L_0CF2              ; 0D65 c3 f2 0c
L_0D68:  MVI  E,01h               ; 0D68 1e 01
L_0D6A:  JMP  L_0CF2              ; 0D6A c3 f2 0c
L_0D6D:  POP  H                   ; 0D6D e1
L_0D6E:  MOV  A,E                 ; 0D6E 7b
L_0D6F:  JMP  L_0D75              ; 0D6F c3 75 0d
L_0D72:  POP  H                   ; 0D72 e1
L_0D73:  MVI  A,1Bh               ; 0D73 3e 1b
L_0D75:  PUSH PSW                 ; 0D75 f5
L_0D76:  CALL L_0FE0              ; 0D76 cd e0 0f
L_0D79:  POP  PSW                 ; 0D79 f1
L_0D7A:  RET                      ; 0D7A c9
L_0D7B:  CALL L_2A0A              ; 0D7B cd 0a 2a
L_0D7E:  CALL L_347D              ; 0D7E cd 7d 34
L_0D81:  CALL L_2A0A              ; 0D81 cd 0a 2a
L_0D84:  LXI  H,3E93h             ; 0D84 21 93 3e
L_0D87:  CALL L_0E4D              ; 0D87 cd 4d 0e
L_0D8A:  MOV  B,M                 ; 0D8A 46
L_0D8B:  LDA  0B69Dh              ; 0D8B 3a 9d b6
L_0D8E:  MOV  C,A                 ; 0D8E 4f
L_0D8F:  LXI  H,0000h             ; 0D8F 21 00 00
L_0D92:  DAD  SP                  ; 0D92 39
L_0D93:  SHLD 0DEDh               ; 0D93 22 ed 0d
L_0D96:  LXI  SP,00B0h            ; 0D96 31 b0 00
L_0D99:  XRA  A                   ; 0D99 af
L_0D9A:  OUT  10h                 ; 0D9A d3 10
L_0D9C:  MOV  A,B                 ; 0D9C 78
L_0D9D:  DCR  C                   ; 0D9D 0d
L_0D9E:  JZ   L_0DC0              ; 0D9E ca c0 0d
L_0DA1:  MVI  H,0D0h              ; 0DA1 26 d0
L_0DA3:  MVI  B,60h               ; 0DA3 06 60
L_0DA5:  CALL L_0DF5              ; 0DA5 cd f5 0d
L_0DA8:  MVI  H,0DEh              ; 0DA8 26 de
L_0DAA:  MVI  B,03h               ; 0DAA 06 03
L_0DAC:  CALL L_0DF5              ; 0DAC cd f5 0d
L_0DAF:  CPI  50h                 ; 0DAF fe 50
L_0DB1:  JZ   L_0DE1              ; 0DB1 ca e1 0d
L_0DB4:  MVI  H,0B5h              ; 0DB4 26 b5
L_0DB6:  MVI  B,80h               ; 0DB6 06 80
L_0DB8:  CALL L_0DF5              ; 0DB8 cd f5 0d
L_0DBB:  MVI  H,0B9h              ; 0DBB 26 b9
L_0DBD:  JMP  L_0DDC              ; 0DBD c3 dc 0d
L_0DC0:  MVI  H,0C1h              ; 0DC0 26 c1
L_0DC2:  MVI  B,60h               ; 0DC2 06 60
L_0DC4:  CALL L_0DF5              ; 0DC4 cd f5 0d
L_0DC7:  MVI  H,0CFh              ; 0DC7 26 cf
L_0DC9:  MVI  B,03h               ; 0DC9 06 03
L_0DCB:  CALL L_0DF5              ; 0DCB cd f5 0d
L_0DCE:  CPI  50h                 ; 0DCE fe 50
L_0DD0:  JZ   L_0DF0              ; 0DD0 ca f0 0d
L_0DD3:  MVI  H,0A6h              ; 0DD3 26 a6
L_0DD5:  MVI  B,80h               ; 0DD5 06 80
L_0DD7:  CALL L_0DF5              ; 0DD7 cd f5 0d
L_0DDA:  MVI  H,0AAh              ; 0DDA 26 aa
L_0DDC:  MVI  B,01h               ; 0DDC 06 01
L_0DDE:  JMP  L_0DE5              ; 0DDE c3 e5 0d
L_0DE1:  MVI  H,0B7h              ; 0DE1 26 b7
L_0DE3:  MVI  B,14h               ; 0DE3 06 14
L_0DE5:  CALL L_0DF5              ; 0DE5 cd f5 0d
L_0DE8:  MVI  A,23h               ; 0DE8 3e 23
L_0DEA:  OUT  10h                 ; 0DEA d3 10
L_0DEC:  LXI  SP,0000h            ; 0DEC 31 00 00
L_0DEF:  RET                      ; 0DEF c9
L_0DF0:  MVI  H,0A8h              ; 0DF0 26 a8
L_0DF2:  JMP  L_0DE3              ; 0DF2 c3 e3 0d
L_0DF5:  MVI  L,20h               ; 0DF5 2e 20
L_0DF7:  MVI  C,0CFh              ; 0DF7 0e cf
L_0DF9:  MOV  M,B                 ; 0DF9 70
L_0DFA:  INX  H                   ; 0DFA 23
L_0DFB:  DCR  C                   ; 0DFB 0d
L_0DFC:  JNZ  L_0DF9              ; 0DFC c2 f9 0d
L_0DFF:  RET                      ; 0DFF c9
L_0E00:  PUSH H                   ; 0E00 e5
L_0E01:  XCHG                     ; 0E01 eb
L_0E02:  LXI  D,0FF9Ch            ; 0E02 11 9c ff
L_0E05:  MVI  C,30h               ; 0E05 0e 30
L_0E07:  INR  C                   ; 0E07 0c
L_0E08:  DAD  D                   ; 0E08 19
L_0E09:  JC   L_0E07              ; 0E09 da 07 0e
L_0E0C:  LXI  D,0064h             ; 0E0C 11 64 00
L_0E0F:  DAD  D                   ; 0E0F 19
L_0E10:  DCR  C                   ; 0E10 0d
L_0E11:  MOV  A,L                 ; 0E11 7d
L_0E12:  POP  H                   ; 0E12 e1
L_0E13:  MOV  M,C                 ; 0E13 71
L_0E14:  PUSH H                   ; 0E14 e5
L_0E15:  JMP  L_0E21              ; 0E15 c3 21 0e
L_0E18:  LXI  H,10C3h             ; 0E18 21 c3 10
L_0E1B:  PUSH H                   ; 0E1B e5
L_0E1C:  MVI  B,64h               ; 0E1C 06 64
L_0E1E:  CALL L_0E3C              ; 0E1E cd 3c 0e
L_0E21:  MVI  B,0Ah               ; 0E21 06 0a
L_0E23:  INX  H                   ; 0E23 23
L_0E24:  CALL L_0E3C              ; 0E24 cd 3c 0e
L_0E27:  MVI  B,01h               ; 0E27 06 01
L_0E29:  INX  H                   ; 0E29 23
L_0E2A:  CALL L_0E3C              ; 0E2A cd 3c 0e
L_0E2D:  POP  H                   ; 0E2D e1
L_0E2E:  MVI  C,02h               ; 0E2E 0e 02
L_0E30:  MOV  A,M                 ; 0E30 7e
L_0E31:  CPI  30h                 ; 0E31 fe 30
L_0E33:  RNZ                      ; 0E33 c0
L_0E34:  MVI  M,20h               ; 0E34 36 20
L_0E36:  INX  H                   ; 0E36 23
L_0E37:  DCR  C                   ; 0E37 0d
L_0E38:  JNZ  L_0E30              ; 0E38 c2 30 0e
L_0E3B:  RET                      ; 0E3B c9
L_0E3C:  MVI  C,30h               ; 0E3C 0e 30
L_0E3E:  SUB  B                   ; 0E3E 90
L_0E3F:  INR  C                   ; 0E3F 0c
L_0E40:  JNC  L_0E3E              ; 0E40 d2 3e 0e
L_0E43:  ADD  B                   ; 0E43 80
L_0E44:  DCR  C                   ; 0E44 0d
L_0E45:  MOV  M,C                 ; 0E45 71
L_0E46:  RET                      ; 0E46 c9
L_0E47:  CALL L_0E4D              ; 0E47 cd 4d 0e
L_0E4A:  JMP  L_0E4D              ; 0E4A c3 4d 0e
L_0E4D:  LDA  0B69Dh              ; 0E4D 3a 9d b6
L_0E50:  DCR  A                   ; 0E50 3d
L_0E51:  RZ                       ; 0E51 c8
L_0E52:  INX  H                   ; 0E52 23
L_0E53:  RET                      ; 0E53 c9
L_0E54:  LDA  0B69Dh              ; 0E54 3a 9d b6
L_0E57:  MOV  B,A                 ; 0E57 47
L_0E58:  XRA  A                   ; 0E58 af
L_0E59:  ADI  28h                 ; 0E59 c6 28
L_0E5B:  DCR  B                   ; 0E5B 05
L_0E5C:  JNZ  L_0E59              ; 0E5C c2 59 0e
L_0E5F:  ADI  15h                 ; 0E5F c6 15
L_0E61:  STA  L_110D              ; 0E61 32 0d 11
L_0E64:  LXI  H,110Ah             ; 0E64 21 0a 11
L_0E67:  RST  3                   ; 0E67 df
L_0E68:  LXI  H,0A943h            ; 0E68 21 43 a9
L_0E6B:  CALL L_0E47              ; 0E6B cd 47 0e
L_0E6E:  MOV  A,M                 ; 0E6E 7e
L_0E6F:  CPI  00h                 ; 0E6F fe 00
L_0E71:  JZ   L_0E8E              ; 0E71 ca 8e 0e
L_0E74:  LXI  H,1111h             ; 0E74 21 11 11
L_0E77:  CALL L_0E1B              ; 0E77 cd 1b 0e
L_0E7A:  LXI  H,0A947h            ; 0E7A 21 47 a9
L_0E7D:  CALL L_0E47              ; 0E7D cd 47 0e
L_0E80:  MOV  E,M                 ; 0E80 5e
L_0E81:  INX  H                   ; 0E81 23
L_0E82:  MOV  D,M                 ; 0E82 56
L_0E83:  LXI  H,1115h             ; 0E83 21 15 11
L_0E86:  CALL L_0E00              ; 0E86 cd 00 0e
L_0E89:  LXI  H,110Fh             ; 0E89 21 0f 11
L_0E8C:  RST  3                   ; 0E8C df
L_0E8D:  RET                      ; 0E8D c9
L_0E8E:  MVI  A,08h               ; 0E8E 3e 08
L_0E90:  JMP  L_0F7F              ; 0E90 c3 7f 0f
L_0E93:  LXI  H,0B681h            ; 0E93 21 81 b6
         CALL L_0E47              ; 0E96 cd 47 0e
         MVI  M,00h               ; 0E99 36 00
         CALL L_091B              ; 0E9B cd 1b 09
         LXI  H,3E91h             ; 0E9E 21 91 3e
         MOV  A,M                 ; 0EA1 7e
         INX  H                   ; 0EA2 23
         CMP  M                   ; 0EA3 be
         CZ   L_0FCA              ; 0EA4 cc ca 0f
         CALL L_0C7E              ; 0EA7 cd 7e 0c
         MVI  A,01h               ; 0EAA 3e 01
         STA  0B69Bh              ; 0EAC 32 9b b6
         CALL L_0CD9              ; 0EAF cd d9 0c
         JMP  L_0FE0              ; 0EB2 c3 e0 0f
L_0EB5:  LXI  H,3E91h             ; 0EB5 21 91 3e
L_0EB8:  CALL L_0E4D              ; 0EB8 cd 4d 0e
L_0EBB:  MOV  A,M                 ; 0EBB 7e
L_0EBC:  STA  L_10E8              ; 0EBC 32 e8 10
L_0EBF:  LXI  H,0A887h            ; 0EBF 21 87 a8
L_0EC2:  CALL L_0E4D              ; 0EC2 cd 4d 0e
L_0EC5:  MOV  A,M                 ; 0EC5 7e
L_0EC6:  ADI  30h                 ; 0EC6 c6 30
L_0EC8:  CPI  3Ah                 ; 0EC8 fe 3a
L_0ECA:  JC   L_0ECF              ; 0ECA da cf 0e
         ADI  07h                 ; 0ECD c6 07
L_0ECF:  CPI  30h                 ; 0ECF fe 30
L_0ED1:  JNZ  L_0ED6              ; 0ED1 c2 d6 0e
L_0ED4:  MVI  A,20h               ; 0ED4 3e 20
L_0ED6:  STA  L_10E7              ; 0ED6 32 e7 10
L_0ED9:  LXI  H,0B689h            ; 0ED9 21 89 b6
L_0EDC:  CALL L_0E47              ; 0EDC cd 47 0e
L_0EDF:  MOV  A,M                 ; 0EDF 7e
L_0EE0:  PUSH PSW                 ; 0EE0 f5
L_0EE1:  LXI  H,0A88Ah            ; 0EE1 21 8a a8
L_0EE4:  CALL L_0E4D              ; 0EE4 cd 4d 0e
L_0EE7:  MOV  C,M                 ; 0EE7 4e
L_0EE8:  POP  PSW                 ; 0EE8 f1
L_0EE9:  SUB  C                   ; 0EE9 91
L_0EEA:  LXI  H,10F1h             ; 0EEA 21 f1 10
L_0EED:  CALL L_0E1B              ; 0EED cd 1b 0e
L_0EF0:  LXI  H,3E95h             ; 0EF0 21 95 3e
L_0EF3:  CALL L_0E4D              ; 0EF3 cd 4d 0e
L_0EF6:  MOV  A,M                 ; 0EF6 7e
L_0EF7:  ANI  0Fh                 ; 0EF7 e6 0f
L_0EF9:  CPI  01h                 ; 0EF9 fe 01
L_0EFB:  JZ   L_0F13              ; 0EFB ca 13 0f
         LXI  H,0B67Dh            ; 0EFE 21 7d b6
         CALL L_0E47              ; 0F01 cd 47 0e
         MOV  A,M                 ; 0F04 7e
         LXI  H,10F4h             ; 0F05 21 f4 10
         CALL L_0E1B              ; 0F08 cd 1b 0e
         MVI  A,2Bh               ; 0F0B 3e 2b
         STA  L_10F4              ; 0F0D 32 f4 10
         JMP  L_0F20              ; 0F10 c3 20 0f
L_0F13:  LXI  H,10F4h             ; 0F13 21 f4 10
L_0F16:  MVI  A,20h               ; 0F16 3e 20
L_0F18:  MVI  C,03h               ; 0F18 0e 03
L_0F1A:  MOV  M,A                 ; 0F1A 77
L_0F1B:  INX  H                   ; 0F1B 23
L_0F1C:  DCR  C                   ; 0F1C 0d
L_0F1D:  JNZ  L_0F1A              ; 0F1D c2 1a 0f
L_0F20:  LXI  H,0B685h            ; 0F20 21 85 b6
L_0F23:  CALL L_0E47              ; 0F23 cd 47 0e
L_0F26:  MOV  E,M                 ; 0F26 5e
L_0F27:  INX  H                   ; 0F27 23
L_0F28:  MOV  D,M                 ; 0F28 56
L_0F29:  LXI  H,1102h             ; 0F29 21 02 11
L_0F2C:  CALL L_0E00              ; 0F2C cd 00 0e
L_0F2F:  LXI  H,10E1h             ; 0F2F 21 e1 10
L_0F32:  RST  3                   ; 0F32 df
L_0F33:  LXI  H,0B689h            ; 0F33 21 89 b6
L_0F36:  CALL L_0E47              ; 0F36 cd 47 0e
L_0F39:  XRA  A                   ; 0F39 af
L_0F3A:  CMP  M                   ; 0F3A be
L_0F3B:  RNZ                      ; 0F3B c0
L_0F3C:  LXI  H,0B685h            ; 0F3C 21 85 b6
L_0F3F:  CALL L_0E47              ; 0F3F cd 47 0e
L_0F42:  XRA  A                   ; 0F42 af
L_0F43:  CMP  M                   ; 0F43 be
L_0F44:  RNZ                      ; 0F44 c0
L_0F45:  INX  H                   ; 0F45 23
L_0F46:  CMP  M                   ; 0F46 be
L_0F47:  RNZ                      ; 0F47 c0
L_0F48:  LDA  0B69Dh              ; 0F48 3a 9d b6
L_0F4B:  MOV  C,A                 ; 0F4B 4f
L_0F4C:  MVI  A,06h               ; 0F4C 3e 06
L_0F4E:  ADI  28h                 ; 0F4E c6 28
L_0F50:  DCR  C                   ; 0F50 0d
L_0F51:  JNZ  L_0F4E              ; 0F51 c2 4e 0f
L_0F54:  STA  L_111F              ; 0F54 32 1f 11
L_0F57:  LXI  H,111Ch             ; 0F57 21 1c 11
L_0F5A:  RST  3                   ; 0F5A df
L_0F5B:  RET                      ; 0F5B c9
L_0F5C:  CALL L_0F70              ; 0F5C cd 70 0f
L_0F5F:  MVI  C,20h               ; 0F5F 0e 20
L_0F61:  RST  4                   ; 0F61 e7
L_0F62:  MOV  A,M                 ; 0F62 7e
L_0F63:  CALL L_0E18              ; 0F63 cd 18 0e
L_0F66:  LXI  H,10C3h             ; 0F66 21 c3 10
L_0F69:  RST  3                   ; 0F69 df
L_0F6A:  RET                      ; 0F6A c9
L_0F6B:  MOV  A,M                 ; 0F6B 7e
L_0F6C:  INX  H                   ; 0F6C 23
L_0F6D:  JMP  L_0F75              ; 0F6D c3 75 0f
L_0F70:  LHLD 0A842h              ; 0F70 2a 42 a8
L_0F73:  MVI  A,0Ch               ; 0F73 3e 0c
L_0F75:  MOV  C,M                 ; 0F75 4e
L_0F76:  CALL 0F809h              ; 0F76 cd 09 f8
L_0F79:  INX  H                   ; 0F79 23
L_0F7A:  DCR  A                   ; 0F7A 3d
L_0F7B:  JNZ  L_0F75              ; 0F7B c2 75 0f
L_0F7E:  RET                      ; 0F7E c9
L_0F7F:  MVI  C,8Dh               ; 0F7F 0e 8d
L_0F81:  RST  4                   ; 0F81 e7
L_0F82:  DCR  A                   ; 0F82 3d
L_0F83:  JNZ  L_0F81              ; 0F83 c2 81 0f
L_0F86:  RET                      ; 0F86 c9
         .db 3Ah,9Dh,0B6h,3Dh,0CAh,95h,0Fh,6Fh,26h,00h,22h,91h,0B6h,0C9h,3Eh,02h ; 0F87 |:..=...o&."...>.|
         .db 0C3h,8Eh,0Fh                                     ; 0F97 |...|
L_0F9A:  LXI  H,1135h             ; 0F9A 21 35 11
L_0F9D:  RST  3                   ; 0F9D df
L_0F9E:  LDA  0B68Fh              ; 0F9E 3a 8f b6
L_0FA1:  DCR  A                   ; 0FA1 3d
L_0FA2:  JZ   L_0FB1              ; 0FA2 ca b1 0f
L_0FA5:  LXI  H,113Ah             ; 0FA5 21 3a 11
L_0FA8:  MVI  A,01h               ; 0FA8 3e 01
L_0FAA:  STA  0B68Fh              ; 0FAA 32 8f b6
L_0FAD:  RST  3                   ; 0FAD df
L_0FAE:  JMP  L_0FF3              ; 0FAE c3 f3 0f
L_0FB1:  LXI  H,118Eh             ; 0FB1 21 8e 11
L_0FB4:  MVI  A,02h               ; 0FB4 3e 02
L_0FB6:  JMP  L_0FAA              ; 0FB6 c3 aa 0f
         .db 21h,63h,0B6h,11h,0Bh,00h,19h,7Eh,0E6h,7Fh,77h,23h,7Eh,0E6h,7Fh,77h ; 0FB9 |!c.....~..w#~..w|
         .db 0C9h                                             ; 0FC9 |.|
L_0FCA:  CALL L_0FD0              ; 0FCA cd d0 0f
         CALL L_091B              ; 0FCD cd 1b 09
L_0FD0:  LDA  0B69Dh              ; 0FD0 3a 9d b6
         DCR  A                   ; 0FD3 3d
         JZ   L_0FDB              ; 0FD4 ca db 0f
L_0FD7:  STA  0B69Dh              ; 0FD7 32 9d b6
         RET                      ; 0FDA c9
L_0FDB:  MVI  A,02h               ; 0FDB 3e 02
         JMP  L_0FD7              ; 0FDD c3 d7 0f
L_0FE0:  CALL L_0FF3              ; 0FE0 cd f3 0f
L_0FE3:  MVI  C,20h               ; 0FE3 0e 20
L_0FE5:  MVI  A,47h               ; 0FE5 3e 47
L_0FE7:  JMP  L_0FF0              ; 0FE7 c3 f0 0f
         .db 0CDh,0F3h,0Fh,0Eh,09h,79h                        ; 0FEA |.....y|
L_0FF0:  CALL L_0F81              ; 0FF0 cd 81 0f
L_0FF3:  LXI  H,2337h             ; 0FF3 21 37 23
L_0FF6:  JMP  L_2071              ; 0FF6 c3 71 20
L_0FF9:  LXI  H,3E37h             ; 0FF9 21 37 3e
L_0FFC:  JMP  L_2071              ; 0FFC c3 71 20
L_0FFF:  CALL L_0FF9              ; 0FFF cd f9 0f
L_1002:  MVI  C,09h               ; 1002 0e 09
L_1004:  MVI  A,06h               ; 1004 3e 06
L_1006:  JMP  L_0F81              ; 1006 c3 81 0f
L_1009:  CALL L_13CB              ; 1009 cd cb 13
L_100C:  LXI  H,11E4h             ; 100C 21 e4 11
L_100F:  RST  3                   ; 100F df
L_1010:  LXI  H,0DF14h            ; 1010 21 14 df
L_1013:  MOV  A,M                 ; 1013 7e
L_1014:  INX  H                   ; 1014 23
L_1015:  CALL L_0F75              ; 1015 cd 75 0f
L_1018:  MVI  C,19h               ; 1018 0e 19
L_101A:  RST  4                   ; 101A e7
L_101B:  LDA  L_3E8F              ; 101B 3a 8f 3e
L_101E:  MVI  C,0Eh               ; 101E 0e 0e
L_1020:  CPI  53h                 ; 1020 fe 53
L_1022:  JZ   0F809h              ; 1022 ca 09 f8
L_1025:  INR  C                   ; 1025 0c
L_1026:  CPI  54h                 ; 1026 fe 54
L_1028:  JZ   0F809h              ; 1028 ca 09 f8
L_102B:  LXI  H,11DEh             ; 102B 21 de 11
L_102E:  CPI  38h                 ; 102E fe 38
L_1030:  JZ   0F818h              ; 1030 ca 18 f8
         LXI  H,11E1h             ; 1033 21 e1 11
         RST  3                   ; 1036 df
         RET                      ; 1037 c9
L_1038:  CALL L_0242              ; 1038 cd 42 02
L_103B:  MVI  A,43h               ; 103B 3e 43
L_103D:  STA  0B673h              ; 103D 32 73 b6
L_1040:  MVI  A,01h               ; 1040 3e 01
L_1042:  STA  0B68Dh              ; 1042 32 8d b6
L_1045:  CALL L_12A7              ; 1045 cd a7 12
L_1048:  LDA  0B68Dh              ; 1048 3a 8d b6
L_104B:  ORA  A                   ; 104B b7
L_104C:  RZ                       ; 104C c8
L_104D:  MVI  A,41h               ; 104D 3e 41
L_104F:  STA  0B673h              ; 104F 32 73 b6
L_1052:  CALL L_12A7              ; 1052 cd a7 12
L_1055:  LDA  0B68Dh              ; 1055 3a 8d b6
L_1058:  ORA  A                   ; 1058 b7
L_1059:  RZ                       ; 1059 c8
L_105A:  LDA  3E97h               ; 105A 3a 97 3e
L_105D:  CPI  59h                 ; 105D fe 59
L_105F:  CZ   L_107E              ; 105F cc 7e 10
L_1062:  LDA  0B68Dh              ; 1062 3a 8d b6
L_1065:  ORA  A                   ; 1065 b7
L_1066:  RZ                       ; 1066 c8
L_1067:  CALL L_0FF3              ; 1067 cd f3 0f
L_106A:  LXI  H,1086h             ; 106A 21 86 10
L_106D:  RST  3                   ; 106D df
L_106E:  LXI  H,0B663h            ; 106E 21 63 b6
L_1071:  CALL L_0F73              ; 1071 cd 73 0f
L_1074:  LXI  H,108Ch             ; 1074 21 8c 10
L_1077:  RST  3                   ; 1077 df
L_1078:  CALL L_0D44              ; 1078 cd 44 0d
L_107B:  JMP  L_0FE0              ; 107B c3 e0 0f
L_107E:  MVI  A,42h               ; 107E 3e 42
L_1080:  STA  0B673h              ; 1080 32 73 b6
L_1083:  JMP  L_12A7              ; 1083 c3 a7 12
         .db 0E6h,0C1h,0CAh,0CCh,20h,00h,20h,0CEh,0C5h,20h,0CEh,0C1h,0CAh,0C4h,0C5h,0CEh ; 1086 |.... . .. ......|
         .db 00h,1Bh,62h,00h,1Bh,61h,00h,1Bh,59h,37h,20h      ; 1096 |..b..a..Y7 |
L_10A1:  .db 55h                                              ; 10A1 |U|
L_10A2:  .db 58h,3Eh,00h,0EBh,0CFh,0D0h,0C9h,0D2h,0D5h,0C5h,0D4h,0D3h,0D1h,00h,00h,00h ; 10A2 |X>..............|
         .db 2Dh,0CAh,20h,0C6h,0C1h,0CAh,0CCh,20h             ; 10B2 |-. .... |
L_10BA:  .db 58h,3Ah,3Dh,3Eh                                  ; 10BA |X:=>|
L_10BE:  .db 59h,3Ah,08h,08h,00h,00h,00h,00h,4Bh,00h,18h,00h,00h,00h,4Bh,18h ; 10BE |Y:......K.....K.|
         .db 18h,1Bh,59h                                      ; 10CE |..Y|
L_10D1:  .db 22h                                              ; 10D1 |"|
L_10D2:  .db 00h,00h,08h,1Ah,00h,3Ah,09h,55h,73h,65h,72h,20h  ; 10D2 |.....:.User |
L_10DE:  .db 58h,08h,00h,20h,0E4h,0C9h,0D3h,0CBh,20h          ; 10DE |X.. .... |
L_10E7:  .db 00h                                              ; 10E7 |.|
L_10E8:  .db 00h,20h,0E6h,0C1h,0CAh,0CCh,0CFh,0D7h,20h,00h,00h,00h ; 10E8 |. ...... ...|
L_10F4:  .db 00h,00h,00h,20h,20h,0F3h,0D7h,0CFh,0C2h,0CFh,0C4h,0CEh,0CFh,20h,00h,00h ; 10F4 |...  ........ ..|
         .db 00h,20h,0EBh,0C2h,2Eh,00h,1Bh,59h,36h            ; 1104 |. .....Y6|
L_110D:  .db 00h,00h,1Bh,62h,00h,00h,00h,2Fh,00h,00h,00h,20h,1Bh,61h,00h,1Bh ; 110D |...b.../... .a..|
         .db 59h,28h                                          ; 111D |Y(|
L_111F:  .db 20h,1Bh,62h,20h,0E4h,0C9h,0D3h,0CBh,20h,45h,72h,72h,6Fh,72h,20h,1Bh ; 111F | .b .... Error .|
         .db 61h,1Bh,59h,20h,48h,00h,1Bh,59h,38h,20h,00h,1Bh,62h,31h,2Dh,0F0h ; 112F |a.Y H..Y8 ..b1-.|
         .db 0CFh,0CDh,0CFh,0DDh,0D8h,20h,32h,2Dh,0EDh,0C5h,0CEh,0C0h,20h,33h,2Dh,0F0h ; 113F |..... 2-.... 3-.|
         .db 0D2h,0CFh,0D3h,0CDh,2Eh,34h,2Dh,0EDh,65h,64h,69h,74h,20h,35h,2Dh,0EBh ; 114F |.....4-.edit 5-.|
         .db 0CFh,0D0h,0C9h,0D1h,20h,36h,2Dh,0E9h,0CDh,0D1h,20h,37h,2Dh,0E4h,0C9h,0D3h ; 115F |.... 6-... 7-...|
         .db 0CBh,20h,38h,2Dh,0F5h,0C2h,0D2h,0C1h,0D4h,0D8h,20h,39h,2Dh,53h,79h,73h ; 116F |. 8-...... 9-Sys|
         .db 2Eh,0D0h,0D2h,0CDh,20h,30h,2Dh,0EDh,0CFh,0CEh,0C9h,0D4h,1Bh,61h,00h,31h ; 117F |.... 0-......a.1|
         .db 2Dh,34h,30h,2Fh,36h,30h,20h,32h,2Dh,0E1h,0D4h,0D2h,0C9h,0C2h,2Eh,33h ; 118F |-40/60 2-......3|
         .db 2Dh,0F0h,0D2h,0EBh,37h,20h,34h,2Dh,57h,6Fh,72h,64h,53h,74h,61h,72h ; 119F |-...7 4-WordStar|
         .db 20h,35h,2Dh,0EBh,0D3h,0FAh,0E9h,20h,36h,2Dh,0FAh,0C1h,0D0h,0C9h,0D3h,0D8h ; 11AF | 5-.... 6-......|
         .db 20h,37h,2Dh,0F0h,0C5h,0DEh,0C1h,0D4h,0D8h,20h,38h,2Dh,0E6h,0C1h,0CAh,0CCh ; 11BF | 7-...... 8-....|
         .db 20h,39h,2Dh,53h,69h,64h,20h,30h,2Dh,0F7h,0D9h,0CAh,0D4h,0C9h,00h,1Bh ; 11CF | 9-Sid 0-.......|
         .db 5Bh,00h,1Bh,5Ch,00h,0Ch,0Ah,20h,3Eh,00h,1Bh,59h,37h,2Dh,00h,00h ; 11DF |[..\... >..Y7-..|
         .db 00h,00h                                          ; 11EF |..|
L_11F1:  LXI  H,0000h             ; 11F1 21 00 00
L_11F4:  SHLD 0A831h              ; 11F4 22 31 a8
L_11F7:  LDA  0B69Bh              ; 11F7 3a 9b b6
L_11FA:  PUSH PSW                 ; 11FA f5
L_11FB:  LXI  H,0B689h            ; 11FB 21 89 b6
L_11FE:  CALL L_0E47              ; 11FE cd 47 0e
L_1201:  MOV  A,M                 ; 1201 7e
L_1202:  MVI  C,00h               ; 1202 0e 00
L_1204:  STA  0B69Bh              ; 1204 32 9b b6
L_1207:  CALL L_29DF              ; 1207 cd df 29
L_120A:  LXI  D,0008h             ; 120A 11 08 00
L_120D:  DAD  D                   ; 120D 19
L_120E:  MVI  A,7Fh               ; 120E 3e 7f
L_1210:  CMP  M                   ; 1210 be
L_1211:  CZ   L_1238              ; 1211 cc 38 12
L_1214:  LDA  0B69Bh              ; 1214 3a 9b b6
L_1217:  DCR  A                   ; 1217 3d
L_1218:  JNZ  L_1204              ; 1218 c2 04 12
L_121B:  POP  PSW                 ; 121B f1
L_121C:  STA  0B69Bh              ; 121C 32 9b b6
L_121F:  LXI  H,0A943h            ; 121F 21 43 a9
L_1222:  PUSH B                   ; 1222 c5
L_1223:  CALL L_0E47              ; 1223 cd 47 0e
L_1226:  POP  B                   ; 1226 c1
L_1227:  MOV  M,C                 ; 1227 71
L_1228:  LHLD 0A831h              ; 1228 2a 31 a8
L_122B:  XCHG                     ; 122B eb
L_122C:  LXI  H,0A947h            ; 122C 21 47 a9
L_122F:  PUSH D                   ; 122F d5
L_1230:  CALL L_0E47              ; 1230 cd 47 0e
L_1233:  POP  D                   ; 1233 d1
L_1234:  MOV  M,E                 ; 1234 73
L_1235:  INX  H                   ; 1235 23
L_1236:  MOV  M,D                 ; 1236 72
L_1237:  RET                      ; 1237 c9
L_1238:  INR  C                   ; 1238 0c
L_1239:  LXI  D,0004h             ; 1239 11 04 00
L_123C:  DAD  D                   ; 123C 19
L_123D:  MOV  E,M                 ; 123D 5e
L_123E:  MVI  D,00h               ; 123E 16 00
L_1240:  LHLD 0A831h              ; 1240 2a 31 a8
L_1243:  DAD  D                   ; 1243 19
L_1244:  SHLD 0A831h              ; 1244 22 31 a8
L_1247:  RET                      ; 1247 c9
L_1248:  LHLD 0A838h              ; 1248 2a 38 a8
L_124B:  SPHL                     ; 124B f9
L_124C:  LHLD 0A83Ah              ; 124C 2a 3a a8
L_124F:  SHLD 0F80Ah              ; 124F 22 0a f8
L_1252:  MVI  A,0FFh              ; 1252 3e ff
L_1254:  CPI  0FFh                ; 1254 fe ff
L_1256:  RET                      ; 1256 c9
L_1257:  LXI  D,0080h             ; 1257 11 80 00
L_125A:  MVI  C,1Ah               ; 125A 0e 1a
L_125C:  RST  1                   ; 125C cf
L_125D:  RET                      ; 125D c9
L_125E:  LDA  0A889h              ; 125E 3a 89 a8
L_1261:  CPI  00h                 ; 1261 fe 00
L_1263:  JZ   L_124C              ; 1263 ca 4c 12
         MVI  E,00h               ; 1266 1e 00
         CALL L_13D7              ; 1268 cd d7 13
         CALL L_1257              ; 126B cd 57 12
         MVI  C,11h               ; 126E 0e 11
         CALL L_19AD              ; 1270 cd ad 19
         LHLD 0A83Ah              ; 1273 2a 3a a8
         SHLD 0F80Ah              ; 1276 22 0a f8
         CPI  0FFh                ; 1279 fe ff
         JZ   L_129D              ; 127B ca 9d 12
         PUSH PSW                 ; 127E f5
         INR  A                   ; 127F 3c
         MOV  C,A                 ; 1280 4f
         XRA  A                   ; 1281 af
         MOV  B,A                 ; 1282 47
L_1283:  ADI  20h                 ; 1283 c6 20
         DCR  C                   ; 1285 0d
         JNZ  L_1283              ; 1286 c2 83 12
         ADI  6Ah                 ; 1289 c6 6a
         MOV  C,A                 ; 128B 4f
         LDAX B                   ; 128C 0a
         ANI  80h                 ; 128D e6 80
         PUSH PSW                 ; 128F f5
         CALL L_13D3              ; 1290 cd d3 13
         POP  PSW                 ; 1293 f1
         CPI  00h                 ; 1294 fe 00
         JZ   L_12A3              ; 1296 ca a3 12
         POP  PSW                 ; 1299 f1
         JMP  L_12D0              ; 129A c3 d0 12
L_129D:  PUSH PSW                 ; 129D f5
         CALL L_13D3              ; 129E cd d3 13
         POP  PSW                 ; 12A1 f1
         RET                      ; 12A2 c9
L_12A3:  POP  PSW                 ; 12A3 f1
         JMP  L_124C              ; 12A4 c3 4c 12
L_12A7:  LXI  H,0000h             ; 12A7 21 00 00
L_12AA:  DAD  SP                  ; 12AA 39
L_12AB:  SHLD 0A838h              ; 12AB 22 38 a8
L_12AE:  LHLD 0F80Ah              ; 12AE 2a 0a f8
L_12B1:  SHLD 0A83Ah              ; 12B1 22 3a a8
L_12B4:  LXI  H,1248h             ; 12B4 21 48 12
L_12B7:  SHLD 0F80Ah              ; 12B7 22 0a f8
L_12BA:  LXI  H,0B663h            ; 12BA 21 63 b6
L_12BD:  CALL L_19BB              ; 12BD cd bb 19
L_12C0:  MVI  C,11h               ; 12C0 0e 11
L_12C2:  CALL L_19AD              ; 12C2 cd ad 19
L_12C5:  CPI  0FFh                ; 12C5 fe ff
L_12C7:  JZ   L_125E              ; 12C7 ca 5e 12
L_12CA:  LHLD 0A83Ah              ; 12CA 2a 3a a8
L_12CD:  SHLD 0F80Ah              ; 12CD 22 0a f8
L_12D0:  XRA  A                   ; 12D0 af
L_12D1:  STA  0B68Dh              ; 12D1 32 8d b6
L_12D4:  LXI  H,353Bh             ; 12D4 21 3b 35
L_12D7:  JMP  L_19BB              ; 12D7 c3 bb 19
         .db 21h,00h,00h,22h,83h,0A8h,0CDh,57h,12h,0CDh,0DFh,29h,21h,91h,3Eh,0CDh ; 12DA |!.."...W...)!.>.|
         .db 4Dh,0Eh,7Eh,32h,73h,0B6h,0CDh,0B8h,19h,3Eh,3Fh,32h,68h,00h,0Eh,11h ; 12EA |M.~2s....>?2h...|
         .db 0C3h,0FFh,12h,0Eh,12h,0CDh,0ADh,19h,0FEh,0FFh,0CAh,22h,13h,3Ch,4Fh,0AFh ; 12FA |...........".<O.|
         .db 47h,0C6h,20h,0Dh,0C2h,0Bh,13h,0C6h,6Fh,4Fh,0Ah,4Fh,2Ah,83h,0A8h,09h ; 130A |G. .....oO.O*...|
         .db 22h,83h,0A8h,0FEh,80h,0CAh,0FDh,12h              ; 131A |".......|
L_1322:  LHLD 0A883h              ; 1322 2a 83 a8
         CALL L_1345              ; 1325 cd 45 13
         LHLD 0A842h              ; 1328 2a 42 a8
         LXI  D,000Ch             ; 132B 11 0c 00
         DAD  D                   ; 132E 19
         MOV  A,M                 ; 132F 7e
         LXI  H,1F52h             ; 1330 21 52 1f
         CALL L_0E1B              ; 1333 cd 1b 0e
         LXI  H,1F42h             ; 1336 21 42 1f
         CALL L_0D13              ; 1339 cd 13 0d
         CALL L_0D13              ; 133C cd 13 0d
         CALL L_0D44              ; 133F cd 44 0d
         JMP  L_0FE0              ; 1342 c3 e0 0f
L_1345:  DAD  H                   ; 1345 29
         DAD  H                   ; 1346 29
         DAD  H                   ; 1347 29
         DAD  H                   ; 1348 29
         LXI  D,0CF2Ch            ; 1349 11 2c cf
         CALL L_3441              ; 134C cd 41 34
         STA  L_1F42              ; 134F 32 42 1f
         LXI  D,0FB1Eh            ; 1352 11 1e fb
         CALL L_3441              ; 1355 cd 41 34
         STA  L_1F43              ; 1358 32 43 1f
         LXI  D,0FF83h            ; 135B 11 83 ff
         CALL L_3441              ; 135E cd 41 34
         STA  L_1F44              ; 1361 32 44 1f
         DAD  H                   ; 1364 29
         DAD  H                   ; 1365 29
         DAD  H                   ; 1366 29
         LXI  D,0FF9Ch            ; 1367 11 9c ff
         CALL L_3441              ; 136A cd 41 34
         STA  L_1F46              ; 136D 32 46 1f
         LXI  D,0FFF6h            ; 1370 11 f6 ff
         CALL L_3441              ; 1373 cd 41 34
         STA  L_1F47              ; 1376 32 47 1f
         LXI  D,0FFFFh            ; 1379 11 ff ff
         CALL L_3441              ; 137C cd 41 34
         STA  L_1F48              ; 137F 32 48 1f
         LXI  H,1F42h             ; 1382 21 42 1f
L_1385:  MOV  A,M                 ; 1385 7e
         CPI  30h                 ; 1386 fe 30
         RNZ                      ; 1388 c0
         MVI  M,20h               ; 1389 36 20
         INX  H                   ; 138B 23
         JMP  L_1385              ; 138C c3 85 13
         .db 0CDh,73h,14h,3Ah,51h,0A8h,3Dh,0C2h,0ACh,13h,3Eh,0Eh,0C3h,0ACh,13h,0CDh ; 138F |.s.:Q.=...>.....|
         .db 73h,14h,3Ah,51h,0A8h,3Ch,0FEh,0Fh,0C2h,0ACh,13h,3Eh,01h ; 139F |s.:Q.<.....>.|
L_13AC:  STA  0A851h              ; 13AC 32 51 a8
         LXI  H,0000h             ; 13AF 21 00 00
         LXI  D,0048h             ; 13B2 11 48 00
L_13B5:  DAD  D                   ; 13B5 19
         DCR  A                   ; 13B6 3d
         JNZ  L_13B5              ; 13B7 c2 b5 13
         LXI  D,0A010h            ; 13BA 11 10 a0
         DAD  D                   ; 13BD 19
         PUSH H                   ; 13BE e5
         LXI  D,0DF14h            ; 13BF 11 14 df
         MVI  C,47h               ; 13C2 0e 47
         RST  5                   ; 13C4 ef
         POP  H                   ; 13C5 e1
L_13C6:  MOV  A,M                 ; 13C6 7e
         INX  H                   ; 13C7 23
         JMP  L_2A02              ; 13C8 c3 02 2a
L_13CB:  MVI  E,00h               ; 13CB 1e 00
L_13CD:  CALL L_13D7              ; 13CD cd d7 13
L_13D0:  CALL L_13DB              ; 13D0 cd db 13
L_13D3:  LDA  0A889h              ; 13D3 3a 89 a8
L_13D6:  MOV  E,A                 ; 13D6 5f
L_13D7:  MVI  C,20h               ; 13D7 0e 20
L_13D9:  RST  1                   ; 13D9 cf
L_13DA:  RET                      ; 13DA c9
L_13DB:  LDA  0B672h              ; 13DB 3a 72 b6
L_13DE:  CPI  59h                 ; 13DE fe 59
L_13E0:  JNZ  L_1409              ; 13E0 c2 09 14
         MVI  A,43h               ; 13E3 3e 43
         STA  0B673h              ; 13E5 32 73 b6
         LXI  H,1F66h             ; 13E8 21 66 1f
         SHLD 0A842h              ; 13EB 22 42 a8
         CALL L_19B8              ; 13EE cd b8 19
         LXI  H,0DF14h            ; 13F1 21 14 df
         MOV  A,M                 ; 13F4 7e
         MOV  E,A                 ; 13F5 5f
         MVI  D,00h               ; 13F6 16 00
         ADI  09h                 ; 13F8 c6 09
         CPI  46h                 ; 13FA fe 46
         JP   L_1409              ; 13FC f2 09 14
         MOV  M,A                 ; 13FF 77
         DAD  D                   ; 1400 19
         INX  H                   ; 1401 23
         LXI  D,1F72h             ; 1402 11 72 1f
         MVI  C,09h               ; 1405 0e 09
         XCHG                     ; 1407 eb
         RST  5                   ; 1408 ef
L_1409:  CALL L_1473              ; 1409 cd 73 14
L_140C:  LXI  D,0080h             ; 140C 11 80 00
L_140F:  CALL L_17F4              ; 140F cd f4 17
L_1412:  XRA  A                   ; 1412 af
L_1413:  STA  007Ch               ; 1413 32 7c 00
L_1416:  LDA  L_3E91              ; 1416 3a 91 3e
L_1419:  ANI  03h                 ; 1419 e6 03
L_141B:  MOV  C,A                 ; 141B 4f
L_141C:  LDA  0A887h              ; 141C 3a 87 a8
L_141F:  RLC                      ; 141F 07
L_1420:  RLC                      ; 1420 07
L_1421:  ADD  C                   ; 1421 81
L_1422:  STA  L_3E91              ; 1422 32 91 3e
L_1425:  LDA  L_3E92              ; 1425 3a 92 3e
L_1428:  ANI  03h                 ; 1428 e6 03
L_142A:  MOV  C,A                 ; 142A 4f
L_142B:  LDA  0A888h              ; 142B 3a 88 a8
L_142E:  RLC                      ; 142E 07
L_142F:  RLC                      ; 142F 07
L_1430:  ADD  C                   ; 1430 81
L_1431:  STA  L_3E92              ; 1431 32 92 3e
L_1434:  LXI  D,0A000h            ; 1434 11 00 a0
L_1437:  MVI  A,09h               ; 1437 3e 09
L_1439:  STAX D                   ; 1439 12
L_143A:  INX  D                   ; 143A 13
L_143B:  LXI  H,3E8Dh             ; 143B 21 8d 3e
L_143E:  MVI  C,0Bh               ; 143E 0e 0b
L_1440:  RST  5                   ; 1440 ef
L_1441:  LXI  H,1F7Dh             ; 1441 21 7d 1f
L_1444:  MVI  C,03h               ; 1444 0e 03
L_1446:  RST  5                   ; 1446 ef
L_1447:  LDA  0B69Dh              ; 1447 3a 9d b6
L_144A:  STAX D                   ; 144A 12
L_144B:  LXI  D,0A010h            ; 144B 11 10 a0
L_144E:  LXI  H,0DF14h            ; 144E 21 14 df
L_1451:  MVI  C,47h               ; 1451 0e 47
L_1453:  RST  5                   ; 1453 ef
L_1454:  MVI  C,0Fh               ; 1454 0e 0f
L_1456:  CALL L_19AD              ; 1456 cd ad 19
L_1459:  MVI  C,08h               ; 1459 0e 08
L_145B:  LXI  D,0A000h            ; 145B 11 00 a0
L_145E:  LXI  H,0080h             ; 145E 21 80 00
L_1461:  CALL L_17F4              ; 1461 cd f4 17
L_1464:  CALL L_1947              ; 1464 cd 47 19
L_1467:  XCHG                     ; 1467 eb
L_1468:  DAD  D                   ; 1468 19
L_1469:  XCHG                     ; 1469 eb
L_146A:  DCR  C                   ; 146A 0d
L_146B:  JNZ  L_1461              ; 146B c2 61 14
L_146E:  MVI  C,10h               ; 146E 0e 10
L_1470:  JMP  L_19AD              ; 1470 c3 ad 19
L_1473:  MVI  C,10h               ; 1473 0e 10
L_1475:  CALL L_19AD              ; 1475 cd ad 19
L_1478:  MVI  A,43h               ; 1478 3e 43
L_147A:  STA  0B673h              ; 147A 32 73 b6
L_147D:  LXI  H,1F5Ah             ; 147D 21 5a 1f
L_1480:  SHLD 0A842h              ; 1480 22 42 a8
L_1483:  CALL L_19B8              ; 1483 cd b8 19
L_1486:  MVI  C,0Fh               ; 1486 0e 0f
L_1488:  CALL L_19AD              ; 1488 cd ad 19
L_148B:  CPI  0FFh                ; 148B fe ff
L_148D:  RZ                       ; 148D c8
L_148E:  LXI  D,0A048h            ; 148E 11 48 a0
L_1491:  LXI  H,0080h             ; 1491 21 80 00
L_1494:  MVI  C,08h               ; 1494 0e 08
L_1496:  CALL L_17F4              ; 1496 cd f4 17
L_1499:  CALL L_1922              ; 1499 cd 22 19
L_149C:  XCHG                     ; 149C eb
L_149D:  DAD  D                   ; 149D 19
L_149E:  XCHG                     ; 149E eb
L_149F:  DCR  C                   ; 149F 0d
L_14A0:  JNZ  L_1496              ; 14A0 c2 96 14
L_14A3:  MVI  C,10h               ; 14A3 0e 10
L_14A5:  CALL L_19AD              ; 14A5 cd ad 19
L_14A8:  XRA  A                   ; 14A8 af
L_14A9:  RET                      ; 14A9 c9
L_14AA:  MVI  E,00h               ; 14AA 1e 00
L_14AC:  CALL L_13D7              ; 14AC cd d7 13
L_14AF:  CALL L_14B5              ; 14AF cd b5 14
L_14B2:  JMP  L_13D3              ; 14B2 c3 d3 13
L_14B5:  MVI  A,01h               ; 14B5 3e 01
L_14B7:  STA  0A94Eh              ; 14B7 32 4e a9
L_14BA:  LXI  H,000Eh             ; 14BA 21 0e 00
L_14BD:  SHLD 0A851h              ; 14BD 22 51 a8
L_14C0:  MVI  A,4Eh               ; 14C0 3e 4e
L_14C2:  STA  0B672h              ; 14C2 32 72 b6
L_14C5:  CALL L_19E2              ; 14C5 cd e2 19
L_14C8:  CALL L_1473              ; 14C8 cd 73 14
L_14CB:  CPI  0FFh                ; 14CB fe ff
L_14CD:  RZ                       ; 14CD c8
L_14CE:  LXI  H,0A048h            ; 14CE 21 48 a0
L_14D1:  MOV  A,M                 ; 14D1 7e
L_14D2:  CPI  09h                 ; 14D2 fe 09
L_14D4:  RNZ                      ; 14D4 c0
L_14D5:  INX  H                   ; 14D5 23
L_14D6:  LXI  D,3E8Dh             ; 14D6 11 8d 3e
L_14D9:  MVI  C,0Bh               ; 14D9 0e 0b
L_14DB:  RST  5                   ; 14DB ef
L_14DC:  LXI  D,1F7Dh             ; 14DC 11 7d 1f
L_14DF:  MVI  C,03h               ; 14DF 0e 03
L_14E1:  RST  5                   ; 14E1 ef
L_14E2:  MOV  A,M                 ; 14E2 7e
L_14E3:  STA  0A94Eh              ; 14E3 32 4e a9
L_14E6:  XRA  A                   ; 14E6 af
L_14E7:  STA  0A94Fh              ; 14E7 32 4f a9
L_14EA:  LDA  L_3E91              ; 14EA 3a 91 3e
L_14ED:  MOV  C,A                 ; 14ED 4f
L_14EE:  ANI  03h                 ; 14EE e6 03
         ADI  40h                 ; 14F0 c6 40
L_14F2:  STA  L_3E91              ; 14F2 32 91 3e
L_14F5:  MOV  A,C                 ; 14F5 79
L_14F6:  RRC                      ; 14F6 0f
L_14F7:  RRC                      ; 14F7 0f
L_14F8:  ANI  0Fh                 ; 14F8 e6 0f
L_14FA:  STA  0A887h              ; 14FA 32 87 a8
L_14FD:  LDA  L_3E92              ; 14FD 3a 92 3e
L_1500:  MOV  C,A                 ; 1500 4f
L_1501:  ANI  03h                 ; 1501 e6 03
         ADI  40h                 ; 1503 c6 40
L_1505:  STA  L_3E92              ; 1505 32 92 3e
L_1508:  MOV  A,C                 ; 1508 79
L_1509:  RRC                      ; 1509 0f
L_150A:  RRC                      ; 150A 0f
L_150B:  ANI  0Fh                 ; 150B e6 0f
L_150D:  STA  0A888h              ; 150D 32 88 a8
L_1510:  LXI  H,0A887h            ; 1510 21 87 a8
L_1513:  LDA  0A94Eh              ; 1513 3a 4e a9
L_1516:  DCR  A                   ; 1516 3d
L_1517:  JZ   L_151B              ; 1517 ca 1b 15
L_151A:  INX  H                   ; 151A 23
L_151B:  MOV  A,M                 ; 151B 7e
L_151C:  STA  0A889h              ; 151C 32 89 a8
L_151F:  LXI  H,1F7Bh             ; 151F 21 7b 1f
L_1522:  MVI  A,04h               ; 1522 3e 04
L_1524:  JMP  L_2A02              ; 1524 c3 02 2a
L_1527:  CALL L_19B8              ; 1527 cd b8 19
         LDA  0065h               ; 152A 3a 65 00
         ANI  80h                 ; 152D e6 80
         CNZ  L_153F              ; 152F c4 3f 15
         LDA  0066h               ; 1532 3a 66 00
         ANI  80h                 ; 1535 e6 80
         CNZ  L_156D              ; 1537 c4 6d 15
         MVI  C,13h               ; 153A 0e 13
         JMP  L_19AD              ; 153C c3 ad 19
L_153F:  LDA  0065h               ; 153F 3a 65 00
         ANI  7Fh                 ; 1542 e6 7f
         STA  0065h               ; 1544 32 65 00
         CALL L_0FE0              ; 1547 cd e0 0f
         LXI  H,1F80h             ; 154A 21 80 1f
         CALL L_0D13              ; 154D cd 13 0d
         LXI  H,005Dh             ; 1550 21 5d 00
         RST  3                   ; 1553 df
         LXI  H,1F85h             ; 1554 21 85 1f
L_1557:  CALL L_0D13              ; 1557 cd 13 0d
         LXI  H,1F8Fh             ; 155A 21 8f 1f
         CALL L_0D13              ; 155D cd 13 0d
         CALL L_1958              ; 1560 cd 58 19
         JNZ  L_156B              ; 1563 c2 6b 15
         MVI  C,1Eh               ; 1566 0e 1e
         JMP  L_19AD              ; 1568 c3 ad 19
L_156B:  POP  H                   ; 156B e1
         RET                      ; 156C c9
L_156D:  LDA  0066h               ; 156D 3a 66 00
         ANI  7Fh                 ; 1570 e6 7f
         STA  0066h               ; 1572 32 66 00
         CALL L_0FE0              ; 1575 cd e0 0f
         LXI  H,1F80h             ; 1578 21 80 1f
         CALL L_0D13              ; 157B cd 13 0d
         LXI  H,005Dh             ; 157E 21 5d 00
         CALL L_0D13              ; 1581 cd 13 0d
         LXI  H,1F9Fh             ; 1584 21 9f 1f
         JMP  L_1557              ; 1587 c3 57 15
L_158A:  LXI  H,0000h             ; 158A 21 00 00
L_158D:  SHLD 0A83Eh              ; 158D 22 3e a8
L_1590:  CALL L_18E5              ; 1590 cd e5 18
L_1593:  LXI  H,0A000h            ; 1593 21 00 a0
L_1596:  SHLD 0A83Eh              ; 1596 22 3e a8
L_1599:  RET                      ; 1599 c9
L_159A:  LDA  0A849h              ; 159A 3a 49 a8
L_159D:  LHLD 0A84Dh              ; 159D 2a 4d a8
L_15A0:  CALL L_19BE              ; 15A0 cd be 19
L_15A3:  LDA  L_1FAA              ; 15A3 3a aa 1f
L_15A6:  MOV  E,A                 ; 15A6 5f
L_15A7:  CALL L_13D7              ; 15A7 cd d7 13
L_15AA:  MVI  C,16h               ; 15AA 0e 16
L_15AC:  LXI  D,005Ch             ; 15AC 11 5c 00
L_15AF:  RST  1                   ; 15AF cf
L_15B0:  ORA  A                   ; 15B0 b7
L_15B1:  JP   L_15BD              ; 15B1 f2 bd 15
L_15B4:  CALL L_1638              ; 15B4 cd 38 16
L_15B7:  PUSH PSW                 ; 15B7 f5
L_15B8:  CALL L_0FFF              ; 15B8 cd ff 0f
L_15BB:  POP  PSW                 ; 15BB f1
L_15BC:  RNZ                      ; 15BC c0
L_15BD:  XRA  A                   ; 15BD af
         STA  006Ah               ; 15BE 32 6a 00
         CALL L_13D3              ; 15C1 cd d3 13
         LDA  0A84Ah              ; 15C4 3a 4a a8
         SUI  40h                 ; 15C7 d6 40
         STA  0A809h              ; 15C9 32 09 a8
         LHLD 0A84Fh              ; 15CC 2a 4f a8
         LXI  D,0A80Ah            ; 15CF 11 0a a8
         CALL L_19C5              ; 15D2 cd c5 19
L_15D5:  LXI  H,6100h             ; 15D5 21 00 61
         SHLD 17E7h               ; 15D8 22 e7 17
         CALL L_168B              ; 15DB cd 8b 16
         DCR  C                   ; 15DE 0d
         RP                       ; 15DF f0
         LXI  H,6100h             ; 15E0 21 00 61
         SHLD 17E7h               ; 15E3 22 e7 17
         PUSH PSW                 ; 15E6 f5
         CALL L_174F              ; 15E7 cd 4f 17
         DCR  C                   ; 15EA 0d
         RP                       ; 15EB f0
         LXI  D,005Ch             ; 15EC 11 5c 00
         LDA  L_1FAA              ; 15EF 3a aa 1f
         STAX D                   ; 15F2 12
         CALL L_1D7C              ; 15F3 cd 7c 1d
         LXI  H,0068h             ; 15F6 21 68 00
         INR  M                   ; 15F9 34
         INX  H                   ; 15FA 23
         MVI  C,13h               ; 15FB 0e 13
         XRA  A                   ; 15FD af
         CALL L_1E75              ; 15FE cd 75 1e
         POP  PSW                 ; 1601 f1
         ORA  A                   ; 1602 b7
         JM   L_15D5              ; 1603 fa d5 15
         LDA  L_3E90              ; 1606 3a 90 3e
         CPI  59h                 ; 1609 fe 59
         RNZ                      ; 160B c0
         LDA  L_1FAA              ; 160C 3a aa 1f
         MOV  E,A                 ; 160F 5f
         CALL L_13D7              ; 1610 cd d7 13
         LDA  0A849h              ; 1613 3a 49 a8
         STA  005Ch               ; 1616 32 5c 00
         CALL L_0B6B              ; 1619 cd 6b 0b
L_161C:  LXI  H,6100h             ; 161C 21 00 61
         SHLD 17E7h               ; 161F 22 e7 17
         LXI  H,005Ch             ; 1622 21 5c 00
         LDA  0A849h              ; 1625 3a 49 a8
         CALL L_1691              ; 1628 cd 91 16
         DCR  C                   ; 162B 0d
         JC   L_161C              ; 162C da 1c 16
         CALL L_13D3              ; 162F cd d3 13
         LDA  0A84Ah              ; 1632 3a 4a a8
         JMP  L_0B6B              ; 1635 c3 6b 0b
L_1638:  CALL L_196A              ; 1638 cd 6a 19
L_163B:  LXI  H,1FB7h             ; 163B 21 b7 1f
L_163E:  CALL L_1953              ; 163E cd 53 19
L_1641:  RNZ                      ; 1641 c0
         MVI  C,0Fh               ; 1642 0e 0f
         CALL L_19AD              ; 1644 cd ad 19
         MVI  C,10h               ; 1647 0e 10
         CALL L_19AD              ; 1649 cd ad 19
         LDA  0065h               ; 164C 3a 65 00
         ORA  A                   ; 164F b7
         JP   L_1667              ; 1650 f2 67 16
         ANI  7Fh                 ; 1653 e6 7f
         STA  0065h               ; 1655 32 65 00
         CALL L_196A              ; 1658 cd 6a 19
         LXI  H,1F85h             ; 165B 21 85 1f
L_165E:  CALL L_1953              ; 165E cd 53 19
         RNZ                      ; 1661 c0
         MVI  C,1Eh               ; 1662 0e 1e
         CALL L_19AD              ; 1664 cd ad 19
L_1667:  LDA  0066h               ; 1667 3a 66 00
         ORA  A                   ; 166A b7
         JP   L_167C              ; 166B f2 7c 16
         ANI  7Fh                 ; 166E e6 7f
         STA  0066h               ; 1670 32 66 00
         CALL L_196A              ; 1673 cd 6a 19
         LXI  H,1F9Fh             ; 1676 21 9f 1f
         JMP  L_165E              ; 1679 c3 5e 16
L_167C:  MVI  C,13h               ; 167C 0e 13
         CALL L_19AD              ; 167E cd ad 19
         CALL L_1E7C              ; 1681 cd 7c 1e
         MVI  C,16h               ; 1684 0e 16
         CALL L_19AD              ; 1686 cd ad 19
         XRA  A                   ; 1689 af
         RET                      ; 168A c9
L_168B:  LXI  H,0A809h            ; 168B 21 09 a8
         LDA  0A84Ah              ; 168E 3a 4a a8
L_1691:  STA  169Eh               ; 1691 32 9e 16
         MOV  D,H                 ; 1694 54
         MOV  E,L                 ; 1695 5d
         PUSH H                   ; 1696 e5
         MVI  C,0Fh               ; 1697 0e 0f
         RST  1                   ; 1699 cf
         POP  H                   ; 169A e1
         INR  A                   ; 169B 3c
         RZ                       ; 169C c8
         MVI  A,00h               ; 169D 3e 00
         SUI  41h                 ; 169F d6 41
         STA  0DDF0h              ; 16A1 32 f0 dd
         LXI  D,000Fh             ; 16A4 11 0f 00
         DAD  D                   ; 16A7 19
         MOV  A,M                 ; 16A8 7e
         MOV  C,A                 ; 16A9 4f
         ORA  A                   ; 16AA b7
         PUSH H                   ; 16AB e5
         LXI  D,0011h             ; 16AC 11 11 00
         DAD  D                   ; 16AF 19
         CNZ  L_16BD              ; 16B0 c4 bd 16
         POP  H                   ; 16B3 e1
         MOV  A,M                 ; 16B4 7e
         ORA  A                   ; 16B5 b7
         RP                       ; 16B6 f0
         LXI  D,0FFFDh            ; 16B7 11 fd ff
         DAD  D                   ; 16BA 19
         INR  M                   ; 16BB 34
         RET                      ; 16BC c9
L_16BD:  PUSH B                   ; 16BD c5
         PUSH H                   ; 16BE e5
         CALL L_17E6              ; 16BF cd e6 17
         POP  H                   ; 16C2 e1
         PUSH H                   ; 16C3 e5
         MOV  A,M                 ; 16C4 7e
         INR  M                   ; 16C5 34
         ANI  07h                 ; 16C6 e6 07
         JZ   L_1701              ; 16C8 ca 01 17
         LDA  0DDF5h              ; 16CB 3a f5 dd
         INR  A                   ; 16CE 3c
L_16CF:  STA  0DDF5h              ; 16CF 32 f5 dd
         CALL 0C027h              ; 16D2 cd 27 c0
         POP  H                   ; 16D5 e1
         POP  B                   ; 16D6 c1
         ORA  A                   ; 16D7 b7
         JNZ  L_1742              ; 16D8 c2 42 17
         DCR  C                   ; 16DB 0d
         JNZ  L_16BD              ; 16DC c2 bd 16
         RET                      ; 16DF c9
L_16E0:  MOV  A,M                 ; 16E0 7e
         LXI  B,0FFF0h            ; 16E1 01 f0 ff
         DAD  B                   ; 16E4 09
L_16E5:  ANI  78h                 ; 16E5 e6 78
         RRC                      ; 16E7 0f
         RRC                      ; 16E8 0f
         RRC                      ; 16E9 0f
         MOV  C,A                 ; 16EA 4f
         MVI  B,00h               ; 16EB 06 00
         DAD  B                   ; 16ED 09
         RET                      ; 16EE c9
L_16EF:  LDA  0DDF5h              ; 16EF 3a f5 dd
         INR  A                   ; 16F2 3c
         CPI  29h                 ; 16F3 fe 29
         JNZ  L_16CF              ; 16F5 c2 cf 16
         LXI  H,0DDF4h            ; 16F8 21 f4 dd
         INR  M                   ; 16FB 34
         MVI  A,01h               ; 16FC 3e 01
         JMP  L_16CF              ; 16FE c3 cf 16
L_1701:  MOV  A,M                 ; 1701 7e
         ANI  0Eh                 ; 1702 e6 0e
         JNZ  L_16EF              ; 1704 c2 ef 16
         CALL L_16E0              ; 1707 cd e0 16
         MOV  E,M                 ; 170A 5e
         INX  H                   ; 170B 23
         MOV  D,M                 ; 170C 56
         CALL L_171F              ; 170D cd 1f 17
         JMP  L_16CF              ; 1710 c3 cf 16
         .db 0CDh,0E0h,16h,7Eh,32h,0F4h,0DDh,3Eh,01h,0C3h,0CFh,16h ; 1713 |...~2..>....|
L_171F:  XCHG                     ; 171F eb
         DAD  H                   ; 1720 29
         XCHG                     ; 1721 eb
         LXI  B,0FB00h            ; 1722 01 00 fb
         XRA  A                   ; 1725 af
         CMC                      ; 1726 3f
L_1727:  MOV  H,D                 ; 1727 62
         MOV  L,E                 ; 1728 6b
L_1729:  RAL                      ; 1729 17
         JC   L_1737              ; 172A da 37 17
         DAD  H                   ; 172D 29
         MOV  D,H                 ; 172E 54
         MOV  E,L                 ; 172F 5d
         DAD  B                   ; 1730 09
         JNC  L_1727              ; 1731 d2 27 17
         JMP  L_1729              ; 1734 c3 29 17
L_1737:  ADI  08h                 ; 1737 c6 08
         STA  0DDF4h              ; 1739 32 f4 dd
         MOV  A,H                 ; 173C 7c
         RLC                      ; 173D 07
         RLC                      ; 173E 07
         RLC                      ; 173F 07
         INR  A                   ; 1740 3c
         RET                      ; 1741 c9
L_1742:  PUSH B                   ; 1742 c5
         LXI  H,1FFBh             ; 1743 21 fb 1f
         RST  3                   ; 1746 df
         CALL L_0D44              ; 1747 cd 44 0d
         CALL L_0FE0              ; 174A cd e0 0f
         POP  B                   ; 174D c1
         RET                      ; 174E c9
L_174F:  MOV  C,A                 ; 174F 4f
         LDA  0A849h              ; 1750 3a 49 a8
         SUI  41h                 ; 1753 d6 41
         STA  0DDF0h              ; 1755 32 f0 dd
         MOV  A,C                 ; 1758 79
         ORA  A                   ; 1759 b7
         RZ                       ; 175A c8
L_175B:  PUSH B                   ; 175B c5
         CALL L_17E6              ; 175C cd e6 17
         LXI  H,006Bh             ; 175F 21 6b 00
         MOV  A,M                 ; 1762 7e
         INR  M                   ; 1763 34
         ANI  07h                 ; 1764 e6 07
         JZ   L_179B              ; 1766 ca 9b 17
         LDA  0DDF5h              ; 1769 3a f5 dd
         INR  A                   ; 176C 3c
L_176D:  STA  0DDF5h              ; 176D 32 f5 dd
         CALL 0C02Ah              ; 1770 cd 2a c0
         POP  B                   ; 1773 c1
         DCR  C                   ; 1774 0d
         JNZ  L_175B              ; 1775 c2 5b 17
         RET                      ; 1778 c9
L_1779:  POP  B                   ; 1779 c1
         JMP  L_17CF              ; 177A c3 cf 17
L_177D:  LDA  0DDF5h              ; 177D 3a f5 dd
         INR  A                   ; 1780 3c
         CPI  29h                 ; 1781 fe 29
         JNZ  L_176D              ; 1783 c2 6d 17
         LXI  H,0DDF4h            ; 1786 21 f4 dd
         INR  M                   ; 1789 34
         MVI  A,01h               ; 178A 3e 01
         JMP  L_176D              ; 178C c3 6d 17
         .db 0CDh,0ACh,17h,7Bh,32h,0F4h,0DDh,3Eh,01h,0C3h,6Dh,17h ; 178F |...{2..>..m.|
L_179B:  MOV  A,M                 ; 179B 7e
         ANI  0Eh                 ; 179C e6 0e
         JNZ  L_177D              ; 179E c2 7d 17
         CALL L_17AC              ; 17A1 cd ac 17
         INX  H                   ; 17A4 23
         MOV  M,D                 ; 17A5 72
         CALL L_171F              ; 17A6 cd 1f 17
         JMP  L_176D              ; 17A9 c3 6d 17
L_17AC:  LXI  H,0A101h            ; 17AC 21 01 a1
L_17AF:  INX  H                   ; 17AF 23
         MOV  A,M                 ; 17B0 7e
         ORA  A                   ; 17B1 b7
         JZ   L_1779              ; 17B2 ca 79 17
         CPI  53h                 ; 17B5 fe 53
         JNZ  L_17AF              ; 17B7 c2 af 17
         MVI  M,5Ah               ; 17BA 36 5a
         SHLD 17ADh               ; 17BC 22 ad 17
         MOV  A,H                 ; 17BF 7c
         SUI  0A1h                ; 17C0 d6 a1
         MOV  D,A                 ; 17C2 57
         MOV  E,L                 ; 17C3 5d
         LDA  006Bh               ; 17C4 3a 6b 00
         LXI  H,006Ch             ; 17C7 21 6c 00
         CALL L_16E5              ; 17CA cd e5 16
         MOV  M,E                 ; 17CD 73
         RET                      ; 17CE c9
L_17CF:  PUSH B                   ; 17CF c5
         CALL L_0FF3              ; 17D0 cd f3 0f
         LXI  H,1FEFh             ; 17D3 21 ef 1f
         RST  3                   ; 17D6 df
         MVI  C,13h               ; 17D7 0e 13
         CALL L_19AD              ; 17D9 cd ad 19
         MVI  A,03h               ; 17DC 3e 03
         STA  0B68Dh              ; 17DE 32 8d b6
         CALL L_0D44              ; 17E1 cd 44 0d
         POP  B                   ; 17E4 c1
         RET                      ; 17E5 c9
L_17E6:  LXI  H,0000h             ; 17E6 21 00 00
         SHLD 0DDF6h              ; 17E9 22 f6 dd
         LXI  B,0080h             ; 17EC 01 80 00
         DAD  B                   ; 17EF 09
         SHLD 17E7h               ; 17F0 22 e7 17
         RET                      ; 17F3 c9
L_17F4:  PUSH H                   ; 17F4 e5
L_17F5:  PUSH D                   ; 17F5 d5
L_17F6:  PUSH B                   ; 17F6 c5
L_17F7:  MVI  C,1Ah               ; 17F7 0e 1a
L_17F9:  RST  1                   ; 17F9 cf
L_17FA:  POP  B                   ; 17FA c1
L_17FB:  POP  D                   ; 17FB d1
L_17FC:  POP  H                   ; 17FC e1
L_17FD:  RET                      ; 17FD c9
L_17FE:  LHLD 0A83Eh              ; 17FE 2a 3e a8
L_1801:  MOV  A,L                 ; 1801 7d
L_1802:  ANI  7Fh                 ; 1802 e6 7f
L_1804:  STA  007Ch               ; 1804 32 7c 00
L_1807:  RET                      ; 1807 c9
L_1808:  CALL L_19B8              ; 1808 cd b8 19
L_180B:  LHLD 0A83Eh              ; 180B 2a 3e a8
L_180E:  MOV  A,L                 ; 180E 7d
L_180F:  DAD  H                   ; 180F 29
L_1810:  ANI  7Fh                 ; 1810 e6 7f
L_1812:  PUSH PSW                 ; 1812 f5
L_1813:  MOV  A,H                 ; 1813 7c
L_1814:  STA  0068h               ; 1814 32 68 00
L_1817:  MVI  C,0Fh               ; 1817 0e 0f
L_1819:  CALL L_19AD              ; 1819 cd ad 19
L_181C:  POP  PSW                 ; 181C f1
L_181D:  STA  007Ch               ; 181D 32 7c 00
L_1820:  RET                      ; 1820 c9
L_1821:  LXI  H,0001h             ; 1821 21 01 00
L_1824:  SHLD 0A853h              ; 1824 22 53 a8
L_1827:  LXI  H,0000h             ; 1827 21 00 00
L_182A:  SHLD 0B68Dh              ; 182A 22 8d b6
L_182D:  SHLD 0A83Eh              ; 182D 22 3e a8
L_1830:  LXI  H,0B663h            ; 1830 21 63 b6
L_1833:  SHLD 0A842h              ; 1833 22 42 a8
L_1836:  LXI  H,0A000h            ; 1836 21 00 a0
L_1839:  SHLD 0A855h              ; 1839 22 55 a8
L_183C:  CALL L_1808              ; 183C cd 08 18
L_183F:  CALL L_187A              ; 183F cd 7a 18
L_1842:  JMP  L_18E0              ; 1842 c3 e0 18
L_1845:  LDA  0A83Eh              ; 1845 3a 3e a8
L_1848:  ANI  7Fh                 ; 1848 e6 7f
L_184A:  CPI  7Eh                 ; 184A fe 7e
L_184C:  JNZ  L_17FE              ; 184C c2 fe 17
         CALL L_18E0              ; 184F cd e0 18
         JMP  L_1808              ; 1852 c3 08 18
L_1855:  LDA  0B68Dh              ; 1855 3a 8d b6
L_1858:  CPI  00h                 ; 1858 fe 00
L_185A:  LHLD 0A83Eh              ; 185A 2a 3e a8
L_185D:  JZ   L_1865              ; 185D ca 65 18
L_1860:  DCX  H                   ; 1860 2b
L_1861:  DCX  H                   ; 1861 2b
L_1862:  JMP  L_1867              ; 1862 c3 67 18
L_1865:  INX  H                   ; 1865 23
L_1866:  INX  H                   ; 1866 23
L_1867:  SHLD 0A83Eh              ; 1867 22 3e a8
L_186A:  CALL L_1872              ; 186A cd 72 18
L_186D:  XRA  A                   ; 186D af
L_186E:  STA  0B68Dh              ; 186E 32 8d b6
L_1871:  RET                      ; 1871 c9
L_1872:  LDA  0B68Dh              ; 1872 3a 8d b6
L_1875:  CPI  00h                 ; 1875 fe 00
L_1877:  CNZ  L_1845              ; 1877 c4 45 18
L_187A:  LXI  D,0A000h            ; 187A 11 00 a0
L_187D:  CALL L_17F4              ; 187D cd f4 17
L_1880:  CALL L_1922              ; 1880 cd 22 19
L_1883:  CPI  00h                 ; 1883 fe 00
L_1885:  JNZ  L_1897              ; 1885 c2 97 18
L_1888:  LXI  D,0A080h            ; 1888 11 80 a0
L_188B:  CALL L_17F4              ; 188B cd f4 17
L_188E:  CALL L_1922              ; 188E cd 22 19
L_1891:  CPI  00h                 ; 1891 fe 00
L_1893:  JNZ  L_18A4              ; 1893 c2 a4 18
L_1896:  RET                      ; 1896 c9
L_1897:  LXI  H,0A000h            ; 1897 21 00 a0
         MVI  C,00h               ; 189A 0e 00
L_189C:  MVI  M,1Ah               ; 189C 36 1a
L_189E:  INX  H                   ; 189E 23
L_189F:  DCR  C                   ; 189F 0d
L_18A0:  JNZ  L_189C              ; 18A0 c2 9c 18
L_18A3:  RET                      ; 18A3 c9
L_18A4:  LXI  H,0A080h            ; 18A4 21 80 a0
L_18A7:  MVI  C,80h               ; 18A7 0e 80
L_18A9:  JMP  L_189C              ; 18A9 c3 9c 18
L_18AC:  LXI  H,0B663h            ; 18AC 21 63 b6
         SHLD 0A842h              ; 18AF 22 42 a8
         LXI  H,0000h             ; 18B2 21 00 00
         SHLD 0A83Eh              ; 18B5 22 3e a8
         CALL L_1808              ; 18B8 cd 08 18
         LXI  D,0A000h            ; 18BB 11 00 a0
         MVI  C,70h               ; 18BE 0e 70
         JMP  L_18C5              ; 18C0 c3 c5 18
L_18C3:  MVI  C,00h               ; 18C3 0e 00
L_18C5:  LXI  H,0080h             ; 18C5 21 80 00
L_18C8:  CALL L_17F4              ; 18C8 cd f4 17
L_18CB:  CALL L_1922              ; 18CB cd 22 19
L_18CE:  XCHG                     ; 18CE eb
L_18CF:  DAD  D                   ; 18CF 19
L_18D0:  XCHG                     ; 18D0 eb
L_18D1:  CPI  00h                 ; 18D1 fe 00
L_18D3:  JNZ  L_18F7              ; 18D3 c2 f7 18
L_18D6:  INR  C                   ; 18D6 0c
L_18D7:  MOV  A,C                 ; 18D7 79
L_18D8:  CPI  80h                 ; 18D8 fe 80
L_18DA:  JNZ  L_18C8              ; 18DA c2 c8 18
L_18DD:  STA  0A886h              ; 18DD 32 86 a8
L_18E0:  MVI  C,10h               ; 18E0 0e 10
L_18E2:  JMP  L_19AD              ; 18E2 c3 ad 19
L_18E5:  CALL L_1808              ; 18E5 cd 08 18
L_18E8:  LXI  D,0A000h            ; 18E8 11 00 a0
L_18EB:  JMP  L_18C3              ; 18EB c3 c3 18
L_18EE:  CALL L_1808              ; 18EE cd 08 18
         LXI  D,6100h             ; 18F1 11 00 61
         JMP  L_18C3              ; 18F4 c3 c3 18
L_18F7:  MOV  A,C                 ; 18F7 79
L_18F8:  JMP  L_18DD              ; 18F8 c3 dd 18
         .db 2Ah,3Ah,0A8h,22h,0Ah,0F8h,2Ah,38h,0A8h,0F9h,0CDh,0E0h,0Fh,3Ah,73h,0B6h ; 18FB |*:."..*8.....:s.|
         .db 4Fh,0E7h,0Eh,3Ah,0E7h,0CDh,70h,19h,21h,0FBh,1Fh,0DFh,0CDh,44h,0Dh,0CDh ; 190B |O..:..p.!....D..|
         .db 0E0h,0Fh,3Eh,0FFh,0C3h,43h,19h                   ; 191B |..>..C.|
L_1922:  PUSH H                   ; 1922 e5
L_1923:  PUSH D                   ; 1923 d5
L_1924:  PUSH B                   ; 1924 c5
L_1925:  LXI  H,0000h             ; 1925 21 00 00
L_1928:  DAD  SP                  ; 1928 39
L_1929:  SHLD 0A838h              ; 1929 22 38 a8
L_192C:  LHLD 0F80Ah              ; 192C 2a 0a f8
L_192F:  SHLD 0A83Ah              ; 192F 22 3a a8
L_1932:  LXI  H,18FBh             ; 1932 21 fb 18
L_1935:  SHLD 0F80Ah              ; 1935 22 0a f8
L_1938:  MVI  C,14h               ; 1938 0e 14
L_193A:  CALL L_19AD              ; 193A cd ad 19
L_193D:  LHLD 0A83Ah              ; 193D 2a 3a a8
L_1940:  SHLD 0F80Ah              ; 1940 22 0a f8
L_1943:  POP  B                   ; 1943 c1
L_1944:  POP  D                   ; 1944 d1
L_1945:  POP  H                   ; 1945 e1
L_1946:  RET                      ; 1946 c9
L_1947:  PUSH H                   ; 1947 e5
L_1948:  PUSH D                   ; 1948 d5
L_1949:  PUSH B                   ; 1949 c5
L_194A:  MVI  C,15h               ; 194A 0e 15
L_194C:  CALL L_19AD              ; 194C cd ad 19
L_194F:  POP  B                   ; 194F c1
L_1950:  POP  D                   ; 1950 d1
L_1951:  POP  H                   ; 1951 e1
L_1952:  RET                      ; 1952 c9
L_1953:  RST  3                   ; 1953 df
L_1954:  LXI  H,1FC2h             ; 1954 21 c2 1f
L_1957:  RST  3                   ; 1957 df
L_1958:  CALL L_0D44              ; 1958 cd 44 0d
L_195B:  LXI  H,1FDAh             ; 195B 21 da 1f
L_195E:  CPI  59h                 ; 195E fe 59
L_1960:  JZ   L_1966              ; 1960 ca 66 19
L_1963:  LXI  H,1FDEh             ; 1963 21 de 1f
L_1966:  PUSH PSW                 ; 1966 f5
L_1967:  RST  3                   ; 1967 df
L_1968:  POP  PSW                 ; 1968 f1
L_1969:  RET                      ; 1969 c9
L_196A:  CALL L_0FF9              ; 196A cd f9 0f
L_196D:  JMP  L_1970              ; 196D c3 70 19
L_1970:  LXI  H,005Dh             ; 1970 21 5d 00
L_1973:  MVI  C,08h               ; 1973 0e 08
L_1975:  MOV  A,M                 ; 1975 7e
L_1976:  CALL L_19DB              ; 1976 cd db 19
L_1979:  INX  H                   ; 1979 23
L_197A:  DCR  C                   ; 197A 0d
L_197B:  JNZ  L_1975              ; 197B c2 75 19
L_197E:  MVI  A,20h               ; 197E 3e 20
L_1980:  CALL L_19DB              ; 1980 cd db 19
L_1983:  MVI  C,03h               ; 1983 0e 03
L_1985:  MOV  A,M                 ; 1985 7e
L_1986:  CALL L_19DB              ; 1986 cd db 19
L_1989:  INX  H                   ; 1989 23
L_198A:  DCR  C                   ; 198A 0d
L_198B:  JNZ  L_1985              ; 198B c2 85 19
L_198E:  RET                      ; 198E c9
L_198F:  CALL L_19B8              ; 198F cd b8 19
L_1992:  MVI  C,16h               ; 1992 0e 16
L_1994:  CALL L_19AD              ; 1994 cd ad 19
L_1997:  ORA  A                   ; 1997 b7
L_1998:  JP   L_199F              ; 1998 f2 9f 19
         CALL L_1638              ; 199B cd 38 16
         RNZ                      ; 199E c0
L_199F:  MVI  A,59h               ; 199F 3e 59
L_19A1:  RET                      ; 19A1 c9
L_19A2:  CALL L_198F              ; 19A2 cd 8f 19
L_19A5:  STA  0A848h              ; 19A5 32 48 a8
L_19A8:  CPI  59h                 ; 19A8 fe 59
L_19AA:  RNZ                      ; 19AA c0
L_19AB:  MVI  C,13h               ; 19AB 0e 13
L_19AD:  LXI  D,005Ch             ; 19AD 11 5c 00
L_19B0:  RST  1                   ; 19B0 cf
L_19B1:  RET                      ; 19B1 c9
L_19B2:  LXI  H,0B654h            ; 19B2 21 54 b6
L_19B5:  SHLD 0A842h              ; 19B5 22 42 a8
L_19B8:  LHLD 0A842h              ; 19B8 2a 42 a8
L_19BB:  LDA  0B673h              ; 19BB 3a 73 b6
L_19BE:  SUI  40h                 ; 19BE d6 40
L_19C0:  LXI  D,005Ch             ; 19C0 11 5c 00
L_19C3:  STAX D                   ; 19C3 12
L_19C4:  INX  D                   ; 19C4 13
L_19C5:  MVI  C,08h               ; 19C5 0e 08
L_19C7:  RST  5                   ; 19C7 ef
L_19C8:  INX  H                   ; 19C8 23
L_19C9:  MVI  C,03h               ; 19C9 0e 03
L_19CB:  RST  5                   ; 19CB ef
L_19CC:  XRA  A                   ; 19CC af
L_19CD:  MVI  C,04h               ; 19CD 0e 04
L_19CF:  STAX D                   ; 19CF 12
L_19D0:  INX  D                   ; 19D0 13
L_19D1:  DCR  C                   ; 19D1 0d
L_19D2:  JNZ  L_19CF              ; 19D2 c2 cf 19
L_19D5:  LXI  H,0010h             ; 19D5 21 10 00
L_19D8:  DAD  D                   ; 19D8 19
L_19D9:  MOV  M,A                 ; 19D9 77
L_19DA:  RET                      ; 19DA c9
L_19DB:  PUSH PSW                 ; 19DB f5
L_19DC:  PUSH B                   ; 19DC c5
L_19DD:  MOV  C,A                 ; 19DD 4f
L_19DE:  RST  4                   ; 19DE e7
L_19DF:  POP  B                   ; 19DF c1
L_19E0:  POP  PSW                 ; 19E0 f1
L_19E1:  RET                      ; 19E1 c9
L_19E2:  MVI  E,02h               ; 19E2 1e 02
L_19E4:  MVI  C,0Eh               ; 19E4 0e 0e
L_19E6:  RST  1                   ; 19E6 cf
L_19E7:  RET                      ; 19E7 c9
L_19E8:  LXI  H,0A887h            ; 19E8 21 87 a8
L_19EB:  CALL L_0E4D              ; 19EB cd 4d 0e
L_19EE:  MOV  E,M                 ; 19EE 5e
L_19EF:  CALL L_13D7              ; 19EF cd d7 13
L_19F2:  CALL L_19E2              ; 19F2 cd e2 19
L_19F5:  LXI  H,0000h             ; 19F5 21 00 00
L_19F8:  SHLD 0DEC1h              ; 19F8 22 c1 de
L_19FB:  CALL L_1257              ; 19FB cd 57 12
L_19FE:  LXI  H,0000h             ; 19FE 21 00 00
L_1A01:  DAD  SP                  ; 1A01 39
L_1A02:  SHLD 0A838h              ; 1A02 22 38 a8
L_1A05:  LHLD 0F80Ah              ; 1A05 2a 0a f8
L_1A08:  SHLD 0A83Ah              ; 1A08 22 3a a8
L_1A0B:  LXI  H,1C00h             ; 1A0B 21 00 1c
L_1A0E:  SHLD 0F80Ah              ; 1A0E 22 0a f8
L_1A11:  LXI  H,3E91h             ; 1A11 21 91 3e
L_1A14:  CALL L_0E4D              ; 1A14 cd 4d 0e
L_1A17:  MOV  A,M                 ; 1A17 7e
L_1A18:  SUI  41h                 ; 1A18 d6 41
L_1A1A:  MVI  C,0Eh               ; 1A1A 0e 0e
L_1A1C:  MOV  E,A                 ; 1A1C 5f
L_1A1D:  ADD  A                   ; 1A1D 87
L_1A1E:  ADI  96h                 ; 1A1E c6 96
L_1A20:  MOV  L,A                 ; 1A20 6f
L_1A21:  MVI  H,0DEh              ; 1A21 26 de
L_1A23:  MOV  A,M                 ; 1A23 7e
L_1A24:  STA  1DF3h               ; 1A24 32 f3 1d
L_1A27:  RST  1                   ; 1A27 cf
L_1A28:  LXI  H,0A943h            ; 1A28 21 43 a9
L_1A2B:  CALL L_0E47              ; 1A2B cd 47 0e
L_1A2E:  SHLD 1A41h               ; 1A2E 22 41 1a
L_1A31:  LXI  H,0A947h            ; 1A31 21 47 a9
L_1A34:  CALL L_0E47              ; 1A34 cd 47 0e
L_1A37:  SHLD 1A44h               ; 1A37 22 44 1a
L_1A3A:  CALL L_20CA              ; 1A3A cd ca 20
L_1A3D:  LXI  H,0000h             ; 1A3D 21 00 00
L_1A40:  SHLD 0000h               ; 1A40 22 00 00
L_1A43:  SHLD 0000h               ; 1A43 22 00 00
L_1A46:  SHLD 0A86Fh              ; 1A46 22 6f a8
L_1A49:  SHLD 0A871h              ; 1A49 22 71 a8
L_1A4C:  SHLD 0A881h              ; 1A4C 22 81 a8
L_1A4F:  LHLD 0A842h              ; 1A4F 2a 42 a8
L_1A52:  SHLD 0A873h              ; 1A52 22 73 a8
L_1A55:  LXI  B,0FFF3h            ; 1A55 01 f3 ff
L_1A58:  DAD  B                   ; 1A58 09
L_1A59:  SHLD 1B3Dh               ; 1A59 22 3d 1b
L_1A5C:  LXI  H,3E91h             ; 1A5C 21 91 3e
L_1A5F:  CALL L_0E4D              ; 1A5F cd 4d 0e
L_1A62:  MOV  A,M                 ; 1A62 7e
L_1A63:  SUI  41h                 ; 1A63 d6 41
L_1A65:  STA  0A876h              ; 1A65 32 76 a8
L_1A68:  MVI  C,1Fh               ; 1A68 0e 1f
L_1A6A:  RST  1                   ; 1A6A cf
L_1A6B:  INX  H                   ; 1A6B 23
L_1A6C:  INX  H                   ; 1A6C 23
L_1A6D:  INX  H                   ; 1A6D 23
L_1A6E:  MOV  A,M                 ; 1A6E 7e
L_1A6F:  STA  0A875h              ; 1A6F 32 75 a8
L_1A72:  CALL L_1DD6              ; 1A72 cd d6 1d
L_1A75:  JMP  L_1A7F              ; 1A75 c3 7f 1a
L_1A78:  PUSH B                   ; 1A78 c5
L_1A79:  PUSH D                   ; 1A79 d5
L_1A7A:  CALL L_1E0A              ; 1A7A cd 0a 1e
L_1A7D:  POP  D                   ; 1A7D d1
L_1A7E:  POP  B                   ; 1A7E c1
L_1A7F:  ORA  A                   ; 1A7F b7
L_1A80:  JM   L_1AEF              ; 1A80 fa ef 1a
L_1A83:  LHLD 0A86Fh              ; 1A83 2a 6f a8
L_1A86:  INX  H                   ; 1A86 23
L_1A87:  SHLD 0A86Fh              ; 1A87 22 6f a8
L_1A8A:  LXI  D,0080h             ; 1A8A 11 80 00
L_1A8D:  ANI  03h                 ; 1A8D e6 03
L_1A8F:  RRC                      ; 1A8F 0f
L_1A90:  RRC                      ; 1A90 0f
L_1A91:  RRC                      ; 1A91 0f
L_1A92:  ADD  E                   ; 1A92 83
L_1A93:  MOV  E,A                 ; 1A93 5f
L_1A94:  LXI  H,000Fh             ; 1A94 21 0f 00
L_1A97:  DAD  D                   ; 1A97 19
L_1A98:  MOV  A,M                 ; 1A98 7e
L_1A99:  CPI  80h                 ; 1A99 fe 80
L_1A9B:  JZ   L_1A78              ; 1A9B ca 78 1a
L_1A9E:  MOV  B,A                 ; 1A9E 47
L_1A9F:  LDA  0A875h              ; 1A9F 3a 75 a8
L_1AA2:  CMA                      ; 1AA2 2f
L_1AA3:  MOV  C,A                 ; 1AA3 4f
L_1AA4:  CMA                      ; 1AA4 2f
L_1AA5:  ADD  B                   ; 1AA5 80
L_1AA6:  ANA  C                   ; 1AA6 a1
L_1AA7:  RRC                      ; 1AA7 0f
L_1AA8:  RRC                      ; 1AA8 0f
L_1AA9:  RRC                      ; 1AA9 0f
L_1AAA:  ANI  1Fh                 ; 1AAA e6 1f
L_1AAC:  MOV  B,A                 ; 1AAC 47
L_1AAD:  DCX  H                   ; 1AAD 2b
L_1AAE:  DCX  H                   ; 1AAE 2b
L_1AAF:  DCX  H                   ; 1AAF 2b
L_1AB0:  MOV  A,M                 ; 1AB0 7e
L_1AB1:  RRC                      ; 1AB1 0f
L_1AB2:  RRC                      ; 1AB2 0f
L_1AB3:  RRC                      ; 1AB3 0f
L_1AB4:  RRC                      ; 1AB4 0f
L_1AB5:  ANI  0F0h                ; 1AB5 e6 f0
L_1AB7:  ADD  B                   ; 1AB7 80
L_1AB8:  MOV  M,A                 ; 1AB8 77
L_1AB9:  LXI  H,3E95h             ; 1AB9 21 95 3e
L_1ABC:  CALL L_0E4D              ; 1ABC cd 4d 0e
L_1ABF:  MOV  A,M                 ; 1ABF 7e
L_1AC0:  ANI  0Fh                 ; 1AC0 e6 0f
L_1AC2:  CPI  01h                 ; 1AC2 fe 01
L_1AC4:  JZ   L_1AD1              ; 1AC4 ca d1 1a
         LXI  H,000Ah             ; 1AC7 21 0a 00
         DAD  D                   ; 1ACA 19
         MOV  A,M                 ; 1ACB 7e
         CPI  80h                 ; 1ACC fe 80
         JNC  L_1D72              ; 1ACE d2 72 1d
L_1AD1:  LHLD 0A873h              ; 1AD1 2a 73 a8
L_1AD4:  INX  D                   ; 1AD4 13
L_1AD5:  MVI  C,08h               ; 1AD5 0e 08
L_1AD7:  XCHG                     ; 1AD7 eb
L_1AD8:  RST  5                   ; 1AD8 ef
L_1AD9:  XCHG                     ; 1AD9 eb
L_1ADA:  MVI  M,20h               ; 1ADA 36 20
L_1ADC:  INX  H                   ; 1ADC 23
L_1ADD:  MVI  C,04h               ; 1ADD 0e 04
L_1ADF:  XCHG                     ; 1ADF eb
L_1AE0:  RST  5                   ; 1AE0 ef
L_1AE1:  XCHG                     ; 1AE1 eb
L_1AE2:  SHLD 0A873h              ; 1AE2 22 73 a8
L_1AE5:  LHLD 0A871h              ; 1AE5 2a 71 a8
L_1AE8:  INX  H                   ; 1AE8 23
L_1AE9:  SHLD 0A871h              ; 1AE9 22 71 a8
L_1AEC:  JMP  L_1A78              ; 1AEC c3 78 1a
L_1AEF:  CALL L_19E2              ; 1AEF cd e2 19
L_1AF2:  LHLD 0A871h              ; 1AF2 2a 71 a8
L_1AF5:  SHLD 0A87Dh              ; 1AF5 22 7d a8
L_1AF8:  LXI  H,3E95h             ; 1AF8 21 95 3e
L_1AFB:  CALL L_0E4D              ; 1AFB cd 4d 0e
L_1AFE:  MOV  A,M                 ; 1AFE 7e
L_1AFF:  ANI  0F0h                ; 1AFF e6 f0
L_1B01:  CPI  40h                 ; 1B01 fe 40
L_1B03:  JZ   L_1C41              ; 1B03 ca 41 1c
L_1B06:  CPI  10h                 ; 1B06 fe 10
L_1B08:  CNZ  L_1B63              ; 1B08 c4 63 1b
L_1B0B:  LHLD 0A87Dh              ; 1B0B 2a 7d a8
L_1B0E:  MOV  A,H                 ; 1B0E 7c
L_1B0F:  ORA  A                   ; 1B0F b7
L_1B10:  RAR                      ; 1B10 1f
L_1B11:  MOV  H,A                 ; 1B11 67
L_1B12:  MOV  A,L                 ; 1B12 7d
L_1B13:  RAR                      ; 1B13 1f
L_1B14:  MOV  L,A                 ; 1B14 6f
L_1B15:  SHLD 0A87Dh              ; 1B15 22 7d a8
L_1B18:  ORA  H                   ; 1B18 b4
L_1B19:  JZ   L_1C41              ; 1B19 ca 41 1c
L_1B1C:  MOV  A,H                 ; 1B1C 7c
L_1B1D:  CMA                      ; 1B1D 2f
L_1B1E:  MOV  H,A                 ; 1B1E 67
L_1B1F:  MOV  A,L                 ; 1B1F 7d
L_1B20:  CMA                      ; 1B20 2f
L_1B21:  MOV  L,A                 ; 1B21 6f
L_1B22:  INX  H                   ; 1B22 23
L_1B23:  XCHG                     ; 1B23 eb
L_1B24:  LHLD 0A871h              ; 1B24 2a 71 a8
L_1B27:  DAD  D                   ; 1B27 19
L_1B28:  SHLD 0A87Bh              ; 1B28 22 7b a8
L_1B2B:  LXI  H,0001h             ; 1B2B 21 01 00
L_1B2E:  SHLD 0A879h              ; 1B2E 22 79 a8
L_1B31:  SHLD 0A877h              ; 1B31 22 77 a8
L_1B34:  XCHG                     ; 1B34 eb
L_1B35:  LHLD 0A87Dh              ; 1B35 2a 7d a8
L_1B38:  DAD  D                   ; 1B38 19
L_1B39:  CALL L_1B59              ; 1B39 cd 59 1b
L_1B3C:  LXI  B,0000h             ; 1B3C 01 00 00
L_1B3F:  DAD  B                   ; 1B3F 09
L_1B40:  XCHG                     ; 1B40 eb
L_1B41:  LHLD 0A877h              ; 1B41 2a 77 a8
L_1B44:  PUSH D                   ; 1B44 d5
L_1B45:  CALL L_1B59              ; 1B45 cd 59 1b
L_1B48:  JMP  L_1B91              ; 1B48 c3 91 1b
L_1B4B:  DAD  B                   ; 1B4B 09
L_1B4C:  LXI  B,000Ah             ; 1B4C 01 0a 00
L_1B4F:  DAD  B                   ; 1B4F 09
L_1B50:  XCHG                     ; 1B50 eb
L_1B51:  POP  H                   ; 1B51 e1
L_1B52:  DAD  B                   ; 1B52 09
L_1B53:  XCHG                     ; 1B53 eb
L_1B54:  MVI  B,03h               ; 1B54 06 03
L_1B56:  JMP  L_1B95              ; 1B56 c3 95 1b
L_1B59:  PUSH H                   ; 1B59 e5
L_1B5A:  DAD  H                   ; 1B5A 29
L_1B5B:  DAD  H                   ; 1B5B 29
L_1B5C:  MOV  D,H                 ; 1B5C 54
L_1B5D:  MOV  E,L                 ; 1B5D 5d
L_1B5E:  DAD  H                   ; 1B5E 29
L_1B5F:  DAD  D                   ; 1B5F 19
L_1B60:  POP  D                   ; 1B60 d1
L_1B61:  DAD  D                   ; 1B61 19
L_1B62:  RET                      ; 1B62 c9
L_1B63:  LXI  H,1B4Bh             ; 1B63 21 4b 1b
L_1B66:  SHLD 1B49h               ; 1B66 22 49 1b
L_1B69:  CPI  20h                 ; 1B69 fe 20
L_1B6B:  JZ   L_1B7F              ; 1B6B ca 7f 1b
         LXI  H,000Ch             ; 1B6E 21 0c 00
         SHLD 1B4Dh               ; 1B71 22 4d 1b
         XRA  A                   ; 1B74 af
         STA  1B55h               ; 1B75 32 55 1b
         LXI  H,0FFF3h            ; 1B78 21 f3 ff
         SHLD 1BA4h               ; 1B7B 22 a4 1b
         RET                      ; 1B7E c9
L_1B7F:  LXI  H,0009h             ; 1B7F 21 09 00
L_1B82:  SHLD 1B4Dh               ; 1B82 22 4d 1b
L_1B85:  MVI  A,03h               ; 1B85 3e 03
L_1B87:  STA  1B55h               ; 1B87 32 55 1b
L_1B8A:  LXI  H,0FFF4h            ; 1B8A 21 f4 ff
L_1B8D:  SHLD 1BA4h               ; 1B8D 22 a4 1b
L_1B90:  RET                      ; 1B90 c9
L_1B91:  POP  D                   ; 1B91 d1
L_1B92:  DAD  B                   ; 1B92 09
L_1B93:  MVI  B,0Ch               ; 1B93 06 0c
L_1B95:  LDAX D                   ; 1B95 1a
L_1B96:  CMP  M                   ; 1B96 be
L_1B97:  JC   L_1BCB              ; 1B97 da cb 1b
L_1B9A:  JNZ  L_1BAF              ; 1B9A c2 af 1b
L_1B9D:  INX  D                   ; 1B9D 13
L_1B9E:  INX  H                   ; 1B9E 23
L_1B9F:  DCR  B                   ; 1B9F 05
L_1BA0:  JNZ  L_1B95              ; 1BA0 c2 95 1b
L_1BA3:  LXI  B,0FFF2h            ; 1BA3 01 f2 ff
L_1BA6:  DAD  B                   ; 1BA6 09
L_1BA7:  XCHG                     ; 1BA7 eb
L_1BA8:  DAD  B                   ; 1BA8 09
L_1BA9:  XCHG                     ; 1BA9 eb
L_1BAA:  MVI  B,0Ch               ; 1BAA 06 0c
L_1BAC:  JMP  L_1B95              ; 1BAC c3 95 1b
L_1BAF:  LHLD 0A879h              ; 1BAF 2a 79 a8
L_1BB2:  INX  H                   ; 1BB2 23
L_1BB3:  SHLD 0A879h              ; 1BB3 22 79 a8
L_1BB6:  XCHG                     ; 1BB6 eb
L_1BB7:  LHLD 0A87Bh              ; 1BB7 2a 7b a8
L_1BBA:  MOV  A,H                 ; 1BBA 7c
L_1BBB:  CMP  D                   ; 1BBB ba
L_1BBC:  JC   L_1B0B              ; 1BBC da 0b 1b
L_1BBF:  JNZ  L_1BC7              ; 1BBF c2 c7 1b
L_1BC2:  MOV  A,L                 ; 1BC2 7d
L_1BC3:  CMP  E                   ; 1BC3 bb
L_1BC4:  JC   L_1B0B              ; 1BC4 da 0b 1b
L_1BC7:  XCHG                     ; 1BC7 eb
L_1BC8:  JMP  L_1B31              ; 1BC8 c3 31 1b
L_1BCB:  MVI  A,0Ch               ; 1BCB 3e 0c
L_1BCD:  SUB  B                   ; 1BCD 90
L_1BCE:  CMA                      ; 1BCE 2f
L_1BCF:  MOV  C,A                 ; 1BCF 4f
L_1BD0:  MVI  B,0FFh              ; 1BD0 06 ff
L_1BD2:  INX  B                   ; 1BD2 03
L_1BD3:  DAD  B                   ; 1BD3 09
L_1BD4:  XCHG                     ; 1BD4 eb
L_1BD5:  DAD  B                   ; 1BD5 09
L_1BD6:  MVI  B,0Dh               ; 1BD6 06 0d
L_1BD8:  LDAX D                   ; 1BD8 1a
L_1BD9:  MOV  C,M                 ; 1BD9 4e
L_1BDA:  MOV  M,A                 ; 1BDA 77
L_1BDB:  MOV  A,C                 ; 1BDB 79
L_1BDC:  STAX D                   ; 1BDC 12
L_1BDD:  INX  H                   ; 1BDD 23
L_1BDE:  INX  D                   ; 1BDE 13
L_1BDF:  DCR  B                   ; 1BDF 05
L_1BE0:  JNZ  L_1BD8              ; 1BE0 c2 d8 1b
L_1BE3:  LHLD 0A87Dh              ; 1BE3 2a 7d a8
L_1BE6:  MOV  A,H                 ; 1BE6 7c
L_1BE7:  CMA                      ; 1BE7 2f
L_1BE8:  MOV  D,A                 ; 1BE8 57
L_1BE9:  MOV  A,L                 ; 1BE9 7d
L_1BEA:  CMA                      ; 1BEA 2f
L_1BEB:  MOV  E,A                 ; 1BEB 5f
L_1BEC:  INX  D                   ; 1BEC 13
L_1BED:  LHLD 0A877h              ; 1BED 2a 77 a8
L_1BF0:  DAD  D                   ; 1BF0 19
L_1BF1:  SHLD 0A877h              ; 1BF1 22 77 a8
L_1BF4:  XRA  A                   ; 1BF4 af
L_1BF5:  ORA  H                   ; 1BF5 b4
L_1BF6:  JM   L_1BAF              ; 1BF6 fa af 1b
L_1BF9:  ORA  L                   ; 1BF9 b5
L_1BFA:  JZ   L_1BAF              ; 1BFA ca af 1b
L_1BFD:  JMP  L_1B34              ; 1BFD c3 34 1b
L_1C00:  LHLD 0A83Ah              ; 1C00 2a 3a a8
L_1C03:  SHLD 0F80Ah              ; 1C03 22 0a f8
L_1C06:  LHLD 0A838h              ; 1C06 2a 38 a8
L_1C09:  SPHL                     ; 1C09 f9
L_1C0A:  CALL L_19E2              ; 1C0A cd e2 19
L_1C0D:  LXI  H,0B689h            ; 1C0D 21 89 b6
L_1C10:  CALL L_0E47              ; 1C10 cd 47 0e
L_1C13:  MVI  M,00h               ; 1C13 36 00
L_1C15:  LXI  H,0B67Dh            ; 1C15 21 7d b6
L_1C18:  CALL L_0E47              ; 1C18 cd 47 0e
L_1C1B:  MVI  M,00h               ; 1C1B 36 00
L_1C1D:  LXI  H,0B685h            ; 1C1D 21 85 b6
L_1C20:  CALL L_0E47              ; 1C20 cd 47 0e
L_1C23:  MVI  M,00h               ; 1C23 36 00
L_1C25:  INX  H                   ; 1C25 23
L_1C26:  MVI  M,00h               ; 1C26 36 00
L_1C28:  RET                      ; 1C28 c9
L_1C29:  LXI  B,0001h             ; 1C29 01 01 00
L_1C2C:  CALL 0C01Eh              ; 1C2C cd 1e c0
L_1C2F:  LXI  B,0008h             ; 1C2F 01 08 00
L_1C32:  CALL 0C021h              ; 1C32 cd 21 c0
L_1C35:  CALL 0C027h              ; 1C35 cd 27 c0
L_1C38:  MVI  A,65h               ; 1C38 3e 65
L_1C3A:  NOP                      ; 1C3A 00
L_1C3B:  DCR  A                   ; 1C3B 3d
L_1C3C:  CPI  64h                 ; 1C3C fe 64
L_1C3E:  JZ   L_1CAB              ; 1C3E ca ab 1c
L_1C41:  LXI  H,1B91h             ; 1C41 21 91 1b
L_1C44:  SHLD 1B49h               ; 1C44 22 49 1b
L_1C47:  LHLD 0A83Ah              ; 1C47 2a 3a a8
L_1C4A:  SHLD 0F80Ah              ; 1C4A 22 0a f8
L_1C4D:  LXI  H,0B689h            ; 1C4D 21 89 b6
L_1C50:  CALL L_0E47              ; 1C50 cd 47 0e
L_1C53:  SHLD 1CAFh               ; 1C53 22 af 1c
L_1C56:  LXI  H,0B67Dh            ; 1C56 21 7d b6
L_1C59:  CALL L_0E47              ; 1C59 cd 47 0e
L_1C5C:  SHLD 1CB5h               ; 1C5C 22 b5 1c
L_1C5F:  LXI  H,0B685h            ; 1C5F 21 85 b6
L_1C62:  CALL L_0E47              ; 1C62 cd 47 0e
L_1C65:  SHLD 1CD9h               ; 1C65 22 d9 1c
L_1C68:  MVI  C,02h               ; 1C68 0e 02
L_1C6A:  CALL 0C01Bh              ; 1C6A cd 1b c0
L_1C6D:  LXI  B,0A100h            ; 1C6D 01 00 a1
L_1C70:  CALL 0C024h              ; 1C70 cd 24 c0
L_1C73:  LXI  B,0000h             ; 1C73 01 00 00
L_1C76:  CALL 0C01Eh              ; 1C76 cd 1e c0
L_1C79:  LXI  B,0001h             ; 1C79 01 01 00
L_1C7C:  CALL 0C021h              ; 1C7C cd 21 c0
L_1C7F:  CALL 0C027h              ; 1C7F cd 27 c0
L_1C82:  MVI  A,02h               ; 1C82 3e 02
L_1C84:  NOP                      ; 1C84 00
L_1C85:  DCR  A                   ; 1C85 3d
L_1C86:  DCR  A                   ; 1C86 3d
L_1C87:  JZ   L_1C29              ; 1C87 ca 29 1c
         MVI  C,00h               ; 1C8A 0e 00
         CALL 0C01Bh              ; 1C8C cd 1b c0
         LXI  B,000Bh             ; 1C8F 01 0b 00
         CALL 0C01Eh              ; 1C92 cd 1e c0
         LXI  B,0029h             ; 1C95 01 29 00
         CALL 0C021h              ; 1C98 cd 21 c0
         LXI  B,0A180h            ; 1C9B 01 80 a1
         CALL 0C024h              ; 1C9E cd 24 c0
L_1CA1:  CALL 0C027h              ; 1CA1 cd 27 c0
         ORA  A                   ; 1CA4 b7
         JNZ  L_1CA1              ; 1CA5 c2 a1 1c
         CALL 0A180h              ; 1CA8 cd 80 a1
L_1CAB:  LHLD 0A871h              ; 1CAB 2a 71 a8
L_1CAE:  SHLD 0000h               ; 1CAE 22 00 00
L_1CB1:  LHLD 0A881h              ; 1CB1 2a 81 a8
L_1CB4:  SHLD 0000h               ; 1CB4 22 00 00
L_1CB7:  CALL L_1257              ; 1CB7 cd 57 12
L_1CBA:  LXI  H,3E91h             ; 1CBA 21 91 3e
L_1CBD:  CALL L_0E4D              ; 1CBD cd 4d 0e
L_1CC0:  MOV  A,M                 ; 1CC0 7e
L_1CC1:  SUI  41h                 ; 1CC1 d6 41
L_1CC3:  MOV  E,A                 ; 1CC3 5f
L_1CC4:  MVI  C,2Eh               ; 1CC4 0e 2e
L_1CC6:  RST  1                   ; 1CC6 cf
L_1CC7:  LHLD 0080h               ; 1CC7 2a 80 00
L_1CCA:  MOV  A,H                 ; 1CCA 7c
L_1CCB:  ORA  A                   ; 1CCB b7
L_1CCC:  RAR                      ; 1CCC 1f
L_1CCD:  ORA  A                   ; 1CCD b7
L_1CCE:  RAR                      ; 1CCE 1f
L_1CCF:  ORA  A                   ; 1CCF b7
L_1CD0:  RAR                      ; 1CD0 1f
L_1CD1:  DAD  H                   ; 1CD1 29
L_1CD2:  DAD  H                   ; 1CD2 29
L_1CD3:  DAD  H                   ; 1CD3 29
L_1CD4:  DAD  H                   ; 1CD4 29
L_1CD5:  DAD  H                   ; 1CD5 29
L_1CD6:  MOV  L,H                 ; 1CD6 6c
L_1CD7:  MOV  H,A                 ; 1CD7 67
L_1CD8:  SHLD 0000h               ; 1CD8 22 00 00
L_1CDB:  LXI  H,0A88Ah            ; 1CDB 21 8a a8
L_1CDE:  CALL L_0E4D              ; 1CDE cd 4d 0e
L_1CE1:  MVI  M,00h               ; 1CE1 36 00
L_1CE3:  LXI  H,0000h             ; 1CE3 21 00 00
L_1CE6:  DAD  SP                  ; 1CE6 39
L_1CE7:  LXI  SP,0FFF0h           ; 1CE7 31 f0 ff
L_1CEA:  MVI  A,40h               ; 1CEA 3e 40
         DCR  A                   ; 1CEC 3d
L_1CED:  OUT  10h                 ; 1CED d3 10
L_1CEF:  POP  D                   ; 1CEF d1
L_1CF0:  MVI  A,22h               ; 1CF0 3e 22
L_1CF2:  INR  A                   ; 1CF2 3c
         OUT  10h                 ; 1CF3 d3 10
L_1CF5:  SPHL                     ; 1CF5 f9
L_1CF6:  MOV  A,D                 ; 1CF6 7a
L_1CF7:  MVI  C,0Ah               ; 1CF7 0e 0a
L_1CF9:  DCR  A                   ; 1CF9 3d
L_1CFA:  DCR  C                   ; 1CFA 0d
L_1CFB:  JNZ  L_1CF9              ; 1CFB c2 f9 1c
L_1CFE:  ORA  A                   ; 1CFE b7
L_1CFF:  JNZ  L_1CFA              ; 1CFF c2 fa 1c
L_1D02:  JMP  L_1D43              ; 1D02 c3 43 1d
L_1D05:  LXI  H,0A88Ah            ; 1D05 21 8a a8
         CALL L_0E4D              ; 1D08 cd 4d 0e
         INR  M                   ; 1D0B 34
         CALL L_20CA              ; 1D0C cd ca 20
         LHLD 0A842h              ; 1D0F 2a 42 a8
         PUSH H                   ; 1D12 e5
         LXI  D,0666h             ; 1D13 11 66 06
         DAD  D                   ; 1D16 19
         XCHG                     ; 1D17 eb
         LXI  H,000Dh             ; 1D18 21 0d 00
         DAD  D                   ; 1D1B 19
         XCHG                     ; 1D1C eb
         LXI  B,7F0Dh             ; 1D1D 01 0d 7f
L_1D20:  PUSH B                   ; 1D20 c5
         RST  5                   ; 1D21 ef
         LXI  B,0FFE6h            ; 1D22 01 e6 ff
         DAD  B                   ; 1D25 09
         XCHG                     ; 1D26 eb
         DAD  B                   ; 1D27 09
         XCHG                     ; 1D28 eb
         POP  B                   ; 1D29 c1
         DCR  B                   ; 1D2A 05
         JNZ  L_1D20              ; 1D2B c2 20 1d
         POP  D                   ; 1D2E d1
         LXI  H,1FE2h             ; 1D2F 21 e2 1f
         RST  5                   ; 1D32 ef
         LXI  H,0B689h            ; 1D33 21 89 b6
         CALL L_0E47              ; 1D36 cd 47 0e
         INR  M                   ; 1D39 34
         RET                      ; 1D3A c9
L_1D3B:  ADI  30h                 ; 1D3B c6 30
L_1D3D:  CPI  3Ah                 ; 1D3D fe 3a
L_1D3F:  RC                       ; 1D3F d8
L_1D40:  ADI  07h                 ; 1D40 c6 07
L_1D42:  RET                      ; 1D42 c9
L_1D43:  MVI  E,10h               ; 1D43 1e 10
L_1D45:  DCR  E                   ; 1D45 1d
L_1D46:  PUSH D                   ; 1D46 d5
L_1D47:  MOV  A,E                 ; 1D47 7b
L_1D48:  CALL L_1D3B              ; 1D48 cd 3b 1d
L_1D4B:  STA  L_1FE9              ; 1D4B 32 e9 1f
L_1D4E:  CALL L_1D5B              ; 1D4E cd 5b 1d
L_1D51:  CZ   L_1D05              ; 1D51 cc 05 1d
L_1D54:  POP  D                   ; 1D54 d1
L_1D55:  INR  E                   ; 1D55 1c
L_1D56:  DCR  E                   ; 1D56 1d
L_1D57:  JNZ  L_1D45              ; 1D57 c2 45 1d
L_1D5A:  RET                      ; 1D5A c9
L_1D5B:  LDA  0A837h              ; 1D5B 3a 37 a8
L_1D5E:  CMP  E                   ; 1D5E bb
L_1D5F:  JZ   L_1D6F              ; 1D5F ca 6f 1d
L_1D62:  MOV  A,E                 ; 1D62 7b
L_1D63:  LXI  H,0A88Ch            ; 1D63 21 8c a8
L_1D66:  MVI  C,40h               ; 1D66 0e 40
L_1D68:  CMP  M                   ; 1D68 be
L_1D69:  RZ                       ; 1D69 c8
L_1D6A:  INX  H                   ; 1D6A 23
L_1D6B:  DCR  C                   ; 1D6B 0d
L_1D6C:  JNZ  L_1D68              ; 1D6C c2 68 1d
L_1D6F:  CPI  14h                 ; 1D6F fe 14
L_1D71:  RET                      ; 1D71 c9
L_1D72:  LHLD 0A881h              ; 1D72 2a 81 a8
         INX  H                   ; 1D75 23
         SHLD 0A881h              ; 1D76 22 81 a8
         JMP  L_1AEC              ; 1D79 c3 ec 1a
L_1D7C:  PUSH D                   ; 1D7C d5
         LXI  B,0080h             ; 1D7D 01 80 00
         CALL 0C024h              ; 1D80 cd 24 c0
         LXI  B,0008h             ; 1D83 01 08 00
         CALL 0C01Eh              ; 1D86 cd 1e c0
         MVI  C,00h               ; 1D89 0e 00
         MVI  B,00h               ; 1D8B 06 00
         MVI  A,0E5h              ; 1D8D 3e e5
         LXI  H,0A88Ch            ; 1D8F 21 8c a8
L_1D92:  CMP  M                   ; 1D92 be
         JZ   L_1D9E              ; 1D93 ca 9e 1d
         INX  H                   ; 1D96 23
         INR  B                   ; 1D97 04
         DCR  C                   ; 1D98 0d
         JNZ  L_1D92              ; 1D99 c2 92 1d
         POP  D                   ; 1D9C d1
         RET                      ; 1D9D c9
L_1D9E:  SHLD 1D90h               ; 1D9E 22 90 1d
         MOV  A,C                 ; 1DA1 79
         STA  1D8Ah               ; 1DA2 32 8a 1d
         MOV  A,B                 ; 1DA5 78
         STA  1D8Ch               ; 1DA6 32 8c 1d
         MOV  M,C                 ; 1DA9 71
         PUSH PSW                 ; 1DAA f5
         CALL L_1DC8              ; 1DAB cd c8 1d
         POP  PSW                 ; 1DAE f1
         POP  H                   ; 1DAF e1
         ANI  03h                 ; 1DB0 e6 03
         INR  A                   ; 1DB2 3c
         MOV  C,A                 ; 1DB3 4f
         MVI  A,60h               ; 1DB4 3e 60
L_1DB6:  ADI  20h                 ; 1DB6 c6 20
         DCR  C                   ; 1DB8 0d
         JNZ  L_1DB6              ; 1DB9 c2 b6 1d
         MOV  E,A                 ; 1DBC 5f
         MVI  D,00h               ; 1DBD 16 00
         MVI  C,20h               ; 1DBF 0e 20
         RST  5                   ; 1DC1 ef
         JMP  0C02Ah              ; 1DC2 c3 2a c0
L_1DC5:  LDA  0A835h              ; 1DC5 3a 35 a8
L_1DC8:  ANI  7Ch                 ; 1DC8 e6 7c
L_1DCA:  RRC                      ; 1DCA 0f
L_1DCB:  RRC                      ; 1DCB 0f
L_1DCC:  INR  A                   ; 1DCC 3c
L_1DCD:  MOV  C,A                 ; 1DCD 4f
L_1DCE:  MVI  B,00h               ; 1DCE 06 00
L_1DD0:  CALL 0C021h              ; 1DD0 cd 21 c0
L_1DD3:  JMP  0C027h              ; 1DD3 c3 27 c0
L_1DD6:  LXI  H,0A887h            ; 1DD6 21 87 a8
L_1DD9:  CALL L_0E4D              ; 1DD9 cd 4d 0e
L_1DDC:  MOV  A,M                 ; 1DDC 7e
L_1DDD:  STA  0A837h              ; 1DDD 32 37 a8
L_1DE0:  LXI  H,3E91h             ; 1DE0 21 91 3e
L_1DE3:  CALL L_0E4D              ; 1DE3 cd 4d 0e
L_1DE6:  MOV  A,M                 ; 1DE6 7e
         CPI  43h                 ; 1DE7 fe 43
L_1DE9:  MVI  A,40h               ; 1DE9 3e 40
L_1DEB:  JZ   L_1DF0              ; 1DEB ca f0 1d
L_1DEE:  MVI  A,80h               ; 1DEE 3e 80
L_1DF0:  MVI  B,00h               ; 1DF0 06 00
L_1DF2:  MVI  C,00h               ; 1DF2 0e 00
L_1DF4:  PUSH PSW                 ; 1DF4 f5
L_1DF5:  STA  1D67h               ; 1DF5 32 67 1d
L_1DF8:  CALL 0C01Eh              ; 1DF8 cd 1e c0
L_1DFB:  POP  PSW                 ; 1DFB f1
L_1DFC:  LXI  H,0A88Ch            ; 1DFC 21 8c a8
L_1DFF:  INR  A                   ; 1DFF 3c
L_1E00:  STA  0A836h              ; 1E00 32 36 a8
L_1E03:  SHLD 0A833h              ; 1E03 22 33 a8
L_1E06:  XRA  A                   ; 1E06 af
L_1E07:  STA  0A835h              ; 1E07 32 35 a8
L_1E0A:  LXI  H,0A835h            ; 1E0A 21 35 a8
L_1E0D:  INR  M                   ; 1E0D 34
L_1E0E:  LDA  0A836h              ; 1E0E 3a 36 a8
L_1E11:  CMP  M                   ; 1E11 be
L_1E12:  MVI  A,0FFh              ; 1E12 3e ff
L_1E14:  RZ                       ; 1E14 c8
L_1E15:  MOV  A,M                 ; 1E15 7e
L_1E16:  ANI  03h                 ; 1E16 e6 03
L_1E18:  CPI  01h                 ; 1E18 fe 01
L_1E1A:  CZ   L_1DC5              ; 1E1A cc c5 1d
L_1E1D:  LDA  0A835h              ; 1E1D 3a 35 a8
L_1E20:  ANI  03h                 ; 1E20 e6 03
L_1E22:  ADI  04h                 ; 1E22 c6 04
L_1E24:  DCR  A                   ; 1E24 3d
L_1E25:  ANI  03h                 ; 1E25 e6 03
L_1E27:  MOV  D,A                 ; 1E27 57
L_1E28:  INR  A                   ; 1E28 3c
L_1E29:  MOV  C,A                 ; 1E29 4f
L_1E2A:  XRA  A                   ; 1E2A af
L_1E2B:  ADI  20h                 ; 1E2B c6 20
L_1E2D:  DCR  C                   ; 1E2D 0d
L_1E2E:  JNZ  L_1E2B              ; 1E2E c2 2b 1e
L_1E31:  ADI  60h                 ; 1E31 c6 60
L_1E33:  MOV  C,A                 ; 1E33 4f
L_1E34:  MVI  B,00h               ; 1E34 06 00
L_1E36:  LDAX B                   ; 1E36 0a
L_1E37:  LHLD 0A833h              ; 1E37 2a 33 a8
L_1E3A:  MOV  M,A                 ; 1E3A 77
L_1E3B:  INX  H                   ; 1E3B 23
L_1E3C:  SHLD 0A833h              ; 1E3C 22 33 a8
L_1E3F:  MOV  E,A                 ; 1E3F 5f
L_1E40:  LDA  0A837h              ; 1E40 3a 37 a8
L_1E43:  CMP  E                   ; 1E43 bb
L_1E44:  MOV  A,D                 ; 1E44 7a
L_1E45:  RZ                       ; 1E45 c8
L_1E46:  MOV  A,E                 ; 1E46 7b
L_1E47:  CPI  0E5h                ; 1E47 fe e5
L_1E49:  JNZ  L_1E0A              ; 1E49 c2 0a 1e
L_1E4C:  INX  B                   ; 1E4C 03
L_1E4D:  LDAX B                   ; 1E4D 0a
L_1E4E:  CPI  0E5h                ; 1E4E fe e5
L_1E50:  JNZ  L_1E0A              ; 1E50 c2 0a 1e
L_1E53:  LDA  0A836h              ; 1E53 3a 36 a8
L_1E56:  MOV  C,A                 ; 1E56 4f
L_1E57:  LDA  0A835h              ; 1E57 3a 35 a8
L_1E5A:  LHLD 0A833h              ; 1E5A 2a 33 a8
L_1E5D:  INR  A                   ; 1E5D 3c
L_1E5E:  CMP  C                   ; 1E5E b9
L_1E5F:  JZ   L_1E68              ; 1E5F ca 68 1e
L_1E62:  MVI  M,0F5h              ; 1E62 36 f5
L_1E64:  INX  H                   ; 1E64 23
L_1E65:  JMP  L_1E5D              ; 1E65 c3 5d 1e
L_1E68:  MVI  A,0FFh              ; 1E68 3e ff
L_1E6A:  RET                      ; 1E6A c9
L_1E6B:  PUSH H                   ; 1E6B e5
L_1E6C:  ADD  A                   ; 1E6C 87
L_1E6D:  ADI  96h                 ; 1E6D c6 96
L_1E6F:  MOV  L,A                 ; 1E6F 6f
L_1E70:  MVI  H,0DEh              ; 1E70 26 de
L_1E72:  MOV  A,M                 ; 1E72 7e
L_1E73:  POP  H                   ; 1E73 e1
L_1E74:  RET                      ; 1E74 c9
L_1E75:  MOV  M,A                 ; 1E75 77
L_1E76:  INX  H                   ; 1E76 23
L_1E77:  DCR  C                   ; 1E77 0d
L_1E78:  JNZ  L_1E75              ; 1E78 c2 75 1e
L_1E7B:  RET                      ; 1E7B c9
L_1E7C:  LXI  H,0A88Ch            ; 1E7C 21 8c a8
L_1E7F:  SHLD 1D90h               ; 1E7F 22 90 1d
L_1E82:  SHLD 0A82Dh              ; 1E82 22 2d a8
L_1E85:  XRA  A                   ; 1E85 af
L_1E86:  STA  1D8Ch               ; 1E86 32 8c 1d
L_1E89:  LDA  0A849h              ; 1E89 3a 49 a8
L_1E8C:  SUI  41h                 ; 1E8C d6 41
L_1E8E:  PUSH PSW                 ; 1E8E f5
L_1E8F:  MOV  E,A                 ; 1E8F 5f
L_1E90:  MVI  C,0Eh               ; 1E90 0e 0e
L_1E92:  RST  1                   ; 1E92 cf
L_1E93:  POP  PSW                 ; 1E93 f1
L_1E94:  CALL L_1E6B              ; 1E94 cd 6b 1e
L_1E97:  STA  1D84h               ; 1E97 32 84 1d
L_1E9A:  MOV  C,A                 ; 1E9A 4f
L_1E9B:  MVI  B,00h               ; 1E9B 06 00
L_1E9D:  CALL 0C01Eh              ; 1E9D cd 1e c0
L_1EA0:  MVI  C,1Fh               ; 1EA0 0e 1f
L_1EA2:  RST  1                   ; 1EA2 cf
L_1EA3:  LXI  D,0005h             ; 1EA3 11 05 00
L_1EA6:  DAD  D                   ; 1EA6 19
L_1EA7:  MOV  C,M                 ; 1EA7 4e
L_1EA8:  INX  H                   ; 1EA8 23
L_1EA9:  MOV  B,M                 ; 1EA9 46
L_1EAA:  LXI  H,0A101h            ; 1EAA 21 01 a1
L_1EAD:  SHLD 17ADh               ; 1EAD 22 ad 17
L_1EB0:  MVI  A,53h               ; 1EB0 3e 53
L_1EB2:  CALL L_1E75              ; 1EB2 cd 75 1e
L_1EB5:  DCR  B                   ; 1EB5 05
L_1EB6:  MOV  C,B                 ; 1EB6 48
L_1EB7:  CZ   L_1E75              ; 1EB7 cc 75 1e
L_1EBA:  MVI  M,00h               ; 1EBA 36 00
L_1EBC:  LXI  H,0080h             ; 1EBC 21 80 00
L_1EBF:  SHLD 0DDF6h              ; 1EBF 22 f6 dd
L_1EC2:  LDA  0A849h              ; 1EC2 3a 49 a8
L_1EC5:  CPI  43h                 ; 1EC5 fe 43
L_1EC7:  MVI  A,40h               ; 1EC7 3e 40
L_1EC9:  LXI  H,1F28h             ; 1EC9 21 28 1f
L_1ECC:  JZ   L_1ED4              ; 1ECC ca d4 1e
L_1ECF:  MVI  A,80h               ; 1ECF 3e 80
L_1ED1:  LXI  H,1F0Bh             ; 1ED1 21 0b 1f
L_1ED4:  SHLD 1F00h               ; 1ED4 22 00 1f
L_1ED7:  STA  1D8Ah               ; 1ED7 32 8a 1d
L_1EDA:  RRC                      ; 1EDA 0f
L_1EDB:  RRC                      ; 1EDB 0f
L_1EDC:  MOV  B,A                 ; 1EDC 47
L_1EDD:  MVI  C,01h               ; 1EDD 0e 01
L_1EDF:  PUSH B                   ; 1EDF c5
L_1EE0:  CALL L_1DCE              ; 1EE0 cd ce 1d
L_1EE3:  CALL L_1EED              ; 1EE3 cd ed 1e
L_1EE6:  POP  B                   ; 1EE6 c1
L_1EE7:  INR  C                   ; 1EE7 0c
L_1EE8:  DCR  B                   ; 1EE8 05
L_1EE9:  JNZ  L_1EDF              ; 1EE9 c2 df 1e
L_1EEC:  RET                      ; 1EEC c9
L_1EED:  LHLD 0A82Dh              ; 1EED 2a 2d a8
L_1EF0:  XCHG                     ; 1EF0 eb
L_1EF1:  LXI  H,0060h             ; 1EF1 21 60 00
L_1EF4:  MVI  C,04h               ; 1EF4 0e 04
L_1EF6:  MOV  A,L                 ; 1EF6 7d
L_1EF7:  ADI  20h                 ; 1EF7 c6 20
L_1EF9:  MOV  L,A                 ; 1EF9 6f
L_1EFA:  MOV  A,M                 ; 1EFA 7e
L_1EFB:  STAX D                   ; 1EFB 12
L_1EFC:  INX  D                   ; 1EFC 13
L_1EFD:  CPI  0E5h                ; 1EFD fe e5
L_1EFF:  CNZ  L_1F0B              ; 1EFF c4 0b 1f
L_1F02:  DCR  C                   ; 1F02 0d
L_1F03:  JNZ  L_1EF6              ; 1F03 c2 f6 1e
L_1F06:  XCHG                     ; 1F06 eb
L_1F07:  SHLD 0A82Dh              ; 1F07 22 2d a8
L_1F0A:  RET                      ; 1F0A c9
L_1F0B:  PUSH H                   ; 1F0B e5
L_1F0C:  PUSH D                   ; 1F0C d5
L_1F0D:  PUSH B                   ; 1F0D c5
L_1F0E:  MOV  A,L                 ; 1F0E 7d
L_1F0F:  ADI  10h                 ; 1F0F c6 10
L_1F11:  MOV  E,A                 ; 1F11 5f
L_1F12:  MVI  D,00h               ; 1F12 16 00
L_1F14:  MVI  C,08h               ; 1F14 0e 08
L_1F16:  LDAX D                   ; 1F16 1a
L_1F17:  MOV  L,A                 ; 1F17 6f
L_1F18:  INX  D                   ; 1F18 13
L_1F19:  LDAX D                   ; 1F19 1a
L_1F1A:  INX  D                   ; 1F1A 13
L_1F1B:  ADI  0A1h                ; 1F1B c6 a1
L_1F1D:  MOV  H,A                 ; 1F1D 67
L_1F1E:  MVI  M,5Ah               ; 1F1E 36 5a
L_1F20:  DCR  C                   ; 1F20 0d
L_1F21:  JNZ  L_1F16              ; 1F21 c2 16 1f
L_1F24:  POP  B                   ; 1F24 c1
L_1F25:  POP  D                   ; 1F25 d1
L_1F26:  POP  H                   ; 1F26 e1
L_1F27:  RET                      ; 1F27 c9
L_1F28:  PUSH H                   ; 1F28 e5
L_1F29:  PUSH D                   ; 1F29 d5
L_1F2A:  PUSH B                   ; 1F2A c5
L_1F2B:  MOV  A,L                 ; 1F2B 7d
L_1F2C:  ADI  10h                 ; 1F2C c6 10
L_1F2E:  MOV  E,A                 ; 1F2E 5f
L_1F2F:  MVI  D,00h               ; 1F2F 16 00
L_1F31:  MVI  C,10h               ; 1F31 0e 10
L_1F33:  LDAX D                   ; 1F33 1a
L_1F34:  MOV  L,A                 ; 1F34 6f
L_1F35:  INX  D                   ; 1F35 13
L_1F36:  MVI  H,0A1h              ; 1F36 26 a1
L_1F38:  MVI  M,5Ah               ; 1F38 36 5a
L_1F3A:  DCR  C                   ; 1F3A 0d
L_1F3B:  JNZ  L_1F33              ; 1F3B c2 33 1f
L_1F3E:  POP  B                   ; 1F3E c1
L_1F3F:  POP  D                   ; 1F3F d1
L_1F40:  POP  H                   ; 1F40 e1
L_1F41:  RET                      ; 1F41 c9
L_1F42:  .db 00h                                              ; 1F42 |.|
L_1F43:  .db 00h                                              ; 1F43 |.|
L_1F44:  .db 00h,20h                                          ; 1F44 |. |
L_1F46:  .db 00h                                              ; 1F46 |.|
L_1F47:  .db 00h                                              ; 1F47 |.|
L_1F48:  .db 00h,20h,0E2h,0C1h,0CAh,0D4h,00h,20h,20h,28h,00h,00h,00h,20h,0EBh,0C2h ; 1F48 |. .....  (... ..|
         .db 29h,00h,43h,4Fh,20h,20h,20h,20h,20h,20h,20h,50h,52h,4Dh,43h,4Fh ; 1F58 |).CO       PRMCO|
         .db 20h,20h,20h,20h,20h,20h,20h,50h,54h,4Bh,3Eh,43h,3Ah,43h,4Fh,2Eh ; 1F68 |       PTK>C:CO.|
         .db 50h,54h,4Bh,1Bh,50h                              ; 1F78 |PTK.P|
L_1F7D:  .db 00h                                              ; 1F7D |.|
L_1F7E:  .db 0FFh                                             ; 1F7E |.|
L_1F7F:  .db 09h,0E6h,0C1h,0CAh,0CCh,00h,20h,0FAh,0C1h,0DDh,0C9h,0DDh,0C5h,0CEh,20h,00h ; 1F7F |...... ....... .|
         .db 20h,0F5h,0C4h,0C1h,0CCh,0D1h,0D4h,0D8h,3Fh,20h,28h,59h,2Fh,4Eh,29h,00h ; 1F8F | .......? (Y/N).|
         .db 20h,0F3h,0C9h,0D3h,0D4h,0C5h,0CDh,0CEh,0D9h,0CAh,00h ; 1F9F | ..........|
L_1FAA:  .db 00h,20h,0CEh,0C1h,20h,0C4h,0C9h,0D3h,0CBh,0C5h,20h,22h,00h,20h,0D5h,0D6h ; 1FAA |. .. ..... ". ..|
         .db 0C5h,20h,0C5h,0D3h,0D4h,0D8h,2Eh,00h,20h,0FAh,0C1h,0CDh,0C5h,0CEh,0D1h,0D4h ; 1FBA |. ...... .......|
         .db 0D8h,3Fh,20h,28h,59h,2Fh,4Eh,29h,20h,20h,20h,20h,08h,08h,08h,00h ; 1FCA |.? (Y/N)    ....|
         .db 59h,65h,73h,00h,4Eh,6Fh,20h,00h,2Eh,20h,75h,73h,65h,72h,20h ; 1FDA |Yes.No .. user |
L_1FE9:  .db 30h,20h,64h,69h,72h,00h,0E4h,0C9h,0D3h,0CBh,20h,0D0h,0CFh,0CCh,0CEh,0D9h ; 1FE9 |0 dir..... .....|
         .db 0CAh,00h,20h,2Dh,20h,0E6h,0C1h                   ; 1FF9 |.. - ..|
L_2000:  JZ   20CCh               ; 2000 ca cc 20
         ACI  0C5h                ; 2003 ce c5
         .db 20h                                              ; 2005 DB   20h
         SBI  0C9h                ; 2006 de c9
         CNC  0C5C1h              ; 2008 d4 c1 c5
         CNC  0D1D3h              ; 200B d4 d3 d1
         NOP                      ; 200E 00
L_200F:  MVI  C,06h               ; 200F 0e 06
L_2011:  MVI  E,0FFh              ; 2011 1e ff
L_2013:  CALL 0005h               ; 2013 cd 05 00
L_2016:  CPI  00h                 ; 2016 fe 00
L_2018:  JNZ  L_200F              ; 2018 c2 0f 20
L_201B:  LDA  0DF15h              ; 201B 3a 15 df
L_201E:  CPI  3Ch                 ; 201E fe 3c
L_2020:  JZ   L_2054              ; 2020 ca 54 20
L_2023:  CALL L_1009              ; 2023 cd 09 10
L_2026:  LXI  H,203Ah             ; 2026 21 3a 20
L_2029:  SHLD 0C05Dh              ; 2029 22 5d c0
L_202C:  LXI  H,0E176h            ; 202C 21 76 e1
L_202F:  SHLD 0DA32h              ; 202F 22 32 da
L_2032:  MVI  A,31h               ; 2032 3e 31
L_2034:  STA  0DA31h              ; 2034 32 31 da
L_2037:  JMP  L_205D              ; 2037 c3 5d 20
L_203A:  PUSH PSW                 ; 203A f5
L_203B:  PUSH B                   ; 203B c5
L_203C:  PUSH D                   ; 203C d5
L_203D:  PUSH H                   ; 203D e5
L_203E:  LXI  H,0C013h            ; 203E 21 13 c0
L_2041:  SHLD 0C05Dh              ; 2041 22 5d c0
L_2044:  LXI  H,0DF65h            ; 2044 21 65 df
L_2047:  SHLD 0DA32h              ; 2047 22 32 da
L_204A:  MVI  A,0C3h              ; 204A 3e c3
L_204C:  STA  0DA31h              ; 204C 32 31 da
L_204F:  POP  H                   ; 204F e1
L_2050:  POP  D                   ; 2050 d1
L_2051:  POP  B                   ; 2051 c1
L_2052:  POP  PSW                 ; 2052 f1
L_2053:  RET                      ; 2053 c9
L_2054:  CALL L_1009              ; 2054 cd 09 10
L_2057:  LXI  H,2066h             ; 2057 21 66 20
L_205A:  SHLD 0C05Dh              ; 205A 22 5d c0
L_205D:  LXI  H,0E2BDh            ; 205D 21 bd e2
L_2060:  SHLD 0E213h              ; 2060 22 13 e2
L_2063:  JMP  0000h               ; 2063 c3 00 00
L_2066:  PUSH PSW                 ; 2066 f5
L_2067:  PUSH H                   ; 2067 e5
L_2068:  LXI  H,0C713h            ; 2068 21 13 c7
L_206B:  SHLD 0C05Dh              ; 206B 22 5d c0
L_206E:  POP  H                   ; 206E e1
L_206F:  POP  PSW                 ; 206F f1
L_2070:  RET                      ; 2070 c9
L_2071:  SHLD L_207B              ; 2071 22 7b 20
L_2074:  LXI  H,2079h             ; 2074 21 79 20
L_2077:  RST  3                   ; 2077 df
L_2078:  RET                      ; 2078 c9
         .db 1Bh,59h                                          ; 2079 |.Y|
L_207B:  .db 00h,00h,00h                                      ; 207B |...|
L_207E:  LXI  D,20C3h             ; 207E 11 c3 20
L_2081:  CALL L_28D2              ; 2081 cd d2 28
L_2084:  LXI  B,20C5h             ; 2084 01 c5 20
L_2087:  LXI  H,0000h             ; 2087 21 00 00
L_208A:  LDA  L_20C4              ; 208A 3a c4 20
L_208D:  ORA  A                   ; 208D b7
L_208E:  JZ   L_20B5              ; 208E ca b5 20
L_2091:  DCR  A                   ; 2091 3d
L_2092:  JZ   L_20AF              ; 2092 ca af 20
L_2095:  DCR  A                   ; 2095 3d
L_2096:  JZ   L_20A9              ; 2096 ca a9 20
         DCR  A                   ; 2099 3d
         JZ   L_20A3              ; 209A ca a3 20
         LXI  D,03E8h             ; 209D 11 e8 03
         CALL L_20B9              ; 20A0 cd b9 20
L_20A3:  LXI  D,0064h             ; 20A3 11 64 00
         CALL L_20B9              ; 20A6 cd b9 20
L_20A9:  LXI  D,000Ah             ; 20A9 11 0a 00
L_20AC:  CALL L_20B9              ; 20AC cd b9 20
L_20AF:  LXI  D,0001h             ; 20AF 11 01 00
L_20B2:  CALL L_20B9              ; 20B2 cd b9 20
L_20B5:  POP  B                   ; 20B5 c1
L_20B6:  PUSH H                   ; 20B6 e5
L_20B7:  PUSH B                   ; 20B7 c5
L_20B8:  RET                      ; 20B8 c9
L_20B9:  LDAX B                   ; 20B9 0a
L_20BA:  INX  B                   ; 20BA 03
L_20BB:  SUI  2Fh                 ; 20BB d6 2f
L_20BD:  DCR  A                   ; 20BD 3d
L_20BE:  RZ                       ; 20BE c8
L_20BF:  DAD  D                   ; 20BF 19
L_20C0:  JMP  L_20BD              ; 20C0 c3 bd 20
         .db 05h                                              ; 20C3 |.|
L_20C4:  .db 00h,00h,00h,00h,00h                              ; 20C4 |.....|
L_20C9:  NOP                      ; 20C9 00
L_20CA:  LXI  H,0A954h            ; 20CA 21 54 a9
L_20CD:  LDA  0B69Dh              ; 20CD 3a 9d b6
L_20D0:  DCR  A                   ; 20D0 3d
L_20D1:  JZ   L_20D8              ; 20D1 ca d8 20
L_20D4:  LXI  D,0680h             ; 20D4 11 80 06
L_20D7:  DAD  D                   ; 20D7 19
L_20D8:  SHLD 0A842h              ; 20D8 22 42 a8
L_20DB:  RET                      ; 20DB c9
L_20DC:  CALL L_29DF              ; 20DC cd df 29
L_20DF:  LXI  D,0B663h            ; 20DF 11 63 b6
L_20E2:  MVI  C,08h               ; 20E2 0e 08
L_20E4:  CALL L_20F5              ; 20E4 cd f5 20
L_20E7:  INX  H                   ; 20E7 23
L_20E8:  INX  D                   ; 20E8 13
L_20E9:  MVI  C,03h               ; 20E9 0e 03
L_20EB:  CALL L_20F5              ; 20EB cd f5 20
L_20EE:  LXI  H,0001h             ; 20EE 21 01 00
L_20F1:  SHLD 0B68Dh              ; 20F1 22 8d b6
L_20F4:  RET                      ; 20F4 c9
L_20F5:  LDAX D                   ; 20F5 1a
L_20F6:  CMP  M                   ; 20F6 be
L_20F7:  CNZ  L_2101              ; 20F7 c4 01 21
L_20FA:  INX  H                   ; 20FA 23
L_20FB:  INX  D                   ; 20FB 13
L_20FC:  DCR  C                   ; 20FC 0d
L_20FD:  JNZ  L_20F5              ; 20FD c2 f5 20
L_2100:  RET                      ; 2100 c9
L_2101:  CPI  3Fh                 ; 2101 fe 3f
L_2103:  RZ                       ; 2103 c8
L_2104:  POP  H                   ; 2104 e1
L_2105:  POP  H                   ; 2105 e1
L_2106:  RET                      ; 2106 c9
L_2107:  LXI  H,0B663h            ; 2107 21 63 b6
L_210A:  LXI  D,006Dh             ; 210A 11 6d 00
L_210D:  MVI  C,08h               ; 210D 0e 08
L_210F:  RST  5                   ; 210F ef
L_2110:  INX  H                   ; 2110 23
L_2111:  MVI  C,03h               ; 2111 0e 03
L_2113:  RST  5                   ; 2113 ef
L_2114:  CALL L_29DF              ; 2114 cd df 29
L_2117:  LXI  H,3E91h             ; 2117 21 91 3e
L_211A:  CALL L_0E4D              ; 211A cd 4d 0e
L_211D:  MOV  A,M                 ; 211D 7e
L_211E:  STA  0B673h              ; 211E 32 73 b6
L_2121:  PUSH PSW                 ; 2121 f5
L_2122:  CALL L_19B8              ; 2122 cd b8 19
L_2125:  POP  PSW                 ; 2125 f1
L_2126:  SUI  40h                 ; 2126 d6 40
L_2128:  STA  006Ch               ; 2128 32 6c 00
L_212B:  XRA  A                   ; 212B af
L_212C:  MVI  C,04h               ; 212C 0e 04
L_212E:  LXI  H,0078h             ; 212E 21 78 00
L_2131:  MOV  M,A                 ; 2131 77
L_2132:  DCR  C                   ; 2132 0d
L_2133:  JNZ  L_2131              ; 2133 c2 31 21
L_2136:  LXI  D,005Ch             ; 2136 11 5c 00
L_2139:  MVI  C,17h               ; 2139 0e 17
L_213B:  RST  1                   ; 213B cf
L_213C:  RET                      ; 213C c9
L_213D:  LXI  H,0B689h            ; 213D 21 89 b6
L_2140:  CALL L_0E47              ; 2140 cd 47 0e
L_2143:  XRA  A                   ; 2143 af
L_2144:  CMP  M                   ; 2144 be
L_2145:  JNZ  L_2157              ; 2145 c2 57 21
         CALL L_20CA              ; 2148 cd ca 20
         LXI  D,353Bh             ; 214B 11 3b 35
         CALL L_3979              ; 214E cd 79 39
         LXI  H,0001h             ; 2151 21 01 00
         SHLD 0B69Bh              ; 2154 22 9b b6
L_2157:  LXI  H,266Dh             ; 2157 21 6d 26
L_215A:  CALL L_0D13              ; 215A cd 13 0d
L_215D:  CALL L_29DF              ; 215D cd df 29
L_2160:  CALL L_22AC              ; 2160 cd ac 22
L_2163:  LDA  0B68Dh              ; 2163 3a 8d b6
L_2166:  CPI  01h                 ; 2166 fe 01
L_2168:  JZ   L_0FE0              ; 2168 ca e0 0f
         CALL L_025B              ; 216B cd 5b 02
         LXI  H,3E91h             ; 216E 21 91 3e
         CALL L_0E4D              ; 2171 cd 4d 0e
         MOV  A,M                 ; 2174 7e
         STA  0B673h              ; 2175 32 73 b6
         LXI  H,0B663h            ; 2178 21 63 b6
         SHLD 0A842h              ; 217B 22 42 a8
         CALL L_198F              ; 217E cd 8f 19
         CALL L_0FF3              ; 2181 cd f3 0f
         CALL L_0273              ; 2184 cd 73 02
         JMP  L_0E93              ; 2187 c3 93 0e
L_218A:  LXI  H,2657h             ; 218A 21 57 26
L_218D:  CALL L_0D13              ; 218D cd 13 0d
L_2190:  CALL L_231E              ; 2190 cd 1e 23
L_2193:  LDA  0B68Dh              ; 2193 3a 8d b6
L_2196:  DCR  A                   ; 2196 3d
L_2197:  JZ   L_0FE0              ; 2197 ca e0 0f
L_219A:  LXI  H,3E91h             ; 219A 21 91 3e
L_219D:  CALL L_0E4D              ; 219D cd 4d 0e
L_21A0:  MOV  A,M                 ; 21A0 7e
L_21A1:  STA  0B673h              ; 21A1 32 73 b6
L_21A4:  CALL L_0262              ; 21A4 cd 62 02
L_21A7:  CALL L_21F8              ; 21A7 cd f8 21
L_21AA:  LXI  H,21CDh             ; 21AA 21 cd 21
L_21AD:  CALL L_0B7A              ; 21AD cd 7a 0b
L_21B0:  CALL L_0273              ; 21B0 cd 73 02
L_21B3:  LXI  H,0B681h            ; 21B3 21 81 b6
L_21B6:  CALL L_0E47              ; 21B6 cd 47 0e
L_21B9:  XRA  A                   ; 21B9 af
L_21BA:  MOV  M,A                 ; 21BA 77
L_21BB:  CALL L_091B              ; 21BB cd 1b 09
L_21BE:  MVI  A,01h               ; 21BE 3e 01
L_21C0:  STA  0B69Bh              ; 21C0 32 9b b6
L_21C3:  CALL L_0CD9              ; 21C3 cd d9 0c
L_21C6:  XRA  A                   ; 21C6 af
L_21C7:  STA  0B68Dh              ; 21C7 32 8d b6
L_21CA:  JMP  L_0FE0              ; 21CA c3 e0 0f
L_21CD:  CALL L_2201              ; 21CD cd 01 22
L_21D0:  CALL L_29DF              ; 21D0 cd df 29
L_21D3:  CALL L_22AF              ; 21D3 cd af 22
L_21D6:  LXI  H,0B663h            ; 21D6 21 63 b6
L_21D9:  SHLD 0A842h              ; 21D9 22 42 a8
L_21DC:  CALL L_19A2              ; 21DC cd a2 19
L_21DF:  LDA  0A848h              ; 21DF 3a 48 a8
L_21E2:  CPI  59h                 ; 21E2 fe 59
L_21E4:  JNZ  L_0FE0              ; 21E4 c2 e0 0f
L_21E7:  LXI  H,0000h             ; 21E7 21 00 00
L_21EA:  SHLD 0B68Dh              ; 21EA 22 8d b6
L_21ED:  MVI  A,03h               ; 21ED 3e 03
L_21EF:  STA  0A94Bh              ; 21EF 32 4b a9
L_21F2:  CALL L_0C2F              ; 21F2 cd 2f 0c
L_21F5:  JMP  L_2107              ; 21F5 c3 07 21
L_21F8:  LXI  H,0B663h            ; 21F8 21 63 b6
L_21FB:  LXI  D,0A90Dh            ; 21FB 11 0d a9
L_21FE:  JMP  L_3979              ; 21FE c3 79 39
L_2201:  LXI  H,0A90Dh            ; 2201 21 0d a9
L_2204:  LXI  D,0B663h            ; 2204 11 63 b6
L_2207:  JMP  L_3979              ; 2207 c3 79 39
L_220A:  XRA  A                   ; 220A af
L_220B:  STA  0B68Dh              ; 220B 32 8d b6
L_220E:  LXI  H,2641h             ; 220E 21 41 26
L_2211:  CALL L_0D13              ; 2211 cd 13 0d
L_2214:  CALL L_231E              ; 2214 cd 1e 23
L_2217:  LDA  0B68Dh              ; 2217 3a 8d b6
L_221A:  DCR  A                   ; 221A 3d
L_221B:  JZ   L_0FE0              ; 221B ca e0 0f
L_221E:  CALL L_0FE0              ; 221E cd e0 0f
L_2221:  CALL L_0A5B              ; 2221 cd 5b 0a
         LDA  L_10BE              ; 2224 3a be 10
         STA  0A849h              ; 2227 32 49 a8
         CALL L_0B5C              ; 222A cd 5c 0b
         CALL L_0262              ; 222D cd 62 02
         LDA  L_10BA              ; 2230 3a ba 10
         STA  0A84Ah              ; 2233 32 4a a8
         CALL L_0B6B              ; 2236 cd 6b 0b
         CALL L_0262              ; 2239 cd 62 02
         CALL L_1E7C              ; 223C cd 7c 1e
         LXI  H,0B663h            ; 223F 21 63 b6
         SHLD 0A84Dh              ; 2242 22 4d a8
         CALL L_21F8              ; 2245 cd f8 21
         LXI  H,2286h             ; 2248 21 86 22
         CALL L_0B7A              ; 224B cd 7a 0b
         LDA  0A849h              ; 224E 3a 49 a8
         CALL L_027A              ; 2251 cd 7a 02
L_2254:  MVI  C,0Dh               ; 2254 0e 0d
L_2256:  RST  1                   ; 2256 cf
L_2257:  LDA  0B69Dh              ; 2257 3a 9d b6
L_225A:  PUSH PSW                 ; 225A f5
L_225B:  MVI  A,01h               ; 225B 3e 01
L_225D:  STA  0B69Dh              ; 225D 32 9d b6
L_2260:  LXI  H,3E91h             ; 2260 21 91 3e
L_2263:  LDA  L_10BE              ; 2263 3a be 10
L_2266:  CMP  M                   ; 2266 be
L_2267:  PUSH H                   ; 2267 e5
L_2268:  PUSH PSW                 ; 2268 f5
L_2269:  CZ   L_091B              ; 2269 cc 1b 09
L_226C:  POP  PSW                 ; 226C f1
L_226D:  POP  H                   ; 226D e1
L_226E:  INX  H                   ; 226E 23
L_226F:  CMP  M                   ; 226F be
L_2270:  CZ   L_0FCA              ; 2270 cc ca 0f
L_2273:  POP  PSW                 ; 2273 f1
L_2274:  STA  0B69Dh              ; 2274 32 9d b6
L_2277:  CALL L_0C7E              ; 2277 cd 7e 0c
L_227A:  CALL L_0FE0              ; 227A cd e0 0f
L_227D:  LDA  0A950h              ; 227D 3a 50 a9
L_2280:  STA  0B69Bh              ; 2280 32 9b b6
L_2283:  JMP  L_0CD9              ; 2283 c3 d9 0c
         .db 0CDh,0DFh,29h,22h,4Fh,0A8h,0CDh,01h,22h,0CDh,0AFh,22h,3Ah,04h,0A8h,0B7h ; 2286 |..)"O..."..":...|
         .db 0CAh,9Ah,15h,21h,0AFh,10h,3Ah,04h,0A8h,0CDh,1Bh,0Eh,0CDh,0E0h,0Fh,21h ; 2296 |...!..:........!|
         .db 0A5h,10h,0DFh,0C3h,9Ah,15h                       ; 22A6 |......|
L_22AC:  CALL L_231E              ; 22AC cd 1e 23
L_22AF:  LHLD 0A842h              ; 22AF 2a 42 a8
L_22B2:  LXI  D,0B663h            ; 22B2 11 63 b6
L_22B5:  MVI  C,0Ch               ; 22B5 0e 0c
L_22B7:  LDAX D                   ; 22B7 1a
L_22B8:  CPI  3Fh                 ; 22B8 fe 3f
L_22BA:  CZ   L_22C4              ; 22BA cc c4 22
L_22BD:  INX  H                   ; 22BD 23
L_22BE:  INX  D                   ; 22BE 13
L_22BF:  DCR  C                   ; 22BF 0d
L_22C0:  JNZ  L_22B7              ; 22C0 c2 b7 22
L_22C3:  RET                      ; 22C3 c9
L_22C4:  MOV  A,M                 ; 22C4 7e
L_22C5:  STAX D                   ; 22C5 12
L_22C6:  RET                      ; 22C6 c9
L_22C7:  CALL L_0FF3              ; 22C7 cd f3 0f
L_22CA:  LXI  H,264Eh             ; 22CA 21 4e 26
L_22CD:  CALL L_0D13              ; 22CD cd 13 0d
L_22D0:  CALL L_231E              ; 22D0 cd 1e 23
L_22D3:  LDA  0B68Dh              ; 22D3 3a 8d b6
L_22D6:  CPI  01h                 ; 22D6 fe 01
L_22D8:  JZ   L_0FE0              ; 22D8 ca e0 0f
L_22DB:  LDA  0B69Bh              ; 22DB 3a 9b b6
L_22DE:  PUSH PSW                 ; 22DE f5
L_22DF:  LXI  H,0B689h            ; 22DF 21 89 b6
L_22E2:  CALL L_0E47              ; 22E2 cd 47 0e
L_22E5:  MOV  A,M                 ; 22E5 7e
L_22E6:  STA  0B69Bh              ; 22E6 32 9b b6
L_22E9:  XRA  A                   ; 22E9 af
L_22EA:  STA  0B68Dh              ; 22EA 32 8d b6
L_22ED:  CALL L_20DC              ; 22ED cd dc 20
L_22F0:  LDA  0B68Dh              ; 22F0 3a 8d b6
L_22F3:  CPI  01h                 ; 22F3 fe 01
L_22F5:  JNZ  L_2301              ; 22F5 c2 01 23
L_22F8:  CALL L_29DF              ; 22F8 cd df 29
L_22FB:  LXI  D,0008h             ; 22FB 11 08 00
L_22FE:  DAD  D                   ; 22FE 19
L_22FF:  MVI  M,7Fh               ; 22FF 36 7f
L_2301:  LDA  0B69Bh              ; 2301 3a 9b b6
L_2304:  DCR  A                   ; 2304 3d
L_2305:  PUSH PSW                 ; 2305 f5
L_2306:  LXI  H,0A88Ah            ; 2306 21 8a a8
L_2309:  CALL L_0E4D              ; 2309 cd 4d 0e
L_230C:  POP  PSW                 ; 230C f1
L_230D:  CMP  M                   ; 230D be
L_230E:  JNZ  L_22E6              ; 230E c2 e6 22
L_2311:  POP  PSW                 ; 2311 f1
L_2312:  STA  0B69Bh              ; 2312 32 9b b6
L_2315:  CALL L_11F1              ; 2315 cd f1 11
L_2318:  CALL L_0FE0              ; 2318 cd e0 0f
L_231B:  JMP  L_090F              ; 231B c3 0f 09
L_231E:  LXI  D,0A91Bh            ; 231E 11 1b a9
L_2321:  MVI  A,0Eh               ; 2321 3e 0e
L_2323:  STAX D                   ; 2323 12
L_2324:  CALL L_28D2              ; 2324 cd d2 28
L_2327:  LDA  0A91Ch              ; 2327 3a 1c a9
L_232A:  ORA  A                   ; 232A b7
L_232B:  JZ   L_23A5              ; 232B ca a5 23
L_232E:  LXI  H,0000h             ; 232E 21 00 00
L_2331:  SHLD 0B68Dh              ; 2331 22 8d b6
L_2334:  LXI  H,0A91Dh            ; 2334 21 1d a9
L_2337:  MOV  E,A                 ; 2337 5f
L_2338:  MVI  D,00h               ; 2338 16 00
L_233A:  DAD  D                   ; 233A 19
L_233B:  MVI  C,07h               ; 233B 0e 07
L_233D:  MVI  A,20h               ; 233D 3e 20
L_233F:  CALL L_239B              ; 233F cd 9b 23
L_2342:  LXI  H,0B663h            ; 2342 21 63 b6
L_2345:  MVI  C,08h               ; 2345 0e 08
L_2347:  LDA  0A91Dh              ; 2347 3a 1d a9
L_234A:  CPI  2Eh                 ; 234A fe 2e
L_234C:  JZ   L_236C              ; 234C ca 6c 23
L_234F:  LXI  D,0A91Dh            ; 234F 11 1d a9
L_2352:  LDAX D                   ; 2352 1a
L_2353:  CPI  2Eh                 ; 2353 fe 2e
L_2355:  JZ   L_2367              ; 2355 ca 67 23
L_2358:  CPI  2Ah                 ; 2358 fe 2a
L_235A:  JZ   L_236C              ; 235A ca 6c 23
L_235D:  MOV  M,A                 ; 235D 77
L_235E:  INX  H                   ; 235E 23
L_235F:  INX  D                   ; 235F 13
L_2360:  DCR  C                   ; 2360 0d
L_2361:  JNZ  L_2352              ; 2361 c2 52 23
L_2364:  JMP  L_2371              ; 2364 c3 71 23
L_2367:  MVI  A,20h               ; 2367 3e 20
         JMP  L_236E              ; 2369 c3 6e 23
L_236C:  MVI  A,3Fh               ; 236C 3e 3f
L_236E:  CALL L_239B              ; 236E cd 9b 23
L_2371:  INX  H                   ; 2371 23
L_2372:  LDA  0A91Ch              ; 2372 3a 1c a9
L_2375:  MOV  C,A                 ; 2375 4f
L_2376:  LXI  D,0A91Dh            ; 2376 11 1d a9
L_2379:  LDAX D                   ; 2379 1a
L_237A:  CPI  2Eh                 ; 237A fe 2e
L_237C:  JZ   L_238B              ; 237C ca 8b 23
L_237F:  INX  D                   ; 237F 13
L_2380:  DCR  C                   ; 2380 0d
L_2381:  JNZ  L_2379              ; 2381 c2 79 23
L_2384:  MVI  C,03h               ; 2384 0e 03
L_2386:  MVI  A,3Fh               ; 2386 3e 3f
L_2388:  JMP  L_239B              ; 2388 c3 9b 23
L_238B:  MVI  C,03h               ; 238B 0e 03
L_238D:  INX  D                   ; 238D 13
L_238E:  LDAX D                   ; 238E 1a
L_238F:  CPI  2Ah                 ; 238F fe 2a
L_2391:  JZ   L_2386              ; 2391 ca 86 23
L_2394:  MOV  M,A                 ; 2394 77
L_2395:  INX  H                   ; 2395 23
L_2396:  DCR  C                   ; 2396 0d
L_2397:  JNZ  L_238D              ; 2397 c2 8d 23
L_239A:  RET                      ; 239A c9
L_239B:  INR  C                   ; 239B 0c
L_239C:  DCR  C                   ; 239C 0d
L_239D:  RZ                       ; 239D c8
L_239E:  MOV  M,A                 ; 239E 77
L_239F:  INX  H                   ; 239F 23
L_23A0:  DCR  C                   ; 23A0 0d
L_23A1:  JNZ  L_239B              ; 23A1 c2 9b 23
L_23A4:  RET                      ; 23A4 c9
L_23A5:  LXI  H,0001h             ; 23A5 21 01 00
L_23A8:  SHLD 0B68Dh              ; 23A8 22 8d b6
L_23AB:  RET                      ; 23AB c9
L_23AC:  LXI  D,0603h             ; 23AC 11 03 06
L_23AF:  LXI  H,25A7h             ; 23AF 21 a7 25
L_23B2:  CALL L_0CF1              ; 23B2 cd f1 0c
L_23B5:  LXI  H,0FE0h             ; 23B5 21 e0 0f
L_23B8:  PUSH H                   ; 23B8 e5
L_23B9:  CPI  1Bh                 ; 23B9 fe 1b
L_23BB:  RZ                       ; 23BB c8
L_23BC:  DCR  A                   ; 23BC 3d
L_23BD:  JZ   L_2479              ; 23BD ca 79 24
L_23C0:  DCR  A                   ; 23C0 3d
L_23C1:  JZ   L_2456              ; 23C1 ca 56 24
L_23C4:  DCR  A                   ; 23C4 3d
L_23C5:  JZ   L_23CF              ; 23C5 ca cf 23
L_23C8:  DCR  A                   ; 23C8 3d
L_23C9:  JZ   L_24E8              ; 23C9 ca e8 24
         JMP  L_249C              ; 23CC c3 9c 24
L_23CF:  LXI  H,3E95h             ; 23CF 21 95 3e
L_23D2:  CALL L_0E4D              ; 23D2 cd 4d 0e
L_23D5:  MOV  A,M                 ; 23D5 7e
L_23D6:  ANI  0F0h                ; 23D6 e6 f0
L_23D8:  RRC                      ; 23D8 0f
L_23D9:  RRC                      ; 23D9 0f
L_23DA:  RRC                      ; 23DA 0f
L_23DB:  RRC                      ; 23DB 0f
L_23DC:  MOV  E,A                 ; 23DC 5f
L_23DD:  MVI  D,05h               ; 23DD 16 05
L_23DF:  LXI  H,25CAh             ; 23DF 21 ca 25
L_23E2:  CALL L_0CF1              ; 23E2 cd f1 0c
L_23E5:  CPI  1Bh                 ; 23E5 fe 1b
L_23E7:  RZ                       ; 23E7 c8
L_23E8:  RRC                      ; 23E8 0f
L_23E9:  RRC                      ; 23E9 0f
L_23EA:  RRC                      ; 23EA 0f
L_23EB:  RRC                      ; 23EB 0f
L_23EC:  MOV  C,A                 ; 23EC 4f
L_23ED:  LXI  H,3E95h             ; 23ED 21 95 3e
L_23F0:  CALL L_0E4D              ; 23F0 cd 4d 0e
L_23F3:  MOV  A,M                 ; 23F3 7e
L_23F4:  ANI  0Fh                 ; 23F4 e6 0f
L_23F6:  ADD  C                   ; 23F6 81
L_23F7:  MOV  M,A                 ; 23F7 77
L_23F8:  CALL L_091B              ; 23F8 cd 1b 09
L_23FB:  JMP  L_0CD9              ; 23FB c3 d9 0c
L_23FE:  LXI  D,0403h             ; 23FE 11 03 04
L_2401:  LXI  H,2623h             ; 2401 21 23 26
L_2404:  CALL L_0CF1              ; 2404 cd f1 0c
L_2407:  CPI  1Bh                 ; 2407 fe 1b
L_2409:  RZ                       ; 2409 c8
L_240A:  STA  0A94Bh              ; 240A 32 4b a9
L_240D:  CALL L_025B              ; 240D cd 5b 02
L_2410:  LXI  H,241Fh             ; 2410 21 1f 24
L_2413:  CALL L_0B7A              ; 2413 cd 7a 0b
L_2416:  CALL L_0CD9              ; 2416 cd d9 0c
L_2419:  CALL L_0273              ; 2419 cd 73 02
L_241C:  JMP  L_0FE0              ; 241C c3 e0 0f
L_241F:  CALL L_0C2F              ; 241F cd 2f 0c
L_2422:  LXI  H,0B681h            ; 2422 21 81 b6
L_2425:  CALL L_0E47              ; 2425 cd 47 0e
L_2428:  MOV  C,M                 ; 2428 4e
L_2429:  INR  C                   ; 2429 0c
L_242A:  MVI  A,0EDh              ; 242A 3e ed
L_242C:  ADI  14h                 ; 242C c6 14
L_242E:  DCR  C                   ; 242E 0d
L_242F:  JNZ  L_242C              ; 242F c2 2c 24
L_2432:  MOV  C,A                 ; 2432 4f
L_2433:  LDA  0B69Bh              ; 2433 3a 9b b6
L_2436:  CMP  C                   ; 2436 b9
L_2437:  RM                       ; 2437 f8
L_2438:  MVI  A,28h               ; 2438 3e 28
L_243A:  ADD  C                   ; 243A 81
L_243B:  MOV  C,A                 ; 243B 4f
L_243C:  LXI  H,3E93h             ; 243C 21 93 3e
L_243F:  PUSH B                   ; 243F c5
L_2440:  CALL L_0E4D              ; 2440 cd 4d 0e
L_2443:  POP  B                   ; 2443 c1
L_2444:  MOV  A,M                 ; 2444 7e
L_2445:  CPI  50h                 ; 2445 fe 50
L_2447:  JZ   L_244E              ; 2447 ca 4e 24
L_244A:  MVI  A,14h               ; 244A 3e 14
L_244C:  ADD  C                   ; 244C 81
L_244D:  MOV  C,A                 ; 244D 4f
L_244E:  LDA  0B69Bh              ; 244E 3a 9b b6
L_2451:  CMP  C                   ; 2451 b9
L_2452:  RP                       ; 2452 f0
L_2453:  JMP  L_082D              ; 2453 c3 2d 08
L_2456:  MVI  E,01h               ; 2456 1e 01
         LDA  3E97h               ; 2458 3a 97 3e
         CPI  59h                 ; 245B fe 59
         JZ   L_2461              ; 245D ca 61 24
         INR  E                   ; 2460 1c
L_2461:  MVI  D,03h               ; 2461 16 03
         LXI  H,25EFh             ; 2463 21 ef 25
         CALL L_0CF1              ; 2466 cd f1 0c
         CPI  1Bh                 ; 2469 fe 1b
         RZ                       ; 246B c8
         MVI  C,59h               ; 246C 0e 59
         DCR  A                   ; 246E 3d
         JZ   L_2474              ; 246F ca 74 24
         MVI  C,4Eh               ; 2472 0e 4e
L_2474:  MOV  A,C                 ; 2474 79
         STA  3E97h               ; 2475 32 97 3e
L_2478:  RET                      ; 2478 c9
L_2479:  MVI  E,01h               ; 2479 1e 01
L_247B:  LDA  L_3E90              ; 247B 3a 90 3e
L_247E:  CPI  59h                 ; 247E fe 59
L_2480:  JZ   L_2484              ; 2480 ca 84 24
L_2483:  INR  E                   ; 2483 1c
L_2484:  MVI  D,03h               ; 2484 16 03
L_2486:  LXI  H,260Ah             ; 2486 21 0a 26
L_2489:  CALL L_0CF1              ; 2489 cd f1 0c
L_248C:  CPI  1Bh                 ; 248C fe 1b
L_248E:  RZ                       ; 248E c8
L_248F:  MVI  C,59h               ; 248F 0e 59
L_2491:  DCR  A                   ; 2491 3d
L_2492:  JZ   L_2497              ; 2492 ca 97 24
         MVI  C,4Eh               ; 2495 0e 4e
L_2497:  MOV  A,C                 ; 2497 79
L_2498:  STA  L_3E90              ; 2498 32 90 3e
L_249B:  RET                      ; 249B c9
L_249C:  LXI  H,3E95h             ; 249C 21 95 3e
         CALL L_0E4D              ; 249F cd 4d 0e
         PUSH H                   ; 24A2 e5
         MOV  A,M                 ; 24A3 7e
         ANI  0Fh                 ; 24A4 e6 0f
         MVI  E,01h               ; 24A6 1e 01
         CPI  01h                 ; 24A8 fe 01
         JZ   L_24AE              ; 24AA ca ae 24
         INR  E                   ; 24AD 1c
L_24AE:  MVI  D,03h               ; 24AE 16 03
         LXI  H,2586h             ; 24B0 21 86 25
         CALL L_0CF1              ; 24B3 cd f1 0c
         POP  H                   ; 24B6 e1
         CPI  1Bh                 ; 24B7 fe 1b
         RZ                       ; 24B9 c8
         MVI  C,01h               ; 24BA 0e 01
         DCR  A                   ; 24BC 3d
         JZ   L_24C2              ; 24BD ca c2 24
         MVI  C,00h               ; 24C0 0e 00
L_24C2:  MOV  A,M                 ; 24C2 7e
         ANI  0Fh                 ; 24C3 e6 0f
         CMP  C                   ; 24C5 b9
         RZ                       ; 24C6 c8
         MOV  A,M                 ; 24C7 7e
         ANI  0F0h                ; 24C8 e6 f0
         ADD  C                   ; 24CA 81
         MOV  M,A                 ; 24CB 77
         CALL L_091B              ; 24CC cd 1b 09
         LXI  H,0001h             ; 24CF 21 01 00
         SHLD 0B69Bh              ; 24D2 22 9b b6
         CALL L_0C7E              ; 24D5 cd 7e 0c
         JMP  L_0CD9              ; 24D8 c3 d9 0c
L_24DB:  CALL 0F815h              ; 24DB cd 15 f8
L_24DE:  MVI  C,20h               ; 24DE 0e 20
L_24E0:  RST  4                   ; 24E0 e7
L_24E1:  CALL L_2549              ; 24E1 cd 49 25
L_24E4:  LDA  L_2698              ; 24E4 3a 98 26
L_24E7:  RET                      ; 24E7 c9
L_24E8:  CALL L_0FE0              ; 24E8 cd e0 0f
L_24EB:  MVI  A,03h               ; 24EB 3e 03
L_24ED:  STA  L_2698              ; 24ED 32 98 26
L_24F0:  CALL L_0FF3              ; 24F0 cd f3 0f
L_24F3:  LDA  L_2698              ; 24F3 3a 98 26
L_24F6:  DCR  A                   ; 24F6 3d
L_24F7:  CZ   L_254E              ; 24F7 cc 4e 25
L_24FA:  LXI  H,2680h             ; 24FA 21 80 26
L_24FD:  CALL L_0D13              ; 24FD cd 13 0d
L_2500:  LDA  L_1F7D              ; 2500 3a 7d 1f
L_2503:  CALL L_24DB              ; 2503 cd db 24
L_2506:  CPI  02h                 ; 2506 fe 02
L_2508:  CZ   L_254E              ; 2508 cc 4e 25
L_250B:  LXI  H,2684h             ; 250B 21 84 26
L_250E:  CALL L_0D13              ; 250E cd 13 0d
L_2511:  LDA  L_1F7E              ; 2511 3a 7e 1f
L_2514:  CALL L_24DB              ; 2514 cd db 24
L_2517:  CPI  03h                 ; 2517 fe 03
L_2519:  CZ   L_254E              ; 2519 cc 4e 25
L_251C:  LXI  H,268Ch             ; 251C 21 8c 26
L_251F:  CALL L_0D13              ; 251F cd 13 0d
L_2522:  LDA  L_1F7F              ; 2522 3a 7f 1f
L_2525:  CALL L_24DB              ; 2525 cd db 24
L_2528:  CALL L_2549              ; 2528 cd 49 25
L_252B:  CALL L_151F              ; 252B cd 1f 15
L_252E:  CALL L_0D44              ; 252E cd 44 0d
L_2531:  LXI  H,2537h             ; 2531 21 37 25
L_2534:  JMP  L_0562              ; 2534 c3 62 05
         .db 05h,08h,53h,25h,18h,62h,25h,19h,70h,25h,1Ah,77h,25h,1Bh,78h,24h ; 2537 |..S%.b%.p%.w%.x$|
         .db 2Bh,25h                                          ; 2547 |+%|
L_2549:  LXI  H,2695h             ; 2549 21 95 26
L_254C:  RST  3                   ; 254C df
L_254D:  RET                      ; 254D c9
L_254E:  LXI  H,2692h             ; 254E 21 92 26
L_2551:  RST  3                   ; 2551 df
L_2552:  RET                      ; 2552 c9
         .db 3Ah,98h,26h,3Dh,0C2h,5Ch,25h,3Eh,03h             ; 2553 |:.&=.\%>.|
L_255C:  STA  L_2698              ; 255C 32 98 26
         JMP  L_24F0              ; 255F c3 f0 24
         .db 3Ah,98h,26h,3Ch,0FEh,04h,0C2h,5Ch,25h,3Eh,01h,0C3h,5Ch,25h,0CDh,7Eh ; 2562 |:.&<...\%>..\%.~|
         .db 25h,34h,0C3h,0F0h,24h,0CDh,7Eh,25h,35h,0C3h,0F0h,24h ; 2572 |%4..$.~%5..$|
L_257E:  LXI  D,1F7Ch             ; 257E 11 7c 1f
         LHLD L_2698              ; 2581 2a 98 26
         DAD  D                   ; 2584 19
         RET                      ; 2585 c9
         .db 0F3h,0C9h,0D3h,0D4h,0C5h,0CDh,0CEh,0D9h,0C5h,20h,0C6h,0C1h,0CAh,0CCh,0D9h,00h ; 2586 |......... ......|
         .db 0F0h,0CFh,0CBh,0C1h,0DAh,0C1h,0CEh,0D9h,00h,0F3h,0D0h,0D2h,0D1h,0D4h,0C1h,0CEh ; 2596 |................|
         .db 0D9h,00h,0F2h,2Eh,0CBh,0CFh,0D0h,0C9h,0D2h,2Eh,00h,0E4h,0C9h,0D3h,0CBh,22h ; 25A6 |..............."|
         .db 42h,22h,00h,0F3h,0CFh,0D2h,0D4h,2Eh,00h,0FCh,0CBh,0D2h,0C1h,0CEh,00h,0F2h ; 25B6 |B"..............|
         .db 2Eh,44h,49h,52h,00h,0F0h,0CFh,20h,0C9h,0CDh,0C5h,0CEh,0C9h,00h,0F0h,0CFh ; 25C6 |.DIR... ........|
         .db 20h,0D4h,0C9h,0D0h,0D5h,00h,0F0h,0CFh,20h,0D2h,0C1h,0DAh,0CDh,0C5h,0D2h,0D5h ; 25D6 | ....... .......|
         .db 00h,0F2h,0C5h,0C1h,0CCh,0D8h,0CEh,0CFh,00h,0E4h,0C9h,0D3h,0CBh,20h,22h,42h ; 25E6 |............. "B|
         .db 22h,00h,0E4h,0CFh,0D3h,0D4h,0D5h,0D0h,0C5h,0CEh,00h,0EFh,0D4h,0CBh,0CCh,0C0h ; 25F6 |"...............|
         .db 0DEh,0C5h,0CEh,00h,0F0h,0D2h,0CFh,0D7h,0C5h,0D2h,0CBh,0D5h,00h,0E4h,0C5h,0CCh ; 2606 |................|
         .db 0C1h,0D4h,0D8h,00h,0EEh,0C5h,20h,0C4h,0C5h,0CCh,0C1h,0D4h,0D8h,00h,0FAh,0C1h ; 2616 |...... .........|
         .db 0DDh,0C9h,0DDh,0C5h,0CEh,00h,0F3h,0C9h,0D3h,0D4h,0C5h,0CDh,0CEh,0D9h,0CAh,00h ; 2626 |................|
         .db 0F3h,0C2h,0D2h,0CFh,0D3h,20h,0C1h,0D4h,0D2h,2Eh,00h,0E9h,0CDh,0D1h,20h,0CBh ; 2636 |..... ........ .|
         .db 0CFh,0D0h,0C9h,0C9h,20h,0C9h,0CCh,0C9h,20h,0CDh,0C1h,0D3h,0CBh,0C1h,20h,2Dh ; 2646 |.... ... ..... -|
         .db 00h,0EEh,0CFh,0D7h,0CFh,0C5h,20h,0C9h,0CDh,0D1h,20h,0C9h,0CCh,0C9h,20h,0CDh ; 2656 |...... ... ... .|
         .db 0C1h,0D3h,0CBh,0C1h,20h,2Dh,00h,0E9h,0CDh,0D1h,20h,0CEh,0CFh,0D7h,0CFh,0C7h ; 2666 |.... -.... .....|
         .db 0CFh,20h,0C6h,0C1h,0CAh,0CCh,0C1h,20h,2Dh,00h,0E6h,0CFh,0CEh,00h,0F3h,0C9h ; 2676 |. ..... -.......|
         .db 0CDh,0D7h,0CFh,0CCh,0D9h,00h,0F0h,0C1h,0D5h,0DAh,0C1h,00h,1Bh,62h,00h,1Bh ; 2686 |.............b..|
         .db 61h,00h                                          ; 2696 |a.|
L_2698:  .db 00h,00h,21h,14h,0DFh,3Ah,02h,0A8h,0BEh,0C8h,35h,0B7h,0CAh,0CCh,26h,0Eh ; 2698 |..!..:....5...&.|
         .db 08h,0CDh,09h,0F8h,3Ah,02h,0A8h,47h,21h,14h,0DFh,7Eh,0F5h,85h,90h,6Fh ; 26A8 |....:..G!..~...o|
         .db 78h,23h,23h,0E5h,0CDh,02h,2Ah,21h,2Ch,29h,0DFh,0E1h,54h,5Dh,2Bh,0F1h ; 26B8 |x##...*!,)..T]+.|
         .db 4Fh,0EBh,0EFh,0C9h,21h,2Bh,29h,0DFh,0C9h         ; 26C8 |O...!+)..|
L_26D1:  CALL L_29DF              ; 26D1 cd df 29
         LXI  H,3E91h             ; 26D4 21 91 3e
         CALL L_0E4D              ; 26D7 cd 4d 0e
         MOV  A,M                 ; 26DA 7e
         STA  0B673h              ; 26DB 32 73 b6
         JMP  L_1527              ; 26DE c3 27 15
L_26E1:  LXI  H,292Fh             ; 26E1 21 2f 29
L_26E4:  MVI  B,4Eh               ; 26E4 06 4e
L_26E6:  LDA  0B672h              ; 26E6 3a 72 b6
L_26E9:  CPI  59h                 ; 26E9 fe 59
L_26EB:  JZ   L_26F3              ; 26EB ca f3 26
L_26EE:  LXI  H,293Dh             ; 26EE 21 3d 29
L_26F1:  MVI  B,59h               ; 26F1 06 59
L_26F3:  MOV  A,B                 ; 26F3 78
L_26F4:  STA  0B672h              ; 26F4 32 72 b6
L_26F7:  RST  3                   ; 26F7 df
L_26F8:  JMP  L_0FF3              ; 26F8 c3 f3 0f
         .db 0CDh,0DFh,29h,3Eh,2Eh,0BEh,0C8h,11h,08h,00h,19h,16h,20h,7Eh,0BAh,0F5h ; 26FB |..)>........ ~..|
         .db 0C2h,10h,27h,16h,7Fh,72h,11h,04h,00h,19h,0E5h,21h,47h,0A9h,0CDh,47h ; 270B |..'..r.....!G..G|
         .db 0Eh,5Eh,23h,56h,2Bh,0E3h,7Eh,0EBh,5Fh,16h,00h,0C1h,0F1h,0F5h,0C5h,0CAh ; 271B |.^#V+.~._.......|
         .db 33h,27h,7Bh,2Fh,5Fh,16h,0FFh,13h,19h,0EBh,0E1h,73h,23h,72h,21h,43h ; 272B |3'{/_......s#r!C|
         .db 0A9h,0CDh,47h,0Eh,46h,04h,0F1h,0CAh,47h,27h,05h,05h,70h,0CDh,54h,0Eh ; 273B |..G.F...G'..p.T.|
         .db 0C3h,5Ah,04h                                     ; 274B |.Z.|
L_274E:  CALL L_0FE0              ; 274E cd e0 0f
L_2751:  LXI  H,294Fh             ; 2751 21 4f 29
L_2754:  RST  3                   ; 2754 df
L_2755:  CALL L_207E              ; 2755 cd 7e 20
L_2758:  POP  H                   ; 2758 e1
L_2759:  XRA  A                   ; 2759 af
L_275A:  CMP  H                   ; 275A bc
L_275B:  JNZ  L_2765              ; 275B c2 65 27
L_275E:  CMP  L                   ; 275E bd
L_275F:  JNZ  L_2765              ; 275F c2 65 27
         LHLD 0A853h              ; 2762 2a 53 a8
L_2765:  SHLD 0A840h              ; 2765 22 40 a8
L_2768:  CALL L_0FE0              ; 2768 cd e0 0f
L_276B:  LHLD 0A853h              ; 276B 2a 53 a8
L_276E:  XCHG                     ; 276E eb
L_276F:  LHLD 0A840h              ; 276F 2a 40 a8
L_2772:  CALL L_27E6              ; 2772 cd e6 27
L_2775:  SHLD 0A950h              ; 2775 22 50 a9
L_2778:  XRA  A                   ; 2778 af
L_2779:  CMP  H                   ; 2779 bc
L_277A:  JNZ  L_2784              ; 277A c2 84 27
L_277D:  CMP  L                   ; 277D bd
L_277E:  JNZ  L_2784              ; 277E c2 84 27
         JMP  L_31C5              ; 2781 c3 c5 31
L_2784:  LDA  0A951h              ; 2784 3a 51 a9
L_2787:  ANI  80h                 ; 2787 e6 80
L_2789:  CPI  00h                 ; 2789 fe 00
L_278B:  JZ   L_27AB              ; 278B ca ab 27
L_278E:  LHLD 0A853h              ; 278E 2a 53 a8
         DCX  H                   ; 2791 2b
         SHLD 0A853h              ; 2792 22 53 a8
         CALL L_32C3              ; 2795 cd c3 32
         LHLD 0A950h              ; 2798 2a 50 a9
         INX  H                   ; 279B 23
         SHLD 0A950h              ; 279C 22 50 a9
         XRA  A                   ; 279F af
         CMP  L                   ; 27A0 bd
         JNZ  L_278E              ; 27A1 c2 8e 27
         CMP  H                   ; 27A4 bc
         JNZ  L_278E              ; 27A5 c2 8e 27
         JMP  L_31C5              ; 27A8 c3 c5 31
L_27AB:  LHLD 0A853h              ; 27AB 2a 53 a8
L_27AE:  INX  H                   ; 27AE 23
L_27AF:  SHLD 0A853h              ; 27AF 22 53 a8
L_27B2:  LHLD 0A950h              ; 27B2 2a 50 a9
L_27B5:  DCX  H                   ; 27B5 2b
L_27B6:  SHLD 0A950h              ; 27B6 22 50 a9
L_27B9:  LDA  0B68Dh              ; 27B9 3a 8d b6
L_27BC:  CPI  4Dh                 ; 27BC fe 4d
L_27BE:  JZ   L_27DC              ; 27BE ca dc 27
L_27C1:  XRA  A                   ; 27C1 af
L_27C2:  CMP  L                   ; 27C2 bd
L_27C3:  JNZ  L_27C8              ; 27C3 c2 c8 27
L_27C6:  CMP  H                   ; 27C6 bc
L_27C7:  RZ                       ; 27C7 c8
L_27C8:  LHLD 0A853h              ; 27C8 2a 53 a8
L_27CB:  INX  H                   ; 27CB 23
L_27CC:  SHLD 0A853h              ; 27CC 22 53 a8
L_27CF:  CALL L_32E7              ; 27CF cd e7 32
L_27D2:  LHLD 0A950h              ; 27D2 2a 50 a9
L_27D5:  DCX  H                   ; 27D5 2b
L_27D6:  SHLD 0A950h              ; 27D6 22 50 a9
L_27D9:  JMP  L_27B9              ; 27D9 c3 b9 27
L_27DC:  LHLD 0A853h              ; 27DC 2a 53 a8
         DCX  H                   ; 27DF 2b
         SHLD 0A853h              ; 27E0 22 53 a8
         JMP  L_32C3              ; 27E3 c3 c3 32
L_27E6:  MOV  A,D                 ; 27E6 7a
L_27E7:  CMA                      ; 27E7 2f
L_27E8:  MOV  D,A                 ; 27E8 57
L_27E9:  MOV  A,E                 ; 27E9 7b
L_27EA:  CMA                      ; 27EA 2f
L_27EB:  MOV  E,A                 ; 27EB 5f
L_27EC:  INX  D                   ; 27EC 13
L_27ED:  DAD  D                   ; 27ED 19
L_27EE:  RET                      ; 27EE c9
         .db 0CDh,0F3h,0Fh,0C3h,0F8h,27h,0CDh,0FEh,27h,21h,14h,0DFh,0C3h,6Bh,0Fh ; 27EF |.....'..'!...k.|
L_27FE:  CALL L_0FE0              ; 27FE cd e0 0f
L_2801:  LDA  L_3E8F              ; 2801 3a 8f 3e
L_2804:  MVI  E,01h               ; 2804 1e 01
L_2806:  CPI  4Ch                 ; 2806 fe 4c
L_2808:  JZ   L_2818              ; 2808 ca 18 28
L_280B:  INR  E                   ; 280B 1c
L_280C:  CPI  53h                 ; 280C fe 53
L_280E:  JZ   L_2818              ; 280E ca 18 28
L_2811:  INR  E                   ; 2811 1c
L_2812:  CPI  54h                 ; 2812 fe 54
L_2814:  JZ   L_2818              ; 2814 ca 18 28
L_2817:  INR  E                   ; 2817 1c
L_2818:  MVI  D,05h               ; 2818 16 05
L_281A:  LXI  H,2964h             ; 281A 21 64 29
L_281D:  CALL L_0CF1              ; 281D cd f1 0c
L_2820:  CPI  1Bh                 ; 2820 fe 1b
L_2822:  RZ                       ; 2822 c8
         DCR  A                   ; 2823 3d
         ADD  A                   ; 2824 87
         ADD  A                   ; 2825 87
         MOV  L,A                 ; 2826 6f
         MVI  H,00h               ; 2827 26 00
         LXI  D,2965h             ; 2829 11 65 29
         DAD  D                   ; 282C 19
         LXI  D,3E8Dh             ; 282D 11 8d 3e
         MVI  C,03h               ; 2830 0e 03
         RST  5                   ; 2832 ef
L_2833:  LXI  H,295Fh             ; 2833 21 5f 29
L_2836:  RST  3                   ; 2836 df
L_2837:  LXI  H,3E8Ch             ; 2837 21 8c 3e
L_283A:  CALL L_0F6B              ; 283A cd 6b 0f
L_283D:  JMP  L_0FF3              ; 283D c3 f3 0f
L_2840:  XRA  A                   ; 2840 af
L_2841:  STA  0B68Dh              ; 2841 32 8d b6
L_2844:  LXI  D,0402h             ; 2844 11 02 04
L_2847:  LXI  H,2974h             ; 2847 21 74 29
L_284A:  CALL L_0CF1              ; 284A cd f1 0c
L_284D:  CPI  1Bh                 ; 284D fe 1b
L_284F:  JZ   L_0FE0              ; 284F ca e0 0f
L_2852:  CPI  02h                 ; 2852 fe 02
L_2854:  JZ   L_0FE0              ; 2854 ca e0 0f
         DCR  A                   ; 2857 3d
         JZ   L_2867              ; 2858 ca 67 28
         CALL L_025B              ; 285B cd 5b 02
         CALL L_3770              ; 285E cd 70 37
L_2861:  CALL L_0273              ; 2861 cd 73 02
         JMP  L_0E93              ; 2864 c3 93 0e
L_2867:  CALL L_025B              ; 2867 cd 5b 02
         CALL L_3760              ; 286A cd 60 37
         JMP  L_2861              ; 286D c3 61 28
L_2870:  LXI  H,3E91h             ; 2870 21 91 3e
         LDA  0B69Dh              ; 2873 3a 9d b6
         DCR  A                   ; 2876 3d
         MOV  E,A                 ; 2877 5f
         MVI  D,00h               ; 2878 16 00
         DAD  D                   ; 287A 19
         MOV  A,M                 ; 287B 7e
         MVI  E,01h               ; 287C 1e 01
         CPI  41h                 ; 287E fe 41
         JZ   L_288A              ; 2880 ca 8a 28
         INR  E                   ; 2883 1c
         CPI  43h                 ; 2884 fe 43
         JZ   L_288A              ; 2886 ca 8a 28
         INR  E                   ; 2889 1c
L_288A:  LDA  3E97h               ; 288A 3a 97 3e
         MVI  D,03h               ; 288D 16 03
         CPI  59h                 ; 288F fe 59
         JNZ  L_2895              ; 2891 c2 95 28
         INR  D                   ; 2894 14
L_2895:  LXI  H,2990h             ; 2895 21 90 29
         CALL L_0CF1              ; 2898 cd f1 0c
         CPI  1Bh                 ; 289B fe 1b
         JZ   L_0FE0              ; 289D ca e0 0f
         MVI  B,41h               ; 28A0 06 41
         DCR  A                   ; 28A2 3d
         JZ   L_28AE              ; 28A3 ca ae 28
         MVI  B,43h               ; 28A6 06 43
         DCR  A                   ; 28A8 3d
         JZ   L_28AE              ; 28A9 ca ae 28
         MVI  B,42h               ; 28AC 06 42
L_28AE:  LXI  H,3E91h             ; 28AE 21 91 3e
L_28B1:  CALL L_0E4D              ; 28B1 cd 4d 0e
L_28B4:  MOV  M,B                 ; 28B4 70
L_28B5:  MOV  A,B                 ; 28B5 78
L_28B6:  CALL L_0262              ; 28B6 cd 62 02
L_28B9:  LXI  H,0B681h            ; 28B9 21 81 b6
L_28BC:  CALL L_0E47              ; 28BC cd 47 0e
L_28BF:  MVI  M,00h               ; 28BF 36 00
L_28C1:  CALL L_091B              ; 28C1 cd 1b 09
L_28C4:  CALL L_0C7E              ; 28C4 cd 7e 0c
L_28C7:  MVI  A,01h               ; 28C7 3e 01
L_28C9:  STA  0B69Bh              ; 28C9 32 9b b6
L_28CC:  CALL L_0CD9              ; 28CC cd d9 0c
L_28CF:  JMP  L_0FE0              ; 28CF c3 e0 0f
L_28D2:  XCHG                     ; 28D2 eb
L_28D3:  MOV  A,M                 ; 28D3 7e
L_28D4:  STA  28FFh               ; 28D4 32 ff 28
L_28D7:  INX  H                   ; 28D7 23
L_28D8:  XRA  A                   ; 28D8 af
L_28D9:  MOV  M,A                 ; 28D9 77
L_28DA:  STA  0A933h              ; 28DA 32 33 a9
L_28DD:  SHLD 290Fh               ; 28DD 22 0f 29
L_28E0:  INX  H                   ; 28E0 23
L_28E1:  CALL L_0D44              ; 28E1 cd 44 0d
L_28E4:  CPI  1Bh                 ; 28E4 fe 1b
L_28E6:  JZ   L_2912              ; 28E6 ca 12 29
L_28E9:  CPI  0Dh                 ; 28E9 fe 0d
L_28EB:  JZ   L_290B              ; 28EB ca 0b 29
L_28EE:  CPI  20h                 ; 28EE fe 20
L_28F0:  JC   L_28E1              ; 28F0 da e1 28
L_28F3:  CPI  7Fh                 ; 28F3 fe 7f
L_28F5:  JZ   L_2916              ; 28F5 ca 16 29
L_28F8:  MOV  M,A                 ; 28F8 77
L_28F9:  INX  H                   ; 28F9 23
L_28FA:  PUSH H                   ; 28FA e5
L_28FB:  MOV  C,A                 ; 28FB 4f
L_28FC:  RST  4                   ; 28FC e7
L_28FD:  POP  H                   ; 28FD e1
L_28FE:  MVI  C,00h               ; 28FE 0e 00
L_2900:  LDA  0A933h              ; 2900 3a 33 a9
L_2903:  INR  A                   ; 2903 3c
L_2904:  STA  0A933h              ; 2904 32 33 a9
L_2907:  CMP  C                   ; 2907 b9
L_2908:  JNZ  L_28E1              ; 2908 c2 e1 28
L_290B:  LDA  0A933h              ; 290B 3a 33 a9
L_290E:  STA  0000h               ; 290E 32 00 00
L_2911:  RET                      ; 2911 c9
L_2912:  XRA  A                   ; 2912 af
L_2913:  JMP  L_290E              ; 2913 c3 0e 29
L_2916:  LDA  0A933h              ; 2916 3a 33 a9
         ORA  A                   ; 2919 b7
         JZ   L_28E1              ; 291A ca e1 28
         DCR  A                   ; 291D 3d
         STA  0A933h              ; 291E 32 33 a9
         DCX  H                   ; 2921 2b
         PUSH H                   ; 2922 e5
         LXI  H,292Bh             ; 2923 21 2b 29
         RST  3                   ; 2926 df
         POP  H                   ; 2927 e1
         JMP  L_28E1              ; 2928 c3 e1 28
         .db 08h,20h,08h,00h,1Bh,59h,36h,25h,8Dh,8Dh,8Dh,8Dh,8Dh,8Dh,8Dh,8Dh ; 292B |. ...Y6%........|
         .db 8Dh,00h,1Bh,59h,36h,25h,1Bh,62h,20h,3Eh,43h,4Fh,2Eh,50h,54h,4Bh ; 293B |...Y6%.b >CO.PTK|
         .db 20h,1Bh,61h,00h,0EEh,0CFh,0CDh,0C5h,0D2h,20h,0D3h,0D4h,0D2h,0CFh,0CBh,0C9h ; 294B | .a...... ......|
         .db 20h,2Dh,20h,00h,1Bh,59h,37h,6Ch,00h,00h,52h,2Fh,4Ch,00h,52h,55h ; 295B | - ..Y7l..R/L.RU|
         .db 53h,00h,4Ch,41h,54h,00h,4Bh,2Dh,38h,00h,0F5h,0C4h,0C1h,0CCh,0D1h,0D4h ; 296B |S.LAT.K-8.......|
         .db 0D8h,00h,0F7h,0D9h,0CAh,0D4h,0C9h,00h,0F5h,0C4h,0C1h,0CCh,0C9h,0D4h,0D8h,20h ; 297B |............... |
         .db 22h,42h,41h,4Bh,22h,00h,22h,41h,22h,00h,22h,43h,22h,00h,22h,42h ; 298B |"BAK"."A"."C"."B|
         .db 22h,00h,0FEh,02h,0F5h,0CCh,06h,3Bh,0F1h,0C4h,51h,3Bh,3Ah,8Dh,0B6h,3Dh ; 299B |"......;..Q;:..=|
         .db 0C9h                                             ; 29AB |.|
L_29AC:  XRA  A                   ; 29AC af
         STA  0A934h              ; 29AD 32 34 a9
         CALL L_0242              ; 29B0 cd 42 02
         CALL L_3BE2              ; 29B3 cd e2 3b
         LXI  H,29CBh             ; 29B6 21 cb 29
         CALL L_0B7A              ; 29B9 cd 7a 0b
         LDA  0A934h              ; 29BC 3a 34 a9
         CPI  00h                 ; 29BF fe 00
         RZ                       ; 29C1 c8
         CALL L_3AFF              ; 29C2 cd ff 3a
         CPI  1Bh                 ; 29C5 fe 1b
         RZ                       ; 29C7 c8
         JMP  L_2C6A              ; 29C8 c3 6a 2c
         .db 0CDh,3Ah,39h,3Ah,36h,0A9h,0CDh,9Dh,29h,0C8h,21h,34h,0A9h,34h,0CDh,24h ; 29CB |.:9:6...).!4.4.$|
         .db 38h,0C3h,0E9h,3Bh                                ; 29DB |8..;|
L_29DF:  LXI  H,0A954h            ; 29DF 21 54 a9
L_29E2:  LDA  0B69Dh              ; 29E2 3a 9d b6
L_29E5:  DCR  A                   ; 29E5 3d
L_29E6:  JZ   L_29ED              ; 29E6 ca ed 29
L_29E9:  LXI  D,0680h             ; 29E9 11 80 06
L_29EC:  DAD  D                   ; 29EC 19
L_29ED:  LDA  0B69Bh              ; 29ED 3a 9b b6
L_29F0:  DCR  A                   ; 29F0 3d
L_29F1:  PUSH H                   ; 29F1 e5
L_29F2:  MOV  E,A                 ; 29F2 5f
L_29F3:  MVI  D,00h               ; 29F3 16 00
L_29F5:  MOV  L,E                 ; 29F5 6b
L_29F6:  MOV  H,D                 ; 29F6 62
L_29F7:  DAD  H                   ; 29F7 29
L_29F8:  DAD  D                   ; 29F8 19
L_29F9:  DAD  H                   ; 29F9 29
L_29FA:  DAD  H                   ; 29FA 29
L_29FB:  DAD  D                   ; 29FB 19
L_29FC:  POP  D                   ; 29FC d1
L_29FD:  DAD  D                   ; 29FD 19
L_29FE:  SHLD 0A842h              ; 29FE 22 42 a8
L_2A01:  RET                      ; 2A01 c9
L_2A02:  MOV  C,M                 ; 2A02 4e
L_2A03:  RST  4                   ; 2A03 e7
L_2A04:  INX  H                   ; 2A04 23
L_2A05:  DCR  A                   ; 2A05 3d
L_2A06:  JNZ  L_2A02              ; 2A06 c2 02 2a
L_2A09:  RET                      ; 2A09 c9
L_2A0A:  LDA  0B69Dh              ; 2A0A 3a 9d b6
L_2A0D:  DCR  A                   ; 2A0D 3d
L_2A0E:  JNZ  L_2A13              ; 2A0E c2 13 2a
L_2A11:  MVI  A,02h               ; 2A11 3e 02
L_2A13:  STA  0B69Dh              ; 2A13 32 9d b6
L_2A16:  RET                      ; 2A16 c9
L_2A17:  CALL L_03DE              ; 2A17 cd de 03
L_2A1A:  CALL L_393A              ; 2A1A cd 3a 39
L_2A1D:  CALL L_29DF              ; 2A1D cd df 29
L_2A20:  LXI  D,0B663h            ; 2A20 11 63 b6
L_2A23:  CALL L_3979              ; 2A23 cd 79 39
L_2A26:  LXI  H,3E91h             ; 2A26 21 91 3e
L_2A29:  CALL L_0E4D              ; 2A29 cd 4d 0e
L_2A2C:  MOV  A,M                 ; 2A2C 7e
L_2A2D:  STA  0B673h              ; 2A2D 32 73 b6
L_2A30:  LXI  H,0B663h            ; 2A30 21 63 b6
L_2A33:  LXI  D,0009h             ; 2A33 11 09 00
L_2A36:  DAD  D                   ; 2A36 19
L_2A37:  LXI  D,35C6h             ; 2A37 11 c6 35
L_2A3A:  MVI  C,03h               ; 2A3A 0e 03
L_2A3C:  CALL L_381A              ; 2A3C cd 1a 38
L_2A3F:  JNZ  L_2F41              ; 2A3F c2 41 2f
         CALL L_1257              ; 2A42 cd 57 12
         XRA  A                   ; 2A45 af
         STA  0A93Fh              ; 2A46 32 3f a9
         LXI  H,35BDh             ; 2A49 21 bd 35
         SHLD 0A842h              ; 2A4C 22 42 a8
         CALL L_19B8              ; 2A4F cd b8 19
         MVI  C,11h               ; 2A52 0e 11
L_2A54:  LXI  H,0A93Fh            ; 2A54 21 3f a9
         INR  M                   ; 2A57 34
         CALL L_19AD              ; 2A58 cd ad 19
         INR  A                   ; 2A5B 3c
         MOV  C,A                 ; 2A5C 4f
         XRA  A                   ; 2A5D af
         MOV  D,A                 ; 2A5E 57
L_2A5F:  ADI  20h                 ; 2A5F c6 20
         DCR  C                   ; 2A61 0d
         JNZ  L_2A5F              ; 2A62 c2 5f 2a
         ADI  61h                 ; 2A65 c6 61
         MOV  E,A                 ; 2A67 5f
         LXI  H,0B663h            ; 2A68 21 63 b6
         MVI  C,08h               ; 2A6B 0e 08
         CALL L_381A              ; 2A6D cd 1a 38
         JNZ  L_2E49              ; 2A70 c2 49 2e
         CALL L_18AC              ; 2A73 cd ac 18
         CALL L_29DF              ; 2A76 cd df 29
         LXI  D,000Ch             ; 2A79 11 0c 00
         DAD  D                   ; 2A7C 19
         MOV  A,M                 ; 2A7D 7e
         PUSH PSW                 ; 2A7E f5
         LXI  H,35A3h             ; 2A7F 21 a3 35
         CALL L_0E1B              ; 2A82 cd 1b 0e
         MVI  C,00h               ; 2A85 0e 00
         LXI  H,9FF0h             ; 2A87 21 f0 9f
         LXI  D,0010h             ; 2A8A 11 10 00
L_2A8D:  INR  C                   ; 2A8D 0c
         DAD  D                   ; 2A8E 19
         MOV  A,M                 ; 2A8F 7e
         ANI  80h                 ; 2A90 e6 80
         CPI  00h                 ; 2A92 fe 00
         JZ   L_2A8D              ; 2A94 ca 8d 2a
         MOV  A,C                 ; 2A97 79
         STA  0A93Ch              ; 2A98 32 3c a9
         POP  PSW                 ; 2A9B f1
         LXI  D,000Ch             ; 2A9C 11 0c 00
         DAD  D                   ; 2A9F 19
         PUSH H                   ; 2AA0 e5
         MOV  E,M                 ; 2AA1 5e
         INX  H                   ; 2AA2 23
         MOV  D,M                 ; 2AA3 56
         MVI  H,00h               ; 2AA4 26 00
         MOV  L,A                 ; 2AA6 6f
         DAD  H                   ; 2AA7 29
         DAD  H                   ; 2AA8 29
         DAD  H                   ; 2AA9 29
L_2AAA:  CALL L_2B41              ; 2AAA cd 41 2b
         XCHG                     ; 2AAD eb
         POP  H                   ; 2AAE e1
         PUSH H                   ; 2AAF e5
         PUSH B                   ; 2AB0 c5
         PUSH D                   ; 2AB1 d5
         INX  D                   ; 2AB2 13
         PUSH H                   ; 2AB3 e5
         CALL L_2B24              ; 2AB4 cd 24 2b
         CALL L_2B24              ; 2AB7 cd 24 2b
         POP  H                   ; 2ABA e1
         PUSH D                   ; 2ABB d5
         LXI  D,0002h             ; 2ABC 11 02 00
         DAD  D                   ; 2ABF 19
         SHLD 0A93Ah              ; 2AC0 22 3a a9
         MOV  E,M                 ; 2AC3 5e
         INX  H                   ; 2AC4 23
         MOV  D,M                 ; 2AC5 56
         DCX  D                   ; 2AC6 1b
         MOV  A,E                 ; 2AC7 7b
         ANI  0F8h                ; 2AC8 e6 f8
         MOV  E,A                 ; 2ACA 5f
         LXI  H,0008h             ; 2ACB 21 08 00
         DAD  D                   ; 2ACE 19
         XCHG                     ; 2ACF eb
         CALL L_2B2B              ; 2AD0 cd 2b 2b
         CALL L_2B2B              ; 2AD3 cd 2b 2b
         CALL L_2B2B              ; 2AD6 cd 2b 2b
         MOV  D,E                 ; 2AD9 53
         MVI  E,00h               ; 2ADA 1e 00
         POP  H                   ; 2ADC e1
         LXI  B,0008h             ; 2ADD 01 08 00
L_2AE0:  CALL L_2B33              ; 2AE0 cd 33 2b
         MOV  A,B                 ; 2AE3 78
         RAL                      ; 2AE4 17
         MOV  B,A                 ; 2AE5 47
         CALL L_2B2B              ; 2AE6 cd 2b 2b
         DCR  C                   ; 2AE9 0d
         JNZ  L_2AE0              ; 2AEA c2 e0 2a
         LHLD 0A93Ah              ; 2AED 2a 3a a9
         LXI  D,0FFF2h            ; 2AF0 11 f2 ff
         DAD  D                   ; 2AF3 19
         MOV  M,B                 ; 2AF4 70
         POP  D                   ; 2AF5 d1
         POP  B                   ; 2AF6 c1
         POP  H                   ; 2AF7 e1
         MOV  A,M                 ; 2AF8 7e
         MOV  M,E                 ; 2AF9 73
         MOV  E,A                 ; 2AFA 5f
         INX  H                   ; 2AFB 23
         MOV  A,M                 ; 2AFC 7e
         MOV  M,D                 ; 2AFD 72
         MOV  D,A                 ; 2AFE 57
         PUSH D                   ; 2AFF d5
         LXI  D,0FFEFh            ; 2B00 11 ef ff
         DAD  D                   ; 2B03 19
         MOV  E,M                 ; 2B04 5e
         INX  H                   ; 2B05 23
         MOV  D,M                 ; 2B06 56
         DCX  H                   ; 2B07 2b
         XTHL                     ; 2B08 e3
         DCR  C                   ; 2B09 0d
         JNZ  L_2AAA              ; 2B0A c2 aa 2a
         POP  H                   ; 2B0D e1
         LDA  0A93Ch              ; 2B0E 3a 3c a9
         LXI  H,35B3h             ; 2B11 21 b3 35
         CALL L_0E1B              ; 2B14 cd 1b 0e
         LDA  0B69Dh              ; 2B17 3a 9d b6
         CPI  01h                 ; 2B1A fe 01
         JZ   L_2B4A              ; 2B1C ca 4a 2b
         MVI  A,48h               ; 2B1F 3e 48
         JMP  L_2B4C              ; 2B21 c3 4c 2b
L_2B24:  MOV  L,E                 ; 2B24 6b
         MOV  H,D                 ; 2B25 62
         DAD  H                   ; 2B26 29
         DAD  H                   ; 2B27 29
         DAD  D                   ; 2B28 19
         XCHG                     ; 2B29 eb
         RET                      ; 2B2A c9
L_2B2B:  ORA  A                   ; 2B2B b7
         MOV  A,D                 ; 2B2C 7a
         RAR                      ; 2B2D 1f
         MOV  D,A                 ; 2B2E 57
         MOV  A,E                 ; 2B2F 7b
         RAR                      ; 2B30 1f
         MOV  E,A                 ; 2B31 5f
         RET                      ; 2B32 c9
L_2B33:  PUSH D                   ; 2B33 d5
         PUSH H                   ; 2B34 e5
         CALL L_2B41              ; 2B35 cd 41 2b
         JC   L_2B3E              ; 2B38 da 3e 2b
         POP  H                   ; 2B3B e1
         POP  D                   ; 2B3C d1
         RET                      ; 2B3D c9
L_2B3E:  POP  D                   ; 2B3E d1
         POP  D                   ; 2B3F d1
         RET                      ; 2B40 c9
L_2B41:  MOV  A,D                 ; 2B41 7a
         CMA                      ; 2B42 2f
         MOV  D,A                 ; 2B43 57
         MOV  A,E                 ; 2B44 7b
         CMA                      ; 2B45 2f
         MOV  E,A                 ; 2B46 5f
         INX  D                   ; 2B47 13
         DAD  D                   ; 2B48 19
         RET                      ; 2B49 c9
L_2B4A:  MVI  A,20h               ; 2B4A 3e 20
L_2B4C:  STA  L_359B              ; 2B4C 32 9b 35
         STA  L_3584              ; 2B4F 32 84 35
         LXI  H,3598h             ; 2B52 21 98 35
         RST  3                   ; 2B55 df
         LXI  H,0A859h            ; 2B56 21 59 a8
         CALL L_0F6B              ; 2B59 cd 6b 0f
         LXI  H,35A2h             ; 2B5C 21 a2 35
         RST  3                   ; 2B5F df
         LDA  0A859h              ; 2B60 3a 59 a8
         MOV  C,A                 ; 2B63 4f
         MVI  A,0Eh               ; 2B64 3e 0e
         SUB  C                   ; 2B66 91
         MVI  C,20h               ; 2B67 0e 20
L_2B69:  RST  4                   ; 2B69 e7
         DCR  A                   ; 2B6A 3d
         JNZ  L_2B69              ; 2B6B c2 69 2b
         LXI  H,35AAh             ; 2B6E 21 aa 35
         RST  3                   ; 2B71 df
         LXI  H,0100h             ; 2B72 21 00 01
         SHLD 0A93Dh              ; 2B75 22 3d a9
         MVI  A,4Eh               ; 2B78 3e 4e
         LXI  H,9F80h             ; 2B7A 21 80 9f
         MVI  C,80h               ; 2B7D 0e 80
L_2B7F:  MOV  M,A                 ; 2B7F 77
         INX  H                   ; 2B80 23
         DCR  C                   ; 2B81 0d
         JNZ  L_2B7F              ; 2B82 c2 7f 2b
         CALL L_2A0A              ; 2B85 cd 0a 2a
         CALL L_347D              ; 2B88 cd 7d 34
         CALL L_2A0A              ; 2B8B cd 0a 2a
         LDA  0A93Ch              ; 2B8E 3a 3c a9
         CPI  14h                 ; 2B91 fe 14
         JC   L_2B98              ; 2B93 da 98 2b
         MVI  A,14h               ; 2B96 3e 14
L_2B98:  CPI  01h                 ; 2B98 fe 01
         JZ   L_2BA6              ; 2B9A ca a6 2b
         PUSH PSW                 ; 2B9D f5
         CALL L_2DDE              ; 2B9E cd de 2d
         POP  PSW                 ; 2BA1 f1
         DCR  A                   ; 2BA2 3d
         JMP  L_2B98              ; 2BA3 c3 98 2b
L_2BA6:  CALL L_2DD0              ; 2BA6 cd d0 2d
L_2BA9:  CALL L_0D44              ; 2BA9 cd 44 0d
         LXI  H,2BB5h             ; 2BAC 21 b5 2b
         CALL L_0562              ; 2BAF cd 62 05
         JMP  L_2BA9              ; 2BB2 c3 a9 2b
         .db 07h,1Ah,8Eh,2Dh,19h,3Eh,2Dh,1Bh,0C3h,2Dh,1Fh,70h,2Dh,0Dh,0E1h,2Bh ; 2BB5 |...-.>-..-.p-..+|
         .db 18h,04h,2Dh,08h,28h,2Dh,6Fh,2Dh,21h,80h,9Fh,3Eh,59h,0BEh,0C8h,2Ch ; 2BC5 |..-.(-o-!..>Y..,|
         .db 0C2h,0D2h,2Bh,3Ah,3Eh,0A9h,0C6h,80h,6Fh,36h,59h,0C9h,21h,51h,35h,11h ; 2BD5 |..+:>...o6Y.!Q5.|
         .db 63h,0B6h,0CDh,79h,39h,0CDh,38h,10h,3Ah,8Dh,0B6h,3Dh,0C8h,3Ah,73h,0B6h ; 2BE5 |c..y9.8.:..=.:s.|
         .db 32h,4Fh,35h,0CDh,0F3h,0Fh,21h,5Dh,35h,0DFh,0E5h,0CDh,0A2h,0Ah,0E1h,3Ah ; 2BF5 |2O5...!]5......:|
         .db 0BEh,10h,32h,5Ch,2Ch,0CDh,0CDh,2Bh,0CDh,0E2h,3Bh,21h,4Eh,35h,11h,0A7h ; 2C05 |..2\,..+..;!N5..|
         .db 0B6h,0Eh,07h,0EFh,0CDh,0E9h,3Bh,3Ah,3Fh,0A9h,0C6h,02h,21h,0A7h,0B6h,77h ; 2C15 |......;:?...!..w|
         .db 23h,36h,44h,23h,0E5h,21h,91h,3Eh,0CDh,4Dh,0Eh,7Eh,0E1h,77h,23h,3Ah ; 2C25 |#6D#.!.>.M.~.w#:|
         .db 3Fh,0A9h,0CDh,96h,2Ch,36h,0Dh,0CDh,0E9h,3Bh,21h,0A7h,0B6h,3Ah,3Ch,0A9h ; 2C35 |?...,6...;!..:<.|
         .db 0F5h,0Fh,0Fh,0Fh,0Fh,0E6h,0Fh,4Fh,0F1h,0C6h,02h,81h,77h,23h,79h,3Ch ; 2C45 |.......O....w#y<|
         .db 0CDh,96h,2Ch,36h,4Eh,23h,36h,58h,23h,0EBh,21h,81h,9Fh,3Ah,3Ch,0A9h ; 2C55 |..,6N#6X#.!..:<.|
         .db 4Fh,0EFh,0CDh,0E9h,3Bh                           ; 2C65 |O...;|
L_2C6A:  LXI  H,3569h             ; 2C6A 21 69 35
         LXI  D,0B6A7h            ; 2C6D 11 a7 b6
         MVI  C,0Bh               ; 2C70 0e 0b
         RST  5                   ; 2C72 ef
         CALL L_3BE9              ; 2C73 cd e9 3b
         LXI  D,0B6A7h            ; 2C76 11 a7 b6
         LXI  H,3574h             ; 2C79 21 74 35
         MVI  C,05h               ; 2C7C 0e 05
         RST  5                   ; 2C7E ef
         CALL L_3BE9              ; 2C7F cd e9 3b
L_2C82:  CALL L_3C07              ; 2C82 cd 07 3c
         MVI  A,02h               ; 2C85 3e 02
         STA  0004h               ; 2C87 32 04 00
         LXI  H,3579h             ; 2C8A 21 79 35
         LXI  D,0DF14h            ; 2C8D 11 14 df
         MVI  C,08h               ; 2C90 0e 08
         RST  5                   ; 2C92 ef
         JMP  L_200F              ; 2C93 c3 0f 20
L_2C96:  DCR  A                   ; 2C96 3d
         RZ                       ; 2C97 c8
         MVI  M,18h               ; 2C98 36 18
         INX  H                   ; 2C9A 23
         JMP  L_2C96              ; 2C9B c3 96 2c
L_2C9E:  LXI  H,0000h             ; 2C9E 21 00 00
         SHLD 0B68Dh              ; 2CA1 22 8d b6
         CALL L_3BE2              ; 2CA4 cd e2 3b
L_2CA7:  LDA  0B68Dh              ; 2CA7 3a 8d b6
         CPI  02h                 ; 2CAA fe 02
         JZ   L_2C82              ; 2CAC ca 82 2c
         CALL L_3D24              ; 2CAF cd 24 3d
         LDA  0B68Dh              ; 2CB2 3a 8d b6
         DCR  A                   ; 2CB5 3d
         RZ                       ; 2CB6 c8
         CPI  0FFh                ; 2CB7 fe ff
         CZ   L_3BE9              ; 2CB9 cc e9 3b
         JMP  L_2CA7              ; 2CBC c3 a7 2c
L_2CBF:  LXI  H,0DF14h            ; 2CBF 21 14 df
         LDA  0A859h              ; 2CC2 3a 59 a8
         ADI  0Ch                 ; 2CC5 c6 0c
         MOV  M,A                 ; 2CC7 77
         INX  H                   ; 2CC8 23
         LDA  0B673h              ; 2CC9 3a 73 b6
         MOV  M,A                 ; 2CCC 77
         INX  H                   ; 2CCD 23
         MVI  M,3Ah               ; 2CCE 36 3a
         INX  H                   ; 2CD0 23
         XCHG                     ; 2CD1 eb
         LXI  H,0B663h            ; 2CD2 21 63 b6
         MVI  C,08h               ; 2CD5 0e 08
         RST  5                   ; 2CD7 ef
         PUSH D                   ; 2CD8 d5
         LXI  H,3E91h             ; 2CD9 21 91 3e
         CALL L_0E4D              ; 2CDC cd 4d 0e
         MOV  A,M                 ; 2CDF 7e
         POP  D                   ; 2CE0 d1
         STAX D                   ; 2CE1 12
         INX  D                   ; 2CE2 13
         MVI  A,3Ah               ; 2CE3 3e 3a
         STAX D                   ; 2CE5 12
         INX  D                   ; 2CE6 13
         LXI  H,0A859h            ; 2CE7 21 59 a8
L_2CEA:  MOV  C,M                 ; 2CEA 4e
         INX  H                   ; 2CEB 23
         RST  5                   ; 2CEC ef
         JMP  L_200F              ; 2CED c3 0f 20
L_2CF0:  CALL L_3D24              ; 2CF0 cd 24 3d
         LDA  0B68Dh              ; 2CF3 3a 8d b6
         DCR  A                   ; 2CF6 3d
         RZ                       ; 2CF7 c8
         LXI  D,0DF14h            ; 2CF8 11 14 df
         LXI  H,0B6A7h            ; 2CFB 21 a7 b6
         MOV  A,M                 ; 2CFE 7e
         STAX D                   ; 2CFF 12
         INX  D                   ; 2D00 13
         JMP  L_2CEA              ; 2D01 c3 ea 2c
         .db 3Ah,3Eh,0A9h,4Fh,3Ah,3Dh,0A9h,0C6h,14h,47h,0B9h,0C8h,3Ah,3Ch,0A9h,0B9h ; 2D04 |:>.O:=...G..:<..|
         .db 0C8h,0B8h,0DAh,1Ah,2Dh,78h,0F5h,3Ah,3Eh,0A9h,0CDh,0DEh,2Dh,0F1h,32h,3Eh ; 2D14 |....-x.:>...-.2>|
         .db 0A9h,0C3h,0D0h,2Dh,3Ah,3Dh,0A9h,4Fh,3Ah,3Eh,0A9h,0B9h,0C8h,0CDh,0DEh,2Dh ; 2D24 |...-:=.O:>.....-|
         .db 3Ah,3Dh,0A9h,3Ch,32h,3Eh,0A9h,0C3h,0D0h,2Dh,3Ah,3Eh,0A9h,0FEh,01h,0C8h ; 2D34 |:=.<2>...-:>....|
         .db 0F5h,0CDh,0DEh,2Dh,3Ah,3Dh,0A9h,4Fh,0F1h,0F5h,91h,0FEh,01h,0C2h,66h,2Dh ; 2D44 |...-:=.O......f-|
         .db 0CDh,0Ah,2Ah,3Eh,01h,32h,4Ah,35h,0CDh,81h,34h,0CDh,0Ah,2Ah,21h,3Dh ; 2D54 |..*>.2J5..4..*!=|
         .db 0A9h,35h,0F1h,3Dh,0CDh,0D0h,2Dh,21h,3Eh,0A9h,35h,0C9h,3Ah,3Eh,0A9h,0C6h ; 2D64 |.5.=..-!>.5.:>..|
         .db 80h,6Fh,26h,9Fh,7Eh,0FEh,4Eh,3Eh,4Eh,0C2h,82h,2Dh,3Eh,59h,77h,3Ah ; 2D74 |.o&.~.N>N..->Yw:|
         .db 3Ch,0A9h,4Fh,3Ah,3Eh,0A9h,0B9h,0CAh,0D0h,2Dh,3Ah,3Ch,0A9h,4Fh,3Ah,3Eh ; 2D84 |<.O:>....-:<.O:>|
         .db 0A9h,0B9h,0C8h,0F5h,0CDh,0DEh,2Dh,3Ah,3Dh,0A9h,4Fh,0F1h,0F5h,91h,0FEh,14h ; 2D94 |......-:=.O.....|
         .db 0C2h,0B9h,2Dh,0CDh,0Ah,2Ah,3Eh,02h,32h,4Ah,35h,0CDh,81h,34h,0CDh,0Ah ; 2DA4 |..-..*>.2J5..4..|
         .db 2Ah,21h,3Dh,0A9h,34h,0F1h,3Ch,0CDh,0D0h,2Dh,21h,3Eh,0A9h,34h,0C9h,0CDh ; 2DB4 |*!=.4.<..-!>.4..|
         .db 0Ah,2Ah,0CDh,15h,04h,0CDh,0Ah,2Ah,0E1h,0C3h,0F3h,0Fh ; 2DC4 |.*.....*....|
L_2DD0:  PUSH PSW                 ; 2DD0 f5
         LXI  H,1097h             ; 2DD1 21 97 10
         RST  3                   ; 2DD4 df
         POP  PSW                 ; 2DD5 f1
         CALL L_2DDE              ; 2DD6 cd de 2d
         LXI  H,109Ah             ; 2DD9 21 9a 10
         RST  3                   ; 2DDC df
         RET                      ; 2DDD c9
L_2DDE:  MOV  E,A                 ; 2DDE 5f
         LXI  H,9F80h             ; 2DDF 21 80 9f
         ADD  L                   ; 2DE2 85
         MOV  L,A                 ; 2DE3 6f
         MOV  A,M                 ; 2DE4 7e
         PUSH PSW                 ; 2DE5 f5
         MOV  A,E                 ; 2DE6 7b
         LXI  H,0A93Dh            ; 2DE7 21 3d a9
         MOV  D,M                 ; 2DEA 56
         SUB  D                   ; 2DEB 92
         ADI  21h                 ; 2DEC c6 21
         STA  L_3583              ; 2DEE 32 83 35
         MVI  D,00h               ; 2DF1 16 00
         LXI  H,9FF0h             ; 2DF3 21 f0 9f
         XCHG                     ; 2DF6 eb
         DAD  H                   ; 2DF7 29
         DAD  H                   ; 2DF8 29
         DAD  H                   ; 2DF9 29
         DAD  H                   ; 2DFA 29
         DAD  D                   ; 2DFB 19
         MOV  A,M                 ; 2DFC 7e
         PUSH H                   ; 2DFD e5
         LXI  H,3592h             ; 2DFE 21 92 35
         CALL L_0E1B              ; 2E01 cd 1b 0e
         LXI  H,3581h             ; 2E04 21 81 35
         RST  3                   ; 2E07 df
         POP  H                   ; 2E08 e1
         INX  H                   ; 2E09 23
         MVI  A,08h               ; 2E0A 3e 08
         CALL L_2A02              ; 2E0C cd 02 2a
         MVI  C,20h               ; 2E0F 0e 20
         POP  PSW                 ; 2E11 f1
         CPI  4Eh                 ; 2E12 fe 4e
         JZ   L_2E19              ; 2E14 ca 19 2e
         MVI  C,7Fh               ; 2E17 0e 7f
L_2E19:  RST  4                   ; 2E19 e7
         MVI  A,03h               ; 2E1A 3e 03
         CALL L_2A02              ; 2E1C cd 02 2a
         MOV  E,M                 ; 2E1F 5e
         INX  H                   ; 2E20 23
         MOV  D,M                 ; 2E21 56
         INX  H                   ; 2E22 23
         PUSH H                   ; 2E23 e5
         XCHG                     ; 2E24 eb
         INX  H                   ; 2E25 23
         CALL L_1345              ; 2E26 cd 45 13
         POP  H                   ; 2E29 e1
         MOV  E,M                 ; 2E2A 5e
         INX  H                   ; 2E2B 23
         MOV  D,M                 ; 2E2C 56
         XCHG                     ; 2E2D eb
         DCX  H                   ; 2E2E 2b
         DAD  H                   ; 2E2F 29
         DAD  H                   ; 2E30 29
         DAD  H                   ; 2E31 29
         DAD  H                   ; 2E32 29
         DAD  H                   ; 2E33 29
         INR  H                   ; 2E34 24
         MOV  A,H                 ; 2E35 7c
         LXI  H,3588h             ; 2E36 21 88 35
         CALL L_0E1B              ; 2E39 cd 1b 0e
         LXI  H,3587h             ; 2E3C 21 87 35
         RST  3                   ; 2E3F df
         LXI  H,1F42h             ; 2E40 21 42 1f
         RST  3                   ; 2E43 df
         LXI  H,3591h             ; 2E44 21 91 35
         RST  3                   ; 2E47 df
         RET                      ; 2E48 c9
L_2E49:  MVI  C,12h               ; 2E49 0e 12
         JMP  L_2A54              ; 2E4B c3 54 2a
L_2E4E:  CALL L_03DE              ; 2E4E cd de 03
L_2E51:  LXI  H,35D2h             ; 2E51 21 d2 35
L_2E54:  LXI  D,0B663h            ; 2E54 11 63 b6
L_2E57:  CALL L_3979              ; 2E57 cd 79 39
L_2E5A:  CALL L_1038              ; 2E5A cd 38 10
L_2E5D:  LDA  0B68Dh              ; 2E5D 3a 8d b6
L_2E60:  CPI  01h                 ; 2E60 fe 01
L_2E62:  RZ                       ; 2E62 c8
L_2E63:  LXI  H,35C9h             ; 2E63 21 c9 35
L_2E66:  LXI  D,0A859h            ; 2E66 11 59 a8
L_2E69:  MVI  C,09h               ; 2E69 0e 09
L_2E6B:  RST  5                   ; 2E6B ef
L_2E6C:  CALL L_2F41              ; 2E6C cd 41 2f
L_2E6F:  RET                      ; 2E6F c9
L_2E70:  XRA  A                   ; 2E70 af
L_2E71:  STA  0B68Dh              ; 2E71 32 8d b6
L_2E74:  LDA  0A854h              ; 2E74 3a 54 a8
L_2E77:  CPI  00h                 ; 2E77 fe 00
L_2E79:  JNZ  L_2E84              ; 2E79 c2 84 2e
L_2E7C:  LDA  0A853h              ; 2E7C 3a 53 a8
L_2E7F:  CPI  15h                 ; 2E7F fe 15
L_2E81:  JC   L_2E8F              ; 2E81 da 8f 2e
L_2E84:  MVI  A,27h               ; 2E84 3e 27
L_2E86:  CALL L_2EE6              ; 2E86 cd e6 2e
L_2E89:  LXI  D,0FFEDh            ; 2E89 11 ed ff
L_2E8C:  JMP  L_2F16              ; 2E8C c3 16 2f
L_2E8F:  CALL L_31BA              ; 2E8F cd ba 31
         MVI  A,01h               ; 2E92 3e 01
         STA  0A853h              ; 2E94 32 53 a8
         JMP  L_33A5              ; 2E97 c3 a5 33
L_2E9A:  MVI  A,01h               ; 2E9A 3e 01
L_2E9C:  STA  L_354A              ; 2E9C 32 4a 35
L_2E9F:  LDA  0A854h              ; 2E9F 3a 54 a8
L_2EA2:  CPI  00h                 ; 2EA2 fe 00
L_2EA4:  JNZ  L_2EBD              ; 2EA4 c2 bd 2e
L_2EA7:  LDA  0A853h              ; 2EA7 3a 53 a8
L_2EAA:  CPI  03h                 ; 2EAA fe 03
L_2EAC:  JNC  L_2EBD              ; 2EAC d2 bd 2e
         CPI  01h                 ; 2EAF fe 01
         RZ                       ; 2EB1 c8
         CALL L_31BA              ; 2EB2 cd ba 31
         MVI  A,01h               ; 2EB5 3e 01
         STA  0A853h              ; 2EB7 32 53 a8
         JMP  L_2ECA              ; 2EBA c3 ca 2e
L_2EBD:  LHLD 0A853h              ; 2EBD 2a 53 a8
L_2EC0:  DCX  H                   ; 2EC0 2b
L_2EC1:  SHLD 0A853h              ; 2EC1 22 53 a8
L_2EC4:  CALL L_318E              ; 2EC4 cd 8e 31
L_2EC7:  CALL L_32C3              ; 2EC7 cd c3 32
L_2ECA:  CALL L_336B              ; 2ECA cd 6b 33
L_2ECD:  MVI  C,13h               ; 2ECD 0e 13
L_2ECF:  PUSH B                   ; 2ECF c5
L_2ED0:  CALL L_32E7              ; 2ED0 cd e7 32
L_2ED3:  POP  B                   ; 2ED3 c1
L_2ED4:  DCR  C                   ; 2ED4 0d
L_2ED5:  JNZ  L_2ECF              ; 2ED5 c2 cf 2e
L_2ED8:  JMP  L_0FF3              ; 2ED8 c3 f3 0f
L_2EDB:  MVI  A,13h               ; 2EDB 3e 13
L_2EDD:  CALL L_2EE6              ; 2EDD cd e6 2e
L_2EE0:  CALL L_274E              ; 2EE0 cd 4e 27
L_2EE3:  JMP  L_33A5              ; 2EE3 c3 a5 33
L_2EE6:  LXI  H,0A840h            ; 2EE6 21 40 a8
L_2EE9:  SUB  M                   ; 2EE9 96
L_2EEA:  PUSH PSW                 ; 2EEA f5
L_2EEB:  CALL L_32C3              ; 2EEB cd c3 32
L_2EEE:  POP  PSW                 ; 2EEE f1
L_2EEF:  DCR  A                   ; 2EEF 3d
L_2EF0:  JNZ  L_2EEA              ; 2EF0 c2 ea 2e
L_2EF3:  RET                      ; 2EF3 c9
         .db 3Ah,57h,0A8h,0C6h,10h,32h,57h,0A8h,0CDh,8Eh,31h,0C3h,0A5h,33h,3Ah,57h ; 2EF4 |:W...2W...1..3:W|
         .db 0A8h,0D6h,10h,0C3h,0F9h,2Eh                      ; 2F04 |......|
L_2F0A:  LDA  0B68Dh              ; 2F0A 3a 8d b6
L_2F0D:  CPI  4Dh                 ; 2F0D fe 4d
L_2F0F:  RZ                       ; 2F0F c8
L_2F10:  CALL L_32C3              ; 2F10 cd c3 32
L_2F13:  LXI  D,0013h             ; 2F13 11 13 00
L_2F16:  LHLD 0A853h              ; 2F16 2a 53 a8
L_2F19:  DAD  D                   ; 2F19 19
L_2F1A:  SHLD 0A853h              ; 2F1A 22 53 a8
L_2F1D:  JMP  L_33A5              ; 2F1D c3 a5 33
L_2F20:  CALL L_27FE              ; 2F20 cd fe 27
L_2F23:  CALL L_318E              ; 2F23 cd 8e 31
L_2F26:  JMP  L_33A5              ; 2F26 c3 a5 33
L_2F29:  MVI  A,02h               ; 2F29 3e 02
L_2F2B:  STA  L_354A              ; 2F2B 32 4a 35
L_2F2E:  LDA  0B68Dh              ; 2F2E 3a 8d b6
L_2F31:  CPI  4Dh                 ; 2F31 fe 4d
L_2F33:  RZ                       ; 2F33 c8
L_2F34:  LHLD 0A853h              ; 2F34 2a 53 a8
L_2F37:  INX  H                   ; 2F37 23
L_2F38:  SHLD 0A853h              ; 2F38 22 53 a8
L_2F3B:  CALL L_335A              ; 2F3B cd 5a 33
L_2F3E:  JMP  L_0FF3              ; 2F3E c3 f3 0f
L_2F41:  LXI  H,35DEh             ; 2F41 21 de 35
L_2F44:  RST  3                   ; 2F44 df
L_2F45:  CALL L_0FF3              ; 2F45 cd f3 0f
L_2F48:  LXI  H,0000h             ; 2F48 21 00 00
L_2F4B:  SHLD 0A857h              ; 2F4B 22 57 a8
L_2F4E:  CALL L_1821              ; 2F4E cd 21 18
L_2F51:  CALL L_33A5              ; 2F51 cd a5 33
L_2F54:  LXI  H,36BFh             ; 2F54 21 bf 36
L_2F57:  RST  3                   ; 2F57 df
L_2F58:  CALL L_0D44              ; 2F58 cd 44 0d
L_2F5B:  LXI  H,2F64h             ; 2F5B 21 64 2f
L_2F5E:  CALL L_0562              ; 2F5E cd 62 05
L_2F61:  JMP  L_2F54              ; 2F61 c3 54 2f
         .db 0Dh,03h,29h,2Fh,00h,9Ah,2Eh,0Ch,36h,31h,02h,91h,2Fh,0Dh,07h,30h ; 2F64 |..)/....61../..0|
         .db 0Ah,0EAh,2Fh,1Bh,65h,31h,19h,70h,2Eh,18h,0F4h,2Eh,08h,02h,2Fh,01h ; 2F74 |../.e1.p....../.|
         .db 20h,2Fh,1Fh,0DBh,2Eh,1Ah,0Ah,2Fh,0F3h,0Fh,2Ah,40h,0A8h,0CDh,0DCh,31h ; 2F84 | /...../..*@...1|
         .db 0FEh,04h,0C8h,0CDh,8Eh,31h,21h,6Bh,36h,22h,8Dh,0B6h,0DFh,0CDh,7Eh,20h ; 2F94 |.....1!k6"....~ |
         .db 0E1h,22h,38h,0A9h,0CDh,0F3h,0Fh                  ; 2FA4 |."8....|
L_2FAB:  LHLD 0A938h              ; 2FAB 2a 38 a9
         MVI  A,00h               ; 2FAE 3e 00
         CMP  H                   ; 2FB0 bc
         JNZ  L_2FBE              ; 2FB1 c2 be 2f
         CMP  L                   ; 2FB4 bd
         JNZ  L_2FBE              ; 2FB5 c2 be 2f
L_2FB8:  CALL L_33A5              ; 2FB8 cd a5 33
         JMP  L_0FE0              ; 2FBB c3 e0 0f
L_2FBE:  DCX  H                   ; 2FBE 2b
         SHLD 0A938h              ; 2FBF 22 38 a9
         LDA  0B68Dh              ; 2FC2 3a 8d b6
         CPI  4Dh                 ; 2FC5 fe 4d
         JZ   L_2FB8              ; 2FC7 ca b8 2f
         CALL L_305B              ; 2FCA cd 5b 30
         JMP  L_2FAB              ; 2FCD c3 ab 2f
L_2FD0:  POP  PSW                 ; 2FD0 f1
         POP  PSW                 ; 2FD1 f1
         POP  PSW                 ; 2FD2 f1
         POP  PSW                 ; 2FD3 f1
         POP  PSW                 ; 2FD4 f1
L_2FD5:  CALL L_329C              ; 2FD5 cd 9c 32
L_2FD8:  CALL L_32C3              ; 2FD8 cd c3 32
L_2FDB:  CALL L_33A5              ; 2FDB cd a5 33
L_2FDE:  JMP  L_0FE0              ; 2FDE c3 e0 0f
L_2FE1:  LDA  0A937h              ; 2FE1 3a 37 a9
         STA  L_3647              ; 2FE4 32 47 36
         JMP  L_0FE0              ; 2FE7 c3 e0 0f
L_2FEA:  CALL L_0FF3              ; 2FEA cd f3 0f
L_2FED:  LDA  L_3647              ; 2FED 3a 47 36
L_2FF0:  STA  0A937h              ; 2FF0 32 37 a9
L_2FF3:  LXI  H,3632h             ; 2FF3 21 32 36
L_2FF6:  RST  3                   ; 2FF6 df
L_2FF7:  LXI  D,3646h             ; 2FF7 11 46 36
L_2FFA:  MVI  C,0Ah               ; 2FFA 0e 0a
L_2FFC:  CALL 0005h               ; 2FFC cd 05 00
L_2FFF:  LDA  L_3647              ; 2FFF 3a 47 36
L_3002:  CPI  00h                 ; 3002 fe 00
L_3004:  JZ   L_2FE1              ; 3004 ca e1 2f
L_3007:  LDA  0B68Dh              ; 3007 3a 8d b6
L_300A:  CPI  4Dh                 ; 300A fe 4d
L_300C:  JZ   L_0FE0              ; 300C ca e0 0f
L_300F:  CALL L_318E              ; 300F cd 8e 31
L_3012:  CALL L_32E7              ; 3012 cd e7 32
L_3015:  LHLD 0A853h              ; 3015 2a 53 a8
L_3018:  INX  H                   ; 3018 23
L_3019:  SHLD 0A853h              ; 3019 22 53 a8
L_301C:  LHLD 0A855h              ; 301C 2a 55 a8
L_301F:  LXI  D,3647h             ; 301F 11 47 36
L_3022:  LDAX D                   ; 3022 1a
L_3023:  MOV  C,A                 ; 3023 4f
L_3024:  INX  D                   ; 3024 13
L_3025:  PUSH D                   ; 3025 d5
L_3026:  PUSH B                   ; 3026 c5
L_3027:  LDAX D                   ; 3027 1a
L_3028:  MOV  B,A                 ; 3028 47
L_3029:  CALL L_303D              ; 3029 cd 3d 30
L_302C:  CMP  B                   ; 302C b8
L_302D:  JNZ  L_3035              ; 302D c2 35 30
L_3030:  INX  D                   ; 3030 13
L_3031:  DCR  C                   ; 3031 0d
L_3032:  JNZ  L_3027              ; 3032 c2 27 30
L_3035:  POP  B                   ; 3035 c1
L_3036:  POP  D                   ; 3036 d1
L_3037:  JZ   L_2FD5              ; 3037 ca d5 2f
L_303A:  JMP  L_3025              ; 303A c3 25 30
L_303D:  PUSH D                   ; 303D d5
L_303E:  PUSH B                   ; 303E c5
L_303F:  RST  2                   ; 303F d7
L_3040:  CPI  1Ah                 ; 3040 fe 1a
L_3042:  JZ   L_2FD0              ; 3042 ca d0 2f
L_3045:  CPI  0Dh                 ; 3045 fe 0d
L_3047:  CZ   L_3051              ; 3047 cc 51 30
L_304A:  INR  L                   ; 304A 2c
L_304B:  CZ   L_3340              ; 304B cc 40 33
L_304E:  POP  B                   ; 304E c1
L_304F:  POP  D                   ; 304F d1
L_3050:  RET                      ; 3050 c9
L_3051:  PUSH H                   ; 3051 e5
L_3052:  LHLD 0A853h              ; 3052 2a 53 a8
L_3055:  INX  H                   ; 3055 23
L_3056:  SHLD 0A853h              ; 3056 22 53 a8
L_3059:  POP  H                   ; 3059 e1
L_305A:  RET                      ; 305A c9
L_305B:  LHLD 0A855h              ; 305B 2a 55 a8
         CALL L_306F              ; 305E cd 6f 30
         LDA  0B68Dh              ; 3061 3a 8d b6
         CPI  4Dh                 ; 3064 fe 4d
         RZ                       ; 3066 c8
         LHLD 0A853h              ; 3067 2a 53 a8
         INX  H                   ; 306A 23
         SHLD 0A853h              ; 306B 22 53 a8
         RET                      ; 306E c9
L_306F:  RST  2                   ; 306F d7
         CPI  1Ah                 ; 3070 fe 1a
         JZ   L_330B              ; 3072 ca 0b 33
         CPI  0Dh                 ; 3075 fe 0d
         JZ   L_3089              ; 3077 ca 89 30
         CALL L_3099              ; 307A cd 99 30
         CPI  1Bh                 ; 307D fe 1b
         JZ   L_308F              ; 307F ca 8f 30
         INR  L                   ; 3082 2c
         CZ   L_3340              ; 3083 cc 40 33
         JMP  L_306F              ; 3086 c3 6f 30
L_3089:  CALL L_3099              ; 3089 cd 99 30
         JMP  L_329C              ; 308C c3 9c 32
L_308F:  LDA  0A853h              ; 308F 3a 53 a8
         INR  A                   ; 3092 3c
         STA  0A853h              ; 3093 32 53 a8
         JMP  L_330B              ; 3096 c3 0b 33
L_3099:  PUSH H                   ; 3099 e5
         STA  L_3549              ; 309A 32 49 35
         LDA  L_354D              ; 309D 3a 4d 35
         CPI  01h                 ; 30A0 fe 01
         JZ   L_30B0              ; 30A2 ca b0 30
         CALL L_30E9              ; 30A5 cd e9 30
         LDA  L_354D              ; 30A8 3a 4d 35
         CPI  03h                 ; 30AB fe 03
         CZ   L_30D5              ; 30AD cc d5 30
L_30B0:  LDA  L_3549              ; 30B0 3a 49 35
         MOV  C,A                 ; 30B3 4f
L_30B4:  IN   05h                 ; 30B4 db 05
         ANI  01h                 ; 30B6 e6 01
         JNZ  L_30C1              ; 30B8 c2 c1 30
         CALL 0F80Fh              ; 30BB cd 0f f8
         XRA  A                   ; 30BE af
         POP  H                   ; 30BF e1
         RET                      ; 30C0 c9
L_30C1:  PUSH B                   ; 30C1 c5
         MVI  E,0FFh              ; 30C2 1e ff
         MVI  C,06h               ; 30C4 0e 06
         CALL 0005h               ; 30C6 cd 05 00
         CPI  1Bh                 ; 30C9 fe 1b
         JNZ  L_30D1              ; 30CB c2 d1 30
         POP  B                   ; 30CE c1
         POP  H                   ; 30CF e1
         RET                      ; 30D0 c9
L_30D1:  POP  B                   ; 30D1 c1
         JMP  L_30B4              ; 30D2 c3 b4 30
L_30D5:  LDA  L_3549              ; 30D5 3a 49 35
         CPI  80h                 ; 30D8 fe 80
         RC                       ; 30DA d8
         SUI  80h                 ; 30DB d6 80
         LXI  H,0103h             ; 30DD 21 03 01
         MOV  E,A                 ; 30E0 5f
         MVI  D,00h               ; 30E1 16 00
         DAD  D                   ; 30E3 19
         MOV  A,M                 ; 30E4 7e
         STA  L_3549              ; 30E5 32 49 35
         RET                      ; 30E8 c9
L_30E9:  LDA  L_3E8F              ; 30E9 3a 8f 3e
         CPI  4Ch                 ; 30EC fe 4c
         JZ   L_30F7              ; 30EE ca f7 30
         CPI  53h                 ; 30F1 fe 53
         JZ   L_311C              ; 30F3 ca 1c 31
         RET                      ; 30F6 c9
L_30F7:  LDA  L_3549              ; 30F7 3a 49 35
         CPI  60h                 ; 30FA fe 60
         RC                       ; 30FC d8
         CPI  80h                 ; 30FD fe 80
         JNC  L_3108              ; 30FF d2 08 31
         ADI  80h                 ; 3102 c6 80
         STA  L_3549              ; 3104 32 49 35
         RET                      ; 3107 c9
L_3108:  CPI  0C0h                ; 3108 fe c0
         RC                       ; 310A d8
         CPI  0E0h                ; 310B fe e0
         JNC  L_3116              ; 310D d2 16 31
         SUI  60h                 ; 3110 d6 60
         STA  L_3549              ; 3112 32 49 35
         RET                      ; 3115 c9
L_3116:  SUI  20h                 ; 3116 d6 20
         STA  L_3549              ; 3118 32 49 35
         RET                      ; 311B c9
L_311C:  LDA  L_3549              ; 311C 3a 49 35
         CPI  40h                 ; 311F fe 40
         RC                       ; 3121 d8
         CPI  80h                 ; 3122 fe 80
         JNC  L_312D              ; 3124 d2 2d 31
         ADI  80h                 ; 3127 c6 80
         STA  L_3549              ; 3129 32 49 35
         RET                      ; 312C c9
L_312D:  CPI  0C0h                ; 312D fe c0
         RC                       ; 312F d8
         SUI  80h                 ; 3130 d6 80
         STA  L_3549              ; 3132 32 49 35
         RET                      ; 3135 c9
         .db 3Ah,9Dh,0B6h,0FEh,03h,0C8h,21h,86h               ; 3136 |:.....!.|
L_313E:  MVI  M,0DFh              ; 313E 36 df
         MVI  A,28h               ; 3140 3e 28
         MVI  C,20h               ; 3142 0e 20
L_3144:  RST  4                   ; 3144 e7
         DCR  A                   ; 3145 3d
         JNZ  L_3144              ; 3146 c2 44 31
         LXI  H,368Bh             ; 3149 21 8b 36
         RST  3                   ; 314C df
         LXI  H,0A859h            ; 314D 21 59 a8
         CALL L_0F6B              ; 3150 cd 6b 0f
         LDA  0B69Dh              ; 3153 3a 9d b6
         STA  0A94Eh              ; 3156 32 4e a9
         LXI  H,0003h             ; 3159 21 03 00
         SHLD 0B69Dh              ; 315C 22 9d b6
         CALL L_318E              ; 315F cd 8e 31
         JMP  L_33A5              ; 3162 c3 a5 33
L_3165:  MVI  C,10h               ; 3165 0e 10
L_3167:  LXI  D,005Ch             ; 3167 11 5c 00
L_316A:  CALL 0005h               ; 316A cd 05 00
L_316D:  CALL L_0FE0              ; 316D cd e0 0f
L_3170:  LDA  0B69Dh              ; 3170 3a 9d b6
L_3173:  PUSH PSW                 ; 3173 f5
L_3174:  MVI  A,03h               ; 3174 3e 03
L_3176:  STA  0B69Dh              ; 3176 32 9d b6
L_3179:  CALL L_0415              ; 3179 cd 15 04
L_317C:  POP  PSW                 ; 317C f1
L_317D:  STA  0B69Dh              ; 317D 32 9d b6
L_3180:  CPI  03h                 ; 3180 fe 03
L_3182:  CZ   L_3187              ; 3182 cc 87 31
L_3185:  POP  H                   ; 3185 e1
L_3186:  RET                      ; 3186 c9
L_3187:  LDA  0A94Eh              ; 3187 3a 4e a9
         STA  0B69Dh              ; 318A 32 9d b6
         RET                      ; 318D c9
L_318E:  LHLD 0A853h              ; 318E 2a 53 a8
L_3191:  DCX  H                   ; 3191 2b
L_3192:  XRA  A                   ; 3192 af
L_3193:  CMP  H                   ; 3193 bc
L_3194:  JNZ  L_319B              ; 3194 c2 9b 31
L_3197:  CMP  L                   ; 3197 bd
L_3198:  JZ   L_31BA              ; 3198 ca ba 31
L_319B:  LDA  0A840h              ; 319B 3a 40 a8
L_319E:  MOV  C,A                 ; 319E 4f
L_319F:  MVI  A,14h               ; 319F 3e 14
L_31A1:  SUB  C                   ; 31A1 91
L_31A2:  MOV  C,A                 ; 31A2 4f
L_31A3:  PUSH B                   ; 31A3 c5
L_31A4:  CALL L_32C3              ; 31A4 cd c3 32
L_31A7:  POP  B                   ; 31A7 c1
L_31A8:  DCR  C                   ; 31A8 0d
L_31A9:  JNZ  L_31A3              ; 31A9 c2 a3 31
L_31AC:  RET                      ; 31AC c9
         .db 3Ah,9Dh,0B6h,3Dh,0C2h,0B6h,31h,3Eh,02h,32h,9Dh,0B6h,0C9h ; 31AD |:..=..1>.2...|
L_31BA:  LXI  D,005Ch             ; 31BA 11 5c 00
L_31BD:  MVI  C,10h               ; 31BD 0e 10
L_31BF:  CALL 0005h               ; 31BF cd 05 00
L_31C2:  JMP  L_1821              ; 31C2 c3 21 18
L_31C5:  LHLD 0A853h              ; 31C5 2a 53 a8
         DCX  H                   ; 31C8 2b
         MOV  A,H                 ; 31C9 7c
         CPI  00h                 ; 31CA fe 00
         JNZ  L_32C3              ; 31CC c2 c3 32
         MOV  A,L                 ; 31CF 7d
         CPI  00h                 ; 31D0 fe 00
         JNZ  L_32C3              ; 31D2 c2 c3 32
         LXI  H,0A000h            ; 31D5 21 00 a0
         SHLD 0A855h              ; 31D8 22 55 a8
         RET                      ; 31DB c9
L_31DC:  LXI  D,0403h             ; 31DC 11 03 04
L_31DF:  LXI  H,3690h             ; 31DF 21 90 36
L_31E2:  CALL L_0CF1              ; 31E2 cd f1 0c
         MVI  D,1Bh               ; 31E5 16 1b
         CMP  D                   ; 31E7 ba
         JNZ  L_31ED              ; 31E8 c2 ed 31
         MVI  A,04h               ; 31EB 3e 04
L_31ED:  STA  L_354D              ; 31ED 32 4d 35
         RET                      ; 31F0 c9
L_31F1:  LXI  H,3E91h             ; 31F1 21 91 3e
L_31F4:  CALL L_0E4D              ; 31F4 cd 4d 0e
L_31F7:  MOV  A,M                 ; 31F7 7e
L_31F8:  STA  0B673h              ; 31F8 32 73 b6
L_31FB:  CALL L_31DC              ; 31FB cd dc 31
         CPI  04h                 ; 31FE fe 04
         JZ   L_0FE0              ; 3200 ca e0 0f
         CALL L_29DF              ; 3203 cd df 29
         CALL L_0FF3              ; 3206 cd f3 0f
         LXI  H,3690h             ; 3209 21 90 36
         RST  3                   ; 320C df
         LXI  H,0000h             ; 320D 21 00 00
         SHLD 0A83Eh              ; 3210 22 3e a8
         CALL L_18EE              ; 3213 cd ee 18
L_3216:  LXI  H,6100h             ; 3216 21 00 61
         LXI  B,4000h             ; 3219 01 00 40
L_321C:  PUSH B                   ; 321C c5
         RST  2                   ; 321D d7
         CPI  1Ah                 ; 321E fe 1a
         JZ   L_3239              ; 3220 ca 39 32
         CALL L_3099              ; 3223 cd 99 30
         CPI  1Bh                 ; 3226 fe 1b
         JZ   L_3239              ; 3228 ca 39 32
         POP  B                   ; 322B c1
         INX  H                   ; 322C 23
         DCX  B                   ; 322D 0b
         MOV  A,B                 ; 322E 78
         ORA  C                   ; 322F b1
         JNZ  L_321C              ; 3230 c2 1c 32
         CALL L_323D              ; 3233 cd 3d 32
         JMP  L_3216              ; 3236 c3 16 32
L_3239:  POP  B                   ; 3239 c1
         JMP  L_0FE0              ; 323A c3 e0 0f
L_323D:  LHLD 0A83Eh              ; 323D 2a 3e a8
         LXI  D,0080h             ; 3240 11 80 00
         DAD  D                   ; 3243 19
         SHLD 0A83Eh              ; 3244 22 3e a8
         JMP  L_18EE              ; 3247 c3 ee 18
L_324A:  MVI  A,0F8h              ; 324A 3e f8
         ANA  E                   ; 324C a3
         MOV  E,A                 ; 324D 5f
         CPI  00h                 ; 324E fe 00
         JNZ  L_3268              ; 3250 c2 68 32
         JMP  L_3282              ; 3253 c3 82 32
L_3256:  STA  L_354B              ; 3256 32 4b 35
L_3259:  CALL L_101B              ; 3259 cd 1b 10
L_325C:  LHLD 0A857h              ; 325C 2a 57 a8
L_325F:  XCHG                     ; 325F eb
L_3260:  LHLD 0A855h              ; 3260 2a 55 a8
L_3263:  MOV  A,E                 ; 3263 7b
L_3264:  ANA  A                   ; 3264 a7
L_3265:  JZ   L_3282              ; 3265 ca 82 32
L_3268:  RST  2                   ; 3268 d7
         CPI  1Ah                 ; 3269 fe 1a
         JZ   L_3282              ; 326B ca 82 32
         CPI  0Dh                 ; 326E fe 0d
         JZ   L_3282              ; 3270 ca 82 32
         PUSH PSW                 ; 3273 f5
         INR  L                   ; 3274 2c
         CZ   L_3340              ; 3275 cc 40 33
         POP  PSW                 ; 3278 f1
         CPI  09h                 ; 3279 fe 09
         JZ   L_324A              ; 327B ca 4a 32
         DCR  E                   ; 327E 1d
         JNZ  L_3268              ; 327F c2 68 32
L_3282:  RST  2                   ; 3282 d7
L_3283:  CPI  0Ah                 ; 3283 fe 0a
L_3285:  CZ   L_32BE              ; 3285 cc be 32
L_3288:  LDA  L_354B              ; 3288 3a 4b 35
L_328B:  MOV  E,A                 ; 328B 5f
L_328C:  RST  2                   ; 328C d7
L_328D:  CPI  20h                 ; 328D fe 20
L_328F:  CC   L_331F              ; 328F dc 1f 33
L_3292:  MOV  C,A                 ; 3292 4f
L_3293:  RST  4                   ; 3293 e7
L_3294:  INR  L                   ; 3294 2c
L_3295:  CZ   L_3340              ; 3295 cc 40 33
L_3298:  DCR  E                   ; 3298 1d
L_3299:  JNZ  L_328C              ; 3299 c2 8c 32
L_329C:  RST  2                   ; 329C d7
L_329D:  CPI  1Ah                 ; 329D fe 1a
L_329F:  JZ   L_32B8              ; 329F ca b8 32
L_32A2:  CPI  0Dh                 ; 32A2 fe 0d
L_32A4:  JZ   L_32B5              ; 32A4 ca b5 32
L_32A7:  CALL L_32BE              ; 32A7 cd be 32
L_32AA:  RST  2                   ; 32AA d7
L_32AB:  CPI  1Ah                 ; 32AB fe 1a
L_32AD:  JZ   L_32B8              ; 32AD ca b8 32
L_32B0:  CPI  0Dh                 ; 32B0 fe 0d
L_32B2:  JNZ  L_32A7              ; 32B2 c2 a7 32
L_32B5:  CALL L_32BE              ; 32B5 cd be 32
L_32B8:  SHLD 0A855h              ; 32B8 22 55 a8
L_32BB:  RET                      ; 32BB c9
         .db 00h,0C9h                                         ; 32BC |..|
L_32BE:  INR  L                   ; 32BE 2c
L_32BF:  CZ   L_3340              ; 32BF cc 40 33
L_32C2:  RET                      ; 32C2 c9
L_32C3:  LHLD 0A855h              ; 32C3 2a 55 a8
L_32C6:  RST  2                   ; 32C6 d7
L_32C7:  CPI  1Ah                 ; 32C7 fe 1a
L_32C9:  JZ   L_32D3              ; 32C9 ca d3 32
L_32CC:  DCR  L                   ; 32CC 2d
L_32CD:  MOV  A,L                 ; 32CD 7d
L_32CE:  CPI  0FFh                ; 32CE fe ff
L_32D0:  CZ   L_334E              ; 32D0 cc 4e 33
L_32D3:  DCR  L                   ; 32D3 2d
L_32D4:  MOV  A,L                 ; 32D4 7d
L_32D5:  CPI  0FFh                ; 32D5 fe ff
L_32D7:  CZ   L_334E              ; 32D7 cc 4e 33
L_32DA:  RST  2                   ; 32DA d7
L_32DB:  CPI  0Dh                 ; 32DB fe 0d
L_32DD:  JNZ  L_32D3              ; 32DD c2 d3 32
L_32E0:  CALL L_32BE              ; 32E0 cd be 32
L_32E3:  SHLD 0A855h              ; 32E3 22 55 a8
L_32E6:  RET                      ; 32E6 c9
L_32E7:  LHLD 0A855h              ; 32E7 2a 55 a8
L_32EA:  RST  2                   ; 32EA d7
L_32EB:  CPI  1Ah                 ; 32EB fe 1a
L_32ED:  JZ   L_32FC              ; 32ED ca fc 32
L_32F0:  CPI  0Dh                 ; 32F0 fe 0d
L_32F2:  JZ   L_32E0              ; 32F2 ca e0 32
L_32F5:  INR  L                   ; 32F5 2c
L_32F6:  CZ   L_3340              ; 32F6 cc 40 33
L_32F9:  JMP  L_32EA              ; 32F9 c3 ea 32
L_32FC:  SHLD 0A855h              ; 32FC 22 55 a8
         LXI  H,004Dh             ; 32FF 21 4d 00
         SHLD 0B68Dh              ; 3302 22 8d b6
         RET                      ; 3305 c9
L_3306:  POP  PSW                 ; 3306 f1
L_3307:  JMP  L_329C              ; 3307 c3 9c 32
L_330A:  POP  PSW                 ; 330A f1
L_330B:  PUSH H                   ; 330B e5
L_330C:  LXI  H,004Dh             ; 330C 21 4d 00
L_330F:  SHLD 0B68Dh              ; 330F 22 8d b6
L_3312:  POP  H                   ; 3312 e1
L_3313:  JMP  L_329C              ; 3313 c3 9c 32
L_3316:  PUSH PSW                 ; 3316 f5
L_3317:  DCR  E                   ; 3317 1d
L_3318:  MVI  A,0F8h              ; 3318 3e f8
L_331A:  ANA  E                   ; 331A a3
L_331B:  MOV  E,A                 ; 331B 5f
L_331C:  INR  E                   ; 331C 1c
L_331D:  POP  PSW                 ; 331D f1
L_331E:  RET                      ; 331E c9
L_331F:  CPI  1Ah                 ; 331F fe 1a
L_3321:  JZ   L_330A              ; 3321 ca 0a 33
L_3324:  CPI  09h                 ; 3324 fe 09
L_3326:  JZ   L_3316              ; 3326 ca 16 33
L_3329:  CPI  0Dh                 ; 3329 fe 0d
L_332B:  JZ   L_3306              ; 332B ca 06 33
L_332E:  PUSH PSW                 ; 332E f5
L_332F:  MVI  C,5Eh               ; 332F 0e 5e
L_3331:  RST  4                   ; 3331 e7
L_3332:  MVI  C,40h               ; 3332 0e 40
L_3334:  DCR  E                   ; 3334 1d
L_3335:  JZ   L_333B              ; 3335 ca 3b 33
L_3338:  POP  PSW                 ; 3338 f1
L_3339:  ADD  C                   ; 3339 81
L_333A:  RET                      ; 333A c9
L_333B:  POP  PSW                 ; 333B f1
         POP  B                   ; 333C c1
         JMP  L_329C              ; 333D c3 9c 32
L_3340:  PUSH D                   ; 3340 d5
L_3341:  PUSH H                   ; 3341 e5
L_3342:  LXI  H,0000h             ; 3342 21 00 00
L_3345:  SHLD 0B68Dh              ; 3345 22 8d b6
L_3348:  CALL L_1855              ; 3348 cd 55 18
L_334B:  POP  H                   ; 334B e1
L_334C:  POP  D                   ; 334C d1
L_334D:  RET                      ; 334D c9
L_334E:  PUSH H                   ; 334E e5
L_334F:  LXI  H,0001h             ; 334F 21 01 00
L_3352:  SHLD 0B68Dh              ; 3352 22 8d b6
L_3355:  CALL L_1855              ; 3355 cd 55 18
L_3358:  POP  H                   ; 3358 e1
L_3359:  RET                      ; 3359 c9
L_335A:  CALL L_3384              ; 335A cd 84 33
L_335D:  LDA  L_3538              ; 335D 3a 38 35
L_3360:  ADI  14h                 ; 3360 c6 14
L_3362:  CALL L_3475              ; 3362 cd 75 34
L_3365:  CALL L_33E9              ; 3365 cd e9 33
L_3368:  JMP  L_3256              ; 3368 c3 56 32
L_336B:  CALL L_3384              ; 336B cd 84 33
L_336E:  CALL L_3471              ; 336E cd 71 34
L_3371:  CALL L_3365              ; 3371 cd 65 33
L_3374:  LDA  0A840h              ; 3374 3a 40 a8
L_3377:  CPI  00h                 ; 3377 fe 00
L_3379:  RZ                       ; 3379 c8
         DCR  A                   ; 337A 3d
         STA  0A840h              ; 337B 32 40 a8
         MVI  A,4Dh               ; 337E 3e 4d
         STA  0B68Dh              ; 3380 32 8d b6
         RET                      ; 3383 c9
L_3384:  XRA  A                   ; 3384 af
L_3385:  STA  0B68Dh              ; 3385 32 8d b6
L_3388:  CALL L_3481              ; 3388 cd 81 34
L_338B:  CALL L_3451              ; 338B cd 51 34
L_338E:  LDA  L_3534              ; 338E 3a 34 35
L_3391:  ADI  0Fh                 ; 3391 c6 0f
L_3393:  STA  L_3534              ; 3393 32 34 35
L_3396:  CALL L_3419              ; 3396 cd 19 34
L_3399:  LXI  H,3531h             ; 3399 21 31 35
L_339C:  RST  3                   ; 339C df
L_339D:  MVI  A,04h               ; 339D 3e 04
L_339F:  LXI  H,3524h             ; 339F 21 24 35
L_33A2:  JMP  L_0F75              ; 33A2 c3 75 0f
L_33A5:  XRA  A                   ; 33A5 af
L_33A6:  STA  0B68Dh              ; 33A6 32 8d b6
L_33A9:  CALL L_347D              ; 33A9 cd 7d 34
L_33AC:  CALL L_3451              ; 33AC cd 51 34
L_33AF:  CALL L_33FB              ; 33AF cd fb 33
L_33B2:  LXI  H,3531h             ; 33B2 21 31 35
L_33B5:  RST  3                   ; 33B5 df
L_33B6:  LXI  H,353Bh             ; 33B6 21 3b 35
L_33B9:  PUSH H                   ; 33B9 e5
L_33BA:  RST  3                   ; 33BA df
L_33BB:  LXI  H,3522h             ; 33BB 21 22 35
L_33BE:  RST  3                   ; 33BE df
L_33BF:  POP  H                   ; 33BF e1
L_33C0:  RST  3                   ; 33C0 df
L_33C1:  MVI  B,14h               ; 33C1 06 14
L_33C3:  CALL L_33E9              ; 33C3 cd e9 33
L_33C6:  STA  L_354B              ; 33C6 32 4b 35
L_33C9:  CALL L_101B              ; 33C9 cd 1b 10
L_33CC:  CALL L_3471              ; 33CC cd 71 34
L_33CF:  PUSH B                   ; 33CF c5
L_33D0:  CALL L_325C              ; 33D0 cd 5c 32
L_33D3:  POP  B                   ; 33D3 c1
L_33D4:  LDA  0B68Dh              ; 33D4 3a 8d b6
L_33D7:  CPI  4Dh                 ; 33D7 fe 4d
L_33D9:  JZ   L_33F4              ; 33D9 ca f4 33
L_33DC:  DCR  B                   ; 33DC 05
L_33DD:  JNZ  L_33CC              ; 33DD c2 cc 33
L_33E0:  LXI  H,0000h             ; 33E0 21 00 00
L_33E3:  SHLD 0A840h              ; 33E3 22 40 a8
L_33E6:  JMP  L_0FF3              ; 33E6 c3 f3 0f
L_33E9:  LDA  0B69Dh              ; 33E9 3a 9d b6
L_33EC:  CPI  03h                 ; 33EC fe 03
L_33EE:  MVI  A,28h               ; 33EE 3e 28
L_33F0:  RNZ                      ; 33F0 c0
         MVI  A,50h               ; 33F1 3e 50
         RET                      ; 33F3 c9
L_33F4:  DCR  B                   ; 33F4 05
L_33F5:  MOV  L,B                 ; 33F5 68
L_33F6:  MVI  H,00h               ; 33F6 26 00
L_33F8:  JMP  L_33E3              ; 33F8 c3 e3 33
L_33FB:  LHLD 0A857h              ; 33FB 2a 57 a8
L_33FE:  LXI  D,0FF9Ch            ; 33FE 11 9c ff
L_3401:  CALL L_3441              ; 3401 cd 41 34
L_3404:  STA  L_352B              ; 3404 32 2b 35
L_3407:  LXI  D,0FFF6h            ; 3407 11 f6 ff
L_340A:  CALL L_3441              ; 340A cd 41 34
L_340D:  STA  L_352C              ; 340D 32 2c 35
L_3410:  LXI  D,0FFFFh            ; 3410 11 ff ff
L_3413:  CALL L_3441              ; 3413 cd 41 34
L_3416:  STA  L_352D              ; 3416 32 2d 35
L_3419:  LHLD 0A853h              ; 3419 2a 53 a8
L_341C:  LXI  D,0FC18h            ; 341C 11 18 fc
L_341F:  CALL L_3441              ; 341F cd 41 34
L_3422:  STA  L_3524              ; 3422 32 24 35
L_3425:  LXI  D,0FF9Ch            ; 3425 11 9c ff
L_3428:  CALL L_3441              ; 3428 cd 41 34
L_342B:  STA  L_3525              ; 342B 32 25 35
L_342E:  LXI  D,0FFF6h            ; 342E 11 f6 ff
L_3431:  CALL L_3441              ; 3431 cd 41 34
L_3434:  STA  L_3526              ; 3434 32 26 35
L_3437:  LXI  D,0FFFFh            ; 3437 11 ff ff
L_343A:  CALL L_3441              ; 343A cd 41 34
L_343D:  STA  L_3527              ; 343D 32 27 35
L_3440:  RET                      ; 3440 c9
L_3441:  MVI  A,00h               ; 3441 3e 00
L_3443:  PUSH H                   ; 3443 e5
L_3444:  DAD  D                   ; 3444 19
L_3445:  JNC  L_344D              ; 3445 d2 4d 34
L_3448:  INR  A                   ; 3448 3c
L_3449:  POP  B                   ; 3449 c1
L_344A:  JMP  L_3443              ; 344A c3 43 34
L_344D:  POP  H                   ; 344D e1
L_344E:  ADI  30h                 ; 344E c6 30
L_3450:  RET                      ; 3450 c9
L_3451:  LDA  0B69Dh              ; 3451 3a 9d b6
L_3454:  DCR  A                   ; 3454 3d
L_3455:  JZ   L_3464              ; 3455 ca 64 34
L_3458:  LXI  H,2020h             ; 3458 21 20 20
L_345B:  SHLD L_3533              ; 345B 22 33 35
L_345E:  LXI  H,2021h             ; 345E 21 21 20
L_3461:  JMP  L_346D              ; 3461 c3 6d 34
L_3464:  LXI  H,4820h             ; 3464 21 20 48
L_3467:  SHLD L_3533              ; 3467 22 33 35
L_346A:  LXI  H,4821h             ; 346A 21 21 48
L_346D:  SHLD L_3538              ; 346D 22 38 35
L_3470:  RET                      ; 3470 c9
L_3471:  LDA  L_3538              ; 3471 3a 38 35
L_3474:  INR  A                   ; 3474 3c
L_3475:  STA  L_3538              ; 3475 32 38 35
L_3478:  LXI  H,3536h             ; 3478 21 36 35
L_347B:  RST  3                   ; 347B df
L_347C:  RET                      ; 347C c9
L_347D:  XRA  A                   ; 347D af
L_347E:  STA  L_354A              ; 347E 32 4a 35
L_3481:  LXI  H,0000h             ; 3481 21 00 00
L_3484:  DAD  SP                  ; 3484 39
L_3485:  LXI  SP,00FFh            ; 3485 31 ff 00
L_3488:  PUSH H                   ; 3488 e5
L_3489:  DI                       ; 3489 f3
L_348A:  LDA  0B69Dh              ; 348A 3a 9d b6
L_348D:  PUSH PSW                 ; 348D f5
L_348E:  XRA  A                   ; 348E af
L_348F:  OUT  10h                 ; 348F d3 10
L_3491:  MVI  B,0Fh               ; 3491 06 0f
L_3493:  POP  PSW                 ; 3493 f1
L_3494:  DCR  A                   ; 3494 3d
L_3495:  JZ   L_34A8              ; 3495 ca a8 34
L_3498:  DCR  A                   ; 3498 3d
L_3499:  JZ   L_349E              ; 3499 ca 9e 34
         MVI  B,1Eh               ; 349C 06 1e
L_349E:  MVI  H,0A1h              ; 349E 26 a1
L_34A0:  CALL L_3504              ; 34A0 cd 04 35
L_34A3:  MVI  H,0C1h              ; 34A3 26 c1
L_34A5:  JMP  L_34AF              ; 34A5 c3 af 34
L_34A8:  MVI  H,0D0h              ; 34A8 26 d0
L_34AA:  CALL L_3504              ; 34AA cd 04 35
L_34AD:  MVI  H,0B0h              ; 34AD 26 b0
L_34AF:  CALL L_3504              ; 34AF cd 04 35
L_34B2:  MVI  A,23h               ; 34B2 3e 23
L_34B4:  OUT  10h                 ; 34B4 d3 10
L_34B6:  POP  H                   ; 34B6 e1
L_34B7:  SPHL                     ; 34B7 f9
L_34B8:  EI                       ; 34B8 fb
L_34B9:  RET                      ; 34B9 c9
L_34BA:  PUSH B                   ; 34BA c5
L_34BB:  XCHG                     ; 34BB eb
L_34BC:  LXI  H,0000h             ; 34BC 21 00 00
L_34BF:  DAD  SP                  ; 34BF 39
L_34C0:  SHLD 34E1h               ; 34C0 22 e1 34
L_34C3:  MOV  H,D                 ; 34C3 62
L_34C4:  DCR  A                   ; 34C4 3d
L_34C5:  MOV  A,H                 ; 34C5 7c
L_34C6:  JZ   L_34EA              ; 34C6 ca ea 34
L_34C9:  MVI  E,0DFh              ; 34C9 1e df
L_34CB:  MVI  L,0EAh              ; 34CB 2e ea
L_34CD:  SPHL                     ; 34CD f9
L_34CE:  XCHG                     ; 34CE eb
L_34CF:  MVI  C,5Eh               ; 34CF 0e 5e
L_34D1:  MOV  D,M                 ; 34D1 56
L_34D2:  DCR  L                   ; 34D2 2d
L_34D3:  MOV  E,M                 ; 34D3 5e
L_34D4:  DCR  L                   ; 34D4 2d
L_34D5:  PUSH D                   ; 34D5 d5
L_34D6:  DCR  C                   ; 34D6 0d
L_34D7:  JNZ  L_34D1              ; 34D7 c2 d1 34
L_34DA:  INR  H                   ; 34DA 24
L_34DB:  MOV  D,H                 ; 34DB 54
L_34DC:  DCR  B                   ; 34DC 05
L_34DD:  JNZ  L_34C9              ; 34DD c2 c9 34
L_34E0:  LXI  SP,0000h            ; 34E0 31 00 00
L_34E3:  POP  B                   ; 34E3 c1
L_34E4:  MOV  H,A                 ; 34E4 67
L_34E5:  MVI  C,0Bh               ; 34E5 0e 0b
L_34E7:  JMP  L_350F              ; 34E7 c3 0f 35
L_34EA:  MVI  E,23h               ; 34EA 1e 23
L_34EC:  MVI  L,2Dh               ; 34EC 2e 2d
L_34EE:  MVI  C,5Eh               ; 34EE 0e 5e
L_34F0:  SPHL                     ; 34F0 f9
L_34F1:  XCHG                     ; 34F1 eb
L_34F2:  POP  D                   ; 34F2 d1
L_34F3:  MOV  M,E                 ; 34F3 73
L_34F4:  INR  L                   ; 34F4 2c
L_34F5:  MOV  M,D                 ; 34F5 72
L_34F6:  INR  L                   ; 34F6 2c
L_34F7:  DCR  C                   ; 34F7 0d
L_34F8:  JNZ  L_34F2              ; 34F8 c2 f2 34
L_34FB:  INR  H                   ; 34FB 24
L_34FC:  MOV  D,H                 ; 34FC 54
L_34FD:  DCR  B                   ; 34FD 05
L_34FE:  JNZ  L_34EA              ; 34FE c2 ea 34
L_3501:  JMP  L_34E0              ; 3501 c3 e0 34
L_3504:  LDA  L_354A              ; 3504 3a 4a 35
L_3507:  ANA  A                   ; 3507 a7
L_3508:  JNZ  L_34BA              ; 3508 c2 ba 34
L_350B:  MVI  C,0CFh              ; 350B 0e cf
L_350D:  MVI  L,20h               ; 350D 2e 20
L_350F:  XRA  A                   ; 350F af
L_3510:  PUSH B                   ; 3510 c5
L_3511:  PUSH B                   ; 3511 c5
L_3512:  PUSH H                   ; 3512 e5
L_3513:  MOV  M,A                 ; 3513 77
L_3514:  INX  H                   ; 3514 23
L_3515:  DCR  C                   ; 3515 0d
L_3516:  JNZ  L_3513              ; 3516 c2 13 35
L_3519:  POP  H                   ; 3519 e1
L_351A:  INR  H                   ; 351A 24
L_351B:  POP  B                   ; 351B c1
L_351C:  DCR  B                   ; 351C 05
L_351D:  JNZ  L_3511              ; 351D c2 11 35
L_3520:  POP  B                   ; 3520 c1
L_3521:  RET                      ; 3521 c9
         .db 0F3h,2Dh                                         ; 3522 |.-|
L_3524:  .db 20h                                              ; 3524 | |
L_3525:  .db 20h                                              ; 3525 | |
L_3526:  .db 20h                                              ; 3526 | |
L_3527:  .db 20h,20h,0F0h,2Dh                                 ; 3527 |  .-|
L_352B:  .db 20h                                              ; 352B | |
L_352C:  .db 20h                                              ; 352C | |
L_352D:  .db 20h,20h,20h,00h,1Bh,59h                          ; 352D |   ..Y|
L_3533:  .db 00h                                              ; 3533 |.|
L_3534:  .db 00h,00h,1Bh,59h                                  ; 3534 |...Y|
L_3538:  .db 20h,20h,00h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h ; 3538 |  .             |
         .db 00h                                              ; 3548 |.|
L_3549:  .db 00h                                              ; 3549 |.|
L_354A:  .db 00h                                              ; 354A |.|
L_354B:  .db 00h,00h                                          ; 354B |..|
L_354D:  .db 00h,06h,58h,3Ah,41h,52h,43h,32h,20h,20h,20h,20h,20h,43h,4Fh,4Dh ; 354D |..X:ARC2     COM|
         .db 0F2h,0C1h,0D3h,0D0h,0C1h,0CBh,0CFh,0D7h,0CBh,0C1h,20h,00h,0Ah,45h,20h,43h ; 355D |.......... ..E C|
         .db 3Ah,43h,4Fh,2Eh,54h,4Fh,4Bh,04h,43h,3Ah,43h,4Fh,07h,3Ch,43h,4Fh ; 356D |:CO.TOK.C:CO.<CO|
         .db 2Eh,54h,4Fh,4Bh,1Bh,59h                          ; 357D |.TOK.Y|
L_3583:  .db 20h                                              ; 3583 | |
L_3584:  .db 20h,20h,00h,20h,20h,20h,20h,20h,0EBh,0C2h,20h,20h,00h,20h,20h,20h ; 3584 |  .     ..  .   |
         .db 20h,25h,20h,00h,1Bh,59h,20h                      ; 3594 | % ..Y |
L_359B:  .db 20h,1Bh,62h,20h,20h,20h,00h,20h,20h,20h,20h,20h,0EBh,0C2h,00h,20h ; 359B | .b   .     ... |
         .db 20h,0E6h,0C1h,0CAh,0CCh,0CFh,0D7h,20h,20h,20h,20h,20h,20h,20h,20h,1Bh ; 35AB | ......        .|
         .db 61h,00h,3Fh,3Fh,3Fh,3Fh,3Fh,3Fh,3Fh,3Fh,00h,50h,4Bh,32h,07h,20h ; 35BB |a.????????.PK2. |
         .db 0F0h,0CFh,0CDh,0CFh,0DDh,0D8h,00h,43h,4Fh,20h,20h,20h,20h,20h,20h,20h ; 35CB |.......CO       |
         .db 48h,4Ch,50h,1Bh,59h,38h,20h,46h,31h,2Dh,0F7h,0D7h,0C5h,0D2h,0C8h,20h ; 35DB |HLP.Y8 F1-..... |
         .db 46h,32h,2Dh,0FBh,0D2h,0C9h,0C6h,0D4h,20h,46h,33h,2Dh,0F0h,0C5h,0DEh,0C1h ; 35EB |F2-..... F3-....|
         .db 0D4h,0D8h,20h,46h,34h,2Dh,0F7h,0CEh,0C9h,0DAh,20h,43h,54h,50h,2Dh,0EBh ; 35FB |.. F4-.... CTP-.|
         .db 20h,0D3h,0D4h,0D2h,0CFh,0CBh,0C5h,20h,23h,20h,0F0h,0F3h,2Dh,0F0h,0CFh,0C9h ; 360B | ...... # ..-...|
         .db 0D3h,0CBh,20h,0F7h,0EBh,2Dh,0F0h,0CFh,0C9h,0D3h,0CBh,20h,0D3h,0CCh,0C5h,0C4h ; 361B |.. ..-..... ....|
         .db 0D5h,0C0h,0DDh,0C5h,0C7h,0CFh,00h,20h,0F0h,0CFh,0C9h,0D3h,0CBh,20h,0D0h,0CFh ; 362B |....... ..... ..|
         .db 0C4h,0D3h,0D4h,0D2h,0CFh,0CBh,0C9h,20h,2Dh,20h,00h,23h ; 363B |....... - .#|
L_3647:  .db 01h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h ; 3647 |.               |
         .db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h ; 3657 |                |
         .db 20h,20h,20h,20h,20h,0F3h,0CBh,0CFh,0CCh,0D8h,0CBh,0CFh,20h,0D3h,0D4h,0D2h ; 3667 |     ....... ...|
         .db 0CFh,0CBh,20h,0D0h,0C5h,0DEh,0C1h,0D4h,0C1h,0D4h,0D8h,20h,2Dh,20h,00h,1Bh ; 3677 |.. ........ - ..|
         .db 59h,20h,48h,00h,1Bh,59h,20h,61h,00h,0F0h,0C5h,0DEh,0C1h,0D4h,0D8h,00h ; 3687 |Y H..Y a........|
         .db 0F0h,0D2h,0D1h,0CDh,0CFh,0CAh,5Fh,0D7h,0D9h,0D7h,0CFh,0C4h,00h,0F7h,5Fh,0CEh ; 3697 |......_......._.|
         .db 0C1h,0C2h,0CFh,0D2h,5Fh,38h,00h,0F7h,5Fh,0E1h,0CCh,0D8h,0D4h,5Fh,0EBh,0CFh ; 36A7 |...._8.._...._..|
         .db 0C4h,5Fh,0E7h,0EFh,0F3h,0F4h,0C1h,00h,1Bh,5Bh,00h,21h,66h,0A8h,0C3h,0CBh ; 36B7 |._.......[.!f...|
         .db 36h,21h,59h,0A8h,22h,0E9h,36h,22h,0Bh,37h,21h,89h,0B6h,0CDh,47h,0Eh ; 36C7 |6!Y.".6".7!...G.|
         .db 7Eh,0FEh,00h,0C8h,3Ah,14h,0DFh,0FEh,37h,0D0h,0CDh,3Ah,39h,21h,14h,0DFh ; 36D7 |~...:...7..:9!..|
         .db 4Eh,3Ah,59h,0A8h,0C6h,03h,47h,81h,77h,79h,85h,6Fh,3Ah,02h,0A8h,0FEh ; 36E7 |N:Y...G.wy.o:...|
         .db 00h,0C4h,3Bh,37h,0E5h,21h,91h,3Eh,0CDh,4Dh,0Eh,7Eh,0E1h,23h,77h,23h ; 36F7 |..;7.!.>.M.~.#w#|
         .db 36h,3Ah,23h,11h,59h,0A8h,0EBh,4Eh,23h,0EFh,0EBh,36h,20h,0C3h,0EFh,27h ; 3707 |6:#.Y..N#..6 ..'|
L_3717:  LDA  0DF14h              ; 3717 3a 14 df
L_371A:  CPI  46h                 ; 371A fe 46
L_371C:  RNC                      ; 371C d0
L_371D:  LDA  0A802h              ; 371D 3a 02 a8
L_3720:  CPI  00h                 ; 3720 fe 00
L_3722:  JZ   L_3754              ; 3722 ca 54 37
         MOV  C,A                 ; 3725 4f
         LXI  H,0DF14h            ; 3726 21 14 df
         MOV  A,M                 ; 3729 7e
         ADD  L                   ; 372A 85
         MOV  L,A                 ; 372B 6f
         MOV  D,H                 ; 372C 54
         MOV  E,L                 ; 372D 5d
         INX  D                   ; 372E 13
         CALL L_374B              ; 372F cd 4b 37
         LDA  0B693h              ; 3732 3a 93 b6
         STAX D                   ; 3735 12
         LXI  H,0DF14h            ; 3736 21 14 df
         INR  M                   ; 3739 34
         RET                      ; 373A c9
         .db 48h,47h,21h,14h,0DFh,7Eh,85h,5Fh,91h,6Fh,54h,48h,0CDh,4Bh,37h,0C9h ; 373B |HG!..~._.oTH.K7.|
L_374B:  MOV  A,M                 ; 374B 7e
         STAX D                   ; 374C 12
         DCX  D                   ; 374D 1b
         DCX  H                   ; 374E 2b
         DCR  C                   ; 374F 0d
         JNZ  L_374B              ; 3750 c2 4b 37
         RET                      ; 3753 c9
L_3754:  LXI  H,0DF14h            ; 3754 21 14 df
L_3757:  INR  M                   ; 3757 34
L_3758:  MOV  A,M                 ; 3758 7e
L_3759:  ADD  L                   ; 3759 85
L_375A:  MOV  L,A                 ; 375A 6f
L_375B:  LDA  0B693h              ; 375B 3a 93 b6
L_375E:  MOV  M,A                 ; 375E 77
L_375F:  RET                      ; 375F c9
L_3760:  LXI  H,3E91h             ; 3760 21 91 3e
         CALL L_0E4D              ; 3763 cd 4d 0e
         MOV  A,M                 ; 3766 7e
         STA  0B673h              ; 3767 32 73 b6
         LXI  H,1527h             ; 376A 21 27 15
         JMP  L_0B7A              ; 376D c3 7a 0b
L_3770:  LDA  0B69Bh              ; 3770 3a 9b b6
         PUSH PSW                 ; 3773 f5
         LXI  H,0B689h            ; 3774 21 89 b6
         CALL L_0E47              ; 3777 cd 47 0e
         MOV  B,M                 ; 377A 46
         INR  B                   ; 377B 04
         PUSH B                   ; 377C c5
         CALL L_20CA              ; 377D cd ca 20
         POP  B                   ; 3780 c1
         MVI  A,01h               ; 3781 3e 01
         LXI  D,0009h             ; 3783 11 09 00
         DAD  D                   ; 3786 19
L_3787:  PUSH H                   ; 3787 e5
         PUSH PSW                 ; 3788 f5
         PUSH B                   ; 3789 c5
         STA  0B69Bh              ; 378A 32 9b b6
         CALL L_37A1              ; 378D cd a1 37
         POP  B                   ; 3790 c1
         POP  PSW                 ; 3791 f1
         POP  H                   ; 3792 e1
         LXI  D,000Dh             ; 3793 11 0d 00
         DAD  D                   ; 3796 19
         INR  A                   ; 3797 3c
         CMP  B                   ; 3798 b8
         JNZ  L_3787              ; 3799 c2 87 37
         POP  PSW                 ; 379C f1
         STA  0B69Bh              ; 379D 32 9b b6
         RET                      ; 37A0 c9
L_37A1:  LXI  D,3E89h             ; 37A1 11 89 3e
         MVI  C,03h               ; 37A4 0e 03
         CALL L_381A              ; 37A6 cd 1a 38
         RNZ                      ; 37A9 c0
         JMP  L_26D1              ; 37AA c3 d1 26
L_37AD:  CALL L_2A0A              ; 37AD cd 0a 2a
L_37B0:  CALL L_20CA              ; 37B0 cd ca 20
L_37B3:  SHLD 37EAh               ; 37B3 22 ea 37
L_37B6:  LXI  H,0B689h            ; 37B6 21 89 b6
L_37B9:  CALL L_0E47              ; 37B9 cd 47 0e
L_37BC:  MOV  A,M                 ; 37BC 7e
L_37BD:  STA  37EDh               ; 37BD 32 ed 37
L_37C0:  CALL L_2A0A              ; 37C0 cd 0a 2a
L_37C3:  CALL L_20CA              ; 37C3 cd ca 20
L_37C6:  SHLD 37FFh               ; 37C6 22 ff 37
L_37C9:  LXI  H,0B689h            ; 37C9 21 89 b6
L_37CC:  CALL L_0E47              ; 37CC cd 47 0e
L_37CF:  MOV  C,M                 ; 37CF 4e
L_37D0:  PUSH B                   ; 37D0 c5
L_37D1:  CALL L_37E9              ; 37D1 cd e9 37
L_37D4:  POP  B                   ; 37D4 c1
L_37D5:  LHLD 37FFh               ; 37D5 2a ff 37
L_37D8:  LXI  D,000Dh             ; 37D8 11 0d 00
L_37DB:  DAD  D                   ; 37DB 19
L_37DC:  SHLD 37FFh               ; 37DC 22 ff 37
L_37DF:  DCR  C                   ; 37DF 0d
L_37E0:  JNZ  L_37D0              ; 37E0 c2 d0 37
L_37E3:  CALL L_11F1              ; 37E3 cd f1 11
L_37E6:  JMP  L_090F              ; 37E6 c3 0f 09
L_37E9:  LXI  H,0000h             ; 37E9 21 00 00
L_37EC:  MVI  C,00h               ; 37EC 0e 00
L_37EE:  PUSH H                   ; 37EE e5
L_37EF:  PUSH B                   ; 37EF c5
L_37F0:  CALL L_37FE              ; 37F0 cd fe 37
L_37F3:  POP  B                   ; 37F3 c1
L_37F4:  POP  H                   ; 37F4 e1
L_37F5:  LXI  D,000Dh             ; 37F5 11 0d 00
L_37F8:  DAD  D                   ; 37F8 19
L_37F9:  DCR  C                   ; 37F9 0d
L_37FA:  JNZ  L_37EE              ; 37FA c2 ee 37
L_37FD:  RET                      ; 37FD c9
L_37FE:  LXI  D,0000h             ; 37FE 11 00 00
L_3801:  MVI  C,08h               ; 3801 0e 08
L_3803:  LDAX D                   ; 3803 1a
L_3804:  CPI  2Eh                 ; 3804 fe 2e
L_3806:  RZ                       ; 3806 c8
L_3807:  CALL L_381A              ; 3807 cd 1a 38
L_380A:  RNZ                      ; 380A c0
L_380B:  INX  H                   ; 380B 23
L_380C:  INX  D                   ; 380C 13
L_380D:  MVI  C,03h               ; 380D 0e 03
L_380F:  CALL L_381A              ; 380F cd 1a 38
L_3812:  RNZ                      ; 3812 c0
L_3813:  LXI  H,0FFFCh            ; 3813 21 fc ff
L_3816:  DAD  D                   ; 3816 19
L_3817:  MVI  M,7Fh               ; 3817 36 7f
L_3819:  RET                      ; 3819 c9
L_381A:  LDAX D                   ; 381A 1a
L_381B:  CMP  M                   ; 381B be
L_381C:  RNZ                      ; 381C c0
L_381D:  INX  H                   ; 381D 23
L_381E:  INX  D                   ; 381E 13
L_381F:  DCR  C                   ; 381F 0d
L_3820:  JNZ  L_381A              ; 3820 c2 1a 38
L_3823:  RET                      ; 3823 c9
         .db 3Ah,59h,0A8h,0C6h,0Ch,21h,0A7h,0B6h,77h,23h,3Ah,73h,0B6h,77h,23h,36h ; 3824 |:Y...!..w#:s.w#6|
         .db 3Ah,23h,0EBh,21h,9Fh,0B6h,23h,0Eh,07h,0EFh,0EBh,36h,20h,23h,0E5h,21h ; 3834 |:#.!..#....6 #.!|
         .db 91h,3Eh,0CDh,4Dh,0Eh,7Eh,0E1h,77h,23h,36h,3Ah,23h,0EBh,21h,59h,0A8h ; 3844 |.>.M.~.w#6:#.!Y.|
         .db 4Eh,23h,0EFh,0D5h,21h,9Fh,0B6h,11h,05h,00h,19h,0D1h,7Eh,0FEh,44h,0C8h ; 3854 |N#..!.......~.D.|
         .db 0FEh,52h,0CAh,82h,38h,3Eh,22h,12h,13h,21h,0A7h,0B6h,46h,3Ah,66h,0A8h ; 3864 |.R..8>"..!..F:f.|
         .db 4Fh,80h,0C6h,02h,77h,21h,66h,0A8h,23h,0EFh,3Eh,22h,12h,0C9h,3Ah,0A7h ; 3874 |O...w!f.#.>"..:.|
         .db 0B6h,0C6h,04h,32h,0A7h,0B6h,21h,85h,3Eh,0Eh,04h,0EFh,0C9h ; 3884 |...2..!.>....|
L_3891:  CALL L_393A              ; 3891 cd 3a 39
L_3894:  LXI  H,0B6A7h            ; 3894 21 a7 b6
L_3897:  MOV  C,M                 ; 3897 4e
L_3898:  INX  H                   ; 3898 23
L_3899:  MVI  A,21h               ; 3899 3e 21
L_389B:  CMP  M                   ; 389B be
L_389C:  CZ   L_38C9              ; 389C cc c9 38
L_389F:  INX  H                   ; 389F 23
L_38A0:  DCR  C                   ; 38A0 0d
L_38A1:  JNZ  L_389B              ; 38A1 c2 9b 38
L_38A4:  LXI  H,0B6A7h            ; 38A4 21 a7 b6
L_38A7:  MOV  C,M                 ; 38A7 4e
L_38A8:  INX  H                   ; 38A8 23
L_38A9:  MVI  A,21h               ; 38A9 3e 21
L_38AB:  CMP  M                   ; 38AB be
L_38AC:  CZ   L_38BA              ; 38AC cc ba 38
L_38AF:  INX  H                   ; 38AF 23
L_38B0:  DCR  C                   ; 38B0 0d
L_38B1:  JNZ  L_38AB              ; 38B1 c2 ab 38
L_38B4:  RET                      ; 38B4 c9
L_38B5:  MVI  A,21h               ; 38B5 3e 21
L_38B7:  POP  H                   ; 38B7 e1
L_38B8:  POP  B                   ; 38B8 c1
L_38B9:  RET                      ; 38B9 c9
L_38BA:  PUSH B                   ; 38BA c5
L_38BB:  PUSH H                   ; 38BB e5
L_38BC:  LDA  0A866h              ; 38BC 3a 66 a8
L_38BF:  INR  A                   ; 38BF 3c
L_38C0:  LXI  H,0A866h            ; 38C0 21 66 a8
L_38C3:  SHLD 3906h               ; 38C3 22 06 39
L_38C6:  JMP  L_38E3              ; 38C6 c3 e3 38
L_38C9:  PUSH B                   ; 38C9 c5
L_38CA:  PUSH H                   ; 38CA e5
L_38CB:  INX  H                   ; 38CB 23
L_38CC:  MVI  A,2Eh               ; 38CC 3e 2e
L_38CE:  CMP  M                   ; 38CE be
L_38CF:  JNZ  L_38B5              ; 38CF c2 b5 38
L_38D2:  INX  H                   ; 38D2 23
L_38D3:  MVI  A,21h               ; 38D3 3e 21
L_38D5:  CMP  M                   ; 38D5 be
L_38D6:  JNZ  L_38B5              ; 38D6 c2 b5 38
L_38D9:  LDA  0A859h              ; 38D9 3a 59 a8
L_38DC:  DCR  A                   ; 38DC 3d
L_38DD:  LXI  H,0A859h            ; 38DD 21 59 a8
L_38E0:  SHLD 3906h               ; 38E0 22 06 39
L_38E3:  LXI  H,0B6A7h            ; 38E3 21 a7 b6
L_38E6:  ADD  M                   ; 38E6 86
L_38E7:  MOV  M,A                 ; 38E7 77
L_38E8:  MOV  E,A                 ; 38E8 5f
L_38E9:  MVI  D,00h               ; 38E9 16 00
L_38EB:  DAD  D                   ; 38EB 19
L_38EC:  XCHG                     ; 38EC eb
L_38ED:  POP  H                   ; 38ED e1
L_38EE:  PUSH H                   ; 38EE e5
L_38EF:  MVI  B,00h               ; 38EF 06 00
L_38F1:  DAD  B                   ; 38F1 09
L_38F2:  INX  D                   ; 38F2 13
L_38F3:  CALL L_3915              ; 38F3 cd 15 39
L_38F6:  PUSH H                   ; 38F6 e5
L_38F7:  LXI  H,3E91h             ; 38F7 21 91 3e
L_38FA:  CALL L_0E4D              ; 38FA cd 4d 0e
L_38FD:  MOV  A,M                 ; 38FD 7e
L_38FE:  POP  H                   ; 38FE e1
L_38FF:  MOV  M,A                 ; 38FF 77
L_3900:  INX  H                   ; 3900 23
L_3901:  MVI  M,3Ah               ; 3901 36 3a
L_3903:  INX  H                   ; 3903 23
L_3904:  XCHG                     ; 3904 eb
L_3905:  LXI  H,0000h             ; 3905 21 00 00
L_3908:  MOV  C,M                 ; 3908 4e
L_3909:  INX  H                   ; 3909 23
L_390A:  MOV  A,M                 ; 390A 7e
L_390B:  STAX D                   ; 390B 12
L_390C:  INX  H                   ; 390C 23
L_390D:  INX  D                   ; 390D 13
L_390E:  DCR  C                   ; 390E 0d
L_390F:  JNZ  L_390A              ; 390F c2 0a 39
L_3912:  JMP  L_38B5              ; 3912 c3 b5 38
L_3915:  MOV  A,M                 ; 3915 7e
L_3916:  STAX D                   ; 3916 12
L_3917:  DCX  H                   ; 3917 2b
L_3918:  DCX  D                   ; 3918 1b
L_3919:  DCR  C                   ; 3919 0d
L_391A:  JNZ  L_3915              ; 391A c2 15 39
L_391D:  RET                      ; 391D c9
L_391E:  LXI  H,0B69Fh            ; 391E 21 9f b6
         INX  H                   ; 3921 23
         LXI  D,0B663h            ; 3922 11 63 b6
         MVI  C,07h               ; 3925 0e 07
         RST  5                   ; 3927 ef
         LXI  H,3E4Fh             ; 3928 21 4f 3e
         MVI  C,05h               ; 392B 0e 05
         RST  5                   ; 392D ef
         JMP  L_103B              ; 392E c3 3b 10
L_3931:  MVI  A,08h               ; 3931 3e 08
L_3933:  SUB  C                   ; 3933 91
L_3934:  STA  0A866h              ; 3934 32 66 a8
L_3937:  JMP  L_3957              ; 3937 c3 57 39
L_393A:  LHLD 0A842h              ; 393A 2a 42 a8
L_393D:  PUSH H                   ; 393D e5
L_393E:  CALL L_29DF              ; 393E cd df 29
L_3941:  PUSH H                   ; 3941 e5
L_3942:  LXI  D,0A866h            ; 3942 11 66 a8
L_3945:  MVI  A,08h               ; 3945 3e 08
L_3947:  MOV  C,A                 ; 3947 4f
L_3948:  STAX D                   ; 3948 12
L_3949:  INX  D                   ; 3949 13
L_394A:  MOV  A,M                 ; 394A 7e
L_394B:  CPI  20h                 ; 394B fe 20
L_394D:  JZ   L_3931              ; 394D ca 31 39
L_3950:  STAX D                   ; 3950 12
L_3951:  INX  H                   ; 3951 23
L_3952:  INX  D                   ; 3952 13
L_3953:  DCR  C                   ; 3953 0d
L_3954:  JNZ  L_394A              ; 3954 c2 4a 39
L_3957:  LXI  H,0A866h            ; 3957 21 66 a8
L_395A:  LXI  D,0A859h            ; 395A 11 59 a8
L_395D:  MOV  C,M                 ; 395D 4e
L_395E:  INR  C                   ; 395E 0c
L_395F:  RST  5                   ; 395F ef
L_3960:  POP  H                   ; 3960 e1
L_3961:  LXI  B,0009h             ; 3961 01 09 00
L_3964:  DAD  B                   ; 3964 09
L_3965:  MVI  A,2Eh               ; 3965 3e 2e
L_3967:  STAX D                   ; 3967 12
L_3968:  INX  D                   ; 3968 13
L_3969:  MVI  C,03h               ; 3969 0e 03
L_396B:  RST  5                   ; 396B ef
L_396C:  LDA  0A859h              ; 396C 3a 59 a8
L_396F:  ADI  04h                 ; 396F c6 04
L_3971:  STA  0A859h              ; 3971 32 59 a8
L_3974:  POP  H                   ; 3974 e1
L_3975:  SHLD 0A842h              ; 3975 22 42 a8
L_3978:  RET                      ; 3978 c9
L_3979:  MVI  C,0Ch               ; 3979 0e 0c
L_397B:  RST  5                   ; 397B ef
L_397C:  RET                      ; 397C c9
         .db 21h,48h,3Eh                                      ; 397D |!H>|
L_3980:  LXI  D,0B663h            ; 3980 11 63 b6
L_3983:  CALL L_3979              ; 3983 cd 79 39
L_3986:  CALL L_1038              ; 3986 cd 38 10
L_3989:  LDA  0B68Dh              ; 3989 3a 8d b6
L_398C:  DCR  A                   ; 398C 3d
L_398D:  RZ                       ; 398D c8
         LDA  0A801h              ; 398E 3a 01 a8
         ANI  40h                 ; 3991 e6 40
         JZ   L_399C              ; 3993 ca 9c 39
         CALL L_393A              ; 3996 cd 3a 39
         JMP  L_2CBF              ; 3999 c3 bf 2c
L_399C:  LXI  H,0DF14h            ; 399C 21 14 df
         MVI  M,08h               ; 399F 36 08
         PUSH H                   ; 39A1 e5
         INX  H                   ; 39A2 23
         LDA  0B673h              ; 39A3 3a 73 b6
         MOV  M,A                 ; 39A6 77
         INX  H                   ; 39A7 23
         MVI  M,3Ah               ; 39A8 36 3a
         INX  H                   ; 39AA 23
         LXI  D,0B663h            ; 39AB 11 63 b6
         XCHG                     ; 39AE eb
         MVI  C,06h               ; 39AF 0e 06
         RST  5                   ; 39B1 ef
         POP  H                   ; 39B2 e1
         CALL L_13C6              ; 39B3 cd c6 13
         XRA  A                   ; 39B6 af
         STA  0A802h              ; 39B7 32 02 a8
         JMP  L_0772              ; 39BA c3 72 07
L_39BD:  LXI  H,3E60h             ; 39BD 21 60 3e
L_39C0:  JMP  L_3980              ; 39C0 c3 80 39
L_39C3:  LXI  H,3E54h             ; 39C3 21 54 3e
L_39C6:  JMP  L_3980              ; 39C6 c3 80 39
L_39C9:  CALL L_347D              ; 39C9 cd 7d 34
L_39CC:  CALL L_3451              ; 39CC cd 51 34
L_39CF:  LXI  H,3531h             ; 39CF 21 31 35
L_39D2:  RST  3                   ; 39D2 df
L_39D3:  LXI  H,3E6Ch             ; 39D3 21 6c 3e
L_39D6:  RST  3                   ; 39D6 df
L_39D7:  LXI  H,0B728h            ; 39D7 21 28 b7
L_39DA:  MVI  A,2Eh               ; 39DA 3e 2e
L_39DC:  MVI  M,00h               ; 39DC 36 00
L_39DE:  INX  H                   ; 39DE 23
L_39DF:  DCR  A                   ; 39DF 3d
L_39E0:  JNZ  L_39DC              ; 39E0 c2 dc 39
L_39E3:  MVI  E,00h               ; 39E3 1e 00
L_39E5:  CALL L_13D7              ; 39E5 cd d7 13
L_39E8:  CALL L_3BD6              ; 39E8 cd d6 3b
L_39EB:  LXI  H,0B728h            ; 39EB 21 28 b7
L_39EE:  DCX  H                   ; 39EE 2b
L_39EF:  PUSH H                   ; 39EF e5
L_39F0:  CALL L_3BA0              ; 39F0 cd a0 3b
L_39F3:  LDA  0B6A9h              ; 39F3 3a a9 b6
L_39F6:  CPI  29h                 ; 39F6 fe 29
L_39F8:  JNZ  L_3A24              ; 39F8 c2 24 3a
L_39FB:  LXI  H,0B6A7h            ; 39FB 21 a7 b6
L_39FE:  LDA  0B6A7h              ; 39FE 3a a7 b6
L_3A01:  CPI  28h                 ; 3A01 fe 28
L_3A03:  JC   L_3A0B              ; 3A03 da 0b 3a
L_3A06:  MVI  A,28h               ; 3A06 3e 28
L_3A08:  STA  0B6A7h              ; 3A08 32 a7 b6
L_3A0B:  CALL L_3471              ; 3A0B cd 71 34
L_3A0E:  LXI  H,0B6A7h            ; 3A0E 21 a7 b6
L_3A11:  CALL L_0F6B              ; 3A11 cd 6b 0f
L_3A14:  LDA  0B6A8h              ; 3A14 3a a8 b6
L_3A17:  CPI  30h                 ; 3A17 fe 30
L_3A19:  JZ   L_3A2A              ; 3A19 ca 2a 3a
L_3A1C:  POP  H                   ; 3A1C e1
L_3A1D:  INX  H                   ; 3A1D 23
L_3A1E:  MOV  M,A                 ; 3A1E 77
L_3A1F:  INX  H                   ; 3A1F 23
L_3A20:  PUSH H                   ; 3A20 e5
L_3A21:  JMP  L_39F0              ; 3A21 c3 f0 39
L_3A24:  POP  H                   ; 3A24 e1
L_3A25:  INR  M                   ; 3A25 34
L_3A26:  PUSH H                   ; 3A26 e5
L_3A27:  JMP  L_39F0              ; 3A27 c3 f0 39
L_3A2A:  POP  H                   ; 3A2A e1
L_3A2B:  CALL L_13D3              ; 3A2B cd d3 13
L_3A2E:  CALL L_0FF3              ; 3A2E cd f3 0f
L_3A31:  CALL L_0D44              ; 3A31 cd 44 0d
L_3A34:  CPI  30h                 ; 3A34 fe 30
L_3A36:  JZ   L_0415              ; 3A36 ca 15 04
L_3A39:  CPI  1Bh                 ; 3A39 fe 1b
L_3A3B:  JZ   L_0415              ; 3A3B ca 15 04
L_3A3E:  PUSH PSW                 ; 3A3E f5
L_3A3F:  CALL L_0492              ; 3A3F cd 92 04
L_3A42:  POP  PSW                 ; 3A42 f1
L_3A43:  LXI  H,0B728h            ; 3A43 21 28 b7
L_3A46:  MVI  C,1Ah               ; 3A46 0e 1a
L_3A48:  CMP  M                   ; 3A48 be
L_3A49:  JZ   L_3A55              ; 3A49 ca 55 3a
L_3A4C:  INX  H                   ; 3A4C 23
L_3A4D:  INX  H                   ; 3A4D 23
L_3A4E:  DCR  C                   ; 3A4E 0d
L_3A4F:  JNZ  L_3A48              ; 3A4F c2 48 3a
L_3A52:  JMP  L_3A2E              ; 3A52 c3 2e 3a
L_3A55:  PUSH H                   ; 3A55 e5
         LXI  H,0A000h            ; 3A56 21 00 a0
         SHLD 0A83Eh              ; 3A59 22 3e a8
         POP  H                   ; 3A5C e1
L_3A5D:  PUSH H                   ; 3A5D e5
         CALL L_3BA0              ; 3A5E cd a0 3b
         LXI  H,0B6A9h            ; 3A61 21 a9 b6
         MVI  A,29h               ; 3A64 3e 29
         CMP  M                   ; 3A66 be
         DCX  H                   ; 3A67 2b
         MOV  A,M                 ; 3A68 7e
         POP  H                   ; 3A69 e1
         JNZ  L_3A5D              ; 3A6A c2 5d 3a
         CMP  M                   ; 3A6D be
         JNZ  L_3A5D              ; 3A6E c2 5d 3a
         INX  H                   ; 3A71 23
         MOV  A,M                 ; 3A72 7e
         CPI  01h                 ; 3A73 fe 01
         JZ   L_2CF0              ; 3A75 ca f0 2c
         JMP  L_2C9E              ; 3A78 c3 9e 2c
L_3A7B:  LDA  0B6ABh              ; 3A7B 3a ab b6
L_3A7E:  CPI  3Ah                 ; 3A7E fe 3a
L_3A80:  JZ   L_200F              ; 3A80 ca 0f 20
         CALL L_1009              ; 3A83 cd 09 10
         LXI  H,3E15h             ; 3A86 21 15 3e
         RST  3                   ; 3A89 df
         MVI  C,0Fh               ; 3A8A 0e 0f
         LDA  0B6ABh              ; 3A8C 3a ab b6
         CPI  4Bh                 ; 3A8F fe 4b
         JZ   L_3AA4              ; 3A91 ca a4 3a
         CPI  4Ch                 ; 3A94 fe 4c
         JZ   L_3AA0              ; 3A96 ca a0 3a
         CPI  52h                 ; 3A99 fe 52
         JNZ  L_3AA1              ; 3A9B c2 a1 3a
         MVI  C,0Eh               ; 3A9E 0e 0e
L_3AA0:  RST  4                   ; 3AA0 e7
L_3AA1:  JMP  L_2026              ; 3AA1 c3 26 20
L_3AA4:  LXI  H,3E12h             ; 3AA4 21 12 3e
         RST  3                   ; 3AA7 df
         JMP  L_2026              ; 3AA8 c3 26 20
L_3AAB:  MVI  E,00h               ; 3AAB 1e 00
L_3AAD:  CALL L_13D7              ; 3AAD cd d7 13
L_3AB0:  CALL L_3AC4              ; 3AB0 cd c4 3a
L_3AB3:  PUSH PSW                 ; 3AB3 f5
L_3AB4:  CALL L_13D3              ; 3AB4 cd d3 13
L_3AB7:  POP  PSW                 ; 3AB7 f1
L_3AB8:  RZ                       ; 3AB8 c8
L_3AB9:  CALL L_03DE              ; 3AB9 cd de 03
L_3ABC:  JMP  L_39C9              ; 3ABC c3 c9 39
         .db 0Eh,08h,0C3h,0D2h,3Ah                            ; 3ABF |....:|
L_3AC4:  MVI  C,0Ch               ; 3AC4 0e 0c
L_3AC6:  CALL L_3AD2              ; 3AC6 cd d2 3a
L_3AC9:  CALL L_1038              ; 3AC9 cd 38 10
L_3ACC:  LDA  0B68Dh              ; 3ACC 3a 8d b6
L_3ACF:  CPI  01h                 ; 3ACF fe 01
L_3AD1:  RET                      ; 3AD1 c9
L_3AD2:  LXI  H,3E24h             ; 3AD2 21 24 3e
L_3AD5:  LXI  D,0B663h            ; 3AD5 11 63 b6
L_3AD8:  RST  5                   ; 3AD8 ef
L_3AD9:  RET                      ; 3AD9 c9
L_3ADA:  LXI  H,0A943h            ; 3ADA 21 43 a9
L_3ADD:  CALL L_0E4D              ; 3ADD cd 4d 0e
L_3AE0:  MOV  L,M                 ; 3AE0 6e
L_3AE1:  MVI  H,00h               ; 3AE1 26 00
L_3AE3:  SHLD 0A934h              ; 3AE3 22 34 a9
L_3AE6:  LXI  D,0301h             ; 3AE6 11 01 03
L_3AE9:  LXI  H,3DFDh             ; 3AE9 21 fd 3d
L_3AEC:  CALL L_0CF1              ; 3AEC cd f1 0c
L_3AEF:  LXI  H,0B68Dh            ; 3AEF 21 8d b6
L_3AF2:  MVI  M,00h               ; 3AF2 36 00
L_3AF4:  STA  0A936h              ; 3AF4 32 36 a9
L_3AF7:  CPI  1Bh                 ; 3AF7 fe 1b
L_3AF9:  CNZ  L_29AC              ; 3AF9 c4 ac 29
L_3AFC:  JMP  L_0FE0              ; 3AFC c3 e0 0f
L_3AFF:  LXI  H,3DDCh             ; 3AFF 21 dc 3d
         RST  3                   ; 3B02 df
         JMP  L_0D44              ; 3B03 c3 44 0d
L_3B06:  CALL L_0FE0              ; 3B06 cd e0 0f
         LXI  H,0A859h            ; 3B09 21 59 a8
         MOV  C,M                 ; 3B0C 4e
         MVI  B,0Dh               ; 3B0D 06 0d
         LXI  D,3DBAh             ; 3B0F 11 ba 3d
         INX  H                   ; 3B12 23
L_3B13:  MOV  A,M                 ; 3B13 7e
         STAX D                   ; 3B14 12
         INX  H                   ; 3B15 23
         INX  D                   ; 3B16 13
         DCR  B                   ; 3B17 05
         DCR  C                   ; 3B18 0d
         JNZ  L_3B13              ; 3B19 c2 13 3b
         MVI  A,20h               ; 3B1C 3e 20
L_3B1E:  STAX D                   ; 3B1E 12
         INX  D                   ; 3B1F 13
         DCR  B                   ; 3B20 05
         JNZ  L_3B1E              ; 3B21 c2 1e 3b
         LXI  D,0601h             ; 3B24 11 01 06
         LXI  H,3DB5h             ; 3B27 21 b5 3d
         CALL L_0CF1              ; 3B2A cd f1 0c
         LXI  H,0001h             ; 3B2D 21 01 00
         SHLD 0B68Dh              ; 3B30 22 8d b6
         CPI  1Bh                 ; 3B33 fe 1b
         RZ                       ; 3B35 c8
         ADD  A                   ; 3B36 87
         ADD  A                   ; 3B37 87
         MOV  E,A                 ; 3B38 5f
         MVI  D,00h               ; 3B39 16 00
         LXI  H,3DC4h             ; 3B3B 21 c4 3d
         DAD  D                   ; 3B3E 19
         LXI  D,0B6A4h            ; 3B3F 11 a4 b6
         MVI  C,03h               ; 3B42 0e 03
         RST  5                   ; 3B44 ef
         LXI  H,3DB0h             ; 3B45 21 b0 3d
         LXI  D,0B69Fh            ; 3B48 11 9f b6
         MVI  C,05h               ; 3B4B 0e 05
         RST  5                   ; 3B4D ef
         JMP  L_391E              ; 3B4E c3 1e 39
         .db 21h,63h,0B6h,11h,09h,00h,19h,0E5h,0D5h,0CDh,0DFh,29h,0D1h,19h,0D1h,0D5h ; 3B51 |!c.........)....|
         .db 0Eh,03h,0EFh,0CDh,0B9h,0Fh,0D1h,21h,0A4h,3Dh,06h,04h,0E5h,0D5h,0Eh,03h ; 3B61 |.......!.=......|
         .db 0CDh,1Ah,38h,0CAh,83h,3Bh,0D1h,0E1h,23h,23h,23h,05h,0C2h,6Dh,3Bh,0C3h ; 3B71 |..8..;..###..m;.|
         .db 06h,3Bh,0D1h,11h,9Fh,0B6h,3Eh,07h,12h,13h,21h,0B1h,3Dh,0Eh,04h,0EFh ; 3B81 |.;....>...!.=...|
         .db 0E1h,0Eh,03h,79h,0B8h,0C2h,9Ch,3Bh,21h,0CCh,3Dh,0EFh,0C3h,1Eh,39h ; 3B91 |...y...;!.=...9|
L_3BA0:  LHLD 0A83Eh              ; 3BA0 2a 3e a8
L_3BA3:  XCHG                     ; 3BA3 eb
L_3BA4:  LXI  H,0B6A7h            ; 3BA4 21 a7 b6
L_3BA7:  INX  H                   ; 3BA7 23
L_3BA8:  MVI  C,00h               ; 3BA8 0e 00
L_3BAA:  MVI  B,80h               ; 3BAA 06 80
L_3BAC:  LDAX D                   ; 3BAC 1a
L_3BAD:  CPI  0Dh                 ; 3BAD fe 0d
L_3BAF:  JZ   L_3BC2              ; 3BAF ca c2 3b
L_3BB2:  MOV  M,A                 ; 3BB2 77
L_3BB3:  INR  C                   ; 3BB3 0c
L_3BB4:  INX  D                   ; 3BB4 13
L_3BB5:  INX  H                   ; 3BB5 23
L_3BB6:  DCR  B                   ; 3BB6 05
L_3BB7:  JNZ  L_3BAC              ; 3BB7 c2 ac 3b
L_3BBA:  LDAX D                   ; 3BBA 1a
         CPI  00h                 ; 3BBB fe 00
         INX  D                   ; 3BBD 13
         JNZ  L_3BBA              ; 3BBE c2 ba 3b
         DCX  D                   ; 3BC1 1b
L_3BC2:  XCHG                     ; 3BC2 eb
L_3BC3:  INX  H                   ; 3BC3 23
L_3BC4:  INX  H                   ; 3BC4 23
L_3BC5:  SHLD 0A83Eh              ; 3BC5 22 3e a8
L_3BC8:  LXI  H,0B6A7h            ; 3BC8 21 a7 b6
L_3BCB:  MOV  M,C                 ; 3BCB 71
L_3BCC:  RET                      ; 3BCC c9
L_3BCD:  LXI  H,3E18h             ; 3BCD 21 18 3e
L_3BD0:  SHLD 0A842h              ; 3BD0 22 42 a8
L_3BD3:  JMP  L_158A              ; 3BD3 c3 8a 15
L_3BD6:  LXI  H,3E24h             ; 3BD6 21 24 3e
L_3BD9:  JMP  L_3BD0              ; 3BD9 c3 d0 3b
L_3BDC:  LXI  H,3E30h             ; 3BDC 21 30 3e
L_3BDF:  JMP  L_3BD0              ; 3BDF c3 d0 3b
L_3BE2:  LXI  H,9100h             ; 3BE2 21 00 91
         SHLD 0A940h              ; 3BE5 22 40 a9
         RET                      ; 3BE8 c9
L_3BE9:  LHLD 0A940h              ; 3BE9 2a 40 a9
         XCHG                     ; 3BEC eb
         LXI  H,0B6A7h            ; 3BED 21 a7 b6
         MOV  C,M                 ; 3BF0 4e
         INX  H                   ; 3BF1 23
L_3BF2:  MOV  A,M                 ; 3BF2 7e
         STAX D                   ; 3BF3 12
         INX  H                   ; 3BF4 23
         INX  D                   ; 3BF5 13
         DCR  C                   ; 3BF6 0d
         JNZ  L_3BF2              ; 3BF7 c2 f2 3b
         MVI  A,0Dh               ; 3BFA 3e 0d
         STAX D                   ; 3BFC 12
         INX  D                   ; 3BFD 13
         MVI  A,0Ah               ; 3BFE 3e 0a
         STAX D                   ; 3C00 12
         INX  D                   ; 3C01 13
         XCHG                     ; 3C02 eb
         SHLD 0A940h              ; 3C03 22 40 a9
         RET                      ; 3C06 c9
L_3C07:  LHLD 0A940h              ; 3C07 2a 40 a9
         MVI  M,1Ah               ; 3C0A 36 1a
         MVI  A,43h               ; 3C0C 3e 43
         STA  0B673h              ; 3C0E 32 73 b6
         LXI  H,3E3Ch             ; 3C11 21 3c 3e
         SHLD 0A842h              ; 3C14 22 42 a8
         CALL L_19B8              ; 3C17 cd b8 19
         MVI  C,13h               ; 3C1A 0e 13
         CALL L_3C39              ; 3C1C cd 39 3c
         MVI  C,16h               ; 3C1F 0e 16
         CALL L_3C39              ; 3C21 cd 39 3c
         MVI  C,0Fh               ; 3C24 0e 0f
         CALL L_3C39              ; 3C26 cd 39 3c
         LHLD 0A940h              ; 3C29 2a 40 a9
         LXI  D,6F00h             ; 3C2C 11 00 6f
         DAD  D                   ; 3C2F 19
         DAD  H                   ; 3C30 29
         MOV  C,H                 ; 3C31 4c
         INR  C                   ; 3C32 0c
         LXI  D,9100h             ; 3C33 11 00 91
         JMP  L_145E              ; 3C36 c3 5e 14
L_3C39:  LXI  D,005Ch             ; 3C39 11 5c 00
         RST  1                   ; 3C3C cf
         RET                      ; 3C3D c9
L_3C3E:  LXI  H,3E18h             ; 3C3E 21 18 3e
L_3C41:  MVI  C,0Eh               ; 3C41 0e 0e
L_3C43:  CALL L_3AD5              ; 3C43 cd d5 3a
L_3C46:  MVI  E,00h               ; 3C46 1e 00
L_3C48:  CALL L_13D7              ; 3C48 cd d7 13
L_3C4B:  CALL L_1038              ; 3C4B cd 38 10
L_3C4E:  CALL L_13D3              ; 3C4E cd d3 13
L_3C51:  LDA  0B68Dh              ; 3C51 3a 8d b6
L_3C54:  CPI  01h                 ; 3C54 fe 01
L_3C56:  RZ                       ; 3C56 c8
L_3C57:  CALL L_29DF              ; 3C57 cd df 29
L_3C5A:  LXI  D,0B663h            ; 3C5A 11 63 b6
L_3C5D:  CALL L_3979              ; 3C5D cd 79 39
L_3C60:  MVI  E,00h               ; 3C60 1e 00
L_3C62:  CALL L_13D7              ; 3C62 cd d7 13
L_3C65:  CALL L_3BCD              ; 3C65 cd cd 3b
L_3C68:  CALL L_13D3              ; 3C68 cd d3 13
L_3C6B:  LDA  0A801h              ; 3C6B 3a 01 a8
L_3C6E:  ANI  60h                 ; 3C6E e6 60
L_3C70:  RLC                      ; 3C70 07
L_3C71:  RLC                      ; 3C71 07
L_3C72:  RLC                      ; 3C72 07
L_3C73:  STA  0B73Ch              ; 3C73 32 3c b7
L_3C76:  CALL L_3BA0              ; 3C76 cd a0 3b
L_3C79:  LXI  H,0B654h            ; 3C79 21 54 b6
L_3C7C:  LXI  D,0009h             ; 3C7C 11 09 00
L_3C7F:  DAD  D                   ; 3C7F 19
L_3C80:  XCHG                     ; 3C80 eb
L_3C81:  LXI  H,0B6A7h            ; 3C81 21 a7 b6
L_3C84:  INX  H                   ; 3C84 23
L_3C85:  MVI  C,03h               ; 3C85 0e 03
L_3C87:  RST  5                   ; 3C87 ef
L_3C88:  LXI  H,0B6A7h            ; 3C88 21 a7 b6
L_3C8B:  INX  H                   ; 3C8B 23
L_3C8C:  MOV  A,M                 ; 3C8C 7e
L_3C8D:  CPI  2Eh                 ; 3C8D fe 2e
L_3C8F:  RZ                       ; 3C8F c8
L_3C90:  CALL L_3D0C              ; 3C90 cd 0c 3d
L_3C93:  JNZ  L_3C76              ; 3C93 c2 76 3c
L_3C96:  LDA  0B73Ch              ; 3C96 3a 3c b7
L_3C99:  CPI  03h                 ; 3C99 fe 03
L_3C9B:  JZ   L_3CA5              ; 3C9B ca a5 3c
         INR  A                   ; 3C9E 3c
         STA  0B73Ch              ; 3C9F 32 3c b7
         JMP  L_3C76              ; 3CA2 c3 76 3c
L_3CA5:  LXI  H,0B6A7h            ; 3CA5 21 a7 b6
L_3CA8:  LXI  D,0005h             ; 3CA8 11 05 00
L_3CAB:  DAD  D                   ; 3CAB 19
L_3CAC:  MOV  A,M                 ; 3CAC 7e
L_3CAD:  PUSH PSW                 ; 3CAD f5
L_3CAE:  PUSH H                   ; 3CAE e5
L_3CAF:  CALL L_3891              ; 3CAF cd 91 38
L_3CB2:  POP  H                   ; 3CB2 e1
L_3CB3:  POP  PSW                 ; 3CB3 f1
L_3CB4:  CPI  21h                 ; 3CB4 fe 21
L_3CB6:  JZ   L_3CCF              ; 3CB6 ca cf 3c
L_3CB9:  CPI  3Ch                 ; 3CB9 fe 3c
L_3CBB:  JZ   L_3CCF              ; 3CBB ca cf 3c
         CALL L_3CE6              ; 3CBE cd e6 3c
         LDA  0B68Dh              ; 3CC1 3a 8d b6
         CPI  01h                 ; 3CC4 fe 01
         RZ                       ; 3CC6 c8
         LDA  0B673h              ; 3CC7 3a 73 b6
         SUI  41h                 ; 3CCA d6 41
         STA  0004h               ; 3CCC 32 04 00
L_3CCF:  LXI  H,0B6A7h            ; 3CCF 21 a7 b6
L_3CD2:  LXI  D,0005h             ; 3CD2 11 05 00
L_3CD5:  DAD  D                   ; 3CD5 19
L_3CD6:  LXI  D,0DF15h            ; 3CD6 11 15 df
L_3CD9:  LDA  0B6A7h              ; 3CD9 3a a7 b6
L_3CDC:  SUI  04h                 ; 3CDC d6 04
L_3CDE:  STA  0DF14h              ; 3CDE 32 14 df
L_3CE1:  MOV  C,A                 ; 3CE1 4f
L_3CE2:  RST  5                   ; 3CE2 ef
L_3CE3:  JMP  L_3A7B              ; 3CE3 c3 7b 3a
L_3CE6:  LXI  D,0B663h            ; 3CE6 11 63 b6
         MVI  C,08h               ; 3CE9 0e 08
L_3CEB:  MOV  A,M                 ; 3CEB 7e
         CPI  20h                 ; 3CEC fe 20
         JZ   L_3CFB              ; 3CEE ca fb 3c
         STAX D                   ; 3CF1 12
         INX  H                   ; 3CF2 23
         INX  D                   ; 3CF3 13
         DCR  C                   ; 3CF4 0d
         JNZ  L_3CEB              ; 3CF5 c2 eb 3c
         JMP  L_3D01              ; 3CF8 c3 01 3d
L_3CFB:  STAX D                   ; 3CFB 12
         INX  D                   ; 3CFC 13
         DCR  C                   ; 3CFD 0d
         JNZ  L_3CFB              ; 3CFE c2 fb 3c
L_3D01:  INX  D                   ; 3D01 13
         LXI  H,3E69h             ; 3D02 21 69 3e
         MVI  C,03h               ; 3D05 0e 03
         RST  5                   ; 3D07 ef
         CALL L_1038              ; 3D08 cd 38 10
         RET                      ; 3D0B c9
L_3D0C:  LXI  B,0009h             ; 3D0C 01 09 00
L_3D0F:  LXI  H,0B654h            ; 3D0F 21 54 b6
L_3D12:  DAD  B                   ; 3D12 09
L_3D13:  XCHG                     ; 3D13 eb
L_3D14:  LXI  H,0B663h            ; 3D14 21 63 b6
L_3D17:  DAD  B                   ; 3D17 09
L_3D18:  MVI  C,03h               ; 3D18 0e 03
L_3D1A:  LDAX D                   ; 3D1A 1a
L_3D1B:  CMP  M                   ; 3D1B be
L_3D1C:  RNZ                      ; 3D1C c0
L_3D1D:  INX  H                   ; 3D1D 23
L_3D1E:  INX  D                   ; 3D1E 13
L_3D1F:  DCR  C                   ; 3D1F 0d
L_3D20:  JNZ  L_3D1A              ; 3D20 c2 1a 3d
L_3D23:  RET                      ; 3D23 c9
L_3D24:  CALL L_3BA0              ; 3D24 cd a0 3b
         LXI  H,0B6A7h            ; 3D27 21 a7 b6
         LXI  D,0002h             ; 3D2A 11 02 00
         DAD  D                   ; 3D2D 19
         MOV  A,M                 ; 3D2E 7e
         CPI  29h                 ; 3D2F fe 29
         JZ   L_3D63              ; 3D31 ca 63 3d
         XRA  A                   ; 3D34 af
         STA  0B68Dh              ; 3D35 32 8d b6
         CALL L_3891              ; 3D38 cd 91 38
         LXI  H,0B6A7h            ; 3D3B 21 a7 b6
         INX  H                   ; 3D3E 23
         MOV  A,M                 ; 3D3F 7e
         CPI  58h                 ; 3D40 fe 58
         RNZ                      ; 3D42 c0
         INX  H                   ; 3D43 23
         MOV  A,M                 ; 3D44 7e
         CPI  3Ah                 ; 3D45 fe 3a
         RNZ                      ; 3D47 c0
         LXI  H,0B6A7h            ; 3D48 21 a7 b6
         LXI  D,0003h             ; 3D4B 11 03 00
         DAD  D                   ; 3D4E 19
         CALL L_3CE6              ; 3D4F cd e6 3c
         LDA  0B68Dh              ; 3D52 3a 8d b6
         CPI  01h                 ; 3D55 fe 01
         JZ   L_0415              ; 3D57 ca 15 04
         LDA  0B673h              ; 3D5A 3a 73 b6
         LXI  H,0B6A7h            ; 3D5D 21 a7 b6
         INX  H                   ; 3D60 23
         MOV  M,A                 ; 3D61 77
         RET                      ; 3D62 c9
L_3D63:  MVI  A,02h               ; 3D63 3e 02
         STA  0B68Dh              ; 3D65 32 8d b6
         RET                      ; 3D68 c9
L_3D69:  LDA  0B69Bh              ; 3D69 3a 9b b6
L_3D6C:  PUSH PSW                 ; 3D6C f5
L_3D6D:  LXI  H,0A88Ah            ; 3D6D 21 8a a8
L_3D70:  CALL L_0E4D              ; 3D70 cd 4d 0e
L_3D73:  MOV  A,M                 ; 3D73 7e
L_3D74:  STA  3D8Ch               ; 3D74 32 8c 3d
L_3D77:  INR  A                   ; 3D77 3c
L_3D78:  STA  0B69Bh              ; 3D78 32 9b b6
L_3D7B:  CALL L_29DF              ; 3D7B cd df 29
L_3D7E:  POP  PSW                 ; 3D7E f1
L_3D7F:  STA  0B69Bh              ; 3D7F 32 9b b6
L_3D82:  LXI  D,0008h             ; 3D82 11 08 00
L_3D85:  DAD  D                   ; 3D85 19
L_3D86:  LXI  D,000Dh             ; 3D86 11 0d 00
L_3D89:  MVI  A,80h               ; 3D89 3e 80
L_3D8B:  SUI  00h                 ; 3D8B d6 00
L_3D8D:  MOV  C,A                 ; 3D8D 4f
L_3D8E:  MVI  B,20h               ; 3D8E 06 20
L_3D90:  MOV  A,M                 ; 3D90 7e
L_3D91:  CPI  7Fh                 ; 3D91 fe 7f
L_3D93:  JZ   L_3D98              ; 3D93 ca 98 3d
L_3D96:  MVI  B,7Fh               ; 3D96 06 7f
L_3D98:  MOV  M,B                 ; 3D98 70
L_3D99:  DAD  D                   ; 3D99 19
L_3D9A:  DCR  C                   ; 3D9A 0d
L_3D9B:  JNZ  L_3D8E              ; 3D9B c2 8e 3d
L_3D9E:  CALL L_11F1              ; 3D9E cd f1 11
L_3DA1:  JMP  L_090F              ; 3DA1 c3 0f 09
         .db 42h,41h,53h,43h,4Fh,4Dh,41h,53h,4Dh,4Dh,4Fh,4Eh,07h,53h,41h,56h ; 3DA4 |BASCOMASMMON.SAV|
         .db 45h,0E6h,0C1h,0CAh,0CCh,20h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h ; 3DB4 |E.... ..........|
         .db 00h,00h,00h,00h,44h,4Fh,53h,00h,52h,4Fh,4Dh,00h,42h,41h,53h,00h ; 3DC4 |....DOS.ROM.BAS.|
         .db 41h,53h,4Dh,00h,4Dh,4Fh,4Eh,00h,20h,0E4h,0CCh,0D1h,20h,0DAh,0C1h,0D0h ; 3DD4 |ASM.MON. ... ...|
         .db 0C9h,0D3h,0C9h,20h,0CEh,0C1h,0D6h,0CDh,0C9h,0D4h,0C5h,20h,0CCh,0C0h,0C2h,0D5h ; 3DE4 |... ....... ....|
         .db 0C0h,20h,0CBh,0CCh,0C1h,0D7h,0C9h,0DBh,0D5h,00h,0F0h,0CFh,20h,0D4h,0C9h,0D0h ; 3DF4 |. .......... ...|
         .db 0D5h,00h,0F3h,20h,0D5h,0CBh,0C1h,0DAh,0C1h,0CEh,0C9h,0C5h ; 3E04 |... ........|
L_3E10:  CALL 1B00h               ; 3E10 cd 00 1b
         MOV  E,E                 ; 3E13 5b
         NOP                      ; 3E14 00
         DCX  D                   ; 3E15 1b
         MOV  E,H                 ; 3E16 5c
         NOP                      ; 3E17 00
         MOV  B,E                 ; 3E18 43
         MOV  C,A                 ; 3E19 4f
         .db 20h                                              ; 3E1A DB   20h
         .db 20h                                              ; 3E1B DB   20h
         .db 20h                                              ; 3E1C DB   20h
         .db 20h                                              ; 3E1D DB   20h
         .db 20h                                              ; 3E1E DB   20h
         .db 20h                                              ; 3E1F DB   20h
         INX  B                   ; 3E20 03
         MOV  B,L                 ; 3E21 45
         MOV  E,B                 ; 3E22 58
         MOV  D,H                 ; 3E23 54
         MOV  B,E                 ; 3E24 43
         MOV  C,A                 ; 3E25 4f
         .db 20h                                              ; 3E26 DB   20h
         .db 20h                                              ; 3E27 DB   20h
         .db 20h                                              ; 3E28 DB   20h
         .db 20h                                              ; 3E29 DB   20h
         .db 20h                                              ; 3E2A DB   20h
         .db 20h                                              ; 3E2B DB   20h
         INX  B                   ; 3E2C 03
         MOV  C,L                 ; 3E2D 4d
         MOV  C,M                 ; 3E2E 4e
         MOV  D,L                 ; 3E2F 55
         MOV  B,E                 ; 3E30 43
         MOV  C,A                 ; 3E31 4f
         .db 20h                                              ; 3E32 DB   20h
         .db 20h                                              ; 3E33 DB   20h
         .db 20h                                              ; 3E34 DB   20h
         .db 20h                                              ; 3E35 DB   20h
         .db 20h                                              ; 3E36 DB   20h
         .db 20h                                              ; 3E37 DB   20h
         INX  B                   ; 3E38 03
         MOV  E,D                 ; 3E39 5a
         MOV  B,A                 ; 3E3A 47
         MOV  D,D                 ; 3E3B 52
         MOV  B,E                 ; 3E3C 43
         MOV  C,A                 ; 3E3D 4f
         .db 20h                                              ; 3E3E DB   20h
         .db 20h                                              ; 3E3F DB   20h
         .db 20h                                              ; 3E40 DB   20h
         .db 20h                                              ; 3E41 DB   20h
         .db 20h                                              ; 3E42 DB   20h
         .db 20h                                              ; 3E43 DB   20h
         INX  B                   ; 3E44 03
         MOV  D,H                 ; 3E45 54
         MOV  C,A                 ; 3E46 4f
         MOV  C,E                 ; 3E47 4b
         MOV  C,L                 ; 3E48 4d
         MOV  B,L                 ; 3E49 45
         MOV  B,H                 ; 3E4A 44
         MOV  C,C                 ; 3E4B 49
         MOV  D,H                 ; 3E4C 54
         .db 20h                                              ; 3E4D DB   20h
         .db 20h                                              ; 3E4E DB   20h
         .db 20h                                              ; 3E4F DB   20h
         .db 20h                                              ; 3E50 DB   20h
         MOV  B,E                 ; 3E51 43
         MOV  C,A                 ; 3E52 4f
         MOV  C,L                 ; 3E53 4d
         MOV  D,A                 ; 3E54 57
         MOV  D,E                 ; 3E55 53
         MOV  D,D                 ; 3E56 52
         .db 20h                                              ; 3E57 DB   20h
         .db 20h                                              ; 3E58 DB   20h
         .db 20h                                              ; 3E59 DB   20h
         .db 20h                                              ; 3E5A DB   20h
         .db 20h                                              ; 3E5B DB   20h
         .db 20h                                              ; 3E5C DB   20h
         MOV  B,E                 ; 3E5D 43
         MOV  C,A                 ; 3E5E 4f
         MOV  C,L                 ; 3E5F 4d
         MOV  D,E                 ; 3E60 53
         MOV  C,C                 ; 3E61 49
         MOV  B,H                 ; 3E62 44
         .db 20h                                              ; 3E63 DB   20h
         .db 20h                                              ; 3E64 DB   20h
         .db 20h                                              ; 3E65 DB   20h
         .db 20h                                              ; 3E66 DB   20h
         .db 20h                                              ; 3E67 DB   20h
         .db 20h                                              ; 3E68 DB   20h
         MOV  B,E                 ; 3E69 43
         MOV  C,A                 ; 3E6A 4f
         MOV  C,L                 ; 3E6B 4d
         DAD  B                   ; 3E6C 09
         .db 20h                                              ; 3E6D DB   20h
         .db 20h                                              ; 3E6E DB   20h
         .db 20h                                              ; 3E6F DB   20h
         .db 20h                                              ; 3E70 DB   20h
         .db 0EDh,0C5h,0CEh                                   ; 3E71 CALL @
         RNZ                      ; 3E74 c0
         .db 20h                                              ; 3E75 DB   20h
         RNC                      ; 3E76 d0
         RST  1                   ; 3E77 cf
         CZ   0DAD8h              ; 3E78 cc d8 da
         RST  1                   ; 3E7B cf
         RST  2                   ; 3E7C d7
         POP  B                   ; 3E7D c1
         CNC  0CCC5h              ; 3E7E d4 c5 cc
         POP  D                   ; 3E81 d1
         DAD  B                   ; 3E82 09
         DAD  B                   ; 3E83 09
         NOP                      ; 3E84 00
         .db 20h                                              ; 3E85 DB   20h
         LXI  SP,3230h            ; 3E86 31 30 32
         MOV  B,D                 ; 3E89 42
         MOV  B,C                 ; 3E8A 41
         MOV  C,E                 ; 3E8B 4b
         INX  B                   ; 3E8C 03
         MOV  C,E                 ; 3E8D 4b
         DCR  L                   ; 3E8E 2d
L_3E8F:  .db 38h                                              ; 3E8F DB   38h
L_3E90:  MOV  C,M                 ; 3E90 4e
L_3E91:  MOV  B,E                 ; 3E91 43
L_3E92:  MOV  B,C                 ; 3E92 41
         MOV  D,B                 ; 3E93 50
         MOV  C,E                 ; 3E94 4b
         LXI  D,5910h             ; 3E95 11 10 59
L_3E98:  LDA  0DF15h              ; 3E98 3a 15 df
L_3E9B:  CPI  43h                 ; 3E9B fe 43
L_3E9D:  JZ   L_3F2E              ; 3E9D ca 2e 3f
L_3EA0:  STA  0B673h              ; 3EA0 32 73 b6
L_3EA3:  STA  0A84Ah              ; 3EA3 32 4a a8
L_3EA6:  CALL L_0B6B              ; 3EA6 cd 6b 0b
L_3EA9:  SUI  41h                 ; 3EA9 d6 41
L_3EAB:  STA  0004h               ; 3EAB 32 04 00
L_3EAE:  LXI  H,3FB8h             ; 3EAE 21 b8 3f
L_3EB1:  MVI  B,67h               ; 3EB1 06 67
L_3EB3:  MOV  A,M                 ; 3EB3 7e
L_3EB4:  CMA                      ; 3EB4 2f
L_3EB5:  MOV  C,A                 ; 3EB5 4f
L_3EB6:  RST  4                   ; 3EB6 e7
L_3EB7:  INX  H                   ; 3EB7 23
L_3EB8:  DCR  B                   ; 3EB8 05
L_3EB9:  JNZ  L_3EB3              ; 3EB9 c2 b3 3e
L_3EBC:  LXI  H,3E30h             ; 3EBC 21 30 3e
L_3EBF:  MVI  C,0Ch               ; 3EBF 0e 0c
L_3EC1:  CALL L_3AD5              ; 3EC1 cd d5 3a
L_3EC4:  MVI  A,02h               ; 3EC4 3e 02
L_3EC6:  STA  0B69Dh              ; 3EC6 32 9d b6
L_3EC9:  MVI  A,01h               ; 3EC9 3e 01
L_3ECB:  STA  0B68Dh              ; 3ECB 32 8d b6
L_3ECE:  CALL L_12A7              ; 3ECE cd a7 12
L_3ED1:  LDA  0B68Dh              ; 3ED1 3a 8d b6
L_3ED4:  DCR  A                   ; 3ED4 3d
L_3ED5:  JZ   L_3F2E              ; 3ED5 ca 2e 3f
L_3ED8:  CALL L_3BDC              ; 3ED8 cd dc 3b
L_3EDB:  XRA  A                   ; 3EDB af
L_3EDC:  STA  0B69Bh              ; 3EDC 32 9b b6
L_3EDF:  CALL L_3BA0              ; 3EDF cd a0 3b
L_3EE2:  LXI  H,0B69Bh            ; 3EE2 21 9b b6
L_3EE5:  INR  M                   ; 3EE5 34
L_3EE6:  CALL L_29DF              ; 3EE6 cd df 29
L_3EE9:  XCHG                     ; 3EE9 eb
L_3EEA:  LXI  H,0B6A8h            ; 3EEA 21 a8 b6
L_3EED:  MVI  C,08h               ; 3EED 0e 08
L_3EEF:  MOV  A,M                 ; 3EEF 7e
L_3EF0:  CPI  2Eh                 ; 3EF0 fe 2e
L_3EF2:  JZ   L_3FA4              ; 3EF2 ca a4 3f
L_3EF5:  STAX D                   ; 3EF5 12
L_3EF6:  INX  H                   ; 3EF6 23
L_3EF7:  INX  D                   ; 3EF7 13
L_3EF8:  DCR  C                   ; 3EF8 0d
L_3EF9:  JNZ  L_3EEF              ; 3EF9 c2 ef 3e
L_3EFC:  INX  H                   ; 3EFC 23
L_3EFD:  INX  D                   ; 3EFD 13
L_3EFE:  MVI  C,03h               ; 3EFE 0e 03
L_3F00:  RST  5                   ; 3F00 ef
L_3F01:  LDA  0B6A8h              ; 3F01 3a a8 b6
L_3F04:  CPI  2Eh                 ; 3F04 fe 2e
L_3F06:  JNZ  L_3EDF              ; 3F06 c2 df 3e
L_3F09:  MVI  A,43h               ; 3F09 3e 43
L_3F0B:  STA  0A849h              ; 3F0B 32 49 a8
L_3F0E:  CALL L_0B5C              ; 3F0E cd 5c 0b
L_3F11:  CALL L_1E7C              ; 3F11 cd 7c 1e
L_3F14:  LXI  H,0B69Bh            ; 3F14 21 9b b6
L_3F17:  DCR  M                   ; 3F17 35
L_3F18:  CALL L_29DF              ; 3F18 cd df 29
L_3F1B:  SHLD 0A84Fh              ; 3F1B 22 4f a8
L_3F1E:  SHLD 0A84Dh              ; 3F1E 22 4d a8
L_3F21:  CALL L_159A              ; 3F21 cd 9a 15
L_3F24:  LXI  H,0B69Bh            ; 3F24 21 9b b6
L_3F27:  DCR  M                   ; 3F27 35
L_3F28:  JNZ  L_3F18              ; 3F28 c2 18 3f
         MVI  C,0Dh               ; 3F2B 0e 0d
         RST  1                   ; 3F2D cf
L_3F2E:  LXI  H,0B681h            ; 3F2E 21 81 b6
L_3F31:  MVI  C,04h               ; 3F31 0e 04
L_3F33:  XRA  A                   ; 3F33 af
L_3F34:  CALL L_1E75              ; 3F34 cd 75 1e
L_3F37:  LDA  0DE80h              ; 3F37 3a 80 de
L_3F3A:  ANA  A                   ; 3F3A a7
L_3F3B:  JNZ  L_3F47              ; 3F3B c2 47 3f
         LXI  H,4101h             ; 3F3E 21 01 41
         SHLD 0DF14h              ; 3F41 22 14 df
         JMP  L_2026              ; 3F44 c3 26 20
L_3F47:  CALL L_14AA              ; 3F47 cd aa 14
L_3F4A:  MVI  A,01h               ; 3F4A 3e 01
L_3F4C:  STA  0B69Bh              ; 3F4C 32 9b b6
L_3F4F:  STA  0A94Dh              ; 3F4F 32 4d a9
L_3F52:  MVI  C,0Eh               ; 3F52 0e 0e
L_3F54:  LXI  D,0002h             ; 3F54 11 02 00
L_3F57:  RST  1                   ; 3F57 cf
L_3F58:  CALL L_03DE              ; 3F58 cd de 03
L_3F5B:  LXI  H,404Eh             ; 3F5B 21 4e 40
L_3F5E:  MVI  B,04h               ; 3F5E 06 04
L_3F60:  RST  3                   ; 3F60 df
L_3F61:  INX  H                   ; 3F61 23
L_3F62:  MVI  A,26h               ; 3F62 3e 26
L_3F64:  CALL L_0F7F              ; 3F64 cd 7f 0f
L_3F67:  DCR  B                   ; 3F67 05
L_3F68:  JNZ  L_3F60              ; 3F68 c2 60 3f
L_3F6B:  RST  3                   ; 3F6B df
L_3F6C:  LXI  H,3E8Ch             ; 3F6C 21 8c 3e
L_3F6F:  CALL L_0F6B              ; 3F6F cd 6b 0f
L_3F72:  MVI  A,01h               ; 3F72 3e 01
L_3F74:  STA  0B69Dh              ; 3F74 32 9d b6
L_3F77:  CALL L_091B              ; 3F77 cd 1b 09
L_3F7A:  MVI  A,02h               ; 3F7A 3e 02
L_3F7C:  STA  0B69Dh              ; 3F7C 32 9d b6
L_3F7F:  STA  0B68Fh              ; 3F7F 32 8f b6
L_3F82:  CALL L_091B              ; 3F82 cd 1b 09
L_3F85:  STA  0B68Fh              ; 3F85 32 8f b6
L_3F88:  CALL L_0F9A              ; 3F88 cd 9a 0f
L_3F8B:  LDA  0A94Eh              ; 3F8B 3a 4e a9
L_3F8E:  STA  0B69Dh              ; 3F8E 32 9d b6
L_3F91:  CALL L_0C7E              ; 3F91 cd 7e 0c
L_3F94:  CALL L_0CD9              ; 3F94 cd d9 0c
L_3F97:  LXI  H,0A887h            ; 3F97 21 87 a8
L_3F9A:  CALL L_0E4D              ; 3F9A cd 4d 0e
L_3F9D:  MOV  A,M                 ; 3F9D 7e
L_3F9E:  STA  0A889h              ; 3F9E 32 89 a8
L_3FA1:  JMP  L_030F              ; 3FA1 c3 0f 03
L_3FA4:  MVI  A,20h               ; 3FA4 3e 20
L_3FA6:  STAX D                   ; 3FA6 12
L_3FA7:  INX  D                   ; 3FA7 13
L_3FA8:  DCR  C                   ; 3FA8 0d
L_3FA9:  JNZ  L_3FA6              ; 3FA9 c2 a6 3f
L_3FAC:  JMP  L_3EFC              ; 3FAC c3 fc 3e
L_3FAF:  RZ                       ; 3FAF c8
L_3FB0:  MOV  A,M                 ; 3FB0 7e
L_3FB1:  STAX D                   ; 3FB1 12
L_3FB2:  INX  H                   ; 3FB2 23
L_3FB3:  INX  D                   ; 3FB3 13
L_3FB4:  DCR  C                   ; 3FB4 0d
L_3FB5:  JMP  L_3FAF              ; 3FB5 c3 af 3f
         .db 0F2h,0F1h,88h,0BAh,0ADh,0ACh,0DFh,0CDh,0D1h,0CFh,0F2h,0F5h,97h,0BEh,0ADh,0A7h ; 3FB8 |................|
         .db 0B4h,0B0h,0A8h,0DFh,0CEh,0C6h,0C6h,0CCh,0F2h,0F5h,84h,0B6h,0A4h,0BEh,0ABh,0ACh ; 3FC8 |................|
L_3FD8:  ORA  H                   ; 3FD8 b4
         ORA  M                   ; 3FD9 b6
         ORA  L                   ; 3FDA b5
         RST  3                   ; 3FDB df
         ADC  H                   ; 3FDC 8c
         POP  D                   ; 3FDD d1
         SUB  D                   ; 3FDE 92
         POP  D                   ; 3FDF d1
         JP   9DF5h               ; 3FE0 f2 f5 9d
         XRA  D                   ; 3FE3 aa
         CMP  E                   ; 3FE4 bb
         XRA  D                   ; 3FE5 aa
         RST  3                   ; 3FE6 df
         CMP  L                   ; 3FE7 bd
         ORA  E                   ; 3FE8 b3
         CMP  M                   ; 3FE9 be
         CMP  B                   ; 3FEA b8
         ORA  B                   ; 3FEB b0
         CMP  E                   ; 3FEC bb
         CMP  M                   ; 3FED be
         XRA  L                   ; 3FEE ad
         CMP  D                   ; 3FEF ba
         ORA  C                   ; 3FF0 b1
         RST  3                   ; 3FF1 df
         ANA  L                   ; 3FF2 a5
         CMP  M                   ; 3FF3 be
         RST  3                   ; 3FF4 df
         ORA  B                   ; 3FF5 b0
         XRA  E                   ; 3FF6 ab
         ANA  L                   ; 3FF7 a5
         ANA  M                   ; 3FF8 a6
         XRA  B                   ; 3FF9 a8
         ANA  M                   ; 3FFA a6
         RST  3                   ; 3FFB df
         ORA  M                   ; 3FFC b6
         RST  3                   ; 3FFD df
         XRA  A                   ; 3FFE af
         ORA  B                   ; 3FFF b0
         XRA  C                   ; 4000 a9
         CMP  D                   ; 4001 ba
         ORA  E                   ; 4002 b3
         CMP  M                   ; 4003 be
         ORA  C                   ; 4004 b1
         ORA  M                   ; 4005 b6
         XRA  M                   ; 4006 ae
         JP   97F5h               ; 4007 f2 f5 97
         CMP  M                   ; 400A be
         XRA  L                   ; 400B ad
         ANA  A                   ; 400C a7
         ORA  H                   ; 400D b4
         ORA  B                   ; 400E b0
         XRA  B                   ; 400F a8
         RST  3                   ; 4010 df
         CMP  M                   ; 4011 be
         RNC                      ; 4012 d0
         XRA  M                   ; 4013 ae
         RST  3                   ; 4014 df
         ADI  0CAh                ; 4015 c6 ca
         ADI  0CCh                ; 4017 c6 cc
         JP   0F2F5h              ; 4019 f2 f5 f2
         PUSH PSW                 ; 401C f5
         CPO  L_21A4              ; 401D e4 a4 21
         MOV  A,C                 ; 4020 79
         RST  3                   ; 4021 df
         SHLD 0C05Dh              ; 4022 22 5d c0
         LXI  H,0E176h            ; 4025 21 76 e1
         SHLD 0DA32h              ; 4028 22 32 da
         MVI  A,31h               ; 402B 3e 31
         STA  0DA31h              ; 402D 32 31 da
         JMP  0DA34h              ; 4030 c3 34 da
         .db 0E5h,21h,13h,0C7h,22h,5Dh,0C0h,21h,04h,43h,22h,14h,0DFh,21h,3Ah,43h ; 4033 |.!.."].!.C"..!:C|
         .db 22h,16h,0DFh,21h,4Fh,0Dh,22h,18h,0DFh,0E1h,0C9h,1Bh,5Bh,0Ch,1Bh,59h ; 4043 |"..!O.".....[..Y|
         .db 21h,20h,89h,00h,0BBh,89h,00h,0BBh,1Bh,59h,36h,20h,88h,00h,0BCh,88h ; 4053 |! .......Y6 ....|
         .db 00h,0BCh,1Bh,59h,37h,6Ch,00h                     ; 4063 |...Y7l.|
L_406A:  LHLD 0006h               ; 406A 2a 06 00
         SPHL                     ; 406D f9
         SHLD 0009h               ; 406E 22 09 00
L_4071:  XRA  A                   ; 4071 af
L_4072:  STA  0A889h              ; 4072 32 89 a8
L_4075:  LXI  H,0185h             ; 4075 21 85 01
L_4078:  SHLD 0E213h              ; 4078 22 13 e2
L_407B:  MVI  A,0C3h              ; 407B 3e c3
L_407D:  STA  0008h               ; 407D 32 08 00
L_4080:  STA  0018h               ; 4080 32 18 00
L_4083:  STA  0020h               ; 4083 32 20 00
L_4086:  LXI  H,0C97Eh            ; 4086 21 7e c9
L_4089:  SHLD 0010h               ; 4089 22 10 00
L_408C:  INR  L                   ; 408C 2c
L_408D:  SHLD 0012h               ; 408D 22 12 00
L_4090:  LHLD 0F819h              ; 4090 2a 19 f8
L_4093:  SHLD 0019h               ; 4093 22 19 00
L_4096:  LXI  H,3FAFh             ; 4096 21 af 3f
L_4099:  LXI  D,0027h             ; 4099 11 27 00
L_409C:  MVI  C,07h               ; 409C 0e 07
L_409E:  CALL L_3FB0              ; 409E cd b0 3f
L_40A1:  LXI  H,0027h             ; 40A1 21 27 00
L_40A4:  SHLD 002Eh               ; 40A4 22 2e 00
L_40A7:  LHLD 0F80Ah              ; 40A7 2a 0a f8
L_40AA:  SHLD 0F77h               ; 40AA 22 77 0f
L_40AD:  SHLD 0A4Ch               ; 40AD 22 4c 0a
L_40B0:  SHLD 0021h               ; 40B0 22 21 00
L_40B3:  LXI  D,0DF65h            ; 40B3 11 65 df
L_40B6:  LXI  H,401Fh             ; 40B6 21 1f 40
L_40B9:  MVI  C,2Fh               ; 40B9 0e 2f
L_40BB:  RST  5                   ; 40BB ef
L_40BC:  LDA  0DF16h              ; 40BC 3a 16 df
L_40BF:  CPI  3Ah                 ; 40BF fe 3a
L_40C1:  JZ   L_3E98              ; 40C1 ca 98 3e
L_40C4:  LDA  0004h               ; 40C4 3a 04 00
L_40C7:  ADI  41h                 ; 40C7 c6 41
L_40C9:  JMP  L_3E9B              ; 40C9 c3 9b 3e
         .db 0F5h,0C5h,0D5h,0E5h,0CDh,15h,0F8h,0CDh,03h,0F8h,0E1h,0D1h,0C1h,0F1h,0C9h ; 40CC |...............|
L_40DB:  NOP                      ; 40DB 00
         NOP                      ; 40DC 00
         NOP                      ; 40DD 00
L_40DE:  NOP                      ; 40DE 00
         NOP                      ; 40DF 00
         NOP                      ; 40E0 00
L_40E1:  NOP                      ; 40E1 00
         NOP                      ; 40E2 00
         NOP                      ; 40E3 00
L_40E4:  NOP                      ; 40E4 00
L_40E5:  NOP                      ; 40E5 00
L_40E6:  NOP                      ; 40E6 00
L_40E7:  NOP                      ; 40E7 00
L_40E8:  NOP                      ; 40E8 00
L_40E9:  NOP                      ; 40E9 00
L_40EA:  NOP                      ; 40EA 00
L_40EB:  NOP                      ; 40EB 00
         NOP                      ; 40EC 00
         NOP                      ; 40ED 00
L_40EE:  NOP                      ; 40EE 00
         NOP                      ; 40EF 00
         NOP                      ; 40F0 00
L_40F1:  NOP                      ; 40F1 00
         NOP                      ; 40F2 00
         NOP                      ; 40F3 00
L_40F4:  NOP                      ; 40F4 00
         NOP                      ; 40F5 00
         NOP                      ; 40F6 00
L_40F7:  NOP                      ; 40F7 00
         NOP                      ; 40F8 00
         NOP                      ; 40F9 00
L_40FA:  NOP                      ; 40FA 00
         NOP                      ; 40FB 00
         NOP                      ; 40FC 00
         NOP                      ; 40FD 00
         NOP                      ; 40FE 00
         NOP                      ; 40FF 00
