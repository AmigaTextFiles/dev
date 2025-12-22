
; Listing13e3.s	; Speicherbereich löschen - weiter verbessert
				; Cycle and Bus Counting
; Zeile 1450

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	lea	Table,a0				; Zeiger auf Tabelle									- 12 Zyklen
	move.w	#(1200/16)-1,d7		; Anzahl der Bytes geteilt durch 16 für das clr.l !		- 8 Zyklen
Clr:
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	clr.l	(a0)+				; zurücksetzen 4 bytes									- 20 Zyklen
	dbra	d7,Clr				; und wir machen 1/16 der Schleifen						- 10 Zyklen	/ (1*14 Zyklen)
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Table:
	blk.b 1200,$FF				; 1200 Bytes, die gelöscht werden sollen
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13e3.s
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
00023D30 66f6                     BNE.B #$f6 == $00023d28 (T)
00023D32 41f9 0002 3d54           LEA.L $00023d54,A0
00023D38 3e3c 004a                MOVE.W #$004a,D7
00023D3C 4298                     CLR.L (A0)+ [000e0000]
00023D3E 4298                     CLR.L (A0)+ [000e0000]
00023D40 4298                     CLR.L (A0)+ [000e0000]
00023D42 4298                     CLR.L (A0)+ [000e0000]
00023D44 51cf fff6                DBF .W D7,#$fff6 == $00023d3c (F)
00023D48 4e71                     NOP
00023D4A 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
>f 23D32																		; step 2 - set breakpoint
Breakpoint added.
>fl																				; step 2b
0: PC == 00023d32 [00000000 00000000]
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
  D0 0000004B   D1 00C50000   D2 00000000   D3 0000FFFF							; WinUAE-Debugger output
  D4 00000000   D5 0000FFFF   D6 00000000   D7 00000000
  A0 00C5CAFA   A1 00C5CC12   A2 00C5CC5C   A3 00C5CB23
  A4 00C5B940   A5 00000011   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000000
00023D32 41f9 0002 3d54           LEA.L $00023d54,A0
Next PC: 00023d38
;------------------------------------------------------------------------------
>fi 4e71																		; step 5 - run to command nop (fi nop)
Cycles: 3387 Chip, 6774 CPU. (V=105 H=24 -> V=120 H=6)							; complete cycle and bus usage
  D0 0000004B   D1 00C50000   D2 00000000   D3 0000FFFF
  D4 00000000   D5 0000FFFF   D6 00000000   D7 0000FFFF
  A0 00024204   A1 00C5CC12   A2 00C5CC5C   A3 00C5CB23
  A4 00C5B940   A5 00000011   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 4e71 (NOP) Chip latch 00000000
00023D48 4e71                     NOP
Next PC: 00023d4a
;------------------------------------------------------------------------------
>fd																				; step 6 - breakpoint löschen
All breakpoints removed.
>x																				; step 7 - Debugger verlassen

	end

;------------------------------------------------------------------------------
Zusammenfassung: 6774
12+8+75*(4*20)+74*10+14=9024

>?12+8+75*4*20+74*10+14
0x00001A76 = %00000000000000000001101001110110 = 6774 = 6774




