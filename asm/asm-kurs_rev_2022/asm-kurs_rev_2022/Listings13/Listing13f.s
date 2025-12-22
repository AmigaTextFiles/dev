
; Listing13f.s	Code-Erweiterungstechnik
; Zeile 1539

; 64*2 Bytes=128 Bytes kopieren
; 24440 Zyklen

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	

	lea	Table,a2				; Quelle										; 12 Zyklen
	lea	Table2,a1				; Ziel											; 12 Zyklen
;-------------------------------; 
ROUTINE2:
	MOVEQ	#64-1,D0			; 64 Schleifen									; 4 Zyklen
SLOWLOOP2:
	MOVE.W	(a2),(a1)			; Daten kopieren								; 12 Zyklen	
	ADDQ.w	#4,a1																; 8 Zyklen
	ADDQ.w	#8,a2																; 8 Zyklen		
	DBRA	D0,SLOWLOOP2														; 10 Zyklen/ (14 Zyklen)
;-------------------------------;		
	nop							; an dieser Stelle ist die Aufgabe erledigt		; 4 Zyklen
	move.w #$C000,$dff09a		; Interrupts enable								; 20 Zyklen	
	rts

Table:
	blk.w 1024,$FFFF
		
Table2:
	blk.w 1024,$0000
	end


;------------------------------------------------------------------------------
r
Filename: Listing13f.s
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
00024104 66f6                     bne.b #$f6 == $000240fc (T)
00024106 45f9 0002 412a           lea.l $0002412a,a2
0002410c 43f9 0002 492a           lea.l $0002492a,a1
00024112 703f                     moveq #$3f,d0
00024114 3292                     move.w (a2) [0000],(a1) [0000]
00024116 5849                     addaq.w #$04,a1
00024118 504a                     addaq.w #$08,a2
0002411a 51c8 fff8                dbf .w d0,#$fff8 == $00024114 (F)
0002411e 4e71                     nop
00024120 33fc c000 00df f09a      move.w #$c000,$00dff09a
>f 24106
Breakpoint added.
>fl
0: PC == 00024106 [00000000 00000000]

;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
Cycles: 8384042 Chip, 16768084 CPU. (V=105 H=3 -> V=105 H=27)					; WinUAE-Debugger output
	D0 0000FFFF   D1 0000005A   D2 00000010   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 0002181C   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 45f9 (LEA) 0002 (OR) Chip latch 00000000
00024106 45f9 0002 412a           lea.l $0002412a,a2
Next PC: 0002410c
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=27 -> V=105 H=33)
	D0 0000FFFF   D1 0000005A   D2 00000010   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 0002181C   A1 00000000   A2 0002412A   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 43f9 (LEA) 0002 (OR) Chip latch 00000000
0002410c 43f9 0002 492a           lea.l $0002492a,a1
Next PC: 00024112
;------------------------------------------------------------------------------
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=33 -> V=105 H=39)
	D0 0000FFFF   D1 0000005A   D2 00000010   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 0002181C   A1 0002492A   A2 0002412A   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 703f (MOVE) 3292 (MOVE) Chip latch 00000000
00024112 703f                     moveq #$3f,d0
Next PC: 00024114
>
;------------------------------------------------------------------------------
>m 2412a 3
0002412A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0002413A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
0002414A FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
;------------------------------------------------------------------------------
>m 2492a 3
0002492A 0000 0000 0000 0000 0000 0000 0000 0000  ................
0002493A 0000 0000 0000 0000 0000 0000 0000 0000  ................
0002494A 0000 0000 0000 0000 0000 0000 0000 0000  ................
;------------------------------------------------------------------------------
>fi																				; stop on rts	
Cycles: 1232 Chip, 2464 CPU. (V=105 H=39 -> V=110 H=136)						; nop 4 Zyklen, move xx 20 Zyklen
	D0 0000FFFF   D1 0000005A   D2 00000010   D3 00000000							; 2464-24=2440 Zyklen
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 0002181C   A1 00024A2A   A2 0002432A   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) ffff (ILLEGAL) Chip latch 00000000
00024128 4e75                     rts  == $00c4f7b8
Next PC: 0002412a
>
;------------------------------------------------------------------------------
>fi nop																			; fi nop = 2440 Zyklen
Cycles: 1220 Chip, 2440 CPU. (V=105 H=34 -> V=110 H=119)
	D0 0000FFFF   D1 0000005A   D2 00000010   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 0002181C   A1 00024042   A2 00023942   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=1 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 00000000
00023736 4e71                     nop
Next PC: 00023738
>
;------------------------------------------------------------------------------
>m 2492a
0002492A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................	; 4 word * 16 Zeilen = 64 words / 128 bytes
0002493A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002494A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002495A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002496A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002497A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002498A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
0002499A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249AA FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249BA FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249CA FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249DA FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249EA FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
000249FA FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A0A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A1A FFFF 0000 FFFF 0000 FFFF 0000 FFFF 0000  ................
00024A2A 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024A3A 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024A4A 0000 0000 0000 0000 0000 0000 0000 0000  ................
00024A5A 0000 0000 0000 0000 0000 0000 0000 0000  ................
>


Zusammenfassung:
4+64*(12+8+8)+63*10+14
>?4+64*28+63*10+14
0x00000988 = %00000000000000000000100110001000 = 2440 = 2440