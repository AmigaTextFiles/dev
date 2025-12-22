
; Listing19i2.s
; Scanline
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger
 
; fs <lines to wait> | <vpos> <hpos> Wait n scanlines/position.

; 1. fs <lines to wait>
; 1b. fs 313	; one frame forward
; 2. fs <vpos> <hpos>

;------------------------------------------------------------------------------

start:
	move.w #$4000,$dff09a		; Interrupts disable
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00013700,d0

; auf Ende des-Rasterdurchlaufs warten
	bne.s loop
	bsr somethingtodo
	btst #6,$bfe001
	bne loop
	move.w #$C000,$dff09a		; Interrupts enable	
	rts

somethingtodo:					; that are 227cycles
	
	lea	Table,a0				; 12 cycles
	movem.l	(a0)+,d3-d7/a3-a6	; 84(21/0)		; 42 cycles 5*42=210
	movem.l	(a0)+,d3-d7/a3-a6
	movem.l	(a0)+,d3-d7/a3-a6
	movem.l	(a0)+,d3-d7/a3-a6

	move.b	#0,d0
	move.l	#0,d0
	rts

Table:
	blk.w 1200,$FFFF


	end

;------------------------------------------------------------------------------
>r
Filename:Listing19i2.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; we need no breakpoint, program runs in a loop
>d pc
00021110 0c80 0001 3700           cmp.l #$00013700,d0
00021116 66ec                     bne.b #$ec == $00021104 (T)
00021118 6100 0018                bsr.w #$0018 == $00021132
0002111c 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00021124 6600 ffde                bne.w #$ffde == $00021104 (T)
00021128 33fc c000 00df f09a      move.w #$c000,$00dff09a
00021130 4e75                     rts  == $00c4f7b8
00021132 41f9 0002 1154           lea.l $00021154,a0
00021138 4cd8 78f8                movem.l (a0)+,d3-d7/a3-a6
0002113c 4cd8 78f8                movem.l (a0)+,d3-d7/a3-a6
;------------------------------------------------------------------------------
>t
Cycles: 7 Chip, 14 CPU. (V=105 H=0 -> V=105 H=7)
	D0 00006800   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00021116 66ec                     bne.b #$ec == $00021104 (T)
Next PC: 00021118
;------------------------------------------------------------------------------
>fs 10
	D0 00007200   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c80 (CMP) 0001 (OR) Chip latch 00000000
00021110 0c80 0001 3700           cmp.l #$00013700,d0
Next PC: 00021116
;------------------------------------------------------------------------------
>t
Cycles: 7 Chip, 14 CPU. (V=115 H=10 -> V=115 H=17)
	D0 00007200   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00021116 66ec                     bne.b #$ec == $00021104 (T)
Next PC: 00021118
;------------------------------------------------------------------------------
>fs 60
	D0 0000AE00   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00021116 66ec                     bne.b #$ec == $00021104 (T)
Next PC: 00021118
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=175 H=17 -> V=175 H=22)
	D0 0000AE00   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 2039 (MOVE) 00df (ILLEGAL) Chip latch 00000000
00021104 2039 00df f004           move.l $00dff004,d0
Next PC: 0002110a
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 00159c (00156e) ALARM 000000    CYC=11554A00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 0038ec (000000) ALARM 000082    CLK=2
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 13 word B5F8 pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 23f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: af HPOS: 16
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001ede4
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 952799.41 ms [frames: 3869 time: -608586376]				; frame 3869
;------------------------------------------------------------------------------
>fs 125
	D0 00012B00   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 0000FFFE
00021116 66ec                     bne.b #$ec == $00021104 (T)
Next PC: 00021118
;------------------------------------------------------------------------------
>t
Cycles: 5 Chip, 10 CPU. (V=300 H=22 -> V=300 H=27)
	D0 00012B00   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 2039 (MOVE) 00df (ILLEGAL) Chip latch 0000FFFE
00021104 2039 00df f004           move.l $00dff004,d0
Next PC: 0002110a
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 00159c (00156e) ALARM 000000    CYC=12330200
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 003969 (000000) ALARM 000082    CLK=2
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 13 word B5F8 pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 23f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: 12c HPOS: 1b
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001edf0
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: 0200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 952799.41 ms [frames: 3869 time: -608586376]				; frame 3869
;------------------------------------------------------------------------------
>fs 400
	D0 00004900   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 2039 (MOVE) 00df (ILLEGAL) Chip latch 00000000
00021104 2039 00df f004           move.l $00dff004,d0
Next PC: 0002110a
;------------------------------------------------------------------------------
>t
Cycles: 10 Chip, 20 CPU. (V=74 H=29 -> V=74 H=39)
	D0 80004A1D   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 000211E4   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0280 (AND) 000f (ILLEGAL) Chip latch 00000000
0002110a 0280 000f ff00           and.l #$000fff00,d0
Next PC: 00021110
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 00159e (00156e) ALARM 000000    CYC=14F87A00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 003af9 (000000) ALARM 000082    CLK=4
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 13 word B5F8 pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 23f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: 4a HPOS: 27
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001ede4
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 952604.96 ms [frames: 3870 time: -608386105]				; frame 3870
>


;******************************************************************************	; 1b test
;------------------------------------------------------------------------------	
>fs 313																			; + 1frame forward (313 lines)
	D0 00011300   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00022f8e 66ec                     bne.b #$ec == $00022f7c (T)
Next PC: 00022f90
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 0017c5 (001794) ALARM 000000    CYC=C11AF400
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 003cfc (000000) ALARM 000082    CLK=0
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 12 word 161A pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 03f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: 114 HPOS: 19				; VPOS: 114 HPOS: 19
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001ede8
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 136698.82 ms [frames: 4421 time: 604345463]						; frame 4421
;------------------------------------------------------------------------------
>fs 313
	D0 00011300   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00022f8e 66ec                     bne.b #$ec == $00022f7c (T)
Next PC: 00022f90
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 0017c6 (001794) ALARM 000000    CYC=C3460A00
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 003e35 (000000) ALARM 000082    CLK=1
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 12 word 161A pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 03f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: 114 HPOS: 19				; VPOS: 114 HPOS: 19
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001ede8
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 166777.13 ms [frames: 4422 time: 737488485]						; frame 4422
;------------------------------------------------------------------------------
>fs 313
	D0 00011300   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00022f8e 66ec                     bne.b #$ec == $00022f7c (T)
Next PC: 00022f90
;------------------------------------------------------------------------------
>c
A: CRA 00 CRB 08 ICR e8 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 0017c7 (001794) ALARM 000000    CYC=C5712000
B: CRA 04 CRB 84 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 003f6e (000000) ALARM 000082    CLK=2
DEBUG: drive 0 motor off cylinder  1 sel no ro mfmpos 0/101344
side 0 dma 0 off 12 word 161A pt 00000000 len 4000 bytr 0000 adk 1100 sync 4489
DMACON: 03f0 INTENA: 202c (202c) INTREQ: 0068 (0068) VPOS: 114 HPOS: 19				; VPOS: 114 HPOS: 19
INT: 0028 IPL: -1
COP1LC: 00000420, COP2LC: 0001ed50 COPPTR: 0001ede8
DIWSTRT: 0581 DIWSTOP: 40c1 DDFSTRT: 003c DDFSTOP: 00d0
BPLCON 0: a200 1: 0000 2: 0024 3: 0c00 4: 0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 209582.16 ms [frames: 4423 time: 926981902]						; frame 4423
>

;******************************************************************************	; 2 test

>fs 115 20																		; stop at line VPOS: 115 HPOS: 20
;Cycles: x Chip, x CPU. (V=114 H=19 -> V=115 H=25)
	D0 00007300   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0c80 (CMP) 0001 (OR) Chip latch 00000000
00022f88 0c80 0001 3700           cmp.l #$00013700,d0
Next PC: 00022f8e
;------------------------------------------------------------------------------
>t
Cycles: 7 Chip, 14 CPU. (V=115 H=25 -> V=115 H=32)								; stopped here
	D0 00007300   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 66ec (Bcc) 6100 (BSR) Chip latch 00000000
00022f8e 66ec                     bne.b #$ec == $00022f7c (T)
Next PC: 00022f90
;------------------------------------------------------------------------------
>fs 127 70																		; stop at line VPOS: 127 HPOS: 70
;Cycles: x Chip, x CPU. (V=115 H=32 -> V=127 H=73)
	D0 00007F00   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=1 IMASK=0 STP=0
Prefetch 2039 (MOVE) 00df (ILLEGAL) Chip latch 00000000
00022f7c 2039 00df f004           move.l $00dff004,d0
Next PC: 00022f82
;------------------------------------------------------------------------------
>t
Cycles: 10 Chip, 20 CPU. (V=127 H=73 -> V=127 H=83)								; stopped here
	D0 80007F49   D1 00000000   D2 00000000   D3 FFFFFFFF
	D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
	A0 0002305C   A1 00000000   A2 00000000   A3 FFFFFFFF
	A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0280 (AND) 000f (ILLEGAL) Chip latch 00000000
00022f82 0280 000f ff00           and.l #$000fff00,d0
Next PC: 00022f88
>

;------------------------------------------------------------------------------
from EAB:
run n cyclesvblslines

I'd like to analyze (and measure execution time for some procedures) a few demos and games for educational purposes.
I tried two methods - set a breakpoint for VERTB; use Copper breakpoint, but in both cases without success.
In the first case, VERTB was masked in INTENA or was disturbed by Copper interrupt.
In the second case, COP1LH/COP2LH were very often modified (different copper lists I guess).
Therefore, would be cool to have another breakpoint method, e.g. break after n VBLs/cycles or break on n scan-line etc.
Or break on defined Vpos/Hpos

Note that debugger always needs to wait until current CPU instruction has finished execution which
means above breakpoints can't be 100% exact.

many thanks.
agree, a user should takes into account that a long instructions like div/mul could delay a breakpoint.

what about adding a breakpoint (bitfield mask) for INTREQR interrupts?
That would allow to track a masked breakpoints and also it would make easier to distinguish interrupts with the same level.
