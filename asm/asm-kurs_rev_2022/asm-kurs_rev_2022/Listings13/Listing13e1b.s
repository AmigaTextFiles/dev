
; Listing13e1b.s	; Speicherbereich löschen - schlechte Methode
					; Cycle and Bus Counting
; Zeile 1425

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;
	lea	Table,a0				; Zeiger auf Tabelle							- 12 Zyklen
	move.w	#1200-1,d7			; Anzahl Schleifen 1200							-  8 Zyklen
CleaLoop:
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
Filename: Listing13e1b.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - memory view
>d pc																			; step 1
00022F98 66f6                     BNE.B #$f6 == $00022f90 (T)
00022F9A 41f9 0002 2fb6           LEA.L $00022fb6,A0							; adress from table is $00022fb6
00022FA0 3e3c 04af                MOVE.W #$04af,D7
00022FA4 4218                     CLR.B (A0)+ [ff]
00022FA6 56cf fffc                DBNE.W D7,#$fffc == $00022fa4 (T)
00022FAA 4e71                     NOP
00022FAC 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
00022FB4 4e75                     RTS
00022FB6 ffff                     ILLEGAL
00022FB8 ffff                     ILLEGAL
>
;------------------------------------------------------------------------------
																				; we know the startadress from our table is $00022fb6
>?$22fb6+1200																	; the last byte from this table is 1200-1 bytes further, so $00022fb6+1199=$23465
0x00023466 = %00000000000000100011010001100110 = 144486 = 144486				; so $23466 is the first byte after this table
>																				; we check this
>m $22fb6																		; step 2
00022FB6 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FC6 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00022FD6 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
...
>m																				; step 2 - more memory ...
>m 
00023446 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023456 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
00023466 0000 1234 5678 0101 0000 0014 0000 0000  ...4Vx..........				; so $23466 is the first byte after this table
;------------------------------------------------------------------------------
																				; how could we calculate the lines?
																				; one memory line shows 8 words or 16bytes
																				; 1200 bytes/ 16 bytes per line = 75
																				; but winuae debugger will have the hex number so $4b
;>m $22fb6 75																	; we will run to wide
>m $22fb6 4b																	; step 3 - lines as hex-number - good to know!
00022FB6 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
...
00023456 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
>
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 2 - single step
>d pc																			; step 4
00022F98 66f6                     BNE.B #$f6 == $00022f90 (T)
00022F9A 41f9 0002 2fb6           LEA.L $00022fb6,A0							; adress from table is $00022fb6
00022FA0 3e3c 04af                MOVE.W #$04af,D7
00022FA4 4218                     CLR.B (A0)+ [ff]
00022FA6 56cf fffc                DBNE.W D7,#$fffc == $00022fa4 (T)
00022FAA 4e71                     NOP
00022FAC 33fc c000 00df f09a      MOVE.W #$c000,$00dff09a
00022FB4 4e75                     RTS
00022FB6 ffff                     ILLEGAL
00022FB8 ffff                     ILLEGAL
>
;------------------------------------------------------------------------------
>fd
All breakpoints removed.
>f 22F9A																		; step 5 - set breakpoint	
Breakpoint added.
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 6 - run program
Breakpoint 0 triggered.															; step 7 - press now left mousebutton
	D0 00000000   D1 00000000   D2 00000000   D3 00000000							; WinUAE-Debugger output
	D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
	A0 00023DB2   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 0002 (OR) 41f9 (LEA) Chip latch 00000000
00022F9A 41f9 0002 2fb6           LEA.L $00022fb6,A0
Next PC: 00022fa0
>t																				; step 8 - LEA.L $00022fb6,A0 = 12 cycles
Cycles: 6 Chip, 12 CPU. (V=0 H=34 -> V=0 H=40)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
	A0 00022FB6   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 04af (SUB) 3e3c (MOVE) Chip latch 00000000
00022FA0 3e3c 04af                MOVE.W #$04af,D7
Next PC: 00022fa4 
>t																				; step 9 - MOVE.W #$04af,D7 = 8 cycles
Cycles: 4 Chip, 8 CPU. (V=0 H=40 -> V=0 H=44)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 000004AF
	A0 00022FB6   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 56cf (DBcc) 4218 (CLR) Chip latch 00000000
00022FA4 4218                     CLR.B (A0)+ [ff]
Next PC: 00022fa6
>t																				; step 10 - CLR.B (A0)+ = 12 cycles
Cycles: 6 Chip, 12 CPU. (V=0 H=44 -> V=0 H=50)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 000004AF
	A0 00022FB7   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch fffc (ILLEGAL) 56cf (DBcc) Chip latch 00000000
00022FA6 56cf fffc                DBNE.W D7,#$fffc == $00022fa4 (F)
Next PC: 00022faa
>t																				; step 11 - DBNE.W D7,#$fffc = 10 cycles
Cycles: 5 Chip, 10 CPU. (V=0 H=50 -> V=0 H=55)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 000004AE
	A0 00022FB7   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 56cf (DBcc) 4218 (CLR) Chip latch 00000000
00022FA4 4218                     CLR.B (A0)+ [ff]
Next PC: 00022fa6
;------------------------------------------------------------------------------
																				; task 3 - verify 14 cycles for last DBNE	
>fo d7==0																		; step 12 - set breakpoint if d7=0		 													
Breakpoint added.
>fl
0: D7 == 00000000 [ffffffff 00000000]

>g																				; step 13 - run
Breakpoint 0 triggered.
Cycles: 13178 Chip, 26356 CPU. (V=0 H=55 -> V=58 H=67)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00023465   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 56cf (DBcc) 4218 (CLR) Chip latch 00000000
00022FA4 4218                     CLR.B (A0)+ [ff]
Next PC: 00022fa6
>t																				; step 14
Cycles: 6 Chip, 12 CPU. (V=58 H=67 -> V=58 H=73)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 00000000
	A0 00023466   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch fffc (ILLEGAL) 56cf (DBcc) Chip latch 00000000
00022FA6 56cf fffc                DBNE.W D7,#$fffc == $00022fa4 (F)				
Next PC: 00022faa
>t																				; step 15 - DBNE.W D7,#$fffc (14 cycles)
Cycles: 7 Chip, 14 CPU. (V=58 H=73 -> V=58 H=80)
	D0 00000000   D1 00000000   D2 00000000   D3 00000000
	D4 00000000   D5 00000000   D6 00000000   D7 0000FFFF
	A0 00023466   A1 00000000   A2 00000000   A3 00000000
	A4 00000000   A5 00000000   A6 00000000   A7 00C5FED8
USP  00C5FED8 ISP  00C60ED8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 4e71 (NOP) Chip latch 00000000
00022FAA 4e71                     NOP
Next PC: 00022fac
>

;------------------------------------------------------------------------------
																				; task 4 - memory view
>m $22fb6 4b																	; step 16 - control the result	
00022FB6 0000 0000 0000 0000 0000 0000 0000 0000  ................
...
00023456 0000 0000 0000 0000 0000 0000 0000 0000  ................

