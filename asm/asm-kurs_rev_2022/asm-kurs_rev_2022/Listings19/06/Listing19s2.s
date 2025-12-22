
; Listing19s2.s		Reset

start:
	btst	#2,$dff016			; right mousebutton?
	bne.s	start	

	move.l	4.w,a6				; ExecBase in a6
	lea	SuperCode(PC),a5		; Routine zur Ausführung im Supervisor
	jsr	-$1e(a6)				; LvoSupervisor - Führe die Routine aus								
	rts							
	
; Routine wird im Supervisor-Modus ausgeführt wird
		
SuperCode:
	;cnop    0,4
		lea     2.l,a0
		reset
		jmp     (a0)
	rte							; Return From Exception: wie RTS, jedoch von Ausnahme.

	end

; without Supervisor-Modus ** Privilege Violation Raised***

;------------------------------------------------------------------------------
>r
Filename:Listing19s2.s
>a
Pass1
Pass2
No Errors
>j

																					; start the programm
																					; the program is waiting for the right mouse button
;------------------------------------------------------------------------------
																					; open the Debugger with Shift+F12

>d pc
00021098 66f6                     bne.b #$f6 == $00021090 (T)
0002109a 2c78 0004                movea.l $0004 [00c00276],a6
0002109e 4bfa 0008                lea.l (pc,$0008) == $000210a8,a5
000210a2 4eae ffe2                jsr (a6,-$001e) == $ffffffe2
000210a6 4e75                     rts  == $00c4f6d8
000210a8 41f9 0000 0002           lea.l $00000002,a0
000210ae 4e70                     reset
000210b0 4ed0                     jmp (a0)
000210b2 4e73                     rte  == $f6d80000
000210b4 1234 5678                move.b (a4,d5.W[*8],$78) == $00000078 (68020+) [00],d1
>f 2109a																			; set breakpoint
Breakpoint added.
>g
;------------------------------------------------------------------------------
Breakpoint 0 triggered.																; now click right mouse-button, the debuger reopens
Cycles: 7460389 Chip, 14920778 CPU. (V=105 H=3 -> V=105 H=37)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2c78 (MOVEA) 0004 (OR) Chip latch 00000004
0002109a 2c78 0004                movea.l $0004 [00c00276],a6
Next PC: 0002109e
>t
Cycles: 8 Chip, 16 CPU. (V=105 H=37 -> V=105 H=45)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00C00276   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4bfa (LEA) 0008 (ILLEGAL) Chip latch 00000008
0002109e 4bfa 0008                lea.l (pc,$0008) == $000210a8,a5
Next PC: 000210a2
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=45 -> V=105 H=49)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 000210A8   A6 00C00276   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4eae (JSR) ffe2 (ILLEGAL) Chip latch 0000FFE2
000210a2 4eae ffe2                jsr (a6,-$001e) == $00c00258
Next PC: 000210a6
>t
Cycles: 9 Chip, 18 CPU. (V=105 H=49 -> V=105 H=58)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 000210A8   A6 00C00276   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4ef9 (JMP) 00fc (ILLEGAL) Chip latch 000000FC
00c00258 4ef9 00fc 08e6           jmp $00fc08e6
Next PC: 00c0025e
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=58 -> V=105 H=64)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 000210A8   A6 00C00276   A7 00C5FDF4
USP  00C5FDF4 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 007c (ORSR) 2000 (MOVE) Chip latch 000008E6
00fc08e6 007c 2000                or.w #$2000,sr
Next PC: 00fc08ea
 ;-----------------------------------------------------------------------------
>g
	D0 00000034   D1 000C61C2   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 FFFFFFFF   D7 00000000
	A0 00FE9716   A1 00C014E2   A2 00C014E2   A3 00C04730
	A4 00001558   A5 00C014B6   A6 00C03A84   A7 00C0149E
USP  00C0149E ISP  00C80000
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4cdf (MVMEL) 0c00 (CMP) Chip latch 00000000
00fe9c90 4cdf 0c00                movem.l (a7)+,a2-a3
Next PC: 00fe9c94
;-----------------------------------------------------------------------------
>H 500																				; this are the last 500 instructions
 0 00fe864a b4ad 004c                cmp.l (a5,$004c) == $00c01502 [00000000],d2	
 0 00fe864e 67e8                     beq.b #$e8 == $00fe8638 (F)
 0 00fe8638 43ed 002c                lea.l (a5,$002c) == $00c014e2,a1
 0 00fe863c 337c 000d 001c           move.w #$000d,(a1,$001c) == $00c014fe [000d]
 ...
 0 00fe9e68 265f                     movea.l (a7)+ [00c04730],a3
 0 00fe9e6a 4e75                     rts  == $00fe9720
 0 00fe9720 4e75                     rts  == $00fe9c90
 0 00fe9c90 4cdf 0c00                movem.l (a7)+,a2-a3							; last instruction
 ;-----------------------------------------------------------------------------
 >fd
All breakpoints removed.
>x


