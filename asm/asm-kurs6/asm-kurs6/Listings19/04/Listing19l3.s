
; Listing19l3.s
; Copper Debugger, Copper Tracing, Copper Breakpoint
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

	move.w	#$0080,$dff096		; DMACON		Retrieving the old copper 
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
Filename:Listing19l4.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
>o1 4
 00000420: 0180 005a            ;  COLOR00 := 0x005a							
 00000424: 00e2 0000            ;  BPL1PTL := 0x0000
 00000428: 0120 0000            ;  SPR0PTH := 0x0000
 0000042c: 0122 0c80            ;  SPR0PTL := 0x0c80							; if copperlist without VPOS/HPOS-information
;------------------------------------------------------------------------------		
>od
Copper debugger enabled.
>fs 400																			; run more than one frame forward	
;------------------------------------------------------------------------------
>o1
 00000420: 0180 005a [000 008]  ;  COLOR00 := 0x005a							; now copperlist with VPOS/HPOS-information
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
 00000468: 0c01 fffe [000 050]  ;  Wait for vpos >= 0x0c and hpos >= 0x00
                                ;  VP 0c, VE 7f; HP 00, HE fe; BFD 1
 0000046c: 008a 0000 [00c 008]  ;  COPJMP2 := 0x0000
 0001ed50: Copper jump		
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 000daa (000daa) ALARM 000000    CYC=D71E9400
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 0000bf (000000) ALARM 000082    CLK=3
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 7 word 2D6D pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 03f0 INTENA: 602c (602c) INTREQ: 0040 (0040) VPOS: c0 HPOS: e
INT: 0000 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001ede4
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 947479.24 ms [frames: 1835 time: 1738624397]
>	
;------------------------------------------------------------------------------	
>g																				; run and then press left mouse button
																				; "norwegian flag" is visible on screen
;------------------------------------------------------------------------------
																				; Shift+F12
																			    ; Debugger waits here	
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=1 C=1 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 4e71 (NOP) Chip latch 00000000
0002157a 66f6                     bne.b #$f6 == $00021572 (T)
Next PC: 0002157c
;------------------------------------------------------------------------------
>o1																				; copperlist
 000215de: 9001 fffe [000 008]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
*000215e2: 0180 0f00            ;  COLOR00 := 0x0f00
 000215e6: a001 fffe            ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 000215ea: 0180 0fff            ;  COLOR00 := 0x0fff
 000215ee: 0180 000f            ;  COLOR00 := 0x000f
 000215f2: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 000215f6: 0180 0fff            ;  COLOR00 := 0x0fff
 000215fa: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 000215fe: 0180 0f00            ;  COLOR00 := 0x0f00
 00021602: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00021606: 0180 0000            ;  COLOR00 := 0x0000
 0002160a: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0002160e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021612: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021616: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0002161a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0002161e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021622: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021626: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0002162a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
>
;------------------------------------------------------------------------------
																				; Copper tracing
>ot
Cycles: 8862 Chip, 17724 CPU. (V=105 H=4 -> V=144 H=13)							; 105 = $69	(V=105 H=4)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216C2   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 78f8 (MOVE) Chip latch 0000FFFE
000215a2 4cd8 78f8                movem.l (a0)+,d3-d7/a3-a6
Next PC: 000215a6
;------------------------------------------------------------------------------
>ot
Cycles: 3622 Chip, 7244 CPU. (V=144 H=23 -> V=160 H=13)							; 144 = $90 (V=144 H=23)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF							
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 4e71 (NOP) Chip latch 0000000F
0002157a 66f6                     bne.b #$f6 == $00021572 (T)
Next PC: 0002157c
;------------------------------------------------------------------------------
>ot
Cycles: 5 Chip, 10 CPU. (V=160 H=13 -> V=160 H=18)								; 160 = $A0 (V=160 H=13)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 0000FFFE
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
;------------------------------------------------------------------------------
>ot
Cycles: 2260 Chip, 4520 CPU. (V=160 H=18 -> V=170 H=8)							; 160 = $A0 (V=160 H=18)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 4e71 (NOP) Chip latch 00000180
0002157a 66f6                     bne.b #$f6 == $00021572 (T)
Next PC: 0002157c
;------------------------------------------------------------------------------
>ot
Cycles: 5 Chip, 10 CPU. (V=170 H=8 -> V=170 H=13)								; 170 = $AA (V=170 H=8)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 0000FFFE
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
;------------------------------------------------------------------------------
>ot
Cycles: 900 Chip, 1800 CPU. (V=170 H=13 -> V=174 H=5)							; 170 = $AA (V=170 H=13)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 0000FFFE
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
;------------------------------------------------------------------------------
>ot
Cycles: 8 Chip, 16 CPU. (V=174 H=5 -> V=174 H=13)								; 174 = $AE (V=174 H=5)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 4e71 (NOP) Chip latch 0000FFFE
0002157a 66f6                     bne.b #$f6 == $00021572 (T)
Next PC: 0002157c
;------------------------------------------------------------------------------
>ot
Cycles: 3630 Chip, 7260 CPU. (V=174 H=15 -> V=190 H=13)							; 174 = $AE (V=174 H=15)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 4e71 (NOP) Chip latch 0000FFFE
0002157a 66f6                     bne.b #$f6 == $00021572 (T)
Next PC: 0002157c
;------------------------------------------------------------------------------
>ot
Cycles: 27920 Chip, 55840 CPU. (V=190 H=13 -> V=0 H=12)							; 190 = $be (V=190 H=13)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=1 C=1 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 0000FFFE
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
;------------------------------------------------------------------------------
>ot
Cycles: 32689 Chip, 65378 CPU. (V=0 H=12 -> V=144 H=13)							; 0 (V=0 H=12)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216C2   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 78f8 (MOVE) Chip latch 0000FFFE
000215a2 4cd8 78f8                movem.l (a0)+,d3-d7/a3-a6
Next PC: 000215a6
;------------------------------------------------------------------------------
>ot
Cycles: 3612 Chip, 7224 CPU. (V=144 H=26 -> V=160 H=6)							; 144 = $90 (V=144 H=26)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 0000FFFE
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
>
;------------------------------------------------------------------------------
>o1
 000215de: 9001 fffe [000 008]  ;  Wait for vpos >= 0x90 and hpos >= 0x00		; 144 = $90 (current position)
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 000215e2: 0180 0f00 [090 008]  ;  COLOR00 := 0x0f00
 000215e6: a001 fffe [090 00c]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
*000215ea: 0180 0fff            ;  COLOR00 := 0x0fff							; * CPPTR stands here
 000215ee: 0180 000f            ;  COLOR00 := 0x000f
 000215f2: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 000215f6: 0180 0fff            ;  COLOR00 := 0x0fff
 000215fa: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00		; 215fa
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 000215fe: 0180 0f00            ;  COLOR00 := 0x0f00
 00021602: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00021606: 0180 0000            ;  COLOR00 := 0x0000
 0002160a: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0002160e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
;------------------------------------------------------------------------------
>ob 215fa																		; Copper-Breakpoint
Copper breakpoint @0x000215fa
;------------------------------------------------------------------------------
>g
Cycles: 5892 Chip, 11784 CPU. (V=144 H=23 -> V=170 H=13)						; stops here: V=170 H=13 (170 = $AA)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 0000FFFE
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
;------------------------------------------------------------------------------
>o1
 000215de: 9001 fffe [000 008]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 000215e2: 0180 0f00 [090 008]  ;  COLOR00 := 0x0f00
 000215e6: a001 fffe [090 00c]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 000215ea: 0180 0fff [0a0 008]  ;  COLOR00 := 0x0fff
 000215ee: 0180 000f [0a0 00c]  ;  COLOR00 := 0x000f
 000215f2: aa01 fffe [0a0 010]  ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 000215f6: 0180 0fff [0aa 008]  ;  COLOR00 := 0x0fff
 000215fa: ae01 fffe [0aa 00c]  ;  Wait for vpos >= 0xae and hpos >= 0x00		; current copper breakpoint position
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
*000215fe: 0180 0f00            ;  COLOR00 := 0x0f00							; * CPPTR stands here
 00021602: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00021606: 0180 0000            ;  COLOR00 := 0x0000
 0002160a: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0002160e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR ec IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 001e33 (000e41) ALARM 000000    CYC=B1665400
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 137f8b (000000) ALARM 000082    CLK=1
DEBUG: drive 0 motor off cylinder  2 sel no ro mfmpos 0/101344
side 0 dma 0 off 8 word 5ADB pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 03f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: aa HPOS: d
INT: 0028 IPL: -1
COP1LC: 000215de, COP2LC: 0001ed50 COPPTR: 000215fe								; COPPTR: 000215fe
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 422123.63 ms [frames: 6066 time: -1734365355]
;------------------------------------------------------------------------------
>ob 215e6
Copper breakpoint @0x000215e6
;------------------------------------------------------------------------------
>g
Cycles: 65149 Chip, 130298 CPU. (V=170 H=13 -> V=144 H=13)						; stops here: V=144 H=13 (144 = $90)	
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216C2   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 78f8 (MOVE) Chip latch 0000FFFE
000215a2 4cd8 78f8                movem.l (a0)+,d3-d7/a3-a6
Next PC: 000215a6
;------------------------------------------------------------------------------
>o1
 000215de: 9001 fffe [000 008]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 000215e2: 0180 0f00 [090 008]  ;  COLOR00 := 0x0f00
 000215e6: a001 fffe [090 00c]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00		; current copper breakpoint position
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
*000215ea: 0180 0fff            ;  COLOR00 := 0x0fff							; COPPTR
 000215ee: 0180 000f            ;  COLOR00 := 0x000f
 000215f2: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 000215f6: 0180 0fff            ;  COLOR00 := 0x0fff
 000215fa: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 000215fe: 0180 0f00            ;  COLOR00 := 0x0f00
 00021602: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00021606: 0180 0000            ;  COLOR00 := 0x0000
 0002160a: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0002160e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021612: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1		
;------------------------------------------------------------------------------	
>ob 21602
Copper breakpoint @0x00021602
;------------------------------------------------------------------------------
>g
Cycles: 6797 Chip, 13594 CPU. (V=144 H=26 -> V=174 H=13)						; stops here: V=174 H=13 (174 = $AE)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 66f6 (Bcc) 4e71 (NOP) Chip latch 0000FFFE
0002157a 66f6                     bne.b #$f6 == $00021572 (T)
Next PC: 0002157c
;------------------------------------------------------------------------------
>o1
 000215de: 9001 fffe [000 008]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 000215e2: 0180 0f00 [090 008]  ;  COLOR00 := 0x0f00
 000215e6: a001 fffe [090 00c]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 000215ea: 0180 0fff [0a0 008]  ;  COLOR00 := 0x0fff
 000215ee: 0180 000f [0a0 00c]  ;  COLOR00 := 0x000f
 000215f2: aa01 fffe [0a0 010]  ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 000215f6: 0180 0fff [0aa 008]  ;  COLOR00 := 0x0fff
 000215fa: ae01 fffe [0aa 00c]  ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 000215fe: 0180 0f00 [0ae 008]  ;  COLOR00 := 0x0f00
 00021602: be01 fffe [0ae 00c]  ;  Wait for vpos >= 0xbe and hpos >= 0x00		; current copper breakpoint position
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
*00021606: 0180 0000            ;  COLOR00 := 0x0000							; COPPTR
 0002160a: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0002160e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021612: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021616: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0002161a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0002161e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021622: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 00021626: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
 0002162a: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
;------------------------------------------------------------------------------
>ob 215ea
Copper breakpoint @0x000215ea
;------------------------------------------------------------------------------
>g
Cycles: 67864 Chip, 135728 CPU. (V=174 H=18 -> V=160 H=9)						; stops here: V=160 H=9	(160 = $A0)
  D0 00000000   D1 00000000   D2 00000000   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000216E6   A1 000215DE   A2 00000000   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c39 (CMP) 008f (ILLEGAL) Chip latch 00000FFF
00021572 0c39 008f 00df f006      cmp.b #$8f,$00dff006
Next PC: 0002157a
;------------------------------------------------------------------------------
>o1
 000215de: 9001 fffe [000 008]  ;  Wait for vpos >= 0x90 and hpos >= 0x00
                                ;  VP 90, VE 7f; HP 00, HE fe; BFD 1
 000215e2: 0180 0f00 [090 008]  ;  COLOR00 := 0x0f00
 000215e6: a001 fffe [090 00c]  ;  Wait for vpos >= 0xa0 and hpos >= 0x00
                                ;  VP a0, VE 7f; HP 00, HE fe; BFD 1
 000215ea: 0180 0fff [0a0 008]  ;  COLOR00 := 0x0fff							; current copper breakpoint position
*000215ee: 0180 000f            ;  COLOR00 := 0x000f							; COPPTR
 000215f2: aa01 fffe            ;  Wait for vpos >= 0xaa and hpos >= 0x00
                                ;  VP aa, VE 7f; HP 00, HE fe; BFD 1
 000215f6: 0180 0fff            ;  COLOR00 := 0x0fff
 000215fa: ae01 fffe            ;  Wait for vpos >= 0xae and hpos >= 0x00
                                ;  VP ae, VE 7f; HP 00, HE fe; BFD 1
 000215fe: 0180 0f00            ;  COLOR00 := 0x0f00
 00021602: be01 fffe            ;  Wait for vpos >= 0xbe and hpos >= 0x00
                                ;  VP be, VE 7f; HP 00, HE fe; BFD 1
 00021606: 0180 0000            ;  COLOR00 := 0x0000
 0002160a: ffff fffe            ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1
                                ;  End of Copperlist
 0002160e: ffff ffff            ;  Skip if vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1									