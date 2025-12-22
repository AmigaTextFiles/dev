
; Listing19s1.s 
; Logo (Workbench 1.3 Hand) rippen
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

;------------------------------------------------------------------------------
; WinUAE configuration
; Model A500 with ROM file: Kick1.3
; no floppys, no CD & Harddrives
; Start
; WinUAE starts with the Disk "Workbench v1.3" in the hand
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
;------------------------------------------------------------------------------
																				; 1. make some observations
>v-4
DMA debugger enabled, mode=4.
>x																				; we can see copperlist activity on three rasterpositions
																				; yellow color and bitplane data (blue)
																				; copper before and on the end of bitplane data 		
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; 
>e																				; 2. this shows the actual values from current reasterposition	
000 BLTDDAT     0000    106 BPLCON3     0C00
002 DMACONR     03D0    108 BPL1MOD     0000
004 VPOSR       8000    10A BPL2MOD     0000
006 VHPOSR      6903    10C BPLCON4     0011									; 006 VHPOSR      6903	; vertical line $69
00A JOY0DAT     3290    10E CLXCON2     0000
00C JOY1DAT     0000    110 BPL1DAT     0000
00E CLXDAT      8000    112 BPL2DAT     0000
010 ADKCONR     1100    114 BPL3DAT     0000
012 POT0DAT     0000    116 BPL4DAT     0000
014 POT1DAT     0000    118 BPL5DAT     0000
016 POTGOR      0000    11A BPL6DAT     0000
018 SERDATR     0000    11C BPL7DAT     0000
01A DSKBYTR     8000    11E BPL8DAT     0000
01C INTENAR     602C    120 SPR0PTH     0000
01E INTREQR     0040    122 SPR0PTL     0C80
020 DSKPTH      0000    124 SPR1PTH     0000
022 DSKPTL      0000    126 SPR1PTL     0478
024 DSKLEN      4000    128 SPR2PTH     0000
02A VPOSW       8001    12A SPR2PTL     0478
02C VHPOSW      0000    12C SPR3PTH     0000
02E COPCON      0000    12E SPR3PTL     0478
030 SERDAT      010A    130 SPR4PTH     0000
032 SERPER      0174    132 SPR4PTL     0478
034 POTGO       0F00    134 SPR5PTH     0000
036 JOYTEST     0000    136 SPR5PTL     0478
038 STREQU      0000    138 SPR6PTH     0000
03A STRVBL      0000    13A SPR6PTL     0478
03C STRHOR      0000    13C SPR7PTH     0000
03E STRLONG     0000    13E SPR7PTL     0478
040 BLTCON0     07EA    140 SPR0POS     2B3F
042 BLTCON1     2000    142 SPR0CTL     3B01
044 BLTAFWM     3FFF    144 SPR0DATA    0000
046 BLTALWM     C000    146 SPR0DATB    0000
048 BLTCPTH     0000    148 SPR1POS     FE00
04A BLTCPTL     708E    14A SPR1CTL     FF00
04C BLTBPTH     0000    14C SPR1DATA    0000
04E BLTBPTL     195A    14E SPR1DATB    0000
050 BLTAPTH     0000    150 SPR2POS     FE00
052 BLTAPTL     D830    152 SPR2CTL     FF00
054 BLTDPTH     0000    154 SPR2DATA    0000
056 BLTDPTL     708E    156 SPR2DATB    0000
058 BLTSIZE     0284    158 SPR3POS     FE00
05A BLTCON0L    00EA    15A SPR3CTL     FF00
05C BLTSIZV     000A    15C SPR3DATA    0000
05E BLTSIZH     0004    15E SPR3DATB    0000
060 BLTCMOD     FFD0    160 SPR4POS     FE00
062 BLTBMOD     FFF2    162 SPR4CTL     FF00
064 BLTAMOD     0000    164 SPR4DATA    0000
066 BLTDMOD     FFD0    166 SPR4DATB    0000
070 BLTCDAT     0000    168 SPR5POS     FE00
072 BLTBDAT     0707    16A SPR5CTL     FF00
074 BLTADAT     FFFF    16C SPR5DATA    0000
076 BLTDDAT     0000    16E SPR5DATB    0000
07C LISAID      FFFF    170 SPR6POS     FE00
07E DSKSYNC     4489    172 SPR6CTL     FF00
080 COP1LCH     0000    174 SPR6DATA    0000
082 COP1LCL     0420    176 SPR6DATB    0000
084 COP2LCH     0000    178 SPR7POS     FE00
086 COP2LCL     B888    17A SPR7CTL     FF00
088 COPJMP1     0000    17C SPR7DATA    0000
08A COPJMP2     0000    17E SPR7DATB    0000
08C COPINS      0000    180 COLOR00     0FFF
08E DIWSTRT     0581    182 COLOR01     0000
090 DIWSTOP     40C1    184 COLOR02     077C
092 DDFSTRT     0038    186 COLOR03     0BBB
094 DDFSTOP     00D0    188 COLOR04     0000
096 DMACON      03D0    18A COLOR05     0000
098 CLXCON      0000    18C COLOR06     0000
09A INTENA      602C    18E COLOR07     0000
09C INTREQ      0040    190 COLOR08     0000
09E ADKCON      1100    192 COLOR09     0000
0A0 AUD0LCH     0000    194 COLOR10     0000
0A2 AUD0LCL     0000    196 COLOR11     0000
0A4 AUD0LEN     0000    198 COLOR12     0000
0A6 AUD0PER     0004    19A COLOR13     0000
0A8 AUD0VOL     0000    19C COLOR14     0000
0AA AUD0DAT     0000    19E COLOR15     0000
0B0 AUD1LCH     0000    1A0 COLOR16     0000
0B2 AUD1LCL     0000    1A2 COLOR17     0000
0B4 AUD1LEN     0000    1A4 COLOR18     0000
0B6 AUD1PER     0004    1A6 COLOR19     0000
0B8 AUD1VOL     0000    1A8 COLOR20     0000
0BA AUD1DAT     0000    1AA COLOR21     0000
0C0 AUD2LCH     0000    1AC COLOR22     0000
0C2 AUD2LCL     0000    1AE COLOR23     0000
0C4 AUD2LEN     0000    1B0 COLOR24     0000
0C6 AUD2PER     0004    1B2 COLOR25     0000
0C8 AUD2VOL     0000    1B4 COLOR26     0000
0CA AUD2DAT     0000    1B6 COLOR27     0000
0D0 AUD3LCH     0000    1B8 COLOR28     0000
0D2 AUD3LCL     0000    1BA COLOR29     0000
0D4 AUD3LEN     0000    1BC COLOR30     0000
0D6 AUD3PER     0004    1BE COLOR31     0000
0D8 AUD3VOL     0000    1C0 HTOTAL      00FF
0DA AUD3DAT     0000    1C2 HSSTOP      0000
0E0 BPL1PTH     0000    1C4 HBSTRT      0000
0E2 BPL1PTL     644A    1C6 HBSTOP      0000
0E4 BPL2PTH     0000    1C8 VTOTAL      07FF
0E6 BPL2PTL     838A    1CA VSSTOP      0000
0E8 BPL3PTH     0002    1CC VBSTRT      0000
0EA BPL3PTL     1A60    1CE VBSTOP      0000
0EC BPL4PTH     0002    1D0 SPRHSTRT    0000
0EE BPL4PTL     BA60    1D2 SPRHSTOP    0000
0F0 BPL5PTH     0000    1D4 BPLHSTRT    0000
0F2 BPL5PTL     0000    1D6 BPLHSTOP    0000
0F4 BPL6PTH     0000    1D8 HHPOSW      0000
0F6 BPL6PTL     0000    1DA HHPOSR      0003
0F8 BPL7PTH     0000    1DC BEAMCON0    0020
0FA BPL7PTL     0000    1DE HSSTRT      0000
0FC BPL8PTH     0000    1E0 VSSTRT      0000
0FE BPL8PTL     0000    1E2 HCENTER     0000
100 BPLCON0     2200    1E4 DIWHIGH     0000
102 BPLCON1     0000    1FC FMODE       0000
104 BPLCON2     0024    1FE NULL        0000
>
;------------------------------------------------------------------------------
																				; interesting data, but we are in line $69
																				0E0 BPL1PTH     0000    1C4 HBSTRT      0000
																				0E2 BPL1PTL     644A    1C6 HBSTOP      0000
																				0E4 BPL2PTH     0000    1C8 VTOTAL      07FF
																				0E6 BPL2PTL     838A    1CA VSSTOP      0000

																				100 BPLCON0     2200    1E4 DIWHIGH     0000

																				002 DMACONR     03D0    108 BPL1MOD     0000
																				004 VPOSR       8000    10A BPL2MOD     0000

																				08E DIWSTRT     0581    182 COLOR01     0000
																				090 DIWSTOP     40C1    184 COLOR02     077C
																				092 DDFSTRT     0038    186 COLOR03     0BBB
																				094 DDFSTOP     00D0    188 COLOR04     0000
																				; the bitplanepointer are increased with every new rasterposition!
;------------------------------------------------------------------------------
																				; 3. we have to find the true start bitplanepointer adresses
>c
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 0047fc (0047fc) ALARM 000000    CYC=27763C00
B: CRA 00 CRB 80 ICR 00 IM 04 TA ffff (ffff) TB ffff (ffff)
TOD 000068 (00002c) ALARM 000000    CLK=4
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 64/101344
side 0 dma 0 off 3 word A3F6 pt 00000000 len 4000 bytr 8000 adk 1100 sync 0000
DMACON: 03d0 INTENA: e02c (e02c) INTREQ: 8040 (8040) VPOS: 69 HPOS: 1
INT: 8000 IPL: -1
COP1LC: 00000420, COP2LC: 0000b888 COPPTR: 0000b8dc								; Copperlist info
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 0038 DDFSTOP: 00d0
BPLCON 0: 2200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 209260.63 ms [frames: 18553 time: -412554760]
>
;------------------------------------------------------------------------------
																				; 4. copperlist without copper debugger
>o1																				; better with copper debugger data! 
 00000420: 00e0 0000            ;  BPL1PTH := 0x0000
 00000424: 00e2 0000            ;  BPL1PTL := 0x0000
 00000428: 0120 0000            ;  SPR0PTH := 0x0000
 0000042c: 0122 0c80            ;  SPR0PTL := 0x0c80
 00000430: 0124 0000            ;  SPR1PTH := 0x0000
 00000434: 0126 0478            ;  SPR1PTL := 0x0478
 00000438: 0128 0000            ;  SPR2PTH := 0x0000
 0000043c: 012a 0478            ;  SPR2PTL := 0x0478
 00000440: 012c 0000            ;  SPR3PTH := 0x0000
 00000444: 012e 0478            ;  SPR3PTL := 0x0478
 00000448: 0130 0000            ;  SPR4PTH := 0x0000
 0000044c: 0132 0478            ;  SPR4PTL := 0x0478
 00000450: 0134 0000            ;  SPR5PTH := 0x0000
 00000454: 0136 0478            ;  SPR5PTL := 0x0478
 00000458: 0138 0000            ;  SPR6PTH := 0x0000
 0000045c: 013a 0478            ;  SPR6PTL := 0x0478
 00000460: 013c 0000            ;  SPR7PTH := 0x0000
 00000464: 013e 0478            ;  SPR7PTL := 0x0478
 00000468: 0c01 fffe            ;  Wait for vpos >= 0x0c and hpos >= 0x00
                                ;  VP 0c, VE 7f; HP 00, HE fe; BFD 1
 0000046c: 008a 0000            ;  COPJMP2 := 0x0000
>o
 00000470: fffe ffff            ;  NULL := 0xffff
 00000474: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 00000478: fe00 ff00            ;  BLTDDAT := 0xff00
 0000047c: 0000 0000            ;  BLTDDAT := 0x0000
 00000480: 0000 0000            ;  BLTDDAT := 0x0000
 00000484: 0007 fb80            ;  Wait for  hpos & 0x80 >= 0x00
                                ;  VP 00, VE 7b; HP 06, HE 80; BFD 1
 00000488: 0000 0000            ;  BLTDDAT := 0x0000
 0000048c: 0000 0000            ;  BLTDDAT := 0x0000
 ...
 000004bc: 0000 0000            ;  BLTDDAT := 0x0000
>o
 000004c0: 0000 0000            ;  BLTDDAT := 0x0000
 000004c4: 0000 0000            ;  BLTDDAT := 0x0000
 ...
;------------------------------------------------------------------------------
>o 420
 00000420: 00e0 0000            ;  BPL1PTH := 0x0000
 00000424: 00e2 0000            ;  BPL1PTL := 0x0000
 00000428: 0120 0000            ;  SPR0PTH := 0x0000
 0000042c: 0122 0c80            ;  SPR0PTL := 0x0c80
 00000430: 0124 0000            ;  SPR1PTH := 0x0000
 00000434: 0126 0478            ;  SPR1PTL := 0x0478
 00000438: 0128 0000            ;  SPR2PTH := 0x0000
 0000043c: 012a 0478            ;  SPR2PTL := 0x0478
 00000440: 012c 0000            ;  SPR3PTH := 0x0000
 00000444: 012e 0478            ;  SPR3PTL := 0x0478
 00000448: 0130 0000            ;  SPR4PTH := 0x0000
 0000044c: 0132 0478            ;  SPR4PTL := 0x0478
 00000450: 0134 0000            ;  SPR5PTH := 0x0000
 00000454: 0136 0478            ;  SPR5PTL := 0x0478
 00000458: 0138 0000            ;  SPR6PTH := 0x0000
 0000045c: 013a 0478            ;  SPR6PTL := 0x0478
 00000460: 013c 0000            ;  SPR7PTH := 0x0000
 00000464: 013e 0478            ;  SPR7PTL := 0x0478
 00000468: 0c01 fffe            ;  Wait for vpos >= 0x0c and hpos >= 0x00
                                ;  VP 0c, VE 7f; HP 00, HE fe; BFD 1
 0000046c: 008a 0000            ;  COPJMP2 := 0x0000
>o
 00000470: fffe ffff            ;  NULL := 0xffff
 00000474: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 00000478: fe00 ff00            ;  BLTDDAT := 0xff00
 0000047c: 0000 0000            ;  BLTDDAT := 0x0000
 00000480: 0000 0000            ;  BLTDDAT := 0x0000
 00000484: 0007 fb80            ;  Wait for  hpos & 0x80 >= 0x00
                                ;  VP 00, VE 7b; HP 06, HE 80; BFD 1
 00000488: 0000 0000            ;  BLTDDAT := 0x0000
 0000048c: 0000 0000            ;  BLTDDAT := 0x0000
 ...
>
;------------------------------------------------------------------------------
>od																				; 5. enable copper debugger
Copper debugger enabled.	
>o 420																			; here no copper debugger date, because no data
 00000420: 00e0 0000            ;  BPL1PTH := 0x0000							; was collected
 00000424: 00e2 0000            ;  BPL1PTL := 0x0000
 ...
;------------------------------------------------------------------------------
>fs 313																			; 6. so run one frame forward
  D0 00000034   D1 000C61C2   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 FFFFFFFF   D7 00000000
  A0 00FE9716   A1 00C014E2   A2 00000001   A3 00FE86EE
  A4 00001558   A5 00C014B6   A6 00C03AA4   A7 00C014AA
USP  00C014AA ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2c5f (MOVEA) 225f (MOVEA) Chip latch 00000000
00fc072a 2c5f                     movea.l (a7)+ [00c00276],a6
Next PC: 00fc072c
;------------------------------------------------------------------------------
>o 420																			; 7. copperlist with copper debugger info
 00000420: 00e0 0000 [000 008]  ;  BPL1PTH := 0x0000							; Start Copperlist
 00000424: 00e2 0000 [000 00c]  ;  BPL1PTL := 0x0000
 00000428: 0120 0000 [000 010]  ;  SPR0PTH := 0x0000
 0000042c: 0122 0c80 [000 014]  ;  SPR0PTL := 0x0c80
 00000430: 0124 0000 [000 018]  ;  SPR1PTH := 0x0000
 00000434: 0126 0478 [000 01c]  ;  SPR1PTL := 0x0478
 00000438: 0128 0000 [000 020]  ;  SPR2PTH := 0x0000
 0000043c: 012a 0478 [000 024]  ;  SPR2PTL := 0x0478
 00000440: 012c 0000 [000 028]  ;  SPR3PTH := 0x0000
 00000444: 012e 0478 [000 02c]  ;  SPR3PTL := 0x0478
 00000448: 0130 0000 [000 030]  ;  SPR4PTH := 0x0000
 0000044c: 0132 0478 [000 034]  ;  SPR4PTL := 0x0478
 00000450: 0134 0000 [000 038]  ;  SPR5PTH := 0x0000
 00000454: 0136 0478 [000 03c]  ;  SPR5PTL := 0x0478
 00000458: 0138 0000 [000 040]  ;  SPR6PTH := 0x0000
 0000045c: 013a 0478 [000 044]  ;  SPR6PTL := 0x0478
 00000460: 013c 0000 [000 048]  ;  SPR7PTH := 0x0000
 00000464: 013e 0478 [000 04c]  ;  SPR7PTL := 0x0478
 00000468: 0c01 fffe [000 050]  ;  Wait for vpos >= 0x0c and hpos >= 0x00		; wait $0c=12
                                ;  VP 0c, VE 7f; HP 00, HE fe; BFD 1
 0000046c: 008a 0000 [00c 008]  ;  COPJMP2 := 0x0000
 0000b888: Copper jump															; copper jump !	next adress
>o
 0000b888: 2b01 fffe [00c 010]  ;  Wait for vpos >= 0x2b and hpos >= 0x00		; wait $2b=43 
                                ;  VP 2b, VE 7f; HP 00, HE fe; BFD 1
 0000b88c: 0180 0fff [02b 008]  ;  COLOR00 := 0x0fff
 0000b890: 0182 0000 [02b 00c]  ;  COLOR01 := 0x0000
 0000b894: 0184 077c [02b 010]  ;  COLOR02 := 0x077c
 0000b898: 0186 0bbb [02b 014]  ;  COLOR03 := 0x0bbb
 0000b89c: 008e 0581 [02b 018]  ;  DIWSTRT := 0x0581
 0000b8a0: 0100 0200 [02b 01c]  ;  BPLCON0 := 0x0200
 0000b8a4: 0104 0024 [02b 020]  ;  BPLCON2 := 0x0024
 0000b8a8: 0090 40c1 [02b 024]  ;  DIWSTOP := 0x40c1
 0000b8ac: 0092 0038 [02b 028]  ;  DDFSTRT := 0x0038
 0000b8b0: 0094 00d0 [02b 02c]  ;  DDFSTOP := 0x00d0
 0000b8b4: 0102 0000 [02b 030]  ;  BPLCON1 := 0x0000
 0000b8b8: 0108 0000 [02b 034]  ;  BPL1MOD := 0x0000
 0000b8bc: 010a 0000 [02b 038]  ;  BPL2MOD := 0x0000
 0000b8c0: 00e0 0000 [02b 03c]  ;  BPL1PTH := 0x0000
 0000b8c4: 00e2 5ac2            ;  BPL1PTL := 0x5ac2							; BPL1PT = $5ac2
 0000b8c8: 00e4 0000            ;  BPL2PTH := 0x0000
 0000b8cc: 00e6 7a02            ;  BPL2PTL := 0x7a02							; BPL2PT = $7a02
 0000b8d0: 2c01 fffe            ;  Wait for vpos >= 0x2c and hpos >= 0x00		; wait $2c=44
                                ;  VP 2c, VE 7f; HP 00, HE fe; BFD 1
 0000b8d4: 0100 2200            ;  BPLCON0 := 0x2200
>o
 0000b8d8: f401 fffe [02c 00c]  ;  Wait for vpos >= 0xf4 and hpos >= 0x00		; wait $f4=244
                                ;  VP f4, VE 7f; HP 00, HE fe; BFD 1
*0000b8dc: 0100 0200            ;  BPLCON0 := 0x0200
 0000b8e0: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0000b8e4: 0000 0000            ;  BLTDDAT := 0x0000
 0000b8e8: 0000 0000            ;  BLTDDAT := 0x0000
 0000b8ec: 0000 0000            ;  BLTDDAT := 0x0000
 0000b8f0: 0000 0000            ;  BLTDDAT := 0x0000
 0000b8f4: 0007 4710            ;  Wait for  hpos & 0x10 >= 0x00
                                ;  VP 00, VE 47; HP 06, HE 10; BFD 0
 0000b8f8: 0000 0000            ;  BLTDDAT := 0x0000
;------------------------------------------------------------------------------
																				In Zeile $2c (44) wird BPLCON0 auf 2 Bitplanes geschaltet und in Zeile
																				$f4 (244) wieder 0 Bitplanes. Somit sind zwischen Zeile $2c (44) und $f4 (244)
																				2 Bitplanes aktiv. (200 Zeilen) Das Modulo ist BPL1MOD/BPL2MOD is 0.
																				Aus den Screendaten DIWSTRT HH=$81 und DIWSTOP HH=$1c1 kann die Bitplanebreite
																				$1c1-$81=$140 = 320Pixel ermittelt werden. d.h. 40 Bytes

																				Der Abstand der Bitplanepointer aus der Copperlist:
																				BPL2PT = $7a02 - BPL1PT = $5ac2
																				>?$7a02-$5ac2
																				0x00001F40 = %00000000000000000001111101000000 = 8000 = 8000
																				>

																				Umgekehrt kann nun die Bytegröße einer Bitplane aus der Copperliste berechnet
																				werden.	(320*200)/8=8000 Bytes = $1F40
																				>?!320*!200
																				0x0000FA00 = %00000000000000001111101000000000 = 64000 = 64000
																				>?$Fa00/8
																				0x00001F40 = %00000000000000000001111101000000 = 8000 = 8000
																				>
;------------------------------------------------------------------------------
>S Hand $5ac2 !16000															; 2 Bitplanes 2*8000 Bytes
Wrote 00005AC2 - 00009942 (16000 bytes) to 'Hand'.
>
																				; C:\Users\Public\Documents\Amiga Files\WinUAE\
																				; file Hand 16kb
;------------------------------------------------------------------------------
>v $c																			; 8. only for interest dma-debuger
Line: 0C  12 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
                       CPU-RW  RFS0 03A    CPU-WW  RFS1 1FE  COP  08C  RFS2 1FE		; 0000046c: 008a 0000 [00c 008]  ;  COPJMP2 := 0x0000
                         4EF9       *B=  W   00FC        *F      008A
                     00C03A86            00C014A6            0000046C
 4B277000  4B277200  4B277400  4B277600  4B277800  4B277A00  4B277C00  4B277E00

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
 COP  08A  RFS3 1FE  COP  08C    CPU-WW  COP  1FE    CPU-RW  COP  08C    CPU-RW		; 0000b888: 2b01 fffe
     0000                FFFE      072A      FFFF      00FE      2B01      9C3E
 0000046E            00000470  00C014A8  00000472  00C03A88  0000B888  00C03A8A		; o470, o472 wasted
 4B278000  4B278200  4B278400  4B278600  4B278800  4B278A00  4B278C00  4B278E00

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
 COP  08C                                                                CPU-RB
     FFFE                                                                  0000
 0000B888                                                              00C01501
 4B279000  4B279200  4B279400  4B279600  4B279800  4B279A00  4B279C00  4B279E00

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
                                 CPU-WB
                                   0000
                               00C01501
 4B27A000  4B27A200  4B27A400  4B27A600  4B27A800  4B27AA00  4B27AC00  4B27AE00
;------------------------------------------------------------------------------
>v $2b
Line: 2B  43 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
   CPU-RW              CPU-RW  RFS0 03C    CPU-RW  RFS1 1FE  COP  08C  RFS2 1FE
     00FE                86EE        *=  W   00FC        *F      0180
 00C014A2            00C014A4            00C014A6            0000B88C
 49335400  49335600  49335800  49335A00  49335C00  49335E00  49336000  49336200

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
 COP  180  RFS3 1FE  COP  08C    CPU-RW  COP  182    CPU-RW  COP  08C
     0FFF                0182      00FC      0000      072A      0184
 0000B88E            0000B890  00C014A6  0000B892  00C014A8  0000B894
 49336400  49336600  49336800  49336A00  49336C00  49336E00  49337000  49337200

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
 COP  184            COP  08C    CPU-RW  COP  186    CPU-RW  COP  08C
     077C                0186      00C0      0BBB      0276      008E
 0000B896            0000B898  00C014AA  0000B89A  00C014AC  0000B89C
 49337400  49337600  49337800  49337A00  49337C00  49337E00  49338000  49338200

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
 COP  08E    CPU-RW  COP  08C    CPU-RW  COP  100            COP  08C
     0581      00C0      0100      14E2      0200                0104
 0000B89E  00C014AE  0000B8A0  00C014B0  0000B8A2            0000B8A4
 49338400  49338600  49338800  49338A00  49338C00  49338E00  49339000  49339200

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
 COP  104            COP  08C    CPU-RB  COP  090            COP  08C
     0024                0090      0081  (   40C1                0092
 0000B8A6            0000B8A8  00C01500  0000B8AA            0000B8AC
 49339400  49339600  49339800  49339A00  49339C00  49339E00  4933A000  4933A200

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
 COP  092            COP  08C            COP  094            COP  08C    CPU-RB
     0038                0094                00D0                0102      0000
 0000B8AE            0000B8B0            0000B8B2            0000B8B4  00C01501
 4933A400  4933A600  4933A800  4933AA00  4933AC00  4933AE00  4933B000  4933B200

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
 COP  102            COP  08C            COP  108            COP  08C    CPU-RW
     0000                0108                0000                010A      00FE
 0000B8B6            0000B8B8            0000B8BA            0000B8BC  00C014B2
 4933B400  4933B600  4933B800  4933BA00  4933BC00  4933BE00  4933C000  4933C200

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  10A    CPU-RW  COP  08C            COP  0E0            COP  08C
 0   0000      8646      00E0                0000                00E2
 0000B8BE  00C014B4  0000B8C0            0000B8C2            0000B8C4
 4933C400  4933C600  4933C800  4933CA00  4933CC00  4933CE00  4933D000  4933D200

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 COP  0E2            COP  08C            COP  0E4            COP  08C    CPU-RW
     5AC2                00E4                0000                00E6      0000		; COP  0E2 = $5AC2	BPLPT0
 0000B8C6            0000B8C8            0000B8CA            0000B8CC  00C01502
 4933D400  4933D600  4933D800  4933DA00  4933DC00  4933DE00  4933E000  4933E200

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
 COP  0E6    CPU-RW  COP  08C            COP  08C
     7A02      0000      2C01                FFFE									; COP  0E6 = $7A02	BPLPT1
 0000B8CE  00C01504  0000B8D0            0000B8D0
 4933E400  4933E600  4933E800  4933EA00  4933EC00  4933EE00  4933F000  4933F200
;------------------------------------------------------------------------------
>v 0 0
Line: 00   0 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
   CPU-RW              CPU-RW  RFS0 038  COP  1FE  RFS1 1FE  COP  08C  RFS2 1FE
     0001                00FE        *B      0000        *F      00E0
 00C014A0            00C014A2            0000B8E4            00000420
 AA967400  AA967600  AA967800  AA967A00  AA967C00  AA967E00  AA968000  AA968200

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]
 COP  0E0  RFS3 1FE  COP  08C    CPU-RW  COP  0E2    CPU-RW  COP  08C
     0000                00E2      86EE      0000      00FC      0120
 00000422            00000424  00C014A4  00000426  00C014A6  00000428
 AA968400  AA968600  AA968800  AA968A00  AA968C00  AA968E00  AA969000  AA969200

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
 COP  120            COP  08C            COP  122    CPU-WW  COP  08C
     0000  I             0122                0C80      9C94      0124
 0000042A            0000042C            0000042E  00C7FFFE  00000430
 AA969400  AA969600  AA969800  AA969A00  AA969C00  AA969E00  AA96A000  AA96A200

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
 COP  124            COP  08C    CPU-WW  COP  126    CPU-WW  COP  08C    CPU-RW
     0000                0126      0000      0478      00FE      0128      00FC
 00000432            00000434  00C7FFFA  00000436  00C7FFFC  00000438  0000006C
 AA96A400  AA96A600  AA96A800  AA96AA00  AA96AC00  AA96AE00  AA96B000  AA96B200

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
 COP  128    CPU-RW  COP  08C            COP  12A            COP  08C
     0000      0D14      012A            (   0478                012C
 0000043A  0000006E  0000043C            0000043E            00000440
 AA96B400  AA96B600  AA96B800  AA96BA00  AA96BC00  AA96BE00  AA96C000  AA96C200

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
 COP  12C            COP  08C    CPU-WW  COP  12E    CPU-WW  COP  08C    CPU-WW
     0000                012E      3AA4      0478      00C0      0130      14B6
 00000442            00000444  00C7FFF8  00000446  00C7FFF6  00000448  00C7FFF4
 AA96C400  AA96C600  AA96C800  AA96CA00  AA96CC00  AA96CE00  AA96D000  AA96D200

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]
 COP  130    CPU-WW  COP  08C    CPU-WW  COP  132    CPU-WW  COP  08C    CPU-WW
     0000      00C0      0132      14E2      0478      00C0      0134      9716
 0000044A  00C7FFF2  0000044C  00C7FFF0  0000044E  00C7FFEE  00000450  00C7FFEC
 AA96D400  AA96D600  AA96D800  AA96DA00  AA96DC00  AA96DE00  AA96E000  AA96E200

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
 COP  134    CPU-WW  COP  08C    CPU-WW  COP  136    CPU-WW  COP  08C    CPU-WW
     0000      00FE      0136      61C2      0478      000C      0138      0034
 00000452  00C7FFEA  00000454  00C7FFE8  00000456  00C7FFE6  00000458  00C7FFE4
 AA96E400  AA96E600  AA96E800  AA96EA00  AA96EC00  AA96EE00  AA96F000  AA96F200

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
 COP  138    CPU-WW  COP  08C            COP  13A            COP  08C
     0000      0000      013A                0478                013C
 0000045A  00C7FFE2  0000045C            0000045E            00000460
 AA96F400  AA96F600  AA96F800  AA96FA00  AA96FC00  AA96FE00  AA970000  AA970200

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
 COP  13C            COP  08C            COP  13E    CPU-RW  COP  08C    CPU-RW
     0000                013E                0478      00C0      0C01      0276
 00000462            00000464            00000466  00000004  00000468  00000006
 AA970400  AA970600  AA970800  AA970A00  AA970C00  AA970E00  AA971000  AA971200
;------------------------------------------------------------------------------
>vo																				; finish
DMA debugger disabled
>od
Copper debugger disabled.
>x
