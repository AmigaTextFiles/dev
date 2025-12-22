
; Listing19l4.s
; Copper Debugger, Copper Tracing, Copper Breakpoint, DMA-Debugger
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

;  o <0-2|addr> [<lines>] View memory as Copper instructions.
;  od                    Enable/disable Copper vpos/hpos tracing.
;  ot                    Copper single step trace.
;  ob <addr>             Copper breakpoint.

;------------------------------------------------------------------------------
; source from the danish-asm-course

start:

waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	waitmouse	

	move.w #$4000,$dff09a		; Interrupts disable
	lea.l	copperlist,a1		; start up our own copper list.
	move.l	a1,$dff080			; COP1LCH		
	move.w	#$8080,$dff096		; DMACON		

;WaitWblank:
waitmouse2:
	cmp.b	#$8F,$dff006		; vhposr - wait for line 144
	bne.s	waitmouse2			; WaitWblank
;Aspetta:
;	cmp.b	#$8F,$dff006		; vhposr - noch Zeile 144?
;	beq.s	Aspetta
	nop						

somethingtodo:					; some work in line $8F, $90, ...
	move.b	#0,d0
	move.l	#0,d0	

	lea	Table,a0				; 12 cycles
	movem.l	(a0)+,d3-d7/a3-a6	; 84(21/0)		; 42 cycles 5*42=210
	movem.l	(a0)+,d3-d7/a3-a6
	movem.l	(a0)+,d3-d7/a3-a6
	movem.l	(a0)+,d3-d7/a3-a6
	movem.l	(a0)+,d3-d7/a3-a6
	movem.l	(a0)+,d3-d7/a3-a6


	btst	#2,$dff016			; right mousebutton?
	bne.s	waitmouse2		 

	move.w	#$0080,$dff096		; DMACON		retrieving the old copper 
								; settings back (as to reactivate the workbench) and
	move.l	$04,a6				; start the copper.
	move.l	156(a6),a1					
	move.l	38(a1),$dff080		; COP1LCH		
	move.w	#$81a0,$dff096		; DMACON	

	nop	
	move.w #$C000,$dff09a		; Interrupts enable
	rts

copperlist:						
	dc.w	$9001,$fffe
	dc.w	$0180,$0f00
	dc.w	$a001,$fffe
	dc.w	$0180,$0fff
	dc.w	$0180,$000f
	dc.w	$aa01,$fffe
	dc.w	$0180,$0fff
	dc.w	$ae01,$fffe
	dc.w	$0180,$0f00
	dc.w	$be01,$fffe
	dc.w	$0180,$0000
	dc.w	$ffff,$fffe				
	
Table:
	blk.w 1200,$FFFF	
				
	end


;------------------------------------------------------------------------------
>r
Filename:Listing19l3.s
>a
Pass1
Pass2
No Errors
>j

																				; start the programm
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12

>d pc 15																				; programm disassembled
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
000350E4 4e71                     NOP
000350E6 103c 0000                MOVE.B #$00,D0
000350EA 203c 0000 0000           MOVE.L #$00000000,D0
000350F0 41f9 0003 517a           LEA.L $0003517a,A0
000350F6 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
000350FA 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
000350FE 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
00035102 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
00035106 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
0003510A 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
0003510E 0839 0002 00df f016      BTST.B #$0002,$00dff016
00035116 66c2                     BNE.B #$c2 == $000350da (T)
00035118 33fc 0080 00df f096      MOVE.W #$0080,$00dff096
00035120 2c79 0000 0004           MOVEA.L $00000004 [00c00276],A6
00035126 226e 009c                MOVEA.L (A6,$009c) == $0000009b [4200fc08],A1
0003512A 23e9 0026 00df f080      MOVE.L (A1,$0026) == $0003516c [0f00be01],$00dff080
00035132 33fc 81a0 00df f096      MOVE.W #$81a0,$00dff096
0003513A 4e71                     NOP
0003513C 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
00035144 4e75                     RTS
;------------------------------------------------------------------------------
>m 3517a																				; label table,a0	(LEA.L $0003517a,A0)
0003517A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003518A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003519A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000351AA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000351BA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000351CA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000351DA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000351EA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000351FA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003520A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003521A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003522A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003523A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003524A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003525A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003526A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003527A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003528A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0003529A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000352AA FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
;------------------------------------------------------------------------------
>v -4																					; visual DMA-Debugger ; cycle exact mode has to be enabled
DMA debugger enabled, mode=4.
>x																						
;------------------------------------------------------------------------------
																						; open the Debugger with Shift+F12

																						; we are interested in this line from copperlist
																						; dc.w	$9001,$fffe																	
																						; dc.w	$0180,$0f00			
																						; dc.w	$a001,$fffe	
;------------------------------------------------------------------------------
>v $90																					; analyze line $90 with DMA-Debugger	
Line: 90 144 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7]
   CPU-RW  RFS  1FE  COP  08C  RFS  1FE  COP  180  RFS  1FE  COP  08C    CPU-RW
 W   FFFF      FFFF      0180      FFFF      0F00      FFFF      A001      FFFF			; COP: dc.w	$0180,$0f00	
 00035228            0003514A            0003514C            0003514E  0003522A
 071E2C00  071E2E00  071E3000  071E3200  071E3400  071E3600  071E3800  071E3A00

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]		
 COP  08C    CPU-RW              CPU-RW              CPU-RW              CPU-RW			; COP: dc.w	$a001,$fffe	
     FFFE      FFFF                FFFF                78F8                0839			; 0003510E 0839 0002 00df f016      BTST.B #$0002,$00dff016
 00035150  0003522C            0003522E            0003510C            0003510E			; Cycles: 42 Chip, 84 CPU. (V=144 H=15 -> V=144 H=57)
 071E3C00  071E3E00  071E4000  071E4200  071E4400  071E4600  071E4800  071E4A00			; see below (search for: V=144 H=15)
																						; 0003510A 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW			; all MOVEM.L (A0)+,D3-D7/A3-A6
               FFFF                FFFF                FFFF                FFFF			; copies $FFFF from table
           0003522E            00035230            00035232            00035234			; from 3522E - 4 words
 071E4C00  071E4E00  071E5000  071E5200  071E5400  071E5600  071E5800  071E5A00			

 [18  24]  [19  25]  [1A  26]  [1B  27]  [1C  28]  [1D  29]  [1E  30]  [1F  31]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               FFFF                FFFF                FFFF                FFFF
           00035236            00035238            0003523A            0003523C			; 3523A, 3523C increasing addresses
 071E5C00  071E5E00  071E6000  071E6200  071E6400  071E6600  071E6800  071E6A00

 [20  32]  [21  33]  [22  34]  [23  35]  [24  36]  [25  37]  [26  38]  [27  39]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               FFFF                FFFF                FFFF                FFFF
           0003523E            00035240            00035242            00035244
 071E6C00  071E6E00  071E7000  071E7200  071E7400  071E7600  071E7800  071E7A00

 [28  40]  [29  41]  [2A  42]  [2B  43]  [2C  44]  [2D  45]  [2E  46]  [2F  47]
             CPU-RW              CPU-RW              CPU-RW              CPU-RW
               FFFF                FFFF                FFFF                FFFF
           00035246            00035248            0003524A            0003524C
 071E7C00  071E7E00  071E8000  071E8200  071E8400  071E8600  071E8800  071E8A00

 [30  48]  [31  49]  [32  50]  [33  51]  [34  52]  [35  53]  [36  54]  [37  55]			; 0003510E 0839 0002 00df f016      BTST.B #$0002,$00dff016
             CPU-RW              CPU-RW              CPU-RW              CPU-RW			; Cycles: 42 Chip, 84 CPU. (V=144 H=15 -> V=144 H=57)
               FFFF                FFFF                FFFF                0002
           0003524E            00035250            00035252            00035110
 071E8C00  071E8E00  071E9000  071E9200  071E9400  071E9600  071E9800  071E9A00

 [38  56]  [39  57]  [3A  58]  [3B  59]  [3C  60]  [3D  61]  [3E  62]  [3F  63]
             CPU-RW              CPU-RW              CPU-RW              CPU-RB
               00DF                F016                66C2                0005			; 00035116 66c2                     BNE.B #$c2 == $000350da (T)
           00035112            00035114            00035116            00DFF016
 071E9C00  071E9E00  071EA000  071EA200  071EA400  071EA600  071EA800  071EAA00

 [40  64]  [41  65]  [42  66]  [43  67]  [44  68]  [45  69]  [46  70]  [47  71]
             CPU-RW                        CPU-RW              CPU-RW
               33FC                          0C39                008F					; 000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
           00035118                      000350DA            000350DC
 071EAC00  071EAE00  071EB000  071EB200  071EB400  071EB600  071EB800  071EBA00

 [48  72]  [49  73]  [4A  74]  [4B  75]  [4C  76]  [4D  77]  [4E  78]  [4F  79]
   CPU-RW              CPU-RW              CPU-RW              CPU-RB
     00DF                F006                66F6                0090
 000350DE            000350E0            000350E2            00DFF006
 071EBC00  071EBE00  071EC000  071EC200  071EC400  071EC600  071EC800  071ECA00
;------------------------------------------------------------------------------
>d pc
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
000350E4 4e71                     NOP
000350E6 103c 0000                MOVE.B #$00,D0
000350EA 203c 0000 0000           MOVE.L #$00000000,D0
000350F0 41f9 0003 517a           LEA.L $0003517a,A0
000350F6 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
000350FA 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
000350FE 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
00035102 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
00035106 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6

;------------------------------------------------------------------------------
																					; now analyze Copper with >c, >ot, >o1
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002122 (001d9f) ALARM 000000    CYC=09BC9000
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044bfc (000000) ALARM 0000ac    CLK=2
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: d2 HPOS: 4				; line 210 (VPOS: $d2)
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 0003517a
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00			; first interesting adress from copperlist
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1				; so we make a copper-breakpoint on this 	
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00								; adress --> ob 35146	
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff            ;  COLOR00 := 0x0fff
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff            ;  COLOR00 := 0x0fff
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000            ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
*0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe			; we reached end of copperlist
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1				; this is the data area (LEA.L $0003517a,A0)
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
>
;------------------------------------------------------------------------------
>ob 35146																			; Copper Breakpoint on 00035146: 9001 fffe
Copper breakpoint @0x00035146														; on adress with copper wait instruction	
>
;------------------------------------------------------------------------------
>g																					; run
Cycles: 56065 Chip, 112130 CPU. (V=210 H=4 -> V=144 H=0)							; we run to VPOS=144 = $90
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 0003522E   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 78f8 (MOVE) 4cd8 (MVMEL) Chip latch 000078F8
00035106 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
0003510A 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
Next PC: 0003510e

;------------------------------------------------------------------------------
																					; now analyze Copper with >c, >ot, >o1
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00			; with breakpoint we stand here
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1				
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00								; look above DMA-Debugger
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00			; look above DMA-Debugger
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
*00035152: 0180 0fff            ;  COLOR00 := 0x0fff								; but the COPPTR stands here
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff            ;  COLOR00 := 0x0fff
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000            ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
>

;------------------------------------------------------------------------------
>d pc																			; program stands here
0003510A 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
0003510E 0839 0002 00df f016      BTST.B #$0002,$00dff016
00035116 66c2                     BNE.B #$c2 == $000350da (F)
00035118 33fc 0080 00df f096      MOVE.W #$0080,$00dff096
00035120 2c79 0000 0004           MOVEA.L $00000004 [00c00276],A6
00035126 226e 009c                MOVEA.L (A6,$009c) == $0000009b [4200fc08],A1
0003512A 23e9 0026 00df f080      MOVE.L (A1,$0026) == $0003516c [0f00be01],$00dff080
00035132 33fc 81a0 00df f096      MOVE.W #$81a0,$00dff096
0003513A 4e71                     NOP
0003513C 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
;------------------------------------------------------------------------------
>t																				; current instruction MOVEM.L (A0)+,D3-D7/A3-A6
Cycles: 42 Chip, 84 CPU. (V=144 H=15 -> V=144 H=57)								; next command would be
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF							; see above DMA-Debugger
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 0839 (BTST) Chip latch 00000002
0003510E 0839 0002 00df f016      BTST.B #$0002,$00dff016						; next instruction
Next PC: 00035116
;------------------------------------------------------------------------------
>t
Cycles: 10 Chip, 20 CPU. (V=144 H=57 -> V=144 H=67)								; next command would be	
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF							; see above DMA-Debugger
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 66c2 (Bcc) Chip latch 000033FC
00035116 66c2                     BNE.B #$c2 == $000350da (T)					; next instruction
Next PC: 00035118
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0B731800
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044cf3 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: 90 HPOS: 43			; HPOS=43? =>	$43=67d
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 00035152
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=144 H=67 -> V=144 H=72)								; next command would be
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF							; see above DMA-Debugger
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 008f (ILLEGAL) 0c39 (CMP) Chip latch 0000008F
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
Next PC: 000350e2
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0B732200
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044cf3 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: 90 HPOS: 48			; HPOS=48? =>	$48=72d
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 00035152								; COPPTR: 00035152
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done to the next copper-wait?

>ot
Cycles: 3560 Chip, 7120 CPU. (V=144 H=72 -> V=160 H=0)							; V=160	==> $A0
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00		; program stands here	
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff            ;  COLOR00 := 0x0fff
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
*0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00		; COPPTR stands here
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff            ;  COLOR00 := 0x0fff
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000            ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0B8F0400
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044d03 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: a0 HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 0003515a								; COPPTR: 0003515a
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done to the next copper-wait?

>ot
Cycles: 899 Chip, 1798 CPU. (V=160 H=9 -> V=164 H=0)							; V=164=$A4
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff            ;  COLOR00 := 0x0fff
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00		; program stands here
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
*00035162: 0180 0fff            ;  COLOR00 := 0x0fff							; COPPTR stands here	
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000            ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0B961C00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044d07 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: a4 HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 00035162								; COPPTR: 00035162
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
; ot - run to next copper-instruction
; how many cycles are done ton next copper-wait?

>ot
Cycles: 1353 Chip, 2706 CPU. (V=164 H=9 -> V=170 H=0)							; V=170 = $AA
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff            ;  COLOR00 := 0x0fff
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00		; program stands here
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff            ;  COLOR00 := 0x0fff
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
*0003516a: 0180 0f00            ;  COLOR00 := 0x0f00							; COPPTR stands here
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000            ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0BA0C000
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044d0d (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: aa HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 0003516a								; COPPTR: 0003516a
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done ton next copper-wait?

>ot
Cycles: 899 Chip, 1798 CPU. (V=170 H=9 -> V=174 H=0)							; V=174 = $AE
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff            ;  COLOR00 := 0x0fff
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff            ;  COLOR00 := 0x0fff
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00		; program stands here
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
*00035172: 0180 0000            ;  COLOR00 := 0x0000							; COPPTR stands here	
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0BA7D800
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044d11 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: ae HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 00035172								; COPPTR: 00035172
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done ton next copper-wait?

>ot
Cycles: 3623 Chip, 7246 CPU. (V=174 H=9 -> V=190 H=0)							; VPOS=190 = $BE
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe            ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003514e: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff            ;  COLOR00 := 0x0fff
 00035156: a401 fffe            ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f            ;  COLOR00 := 0x000f
 0003515e: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff            ;  COLOR00 := 0x0fff
 00035166: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00            ;  COLOR00 := 0x0f00
 0003516e: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00		; program stands here
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000            ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
*0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe		; COPPTR stands here
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002123 (001d9f) ALARM 000000    CYC=0BC43800
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044d21 (000000) ALARM 0000ac    CLK=3
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: be HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 0003517a								; COPPTR: 0003517a
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done to next copper-wait?

>ot
Cycles: 60600 Chip, 121200 CPU. (V=190 H=9 -> V=144 H=0)						; we are back on line VPOS=144 = $90
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 0003522E   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 78f8 (MOVE) 4cd8 (MVMEL) Chip latch 000078F8
00035106 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
0003510A 4cd8 78f8                MOVEM.L (A0)+,D3-D7/A3-A6
Next PC: 0003510e
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe [090 000]  ;  Wait for vpos >= 0x90 and hpos >= 0x00		; program stands again here
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00 [090 004]  ;  COLOR00 := 0x0f00
 0003514e: a001 fffe [0a0 000]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
*00035152: 0180 0fff [0a0 004]  ;  COLOR00 := 0x0fff
 00035156: a401 fffe [0a4 000]  ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f [0a4 004]  ;  COLOR00 := 0x000f
 0003515e: aa01 fffe [0aa 000]  ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff [0aa 004]  ;  COLOR00 := 0x0fff
 00035166: ae01 fffe [0ae 000]  ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00 [0ae 004]  ;  COLOR00 := 0x0f00
 0003516e: be01 fffe [0be 000]  ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000 [0be 004]  ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe		; end of copperprogram
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe		; COPPTR: 0003517a --> never reached
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002124 (001d9f) ALARM 000000    CYC=0D9DC600
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044e2c (000000) ALARM 0000ac    CLK=4
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: 90 HPOS: f
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 00035152								; COPPTR: 00035152
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done ton next copper-wait?
>ot
Cycles: 3617 Chip, 7234 CPU. (V=144 H=15 -> V=160 H=0)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe [090 000]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00 [090 004]  ;  COLOR00 := 0x0f00
 0003514e: a001 fffe [0a0 000]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff [0a0 004]  ;  COLOR00 := 0x0fff
 00035156: a401 fffe [0a4 000]  ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
*0003515a: 0180 000f [0a4 004]  ;  COLOR00 := 0x000f
 0003515e: aa01 fffe [0aa 000]  ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 00035162: 0180 0fff [0aa 004]  ;  COLOR00 := 0x0fff
 00035166: ae01 fffe [0ae 000]  ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00 [0ae 004]  ;  COLOR00 := 0x0f00
 0003516e: be01 fffe [0be 000]  ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000 [0be 004]  ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002124 (001d9f) ALARM 000000    CYC=0DBA1A00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044e3c (000000) ALARM 0000ac    CLK=4
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: a0 HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 0003515a
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

;------------------------------------------------------------------------------
																				; ot - run to next copper-instruction
																				; how many cycles are done ton next copper-wait?
>ot
Cycles: 899 Chip, 1798 CPU. (V=160 H=9 -> V=164 H=0)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00035252   A1 00035146   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C63CE8
USP  00C63CE8 ISP  00C64CE8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 66f6 (Bcc) Chip latch 00004E71
000350DA 0c39 008f 00df f006      CMP.B #$8f,$00dff006
000350E2 66f6                     BNE.B #$f6 == $000350da (T)
Next PC: 000350e4
;------------------------------------------------------------------------------
>o 1
 00035146: 9001 fffe [090 000]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 0003514a: 0180 0f00 [090 004]  ;  COLOR00 := 0x0f00
 0003514e: a001 fffe [0a0 000]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 00035152: 0180 0fff [0a0 004]  ;  COLOR00 := 0x0fff
 00035156: a401 fffe [0a4 000]  ;  Wait for vpos >= 0xa4 and hpos >= 0x00
                                ;  VP a4, VE 7f; HP 00, HE fe; BFD 1
 0003515a: 0180 000f [0a4 004]  ;  COLOR00 := 0x000f
 0003515e: aa01 fffe [0aa 000]  ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
*00035162: 0180 0fff [0aa 004]  ;  COLOR00 := 0x0fff
 00035166: ae01 fffe [0ae 000]  ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 0003516a: 0180 0f00 [0ae 004]  ;  COLOR00 := 0x0f00
 0003516e: be01 fffe [0be 000]  ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00035172: 0180 0000 [0be 004]  ;  COLOR00 := 0x0000
 00035176: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0003517a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003517e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035182: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035186: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0003518e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00035192: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 002124 (001d9f) ALARM 000000    CYC=0DC13200
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 044e40 (000000) ALARM 0000ac    CLK=4
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 4 word 2182 pt 00000000 len 4000 bytr 0000 adk 1100 sync 0000
DMACON: 03f0 INTENA: a02c (a02c) INTREQ: 8068 (8068) VPOS: a4 HPOS: 9
INT: 8028 IPL: -1
COP1LC: 00035146, COP2LC: 0001f280 COPPTR: 00035162
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 173533.89 ms [frames: 6638 time: 1151917963]
>

