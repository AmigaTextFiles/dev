;
;       Disassembled by:
;               DASMx object code disassembler
;               (c) Copyright 1996-2003   Conquest Consultants
;               Version 1.40 (Oct 18 2003)
;       Commented by:
;               Annotate 2.33 (16 Apr 2010) by Amigan Software
;
;       File:           superbug.bin
;
;       Size:           4096 bytes
;       Checksum:       4EF3
;       CRC-32:         FEF2AAE9
;
;       Date:           Thu Jun 04 15:03:21 2009
;
;       CPU:            Signetics 2650 (2650 family)
;       Platform:       Emerson Arcadia 2001 family, type "G"
;
;Hardware Equates/Memory Map----------------------------------------------
;                   $0000..$0FFF: (R/-)  ROM (first 4K of cartridge)
;                   $1000..$10FF: (*/*)  mirror of $1800..$18FF
;                   $1100..$11FF: (*/*)  mirror of $1900..$19FF
;                   $1200..$12FF: (*/*)  mirror of $1A00..$1AFF
;                   $1300..$13FF: (*/*)  mirror of $1B00..$1BFF
;                   $1400..$17FF: (*/*)  mirror of $1000..$13FF
;                   $1800..$18CF: (R/W)  upper screen
;                   $18D0..$18EF: (R/W)  32 bytes of CPU+UVI RAM
SPRITE0Y        equ $18F0        ;(R/W)
SPRITE0X        equ $18F1        ;(R/W)
SPRITE1Y        equ $18F2        ;(R/W)
SPRITE1X        equ $18F3        ;(R/W)
SPRITE2Y        equ $18F4        ;(R/W)
SPRITE2X        equ $18F5        ;(R/W)
SPRITE3Y        equ $18F6        ;(R/W)
SPRITE3X        equ $18F7        ;(R/W)
;                   $18F8..$18FB: (R/W)  4 bytes of CPU+UVI RAM
VSCROLL         equ $18FC        ;(R/W)  CRTC vertical position register
PITCH           equ $18FD        ;(R/W)  also other uses
;    bit  7:                             0 = normal mode
;                                        1 = "board" mode
;    bits 6..0:                          pitch
VOLUME          equ $18FE        ;(R/W)  also other uses
;    bits 7..5:                          horizontal scrolling (0..7)
;    bit  4:                             noise on/off
;    bit  3:                             tones on/off
;    bits 2..0:                          volume (0..7)
CHARLINE        equ $18FF        ;(R/-)  current character line
P1LEFTKEYS      equ $1900        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p1 (left) '1' button
;    bit  2:                             p1 (left) '4' button
;    bit  1:                             p1 (left) '7' button
;    bit  0:                             p1 (left) 'C' button (Clear)
P1MIDDLEKEYS    equ $1901        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p1 (left) '2' button
;    bit  2:                             p1 (left) '5' button
;    bit  1:                             p1 (left) '8' button
;    bit  0:                             p1 (left) '0' button
P1RIGHTKEYS     equ $1902        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p1 (left) '3' button
;    bit  2:                             p1 (left) '6' button
;    bit  1:                             p1 (left) '9' button
;    bit  0:                             p1 (left) 'E' button (Enter)
P1PALLADIUM     equ $1903        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p1 (left)  Palladium button 'x4'
;    bit  2:                             p1 (left)  Palladium button 'x3'
;    bit  1:                             p1 (left)  Palladium button 'x2'
;    bit  0:                             p1 (left)  Palladium button 'x1'
P2LEFTKEYS      equ $1904        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p2 (right) '1' button
;    bit  2:                             p2 (right) '4' button
;    bit  1:                             p2 (right) '7' button
;    bit  0:                             p2 (right) 'C' button (Clear)
P2MIDDLEKEYS    equ $1905        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p2 (right) '2' button
;    bit  2:                             p2 (right) '5' button
;    bit  1:                             p2 (right) '8' button
;    bit  0:                             p2 (right) '0' button
P2RIGHTKEYS     equ $1906        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p2 (right) '3' button
;    bit  2:                             p2 (right) '6' button
;    bit  1:                             p2 (right) '9' button
;    bit  0:                             p2 (right) 'E' button (Enter)
P2PALLADIUM     equ $1907        ;(R/-)
;    bits 7..4:                          unused
;    bit  3:                             p2 (right) Palladium button 'x4'
;    bit  2:                             p2 (right) Palladium button 'x3'
;    bit  1:                             p2 (right) Palladium button 'x2'
;    bit  0:                             p2 (right) Palladium button 'x1'
CONSOLE         equ $1908        ;(R/-)
;    bits 7..3:                          unused
;    bit  2:                             B button
;    bit  1:                             A button
;    bit  0:                             START button
;                   $1909..$190F: (-/-)  unmapped
;                   $1910..$191F: (*/*)  mirror of $1900..$190F
;                   $1920..$192F: (*/*)  mirror of $1900..$190F
;                   $1930..$193F: (*/*)  mirror of $1900..$190F
;                   $1940..$194F: (*/*)  mirror of $1900..$190F
;                   $1950..$195F: (*/*)  mirror of $1900..$190F
;                   $1960..$196F: (*/*)  mirror of $1900..$190F
;                   $1970..$197F: (*/*)  mirror of $1900..$190F
;                   $1980..$1987: (R/W)  sprite #0 imagery
;                   $1988..$198F: (R/W)  sprite #1 imagery
;                   $1990..$1997: (R/W)  sprite #2 imagery
;                   $1998..$199F: (R/W)  sprite #3 imagery
UDC0            equ $19A0
;                   $19A0..$19A7: (R/W)  user-defined character #0 imagery
UDC1            equ $19A8
;                   $19A8..$19AF: (R/W)  user-defined character #1 imagery
UDC2            equ $19B0
;                   $19B0..$19B7: (R/W)  user-defined character #2 imagery
UDC3            equ $19B8
;                   $19B8..$19BF: (R/W)  user-defined character #3 imagery
;                   $19C0..$19F7: (-/-)  unmapped
RESOLUTION      equ $19F8        ;(-/W)  also other uses
;    bit  7:                             0 = normal mode
;                                        1 = block graphics mode
;    bit  6:                             0 = 13 character rows
;                                        1 = 26 character rows
;    bits 5..0:                          rectangle descs in block mode
BGCOLOUR        equ $19F9        ;(-/W)  also other uses
;    bit  7:                             0 = low-res mode
;                                        1 = high-res mode
;    bit  6:                             paddle interpolation
;    bits 5..3:                          colours of tile set 0
;    bits 2..0:                          background colour
SPRITES23CTRL   equ $19FA        ;(-/W)
;    bit  7:                             0 = sprite #2 double-height
;                                        1 = sprite #2 normal
;    bit  6:                             0 = sprite #3 double-height
;                                        1 = sprite #3 normal
;    bits 5..3:                          colours of sprite #2
;    bits 2..0:                          colours of sprite #3
SPRITES01CTRL   equ $19FB        ;(-/W)
;    bit  7:                             0 = sprite #0 double-height
;                                        1 = sprite #0 normal
;    bit  6:                             0 = sprite #1 double-height
;                                        1 = sprite #1 normal
;    bits 5..3:                          colours of sprite #0
;    bits 2..0:                          colours of sprite #1
BGCOLLIDE       equ $19FC        ;(R/-)
;    bits 7..4:                          unused
;    bits 3:                             sprite #3 collision with bkgrnd
;    bits 2:                             sprite #2 collision with bkgrnd
;    bits 1:                             sprite #1 collision with bkgrnd
;    bits 0:                             sprite #0 collision with bkgrnd
SPRITECOLLIDE   equ $19FD        ;(R/-)
;    bits 7..6:                          unused
;    bit 5:                              sprites #2/#3 collision
;    bit 4:                              sprites #1/#3 collision
;    bit 3:                              sprites #1/#2 collision
;    bit 2:                              sprites #0/#3 collision
;    bit 1:                              sprites #0/#2 collision
;    bit 0:                              sprites #0/#1 collision
P2PADDLE        equ $19FE        ;(R/-)
P1PADDLE        equ $19FF        ;(R/-)
;                   $1A00..$1ACF: (R/W)  lower screen
;                   $1AD0..$1AFF: (R/W)  48 bytes of CPU+UVI RAM
;                   $1B00..$1BFF: (*/*)  mirror of $1900..$19FF
;                   $1C00..$1FFF: (*/*)  mirror of $1800..$1BFF
;                   $2000..$2FFF: (R/-)  ROM
;                   $3000..$3FFF: (*/*)  mirror of $1000..$1FFF
;                   $4000..$4FFF: (*/*)  mirror of $0000..$0FFF?
;                   $5000..$5FFF: (*/*)  mirror of $1000..$1FFF
;                   $6000..$6FFF: (*/*)  mirror of $0000..$0FFF?
;                   $7000..$7FFF: (*/*)  mirror of $1000..$1FFF
;2650 Equates-------------------------------------------------------------
z               equ 0
eq              equ z
p               equ 1
gt              equ p
n               equ 2
lt              equ n
un              equ 3
;-------------------------------------------------------------------------
        org     $0000
;
;$0000:
        eorz    r0           ;r0 = 0;                                 ;2,1 $0000:        20
        lpsu                 ;PSU = (r0 & %01100111);                 ;2,1 $0001:        92
        lpsl                 ;PSL = r0;                               ;2,1 $0002:        93
        ppsu    $60          ;PSU |= .FI..... & %01100111;            ;3,2 $0003..$0004: 76 60
        ppsl    $02          ;PSL |= ......M.;                        ;3,2 $0005..$0006: 77 02
        bsta,un $0684        ;gosub $0684; // ROM                     ;3,3 $0007..$0009: 3F 06 84
        eorz    r0           ;r0 = 0;                                 ;2,1 $000A:        20
        strz    r1           ;r1 = r0;                                ;2,1 $000B:        C1
;$000C:
        stra,r0 $17FF,r1     ;*($17FF + r1) = r0;                     ;4,3 $000C..$000E: CD 77 FF
        stra,r0 $19FF,r1     ;*($19FF + r1) = r0;                     ;4,3 $000F..$0011: CD 79 FF
        stra,r0 $18FF,r1     ;*($18FF + r1) = r0;                     ;4,3 $0012..$0014: CD 78 FF
        bdrr,r1 $000C        ;if (--r1 != 0) goto $000C; // ROM       ;3,2 $0015..$0016: F9 75
        bcta,un $0110        ;goto $0110; // ROM                      ;3,3 $0017..$0019: 1F 01 10
;
        db      $24, $99, $5A, $2D                                    ;0,4 $001A..$001D: 24 99 5A 2D
        db      $6E, $BC, $5A, $81                                    ;0,4 $001E..$0021: 6E BC 5A 81
        db      $24, $19, $DA, $3D                                    ;0,4 $0022..$0025: 24 19 DA 3D
        db      $6E, $AC, $5B, $80                                    ;0,4 $0026..$0029: 6E AC 5B 80
        db      $00, $98, $5B, $BC                                    ;0,4 $002A..$002D: 00 98 5B BC
        db      $76, $35, $DA, $01                                    ;0,4 $002E..$0031: 76 35 DA 01
        db      $24, $98, $5A, $BD                                    ;0,4 $0032..$0035: 24 98 5A BD
        db      $66, $BD, $5A, $01                                    ;0,4 $0036..$0039: 66 BD 5A 01
        db      $A2, $54, $39, $66                                    ;0,4 $003A..$003D: A2 54 39 66
        db      $7E, $39, $54, $8A                                    ;0,4 $003E..$0041: 7E 39 54 8A
        db      $A4, $54, $39, $4E                                    ;0,4 $0042..$0045: A4 54 39 4E
        db      $7E, $39, $54, $4A                                    ;0,4 $0046..$0049: 7E 39 54 4A
        db      $4A, $54, $38, $7E                                    ;0,4 $004A..$004D: 4A 54 38 7E
        db      $4E, $38, $54, $A4                                    ;0,4 $004E..$0051: 4E 38 54 A4
        db      $2A, $54, $39, $6E                                    ;0,4 $0052..$0055: 2A 54 39 6E
        db      $6E, $39, $54, $A8                                    ;0,4 $0056..$0059: 6E 39 54 A8
        db      $81, $5A, $3D, $76                                    ;0,4 $005A..$005D: 81 5A 3D 76
        db      $B4, $5A, $99, $24                                    ;0,4 $005E..$0061: B4 5A 99 24
        db      $01, $DA, $35, $76                                    ;0,4 $0062..$0065: 01 DA 35 76
        db      $5C, $5B, $98, $24                                    ;0,4 $0066..$0069: 5C 5B 98 24
        db      $80, $5B, $AC, $6E                                    ;0,4 $006A..$006D: 80 5B AC 6E
        db      $3D, $DA, $19, $00                                    ;0,4 $006E..$0071: 3D DA 19 00
        db      $80, $5A, $BD, $66                                    ;0,4 $0072..$0075: 80 5A BD 66
        db      $BD, $5A, $19, $24                                    ;0,4 $0076..$0079: BD 5A 19 24
        db      $51, $2A, $9C, $7E                                    ;0,4 $007A..$007D: 51 2A 9C 7E
        db      $66, $9C, $2A, $45                                    ;0,4 $007E..$0081: 66 9C 2A 45
        db      $4A, $2A, $1C, $3A                                    ;0,4 $0082..$0085: 4A 2A 1C 3A
        db      $3A, $1C, $2A, $4A                                    ;0,4 $0086..$0089: 3A 1C 2A 4A
        db      $52, $2A, $9C, $7E                                    ;0,4 $008A..$008D: 52 2A 9C 7E
        db      $72, $9C, $2A, $25                                    ;0,4 $008E..$0091: 72 9C 2A 25
        db      $15, $2A, $9C, $76                                    ;0,4 $0092..$0095: 15 2A 9C 76
        db      $76, $9C, $2A                                         ;0,3 $0096..$0098: 76 9C 2A
X0099:
        db      $54, $00, $00, $00                                    ;0,4 $0099..$009C: 54 00 00 00
        db      $18, $18, $00, $00                                    ;0,4 $009D..$00A0: 18 18 00 00
        db      $00, $F2, $10, $00                                    ;0,4 $00A1..$00A4: 00 F2 10 00
        db      $89, $F1, $0D, $84                                    ;0,4 $00A5..$00A8: 89 F1 0D 84
        db      $82, $00, $87, $7C                                    ;0,4 $00A9..$00AC: 82 00 87 7C
        db      $F2, $07, $7C, $F2                                    ;0,4 $00AD..$00B0: F2 07 7C F2
        db      $03, $FF, $85, $00                                    ;0,4 $00B1..$00B4: 03 FF 85 00
        db      $87, $F2, $07, $7C                                    ;0,4 $00B5..$00B8: 87 F2 07 7C
        db      $F2, $05, $85, $F3                                    ;0,4 $00B9..$00BC: F2 05 85 F3
        db      $40, $50, $01, $00                                    ;0,4 $00BD..$00C0: 40 50 01 00
        db      $87, $F2, $03, $7C                                    ;0,4 $00C1..$00C4: 87 F2 03 7C
        db      $F2, $09, $85, $00                                    ;0,4 $00C5..$00C8: F2 09 85 00
        db      $87, $F2, $04, $7C                                    ;0,4 $00C9..$00CC: 87 F2 04 7C
        db      $F2, $05, $7C, $00                                    ;0,4 $00CD..$00D0: F2 05 7C 00
        db      $00, $85, $00, $87                                    ;0,4 $00D1..$00D4: 00 85 00 87
        db      $F2, $0D, $85, $F3                                    ;0,4 $00D5..$00D8: F2 0D 85 F3
        db      $80, $90, $01, $F3                                    ;0,4 $00D9..$00DC: 80 90 01 F3
        db      $40, $A0, $01, $00                                    ;0,4 $00DD..$00E0: 40 A0 01 00
        db      $87, $00, $7C, $F2                                    ;0,4 $00E1..$00E4: 87 00 7C F2
        db      $09, $7C, $00, $85                                    ;0,4 $00E5..$00E8: 09 7C 00 85
        db      $00, $8A, $F1, $0D                                    ;0,4 $00E9..$00EC: 00 8A F1 0D
        db      $86, $81                                              ;0,2 $00ED..$00EE: 86 81
X00EF:
        db      $F0, $9A, $00, $D4                                    ;0,4 $00EF..$00F2: F0 9A 00 D4
        db      $00, $00, $00, $00                                    ;0,4 $00F3..$00F6: 00 00 00 00
        db      $00, $00, $00, $00                                    ;0,4 $00F7..$00FA: 00 00 00 00
        db      $00, $00, $00, $D3                                    ;0,4 $00FB..$00FE: 00 00 00 D3
X00FF:
        db      $D0, $6C, $6E, $69                                    ;0,4 $00FF..$0102: D0 6C 6E 69
        db      $5E, $6B, $5B, $6E                                    ;0,4 $0103..$0106: 5E 6B 5B 6E
        db      $60, $00, $A5, $9E                                    ;0,4 $0107..$010A: 60 00 A5 9E
        db      $AF, $9E, $A5, $00                                    ;0,4 $010B..$010E: AF 9E A5 00
        db      $D1                                                   ;0,1 $010F:        D1
;
;$0110:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $0110..$0112: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $0113..$0115: 3F 07 00
        lodi,r0 $E6          ;r0 = $E6;                               ;2,2 $0116..$0117: 04 E6
        stra,r0 $18FC        ;VSCROLL = r0; // UVI register           ;4,3 $0118..$011A: CC 18 FC
        eorz    r0           ;r0 = 0;                                 ;2,1 $011B:        20
        stra,r0 $18FD        ;PITCH = r0; // UVI register             ;4,3 $011C..$011E: CC 18 FD
        stra,r0 $1A13        ;*($1A13) = r0; // lower screen or user RAM
                                                                      ;4,3 $011F..$0121: CC 1A 13
        stra,r0 $1A0E        ;*($1A0E) = r0; // lower screen or user RAM
                                                                      ;4,3 $0122..$0124: CC 1A 0E
        lodi,r0 $08          ;r0 = $08;                               ;2,2 $0125..$0126: 04 08
        stra,r0 $19F9        ;BGCOLOUR = r0; // UVI register          ;4,3 $0127..$0129: CC 19 F9
        lodi,r3 $10          ;r3 = $10;                               ;2,2 $012A..$012B: 07 10
;$012C:
        loda,r0 $00FF,r3     ;r0 = *($00FF + r3);                     ;4,3 $012C..$012E: 0F 60 FF
        stra,r0 $185F,r3     ;*($185F + r3) = r0;                     ;4,3 $012F..$0131: CF 78 5F
        bdrr,r3 $012C        ;if (--r3 != 0) goto $012C; // ROM       ;3,2 $0132..$0133: FB 78
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0134..$0136: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0137..$0138: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $0139..$013B: CC 1A 11
        lodi,r0 $0C          ;r0 = $0C;                               ;2,2 $013C..$013D: 04 0C
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $013E..$0140: CC 1A 12
;$0141:
        bsta,un $0684        ;gosub $0684; // ROM                     ;3,3 $0141..$0143: 3F 06 84
        bsta,un $05A8        ;gosub $05A8; // ROM                     ;3,3 $0144..$0146: 3F 05 A8
        comi,r0 $FF          ;compare r0 against $FF;                 ;2,2 $0147..$0148: E4 FF
        bcfr,eq $0141        ;if != goto $0141; // ROM                ;3,2 $0149..$014A: 98 76
;$014B:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $014B..$014D: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $014E..$0150: 3F 07 00
        loda,r0 $1A0B        ;r0 = *($1A0B); // lower screen or user RAM
                                                                      ;4,3 $0151..$0153: 0C 1A 0B
        addi,r0 $01          ;r0++;                                   ;2,2 $0154..$0155: 84 01
        stra,r0 $1A0B        ;*($1A0B) = r0; // lower screen or user RAM
                                                                      ;4,3 $0156..$0158: CC 1A 0B
        comi,r0 $FF          ;compare r0 against $FF;                 ;2,2 $0159..$015A: E4 FF
        bcta,eq $01AE        ;if == goto $01AE; // ROM                ;3,3 $015B..$015D: 1C 01 AE
        loda,r0 $1908        ;r0 = CONSOLE; // UVI register           ;4,3 $015E..$0160: 0C 19 08
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0161..$0162: 44 0F
        comi,r0 $02          ;compare r0 against $02;                 ;2,2 $0163..$0164: E4 02
        bcta,eq $0175        ;if == goto $0175; // ROM                ;3,3 $0165..$0167: 1C 01 75
        comi,r0 $01          ;compare r0 against $01;                 ;2,2 $0168..$0169: E4 01
        bcta,eq $01B5        ;if == goto $01B5; // ROM                ;3,3 $016A..$016C: 1C 01 B5
        lodi,r3 $05          ;r3 = $05;                               ;2,2 $016D..$016E: 07 05
        bsta,un $0983        ;gosub $0983; // ROM                     ;3,3 $016F..$0171: 3F 09 83
        bcta,un $014B        ;goto $014B; // ROM                      ;3,3 $0172..$0174: 1F 01 4B
;
;$0175:
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0175..$0177: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0178..$0179: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $017A..$017C: CC 1A 11
        lodi,r0 $57          ;r0 = $57;                               ;2,2 $017D..$017E: 04 57
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $017F..$0181: CC 1A 12
        loda,r0 $186F        ;r0 = *($186F); // upper screen          ;4,3 $0182..$0184: 0C 18 6F
        strz    r1           ;r1 = r0;                                ;2,1 $0185:        C1
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0186..$0187: 44 0F
        comi,r0 $03          ;compare r0 against $03;                 ;2,2 $0188..$0189: E4 03
        bcfr,eq $0197        ;if != goto $0197; // ROM                ;3,2 $018A..$018B: 98 0B
        eorz    r0           ;r0 = 0;                                 ;2,1 $018C:        20
        stra,r0 $1A0E        ;*($1A0E) = r0; // lower screen or user RAM
                                                                      ;4,3 $018D..$018F: CC 1A 0E
        lodi,r0 $D1          ;r0 = $D1;                               ;2,2 $0190..$0191: 04 D1
        stra,r0 $186F        ;*($186F) = r0; // upper screen          ;4,3 $0192..$0194: CC 18 6F
        bctr,un $01A4        ;goto $01A4; // ROM                      ;3,2 $0195..$0196: 1B 0D
;
;$0197:
        addi,r1 $01          ;r1++;                                   ;2,2 $0197..$0198: 85 01
        stra,r1 $186F        ;*($186F) = r1; // upper screen          ;4,3 $0199..$019B: CD 18 6F
        loda,r0 $1A0E        ;r0 = *($1A0E); // lower screen or user RAM
                                                                      ;4,3 $019C..$019E: 0C 1A 0E
        addi,r0 $01          ;r0++;                                   ;2,2 $019F..$01A0: 84 01
        stra,r0 $1A0E        ;*($1A0E) = r0; // lower screen or user RAM
                                                                      ;4,3 $01A1..$01A3: CC 1A 0E
;$01A4:
        eorz    r0           ;r0 = 0;                                 ;2,1 $01A4:        20
        stra,r0 $1A0B        ;*($1A0B) = r0; // lower screen or user RAM
                                                                      ;4,3 $01A5..$01A7: CC 1A 0B
        bsta,un $0981        ;gosub $0981; // ROM                     ;3,3 $01A8..$01AA: 3F 09 81
        bcta,un $014B        ;goto $014B; // ROM                      ;3,3 $01AB..$01AD: 1F 01 4B
;
;$01AE:
        lodi,r0 $FF          ;r0 = $FF;                               ;2,2 $01AE..$01AF: 04 FF
        stra,r0 $1A0C        ;*($1A0C) = r0; // lower screen or user RAM
                                                                      ;4,3 $01B0..$01B2: CC 1A 0C
        bctr,un $01C4        ;goto $01C4; // ROM                      ;3,2 $01B3..$01B4: 1B 0F
;
;$01B5:
        eorz    r0           ;r0 = 0;                                 ;2,1 $01B5:        20
        stra,r0 $1A0C        ;*($1A0C) = r0; // lower screen or user RAM
                                                                      ;4,3 $01B6..$01B8: CC 1A 0C
        stra,r0 $1A0A        ;*($1A0A) = r0; // lower screen or user RAM
                                                                      ;4,3 $01B9..$01BB: CC 1A 0A
        stra,r0 $1A13        ;*($1A13) = r0; // lower screen or user RAM
                                                                      ;4,3 $01BC..$01BE: CC 1A 13
        lodi,r0 $70          ;r0 = $70;                               ;2,2 $01BF..$01C0: 04 70
        stra,r0 $1A09        ;*($1A09) = r0; // lower screen or user RAM
                                                                      ;4,3 $01C1..$01C3: CC 1A 09
;$01C4:
        lodi,r2 $AA          ;r2 = $AA;                               ;2,2 $01C4..$01C5: 06 AA
        lodi,r3 $08          ;r3 = $08;                               ;2,2 $01C6..$01C7: 07 08
;$01C8:
        eorz    r0           ;r0 = 0;                                 ;2,1 $01C8:        20
        stra,r0 $197F,r3     ;*($197F + r3) = r0;                     ;4,3 $01C9..$01CB: CF 79 7F
        loda,r0 $0099,r3     ;r0 = *($0099 + r3);                     ;4,3 $01CC..$01CE: 0F 60 99
        stra,r0 $1997,r3     ;*($1997 + r3) = r0;                     ;4,3 $01CF..$01D1: CF 79 97
        lodz    r2           ;r0 = r2;                                ;2,1 $01D2:        02
        stra,r0 $19AF,r3     ;*($19AF + r3) = r0;                     ;4,3 $01D3..$01D5: CF 79 AF
        bdrr,r3 $01C8        ;if (--r3 != 0) goto $01C8; // ROM       ;3,2 $01D6..$01D7: FB 70
        lodi,r3 $10          ;r3 = $10;                               ;2,2 $01D8..$01D9: 07 10
;$01DA:
        loda,r0 $00EF,r3     ;r0 = *($00EF + r3);                     ;4,3 $01DA..$01DC: 0F 60 EF
        stra,r0 $17FF,r3     ;*($17FF + r3) = r0;                     ;4,3 $01DD..$01DF: CF 77 FF
        bdrr,r3 $01DA        ;if (--r3 != 0) goto $01DA; // ROM       ;3,2 $01E0..$01E1: FB 78
        bcta,un $080B        ;goto $080B; // ROM                      ;3,3 $01E2..$01E4: 1F 08 0B
;
;$01E5:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $01E5..$01E7: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $01E8..$01EA: 3F 07 00
        loda,r0 $19FD        ;r0 = SPRITECOLLIDE; // UVI register     ;4,3 $01EB..$01ED: 0C 19 FD
        stra,r0 $18EC        ;*($18EC) = r0; // CPU+UVI RAM           ;4,3 $01EE..$01F0: CC 18 EC
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $01F1..$01F3: 0C 18 E8
        andi,r0 $01          ;r0 &= %00000001;                        ;2,2 $01F4..$01F5: 44 01
        bcta,eq $029C        ;if == goto $029C; // ROM                ;3,3 $01F6..$01F8: 1C 02 9C
        loda,r0 $1A0C        ;r0 = *($1A0C); // lower screen or user RAM
                                                                      ;4,3 $01F9..$01FB: 0C 1A 0C
        bctr,eq $021B        ;if == goto $021B; // ROM                ;3,2 $01FC..$01FD: 18 1D
        loda,r0 $1A0D        ;r0 = *($1A0D); // lower screen or user RAM
                                                                      ;4,3 $01FE..$0200: 0C 1A 0D
        bctr,eq $020E        ;if == goto $020E; // ROM                ;3,2 $0201..$0202: 18 0B
        subi,r0 $01          ;r0--;                                   ;2,2 $0203..$0204: A4 01
        stra,r0 $1A0D        ;*($1A0D) = r0; // lower screen or user RAM
                                                                      ;4,3 $0205..$0207: CC 1A 0D
        loda,r0 $18D7        ;r0 = *($18D7); // CPU+UVI RAM           ;4,3 $0208..$020A: 0C 18 D7
        bcta,un $0266        ;goto $0266; // ROM                      ;3,3 $020B..$020D: 1F 02 66
;
;$020E:
        lodi,r0 $0A          ;r0 = $0A;                               ;2,2 $020E..$020F: 04 0A
        stra,r0 $1A0D        ;*($1A0D) = r0; // lower screen or user RAM
                                                                      ;4,3 $0210..$0212: CC 1A 0D
        bsta,un $0802        ;gosub $0802; // ROM                     ;3,3 $0213..$0215: 3F 08 02
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0216..$0217: 44 0F
        bcta,un $0266        ;goto $0266; // ROM                      ;3,3 $0218..$021A: 1F 02 66
;
;$021B:
        loda,r3 $19FF        ;r3 = P1PADDLE; // UVI register          ;4,3 $021B..$021D: 0F 19 FF
        loda,r0 $18D0        ;r0 = *($18D0); // CPU+UVI RAM           ;4,3 $021E..$0220: 0C 18 D0
        eori,r0 $40          ;r0 ^= %01000000;                        ;2,2 $0221..$0222: 24 40
        stra,r0 $18D0        ;*($18D0) = r0; // CPU+UVI RAM           ;4,3 $0223..$0225: CC 18 D0
        stra,r0 $19F9        ;BGCOLOUR = r0; // UVI register          ;4,3 $0226..$0228: CC 19 F9
        loda,r0 $18D7        ;r0 = *($18D7); // CPU+UVI RAM           ;4,3 $0229..$022B: 0C 18 D7
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $022C..$022D: 44 0F
        strz    r1           ;r1 = r0;                                ;2,1 $022E:        C1
        strz    r2           ;r2 = r0;                                ;2,1 $022F:        C2
        loda,r0 $18D0        ;r0 = *($18D0); // CPU+UVI RAM           ;4,3 $0230..$0232: 0C 18 D0
        andi,r0 $40          ;r0 &= %01000000;                        ;2,2 $0233..$0234: 44 40
        bctr,eq $024F        ;if == goto $024F; // ROM                ;3,2 $0235..$0236: 18 18
        eori,r3 $FF          ;r3 ^= %11111111;                        ;2,2 $0237..$0238: 27 FF
        lodi,r0 $0A          ;r0 = $0A;                               ;2,2 $0239..$023A: 04 0A
        andz    r2           ;r0 &= r2;                               ;2,1 $023B:        42
        strz    r2           ;r2 = r0;                                ;2,1 $023C:        C2
        comi,r3 $C8          ;compare r3 against $C8;                 ;2,2 $023D..$023E: E7 C8
        bctr,gt $0247        ;if > goto $0247; // ROM                 ;3,2 $023F..$0240: 19 06
        comi,r3 $38          ;compare r3 against $38;                 ;2,2 $0241..$0242: E7 38
        bctr,lt $024B        ;if < goto $024B; // ROM                 ;3,2 $0243..$0244: 1A 06
        bctr,un $0266        ;goto $0266; // ROM                      ;3,2 $0245..$0246: 1B 1F
;
;$0247:
        lodi,r0 $01          ;r0 = $01;                               ;2,2 $0247..$0248: 04 01
        bctr,un $0263        ;goto $0263; // ROM                      ;3,2 $0249..$024A: 1B 18
;
;$024B:
        lodi,r0 $04          ;r0 = $04;                               ;2,2 $024B..$024C: 04 04
        bctr,un $0263        ;goto $0263; // ROM                      ;3,2 $024D..$024E: 1B 14
;
;$024F:
        lodi,r0 $05          ;r0 = $05;                               ;2,2 $024F..$0250: 04 05
        andz    r2           ;r0 &= r2;                               ;2,1 $0251:        42
        strz    r2           ;r2 = r0;                                ;2,1 $0252:        C2
        comi,r3 $C8          ;compare r3 against $C8;                 ;2,2 $0253..$0254: E7 C8
        bctr,gt $025D        ;if > goto $025D; // ROM                 ;3,2 $0255..$0256: 19 06
        comi,r3 $38          ;compare r3 against $38;                 ;2,2 $0257..$0258: E7 38
        bctr,lt $0261        ;if < goto $0261; // ROM                 ;3,2 $0259..$025A: 1A 06
        bctr,un $0266        ;goto $0266; // ROM                      ;3,2 $025B..$025C: 1B 09
;
;$025D:
        lodi,r0 $02          ;r0 = $02;                               ;2,2 $025D..$025E: 04 02
        bctr,un $0263        ;goto $0263; // ROM                      ;3,2 $025F..$0260: 1B 02
;
;$0261:
        lodi,r0 $08          ;r0 = $08;                               ;2,2 $0261..$0262: 04 08
;$0263:
        iorz    r2           ;r0 |= r2;                               ;2,1 $0263:        62
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0264..$0265: 44 0F
;$0266:
        stra,r0 $18D7        ;*($18D7) = r0; // CPU+UVI RAM           ;4,3 $0266..$0268: CC 18 D7
        iorz    r0           ;r0 |= r0;                               ;2,1 $0269:        60
        bcfr,eq $0276        ;if != goto $0276; // ROM                ;3,2 $026A..$026B: 98 0A
        lodz    r1           ;r0 = r1;                                ;2,1 $026C:        01
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $026D..$026E: 44 0F
        bctr,eq $029C        ;if == goto $029C; // ROM                ;3,2 $026F..$0270: 18 2B
        strz    r3           ;r3 = r0;                                ;2,1 $0271:        C3
        eorz    r0           ;r0 = 0;                                 ;2,1 $0272:        20
        strz    r2           ;r2 = r0;                                ;2,1 $0273:        C2
        bctr,un $0282        ;goto $0282; // ROM                      ;3,2 $0274..$0275: 1B 0C
;
;$0276:
        loda,r2 $18D8        ;r2 = *($18D8); // CPU+UVI RAM           ;4,3 $0276..$0278: 0E 18 D8
        bsta,un $067C        ;gosub $067C; // ROM                     ;3,3 $0279..$027B: 3F 06 7C
        stra,r2 $18D8        ;*($18D8) = r2; // CPU+UVI RAM           ;4,3 $027C..$027E: CE 18 D8
        loda,r3 $18D7        ;r3 = *($18D7); // CPU+UVI RAM           ;4,3 $027F..$0281: 0F 18 D7
;$0282:
        stra,r3 $18E9        ;*($18E9) = r3; // CPU+UVI RAM           ;4,3 $0282..$0284: CF 18 E9
        lodi,r0 $00          ;r0 = $00;                               ;2,2 $0285..$0286: 04 00
        stra,r0 $18D1        ;*($18D1) = r0; // CPU+UVI RAM           ;4,3 $0287..$0289: CC 18 D1
        lodi,r0 $1A          ;r0 = $1A;                               ;2,2 $028A..$028B: 04 1A
        stra,r0 $18D2        ;*($18D2) = r0; // CPU+UVI RAM           ;4,3 $028C..$028E: CC 18 D2
        lodi,r0 $19          ;r0 = $19;                               ;2,2 $028F..$0290: 04 19
        stra,r0 $18D3        ;*($18D3) = r0; // CPU+UVI RAM           ;4,3 $0291..$0293: CC 18 D3
        lodi,r0 $80          ;r0 = $80;                               ;2,2 $0294..$0295: 04 80
        stra,r0 $18D4        ;*($18D4) = r0; // CPU+UVI RAM           ;4,3 $0296..$0298: CC 18 D4
        bsta,un $070A        ;gosub $070A; // ROM                     ;3,3 $0299..$029B: 3F 07 0A
;$029C:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $029C..$029E: 0C 18 E8
        andi,r0 $02          ;r0 &= %00000010;                        ;2,2 $029F..$02A0: 44 02
        bcta,eq $02FE        ;if == goto $02FE; // ROM                ;3,3 $02A1..$02A3: 1C 02 FE
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $02A4..$02A6: 0C 18 E8
        andi,r0 $04          ;r0 &= %00000100;                        ;2,2 $02A7..$02A8: 44 04
        bcfa,eq $02D1        ;if != goto $02D1; // ROM                ;3,3 $02A9..$02AB: 9C 02 D1
        loda,r2 $18DA        ;r2 = *($18DA); // CPU+UVI RAM           ;4,3 $02AC..$02AE: 0E 18 DA
        bsta,un $067C        ;gosub $067C; // ROM                     ;3,3 $02AF..$02B1: 3F 06 7C
        stra,r2 $18DA        ;*($18DA) = r2; // CPU+UVI RAM           ;4,3 $02B2..$02B4: CE 18 DA
        loda,r3 $18D9        ;r3 = *($18D9); // CPU+UVI RAM           ;4,3 $02B5..$02B7: 0F 18 D9
        loda,r0 $18E2        ;r0 = *($18E2); // CPU+UVI RAM           ;4,3 $02B8..$02BA: 0C 18 E2
        stra,r0 $18D1        ;*($18D1) = r0; // CPU+UVI RAM           ;4,3 $02BB..$02BD: CC 18 D1
        loda,r0 $18E3        ;r0 = *($18E3); // CPU+UVI RAM           ;4,3 $02BE..$02C0: 0C 18 E3
        stra,r0 $18D2        ;*($18D2) = r0; // CPU+UVI RAM           ;4,3 $02C1..$02C3: CC 18 D2
        lodi,r0 $19          ;r0 = $19;                               ;2,2 $02C4..$02C5: 04 19
        stra,r0 $18D3        ;*($18D3) = r0; // CPU+UVI RAM           ;4,3 $02C6..$02C8: CC 18 D3
        lodi,r0 $88          ;r0 = $88;                               ;2,2 $02C9..$02CA: 04 88
        stra,r0 $18D4        ;*($18D4) = r0; // CPU+UVI RAM           ;4,3 $02CB..$02CD: CC 18 D4
        bsta,un $070A        ;gosub $070A; // ROM                     ;3,3 $02CE..$02D0: 3F 07 0A
;$02D1:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $02D1..$02D3: 0C 18 E8
        andi,r0 $08          ;r0 &= %00001000;                        ;2,2 $02D4..$02D5: 44 08
        bcfa,eq $02FE        ;if != goto $02FE; // ROM                ;3,3 $02D6..$02D8: 9C 02 FE
        loda,r2 $18DC        ;r2 = *($18DC); // CPU+UVI RAM           ;4,3 $02D9..$02DB: 0E 18 DC
        bsta,un $067C        ;gosub $067C; // ROM                     ;3,3 $02DC..$02DE: 3F 06 7C
        stra,r2 $18DC        ;*($18DC) = r2; // CPU+UVI RAM           ;4,3 $02DF..$02E1: CE 18 DC
        loda,r3 $18DB        ;r3 = *($18DB); // CPU+UVI RAM           ;4,3 $02E2..$02E4: 0F 18 DB
        loda,r0 $18E2        ;r0 = *($18E2); // CPU+UVI RAM           ;4,3 $02E5..$02E7: 0C 18 E2
        stra,r0 $18D1        ;*($18D1) = r0; // CPU+UVI RAM           ;4,3 $02E8..$02EA: CC 18 D1
        loda,r0 $18E3        ;r0 = *($18E3); // CPU+UVI RAM           ;4,3 $02EB..$02ED: 0C 18 E3
        stra,r0 $18D2        ;*($18D2) = r0; // CPU+UVI RAM           ;4,3 $02EE..$02F0: CC 18 D2
        lodi,r0 $19          ;r0 = $19;                               ;2,2 $02F1..$02F2: 04 19
        stra,r0 $18D3        ;*($18D3) = r0; // CPU+UVI RAM           ;4,3 $02F3..$02F5: CC 18 D3
        lodi,r0 $90          ;r0 = $90;                               ;2,2 $02F6..$02F7: 04 90
        stra,r0 $18D4        ;*($18D4) = r0; // CPU+UVI RAM           ;4,3 $02F8..$02FA: CC 18 D4
        bsta,un $070A        ;gosub $070A; // ROM                     ;3,3 $02FB..$02FD: 3F 07 0A
;$02FE:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $02FE..$0300: 3F 07 05
        bsta,un $05A8        ;gosub $05A8; // ROM                     ;3,3 $0301..$0303: 3F 05 A8
        loda,r0 $1A06        ;r0 = *($1A06); // lower screen or user RAM
                                                                      ;4,3 $0304..$0306: 0C 1A 06
        addi,r0 $01          ;r0++;                                   ;2,2 $0307..$0308: 84 01
        stra,r0 $1A06        ;*($1A06) = r0; // lower screen or user RAM
                                                                      ;4,3 $0309..$030B: CC 1A 06
        loda,r3 $18EF        ;r3 = *($18EF); // CPU+UVI RAM           ;4,3 $030C..$030E: 0F 18 EF
        bctr,eq $0318        ;if == goto $0318; // ROM                ;3,2 $030F..$0310: 18 07
        subi,r3 $01          ;r3--;                                   ;2,2 $0311..$0312: A7 01
        stra,r3 $18EF        ;*($18EF) = r3; // CPU+UVI RAM           ;4,3 $0313..$0315: CF 18 EF
        bctr,un $033F        ;goto $033F; // ROM                      ;3,2 $0316..$0317: 1B 27
;
;$0318:
        loda,r0 $180F        ;r0 = *($180F); // upper screen          ;4,3 $0318..$031A: 0C 18 0F
        strz    r2           ;r2 = r0;                                ;2,1 $031B:        C2
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $031C..$031D: 44 0F
        bctr,eq $0327        ;if == goto $0327; // ROM                ;3,2 $031E..$031F: 18 07
        subi,r2 $01          ;r2--;                                   ;2,2 $0320..$0321: A6 01
        stra,r2 $180F        ;*($180F) = r2; // upper screen          ;4,3 $0322..$0324: CE 18 0F
        bctr,un $033A        ;goto $033A; // ROM                      ;3,2 $0325..$0326: 1B 13
;
;$0327:
        loda,r0 $180E        ;r0 = *($180E); // upper screen          ;4,3 $0327..$0329: 0C 18 0E
        strz    r1           ;r1 = r0;                                ;2,1 $032A:        C1
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $032B..$032C: 44 0F
        bcta,eq $0A91        ;if == goto $0A91; // ROM                ;3,3 $032D..$032F: 1C 0A 91
        subi,r1 $01          ;r1--;                                   ;2,2 $0330..$0331: A5 01
        stra,r1 $180E        ;*($180E) = r1; // upper screen          ;4,3 $0332..$0334: CD 18 0E
        lodi,r0 $59          ;r0 = $59;                               ;2,2 $0335..$0336: 04 59
        stra,r0 $180F        ;*($180F) = r0; // upper screen          ;4,3 $0337..$0339: CC 18 0F
;$033A:
        lodi,r0 $32          ;r0 = $32;                               ;2,2 $033A..$033B: 04 32
        stra,r0 $18EF        ;*($18EF) = r0; // CPU+UVI RAM           ;4,3 $033C..$033E: CC 18 EF
;$033F:
        loda,r3 $18EC        ;r3 = *($18EC); // CPU+UVI RAM           ;4,3 $033F..$0341: 0F 18 EC
        eori,r3 $FF          ;r3 ^= %11111111;                        ;2,2 $0342..$0343: 27 FF
        lodi,r0 $10          ;r0 = $10;                               ;2,2 $0344..$0345: 04 10
        andz    r3           ;r0 &= r3;                               ;2,1 $0346:        43
        bcta,eq $0371        ;if == goto $0371; // ROM                ;3,3 $0347..$0349: 1C 03 71
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $034A..$034C: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $034D..$034E: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $034F..$0351: CC 1A 11
        lodi,r0 $5C          ;r0 = $5C;                               ;2,2 $0352..$0353: 04 5C
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $0354..$0356: CC 1A 12
        eorz    r0           ;r0 = 0;                                 ;2,1 $0357:        20
        stra,r0 $18F2        ;SPRITE1Y = r0; // UVI register          ;4,3 $0358..$035A: CC 18 F2
        stra,r0 $18F3        ;SPRITE1X = r0; // UVI register          ;4,3 $035B..$035D: CC 18 F3
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $035E..$0360: 0C 18 E8
        iori,r0 $04          ;r0 |= %00000100;                        ;2,2 $0361..$0362: 64 04
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $0363..$0365: CC 18 E8
        bsta,un $061B        ;gosub $061B; // ROM                     ;3,3 $0366..$0368: 3F 06 1B
        lodi,r2 $02          ;r2 = $02;                               ;2,2 $0369..$036A: 06 02
        bsta,un $07BF        ;gosub $07BF; // ROM                     ;3,3 $036B..$036D: 3F 07 BF
        bcta,un $03A4        ;goto $03A4; // ROM                      ;3,3 $036E..$0370: 1F 03 A4
;
;$0371:
        lodi,r0 $20          ;r0 = $20;                               ;2,2 $0371..$0372: 04 20
        andz    r3           ;r0 &= r3;                               ;2,1 $0373:        43
        bcta,eq $039E        ;if == goto $039E; // ROM                ;3,3 $0374..$0376: 1C 03 9E
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0377..$0379: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $037A..$037B: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $037C..$037E: CC 1A 11
        lodi,r0 $5C          ;r0 = $5C;                               ;2,2 $037F..$0380: 04 5C
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $0381..$0383: CC 1A 12
        eorz    r0           ;r0 = 0;                                 ;2,1 $0384:        20
        stra,r0 $18F5        ;SPRITE2X = r0; // UVI register          ;4,3 $0385..$0387: CC 18 F5
        stra,r0 $18F4        ;SPRITE2Y = r0; // UVI register          ;4,3 $0388..$038A: CC 18 F4
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $038B..$038D: 0C 18 E8
        iori,r0 $08          ;r0 |= %00001000;                        ;2,2 $038E..$038F: 64 08
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $0390..$0392: CC 18 E8
        bsta,un $061B        ;gosub $061B; // ROM                     ;3,3 $0393..$0395: 3F 06 1B
        lodi,r2 $02          ;r2 = $02;                               ;2,2 $0396..$0397: 06 02
        bsta,un $07BF        ;gosub $07BF; // ROM                     ;3,3 $0398..$039A: 3F 07 BF
        bcta,un $03A4        ;goto $03A4; // ROM                      ;3,3 $039B..$039D: 1F 03 A4
;
;$039E:
        lodi,r0 $03          ;r0 = $03;                               ;2,2 $039E..$039F: 04 03
        andz    r3           ;r0 &= r3;                               ;2,1 $03A0:        43
        bcfa,eq $0A91        ;if != goto $0A91; // ROM                ;3,3 $03A1..$03A3: 9C 0A 91
;$03A4:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $03A4..$03A6: 0C 18 E8
        andi,r0 $10          ;r0 &= %00010000;                        ;2,2 $03A7..$03A8: 44 10
        bcta,eq $03F8        ;if == goto $03F8; // ROM                ;3,3 $03A9..$03AB: 1C 03 F8
        loda,r3 $18EA        ;r3 = *($18EA); // CPU+UVI RAM           ;4,3 $03AC..$03AE: 0F 18 EA
        loda,r2 $18F7        ;r2 = SPRITE3X; // UVI register          ;4,3 $03AF..$03B1: 0E 18 F7
        loda,r1 $18F6        ;r1 = SPRITE3Y; // UVI register          ;4,3 $03B2..$03B4: 0D 18 F6
        bsta,un $068D        ;gosub $068D; // ROM                     ;3,3 $03B5..$03B7: 3F 06 8D
        comi,r3 $FF          ;compare r3 against $FF;                 ;2,2 $03B8..$03B9: E7 FF
        bctr,eq $03EA        ;if == goto $03EA; // ROM                ;3,2 $03BA..$03BB: 18 2E
        comi,r3 $3C          ;compare r3 against $3C;                 ;2,2 $03BC..$03BD: E7 3C
        bctr,lt $03D7        ;if < goto $03D7; // ROM                 ;3,2 $03BE..$03BF: 1A 17
        comi,r3 $3F          ;compare r3 against $3F;                 ;2,2 $03C0..$03C1: E7 3F
        bctr,eq $03D7        ;if == goto $03D7; // ROM                ;3,2 $03C2..$03C3: 18 13
        loda,r0 $1A00        ;r0 = *($1A00); // lower screen or user RAM
                                                                      ;4,3 $03C4..$03C6: 0C 1A 00
        andi,r0 $01          ;r0 &= %00000001;                        ;2,2 $03C7..$03C8: 44 01
        bctr,eq $03D7        ;if == goto $03D7; // ROM                ;3,2 $03C9..$03CA: 18 0C
        loda,r3 $18EB        ;r3 = *($18EB); // CPU+UVI RAM           ;4,3 $03CB..$03CD: 0F 18 EB
        eorz    r0           ;r0 = 0;                                 ;2,1 $03CE:        20
        stra,r0 $1800,r3     ;*($1800 + r3) = r0;                     ;4,3 $03CF..$03D1: CF 78 00
        lodi,r2 $01          ;r2 = $01;                               ;2,2 $03D2..$03D3: 06 01
        bsta,un $07BF        ;gosub $07BF; // ROM                     ;3,3 $03D4..$03D6: 3F 07 BF
;$03D7:
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $03D7..$03D9: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $03DA..$03DB: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $03DC..$03DE: CC 1A 11
        lodi,r0 $64          ;r0 = $64;                               ;2,2 $03DF..$03E0: 04 64
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $03E1..$03E3: CC 1A 12
        bsta,un $061B        ;gosub $061B; // ROM                     ;3,3 $03E4..$03E6: 3F 06 1B
        bcta,un $0438        ;goto $0438; // ROM                      ;3,3 $03E7..$03E9: 1F 04 38
;
;$03EA:
        stra,r2 $18F7        ;SPRITE3X = r2; // UVI register          ;4,3 $03EA..$03EC: CE 18 F7
        stra,r1 $18F6        ;SPRITE3Y = r1; // UVI register          ;4,3 $03ED..$03EF: CD 18 F6
        comi,r2 $2F          ;compare r2 against $2F;                 ;2,2 $03F0..$03F1: E6 2F
        bsta,lt $061B        ;if < gosub $061B; // ROM                ;3,3 $03F2..$03F4: 3E 06 1B
        bcta,un $0438        ;goto $0438; // ROM                      ;3,3 $03F5..$03F7: 1F 04 38
;
;$03F8:
        eorz    r0           ;r0 = 0;                                 ;2,1 $03F8:        20
        strz    r3           ;r3 = r0;                                ;2,1 $03F9:        C3
;$03FA:
        loda,r0 $1900,r3     ;r0 = *($1900 + r3);                     ;4,3 $03FA..$03FC: 0F 79 00
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $03FD..$03FE: 44 0F
        bcfr,eq $0409        ;if != goto $0409; // ROM                ;3,2 $03FF..$0400: 98 08
        addi,r3 $01          ;r3++;                                   ;2,2 $0401..$0402: 87 01
        comi,r3 $04          ;compare r3 against $04;                 ;2,2 $0403..$0404: E7 04
        bcfr,eq $03FA        ;if != goto $03FA; // ROM                ;3,2 $0405..$0406: 98 73
        bctr,un $0438        ;goto $0438; // ROM                      ;3,2 $0407..$0408: 1B 2F
;
;$0409:
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0409..$040B: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $040C..$040D: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $040E..$0410: CC 1A 11
        lodi,r0 $6A          ;r0 = $6A;                               ;2,2 $0411..$0412: 04 6A
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $0413..$0415: CC 1A 12
        loda,r0 $18E9        ;r0 = *($18E9); // CPU+UVI RAM           ;4,3 $0416..$0418: 0C 18 E9
        stra,r0 $18EA        ;*($18EA) = r0; // CPU+UVI RAM           ;4,3 $0419..$041B: CC 18 EA
        loda,r0 $18F1        ;r0 = SPRITE0X; // UVI register          ;4,3 $041C..$041E: 0C 18 F1
        stra,r0 $18F7        ;SPRITE3X = r0; // UVI register          ;4,3 $041F..$0421: CC 18 F7
        loda,r0 $18F0        ;r0 = SPRITE0Y; // UVI register          ;4,3 $0422..$0424: 0C 18 F0
        stra,r0 $18F6        ;SPRITE3Y = r0; // UVI register          ;4,3 $0425..$0427: CC 18 F6
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0428..$042A: 0C 18 E8
        iori,r0 $10          ;r0 |= %00010000;                        ;2,2 $042B..$042C: 64 10
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $042D..$042F: CC 18 E8
        loda,r0 $1A06        ;r0 = *($1A06); // lower screen or user RAM
                                                                      ;4,3 $0430..$0432: 0C 1A 06
        addi,r0 $01          ;r0++;                                   ;2,2 $0433..$0434: 84 01
        stra,r0 $1A06        ;*($1A06) = r0; // lower screen or user RAM
                                                                      ;4,3 $0435..$0437: CC 1A 06
;$0438:
        loda,r1 $18E8        ;r1 = *($18E8); // CPU+UVI RAM           ;4,3 $0438..$043A: 0D 18 E8
        andi,r1 $FC          ;r1 &= %11111100;                        ;2,2 $043B..$043C: 45 FC
        loda,r0 $18E6        ;r0 = *($18E6); // CPU+UVI RAM           ;4,3 $043D..$043F: 0C 18 E6
        subi,r0 $01          ;r0--;                                   ;2,2 $0440..$0441: A4 01
        stra,r0 $18E6        ;*($18E6) = r0; // CPU+UVI RAM           ;4,3 $0442..$0444: CC 18 E6
        bcfr,eq $044F        ;if != goto $044F; // ROM                ;3,2 $0445..$0446: 98 08
        iori,r1 $01          ;r1 |= %00000001;                        ;2,2 $0447..$0448: 65 01
        loda,r0 $18DF        ;r0 = *($18DF); // CPU+UVI RAM           ;4,3 $0449..$044B: 0C 18 DF
        stra,r0 $18E6        ;*($18E6) = r0; // CPU+UVI RAM           ;4,3 $044C..$044E: CC 18 E6
;$044F:
        loda,r0 $18E7        ;r0 = *($18E7); // CPU+UVI RAM           ;4,3 $044F..$0451: 0C 18 E7
        subi,r0 $01          ;r0--;                                   ;2,2 $0452..$0453: A4 01
        stra,r0 $18E7        ;*($18E7) = r0; // CPU+UVI RAM           ;4,3 $0454..$0456: CC 18 E7
        bcfr,eq $0461        ;if != goto $0461; // ROM                ;3,2 $0457..$0458: 98 08
        iori,r1 $02          ;r1 |= %00000010;                        ;2,2 $0459..$045A: 65 02
        loda,r0 $18E0        ;r0 = *($18E0); // CPU+UVI RAM           ;4,3 $045B..$045D: 0C 18 E0
        stra,r0 $18E7        ;*($18E7) = r0; // CPU+UVI RAM           ;4,3 $045E..$0460: CC 18 E7
;$0461:
        stra,r1 $18E8        ;*($18E8) = r1; // CPU+UVI RAM           ;4,3 $0461..$0463: CD 18 E8
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0464..$0466: 0C 18 E8
        andi,r0 $01          ;r0 &= %00000001;                        ;2,2 $0467..$0468: 44 01
        bctr,eq $0491        ;if == goto $0491; // ROM                ;3,2 $0469..$046A: 18 26
        loda,r3 $18D7        ;r3 = *($18D7); // CPU+UVI RAM           ;4,3 $046B..$046D: 0F 18 D7
        loda,r2 $18F1        ;r2 = SPRITE0X; // UVI register          ;4,3 $046E..$0470: 0E 18 F1
        loda,r1 $18F0        ;r1 = SPRITE0Y; // UVI register          ;4,3 $0471..$0473: 0D 18 F0
        bsta,un $068D        ;gosub $068D; // ROM                     ;3,3 $0474..$0476: 3F 06 8D
        comi,r3 $3F          ;compare r3 against $3F;                 ;2,2 $0477..$0478: E7 3F
        bcta,eq $0992        ;if == goto $0992; // ROM                ;3,3 $0479..$047B: 1C 09 92
        comi,r3 $3C          ;compare r3 against $3C;                 ;2,2 $047C..$047D: E7 3C
        bcta,eq $0A91        ;if == goto $0A91; // ROM                ;3,3 $047E..$0480: 1C 0A 91
        comi,r3 $3D          ;compare r3 against $3D;                 ;2,2 $0481..$0482: E7 3D
        bcta,eq $0A91        ;if == goto $0A91; // ROM                ;3,3 $0483..$0485: 1C 0A 91
        stra,r2 $18F1        ;SPRITE0X = r2; // UVI register          ;4,3 $0486..$0488: CE 18 F1
        comi,r2 $2F          ;compare r2 against $2F;                 ;2,2 $0489..$048A: E6 2F
        bcta,lt $09D6        ;if < goto $09D6; // ROM                 ;3,3 $048B..$048D: 1E 09 D6
        stra,r1 $18F0        ;SPRITE0Y = r1; // UVI register          ;4,3 $048E..$0490: CD 18 F0
;$0491:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0491..$0493: 0C 18 E8
        andi,r0 $02          ;r0 &= %00000010;                        ;2,2 $0494..$0495: 44 02
        bcta,eq $0547        ;if == goto $0547; // ROM                ;3,3 $0496..$0498: 1C 05 47
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0499..$049B: 0C 18 E8
        andi,r0 $04          ;r0 &= %00000100;                        ;2,2 $049C..$049D: 44 04
        bcfa,eq $04F0        ;if != goto $04F0; // ROM                ;3,3 $049E..$04A0: 9C 04 F0
        bsta,un $0802        ;gosub $0802; // ROM                     ;3,3 $04A1..$04A3: 3F 08 02
        coma,r0 $1A09        ;compare r0 against *($1A09); // lower screen or user RAM
                                                                      ;4,3 $04A4..$04A6: EC 1A 09
        bctr,gt $04B4        ;if > goto $04B4; // ROM                 ;3,2 $04A7..$04A8: 19 0B
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $04A9..$04AA: 44 0F
        stra,r0 $18D9        ;*($18D9) = r0; // CPU+UVI RAM           ;4,3 $04AB..$04AD: CC 18 D9
        loda,r0 $18E1        ;r0 = *($18E1); // CPU+UVI RAM           ;4,3 $04AE..$04B0: 0C 18 E1
        stra,r0 $18E4        ;*($18E4) = r0; // CPU+UVI RAM           ;4,3 $04B1..$04B3: CC 18 E4
;$04B4:
        loda,r3 $18F3        ;r3 = SPRITE1X; // UVI register          ;4,3 $04B4..$04B6: 0F 18 F3
        loda,r2 $18F2        ;r2 = SPRITE1Y; // UVI register          ;4,3 $04B7..$04B9: 0E 18 F2
        loda,r1 $18D9        ;r1 = *($18D9); // CPU+UVI RAM           ;4,3 $04BA..$04BC: 0D 18 D9
        loda,r0 $18E4        ;r0 = *($18E4); // CPU+UVI RAM           ;4,3 $04BD..$04BF: 0C 18 E4
        subi,r0 $01          ;r0--;                                   ;2,2 $04C0..$04C1: A4 01
        stra,r0 $18E4        ;*($18E4) = r0; // CPU+UVI RAM           ;4,3 $04C2..$04C4: CC 18 E4
        bctr,eq $04CC        ;if == goto $04CC; // ROM                ;3,2 $04C5..$04C6: 18 05
        bsta,un $0666        ;gosub $0666; // ROM                     ;3,3 $04C7..$04C9: 3F 06 66
        bctr,un $04DB        ;goto $04DB; // ROM                      ;3,2 $04CA..$04CB: 1B 0F
;
;$04CC:
        loda,r0 $18E1        ;r0 = *($18E1); // CPU+UVI RAM           ;4,3 $04CC..$04CE: 0C 18 E1
        stra,r0 $18E4        ;*($18E4) = r0; // CPU+UVI RAM           ;4,3 $04CF..$04D1: CC 18 E4
        loda,r1 $18DD        ;r1 = *($18DD); // CPU+UVI RAM           ;4,3 $04D2..$04D4: 0D 18 DD
        bsta,un $062C        ;gosub $062C; // ROM                     ;3,3 $04D5..$04D7: 3F 06 2C
        stra,r1 $18DD        ;*($18DD) = r1; // CPU+UVI RAM           ;4,3 $04D8..$04DA: CD 18 DD
;$04DB:
        stra,r0 $18D9        ;*($18D9) = r0; // CPU+UVI RAM           ;4,3 $04DB..$04DD: CC 18 D9
        loda,r3 $18D9        ;r3 = *($18D9); // CPU+UVI RAM           ;4,3 $04DE..$04E0: 0F 18 D9
        loda,r2 $18F3        ;r2 = SPRITE1X; // UVI register          ;4,3 $04E1..$04E3: 0E 18 F3
        loda,r1 $18F2        ;r1 = SPRITE1Y; // UVI register          ;4,3 $04E4..$04E6: 0D 18 F2
        bsta,un $068D        ;gosub $068D; // ROM                     ;3,3 $04E7..$04E9: 3F 06 8D
        stra,r2 $18F3        ;SPRITE1X = r2; // UVI register          ;4,3 $04EA..$04EC: CE 18 F3
        stra,r1 $18F2        ;SPRITE1Y = r1; // UVI register          ;4,3 $04ED..$04EF: CD 18 F2
;$04F0:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $04F0..$04F2: 0C 18 E8
        andi,r0 $08          ;r0 &= %00001000;                        ;2,2 $04F3..$04F4: 44 08
        bcfa,eq $0547        ;if != goto $0547; // ROM                ;3,3 $04F5..$04F7: 9C 05 47
        bsta,un $0802        ;gosub $0802; // ROM                     ;3,3 $04F8..$04FA: 3F 08 02
        coma,r0 $1A09        ;compare r0 against *($1A09); // lower screen or user RAM
                                                                      ;4,3 $04FB..$04FD: EC 1A 09
        bctr,gt $050B        ;if > goto $050B; // ROM                 ;3,2 $04FE..$04FF: 19 0B
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0500..$0501: 44 0F
        stra,r0 $18DB        ;*($18DB) = r0; // CPU+UVI RAM           ;4,3 $0502..$0504: CC 18 DB
        loda,r0 $18E1        ;r0 = *($18E1); // CPU+UVI RAM           ;4,3 $0505..$0507: 0C 18 E1
        stra,r0 $18E5        ;*($18E5) = r0; // CPU+UVI RAM           ;4,3 $0508..$050A: CC 18 E5
;$050B:
        loda,r3 $18F5        ;r3 = SPRITE2X; // UVI register          ;4,3 $050B..$050D: 0F 18 F5
        loda,r2 $18F4        ;r2 = SPRITE2Y; // UVI register          ;4,3 $050E..$0510: 0E 18 F4
        loda,r1 $18DB        ;r1 = *($18DB); // CPU+UVI RAM           ;4,3 $0511..$0513: 0D 18 DB
        loda,r0 $18E5        ;r0 = *($18E5); // CPU+UVI RAM           ;4,3 $0514..$0516: 0C 18 E5
        subi,r0 $01          ;r0--;                                   ;2,2 $0517..$0518: A4 01
        stra,r0 $18E5        ;*($18E5) = r0; // CPU+UVI RAM           ;4,3 $0519..$051B: CC 18 E5
        bctr,eq $0523        ;if == goto $0523; // ROM                ;3,2 $051C..$051D: 18 05
        bsta,un $0666        ;gosub $0666; // ROM                     ;3,3 $051E..$0520: 3F 06 66
        bctr,un $0532        ;goto $0532; // ROM                      ;3,2 $0521..$0522: 1B 0F
;
;$0523:
        loda,r0 $18E1        ;r0 = *($18E1); // CPU+UVI RAM           ;4,3 $0523..$0525: 0C 18 E1
        stra,r0 $18E5        ;*($18E5) = r0; // CPU+UVI RAM           ;4,3 $0526..$0528: CC 18 E5
        loda,r1 $18DE        ;r1 = *($18DE); // CPU+UVI RAM           ;4,3 $0529..$052B: 0D 18 DE
        bsta,un $062C        ;gosub $062C; // ROM                     ;3,3 $052C..$052E: 3F 06 2C
        stra,r1 $18DE        ;*($18DE) = r1; // CPU+UVI RAM           ;4,3 $052F..$0531: CD 18 DE
;$0532:
        stra,r0 $18DB        ;*($18DB) = r0; // CPU+UVI RAM           ;4,3 $0532..$0534: CC 18 DB
        loda,r3 $18DB        ;r3 = *($18DB); // CPU+UVI RAM           ;4,3 $0535..$0537: 0F 18 DB
        loda,r2 $18F5        ;r2 = SPRITE2X; // UVI register          ;4,3 $0538..$053A: 0E 18 F5
        loda,r1 $18F4        ;r1 = SPRITE2Y; // UVI register          ;4,3 $053B..$053D: 0D 18 F4
        bsta,un $068D        ;gosub $068D; // ROM                     ;3,3 $053E..$0540: 3F 06 8D
        stra,r2 $18F5        ;SPRITE2X = r2; // UVI register          ;4,3 $0541..$0543: CE 18 F5
        stra,r1 $18F4        ;SPRITE2Y = r1; // UVI register          ;4,3 $0544..$0546: CD 18 F4
;$0547:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0547..$0549: 0C 18 E8
        andi,r0 $04          ;r0 &= %00000100;                        ;2,2 $054A..$054B: 44 04
        bctr,eq $0576        ;if == goto $0576; // ROM                ;3,2 $054C..$054D: 18 28
        loda,r0 $18ED        ;r0 = *($18ED); // CPU+UVI RAM           ;4,3 $054E..$0550: 0C 18 ED
        bcfr,eq $055B        ;if != goto $055B; // ROM                ;3,2 $0551..$0552: 98 08
        loda,r0 $1A03        ;r0 = *($1A03); // lower screen or user RAM
                                                                      ;4,3 $0553..$0555: 0C 1A 03
        stra,r0 $18ED        ;*($18ED) = r0; // CPU+UVI RAM           ;4,3 $0556..$0558: CC 18 ED
        bctr,un $0576        ;goto $0576; // ROM                      ;3,2 $0559..$055A: 1B 1B
;
;$055B:
        subi,r0 $01          ;r0--;                                   ;2,2 $055B..$055C: A4 01
        stra,r0 $18ED        ;*($18ED) = r0; // CPU+UVI RAM           ;4,3 $055D..$055F: CC 18 ED
        bcfr,eq $0576        ;if != goto $0576; // ROM                ;3,2 $0560..$0561: 98 14
        loda,r0 $1A04        ;r0 = *($1A04); // lower screen or user RAM
                                                                      ;4,3 $0562..$0564: 0C 1A 04
        stra,r0 $18F3        ;SPRITE1X = r0; // UVI register          ;4,3 $0565..$0567: CC 18 F3
        loda,r0 $1A05        ;r0 = *($1A05); // lower screen or user RAM
                                                                      ;4,3 $0568..$056A: 0C 1A 05
        stra,r0 $18F2        ;SPRITE1Y = r0; // UVI register          ;4,3 $056B..$056D: CC 18 F2
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $056E..$0570: 0C 18 E8
        andi,r0 $FB          ;r0 &= %11111011;                        ;2,2 $0571..$0572: 44 FB
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $0573..$0575: CC 18 E8
;$0576:
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0576..$0578: 0C 18 E8
        andi,r0 $08          ;r0 &= %00001000;                        ;2,2 $0579..$057A: 44 08
        bctr,eq $05A5        ;if == goto $05A5; // ROM                ;3,2 $057B..$057C: 18 28
        loda,r0 $18EE        ;r0 = *($18EE); // CPU+UVI RAM           ;4,3 $057D..$057F: 0C 18 EE
        bcfr,eq $058A        ;if != goto $058A; // ROM                ;3,2 $0580..$0581: 98 08
        loda,r0 $1A03        ;r0 = *($1A03); // lower screen or user RAM
                                                                      ;4,3 $0582..$0584: 0C 1A 03
        stra,r0 $18EE        ;*($18EE) = r0; // CPU+UVI RAM           ;4,3 $0585..$0587: CC 18 EE
        bctr,un $05A5        ;goto $05A5; // ROM                      ;3,2 $0588..$0589: 1B 1B
;
;$058A:
        subi,r0 $01          ;r0--;                                   ;2,2 $058A..$058B: A4 01
        stra,r0 $18EE        ;*($18EE) = r0; // CPU+UVI RAM           ;4,3 $058C..$058E: CC 18 EE
        bcfr,eq $05A5        ;if != goto $05A5; // ROM                ;3,2 $058F..$0590: 98 14
        loda,r0 $1A04        ;r0 = *($1A04); // lower screen or user RAM
                                                                      ;4,3 $0591..$0593: 0C 1A 04
        stra,r0 $18F5        ;SPRITE2X = r0; // UVI register          ;4,3 $0594..$0596: CC 18 F5
        loda,r0 $1A05        ;r0 = *($1A05); // lower screen or user RAM
                                                                      ;4,3 $0597..$0599: 0C 1A 05
        stra,r0 $18F4        ;SPRITE2Y = r0; // UVI register          ;4,3 $059A..$059C: CC 18 F4
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $059D..$059F: 0C 18 E8
        andi,r0 $F7          ;r0 &= %11110111;                        ;2,2 $05A0..$05A1: 44 F7
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $05A2..$05A4: CC 18 E8
;$05A5:
        bcta,un $01E5        ;goto $01E5; // ROM                      ;3,3 $05A5..$05A7: 1F 01 E5
;
;$05A8:
        loda,r0 $1A0F        ;r0 = *($1A0F); // lower screen or user RAM
                                                                      ;4,3 $05A8..$05AA: 0C 1A 0F
        comi,r0 $F0          ;compare r0 against $F0;                 ;2,2 $05AB..$05AC: E4 F0
        bcta,eq $0604        ;if == goto $0604; // ROM                ;3,3 $05AD..$05AF: 1C 06 04
        comi,r0 $F1          ;compare r0 against $F1;                 ;2,2 $05B0..$05B1: E4 F1
        bcta,eq $05CB        ;if == goto $05CB; // ROM                ;3,3 $05B2..$05B4: 1C 05 CB
        comi,r0 $F2          ;compare r0 against $F2;                 ;2,2 $05B5..$05B6: E4 F2
        bcta,eq $05BB        ;if == goto $05BB; // ROM                ;3,3 $05B7..$05B9: 1C 05 BB
        retc,un              ;return;                                 ;3,1 $05BA:        17
;
;$05BB:
        lodi,r0 $60          ;r0 = $60;                               ;2,2 $05BB..$05BC: 04 60
        stra,r0 $18FD        ;PITCH = r0; // UVI register             ;4,3 $05BD..$05BF: CC 18 FD
        lodi,r0 $15          ;r0 = $15;                               ;2,2 $05C0..$05C1: 04 15
        stra,r0 $18FE        ;VOLUME = r0; // UVI register            ;4,3 $05C2..$05C4: CC 18 FE
        lodi,r0 $FE          ;r0 = $FE;                               ;2,2 $05C5..$05C6: 04 FE
        stra,r0 $1A0F        ;*($1A0F) = r0; // lower screen or user RAM
                                                                      ;4,3 $05C7..$05C9: CC 1A 0F
        retc,un              ;return;                                 ;3,1 $05CA:        17
;
;$05CB:
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $05CB..$05CC: 04 0F
        stra,r0 $18FE        ;VOLUME = r0; // UVI register            ;4,3 $05CD..$05CF: CC 18 FE
        loda,r2 $1A13        ;r2 = *($1A13); // lower screen or user RAM
                                                                      ;4,3 $05D0..$05D2: 0E 1A 13
        loda,r0 *$1A11,r2    ;r0 = *(*($1A11) + r2);                  ;6,3 $05D3..$05D5: 0E FA 11
        addi,r2 $01          ;r2++;                                   ;2,2 $05D6..$05D7: 86 01
        stra,r2 $1A13        ;*($1A13) = r2; // lower screen or user RAM
                                                                      ;4,3 $05D8..$05DA: CE 1A 13
        comi,r0 $FF          ;compare r0 against $FF;                 ;2,2 $05DB..$05DC: E4 FF
        bcta,eq $05F4        ;if == goto $05F4; // ROM                ;3,3 $05DD..$05DF: 1C 05 F4
        stra,r0 $18FD        ;PITCH = r0; // UVI register             ;4,3 $05E0..$05E2: CC 18 FD
        loda,r0 *$1A11,r2    ;r0 = *(*($1A11) + r2);                  ;6,3 $05E3..$05E5: 0E FA 11
        addi,r2 $01          ;r2++;                                   ;2,2 $05E6..$05E7: 86 01
        stra,r2 $1A13        ;*($1A13) = r2; // lower screen or user RAM
                                                                      ;4,3 $05E8..$05EA: CE 1A 13
        stra,r0 $1A10        ;*($1A10) = r0; // lower screen or user RAM
                                                                      ;4,3 $05EB..$05ED: CC 1A 10
        lodi,r0 $F0          ;r0 = $F0;                               ;2,2 $05EE..$05EF: 04 F0
        stra,r0 $1A0F        ;*($1A0F) = r0; // lower screen or user RAM
                                                                      ;4,3 $05F0..$05F2: CC 1A 0F
        retc,un              ;return;                                 ;3,1 $05F3:        17
;
;$05F4:
        eorz    r0           ;r0 = 0;                                 ;2,1 $05F4:        20
        stra,r0 $18FD        ;PITCH = r0; // UVI register             ;4,3 $05F5..$05F7: CC 18 FD
        stra,r0 $1A13        ;*($1A13) = r0; // lower screen or user RAM
                                                                      ;4,3 $05F8..$05FA: CC 1A 13
        loda,r0 *$1A11,r2    ;r0 = *(*($1A11) + r2);                  ;6,3 $05FB..$05FD: 0E FA 11
        stra,r0 $1A0F        ;*($1A0F) = r0; // lower screen or user RAM
                                                                      ;4,3 $05FE..$0600: CC 1A 0F
        lodi,r0 $FF          ;r0 = $FF;                               ;2,2 $0601..$0602: 04 FF
        retc,un              ;return;                                 ;3,1 $0603:        17
;
;$0604:
        loda,r0 $1A10        ;r0 = *($1A10); // lower screen or user RAM
                                                                      ;4,3 $0604..$0606: 0C 1A 10
        bctr,eq $0611        ;if == goto $0611; // ROM                ;3,2 $0607..$0608: 18 08
        subi,r0 $01          ;r0--;                                   ;2,2 $0609..$060A: A4 01
        bctr,eq $0611        ;if == goto $0611; // ROM                ;3,2 $060B..$060C: 18 04
        stra,r0 $1A10        ;*($1A10) = r0; // lower screen or user RAM
                                                                      ;4,3 $060D..$060F: CC 1A 10
        retc,un              ;return;                                 ;3,1 $0610:        17
;
;$0611:
        eorz    r0           ;r0 = 0;                                 ;2,1 $0611:        20
        stra,r0 $18FD        ;PITCH = r0; // UVI register             ;4,3 $0612..$0614: CC 18 FD
        lodi,r0 $F1          ;r0 = $F1;                               ;2,2 $0615..$0616: 04 F1
        stra,r0 $1A0F        ;*($1A0F) = r0; // lower screen or user RAM
                                                                      ;4,3 $0617..$0619: CC 1A 0F
        retc,un              ;return;                                 ;3,1 $061A:        17
;
;$061B:
        lodi,r0 $FF          ;r0 = $FF;                               ;2,2 $061B..$061C: 04 FF
        stra,r0 $18F7        ;SPRITE3X = r0; // UVI register          ;4,3 $061D..$061F: CC 18 F7
        stra,r0 $18F6        ;SPRITE3Y = r0; // UVI register          ;4,3 $0620..$0622: CC 18 F6
        loda,r0 $18E8        ;r0 = *($18E8); // CPU+UVI RAM           ;4,3 $0623..$0625: 0C 18 E8
        andi,r0 $EF          ;r0 &= %11101111;                        ;2,2 $0626..$0627: 44 EF
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $0628..$062A: CC 18 E8
        retc,un              ;return;                                 ;3,1 $062B:        17
;
;$062C:
        comi,r1 $00          ;compare r1 against $00;                 ;2,2 $062C..$062D: E5 00
        bctr,eq $063C        ;if == goto $063C; // ROM                ;3,2 $062E..$062F: 18 0C
        bsta,un $064E        ;gosub $064E; // ROM                     ;3,3 $0630..$0632: 3F 06 4E
        bcfr,eq $0648        ;if != goto $0648; // ROM                ;3,2 $0633..$0634: 98 13
        bsta,un $065A        ;gosub $065A; // ROM                     ;3,3 $0635..$0637: 3F 06 5A
        bctr,eq $0646        ;if == goto $0646; // ROM                ;3,2 $0638..$0639: 18 0C
        bctr,un $064B        ;goto $064B; // ROM                      ;3,2 $063A..$063B: 1B 0F
;
;$063C:
        bsta,un $065A        ;gosub $065A; // ROM                     ;3,3 $063C..$063E: 3F 06 5A
        bcfr,eq $064B        ;if != goto $064B; // ROM                ;3,2 $063F..$0640: 98 0A
        bsta,un $064E        ;gosub $064E; // ROM                     ;3,3 $0641..$0643: 3F 06 4E
        bcfr,eq $0648        ;if != goto $0648; // ROM                ;3,2 $0644..$0645: 98 02
;$0646:
        eorz    r0           ;r0 = 0;                                 ;2,1 $0646:        20
        retc,un              ;return;                                 ;3,1 $0647:        17
;
;$0648:
        lodi,r1 $00          ;r1 = $00;                               ;2,2 $0648..$0649: 05 00
        retc,un              ;return;                                 ;3,1 $064A:        17
;
;$064B:
        lodi,r1 $FF          ;r1 = $FF;                               ;2,2 $064B..$064C: 05 FF
        retc,un              ;return;                                 ;3,1 $064D:        17
;
;$064E:
        coma,r3 $18F1        ;compare r3 against SPRITE0X; // UVI register
                                                                      ;4,3 $064E..$0650: EF 18 F1
        retc,eq              ;if == return;                           ;3,1 $0651:        14
        bctr,gt $0657        ;if > goto $0657; // ROM                 ;3,2 $0652..$0653: 19 03
        lodi,r0 $02          ;r0 = $02;                               ;2,2 $0654..$0655: 04 02
        retc,un              ;return;                                 ;3,1 $0656:        17
;
;$0657:
        lodi,r0 $08          ;r0 = $08;                               ;2,2 $0657..$0658: 04 08
        retc,un              ;return;                                 ;3,1 $0659:        17
;
;$065A:
        coma,r2 $18F0        ;compare r2 against SPRITE0Y; // UVI register
                                                                      ;4,3 $065A..$065C: EE 18 F0
        retc,eq              ;if == return;                           ;3,1 $065D:        14
        bctr,gt $0663        ;if > goto $0663; // ROM                 ;3,2 $065E..$065F: 19 03
        lodi,r0 $01          ;r0 = $01;                               ;2,2 $0660..$0661: 04 01
        retc,un              ;return;                                 ;3,1 $0662:        17
;
;$0663:
        lodi,r0 $04          ;r0 = $04;                               ;2,2 $0663..$0664: 04 04
        retc,un              ;return;                                 ;3,1 $0665:        17
;
;$0666:
        coma,r3 $18F1        ;compare r3 against SPRITE0X; // UVI register
                                                                      ;4,3 $0666..$0668: EF 18 F1
        bcfr,eq $066F        ;if != goto $066F; // ROM                ;3,2 $0669..$066A: 98 04
        lodi,r0 $05          ;r0 = $05;                               ;2,2 $066B..$066C: 04 05
        bctr,un $067A        ;goto $067A; // ROM                      ;3,2 $066D..$066E: 1B 0B
;
;$066F:
        coma,r2 $18F0        ;compare r2 against SPRITE0Y; // UVI register
                                                                      ;4,3 $066F..$0671: EE 18 F0
        bcfr,eq $0678        ;if != goto $0678; // ROM                ;3,2 $0672..$0673: 98 04
        lodi,r0 $0A          ;r0 = $0A;                               ;2,2 $0674..$0675: 04 0A
        bctr,un $067A        ;goto $067A; // ROM                      ;3,2 $0676..$0677: 1B 02
;
;$0678:
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0678..$0679: 04 0F
;$067A:
        andz    r1           ;r0 &= r1;                               ;2,1 $067A:        41
        retc,un              ;return;                                 ;3,1 $067B:        17
;
;$067C:
        addi,r2 $08          ;r2 += $08;                              ;2,2 $067C..$067D: 86 08
        comi,r2 $20          ;compare r2 against $20;                 ;2,2 $067E..$067F: E6 20
        retc,lt              ;if < return;                            ;3,1 $0680:        16
        eorz    r0           ;r0 = 0;                                 ;2,1 $0681:        20
        strz    r2           ;r2 = r0;                                ;2,1 $0682:        C2
        retc,un              ;return;                                 ;3,1 $0683:        17
;
;$0684:
        tpsu    $80          ;test bits S....... of PSU;              ;3,2 $0684..$0685: B4 80
        bcfr,eq $0684        ;if != goto $0684; // ROM                ;3,2 $0686..$0687: 98 7C
;$0688:
        tpsu    $80          ;test bits S....... of PSU;              ;3,2 $0688..$0689: B4 80
        bctr,eq $0688        ;if == goto $0688; // ROM                ;3,2 $068A..$068B: 18 7C
        retc,un              ;return;                                 ;3,1 $068C:        17
;
;$068D:
        andi,r3 $0F          ;r3 &= %00001111;                        ;2,2 $068D..$068E: 47 0F
        retc,eq              ;if == return;                           ;3,1 $068F:        14
        stra,r2 $18D1        ;*($18D1) = r2; // CPU+UVI RAM           ;4,3 $0690..$0692: CE 18 D1
        stra,r1 $18D2        ;*($18D2) = r1; // CPU+UVI RAM           ;4,3 $0693..$0695: CD 18 D2
        lodi,r0 $01          ;r0 = $01;                               ;2,2 $0696..$0697: 04 01
        andz    r3           ;r0 &= r3;                               ;2,1 $0698:        43
        bctr,eq $069F        ;if == goto $069F; // ROM                ;3,2 $0699..$069A: 18 04
        addi,r1 $02          ;r1 += $02;                              ;2,2 $069B..$069C: 85 02
        bctr,un $06B3        ;goto $06B3; // ROM                      ;3,2 $069D..$069E: 1B 14
;
;$069F:
        bsta,un $06F9        ;gosub $06F9; // ROM                     ;3,3 $069F..$06A1: 3F 06 F9
        bctr,eq $06A8        ;if == goto $06A8; // ROM                ;3,2 $06A2..$06A3: 18 04
        addi,r2 $01          ;r2++;                                   ;2,2 $06A4..$06A5: 86 01
        bctr,un $06B3        ;goto $06B3; // ROM                      ;3,2 $06A6..$06A7: 1B 0B
;
;$06A8:
        bsta,un $06F9        ;gosub $06F9; // ROM                     ;3,3 $06A8..$06AA: 3F 06 F9
        bctr,eq $06B1        ;if == goto $06B1; // ROM                ;3,2 $06AB..$06AC: 18 04
        subi,r1 $02          ;r1 -= $02;                              ;2,2 $06AD..$06AE: A5 02
        bctr,un $06B3        ;goto $06B3; // ROM                      ;3,2 $06AF..$06B0: 1B 02
;
;$06B1:
        subi,r2 $01          ;r2--;                                   ;2,2 $06B1..$06B2: A6 01
;$06B3:
        bsta,un $06C8        ;gosub $06C8; // ROM                     ;3,3 $06B3..$06B5: 3F 06 C8
        comi,r3 $3D          ;compare r3 against $3D;                 ;2,2 $06B6..$06B7: E7 3D
        bctr,lt $06C1        ;if < goto $06C1; // ROM                 ;3,2 $06B8..$06B9: 1A 07
        loda,r2 $18D3        ;r2 = *($18D3); // CPU+UVI RAM           ;4,3 $06BA..$06BC: 0E 18 D3
        loda,r1 $18D4        ;r1 = *($18D4); // CPU+UVI RAM           ;4,3 $06BD..$06BF: 0D 18 D4
        retc,un              ;return;                                 ;3,1 $06C0:        17
;
;$06C1:
        loda,r2 $18D1        ;r2 = *($18D1); // CPU+UVI RAM           ;4,3 $06C1..$06C3: 0E 18 D1
        loda,r1 $18D2        ;r1 = *($18D2); // CPU+UVI RAM           ;4,3 $06C4..$06C6: 0D 18 D2
        retc,un              ;return;                                 ;3,1 $06C7:        17
;
;$06C8:
        stra,r2 $18D3        ;*($18D3) = r2; // CPU+UVI RAM           ;4,3 $06C8..$06CA: CE 18 D3
        stra,r1 $18D4        ;*($18D4) = r1; // CPU+UVI RAM           ;4,3 $06CB..$06CD: CD 18 D4
        eori,r1 $FF          ;r1 ^= %11111111;                        ;2,2 $06CE..$06CF: 25 FF
        addi,r1 $08          ;r1 += $08;                              ;2,2 $06D0..$06D1: 85 08
        subi,r1 $19          ;r1 -= $19;                              ;2,2 $06D2..$06D3: A5 19
        tpsl    $01          ;test bits .......C of PSL;              ;3,2 $06D4..$06D5: B5 01
        bctr,lt $06F6        ;if < goto $06F6; // ROM                 ;3,2 $06D6..$06D7: 1A 1E
        andi,r1 $F0          ;r1 &= %11110000;                        ;2,2 $06D8..$06D9: 45 F0
        addi,r2 $04          ;r2 += $04;                              ;2,2 $06DA..$06DB: 86 04
        subi,r2 $2B          ;r2 -= $2B;                              ;2,2 $06DC..$06DD: A6 2B
        tpsl    $01          ;test bits .......C of PSL;              ;3,2 $06DE..$06DF: B5 01
        bctr,lt $06F6        ;if < goto $06F6; // ROM                 ;3,2 $06E0..$06E1: 1A 14
        rrr,r2               ;r2 >>= 1;                               ;2,1 $06E2:        52
        rrr,r2               ;r2 >>= 1;                               ;2,1 $06E3:        52
        rrr,r2               ;r2 >>= 1;                               ;2,1 $06E4:        52
        andi,r2 $1F          ;r2 &= %00011111;                        ;2,2 $06E5..$06E6: 46 1F
        lodz    r1           ;r0 = r1;                                ;2,1 $06E7:        01
        addz    r2           ;r0 += r2;                               ;2,1 $06E8:        82
        strz    r3           ;r3 = r0;                                ;2,1 $06E9:        C3
        stra,r3 $18EB        ;*($18EB) = r3; // CPU+UVI RAM           ;4,3 $06EA..$06EC: CF 18 EB
        loda,r0 $1800,r3     ;r0 = *($1800 + r3);                     ;4,3 $06ED..$06EF: 0F 78 00
        bctr,eq $06F6        ;if == goto $06F6; // ROM                ;3,2 $06F0..$06F1: 18 04
        andi,r0 $3F          ;r0 &= %00111111;                        ;2,2 $06F2..$06F3: 44 3F
        strz    r3           ;r3 = r0;                                ;2,1 $06F4:        C3
        retc,un              ;return;                                 ;3,1 $06F5:        17
;
;$06F6:
        lodi,r3 $FF          ;r3 = $FF;                               ;2,2 $06F6..$06F7: 07 FF
        retc,un              ;return;                                 ;3,1 $06F8:        17
;
;$06F9:
        rrr,r3               ;r3 >>= 1;                               ;2,1 $06F9:        53
        andi,r3 $7F          ;r3 &= %01111111;                        ;2,2 $06FA..$06FB: 47 7F
        lodi,r0 $01          ;r0 = $01;                               ;2,2 $06FC..$06FD: 04 01
        andz    r3           ;r0 &= r3;                               ;2,1 $06FE:        43
        retc,un              ;return;                                 ;3,1 $06FF:        17
;
;$0700:
        tpsu    $80          ;test bits S....... of PSU;              ;3,2 $0700..$0701: B4 80
        bcfr,eq $0700        ;if != goto $0700; // ROM                ;3,2 $0702..$0703: 98 7C
        retc,un              ;return;                                 ;3,1 $0704:        17
;
;$0705:
        tpsu    $80          ;test bits S....... of PSU;              ;3,2 $0705..$0706: B4 80
        bctr,eq $0705        ;if == goto $0705; // ROM                ;3,2 $0707..$0708: 18 7C
        retc,un              ;return;                                 ;3,1 $0709:        17
;
;$070A:
        lodi,r1 $00          ;r1 = $00;                               ;2,2 $070A..$070B: 05 00
        andi,r3 $0F          ;r3 &= %00001111;                        ;2,2 $070C..$070D: 47 0F
        retc,eq              ;if == return;                           ;3,1 $070E:        14
;$070F:
        lodi,r0 $01          ;r0 = $01;                               ;2,2 $070F..$0710: 04 01
        andz    r3           ;r0 &= r3;                               ;2,1 $0711:        43
        bcfr,eq $071B        ;if != goto $071B; // ROM                ;3,2 $0712..$0713: 98 07
        addi,r1 $20          ;r1 += $20;                              ;2,2 $0714..$0715: 85 20
        bsta,un $06F9        ;gosub $06F9; // ROM                     ;3,3 $0716..$0718: 3F 06 F9
        bctr,un $070F        ;goto $070F; // ROM                      ;3,2 $0719..$071A: 1B 74
;
;$071B:
        lodz    r1           ;r0 = r1;                                ;2,1 $071B:        01
        addz    r2           ;r0 += r2;                               ;2,1 $071C:        82
        strz    r1           ;r1 = r0;                                ;2,1 $071D:        C1
        lodi,r3 $00          ;r3 = $00;                               ;2,2 $071E..$071F: 07 00
;$0720:
        loda,r0 *$18D1,r1    ;r0 = *(*($18D1) + r1);                  ;6,3 $0720..$0722: 0D F8 D1
        stra,r0 *$18D3,r3    ;*(*($18D3) + r3) = r0;                  ;6,3 $0723..$0725: CF F8 D3
        addi,r3 $01          ;r3++;                                   ;2,2 $0726..$0727: 87 01
        addi,r1 $01          ;r1++;                                   ;2,2 $0728..$0729: 85 01
        comi,r3 $08          ;compare r3 against $08;                 ;2,2 $072A..$072B: E7 08
        bcfr,eq $0720        ;if != goto $0720; // ROM                ;3,2 $072C..$072D: 98 72
        retc,un              ;return;                                 ;3,1 $072E:        17
;
;$072F:
        eorz    r0           ;r0 = 0;                                 ;2,1 $072F:        20
        strz    r3           ;r3 = r0;                                ;2,1 $0730:        C3
        lodi,r2 $10          ;r2 = $10;                               ;2,2 $0731..$0732: 06 10
;$0733:
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $0733..$0735: 0F F8 D1
        comi,r0 $F0          ;compare r0 against $F0;                 ;2,2 $0736..$0737: E4 F0
        retc,eq              ;if == return;                           ;3,1 $0738:        14
        comi,r0 $F1          ;compare r0 against $F1;                 ;2,2 $0739..$073A: E4 F1
        bcta,eq $0751        ;if == goto $0751; // ROM                ;3,3 $073B..$073D: 1C 07 51
        comi,r0 $F2          ;compare r0 against $F2;                 ;2,2 $073E..$073F: E4 F2
        bcta,eq $0768        ;if == goto $0768; // ROM                ;3,3 $0740..$0742: 1C 07 68
        comi,r0 $F3          ;compare r0 against $F3;                 ;2,2 $0743..$0744: E4 F3
        bcta,eq $0774        ;if == goto $0774; // ROM                ;3,3 $0745..$0747: 1C 07 74
        stra,r0 $1800,r2     ;*($1800 + r2) = r0;                     ;4,3 $0748..$074A: CE 78 00
        addi,r3 $01          ;r3++;                                   ;2,2 $074B..$074C: 87 01
        addi,r2 $01          ;r2++;                                   ;2,2 $074D..$074E: 86 01
        bctr,un $0733        ;goto $0733; // ROM                      ;3,2 $074F..$0750: 1B 62
;
;$0751:
        addi,r3 $01          ;r3++;                                   ;2,2 $0751..$0752: 87 01
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $0753..$0755: 0F F8 D1
        strz    r1           ;r1 = r0;                                ;2,1 $0756:        C1
        addi,r3 $01          ;r3++;                                   ;2,2 $0757..$0758: 87 01
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $0759..$075B: 0F F8 D1
;$075C:
        stra,r0 $1800,r2     ;*($1800 + r2) = r0;                     ;4,3 $075C..$075E: CE 78 00
        addi,r2 $01          ;r2++;                                   ;2,2 $075F..$0760: 86 01
        bdrr,r1 $075C        ;if (--r1 != 0) goto $075C; // ROM       ;3,2 $0761..$0762: F9 79
        addi,r3 $01          ;r3++;                                   ;2,2 $0763..$0764: 87 01
        bcta,un $0733        ;goto $0733; // ROM                      ;3,3 $0765..$0767: 1F 07 33
;
;$0768:
        addi,r3 $01          ;r3++;                                   ;2,2 $0768..$0769: 87 01
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $076A..$076C: 0F F8 D1
        addz    r2           ;r0 += r2;                               ;2,1 $076D:        82
        strz    r2           ;r2 = r0;                                ;2,1 $076E:        C2
        addi,r3 $01          ;r3++;                                   ;2,2 $076F..$0770: 87 01
        bcta,un $0733        ;goto $0733; // ROM                      ;3,3 $0771..$0773: 1F 07 33
;
;$0774:
        lodi,r0 $18          ;r0 = $18;                               ;2,2 $0774..$0775: 04 18
        stra,r0 $18D3        ;*($18D3) = r0; // CPU+UVI RAM           ;4,3 $0776..$0778: CC 18 D3
        stra,r0 $18D5        ;*($18D5) = r0; // CPU+UVI RAM           ;4,3 $0779..$077B: CC 18 D5
        addi,r3 $01          ;r3++;                                   ;2,2 $077C..$077D: 87 01
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $077E..$0780: 0F F8 D1
        stra,r0 $18D4        ;*($18D4) = r0; // CPU+UVI RAM           ;4,3 $0781..$0783: CC 18 D4
        addi,r3 $01          ;r3++;                                   ;2,2 $0784..$0785: 87 01
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $0786..$0788: 0F F8 D1
        stra,r0 $18D6        ;*($18D6) = r0; // CPU+UVI RAM           ;4,3 $0789..$078B: CC 18 D6
        addi,r3 $01          ;r3++;                                   ;2,2 $078C..$078D: 87 01
        loda,r0 *$18D1,r3    ;r0 = *(*($18D1) + r3);                  ;6,3 $078E..$0790: 0F F8 D1
        strz    r1           ;r1 = r0;                                ;2,1 $0791:        C1
;$0792:
        lodi,r2 $00          ;r2 = $00;                               ;2,2 $0792..$0793: 06 00
;$0794:
        loda,r0 *$18D3,r2    ;r0 = *(*($18D3) + r2);                  ;6,3 $0794..$0796: 0E F8 D3
        stra,r0 *$18D5,r2    ;*(*($18D5) + r2) = r0;                  ;6,3 $0797..$0799: CE F8 D5
        addi,r2 $01          ;r2++;                                   ;2,2 $079A..$079B: 86 01
        comi,r2 $10          ;compare r2 against $10;                 ;2,2 $079C..$079D: E6 10
        bcfr,eq $0794        ;if != goto $0794; // ROM                ;3,2 $079E..$079F: 98 74
        loda,r0 $18D6        ;r0 = *($18D6); // CPU+UVI RAM           ;4,3 $07A0..$07A2: 0C 18 D6
        addi,r0 $10          ;r0 += $10;                              ;2,2 $07A3..$07A4: 84 10
        stra,r0 $18D6        ;*($18D6) = r0; // CPU+UVI RAM           ;4,3 $07A5..$07A7: CC 18 D6
        bdrr,r1 $0792        ;if (--r1 != 0) goto $0792; // ROM       ;3,2 $07A8..$07A9: F9 68
        loda,r0 $18D6        ;r0 = *($18D6); // CPU+UVI RAM           ;4,3 $07AA..$07AC: 0C 18 D6
        subi,r0 $00          ;r0 -= $00;                              ;2,2 $07AD..$07AE: A4 00
        strz    r2           ;r2 = r0;                                ;2,1 $07AF:        C2
        addi,r3 $01          ;r3++;                                   ;2,2 $07B0..$07B1: 87 01
        bcta,un $0733        ;goto $0733; // ROM                      ;3,3 $07B2..$07B4: 1F 07 33
;
;$07B5:
        lodi,r0 $F1          ;r0 = $F1;                               ;2,2 $07B5..$07B6: 04 F1
        stra,r0 $1A0F        ;*($1A0F) = r0; // lower screen or user RAM
                                                                      ;4,3 $07B7..$07B9: CC 1A 0F
        eorz    r0           ;r0 = 0;                                 ;2,1 $07BA:        20
        stra,r0 $1A13        ;*($1A13) = r0; // lower screen or user RAM
                                                                      ;4,3 $07BB..$07BD: CC 1A 13
        retc,un              ;return;                                 ;3,1 $07BE:        17
;
;$07BF:
        lodi,r0 $D0          ;r0 = $D0;                               ;2,2 $07BF..$07C0: 04 D0
        stra,r0 $180B        ;*($180B) = r0; // upper screen          ;4,3 $07C1..$07C3: CC 18 0B
        stra,r0 $180C        ;*($180C) = r0; // upper screen          ;4,3 $07C4..$07C6: CC 18 0C
        loda,r0 $180A        ;r0 = *($180A); // upper screen          ;4,3 $07C7..$07C9: 0C 18 0A
        addz    r2           ;r0 += r2;                               ;2,1 $07CA:        82
        iori,r0 $D0          ;r0 |= %11010000;                        ;2,2 $07CB..$07CC: 64 D0
        stra,r0 $180A        ;*($180A) = r0; // upper screen          ;4,3 $07CD..$07CF: CC 18 0A
;$07D0:
        lodi,r1 $05          ;r1 = $05;                               ;2,2 $07D0..$07D1: 05 05
;$07D2:
        loda,r0 $1805,r1     ;r0 = *($1805 + r1);                     ;4,3 $07D2..$07D4: 0D 78 05
        strz    r2           ;r2 = r0;                                ;2,1 $07D5:        C2
        andi,r2 $0F          ;r2 &= %00001111;                        ;2,2 $07D6..$07D7: 46 0F
        comi,r2 $09          ;compare r2 against $09;                 ;2,2 $07D8..$07D9: E6 09
        bcfr,gt $07ED        ;if <= goto $07ED; // ROM                ;3,2 $07DA..$07DB: 99 11
        subi,r0 $0A          ;r0 -= $0A;                              ;2,2 $07DC..$07DD: A4 0A
        iori,r0 $D0          ;r0 |= %11010000;                        ;2,2 $07DE..$07DF: 64 D0
        stra,r0 $1805,r1     ;*($1805 + r1) = r0;                     ;4,3 $07E0..$07E2: CD 78 05
        loda,r0 $1804,r1     ;r0 = *($1804 + r1);                     ;4,3 $07E3..$07E5: 0D 78 04
        addi,r0 $01          ;r0++;                                   ;2,2 $07E6..$07E7: 84 01
        iori,r0 $D0          ;r0 |= %11010000;                        ;2,2 $07E8..$07E9: 64 D0
        stra,r0 $1804,r1     ;*($1804 + r1) = r0;                     ;4,3 $07EA..$07EC: CD 78 04
;$07ED:
        bdrr,r1 $07D2        ;if (--r1 != 0) goto $07D2; // ROM       ;3,2 $07ED..$07EE: F9 63
        lodi,r1 $00          ;r1 = $00;                               ;2,2 $07EF..$07F0: 05 00
;$07F1:
        loda,r0 $1806,r1     ;r0 = *($1806 + r1);                     ;4,3 $07F1..$07F3: 0D 78 06
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $07F4..$07F5: 44 0F
        bcfr,eq $0801        ;if != goto $0801; // ROM                ;3,2 $07F6..$07F7: 98 09
        stra,r0 $1806,r1     ;*($1806 + r1) = r0;                     ;4,3 $07F8..$07FA: CD 78 06
        addi,r1 $01          ;r1++;                                   ;2,2 $07FB..$07FC: 85 01
        comi,r1 $05          ;compare r1 against $05;                 ;2,2 $07FD..$07FE: E5 05
        bcfr,eq $07F1        ;if != goto $07F1; // ROM                ;3,2 $07FF..$0800: 98 70
;$0801:
        retc,un              ;return;                                 ;3,1 $0801:        17
;
;$0802:
        loda,r0 $1A06        ;r0 = *($1A06); // lower screen or user RAM
                                                                      ;4,3 $0802..$0804: 0C 1A 06
        addi,r0 $01          ;r0++;                                   ;2,2 $0805..$0806: 84 01
        stra,r0 $1A06        ;*($1A06) = r0; // lower screen or user RAM
                                                                      ;4,3 $0807..$0809: CC 1A 06
        retc,un              ;return;                                 ;3,1 $080A:        17
;
;$080B:
        lodi,r0 $0B          ;r0 = $0B;                               ;2,2 $080B..$080C: 04 0B
        stra,r0 $1A01        ;*($1A01) = r0; // lower screen or user RAM
                                                                      ;4,3 $080D..$080F: CC 1A 01
        lodi,r0 $18          ;r0 = $18;                               ;2,2 $0810..$0811: 04 18
        stra,r0 $1A02        ;*($1A02) = r0; // lower screen or user RAM
                                                                      ;4,3 $0812..$0814: CC 1A 02
;$0815:
        eorz    r0           ;r0 = 0;                                 ;2,1 $0815:        20
        stra,r0 $18D8        ;*($18D8) = r0; // CPU+UVI RAM           ;4,3 $0816..$0818: CC 18 D8
        stra,r0 $18DA        ;*($18DA) = r0; // CPU+UVI RAM           ;4,3 $0819..$081B: CC 18 DA
        stra,r0 $18DC        ;*($18DC) = r0; // CPU+UVI RAM           ;4,3 $081C..$081E: CC 18 DC
        stra,r0 $18D9        ;*($18D9) = r0; // CPU+UVI RAM           ;4,3 $081F..$0821: CC 18 D9
        stra,r0 $18DB        ;*($18DB) = r0; // CPU+UVI RAM           ;4,3 $0822..$0824: CC 18 DB
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $0825..$0827: CC 18 E8
        strz    r3           ;r3 = r0;                                ;2,1 $0828:        C3
        lodi,r2 $C0          ;r2 = $C0;                               ;2,2 $0829..$082A: 06 C0
;$082B:
        stra,r0 $180F,r2     ;*($180F + r2) = r0;                     ;4,3 $082B..$082D: CE 78 0F
        bdrr,r2 $082B        ;if (--r2 != 0) goto $082B; // ROM       ;3,2 $082E..$082F: FA 7B
        lodi,r0 $FF          ;r0 = $FF;                               ;2,2 $0830..$0831: 04 FF
        stra,r0 $18F6        ;SPRITE3Y = r0; // UVI register          ;4,3 $0832..$0834: CC 18 F6
        stra,r0 $18F7        ;SPRITE3X = r0; // UVI register          ;4,3 $0835..$0837: CC 18 F7
        lodi,r0 $32          ;r0 = $32;                               ;2,2 $0838..$0839: 04 32
        stra,r0 $18EF        ;*($18EF) = r0; // CPU+UVI RAM           ;4,3 $083A..$083C: CC 18 EF
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $083D..$083F: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $0840..$0842: 3F 07 00
;$0843:
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0843..$0845: 0F FA 01
        stra,r0 $19A0,r3     ;*($19A0 + r3) = r0;                     ;4,3 $0846..$0848: CF 79 A0
        stra,r0 $19A8,r3     ;*($19A8 + r3) = r0;                     ;4,3 $0849..$084B: CF 79 A8
        addi,r3 $01          ;r3++;                                   ;2,2 $084C..$084D: 87 01
        comi,r3 $08          ;compare r3 against $08;                 ;2,2 $084E..$084F: E7 08
        bcfr,eq $0843        ;if != goto $0843; // ROM                ;3,2 $0850..$0851: 98 71
;$0852:
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0852..$0854: 0F FA 01
        stra,r0 $19B0,r3     ;*($19B0 + r3) = r0;                     ;4,3 $0855..$0857: CF 79 B0
        addi,r3 $01          ;r3++;                                   ;2,2 $0858..$0859: 87 01
        comi,r3 $10          ;compare r3 against $10;                 ;2,2 $085A..$085B: E7 10
        bcfr,eq $0852        ;if != goto $0852; // ROM                ;3,2 $085C..$085D: 98 74
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $085E..$0860: 0F FA 01
        stra,r0 $18F3        ;SPRITE1X = r0; // UVI register          ;4,3 $0861..$0863: CC 18 F3
        addi,r3 $01          ;r3++;                                   ;2,2 $0864..$0865: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0866..$0868: 0F FA 01
        stra,r0 $18F2        ;SPRITE1Y = r0; // UVI register          ;4,3 $0869..$086B: CC 18 F2
        addi,r3 $01          ;r3++;                                   ;2,2 $086C..$086D: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $086E..$0870: 0F FA 01
        stra,r0 $18F5        ;SPRITE2X = r0; // UVI register          ;4,3 $0871..$0873: CC 18 F5
        addi,r3 $01          ;r3++;                                   ;2,2 $0874..$0875: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0876..$0878: 0F FA 01
        stra,r0 $18F4        ;SPRITE2Y = r0; // UVI register          ;4,3 $0879..$087B: CC 18 F4
        addi,r3 $01          ;r3++;                                   ;2,2 $087C..$087D: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $087E..$0880: 0F FA 01
        stra,r0 $1A03        ;*($1A03) = r0; // lower screen or user RAM
                                                                      ;4,3 $0881..$0883: CC 1A 03
        stra,r0 $18ED        ;*($18ED) = r0; // CPU+UVI RAM           ;4,3 $0884..$0886: CC 18 ED
        stra,r0 $18EE        ;*($18EE) = r0; // CPU+UVI RAM           ;4,3 $0887..$0889: CC 18 EE
        addi,r3 $01          ;r3++;                                   ;2,2 $088A..$088B: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $088C..$088E: 0F FA 01
        stra,r0 $18E2        ;*($18E2) = r0; // CPU+UVI RAM           ;4,3 $088F..$0891: CC 18 E2
        addi,r3 $01          ;r3++;                                   ;2,2 $0892..$0893: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0894..$0896: 0F FA 01
        stra,r0 $18E3        ;*($18E3) = r0; // CPU+UVI RAM           ;4,3 $0897..$0899: CC 18 E3
        addi,r3 $01          ;r3++;                                   ;2,2 $089A..$089B: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $089C..$089E: 0F FA 01
        stra,r0 $18DF        ;*($18DF) = r0; // CPU+UVI RAM           ;4,3 $089F..$08A1: CC 18 DF
        stra,r0 $18E6        ;*($18E6) = r0; // CPU+UVI RAM           ;4,3 $08A2..$08A4: CC 18 E6
        addi,r3 $01          ;r3++;                                   ;2,2 $08A5..$08A6: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08A7..$08A9: 0F FA 01
        stra,r0 $18E0        ;*($18E0) = r0; // CPU+UVI RAM           ;4,3 $08AA..$08AC: CC 18 E0
        stra,r0 $18E7        ;*($18E7) = r0; // CPU+UVI RAM           ;4,3 $08AD..$08AF: CC 18 E7
        addi,r3 $01          ;r3++;                                   ;2,2 $08B0..$08B1: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08B2..$08B4: 0F FA 01
        stra,r0 $18E1        ;*($18E1) = r0; // CPU+UVI RAM           ;4,3 $08B5..$08B7: CC 18 E1
        stra,r0 $18E4        ;*($18E4) = r0; // CPU+UVI RAM           ;4,3 $08B8..$08BA: CC 18 E4
        stra,r0 $18E5        ;*($18E5) = r0; // CPU+UVI RAM           ;4,3 $08BB..$08BD: CC 18 E5
        addi,r3 $01          ;r3++;                                   ;2,2 $08BE..$08BF: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08C0..$08C2: 0F FA 01
        stra,r0 $1A00        ;*($1A00) = r0; // lower screen or user RAM
                                                                      ;4,3 $08C3..$08C5: CC 1A 00
        addi,r3 $01          ;r3++;                                   ;2,2 $08C6..$08C7: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08C8..$08CA: 0F FA 01
        stra,r0 $18D1        ;*($18D1) = r0; // CPU+UVI RAM           ;4,3 $08CB..$08CD: CC 18 D1
        addi,r3 $01          ;r3++;                                   ;2,2 $08CE..$08CF: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08D0..$08D2: 0F FA 01
        stra,r0 $18D2        ;*($18D2) = r0; // CPU+UVI RAM           ;4,3 $08D3..$08D5: CC 18 D2
        addi,r3 $01          ;r3++;                                   ;2,2 $08D6..$08D7: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08D8..$08DA: 0F FA 01
        loda,r2 $1A0E        ;r2 = *($1A0E); // lower screen or user RAM
                                                                      ;4,3 $08DB..$08DD: 0E 1A 0E
        subz    r2           ;r0 -= r2;                               ;2,1 $08DE:        A2
        stra,r0 $180E        ;*($180E) = r0; // upper screen          ;4,3 $08DF..$08E1: CC 18 0E
        addi,r3 $01          ;r3++;                                   ;2,2 $08E2..$08E3: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08E4..$08E6: 0F FA 01
        stra,r0 $180F        ;*($180F) = r0; // upper screen          ;4,3 $08E7..$08E9: CC 18 0F
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $08EA..$08EC: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $08ED..$08EF: 3F 07 00
        addi,r3 $01          ;r3++;                                   ;2,2 $08F0..$08F1: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08F2..$08F4: 0F FA 01
        stra,r0 $19FB        ;SPRITES01CTRL = r0; // UVI register     ;4,3 $08F5..$08F7: CC 19 FB
        addi,r3 $01          ;r3++;                                   ;2,2 $08F8..$08F9: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $08FA..$08FC: 0F FA 01
        stra,r0 $19FA        ;SPRITES23CTRL = r0; // UVI register     ;4,3 $08FD..$08FF: CC 19 FA
        addi,r3 $01          ;r3++;                                   ;2,2 $0900..$0901: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0902..$0904: 0F FA 01
        stra,r0 $19F9        ;BGCOLOUR = r0; // UVI register          ;4,3 $0905..$0907: CC 19 F9
        stra,r0 $18D0        ;*($18D0) = r0; // CPU+UVI RAM           ;4,3 $0908..$090A: CC 18 D0
        addi,r3 $01          ;r3++;                                   ;2,2 $090B..$090C: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $090D..$090F: 0F FA 01
        stra,r0 $1A04        ;*($1A04) = r0; // lower screen or user RAM
                                                                      ;4,3 $0910..$0912: CC 1A 04
        addi,r3 $01          ;r3++;                                   ;2,2 $0913..$0914: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0915..$0917: 0F FA 01
        stra,r0 $1A05        ;*($1A05) = r0; // lower screen or user RAM
                                                                      ;4,3 $0918..$091A: CC 1A 05
        bsta,un $072F        ;gosub $072F; // ROM                     ;3,3 $091B..$091D: 3F 07 2F
        loda,r0 $1871        ;r0 = *($1871); // upper screen          ;4,3 $091E..$0920: 0C 18 71
        stra,r0 $18D5        ;*($18D5) = r0; // CPU+UVI RAM           ;4,3 $0921..$0923: CC 18 D5
        eorz    r0           ;r0 = 0;                                 ;2,1 $0924:        20
        stra,r0 $1871        ;*($1871) = r0; // upper screen          ;4,3 $0925..$0927: CC 18 71
        lodi,r0 $2B          ;r0 = $2B;                               ;2,2 $0928..$0929: 04 2B
        stra,r0 $18F1        ;SPRITE0X = r0; // UVI register          ;4,3 $092A..$092C: CC 18 F1
        lodi,r0 $76          ;r0 = $76;                               ;2,2 $092D..$092E: 04 76
        stra,r0 $18F0        ;SPRITE0Y = r0; // UVI register          ;4,3 $092F..$0931: CC 18 F0
        lodi,r0 $00          ;r0 = $00;                               ;2,2 $0932..$0933: 04 00
        stra,r0 $1A07        ;*($1A07) = r0; // lower screen or user RAM
                                                                      ;4,3 $0934..$0936: CC 1A 07
        lodi,r0 $3A          ;r0 = $3A;                               ;2,2 $0937..$0938: 04 3A
        stra,r0 $1A08        ;*($1A08) = r0; // lower screen or user RAM
                                                                      ;4,3 $0939..$093B: CC 1A 08
        lodi,r2 $04          ;r2 = $04;                               ;2,2 $093C..$093D: 06 04
;$093E:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $093E..$0940: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $0941..$0943: 3F 07 00
        lodi,r3 $00          ;r3 = $00;                               ;2,2 $0944..$0945: 07 00
;$0946:
        loda,r0 *$1A07,r3    ;r0 = *(*($1A07) + r3);                  ;6,3 $0946..$0948: 0F FA 07
        stra,r0 $1980,r3     ;*($1980 + r3) = r0;                     ;4,3 $0949..$094B: CF 79 80
        addi,r3 $01          ;r3++;                                   ;2,2 $094C..$094D: 87 01
        comi,r3 $08          ;compare r3 against $08;                 ;2,2 $094E..$094F: E7 08
        bcfr,eq $0946        ;if != goto $0946; // ROM                ;3,2 $0950..$0951: 98 74
        loda,r0 $18F1        ;r0 = SPRITE0X; // UVI register          ;4,3 $0952..$0954: 0C 18 F1
        addi,r0 $03          ;r0 += $03;                              ;2,2 $0955..$0956: 84 03
        stra,r0 $18F1        ;SPRITE0X = r0; // UVI register          ;4,3 $0957..$0959: CC 18 F1
        lodi,r3 $06          ;r3 = $06;                               ;2,2 $095A..$095B: 07 06
        bsta,un $0983        ;gosub $0983; // ROM                     ;3,3 $095C..$095E: 3F 09 83
        loda,r0 $1A08        ;r0 = *($1A08); // lower screen or user RAM
                                                                      ;4,3 $095F..$0961: 0C 1A 08
        addi,r0 $08          ;r0 += $08;                              ;2,2 $0962..$0963: 84 08
        stra,r0 $1A08        ;*($1A08) = r0; // lower screen or user RAM
                                                                      ;4,3 $0964..$0966: CC 1A 08
        bdrr,r2 $093E        ;if (--r2 != 0) goto $093E; // ROM       ;3,2 $0967..$0968: FA 55
        loda,r0 $18D5        ;r0 = *($18D5); // CPU+UVI RAM           ;4,3 $0969..$096B: 0C 18 D5
        stra,r0 $1871        ;*($1871) = r0; // upper screen          ;4,3 $096C..$096E: CC 18 71
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $096F..$0971: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0972..$0973: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $0974..$0976: CC 1A 11
        lodi,r0 $72          ;r0 = $72;                               ;2,2 $0977..$0978: 04 72
        addi,r0 $0C          ;r0 += $0C;                              ;2,2 $0979..$097A: 84 0C
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $097B..$097D: CC 1A 12
        bcta,un $01E5        ;goto $01E5; // ROM                      ;3,3 $097E..$0980: 1F 01 E5
;
;$0981:
        lodi,r3 $0F          ;r3 = $0F;                               ;2,2 $0981..$0982: 07 0F
;$0983:
        bsta,un $0684        ;gosub $0684; // ROM                     ;3,3 $0983..$0985: 3F 06 84
        bsta,un $05A8        ;gosub $05A8; // ROM                     ;3,3 $0986..$0988: 3F 05 A8
        bdrr,r3 $0983        ;if (--r3 != 0) goto $0983; // ROM       ;3,2 $0989..$098A: FB 78
        retc,un              ;return;                                 ;3,1 $098B:        17
;
;$098C:
        bsta,un $0684        ;gosub $0684; // ROM                     ;3,3 $098C..$098E: 3F 06 84
        bdrr,r3 $098C        ;if (--r3 != 0) goto $098C; // ROM       ;3,2 $098F..$0990: FB 7B
        retc,un              ;return;                                 ;3,1 $0991:        17
;
;$0992:
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0992..$0994: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0995..$0996: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $0997..$0999: CC 1A 11
        lodi,r0 $72          ;r0 = $72;                               ;2,2 $099A..$099B: 04 72
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $099C..$099E: CC 1A 12
        eorz    r0           ;r0 = 0;                                 ;2,1 $099F:        20
        loda,r1 $18EB        ;r1 = *($18EB); // CPU+UVI RAM           ;4,3 $09A0..$09A2: 0D 18 EB
        stra,r0 $1800,r1     ;*($1800 + r1) = r0;                     ;4,3 $09A3..$09A5: CD 78 00
        lodi,r0 $01          ;r0 = $01;                               ;2,2 $09A6..$09A7: 04 01
        loda,r1 $1809        ;r1 = *($1809); // upper screen          ;4,3 $09A8..$09AA: 0D 18 09
        addz    r1           ;r0 += r1;                               ;2,1 $09AB:        81
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $09AC..$09AD: 44 0F
        iori,r0 $D0          ;r0 |= %11010000;                        ;2,2 $09AE..$09AF: 64 D0
        stra,r0 $1809        ;*($1809) = r0; // upper screen          ;4,3 $09B0..$09B2: CC 18 09
        loda,r0 $1A00        ;r0 = *($1A00); // lower screen or user RAM
                                                                      ;4,3 $09B3..$09B5: 0C 1A 00
        andi,r0 $02          ;r0 &= %00000010;                        ;2,2 $09B6..$09B7: 44 02
        bctr,eq $09C5        ;if == goto $09C5; // ROM                ;3,2 $09B8..$09B9: 18 0B
        loda,r0 $1A00        ;r0 = *($1A00); // lower screen or user RAM
                                                                      ;4,3 $09BA..$09BC: 0C 1A 00
        andi,r0 $FD          ;r0 &= %11111101;                        ;2,2 $09BD..$09BE: 44 FD
        stra,r0 $1A00        ;*($1A00) = r0; // lower screen or user RAM
                                                                      ;4,3 $09BF..$09C1: CC 1A 00
        bcta,un $01E5        ;goto $01E5; // ROM                      ;3,3 $09C2..$09C4: 1F 01 E5
;
;$09C5:
        eorz    r0           ;r0 = 0;                                 ;2,1 $09C5:        20
        stra,r0 $1871        ;*($1871) = r0; // upper screen          ;4,3 $09C6..$09C8: CC 18 71
        lodi,r0 $3F          ;r0 = $3F;                               ;2,2 $09C9..$09CA: 04 3F
        stra,r0 $1A04        ;*($1A04) = r0; // lower screen or user RAM
                                                                      ;4,3 $09CB..$09CD: CC 1A 04
        lodi,r0 $76          ;r0 = $76;                               ;2,2 $09CE..$09CF: 04 76
        stra,r0 $1A05        ;*($1A05) = r0; // lower screen or user RAM
                                                                      ;4,3 $09D0..$09D2: CC 1A 05
        bcta,un $01E5        ;goto $01E5; // ROM                      ;3,3 $09D3..$09D5: 1F 01 E5
;
;$09D6:
        bsta,un $061B        ;gosub $061B; // ROM                     ;3,3 $09D6..$09D8: 3F 06 1B
        lodi,r0 $00          ;r0 = $00;                               ;2,2 $09D9..$09DA: 04 00
        stra,r0 $18FD        ;PITCH = r0; // UVI register             ;4,3 $09DB..$09DD: CC 18 FD
        lodi,r0 $00          ;r0 = $00;                               ;2,2 $09DE..$09DF: 04 00
        stra,r0 $1A07        ;*($1A07) = r0; // lower screen or user RAM
                                                                      ;4,3 $09E0..$09E2: CC 1A 07
        lodi,r0 $7A          ;r0 = $7A;                               ;2,2 $09E3..$09E4: 04 7A
        stra,r0 $1A08        ;*($1A08) = r0; // lower screen or user RAM
                                                                      ;4,3 $09E5..$09E7: CC 1A 08
        lodi,r2 $04          ;r2 = $04;                               ;2,2 $09E8..$09E9: 06 04
;$09EA:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $09EA..$09EC: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $09ED..$09EF: 3F 07 00
        lodi,r3 $00          ;r3 = $00;                               ;2,2 $09F0..$09F1: 07 00
;$09F2:
        loda,r0 *$1A07,r3    ;r0 = *(*($1A07) + r3);                  ;6,3 $09F2..$09F4: 0F FA 07
        stra,r0 $1980,r3     ;*($1980 + r3) = r0;                     ;4,3 $09F5..$09F7: CF 79 80
        addi,r3 $01          ;r3++;                                   ;2,2 $09F8..$09F9: 87 01
        comi,r3 $08          ;compare r3 against $08;                 ;2,2 $09FA..$09FB: E7 08
        bcfr,eq $09F2        ;if != goto $09F2; // ROM                ;3,2 $09FC..$09FD: 98 74
        loda,r0 $18F1        ;r0 = SPRITE0X; // UVI register          ;4,3 $09FE..$0A00: 0C 18 F1
        subi,r0 $01          ;r0--;                                   ;2,2 $0A01..$0A02: A4 01
        stra,r0 $18F1        ;SPRITE0X = r0; // UVI register          ;4,3 $0A03..$0A05: CC 18 F1
        lodi,r3 $04          ;r3 = $04;                               ;2,2 $0A06..$0A07: 07 04
        bsta,un $098C        ;gosub $098C; // ROM                     ;3,3 $0A08..$0A0A: 3F 09 8C
        loda,r0 $1A08        ;r0 = *($1A08); // lower screen or user RAM
                                                                      ;4,3 $0A0B..$0A0D: 0C 1A 08
        addi,r0 $08          ;r0 += $08;                              ;2,2 $0A0E..$0A0F: 84 08
        stra,r0 $1A08        ;*($1A08) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A10..$0A12: CC 1A 08
        bdrr,r2 $09EA        ;if (--r2 != 0) goto $09EA; // ROM       ;3,2 $0A13..$0A14: FA 55
        loda,r0 $1A0A        ;r0 = *($1A0A); // lower screen or user RAM
                                                                      ;4,3 $0A15..$0A17: 0C 1A 0A
        addi,r0 $01          ;r0++;                                   ;2,2 $0A18..$0A19: 84 01
        comi,r0 $05          ;compare r0 against $05;                 ;2,2 $0A1A..$0A1B: E4 05
        bcfr,eq $0A2D        ;if != goto $0A2D; // ROM                ;3,2 $0A1C..$0A1D: 98 0F
        eorz    r0           ;r0 = 0;                                 ;2,1 $0A1E:        20
        loda,r1 $1A09        ;r1 = *($1A09); // lower screen or user RAM
                                                                      ;4,3 $0A1F..$0A21: 0D 1A 09
        subi,r1 $10          ;r1 -= $10;                              ;2,2 $0A22..$0A23: A5 10
        comi,r1 $10          ;compare r1 against $10;                 ;2,2 $0A24..$0A25: E5 10
        bctr,gt $0A2A        ;if > goto $0A2A; // ROM                 ;3,2 $0A26..$0A27: 19 02
        lodi,r1 $10          ;r1 = $10;                               ;2,2 $0A28..$0A29: 05 10
;$0A2A:
        stra,r1 $1A09        ;*($1A09) = r1; // lower screen or user RAM
                                                                      ;4,3 $0A2A..$0A2C: CD 1A 09
;$0A2D:
        stra,r0 $1A0A        ;*($1A0A) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A2D..$0A2F: CC 1A 0A
        loda,r0 $180F        ;r0 = *($180F); // upper screen          ;4,3 $0A30..$0A32: 0C 18 0F
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0A33..$0A34: 44 0F
        loda,r1 $1809        ;r1 = *($1809); // upper screen          ;4,3 $0A35..$0A37: 0D 18 09
        addz    r1           ;r0 += r1;                               ;2,1 $0A38:        81
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0A39..$0A3A: 44 0F
        iori,r0 $D0          ;r0 |= %11010000;                        ;2,2 $0A3B..$0A3C: 64 D0
        stra,r0 $1809        ;*($1809) = r0; // upper screen          ;4,3 $0A3D..$0A3F: CC 18 09
        loda,r0 $180E        ;r0 = *($180E); // upper screen          ;4,3 $0A40..$0A42: 0C 18 0E
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0A43..$0A44: 44 0F
        loda,r1 $1808        ;r1 = *($1808); // upper screen          ;4,3 $0A45..$0A47: 0D 18 08
        addz    r1           ;r0 += r1;                               ;2,1 $0A48:        81
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0A49..$0A4A: 44 0F
        iori,r0 $D0          ;r0 |= %11010000;                        ;2,2 $0A4B..$0A4C: 64 D0
        stra,r0 $1808        ;*($1808) = r0; // upper screen          ;4,3 $0A4D..$0A4F: CC 18 08
        bsta,un $07D0        ;gosub $07D0; // ROM                     ;3,3 $0A50..$0A52: 3F 07 D0
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0A53..$0A55: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0A56..$0A57: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A58..$0A5A: CC 1A 11
        lodi,r0 $C3          ;r0 = $C3;                               ;2,2 $0A5B..$0A5C: 04 C3
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A5D..$0A5F: CC 1A 12
;$0A60:
        bsta,un $0684        ;gosub $0684; // ROM                     ;3,3 $0A60..$0A62: 3F 06 84
        bsta,un $05A8        ;gosub $05A8; // ROM                     ;3,3 $0A63..$0A65: 3F 05 A8
        comi,r0 $FF          ;compare r0 against $FF;                 ;2,2 $0A66..$0A67: E4 FF
        bcfr,eq $0A60        ;if != goto $0A60; // ROM                ;3,2 $0A68..$0A69: 98 76
        lodi,r3 $24          ;r3 = $24;                               ;2,2 $0A6A..$0A6B: 07 24
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0A6C..$0A6E: 0F FA 01
        strz    r2           ;r2 = r0;                                ;2,1 $0A6F:        C2
        addi,r3 $01          ;r3++;                                   ;2,2 $0A70..$0A71: 87 01
        loda,r0 *$1A01,r3    ;r0 = *(*($1A01) + r3);                  ;6,3 $0A72..$0A74: 0F FA 01
        stra,r0 $1A02        ;*($1A02) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A75..$0A77: CC 1A 02
        stra,r2 $1A01        ;*($1A01) = r2; // lower screen or user RAM
                                                                      ;4,3 $0A78..$0A7A: CE 1A 01
        lodi,r2 $03          ;r2 = $03;                               ;2,2 $0A7B..$0A7C: 06 03
        bsta,un $07BF        ;gosub $07BF; // ROM                     ;3,3 $0A7D..$0A7F: 3F 07 BF
        loda,r0 $1800        ;r0 = *($1800); // upper screen          ;4,3 $0A80..$0A82: 0C 18 00
        addi,r0 $01          ;r0++;                                   ;2,2 $0A83..$0A84: 84 01
        comi,r0 $9F          ;compare r0 against $9F;                 ;2,2 $0A85..$0A86: E4 9F
        bcfr,eq $0A8B        ;if != goto $0A8B; // ROM                ;3,2 $0A87..$0A88: 98 02
        lodi,r0 $9A          ;r0 = $9A;                               ;2,2 $0A89..$0A8A: 04 9A
;$0A8B:
        stra,r0 $1800        ;*($1800) = r0; // upper screen          ;4,3 $0A8B..$0A8D: CC 18 00
        bcta,un $0815        ;goto $0815; // ROM                      ;3,3 $0A8E..$0A90: 1F 08 15
;
;$0A91:
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0A91..$0A93: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0A94..$0A95: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A96..$0A98: CC 1A 11
        lodi,r0 $8C          ;r0 = $8C;                               ;2,2 $0A99..$0A9A: 04 8C
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $0A9B..$0A9D: CC 1A 12
        bsta,un $061B        ;gosub $061B; // ROM                     ;3,3 $0A9E..$0AA0: 3F 06 1B
        lodi,r1 $08          ;r1 = $08;                               ;2,2 $0AA1..$0AA2: 05 08
;$0AA3:
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $0AA3..$0AA5: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $0AA6..$0AA8: 3F 07 00
        eorz    r0           ;r0 = 0;                                 ;2,1 $0AA9:        20
        stra,r0 $197F,r1     ;*($197F + r1) = r0;                     ;4,3 $0AAA..$0AAC: CD 79 7F
        bsta,un $0981        ;gosub $0981; // ROM                     ;3,3 $0AAD..$0AAF: 3F 09 81
        bdrr,r1 $0AA3        ;if (--r1 != 0) goto $0AA3; // ROM       ;3,2 $0AB0..$0AB1: F9 71
        eorz    r0           ;r0 = 0;                                 ;2,1 $0AB2:        20
        stra,r0 $18E8        ;*($18E8) = r0; // CPU+UVI RAM           ;4,3 $0AB3..$0AB5: CC 18 E8
        loda,r0 $1802        ;r0 = *($1802); // upper screen          ;4,3 $0AB6..$0AB8: 0C 18 02
        strz    r1           ;r1 = r0;                                ;2,1 $0AB9:        C1
        andi,r1 $0F          ;r1 &= %00001111;                        ;2,2 $0ABA..$0ABB: 45 0F
        subi,r1 $01          ;r1--;                                   ;2,2 $0ABC..$0ABD: A5 01
        comi,r1 $FF          ;compare r1 against $FF;                 ;2,2 $0ABE..$0ABF: E5 FF
        bctr,eq $0ACA        ;if == goto $0ACA; // ROM                ;3,2 $0AC0..$0AC1: 18 08
        subi,r0 $01          ;r0--;                                   ;2,2 $0AC2..$0AC3: A4 01
        stra,r0 $1802        ;*($1802) = r0; // upper screen          ;4,3 $0AC4..$0AC6: CC 18 02
        bcta,un $0815        ;goto $0815; // ROM                      ;3,3 $0AC7..$0AC9: 1F 08 15
;
;$0ACA:
        lodi,r3 $10          ;r3 = $10;                               ;2,2 $0ACA..$0ACB: 07 10
;$0ACC:
        loda,r0 $0B07,r3     ;r0 = *($0B07 + r3);                     ;4,3 $0ACC..$0ACE: 0F 6B 07
        stra,r0 $185F,r3     ;*($185F + r3) = r0;                     ;4,3 $0ACF..$0AD1: CF 78 5F
        bdrr,r3 $0ACC        ;if (--r3 != 0) goto $0ACC; // ROM       ;3,2 $0AD2..$0AD3: FB 78
        bsta,un $0705        ;gosub $0705; // ROM                     ;3,3 $0AD4..$0AD6: 3F 07 05
        bsta,un $0700        ;gosub $0700; // ROM                     ;3,3 $0AD7..$0AD9: 3F 07 00
        lodi,r0 $08          ;r0 = $08;                               ;2,2 $0ADA..$0ADB: 04 08
        stra,r0 $19F9        ;BGCOLOUR = r0; // UVI register          ;4,3 $0ADC..$0ADE: CC 19 F9
        bsta,un $07B5        ;gosub $07B5; // ROM                     ;3,3 $0ADF..$0AE1: 3F 07 B5
        lodi,r0 $0F          ;r0 = $0F;                               ;2,2 $0AE2..$0AE3: 04 0F
        stra,r0 $1A11        ;*($1A11) = r0; // lower screen or user RAM
                                                                      ;4,3 $0AE4..$0AE6: CC 1A 11
        lodi,r0 $A1          ;r0 = $A1;                               ;2,2 $0AE7..$0AE8: 04 A1
        stra,r0 $1A12        ;*($1A12) = r0; // lower screen or user RAM
                                                                      ;4,3 $0AE9..$0AEB: CC 1A 12
;$0AEC:
        bsta,un $0684        ;gosub $0684; // ROM                     ;3,3 $0AEC..$0AEE: 3F 06 84
        bsta,un $05A8        ;gosub $05A8; // ROM                     ;3,3 $0AEF..$0AF1: 3F 05 A8
        comi,r0 $FF          ;compare r0 against $FF;                 ;2,2 $0AF2..$0AF3: E4 FF
        bcfr,eq $0AEC        ;if != goto $0AEC; // ROM                ;3,2 $0AF4..$0AF5: 98 76
        loda,r0 $1A0C        ;r0 = *($1A0C); // lower screen or user RAM
                                                                      ;4,3 $0AF6..$0AF8: 0C 1A 0C
        bcfa,eq $0110        ;if != goto $0110; // ROM                ;3,3 $0AF9..$0AFB: 9C 01 10
;$0AFC:
        loda,r0 $1908        ;r0 = CONSOLE; // UVI register           ;4,3 $0AFC..$0AFE: 0C 19 08
        andi,r0 $0F          ;r0 &= %00001111;                        ;2,2 $0AFF..$0B00: 44 0F
        comi,r0 $01          ;compare r0 against $01;                 ;2,2 $0B01..$0B02: E4 01
        bcta,eq $01B5        ;if == goto $01B5; // ROM                ;3,3 $0B03..$0B05: 1C 01 B5
        bctr,un $0AFC        ;goto $0AFC; // ROM                      ;3,2 $0B06..$0B07: 1B 74
;
        db      $00, $C3, $C3, $C3                                    ;0,4 $0B08..$0B0B: 00 C3 C3 C3
        db      $E0, $DA, $E6, $DE                                    ;0,4 $0B0C..$0B0F: E0 DA E6 DE
        db      $00, $E8, $EF, $DE                                    ;0,4 $0B10..$0B13: 00 E8 EF DE
        db      $EB, $C3, $C3, $C3                                    ;0,4 $0B14..$0B17: EB C3 C3 C3
        db      $08, $1C, $2A, $77                                    ;0,4 $0B18..$0B1B: 08 1C 2A 77
        db      $2A, $08, $08, $3E                                    ;0,4 $0B1C..$0B1F: 2A 08 08 3E
        db      $10, $38, $6C, $DE                                    ;0,4 $0B20..$0B23: 10 38 6C DE
        db      $DE, $5C, $38, $10                                    ;0,4 $0B24..$0B27: DE 5C 38 10
        db      $83, $96, $63, $36                                    ;0,4 $0B28..$0B2B: 83 96 63 36
        db      $D0, $00, $1A, $03                                    ;0,4 $0B2C..$0B2F: D0 00 1A 03
        db      $02, $08, $00, $00                                    ;0,4 $0B30..$0B33: 02 08 00 00
        db      $A2, $55, $50, $3E                                    ;0,4 $0B34..$0B37: A2 55 50 3E
        db      $1A, $00, $73, $76                                    ;0,4 $0B38..$0B3B: 1A 00 73 76
        db      $0B, $3E, $10, $38                                    ;0,4 $0B3C..$0B3F: 0B 3E 10 38
        db      $7C, $FE, $FE, $54                                    ;0,4 $0B40..$0B43: 7C FE FE 54
        db      $10, $38, $30, $10                                    ;0,4 $0B44..$0B47: 10 38 30 10
        db      $A6, $FF, $DF, $DF                                    ;0,4 $0B48..$0B4B: A6 FF DF DF
        db      $6E, $3C, $6B, $B6                                    ;0,4 $0B4C..$0B4F: 6E 3C 6B B6
        db      $73, $36, $D0, $0B                                    ;0,4 $0B50..$0B53: 73 36 D0 0B
        db      $64, $03, $02, $08                                    ;0,4 $0B54..$0B57: 64 03 02 08
        db      $00, $0B, $E4, $55                                    ;0,4 $0B58..$0B5B: 00 0B E4 55
        db      $50, $3C, $32, $08                                    ;0,4 $0B5C..$0B5F: 50 3C 32 08
        db      $83, $76, $0E, $95                                    ;0,4 $0B60..$0B63: 83 76 0E 95
        db      $3C, $98, $5A, $BD                                    ;0,4 $0B64..$0B67: 3C 98 5A BD
        db      $76, $A5, $5A, $01                                    ;0,4 $0B68..$0B6B: 76 A5 5A 01
        db      $24, $98, $5B, $B4                                    ;0,4 $0B6C..$0B6F: 24 98 5B B4
        db      $76, $35, $DA, $19                                    ;0,4 $0B70..$0B73: 76 35 DA 19
        db      $18, $99, $5A, $24                                    ;0,4 $0B74..$0B77: 18 99 5A 24
        db      $EF, $3C, $DA, $09                                    ;0,4 $0B78..$0B7B: EF 3C DA 09
        db      $3C, $99, $5A, $2D                                    ;0,4 $0B7C..$0B7F: 3C 99 5A 2D
        db      $6E, $BC, $5C, $81                                    ;0,4 $0B80..$0B83: 6E BC 5C 81
        db      $2A, $54, $39, $5F                                    ;0,4 $0B84..$0B87: 2A 54 39 5F
        db      $4F, $39, $54, $A8                                    ;0,4 $0B88..$0B8B: 4F 39 54 A8
        db      $4A, $54, $39, $FE                                    ;0,4 $0B8C..$0B8F: 4A 54 39 FE
        db      $C6, $39, $54, $A4                                    ;0,4 $0B90..$0B93: C6 39 54 A4
        db      $52, $54, $38, $67                                    ;0,4 $0B94..$0B97: 52 54 38 67
        db      $F7, $38, $54, $92                                    ;0,4 $0B98..$0B9B: F7 38 54 92
        db      $A2, $54, $39, $67                                    ;0,4 $0B9C..$0B9F: A2 54 39 67
        db      $7F, $39, $54, $8A                                    ;0,4 $0BA0..$0BA3: 7F 39 54 8A
        db      $81, $5A, $3D, $76                                    ;0,4 $0BA4..$0BA7: 81 5A 3D 76
        db      $B4, $5A, $99, $3C                                    ;0,4 $0BA8..$0BAB: B4 5A 99 3C
        db      $90, $5B, $3C, $F7                                    ;0,4 $0BAC..$0BAF: 90 5B 3C F7
        db      $24, $5A, $99, $18                                    ;0,4 $0BB0..$0BB3: 24 5A 99 18
        db      $98, $5B, $AC, $6E                                    ;0,4 $0BB4..$0BB7: 98 5B AC 6E
        db      $2D, $DA, $19, $24                                    ;0,4 $0BB8..$0BBB: 2D DA 19 24
        db      $80, $5A, $A5, $6E                                    ;0,4 $0BBC..$0BBF: 80 5A A5 6E
        db      $BD, $5A, $19, $3C                                    ;0,4 $0BC0..$0BC3: BD 5A 19 3C
        db      $15, $2A, $9C, $F2                                    ;0,4 $0BC4..$0BC7: 15 2A 9C F2
        db      $FA, $9C, $2A, $54                                    ;0,4 $0BC8..$0BCB: FA 9C 2A 54
        db      $25, $2A, $9C, $F2                                    ;0,4 $0BCC..$0BCF: 25 2A 9C F2
        db      $7F, $9C, $2A, $52                                    ;0,4 $0BD0..$0BD3: 7F 9C 2A 52
        db      $49, $2A, $7C, $EF                                    ;0,4 $0BD4..$0BD7: 49 2A 7C EF
        db      $E6, $1C, $2A, $4A                                    ;0,4 $0BD8..$0BDB: E6 1C 2A 4A
        db      $51, $2A, $9C, $FE                                    ;0,4 $0BDC..$0BDF: 51 2A 9C FE
        db      $E6, $9C, $2A, $45                                    ;0,4 $0BE0..$0BE3: E6 9C 2A 45
        db      $F2, $10, $F2, $04                                    ;0,4 $0BE4..$0BE7: F2 10 F2 04
        db      $01, $F1, $0A, $04                                    ;0,4 $0BE8..$0BEB: 01 F1 0A 04
        db      $08, $F2, $03, $01                                    ;0,4 $0BEC..$0BEF: 08 F2 03 01
        db      $F2, $03, $7C, $F2                                    ;0,4 $0BF0..$0BF3: F2 03 7C F2
        db      $06, $7C, $05, $F2                                    ;0,4 $0BF4..$0BF7: 06 7C 05 F2
        db      $02, $01, $F2, $0C                                    ;0,4 $0BF8..$0BFB: 02 01 F2 0C
        db      $05, $00, $01, $F2                                    ;0,4 $0BFC..$0BFF: 05 00 01 F2
        db      $08, $7C, $F2, $04                                    ;0,4 $0C00..$0C03: 08 7C F2 04
        db      $05, $00, $07, $F2                                    ;0,4 $0C04..$0C07: 05 00 07 F2
        db      $03, $7C, $F2, $06                                    ;0,4 $0C08..$0C0B: 03 7C F2 06
        db      $03, $FE, $FE, $05                                    ;0,4 $0C0C..$0C0F: 03 FE FE 05
        db      $00, $07, $F2, $0A                                    ;0,4 $0C10..$0C13: 00 07 F2 0A
        db      $03, $7F, $FE, $05                                    ;0,4 $0C14..$0C17: 03 7F FE 05
        db      $F3, $60, $80, $01                                    ;0,4 $0C18..$0C1B: F3 60 80 01
        db      $00, $02, $F2, $08                                    ;0,4 $0C1C..$0C1F: 00 02 F2 08
        db      $7C, $F2, $04, $05                                    ;0,4 $0C20..$0C23: 7C F2 04 05
        db      $00, $00, $02, $F2                                    ;0,4 $0C24..$0C27: 00 00 02 F2
        db      $0C, $05, $F2, $03                                    ;0,4 $0C28..$0C2B: 0C 05 F2 03
        db      $02, $F2, $03, $7C                                    ;0,4 $0C2C..$0C2F: 02 F2 03 7C
        db      $F2, $06, $7C, $05                                    ;0,4 $0C30..$0C33: F2 06 7C 05
        db      $F2, $04, $02, $F1                                    ;0,4 $0C34..$0C37: F2 04 02 F1
        db      $0A, $06, $0B, $F0                                    ;0,4 $0C38..$0C3B: 0A 06 0B F0
        db      $00, $10, $38, $7C                                    ;0,4 $0C3C..$0C3F: 00 10 38 7C
        db      $FE, $7C, $38, $10                                    ;0,4 $0C40..$0C43: FE 7C 38 10
        db      $06, $0C, $18, $64                                    ;0,4 $0C44..$0C47: 06 0C 18 64
        db      $B6, $6B, $0F, $06                                    ;0,4 $0C48..$0C4B: B6 6B 0F 06
        db      $83, $96, $7B, $36                                    ;0,4 $0C4C..$0C4F: 83 96 7B 36
        db      $C0, $0C, $62, $03                                    ;0,4 $0C50..$0C53: C0 0C 62 03
        db      $02, $08, $03, $0C                                    ;0,4 $0C54..$0C57: 02 08 03 0C
        db      $E2, $55, $50, $39                                    ;0,4 $0C58..$0C5B: E2 55 50 39
        db      $1A, $00, $8B, $76                                    ;0,4 $0C5C..$0C5F: 1A 00 8B 76
        db      $0D, $69, $28, $92                                    ;0,4 $0C60..$0C63: 0D 69 28 92
        db      $54, $38, $54, $92                                    ;0,4 $0C64..$0C67: 54 38 54 92
        db      $10, $00, $20, $92                                    ;0,4 $0C68..$0C6B: 10 00 20 92
        db      $FE, $38, $D6, $90                                    ;0,4 $0C6C..$0C6F: FE 38 D6 90
        db      $08, $04, $08, $10                                    ;0,4 $0C70..$0C73: 08 04 08 10
        db      $D6, $38, $D6, $12                                    ;0,4 $0C74..$0C77: D6 38 D6 12
        db      $20, $40, $28, $92                                    ;0,4 $0C78..$0C7B: 20 40 28 92
        db      $FE, $38, $D6, $10                                    ;0,4 $0C7C..$0C7F: FE 38 D6 10
        db      $10, $10, $22, $14                                    ;0,4 $0C80..$0C83: 10 10 22 14
        db      $09, $7E, $09, $14                                    ;0,4 $0C84..$0C87: 09 7E 09 14
        db      $22, $00, $36, $14                                    ;0,4 $0C88..$0C8B: 22 00 36 14
        db      $0D, $3E, $4C, $94                                    ;0,4 $0C8C..$0C8F: 0D 3E 4C 94
        db      $16, $00, $14, $94                                    ;0,4 $0C90..$0C93: 16 00 14 94
        db      $48, $3E, $09, $14                                    ;0,4 $0C94..$0C97: 48 3E 09 14
        db      $34, $00, $16, $14                                    ;0,4 $0C98..$0C9B: 34 00 16 14
        db      $0D, $FE, $0D, $14                                    ;0,4 $0C9C..$0C9F: 0D FE 0D 14
        db      $16, $00, $08, $08                                    ;0,4 $0CA0..$0CA3: 16 00 08 08
        db      $08, $6B, $1C, $7F                                    ;0,4 $0CA4..$0CA7: 08 6B 1C 7F
        db      $49, $14, $02, $04                                    ;0,4 $0CA8..$0CAB: 49 14 02 04
        db      $48, $6B, $1C, $6B                                    ;0,4 $0CAC..$0CAF: 48 6B 1C 6B
        db      $08, $10, $20, $10                                    ;0,4 $0CB0..$0CB3: 08 10 20 10
        db      $09, $6B, $1C, $7F                                    ;0,4 $0CB4..$0CB7: 09 6B 1C 7F
        db      $49, $04, $00, $08                                    ;0,4 $0CB8..$0CBB: 49 04 00 08
        db      $49, $2A, $1C, $2A                                    ;0,4 $0CBC..$0CBF: 49 2A 1C 2A
        db      $49, $14, $00, $44                                    ;0,4 $0CC0..$0CC3: 49 14 00 44
        db      $28, $90, $7E, $90                                    ;0,4 $0CC4..$0CC7: 28 90 7E 90
        db      $28, $44, $00, $68                                    ;0,4 $0CC8..$0CCB: 28 44 00 68
        db      $29, $32, $7C, $B0                                    ;0,4 $0CCC..$0CCF: 29 32 7C B0
        db      $28, $6C, $00, $2C                                    ;0,4 $0CD0..$0CD3: 28 6C 00 2C
        db      $28, $90, $7C, $12                                    ;0,4 $0CD4..$0CD7: 28 90 7C 12
        db      $29, $28, $00, $68                                    ;0,4 $0CD8..$0CDB: 29 28 00 68
        db      $28, $B0, $7F, $B0                                    ;0,4 $0CDC..$0CDF: 28 B0 7F B0
        db      $28, $68, $F2, $10                                    ;0,4 $0CE0..$0CE3: 28 68 F2 10
        db      $00, $49, $F1, $04                                    ;0,4 $0CE4..$0CE7: 00 49 F1 04
        db      $44, $47, $00, $45                                    ;0,4 $0CE8..$0CEB: 44 47 00 45
        db      $F1, $06, $44, $48                                    ;0,4 $0CEC..$0CEF: F1 06 44 48
        db      $00, $47, $F2, $04                                    ;0,4 $0CF0..$0CF3: 00 47 F2 04
        db      $47, $00, $45, $F2                                    ;0,4 $0CF4..$0CF7: 47 00 45 F2
        db      $03, $BD, $43, $BF                                    ;0,4 $0CF8..$0CFB: 03 BD 43 BF
        db      $45, $00, $47, $FD                                    ;0,4 $0CFC..$0CFF: 45 00 47 FD
        db      $F2, $03, $44, $43                                    ;0,4 $0D00..$0D03: F2 03 44 43
        db      $44, $00, $BD, $00                                    ;0,4 $0D04..$0D07: 44 00 BD 00
        db      $00, $FD, $FD, $45                                    ;0,4 $0D08..$0D0B: 00 FD FD 45
        db      $00, $47, $00, $00                                    ;0,4 $0D0C..$0D0F: 00 47 00 00
        db      $BD, $00, $00, $FD                                    ;0,4 $0D10..$0D13: BD 00 00 FD
        db      $F2, $05, $FD, $00                                    ;0,4 $0D14..$0D17: F2 05 FD 00
        db      $45, $00, $47, $F2                                    ;0,4 $0D18..$0D1B: 45 00 47 F2
        db      $04, $BD, $00, $00                                    ;0,4 $0D1C..$0D1F: 04 BD 00 00
        db      $FD, $F2, $04, $BD                                    ;0,4 $0D20..$0D23: FD F2 04 BD
        db      $45, $00, $47, $00                                    ;0,4 $0D24..$0D27: 45 00 47 00
        db      $00, $FD, $00, $00                                    ;0,4 $0D28..$0D2B: 00 FD 00 00
        db      $43, $F2, $07, $45                                    ;0,4 $0D2C..$0D2F: 43 F2 07 45
        db      $00, $47, $00, $BD                                    ;0,4 $0D30..$0D33: 00 47 00 BD
        db      $00, $00, $FD, $F2                                    ;0,4 $0D34..$0D37: 00 00 FD F2
        db      $03, $BD, $F2, $03                                    ;0,4 $0D38..$0D3B: 03 BD F2 03
        db      $FD, $45, $F3, $50                                    ;0,4 $0D3C..$0D3F: FD 45 F3 50
        db      $90, $01, $00, $47                                    ;0,4 $0D40..$0D43: 90 01 00 47
        db      $FD, $F2, $03, $46                                    ;0,4 $0D44..$0D47: FD F2 03 46
        db      $43, $46, $F2, $03                                    ;0,4 $0D48..$0D4B: 43 46 F2 03
        db      $00, $FD, $BD, $45                                    ;0,4 $0D4C..$0D4F: 00 FD BD 45
        db      $00, $47, $F2, $04                                    ;0,4 $0D50..$0D53: 00 47 F2 04
        db      $47, $00, $45, $F2                                    ;0,4 $0D54..$0D57: 47 00 45 F2
        db      $04, $43, $FF, $45                                    ;0,4 $0D58..$0D5B: 04 43 FF 45
        db      $00, $4A, $F1, $04                                    ;0,4 $0D5C..$0D5F: 00 4A F1 04
        db      $46, $47, $00, $45                                    ;0,4 $0D60..$0D63: 46 47 00 45
        db      $F1, $06, $46, $4B                                    ;0,4 $0D64..$0D67: F1 06 46 4B
        db      $F0, $3C, $6E, $DF                                    ;0,4 $0D68..$0D6B: F0 3C 6E DF
        db      $BF, $BF, $5F, $7F                                    ;0,4 $0D6C..$0D6F: BF BF 5F 7F
        db      $3E, $62, $34, $08                                    ;0,4 $0D70..$0D73: 3E 62 34 08
        db      $7E, $CF, $DF, $7E                                    ;0,4 $0D74..$0D77: 7E CF DF 7E
        db      $3C, $3B, $B6, $5B                                    ;0,4 $0D78..$0D7B: 3C 3B B6 5B
        db      $36, $C0, $0D, $8F                                    ;0,4 $0D7C..$0D7F: 36 C0 0D 8F
        db      $03, $02, $08, $03                                    ;0,4 $0D80..$0D83: 03 02 08 03
        db      $0E, $0F, $55, $50                                    ;0,4 $0D84..$0D87: 0E 0F 55 50
        db      $3A, $32, $08, $8B                                    ;0,4 $0D88..$0D8B: 3A 32 08 8B
        db      $56, $0B, $18, $24                                    ;0,4 $0D8C..$0D8F: 56 0B 18 24
        db      $99, $DB, $FF, $99                                    ;0,4 $0D90..$0D93: 99 DB FF 99
        db      $99, $18, $3C, $00                                    ;0,4 $0D94..$0D97: 99 18 3C 00
        db      $99, $DB, $FF, $18                                    ;0,4 $0D98..$0D9B: 99 DB FF 18
        db      $24, $42, $C3, $00                                    ;0,4 $0D9C..$0D9F: 24 42 C3 00
        db      $3C, $18, $FF, $FF                                    ;0,4 $0DA0..$0DA3: 3C 18 FF FF
        db      $DB, $99, $24, $24                                    ;0,4 $0DA4..$0DA7: DB 99 24 24
        db      $99, $DB, $FF, $DB                                    ;0,4 $0DA8..$0DAB: 99 DB FF DB
        db      $99, $24, $66, $3E                                    ;0,4 $0DAC..$0DAF: 99 24 66 3E
        db      $0C, $89, $FE, $FE                                    ;0,4 $0DB0..$0DB3: 0C 89 FE FE
        db      $89, $0C, $3E, $8E                                    ;0,4 $0DB4..$0DB7: 89 0C 3E 8E
        db      $CC, $28, $1E, $1E                                    ;0,4 $0DB8..$0DBB: CC 28 1E 1E
        db      $28, $CC, $8E, $78                                    ;0,4 $0DBC..$0DBF: 28 CC 8E 78
        db      $38, $9A, $7E, $7E                                    ;0,4 $0DC0..$0DC3: 38 9A 7E 7E
        db      $9A, $38, $78, $3E                                    ;0,4 $0DC4..$0DC7: 9A 38 78 3E
        db      $9C, $C9, $3E, $3E                                    ;0,4 $0DC8..$0DCB: 9C C9 3E 3E
        db      $C9, $9C, $3E, $66                                    ;0,4 $0DCC..$0DCF: C9 9C 3E 66
        db      $24, $99, $DB, $FF                                    ;0,4 $0DD0..$0DD3: 24 99 DB FF
        db      $DB, $99, $24, $24                                    ;0,4 $0DD4..$0DD7: DB 99 24 24
        db      $99, $DB, $FF, $FF                                    ;0,4 $0DD8..$0DDB: 99 DB FF FF
        db      $18, $3C, $00, $C3                                    ;0,4 $0DDC..$0DDF: 18 3C 00 C3
        db      $42, $24, $18, $FF                                    ;0,4 $0DE0..$0DE3: 42 24 18 FF
        db      $DB, $99, $00, $3C                                    ;0,4 $0DE4..$0DE7: DB 99 00 3C
        db      $18, $99, $99, $FF                                    ;0,4 $0DE8..$0DEB: 18 99 99 FF
        db      $DB, $99, $24, $7D                                    ;0,4 $0DEC..$0DEF: DB 99 24 7D
        db      $30, $91, $7F, $7F                                    ;0,4 $0DF0..$0DF3: 30 91 7F 7F
        db      $91, $30, $7D, $71                                    ;0,4 $0DF4..$0DF7: 91 30 7D 71
        db      $33, $14, $38, $38                                    ;0,4 $0DF8..$0DFB: 33 14 38 38
        db      $14, $33, $71, $1E                                    ;0,4 $0DFC..$0DFF: 14 33 71 1E
        db      $1C, $59, $7E, $7E                                    ;0,4 $0E00..$0E03: 1C 59 7E 7E
        db      $59, $1C, $1E, $7D                                    ;0,4 $0E04..$0E07: 59 1C 1E 7D
        db      $39, $93, $7C, $7D                                    ;0,4 $0E08..$0E0B: 39 93 7C 7D
        db      $93, $39, $7D, $F2                                    ;0,4 $0E0C..$0E0F: 93 39 7D F2
        db      $10, $00, $09, $F1                                    ;0,4 $0E10..$0E13: 10 00 09 F1
        db      $06, $04, $03, $F1                                    ;0,4 $0E14..$0E17: 06 04 03 F1
        db      $06, $04, $08, $00                                    ;0,4 $0E18..$0E1B: 06 04 08 00
        db      $07, $F2, $04, $BD                                    ;0,4 $0E1C..$0E1F: 07 F2 04 BD
        db      $00, $7F, $00, $BD                                    ;0,4 $0E20..$0E23: 00 7F 00 BD
        db      $F2, $04, $05, $00                                    ;0,4 $0E24..$0E27: F2 04 05 00
        db      $07, $F2, $03, $7D                                    ;0,4 $0E28..$0E2B: 07 F2 03 7D
        db      $00, $00, $BD, $00                                    ;0,4 $0E2C..$0E2F: 00 00 BD 00
        db      $00, $7D, $F2, $03                                    ;0,4 $0E30..$0E33: 00 7D F2 03
        db      $05, $00, $07, $00                                    ;0,4 $0E34..$0E37: 05 00 07 00
        db      $00, $BD, $00, $BD                                    ;0,4 $0E38..$0E3B: 00 BD 00 BD
        db      $00, $03, $00, $BD                                    ;0,4 $0E3C..$0E3F: 00 03 00 BD
        db      $00, $BD, $00, $00                                    ;0,4 $0E40..$0E43: 00 BD 00 00
        db      $05, $00, $07, $00                                    ;0,4 $0E44..$0E47: 05 00 07 00
        db      $00, $7D, $03, $00                                    ;0,4 $0E48..$0E4B: 00 7D 03 00
        db      $7D, $00, $7D, $00                                    ;0,4 $0E4C..$0E4F: 7D 00 7D 00
        db      $03, $7D, $00, $00                                    ;0,4 $0E50..$0E53: 03 7D 00 00
        db      $05, $00, $07, $F2                                    ;0,4 $0E54..$0E57: 05 00 07 F2
        db      $03, $BD, $00, $00                                    ;0,4 $0E58..$0E5B: 03 BD 00 00
        db      $03, $00, $00, $BD                                    ;0,4 $0E5C..$0E5F: 03 00 00 BD
        db      $F2, $03, $05, $00                                    ;0,4 $0E60..$0E63: F2 03 05 00
        db      $07, $F2, $04, $7D                                    ;0,4 $0E64..$0E67: 07 F2 04 7D
        db      $00, $03, $00, $7D                                    ;0,4 $0E68..$0E6B: 00 03 00 7D
        db      $F2, $04, $05, $00                                    ;0,4 $0E6C..$0E6F: F2 04 05 00
        db      $07, $F2, $05, $BD                                    ;0,4 $0E70..$0E73: 07 F2 05 BD
        db      $03, $BD, $F2, $05                                    ;0,4 $0E74..$0E77: 03 BD F2 05
        db      $05, $00, $07, $F2                                    ;0,4 $0E78..$0E7B: 05 00 07 F2
        db      $06, $03, $F2, $06                                    ;0,4 $0E7C..$0E7F: 06 03 F2 06
        db      $05, $00, $07, $F2                                    ;0,4 $0E80..$0E83: 05 00 07 F2
        db      $06, $03, $F2, $05                                    ;0,4 $0E84..$0E87: 06 03 F2 05
        db      $7F, $05, $00, $0A                                    ;0,4 $0E88..$0E8B: 7F 05 00 0A
        db      $F1, $06, $06, $03                                    ;0,4 $0E8C..$0E8F: F1 06 06 03
        db      $F1, $06, $06, $0B                                    ;0,4 $0E90..$0E93: F1 06 06 0B
        db      $F0, $44, $EE, $FE                                    ;0,4 $0E94..$0E97: F0 44 EE FE
        db      $FE, $FE, $7C, $38                                    ;0,4 $0E98..$0E9B: FE FE 7C 38
        db      $10, $0C, $08, $7E                                    ;0,4 $0E9C..$0E9F: 10 0C 08 7E
        db      $DB, $F5, $5A, $2C                                    ;0,4 $0EA0..$0EA3: DB F5 5A 2C
        db      $18, $73, $B6, $83                                    ;0,4 $0EA4..$0EA7: 18 73 B6 83
        db      $76, $D0, $0D, $8F                                    ;0,4 $0EA8..$0EAB: 76 D0 0D 8F
        db      $03, $02, $08, $01                                    ;0,4 $0EAC..$0EAF: 03 02 08 01
        db      $0E, $BB, $55, $50                                    ;0,4 $0EB0..$0EB3: 0E BB 55 50
        db      $3B, $0A, $00, $83                                    ;0,4 $0EB4..$0EB7: 3B 0A 00 83
        db      $76, $0C, $3C, $F2                                    ;0,4 $0EB8..$0EBB: 76 0C 3C F2
        db      $10, $F2, $08, $F1                                    ;0,4 $0EBC..$0EBF: 10 F2 08 F1
        db      $08, $C3, $F2, $04                                    ;0,4 $0EC0..$0EC3: 08 C3 F2 04
        db      $F1, $05, $C3, $F2                                    ;0,4 $0EC4..$0EC7: F1 05 C3 F2
        db      $06, $C5, $00, $F1                                    ;0,4 $0EC8..$0ECB: 06 C5 00 F1
        db      $04, $C3, $F2, $03                                    ;0,4 $0ECC..$0ECF: 04 C3 F2 03
        db      $BD, $F2, $04, $BD                                    ;0,4 $0ED0..$0ED3: BD F2 04 BD
        db      $00, $C5, $00, $C7                                    ;0,4 $0ED4..$0ED7: 00 C5 00 C7
        db      $F2, $03, $BD, $F2                                    ;0,4 $0ED8..$0EDB: F2 03 BD F2
        db      $04, $BD, $F2, $04                                    ;0,4 $0EDC..$0EDF: 04 BD F2 04
        db      $C5, $00, $C7, $F2                                    ;0,4 $0EE0..$0EE3: C5 00 C7 F2
        db      $05, $BD, $F2, $04                                    ;0,4 $0EE4..$0EE7: 05 BD F2 04
        db      $BD, $00, $BD, $C5                                    ;0,4 $0EE8..$0EEB: BD 00 BD C5
        db      $00, $C7, $F2, $04                                    ;0,4 $0EEC..$0EEF: 00 C7 F2 04
        db      $C3, $F2, $05, $C3                                    ;0,4 $0EF0..$0EF3: C3 F2 05 C3
        db      $7F, $00, $C5, $F3                                    ;0,4 $0EF4..$0EF7: 7F 00 C5 F3
        db      $60, $80, $01, $F3                                    ;0,4 $0EF8..$0EFB: 60 80 01 F3
        db      $50, $90, $01, $F3                                    ;0,4 $0EFC..$0EFF: 50 90 01 F3
        db      $40, $A0, $01, $F3                                    ;0,4 $0F00..$0F03: 40 A0 01 F3
        db      $30, $B0, $01, $F3                                    ;0,4 $0F04..$0F07: 30 B0 01 F3
        db      $20, $C0, $01, $F0                                    ;0,4 $0F08..$0F0B: 20 C0 01 F0
        db      $27, $0E, $1D, $0E                                    ;0,4 $0F0C..$0F0F: 27 0E 1D 0E
        db      $1D, $0E, $19, $07                                    ;0,4 $0F10..$0F13: 1D 0E 19 07
        db      $17, $07, $15, $0E                                    ;0,4 $0F14..$0F17: 17 07 15 0E
        db      $15, $0E, $13, $07                                    ;0,4 $0F18..$0F1B: 15 0E 13 07
        db      $15, $07, $17, $07                                    ;0,4 $0F1C..$0F1F: 15 07 17 07
        db      $19, $07, $17, $0E                                    ;0,4 $0F20..$0F23: 19 07 17 0E
        db      $17, $12, $00, $04                                    ;0,4 $0F24..$0F27: 17 12 00 04
        db      $13, $07, $15, $07                                    ;0,4 $0F28..$0F2B: 13 07 15 07
        db      $17, $07, $19, $07                                    ;0,4 $0F2C..$0F2F: 17 07 19 07
        db      $17, $0E, $17, $0E                                    ;0,4 $0F30..$0F33: 17 0E 17 0E
        db      $13, $07, $15, $07                                    ;0,4 $0F34..$0F37: 13 07 15 07
        db      $17, $07, $19, $07                                    ;0,4 $0F38..$0F3B: 17 07 19 07
        db      $1D, $0E, $1D, $0E                                    ;0,4 $0F3C..$0F3F: 1D 0E 1D 0E
        db      $15, $07, $17, $07                                    ;0,4 $0F40..$0F43: 15 07 17 07
        db      $19, $07, $17, $07                                    ;0,4 $0F44..$0F47: 19 07 17 07
        db      $15, $07, $13, $07                                    ;0,4 $0F48..$0F4B: 15 07 13 07
        db      $15, $07, $19, $07                                    ;0,4 $0F4C..$0F4F: 15 07 19 07
        db      $11, $0E, $0F, $0E                                    ;0,4 $0F50..$0F53: 11 0E 0F 0E
        db      $0E, $14, $FF, $10                                    ;0,4 $0F54..$0F57: 0E 14 FF 10
        db      $04, $08, $05, $FF                                    ;0,4 $0F58..$0F5B: 04 08 05 FF
        db      $20, $07, $06, $03                                    ;0,4 $0F5C..$0F5F: 20 07 06 03
        db      $04, $09, $FF, $F2                                    ;0,4 $0F60..$0F63: 04 09 FF F2
        db      $06, $03, $09, $03                                    ;0,4 $0F64..$0F67: 06 03 09 03
        db      $FF, $F2, $3B, $02                                    ;0,4 $0F68..$0F6B: FF F2 3B 02
        db      $1D, $02, $07, $02                                    ;0,4 $0F6C..$0F6F: 1D 02 07 02
        db      $FF, $F2, $0E, $02                                    ;0,4 $0F70..$0F73: FF F2 0E 02
        db      $0D, $02, $0C, $02                                    ;0,4 $0F74..$0F77: 0D 02 0C 02
        db      $0B, $02, $0A, $02                                    ;0,4 $0F78..$0F7B: 0B 02 0A 02
        db      $09, $02, $08, $02                                    ;0,4 $0F7C..$0F7F: 09 02 08 02
        db      $07, $02, $06, $02                                    ;0,4 $0F80..$0F83: 07 02 06 02
        db      $05, $02, $04, $02                                    ;0,4 $0F84..$0F87: 05 02 04 02
        db      $03, $02, $FF, $F2                                    ;0,4 $0F88..$0F8B: 03 02 FF F2
        db      $1D, $24, $27, $0C                                    ;0,4 $0F8C..$0F8F: 1D 24 27 0C
        db      $00, $01, $27, $0C                                    ;0,4 $0F90..$0F93: 00 01 27 0C
        db      $2E, $14, $00, $01                                    ;0,4 $0F94..$0F97: 2E 14 00 01
        db      $2E, $0C, $00, $01                                    ;0,4 $0F98..$0F9B: 2E 0C 00 01
        db      $2E, $0C, $3B, $26                                    ;0,4 $0F9C..$0F9F: 2E 0C 3B 26
        db      $FF, $3B, $26, $17                                    ;0,4 $0FA0..$0FA3: FF 3B 26 17
        db      $09, $13, $09, $13                                    ;0,4 $0FA4..$0FA7: 09 13 09 13
        db      $09, $13, $09, $15                                    ;0,4 $0FA8..$0FAB: 09 13 09 15
        db      $09, $11, $09, $11                                    ;0,4 $0FAC..$0FAF: 09 11 09 11
        db      $09, $11, $09, $0F                                    ;0,4 $0FB0..$0FB3: 09 11 09 0F
        db      $09, $0F, $09, $11                                    ;0,4 $0FB4..$0FB7: 09 0F 09 11
        db      $09, $0F, $09, $0E                                    ;0,4 $0FB8..$0FBB: 09 0F 09 0E
        db      $09, $0D, $09, $0E                                    ;0,4 $0FBC..$0FBF: 09 0D 09 0E
        db      $0A, $FF, $F2, $13                                    ;0,4 $0FC0..$0FC3: 0A FF F2 13
        db      $14, $17, $0A, $15                                    ;0,4 $0FC4..$0FC7: 14 17 0A 15
        db      $0A, $13, $0A, $0E                                    ;0,4 $0FC8..$0FCB: 0A 13 0A 0E
        db      $1E, $00, $01, $0F                                    ;0,4 $0FCC..$0FCF: 1E 00 01 0F
        db      $06, $0E, $06, $0D                                    ;0,4 $0FD0..$0FD3: 06 0E 06 0D
        db      $0A, $0E, $0A, $0F                                    ;0,4 $0FD4..$0FD7: 0A 0E 0A 0F
        db      $0A, $11, $0A, $13                                    ;0,4 $0FD8..$0FDB: 0A 11 0A 13
        db      $0F, $00, $0F, $0F                                    ;0,4 $0FDC..$0FDF: 0F 00 0F 0F
        db      $06, $0E, $06, $0D                                    ;0,4 $0FE0..$0FE3: 06 0E 06 0D
        db      $0A, $0E, $0A, $0F                                    ;0,4 $0FE4..$0FE7: 0A 0E 0A 0F
        db      $0A, $11, $0A, $13                                    ;0,4 $0FE8..$0FEB: 0A 11 0A 13
        db      $0A, $11, $0A, $13                                    ;0,4 $0FEC..$0FEF: 0A 11 0A 13
        db      $0A, $15, $0A, $17                                    ;0,4 $0FF0..$0FF3: 0A 15 0A 17
        db      $14, $19, $14, $1D                                    ;0,4 $0FF4..$0FF7: 14 19 14 1D
        db      $1F, $FF, $F2, $00                                    ;0,4 $0FF8..$0FFB: 1F FF F2 00
        db      $00, $00, $00, $00                                    ;0,4 $0FFC..$0FFF: 00 00 00 00

        end
