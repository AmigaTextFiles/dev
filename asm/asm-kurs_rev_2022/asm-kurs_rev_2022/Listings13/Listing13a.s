
; Listing13a.s - Austauschanweisungen - Beispiel
; Zeile 265

start:
	;move.w #$4000,$dff09a	; Interrupts disable
waitmouse:  
	btst	#6,$bfe001		; left mousebutton?
	bne.s	Waitmouse	
;-----------------------	; Zeile 265
	lea	LABEL1,a0																	; 12 Zyklen		; 000214aa 41f9 0002 14e0           lea.l $000214e0,a0
	move.l	0(a0),d0																; 16 Zyklen																	
	move.l	2(a0),d1																; 16 Zyklen
	ADD.W	#5,d0																	; 8 Zyklen
	SUB.W	#5,d1																	; 8 Zyklen
	MULU.W	#2,d0																	; 44 Zyklen
	MOVE.L	#30,d2																	; 12 Zyklen
	;rts

; Dasselbe können Sie tun, indem Sie diese Anweisungen auswählen:

	lea	LABEL1(PC),a0	; schnellere (PC) Adressierung								8 Zyklen		; 000214ca 41fa 0014                lea.l (pc,$0014) == $000214e0,a0
	move.l	(a0),d0		; kein Offset 0 erforderlich !!								12 Zyklen
	move.l	2(a0),d1	; das bleibt so												16 Zyklen
	ADDQ.W	#5,d0		; Nummer kleiner als 8, Sie können ADDQ verwenden!			4 Zyklen
	SUBQ.W	#5,d1		; das Gleiche gilt für SUBQ!								4 Zyklen
	ADD.W	d0,d0		; spart 40 Zyklen!! D0*2 ist das gleiche wie D0+D0!!!		4 Zyklen
	MOVEQ	#30,d2		; Nummer kleiner als 127, ich kann MOVEQ verwenden!			4 Zyklen
;------------------------------------------------------------------------------
	nop					; an dieser Stelle ist die Aufgabe erledigt	
	;move.w #$C000,$dff09a	; Interrupts enable
	rts

Label1:
	dc.w $100
	even

	end		
	

;------------------------------------------------------------------------------
r
Filename: Listing13a.s
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
000214a8 66f6                     bne.b #$f6 == $000214a0 (T)
000214aa 41f9 0002 14e0           lea.l $000214e0,a0
000214b0 2028 0000                move.l (a0,$0000) == $00000000 [00000000],d0
000214b4 2228 0002                move.l (a0,$0002) == $00000002 [000000c0],d1
000214b8 0640 0005                add.w #$0005,d0
000214bc 0441 0005                sub.w #$0005,d1
000214c0 c0fc 0002                mulu.w #$0002,d0
000214c4 243c 0000 001e           move.l #$0000001e,d2
000214ca 41fa 0014                lea.l (pc,$0014) == $000214e0,a0
000214ce 2010                     move.l (a0) [00000000],d0
>f 214aa																		; set breakpoint
Breakpoint added.

;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
Cycles: 5040045 Chip, 10080090 CPU. (V=105 H=8 -> V=105 H=22)					; WinUAE-Debugger output
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00000000   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 41f9 (LEA) 0002 (OR) Chip latch 00000000
000214aa 41f9 0002 14e0           lea.l $000214e0,a0
Next PC: 000214b0
;------------------------------------------------------------------------------
>d pc
000214aa 41f9 0002 14e0           lea.l $000214e0,a0
000214b0 2028 0000                move.l (a0,$0000) == $00000000 [00000000],d0
000214b4 2228 0002                move.l (a0,$0002) == $00000002 [000000c0],d1
000214b8 0640 0005                add.w #$0005,d0
000214bc 0441 0005                sub.w #$0005,d1
000214c0 c0fc 0002                mulu.w #$0002,d0
000214c4 243c 0000 001e           move.l #$0000001e,d2
000214ca 41fa 0014                lea.l (pc,$0014) == $000214e0,a0
000214ce 2010                     move.l (a0) [00000000],d0
000214d0 2228 0002                move.l (a0,$0002) == $00000002 [000000c0],d1
;------------------------------------------------------------------------------
>t																				; step through the program via t
Cycles: 6 Chip, 12 CPU. (V=105 H=22 -> V=105 H=28)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2028 (MOVE) 0000 (OR) Chip latch 00000000
000214b0 2028 0000                move.l (a0,$0000) == $000214e0 [01000000],d0
Next PC: 000214b4
>t
Cycles: 8 Chip, 16 CPU. (V=105 H=28 -> V=105 H=36)
	D0 01000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2228 (MOVE) 0002 (OR) Chip latch 00000000
000214b4 2228 0002                move.l (a0,$0002) == $000214e2 [00001234],d1
Next PC: 000214b8
>t
Cycles: 8 Chip, 16 CPU. (V=105 H=36 -> V=105 H=44)
	D0 01000000   D1 00001234   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0640 (ADD) 0005 (OR) Chip latch 00000000
000214b8 0640 0005                add.w #$0005,d0
Next PC: 000214bc
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=44 -> V=105 H=48)
	D0 01000005   D1 00001234   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0441 (SUB) 0005 (OR) Chip latch 00000000
000214bc 0441 0005                sub.w #$0005,d1
Next PC: 000214c0
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=48 -> V=105 H=52)
	D0 01000005   D1 0000122F   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch c0fc (MULU) 0002 (OR) Chip latch 00000000
000214c0 c0fc 0002                mulu.w #$0002,d0
Next PC: 000214c4
>t
Cycles: 22 Chip, 44 CPU. (V=105 H=52 -> V=105 H=74)
	D0 0000000A   D1 0000122F   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 243c (MOVE) 0000 (OR) Chip latch 00000000
000214c4 243c 0000 001e           move.l #$0000001e,d2
Next PC: 000214ca
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=74 -> V=105 H=80)
	D0 0000000A   D1 0000122F   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 41fa (LEA) 0014 (OR) Chip latch 00000000
000214ca 41fa 0014                lea.l (pc,$0014) == $000214e0,a0
Next PC: 000214ce
;------------------------------------------------------------------------------
>d pc																			; optimized version 
000214ca 41fa 0014                lea.l (pc,$0014) == $000214e0,a0
000214ce 2010                     move.l (a0) [01000000],d0
000214d0 2228 0002                move.l (a0,$0002) == $000214e2 [00001234],d1
000214d4 5a40                     addq.w #$05,d0
000214d6 5b41                     subq.w #$05,d1
000214d8 d040                     add.w d0,d0
000214da 741e                     moveq #$1e,d2
000214dc 4e71                     nop
000214de 4e75                     rts  == $00c4f7b8
000214e0 0100                     btst.l d0,d0
>t
Cycles: 4 Chip, 8 CPU. (V=105 H=80 -> V=105 H=84)
	D0 0000000A   D1 0000122F   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2010 (MOVE) 2228 (MOVE) Chip latch 00000000
000214ce 2010                     move.l (a0) [01000000],d0
Next PC: 000214d0
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=84 -> V=105 H=90)
	D0 01000000   D1 0000122F   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 2228 (MOVE) 0002 (OR) Chip latch 00000000
000214d0 2228 0002                move.l (a0,$0002) == $000214e2 [00001234],d1
Next PC: 000214d4
>t
Cycles: 8 Chip, 16 CPU. (V=105 H=90 -> V=105 H=98)
	D0 01000000   D1 00001234   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 5a40 (ADD) 5b41 (SUB) Chip latch 00000000
000214d4 5a40                     addq.w #$05,d0
Next PC: 000214d6
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=98 -> V=105 H=100)
	D0 01000005   D1 00001234   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 5b41 (SUB) d040 (ADD) Chip latch 00000000
000214d6 5b41                     subq.w #$05,d1
Next PC: 000214d8
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=100 -> V=105 H=102)
	D0 01000005   D1 0000122F   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch d040 (ADD) 741e (MOVE) Chip latch 00000000
000214d8 d040                     add.w d0,d0
Next PC: 000214da
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=102 -> V=105 H=104)
	D0 0100000A   D1 0000122F   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 741e (MOVE) 4e71 (NOP) Chip latch 00000000
000214da 741e                     moveq #$1e,d2
Next PC: 000214dc
>t
Cycles: 2 Chip, 4 CPU. (V=105 H=104 -> V=105 H=106)
	D0 0100000A   D1 0000122F   D2 0000001E   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 000214E0   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 4e75 (RTS) Chip latch 00000000
000214dc 4e71                     nop
Next PC: 000214de
>
