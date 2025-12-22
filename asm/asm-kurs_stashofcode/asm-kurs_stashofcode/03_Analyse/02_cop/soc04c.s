
; soc04c.s
; Auszug Copperlist
; zeigt die 41 Moves nach einem Copper-Wait pro Zeile mit einem horizontalen Versatz
; dec.w $2c3f,$fffe bzw. dec.w $2d3d,$fffe

  D0 0080373D   D1 AB1B00F4   D2 26EB0004   D3 0000019C
  D4 00000252   D5 000000E4   D6 0000002A   D7 01FC0032
  A0 00024D9A   A1 0003C638   A2 00024492   A3 00024514
  A4 000245C4   A5 00DFF000   A6 0003BEB0   A7 00C60984
USP  00C60984 ISP  00C619C0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 3b7c (MOVE) 0a41 (EOR) Chip latch 00000182
00c2cdc8 3b7c 0a41 0058           move.w #$0a41,(a5,$0058) == $00dff058
Next PC: 00c2cdce
>o1
 0002ee60: 008e 2c81            ;  DIWSTRT := 0x2c81
 0002ee64: 0090 2cc1            ;  DIWSTOP := 0x2cc1
 0002ee68: 0100 1200            ;  BPLCON0 := 0x1200
 0002ee6c: 0102 0000            ;  BPLCON1 := 0x0000
 0002ee70: 0104 0000            ;  BPLCON2 := 0x0000
 0002ee74: 0092 0038            ;  DDFSTRT := 0x0038
 0002ee78: 0094 00d0            ;  DDFSTOP := 0x00d0
 0002ee7c: 0108 0000            ;  BPL1MOD := 0x0000
 0002ee80: 010a 0000            ;  BPL2MOD := 0x0000
 0002ee84: 01fc 0000            ;  FMODE := 0x0000
 0002ee88: 00e2 9698            ;  BPL1PTL := 0x9698
 0002ee8c: 00e0 0003            ;  BPL1PTH := 0x0003
 0002ee90: 0180 0000            ;  COLOR00 := 0x0000
 0002ee94: 2c3f fffe            ;  Wait for vpos >= 0x2c and hpos >= 0x3e
                                ;  VP 2c, VE 7f; HP 3e, HE fe; BFD 1
 0002ee98: 0182 ffff            ;  COLOR01 := 0xffff
 0002ee9c: 0182 ffff            ;  COLOR01 := 0xffff
 0002eea0: 0182 ffff            ;  COLOR01 := 0xffff
 0002eea4: 0182 ffff            ;  COLOR01 := 0xffff
 0002eea8: 0182 ffff            ;  COLOR01 := 0xffff
 0002eeac: 0182 ffff            ;  COLOR01 := 0xffff
>o
 0002eeb0: 0182 ffff            ;  COLOR01 := 0xffff
 0002eeb4: 0182 ffff            ;  COLOR01 := 0xffff
 0002eeb8: 0182 ffff            ;  COLOR01 := 0xffff
 0002eebc: 0182 ffff            ;  COLOR01 := 0xffff		; 10 moves
 0002eec0: 0182 ffff            ;  COLOR01 := 0xffff
 0002eec4: 0182 ffff            ;  COLOR01 := 0xffff
 0002eec8: 0182 ffff            ;  COLOR01 := 0xffff
 0002eecc: 0182 ffff            ;  COLOR01 := 0xffff
 0002eed0: 0182 ffff            ;  COLOR01 := 0xffff
 0002eed4: 0182 ffff            ;  COLOR01 := 0xffff
 0002eed8: 0182 ffff            ;  COLOR01 := 0xffff
 0002eedc: 0182 ffff            ;  COLOR01 := 0xffff
 0002eee0: 0182 ffff            ;  COLOR01 := 0xffff
 0002eee4: 0182 ffff            ;  COLOR01 := 0xffff		; 20 moves
 0002eee8: 0182 ffff            ;  COLOR01 := 0xffff
 0002eeec: 0182 ffff            ;  COLOR01 := 0xffff
 0002eef0: 0182 ffff            ;  COLOR01 := 0xffff
 0002eef4: 0182 ffff            ;  COLOR01 := 0xffff
 0002eef8: 0182 ffff            ;  COLOR01 := 0xffff
 0002eefc: 0182 ffff            ;  COLOR01 := 0xffff
>o
 0002ef00: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef04: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef08: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef0c: 0182 ffff            ;  COLOR01 := 0xffff		; 30 moves
 0002ef10: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef14: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef18: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef1c: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef20: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef24: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef28: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef2c: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef30: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef34: 0182 ffff            ;  COLOR01 := 0xffff		; 40 moves
 0002ef38: 0182 ffff            ;  COLOR01 := 0xffff		; 41 41 moves
 0002ef3c: 2d3d fffe            ;  Wait for vpos >= 0x2d and hpos >= 0x3c
                                ;  VP 2d, VE 7f; HP 3c, HE fe; BFD 1
 0002ef40: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef44: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef48: 0182 ffff            ;  COLOR01 := 0xffff
 0002ef4c: 0182 ffff            ;  COLOR01 := 0xffff