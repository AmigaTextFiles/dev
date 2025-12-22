
; soc22e.s
; _waitVBL - auf Ende des-Rasterdurchlaufs warten, zwei Varianten

; Registers
VPOSR=$004

; Program
DISPLAY_DY=256
DISPLAY_X=$81
DISPLAY_Y=$2C

	lea $dff000,a5
loop: 

; Total cycles:	66(11/0) – 68(11/0)
; Total length:	18 bytes

_waitVBL:
	move.l VPOSR(a5),d0
	lsr.l #8,d0
	and.w #$01FF,d0
	cmp.w #DISPLAY_Y+DISPLAY_DY,d0	; $2C+256=300= $12C
	blt _waitVBL

	; any prg
	movem.l d0-d2/a0-a3,-(sp)		; breakpoint here	
	movem.l (sp)+,d0-d2/a0-a3
	
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	loop

	rts

	end

;------------------------------------------------------------------------------

; alternativ:

; Total cycles: 58(12/0) – 60(13/0)
; Total length: 20 bytes
	
loop:
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00012c00,d0				; Zeile $12c - auf Ende des-Rasterdurchlaufs warten
	bne.s loop

	; any prg
	movem.l d0-d2/a0-a3,-(sp)		; breakpoint here	
	movem.l (sp)+,d0-d2/a0-a3
	
	btst	#6,$bfe001				; linke Maustaste gedrückt?
	bne.s	loop

	rts

;------------------------------------------------------------------------------
; WinUAE-Debugger (open with Shift+F12) WinUAE 5.0

>d pc
00c269b4 0240 01ff                and.w #$01ff,d0
00c269b8 0c40 012c                cmp.w #$012c,d0
00c269bc 6d00 fff0                blt.w #$fff0 == $00c269ae (F)
00c269c0 48e7 e0f0                movem.l d0-d2/a0-a3,-(a7)
00c269c4 4cdf 0f07                movem.l (a7)+,d0-d2/a0-a3
00c269c8 0839 0006 00bf e001      btst.b #$0006,$00bfe001
00c269d0 66dc                     bne.b #$dc == $00c269ae (T)
00c269d2 4e75                     rts  == $00c502a0
00c269d4 1234 5678                move.b (a4,d5.w[*8],$78) == $00000078 (68020+) [00],d1
00c269d8 5441                     addq.w #$02,d1
>f c269c0																		; breakpoint	
Breakpoint added.
>g
Breakpoint 0 triggered.
Cycles: 20480 Chip, 40960 CPU. (V=210 H=2 -> V=300 H=52)						; Zeile $12c=300
VPOS: 300 ($12c) HPOS: 052 ($034) COP: $00023898
  D0 0080012C   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00DFF000   A6 00000000   A7 00C609C0
USP  00C609C0 ISP  00C619C0
SR=0004 T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IM=0 STP=0
Prefetch 48e7 (MVMLE) e0f0 (ASRW) Chip latch 0000FFFE
00c269c0 48e7 e0f0                movem.l d0-d2/a0-a3,-(a7)
Next PC: 00c269c4
>c
A: CRA 00 CRB 08 ICR 00 IM 0a TA ffff (ffff) TB 0863 (0863)
TOD 00f9c7 (00f9c7) ALARM 000000 -- CYC=000001FF4649A000
B: CRA 00 CRB 80 ICR 04 IM 00 TA ffff (ffff) TB ffff (ffff)
TOD 00012b (00ffff) ALARM 0000ac --
DEBUG: drive 0 motor off cylinder  0 sel no ro mfmpos 256/101344
DEBUG: drive 1 motor off cylinder  0 sel no ro mfmpos 0/101344
side 0 dma 0 off 8 word 0000 pt 00000000 len 4000 bytr 8000 adk 1100 sync 0000
DMACON: $03f0 INTENA: $602c ($602c) INTREQ: $1040 ($1040) VPOS: 300 ($12c) HPOS: 052 ($034)	; Zeile $12c=300
INT: $0000 IPL: -1
COP1LC: $00000420, COP2LC: $000237f8 COPPTR: $00023898
DIWSTRT: $0581 DIWSTOP: $40c1 DDFSTRT: $003c DDFSTOP: $00d0
BPLCON 0: $0200 1: $0000 2: $0024 3: $0c00 4: $0011 LOF=1/1 HDIW=0 VDIW=1
Average frame time: 303381.54 ms [frames: 60322 time: 1121015302]
>e
000 BLTDDAT     0000    108 BPL1MOD     0000
002 DMACONR     03F0    10A BPL2MOD     0000
004 VPOSR       8001    10C BPLCON4     0011									; VPOSR/VHPOSR Zeile $12c=300
006 VHPOSR      2C35    10E CLXCON2     0000
00A JOY0DAT     0858    110 BPL1DAT     0000