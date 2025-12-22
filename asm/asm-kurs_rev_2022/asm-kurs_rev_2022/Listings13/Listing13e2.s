
; Listing13e2.s	; Speicherbereich löschen - schlechte Methode (etwas verbessert)
				; Cycle and Bus Counting
; Zeile 1439

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	lea	Table,a0				; Zeiger auf Tabelle									- 12 Zyklen
	move.w	#(1200/4)-1,d7		; Anzahl der Bytes geteilt durch 4, für das clr.l !		- 8 Zyklen
Clr:
	Clr.l	(a0)+				; Wir setzen jeweils 4 Bytes zurück ...					- 20 Zyklen		
	dbra	d7,Clr				; und wir machen 1/4 der Schleifen.						- 10 Zyklen	/ (1*14 Zyklen)
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Table:
	blk.b 1200,$FF				; 1200 Bytes, die gelöscht werden sollen
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13d2.s
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
00023DF4 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
00023DFC 66f6                     BNE.B #$f6 == $00023df4 (T)
00023DFE 41f9 0002 3e1a           LEA.L $00023e1a,A0
00023E04 3e3c 012b                MOVE.W #$012b,D7
00023E08 4298                     CLR.L (A0)+ [00001234]
00023E0A 51cf fffc                DBF .W D7,#$fffc == $00023e08 (F)
00023E0E 4e71                     NOP
00023E10 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
00023E18 4e75                     RTS
00023E1A ffff                     ILLEGAL
>f 23DFE																		; step 2 - set breakpoint
Breakpoint added.
>fl																				; step 2b
0: PC == 00023dfe [ffffffff 00000000]

;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
  D0 00000000   D1 00000000   D2 00000000   D3 00000000							; WinUAE-Debugger output
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 0002520A   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000000
00023DFE 41f9 0002 3e1a           LEA.L $00023e1a,A0
Next PC: 00023e04
;------------------------------------------------------------------------------
>fi 4e71																		; step 5 - run to command nop (fi nop)
Cycles: 4512 Chip, 9024 CPU. (V=0 H=18 -> V=19 H=217)							; complete cycle and bus usage
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 000242CA   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 4e71 (NOP) Chip latch 00000000
00023E0E 4e71                     NOP
Next PC: 00023e10
>fd																				; step 6 - breakpoint löschen
All breakpoints removed.
>x																				; step 7 - Debugger verlassen

	end
;------------------------------------------------------------------------------
Zusammenfassung: 9024
12+8+300*20+299*10+14=9024

