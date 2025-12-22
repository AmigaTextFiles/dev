
; soc30a.s = copperScreen.s
; Copperlist-Analyse

>fs 0 0
Cycles: 47214 Chip, 94428 CPU. (V=105 H=2 -> V=0 H=0)									; Startposition frame
VPOS: 000 ($000) HPOS: 006 ($006) COP: $0001fd38
  D0 FD380001   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00020508   A1 00022A10   A2 00000000   A3 00000000
  A4 00000000   A5 00DFF000   A6 00C00276   A7 00C5FDE4
USP  00C5FDE4 ISP  00C60E20
SR=0008 T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IM=0 STP=0
Prefetch 6600 (Bcc) fff6 (ILLEGAL) Chip latch 0000FFFF
0001fc26 6600 fff6                bne.w #$fff6 == $0001fc1e (T)
Next PC: 0001fc2a
>o1
*0001fd38: 008e 2c81            ;  DIWSTRT := 0x2c81									; 0x1fd38 = Cl
 0001fd3c: 0090 2cc1            ;  DIWSTOP := 0x2cc1
 0001fd40: 0100 1200            ;  BPLCON0 := 0x1200
 0001fd44: 0102 0000            ;  BPLCON1 := 0x0000
 0001fd48: 0104 0000            ;  BPLCON2 := 0x0000
 0001fd4c: 0092 0038            ;  DDFSTRT := 0x0038
 0001fd50: 0094 00d0            ;  DDFSTOP := 0x00d0
 0001fd54: 0108 0000            ;  BPL1MOD := 0x0000
 0001fd58: 010a 0000            ;  BPL2MOD := 0x0000
 0001fd5c: 01fc 0000            ;  FMODE := 0x0000
 0001fd60: 00e2 0508            ;  BPL1PTL := 0x0508
 0001fd64: 00e0 0002            ;  BPL1PTH := 0x0002
 0001fd68: 0182 0fff            ;  COLOR01 := 0x0fff
 0001fd6c: 0180 0000            ;  COLOR00 := 0x0000
 0001fd70: 0082 fd84            ;  COP1LCL := 0xfd84									; COP1PT = 0x1fd84 ->Cla
 0001fd74: 0080 0001            ;  COP1LCH := 0x0001
 0001fd78: 6401 fffe            ;  Wait for vpos >= 0x64 and hpos >= 0x00
                                ;  VP 64, VE 7f; HP 00, HE fe; BFD 1
 0001fd7c: 0086 fe3c            ;  COP2LCL := 0xfe3c									; COP2PT = 0x1fe3c ->Clb 
 0001fd80: 0084 0001            ;  COP2LCH := 0x0001
;------------------------------------------------------------------------------			; Ende Teil 1
>o1
 0001fd84: 8001 8001 [0c9 098]  ;  Skip if vpos & 0x00 >= 0x80, , ignore horizontal		; 0x1fd84 = Cla
                                ;  VP 80, VE 00; HP 00, HE 00; BFD 1
 0001fd88: 008a 0000            ;  COPJMP2 := 0x0000									; COPJMP2 = 0x1fe3c ->Clb 
 0001fd8c: 803f 80fe [0c9 0a4]  ;  Wait for vpos & 0x00 >= 0x80 and hpos >= 0x3e
                                ;  VP 80, VE 00; HP 3e, HE fe; BFD 1
 0001fd90: 0180 0f00            ;  COLOR00 := 0x0f00
 0001fd94: 0180 00f0            ;  COLOR00 := 0x00f0
 0001fd98: 0180 000f            ;  COLOR00 := 0x000f
 0001fd9c: 0180 0fff            ;  COLOR00 := 0x0fff
 0001fda0: 0180 0000            ;  COLOR00 := 0x0000
 0001fda4: 0180 0ff0            ;  COLOR00 := 0x0ff0
 0001fda8: 0180 0f0f            ;  COLOR00 := 0x0f0f
 0001fdac: 0180 00ff            ;  COLOR00 := 0x00ff
 0001fdb0: 0180 0c00            ;  COLOR00 := 0x0c00
 0001fdb4: 0180 00c0            ;  COLOR00 := 0x00c0
 0001fdb8: 0180 000c            ;  COLOR00 := 0x000c
 0001fdbc: 0180 0ccc            ;  COLOR00 := 0x0ccc
 0001fdc0: 0180 0000            ;  COLOR00 := 0x0000
 0001fdc4: 0180 0cc0            ;  COLOR00 := 0x0cc0
 0001fdc8: 0180 0c0c            ;  COLOR00 := 0x0c0c
 0001fdcc: 0180 00cc            ;  COLOR00 := 0x00cc
 0001fdd0: 0180 0900            ;  COLOR00 := 0x0900
>o
 0001fdd4: 0180 0090            ;  COLOR00 := 0x0090
 0001fdd8: 0180 0009            ;  COLOR00 := 0x0009
 0001fddc: 0180 0999            ;  COLOR00 := 0x0999
 0001fde0: 0180 0000            ;  COLOR00 := 0x0000
 0001fde4: 0180 0990            ;  COLOR00 := 0x0990
 0001fde8: 0180 0909            ;  COLOR00 := 0x0909
 0001fdec: 0180 0099            ;  COLOR00 := 0x0099
 0001fdf0: 0180 0600            ;  COLOR00 := 0x0600
 0001fdf4: 0180 0060            ;  COLOR00 := 0x0060
 0001fdf8: 0180 0006            ;  COLOR00 := 0x0006
 0001fdfc: 0180 0666            ;  COLOR00 := 0x0666
 0001fe00: 0180 0000            ;  COLOR00 := 0x0000
 0001fe04: 0180 0660            ;  COLOR00 := 0x0660
 0001fe08: 0180 0606            ;  COLOR00 := 0x0606
 0001fe0c: 0180 0066            ;  COLOR00 := 0x0066
 0001fe10: 0180 0300            ;  COLOR00 := 0x0300
 0001fe14: 0180 0030            ;  COLOR00 := 0x0030
 0001fe18: 0180 0003            ;  COLOR00 := 0x0003
 0001fe1c: 0180 0333            ;  COLOR00 := 0x0333
 0001fe20: 0180 0000            ;  COLOR00 := 0x0000
>o
 0001fe24: 0180 0330            ;  COLOR00 := 0x0330
 0001fe28: 0180 0303            ;  COLOR00 := 0x0303
 0001fe2c: 0180 0033            ;  COLOR00 := 0x0033
 0001fe30: 0086 fee0            ;  COP2LCL := 0xfee0
 0001fe34: 0084 0001            ;  COP2LCH := 0x0001
 0001fe38: 008a 0000            ;  COPJMP2 := 0x0000
 0001fe3c: 003f 80fe            ;  Wait for  hpos >= 0x3e									; Clb = 0x1fe3c
                                ;  VP 00, VE 00; HP 3e, HE fe; BFD 1
 0001fe40: 0180 0033            ;  COLOR00 := 0x0033
 0001fe44: 0180 0303            ;  COLOR00 := 0x0303
 0001fe48: 0180 0330            ;  COLOR00 := 0x0330
 0001fe4c: 0180 0000            ;  COLOR00 := 0x0000
 0001fe50: 0180 0333            ;  COLOR00 := 0x0333
 0001fe54: 0180 0003            ;  COLOR00 := 0x0003
 0001fe58: 0180 0030            ;  COLOR00 := 0x0030
 0001fe5c: 0180 0300            ;  COLOR00 := 0x0300
 0001fe60: 0180 0066            ;  COLOR00 := 0x0066
 0001fe64: 0180 0606            ;  COLOR00 := 0x0606
 0001fe68: 0180 0660            ;  COLOR00 := 0x0660
 0001fe6c: 0180 0000            ;  COLOR00 := 0x0000
 0001fe70: 0180 0666            ;  COLOR00 := 0x0666
>o
 0001fe74: 0180 0006            ;  COLOR00 := 0x0006
 0001fe78: 0180 0060            ;  COLOR00 := 0x0060
 0001fe7c: 0180 0600            ;  COLOR00 := 0x0600
 0001fe80: 0180 0099            ;  COLOR00 := 0x0099
 0001fe84: 0180 0909            ;  COLOR00 := 0x0909
 0001fe88: 0180 0990            ;  COLOR00 := 0x0990
 0001fe8c: 0180 0000            ;  COLOR00 := 0x0000
 0001fe90: 0180 0999            ;  COLOR00 := 0x0999
 0001fe94: 0180 0009            ;  COLOR00 := 0x0009
 0001fe98: 0180 0090            ;  COLOR00 := 0x0090
 0001fe9c: 0180 0900            ;  COLOR00 := 0x0900
 0001fea0: 0180 00cc            ;  COLOR00 := 0x00cc
 0001fea4: 0180 0c0c            ;  COLOR00 := 0x0c0c
 0001fea8: 0180 0cc0            ;  COLOR00 := 0x0cc0
 0001feac: 0180 0000            ;  COLOR00 := 0x0000
 0001feb0: 0180 0ccc            ;  COLOR00 := 0x0ccc
 0001feb4: 0180 000c            ;  COLOR00 := 0x000c
 0001feb8: 0180 00c0            ;  COLOR00 := 0x00c0
 0001febc: 0180 0c00            ;  COLOR00 := 0x0c00
 0001fec0: 0180 00ff            ;  COLOR00 := 0x00ff
>o
 0001fec4: 0180 0f0f            ;  COLOR00 := 0x0f0f
 0001fec8: 0180 0ff0            ;  COLOR00 := 0x0ff0
 0001fecc: 0180 0000            ;  COLOR00 := 0x0000
 0001fed0: 0180 0fff            ;  COLOR00 := 0x0fff
 0001fed4: 0180 000f            ;  COLOR00 := 0x000f
 0001fed8: 0180 00f0            ;  COLOR00 := 0x00f0
 0001fedc: 0180 0f00            ;  COLOR00 := 0x0f00
*0001fee0: ff01 ff01            ;  Skip if vpos >= 0xff, , ignore horizontal				; Clc = 0x1fee0
                                ;  VP ff, VE 7f; HP 00, HE 00; BFD 1
 0001fee4: 0088 0000            ;  COPJMP1 := 0x0000
 0001fee8: ff3f fffe            ;  Wait for vpos >= 0xff and hpos >= 0x3e					; Cld = 0x01fee8	
                                ;  VP ff, VE 7f; HP 3e, HE fe; BFD 1
 0001feec: 0180 0033            ;  COLOR00 := 0x0033
 0001fef0: 0180 0303            ;  COLOR00 := 0x0303
 0001fef4: 0180 0330            ;  COLOR00 := 0x0330
 0001fef8: 0180 0000            ;  COLOR00 := 0x0000
 0001fefc: 0180 0333            ;  COLOR00 := 0x0333
 0001ff00: 0180 0003            ;  COLOR00 := 0x0003
 0001ff04: 0180 0030            ;  COLOR00 := 0x0030
 0001ff08: 0180 0300            ;  COLOR00 := 0x0300
 0001ff0c: 0180 0066            ;  COLOR00 := 0x0066
 0001ff10: 0180 0606            ;  COLOR00 := 0x0606
>o
 0001ff14: 0180 0660            ;  COLOR00 := 0x0660
 0001ff18: 0180 0000            ;  COLOR00 := 0x0000
 0001ff1c: 0180 0666            ;  COLOR00 := 0x0666
 0001ff20: 0180 0006            ;  COLOR00 := 0x0006
 0001ff24: 0180 0060            ;  COLOR00 := 0x0060
 0001ff28: 0180 0600            ;  COLOR00 := 0x0600
 0001ff2c: 0180 0099            ;  COLOR00 := 0x0099
 0001ff30: 0180 0909            ;  COLOR00 := 0x0909
 0001ff34: 0180 0990            ;  COLOR00 := 0x0990
 0001ff38: 0180 0000            ;  COLOR00 := 0x0000
 0001ff3c: 0180 0999            ;  COLOR00 := 0x0999
 0001ff40: 0180 0009            ;  COLOR00 := 0x0009
 0001ff44: 0180 0090            ;  COLOR00 := 0x0090
 0001ff48: 0180 0900            ;  COLOR00 := 0x0900
 0001ff4c: 0180 00cc            ;  COLOR00 := 0x00cc
 0001ff50: 0180 0c0c            ;  COLOR00 := 0x0c0c
 0001ff54: 0180 0cc0            ;  COLOR00 := 0x0cc0
 0001ff58: 0180 0000            ;  COLOR00 := 0x0000
 0001ff5c: 0180 0ccc            ;  COLOR00 := 0x0ccc
 0001ff60: 0180 000c            ;  COLOR00 := 0x000c
>o
 0001ff64: 0180 00c0            ;  COLOR00 := 0x00c0
 0001ff68: 0180 0c00            ;  COLOR00 := 0x0c00
 0001ff6c: 0180 00ff            ;  COLOR00 := 0x00ff
 0001ff70: 0180 0f0f            ;  COLOR00 := 0x0f0f
 0001ff74: 0180 0ff0            ;  COLOR00 := 0x0ff0
 0001ff78: 0180 0000            ;  COLOR00 := 0x0000
 0001ff7c: 0180 0fff            ;  COLOR00 := 0x0fff
 0001ff80: 0180 000f            ;  COLOR00 := 0x000f
 0001ff84: 0180 00f0            ;  COLOR00 := 0x00f0
 0001ff88: 0180 0f00            ;  COLOR00 := 0x0f00
 0001ff8c: 0082 ff94            ;  COP1LCL := 0xff94
 0001ff90: 0080 0001            ;  COP1LCH := 0x0001
 0001ff94: 003f 80fe            ;  Wait for  hpos >= 0x3e								; Cle = 0x01ff94
                                ;  VP 00, VE 00; HP 3e, HE fe; BFD 1
 0001ff98: 0180 0033            ;  COLOR00 := 0x0033
 0001ff9c: 0180 0303            ;  COLOR00 := 0x0303
 0001ffa0: 0180 0330            ;  COLOR00 := 0x0330
 0001ffa4: 0180 0000            ;  COLOR00 := 0x0000
 0001ffa8: 0180 0333            ;  COLOR00 := 0x0333
 0001ffac: 0180 0003            ;  COLOR00 := 0x0003
 0001ffb0: 0180 0030            ;  COLOR00 := 0x0030
>o
 0001ffb4: 0180 0300            ;  COLOR00 := 0x0300
 0001ffb8: 0180 0066            ;  COLOR00 := 0x0066
 0001ffbc: 0180 0606            ;  COLOR00 := 0x0606
 0001ffc0: 0180 0660            ;  COLOR00 := 0x0660
 0001ffc4: 0180 0000            ;  COLOR00 := 0x0000
 0001ffc8: 0180 0666            ;  COLOR00 := 0x0666
 0001ffcc: 0180 0006            ;  COLOR00 := 0x0006
 0001ffd0: 0180 0060            ;  COLOR00 := 0x0060
 0001ffd4: 0180 0600            ;  COLOR00 := 0x0600
 0001ffd8: 0180 0099            ;  COLOR00 := 0x0099
 0001ffdc: 0180 0909            ;  COLOR00 := 0x0909
 0001ffe0: 0180 0990            ;  COLOR00 := 0x0990
 0001ffe4: 0180 0000            ;  COLOR00 := 0x0000
 0001ffe8: 0180 0999            ;  COLOR00 := 0x0999
 0001ffec: 0180 0009            ;  COLOR00 := 0x0009
 0001fff0: 0180 0090            ;  COLOR00 := 0x0090
 0001fff4: 0180 0900            ;  COLOR00 := 0x0900
 0001fff8: 0180 00cc            ;  COLOR00 := 0x00cc
 0001fffc: 0180 0c0c            ;  COLOR00 := 0x0c0c
 00020000: 0180 0cc0            ;  COLOR00 := 0x0cc0
>o
 00020004: 0180 0000            ;  COLOR00 := 0x0000
 00020008: 0180 0ccc            ;  COLOR00 := 0x0ccc
 0002000c: 0180 000c            ;  COLOR00 := 0x000c
 00020010: 0180 00c0            ;  COLOR00 := 0x00c0
 00020014: 0180 0c00            ;  COLOR00 := 0x0c00
 00020018: 0180 00ff            ;  COLOR00 := 0x00ff
 0002001c: 0180 0f0f            ;  COLOR00 := 0x0f0f
 00020020: 0180 0ff0            ;  COLOR00 := 0x0ff0
 00020024: 0180 0000            ;  COLOR00 := 0x0000
 00020028: 0180 0fff            ;  COLOR00 := 0x0fff
 0002002c: 0180 000f            ;  COLOR00 := 0x000f
 00020030: 0180 00f0            ;  COLOR00 := 0x00f0
 00020034: 0180 0f00            ;  COLOR00 := 0x0f00
 00020038: 1901 ff01            ;  Skip if vpos >= 0x19, , ignore horizontal
                                ;  VP 19, VE 7f; HP 00, HE 00; BFD 1
 0002003c: 0088 0000            ;  COPJMP1 := 0x0000
 00020040: 0082 fd38            ;  COP1LCL := 0xfd38
 00020044: 0080 0001            ;  COP1LCH := 0x0001
 00020048: 0180 0000            ;  COLOR00 := 0x0000
 0002004c: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 00020050: 0000 0000            ;  BLTDDAT := 0x0000
>

