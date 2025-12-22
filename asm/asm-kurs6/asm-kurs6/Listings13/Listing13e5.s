
; Listing13e5.s	; Speicherbereich löschen - es geht noch besser
				; Cycle and Bus Counting
; Zeile 1492

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------; 
	movem.l	d0-d7/a0-a6,-(sp)	; alle Register speichern								; 128 Zyklen
	move.l	a7,SalvaStack		; wir speichern den Stack in einem Label				; 20 Zyklen
	movem.l	CLREG(PC),d0-d7/a0-a6	; Wir setzen alle Register mit nur					; 136 Zyklen
								; einem Movem aus einem Puffer von Nullen zurück.		
	lea	Table+1200,a7			; in A7 einfügen (oder SP, es ist das gleiche Register)	; 12 Zyklen
								; die Adresse des Endes des zu reinigenden Bereichs.
	moveq	#21-1,d7			; Anzahl der auszuführenden movem (2100/56=21)			; 4 Zyklen
CleaLoop:
	movem.l	d0-d6/a0-a6,-(a7)	; Wir setzen "rückwärts" zurück 56 bytes.				; 120 Zyklen
								; Wenn Sie sich erinnern, das movem arbeitet
								; schreibend "rückwärts" für den Stack.
	dbra	d7,CleaLoop																	; 10 Zyklen / (1*14 Zyklen)
	movem.l	d0-d5,-(a7)	  		; die hohen 24 bytes zurücksetzen						; 56 Zyklen
	move.l	SalvaStack(PC),a7 	; den Stack wieder in SP setzen							; 16 Zyklen
	movem.l	(sp)+,d0-d7/a0-a6	; Wert der Register zurücksetzen						; 132 Zyklen
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	rts

	; 15 Longs gelöscht, um in die Register geladen zu werden, um sie zu löschen
CLREG:
	dcb.l	15,0

SalvaStack:
	dc.l	0

Table:
	blk.b 1200,$FF				; 1200 Bytes, die gelöscht werden sollen
		
	end

;------------------------------------------------------------------------------
r
Filename: Listing13e5.s
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
00027594 0839 0006 00bf e001      btst.b #$0006,$00bfe001
0002759c 66f6                     bne.b #$f6 == $00027594 (T)
0002759e 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
000275a2 23cf 0002 7612           move.l a7,$00027612 [00000000]
000275a8 4cfa 7fff 002a           movem.l (pc,$002a) == $000275d6,d0-d7/a0-a6
000275ae 4ff9 0002 7ac6           lea.l $00027ac6,a7
000275b4 7e14                     moveq #$14,d7
000275b6 48e7 fefe                movem.l d0-d6/a0-a6,-(a7)
000275ba 51cf fffa                dbf .w d7,#$fffa == $000275b6 (F)
000275be 48e7 fc00                movem.l d0-d5,-(a7)
>f 2759e																		; step 2 - set breakpoint
Breakpoint added.
>fl																				; step 2b

0: PC == 0002759e [00000000 00000000]

;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton
Cycles: 2837454 Chip, 5674908 CPU. (V=105 H=13 -> V=105 H=17) 					; WinUAE-Debugger output
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e7 (MVMLE) fffe (ILLEGAL) Chip latch 00000000
0002759e 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
Next PC: 000275a2
;------------------------------------------------------------------------------
>fi nop																			; step 5 - run to command nop (fi nop)					
Cycles: 1619 Chip, 3238 CPU. (V=105 H=17 -> V=112 H=47)							; complete cycle and bus usage
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 00000000
000275ca 4e71                     nop
Next PC: 000275cc
;------------------------------------------------------------------------------
>fd																				; step 6 - delete breakpoint
All breakpoints removed.
>x																				; step 7 - leave debugger

	end

;------------------------------------------------------------------------------
Zusammenfassung: 3238
128+20+136+12+4+21*120+20*10+14+56+16+132=3238

>?128+20+136+12+4+21*120+20*10+14+56+16+132
0x00000CA6 = %00000000000000000000110010100110 = 3238 = 3238
>
																				; Speicher checken
;------------------------------------------------------------------------------
r
Filename: Lektion13e5.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d PC
0002701C 66f6                     BNE.B #$f6 == $00027014 (T)
0002701E 48e7 fffe                MOVEM.L D0-D7/A0-A6,-(A7)
00027022 23cf 0002 7092           MOVE.L A7,$00027092 [00000000]
00027028 4cfa 7fff 002a           MOVEM.L (PC,$002a) == $00027056,D0-D7/A0-A6
0002702E 4ff9 0002 7546           LEA.L $00027546,A7
00027034 7e14                     MOVEQ #$14,D7
00027036 48e7 fefe                MOVEM.L D0-D6/A0-A6,-(A7)
0002703A 51cf fffa                DBF .W D7,#$fffa == $00027036 (F)
0002703E 48e7 fc00                MOVEM.L D0-D5,-(A7)
00027042 2e7a 004e                MOVEA.L (PC,$004e) == $00027092 [00000000],A7
>fd
All breakpoints removed.
>f 2701E
Breakpoint added.
>
;------------------------------------------------------------------------------
																				; Speicher
																				; lea	Table+1200,a7 - aber Achtung wir löschen Richtung untere Adressen
>?$27546-1200																	; LEA.L $00027546,A7 - zurückgehen zu table
0x00027096 = %00000000000000100111000010010110 = 159894 = 159894
>m 27096 2
00027096 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
000270A6 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................
>m 27096-6 1																	; ok FFFF starts on adress $27096
00027090 0000 0000 0000 FFFF FFFF FFFF FFFF FFFF  ................

>?$27096+!1200
0x00027546 = %00000000000000100111010101000110 = 161094 = 161094
>

>m 27096 4b																		; $4b = 75	--> 75*(8*2bytes)=1200bytes
00027096 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				; start $27096
...
00027536 FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF  ................				; end 	
>m
00027546 0000 1234 5678 0101 0000 0018 0101 0000  ...4Vx..........
;------------------------------------------------------------------------------
>x

;------------------------------------------------------------------------------
																				; start the programm																				
																				; the program is waiting for the left mouse button
>d PC
0002701E 48e7 fffe                MOVEM.L D0-D7/A0-A6,-(A7)
00027022 23cf 0002 7092           MOVE.L A7,$00027092 [00000000]
00027028 4cfa 7fff 002a           MOVEM.L (PC,$002a) == $00027056,D0-D7/A0-A6
0002702E 4ff9 0002 7546           LEA.L $00027546,A7
00027034 7e14                     MOVEQ #$14,D7
00027036 48e7 fefe                MOVEM.L D0-D6/A0-A6,-(A7)
0002703A 51cf fffa                DBF .W D7,#$fffa == $00027036 (F)
0002703E 48e7 fc00                MOVEM.L D0-D5,-(A7)
00027042 2e7a 004e                MOVEA.L (PC,$004e) == $00027092 [00000000],A7
00027046 4cdf 7fff                MOVEM.L (A7)+,D0-D7/A0-A6
;------------------------------------------------------------------------------
>fi 4e71
Cycles: 1619 Chip, 3238 CPU. (V=210 H=34 -> V=217 H=64)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60DB0
USP  00C60DB0 ISP  00C61DB0
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 33fc (MOVE) 4e71 (NOP) Chip latch 00000000
0002704A 4e71                     NOP
Next PC: 0002704c
;------------------------------------------------------------------------------
>m 27096 4b																		; Speicherbereich gereinigt
00027096 0000 0000 0000 0000 0000 0000 0000 0000  ................
...
00027536 0000 0000 0000 0000 0000 0000 0000 0000  ................
>m
00027546 0000 1234 5678 0101 0000 0018 0101 0000  ...4Vx..........