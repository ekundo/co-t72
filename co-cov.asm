L_0100:  JMP  L_406A              ; 0100 c3 6a 40
L_0103:  RNZ                      ; 0103 c0
         POP  B                   ; 0104 c1
         JNZ  C4C3h               ; 0105 c2 c3 c4
L_0108:  PUSH B                   ; 0108 c5
         ADI  C7h                 ; 0109 c6 c7
L_010B:  RZ                       ; 010B c8
L_010C:  RET                      ; 010C c9
L_010D:  JZ   CCCBh               ; 010D ca cb cc
L_0110:  CALL CFCEh               ; 0110 cd ce cf
         RNC                      ; 0113 d0
         POP  D                   ; 0114 d1
L_0115:  JNC  D4D3h               ; 0115 d2 d3 d4
         PUSH D                   ; 0118 d5
         SUI  D7h                 ; 0119 d6 d7
L_011B:  RC                       ; 011B d8
L_011C:  RET                      ; 011C d9
L_011D:  JC   DCDBh               ; 011D da db dc
         CALL DFDEh               ; 0120 dd de df
L_0123:  RP                       ; 0123 f0
L_0124:  POP  PSW                 ; 0124 f1
L_0125:  JP   F4F3h               ; 0125 f2 f3 f4
L_0128:  PUSH PSW                 ; 0128 f5
L_0129:  ORI  F7h                 ; 0129 f6 f7
         RM                       ; 012B f8
L_012C:  SPHL                     ; 012C f9
L_012D:  JM   FCFBh               ; 012D fa fb fc
L_0130:  CALL 9AFEh               ; 0130 fd fe 9a
L_0133:  ORA  B                   ; 0133 b0
L_0134:  ORA  C                   ; 0134 b1
L_0135:  ORA  D                   ; 0135 b2
L_0136:  ORA  E                   ; 0136 b3
L_0137:  ORA  H                   ; 0137 b4
L_0138:  ORA  L                   ; 0138 b5
L_0139:  ORA  M                   ; 0139 b6
L_013A:  ORA  A                   ; 013A b7
L_013B:  CMP  B                   ; 013B b8
         CMP  C                   ; 013C b9
         CMP  D                   ; 013D ba
L_013E:  CMP  E                   ; 013E bb
L_013F:  CMP  H                   ; 013F bc
L_0140:  CMP  L                   ; 0140 bd
L_0141:  CMP  M                   ; 0141 be
L_0142:  CMP  A                   ; 0142 bf
         XRI  A0h                 ; 0143 ee a0
L_0145:  ANA  C                   ; 0145 a1
L_0146:  ANI  A4h                 ; 0146 e6 a4
L_0148:  ANA  L                   ; 0148 a5
         CPO  E5A3h               ; 0149 e4 a3 e5
         XRA  B                   ; 014C a8
         XRA  C                   ; 014D a9
L_014E:  XRA  D                   ; 014E aa
         XRA  E                   ; 014F ab
         XRA  H                   ; 0150 ac
L_0151:  XRA  L                   ; 0151 ad
         XRA  M                   ; 0152 ae
         XRA  A                   ; 0153 af
L_0154:  RST  5                   ; 0154 ef
         RPO                      ; 0155 e0
         POP  H                   ; 0156 e1
L_0157:  JPO  A6E3h               ; 0157 e2 e3 a6
L_015A:  ANA  D                   ; 015A a2
         CPE  A7EBh               ; 015B ec eb a7
         RPE                      ; 015E e8
L_015F:  CALL E7E9h               ; 015F ed e9 e7
         JPE  809Eh               ; 0162 ea 9e 80
         ADD  C                   ; 0165 81
L_0166:  SUB  M                   ; 0166 96
         ADD  H                   ; 0167 84
         ADD  L                   ; 0168 85
L_0169:  SUB  H                   ; 0169 94
         ADD  E                   ; 016A 83
         SUB  L                   ; 016B 95
L_016C:  ADC  B                   ; 016C 88
         ADC  C                   ; 016D 89
         ADC  D                   ; 016E 8a
L_016F:  ADC  E                   ; 016F 8b
         ADC  H                   ; 0170 8c
         ADC  L                   ; 0171 8d
L_0172:  ADC  M                   ; 0172 8e
         ADC  A                   ; 0173 8f
         SBB  A                   ; 0174 9f
L_0175:  SUB  B                   ; 0175 90
L_0176:  SUB  C                   ; 0176 91
         SUB  D                   ; 0177 92
         SUB  E                   ; 0178 93
L_0179:  ADD  M                   ; 0179 86
         ADD  D                   ; 017A 82
         SBB  H                   ; 017B 9c
L_017C:  SBB  E                   ; 017C 9b
         ADD  A                   ; 017D 87
L_017E:  SBB  B                   ; 017E 98
         SBB  L                   ; 017F 9d
         SBB  C                   ; 0180 99
L_0181:  SUB  A                   ; 0181 97
         RST  7                   ; 0182 ff
L_0183:  NOP                      ; 0183 00
L_0184:  NOP                      ; 0184 00
L_0185:  MOV  A,M                 ; 0185 7e
L_0186:  CPI  02h                 ; 0186 fe 02
L_0188:  JZ   E2BDh               ; 0188 ca bd e2
L_018B:  MOV  B,A                 ; 018B 47
L_018C:  MOV  D,H                 ; 018C 54
L_018D:  MOV  E,L                 ; 018D 5d
L_018E:  INX  H                   ; 018E 23
L_018F:  INX  H                   ; 018F 23
L_0190:  MOV  C,M                 ; 0190 4e
L_0191:  INX  H                   ; 0191 23
L_0192:  INX  H                   ; 0192 23
L_0193:  MOV  A,M                 ; 0193 7e
L_0194:  CPI  08h                 ; 0194 fe 08
L_0196:  JNZ  L_0204              ; 0196 c2 04 02
L_0199:  MOV  A,B                 ; 0199 78
L_019A:  STA  L_0236              ; 019A 32 36 02
L_019D:  MOV  A,C                 ; 019D 79
L_019E:  STA  L_0235              ; 019E 32 35 02
L_01A1:  INX  H                   ; 01A1 23
L_01A2:  MOV  A,M                 ; 01A2 7e
L_01A3:  CPI  21h                 ; 01A3 fe 21
L_01A5:  JNC  L_0204              ; 01A5 d2 04 02
L_01A8:  PUSH H                   ; 01A8 e5
L_01A9:  LXI  H,0183h             ; 01A9 21 83 01
L_01AC:  DCR  B                   ; 01AC 05
L_01AD:  JNZ  L_01B1              ; 01AD c2 b1 01
L_01B0:  INX  H                   ; 01B0 23
L_01B1:  MOV  A,M                 ; 01B1 7e
L_01B2:  ANA  A                   ; 01B2 a7
L_01B3:  CZ   L_02A3              ; 01B3 cc a3 02
L_01B6:  POP  H                   ; 01B6 e1
L_01B7:  DI                       ; 01B7 f3
L_01B8:  MOV  A,M                 ; 01B8 7e
L_01B9:  INX  H                   ; 01B9 23
L_01BA:  MOV  E,M                 ; 01BA 5e
L_01BB:  INX  H                   ; 01BB 23
L_01BC:  MOV  D,M                 ; 01BC 56
L_01BD:  STC                      ; 01BD 37
L_01BE:  CMC                      ; 01BE 3f
L_01BF:  RAR                      ; 01BF 1f
L_01C0:  MOV  B,A                 ; 01C0 47
L_01C1:  MVI  A,00h               ; 01C1 3e 00
L_01C3:  RAR                      ; 01C3 1f
L_01C4:  MOV  C,A                 ; 01C4 4f
L_01C5:  LXI  H,3F80h             ; 01C5 21 80 3f
L_01C8:  DAD  B                   ; 01C8 09
L_01C9:  LDA  L_0236              ; 01C9 3a 36 02
L_01CC:  DCR  A                   ; 01CC 3d
L_01CD:  JZ   L_01D4              ; 01CD ca d4 01
L_01D0:  LXI  B,1000h             ; 01D0 01 00 10
L_01D3:  DAD  B                   ; 01D3 09
L_01D4:  LDA  L_0235              ; 01D4 3a 35 02
L_01D7:  CPI  06h                 ; 01D7 fe 06
L_01D9:  XCHG                     ; 01D9 eb
L_01DA:  JNZ  L_0208              ; 01DA c2 08 02
         SHLD L_01E8              ; 01DD 22 e8 01
         LXI  H,0000h             ; 01E0 21 00 00
         DAD  SP                  ; 01E3 39
         SHLD L_0200              ; 01E4 22 00 02
         LXI  SP,0000h            ; 01E7 31 00 00
         XCHG                     ; 01EA eb
         MOV  A,L                 ; 01EB 7d
         INR  A                   ; 01EC 3c
         MVI  A,F2h               ; 01ED 3e f2
         JP   L_01F4              ; 01EF f2 f4 01
         MVI  A,FAh               ; 01F2 3e fa
L_01F4:  STA  L_01FC              ; 01F4 32 fc 01
L_01F7:  POP  D                   ; 01F7 d1
         MOV  M,E                 ; 01F8 73
         INR  L                   ; 01F9 2c
         MOV  M,D                 ; 01FA 72
         INR  L                   ; 01FB 2c
L_01FC:  JMP  L_01F7              ; 01FC c3 f7 01
         .db 31h,00h,00h,AFh,C8h                              ; 01FF |1....|
L_0204:  XCHG                     ; 0204 eb
L_0205:  JMP  E2BDh               ; 0205 c3 bd e2
L_0208:  LXI  B,0080h             ; 0208 01 80 00
L_020B:  DAD  B                   ; 020B 09
L_020C:  SHLD L_0217              ; 020C 22 17 02
L_020F:  LXI  H,0000h             ; 020F 21 00 00
L_0212:  DAD  SP                  ; 0212 39
L_0213:  SHLD L_0231              ; 0213 22 31 02
L_0216:  LXI  SP,0000h            ; 0216 31 00 00
L_0219:  XCHG                     ; 0219 eb
L_021A:  DAD  B                   ; 021A 09
L_021B:  MOV  A,L                 ; 021B 7d
L_021C:  DCR  A                   ; 021C 3d
L_021D:  MVI  A,F2h               ; 021D 3e f2
L_021F:  JP   L_0224              ; 021F f2 24 02
L_0222:  MVI  A,FAh               ; 0222 3e fa
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
         CALL L_0E4D              ; 025E cd 4d 0e
         MOV  A,M                 ; 0261 7e
L_0262:  CPI  43h                 ; 0262 fe 43
         RZ                       ; 0264 c8
         SUI  41h                 ; 0265 d6 41
         JNZ  L_026E              ; 0267 c2 6e 02
         STA  L_0183              ; 026A 32 83 01
         RET                      ; 026D c9
L_026E:  XRA  A                   ; 026E af
         STA  L_0184              ; 026F 32 84 01
         RET                      ; 0272 c9
L_0273:  LXI  H,3E91h             ; 0273 21 91 3e
         CALL L_0E4D              ; 0276 cd 4d 0e
         MOV  A,M                 ; 0279 7e
L_027A:  CPI  43h                 ; 027A fe 43
         RZ                       ; 027C c8
         SUI  41h                 ; 027D d6 41
         STA  L_0236              ; 027F 32 36 02
         CALL L_028D              ; 0282 cd 8d 02
         MVI  A,06h               ; 0285 3e 06
         STA  L_0238              ; 0287 32 38 02
         CALL L_02B5              ; 028A cd b5 02
L_028D:  MVI  A,09h               ; 028D 3e 09
         STA  L_023B              ; 028F 32 3b 02
         LXI  H,0080h             ; 0292 21 80 00
         SHLD L_023C              ; 0295 22 3c 02
         MVI  A,04h               ; 0298 3e 04
         STA  L_0238              ; 029A 32 38 02
         LXI  H,0236h             ; 029D 21 36 02
         JMP  L_02F1              ; 02A0 c3 f1 02
L_02A3:  MVI  A,04h               ; 02A3 3e 04
L_02A5:  STA  L_0238              ; 02A5 32 38 02
L_02A8:  LXI  H,0183h             ; 02A8 21 83 01
L_02AB:  LDA  L_0236              ; 02AB 3a 36 02
L_02AE:  DCR  A                   ; 02AE 3d
L_02AF:  JNZ  L_02B3              ; 02AF c2 b3 02
         INX  H                   ; 02B2 23
L_02B3:  MVI  M,59h               ; 02B3 36 59
L_02B5:  PUSH B                   ; 02B5 c5
L_02B6:  PUSH D                   ; 02B6 d5
L_02B7:  PUSH H                   ; 02B7 e5
L_02B8:  MVI  A,01h               ; 02B8 3e 01
L_02BA:  STA  L_023B              ; 02BA 32 3b 02
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
L_02E1:  LDA  L_023B              ; 02E1 3a 3b 02
L_02E4:  INR  A                   ; 02E4 3c
L_02E5:  STA  L_023B              ; 02E5 32 3b 02
L_02E8:  CPI  21h                 ; 02E8 fe 21
L_02EA:  JNZ  L_02D1              ; 02EA c2 d1 02
L_02ED:  POP  H                   ; 02ED e1
L_02EE:  POP  D                   ; 02EE d1
L_02EF:  POP  B                   ; 02EF c1
L_02F0:  RET                      ; 02F0 c9
L_02F1:  MVI  C,03h               ; 02F1 0e 03
L_02F3:  PUSH B                   ; 02F3 c5
L_02F4:  PUSH H                   ; 02F4 e5
L_02F5:  CALL E2BDh               ; 02F5 cd bd e2
L_02F8:  POP  H                   ; 02F8 e1
L_02F9:  POP  B                   ; 02F9 c1
L_02FA:  ORA  A                   ; 02FA b7
L_02FB:  RZ                       ; 02FB c8
         DCR  C                   ; 02FC 0d
         JNZ  L_02F3              ; 02FD c2 f3 02
         LDA  L_0236              ; 0300 3a 36 02
         MOV  C,A                 ; 0303 4f
         MVI  B,00h               ; 0304 06 00
         LXI  H,0183h             ; 0306 21 83 01
         DAD  H                   ; 0309 29
         XRA  A                   ; 030A af
         MOV  M,A                 ; 030B 77
         JMP  F809h               ; 030C c3 09 f8
L_030F:  CALL L_0583              ; 030F cd 83 05
L_0312:  JMP  L_030F              ; 0312 c3 0f 03
         .db CDh,2Dh,08h,CDh,F3h,0Fh,CDh,C1h,04h,CDh,CAh,20h,21h,89h,B6h,CDh ; 0315 |.-......... !...|
         .db 47h,0Eh,4Eh,2Ah,42h,A8h,D1h,41h,7Bh,3Dh,11h,0Dh,00h,BEh,DAh,3Bh ; 0325 |G.N*B..A{=.....;|
         .db 03h,19h,0Dh,C2h,32h,03h,78h,91h,3Ch,32h,9Bh,B6h,C3h,90h,08h,CDh ; 0335 |....2.x.<2......|
         .db CAh,20h,01h,80h,20h,11h,08h,00h,19h,11h,0Dh,00h,70h,19h,0Dh,C2h ; 0345 |. .. .......p...|
         .db 51h,03h,21h,43h,A9h,CDh,47h,0Eh,36h,00h,21h,47h,A9h,CDh,47h,0Eh ; 0355 |Q.!C..G.6.!G..G.|
         .db 36h,00h,23h,36h,00h,C3h,0Fh,09h,3Ah,01h,A8h,E6h,20h,CAh,BFh,05h ; 0365 |6.#6....:... ...|
         .db 3Ah,2Bh,08h,A7h,C0h,2Ah,7Dh,1Fh,E5h,21h,00h,00h,CDh,A6h,04h,76h ; 0375 |:+...*}..!.....v|
         .db 0Eh,19h,E7h,F3h,3Ah,03h,A8h,32h,ABh,FFh,CDh,B8h,03h,E1h,E5h,CDh ; 0385 |....:..2........|
         .db A6h,04h,0Eh,0Bh,E7h,CDh,C1h,04h,E1h,21h,00h,00h,CDh,A6h,04h,76h ; 0395 |.........!.....v|
         .db 0Eh,1Ah,E7h,F3h,3Eh,FFh,32h,ABh,FFh,CDh,B8h,03h,E1h,CDh,A6h,04h ; 03A5 |....>.2.........|
         .db C3h,F3h,0Fh                                      ; 03B5 |...|
L_03B8:  XRA  A                   ; 03B8 af
         OUT  10h                 ; 03B9 d3 10
         LXI  H,9EFFh             ; 03BB 21 ff 9e
         LXI  D,DEFFh             ; 03BE 11 ff de
         MVI  C,3Eh               ; 03C1 0e 3e
L_03C3:  LDAX D                   ; 03C3 1a
         MOV  B,A                 ; 03C4 47
         MOV  A,M                 ; 03C5 7e
         STAX D                   ; 03C6 12
         MOV  M,B                 ; 03C7 70
         DCX  D                   ; 03C8 1b
         DCR  L                   ; 03C9 2d
         JNZ  L_03C3              ; 03CA c2 c3 03
         LDAX D                   ; 03CD 1a
         MOV  B,A                 ; 03CE 47
         MOV  A,M                 ; 03CF 7e
         STAX D                   ; 03D0 12
         MOV  M,B                 ; 03D1 70
         DCX  D                   ; 03D2 1b
         DCX  H                   ; 03D3 2b
         DCR  C                   ; 03D4 0d
         JNZ  L_03C3              ; 03D5 c2 c3 03
         MVI  A,23h               ; 03D8 3e 23
         OUT  10h                 ; 03DA d3 10
         EI                       ; 03DC fb
         RET                      ; 03DD c9
L_03DE:  LDA  FFABh               ; 03DE 3a ab ff
L_03E1:  STA  A803h               ; 03E1 32 03 a8
L_03E4:  MVI  C,08h               ; 03E4 0e 08
L_03E6:  RST  4                   ; 03E6 e7
L_03E7:  LXI  H,A000h             ; 03E7 21 00 a0
L_03EA:  LXI  D,DFFFh             ; 03EA 11 ff df
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
L_0415:  LDA  B69Dh               ; 0415 3a 9d b6
         DCR  A                   ; 0418 3d
         JZ   L_0444              ; 0419 ca 44 04
         DCR  A                   ; 041C 3d
         JZ   L_042E              ; 041D ca 2e 04
         LXI  H,E000h             ; 0420 21 00 e0
         LXI  D,9FFFh             ; 0423 11 ff 9f
         MVI  C,3Fh               ; 0426 0e 3f
L_0428:  CALL L_03EF              ; 0428 cd ef 03
         JMP  L_2833              ; 042B c3 33 28
L_042E:  LXI  H,D000h             ; 042E 21 00 d0
         LXI  D,8FFFh             ; 0431 11 ff 8f
         MVI  C,0Fh               ; 0434 0e 0f
         CALL L_03EF              ; 0436 cd ef 03
         LXI  H,B000h             ; 0439 21 00 b0
         LXI  D,6FFFh             ; 043C 11 ff 6f
         MVI  C,0Fh               ; 043F 0e 0f
         JMP  L_03EF              ; 0441 c3 ef 03
L_0444:  LXI  H,E000h             ; 0444 21 00 e0
         LXI  D,9FFFh             ; 0447 11 ff 9f
         MVI  C,10h               ; 044A 0e 10
         CALL L_03EF              ; 044C cd ef 03
         LXI  H,C000h             ; 044F 21 00 c0
         LXI  D,7FFFh             ; 0452 11 ff 7f
         MVI  C,10h               ; 0455 0e 10
         JMP  L_0428              ; 0457 c3 28 04
L_045A:  CALL L_082D              ; 045A cd 2d 08
L_045D:  LXI  H,B69Bh             ; 045D 21 9b b6
L_0460:  INR  M                   ; 0460 34
L_0461:  JMP  L_0890              ; 0461 c3 90 08
L_0464:  CALL L_082D              ; 0464 cd 2d 08
         LDA  B69Bh               ; 0467 3a 9b b6
         SUI  15h                 ; 046A d6 15
         JNC  L_0470              ; 046C d2 70 04
         XRA  A                   ; 046F af
L_0470:  INR  A                   ; 0470 3c
         STA  B69Bh               ; 0471 32 9b b6
         JMP  L_0890              ; 0474 c3 90 08
L_0477:  CALL L_082D              ; 0477 cd 2d 08
L_047A:  LXI  H,B69Bh             ; 047A 21 9b b6
L_047D:  DCR  M                   ; 047D 35
L_047E:  JNZ  L_0890              ; 047E c2 90 08
         INR  M                   ; 0481 34
         JMP  L_0890              ; 0482 c3 90 08
L_0485:  CALL L_082D              ; 0485 cd 2d 08
         LXI  H,B69Bh             ; 0488 21 9b b6
         MVI  A,14h               ; 048B 3e 14
         ADD  M                   ; 048D 86
         MOV  M,A                 ; 048E 77
         JMP  L_0890              ; 048F c3 90 08
L_0492:  LXI  H,0622h             ; 0492 21 22 06
         JMP  L_0562              ; 0495 c3 62 05
         .db 2Ah,7Dh,1Fh,E5h,21h,00h,00h,CDh,A6h,04h,CDh,03h,F8h,E1h ; 0498 |*}..!.........|
L_04A6:  PUSH PSW                 ; 04A6 f5
L_04A7:  SHLD L_1F7D              ; 04A7 22 7d 1f
L_04AA:  CALL L_151F              ; 04AA cd 1f 15
L_04AD:  POP  PSW                 ; 04AD f1
L_04AE:  RET                      ; 04AE c9
L_04AF:  LDA  L_082C              ; 04AF 3a 2c 08
L_04B2:  ANA  A                   ; 04B2 a7
L_04B3:  JNZ  L_04F4              ; 04B3 c2 f4 04
         CALL L_0F9A              ; 04B6 cd 9a 0f
         MVI  A,35h               ; 04B9 3e 35
         STA  L_082C              ; 04BB 32 2c 08
         JMP  L_04F4              ; 04BE c3 f4 04
L_04C1:  LDA  L_1F7F              ; 04C1 3a 7f 1f
L_04C4:  CPI  00h                 ; 04C4 fe 00
L_04C6:  JZ   L_0536              ; 04C6 ca 36 05
L_04C9:  LHLD FFBFh               ; 04C9 2a bf ff
L_04CC:  PUSH H                   ; 04CC e5
L_04CD:  MOV  D,A                 ; 04CD 57
L_04CE:  MVI  B,FFh               ; 04CE 06 ff
L_04D0:  MVI  C,FFh               ; 04D0 0e ff
L_04D2:  IN   01h                 ; 04D2 db 01
L_04D4:  STA  A801h               ; 04D4 32 01 a8
L_04D7:  LDA  A800h               ; 04D7 3a 00 a8
L_04DA:  DCR  A                   ; 04DA 3d
L_04DB:  JNZ  L_04F4              ; 04DB c2 f4 04
L_04DE:  LDA  A801h               ; 04DE 3a 01 a8
L_04E1:  ANI  20h                 ; 04E1 e6 20
L_04E3:  JNZ  L_04AF              ; 04E3 c2 af 04
         LDA  B68Fh               ; 04E6 3a 8f b6
         DCR  A                   ; 04E9 3d
         JNZ  L_04F4              ; 04EA c2 f4 04
         CALL L_0F9A              ; 04ED cd 9a 0f
         XRA  A                   ; 04F0 af
         STA  L_082C              ; 04F1 32 2c 08
L_04F4:  CALL F81Bh               ; 04F4 cd 1b f8
L_04F7:  CPI  FFh                 ; 04F7 fe ff
L_04F9:  JNZ  L_0522              ; 04F9 c2 22 05
L_04FC:  DCR  C                   ; 04FC 0d
L_04FD:  JNZ  L_04D2              ; 04FD c2 d2 04
L_0500:  DCR  B                   ; 0500 05
L_0501:  JNZ  L_04D0              ; 0501 c2 d0 04
L_0504:  DCR  D                   ; 0504 15
L_0505:  JNZ  L_04CE              ; 0505 c2 ce 04
         LXI  H,0000h             ; 0508 21 00 00
         CALL L_04A6              ; 050B cd a6 04
L_050E:  CALL F81Bh               ; 050E cd 1b f8
         CPI  FFh                 ; 0511 fe ff
         JZ   L_050E              ; 0513 ca 0e 05
         POP  H                   ; 0516 e1
         CALL L_04A6              ; 0517 cd a6 04
         MVI  C,06h               ; 051A 0e 06
         MVI  E,FFh               ; 051C 1e ff
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
L_052E:  MVI  E,FFh               ; 052E 1e ff
L_0530:  RST  1                   ; 0530 cf
L_0531:  ORA  A                   ; 0531 b7
L_0532:  JNZ  L_052C              ; 0532 c2 2c 05
L_0535:  RET                      ; 0535 c9
L_0536:  CALL F803h               ; 0536 cd 03 f8
         JMP  L_0526              ; 0539 c3 26 05
         .db 21h,81h,B6h,CDh,47h,0Eh,AFh,77h,3Ch,32h,9Bh,B6h,21h,93h,3Eh,CDh ; 053C |!...G..w<2..!.>.|
         .db 4Dh,0Eh,0Eh,4Bh,7Eh,FEh,50h,CAh,58h,05h,0Eh,50h,71h,CDh,1Eh,09h ; 054C |M..K~.P.X..Pq...|
         .db CDh,D9h,0Ch,C3h,E0h,0Fh                          ; 055C |......|
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
         JZ   L_05BF              ; 0576 ca bf 05
         RC                       ; 0579 d8
         CPI  3Ah                 ; 057A fe 3a
         RNC                      ; 057C d0
         SUI  10h                 ; 057D d6 10
         STA  B693h               ; 057F 32 93 b6
         RET                      ; 0582 c9
L_0583:  MVI  A,01h               ; 0583 3e 01
L_0585:  STA  A800h               ; 0585 32 00 a8
L_0588:  CALL L_04C1              ; 0588 cd c1 04
L_058B:  XRA  A                   ; 058B af
L_058C:  STA  A800h               ; 058C 32 00 a8
L_058F:  POP  H                   ; 058F e1
L_0590:  MOV  A,L                 ; 0590 7d
L_0591:  STA  B693h               ; 0591 32 93 b6
L_0594:  CPI  40h                 ; 0594 fe 40
L_0596:  JNC  L_074A              ; 0596 d2 4a 07
L_0599:  LDA  B68Fh               ; 0599 3a 8f b6
L_059C:  CPI  02h                 ; 059C fe 02
L_059E:  LDA  B693h               ; 059E 3a 93 b6
L_05A1:  CZ   L_0574              ; 05A1 cc 74 05
L_05A4:  LXI  H,05DAh             ; 05A4 21 da 05
L_05A7:  JMP  L_0562              ; 05A7 c3 62 05
L_05AA:  LXI  H,B689h             ; 05AA 21 89 b6
L_05AD:  CALL L_0E47              ; 05AD cd 47 0e
L_05B0:  MOV  A,M                 ; 05B0 7e
L_05B1:  CPI  00h                 ; 05B1 fe 00
L_05B3:  JZ   L_0F86              ; 05B3 ca 86 0f
L_05B6:  LDA  B693h               ; 05B6 3a 93 b6
L_05B9:  LXI  H,0637h             ; 05B9 21 37 06
L_05BC:  JMP  L_0562              ; 05BC c3 62 05
L_05BF:  LXI  H,0817h             ; 05BF 21 17 08
         CALL L_0D13              ; 05C2 cd 13 0d
         CALL L_1958              ; 05C5 cd 58 19
         JNZ  L_05D4              ; 05C8 c2 d4 05
         CALL L_101B              ; 05CB cd 1b 10
         CALL L_13CB              ; 05CE cd cb 13
         JMP  L_205D              ; 05D1 c3 5d 20
L_05D4:  CALL L_0FE0              ; 05D4 cd e0 0f
         JMP  L_030F              ; 05D7 c3 0f 03
         .db 11h,00h,4Ah,07h,02h,4Ah,07h,03h,4Ah,07h,3Ch,4Ah,07h,20h,6Dh,03h ; 05DA |..J..J..J.<J. m.|
         .db 01h,FEh,27h,1Bh,9Ah,0Fh,0Ch,F7h,0Bh,0Ah,E1h,26h,31h,16h,06h,21h ; 05EA |..'........&1..!|
         .db 3Ch,05h,32h,1Ch,06h,37h,70h,28h,28h,3Dh,21h,39h,ACh,23h,30h,98h ; 05FA |<.2..7p((=!9.#0.|
         .db 04h,09h,F7h,0Bh,AAh,05h                          ; 060A |......|
L_0610:  MVI  A,4Eh               ; 0610 3e 4e
L_0612:  STA  L_082B              ; 0612 32 2b 08
L_0615:  RET                      ; 0615 c9
L_0616:  CALL L_0610              ; 0616 cd 10 06
L_0619:  JMP  L_2E4E              ; 0619 c3 4e 2e
         .db CDh,10h,06h,C3h,ABh,3Ah,06h,19h,77h,04h,1Ah,5Ah,04h,01h,FEh,27h ; 061C |.....:..w..Z...'|
         .db 08h,64h,04h,18h,85h,04h,0Ah,E1h,26h,DDh,03h,18h,19h,77h,04h,1Ah ; 062C |.d......&....w..|
         .db 5Ah,04h,08h,64h,04h,18h,85h,04h,1Fh,FBh,26h,0Dh,ACh,06h,3Bh,15h ; 063C |Z..d......&...;.|
         .db 03h,2Bh,C7h,22h,2Dh,44h,03h,3Dh,ADh,37h,2Fh,69h,3Dh,22h,A0h,06h ; 064C |.+."-D.=.7/i="..|
         .db 33h,F7h,06h,23h,00h,07h,34h,8Eh,06h,24h,94h,06h,35h,2Eh,07h,25h ; 065C |3..#..4..$..5..%|
         .db 3Ah,07h,36h,88h,06h,26h,EEh,06h,38h,A6h,06h,27h,E5h,06h,3Fh,82h ; 066C |:.6..&..8..'..?.|
         .db 06h,29h,9Ah,06h,82h,05h,CDh,1Eh,07h,C3h,DAh,12h,CDh,14h,07h,C3h ; 067C |.)..............|
         .db 8Ah,21h,CDh,1Eh,07h,C3h,7Dh,39h,CDh,1Eh,07h,C3h,C3h,39h,CDh,1Eh ; 068C |.!....}9.....9..|
         .db 07h,C3h,BDh,39h,CDh,14h,07h,C3h,FEh,23h,CDh,14h,07h,C3h,40h,28h ; 069C |...9.....#....@(|
         .db CDh,DFh,29h,7Eh,FEh,2Eh,C2h,3Eh,3Ch,01h,07h,00h,09h,7Eh,D6h,30h ; 06AC |..)~...><....~.0|
         .db FEh,0Ah,DAh,C3h,06h,D6h,07h,32h,89h,A8h,F5h,21h,87h,A8h,CDh,4Dh ; 06BC |.......2...!...M|
         .db 0Eh,F1h,77h,CDh,1Bh,09h,3Eh,01h,32h,9Bh,B6h,21h,81h,B6h,CDh,47h ; 06CC |..w...>.2..!...G|
         .db 0Eh,36h,00h,CDh,7Eh,0Ch,C3h,D9h,0Ch,CDh,1Eh,07h,CDh,10h,06h,C3h ; 06DC |.6..~...........|
         .db F1h,31h,CDh,14h,07h,CDh,10h,06h,C3h,DAh,3Ah,CDh,1Eh,07h,CDh,10h ; 06EC |.1........:.....|
         .db 06h,C3h,17h,2Ah,CDh,1Eh,07h,CDh,10h,06h,3Eh,E6h,32h,11h,00h,CDh ; 06FC |...*......>.2...|
         .db 17h,2Ah,3Eh,C9h,32h,11h,00h,C9h                  ; 070C |.*>.2...|
L_0714:  LXI  H,A943h             ; 0714 21 43 a9
         CALL L_0E47              ; 0717 cd 47 0e
         MOV  A,M                 ; 071A 7e
         CPI  00h                 ; 071B fe 00
         RNZ                      ; 071D c0
L_071E:  LXI  H,A88Ah             ; 071E 21 8a a8
         CALL L_0E4D              ; 0721 cd 4d 0e
         MOV  A,M                 ; 0724 7e
         INR  A                   ; 0725 3c
         MOV  B,A                 ; 0726 47
         LDA  B69Bh               ; 0727 3a 9b b6
         CMP  B                   ; 072A b8
         RNC                      ; 072B d0
         POP  H                   ; 072C e1
         RET                      ; 072D c9
         .db CDh,14h,07h,CDh,10h,06h,CDh,05h,0Bh,C3h,43h,07h,CDh,14h,07h,CDh ; 072E |..........C.....|
         .db 10h,06h,CDh,0Ah,22h,3Ah,89h,A8h,32h,AAh,1Fh,C9h  ; 073E |....":..2...|
L_074A:  LDA  B693h               ; 074A 3a 93 b6
         CPI  7Fh                 ; 074D fe 7f
         JZ   L_0FE0              ; 074F ca e0 0f
         XRA  A                   ; 0752 af
         STA  DF14h               ; 0753 32 14 df
         STA  A802h               ; 0756 32 02 a8
         LDA  B693h               ; 0759 3a 93 b6
L_075C:  LXI  H,077Dh             ; 075C 21 7d 07
         CALL L_0562              ; 075F cd 62 05
         LDA  A802h               ; 0762 3a 02 a8
         MOV  L,A                 ; 0765 6f
         LDA  DF14h               ; 0766 3a 14 df
         ADI  23h                 ; 0769 c6 23
         SUB  L                   ; 076B 95
         MOV  H,A                 ; 076C 67
         MVI  L,17h               ; 076D 2e 17
         CALL L_2071              ; 076F cd 71 20
L_0772:  CALL L_04C1              ; 0772 cd c1 04
         POP  H                   ; 0775 e1
         MOV  A,L                 ; 0776 7d
         STA  B693h               ; 0777 32 93 b6
         JMP  L_075C              ; 077A c3 5c 07
         .db 0Fh,01h,F5h,27h,00h,05h,08h,0Ah,E1h,26h,02h,05h,08h,03h,C2h,36h ; 077D |...'.....&.....6|
         .db 0Dh,0Fh,20h,1Ah,5Ah,04h,08h,C0h,07h,18h,ADh,07h,19h,77h,04h,0Ch ; 078D |.. .Z........w..|
         .db F7h,0Bh,09h,F7h,0Bh,1Fh,C8h,36h,7Fh,F4h,07h,1Bh,FCh,07h,D7h,07h ; 079D |.......6........|
         .db 3Ah,01h,A8h,E6h,20h,CAh,85h,04h,21h,02h,A8h,7Eh,FEh,00h,CAh,85h ; 07AD |:... ...!..~....|
         .db 04h,35h,C9h,3Ah,01h,A8h,E6h,20h,CAh,64h,04h,3Ah,02h,A8h,21h,14h ; 07BD |.5.:... .d.:..!.|
         .db DFh,BEh,CAh,64h,04h,3Ch,32h,02h,A8h,C9h,3Ah,93h,B6h,4Fh,E7h,21h ; 07CD |...d.<2...:..O.!|
         .db 14h,DFh,3Ah,02h,A8h,FEh,00h,CAh,17h,37h,4Fh,7Eh,91h,85h,3Ch,6Fh ; 07DD |..:......7O~..<o|
         .db 79h,CDh,02h,2Ah,C3h,17h,37h,3Ah,14h,DFh,FEh,01h,C2h,9Ah,26h,3Eh ; 07ED |y..*..7:......&>|
         .db 0Eh,32h,51h,A8h,E1h,C3h,E0h,0Fh,AFh,32h,02h,A8h,CDh,E0h,0Fh,3Ah ; 07FD |.2Q......2.....:|
         .db 93h,B6h,FEh,02h,CAh,9Eh,13h,C3h,8Fh,13h,F7h,D9h,CAh,D4h,C9h,20h ; 080D |............... |
         .db D7h,20h,44h,4Fh,53h,20h,3Fh,20h,28h,59h,2Fh,4Eh,29h,00h,00h,05h ; 081D |. DOS ? (Y/N)...|
L_082D:  LXI  H,3E93h             ; 082D 21 93 3e
L_0830:  CALL L_0E4D              ; 0830 cd 4d 0e
L_0833:  MOV  A,M                 ; 0833 7e
L_0834:  CPI  50h                 ; 0834 fe 50
L_0836:  JZ   L_0844              ; 0836 ca 44 08
L_0839:  MVI  A,0Dh               ; 0839 3e 0d
L_083B:  STA  L_0865              ; 083B 32 65 08
L_083E:  CALL L_084F              ; 083E cd 4f 08
L_0841:  JMP  L_0F70              ; 0841 c3 70 0f
L_0844:  MVI  A,14h               ; 0844 3e 14
         STA  L_0865              ; 0846 32 65 08
         CALL L_084F              ; 0849 cd 4f 08
         JMP  L_0F5C              ; 084C c3 5c 0f
L_084F:  LXI  H,B681h             ; 084F 21 81 b6
L_0852:  CALL L_0E47              ; 0852 cd 47 0e
L_0855:  MVI  B,14h               ; 0855 06 14
L_0857:  MOV  C,M                 ; 0857 4e
L_0858:  CALL L_087E              ; 0858 cd 7e 08
L_085B:  MOV  C,A                 ; 085B 4f
L_085C:  LDA  B69Bh               ; 085C 3a 9b b6
L_085F:  SUB  C                   ; 085F 91
L_0860:  DCR  A                   ; 0860 3d
L_0861:  CALL L_0887              ; 0861 cd 87 08
L_0864:  MVI  B,0Dh               ; 0864 06 0d
L_0866:  CALL L_087E              ; 0866 cd 7e 08
L_0869:  PUSH PSW                 ; 0869 f5
L_086A:  LDA  B69Dh               ; 086A 3a 9d b6
L_086D:  MOV  C,A                 ; 086D 4f
L_086E:  MVI  B,28h               ; 086E 06 28
L_0870:  CALL L_087E              ; 0870 cd 7e 08
L_0873:  SUI  27h                 ; 0873 d6 27
L_0875:  MOV  C,A                 ; 0875 4f
L_0876:  POP  PSW                 ; 0876 f1
L_0877:  ADD  C                   ; 0877 81
L_0878:  STA  B695h               ; 0878 32 95 b6
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
L_0890:  LXI  H,B689h             ; 0890 21 89 b6
L_0893:  CALL L_0E47              ; 0893 cd 47 0e
L_0896:  LDA  B69Bh               ; 0896 3a 9b b6
L_0899:  CMP  M                   ; 0899 be
L_089A:  JC   L_08A1              ; 089A da a1 08
         MOV  A,M                 ; 089D 7e
         STA  B69Bh               ; 089E 32 9b b6
L_08A1:  CALL L_08EB              ; 08A1 cd eb 08
L_08A4:  PUSH PSW                 ; 08A4 f5
L_08A5:  LXI  H,3E93h             ; 08A5 21 93 3e
L_08A8:  CALL L_0E4D              ; 08A8 cd 4d 0e
L_08AB:  MOV  A,M                 ; 08AB 7e
L_08AC:  MVI  C,28h               ; 08AC 0e 28
L_08AE:  CPI  50h                 ; 08AE fe 50
L_08B0:  JZ   L_08B5              ; 08B0 ca b5 08
L_08B3:  MVI  C,3Ch               ; 08B3 0e 3c
L_08B5:  LXI  H,B681h             ; 08B5 21 81 b6
L_08B8:  CALL L_0E47              ; 08B8 cd 47 0e
L_08BB:  POP  PSW                 ; 08BB f1
L_08BC:  ADD  C                   ; 08BC 81
L_08BD:  MOV  C,A                 ; 08BD 4f
L_08BE:  LDA  B69Bh               ; 08BE 3a 9b b6
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
L_08D9:  LDA  B69Bh               ; 08D9 3a 9b b6
L_08DC:  DCR  A                   ; 08DC 3d
L_08DD:  CMP  C                   ; 08DD b9
L_08DE:  JNC  L_0CD9              ; 08DE d2 d9 0c
L_08E1:  DCR  M                   ; 08E1 35
         ADI  14h                 ; 08E2 c6 14
         CMP  C                   ; 08E4 b9
         JC   L_08E1              ; 08E5 da e1 08
         JMP  L_08CD              ; 08E8 c3 cd 08
L_08EB:  LXI  H,B681h             ; 08EB 21 81 b6
L_08EE:  CALL L_0E47              ; 08EE cd 47 0e
L_08F1:  MOV  C,M                 ; 08F1 4e
L_08F2:  MVI  B,14h               ; 08F2 06 14
L_08F4:  JMP  L_087E              ; 08F4 c3 7e 08
L_08F7:  LDA  B695h               ; 08F7 3a 95 b6
L_08FA:  ADI  20h                 ; 08FA c6 20
L_08FC:  MOV  H,A                 ; 08FC 67
L_08FD:  LDA  B69Bh               ; 08FD 3a 9b b6
L_0900:  DCR  A                   ; 0900 3d
L_0901:  SUI  14h                 ; 0901 d6 14
L_0903:  JNC  L_0901              ; 0903 d2 01 09
L_0906:  ADI  36h                 ; 0906 c6 36
L_0908:  MOV  L,A                 ; 0908 6f
L_0909:  CALL L_2071              ; 0909 cd 71 20
L_090C:  JMP  L_29DF              ; 090C c3 df 29
L_090F:  LXI  H,09A7h             ; 090F 21 a7 09
         SHLD L_0961              ; 0912 22 61 09
         CALL L_0927              ; 0915 cd 27 09
         JMP  L_0CD9              ; 0918 c3 d9 0c
L_091B:  CALL L_19E8              ; 091B cd e8 19
L_091E:  CALL L_0D7B              ; 091E cd 7b 0d
L_0921:  LXI  H,09E7h             ; 0921 21 e7 09
L_0924:  SHLD L_0961              ; 0924 22 61 09
L_0927:  CALL L_0E54              ; 0927 cd 54 0e
L_092A:  LDA  B69Bh               ; 092A 3a 9b b6
L_092D:  PUSH PSW                 ; 092D f5
L_092E:  LXI  H,B681h             ; 092E 21 81 b6
L_0931:  CALL L_0E47              ; 0931 cd 47 0e
L_0934:  MOV  C,M                 ; 0934 4e
L_0935:  MVI  A,EDh               ; 0935 3e ed
L_0937:  MVI  B,14h               ; 0937 06 14
L_0939:  INR  C                   ; 0939 0c
L_093A:  ADD  B                   ; 093A 80
L_093B:  DCR  C                   ; 093B 0d
L_093C:  JNZ  L_093A              ; 093C c2 3a 09
L_093F:  STA  B69Bh               ; 093F 32 9b b6
L_0942:  LXI  H,B689h             ; 0942 21 89 b6
L_0945:  CALL L_0E47              ; 0945 cd 47 0e
L_0948:  MOV  A,M                 ; 0948 7e
L_0949:  ORA  A                   ; 0949 b7
L_094A:  JZ   L_097A              ; 094A ca 7a 09
L_094D:  INR  A                   ; 094D 3c
L_094E:  STA  A807h               ; 094E 32 07 a8
L_0951:  LXI  H,3E93h             ; 0951 21 93 3e
L_0954:  CALL L_0E4D              ; 0954 cd 4d 0e
L_0957:  MOV  A,M                 ; 0957 7e
L_0958:  STA  A808h               ; 0958 32 08 a8
L_095B:  CALL L_29DF              ; 095B cd df 29
L_095E:  MVI  C,27h               ; 095E 0e 27
L_0960:  CALL L_09A7              ; 0960 cd a7 09
         LDA  A808h               ; 0963 3a 08 a8
         CPI  50h                 ; 0966 fe 50
         JNZ  L_0970              ; 0968 c2 70 09
         MVI  C,0Bh               ; 096B 0e 0b
         JMP  L_0977              ; 096D c3 77 09
L_0970:  MVI  C,12h               ; 0970 0e 12
         CALL L_09AF              ; 0972 cd af 09
         MVI  C,05h               ; 0975 0e 05
L_0977:  CALL L_09AF              ; 0977 cd af 09
L_097A:  POP  PSW                 ; 097A f1
L_097B:  STA  B69Bh               ; 097B 32 9b b6
L_097E:  JMP  L_0FF3              ; 097E c3 f3 0f
L_0981:  POP  H                   ; 0981 e1
L_0982:  JMP  L_097A              ; 0982 c3 7a 09
L_0985:  LDA  B69Dh               ; 0985 3a 9d b6
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
L_09A2:  LDA  A807h               ; 09A2 3a 07 a8
L_09A5:  MOV  B,A                 ; 09A5 47
L_09A6:  RET                      ; 09A6 c9
L_09A7:  LXI  D,0008h             ; 09A7 11 08 00
         DAD  D                   ; 09AA 19
         MOV  A,C                 ; 09AB 79
         SUI  08h                 ; 09AC d6 08
         MOV  C,A                 ; 09AE 4f
L_09AF:  CALL L_0985              ; 09AF cd 85 09
         LXI  D,000Dh             ; 09B2 11 0d 00
L_09B5:  PUSH B                   ; 09B5 c5
         MOV  C,M                 ; 09B6 4e
         RST  4                   ; 09B7 e7
         POP  B                   ; 09B8 c1
         DAD  D                   ; 09B9 19
         PUSH H                   ; 09BA e5
         LXI  H,10D4h             ; 09BB 21 d4 10
         RST  3                   ; 09BE df
         POP  H                   ; 09BF e1
         LDA  B69Bh               ; 09C0 3a 9b b6
         INR  A                   ; 09C3 3c
         STA  B69Bh               ; 09C4 32 9b b6
         CMP  B                   ; 09C7 b8
         JZ   L_0981              ; 09C8 ca 81 09
         DCR  C                   ; 09CB 0d
         JNZ  L_09B5              ; 09CC c2 b5 09
         RET                      ; 09CF c9
L_09D0:  CALL L_0A20              ; 09D0 cd 20 0a
L_09D3:  LDA  B69Bh               ; 09D3 3a 9b b6
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
         LDA  A808h               ; 09F1 3a 08 a8
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
L_0A0E:  LDA  B69Bh               ; 0A0E 3a 9b b6
L_0A11:  INR  A                   ; 0A11 3c
L_0A12:  STA  B69Bh               ; 0A12 32 9b b6
L_0A15:  CMP  B                   ; 0A15 b8
L_0A16:  JP   L_0981              ; 0A16 f2 81 09
L_0A19:  DCR  C                   ; 0A19 0d
L_0A1A:  JNZ  L_09EA              ; 0A1A c2 ea 09
         JMP  L_0981              ; 0A1D c3 81 09
L_0A20:  CALL L_0A40              ; 0A20 cd 40 0a
L_0A23:  LDA  A808h               ; 0A23 3a 08 a8
L_0A26:  CPI  50h                 ; 0A26 fe 50
L_0A28:  RNZ                      ; 0A28 c0
         PUSH H                   ; 0A29 e5
         PUSH B                   ; 0A2A c5
         DCX  H                   ; 0A2B 2b
         MOV  A,M                 ; 0A2C 7e
         LXI  H,10C9h             ; 0A2D 21 c9 10
         CALL L_0E1B              ; 0A30 cd 1b 0e
         LXI  H,10C8h             ; 0A33 21 c8 10
         MVI  E,07h               ; 0A36 1e 07
         MVI  A,20h               ; 0A38 3e 20
         CALL L_0A44              ; 0A3A cd 44 0a
         POP  B                   ; 0A3D c1
         POP  H                   ; 0A3E e1
         RET                      ; 0A3F c9
L_0A40:  MVI  A,20h               ; 0A40 3e 20
L_0A42:  MVI  E,0Ch               ; 0A42 1e 0c
L_0A44:  MOV  C,M                 ; 0A44 4e
L_0A45:  CMP  C                   ; 0A45 b9
L_0A46:  JNZ  L_0A4B              ; 0A46 c2 4b 0a
L_0A49:  MVI  C,18h               ; 0A49 0e 18
L_0A4B:  CALL F809h               ; 0A4B cd 09 f8
L_0A4E:  INX  H                   ; 0A4E 23
L_0A4F:  DCR  E                   ; 0A4F 1d
L_0A50:  JNZ  L_0A44              ; 0A50 c2 44 0a
L_0A53:  INX  H                   ; 0A53 23
L_0A54:  RET                      ; 0A54 c9
L_0A55:  LDA  L_10DE              ; 0A55 3a de 10
         JMP  L_0A86              ; 0A58 c3 86 0a
L_0A5B:  CALL L_0AA2              ; 0A5B cd a2 0a
         LXI  H,A887h             ; 0A5E 21 87 a8
         LDA  B69Dh               ; 0A61 3a 9d b6
         DCR  A                   ; 0A64 3d
         JNZ  L_0A69              ; 0A65 c2 69 0a
         INX  H                   ; 0A68 23
L_0A69:  MOV  A,M                 ; 0A69 7e
         CALL L_1D3B              ; 0A6A cd 3b 1d
         STA  L_10DE              ; 0A6D 32 de 10
         LXI  H,10D7h             ; 0A70 21 d7 10
         RST  3                   ; 0A73 df
         CALL L_0D44              ; 0A74 cd 44 0d
         CPI  0Dh                 ; 0A77 fe 0d
         JZ   L_0A55              ; 0A79 ca 55 0a
         CPI  1Ah                 ; 0A7C fe 1a
         JZ   L_0A55              ; 0A7E ca 55 0a
         CPI  20h                 ; 0A81 fe 20
         JC   L_0B01              ; 0A83 da 01 0b
L_0A86:  MOV  C,A                 ; 0A86 4f
         RST  4                   ; 0A87 e7
         SUI  30h                 ; 0A88 d6 30
         CPI  0Ah                 ; 0A8A fe 0a
         JC   L_0A96              ; 0A8C da 96 0a
         SUI  07h                 ; 0A8F d6 07
         CPI  0Ah                 ; 0A91 fe 0a
         JC   L_0B01              ; 0A93 da 01 0b
L_0A96:  CPI  10h                 ; 0A96 fe 10
         JNC  L_0B01              ; 0A98 d2 01 0b
         STA  L_1FAA              ; 0A9B 32 aa 1f
         CALL L_0FE0              ; 0A9E cd e0 0f
         RET                      ; 0AA1 c9
L_0AA2:  LXI  H,3E91h             ; 0AA2 21 91 3e
         CALL L_0E4D              ; 0AA5 cd 4d 0e
         MOV  A,M                 ; 0AA8 7e
         STA  L_10BA              ; 0AA9 32 ba 10
         LXI  H,3E91h             ; 0AAC 21 91 3e
         LDA  B69Dh               ; 0AAF 3a 9d b6
         DCR  A                   ; 0AB2 3d
         JNZ  L_0AB7              ; 0AB3 c2 b7 0a
         INX  H                   ; 0AB6 23
L_0AB7:  MOV  A,M                 ; 0AB7 7e
         STA  L_10BE              ; 0AB8 32 be 10
         STA  A806h               ; 0ABB 32 06 a8
         LXI  H,10BAh             ; 0ABE 21 ba 10
         RST  3                   ; 0AC1 df
         CALL L_0D44              ; 0AC2 cd 44 0d
         CPI  20h                 ; 0AC5 fe 20
         JC   L_0ACC              ; 0AC7 da cc 0a
         MOV  C,A                 ; 0ACA 4f
         RST  4                   ; 0ACB e7
L_0ACC:  LXI  H,0AD2h             ; 0ACC 21 d2 0a
         JMP  L_0562              ; 0ACF c3 62 05
         .db 05h,0Dh,FCh,0Ah,1Ah,FCh,0Ah,41h,F1h,0Ah,42h,E4h,0Ah,43h,F6h,0Ah ; 0AD2 |.......A..B..C..|
         .db 00h,0Bh,3Ah,97h,3Eh,FEh,59h,C2h,01h,0Bh,3Eh,42h,C3h,F8h,0Ah,3Eh ; 0AE2 |..:.>.Y...>B...>|
         .db 41h,C3h,F8h,0Ah,3Eh,43h                          ; 0AF2 |A...>C|
L_0AF8:  STA  L_10BE              ; 0AF8 32 be 10
         RET                      ; 0AFB c9
         .db 0Eh,18h,E7h,C9h,E1h                              ; 0AFC |.....|
L_0B01:  POP  H                   ; 0B01 e1
         JMP  L_0FE0              ; 0B02 c3 e0 0f
         .db 21h,87h,A8h,7Eh,32h,AAh,1Fh,CDh,5Bh,0Ah,21h,BEh,10h,7Eh,32h,49h ; 0B05 |!..~2...[.!..~2I|
         .db A8h,3Ah,BAh,10h,32h,4Ah,A8h,BEh,C2h,2Ch,0Bh,21h,87h,A8h,CDh,4Dh ; 0B15 |.:..2J...,.!...M|
         .db 0Eh,4Eh,3Ah,AAh,1Fh,BEh,C8h,3Ah,4Ah,A8h,CDh,6Bh,0Bh,CDh,62h,02h ; 0B25 |.N:....:J..k..b.|
         .db 3Ah,49h,A8h,CDh,5Ch,0Bh,CDh,62h,02h,CDh,7Ch,1Eh,21h,AFh,10h,3Eh ; 0B35 |:I..\..b..|.!..>|
         .db 01h,CDh,1Bh,0Eh,21h,A5h,10h,DFh,21h,E0h,0Bh,CDh,7Ah,0Bh,3Ah,49h ; 0B45 |....!...!...z.:I|
         .db A8h,CDh,7Ah,02h,C3h,54h,22h                      ; 0B55 |..z..T"|
L_0B5C:  LXI  H,178Fh             ; 0B5C 21 8f 17
L_0B5F:  CPI  43h                 ; 0B5F fe 43
L_0B61:  JZ   L_0B67              ; 0B61 ca 67 0b
         LXI  H,179Bh             ; 0B64 21 9b 17
L_0B67:  SHLD L_1767              ; 0B67 22 67 17
L_0B6A:  RET                      ; 0B6A c9
L_0B6B:  LXI  H,1713h             ; 0B6B 21 13 17
L_0B6E:  CPI  43h                 ; 0B6E fe 43
L_0B70:  JZ   L_0B76              ; 0B70 ca 76 0b
L_0B73:  LXI  H,1701h             ; 0B73 21 01 17
L_0B76:  SHLD L_16C9              ; 0B76 22 c9 16
L_0B79:  RET                      ; 0B79 c9
L_0B7A:  SHLD L_0BB1              ; 0B7A 22 b1 0b
         SHLD L_0BD9              ; 0B7D 22 d9 0b
         LDA  B69Bh               ; 0B80 3a 9b b6
         STA  A950h               ; 0B83 32 50 a9
         XRA  A                   ; 0B86 af
         STA  B69Bh               ; 0B87 32 9b b6
         INR  A                   ; 0B8A 3c
         STA  A804h               ; 0B8B 32 04 a8
         LXI  H,B689h             ; 0B8E 21 89 b6
         CALL L_0E47              ; 0B91 cd 47 0e
L_0B94:  LDA  B69Bh               ; 0B94 3a 9b b6
         CMP  M                   ; 0B97 be
         JZ   L_0BC8              ; 0B98 ca c8 0b
         INR  A                   ; 0B9B 3c
         STA  B69Bh               ; 0B9C 32 9b b6
         PUSH H                   ; 0B9F e5
         CALL L_29DF              ; 0BA0 cd df 29
         LXI  D,0008h             ; 0BA3 11 08 00
         XCHG                     ; 0BA6 eb
         DAD  D                   ; 0BA7 19
         MOV  A,M                 ; 0BA8 7e
         CPI  7Fh                 ; 0BA9 fe 7f
         POP  H                   ; 0BAB e1
         JNZ  L_0B94              ; 0BAC c2 94 0b
         PUSH H                   ; 0BAF e5
         CALL 0000h               ; 0BB0 cd 00 00
         LXI  H,A804h             ; 0BB3 21 04 a8
         INR  M                   ; 0BB6 34
         CALL F81Bh               ; 0BB7 cd 1b f8
         CPI  1Bh                 ; 0BBA fe 1b
         POP  H                   ; 0BBC e1
         JZ   L_0BC8              ; 0BBD ca c8 0b
         LDA  B68Dh               ; 0BC0 3a 8d b6
         CPI  03h                 ; 0BC3 fe 03
         JNZ  L_0B94              ; 0BC5 c2 94 0b
L_0BC8:  LDA  A950h               ; 0BC8 3a 50 a9
         STA  B69Bh               ; 0BCB 32 9b b6
         CALL L_29DF              ; 0BCE cd df 29
         XCHG                     ; 0BD1 eb
         MVI  A,01h               ; 0BD2 3e 01
         LXI  H,A804h             ; 0BD4 21 04 a8
         CMP  M                   ; 0BD7 be
         CZ   0000h               ; 0BD8 cc 00 00
         XRA  A                   ; 0BDB af
         STA  B68Dh               ; 0BDC 32 8d b6
         RET                      ; 0BDF c9
         .db EBh,22h,4Fh,A8h,22h,4Dh,A8h,3Ah,04h,A8h,21h,EDh,11h,CDh,1Bh,0Eh ; 0BE0 |."O."M.:..!.....|
         .db 21h,E9h,11h,DFh,C3h,9Ah,15h                      ; 0BF0 |!......|
L_0BF7:  LXI  H,B689h             ; 0BF7 21 89 b6
L_0BFA:  CALL L_0E47              ; 0BFA cd 47 0e
L_0BFD:  XRA  A                   ; 0BFD af
L_0BFE:  CMP  M                   ; 0BFE be
L_0BFF:  CNZ  L_082D              ; 0BFF c4 2d 08
L_0C02:  LDA  B69Dh               ; 0C02 3a 9d b6
L_0C05:  DCR  A                   ; 0C05 3d
L_0C06:  JNZ  L_0C0B              ; 0C06 c2 0b 0c
L_0C09:  MVI  A,02h               ; 0C09 3e 02
L_0C0B:  STA  B69Dh               ; 0C0B 32 9d b6
L_0C0E:  LDA  B69Bh               ; 0C0E 3a 9b b6
L_0C11:  MOV  C,A                 ; 0C11 4f
L_0C12:  LDA  A94Dh               ; 0C12 3a 4d a9
L_0C15:  STA  B69Bh               ; 0C15 32 9b b6
L_0C18:  MOV  A,C                 ; 0C18 79
L_0C19:  STA  A94Dh               ; 0C19 32 4d a9
L_0C1C:  LXI  H,A887h             ; 0C1C 21 87 a8
L_0C1F:  CALL L_0E4D              ; 0C1F cd 4d 0e
L_0C22:  MOV  A,M                 ; 0C22 7e
L_0C23:  STA  A889h               ; 0C23 32 89 a8
L_0C26:  CALL L_13D3              ; 0C26 cd d3 13
L_0C29:  CALL L_0C7E              ; 0C29 cd 7e 0c
L_0C2C:  JMP  L_0CD9              ; 0C2C c3 d9 0c
L_0C2F:  CALL L_29DF              ; 0C2F cd df 29
         PUSH H                   ; 0C32 e5
         LXI  D,B654h             ; 0C33 11 54 b6
         MVI  C,0Eh               ; 0C36 0e 0e
         RST  5                   ; 0C38 ef
         LXI  H,0C56h             ; 0C39 21 56 0c
         PUSH H                   ; 0C3C e5
         LDA  A94Bh               ; 0C3D 3a 4b a9
         DCR  A                   ; 0C40 3d
         JZ   L_0C63              ; 0C41 ca 63 0c
         DCR  A                   ; 0C44 3d
         JZ   L_0C5D              ; 0C45 ca 5d 0c
         LXI  H,B65Dh             ; 0C48 21 5d b6
         MOV  A,M                 ; 0C4B 7e
         ANI  7Fh                 ; 0C4C e6 7f
         MOV  M,A                 ; 0C4E 77
         INX  H                   ; 0C4F 23
         MOV  A,M                 ; 0C50 7e
         ANI  7Fh                 ; 0C51 e6 7f
         JMP  L_0C69              ; 0C53 c3 69 0c
         .db D1h,21h,54h,B6h,C3h,79h,39h                      ; 0C56 |.!T..y9|
L_0C5D:  LXI  H,B65Eh             ; 0C5D 21 5e b6
         JMP  L_0C66              ; 0C60 c3 66 0c
L_0C63:  LXI  H,B65Dh             ; 0C63 21 5d b6
L_0C66:  MOV  A,M                 ; 0C66 7e
         ORI  80h                 ; 0C67 f6 80
L_0C69:  MOV  M,A                 ; 0C69 77
         LXI  H,3E91h             ; 0C6A 21 91 3e
         CALL L_0E4D              ; 0C6D cd 4d 0e
         MOV  A,M                 ; 0C70 7e
         STA  B673h               ; 0C71 32 73 b6
         CALL L_19B2              ; 0C74 cd b2 19
         MVI  C,1Eh               ; 0C77 0e 1e
         LXI  D,005Ch             ; 0C79 11 5c 00
         RST  1                   ; 0C7C cf
         RET                      ; 0C7D c9
L_0C7E:  MVI  C,0Bh               ; 0C7E 0e 0b
L_0C80:  RST  4                   ; 0C80 e7
L_0C81:  LDA  B69Dh               ; 0C81 3a 9d b6
L_0C84:  DCR  A                   ; 0C84 3d
L_0C85:  JZ   L_0CBA              ; 0C85 ca ba 0c
L_0C88:  STA  B69Dh               ; 0C88 32 9d b6
L_0C8B:  CALL L_0EB5              ; 0C8B cd b5 0e
L_0C8E:  MVI  A,02h               ; 0C8E 3e 02
L_0C90:  STA  B69Dh               ; 0C90 32 9d b6
L_0C93:  CALL L_0CCD              ; 0C93 cd cd 0c
L_0C96:  LXI  H,3E91h             ; 0C96 21 91 3e
L_0C99:  CALL L_0E4D              ; 0C99 cd 4d 0e
L_0C9C:  MOV  A,M                 ; 0C9C 7e
L_0C9D:  STA  L_10A2              ; 0C9D 32 a2 10
L_0CA0:  SUI  41h                 ; 0CA0 d6 41
L_0CA2:  STA  0004h               ; 0CA2 32 04 00
L_0CA5:  LDA  A889h               ; 0CA5 3a 89 a8
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
L_0CBF:  STA  B69Dh               ; 0CBF 32 9d b6
L_0CC2:  CALL L_0EB5              ; 0CC2 cd b5 0e
L_0CC5:  MVI  A,01h               ; 0CC5 3e 01
L_0CC7:  STA  B69Dh               ; 0CC7 32 9d b6
L_0CCA:  JMP  L_0C96              ; 0CCA c3 96 0c
L_0CCD:  LXI  H,1097h             ; 0CCD 21 97 10
L_0CD0:  RST  3                   ; 0CD0 df
L_0CD1:  CALL L_0EB5              ; 0CD1 cd b5 0e
L_0CD4:  LXI  H,109Ah             ; 0CD4 21 9a 10
L_0CD7:  RST  3                   ; 0CD7 df
L_0CD8:  RET                      ; 0CD8 c9
L_0CD9:  LXI  H,B689h             ; 0CD9 21 89 b6
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
         POP  H                   ; 0CF5 e1
         PUSH H                   ; 0CF6 e5
         MVI  C,00h               ; 0CF7 0e 00
L_0CF9:  CALL L_0D13              ; 0CF9 cd 13 0d
         MOV  A,E                 ; 0CFC 7b
         CMP  C                   ; 0CFD b9
         JNZ  L_0CF9              ; 0CFE c2 f9 0c
         PUSH H                   ; 0D01 e5
         LXI  H,1097h             ; 0D02 21 97 10
         RST  3                   ; 0D05 df
         POP  H                   ; 0D06 e1
         CALL L_0D13              ; 0D07 cd 13 0d
         PUSH H                   ; 0D0A e5
         LXI  H,109Ah             ; 0D0B 21 9a 10
         RST  3                   ; 0D0E df
         POP  H                   ; 0D0F e1
         JMP  L_0D20              ; 0D10 c3 20 0d
L_0D13:  PUSH B                   ; 0D13 c5
         MVI  C,20h               ; 0D14 0e 20
         RST  4                   ; 0D16 e7
         RST  3                   ; 0D17 df
         RST  4                   ; 0D18 e7
         POP  B                   ; 0D19 c1
         INX  H                   ; 0D1A 23
         INR  C                   ; 0D1B 0c
         RET                      ; 0D1C c9
L_0D1D:  CALL L_0D13              ; 0D1D cd 13 0d
L_0D20:  MOV  A,D                 ; 0D20 7a
         CMP  C                   ; 0D21 b9
         JNZ  L_0D1D              ; 0D22 c2 1d 0d
L_0D25:  CALL L_0D44              ; 0D25 cd 44 0d
         CPI  08h                 ; 0D28 fe 08
         JZ   L_0D50              ; 0D2A ca 50 0d
         CPI  18h                 ; 0D2D fe 18
         JZ   L_0D5E              ; 0D2F ca 5e 0d
         CPI  0Dh                 ; 0D32 fe 0d
         JZ   L_0D6D              ; 0D34 ca 6d 0d
         CPI  1Ah                 ; 0D37 fe 1a
         JZ   L_0D6D              ; 0D39 ca 6d 0d
         CPI  1Bh                 ; 0D3C fe 1b
         JZ   L_0D72              ; 0D3E ca 72 0d
         JMP  L_0D25              ; 0D41 c3 25 0d
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
         DCR  A                   ; 0D51 3d
         JZ   L_0D59              ; 0D52 ca 59 0d
         DCR  E                   ; 0D55 1d
         JMP  L_0CF2              ; 0D56 c3 f2 0c
L_0D59:  MOV  E,D                 ; 0D59 5a
         DCR  E                   ; 0D5A 1d
         JMP  L_0CF2              ; 0D5B c3 f2 0c
L_0D5E:  MOV  A,E                 ; 0D5E 7b
         INR  A                   ; 0D5F 3c
         CMP  D                   ; 0D60 ba
         JZ   L_0D68              ; 0D61 ca 68 0d
         INR  E                   ; 0D64 1c
         JMP  L_0CF2              ; 0D65 c3 f2 0c
L_0D68:  MVI  E,01h               ; 0D68 1e 01
         JMP  L_0CF2              ; 0D6A c3 f2 0c
L_0D6D:  POP  H                   ; 0D6D e1
         MOV  A,E                 ; 0D6E 7b
         JMP  L_0D75              ; 0D6F c3 75 0d
L_0D72:  POP  H                   ; 0D72 e1
         MVI  A,1Bh               ; 0D73 3e 1b
L_0D75:  PUSH PSW                 ; 0D75 f5
         CALL L_0FE0              ; 0D76 cd e0 0f
         POP  PSW                 ; 0D79 f1
         RET                      ; 0D7A c9
L_0D7B:  CALL L_2A0A              ; 0D7B cd 0a 2a
L_0D7E:  CALL L_347D              ; 0D7E cd 7d 34
L_0D81:  CALL L_2A0A              ; 0D81 cd 0a 2a
L_0D84:  LXI  H,3E93h             ; 0D84 21 93 3e
L_0D87:  CALL L_0E4D              ; 0D87 cd 4d 0e
L_0D8A:  MOV  B,M                 ; 0D8A 46
L_0D8B:  LDA  B69Dh               ; 0D8B 3a 9d b6
L_0D8E:  MOV  C,A                 ; 0D8E 4f
L_0D8F:  LXI  H,0000h             ; 0D8F 21 00 00
L_0D92:  DAD  SP                  ; 0D92 39
L_0D93:  SHLD L_0DED              ; 0D93 22 ed 0d
L_0D96:  LXI  SP,00B0h            ; 0D96 31 b0 00
L_0D99:  XRA  A                   ; 0D99 af
L_0D9A:  OUT  10h                 ; 0D9A d3 10
L_0D9C:  MOV  A,B                 ; 0D9C 78
L_0D9D:  DCR  C                   ; 0D9D 0d
L_0D9E:  JZ   L_0DC0              ; 0D9E ca c0 0d
L_0DA1:  MVI  H,D0h               ; 0DA1 26 d0
L_0DA3:  MVI  B,60h               ; 0DA3 06 60
L_0DA5:  CALL L_0DF5              ; 0DA5 cd f5 0d
L_0DA8:  MVI  H,DEh               ; 0DA8 26 de
L_0DAA:  MVI  B,03h               ; 0DAA 06 03
L_0DAC:  CALL L_0DF5              ; 0DAC cd f5 0d
L_0DAF:  CPI  50h                 ; 0DAF fe 50
L_0DB1:  JZ   L_0DE1              ; 0DB1 ca e1 0d
L_0DB4:  MVI  H,B5h               ; 0DB4 26 b5
L_0DB6:  MVI  B,80h               ; 0DB6 06 80
L_0DB8:  CALL L_0DF5              ; 0DB8 cd f5 0d
L_0DBB:  MVI  H,B9h               ; 0DBB 26 b9
L_0DBD:  JMP  L_0DDC              ; 0DBD c3 dc 0d
L_0DC0:  MVI  H,C1h               ; 0DC0 26 c1
L_0DC2:  MVI  B,60h               ; 0DC2 06 60
L_0DC4:  CALL L_0DF5              ; 0DC4 cd f5 0d
L_0DC7:  MVI  H,CFh               ; 0DC7 26 cf
L_0DC9:  MVI  B,03h               ; 0DC9 06 03
L_0DCB:  CALL L_0DF5              ; 0DCB cd f5 0d
L_0DCE:  CPI  50h                 ; 0DCE fe 50
L_0DD0:  JZ   L_0DF0              ; 0DD0 ca f0 0d
L_0DD3:  MVI  H,A6h               ; 0DD3 26 a6
L_0DD5:  MVI  B,80h               ; 0DD5 06 80
L_0DD7:  CALL L_0DF5              ; 0DD7 cd f5 0d
L_0DDA:  MVI  H,AAh               ; 0DDA 26 aa
L_0DDC:  MVI  B,01h               ; 0DDC 06 01
L_0DDE:  JMP  L_0DE5              ; 0DDE c3 e5 0d
L_0DE1:  MVI  H,B7h               ; 0DE1 26 b7
L_0DE3:  MVI  B,14h               ; 0DE3 06 14
L_0DE5:  CALL L_0DF5              ; 0DE5 cd f5 0d
L_0DE8:  MVI  A,23h               ; 0DE8 3e 23
L_0DEA:  OUT  10h                 ; 0DEA d3 10
L_0DEC:  LXI  SP,0000h            ; 0DEC 31 00 00
L_0DEF:  RET                      ; 0DEF c9
L_0DF0:  MVI  H,A8h               ; 0DF0 26 a8
         JMP  L_0DE3              ; 0DF2 c3 e3 0d
L_0DF5:  MVI  L,20h               ; 0DF5 2e 20
L_0DF7:  MVI  C,CFh               ; 0DF7 0e cf
L_0DF9:  MOV  M,B                 ; 0DF9 70
L_0DFA:  INX  H                   ; 0DFA 23
L_0DFB:  DCR  C                   ; 0DFB 0d
L_0DFC:  JNZ  L_0DF9              ; 0DFC c2 f9 0d
L_0DFF:  RET                      ; 0DFF c9
L_0E00:  PUSH H                   ; 0E00 e5
L_0E01:  XCHG                     ; 0E01 eb
L_0E02:  LXI  D,FF9Ch             ; 0E02 11 9c ff
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
L_0E4D:  LDA  B69Dh               ; 0E4D 3a 9d b6
L_0E50:  DCR  A                   ; 0E50 3d
L_0E51:  RZ                       ; 0E51 c8
L_0E52:  INX  H                   ; 0E52 23
L_0E53:  RET                      ; 0E53 c9
L_0E54:  LDA  B69Dh               ; 0E54 3a 9d b6
L_0E57:  MOV  B,A                 ; 0E57 47
L_0E58:  XRA  A                   ; 0E58 af
L_0E59:  ADI  28h                 ; 0E59 c6 28
L_0E5B:  DCR  B                   ; 0E5B 05
L_0E5C:  JNZ  L_0E59              ; 0E5C c2 59 0e
L_0E5F:  ADI  15h                 ; 0E5F c6 15
L_0E61:  STA  L_110D              ; 0E61 32 0d 11
L_0E64:  LXI  H,110Ah             ; 0E64 21 0a 11
L_0E67:  RST  3                   ; 0E67 df
L_0E68:  LXI  H,A943h             ; 0E68 21 43 a9
L_0E6B:  CALL L_0E47              ; 0E6B cd 47 0e
L_0E6E:  MOV  A,M                 ; 0E6E 7e
L_0E6F:  CPI  00h                 ; 0E6F fe 00
L_0E71:  JZ   L_0E8E              ; 0E71 ca 8e 0e
         LXI  H,1111h             ; 0E74 21 11 11
         CALL L_0E1B              ; 0E77 cd 1b 0e
         LXI  H,A947h             ; 0E7A 21 47 a9
         CALL L_0E47              ; 0E7D cd 47 0e
         MOV  E,M                 ; 0E80 5e
         INX  H                   ; 0E81 23
         MOV  D,M                 ; 0E82 56
         LXI  H,1115h             ; 0E83 21 15 11
         CALL L_0E00              ; 0E86 cd 00 0e
         LXI  H,110Fh             ; 0E89 21 0f 11
         RST  3                   ; 0E8C df
         RET                      ; 0E8D c9
L_0E8E:  MVI  A,08h               ; 0E8E 3e 08
L_0E90:  JMP  L_0F7F              ; 0E90 c3 7f 0f
L_0E93:  LXI  H,B681h             ; 0E93 21 81 b6
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
         STA  B69Bh               ; 0EAC 32 9b b6
         CALL L_0CD9              ; 0EAF cd d9 0c
         JMP  L_0FE0              ; 0EB2 c3 e0 0f
L_0EB5:  LXI  H,3E91h             ; 0EB5 21 91 3e
L_0EB8:  CALL L_0E4D              ; 0EB8 cd 4d 0e
L_0EBB:  MOV  A,M                 ; 0EBB 7e
L_0EBC:  STA  L_10E8              ; 0EBC 32 e8 10
L_0EBF:  LXI  H,A887h             ; 0EBF 21 87 a8
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
L_0ED9:  LXI  H,B689h             ; 0ED9 21 89 b6
L_0EDC:  CALL L_0E47              ; 0EDC cd 47 0e
L_0EDF:  MOV  A,M                 ; 0EDF 7e
L_0EE0:  PUSH PSW                 ; 0EE0 f5
L_0EE1:  LXI  H,A88Ah             ; 0EE1 21 8a a8
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
         LXI  H,B67Dh             ; 0EFE 21 7d b6
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
L_0F20:  LXI  H,B685h             ; 0F20 21 85 b6
L_0F23:  CALL L_0E47              ; 0F23 cd 47 0e
L_0F26:  MOV  E,M                 ; 0F26 5e
L_0F27:  INX  H                   ; 0F27 23
L_0F28:  MOV  D,M                 ; 0F28 56
L_0F29:  LXI  H,1102h             ; 0F29 21 02 11
L_0F2C:  CALL L_0E00              ; 0F2C cd 00 0e
L_0F2F:  LXI  H,10E1h             ; 0F2F 21 e1 10
L_0F32:  RST  3                   ; 0F32 df
L_0F33:  LXI  H,B689h             ; 0F33 21 89 b6
L_0F36:  CALL L_0E47              ; 0F36 cd 47 0e
L_0F39:  XRA  A                   ; 0F39 af
L_0F3A:  CMP  M                   ; 0F3A be
L_0F3B:  RNZ                      ; 0F3B c0
         LXI  H,B685h             ; 0F3C 21 85 b6
         CALL L_0E47              ; 0F3F cd 47 0e
         XRA  A                   ; 0F42 af
         CMP  M                   ; 0F43 be
         RNZ                      ; 0F44 c0
         INX  H                   ; 0F45 23
         CMP  M                   ; 0F46 be
         RNZ                      ; 0F47 c0
         LDA  B69Dh               ; 0F48 3a 9d b6
         MOV  C,A                 ; 0F4B 4f
         MVI  A,06h               ; 0F4C 3e 06
L_0F4E:  ADI  28h                 ; 0F4E c6 28
         DCR  C                   ; 0F50 0d
         JNZ  L_0F4E              ; 0F51 c2 4e 0f
         STA  L_111F              ; 0F54 32 1f 11
         LXI  H,111Ch             ; 0F57 21 1c 11
         RST  3                   ; 0F5A df
         RET                      ; 0F5B c9
L_0F5C:  CALL L_0F70              ; 0F5C cd 70 0f
         MVI  C,20h               ; 0F5F 0e 20
         RST  4                   ; 0F61 e7
         MOV  A,M                 ; 0F62 7e
         CALL L_0E18              ; 0F63 cd 18 0e
         LXI  H,10C3h             ; 0F66 21 c3 10
         RST  3                   ; 0F69 df
         RET                      ; 0F6A c9
L_0F6B:  MOV  A,M                 ; 0F6B 7e
L_0F6C:  INX  H                   ; 0F6C 23
L_0F6D:  JMP  L_0F75              ; 0F6D c3 75 0f
L_0F70:  LHLD A842h               ; 0F70 2a 42 a8
L_0F73:  MVI  A,0Ch               ; 0F73 3e 0c
L_0F75:  MOV  C,M                 ; 0F75 4e
L_0F76:  CALL F809h               ; 0F76 cd 09 f8
L_0F79:  INX  H                   ; 0F79 23
L_0F7A:  DCR  A                   ; 0F7A 3d
L_0F7B:  JNZ  L_0F75              ; 0F7B c2 75 0f
L_0F7E:  RET                      ; 0F7E c9
L_0F7F:  MVI  C,8Dh               ; 0F7F 0e 8d
L_0F81:  RST  4                   ; 0F81 e7
L_0F82:  DCR  A                   ; 0F82 3d
L_0F83:  JNZ  L_0F81              ; 0F83 c2 81 0f
L_0F86:  RET                      ; 0F86 c9
         .db 3Ah,9Dh,B6h,3Dh,CAh,95h,0Fh,6Fh,26h,00h,22h,91h,B6h,C9h,3Eh,02h ; 0F87 |:..=...o&."...>.|
         .db C3h,8Eh,0Fh                                      ; 0F97 |...|
L_0F9A:  LXI  H,1135h             ; 0F9A 21 35 11
L_0F9D:  RST  3                   ; 0F9D df
L_0F9E:  LDA  B68Fh               ; 0F9E 3a 8f b6
L_0FA1:  DCR  A                   ; 0FA1 3d
L_0FA2:  JZ   L_0FB1              ; 0FA2 ca b1 0f
L_0FA5:  LXI  H,113Ah             ; 0FA5 21 3a 11
L_0FA8:  MVI  A,01h               ; 0FA8 3e 01
L_0FAA:  STA  B68Fh               ; 0FAA 32 8f b6
L_0FAD:  RST  3                   ; 0FAD df
L_0FAE:  JMP  L_0FF3              ; 0FAE c3 f3 0f
L_0FB1:  LXI  H,118Eh             ; 0FB1 21 8e 11
         MVI  A,02h               ; 0FB4 3e 02
         JMP  L_0FAA              ; 0FB6 c3 aa 0f
         .db 21h,63h,B6h,11h,0Bh,00h,19h,7Eh,E6h,7Fh,77h,23h,7Eh,E6h,7Fh,77h ; 0FB9 |!c.....~..w#~..w|
         .db C9h                                              ; 0FC9 |.|
L_0FCA:  CALL L_0FD0              ; 0FCA cd d0 0f
         CALL L_091B              ; 0FCD cd 1b 09
L_0FD0:  LDA  B69Dh               ; 0FD0 3a 9d b6
         DCR  A                   ; 0FD3 3d
         JZ   L_0FDB              ; 0FD4 ca db 0f
L_0FD7:  STA  B69Dh               ; 0FD7 32 9d b6
         RET                      ; 0FDA c9
L_0FDB:  MVI  A,02h               ; 0FDB 3e 02
         JMP  L_0FD7              ; 0FDD c3 d7 0f
L_0FE0:  CALL L_0FF3              ; 0FE0 cd f3 0f
L_0FE3:  MVI  C,20h               ; 0FE3 0e 20
L_0FE5:  MVI  A,47h               ; 0FE5 3e 47
L_0FE7:  JMP  L_0FF0              ; 0FE7 c3 f0 0f
         .db CDh,F3h,0Fh,0Eh,09h,79h                          ; 0FEA |.....y|
L_0FF0:  CALL L_0F81              ; 0FF0 cd 81 0f
L_0FF3:  LXI  H,2337h             ; 0FF3 21 37 23
L_0FF6:  JMP  L_2071              ; 0FF6 c3 71 20
L_0FF9:  LXI  H,3E37h             ; 0FF9 21 37 3e
         JMP  L_2071              ; 0FFC c3 71 20
L_0FFF:  CALL L_0FF9              ; 0FFF cd f9 0f
         MVI  C,09h               ; 1002 0e 09
         MVI  A,06h               ; 1004 3e 06
         JMP  L_0F81              ; 1006 c3 81 0f
L_1009:  CALL L_13CB              ; 1009 cd cb 13
         LXI  H,11E4h             ; 100C 21 e4 11
         RST  3                   ; 100F df
         LXI  H,DF14h             ; 1010 21 14 df
         MOV  A,M                 ; 1013 7e
         INX  H                   ; 1014 23
         CALL L_0F75              ; 1015 cd 75 0f
         MVI  C,19h               ; 1018 0e 19
         RST  4                   ; 101A e7
L_101B:  LDA  L_3E8F              ; 101B 3a 8f 3e
L_101E:  MVI  C,0Eh               ; 101E 0e 0e
L_1020:  CPI  53h                 ; 1020 fe 53
L_1022:  JZ   F809h               ; 1022 ca 09 f8
L_1025:  INR  C                   ; 1025 0c
L_1026:  CPI  54h                 ; 1026 fe 54
L_1028:  JZ   F809h               ; 1028 ca 09 f8
L_102B:  LXI  H,11DEh             ; 102B 21 de 11
L_102E:  CPI  38h                 ; 102E fe 38
L_1030:  JZ   F818h               ; 1030 ca 18 f8
         LXI  H,11E1h             ; 1033 21 e1 11
         RST  3                   ; 1036 df
         RET                      ; 1037 c9
L_1038:  CALL L_0242              ; 1038 cd 42 02
L_103B:  MVI  A,43h               ; 103B 3e 43
L_103D:  STA  B673h               ; 103D 32 73 b6
L_1040:  MVI  A,01h               ; 1040 3e 01
L_1042:  STA  B68Dh               ; 1042 32 8d b6
L_1045:  CALL L_12A7              ; 1045 cd a7 12
L_1048:  LDA  B68Dh               ; 1048 3a 8d b6
L_104B:  ORA  A                   ; 104B b7
L_104C:  RZ                       ; 104C c8
L_104D:  MVI  A,41h               ; 104D 3e 41
L_104F:  STA  B673h               ; 104F 32 73 b6
L_1052:  CALL L_12A7              ; 1052 cd a7 12
L_1055:  LDA  B68Dh               ; 1055 3a 8d b6
L_1058:  ORA  A                   ; 1058 b7
L_1059:  RZ                       ; 1059 c8
         LDA  L_3E97              ; 105A 3a 97 3e
         CPI  59h                 ; 105D fe 59
         CZ   L_107E              ; 105F cc 7e 10
         LDA  B68Dh               ; 1062 3a 8d b6
         ORA  A                   ; 1065 b7
         RZ                       ; 1066 c8
         CALL L_0FF3              ; 1067 cd f3 0f
         LXI  H,1086h             ; 106A 21 86 10
         RST  3                   ; 106D df
         LXI  H,B663h             ; 106E 21 63 b6
         CALL L_0F73              ; 1071 cd 73 0f
         LXI  H,108Ch             ; 1074 21 8c 10
         RST  3                   ; 1077 df
         CALL L_0D44              ; 1078 cd 44 0d
         JMP  L_0FE0              ; 107B c3 e0 0f
L_107E:  MVI  A,42h               ; 107E 3e 42
         STA  B673h               ; 1080 32 73 b6
         JMP  L_12A7              ; 1083 c3 a7 12
         .db E6h,C1h,CAh,CCh,20h,00h,20h,CEh,C5h,20h,CEh,C1h,CAh,C4h,C5h,CEh ; 1086 |.... . .. ......|
         .db 00h,1Bh,62h,00h,1Bh,61h,00h,1Bh,59h,37h,20h,55h,58h,3Eh,00h,EBh ; 1096 |..b..a..Y7 UX>..|
         .db CFh,D0h,C9h,D2h,D5h,C5h,D4h,D3h,D1h,00h,00h,00h,2Dh,CAh,20h,C6h ; 10A6 |............-. .|
         .db C1h,CAh,CCh,20h,58h,3Ah,3Dh,3Eh,59h,3Ah,08h,08h,00h,00h,00h,00h ; 10B6 |... X:=>Y:......|
         .db 4Bh,00h,18h,00h,00h,00h,4Bh,18h,18h,1Bh,59h,22h,00h,00h,08h,1Ah ; 10C6 |K.....K...Y"....|
         .db 00h,3Ah,09h,55h,73h,65h,72h,20h,58h,08h,00h,20h,E4h,C9h,D3h,CBh ; 10D6 |.:.User X.. ....|
         .db 20h,00h,00h,20h,E6h,C1h,CAh,CCh,CFh,D7h,20h,00h,00h,00h,00h,00h ; 10E6 | .. ...... .....|
         .db 00h,20h,20h,F3h,D7h,CFh,C2h,CFh,C4h,CEh,CFh,20h,00h,00h,00h,20h ; 10F6 |.  ........ ... |
         .db EBh,C2h,2Eh,00h,1Bh,59h,36h,00h,00h,1Bh,62h,00h,00h,00h,2Fh,00h ; 1106 |.....Y6...b.../.|
         .db 00h,00h,20h,1Bh,61h,00h,1Bh,59h,28h,20h,1Bh,62h,20h,E4h,C9h,D3h ; 1116 |.. .a..Y( .b ...|
         .db CBh,20h,45h,72h,72h,6Fh,72h,20h,1Bh,61h,1Bh,59h,20h,48h,00h,1Bh ; 1126 |. Error .a.Y H..|
         .db 59h,38h,20h,00h,1Bh,62h,31h,2Dh,F0h,CFh,CDh,CFh,DDh,D8h,20h,32h ; 1136 |Y8 ..b1-...... 2|
         .db 2Dh,EDh,C5h,CEh,C0h,20h,33h,2Dh,F0h,D2h,CFh,D3h,CDh,2Eh,34h,2Dh ; 1146 |-.... 3-......4-|
         .db EDh,65h,64h,69h,74h,20h,35h,2Dh,EBh,CFh,D0h,C9h,D1h,20h,36h,2Dh ; 1156 |.edit 5-..... 6-|
         .db E9h,CDh,D1h,20h,37h,2Dh,E4h,C9h,D3h,CBh,20h,38h,2Dh,F5h,C2h,D2h ; 1166 |... 7-.... 8-...|
         .db C1h,D4h,D8h,20h,39h,2Dh,53h,79h,73h,2Eh,D0h,D2h,CDh,20h,30h,2Dh ; 1176 |... 9-Sys.... 0-|
         .db EDh,CFh,CEh,C9h,D4h,1Bh,61h,00h,31h,2Dh,34h,30h,2Fh,36h,30h,20h ; 1186 |......a.1-40/60 |
         .db 32h,2Dh,E1h,D4h,D2h,C9h,C2h,2Eh,33h,2Dh,F0h,D2h,EBh,37h,20h,34h ; 1196 |2-......3-...7 4|
         .db 2Dh,57h,6Fh,72h,64h,53h,74h,61h,72h,20h,35h,2Dh,EBh,D3h,FAh,E9h ; 11A6 |-WordStar 5-....|
         .db 20h,36h,2Dh,FAh,C1h,D0h,C9h,D3h,D8h,20h,37h,2Dh,F0h,C5h,DEh,C1h ; 11B6 | 6-...... 7-....|
         .db D4h,D8h,20h,38h,2Dh,E6h,C1h,CAh,CCh,20h,39h,2Dh,53h,69h,64h,20h ; 11C6 |.. 8-.... 9-Sid |
         .db 30h,2Dh,F7h,D9h,CAh,D4h,C9h,00h,1Bh,5Bh,00h,1Bh,5Ch,00h,0Ch,0Ah ; 11D6 |0-.......[..\...|
         .db 20h,3Eh,00h,1Bh,59h,37h,2Dh,00h,00h,00h,00h      ; 11E6 | >..Y7-....|
L_11F1:  LXI  H,0000h             ; 11F1 21 00 00
         SHLD A831h               ; 11F4 22 31 a8
         LDA  B69Bh               ; 11F7 3a 9b b6
         PUSH PSW                 ; 11FA f5
         LXI  H,B689h             ; 11FB 21 89 b6
         CALL L_0E47              ; 11FE cd 47 0e
         MOV  A,M                 ; 1201 7e
         MVI  C,00h               ; 1202 0e 00
L_1204:  STA  B69Bh               ; 1204 32 9b b6
         CALL L_29DF              ; 1207 cd df 29
         LXI  D,0008h             ; 120A 11 08 00
         DAD  D                   ; 120D 19
         MVI  A,7Fh               ; 120E 3e 7f
         CMP  M                   ; 1210 be
         CZ   L_1238              ; 1211 cc 38 12
         LDA  B69Bh               ; 1214 3a 9b b6
         DCR  A                   ; 1217 3d
         JNZ  L_1204              ; 1218 c2 04 12
         POP  PSW                 ; 121B f1
         STA  B69Bh               ; 121C 32 9b b6
         LXI  H,A943h             ; 121F 21 43 a9
         PUSH B                   ; 1222 c5
         CALL L_0E47              ; 1223 cd 47 0e
         POP  B                   ; 1226 c1
         MOV  M,C                 ; 1227 71
         LHLD A831h               ; 1228 2a 31 a8
         XCHG                     ; 122B eb
         LXI  H,A947h             ; 122C 21 47 a9
         PUSH D                   ; 122F d5
         CALL L_0E47              ; 1230 cd 47 0e
         POP  D                   ; 1233 d1
         MOV  M,E                 ; 1234 73
         INX  H                   ; 1235 23
         MOV  M,D                 ; 1236 72
         RET                      ; 1237 c9
L_1238:  INR  C                   ; 1238 0c
         LXI  D,0004h             ; 1239 11 04 00
         DAD  D                   ; 123C 19
         MOV  E,M                 ; 123D 5e
         MVI  D,00h               ; 123E 16 00
         LHLD A831h               ; 1240 2a 31 a8
         DAD  D                   ; 1243 19
         SHLD A831h               ; 1244 22 31 a8
         RET                      ; 1247 c9
         .db 2Ah,38h,A8h,F9h                                  ; 1248 |*8..|
L_124C:  LHLD A83Ah               ; 124C 2a 3a a8
L_124F:  SHLD F80Ah               ; 124F 22 0a f8
L_1252:  MVI  A,FFh               ; 1252 3e ff
L_1254:  CPI  FFh                 ; 1254 fe ff
L_1256:  RET                      ; 1256 c9
L_1257:  LXI  D,0080h             ; 1257 11 80 00
L_125A:  MVI  C,1Ah               ; 125A 0e 1a
L_125C:  RST  1                   ; 125C cf
L_125D:  RET                      ; 125D c9
L_125E:  LDA  A889h               ; 125E 3a 89 a8
L_1261:  CPI  00h                 ; 1261 fe 00
L_1263:  JZ   L_124C              ; 1263 ca 4c 12
         MVI  E,00h               ; 1266 1e 00
         CALL L_13D7              ; 1268 cd d7 13
         CALL L_1257              ; 126B cd 57 12
         MVI  C,11h               ; 126E 0e 11
         CALL L_19AD              ; 1270 cd ad 19
         LHLD A83Ah               ; 1273 2a 3a a8
         SHLD F80Ah               ; 1276 22 0a f8
         CPI  FFh                 ; 1279 fe ff
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
L_12AB:  SHLD A838h               ; 12AB 22 38 a8
L_12AE:  LHLD F80Ah               ; 12AE 2a 0a f8
L_12B1:  SHLD A83Ah               ; 12B1 22 3a a8
L_12B4:  LXI  H,1248h             ; 12B4 21 48 12
L_12B7:  SHLD F80Ah               ; 12B7 22 0a f8
L_12BA:  LXI  H,B663h             ; 12BA 21 63 b6
L_12BD:  CALL L_19BB              ; 12BD cd bb 19
L_12C0:  MVI  C,11h               ; 12C0 0e 11
L_12C2:  CALL L_19AD              ; 12C2 cd ad 19
L_12C5:  CPI  FFh                 ; 12C5 fe ff
L_12C7:  JZ   L_125E              ; 12C7 ca 5e 12
L_12CA:  LHLD A83Ah               ; 12CA 2a 3a a8
L_12CD:  SHLD F80Ah               ; 12CD 22 0a f8
L_12D0:  XRA  A                   ; 12D0 af
L_12D1:  STA  B68Dh               ; 12D1 32 8d b6
L_12D4:  LXI  H,353Bh             ; 12D4 21 3b 35
L_12D7:  JMP  L_19BB              ; 12D7 c3 bb 19
         .db 21h,00h,00h,22h,83h,A8h,CDh,57h,12h,CDh,DFh,29h,21h,91h,3Eh,CDh ; 12DA |!.."...W...)!.>.|
         .db 4Dh,0Eh,7Eh,32h,73h,B6h,CDh,B8h,19h,3Eh,3Fh,32h,68h,00h,0Eh,11h ; 12EA |M.~2s....>?2h...|
         .db C3h,FFh,12h,0Eh,12h,CDh,ADh,19h,FEh,FFh,CAh,22h,13h,3Ch,4Fh,AFh ; 12FA |...........".<O.|
         .db 47h,C6h,20h,0Dh,C2h,0Bh,13h,C6h,6Fh,4Fh,0Ah,4Fh,2Ah,83h,A8h,09h ; 130A |G. .....oO.O*...|
         .db 22h,83h,A8h,FEh,80h,CAh,FDh,12h                  ; 131A |".......|
L_1322:  LHLD A883h               ; 1322 2a 83 a8
         CALL L_1345              ; 1325 cd 45 13
         LHLD A842h               ; 1328 2a 42 a8
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
         LXI  D,CF2Ch             ; 1349 11 2c cf
         CALL L_3441              ; 134C cd 41 34
         STA  L_1F42              ; 134F 32 42 1f
         LXI  D,FB1Eh             ; 1352 11 1e fb
         CALL L_3441              ; 1355 cd 41 34
         STA  L_1F43              ; 1358 32 43 1f
         LXI  D,FF83h             ; 135B 11 83 ff
         CALL L_3441              ; 135E cd 41 34
         STA  L_1F44              ; 1361 32 44 1f
         DAD  H                   ; 1364 29
         DAD  H                   ; 1365 29
         DAD  H                   ; 1366 29
         LXI  D,FF9Ch             ; 1367 11 9c ff
         CALL L_3441              ; 136A cd 41 34
         STA  L_1F46              ; 136D 32 46 1f
         LXI  D,FFF6h             ; 1370 11 f6 ff
         CALL L_3441              ; 1373 cd 41 34
         STA  L_1F47              ; 1376 32 47 1f
         LXI  D,FFFFh             ; 1379 11 ff ff
         CALL L_3441              ; 137C cd 41 34
         STA  L_1F48              ; 137F 32 48 1f
         LXI  H,1F42h             ; 1382 21 42 1f
L_1385:  MOV  A,M                 ; 1385 7e
         CPI  30h                 ; 1386 fe 30
         RNZ                      ; 1388 c0
         MVI  M,20h               ; 1389 36 20
         INX  H                   ; 138B 23
         JMP  L_1385              ; 138C c3 85 13
         .db CDh,73h,14h,3Ah,51h,A8h,3Dh,C2h,ACh,13h,3Eh,0Eh,C3h,ACh,13h,CDh ; 138F |.s.:Q.=...>.....|
         .db 73h,14h,3Ah,51h,A8h,3Ch,FEh,0Fh,C2h,ACh,13h,3Eh,01h ; 139F |s.:Q.<.....>.|
L_13AC:  STA  A851h               ; 13AC 32 51 a8
         LXI  H,0000h             ; 13AF 21 00 00
         LXI  D,0048h             ; 13B2 11 48 00
L_13B5:  DAD  D                   ; 13B5 19
         DCR  A                   ; 13B6 3d
         JNZ  L_13B5              ; 13B7 c2 b5 13
         LXI  D,A010h             ; 13BA 11 10 a0
         DAD  D                   ; 13BD 19
         PUSH H                   ; 13BE e5
         LXI  D,DF14h             ; 13BF 11 14 df
         MVI  C,47h               ; 13C2 0e 47
         RST  5                   ; 13C4 ef
         POP  H                   ; 13C5 e1
L_13C6:  MOV  A,M                 ; 13C6 7e
         INX  H                   ; 13C7 23
         JMP  L_2A02              ; 13C8 c3 02 2a
L_13CB:  MVI  E,00h               ; 13CB 1e 00
         CALL L_13D7              ; 13CD cd d7 13
         CALL L_13DB              ; 13D0 cd db 13
L_13D3:  LDA  A889h               ; 13D3 3a 89 a8
L_13D6:  MOV  E,A                 ; 13D6 5f
L_13D7:  MVI  C,20h               ; 13D7 0e 20
L_13D9:  RST  1                   ; 13D9 cf
L_13DA:  RET                      ; 13DA c9
L_13DB:  LDA  B672h               ; 13DB 3a 72 b6
         CPI  59h                 ; 13DE fe 59
         JNZ  L_1409              ; 13E0 c2 09 14
         MVI  A,43h               ; 13E3 3e 43
         STA  B673h               ; 13E5 32 73 b6
         LXI  H,1F66h             ; 13E8 21 66 1f
         SHLD A842h               ; 13EB 22 42 a8
         CALL L_19B8              ; 13EE cd b8 19
         LXI  H,DF14h             ; 13F1 21 14 df
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
         LXI  D,0080h             ; 140C 11 80 00
         CALL L_17F4              ; 140F cd f4 17
         XRA  A                   ; 1412 af
         STA  007Ch               ; 1413 32 7c 00
         LDA  L_3E91              ; 1416 3a 91 3e
         ANI  03h                 ; 1419 e6 03
         MOV  C,A                 ; 141B 4f
         LDA  A887h               ; 141C 3a 87 a8
         RLC                      ; 141F 07
         RLC                      ; 1420 07
         ADD  C                   ; 1421 81
         STA  L_3E91              ; 1422 32 91 3e
         LDA  L_3E92              ; 1425 3a 92 3e
         ANI  03h                 ; 1428 e6 03
         MOV  C,A                 ; 142A 4f
         LDA  A888h               ; 142B 3a 88 a8
         RLC                      ; 142E 07
         RLC                      ; 142F 07
         ADD  C                   ; 1430 81
         STA  L_3E92              ; 1431 32 92 3e
         LXI  D,A000h             ; 1434 11 00 a0
         MVI  A,09h               ; 1437 3e 09
         STAX D                   ; 1439 12
         INX  D                   ; 143A 13
         LXI  H,3E8Dh             ; 143B 21 8d 3e
         MVI  C,0Bh               ; 143E 0e 0b
         RST  5                   ; 1440 ef
         LXI  H,1F7Dh             ; 1441 21 7d 1f
         MVI  C,03h               ; 1444 0e 03
         RST  5                   ; 1446 ef
         LDA  B69Dh               ; 1447 3a 9d b6
         STAX D                   ; 144A 12
         LXI  D,A010h             ; 144B 11 10 a0
         LXI  H,DF14h             ; 144E 21 14 df
         MVI  C,47h               ; 1451 0e 47
         RST  5                   ; 1453 ef
         MVI  C,0Fh               ; 1454 0e 0f
         CALL L_19AD              ; 1456 cd ad 19
         MVI  C,08h               ; 1459 0e 08
         LXI  D,A000h             ; 145B 11 00 a0
L_145E:  LXI  H,0080h             ; 145E 21 80 00
L_1461:  CALL L_17F4              ; 1461 cd f4 17
         CALL L_1947              ; 1464 cd 47 19
         XCHG                     ; 1467 eb
         DAD  D                   ; 1468 19
         XCHG                     ; 1469 eb
         DCR  C                   ; 146A 0d
         JNZ  L_1461              ; 146B c2 61 14
         MVI  C,10h               ; 146E 0e 10
         JMP  L_19AD              ; 1470 c3 ad 19
L_1473:  MVI  C,10h               ; 1473 0e 10
L_1475:  CALL L_19AD              ; 1475 cd ad 19
L_1478:  MVI  A,43h               ; 1478 3e 43
L_147A:  STA  B673h               ; 147A 32 73 b6
L_147D:  LXI  H,1F5Ah             ; 147D 21 5a 1f
L_1480:  SHLD A842h               ; 1480 22 42 a8
L_1483:  CALL L_19B8              ; 1483 cd b8 19
L_1486:  MVI  C,0Fh               ; 1486 0e 0f
L_1488:  CALL L_19AD              ; 1488 cd ad 19
L_148B:  CPI  FFh                 ; 148B fe ff
L_148D:  RZ                       ; 148D c8
L_148E:  LXI  D,A048h             ; 148E 11 48 a0
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
L_14B7:  STA  A94Eh               ; 14B7 32 4e a9
L_14BA:  LXI  H,000Eh             ; 14BA 21 0e 00
L_14BD:  SHLD A851h               ; 14BD 22 51 a8
L_14C0:  MVI  A,4Eh               ; 14C0 3e 4e
L_14C2:  STA  B672h               ; 14C2 32 72 b6
L_14C5:  CALL L_19E2              ; 14C5 cd e2 19
L_14C8:  CALL L_1473              ; 14C8 cd 73 14
L_14CB:  CPI  FFh                 ; 14CB fe ff
L_14CD:  RZ                       ; 14CD c8
L_14CE:  LXI  H,A048h             ; 14CE 21 48 a0
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
L_14E3:  STA  A94Eh               ; 14E3 32 4e a9
L_14E6:  XRA  A                   ; 14E6 af
L_14E7:  STA  A94Fh               ; 14E7 32 4f a9
L_14EA:  LDA  L_3E91              ; 14EA 3a 91 3e
L_14ED:  MOV  C,A                 ; 14ED 4f
L_14EE:  ANI  03h                 ; 14EE e6 03
L_14F0:  ADI  40h                 ; 14F0 c6 40
L_14F2:  STA  L_3E91              ; 14F2 32 91 3e
L_14F5:  MOV  A,C                 ; 14F5 79
L_14F6:  RRC                      ; 14F6 0f
L_14F7:  RRC                      ; 14F7 0f
L_14F8:  ANI  0Fh                 ; 14F8 e6 0f
L_14FA:  STA  A887h               ; 14FA 32 87 a8
L_14FD:  LDA  L_3E92              ; 14FD 3a 92 3e
L_1500:  MOV  C,A                 ; 1500 4f
L_1501:  ANI  03h                 ; 1501 e6 03
L_1503:  ADI  40h                 ; 1503 c6 40
L_1505:  STA  L_3E92              ; 1505 32 92 3e
L_1508:  MOV  A,C                 ; 1508 79
L_1509:  RRC                      ; 1509 0f
L_150A:  RRC                      ; 150A 0f
L_150B:  ANI  0Fh                 ; 150B e6 0f
L_150D:  STA  A888h               ; 150D 32 88 a8
L_1510:  LXI  H,A887h             ; 1510 21 87 a8
L_1513:  LDA  A94Eh               ; 1513 3a 4e a9
L_1516:  DCR  A                   ; 1516 3d
L_1517:  JZ   L_151B              ; 1517 ca 1b 15
L_151A:  INX  H                   ; 151A 23
L_151B:  MOV  A,M                 ; 151B 7e
L_151C:  STA  A889h               ; 151C 32 89 a8
L_151F:  LXI  H,1F7Bh             ; 151F 21 7b 1f
L_1522:  MVI  A,04h               ; 1522 3e 04
L_1524:  JMP  L_2A02              ; 1524 c3 02 2a
         .db CDh,B8h,19h,3Ah,65h,00h,E6h,80h,C4h,3Fh,15h,3Ah,66h,00h,E6h,80h ; 1527 |...:e....?.:f...|
         .db C4h,6Dh,15h,0Eh,13h,C3h,ADh,19h,3Ah,65h,00h,E6h,7Fh,32h,65h,00h ; 1537 |.m......:e...2e.|
         .db CDh,E0h,0Fh,21h,80h,1Fh,CDh,13h,0Dh,21h,5Dh,00h,DFh,21h,85h,1Fh ; 1547 |...!.....!]..!..|
         .db CDh,13h,0Dh,21h,8Fh,1Fh,CDh,13h,0Dh,CDh,58h,19h,C2h,6Bh,15h,0Eh ; 1557 |...!......X..k..|
         .db 1Eh,C3h,ADh,19h,E1h,C9h,3Ah,66h,00h,E6h,7Fh,32h,66h,00h,CDh,E0h ; 1567 |......:f...2f...|
         .db 0Fh,21h,80h,1Fh,CDh,13h,0Dh,21h,5Dh,00h,CDh,13h,0Dh,21h,9Fh,1Fh ; 1577 |.!.....!]....!..|
         .db C3h,57h,15h                                      ; 1587 |.W.|
L_158A:  LXI  H,0000h             ; 158A 21 00 00
L_158D:  SHLD A83Eh               ; 158D 22 3e a8
L_1590:  CALL L_18E5              ; 1590 cd e5 18
L_1593:  LXI  H,A000h             ; 1593 21 00 a0
L_1596:  SHLD A83Eh               ; 1596 22 3e a8
L_1599:  RET                      ; 1599 c9
L_159A:  LDA  A849h               ; 159A 3a 49 a8
L_159D:  LHLD A84Dh               ; 159D 2a 4d a8
L_15A0:  CALL L_19BE              ; 15A0 cd be 19
L_15A3:  LDA  L_1FAA              ; 15A3 3a aa 1f
L_15A6:  MOV  E,A                 ; 15A6 5f
L_15A7:  CALL L_13D7              ; 15A7 cd d7 13
L_15AA:  MVI  C,16h               ; 15AA 0e 16
L_15AC:  LXI  D,005Ch             ; 15AC 11 5c 00
L_15AF:  RST  1                   ; 15AF cf
L_15B0:  ORA  A                   ; 15B0 b7
L_15B1:  JP   L_15BD              ; 15B1 f2 bd 15
         CALL L_1638              ; 15B4 cd 38 16
         PUSH PSW                 ; 15B7 f5
         CALL L_0FFF              ; 15B8 cd ff 0f
         POP  PSW                 ; 15BB f1
         RNZ                      ; 15BC c0
L_15BD:  XRA  A                   ; 15BD af
L_15BE:  STA  006Ah               ; 15BE 32 6a 00
L_15C1:  CALL L_13D3              ; 15C1 cd d3 13
L_15C4:  LDA  A84Ah               ; 15C4 3a 4a a8
L_15C7:  SUI  40h                 ; 15C7 d6 40
L_15C9:  STA  A809h               ; 15C9 32 09 a8
L_15CC:  LHLD A84Fh               ; 15CC 2a 4f a8
L_15CF:  LXI  D,A80Ah             ; 15CF 11 0a a8
L_15D2:  CALL L_19C5              ; 15D2 cd c5 19
L_15D5:  LXI  H,6100h             ; 15D5 21 00 61
L_15D8:  SHLD L_17E7              ; 15D8 22 e7 17
L_15DB:  CALL L_168B              ; 15DB cd 8b 16
L_15DE:  DCR  C                   ; 15DE 0d
L_15DF:  RP                       ; 15DF f0
L_15E0:  LXI  H,6100h             ; 15E0 21 00 61
L_15E3:  SHLD L_17E7              ; 15E3 22 e7 17
L_15E6:  PUSH PSW                 ; 15E6 f5
L_15E7:  CALL L_174F              ; 15E7 cd 4f 17
L_15EA:  DCR  C                   ; 15EA 0d
L_15EB:  RP                       ; 15EB f0
L_15EC:  LXI  D,005Ch             ; 15EC 11 5c 00
L_15EF:  LDA  L_1FAA              ; 15EF 3a aa 1f
L_15F2:  STAX D                   ; 15F2 12
L_15F3:  CALL L_1D7C              ; 15F3 cd 7c 1d
L_15F6:  LXI  H,0068h             ; 15F6 21 68 00
L_15F9:  INR  M                   ; 15F9 34
L_15FA:  INX  H                   ; 15FA 23
L_15FB:  MVI  C,13h               ; 15FB 0e 13
L_15FD:  XRA  A                   ; 15FD af
L_15FE:  CALL L_1E75              ; 15FE cd 75 1e
L_1601:  POP  PSW                 ; 1601 f1
L_1602:  ORA  A                   ; 1602 b7
L_1603:  JM   L_15D5              ; 1603 fa d5 15
L_1606:  LDA  L_3E90              ; 1606 3a 90 3e
L_1609:  CPI  59h                 ; 1609 fe 59
L_160B:  RNZ                      ; 160B c0
         LDA  L_1FAA              ; 160C 3a aa 1f
         MOV  E,A                 ; 160F 5f
         CALL L_13D7              ; 1610 cd d7 13
         LDA  A849h               ; 1613 3a 49 a8
         STA  005Ch               ; 1616 32 5c 00
         CALL L_0B6B              ; 1619 cd 6b 0b
L_161C:  LXI  H,6100h             ; 161C 21 00 61
         SHLD L_17E7              ; 161F 22 e7 17
         LXI  H,005Ch             ; 1622 21 5c 00
         LDA  A849h               ; 1625 3a 49 a8
         CALL L_1691              ; 1628 cd 91 16
         DCR  C                   ; 162B 0d
         JC   L_161C              ; 162C da 1c 16
         CALL L_13D3              ; 162F cd d3 13
         LDA  A84Ah               ; 1632 3a 4a a8
         JMP  L_0B6B              ; 1635 c3 6b 0b
L_1638:  CALL L_196A              ; 1638 cd 6a 19
         LXI  H,1FB7h             ; 163B 21 b7 1f
         CALL L_1953              ; 163E cd 53 19
         RNZ                      ; 1641 c0
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
L_168B:  LXI  H,A809h             ; 168B 21 09 a8
L_168E:  LDA  A84Ah               ; 168E 3a 4a a8
L_1691:  STA  L_169E              ; 1691 32 9e 16
L_1694:  MOV  D,H                 ; 1694 54
L_1695:  MOV  E,L                 ; 1695 5d
L_1696:  PUSH H                   ; 1696 e5
L_1697:  MVI  C,0Fh               ; 1697 0e 0f
L_1699:  RST  1                   ; 1699 cf
L_169A:  POP  H                   ; 169A e1
L_169B:  INR  A                   ; 169B 3c
L_169C:  RZ                       ; 169C c8
L_169D:  MVI  A,00h               ; 169D 3e 00
L_169F:  SUI  41h                 ; 169F d6 41
L_16A1:  STA  DDF0h               ; 16A1 32 f0 dd
L_16A4:  LXI  D,000Fh             ; 16A4 11 0f 00
L_16A7:  DAD  D                   ; 16A7 19
L_16A8:  MOV  A,M                 ; 16A8 7e
L_16A9:  MOV  C,A                 ; 16A9 4f
L_16AA:  ORA  A                   ; 16AA b7
L_16AB:  PUSH H                   ; 16AB e5
L_16AC:  LXI  D,0011h             ; 16AC 11 11 00
L_16AF:  DAD  D                   ; 16AF 19
L_16B0:  CNZ  L_16BD              ; 16B0 c4 bd 16
L_16B3:  POP  H                   ; 16B3 e1
L_16B4:  MOV  A,M                 ; 16B4 7e
L_16B5:  ORA  A                   ; 16B5 b7
L_16B6:  RP                       ; 16B6 f0
L_16B7:  LXI  D,FFFDh             ; 16B7 11 fd ff
L_16BA:  DAD  D                   ; 16BA 19
L_16BB:  INR  M                   ; 16BB 34
L_16BC:  RET                      ; 16BC c9
L_16BD:  PUSH B                   ; 16BD c5
L_16BE:  PUSH H                   ; 16BE e5
L_16BF:  CALL L_17E6              ; 16BF cd e6 17
L_16C2:  POP  H                   ; 16C2 e1
L_16C3:  PUSH H                   ; 16C3 e5
L_16C4:  MOV  A,M                 ; 16C4 7e
L_16C5:  INR  M                   ; 16C5 34
L_16C6:  ANI  07h                 ; 16C6 e6 07
L_16C8:  JZ   L_1701              ; 16C8 ca 01 17
L_16CB:  LDA  DDF5h               ; 16CB 3a f5 dd
L_16CE:  INR  A                   ; 16CE 3c
L_16CF:  STA  DDF5h               ; 16CF 32 f5 dd
L_16D2:  CALL C027h               ; 16D2 cd 27 c0
L_16D5:  POP  H                   ; 16D5 e1
L_16D6:  POP  B                   ; 16D6 c1
L_16D7:  ORA  A                   ; 16D7 b7
L_16D8:  JNZ  L_1742              ; 16D8 c2 42 17
L_16DB:  DCR  C                   ; 16DB 0d
L_16DC:  JNZ  L_16BD              ; 16DC c2 bd 16
L_16DF:  RET                      ; 16DF c9
L_16E0:  MOV  A,M                 ; 16E0 7e
L_16E1:  LXI  B,FFF0h             ; 16E1 01 f0 ff
L_16E4:  DAD  B                   ; 16E4 09
L_16E5:  ANI  78h                 ; 16E5 e6 78
L_16E7:  RRC                      ; 16E7 0f
L_16E8:  RRC                      ; 16E8 0f
L_16E9:  RRC                      ; 16E9 0f
L_16EA:  MOV  C,A                 ; 16EA 4f
L_16EB:  MVI  B,00h               ; 16EB 06 00
L_16ED:  DAD  B                   ; 16ED 09
L_16EE:  RET                      ; 16EE c9
L_16EF:  LDA  DDF5h               ; 16EF 3a f5 dd
L_16F2:  INR  A                   ; 16F2 3c
L_16F3:  CPI  29h                 ; 16F3 fe 29
L_16F5:  JNZ  L_16CF              ; 16F5 c2 cf 16
L_16F8:  LXI  H,DDF4h             ; 16F8 21 f4 dd
L_16FB:  INR  M                   ; 16FB 34
L_16FC:  MVI  A,01h               ; 16FC 3e 01
L_16FE:  JMP  L_16CF              ; 16FE c3 cf 16
L_1701:  MOV  A,M                 ; 1701 7e
L_1702:  ANI  0Eh                 ; 1702 e6 0e
L_1704:  JNZ  L_16EF              ; 1704 c2 ef 16
L_1707:  CALL L_16E0              ; 1707 cd e0 16
L_170A:  MOV  E,M                 ; 170A 5e
L_170B:  INX  H                   ; 170B 23
L_170C:  MOV  D,M                 ; 170C 56
L_170D:  CALL L_171F              ; 170D cd 1f 17
L_1710:  JMP  L_16CF              ; 1710 c3 cf 16
         .db CDh,E0h,16h,7Eh,32h,F4h,DDh,3Eh,01h,C3h,CFh,16h  ; 1713 |...~2..>....|
L_171F:  XCHG                     ; 171F eb
L_1720:  DAD  H                   ; 1720 29
L_1721:  XCHG                     ; 1721 eb
L_1722:  LXI  B,FB00h             ; 1722 01 00 fb
L_1725:  XRA  A                   ; 1725 af
L_1726:  CMC                      ; 1726 3f
L_1727:  MOV  H,D                 ; 1727 62
L_1728:  MOV  L,E                 ; 1728 6b
L_1729:  RAL                      ; 1729 17
L_172A:  JC   L_1737              ; 172A da 37 17
L_172D:  DAD  H                   ; 172D 29
L_172E:  MOV  D,H                 ; 172E 54
L_172F:  MOV  E,L                 ; 172F 5d
L_1730:  DAD  B                   ; 1730 09
L_1731:  JNC  L_1727              ; 1731 d2 27 17
L_1734:  JMP  L_1729              ; 1734 c3 29 17
L_1737:  ADI  08h                 ; 1737 c6 08
L_1739:  STA  DDF4h               ; 1739 32 f4 dd
L_173C:  MOV  A,H                 ; 173C 7c
L_173D:  RLC                      ; 173D 07
L_173E:  RLC                      ; 173E 07
L_173F:  RLC                      ; 173F 07
L_1740:  INR  A                   ; 1740 3c
L_1741:  RET                      ; 1741 c9
L_1742:  PUSH B                   ; 1742 c5
         LXI  H,1FFBh             ; 1743 21 fb 1f
         RST  3                   ; 1746 df
         CALL L_0D44              ; 1747 cd 44 0d
         CALL L_0FE0              ; 174A cd e0 0f
         POP  B                   ; 174D c1
         RET                      ; 174E c9
L_174F:  MOV  C,A                 ; 174F 4f
L_1750:  LDA  A849h               ; 1750 3a 49 a8
L_1753:  SUI  41h                 ; 1753 d6 41
L_1755:  STA  DDF0h               ; 1755 32 f0 dd
L_1758:  MOV  A,C                 ; 1758 79
L_1759:  ORA  A                   ; 1759 b7
L_175A:  RZ                       ; 175A c8
L_175B:  PUSH B                   ; 175B c5
L_175C:  CALL L_17E6              ; 175C cd e6 17
L_175F:  LXI  H,006Bh             ; 175F 21 6b 00
L_1762:  MOV  A,M                 ; 1762 7e
L_1763:  INR  M                   ; 1763 34
L_1764:  ANI  07h                 ; 1764 e6 07
L_1766:  JZ   L_179B              ; 1766 ca 9b 17
L_1769:  LDA  DDF5h               ; 1769 3a f5 dd
L_176C:  INR  A                   ; 176C 3c
L_176D:  STA  DDF5h               ; 176D 32 f5 dd
L_1770:  CALL C02Ah               ; 1770 cd 2a c0
L_1773:  POP  B                   ; 1773 c1
L_1774:  DCR  C                   ; 1774 0d
L_1775:  JNZ  L_175B              ; 1775 c2 5b 17
L_1778:  RET                      ; 1778 c9
L_1779:  POP  B                   ; 1779 c1
         JMP  L_17CF              ; 177A c3 cf 17
L_177D:  LDA  DDF5h               ; 177D 3a f5 dd
         INR  A                   ; 1780 3c
         CPI  29h                 ; 1781 fe 29
         JNZ  L_176D              ; 1783 c2 6d 17
         LXI  H,DDF4h             ; 1786 21 f4 dd
         INR  M                   ; 1789 34
         MVI  A,01h               ; 178A 3e 01
         JMP  L_176D              ; 178C c3 6d 17
L_178F:  CALL L_17AC              ; 178F cd ac 17
L_1792:  MOV  A,E                 ; 1792 7b
L_1793:  STA  DDF4h               ; 1793 32 f4 dd
L_1796:  MVI  A,01h               ; 1796 3e 01
L_1798:  JMP  L_176D              ; 1798 c3 6d 17
L_179B:  MOV  A,M                 ; 179B 7e
         ANI  0Eh                 ; 179C e6 0e
         JNZ  L_177D              ; 179E c2 7d 17
         CALL L_17AC              ; 17A1 cd ac 17
         INX  H                   ; 17A4 23
         MOV  M,D                 ; 17A5 72
         CALL L_171F              ; 17A6 cd 1f 17
         JMP  L_176D              ; 17A9 c3 6d 17
L_17AC:  LXI  H,A101h             ; 17AC 21 01 a1
L_17AF:  INX  H                   ; 17AF 23
L_17B0:  MOV  A,M                 ; 17B0 7e
L_17B1:  ORA  A                   ; 17B1 b7
L_17B2:  JZ   L_1779              ; 17B2 ca 79 17
L_17B5:  CPI  53h                 ; 17B5 fe 53
L_17B7:  JNZ  L_17AF              ; 17B7 c2 af 17
L_17BA:  MVI  M,5Ah               ; 17BA 36 5a
L_17BC:  SHLD L_17AD              ; 17BC 22 ad 17
L_17BF:  MOV  A,H                 ; 17BF 7c
L_17C0:  SUI  A1h                 ; 17C0 d6 a1
L_17C2:  MOV  D,A                 ; 17C2 57
L_17C3:  MOV  E,L                 ; 17C3 5d
L_17C4:  LDA  006Bh               ; 17C4 3a 6b 00
L_17C7:  LXI  H,006Ch             ; 17C7 21 6c 00
L_17CA:  CALL L_16E5              ; 17CA cd e5 16
L_17CD:  MOV  M,E                 ; 17CD 73
L_17CE:  RET                      ; 17CE c9
L_17CF:  PUSH B                   ; 17CF c5
         CALL L_0FF3              ; 17D0 cd f3 0f
         LXI  H,1FEFh             ; 17D3 21 ef 1f
         RST  3                   ; 17D6 df
         MVI  C,13h               ; 17D7 0e 13
         CALL L_19AD              ; 17D9 cd ad 19
         MVI  A,03h               ; 17DC 3e 03
         STA  B68Dh               ; 17DE 32 8d b6
         CALL L_0D44              ; 17E1 cd 44 0d
         POP  B                   ; 17E4 c1
         RET                      ; 17E5 c9
L_17E6:  LXI  H,0000h             ; 17E6 21 00 00
L_17E9:  SHLD DDF6h               ; 17E9 22 f6 dd
L_17EC:  LXI  B,0080h             ; 17EC 01 80 00
L_17EF:  DAD  B                   ; 17EF 09
L_17F0:  SHLD L_17E7              ; 17F0 22 e7 17
L_17F3:  RET                      ; 17F3 c9
L_17F4:  PUSH H                   ; 17F4 e5
L_17F5:  PUSH D                   ; 17F5 d5
L_17F6:  PUSH B                   ; 17F6 c5
L_17F7:  MVI  C,1Ah               ; 17F7 0e 1a
L_17F9:  RST  1                   ; 17F9 cf
L_17FA:  POP  B                   ; 17FA c1
L_17FB:  POP  D                   ; 17FB d1
L_17FC:  POP  H                   ; 17FC e1
L_17FD:  RET                      ; 17FD c9
L_17FE:  LHLD A83Eh               ; 17FE 2a 3e a8
L_1801:  MOV  A,L                 ; 1801 7d
L_1802:  ANI  7Fh                 ; 1802 e6 7f
L_1804:  STA  007Ch               ; 1804 32 7c 00
L_1807:  RET                      ; 1807 c9
L_1808:  CALL L_19B8              ; 1808 cd b8 19
L_180B:  LHLD A83Eh               ; 180B 2a 3e a8
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
L_1824:  SHLD A853h               ; 1824 22 53 a8
L_1827:  LXI  H,0000h             ; 1827 21 00 00
L_182A:  SHLD B68Dh               ; 182A 22 8d b6
L_182D:  SHLD A83Eh               ; 182D 22 3e a8
L_1830:  LXI  H,B663h             ; 1830 21 63 b6
L_1833:  SHLD A842h               ; 1833 22 42 a8
L_1836:  LXI  H,A000h             ; 1836 21 00 a0
L_1839:  SHLD A855h               ; 1839 22 55 a8
L_183C:  CALL L_1808              ; 183C cd 08 18
L_183F:  CALL L_187A              ; 183F cd 7a 18
L_1842:  JMP  L_18E0              ; 1842 c3 e0 18
L_1845:  LDA  A83Eh               ; 1845 3a 3e a8
L_1848:  ANI  7Fh                 ; 1848 e6 7f
L_184A:  CPI  7Eh                 ; 184A fe 7e
L_184C:  JNZ  L_17FE              ; 184C c2 fe 17
         CALL L_18E0              ; 184F cd e0 18
         JMP  L_1808              ; 1852 c3 08 18
L_1855:  LDA  B68Dh               ; 1855 3a 8d b6
L_1858:  CPI  00h                 ; 1858 fe 00
L_185A:  LHLD A83Eh               ; 185A 2a 3e a8
L_185D:  JZ   L_1865              ; 185D ca 65 18
L_1860:  DCX  H                   ; 1860 2b
L_1861:  DCX  H                   ; 1861 2b
L_1862:  JMP  L_1867              ; 1862 c3 67 18
L_1865:  INX  H                   ; 1865 23
L_1866:  INX  H                   ; 1866 23
L_1867:  SHLD A83Eh               ; 1867 22 3e a8
L_186A:  CALL L_1872              ; 186A cd 72 18
L_186D:  XRA  A                   ; 186D af
L_186E:  STA  B68Dh               ; 186E 32 8d b6
L_1871:  RET                      ; 1871 c9
L_1872:  LDA  B68Dh               ; 1872 3a 8d b6
L_1875:  CPI  00h                 ; 1875 fe 00
L_1877:  CNZ  L_1845              ; 1877 c4 45 18
L_187A:  LXI  D,A000h             ; 187A 11 00 a0
L_187D:  CALL L_17F4              ; 187D cd f4 17
L_1880:  CALL L_1922              ; 1880 cd 22 19
L_1883:  CPI  00h                 ; 1883 fe 00
L_1885:  JNZ  L_1897              ; 1885 c2 97 18
L_1888:  LXI  D,A080h             ; 1888 11 80 a0
L_188B:  CALL L_17F4              ; 188B cd f4 17
L_188E:  CALL L_1922              ; 188E cd 22 19
L_1891:  CPI  00h                 ; 1891 fe 00
L_1893:  JNZ  L_18A4              ; 1893 c2 a4 18
L_1896:  RET                      ; 1896 c9
L_1897:  LXI  H,A000h             ; 1897 21 00 a0
         MVI  C,00h               ; 189A 0e 00
L_189C:  MVI  M,1Ah               ; 189C 36 1a
         INX  H                   ; 189E 23
         DCR  C                   ; 189F 0d
         JNZ  L_189C              ; 18A0 c2 9c 18
         RET                      ; 18A3 c9
L_18A4:  LXI  H,A080h             ; 18A4 21 80 a0
         MVI  C,80h               ; 18A7 0e 80
         JMP  L_189C              ; 18A9 c3 9c 18
L_18AC:  LXI  H,B663h             ; 18AC 21 63 b6
         SHLD A842h               ; 18AF 22 42 a8
         LXI  H,0000h             ; 18B2 21 00 00
         SHLD A83Eh               ; 18B5 22 3e a8
         CALL L_1808              ; 18B8 cd 08 18
         LXI  D,A000h             ; 18BB 11 00 a0
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
L_18DD:  STA  A886h               ; 18DD 32 86 a8
L_18E0:  MVI  C,10h               ; 18E0 0e 10
L_18E2:  JMP  L_19AD              ; 18E2 c3 ad 19
L_18E5:  CALL L_1808              ; 18E5 cd 08 18
L_18E8:  LXI  D,A000h             ; 18E8 11 00 a0
L_18EB:  JMP  L_18C3              ; 18EB c3 c3 18
L_18EE:  CALL L_1808              ; 18EE cd 08 18
         LXI  D,6100h             ; 18F1 11 00 61
         JMP  L_18C3              ; 18F4 c3 c3 18
L_18F7:  MOV  A,C                 ; 18F7 79
L_18F8:  JMP  L_18DD              ; 18F8 c3 dd 18
         .db 2Ah,3Ah,A8h,22h,0Ah,F8h,2Ah,38h,A8h,F9h,CDh,E0h,0Fh,3Ah,73h,B6h ; 18FB |*:."..*8.....:s.|
         .db 4Fh,E7h,0Eh,3Ah,E7h,CDh,70h,19h,21h,FBh,1Fh,DFh,CDh,44h,0Dh,CDh ; 190B |O..:..p.!....D..|
         .db E0h,0Fh,3Eh,FFh,C3h,43h,19h                      ; 191B |..>..C.|
L_1922:  PUSH H                   ; 1922 e5
L_1923:  PUSH D                   ; 1923 d5
L_1924:  PUSH B                   ; 1924 c5
L_1925:  LXI  H,0000h             ; 1925 21 00 00
L_1928:  DAD  SP                  ; 1928 39
L_1929:  SHLD A838h               ; 1929 22 38 a8
L_192C:  LHLD F80Ah               ; 192C 2a 0a f8
L_192F:  SHLD A83Ah               ; 192F 22 3a a8
L_1932:  LXI  H,18FBh             ; 1932 21 fb 18
L_1935:  SHLD F80Ah               ; 1935 22 0a f8
L_1938:  MVI  C,14h               ; 1938 0e 14
L_193A:  CALL L_19AD              ; 193A cd ad 19
L_193D:  LHLD A83Ah               ; 193D 2a 3a a8
L_1940:  SHLD F80Ah               ; 1940 22 0a f8
L_1943:  POP  B                   ; 1943 c1
L_1944:  POP  D                   ; 1944 d1
L_1945:  POP  H                   ; 1945 e1
L_1946:  RET                      ; 1946 c9
L_1947:  PUSH H                   ; 1947 e5
         PUSH D                   ; 1948 d5
         PUSH B                   ; 1949 c5
         MVI  C,15h               ; 194A 0e 15
         CALL L_19AD              ; 194C cd ad 19
         POP  B                   ; 194F c1
         POP  D                   ; 1950 d1
         POP  H                   ; 1951 e1
         RET                      ; 1952 c9
L_1953:  RST  3                   ; 1953 df
         LXI  H,1FC2h             ; 1954 21 c2 1f
         RST  3                   ; 1957 df
L_1958:  CALL L_0D44              ; 1958 cd 44 0d
         LXI  H,1FDAh             ; 195B 21 da 1f
         CPI  59h                 ; 195E fe 59
         JZ   L_1966              ; 1960 ca 66 19
         LXI  H,1FDEh             ; 1963 21 de 1f
L_1966:  PUSH PSW                 ; 1966 f5
         RST  3                   ; 1967 df
         POP  PSW                 ; 1968 f1
         RET                      ; 1969 c9
L_196A:  CALL L_0FF9              ; 196A cd f9 0f
         JMP  L_1970              ; 196D c3 70 19
L_1970:  LXI  H,005Dh             ; 1970 21 5d 00
         MVI  C,08h               ; 1973 0e 08
L_1975:  MOV  A,M                 ; 1975 7e
         CALL L_19DB              ; 1976 cd db 19
         INX  H                   ; 1979 23
         DCR  C                   ; 197A 0d
         JNZ  L_1975              ; 197B c2 75 19
         MVI  A,20h               ; 197E 3e 20
         CALL L_19DB              ; 1980 cd db 19
         MVI  C,03h               ; 1983 0e 03
L_1985:  MOV  A,M                 ; 1985 7e
         CALL L_19DB              ; 1986 cd db 19
         INX  H                   ; 1989 23
         DCR  C                   ; 198A 0d
         JNZ  L_1985              ; 198B c2 85 19
         RET                      ; 198E c9
L_198F:  CALL L_19B8              ; 198F cd b8 19
         MVI  C,16h               ; 1992 0e 16
         CALL L_19AD              ; 1994 cd ad 19
         ORA  A                   ; 1997 b7
         JP   L_199F              ; 1998 f2 9f 19
         CALL L_1638              ; 199B cd 38 16
         RNZ                      ; 199E c0
L_199F:  MVI  A,59h               ; 199F 3e 59
         RET                      ; 19A1 c9
         .db CDh,8Fh,19h,32h,48h,A8h,FEh,59h,C0h,0Eh,13h      ; 19A2 |...2H..Y...|
L_19AD:  LXI  D,005Ch             ; 19AD 11 5c 00
L_19B0:  RST  1                   ; 19B0 cf
L_19B1:  RET                      ; 19B1 c9
L_19B2:  LXI  H,B654h             ; 19B2 21 54 b6
         SHLD A842h               ; 19B5 22 42 a8
L_19B8:  LHLD A842h               ; 19B8 2a 42 a8
L_19BB:  LDA  B673h               ; 19BB 3a 73 b6
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
         PUSH B                   ; 19DC c5
         MOV  C,A                 ; 19DD 4f
         RST  4                   ; 19DE e7
         POP  B                   ; 19DF c1
         POP  PSW                 ; 19E0 f1
         RET                      ; 19E1 c9
L_19E2:  MVI  E,02h               ; 19E2 1e 02
L_19E4:  MVI  C,0Eh               ; 19E4 0e 0e
L_19E6:  RST  1                   ; 19E6 cf
L_19E7:  RET                      ; 19E7 c9
L_19E8:  LXI  H,A887h             ; 19E8 21 87 a8
L_19EB:  CALL L_0E4D              ; 19EB cd 4d 0e
L_19EE:  MOV  E,M                 ; 19EE 5e
L_19EF:  CALL L_13D7              ; 19EF cd d7 13
L_19F2:  CALL L_19E2              ; 19F2 cd e2 19
L_19F5:  LXI  H,0000h             ; 19F5 21 00 00
L_19F8:  SHLD DEC1h               ; 19F8 22 c1 de
L_19FB:  CALL L_1257              ; 19FB cd 57 12
L_19FE:  LXI  H,0000h             ; 19FE 21 00 00
L_1A01:  DAD  SP                  ; 1A01 39
L_1A02:  SHLD A838h               ; 1A02 22 38 a8
L_1A05:  LHLD F80Ah               ; 1A05 2a 0a f8
L_1A08:  SHLD A83Ah               ; 1A08 22 3a a8
L_1A0B:  LXI  H,1C00h             ; 1A0B 21 00 1c
L_1A0E:  SHLD F80Ah               ; 1A0E 22 0a f8
L_1A11:  LXI  H,3E91h             ; 1A11 21 91 3e
L_1A14:  CALL L_0E4D              ; 1A14 cd 4d 0e
L_1A17:  MOV  A,M                 ; 1A17 7e
L_1A18:  SUI  41h                 ; 1A18 d6 41
L_1A1A:  MVI  C,0Eh               ; 1A1A 0e 0e
L_1A1C:  MOV  E,A                 ; 1A1C 5f
L_1A1D:  ADD  A                   ; 1A1D 87
L_1A1E:  ADI  96h                 ; 1A1E c6 96
L_1A20:  MOV  L,A                 ; 1A20 6f
L_1A21:  MVI  H,DEh               ; 1A21 26 de
L_1A23:  MOV  A,M                 ; 1A23 7e
L_1A24:  STA  L_1DF3              ; 1A24 32 f3 1d
L_1A27:  RST  1                   ; 1A27 cf
L_1A28:  LXI  H,A943h             ; 1A28 21 43 a9
L_1A2B:  CALL L_0E47              ; 1A2B cd 47 0e
L_1A2E:  SHLD L_1A41              ; 1A2E 22 41 1a
L_1A31:  LXI  H,A947h             ; 1A31 21 47 a9
L_1A34:  CALL L_0E47              ; 1A34 cd 47 0e
L_1A37:  SHLD L_1A44              ; 1A37 22 44 1a
L_1A3A:  CALL L_20CA              ; 1A3A cd ca 20
L_1A3D:  LXI  H,0000h             ; 1A3D 21 00 00
L_1A40:  SHLD 0000h               ; 1A40 22 00 00
L_1A43:  SHLD 0000h               ; 1A43 22 00 00
L_1A46:  SHLD A86Fh               ; 1A46 22 6f a8
L_1A49:  SHLD A871h               ; 1A49 22 71 a8
L_1A4C:  SHLD A881h               ; 1A4C 22 81 a8
L_1A4F:  LHLD A842h               ; 1A4F 2a 42 a8
L_1A52:  SHLD A873h               ; 1A52 22 73 a8
L_1A55:  LXI  B,FFF3h             ; 1A55 01 f3 ff
L_1A58:  DAD  B                   ; 1A58 09
L_1A59:  SHLD L_1B3D              ; 1A59 22 3d 1b
L_1A5C:  LXI  H,3E91h             ; 1A5C 21 91 3e
L_1A5F:  CALL L_0E4D              ; 1A5F cd 4d 0e
L_1A62:  MOV  A,M                 ; 1A62 7e
L_1A63:  SUI  41h                 ; 1A63 d6 41
L_1A65:  STA  A876h               ; 1A65 32 76 a8
L_1A68:  MVI  C,1Fh               ; 1A68 0e 1f
L_1A6A:  RST  1                   ; 1A6A cf
L_1A6B:  INX  H                   ; 1A6B 23
L_1A6C:  INX  H                   ; 1A6C 23
L_1A6D:  INX  H                   ; 1A6D 23
L_1A6E:  MOV  A,M                 ; 1A6E 7e
L_1A6F:  STA  A875h               ; 1A6F 32 75 a8
L_1A72:  CALL L_1DD6              ; 1A72 cd d6 1d
L_1A75:  JMP  L_1A7F              ; 1A75 c3 7f 1a
L_1A78:  PUSH B                   ; 1A78 c5
L_1A79:  PUSH D                   ; 1A79 d5
L_1A7A:  CALL L_1E0A              ; 1A7A cd 0a 1e
L_1A7D:  POP  D                   ; 1A7D d1
L_1A7E:  POP  B                   ; 1A7E c1
L_1A7F:  ORA  A                   ; 1A7F b7
L_1A80:  JM   L_1AEF              ; 1A80 fa ef 1a
L_1A83:  LHLD A86Fh               ; 1A83 2a 6f a8
L_1A86:  INX  H                   ; 1A86 23
L_1A87:  SHLD A86Fh               ; 1A87 22 6f a8
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
L_1A9F:  LDA  A875h               ; 1A9F 3a 75 a8
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
L_1AB5:  ANI  F0h                 ; 1AB5 e6 f0
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
L_1AD1:  LHLD A873h               ; 1AD1 2a 73 a8
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
L_1AE2:  SHLD A873h               ; 1AE2 22 73 a8
L_1AE5:  LHLD A871h               ; 1AE5 2a 71 a8
L_1AE8:  INX  H                   ; 1AE8 23
L_1AE9:  SHLD A871h               ; 1AE9 22 71 a8
L_1AEC:  JMP  L_1A78              ; 1AEC c3 78 1a
L_1AEF:  CALL L_19E2              ; 1AEF cd e2 19
L_1AF2:  LHLD A871h               ; 1AF2 2a 71 a8
L_1AF5:  SHLD A87Dh               ; 1AF5 22 7d a8
L_1AF8:  LXI  H,3E95h             ; 1AF8 21 95 3e
L_1AFB:  CALL L_0E4D              ; 1AFB cd 4d 0e
L_1AFE:  MOV  A,M                 ; 1AFE 7e
L_1AFF:  ANI  F0h                 ; 1AFF e6 f0
L_1B01:  CPI  40h                 ; 1B01 fe 40
L_1B03:  JZ   L_1C41              ; 1B03 ca 41 1c
L_1B06:  CPI  10h                 ; 1B06 fe 10
L_1B08:  CNZ  L_1B63              ; 1B08 c4 63 1b
L_1B0B:  LHLD A87Dh               ; 1B0B 2a 7d a8
L_1B0E:  MOV  A,H                 ; 1B0E 7c
L_1B0F:  ORA  A                   ; 1B0F b7
L_1B10:  RAR                      ; 1B10 1f
L_1B11:  MOV  H,A                 ; 1B11 67
L_1B12:  MOV  A,L                 ; 1B12 7d
L_1B13:  RAR                      ; 1B13 1f
L_1B14:  MOV  L,A                 ; 1B14 6f
L_1B15:  SHLD A87Dh               ; 1B15 22 7d a8
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
L_1B24:  LHLD A871h               ; 1B24 2a 71 a8
L_1B27:  DAD  D                   ; 1B27 19
L_1B28:  SHLD A87Bh               ; 1B28 22 7b a8
L_1B2B:  LXI  H,0001h             ; 1B2B 21 01 00
L_1B2E:  SHLD A879h               ; 1B2E 22 79 a8
L_1B31:  SHLD A877h               ; 1B31 22 77 a8
L_1B34:  XCHG                     ; 1B34 eb
L_1B35:  LHLD A87Dh               ; 1B35 2a 7d a8
L_1B38:  DAD  D                   ; 1B38 19
L_1B39:  CALL L_1B59              ; 1B39 cd 59 1b
L_1B3C:  LXI  B,0000h             ; 1B3C 01 00 00
L_1B3F:  DAD  B                   ; 1B3F 09
L_1B40:  XCHG                     ; 1B40 eb
L_1B41:  LHLD A877h               ; 1B41 2a 77 a8
L_1B44:  PUSH D                   ; 1B44 d5
L_1B45:  CALL L_1B59              ; 1B45 cd 59 1b
L_1B48:  JMP  L_1B91              ; 1B48 c3 91 1b
         .db 09h,01h,0Ah,00h,09h,EBh,E1h,09h,EBh,06h,03h,C3h,95h,1Bh ; 1B4B |..............|
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
         SHLD L_1B49              ; 1B66 22 49 1b
         CPI  20h                 ; 1B69 fe 20
         JZ   L_1B7F              ; 1B6B ca 7f 1b
         LXI  H,000Ch             ; 1B6E 21 0c 00
         SHLD L_1B4D              ; 1B71 22 4d 1b
         XRA  A                   ; 1B74 af
         STA  L_1B55              ; 1B75 32 55 1b
         LXI  H,FFF3h             ; 1B78 21 f3 ff
         SHLD L_1BA4              ; 1B7B 22 a4 1b
         RET                      ; 1B7E c9
L_1B7F:  LXI  H,0009h             ; 1B7F 21 09 00
         SHLD L_1B4D              ; 1B82 22 4d 1b
         MVI  A,03h               ; 1B85 3e 03
         STA  L_1B55              ; 1B87 32 55 1b
         LXI  H,FFF4h             ; 1B8A 21 f4 ff
         SHLD L_1BA4              ; 1B8D 22 a4 1b
         RET                      ; 1B90 c9
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
         LXI  B,FFF2h             ; 1BA3 01 f2 ff
         DAD  B                   ; 1BA6 09
         XCHG                     ; 1BA7 eb
         DAD  B                   ; 1BA8 09
         XCHG                     ; 1BA9 eb
         MVI  B,0Ch               ; 1BAA 06 0c
         JMP  L_1B95              ; 1BAC c3 95 1b
L_1BAF:  LHLD A879h               ; 1BAF 2a 79 a8
L_1BB2:  INX  H                   ; 1BB2 23
L_1BB3:  SHLD A879h               ; 1BB3 22 79 a8
L_1BB6:  XCHG                     ; 1BB6 eb
L_1BB7:  LHLD A87Bh               ; 1BB7 2a 7b a8
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
L_1BD0:  MVI  B,FFh               ; 1BD0 06 ff
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
L_1BE3:  LHLD A87Dh               ; 1BE3 2a 7d a8
L_1BE6:  MOV  A,H                 ; 1BE6 7c
L_1BE7:  CMA                      ; 1BE7 2f
L_1BE8:  MOV  D,A                 ; 1BE8 57
L_1BE9:  MOV  A,L                 ; 1BE9 7d
L_1BEA:  CMA                      ; 1BEA 2f
L_1BEB:  MOV  E,A                 ; 1BEB 5f
L_1BEC:  INX  D                   ; 1BEC 13
L_1BED:  LHLD A877h               ; 1BED 2a 77 a8
L_1BF0:  DAD  D                   ; 1BF0 19
L_1BF1:  SHLD A877h               ; 1BF1 22 77 a8
L_1BF4:  XRA  A                   ; 1BF4 af
L_1BF5:  ORA  H                   ; 1BF5 b4
L_1BF6:  JM   L_1BAF              ; 1BF6 fa af 1b
L_1BF9:  ORA  L                   ; 1BF9 b5
L_1BFA:  JZ   L_1BAF              ; 1BFA ca af 1b
L_1BFD:  JMP  L_1B34              ; 1BFD c3 34 1b
         .db 2Ah,3Ah,A8h,22h,0Ah,F8h,2Ah,38h,A8h,F9h,CDh,E2h,19h,21h,89h,B6h ; 1C00 |*:."..*8.....!..|
         .db CDh,47h,0Eh,36h,00h,21h,7Dh,B6h,CDh,47h,0Eh,36h,00h,21h,85h,B6h ; 1C10 |.G.6.!}..G.6.!..|
         .db CDh,47h,0Eh,36h,00h,23h,36h,00h,C9h              ; 1C20 |.G.6.#6..|
L_1C29:  LXI  B,0001h             ; 1C29 01 01 00
L_1C2C:  CALL C01Eh               ; 1C2C cd 1e c0
L_1C2F:  LXI  B,0008h             ; 1C2F 01 08 00
L_1C32:  CALL C021h               ; 1C32 cd 21 c0
L_1C35:  CALL C027h               ; 1C35 cd 27 c0
L_1C38:  MVI  A,65h               ; 1C38 3e 65
L_1C3A:  NOP                      ; 1C3A 00
L_1C3B:  DCR  A                   ; 1C3B 3d
L_1C3C:  CPI  64h                 ; 1C3C fe 64
L_1C3E:  JZ   L_1CAB              ; 1C3E ca ab 1c
L_1C41:  LXI  H,1B91h             ; 1C41 21 91 1b
L_1C44:  SHLD L_1B49              ; 1C44 22 49 1b
L_1C47:  LHLD A83Ah               ; 1C47 2a 3a a8
L_1C4A:  SHLD F80Ah               ; 1C4A 22 0a f8
L_1C4D:  LXI  H,B689h             ; 1C4D 21 89 b6
L_1C50:  CALL L_0E47              ; 1C50 cd 47 0e
L_1C53:  SHLD L_1CAF              ; 1C53 22 af 1c
L_1C56:  LXI  H,B67Dh             ; 1C56 21 7d b6
L_1C59:  CALL L_0E47              ; 1C59 cd 47 0e
L_1C5C:  SHLD L_1CB5              ; 1C5C 22 b5 1c
L_1C5F:  LXI  H,B685h             ; 1C5F 21 85 b6
L_1C62:  CALL L_0E47              ; 1C62 cd 47 0e
L_1C65:  SHLD L_1CD9              ; 1C65 22 d9 1c
L_1C68:  MVI  C,02h               ; 1C68 0e 02
L_1C6A:  CALL C01Bh               ; 1C6A cd 1b c0
L_1C6D:  LXI  B,A100h             ; 1C6D 01 00 a1
L_1C70:  CALL C024h               ; 1C70 cd 24 c0
L_1C73:  LXI  B,0000h             ; 1C73 01 00 00
L_1C76:  CALL C01Eh               ; 1C76 cd 1e c0
L_1C79:  LXI  B,0001h             ; 1C79 01 01 00
L_1C7C:  CALL C021h               ; 1C7C cd 21 c0
L_1C7F:  CALL C027h               ; 1C7F cd 27 c0
L_1C82:  MVI  A,02h               ; 1C82 3e 02
L_1C84:  NOP                      ; 1C84 00
L_1C85:  DCR  A                   ; 1C85 3d
L_1C86:  DCR  A                   ; 1C86 3d
L_1C87:  JZ   L_1C29              ; 1C87 ca 29 1c
         MVI  C,00h               ; 1C8A 0e 00
         CALL C01Bh               ; 1C8C cd 1b c0
         LXI  B,000Bh             ; 1C8F 01 0b 00
         CALL C01Eh               ; 1C92 cd 1e c0
         LXI  B,0029h             ; 1C95 01 29 00
         CALL C021h               ; 1C98 cd 21 c0
         LXI  B,A180h             ; 1C9B 01 80 a1
         CALL C024h               ; 1C9E cd 24 c0
L_1CA1:  CALL C027h               ; 1CA1 cd 27 c0
         ORA  A                   ; 1CA4 b7
         JNZ  L_1CA1              ; 1CA5 c2 a1 1c
         CALL A180h               ; 1CA8 cd 80 a1
L_1CAB:  LHLD A871h               ; 1CAB 2a 71 a8
L_1CAE:  SHLD 0000h               ; 1CAE 22 00 00
L_1CB1:  LHLD A881h               ; 1CB1 2a 81 a8
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
L_1CDB:  LXI  H,A88Ah             ; 1CDB 21 8a a8
L_1CDE:  CALL L_0E4D              ; 1CDE cd 4d 0e
L_1CE1:  MVI  M,00h               ; 1CE1 36 00
L_1CE3:  LXI  H,0000h             ; 1CE3 21 00 00
L_1CE6:  DAD  SP                  ; 1CE6 39
L_1CE7:  LXI  SP,FFF0h            ; 1CE7 31 f0 ff
L_1CEA:  MVI  A,40h               ; 1CEA 3e 40
L_1CEC:  DCR  A                   ; 1CEC 3d
L_1CED:  OUT  10h                 ; 1CED d3 10
L_1CEF:  POP  D                   ; 1CEF d1
L_1CF0:  MVI  A,22h               ; 1CF0 3e 22
L_1CF2:  INR  A                   ; 1CF2 3c
L_1CF3:  OUT  10h                 ; 1CF3 d3 10
L_1CF5:  SPHL                     ; 1CF5 f9
L_1CF6:  MOV  A,D                 ; 1CF6 7a
L_1CF7:  MVI  C,0Ah               ; 1CF7 0e 0a
L_1CF9:  DCR  A                   ; 1CF9 3d
L_1CFA:  DCR  C                   ; 1CFA 0d
L_1CFB:  JNZ  L_1CF9              ; 1CFB c2 f9 1c
L_1CFE:  ORA  A                   ; 1CFE b7
L_1CFF:  JNZ  L_1CFA              ; 1CFF c2 fa 1c
L_1D02:  JMP  L_1D43              ; 1D02 c3 43 1d
L_1D05:  LXI  H,A88Ah             ; 1D05 21 8a a8
         CALL L_0E4D              ; 1D08 cd 4d 0e
         INR  M                   ; 1D0B 34
         CALL L_20CA              ; 1D0C cd ca 20
         LHLD A842h               ; 1D0F 2a 42 a8
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
         LXI  B,FFE6h             ; 1D22 01 e6 ff
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
         LXI  H,B689h             ; 1D33 21 89 b6
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
L_1D5B:  LDA  A837h               ; 1D5B 3a 37 a8
L_1D5E:  CMP  E                   ; 1D5E bb
L_1D5F:  JZ   L_1D6F              ; 1D5F ca 6f 1d
L_1D62:  MOV  A,E                 ; 1D62 7b
L_1D63:  LXI  H,A88Ch             ; 1D63 21 8c a8
L_1D66:  MVI  C,40h               ; 1D66 0e 40
L_1D68:  CMP  M                   ; 1D68 be
L_1D69:  RZ                       ; 1D69 c8
L_1D6A:  INX  H                   ; 1D6A 23
L_1D6B:  DCR  C                   ; 1D6B 0d
L_1D6C:  JNZ  L_1D68              ; 1D6C c2 68 1d
L_1D6F:  CPI  14h                 ; 1D6F fe 14
L_1D71:  RET                      ; 1D71 c9
L_1D72:  LHLD A881h               ; 1D72 2a 81 a8
         INX  H                   ; 1D75 23
         SHLD A881h               ; 1D76 22 81 a8
         JMP  L_1AEC              ; 1D79 c3 ec 1a
L_1D7C:  PUSH D                   ; 1D7C d5
L_1D7D:  LXI  B,0080h             ; 1D7D 01 80 00
L_1D80:  CALL C024h               ; 1D80 cd 24 c0
L_1D83:  LXI  B,0008h             ; 1D83 01 08 00
L_1D86:  CALL C01Eh               ; 1D86 cd 1e c0
L_1D89:  MVI  C,00h               ; 1D89 0e 00
L_1D8B:  MVI  B,00h               ; 1D8B 06 00
L_1D8D:  MVI  A,E5h               ; 1D8D 3e e5
L_1D8F:  LXI  H,A88Ch             ; 1D8F 21 8c a8
L_1D92:  CMP  M                   ; 1D92 be
L_1D93:  JZ   L_1D9E              ; 1D93 ca 9e 1d
L_1D96:  INX  H                   ; 1D96 23
L_1D97:  INR  B                   ; 1D97 04
L_1D98:  DCR  C                   ; 1D98 0d
L_1D99:  JNZ  L_1D92              ; 1D99 c2 92 1d
         POP  D                   ; 1D9C d1
         RET                      ; 1D9D c9
L_1D9E:  SHLD L_1D90              ; 1D9E 22 90 1d
L_1DA1:  MOV  A,C                 ; 1DA1 79
L_1DA2:  STA  L_1D8A              ; 1DA2 32 8a 1d
L_1DA5:  MOV  A,B                 ; 1DA5 78
L_1DA6:  STA  L_1D8C              ; 1DA6 32 8c 1d
L_1DA9:  MOV  M,C                 ; 1DA9 71
L_1DAA:  PUSH PSW                 ; 1DAA f5
L_1DAB:  CALL L_1DC8              ; 1DAB cd c8 1d
L_1DAE:  POP  PSW                 ; 1DAE f1
L_1DAF:  POP  H                   ; 1DAF e1
L_1DB0:  ANI  03h                 ; 1DB0 e6 03
L_1DB2:  INR  A                   ; 1DB2 3c
L_1DB3:  MOV  C,A                 ; 1DB3 4f
L_1DB4:  MVI  A,60h               ; 1DB4 3e 60
L_1DB6:  ADI  20h                 ; 1DB6 c6 20
L_1DB8:  DCR  C                   ; 1DB8 0d
L_1DB9:  JNZ  L_1DB6              ; 1DB9 c2 b6 1d
L_1DBC:  MOV  E,A                 ; 1DBC 5f
L_1DBD:  MVI  D,00h               ; 1DBD 16 00
L_1DBF:  MVI  C,20h               ; 1DBF 0e 20
L_1DC1:  RST  5                   ; 1DC1 ef
L_1DC2:  JMP  C02Ah               ; 1DC2 c3 2a c0
L_1DC5:  LDA  A835h               ; 1DC5 3a 35 a8
L_1DC8:  ANI  7Ch                 ; 1DC8 e6 7c
L_1DCA:  RRC                      ; 1DCA 0f
L_1DCB:  RRC                      ; 1DCB 0f
L_1DCC:  INR  A                   ; 1DCC 3c
L_1DCD:  MOV  C,A                 ; 1DCD 4f
L_1DCE:  MVI  B,00h               ; 1DCE 06 00
L_1DD0:  CALL C021h               ; 1DD0 cd 21 c0
L_1DD3:  JMP  C027h               ; 1DD3 c3 27 c0
L_1DD6:  LXI  H,A887h             ; 1DD6 21 87 a8
L_1DD9:  CALL L_0E4D              ; 1DD9 cd 4d 0e
L_1DDC:  MOV  A,M                 ; 1DDC 7e
L_1DDD:  STA  A837h               ; 1DDD 32 37 a8
L_1DE0:  LXI  H,3E91h             ; 1DE0 21 91 3e
L_1DE3:  CALL L_0E4D              ; 1DE3 cd 4d 0e
L_1DE6:  MOV  A,M                 ; 1DE6 7e
L_1DE7:  CPI  43h                 ; 1DE7 fe 43
L_1DE9:  MVI  A,40h               ; 1DE9 3e 40
L_1DEB:  JZ   L_1DF0              ; 1DEB ca f0 1d
L_1DEE:  MVI  A,80h               ; 1DEE 3e 80
L_1DF0:  MVI  B,00h               ; 1DF0 06 00
L_1DF2:  MVI  C,00h               ; 1DF2 0e 00
L_1DF4:  PUSH PSW                 ; 1DF4 f5
L_1DF5:  STA  L_1D67              ; 1DF5 32 67 1d
L_1DF8:  CALL C01Eh               ; 1DF8 cd 1e c0
L_1DFB:  POP  PSW                 ; 1DFB f1
L_1DFC:  LXI  H,A88Ch             ; 1DFC 21 8c a8
L_1DFF:  INR  A                   ; 1DFF 3c
L_1E00:  STA  A836h               ; 1E00 32 36 a8
L_1E03:  SHLD A833h               ; 1E03 22 33 a8
L_1E06:  XRA  A                   ; 1E06 af
L_1E07:  STA  A835h               ; 1E07 32 35 a8
L_1E0A:  LXI  H,A835h             ; 1E0A 21 35 a8
L_1E0D:  INR  M                   ; 1E0D 34
L_1E0E:  LDA  A836h               ; 1E0E 3a 36 a8
L_1E11:  CMP  M                   ; 1E11 be
L_1E12:  MVI  A,FFh               ; 1E12 3e ff
L_1E14:  RZ                       ; 1E14 c8
L_1E15:  MOV  A,M                 ; 1E15 7e
L_1E16:  ANI  03h                 ; 1E16 e6 03
L_1E18:  CPI  01h                 ; 1E18 fe 01
L_1E1A:  CZ   L_1DC5              ; 1E1A cc c5 1d
L_1E1D:  LDA  A835h               ; 1E1D 3a 35 a8
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
L_1E37:  LHLD A833h               ; 1E37 2a 33 a8
L_1E3A:  MOV  M,A                 ; 1E3A 77
L_1E3B:  INX  H                   ; 1E3B 23
L_1E3C:  SHLD A833h               ; 1E3C 22 33 a8
L_1E3F:  MOV  E,A                 ; 1E3F 5f
L_1E40:  LDA  A837h               ; 1E40 3a 37 a8
L_1E43:  CMP  E                   ; 1E43 bb
L_1E44:  MOV  A,D                 ; 1E44 7a
L_1E45:  RZ                       ; 1E45 c8
L_1E46:  MOV  A,E                 ; 1E46 7b
L_1E47:  CPI  E5h                 ; 1E47 fe e5
L_1E49:  JNZ  L_1E0A              ; 1E49 c2 0a 1e
L_1E4C:  INX  B                   ; 1E4C 03
L_1E4D:  LDAX B                   ; 1E4D 0a
L_1E4E:  CPI  E5h                 ; 1E4E fe e5
L_1E50:  JNZ  L_1E0A              ; 1E50 c2 0a 1e
L_1E53:  LDA  A836h               ; 1E53 3a 36 a8
L_1E56:  MOV  C,A                 ; 1E56 4f
L_1E57:  LDA  A835h               ; 1E57 3a 35 a8
L_1E5A:  LHLD A833h               ; 1E5A 2a 33 a8
L_1E5D:  INR  A                   ; 1E5D 3c
L_1E5E:  CMP  C                   ; 1E5E b9
L_1E5F:  JZ   L_1E68              ; 1E5F ca 68 1e
L_1E62:  MVI  M,F5h               ; 1E62 36 f5
L_1E64:  INX  H                   ; 1E64 23
L_1E65:  JMP  L_1E5D              ; 1E65 c3 5d 1e
L_1E68:  MVI  A,FFh               ; 1E68 3e ff
L_1E6A:  RET                      ; 1E6A c9
L_1E6B:  PUSH H                   ; 1E6B e5
L_1E6C:  ADD  A                   ; 1E6C 87
L_1E6D:  ADI  96h                 ; 1E6D c6 96
L_1E6F:  MOV  L,A                 ; 1E6F 6f
L_1E70:  MVI  H,DEh               ; 1E70 26 de
L_1E72:  MOV  A,M                 ; 1E72 7e
L_1E73:  POP  H                   ; 1E73 e1
L_1E74:  RET                      ; 1E74 c9
L_1E75:  MOV  M,A                 ; 1E75 77
L_1E76:  INX  H                   ; 1E76 23
L_1E77:  DCR  C                   ; 1E77 0d
L_1E78:  JNZ  L_1E75              ; 1E78 c2 75 1e
L_1E7B:  RET                      ; 1E7B c9
L_1E7C:  LXI  H,A88Ch             ; 1E7C 21 8c a8
L_1E7F:  SHLD L_1D90              ; 1E7F 22 90 1d
L_1E82:  SHLD A82Dh               ; 1E82 22 2d a8
L_1E85:  XRA  A                   ; 1E85 af
L_1E86:  STA  L_1D8C              ; 1E86 32 8c 1d
L_1E89:  LDA  A849h               ; 1E89 3a 49 a8
L_1E8C:  SUI  41h                 ; 1E8C d6 41
L_1E8E:  PUSH PSW                 ; 1E8E f5
L_1E8F:  MOV  E,A                 ; 1E8F 5f
L_1E90:  MVI  C,0Eh               ; 1E90 0e 0e
L_1E92:  RST  1                   ; 1E92 cf
L_1E93:  POP  PSW                 ; 1E93 f1
L_1E94:  CALL L_1E6B              ; 1E94 cd 6b 1e
L_1E97:  STA  L_1D84              ; 1E97 32 84 1d
L_1E9A:  MOV  C,A                 ; 1E9A 4f
L_1E9B:  MVI  B,00h               ; 1E9B 06 00
L_1E9D:  CALL C01Eh               ; 1E9D cd 1e c0
L_1EA0:  MVI  C,1Fh               ; 1EA0 0e 1f
L_1EA2:  RST  1                   ; 1EA2 cf
L_1EA3:  LXI  D,0005h             ; 1EA3 11 05 00
L_1EA6:  DAD  D                   ; 1EA6 19
L_1EA7:  MOV  C,M                 ; 1EA7 4e
L_1EA8:  INX  H                   ; 1EA8 23
L_1EA9:  MOV  B,M                 ; 1EA9 46
L_1EAA:  LXI  H,A101h             ; 1EAA 21 01 a1
L_1EAD:  SHLD L_17AD              ; 1EAD 22 ad 17
L_1EB0:  MVI  A,53h               ; 1EB0 3e 53
L_1EB2:  CALL L_1E75              ; 1EB2 cd 75 1e
L_1EB5:  DCR  B                   ; 1EB5 05
L_1EB6:  MOV  C,B                 ; 1EB6 48
L_1EB7:  CZ   L_1E75              ; 1EB7 cc 75 1e
L_1EBA:  MVI  M,00h               ; 1EBA 36 00
L_1EBC:  LXI  H,0080h             ; 1EBC 21 80 00
L_1EBF:  SHLD DDF6h               ; 1EBF 22 f6 dd
L_1EC2:  LDA  A849h               ; 1EC2 3a 49 a8
L_1EC5:  CPI  43h                 ; 1EC5 fe 43
L_1EC7:  MVI  A,40h               ; 1EC7 3e 40
L_1EC9:  LXI  H,1F28h             ; 1EC9 21 28 1f
L_1ECC:  JZ   L_1ED4              ; 1ECC ca d4 1e
         MVI  A,80h               ; 1ECF 3e 80
         LXI  H,1F0Bh             ; 1ED1 21 0b 1f
L_1ED4:  SHLD L_1F00              ; 1ED4 22 00 1f
L_1ED7:  STA  L_1D8A              ; 1ED7 32 8a 1d
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
L_1EED:  LHLD A82Dh               ; 1EED 2a 2d a8
L_1EF0:  XCHG                     ; 1EF0 eb
L_1EF1:  LXI  H,0060h             ; 1EF1 21 60 00
L_1EF4:  MVI  C,04h               ; 1EF4 0e 04
L_1EF6:  MOV  A,L                 ; 1EF6 7d
L_1EF7:  ADI  20h                 ; 1EF7 c6 20
L_1EF9:  MOV  L,A                 ; 1EF9 6f
L_1EFA:  MOV  A,M                 ; 1EFA 7e
L_1EFB:  STAX D                   ; 1EFB 12
L_1EFC:  INX  D                   ; 1EFC 13
L_1EFD:  CPI  E5h                 ; 1EFD fe e5
L_1EFF:  CNZ  L_1F0B              ; 1EFF c4 0b 1f
L_1F02:  DCR  C                   ; 1F02 0d
L_1F03:  JNZ  L_1EF6              ; 1F03 c2 f6 1e
L_1F06:  XCHG                     ; 1F06 eb
L_1F07:  SHLD A82Dh               ; 1F07 22 2d a8
L_1F0A:  RET                      ; 1F0A c9
L_1F0B:  PUSH H                   ; 1F0B e5
         PUSH D                   ; 1F0C d5
         PUSH B                   ; 1F0D c5
         MOV  A,L                 ; 1F0E 7d
         ADI  10h                 ; 1F0F c6 10
         MOV  E,A                 ; 1F11 5f
         MVI  D,00h               ; 1F12 16 00
         MVI  C,08h               ; 1F14 0e 08
L_1F16:  LDAX D                   ; 1F16 1a
         MOV  L,A                 ; 1F17 6f
         INX  D                   ; 1F18 13
         LDAX D                   ; 1F19 1a
         INX  D                   ; 1F1A 13
         ADI  A1h                 ; 1F1B c6 a1
         MOV  H,A                 ; 1F1D 67
         MVI  M,5Ah               ; 1F1E 36 5a
         DCR  C                   ; 1F20 0d
         JNZ  L_1F16              ; 1F21 c2 16 1f
         POP  B                   ; 1F24 c1
         POP  D                   ; 1F25 d1
         POP  H                   ; 1F26 e1
         RET                      ; 1F27 c9
         .db E5h,D5h,C5h,7Dh,C6h,10h,5Fh,16h,00h,0Eh,10h,1Ah,6Fh,13h,26h,A1h ; 1F28 |...}.._.....o.&.|
         .db 36h,5Ah,0Dh,C2h,33h,1Fh,C1h,D1h,E1h,C9h,00h,00h,00h,20h,00h,00h ; 1F38 |6Z..3........ ..|
L_1F48:  .db 00h,20h,E2h,C1h,CAh,D4h,00h,20h,20h,28h,00h,00h,00h,20h,EBh,C2h ; 1F48 |. .....  (... ..|
         .db 29h,00h,43h,4Fh,20h,20h,20h,20h,20h,20h,20h,50h,52h,4Dh,43h,4Fh ; 1F58 |).CO       PRMCO|
         .db 20h,20h,20h,20h,20h,20h,20h,50h,54h,4Bh,3Eh,43h,3Ah,43h,4Fh,2Eh ; 1F68 |       PTK>C:CO.|
         .db 50h,54h,4Bh,1Bh,50h,00h,FFh,09h,E6h,C1h,CAh,CCh,00h,20h,FAh,C1h ; 1F78 |PTK.P........ ..|
         .db DDh,C9h,DDh,C5h,CEh,20h,00h,20h,F5h,C4h,C1h,CCh,D1h,D4h,D8h,3Fh ; 1F88 |..... . .......?|
         .db 20h,28h,59h,2Fh,4Eh,29h,00h,20h,F3h,C9h,D3h,D4h,C5h,CDh,CEh,D9h ; 1F98 | (Y/N). ........|
         .db CAh,00h,00h,20h,CEh,C1h,20h,C4h,C9h,D3h,CBh,C5h,20h,22h,00h,20h ; 1FA8 |... .. ..... ". |
         .db D5h,D6h,C5h,20h,C5h,D3h,D4h,D8h,2Eh,00h,20h,FAh,C1h,CDh,C5h,CEh ; 1FB8 |... ...... .....|
         .db D1h,D4h,D8h,3Fh,20h,28h,59h,2Fh,4Eh,29h,20h,20h,20h,20h,08h,08h ; 1FC8 |...? (Y/N)    ..|
         .db 08h,00h,59h,65h,73h,00h,4Eh,6Fh,20h,00h,2Eh,20h,75h,73h,65h,72h ; 1FD8 |..Yes.No .. user|
         .db 20h,30h,20h,64h,69h,72h,00h,E4h,C9h,D3h,CBh,20h,D0h,CFh,CCh,CEh ; 1FE8 | 0 dir..... ....|
         .db D9h,CAh,00h,20h,2Dh,20h,E6h,C1h                  ; 1FF8 |... - ..|
L_2000:  JZ   L_20CC              ; 2000 ca cc 20
         ACI  C5h                 ; 2003 ce c5
         NOP                      ; 2005 20
         SBI  C9h                 ; 2006 de c9
         CNC  C5C1h               ; 2008 d4 c1 c5
         CNC  D1D3h               ; 200B d4 d3 d1
         NOP                      ; 200E 00
L_200F:  MVI  C,06h               ; 200F 0e 06
         MVI  E,FFh               ; 2011 1e ff
         CALL 0005h               ; 2013 cd 05 00
         CPI  00h                 ; 2016 fe 00
         JNZ  L_200F              ; 2018 c2 0f 20
         LDA  DF15h               ; 201B 3a 15 df
         CPI  3Ch                 ; 201E fe 3c
         JZ   L_2054              ; 2020 ca 54 20
         CALL L_1009              ; 2023 cd 09 10
L_2026:  LXI  H,203Ah             ; 2026 21 3a 20
         SHLD C05Dh               ; 2029 22 5d c0
         LXI  H,E176h             ; 202C 21 76 e1
         SHLD DA32h               ; 202F 22 32 da
         MVI  A,31h               ; 2032 3e 31
         STA  DA31h               ; 2034 32 31 da
         JMP  L_205D              ; 2037 c3 5d 20
         .db F5h,C5h,D5h,E5h,21h,13h,C0h,22h,5Dh,C0h,21h,65h,DFh,22h,32h,DAh ; 203A |....!.."].!e."2.|
         .db 3Eh,C3h,32h,31h,DAh,E1h,D1h,C1h,F1h,C9h          ; 204A |>.21......|
L_2054:  CALL L_1009              ; 2054 cd 09 10
         LXI  H,2066h             ; 2057 21 66 20
         SHLD C05Dh               ; 205A 22 5d c0
L_205D:  LXI  H,E2BDh             ; 205D 21 bd e2
         SHLD E213h               ; 2060 22 13 e2
         JMP  0000h               ; 2063 c3 00 00
         .db F5h,E5h,21h,13h,C7h,22h,5Dh,C0h,E1h,F1h,C9h      ; 2066 |..!.."]....|
L_2071:  SHLD L_207B              ; 2071 22 7b 20
L_2074:  LXI  H,2079h             ; 2074 21 79 20
L_2077:  RST  3                   ; 2077 df
L_2078:  RET                      ; 2078 c9
         .db 1Bh,59h,00h,00h,00h                              ; 2079 |.Y...|
L_207E:  LXI  D,20C3h             ; 207E 11 c3 20
         CALL L_28D2              ; 2081 cd d2 28
         LXI  B,20C5h             ; 2084 01 c5 20
         LXI  H,0000h             ; 2087 21 00 00
         LDA  L_20C4              ; 208A 3a c4 20
         ORA  A                   ; 208D b7
         JZ   L_20B5              ; 208E ca b5 20
         DCR  A                   ; 2091 3d
         JZ   L_20AF              ; 2092 ca af 20
         DCR  A                   ; 2095 3d
         JZ   L_20A9              ; 2096 ca a9 20
         DCR  A                   ; 2099 3d
         JZ   L_20A3              ; 209A ca a3 20
         LXI  D,03E8h             ; 209D 11 e8 03
         CALL L_20B9              ; 20A0 cd b9 20
L_20A3:  LXI  D,0064h             ; 20A3 11 64 00
         CALL L_20B9              ; 20A6 cd b9 20
L_20A9:  LXI  D,000Ah             ; 20A9 11 0a 00
         CALL L_20B9              ; 20AC cd b9 20
L_20AF:  LXI  D,0001h             ; 20AF 11 01 00
         CALL L_20B9              ; 20B2 cd b9 20
L_20B5:  POP  B                   ; 20B5 c1
         PUSH H                   ; 20B6 e5
         PUSH B                   ; 20B7 c5
         RET                      ; 20B8 c9
L_20B9:  LDAX B                   ; 20B9 0a
         INX  B                   ; 20BA 03
         SUI  2Fh                 ; 20BB d6 2f
L_20BD:  DCR  A                   ; 20BD 3d
         RZ                       ; 20BE c8
         DAD  D                   ; 20BF 19
         JMP  L_20BD              ; 20C0 c3 bd 20
         .db 05h,00h,00h,00h,00h,00h                          ; 20C3 |......|
L_20C9:  NOP                      ; 20C9 00
L_20CA:  LXI  H,A954h             ; 20CA 21 54 a9
L_20CD:  LDA  B69Dh               ; 20CD 3a 9d b6
L_20D0:  DCR  A                   ; 20D0 3d
L_20D1:  JZ   L_20D8              ; 20D1 ca d8 20
L_20D4:  LXI  D,0680h             ; 20D4 11 80 06
L_20D7:  DAD  D                   ; 20D7 19
L_20D8:  SHLD A842h               ; 20D8 22 42 a8
L_20DB:  RET                      ; 20DB c9
         .db CDh,DFh,29h,11h,63h,B6h,0Eh,08h,CDh,F5h,20h,23h,13h,0Eh,03h,CDh ; 20DC |..).c..... #....|
         .db F5h,20h,21h,01h,00h,22h,8Dh,B6h,C9h              ; 20EC |. !.."...|
L_20F5:  LDAX D                   ; 20F5 1a
         CMP  M                   ; 20F6 be
         CNZ  L_2101              ; 20F7 c4 01 21
         INX  H                   ; 20FA 23
         INX  D                   ; 20FB 13
         DCR  C                   ; 20FC 0d
         JNZ  L_20F5              ; 20FD c2 f5 20
         RET                      ; 2100 c9
L_2101:  CPI  3Fh                 ; 2101 fe 3f
         RZ                       ; 2103 c8
         POP  H                   ; 2104 e1
         POP  H                   ; 2105 e1
         RET                      ; 2106 c9
         .db 21h,63h,B6h,11h,6Dh,00h,0Eh,08h,EFh,23h,0Eh,03h,EFh,CDh,DFh,29h ; 2107 |!c..m....#.....)|
         .db 21h,91h                                          ; 2117 |!.|
L_2119:  MVI  A,CDh               ; 2119 3e cd
         MOV  C,L                 ; 211B 4d
         MVI  C,7Eh               ; 211C 0e 7e
         STA  B673h               ; 211E 32 73 b6
         PUSH PSW                 ; 2121 f5
         CALL L_19B8              ; 2122 cd b8 19
         POP  PSW                 ; 2125 f1
         SUI  40h                 ; 2126 d6 40
         STA  006Ch               ; 2128 32 6c 00
         XRA  A                   ; 212B af
         MVI  C,04h               ; 212C 0e 04
         LXI  H,0078h             ; 212E 21 78 00
L_2131:  MOV  M,A                 ; 2131 77
         DCR  C                   ; 2132 0d
         JNZ  L_2131              ; 2133 c2 31 21
         LXI  D,005Ch             ; 2136 11 5c 00
         MVI  C,17h               ; 2139 0e 17
L_213B:  RST  1                   ; 213B cf
         RET                      ; 213C c9
         .db 21h,89h,B6h,CDh,47h,0Eh,AFh,BEh,C2h,57h,21h,CDh,CAh,20h,11h,3Bh ; 213D |!...G....W!.. .;|
         .db 35h,CDh,79h,39h,21h,01h,00h,22h,9Bh,B6h,21h,6Dh,26h,CDh,13h,0Dh ; 214D |5.y9!.."..!m&...|
         .db CDh,DFh,29h,CDh,ACh,22h,3Ah,8Dh,B6h,FEh,01h,CAh,E0h,0Fh,CDh,5Bh ; 215D |..)..":........[|
         .db 02h,21h,91h,3Eh,CDh,4Dh,0Eh,7Eh,32h,73h,B6h,21h,63h,B6h,22h,42h ; 216D |.!.>.M.~2s.!c."B|
         .db A8h,CDh,8Fh,19h,CDh,F3h,0Fh,CDh,73h,02h,C3h,93h,0Eh,21h,57h,26h ; 217D |........s....!W&|
         .db CDh,13h,0Dh,CDh,1Eh,23h,3Ah,8Dh,B6h,3Dh,CAh,E0h,0Fh,21h,91h,3Eh ; 218D |.....#:..=...!.>|
         .db CDh,4Dh,0Eh,7Eh,32h,73h,B6h                      ; 219D |.M.~2s.|
L_21A4:  CALL L_0262              ; 21A4 cd 62 02
         CALL L_21F8              ; 21A7 cd f8 21
         LXI  H,21CDh             ; 21AA 21 cd 21
         CALL L_0B7A              ; 21AD cd 7a 0b
         CALL L_0273              ; 21B0 cd 73 02
         LXI  H,B681h             ; 21B3 21 81 b6
         CALL L_0E47              ; 21B6 cd 47 0e
         XRA  A                   ; 21B9 af
         MOV  M,A                 ; 21BA 77
         CALL L_091B              ; 21BB cd 1b 09
         MVI  A,01h               ; 21BE 3e 01
         STA  B69Bh               ; 21C0 32 9b b6
         CALL L_0CD9              ; 21C3 cd d9 0c
         XRA  A                   ; 21C6 af
         STA  B68Dh               ; 21C7 32 8d b6
         JMP  L_0FE0              ; 21CA c3 e0 0f
         .db CDh,01h,22h,CDh,DFh,29h,CDh,AFh,22h,21h,63h,B6h,22h,42h,A8h,CDh ; 21CD |.."..).."!c."B..|
         .db A2h,19h,3Ah,48h,A8h,FEh,59h,C2h,E0h,0Fh,21h,00h,00h,22h,8Dh,B6h ; 21DD |..:H..Y...!.."..|
         .db 3Eh,03h,32h,4Bh,A9h,CDh,2Fh,0Ch,C3h,07h,21h      ; 21ED |>.2K../...!|
L_21F8:  LXI  H,B663h             ; 21F8 21 63 b6
         LXI  D,A90Dh             ; 21FB 11 0d a9
         JMP  L_3979              ; 21FE c3 79 39
L_2201:  LXI  H,A90Dh             ; 2201 21 0d a9
         LXI  D,B663h             ; 2204 11 63 b6
         JMP  L_3979              ; 2207 c3 79 39
         .db AFh,32h,8Dh,B6h,21h,41h,26h,CDh,13h,0Dh,CDh,1Eh,23h,3Ah,8Dh,B6h ; 220A |.2..!A&.....#:..|
         .db 3Dh,CAh,E0h,0Fh,CDh,E0h                          ; 221A |=.....|
L_2220:  RRC                      ; 2220 0f
         CALL L_0A5B              ; 2221 cd 5b 0a
         LDA  L_10BE              ; 2224 3a be 10
         STA  A849h               ; 2227 32 49 a8
         CALL L_0B5C              ; 222A cd 5c 0b
         CALL L_0262              ; 222D cd 62 02
         LDA  L_10BA              ; 2230 3a ba 10
         STA  A84Ah               ; 2233 32 4a a8
         CALL L_0B6B              ; 2236 cd 6b 0b
         CALL L_0262              ; 2239 cd 62 02
         CALL L_1E7C              ; 223C cd 7c 1e
         LXI  H,B663h             ; 223F 21 63 b6
         SHLD A84Dh               ; 2242 22 4d a8
         CALL L_21F8              ; 2245 cd f8 21
         LXI  H,2286h             ; 2248 21 86 22
         CALL L_0B7A              ; 224B cd 7a 0b
         LDA  A849h               ; 224E 3a 49 a8
         CALL L_027A              ; 2251 cd 7a 02
         MVI  C,0Dh               ; 2254 0e 0d
         RST  1                   ; 2256 cf
         LDA  B69Dh               ; 2257 3a 9d b6
         PUSH PSW                 ; 225A f5
         MVI  A,01h               ; 225B 3e 01
         STA  B69Dh               ; 225D 32 9d b6
         LXI  H,3E91h             ; 2260 21 91 3e
         LDA  L_10BE              ; 2263 3a be 10
         CMP  M                   ; 2266 be
         PUSH H                   ; 2267 e5
         PUSH PSW                 ; 2268 f5
         CZ   L_091B              ; 2269 cc 1b 09
         POP  PSW                 ; 226C f1
         POP  H                   ; 226D e1
         INX  H                   ; 226E 23
         CMP  M                   ; 226F be
         CZ   L_0FCA              ; 2270 cc ca 0f
         POP  PSW                 ; 2273 f1
         STA  B69Dh               ; 2274 32 9d b6
         CALL L_0C7E              ; 2277 cd 7e 0c
         CALL L_0FE0              ; 227A cd e0 0f
         LDA  A950h               ; 227D 3a 50 a9
         STA  B69Bh               ; 2280 32 9b b6
         JMP  L_0CD9              ; 2283 c3 d9 0c
         .db CDh,DFh,29h,22h,4Fh,A8h,CDh,01h,22h,CDh,AFh,22h,3Ah,04h,A8h,B7h ; 2286 |..)"O..."..":...|
         .db CAh,9Ah,15h,21h,AFh,10h,3Ah,04h,A8h,CDh,1Bh,0Eh,CDh,E0h,0Fh,21h ; 2296 |...!..:........!|
         .db A5h,10h,DFh,C3h,9Ah,15h,CDh,1Eh,23h              ; 22A6 |........#|
L_22AF:  LHLD A842h               ; 22AF 2a 42 a8
         LXI  D,B663h             ; 22B2 11 63 b6
         MVI  C,0Ch               ; 22B5 0e 0c
L_22B7:  LDAX D                   ; 22B7 1a
         CPI  3Fh                 ; 22B8 fe 3f
         CZ   L_22C4              ; 22BA cc c4 22
         INX  H                   ; 22BD 23
         INX  D                   ; 22BE 13
         DCR  C                   ; 22BF 0d
         JNZ  L_22B7              ; 22C0 c2 b7 22
         RET                      ; 22C3 c9
L_22C4:  MOV  A,M                 ; 22C4 7e
         STAX D                   ; 22C5 12
         RET                      ; 22C6 c9
         .db CDh,F3h,0Fh,21h,4Eh,26h,CDh,13h,0Dh,CDh,1Eh,23h,3Ah,8Dh,B6h,FEh ; 22C7 |...!N&.....#:...|
         .db 01h,CAh,E0h,0Fh,3Ah,9Bh,B6h,F5h,21h,89h,B6h,CDh,47h,0Eh,7Eh,32h ; 22D7 |....:...!...G.~2|
         .db 9Bh,B6h,AFh,32h,8Dh,B6h,CDh,DCh,20h,3Ah,8Dh,B6h,FEh,01h,C2h,01h ; 22E7 |...2.... :......|
         .db 23h,CDh,DFh,29h,11h,08h,00h,19h,36h,7Fh,3Ah,9Bh,B6h,3Dh,F5h,21h ; 22F7 |#..)....6.:..=.!|
         .db 8Ah,A8h,CDh,4Dh,0Eh,F1h,BEh,C2h,E6h,22h,F1h,32h,9Bh,B6h,CDh,F1h ; 2307 |...M.....".2....|
         .db 11h,CDh,E0h,0Fh,C3h,0Fh,09h                      ; 2317 |.......|
L_231E:  LXI  D,A91Bh             ; 231E 11 1b a9
         MVI  A,0Eh               ; 2321 3e 0e
         STAX D                   ; 2323 12
         CALL L_28D2              ; 2324 cd d2 28
         LDA  A91Ch               ; 2327 3a 1c a9
         ORA  A                   ; 232A b7
         JZ   L_23A5              ; 232B ca a5 23
         LXI  H,0000h             ; 232E 21 00 00
         SHLD B68Dh               ; 2331 22 8d b6
         LXI  H,A91Dh             ; 2334 21 1d a9
         MOV  E,A                 ; 2337 5f
         MVI  D,00h               ; 2338 16 00
         DAD  D                   ; 233A 19
         MVI  C,07h               ; 233B 0e 07
         MVI  A,20h               ; 233D 3e 20
         CALL L_239B              ; 233F cd 9b 23
         LXI  H,B663h             ; 2342 21 63 b6
         MVI  C,08h               ; 2345 0e 08
         LDA  A91Dh               ; 2347 3a 1d a9
         CPI  2Eh                 ; 234A fe 2e
         JZ   L_236C              ; 234C ca 6c 23
         LXI  D,A91Dh             ; 234F 11 1d a9
L_2352:  LDAX D                   ; 2352 1a
         CPI  2Eh                 ; 2353 fe 2e
         JZ   L_2367              ; 2355 ca 67 23
         CPI  2Ah                 ; 2358 fe 2a
         JZ   L_236C              ; 235A ca 6c 23
         MOV  M,A                 ; 235D 77
         INX  H                   ; 235E 23
         INX  D                   ; 235F 13
         DCR  C                   ; 2360 0d
         JNZ  L_2352              ; 2361 c2 52 23
         JMP  L_2371              ; 2364 c3 71 23
L_2367:  MVI  A,20h               ; 2367 3e 20
         JMP  L_236E              ; 2369 c3 6e 23
L_236C:  MVI  A,3Fh               ; 236C 3e 3f
L_236E:  CALL L_239B              ; 236E cd 9b 23
L_2371:  INX  H                   ; 2371 23
         LDA  A91Ch               ; 2372 3a 1c a9
         MOV  C,A                 ; 2375 4f
         LXI  D,A91Dh             ; 2376 11 1d a9
L_2379:  LDAX D                   ; 2379 1a
         CPI  2Eh                 ; 237A fe 2e
         JZ   L_238B              ; 237C ca 8b 23
         INX  D                   ; 237F 13
         DCR  C                   ; 2380 0d
         JNZ  L_2379              ; 2381 c2 79 23
         MVI  C,03h               ; 2384 0e 03
L_2386:  MVI  A,3Fh               ; 2386 3e 3f
         JMP  L_239B              ; 2388 c3 9b 23
L_238B:  MVI  C,03h               ; 238B 0e 03
L_238D:  INX  D                   ; 238D 13
         LDAX D                   ; 238E 1a
         CPI  2Ah                 ; 238F fe 2a
         JZ   L_2386              ; 2391 ca 86 23
         MOV  M,A                 ; 2394 77
         INX  H                   ; 2395 23
         DCR  C                   ; 2396 0d
         JNZ  L_238D              ; 2397 c2 8d 23
         RET                      ; 239A c9
L_239B:  INR  C                   ; 239B 0c
         DCR  C                   ; 239C 0d
         RZ                       ; 239D c8
         MOV  M,A                 ; 239E 77
         INX  H                   ; 239F 23
         DCR  C                   ; 23A0 0d
         JNZ  L_239B              ; 23A1 c2 9b 23
         RET                      ; 23A4 c9
L_23A5:  LXI  H,0001h             ; 23A5 21 01 00
         SHLD B68Dh               ; 23A8 22 8d b6
         RET                      ; 23AB c9
         .db 11h,03h,06h,21h,A7h,25h,CDh,F1h,0Ch,21h,E0h,0Fh,E5h,FEh,1Bh,C8h ; 23AC |...!.%...!......|
         .db 3Dh,CAh,79h,24h,3Dh,CAh,56h,24h,3Dh,CAh,CFh,23h,3Dh,CAh,E8h,24h ; 23BC |=.y$=.V$=..#=..$|
         .db C3h,9Ch,24h,21h,95h,3Eh,CDh,4Dh,0Eh,7Eh,E6h,F0h,0Fh,0Fh,0Fh,0Fh ; 23CC |..$!.>.M.~......|
         .db 5Fh,16h,05h,21h,CAh,25h,CDh,F1h,0Ch,FEh,1Bh,C8h,0Fh,0Fh,0Fh,0Fh ; 23DC |_..!.%..........|
         .db 4Fh,21h,95h,3Eh,CDh,4Dh,0Eh,7Eh,E6h,0Fh,81h,77h,CDh,1Bh,09h,C3h ; 23EC |O!.>.M.~...w....|
         .db D9h,0Ch,11h,03h,04h,21h,23h,26h,CDh,F1h,0Ch,FEh,1Bh,C8h,32h,4Bh ; 23FC |.....!#&......2K|
         .db A9h,CDh,5Bh,02h,21h,1Fh,24h,CDh,7Ah,0Bh,CDh,D9h,0Ch,CDh,73h,02h ; 240C |..[.!.$.z.....s.|
         .db C3h,E0h,0Fh,CDh,2Fh,0Ch,21h,81h,B6h,CDh,47h,0Eh,4Eh,0Ch,3Eh,EDh ; 241C |..../.!...G.N.>.|
         .db C6h,14h,0Dh,C2h,2Ch,24h,4Fh,3Ah,9Bh,B6h,B9h,F8h,3Eh,28h,81h,4Fh ; 242C |....,$O:....>(.O|
         .db 21h,93h,3Eh,C5h,CDh,4Dh,0Eh,C1h,7Eh,FEh,50h,CAh,4Eh,24h,3Eh,14h ; 243C |!.>..M..~.P.N$>.|
         .db 81h,4Fh,3Ah,9Bh,B6h,B9h,F0h,C3h,2Dh,08h,1Eh,01h,3Ah,97h,3Eh,FEh ; 244C |.O:.....-...:.>.|
         .db 59h,CAh,61h,24h,1Ch,16h,03h,21h,EFh,25h,CDh,F1h,0Ch,FEh,1Bh,C8h ; 245C |Y.a$...!.%......|
         .db 0Eh,59h,3Dh,CAh,74h,24h,0Eh,4Eh,79h,32h,97h,3Eh,C9h,1Eh,01h,3Ah ; 246C |.Y=.t$.Ny2.>...:|
         .db 90h,3Eh,FEh,59h,CAh,84h,24h,1Ch,16h,03h,21h,0Ah,26h,CDh,F1h,0Ch ; 247C |.>.Y..$...!.&...|
         .db FEh,1Bh,C8h,0Eh,59h,3Dh,CAh,97h,24h,0Eh,4Eh,79h,32h,90h,3Eh,C9h ; 248C |....Y=..$.Ny2.>.|
         .db 21h,95h,3Eh,CDh,4Dh,0Eh,E5h,7Eh,E6h,0Fh,1Eh,01h,FEh,01h,CAh,AEh ; 249C |!.>.M..~........|
         .db 24h,1Ch,16h,03h,21h,86h,25h,CDh,F1h,0Ch,E1h,FEh,1Bh,C8h,0Eh,01h ; 24AC |$...!.%.........|
         .db 3Dh,CAh,C2h,24h,0Eh,00h,7Eh,E6h,0Fh,B9h,C8h,7Eh,E6h,F0h,81h,77h ; 24BC |=..$..~....~...w|
         .db CDh,1Bh,09h,21h,01h,00h,22h,9Bh,B6h,CDh,7Eh,0Ch,C3h,D9h,0Ch ; 24CC |...!.."...~....|
L_24DB:  CALL F815h               ; 24DB cd 15 f8
         MVI  C,20h               ; 24DE 0e 20
         RST  4                   ; 24E0 e7
         CALL L_2549              ; 24E1 cd 49 25
         LDA  L_2698              ; 24E4 3a 98 26
         RET                      ; 24E7 c9
         .db CDh,E0h,0Fh,3Eh,03h,32h,98h,26h                  ; 24E8 |...>.2.&|
L_24F0:  CALL L_0FF3              ; 24F0 cd f3 0f
         LDA  L_2698              ; 24F3 3a 98 26
         DCR  A                   ; 24F6 3d
         CZ   L_254E              ; 24F7 cc 4e 25
         LXI  H,2680h             ; 24FA 21 80 26
         CALL L_0D13              ; 24FD cd 13 0d
         LDA  L_1F7D              ; 2500 3a 7d 1f
         CALL L_24DB              ; 2503 cd db 24
         CPI  02h                 ; 2506 fe 02
         CZ   L_254E              ; 2508 cc 4e 25
         LXI  H,2684h             ; 250B 21 84 26
         CALL L_0D13              ; 250E cd 13 0d
         LDA  L_1F7E              ; 2511 3a 7e 1f
         CALL L_24DB              ; 2514 cd db 24
         CPI  03h                 ; 2517 fe 03
         CZ   L_254E              ; 2519 cc 4e 25
         LXI  H,268Ch             ; 251C 21 8c 26
         CALL L_0D13              ; 251F cd 13 0d
         LDA  L_1F7F              ; 2522 3a 7f 1f
         CALL L_24DB              ; 2525 cd db 24
         CALL L_2549              ; 2528 cd 49 25
         CALL L_151F              ; 252B cd 1f 15
         CALL L_0D44              ; 252E cd 44 0d
         LXI  H,2537h             ; 2531 21 37 25
         JMP  L_0562              ; 2534 c3 62 05
         .db 05h,08h,53h,25h,18h,62h,25h,19h,70h,25h,1Ah,77h,25h,1Bh,78h,24h ; 2537 |..S%.b%.p%.w%.x$|
         .db 2Bh,25h                                          ; 2547 |+%|
L_2549:  LXI  H,2695h             ; 2549 21 95 26
         RST  3                   ; 254C df
         RET                      ; 254D c9
L_254E:  LXI  H,2692h             ; 254E 21 92 26
         RST  3                   ; 2551 df
         RET                      ; 2552 c9
         .db 3Ah,98h,26h,3Dh,C2h,5Ch,25h,3Eh,03h              ; 2553 |:.&=.\%>.|
L_255C:  STA  L_2698              ; 255C 32 98 26
         JMP  L_24F0              ; 255F c3 f0 24
         .db 3Ah,98h,26h,3Ch,FEh,04h,C2h,5Ch,25h,3Eh,01h,C3h,5Ch,25h,CDh,7Eh ; 2562 |:.&<...\%>..\%.~|
         .db 25h,34h,C3h,F0h,24h,CDh,7Eh,25h,35h,C3h,F0h,24h  ; 2572 |%4..$.~%5..$|
L_257E:  LXI  D,1F7Ch             ; 257E 11 7c 1f
         LHLD L_2698              ; 2581 2a 98 26
         DAD  D                   ; 2584 19
         RET                      ; 2585 c9
         .db F3h,C9h,D3h,D4h,C5h,CDh,CEh,D9h,C5h,20h,C6h,C1h,CAh,CCh,D9h,00h ; 2586 |......... ......|
         .db F0h,CFh,CBh,C1h,DAh,C1h,CEh,D9h,00h,F3h,D0h,D2h,D1h,D4h,C1h,CEh ; 2596 |................|
         .db D9h,00h,F2h,2Eh,CBh,CFh,D0h,C9h,D2h,2Eh,00h,E4h,C9h,D3h,CBh,22h ; 25A6 |..............."|
         .db 42h,22h,00h,F3h,CFh,D2h,D4h,2Eh,00h,FCh,CBh,D2h,C1h,CEh,00h,F2h ; 25B6 |B"..............|
         .db 2Eh,44h,49h,52h,00h,F0h,CFh,20h,C9h,CDh,C5h,CEh,C9h,00h,F0h,CFh ; 25C6 |.DIR... ........|
         .db 20h,D4h,C9h,D0h,D5h,00h,F0h,CFh,20h,D2h,C1h,DAh,CDh,C5h,D2h,D5h ; 25D6 | ....... .......|
         .db 00h,F2h,C5h,C1h,CCh,D8h,CEh,CFh,00h,E4h,C9h,D3h,CBh,20h,22h,42h ; 25E6 |............. "B|
         .db 22h,00h,E4h,CFh,D3h,D4h,D5h,D0h,C5h,CEh,00h,EFh,D4h,CBh,CCh,C0h ; 25F6 |"...............|
         .db DEh,C5h,CEh,00h,F0h,D2h,CFh,D7h,C5h,D2h,CBh,D5h,00h,E4h,C5h,CCh ; 2606 |................|
         .db C1h,D4h,D8h,00h,EEh,C5h,20h,C4h,C5h,CCh,C1h,D4h,D8h,00h,FAh,C1h ; 2616 |...... .........|
         .db DDh,C9h,DDh,C5h,CEh,00h,F3h,C9h,D3h,D4h,C5h,CDh,CEh,D9h,CAh,00h ; 2626 |................|
         .db F3h,C2h,D2h,CFh,D3h,20h,C1h,D4h,D2h,2Eh,00h,E9h,CDh,D1h,20h,CBh ; 2636 |..... ........ .|
         .db CFh,D0h,C9h,C9h,20h,C9h,CCh,C9h,20h,CDh,C1h,D3h,CBh,C1h,20h,2Dh ; 2646 |.... ... ..... -|
         .db 00h,EEh,CFh,D7h,CFh,C5h,20h,C9h,CDh,D1h,20h,C9h,CCh,C9h,20h,CDh ; 2656 |...... ... ... .|
         .db C1h,D3h,CBh,C1h,20h,2Dh,00h,E9h,CDh,D1h,20h,CEh,CFh,D7h,CFh,C7h ; 2666 |.... -.... .....|
         .db CFh,20h,C6h,C1h,CAh,CCh,C1h,20h,2Dh,00h,E6h,CFh,CEh,00h,F3h,C9h ; 2676 |. ..... -.......|
         .db CDh,D7h,CFh,CCh,D9h,00h,F0h,C1h,D5h,DAh,C1h,00h,1Bh,62h,00h,1Bh ; 2686 |.............b..|
         .db 61h,00h,00h,00h,21h,14h,DFh,3Ah,02h,A8h,BEh,C8h,35h,B7h,CAh,CCh ; 2696 |a...!..:....5...|
         .db 26h,0Eh,08h,CDh,09h,F8h,3Ah,02h,A8h,47h,21h,14h,DFh,7Eh,F5h,85h ; 26A6 |&.....:..G!..~..|
         .db 90h,6Fh,78h,23h,23h,E5h,CDh,02h,2Ah,21h,2Ch,29h,DFh,E1h,54h,5Dh ; 26B6 |.ox##...*!,)..T]|
         .db 2Bh,F1h,4Fh,EBh,EFh,C9h,21h,2Bh,29h,DFh,C9h,CDh,DFh,29h,21h,91h ; 26C6 |+.O...!+)....)!.|
         .db 3Eh,CDh,4Dh,0Eh,7Eh,32h,73h,B6h,C3h,27h,15h,21h,2Fh,29h,06h,4Eh ; 26D6 |>.M.~2s..'.!/).N|
         .db 3Ah,72h,B6h,FEh,59h,CAh,F3h,26h,21h,3Dh,29h,06h,59h,78h,32h,72h ; 26E6 |:r..Y..&!=).Yx2r|
         .db B6h,DFh,C3h,F3h,0Fh,CDh,DFh,29h,3Eh,2Eh,BEh,C8h,11h,08h,00h,19h ; 26F6 |.......)>.......|
         .db 16h,20h,7Eh,BAh,F5h,C2h,10h,27h,16h,7Fh,72h,11h,04h,00h,19h,E5h ; 2706 |. ~....'..r.....|
         .db 21h,47h,A9h,CDh,47h,0Eh,5Eh,23h,56h,2Bh,E3h,7Eh,EBh,5Fh,16h,00h ; 2716 |!G..G.^#V+.~._..|
         .db C1h,F1h,F5h,C5h,CAh,33h,27h,7Bh,2Fh,5Fh,16h,FFh,13h,19h,EBh,E1h ; 2726 |.....3'{/_......|
         .db 73h,23h,72h,21h,43h,A9h,CDh,47h,0Eh,46h,04h,F1h,CAh,47h,27h,05h ; 2736 |s#r!C..G.F...G'.|
         .db 05h,70h,CDh,54h,0Eh,C3h,5Ah,04h,CDh,E0h,0Fh,21h,4Fh,29h,DFh,CDh ; 2746 |.p.T..Z....!O)..|
         .db 7Eh,20h,E1h,AFh,BCh,C2h,65h,27h,BDh,C2h,65h,27h,2Ah,53h,A8h ; 2756 |~ ....e'..e'*S.|
L_2765:  SHLD A840h               ; 2765 22 40 a8
         CALL L_0FE0              ; 2768 cd e0 0f
         LHLD A853h               ; 276B 2a 53 a8
         XCHG                     ; 276E eb
         LHLD A840h               ; 276F 2a 40 a8
         CALL L_27E6              ; 2772 cd e6 27
         SHLD A950h               ; 2775 22 50 a9
         XRA  A                   ; 2778 af
         CMP  H                   ; 2779 bc
         JNZ  L_2784              ; 277A c2 84 27
         CMP  L                   ; 277D bd
         JNZ  L_2784              ; 277E c2 84 27
         JMP  L_31C5              ; 2781 c3 c5 31
L_2784:  LDA  A951h               ; 2784 3a 51 a9
         ANI  80h                 ; 2787 e6 80
         CPI  00h                 ; 2789 fe 00
         JZ   L_27AB              ; 278B ca ab 27
L_278E:  LHLD A853h               ; 278E 2a 53 a8
         DCX  H                   ; 2791 2b
         SHLD A853h               ; 2792 22 53 a8
         CALL L_32C3              ; 2795 cd c3 32
         LHLD A950h               ; 2798 2a 50 a9
         INX  H                   ; 279B 23
         SHLD A950h               ; 279C 22 50 a9
         XRA  A                   ; 279F af
         CMP  L                   ; 27A0 bd
         JNZ  L_278E              ; 27A1 c2 8e 27
         CMP  H                   ; 27A4 bc
         JNZ  L_278E              ; 27A5 c2 8e 27
         JMP  L_31C5              ; 27A8 c3 c5 31
L_27AB:  LHLD A853h               ; 27AB 2a 53 a8
         INX  H                   ; 27AE 23
         SHLD A853h               ; 27AF 22 53 a8
         LHLD A950h               ; 27B2 2a 50 a9
         DCX  H                   ; 27B5 2b
         SHLD A950h               ; 27B6 22 50 a9
L_27B9:  LDA  B68Dh               ; 27B9 3a 8d b6
         CPI  4Dh                 ; 27BC fe 4d
         JZ   L_27DC              ; 27BE ca dc 27
         XRA  A                   ; 27C1 af
         CMP  L                   ; 27C2 bd
         JNZ  L_27C8              ; 27C3 c2 c8 27
         CMP  H                   ; 27C6 bc
         RZ                       ; 27C7 c8
L_27C8:  LHLD A853h               ; 27C8 2a 53 a8
         INX  H                   ; 27CB 23
         SHLD A853h               ; 27CC 22 53 a8
         CALL L_32E7              ; 27CF cd e7 32
         LHLD A950h               ; 27D2 2a 50 a9
         DCX  H                   ; 27D5 2b
         SHLD A950h               ; 27D6 22 50 a9
         JMP  L_27B9              ; 27D9 c3 b9 27
L_27DC:  LHLD A853h               ; 27DC 2a 53 a8
         DCX  H                   ; 27DF 2b
         SHLD A853h               ; 27E0 22 53 a8
         JMP  L_32C3              ; 27E3 c3 c3 32
L_27E6:  MOV  A,D                 ; 27E6 7a
         CMA                      ; 27E7 2f
         MOV  D,A                 ; 27E8 57
         MOV  A,E                 ; 27E9 7b
         CMA                      ; 27EA 2f
         MOV  E,A                 ; 27EB 5f
         INX  D                   ; 27EC 13
         DAD  D                   ; 27ED 19
         RET                      ; 27EE c9
         .db CDh,F3h,0Fh,C3h,F8h,27h,CDh,FEh,27h,21h,14h,DFh,C3h,6Bh,0Fh ; 27EF |.....'..'!...k.|
L_27FE:  CALL L_0FE0              ; 27FE cd e0 0f
         LDA  L_3E8F              ; 2801 3a 8f 3e
         MVI  E,01h               ; 2804 1e 01
         CPI  4Ch                 ; 2806 fe 4c
         JZ   L_2818              ; 2808 ca 18 28
         INR  E                   ; 280B 1c
         CPI  53h                 ; 280C fe 53
         JZ   L_2818              ; 280E ca 18 28
         INR  E                   ; 2811 1c
         CPI  54h                 ; 2812 fe 54
         JZ   L_2818              ; 2814 ca 18 28
         INR  E                   ; 2817 1c
L_2818:  MVI  D,05h               ; 2818 16 05
         LXI  H,2964h             ; 281A 21 64 29
         CALL L_0CF1              ; 281D cd f1 0c
         CPI  1Bh                 ; 2820 fe 1b
         RZ                       ; 2822 c8
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
         RST  3                   ; 2836 df
         LXI  H,3E8Ch             ; 2837 21 8c 3e
         CALL L_0F6B              ; 283A cd 6b 0f
         JMP  L_0FF3              ; 283D c3 f3 0f
         .db AFh,32h,8Dh,B6h,11h,02h,04h,21h,74h,29h,CDh,F1h,0Ch,FEh,1Bh,CAh ; 2840 |.2.....!t)......|
         .db E0h,0Fh,FEh,02h,CAh,E0h,0Fh,3Dh,CAh,67h,28h,CDh,5Bh,02h,CDh,70h ; 2850 |.......=.g(.[..p|
         .db 37h,CDh,73h,02h,C3h,93h,0Eh,CDh,5Bh,02h,CDh,60h,37h,C3h,61h,28h ; 2860 |7.s.....[..`7.a(|
         .db 21h,91h,3Eh,3Ah,9Dh,B6h,3Dh,5Fh,16h,00h,19h,7Eh,1Eh,01h,FEh,41h ; 2870 |!.>:..=_...~...A|
         .db CAh,8Ah,28h,1Ch,FEh,43h,CAh,8Ah,28h,1Ch          ; 2880 |..(..C..(.|
L_288A:  LDA  L_3E97              ; 288A 3a 97 3e
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
         CALL L_0E4D              ; 28B1 cd 4d 0e
         MOV  M,B                 ; 28B4 70
         MOV  A,B                 ; 28B5 78
         CALL L_0262              ; 28B6 cd 62 02
         LXI  H,B681h             ; 28B9 21 81 b6
         CALL L_0E47              ; 28BC cd 47 0e
         MVI  M,00h               ; 28BF 36 00
         CALL L_091B              ; 28C1 cd 1b 09
         CALL L_0C7E              ; 28C4 cd 7e 0c
         MVI  A,01h               ; 28C7 3e 01
         STA  B69Bh               ; 28C9 32 9b b6
         CALL L_0CD9              ; 28CC cd d9 0c
         JMP  L_0FE0              ; 28CF c3 e0 0f
L_28D2:  XCHG                     ; 28D2 eb
         MOV  A,M                 ; 28D3 7e
         STA  L_28FF              ; 28D4 32 ff 28
         INX  H                   ; 28D7 23
         XRA  A                   ; 28D8 af
         MOV  M,A                 ; 28D9 77
         STA  A933h               ; 28DA 32 33 a9
         SHLD L_290F              ; 28DD 22 0f 29
         INX  H                   ; 28E0 23
L_28E1:  CALL L_0D44              ; 28E1 cd 44 0d
         CPI  1Bh                 ; 28E4 fe 1b
         JZ   L_2912              ; 28E6 ca 12 29
         CPI  0Dh                 ; 28E9 fe 0d
         JZ   L_290B              ; 28EB ca 0b 29
         CPI  20h                 ; 28EE fe 20
         JC   L_28E1              ; 28F0 da e1 28
         CPI  7Fh                 ; 28F3 fe 7f
         JZ   L_2916              ; 28F5 ca 16 29
         MOV  M,A                 ; 28F8 77
         INX  H                   ; 28F9 23
         PUSH H                   ; 28FA e5
         MOV  C,A                 ; 28FB 4f
         RST  4                   ; 28FC e7
         POP  H                   ; 28FD e1
         MVI  C,00h               ; 28FE 0e 00
         LDA  A933h               ; 2900 3a 33 a9
         INR  A                   ; 2903 3c
         STA  A933h               ; 2904 32 33 a9
         CMP  C                   ; 2907 b9
         JNZ  L_28E1              ; 2908 c2 e1 28
L_290B:  LDA  A933h               ; 290B 3a 33 a9
L_290E:  STA  0000h               ; 290E 32 00 00
         RET                      ; 2911 c9
L_2912:  XRA  A                   ; 2912 af
         JMP  L_290E              ; 2913 c3 0e 29
L_2916:  LDA  A933h               ; 2916 3a 33 a9
         ORA  A                   ; 2919 b7
         JZ   L_28E1              ; 291A ca e1 28
         DCR  A                   ; 291D 3d
         STA  A933h               ; 291E 32 33 a9
         DCX  H                   ; 2921 2b
         PUSH H                   ; 2922 e5
         LXI  H,292Bh             ; 2923 21 2b 29
         RST  3                   ; 2926 df
         POP  H                   ; 2927 e1
         JMP  L_28E1              ; 2928 c3 e1 28
         .db 08h,20h,08h,00h,1Bh,59h,36h,25h,8Dh,8Dh,8Dh,8Dh,8Dh,8Dh,8Dh,8Dh ; 292B |. ...Y6%........|
         .db 8Dh,00h,1Bh,59h,36h,25h,1Bh,62h,20h,3Eh,43h,4Fh,2Eh,50h,54h,4Bh ; 293B |...Y6%.b >CO.PTK|
         .db 20h,1Bh,61h,00h,EEh,CFh,CDh,C5h,D2h,20h,D3h,D4h,D2h,CFh,CBh,C9h ; 294B | .a...... ......|
         .db 20h,2Dh,20h,00h,1Bh,59h,37h,6Ch,00h,00h,52h,2Fh,4Ch,00h,52h,55h ; 295B | - ..Y7l..R/L.RU|
         .db 53h,00h,4Ch,41h,54h,00h,4Bh,2Dh,38h,00h,F5h,C4h,C1h,CCh,D1h,D4h ; 296B |S.LAT.K-8.......|
         .db D8h,00h,F7h,D9h,CAh,D4h,C9h,00h,F5h,C4h,C1h,CCh,C9h,D4h,D8h,20h ; 297B |............... |
         .db 22h,42h,41h,4Bh,22h,00h,22h,41h,22h,00h,22h,43h,22h,00h,22h,42h ; 298B |"BAK"."A"."C"."B|
         .db 22h,00h,FEh,02h,F5h,CCh,06h,3Bh,F1h,C4h,51h,3Bh,3Ah,8Dh,B6h,3Dh ; 299B |"......;..Q;:..=|
         .db C9h,AFh,32h,34h,A9h,CDh,42h,02h,CDh,E2h,3Bh,21h,CBh,29h,CDh,7Ah ; 29AB |..24..B...;!.).z|
         .db 0Bh,3Ah,34h,A9h,FEh,00h,C8h,CDh,FFh,3Ah,FEh,1Bh,C8h,C3h,6Ah,2Ch ; 29BB |.:4......:....j,|
         .db CDh,3Ah,39h,3Ah,36h,A9h,CDh,9Dh,29h,C8h,21h,34h,A9h,34h,CDh,24h ; 29CB |.:9:6...).!4.4.$|
         .db 38h,C3h,E9h,3Bh                                  ; 29DB |8..;|
L_29DF:  LXI  H,A954h             ; 29DF 21 54 a9
L_29E2:  LDA  B69Dh               ; 29E2 3a 9d b6
L_29E5:  DCR  A                   ; 29E5 3d
L_29E6:  JZ   L_29ED              ; 29E6 ca ed 29
L_29E9:  LXI  D,0680h             ; 29E9 11 80 06
L_29EC:  DAD  D                   ; 29EC 19
L_29ED:  LDA  B69Bh               ; 29ED 3a 9b b6
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
L_29FE:  SHLD A842h               ; 29FE 22 42 a8
L_2A01:  RET                      ; 2A01 c9
L_2A02:  MOV  C,M                 ; 2A02 4e
L_2A03:  RST  4                   ; 2A03 e7
L_2A04:  INX  H                   ; 2A04 23
L_2A05:  DCR  A                   ; 2A05 3d
L_2A06:  JNZ  L_2A02              ; 2A06 c2 02 2a
L_2A09:  RET                      ; 2A09 c9
L_2A0A:  LDA  B69Dh               ; 2A0A 3a 9d b6
L_2A0D:  DCR  A                   ; 2A0D 3d
L_2A0E:  JNZ  L_2A13              ; 2A0E c2 13 2a
L_2A11:  MVI  A,02h               ; 2A11 3e 02
L_2A13:  STA  B69Dh               ; 2A13 32 9d b6
L_2A16:  RET                      ; 2A16 c9
L_2A17:  CALL L_03DE              ; 2A17 cd de 03
         CALL L_393A              ; 2A1A cd 3a 39
         CALL L_29DF              ; 2A1D cd df 29
         LXI  D,B663h             ; 2A20 11 63 b6
         CALL L_3979              ; 2A23 cd 79 39
         LXI  H,3E91h             ; 2A26 21 91 3e
         CALL L_0E4D              ; 2A29 cd 4d 0e
         MOV  A,M                 ; 2A2C 7e
         STA  B673h               ; 2A2D 32 73 b6
         LXI  H,B663h             ; 2A30 21 63 b6
         LXI  D,0009h             ; 2A33 11 09 00
         DAD  D                   ; 2A36 19
         LXI  D,35C6h             ; 2A37 11 c6 35
         MVI  C,03h               ; 2A3A 0e 03
         CALL L_381A              ; 2A3C cd 1a 38
         JNZ  L_2F41              ; 2A3F c2 41 2f
         CALL L_1257              ; 2A42 cd 57 12
         XRA  A                   ; 2A45 af
         STA  A93Fh               ; 2A46 32 3f a9
         LXI  H,35BDh             ; 2A49 21 bd 35
         SHLD A842h               ; 2A4C 22 42 a8
         CALL L_19B8              ; 2A4F cd b8 19
         MVI  C,11h               ; 2A52 0e 11
L_2A54:  LXI  H,A93Fh             ; 2A54 21 3f a9
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
         LXI  H,B663h             ; 2A68 21 63 b6
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
         STA  A93Ch               ; 2A98 32 3c a9
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
         SHLD A93Ah               ; 2AC0 22 3a a9
         MOV  E,M                 ; 2AC3 5e
         INX  H                   ; 2AC4 23
         MOV  D,M                 ; 2AC5 56
         DCX  D                   ; 2AC6 1b
         MOV  A,E                 ; 2AC7 7b
         ANI  F8h                 ; 2AC8 e6 f8
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
         LHLD A93Ah               ; 2AED 2a 3a a9
         LXI  D,FFF2h             ; 2AF0 11 f2 ff
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
         LXI  D,FFEFh             ; 2B00 11 ef ff
         DAD  D                   ; 2B03 19
         MOV  E,M                 ; 2B04 5e
         INX  H                   ; 2B05 23
         MOV  D,M                 ; 2B06 56
         DCX  H                   ; 2B07 2b
         XTHL                     ; 2B08 e3
         DCR  C                   ; 2B09 0d
         JNZ  L_2AAA              ; 2B0A c2 aa 2a
         POP  H                   ; 2B0D e1
         LDA  A93Ch               ; 2B0E 3a 3c a9
         LXI  H,35B3h             ; 2B11 21 b3 35
         CALL L_0E1B              ; 2B14 cd 1b 0e
         LDA  B69Dh               ; 2B17 3a 9d b6
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
         LXI  H,A859h             ; 2B56 21 59 a8
         CALL L_0F6B              ; 2B59 cd 6b 0f
         LXI  H,35A2h             ; 2B5C 21 a2 35
         RST  3                   ; 2B5F df
         LDA  A859h               ; 2B60 3a 59 a8
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
         SHLD A93Dh               ; 2B75 22 3d a9
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
         LDA  A93Ch               ; 2B8E 3a 3c a9
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
         .db 07h,1Ah,8Eh,2Dh,19h,3Eh,2Dh,1Bh,C3h,2Dh,1Fh,70h,2Dh,0Dh,E1h,2Bh ; 2BB5 |...-.>-..-.p-..+|
         .db 18h,04h,2Dh,08h,28h,2Dh,6Fh,2Dh,21h,80h,9Fh,3Eh,59h,BEh,C8h,2Ch ; 2BC5 |..-.(-o-!..>Y..,|
         .db C2h,D2h,2Bh,3Ah,3Eh,A9h,C6h,80h,6Fh,36h,59h,C9h,21h,51h,35h,11h ; 2BD5 |..+:>...o6Y.!Q5.|
         .db 63h,B6h,CDh,79h,39h,CDh,38h,10h,3Ah,8Dh,B6h,3Dh,C8h,3Ah,73h,B6h ; 2BE5 |c..y9.8.:..=.:s.|
         .db 32h,4Fh,35h,CDh,F3h,0Fh,21h,5Dh,35h,DFh,E5h,CDh,A2h,0Ah,E1h,3Ah ; 2BF5 |2O5...!]5......:|
         .db BEh,10h,32h,5Ch,2Ch,CDh,CDh,2Bh,CDh,E2h,3Bh,21h,4Eh,35h,11h,A7h ; 2C05 |..2\,..+..;!N5..|
         .db B6h,0Eh,07h,EFh,CDh,E9h,3Bh,3Ah,3Fh,A9h,C6h,02h,21h,A7h,B6h,77h ; 2C15 |......;:?...!..w|
         .db 23h,36h,44h,23h,E5h,21h,91h,3Eh,CDh,4Dh,0Eh,7Eh,E1h,77h,23h,3Ah ; 2C25 |#6D#.!.>.M.~.w#:|
         .db 3Fh,A9h,CDh,96h,2Ch,36h,0Dh,CDh,E9h,3Bh,21h,A7h,B6h,3Ah,3Ch,A9h ; 2C35 |?...,6...;!..:<.|
         .db F5h,0Fh,0Fh,0Fh,0Fh,E6h,0Fh,4Fh,F1h,C6h,02h,81h,77h,23h,79h,3Ch ; 2C45 |.......O....w#y<|
         .db CDh,96h,2Ch,36h,4Eh,23h,36h,58h,23h,EBh,21h,81h,9Fh,3Ah,3Ch,A9h ; 2C55 |..,6N#6X#.!..:<.|
         .db 4Fh,EFh,CDh,E9h,3Bh,21h,69h,35h,11h,A7h,B6h,0Eh,0Bh,EFh,CDh,E9h ; 2C65 |O...;!i5........|
         .db 3Bh,11h,A7h,B6h,21h,74h,35h,0Eh,05h,EFh,CDh,E9h,3Bh ; 2C75 |;...!t5.....;|
L_2C82:  CALL L_3C07              ; 2C82 cd 07 3c
         MVI  A,02h               ; 2C85 3e 02
         STA  0004h               ; 2C87 32 04 00
         LXI  H,3579h             ; 2C8A 21 79 35
         LXI  D,DF14h             ; 2C8D 11 14 df
         MVI  C,08h               ; 2C90 0e 08
         RST  5                   ; 2C92 ef
         JMP  L_200F              ; 2C93 c3 0f 20
L_2C96:  DCR  A                   ; 2C96 3d
         RZ                       ; 2C97 c8
         MVI  M,18h               ; 2C98 36 18
         INX  H                   ; 2C9A 23
         JMP  L_2C96              ; 2C9B c3 96 2c
L_2C9E:  LXI  H,0000h             ; 2C9E 21 00 00
         SHLD B68Dh               ; 2CA1 22 8d b6
         CALL L_3BE2              ; 2CA4 cd e2 3b
L_2CA7:  LDA  B68Dh               ; 2CA7 3a 8d b6
         CPI  02h                 ; 2CAA fe 02
         JZ   L_2C82              ; 2CAC ca 82 2c
         CALL L_3D24              ; 2CAF cd 24 3d
         LDA  B68Dh               ; 2CB2 3a 8d b6
         DCR  A                   ; 2CB5 3d
         RZ                       ; 2CB6 c8
         CPI  FFh                 ; 2CB7 fe ff
         CZ   L_3BE9              ; 2CB9 cc e9 3b
         JMP  L_2CA7              ; 2CBC c3 a7 2c
L_2CBF:  LXI  H,DF14h             ; 2CBF 21 14 df
         LDA  A859h               ; 2CC2 3a 59 a8
         ADI  0Ch                 ; 2CC5 c6 0c
         MOV  M,A                 ; 2CC7 77
         INX  H                   ; 2CC8 23
         LDA  B673h               ; 2CC9 3a 73 b6
         MOV  M,A                 ; 2CCC 77
         INX  H                   ; 2CCD 23
         MVI  M,3Ah               ; 2CCE 36 3a
         INX  H                   ; 2CD0 23
         XCHG                     ; 2CD1 eb
         LXI  H,B663h             ; 2CD2 21 63 b6
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
         LXI  H,A859h             ; 2CE7 21 59 a8
L_2CEA:  MOV  C,M                 ; 2CEA 4e
         INX  H                   ; 2CEB 23
         RST  5                   ; 2CEC ef
         JMP  L_200F              ; 2CED c3 0f 20
L_2CF0:  CALL L_3D24              ; 2CF0 cd 24 3d
         LDA  B68Dh               ; 2CF3 3a 8d b6
         DCR  A                   ; 2CF6 3d
         RZ                       ; 2CF7 c8
         LXI  D,DF14h             ; 2CF8 11 14 df
         LXI  H,B6A7h             ; 2CFB 21 a7 b6
         MOV  A,M                 ; 2CFE 7e
         STAX D                   ; 2CFF 12
         INX  D                   ; 2D00 13
         JMP  L_2CEA              ; 2D01 c3 ea 2c
         .db 3Ah,3Eh,A9h,4Fh,3Ah,3Dh,A9h,C6h,14h,47h,B9h,C8h,3Ah,3Ch,A9h,B9h ; 2D04 |:>.O:=...G..:<..|
         .db C8h,B8h,DAh,1Ah,2Dh,78h,F5h,3Ah,3Eh,A9h,CDh,DEh,2Dh,F1h,32h,3Eh ; 2D14 |....-x.:>...-.2>|
         .db A9h,C3h,D0h,2Dh,3Ah,3Dh,A9h,4Fh,3Ah,3Eh,A9h,B9h,C8h,CDh,DEh,2Dh ; 2D24 |...-:=.O:>.....-|
         .db 3Ah,3Dh,A9h,3Ch,32h,3Eh,A9h,C3h,D0h,2Dh,3Ah,3Eh,A9h,FEh,01h,C8h ; 2D34 |:=.<2>...-:>....|
         .db F5h,CDh,DEh,2Dh,3Ah,3Dh,A9h,4Fh,F1h,F5h,91h,FEh,01h,C2h,66h,2Dh ; 2D44 |...-:=.O......f-|
         .db CDh,0Ah,2Ah,3Eh,01h,32h,4Ah,35h,CDh,81h,34h,CDh,0Ah,2Ah,21h,3Dh ; 2D54 |..*>.2J5..4..*!=|
         .db A9h,35h,F1h,3Dh,CDh,D0h,2Dh,21h,3Eh,A9h,35h,C9h,3Ah,3Eh,A9h,C6h ; 2D64 |.5.=..-!>.5.:>..|
         .db 80h,6Fh,26h,9Fh,7Eh,FEh,4Eh,3Eh,4Eh,C2h,82h,2Dh,3Eh,59h,77h,3Ah ; 2D74 |.o&.~.N>N..->Yw:|
         .db 3Ch,A9h,4Fh,3Ah,3Eh,A9h,B9h,CAh,D0h,2Dh,3Ah,3Ch,A9h,4Fh,3Ah,3Eh ; 2D84 |<.O:>....-:<.O:>|
         .db A9h,B9h,C8h,F5h,CDh,DEh,2Dh,3Ah,3Dh,A9h,4Fh,F1h,F5h,91h,FEh,14h ; 2D94 |......-:=.O.....|
         .db C2h,B9h,2Dh,CDh,0Ah,2Ah,3Eh,02h,32h,4Ah,35h,CDh,81h,34h,CDh,0Ah ; 2DA4 |..-..*>.2J5..4..|
         .db 2Ah,21h,3Dh,A9h,34h,F1h,3Ch,CDh,D0h,2Dh,21h,3Eh,A9h,34h,C9h,CDh ; 2DB4 |*!=.4.<..-!>.4..|
         .db 0Ah,2Ah,CDh,15h,04h,CDh,0Ah,2Ah,E1h,C3h,F3h,0Fh  ; 2DC4 |.*.....*....|
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
         LXI  H,A93Dh             ; 2DE7 21 3d a9
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
L_2E54:  LXI  D,B663h             ; 2E54 11 63 b6
L_2E57:  CALL L_3979              ; 2E57 cd 79 39
L_2E5A:  CALL L_1038              ; 2E5A cd 38 10
L_2E5D:  LDA  B68Dh               ; 2E5D 3a 8d b6
L_2E60:  CPI  01h                 ; 2E60 fe 01
L_2E62:  RZ                       ; 2E62 c8
L_2E63:  LXI  H,35C9h             ; 2E63 21 c9 35
L_2E66:  LXI  D,A859h             ; 2E66 11 59 a8
L_2E69:  MVI  C,09h               ; 2E69 0e 09
L_2E6B:  RST  5                   ; 2E6B ef
L_2E6C:  CALL L_2F41              ; 2E6C cd 41 2f
         RET                      ; 2E6F c9
L_2E70:  XRA  A                   ; 2E70 af
L_2E71:  STA  B68Dh               ; 2E71 32 8d b6
L_2E74:  LDA  A854h               ; 2E74 3a 54 a8
L_2E77:  CPI  00h                 ; 2E77 fe 00
L_2E79:  JNZ  L_2E84              ; 2E79 c2 84 2e
L_2E7C:  LDA  A853h               ; 2E7C 3a 53 a8
L_2E7F:  CPI  15h                 ; 2E7F fe 15
L_2E81:  JC   L_2E8F              ; 2E81 da 8f 2e
L_2E84:  MVI  A,27h               ; 2E84 3e 27
L_2E86:  CALL L_2EE6              ; 2E86 cd e6 2e
L_2E89:  LXI  D,FFEDh             ; 2E89 11 ed ff
L_2E8C:  JMP  L_2F16              ; 2E8C c3 16 2f
L_2E8F:  CALL L_31BA              ; 2E8F cd ba 31
         MVI  A,01h               ; 2E92 3e 01
         STA  A853h               ; 2E94 32 53 a8
         JMP  L_33A5              ; 2E97 c3 a5 33
         .db 3Eh,01h,32h,4Ah,35h,3Ah,54h,A8h,FEh,00h,C2h,BDh,2Eh,3Ah,53h,A8h ; 2E9A |>.2J5:T......:S.|
         .db FEh,03h,D2h,BDh,2Eh,FEh,01h,C8h,CDh,BAh,31h,3Eh,01h,32h,53h,A8h ; 2EAA |..........1>.2S.|
         .db C3h,CAh,2Eh                                      ; 2EBA |...|
L_2EBD:  LHLD A853h               ; 2EBD 2a 53 a8
         DCX  H                   ; 2EC0 2b
         SHLD A853h               ; 2EC1 22 53 a8
         CALL L_318E              ; 2EC4 cd 8e 31
         CALL L_32C3              ; 2EC7 cd c3 32
         CALL L_336B              ; 2ECA cd 6b 33
         MVI  C,13h               ; 2ECD 0e 13
L_2ECF:  PUSH B                   ; 2ECF c5
         CALL L_32E7              ; 2ED0 cd e7 32
         POP  B                   ; 2ED3 c1
         DCR  C                   ; 2ED4 0d
         JNZ  L_2ECF              ; 2ED5 c2 cf 2e
         JMP  L_0FF3              ; 2ED8 c3 f3 0f
         .db 3Eh,13h,CDh,E6h,2Eh,CDh,4Eh,27h,C3h,A5h,33h      ; 2EDB |>.....N'..3|
L_2EE6:  LXI  H,A840h             ; 2EE6 21 40 a8
L_2EE9:  SUB  M                   ; 2EE9 96
L_2EEA:  PUSH PSW                 ; 2EEA f5
L_2EEB:  CALL L_32C3              ; 2EEB cd c3 32
L_2EEE:  POP  PSW                 ; 2EEE f1
L_2EEF:  DCR  A                   ; 2EEF 3d
L_2EF0:  JNZ  L_2EEA              ; 2EF0 c2 ea 2e
L_2EF3:  RET                      ; 2EF3 c9
         .db 3Ah,57h,A8h,C6h,10h,32h,57h,A8h,CDh,8Eh,31h,C3h,A5h,33h,3Ah,57h ; 2EF4 |:W...2W...1..3:W|
         .db A8h,D6h,10h,C3h,F9h,2Eh                          ; 2F04 |......|
L_2F0A:  LDA  B68Dh               ; 2F0A 3a 8d b6
L_2F0D:  CPI  4Dh                 ; 2F0D fe 4d
L_2F0F:  RZ                       ; 2F0F c8
L_2F10:  CALL L_32C3              ; 2F10 cd c3 32
L_2F13:  LXI  D,0013h             ; 2F13 11 13 00
L_2F16:  LHLD A853h               ; 2F16 2a 53 a8
L_2F19:  DAD  D                   ; 2F19 19
L_2F1A:  SHLD A853h               ; 2F1A 22 53 a8
L_2F1D:  JMP  L_33A5              ; 2F1D c3 a5 33
         .db CDh,FEh,27h,CDh,8Eh,31h,C3h,A5h,33h,3Eh,02h,32h,4Ah,35h,3Ah,8Dh ; 2F20 |..'..1..3>.2J5:.|
         .db B6h,FEh,4Dh,C8h,2Ah,53h,A8h,23h,22h,53h,A8h,CDh,5Ah,33h,C3h,F3h ; 2F30 |..M.*S.#"S..Z3..|
         .db 0Fh                                              ; 2F40 |.|
L_2F41:  LXI  H,35DEh             ; 2F41 21 de 35
L_2F44:  RST  3                   ; 2F44 df
L_2F45:  CALL L_0FF3              ; 2F45 cd f3 0f
L_2F48:  LXI  H,0000h             ; 2F48 21 00 00
L_2F4B:  SHLD A857h               ; 2F4B 22 57 a8
L_2F4E:  CALL L_1821              ; 2F4E cd 21 18
L_2F51:  CALL L_33A5              ; 2F51 cd a5 33
L_2F54:  LXI  H,36BFh             ; 2F54 21 bf 36
L_2F57:  RST  3                   ; 2F57 df
L_2F58:  CALL L_0D44              ; 2F58 cd 44 0d
L_2F5B:  LXI  H,2F64h             ; 2F5B 21 64 2f
L_2F5E:  CALL L_0562              ; 2F5E cd 62 05
L_2F61:  JMP  L_2F54              ; 2F61 c3 54 2f
         .db 0Dh,03h,29h,2Fh,00h,9Ah,2Eh,0Ch,36h,31h,02h,91h,2Fh,0Dh,07h,30h ; 2F64 |..)/....61../..0|
         .db 0Ah,EAh,2Fh,1Bh,65h,31h,19h,70h,2Eh,18h,F4h,2Eh,08h,02h,2Fh,01h ; 2F74 |../.e1.p....../.|
         .db 20h,2Fh,1Fh,DBh,2Eh,1Ah,0Ah,2Fh,F3h,0Fh,2Ah,40h,A8h,CDh,DCh,31h ; 2F84 | /...../..*@...1|
         .db FEh,04h,C8h,CDh,8Eh,31h,21h,6Bh,36h,22h,8Dh,B6h,DFh,CDh,7Eh,20h ; 2F94 |.....1!k6"....~ |
         .db E1h,22h,38h,A9h,CDh,F3h,0Fh                      ; 2FA4 |."8....|
L_2FAB:  LHLD A938h               ; 2FAB 2a 38 a9
         MVI  A,00h               ; 2FAE 3e 00
         CMP  H                   ; 2FB0 bc
         JNZ  L_2FBE              ; 2FB1 c2 be 2f
         CMP  L                   ; 2FB4 bd
         JNZ  L_2FBE              ; 2FB5 c2 be 2f
L_2FB8:  CALL L_33A5              ; 2FB8 cd a5 33
         JMP  L_0FE0              ; 2FBB c3 e0 0f
L_2FBE:  DCX  H                   ; 2FBE 2b
         SHLD A938h               ; 2FBF 22 38 a9
         LDA  B68Dh               ; 2FC2 3a 8d b6
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
         .db 3Ah,37h,A9h,32h,47h,36h,C3h,E0h,0Fh,CDh,F3h,0Fh,3Ah,47h,36h,32h ; 2FE1 |:7.2G6......:G62|
         .db 37h,A9h,21h,32h,36h,DFh,11h,46h,36h,0Eh,0Ah,CDh,05h,00h,3Ah,47h ; 2FF1 |7.!26..F6.....:G|
         .db 36h,FEh,00h,CAh,E1h,2Fh                          ; 3001 |6..../|
L_3007:  LDA  B68Dh               ; 3007 3a 8d b6
L_300A:  CPI  4Dh                 ; 300A fe 4d
L_300C:  JZ   L_0FE0              ; 300C ca e0 0f
L_300F:  CALL L_318E              ; 300F cd 8e 31
L_3012:  CALL L_32E7              ; 3012 cd e7 32
L_3015:  LHLD A853h               ; 3015 2a 53 a8
L_3018:  INX  H                   ; 3018 23
L_3019:  SHLD A853h               ; 3019 22 53 a8
L_301C:  LHLD A855h               ; 301C 2a 55 a8
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
L_3052:  LHLD A853h               ; 3052 2a 53 a8
L_3055:  INX  H                   ; 3055 23
L_3056:  SHLD A853h               ; 3056 22 53 a8
L_3059:  POP  H                   ; 3059 e1
L_305A:  RET                      ; 305A c9
L_305B:  LHLD A855h               ; 305B 2a 55 a8
         CALL L_306F              ; 305E cd 6f 30
         LDA  B68Dh               ; 3061 3a 8d b6
         CPI  4Dh                 ; 3064 fe 4d
         RZ                       ; 3066 c8
         LHLD A853h               ; 3067 2a 53 a8
         INX  H                   ; 306A 23
         SHLD A853h               ; 306B 22 53 a8
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
L_308F:  LDA  A853h               ; 308F 3a 53 a8
         INR  A                   ; 3092 3c
         STA  A853h               ; 3093 32 53 a8
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
         CALL F80Fh               ; 30BB cd 0f f8
         XRA  A                   ; 30BE af
         POP  H                   ; 30BF e1
         RET                      ; 30C0 c9
L_30C1:  PUSH B                   ; 30C1 c5
         MVI  E,FFh               ; 30C2 1e ff
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
L_3108:  CPI  C0h                 ; 3108 fe c0
         RC                       ; 310A d8
         CPI  E0h                 ; 310B fe e0
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
L_312D:  CPI  C0h                 ; 312D fe c0
         RC                       ; 312F d8
         SUI  80h                 ; 3130 d6 80
         STA  L_3549              ; 3132 32 49 35
         RET                      ; 3135 c9
         .db 3Ah,9Dh,B6h,FEh,03h,C8h,21h,86h                  ; 3136 |:.....!.|
L_313E:  MVI  M,DFh               ; 313E 36 df
         MVI  A,28h               ; 3140 3e 28
         MVI  C,20h               ; 3142 0e 20
L_3144:  RST  4                   ; 3144 e7
         DCR  A                   ; 3145 3d
         JNZ  L_3144              ; 3146 c2 44 31
         LXI  H,368Bh             ; 3149 21 8b 36
         RST  3                   ; 314C df
         LXI  H,A859h             ; 314D 21 59 a8
         CALL L_0F6B              ; 3150 cd 6b 0f
         LDA  B69Dh               ; 3153 3a 9d b6
         STA  A94Eh               ; 3156 32 4e a9
         LXI  H,0003h             ; 3159 21 03 00
         SHLD B69Dh               ; 315C 22 9d b6
         CALL L_318E              ; 315F cd 8e 31
         JMP  L_33A5              ; 3162 c3 a5 33
         .db 0Eh,10h,11h,5Ch,00h,CDh,05h,00h,CDh,E0h,0Fh,3Ah,9Dh,B6h,F5h,3Eh ; 3165 |...\.......:...>|
         .db 03h,32h,9Dh,B6h,CDh,15h,04h,F1h,32h,9Dh,B6h,FEh,03h,CCh,87h,31h ; 3175 |.2......2......1|
         .db E1h,C9h,3Ah,4Eh,A9h,32h,9Dh,B6h,C9h              ; 3185 |..:N.2...|
L_318E:  LHLD A853h               ; 318E 2a 53 a8
L_3191:  DCX  H                   ; 3191 2b
L_3192:  XRA  A                   ; 3192 af
L_3193:  CMP  H                   ; 3193 bc
L_3194:  JNZ  L_319B              ; 3194 c2 9b 31
L_3197:  CMP  L                   ; 3197 bd
L_3198:  JZ   L_31BA              ; 3198 ca ba 31
L_319B:  LDA  A840h               ; 319B 3a 40 a8
         MOV  C,A                 ; 319E 4f
         MVI  A,14h               ; 319F 3e 14
         SUB  C                   ; 31A1 91
         MOV  C,A                 ; 31A2 4f
L_31A3:  PUSH B                   ; 31A3 c5
         CALL L_32C3              ; 31A4 cd c3 32
         POP  B                   ; 31A7 c1
         DCR  C                   ; 31A8 0d
         JNZ  L_31A3              ; 31A9 c2 a3 31
         RET                      ; 31AC c9
         .db 3Ah,9Dh,B6h,3Dh,C2h,B6h,31h,3Eh,02h,32h,9Dh,B6h,C9h ; 31AD |:..=..1>.2...|
L_31BA:  LXI  D,005Ch             ; 31BA 11 5c 00
L_31BD:  MVI  C,10h               ; 31BD 0e 10
L_31BF:  CALL 0005h               ; 31BF cd 05 00
L_31C2:  JMP  L_1821              ; 31C2 c3 21 18
L_31C5:  LHLD A853h               ; 31C5 2a 53 a8
         DCX  H                   ; 31C8 2b
         MOV  A,H                 ; 31C9 7c
         CPI  00h                 ; 31CA fe 00
         JNZ  L_32C3              ; 31CC c2 c3 32
         MOV  A,L                 ; 31CF 7d
         CPI  00h                 ; 31D0 fe 00
         JNZ  L_32C3              ; 31D2 c2 c3 32
         LXI  H,A000h             ; 31D5 21 00 a0
         SHLD A855h               ; 31D8 22 55 a8
         RET                      ; 31DB c9
L_31DC:  LXI  D,0403h             ; 31DC 11 03 04
         LXI  H,3690h             ; 31DF 21 90 36
         CALL L_0CF1              ; 31E2 cd f1 0c
         MVI  D,1Bh               ; 31E5 16 1b
         CMP  D                   ; 31E7 ba
         JNZ  L_31ED              ; 31E8 c2 ed 31
         MVI  A,04h               ; 31EB 3e 04
L_31ED:  STA  L_354D              ; 31ED 32 4d 35
         RET                      ; 31F0 c9
         .db 21h,91h,3Eh,CDh,4Dh,0Eh,7Eh,32h,73h,B6h,CDh,DCh,31h,FEh,04h,CAh ; 31F1 |!.>.M.~2s...1...|
         .db E0h,0Fh,CDh,DFh,29h,CDh,F3h,0Fh,21h,90h,36h,DFh,21h,00h,00h,22h ; 3201 |....)...!.6.!.."|
         .db 3Eh,A8h,CDh,EEh,18h,21h,00h,61h,01h,00h,40h,C5h,D7h,FEh,1Ah,CAh ; 3211 |>....!.a..@.....|
         .db 39h,32h,CDh,99h,30h,FEh,1Bh,CAh,39h,32h,C1h,23h,0Bh,78h,B1h,C2h ; 3221 |92..0...92.#.x..|
         .db 1Ch,32h,CDh,3Dh,32h,C3h,16h,32h                  ; 3231 |.2.=2..2|
L_3239:  POP  B                   ; 3239 c1
         JMP  L_0FE0              ; 323A c3 e0 0f
         .db 2Ah,3Eh,A8h,11h,80h,00h,19h,22h,3Eh,A8h,C3h,EEh,18h ; 323D |*>.....">....|
L_324A:  MVI  A,F8h               ; 324A 3e f8
         ANA  E                   ; 324C a3
         MOV  E,A                 ; 324D 5f
         CPI  00h                 ; 324E fe 00
         JNZ  L_3268              ; 3250 c2 68 32
         JMP  L_3282              ; 3253 c3 82 32
L_3256:  STA  L_354B              ; 3256 32 4b 35
         CALL L_101B              ; 3259 cd 1b 10
L_325C:  LHLD A857h               ; 325C 2a 57 a8
L_325F:  XCHG                     ; 325F eb
L_3260:  LHLD A855h               ; 3260 2a 55 a8
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
L_32B8:  SHLD A855h               ; 32B8 22 55 a8
L_32BB:  RET                      ; 32BB c9
         .db 00h,C9h                                          ; 32BC |..|
L_32BE:  INR  L                   ; 32BE 2c
L_32BF:  CZ   L_3340              ; 32BF cc 40 33
L_32C2:  RET                      ; 32C2 c9
L_32C3:  LHLD A855h               ; 32C3 2a 55 a8
L_32C6:  RST  2                   ; 32C6 d7
L_32C7:  CPI  1Ah                 ; 32C7 fe 1a
L_32C9:  JZ   L_32D3              ; 32C9 ca d3 32
L_32CC:  DCR  L                   ; 32CC 2d
L_32CD:  MOV  A,L                 ; 32CD 7d
L_32CE:  CPI  FFh                 ; 32CE fe ff
L_32D0:  CZ   L_334E              ; 32D0 cc 4e 33
L_32D3:  DCR  L                   ; 32D3 2d
L_32D4:  MOV  A,L                 ; 32D4 7d
L_32D5:  CPI  FFh                 ; 32D5 fe ff
L_32D7:  CZ   L_334E              ; 32D7 cc 4e 33
L_32DA:  RST  2                   ; 32DA d7
L_32DB:  CPI  0Dh                 ; 32DB fe 0d
L_32DD:  JNZ  L_32D3              ; 32DD c2 d3 32
L_32E0:  CALL L_32BE              ; 32E0 cd be 32
L_32E3:  SHLD A855h               ; 32E3 22 55 a8
L_32E6:  RET                      ; 32E6 c9
L_32E7:  LHLD A855h               ; 32E7 2a 55 a8
L_32EA:  RST  2                   ; 32EA d7
L_32EB:  CPI  1Ah                 ; 32EB fe 1a
L_32ED:  JZ   L_32FC              ; 32ED ca fc 32
L_32F0:  CPI  0Dh                 ; 32F0 fe 0d
L_32F2:  JZ   L_32E0              ; 32F2 ca e0 32
L_32F5:  INR  L                   ; 32F5 2c
L_32F6:  CZ   L_3340              ; 32F6 cc 40 33
L_32F9:  JMP  L_32EA              ; 32F9 c3 ea 32
L_32FC:  SHLD A855h               ; 32FC 22 55 a8
         LXI  H,004Dh             ; 32FF 21 4d 00
         SHLD B68Dh               ; 3302 22 8d b6
         RET                      ; 3305 c9
L_3306:  POP  PSW                 ; 3306 f1
L_3307:  JMP  L_329C              ; 3307 c3 9c 32
L_330A:  POP  PSW                 ; 330A f1
L_330B:  PUSH H                   ; 330B e5
         LXI  H,004Dh             ; 330C 21 4d 00
         SHLD B68Dh               ; 330F 22 8d b6
         POP  H                   ; 3312 e1
         JMP  L_329C              ; 3313 c3 9c 32
L_3316:  PUSH PSW                 ; 3316 f5
L_3317:  DCR  E                   ; 3317 1d
L_3318:  MVI  A,F8h               ; 3318 3e f8
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
         PUSH PSW                 ; 332E f5
         MVI  C,5Eh               ; 332F 0e 5e
         RST  4                   ; 3331 e7
         MVI  C,40h               ; 3332 0e 40
         DCR  E                   ; 3334 1d
         JZ   L_333B              ; 3335 ca 3b 33
         POP  PSW                 ; 3338 f1
         ADD  C                   ; 3339 81
         RET                      ; 333A c9
L_333B:  POP  PSW                 ; 333B f1
         POP  B                   ; 333C c1
         JMP  L_329C              ; 333D c3 9c 32
L_3340:  PUSH D                   ; 3340 d5
L_3341:  PUSH H                   ; 3341 e5
L_3342:  LXI  H,0000h             ; 3342 21 00 00
L_3345:  SHLD B68Dh               ; 3345 22 8d b6
L_3348:  CALL L_1855              ; 3348 cd 55 18
L_334B:  POP  H                   ; 334B e1
L_334C:  POP  D                   ; 334C d1
L_334D:  RET                      ; 334D c9
L_334E:  PUSH H                   ; 334E e5
L_334F:  LXI  H,0001h             ; 334F 21 01 00
L_3352:  SHLD B68Dh               ; 3352 22 8d b6
L_3355:  CALL L_1855              ; 3355 cd 55 18
L_3358:  POP  H                   ; 3358 e1
L_3359:  RET                      ; 3359 c9
         .db CDh,84h,33h,3Ah,38h,35h,C6h,14h,CDh,75h,34h      ; 335A |..3:85...u4|
L_3365:  CALL L_33E9              ; 3365 cd e9 33
         JMP  L_3256              ; 3368 c3 56 32
L_336B:  CALL L_3384              ; 336B cd 84 33
         CALL L_3471              ; 336E cd 71 34
         CALL L_3365              ; 3371 cd 65 33
         LDA  A840h               ; 3374 3a 40 a8
         CPI  00h                 ; 3377 fe 00
         RZ                       ; 3379 c8
         DCR  A                   ; 337A 3d
         STA  A840h               ; 337B 32 40 a8
         MVI  A,4Dh               ; 337E 3e 4d
         STA  B68Dh               ; 3380 32 8d b6
         RET                      ; 3383 c9
L_3384:  XRA  A                   ; 3384 af
         STA  B68Dh               ; 3385 32 8d b6
         CALL L_3481              ; 3388 cd 81 34
         CALL L_3451              ; 338B cd 51 34
         LDA  L_3534              ; 338E 3a 34 35
         ADI  0Fh                 ; 3391 c6 0f
         STA  L_3534              ; 3393 32 34 35
         CALL L_3419              ; 3396 cd 19 34
         LXI  H,3531h             ; 3399 21 31 35
         RST  3                   ; 339C df
         MVI  A,04h               ; 339D 3e 04
         LXI  H,3524h             ; 339F 21 24 35
         JMP  L_0F75              ; 33A2 c3 75 0f
L_33A5:  XRA  A                   ; 33A5 af
L_33A6:  STA  B68Dh               ; 33A6 32 8d b6
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
L_33D4:  LDA  B68Dh               ; 33D4 3a 8d b6
L_33D7:  CPI  4Dh                 ; 33D7 fe 4d
L_33D9:  JZ   L_33F4              ; 33D9 ca f4 33
L_33DC:  DCR  B                   ; 33DC 05
L_33DD:  JNZ  L_33CC              ; 33DD c2 cc 33
L_33E0:  LXI  H,0000h             ; 33E0 21 00 00
L_33E3:  SHLD A840h               ; 33E3 22 40 a8
L_33E6:  JMP  L_0FF3              ; 33E6 c3 f3 0f
L_33E9:  LDA  B69Dh               ; 33E9 3a 9d b6
L_33EC:  CPI  03h                 ; 33EC fe 03
L_33EE:  MVI  A,28h               ; 33EE 3e 28
L_33F0:  RNZ                      ; 33F0 c0
         MVI  A,50h               ; 33F1 3e 50
         RET                      ; 33F3 c9
L_33F4:  DCR  B                   ; 33F4 05
         MOV  L,B                 ; 33F5 68
         MVI  H,00h               ; 33F6 26 00
         JMP  L_33E3              ; 33F8 c3 e3 33
L_33FB:  LHLD A857h               ; 33FB 2a 57 a8
L_33FE:  LXI  D,FF9Ch             ; 33FE 11 9c ff
L_3401:  CALL L_3441              ; 3401 cd 41 34
L_3404:  STA  L_352B              ; 3404 32 2b 35
L_3407:  LXI  D,FFF6h             ; 3407 11 f6 ff
L_340A:  CALL L_3441              ; 340A cd 41 34
L_340D:  STA  L_352C              ; 340D 32 2c 35
L_3410:  LXI  D,FFFFh             ; 3410 11 ff ff
L_3413:  CALL L_3441              ; 3413 cd 41 34
L_3416:  STA  L_352D              ; 3416 32 2d 35
L_3419:  LHLD A853h               ; 3419 2a 53 a8
L_341C:  LXI  D,FC18h             ; 341C 11 18 fc
L_341F:  CALL L_3441              ; 341F cd 41 34
L_3422:  STA  L_3524              ; 3422 32 24 35
L_3425:  LXI  D,FF9Ch             ; 3425 11 9c ff
L_3428:  CALL L_3441              ; 3428 cd 41 34
L_342B:  STA  L_3525              ; 342B 32 25 35
L_342E:  LXI  D,FFF6h             ; 342E 11 f6 ff
L_3431:  CALL L_3441              ; 3431 cd 41 34
L_3434:  STA  L_3526              ; 3434 32 26 35
L_3437:  LXI  D,FFFFh             ; 3437 11 ff ff
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
L_3451:  LDA  B69Dh               ; 3451 3a 9d b6
L_3454:  DCR  A                   ; 3454 3d
L_3455:  JZ   L_3464              ; 3455 ca 64 34
L_3458:  LXI  H,2020h             ; 3458 21 20 20
L_345B:  SHLD L_3533              ; 345B 22 33 35
L_345E:  LXI  H,2021h             ; 345E 21 21 20
L_3461:  JMP  L_346D              ; 3461 c3 6d 34
L_3464:  LXI  H,4820h             ; 3464 21 20 48
         SHLD L_3533              ; 3467 22 33 35
         LXI  H,4821h             ; 346A 21 21 48
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
L_348A:  LDA  B69Dh               ; 348A 3a 9d b6
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
L_349E:  MVI  H,A1h               ; 349E 26 a1
L_34A0:  CALL L_3504              ; 34A0 cd 04 35
L_34A3:  MVI  H,C1h               ; 34A3 26 c1
L_34A5:  JMP  L_34AF              ; 34A5 c3 af 34
L_34A8:  MVI  H,D0h               ; 34A8 26 d0
L_34AA:  CALL L_3504              ; 34AA cd 04 35
L_34AD:  MVI  H,B0h               ; 34AD 26 b0
L_34AF:  CALL L_3504              ; 34AF cd 04 35
L_34B2:  MVI  A,23h               ; 34B2 3e 23
L_34B4:  OUT  10h                 ; 34B4 d3 10
L_34B6:  POP  H                   ; 34B6 e1
L_34B7:  SPHL                     ; 34B7 f9
L_34B8:  EI                       ; 34B8 fb
L_34B9:  RET                      ; 34B9 c9
L_34BA:  PUSH B                   ; 34BA c5
         XCHG                     ; 34BB eb
         LXI  H,0000h             ; 34BC 21 00 00
         DAD  SP                  ; 34BF 39
         SHLD L_34E1              ; 34C0 22 e1 34
         MOV  H,D                 ; 34C3 62
         DCR  A                   ; 34C4 3d
         MOV  A,H                 ; 34C5 7c
         JZ   L_34EA              ; 34C6 ca ea 34
L_34C9:  MVI  E,DFh               ; 34C9 1e df
         MVI  L,EAh               ; 34CB 2e ea
         SPHL                     ; 34CD f9
         XCHG                     ; 34CE eb
         MVI  C,5Eh               ; 34CF 0e 5e
L_34D1:  MOV  D,M                 ; 34D1 56
         DCR  L                   ; 34D2 2d
         MOV  E,M                 ; 34D3 5e
         DCR  L                   ; 34D4 2d
         PUSH D                   ; 34D5 d5
         DCR  C                   ; 34D6 0d
         JNZ  L_34D1              ; 34D7 c2 d1 34
         INR  H                   ; 34DA 24
         MOV  D,H                 ; 34DB 54
         DCR  B                   ; 34DC 05
         JNZ  L_34C9              ; 34DD c2 c9 34
L_34E0:  LXI  SP,0000h            ; 34E0 31 00 00
         POP  B                   ; 34E3 c1
         MOV  H,A                 ; 34E4 67
         MVI  C,0Bh               ; 34E5 0e 0b
         JMP  L_350F              ; 34E7 c3 0f 35
L_34EA:  MVI  E,23h               ; 34EA 1e 23
         MVI  L,2Dh               ; 34EC 2e 2d
         MVI  C,5Eh               ; 34EE 0e 5e
         SPHL                     ; 34F0 f9
         XCHG                     ; 34F1 eb
L_34F2:  POP  D                   ; 34F2 d1
         MOV  M,E                 ; 34F3 73
         INR  L                   ; 34F4 2c
         MOV  M,D                 ; 34F5 72
         INR  L                   ; 34F6 2c
         DCR  C                   ; 34F7 0d
         JNZ  L_34F2              ; 34F8 c2 f2 34
         INR  H                   ; 34FB 24
         MOV  D,H                 ; 34FC 54
         DCR  B                   ; 34FD 05
         JNZ  L_34EA              ; 34FE c2 ea 34
         JMP  L_34E0              ; 3501 c3 e0 34
L_3504:  LDA  L_354A              ; 3504 3a 4a 35
L_3507:  ANA  A                   ; 3507 a7
L_3508:  JNZ  L_34BA              ; 3508 c2 ba 34
L_350B:  MVI  C,CFh               ; 350B 0e cf
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
         .db F3h,2Dh,20h,20h,20h,20h,20h,F0h,2Dh,20h,20h,20h,20h,20h,00h,1Bh ; 3522 |.-     .-     ..|
         .db 59h,00h,00h,00h,1Bh,59h,20h,20h,00h,20h,20h,20h,20h,20h,20h,20h ; 3532 |Y....Y  .       |
         .db 20h,20h,20h,20h,20h,20h,00h,00h,00h,00h,00h,00h,06h,58h,3Ah,41h ; 3542 |      .......X:A|
         .db 52h,43h,32h,20h,20h,20h,20h,20h,43h,4Fh,4Dh,F2h,C1h,D3h,D0h,C1h ; 3552 |RC2     COM.....|
         .db CBh,CFh,D7h,CBh,C1h,20h,00h,0Ah,45h,20h,43h,3Ah,43h,4Fh,2Eh,54h ; 3562 |..... ..E C:CO.T|
         .db 4Fh,4Bh,04h,43h,3Ah,43h,4Fh,07h,3Ch,43h,4Fh,2Eh,54h,4Fh,4Bh,1Bh ; 3572 |OK.C:CO.<CO.TOK.|
         .db 59h,20h,20h,20h,00h,20h,20h,20h,20h,20h,EBh,C2h,20h,20h,00h,20h ; 3582 |Y   .     ..  . |
         .db 20h,20h,20h,25h,20h,00h,1Bh,59h,20h,20h,1Bh,62h,20h,20h,20h,00h ; 3592 |   % ..Y  .b   .|
         .db 20h,20h,20h,20h,20h,EBh,C2h,00h,20h,20h,E6h,C1h,CAh,CCh,CFh,D7h ; 35A2 |     ...  ......|
         .db 20h,20h,20h,20h,20h,20h,20h,20h,1Bh,61h,00h,3Fh,3Fh,3Fh,3Fh,3Fh ; 35B2 |        .a.?????|
         .db 3Fh,3Fh,3Fh,00h,50h,4Bh,32h,07h,20h,F0h,CFh,CDh,CFh,DDh,D8h,00h ; 35C2 |???.PK2. .......|
         .db 43h,4Fh,20h,20h,20h,20h,20h,20h,20h,48h,4Ch,50h,1Bh,59h,38h,20h ; 35D2 |CO       HLP.Y8 |
         .db 46h,31h,2Dh,F7h,D7h,C5h,D2h,C8h,20h,46h,32h,2Dh,FBh,D2h,C9h,C6h ; 35E2 |F1-..... F2-....|
         .db D4h,20h,46h,33h,2Dh,F0h,C5h,DEh,C1h,D4h,D8h,20h,46h,34h,2Dh,F7h ; 35F2 |. F3-...... F4-.|
         .db CEh,C9h,DAh,20h,43h,54h,50h,2Dh,EBh,20h,D3h,D4h,D2h,CFh,CBh,C5h ; 3602 |... CTP-. ......|
         .db 20h,23h,20h,F0h,F3h,2Dh,F0h,CFh,C9h,D3h,CBh,20h,F7h,EBh,2Dh,F0h ; 3612 | # ..-..... ..-.|
         .db CFh,C9h,D3h,CBh,20h,D3h,CCh,C5h,C4h,D5h,C0h,DDh,C5h,C7h,CFh,00h ; 3622 |.... ...........|
         .db 20h,F0h,CFh,C9h,D3h,CBh,20h,D0h,CFh,C4h,D3h,D4h,D2h,CFh,CBh,C9h ; 3632 | ..... .........|
         .db 20h,2Dh,20h,00h,23h,01h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h ; 3642 | - .#.          |
         .db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h ; 3652 |                |
         .db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,F3h,CBh,CFh,CCh,D8h,CBh ; 3662 |          ......|
         .db CFh,20h,D3h,D4h,D2h,CFh,CBh,20h,D0h,C5h,DEh,C1h,D4h,C1h,D4h,D8h ; 3672 |. ..... ........|
         .db 20h,2Dh,20h,00h,1Bh,59h,20h,48h,00h,1Bh,59h,20h,61h,00h,F0h,C5h ; 3682 | - ..Y H..Y a...|
         .db DEh,C1h,D4h,D8h,00h,F0h,D2h,D1h,CDh,CFh,CAh,5Fh,D7h,D9h,D7h,CFh ; 3692 |..........._....|
         .db C4h,00h,F7h,5Fh,CEh,C1h,C2h,CFh,D2h,5Fh,38h,00h,F7h,5Fh,E1h,CCh ; 36A2 |..._....._8.._..|
         .db D8h,D4h,5Fh,EBh,CFh,C4h,5Fh,E7h,EFh,F3h,F4h,C1h,00h,1Bh,5Bh,00h ; 36B2 |.._..._.......[.|
         .db 21h,66h,A8h,C3h,CBh,36h,21h,59h,A8h,22h,E9h,36h,22h,0Bh,37h,21h ; 36C2 |!f...6!Y.".6".7!|
         .db 89h,B6h,CDh,47h,0Eh,7Eh,FEh,00h,C8h,3Ah,14h,DFh,FEh,37h,D0h,CDh ; 36D2 |...G.~...:...7..|
         .db 3Ah,39h,21h,14h,DFh,4Eh,3Ah,59h,A8h,C6h,03h,47h,81h,77h,79h,85h ; 36E2 |:9!..N:Y...G.wy.|
         .db 6Fh,3Ah,02h,A8h,FEh,00h,C4h,3Bh,37h,E5h,21h,91h,3Eh,CDh,4Dh,0Eh ; 36F2 |o:.....;7.!.>.M.|
         .db 7Eh,E1h,23h,77h,23h,36h,3Ah,23h,11h,59h,A8h,EBh,4Eh,23h,EFh,EBh ; 3702 |~.#w#6:#.Y..N#..|
         .db 36h,20h,C3h,EFh,27h                              ; 3712 |6 ..'|
L_3717:  LDA  DF14h               ; 3717 3a 14 df
         CPI  46h                 ; 371A fe 46
         RNC                      ; 371C d0
         LDA  A802h               ; 371D 3a 02 a8
         CPI  00h                 ; 3720 fe 00
         JZ   L_3754              ; 3722 ca 54 37
         MOV  C,A                 ; 3725 4f
         LXI  H,DF14h             ; 3726 21 14 df
         MOV  A,M                 ; 3729 7e
         ADD  L                   ; 372A 85
         MOV  L,A                 ; 372B 6f
         MOV  D,H                 ; 372C 54
         MOV  E,L                 ; 372D 5d
         INX  D                   ; 372E 13
         CALL L_374B              ; 372F cd 4b 37
         LDA  B693h               ; 3732 3a 93 b6
         STAX D                   ; 3735 12
         LXI  H,DF14h             ; 3736 21 14 df
         INR  M                   ; 3739 34
         RET                      ; 373A c9
         .db 48h,47h,21h,14h,DFh,7Eh,85h,5Fh,91h,6Fh,54h,48h,CDh,4Bh,37h,C9h ; 373B |HG!..~._.oTH.K7.|
L_374B:  MOV  A,M                 ; 374B 7e
         STAX D                   ; 374C 12
         DCX  D                   ; 374D 1b
         DCX  H                   ; 374E 2b
         DCR  C                   ; 374F 0d
         JNZ  L_374B              ; 3750 c2 4b 37
         RET                      ; 3753 c9
L_3754:  LXI  H,DF14h             ; 3754 21 14 df
         INR  M                   ; 3757 34
         MOV  A,M                 ; 3758 7e
         ADD  L                   ; 3759 85
         MOV  L,A                 ; 375A 6f
         LDA  B693h               ; 375B 3a 93 b6
         MOV  M,A                 ; 375E 77
         RET                      ; 375F c9
         .db 21h,91h,3Eh,CDh,4Dh,0Eh,7Eh,32h,73h,B6h,21h,27h,15h,C3h,7Ah,0Bh ; 3760 |!.>.M.~2s.!'..z.|
         .db 3Ah,9Bh,B6h,F5h,21h,89h,B6h,CDh,47h,0Eh,46h,04h,C5h,CDh,CAh,20h ; 3770 |:...!...G.F.... |
         .db C1h,3Eh,01h,11h,09h,00h,19h,E5h,F5h,C5h,32h,9Bh,B6h,CDh,A1h,37h ; 3780 |.>........2....7|
         .db C1h,F1h,E1h,11h,0Dh,00h,19h,3Ch,B8h,C2h,87h,37h,F1h,32h,9Bh,B6h ; 3790 |.......<...7.2..|
         .db C9h,11h,89h,3Eh,0Eh,03h,CDh,1Ah,38h,C0h,C3h,D1h,26h,CDh,0Ah,2Ah ; 37A0 |...>....8...&..*|
         .db CDh,CAh,20h,22h,EAh,37h,21h,89h,B6h,CDh,47h,0Eh,7Eh,32h,EDh,37h ; 37B0 |.. ".7!...G.~2.7|
         .db CDh,0Ah,2Ah,CDh,CAh,20h,22h,FFh,37h,21h,89h,B6h,CDh,47h,0Eh,4Eh ; 37C0 |..*.. ".7!...G.N|
         .db C5h,CDh,E9h,37h,C1h,2Ah,FFh,37h,11h,0Dh,00h,19h,22h,FFh,37h,0Dh ; 37D0 |...7.*.7....".7.|
         .db C2h,D0h,37h,CDh,F1h,11h,C3h,0Fh,09h,21h,00h,00h,0Eh,00h,E5h,C5h ; 37E0 |..7......!......|
         .db CDh,FEh,37h,C1h,E1h,11h,0Dh,00h,19h,0Dh,C2h,EEh,37h,C9h,11h,00h ; 37F0 |..7.........7...|
         .db 00h,0Eh,08h,1Ah,FEh,2Eh,C8h,CDh,1Ah,38h,C0h,23h,13h,0Eh,03h,CDh ; 3800 |.........8.#....|
         .db 1Ah,38h,C0h,21h,FCh,FFh,19h,36h,7Fh,C9h          ; 3810 |.8.!...6..|
L_381A:  LDAX D                   ; 381A 1a
         CMP  M                   ; 381B be
         RNZ                      ; 381C c0
         INX  H                   ; 381D 23
         INX  D                   ; 381E 13
         DCR  C                   ; 381F 0d
         JNZ  L_381A              ; 3820 c2 1a 38
         RET                      ; 3823 c9
         .db 3Ah,59h,A8h,C6h,0Ch,21h,A7h,B6h,77h,23h,3Ah,73h,B6h,77h,23h,36h ; 3824 |:Y...!..w#:s.w#6|
         .db 3Ah,23h,EBh,21h,9Fh,B6h,23h,0Eh,07h,EFh,EBh,36h,20h,23h,E5h,21h ; 3834 |:#.!..#....6 #.!|
         .db 91h,3Eh,CDh,4Dh,0Eh,7Eh,E1h,77h,23h,36h,3Ah,23h,EBh,21h,59h,A8h ; 3844 |.>.M.~.w#6:#.!Y.|
         .db 4Eh,23h,EFh,D5h,21h,9Fh,B6h,11h,05h,00h,19h,D1h,7Eh,FEh,44h,C8h ; 3854 |N#..!.......~.D.|
         .db FEh,52h,CAh,82h,38h,3Eh,22h,12h,13h,21h,A7h,B6h,46h,3Ah,66h,A8h ; 3864 |.R..8>"..!..F:f.|
         .db 4Fh,80h,C6h,02h,77h,21h,66h,A8h,23h,EFh,3Eh,22h,12h,C9h,3Ah,A7h ; 3874 |O...w!f.#.>"..:.|
         .db B6h,C6h,04h,32h,A7h,B6h,21h,85h,3Eh,0Eh,04h,EFh,C9h ; 3884 |...2..!.>....|
L_3891:  CALL L_393A              ; 3891 cd 3a 39
         LXI  H,B6A7h             ; 3894 21 a7 b6
         MOV  C,M                 ; 3897 4e
         INX  H                   ; 3898 23
         MVI  A,21h               ; 3899 3e 21
L_389B:  CMP  M                   ; 389B be
         CZ   L_38C9              ; 389C cc c9 38
         INX  H                   ; 389F 23
         DCR  C                   ; 38A0 0d
         JNZ  L_389B              ; 38A1 c2 9b 38
         LXI  H,B6A7h             ; 38A4 21 a7 b6
         MOV  C,M                 ; 38A7 4e
         INX  H                   ; 38A8 23
         MVI  A,21h               ; 38A9 3e 21
L_38AB:  CMP  M                   ; 38AB be
         CZ   L_38BA              ; 38AC cc ba 38
         INX  H                   ; 38AF 23
         DCR  C                   ; 38B0 0d
         JNZ  L_38AB              ; 38B1 c2 ab 38
         RET                      ; 38B4 c9
L_38B5:  MVI  A,21h               ; 38B5 3e 21
         POP  H                   ; 38B7 e1
         POP  B                   ; 38B8 c1
         RET                      ; 38B9 c9
L_38BA:  PUSH B                   ; 38BA c5
         PUSH H                   ; 38BB e5
         LDA  A866h               ; 38BC 3a 66 a8
         INR  A                   ; 38BF 3c
         LXI  H,A866h             ; 38C0 21 66 a8
         SHLD L_3906              ; 38C3 22 06 39
         JMP  L_38E3              ; 38C6 c3 e3 38
L_38C9:  PUSH B                   ; 38C9 c5
         PUSH H                   ; 38CA e5
         INX  H                   ; 38CB 23
         MVI  A,2Eh               ; 38CC 3e 2e
         CMP  M                   ; 38CE be
         JNZ  L_38B5              ; 38CF c2 b5 38
         INX  H                   ; 38D2 23
         MVI  A,21h               ; 38D3 3e 21
         CMP  M                   ; 38D5 be
         JNZ  L_38B5              ; 38D6 c2 b5 38
         LDA  A859h               ; 38D9 3a 59 a8
         DCR  A                   ; 38DC 3d
         LXI  H,A859h             ; 38DD 21 59 a8
         SHLD L_3906              ; 38E0 22 06 39
L_38E3:  LXI  H,B6A7h             ; 38E3 21 a7 b6
         ADD  M                   ; 38E6 86
         MOV  M,A                 ; 38E7 77
         MOV  E,A                 ; 38E8 5f
         MVI  D,00h               ; 38E9 16 00
         DAD  D                   ; 38EB 19
         XCHG                     ; 38EC eb
         POP  H                   ; 38ED e1
         PUSH H                   ; 38EE e5
         MVI  B,00h               ; 38EF 06 00
         DAD  B                   ; 38F1 09
         INX  D                   ; 38F2 13
         CALL L_3915              ; 38F3 cd 15 39
         PUSH H                   ; 38F6 e5
         LXI  H,3E91h             ; 38F7 21 91 3e
         CALL L_0E4D              ; 38FA cd 4d 0e
         MOV  A,M                 ; 38FD 7e
         POP  H                   ; 38FE e1
         MOV  M,A                 ; 38FF 77
         INX  H                   ; 3900 23
         MVI  M,3Ah               ; 3901 36 3a
         INX  H                   ; 3903 23
         XCHG                     ; 3904 eb
         LXI  H,0000h             ; 3905 21 00 00
         MOV  C,M                 ; 3908 4e
         INX  H                   ; 3909 23
L_390A:  MOV  A,M                 ; 390A 7e
         STAX D                   ; 390B 12
         INX  H                   ; 390C 23
         INX  D                   ; 390D 13
         DCR  C                   ; 390E 0d
         JNZ  L_390A              ; 390F c2 0a 39
         JMP  L_38B5              ; 3912 c3 b5 38
L_3915:  MOV  A,M                 ; 3915 7e
         STAX D                   ; 3916 12
         DCX  H                   ; 3917 2b
         DCX  D                   ; 3918 1b
         DCR  C                   ; 3919 0d
         JNZ  L_3915              ; 391A c2 15 39
         RET                      ; 391D c9
L_391E:  LXI  H,B69Fh             ; 391E 21 9f b6
         INX  H                   ; 3921 23
         LXI  D,B663h             ; 3922 11 63 b6
         MVI  C,07h               ; 3925 0e 07
         RST  5                   ; 3927 ef
         LXI  H,3E4Fh             ; 3928 21 4f 3e
         MVI  C,05h               ; 392B 0e 05
         RST  5                   ; 392D ef
         JMP  L_103B              ; 392E c3 3b 10
L_3931:  MVI  A,08h               ; 3931 3e 08
         SUB  C                   ; 3933 91
         STA  A866h               ; 3934 32 66 a8
         JMP  L_3957              ; 3937 c3 57 39
L_393A:  LHLD A842h               ; 393A 2a 42 a8
         PUSH H                   ; 393D e5
         CALL L_29DF              ; 393E cd df 29
         PUSH H                   ; 3941 e5
         LXI  D,A866h             ; 3942 11 66 a8
         MVI  A,08h               ; 3945 3e 08
         MOV  C,A                 ; 3947 4f
         STAX D                   ; 3948 12
         INX  D                   ; 3949 13
L_394A:  MOV  A,M                 ; 394A 7e
         CPI  20h                 ; 394B fe 20
         JZ   L_3931              ; 394D ca 31 39
         STAX D                   ; 3950 12
         INX  H                   ; 3951 23
         INX  D                   ; 3952 13
         DCR  C                   ; 3953 0d
         JNZ  L_394A              ; 3954 c2 4a 39
L_3957:  LXI  H,A866h             ; 3957 21 66 a8
         LXI  D,A859h             ; 395A 11 59 a8
         MOV  C,M                 ; 395D 4e
         INR  C                   ; 395E 0c
         RST  5                   ; 395F ef
         POP  H                   ; 3960 e1
         LXI  B,0009h             ; 3961 01 09 00
         DAD  B                   ; 3964 09
         MVI  A,2Eh               ; 3965 3e 2e
         STAX D                   ; 3967 12
         INX  D                   ; 3968 13
         MVI  C,03h               ; 3969 0e 03
         RST  5                   ; 396B ef
         LDA  A859h               ; 396C 3a 59 a8
         ADI  04h                 ; 396F c6 04
         STA  A859h               ; 3971 32 59 a8
         POP  H                   ; 3974 e1
         SHLD A842h               ; 3975 22 42 a8
         RET                      ; 3978 c9
L_3979:  MVI  C,0Ch               ; 3979 0e 0c
L_397B:  RST  5                   ; 397B ef
L_397C:  RET                      ; 397C c9
         .db 21h,48h,3Eh                                      ; 397D |!H>|
L_3980:  LXI  D,B663h             ; 3980 11 63 b6
         CALL L_3979              ; 3983 cd 79 39
         CALL L_1038              ; 3986 cd 38 10
         LDA  B68Dh               ; 3989 3a 8d b6
         DCR  A                   ; 398C 3d
         RZ                       ; 398D c8
         LDA  A801h               ; 398E 3a 01 a8
         ANI  40h                 ; 3991 e6 40
         JZ   L_399C              ; 3993 ca 9c 39
         CALL L_393A              ; 3996 cd 3a 39
         JMP  L_2CBF              ; 3999 c3 bf 2c
L_399C:  LXI  H,DF14h             ; 399C 21 14 df
         MVI  M,08h               ; 399F 36 08
         PUSH H                   ; 39A1 e5
         INX  H                   ; 39A2 23
         LDA  B673h               ; 39A3 3a 73 b6
         MOV  M,A                 ; 39A6 77
         INX  H                   ; 39A7 23
         MVI  M,3Ah               ; 39A8 36 3a
         INX  H                   ; 39AA 23
         LXI  D,B663h             ; 39AB 11 63 b6
         XCHG                     ; 39AE eb
         MVI  C,06h               ; 39AF 0e 06
         RST  5                   ; 39B1 ef
         POP  H                   ; 39B2 e1
         CALL L_13C6              ; 39B3 cd c6 13
         XRA  A                   ; 39B6 af
         STA  A802h               ; 39B7 32 02 a8
         JMP  L_0772              ; 39BA c3 72 07
         .db 21h,60h,3Eh,C3h,80h,39h,21h,54h,3Eh,C3h,80h,39h,CDh,7Dh,34h,CDh ; 39BD |!`>..9!T>..9.}4.|
         .db 51h,34h,21h,31h,35h,DFh,21h,6Ch,3Eh,DFh,21h,28h,B7h,3Eh,2Eh,36h ; 39CD |Q4!15.!l>.!(.>.6|
         .db 00h,23h,3Dh,C2h,DCh,39h,1Eh,00h,CDh,D7h,13h,CDh,D6h,3Bh,21h,28h ; 39DD |.#=..9.......;!(|
         .db B7h,2Bh,E5h                                      ; 39ED |.+.|
L_39F0:  CALL L_3BA0              ; 39F0 cd a0 3b
         LDA  B6A9h               ; 39F3 3a a9 b6
         CPI  29h                 ; 39F6 fe 29
         JNZ  L_3A24              ; 39F8 c2 24 3a
         LXI  H,B6A7h             ; 39FB 21 a7 b6
         LDA  B6A7h               ; 39FE 3a a7 b6
         CPI  28h                 ; 3A01 fe 28
         JC   L_3A0B              ; 3A03 da 0b 3a
         MVI  A,28h               ; 3A06 3e 28
         STA  B6A7h               ; 3A08 32 a7 b6
L_3A0B:  CALL L_3471              ; 3A0B cd 71 34
         LXI  H,B6A7h             ; 3A0E 21 a7 b6
         CALL L_0F6B              ; 3A11 cd 6b 0f
         LDA  B6A8h               ; 3A14 3a a8 b6
         CPI  30h                 ; 3A17 fe 30
         JZ   L_3A2A              ; 3A19 ca 2a 3a
         POP  H                   ; 3A1C e1
         INX  H                   ; 3A1D 23
         MOV  M,A                 ; 3A1E 77
         INX  H                   ; 3A1F 23
         PUSH H                   ; 3A20 e5
         JMP  L_39F0              ; 3A21 c3 f0 39
L_3A24:  POP  H                   ; 3A24 e1
         INR  M                   ; 3A25 34
         PUSH H                   ; 3A26 e5
         JMP  L_39F0              ; 3A27 c3 f0 39
L_3A2A:  POP  H                   ; 3A2A e1
         CALL L_13D3              ; 3A2B cd d3 13
L_3A2E:  CALL L_0FF3              ; 3A2E cd f3 0f
         CALL L_0D44              ; 3A31 cd 44 0d
         CPI  30h                 ; 3A34 fe 30
         JZ   L_0415              ; 3A36 ca 15 04
         CPI  1Bh                 ; 3A39 fe 1b
         JZ   L_0415              ; 3A3B ca 15 04
         PUSH PSW                 ; 3A3E f5
         CALL L_0492              ; 3A3F cd 92 04
         POP  PSW                 ; 3A42 f1
         LXI  H,B728h             ; 3A43 21 28 b7
         MVI  C,1Ah               ; 3A46 0e 1a
L_3A48:  CMP  M                   ; 3A48 be
         JZ   L_3A55              ; 3A49 ca 55 3a
         INX  H                   ; 3A4C 23
         INX  H                   ; 3A4D 23
         DCR  C                   ; 3A4E 0d
         JNZ  L_3A48              ; 3A4F c2 48 3a
         JMP  L_3A2E              ; 3A52 c3 2e 3a
L_3A55:  PUSH H                   ; 3A55 e5
         LXI  H,A000h             ; 3A56 21 00 a0
         SHLD A83Eh               ; 3A59 22 3e a8
         POP  H                   ; 3A5C e1
L_3A5D:  PUSH H                   ; 3A5D e5
         CALL L_3BA0              ; 3A5E cd a0 3b
         LXI  H,B6A9h             ; 3A61 21 a9 b6
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
L_3A7B:  LDA  B6ABh               ; 3A7B 3a ab b6
         CPI  3Ah                 ; 3A7E fe 3a
         JZ   L_200F              ; 3A80 ca 0f 20
         CALL L_1009              ; 3A83 cd 09 10
         LXI  H,3E15h             ; 3A86 21 15 3e
         RST  3                   ; 3A89 df
         MVI  C,0Fh               ; 3A8A 0e 0f
         LDA  B6ABh               ; 3A8C 3a ab b6
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
         .db 1Eh,00h,CDh,D7h,13h,CDh,C4h,3Ah,F5h,CDh,D3h,13h,F1h,C8h,CDh,DEh ; 3AAB |.......:........|
         .db 03h,C3h,C9h,39h,0Eh,08h,C3h,D2h,3Ah,0Eh,0Ch,CDh,D2h,3Ah,CDh,38h ; 3ABB |...9....:....:.8|
         .db 10h,3Ah,8Dh,B6h,FEh,01h,C9h                      ; 3ACB |.:.....|
L_3AD2:  LXI  H,3E24h             ; 3AD2 21 24 3e
L_3AD5:  LXI  D,B663h             ; 3AD5 11 63 b6
L_3AD8:  RST  5                   ; 3AD8 ef
L_3AD9:  RET                      ; 3AD9 c9
         .db 21h,43h,A9h,CDh,4Dh,0Eh,6Eh,26h,00h,22h,34h,A9h,11h,01h,03h,21h ; 3ADA |!C..M.n&."4....!|
         .db FDh,3Dh,CDh,F1h,0Ch,21h,8Dh,B6h,36h,00h,32h,36h,A9h,FEh,1Bh,C4h ; 3AEA |.=...!..6.26....|
         .db ACh,29h,C3h,E0h,0Fh,21h,DCh,3Dh,DFh,C3h,44h,0Dh  ; 3AFA |.)...!.=..D.|
L_3B06:  CALL L_0FE0              ; 3B06 cd e0 0f
         LXI  H,A859h             ; 3B09 21 59 a8
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
         SHLD B68Dh               ; 3B30 22 8d b6
         CPI  1Bh                 ; 3B33 fe 1b
         RZ                       ; 3B35 c8
         ADD  A                   ; 3B36 87
         ADD  A                   ; 3B37 87
         MOV  E,A                 ; 3B38 5f
         MVI  D,00h               ; 3B39 16 00
         LXI  H,3DC4h             ; 3B3B 21 c4 3d
         DAD  D                   ; 3B3E 19
         LXI  D,B6A4h             ; 3B3F 11 a4 b6
         MVI  C,03h               ; 3B42 0e 03
         RST  5                   ; 3B44 ef
         LXI  H,3DB0h             ; 3B45 21 b0 3d
         LXI  D,B69Fh             ; 3B48 11 9f b6
         MVI  C,05h               ; 3B4B 0e 05
         RST  5                   ; 3B4D ef
         JMP  L_391E              ; 3B4E c3 1e 39
         .db 21h,63h,B6h,11h,09h,00h,19h,E5h,D5h,CDh,DFh,29h,D1h,19h,D1h,D5h ; 3B51 |!c.........)....|
         .db 0Eh,03h,EFh,CDh,B9h,0Fh,D1h,21h,A4h,3Dh,06h,04h,E5h,D5h,0Eh,03h ; 3B61 |.......!.=......|
         .db CDh,1Ah,38h,CAh,83h,3Bh,D1h,E1h,23h,23h,23h,05h,C2h,6Dh,3Bh,C3h ; 3B71 |..8..;..###..m;.|
         .db 06h,3Bh,D1h,11h,9Fh,B6h,3Eh,07h,12h,13h,21h,B1h,3Dh,0Eh,04h,EFh ; 3B81 |.;....>...!.=...|
         .db E1h,0Eh,03h,79h,B8h,C2h,9Ch,3Bh,21h,CCh,3Dh,EFh,C3h,1Eh,39h ; 3B91 |...y...;!.=...9|
L_3BA0:  LHLD A83Eh               ; 3BA0 2a 3e a8
L_3BA3:  XCHG                     ; 3BA3 eb
L_3BA4:  LXI  H,B6A7h             ; 3BA4 21 a7 b6
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
L_3BC5:  SHLD A83Eh               ; 3BC5 22 3e a8
L_3BC8:  LXI  H,B6A7h             ; 3BC8 21 a7 b6
L_3BCB:  MOV  M,C                 ; 3BCB 71
L_3BCC:  RET                      ; 3BCC c9
         .db 21h,18h,3Eh                                      ; 3BCD |!.>|
L_3BD0:  SHLD A842h               ; 3BD0 22 42 a8
L_3BD3:  JMP  L_158A              ; 3BD3 c3 8a 15
         .db 21h,24h,3Eh,C3h,D0h,3Bh                          ; 3BD6 |!$>..;|
L_3BDC:  LXI  H,3E30h             ; 3BDC 21 30 3e
L_3BDF:  JMP  L_3BD0              ; 3BDF c3 d0 3b
L_3BE2:  LXI  H,9100h             ; 3BE2 21 00 91
         SHLD A940h               ; 3BE5 22 40 a9
         RET                      ; 3BE8 c9
L_3BE9:  LHLD A940h               ; 3BE9 2a 40 a9
         XCHG                     ; 3BEC eb
         LXI  H,B6A7h             ; 3BED 21 a7 b6
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
         SHLD A940h               ; 3C03 22 40 a9
         RET                      ; 3C06 c9
L_3C07:  LHLD A940h               ; 3C07 2a 40 a9
         MVI  M,1Ah               ; 3C0A 36 1a
         MVI  A,43h               ; 3C0C 3e 43
         STA  B673h               ; 3C0E 32 73 b6
         LXI  H,3E3Ch             ; 3C11 21 3c 3e
         SHLD A842h               ; 3C14 22 42 a8
         CALL L_19B8              ; 3C17 cd b8 19
         MVI  C,13h               ; 3C1A 0e 13
         CALL L_3C39              ; 3C1C cd 39 3c
         MVI  C,16h               ; 3C1F 0e 16
         CALL L_3C39              ; 3C21 cd 39 3c
         MVI  C,0Fh               ; 3C24 0e 0f
         CALL L_3C39              ; 3C26 cd 39 3c
         LHLD A940h               ; 3C29 2a 40 a9
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
         .db 21h,18h,3Eh,0Eh,0Eh,CDh,D5h,3Ah,1Eh,00h,CDh,D7h,13h,CDh,38h,10h ; 3C3E |!.>....:......8.|
         .db CDh,D3h,13h,3Ah,8Dh,B6h,FEh,01h,C8h,CDh,DFh,29h,11h,63h,B6h,CDh ; 3C4E |...:.......).c..|
         .db 79h,39h,1Eh,00h,CDh,D7h,13h,CDh,CDh,3Bh,CDh,D3h,13h,3Ah,01h,A8h ; 3C5E |y9.......;...:..|
         .db E6h,60h,07h,07h,07h,32h,3Ch,B7h                  ; 3C6E |.`...2<.|
L_3C76:  CALL L_3BA0              ; 3C76 cd a0 3b
         LXI  H,B654h             ; 3C79 21 54 b6
         LXI  D,0009h             ; 3C7C 11 09 00
         DAD  D                   ; 3C7F 19
         XCHG                     ; 3C80 eb
         LXI  H,B6A7h             ; 3C81 21 a7 b6
         INX  H                   ; 3C84 23
         MVI  C,03h               ; 3C85 0e 03
         RST  5                   ; 3C87 ef
         LXI  H,B6A7h             ; 3C88 21 a7 b6
         INX  H                   ; 3C8B 23
         MOV  A,M                 ; 3C8C 7e
         CPI  2Eh                 ; 3C8D fe 2e
         RZ                       ; 3C8F c8
         CALL L_3D0C              ; 3C90 cd 0c 3d
         JNZ  L_3C76              ; 3C93 c2 76 3c
         LDA  B73Ch               ; 3C96 3a 3c b7
         CPI  03h                 ; 3C99 fe 03
         JZ   L_3CA5              ; 3C9B ca a5 3c
         INR  A                   ; 3C9E 3c
         STA  B73Ch               ; 3C9F 32 3c b7
         JMP  L_3C76              ; 3CA2 c3 76 3c
L_3CA5:  LXI  H,B6A7h             ; 3CA5 21 a7 b6
         LXI  D,0005h             ; 3CA8 11 05 00
         DAD  D                   ; 3CAB 19
         MOV  A,M                 ; 3CAC 7e
         PUSH PSW                 ; 3CAD f5
         PUSH H                   ; 3CAE e5
         CALL L_3891              ; 3CAF cd 91 38
         POP  H                   ; 3CB2 e1
         POP  PSW                 ; 3CB3 f1
         CPI  21h                 ; 3CB4 fe 21
         JZ   L_3CCF              ; 3CB6 ca cf 3c
         CPI  3Ch                 ; 3CB9 fe 3c
         JZ   L_3CCF              ; 3CBB ca cf 3c
         CALL L_3CE6              ; 3CBE cd e6 3c
         LDA  B68Dh               ; 3CC1 3a 8d b6
         CPI  01h                 ; 3CC4 fe 01
         RZ                       ; 3CC6 c8
         LDA  B673h               ; 3CC7 3a 73 b6
         SUI  41h                 ; 3CCA d6 41
         STA  0004h               ; 3CCC 32 04 00
L_3CCF:  LXI  H,B6A7h             ; 3CCF 21 a7 b6
         LXI  D,0005h             ; 3CD2 11 05 00
         DAD  D                   ; 3CD5 19
         LXI  D,DF15h             ; 3CD6 11 15 df
         LDA  B6A7h               ; 3CD9 3a a7 b6
         SUI  04h                 ; 3CDC d6 04
         STA  DF14h               ; 3CDE 32 14 df
         MOV  C,A                 ; 3CE1 4f
         RST  5                   ; 3CE2 ef
         JMP  L_3A7B              ; 3CE3 c3 7b 3a
L_3CE6:  LXI  D,B663h             ; 3CE6 11 63 b6
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
         LXI  H,B654h             ; 3D0F 21 54 b6
         DAD  B                   ; 3D12 09
         XCHG                     ; 3D13 eb
         LXI  H,B663h             ; 3D14 21 63 b6
         DAD  B                   ; 3D17 09
         MVI  C,03h               ; 3D18 0e 03
L_3D1A:  LDAX D                   ; 3D1A 1a
         CMP  M                   ; 3D1B be
         RNZ                      ; 3D1C c0
         INX  H                   ; 3D1D 23
         INX  D                   ; 3D1E 13
         DCR  C                   ; 3D1F 0d
         JNZ  L_3D1A              ; 3D20 c2 1a 3d
         RET                      ; 3D23 c9
L_3D24:  CALL L_3BA0              ; 3D24 cd a0 3b
         LXI  H,B6A7h             ; 3D27 21 a7 b6
         LXI  D,0002h             ; 3D2A 11 02 00
         DAD  D                   ; 3D2D 19
         MOV  A,M                 ; 3D2E 7e
         CPI  29h                 ; 3D2F fe 29
         JZ   L_3D63              ; 3D31 ca 63 3d
         XRA  A                   ; 3D34 af
         STA  B68Dh               ; 3D35 32 8d b6
         CALL L_3891              ; 3D38 cd 91 38
         LXI  H,B6A7h             ; 3D3B 21 a7 b6
         INX  H                   ; 3D3E 23
         MOV  A,M                 ; 3D3F 7e
         CPI  58h                 ; 3D40 fe 58
         RNZ                      ; 3D42 c0
         INX  H                   ; 3D43 23
         MOV  A,M                 ; 3D44 7e
         CPI  3Ah                 ; 3D45 fe 3a
         RNZ                      ; 3D47 c0
         LXI  H,B6A7h             ; 3D48 21 a7 b6
         LXI  D,0003h             ; 3D4B 11 03 00
         DAD  D                   ; 3D4E 19
         CALL L_3CE6              ; 3D4F cd e6 3c
         LDA  B68Dh               ; 3D52 3a 8d b6
         CPI  01h                 ; 3D55 fe 01
         JZ   L_0415              ; 3D57 ca 15 04
         LDA  B673h               ; 3D5A 3a 73 b6
         LXI  H,B6A7h             ; 3D5D 21 a7 b6
         INX  H                   ; 3D60 23
         MOV  M,A                 ; 3D61 77
         RET                      ; 3D62 c9
L_3D63:  MVI  A,02h               ; 3D63 3e 02
         STA  B68Dh               ; 3D65 32 8d b6
         RET                      ; 3D68 c9
         .db 3Ah,9Bh,B6h,F5h,21h,8Ah,A8h,CDh,4Dh,0Eh,7Eh,32h,8Ch,3Dh,3Ch,32h ; 3D69 |:...!...M.~2.=<2|
         .db 9Bh,B6h,CDh,DFh,29h,F1h,32h,9Bh,B6h,11h,08h,00h,19h,11h,0Dh,00h ; 3D79 |....).2.........|
         .db 3Eh,80h,D6h,00h,4Fh,06h,20h,7Eh,FEh,7Fh,CAh,98h,3Dh,06h,7Fh,70h ; 3D89 |>...O. ~....=..p|
         .db 19h,0Dh,C2h,8Eh,3Dh,CDh,F1h,11h,C3h,0Fh,09h,42h,41h,53h,43h,4Fh ; 3D99 |....=......BASCO|
         .db 4Dh,41h,53h,4Dh,4Dh,4Fh,4Eh,07h,53h,41h,56h,45h,E6h,C1h,CAh,CCh ; 3DA9 |MASMMON.SAVE....|
         .db 20h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,44h ; 3DB9 | ..............D|
         .db 4Fh,53h,00h,52h,4Fh,4Dh,00h,42h,41h,53h,00h,41h,53h,4Dh,00h,4Dh ; 3DC9 |OS.ROM.BAS.ASM.M|
         .db 4Fh,4Eh,00h,20h,E4h,CCh,D1h,20h,DAh,C1h,D0h,C9h,D3h,C9h,20h,CEh ; 3DD9 |ON. ... ...... .|
         .db C1h,D6h,CDh,C9h,D4h,C5h,20h,CCh,C0h,C2h,D5h,C0h,20h,CBh,CCh,C1h ; 3DE9 |...... ..... ...|
         .db D7h,C9h,DBh,D5h,00h,F0h,CFh,20h,D4h,C9h,D0h,D5h,00h,F3h,20h,D5h ; 3DF9 |....... ...... .|
         .db CBh,C1h,DAh,C1h,CEh,C9h,C5h                      ; 3E09 |.......|
L_3E10:  CALL L_1B00              ; 3E10 cd 00 1b
         MOV  E,E                 ; 3E13 5b
         NOP                      ; 3E14 00
         DCX  D                   ; 3E15 1b
         MOV  E,H                 ; 3E16 5c
         NOP                      ; 3E17 00
         MOV  B,E                 ; 3E18 43
         MOV  C,A                 ; 3E19 4f
         NOP                      ; 3E1A 20
         NOP                      ; 3E1B 20
         NOP                      ; 3E1C 20
         NOP                      ; 3E1D 20
         NOP                      ; 3E1E 20
         NOP                      ; 3E1F 20
         INX  B                   ; 3E20 03
         MOV  B,L                 ; 3E21 45
         MOV  E,B                 ; 3E22 58
         MOV  D,H                 ; 3E23 54
         MOV  B,E                 ; 3E24 43
         MOV  C,A                 ; 3E25 4f
         NOP                      ; 3E26 20
         NOP                      ; 3E27 20
         NOP                      ; 3E28 20
         NOP                      ; 3E29 20
         NOP                      ; 3E2A 20
         NOP                      ; 3E2B 20
         INX  B                   ; 3E2C 03
         MOV  C,L                 ; 3E2D 4d
         MOV  C,M                 ; 3E2E 4e
         MOV  D,L                 ; 3E2F 55
         MOV  B,E                 ; 3E30 43
         MOV  C,A                 ; 3E31 4f
         NOP                      ; 3E32 20
         NOP                      ; 3E33 20
         NOP                      ; 3E34 20
         NOP                      ; 3E35 20
         NOP                      ; 3E36 20
         NOP                      ; 3E37 20
         INX  B                   ; 3E38 03
         MOV  E,D                 ; 3E39 5a
         MOV  B,A                 ; 3E3A 47
         MOV  D,D                 ; 3E3B 52
         MOV  B,E                 ; 3E3C 43
         MOV  C,A                 ; 3E3D 4f
         NOP                      ; 3E3E 20
         NOP                      ; 3E3F 20
         NOP                      ; 3E40 20
         NOP                      ; 3E41 20
         NOP                      ; 3E42 20
         NOP                      ; 3E43 20
         INX  B                   ; 3E44 03
         MOV  D,H                 ; 3E45 54
         MOV  C,A                 ; 3E46 4f
         MOV  C,E                 ; 3E47 4b
         MOV  C,L                 ; 3E48 4d
         MOV  B,L                 ; 3E49 45
         MOV  B,H                 ; 3E4A 44
         MOV  C,C                 ; 3E4B 49
         MOV  D,H                 ; 3E4C 54
         NOP                      ; 3E4D 20
         NOP                      ; 3E4E 20
         NOP                      ; 3E4F 20
         NOP                      ; 3E50 20
         MOV  B,E                 ; 3E51 43
         MOV  C,A                 ; 3E52 4f
         MOV  C,L                 ; 3E53 4d
         MOV  D,A                 ; 3E54 57
         MOV  D,E                 ; 3E55 53
         MOV  D,D                 ; 3E56 52
         NOP                      ; 3E57 20
         NOP                      ; 3E58 20
         NOP                      ; 3E59 20
         NOP                      ; 3E5A 20
         NOP                      ; 3E5B 20
         NOP                      ; 3E5C 20
         MOV  B,E                 ; 3E5D 43
         MOV  C,A                 ; 3E5E 4f
         MOV  C,L                 ; 3E5F 4d
         MOV  D,E                 ; 3E60 53
         MOV  C,C                 ; 3E61 49
         MOV  B,H                 ; 3E62 44
         NOP                      ; 3E63 20
         NOP                      ; 3E64 20
         NOP                      ; 3E65 20
         NOP                      ; 3E66 20
         NOP                      ; 3E67 20
         NOP                      ; 3E68 20
         MOV  B,E                 ; 3E69 43
         MOV  C,A                 ; 3E6A 4f
         MOV  C,L                 ; 3E6B 4d
         DAD  B                   ; 3E6C 09
         NOP                      ; 3E6D 20
         NOP                      ; 3E6E 20
         NOP                      ; 3E6F 20
         NOP                      ; 3E70 20
         CALL CEC5h               ; 3E71 ed c5 ce
         RNZ                      ; 3E74 c0
         NOP                      ; 3E75 20
         RNC                      ; 3E76 d0
         RST  1                   ; 3E77 cf
         CZ   DAD8h               ; 3E78 cc d8 da
         RST  1                   ; 3E7B cf
         RST  2                   ; 3E7C d7
         POP  B                   ; 3E7D c1
         CNC  CCC5h               ; 3E7E d4 c5 cc
         POP  D                   ; 3E81 d1
         DAD  B                   ; 3E82 09
         DAD  B                   ; 3E83 09
         NOP                      ; 3E84 00
         NOP                      ; 3E85 20
         LXI  SP,3230h            ; 3E86 31 30 32
         MOV  B,D                 ; 3E89 42
         MOV  B,C                 ; 3E8A 41
         MOV  C,E                 ; 3E8B 4b
         INX  B                   ; 3E8C 03
         MOV  C,E                 ; 3E8D 4b
         DCR  L                   ; 3E8E 2d
L_3E8F:  NOP                      ; 3E8F 38
L_3E90:  MOV  C,M                 ; 3E90 4e
L_3E91:  MOV  B,E                 ; 3E91 43
L_3E92:  MOV  B,C                 ; 3E92 41
         MOV  D,B                 ; 3E93 50
         MOV  C,E                 ; 3E94 4b
         LXI  D,5910h             ; 3E95 11 10 59
L_3E98:  LDA  DF15h               ; 3E98 3a 15 df
L_3E9B:  CPI  43h                 ; 3E9B fe 43
L_3E9D:  JZ   L_3F2E              ; 3E9D ca 2e 3f
L_3EA0:  STA  B673h               ; 3EA0 32 73 b6
L_3EA3:  STA  A84Ah               ; 3EA3 32 4a a8
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
L_3EC6:  STA  B69Dh               ; 3EC6 32 9d b6
L_3EC9:  MVI  A,01h               ; 3EC9 3e 01
L_3ECB:  STA  B68Dh               ; 3ECB 32 8d b6
L_3ECE:  CALL L_12A7              ; 3ECE cd a7 12
L_3ED1:  LDA  B68Dh               ; 3ED1 3a 8d b6
L_3ED4:  DCR  A                   ; 3ED4 3d
L_3ED5:  JZ   L_3F2E              ; 3ED5 ca 2e 3f
L_3ED8:  CALL L_3BDC              ; 3ED8 cd dc 3b
L_3EDB:  XRA  A                   ; 3EDB af
L_3EDC:  STA  B69Bh               ; 3EDC 32 9b b6
L_3EDF:  CALL L_3BA0              ; 3EDF cd a0 3b
L_3EE2:  LXI  H,B69Bh             ; 3EE2 21 9b b6
L_3EE5:  INR  M                   ; 3EE5 34
L_3EE6:  CALL L_29DF              ; 3EE6 cd df 29
L_3EE9:  XCHG                     ; 3EE9 eb
L_3EEA:  LXI  H,B6A8h             ; 3EEA 21 a8 b6
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
L_3F01:  LDA  B6A8h               ; 3F01 3a a8 b6
L_3F04:  CPI  2Eh                 ; 3F04 fe 2e
L_3F06:  JNZ  L_3EDF              ; 3F06 c2 df 3e
L_3F09:  MVI  A,43h               ; 3F09 3e 43
L_3F0B:  STA  A849h               ; 3F0B 32 49 a8
L_3F0E:  CALL L_0B5C              ; 3F0E cd 5c 0b
L_3F11:  CALL L_1E7C              ; 3F11 cd 7c 1e
L_3F14:  LXI  H,B69Bh             ; 3F14 21 9b b6
L_3F17:  DCR  M                   ; 3F17 35
L_3F18:  CALL L_29DF              ; 3F18 cd df 29
L_3F1B:  SHLD A84Fh               ; 3F1B 22 4f a8
L_3F1E:  SHLD A84Dh               ; 3F1E 22 4d a8
L_3F21:  CALL L_159A              ; 3F21 cd 9a 15
L_3F24:  LXI  H,B69Bh             ; 3F24 21 9b b6
L_3F27:  DCR  M                   ; 3F27 35
L_3F28:  JNZ  L_3F18              ; 3F28 c2 18 3f
L_3F2B:  MVI  C,0Dh               ; 3F2B 0e 0d
L_3F2D:  RST  1                   ; 3F2D cf
L_3F2E:  LXI  H,B681h             ; 3F2E 21 81 b6
L_3F31:  MVI  C,04h               ; 3F31 0e 04
L_3F33:  XRA  A                   ; 3F33 af
L_3F34:  CALL L_1E75              ; 3F34 cd 75 1e
L_3F37:  LDA  DE80h               ; 3F37 3a 80 de
L_3F3A:  ANA  A                   ; 3F3A a7
L_3F3B:  JNZ  L_3F47              ; 3F3B c2 47 3f
         LXI  H,4101h             ; 3F3E 21 01 41
         SHLD DF14h               ; 3F41 22 14 df
         JMP  L_2026              ; 3F44 c3 26 20
L_3F47:  CALL L_14AA              ; 3F47 cd aa 14
L_3F4A:  MVI  A,01h               ; 3F4A 3e 01
L_3F4C:  STA  B69Bh               ; 3F4C 32 9b b6
L_3F4F:  STA  A94Dh               ; 3F4F 32 4d a9
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
L_3F74:  STA  B69Dh               ; 3F74 32 9d b6
L_3F77:  CALL L_091B              ; 3F77 cd 1b 09
L_3F7A:  MVI  A,02h               ; 3F7A 3e 02
L_3F7C:  STA  B69Dh               ; 3F7C 32 9d b6
L_3F7F:  STA  B68Fh               ; 3F7F 32 8f b6
L_3F82:  CALL L_091B              ; 3F82 cd 1b 09
L_3F85:  STA  B68Fh               ; 3F85 32 8f b6
L_3F88:  CALL L_0F9A              ; 3F88 cd 9a 0f
L_3F8B:  LDA  A94Eh               ; 3F8B 3a 4e a9
L_3F8E:  STA  B69Dh               ; 3F8E 32 9d b6
L_3F91:  CALL L_0C7E              ; 3F91 cd 7e 0c
L_3F94:  CALL L_0CD9              ; 3F94 cd d9 0c
L_3F97:  LXI  H,A887h             ; 3F97 21 87 a8
L_3F9A:  CALL L_0E4D              ; 3F9A cd 4d 0e
L_3F9D:  MOV  A,M                 ; 3F9D 7e
L_3F9E:  STA  A889h               ; 3F9E 32 89 a8
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
         .db F2h,F1h,88h,BAh,ADh,ACh,DFh,CDh,D1h,CFh,F2h,F5h,97h,BEh,ADh,A7h ; 3FB8 |................|
         .db B4h,B0h,A8h,DFh,CEh,C6h,C6h,CCh,F2h,F5h,84h,B6h,A4h,BEh,ABh,ACh ; 3FC8 |................|
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
         ADI  CAh                 ; 4015 c6 ca
         ADI  CCh                 ; 4017 c6 cc
         JP   F2F5h               ; 4019 f2 f5 f2
         PUSH PSW                 ; 401C f5
         CPO  L_21A4              ; 401D e4 a4 21
         MOV  A,C                 ; 4020 79
         RST  3                   ; 4021 df
         SHLD C05Dh               ; 4022 22 5d c0
         LXI  H,E176h             ; 4025 21 76 e1
         SHLD DA32h               ; 4028 22 32 da
         MVI  A,31h               ; 402B 3e 31
         STA  DA31h               ; 402D 32 31 da
         JMP  DA34h               ; 4030 c3 34 da
         .db E5h,21h,13h,C7h,22h,5Dh,C0h,21h,04h,43h,22h,14h,DFh,21h,3Ah,43h ; 4033 |.!.."].!.C"..!:C|
         .db 22h,16h,DFh,21h,4Fh,0Dh,22h,18h,DFh,E1h,C9h,1Bh,5Bh,0Ch,1Bh,59h ; 4043 |"..!O.".....[..Y|
         .db 21h,20h,89h,00h,BBh,89h,00h,BBh,1Bh,59h,36h,20h,88h,00h,BCh,88h ; 4053 |! .......Y6 ....|
         .db 00h,BCh,1Bh,59h,37h,6Ch,00h                      ; 4063 |...Y7l.|
L_406A:  LHLD 0006h               ; 406A 2a 06 00
L_406D:  SPHL                     ; 406D f9
L_406E:  SHLD 0009h               ; 406E 22 09 00
L_4071:  XRA  A                   ; 4071 af
L_4072:  STA  A889h               ; 4072 32 89 a8
L_4075:  LXI  H,0185h             ; 4075 21 85 01
L_4078:  SHLD E213h               ; 4078 22 13 e2
L_407B:  MVI  A,C3h               ; 407B 3e c3
L_407D:  STA  0008h               ; 407D 32 08 00
L_4080:  STA  0018h               ; 4080 32 18 00
L_4083:  STA  0020h               ; 4083 32 20 00
L_4086:  LXI  H,C97Eh             ; 4086 21 7e c9
L_4089:  SHLD 0010h               ; 4089 22 10 00
L_408C:  INR  L                   ; 408C 2c
L_408D:  SHLD 0012h               ; 408D 22 12 00
L_4090:  LHLD F819h               ; 4090 2a 19 f8
L_4093:  SHLD 0019h               ; 4093 22 19 00
L_4096:  LXI  H,3FAFh             ; 4096 21 af 3f
L_4099:  LXI  D,0027h             ; 4099 11 27 00
L_409C:  MVI  C,07h               ; 409C 0e 07
L_409E:  CALL L_3FB0              ; 409E cd b0 3f
L_40A1:  LXI  H,0027h             ; 40A1 21 27 00
L_40A4:  SHLD 002Eh               ; 40A4 22 2e 00
L_40A7:  LHLD F80Ah               ; 40A7 2a 0a f8
L_40AA:  SHLD L_0F77              ; 40AA 22 77 0f
L_40AD:  SHLD L_0A4C              ; 40AD 22 4c 0a
L_40B0:  SHLD 0021h               ; 40B0 22 21 00
L_40B3:  LXI  D,DF65h             ; 40B3 11 65 df
L_40B6:  LXI  H,401Fh             ; 40B6 21 1f 40
L_40B9:  MVI  C,2Fh               ; 40B9 0e 2f
L_40BB:  RST  5                   ; 40BB ef
L_40BC:  LDA  DF16h               ; 40BC 3a 16 df
L_40BF:  CPI  3Ah                 ; 40BF fe 3a
L_40C1:  JZ   L_3E98              ; 40C1 ca 98 3e
L_40C4:  LDA  0004h               ; 40C4 3a 04 00
L_40C7:  ADI  41h                 ; 40C7 c6 41
L_40C9:  JMP  L_3E9B              ; 40C9 c3 9b 3e
         .db F5h,C5h,D5h,E5h,CDh,15h,F8h,CDh,03h,F8h,E1h,D1h,C1h,F1h,C9h,00h ; 40CC |................|
         .db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h ; 40DC |................|
         .db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h ; 40EC |................|
         .db 00h,00h,00h,00h                                  ; 40FC |....|
