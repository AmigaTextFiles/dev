
; Listing13e6.s	; Speicherbereich löschen - es geht noch besser
				; Cycle and Bus Counting

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------; Lektion13 Zeile 1519
	movem.l	d0-d7/a0-a6,-(sp)	; alle Register speichern								; 128 Zyklen
	move.l	a7,SalvaStack		; wir speichern den Stack in einem Label				; 20 Zyklen
	movem.l	CLREG(PC),d0-d7/a0-a6	; Wir setzen alle Register mit nur					; 136 Zyklen
								; einem Movem aus einem Puffer von Nullen zurück.		
	lea	Table+1200,a7			; in A7 einfügen (oder SP, es ist das gleiche Register) ; 12 Zyklen
								; die Adresse des Endes des zu reinigenden Bereichs.
CleaLoop:

	rept	20					 ; wiederholen 20 movem...
	movem.l	d0-d7/a0-a6,-(a7)	 ; Wir setzen "rückwärts" zurück 60 bytes.				; 128 Zyklen
	endr

	move.l	SalvaStack(PC),a7	; den Stack wieder in SP setzen							; 16 Zyklen
	movem.l	(sp)+,d0-d7/a0-a6	; Wert der Register zurücksetzen						; 132 Zyklen
;-------------------------------;	
	nop	
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
Filename: Lektion13e6.s
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
00029e30 66f6                     bne.b #$f6 == $00029e28 (T)
00029e32 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e36 23cf 0002 9ee8           move.l a7,$00029ee8 [00000000]
00029e3c 4cfa 7fff 006c           movem.l (pc,$006c) == $00029eac,d0-d7/a0-a6
00029e42 4ff9 0002 a39c           lea.l $0002a39c,a7
00029e48 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e4c 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e50 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e54 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e58 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
>f 29e32
Breakpoint added.
>fl
0: PC == 00029e32 [00000000 00000000]

;------------------------------------------------------------------------------
; the program is waiting for the left mouse button																			
>g																				; step 3 - run program
Breakpoint 0 triggered.															; step 4 - press now left mousebutton				
Cycles: 6583917 Chip, 13167834 CPU. (V=105 H=13 -> V=0 H=22)					; WinUAE-Debugger output
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 48e7 (MVMLE) fffe (ILLEGAL) Chip latch 00000C80
00029e32 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
Next PC: 00029e36
;------------------------------------------------------------------------------
>fi nop																			; step 5 - run to command nop (fi nop)					
Cycles: 1502 Chip, 3004 CPU. (V=0 H=22 -> V=6 H=162)							; complete cycle and bus usage
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80
USP  00C60D80 ISP  00C61D80
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e71 (NOP) 33fc (MOVE) Chip latch 0000FFFE
00029ea0 4e71                     nop
Next PC: 00029ea2
;------------------------------------------------------------------------------
>fd																				; step 6 - delete breakpoint
All breakpoints removed.
>x																				; step 7 - leave debugger

	end

;------------------------------------------------------------------------------
Zusammenfassung: 3004
128+20+136+12+20*128+16+132=3004

>?128+20+136+12+20*128+16+132
0x00000BBC = %00000000000000000000101110111100 = 3004 = 3004
>


;------------------------------------------------------------------------------
>d 29e30																		; view complete program	
00029e30 66f6                     bne.b #$f6 == $00029e28 (T)
00029e32 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e36 23cf 0002 9ee8           move.l a7,$00029ee8 [00c60d44]
00029e3c 4cfa 7fff 006c           movem.l (pc,$006c) == $00029eac,d0-d7/a0-a6
00029e42 4ff9 0002 a39c           lea.l $0002a39c,a7
00029e48 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e4c 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e50 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e54 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e58 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
>d
00029e5c 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e60 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e64 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e68 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e6c 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e70 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e74 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e78 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e7c 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e80 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
>d
00029e84 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e88 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e8c 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e90 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e94 48e7 fffe                movem.l d0-d7/a0-a6,-(a7)
00029e98 2e7a 004e                movea.l (pc,$004e) == $00029ee8 [00c60d44],a7
00029e9c 4cdf 7fff                movem.l (a7)+,d0-d7/a0-a6
00029ea0 4e71                     nop
00029ea2 33fc c000 00df f09a      move.w #$c000,$00dff09a
00029eaa 4e75                     rts  == $00c50660
>

;------------------------------------------------------------------------------
; Variante ohne rept, die das gleiche macht (aus der 3D-Lektion)

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------; aus 3D-Lektion
	movem.l	d0-d7/a0-a6,-(sp)	; alle Register speichern
	move.l	a7,SalvaStack		; wir speichern den Stack in einem Label
	movem.l	CLREG(PC),d0-d7/a0-a6	; Wir setzen alle Register mit nur
								; einem Movem aus einem Puffer von Nullen zurück.
	lea	Table+1200,a7			; in A7 einfügen (oder SP, es ist das gleiche Register)
								; die Adresse des Endes des zu reinigenden Bereichs.
CleaLoop:
	; Lassen Sie uns nun den Speicher mit vielen ausgeführten "MOVEM.L D0-D7/A0-A6,-(SP)" 
	; nacheinander löschen. Jeder Befehl setzt 60 Bytes zurück (15 Register long, das
	; macht 15*4=60 Bytes) und schreibe in -(SP). Passen Sie auf, dass es vom Ende des
	; Bildschirms (unten) beginnt und "nach oben geht" und so den Speicher zurückgeht.
	; In hex wird das Movem als "$48E7FFFE" zusammengesetzt, es ist also genug
	; eine "dcb.l number_instructions, $48e7fffe" einzugeben.

	dcb.l	20,$48E7FFFE		; 60*20=1200 bytes löschen

	move.l	SalvaStack(PC),a7	; den Stack wieder in SP setzen
	movem.l	(sp)+,d0-d7/a0-a6	; Wert der Register zurücksetzen
;-------------------------------;	
	nop	
	move.w #$C000,$dff09a		; Interrupts enable
	rts

	; 15 Longs gelöscht, um in die Register geladen zu werden, um sie zu löschen
CLREG:
	dcb.l	15,0

SalvaStack:
	dc.l	0

Table:
	blk.b 1200,$FF
		
	end