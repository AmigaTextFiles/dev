
; Listing13e4.s	; Speicherbereich löschen - und noch weiter verbessert
				; Cycle and Bus Counting
; Zeile 1462

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	Lea	Table,a0				; Zeiger auf Tabelle							- 12 Zyklen
	moveq	#0,d0				; "move.l d0" schneller als ein "CLR"!			- 4 Zyklen
	move.w	#(1200/32)-1,d7		; Anzahl der Bytes geteilt durch 32				- 8 Zyklen
Clr:
	move.l	d0,(a0)+			; zurücksetzen 4 bytes							- 8 * 12 Zyklen
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	dbra	d7,Clr				; und wir machen 1/32 der Schleifen				- 10 Zyklen	/ (1*14 Zyklen)				
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt	
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Table:
	blk.b 1200,$FF				; 1200 Bytes, die gelöscht werden sollen
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13e4.s
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
000218D0 66f6                     BNE.B #$f6 == $000218c8 (T)
000218D2 41f9 0002 18fe           LEA.L $000218fe,A0
000218D8 7000                     MOVEQ #$00,D0
000218DA 3e3c 0024                MOVE.W #$0024,D7
000218DE 20c0                     MOVE.L D0,(A0)+ [12345678]
000218E0 20c0                     MOVE.L D0,(A0)+ [12345678]
000218E2 20c0                     MOVE.L D0,(A0)+ [12345678]
000218E4 20c0                     MOVE.L D0,(A0)+ [12345678]
000218E6 20c0                     MOVE.L D0,(A0)+ [12345678]
000218E8 20c0                     MOVE.L D0,(A0)+ [12345678]
>f 218D2																		; step 2 - set breakpoint
Breakpoint added.
>fl																				; step 2b
0: PC == 000218d2 [00000000 00000000]
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
																				; WinUAE-Debugger output
  D0 0000004B   D1 00C50000   D2 00000000   D3 0000FFFF							
  D4 00000000   D5 0000FFFF   D6 00000000   D7 0000FFFF
  A0 00024204   A1 00C5CC12   A2 00C5CC5C   A3 00C5CB23
  A4 00C5B940   A5 00000011   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000000
000218D2 41f9 0002 18fe           LEA.L $000218fe,A0
Next PC: 000218d8
;------------------------------------------------------------------------------
>fi 4e71																		; step 5 - run to command nop (fi nop)
Cycles: 1975 Chip, 3950 CPU. (V=0 H=18 -> V=8 H=177)							; complete cycle and bus usage
  D0 00000000   D1 00C50000   D2 00000000   D3 0000FFFF
  D4 00000000   D5 0000FFFF   D6 00000000   D7 0000FFFF
  A0 00021D9E   A1 00C5CC12   A2 00C5CC5C   A3 00C5CB23
  A4 00C5B940   A5 00000011   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 4e71 (NOP) Chip latch 00000000
000218F2 4e71                     NOP
Next PC: 000218f4
;------------------------------------------------------------------------------
>fd																				; step 6 - breakpoint löschen
All breakpoints removed.
>x																				; step 7 - Debugger verlassen

	end

;------------------------------------------------------------------------------
Zusammenfassung: 3950
12+4+8+37*(8*12)+36*10+14=3950

>?12+4+8+37*8*12+36*10+14
0x00000F6E = %00000000000000000000111101101110 = 3950 = 3950
>

;------------------------------------------------------------------------------
																				; Speicher kontrollieren

>m 218fe 4b
000218fe 0000 0000 0000 0000 0000 0000 0000 0000  ................
...
00021D9E FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
																				; Passt nicht! 16Bytes zu wenig gelöscht!

																				; Warum?
																				; Anzahl der Bytes geteilt durch 32
																				; 1200/32=37,5

>?8*4*37
0x000004A0 = %00000000000000000000010010100000 = 1184 = 1184
>?8*4*38
0x000004C0 = %00000000000000000000010011000000 = 1216 = 1216
>

; Lösung am Ende noch 4 x 
		move.l	d0,(a0)+		; 4* 12 Zyklen
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.l	d0,(a0)+
; anhängen

;------------------------------------------------------------------------------
Zusammenfassung: 3950 + (4*12)=3998
12+4+8+37*(8*12)+36*10+14=3950+48
