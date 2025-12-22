
; Listing13h.s	Datenbereich kopieren
; Zeile 1626

; 364 Bytes kopieren	
; 7 copies of 13 registers with 2 words 7*13*2 words = 182 words (364 bytes)
; 1650 Zyklen

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;

	Lea	Source,a0				; Quelle									; 12 Zyklen
	Lea	Dest,a1					; Ziel										; 12 Zyklen
FASTCOPY:							; Ich benutze 13 Register
	movem.l	(a0)+,d0-d7/a2-a6		; Daten lesen							; 116 Zyklen
	movem.l	d0-d7/a2-a6,(a1)		; Daten schreiben						; 112 Zyklen
	movem.l	(a0)+,d0-d7/a2-a6												; 116 Zyklen
	movem.l	d0-d7/a2-a6,$34(a1)			; $34								; 116 (118 Zyklen - to next line)
	movem.l	(a0)+,d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,$34*2(a1)		; $34*2
	movem.l	(a0)+,d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,$34*3(a1)
	movem.l	(a0)+,d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,$34*4(a1)
	movem.l	(a0)+,d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,$34*5(a1)
	movem.l	(a0)+,d0-d7/a2-a6
	movem.l	d0-d7/a2-a6,$34*6(a1)											; 116 Zyklen

;-------------------------------;		
	nop							; an dieser Stelle ist die Aufgabe erledigt	; 4 Zyklen
	move.w #$C000,$dff09a		; Interrupts enable							; 20 Zyklen	
	rts

Source:
	blk.w 1024,$FFFF			; the dates could also have been different!
		
Dest:
	blk.w 1024,$0000
	end


;------------------------------------------------------------------------------
r
Filename: Listing13h.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
000236a4 66f6                     bne.b #$f6 == $0002369c (T)
000236a6 41f9 0002 3702           lea.l $00023702,a0
000236ac 43f9 0002 3f02           lea.l $00023f02,a1
000236b2 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000236b6 48d1 7cff                movem.l d0-d7/a2-a6,(a1)
000236ba 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000236be 48e9 7cff 0034           movem.l d0-d7/a2-a6,(a1,$0034) == $00023f52
000236c4 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000236c8 48e9 7cff 0068           movem.l d0-d7/a2-a6,(a1,$0068) == $00023f86
000236ce 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
>d
000236d2 48e9 7cff 009c           movem.l d0-d7/a2-a6,(a1,$009c) == $00023fba
000236d8 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000236dc 48e9 7cff 00d0           movem.l d0-d7/a2-a6,(a1,$00d0) == $00023fee
000236e2 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000236e6 48e9 7cff 0104           movem.l d0-d7/a2-a6,(a1,$0104) == $00024022
000236ec 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000236f0 48e9 7cff 0138           movem.l d0-d7/a2-a6,(a1,$0138) == $00024056
000236f6 4e71                     nop
000236f8 33fc c000 00df f09a      move.w #$c000,$00dff09a
00023700 4e75                     rts  == $00c4f6d8
>f 236a6
Breakpoint added.
>fl
0: PC == 000236a6 [00000000 00000000]
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 6157606 Chip, 12315212 CPU. (V=210 H=6 -> V=105 H=10)
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 0002388A   A1 00023F1E   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000002
000236a6 41f9 0002 3702           lea.l $00023702,a0
Next PC: 000236ac
;------------------------------------------------------------------------------
>fi nop
Cycles: 825 Chip, 1650 CPU. (V=105 H=10 -> V=108 H=154)
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 0002386E   A1 00023F02   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 000033FC
000236f6 4e71                     nop
Next PC: 000236f8
;------------------------------------------------------------------------------
>m ra1
00023F02 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................	; 1 * 8 words
00023F12 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F22 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F32 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F42 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F52 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F62 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F72 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F82 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023F92 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................	; 10 * 8 words
00023FA2 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023FB2 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023FC2 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023FD2 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023FE2 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023FF2 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00024002 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00024012 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00024022 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00024032 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................	; 20 * 8 words
>m
00024042 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................	; 21*8 words
00024052 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................	; 22*8 words
00024062 FFFF FFFF FFFF FFFF FFFF FFFF 0000 0000  ................	; +6 words
00024072 0000 0000 0000 0000 0000 0000 0000 0000  ................	; Sum: 182words
>fd
All breakpoints removed.
>x
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
r
Filename: Listing13h.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint

>d pc
000229c4 66f6                     bne.b #$f6 == $000229bc (T)
000229c6 41f9 0002 2a22           lea.l $00022a22,a0
000229cc 43f9 0002 3222           lea.l $00023222,a1
000229d2 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000229d6 48d1 7cff                movem.l d0-d7/a2-a6,(a1)
000229da 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000229de 48e9 7cff 0034           movem.l d0-d7/a2-a6,(a1,$0034) == $00022f76
000229e4 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
000229e8 48e9 7cff 0068           movem.l d0-d7/a2-a6,(a1,$0068) == $00022faa
000229ee 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
>f 229c6
Breakpoint added.
>
;------------------------------------------------------------------------------
>g
Breakpoint 0 triggered.
Cycles: 7739979 Chip, 15479958 CPU. (V=105 H=0 -> V=105 H=10)
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 000228AE   A1 00022F42   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000002
000229c6 41f9 0002 2a22           lea.l $00022a22,a0
Next PC: 000229cc
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=10 -> V=105 H=16)								; 12 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022A22   A1 00022F42   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 43f9 (LEA) 0002 (OR) Chip latch 00000002
000229cc 43f9 0002 3222           lea.l $00023222,a1
Next PC: 000229d2
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=16 -> V=105 H=22)								; 12 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022A22   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
000229d2 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 000229d6
>t
Cycles: 58 Chip, 116 CPU. (V=105 H=22 -> V=105 H=80)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022A56   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48d1 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
000229d6 48d1 7cff                movem.l d0-d7/a2-a6,(a1)
Next PC: 000229da
>t
Cycles: 56 Chip, 112 CPU. (V=105 H=80 -> V=105 H=136)							; 112 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022A56   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
000229da 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 000229de
>t
Cycles: 58 Chip, 116 CPU. (V=105 H=136 -> V=105 H=194)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022A8A   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e9 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
000229de 48e9 7cff 0034           movem.l d0-d7/a2-a6,(a1,$0034) == $00023256
Next PC: 000229e4
>t
Cycles: 59 Chip, 118 CPU. (V=105 H=194 -> V=106 H=26)							; 118 Zyklen - to next line  
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022A8A   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
000229e4 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 000229e8
>t
Cycles: 58 Chip, 116 CPU. (V=106 H=26 -> V=106 H=84)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022ABE   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e9 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
000229e8 48e9 7cff 0068           movem.l d0-d7/a2-a6,(a1,$0068) == $0002328a
Next PC: 000229ee
>t
Cycles: 58 Chip, 116 CPU. (V=106 H=84 -> V=106 H=142)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022ABE   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
000229ee 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 000229f2
>t
Cycles: 58 Chip, 116 CPU. (V=106 H=142 -> V=106 H=200)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022AF2   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e9 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
000229f2 48e9 7cff 009c           movem.l d0-d7/a2-a6,(a1,$009c) == $000232be
Next PC: 000229f8
>t
Cycles: 59 Chip, 118 CPU. (V=106 H=200 -> V=107 H=32)							; 118 Zyklen - to next line  
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022AF2   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
000229f8 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 000229fc
>t
Cycles: 58 Chip, 116 CPU. (V=107 H=32 -> V=107 H=90)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B26   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e9 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
000229fc 48e9 7cff 00d0           movem.l d0-d7/a2-a6,(a1,$00d0) == $000232f2
Next PC: 00022a02
>t
Cycles: 58 Chip, 116 CPU. (V=107 H=90 -> V=107 H=148)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B26   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
00022a02 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 00022a06
>t
Cycles: 58 Chip, 116 CPU. (V=107 H=148 -> V=107 H=206)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B5A   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e9 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
00022a06 48e9 7cff 0104           movem.l d0-d7/a2-a6,(a1,$0104) == $00023326
Next PC: 00022a0c
>t
Cycles: 59 Chip, 118 CPU. (V=107 H=206 -> V=108 H=38)							; 118 Zyklen - to next line
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B5A   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4cd8 (MVMEL) 7cff (MOVE) Chip latch 00007CFF
00022a0c 4cd8 7cff                movem.l (a0)+,d0-d7/a2-a6
Next PC: 00022a10
>t	
Cycles: 58 Chip, 116 CPU. (V=108 H=38 -> V=108 H=96)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B8E   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e9 (MVMLE) 7cff (MOVE) Chip latch 00007CFF
00022a10 48e9 7cff 0138           movem.l d0-d7/a2-a6,(a1,$0138) == $0002335a
Next PC: 00022a16
>t
Cycles: 58 Chip, 116 CPU. (V=108 H=96 -> V=108 H=154)							; 116 Zyklen
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B8E   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 000033FC
00022a16 4e71                     nop
Next PC: 00022a18
>t
Cycles: 2 Chip, 4 CPU. (V=108 H=154 -> V=108 H=156)
  D0 FFFFFFFF   D1 FFFFFFFF   D2 FFFFFFFF   D3 FFFFFFFF
  D4 FFFFFFFF   D5 FFFFFFFF   D6 FFFFFFFF   D7 FFFFFFFF
  A0 00022B8E   A1 00023222   A2 FFFFFFFF   A3 FFFFFFFF
  A4 FFFFFFFF   A5 FFFFFFFF   A6 FFFFFFFF   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) c000 (AND) Chip latch 0000C000
00022a18 33fc c000 00df f09a      move.w #$c000,$00dff09a
Next PC: 00022a20
>

>?12+12+116+112+116+118+3*116+118+3*116+118+2*116
0x00000672 = %00000000000000000000011001110010 = 1650 = 1650
>
