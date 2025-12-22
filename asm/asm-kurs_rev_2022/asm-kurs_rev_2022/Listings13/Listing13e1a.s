
; Listing13e1a.s	; Speicherbereich löschen - schlechte Methode
					; Cycle and Bus Counting
; Zeile 1425

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	lea	Table,a0				; Zeiger auf Tabelle							- 12 Zyklen
	move.w	#1200-1,d7			; d7 - Schleifenzähler							-  8 Zyklen
CleaLoop:						; 
	clr.b	(a0)+				; jeweils ein Byte löschen						- 12 Zyklen		
	dbne	d7,CleaLoop			;												- 10 Zyklen / (1*14 Zyklen)
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

Table:
	blk.b 1200,$FF				; 1200 Bytes, die gelöscht werden sollen
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13e1a.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint

>d PC																			; step 1
00027638 0839 0006 00bf e001      BTST.B #$0006,$00bfe001
00027640 66f6                     BNE.B #$f6 == $00027638 (T)
00027642 41f9 0002 765e           LEA.L $0002765e,A0							; set breakpoint on this line
00027648 3e3c 04af                MOVE.W #$04af,D7
0002764C 4218                     CLR.B (A0)+ [ff]
0002764E 56cf fffc                DBNE.W D7,#$fffc == $0002764c (T)
00027652 4e71                     NOP
00027654 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
0002765C 4e75                     RTS
0002765E ffff                     ILLEGAL
>f 27642																		; step 2 - set breakpoint
Breakpoint added.
>fl																				; step 2b
0: PC == 00027642 [00000000 00000000]
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
  D0 00000000   D1 00000000   D2 00000000   D3 00000000							; WinUAE-Debugger output
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000000
000238D2 41f9 0002 38ee           LEA.L $000238ee,A0
Next PC: 000238d8
>
;------------------------------------------------------------------------------
>fi 4e71																		; step 5 - run to command nop (fi nop)
Cycles: 13212 Chip, 26424 CPU. (V=105 H=24 -> V=163 H=70)						; complete cycle and bus usage
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
  A0 00023D9E   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 4e71 (NOP) Chip latch 00000000
000238E2 4e71                     NOP
Next PC: 000238e4
>fd																				; step 6 - delete breakpoint
>x																				; step 7 - leave debugger

	end
;------------------------------------------------------------------------------

Diese Art von Code ist schrecklich!! Mal sehen, wie lange es dauert ... die
ersten zwei Anweisungen dauern 20 Zyklen, dann muss das clr.b 1200 mal
ausgeführt werden d.h. 1200 * 12 = 14400 Zyklen, außerdem muss das Dbne
hinzugefügt werden was  1199 * 10 = 11990 Zyklen durchgeführt werden muss
plus 14 am Ende.
Zusammenfassung 20 + 14400 + 11990 + 14 = 26424!!! Nun, das alles ist keinen
Kommentar wert. Wir hätten zumindest so etwas tun können: siehe Listing13e1b.s

; why disable and enable interrupts?
; Your code got interrupted, in this case by level 2 interrupt (IMASK=2 in 
; register listing). Possibly keyboard interrupt or CIA-A timer interrupt.
; Keep interrupt disabled temporarily when trying to calculate cycle usage.