
; Listing19l1.s
; Copper Debugger
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

  o <0-2|addr> [<lines>]	View memory as Copper instructions.
  od						Enable/disable Copper vpos/hpos tracing.
  ;ot						Copper single step trace.
  ;ob <addr>				Copper breakpoint.

																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
>e																				; one way to get the values?
..																				; this shows the actual values from current reasterposition	
080 COP1LCH     0000    16E SPR5DATB    0000									; COP1LCH	e 80, e 82
082 COP1LCL     9CE8    170 SPR6POS     FE00
084 COP2LCH     00C0    172 SPR6CTL     FF00									; COP2LCH	e 84, e 86
086 COP2LCL     0276    174 SPR6DATA    0000
...																				; if you have to find the first copper-pointer adress
																				; you can check like >o 9CE8-20

;-------------------------------------------------------------------------------	
>c																				; better way
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 000a3e (000a3e) ALARM 000000    CYC=682FCC00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 000138 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 8 word CA3A pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: 602c (602c) INTREQ: 0060 (0060) VPOS: 0 HPOS: 19
INT: 0020 IPL: 3
COP1LC: 00000420, COP2LC: 0001f280 COPPTR: 00000422								; copper information in this line
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=0
Average frame time: 1943917.38 ms [frames: 782 time: 1520143395]
>

;-------------------------------------------------------------------------------
																				; or
																				; There is no need to find anything. o1 = cop1lc, o2 = cop2lc.

																				; View memory as Copper instructions. without copper debugger od

>o0 2
*00000422: 005a 00e2            ;  BLTCON0L := 0x00e2							; the star marks the actual COPPTR: 00000422	
 00000426: 0000 0120            ;  BLTDDAT := 0x0120
;-------------------------------------------------------------------------------
>o1 3
*00000420: 0180 005a            ;  COLOR00 := 0x005a
 00000424: 00e2 0000            ;  BPL1PTL := 0x0000
 00000428: 0120 0000            ;  SPR0PTH := 0x0000
 ;-------------------------------------------------------------------------------
>o 2 4
 0001f280: 2b01 fffe            ;  Wait for vpos >= 0x2b and hpos >= 0x00
                                ;  VP 2b, VE 7f; HP 00, HE fe; BFD 1
 0001f284: 0180 005a            ;  COLOR00 := 0x005a
 0001f288: 0182 0fff            ;  COLOR01 := 0x0fff
 0001f28c: 0184 0002            ;  COLOR02 := 0x0002
>
;-------------------------------------------------------------------------------
>o 422 5																		; copperlist from actual COPPTR
*00000422: 005a 00e2            ;  BLTCON0L := 0x00e2		
 00000426: 0000 0120            ;  BLTDDAT := 0x0120
 0000042a: 0000 0122            ;  BLTDDAT := 0x0122
 0000042e: 0c80 0124            ;  COP1LCH := 0x0124
 00000432: 0000 0126            ;  BLTDDAT := 0x0126
>

;-------------------------------------------------------------------------------
																				; to show copper debugger info - you have to enable the
																				; copper debugger with od and run one frame forward

>od
Copper debugger enabled.
>o 1 2
*00000420: 0180 005a            ;  COLOR00 := 0x005a							; no debugger data
 00000424: 00e2 0000            ;  BPL1PTL := 0x0000							; no debugger data
>c
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 000a3e (000a3e) ALARM 000000    CYC=682FCC00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 000138 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 8 word CA3A pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: 602c (602c) INTREQ: 0060 (0060) VPOS: 0 HPOS: 19				; we are on line 0 (VPOS: 0)
INT: 0020 IPL: 3
COP1LC: 00000420, COP2LC: 0001f280 COPPTR: 00000422
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=0
Average frame time: 1943917.38 ms [frames: 782 time: 1520143395]
;-------------------------------------------------------------------------------
>fs 200		; fs <lines to wait> | <vpos> <hpos> Wait n scanlines/position.			; move to line 200 ($c8)
  D0 00000000   D1 00000000   D2 00C62CEC   D3 00000030
  D4 0000FFFF   D5 0000FFFF   D6 00000000   D7 00000000
  A0 00C0040C   A1 00C26168   A2 00C18B54   A3 00C00410
  A4 00FC0FE2   A5 00C2716A   A6 00C00276   A7 00C80000
USP  00C271AC ISP  00C80000
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=1
Prefetch 2000 (MOVE) 4e72 (STOP) Chip latch 00000000
00FC0F94 60e6                     BT .B #$e6 == $00fc0f7c (T)
Next PC: 00fc0f96
;-------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 000a3f (000a3f) ALARM 000000    CYC=69927C00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 0000c7 (000000) ALARM 0000ac    CLK=1
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 8 word CA3A pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: 602c (602c) INTREQ: 0040 (0040) VPOS: c8 HPOS: 19			; we are on line 200 (VPOS: c8)
INT: 0000 IPL: -1
COP1LC: 00000420, COP2LC: 0001f280 COPPTR: 0001f314
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 1943917.38 ms [frames: 782 time: 1520143395]
;-------------------------------------------------------------------------------
>o 1 1
 00000420: 0180 005a            ;  COLOR00 := 0x005a							; yes this is the same frame
;-------------------------------------------------------------------------------
>fs 10
  D0 00000000   D1 00000000   D2 00C62CEC   D3 00000030
  D4 0000FFFF   D5 0000FFFF   D6 00000000   D7 00000000
  A0 00C0040C   A1 00C26168   A2 00C18B54   A3 00C00410
  A4 00FC0FE2   A5 00C2716A   A6 00C00276   A7 00C7FFFA
USP  00C271AC ISP  00C7FFFA
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=3 STP=0
Prefetch c0c6 (MULU) 48e7 (MVMLE) Chip latch 00000000
00FC0D14 48e7 c0c6                MOVEM.L D0-D1/A0-A1/A5-A6,-(A7)
Next PC: 00fc0d18
;-------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 000a3f (000a3f) ALARM 000000    CYC=6A5AE800
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 000138 (000000) ALARM 0000ac    CLK=4
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 8 word CA3A pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: 602c (602c) INTREQ: 0060 (0060) VPOS: 0 HPOS: 1c			; now we are one frame further
INT: 0020 IPL: 3
COP1LC: 00000420, COP2LC: 0001f280 COPPTR: 00000424
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=0
Average frame time: 1943917.38 ms [frames: 782 time: 1520143395]
;-------------------------------------------------------------------------------
>o 1 1
 00000420: 0180 005a [000 004]  ;  COLOR00 := 0x005a							; [000 004] Debugger data available
>

;-------------------------------------------------------------------------------
																				; View memory as Copper instructions. with copper debugger data

>o 0 2
*00000424: 00e2 0000 [000 008]  ;  BPL1PTL := 0x0000
 00000428: 0120 0000 [000 00c]  ;  SPR0PTH := 0x0000
;-------------------------------------------------------------------------------
>o 1 2
 00000420: 0180 005a [000 004]  ;  COLOR00 := 0x005a
*00000424: 00e2 0000 [000 008]  ;  BPL1PTL := 0x0000
;-------------------------------------------------------------------------------
>o 2 2
 0001f280: 2b01 fffe [02b 000]  ;  Wait for vpos >= 0x2b and hpos >= 0x00
                                ;  VP 2b, VE 7f; HP 00, HE fe; BFD 1
 0001f284: 0180 005a [02b 004]  ;  COLOR00 := 0x005a
;-------------------------------------------------------------------------------
>o																				; shows the next bytes as copperinstructions	
			
;-------------------------------------------------------------------------------
																				; Copper debugger disabled, doesn't work
																				; you have to close WinUAE and restart WinUAE again

>od
Copper debugger disabled.
;-------------------------------------------------------------------------------
>o 02
 0001f280: 2b01 fffe [02b 000]  ;  Wait for vpos >= 0x2b and hpos >= 0x00
                                ;  VP 2b, VE 7f; HP 00, HE fe; BFD 1
 0001f284: 0180 005a [02b 004]  ;  COLOR00 := 0x005a
 0001f288: 0182 0fff [02b 008]  ;  COLOR01 := 0x0fff
 0001f28c: 0184 0002 [02b 00c]  ;  COLOR02 := 0x0002
 0001f290: 0186 0f80 [02b 010]  ;  COLOR03 := 0x0f80
 0001f294: 01a0 0000 [02b 014]  ;  COLOR16 := 0x0000
 0001f298: 01a2 0d22 [02b 018]  ;  COLOR17 := 0x0d22
 0001f29c: 01a4 0000 [02b 01c]  ;  COLOR18 := 0x0000
 0001f2a0: 01a6 0abc [02b 020]  ;  COLOR19 := 0x0abc
 0001f2a4: 01a8 0444 [02b 024]  ;  COLOR20 := 0x0444
 0001f2a8: 01aa 0555 [02b 028]  ;  COLOR21 := 0x0555
 0001f2ac: 01ac 0666 [02b 02c]  ;  COLOR22 := 0x0666
 0001f2b0: 01ae 0777 [02b 030]  ;  COLOR23 := 0x0777
 0001f2b4: 01b0 0888 [02b 034]  ;  COLOR24 := 0x0888
 0001f2b8: 01b2 0999 [02b 038]  ;  COLOR25 := 0x0999
 0001f2bc: 01b4 0aaa [02b 03c]  ;  COLOR26 := 0x0aaa
 0001f2c0: 01b6 0bbb [02b 040]  ;  COLOR27 := 0x0bbb
 0001f2c4: 01b8 0ccc [02b 044]  ;  COLOR28 := 0x0ccc
 0001f2c8: 01ba 0ddd [02b 048]  ;  COLOR29 := 0x0ddd
 0001f2cc: 01bc 0eee [02b 04c]  ;  COLOR30 := 0x0eee
>x
;-------------------------------------------------------------------------------
>o 0 2
*00000424: 00e2 0000 [000 008]  ;  BPL1PTL := 0x0000
 00000428: 0120 0000 [000 00c]  ;  SPR0PTH := 0x0000
>od
Copper debugger enabled.
>x

;------------------------------------------------------------------------------
																				from EAB

																				Copper Debugger:

																				In emulation you can use copper debugger to see copper timing ("od" in debugger)
																				after that "o" shows also vertical and horizontal position.

																				od - btw, remember to enable copper debugger first (od). 
																				o  - Then check copper list (o-command), use it to find line you need DMA details,
																				v  - then use v-command to see exact details.

																				To collect position info.
																				You need (to exit and let) the Amiga run at least one frame after it was
																				enabled to get copper state information. It is not collected when not enabled
																				(even internally) because it would only waste CPU time.
																				And disabling only disables collecting the data, it won't clear the state data.
																				It needs to be enabled manually simply because it means slower emulation.
