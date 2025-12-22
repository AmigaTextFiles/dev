
; Listing11g6.s -  Verwendung der Coppereigenschaft,  einen "MOVE"
				; durchzuführen erfordert horizontal 8 Pixel.

	SECTION	copfantasia,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup2.s" ; speichern Sie Interrupt, DMA und so weiter.
*****************************************************************************

			;5432109876543210
DMASET	EQU	%1000001010000000	; copper DMA aktivieren

WaitDisk	EQU	30				; 50-150 zur Rettung (je nach Fall)

NUMLINES	=	80


START:	
	BSR.W	MAKE_IT				; copperliste erstellen!

	lea	$dff000,a5
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren copper
	move.l	#COPLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$0e000,d2			; warte auf Zeile $e0
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; warte auf Zeile $e0
	BNE.S	Waity1

	BTST	#2,$16(a5)			; richtige Taste gedrückt?
	BEQ.s	Blocca

	BSR.w	FantaCop			; Farben rollen...

Blocca:
	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse

	rts

*****************************************************************************
*		Routine dadurch wird die copperliste mit dem Effekt erstellt	    *
*****************************************************************************

;	  ____________
;	  \          /
;	   \________/
;	     |  ._|_
;	    ____|o \
;	 ___(°__|___)___
;	 \_/  (___)/\\_/
;	  / \_____/  \\
;	_/     \______\\_
;	\_______________/g®m


MAKE_IT:
	MOVE.L	#$5001FFFE,D2		; $50 = erste vertikale Zeile
	LEA	COPBUF,A0				; Adresse copper Puffer
	MOVEQ	#NUMLINES-1,D6		; Anzahl Zeilen...
MAIN0:
	LEA	COLORS(PC),A1			; Tabelle mit Farben...
	MOVEQ	#32-1,D7			; Anzahl 
	MOVE.L	D2,(A0)+			; das WAIT setzen
	MOVE.L	#$01800505,(A0)+	; color0
COP0:
	MOVE.W	#$0180,(A0)+		; Register COLOR0
	MOVE.W	(A1)+,(A0)+			; Wert von color0 aus der Tabelle entnommen
	DBRA	d7,COP0				; Mache eine Zeile mit 32 color0...
	MOVE.L	#$01800505,(A0)+	; COLOR0 setzen
	ADDI.L	#$01020000,D2		; Warte 1 Zeile darunter und 2 weitere nach vorne
								; um die "diagonale" zu erstellen.
	DBRA	d6,MAIN0			; alle Zeilen machen
	RTS

; Tabelle Farben

COLORS:
	DC.W	$100,$101,$202,$303,$404,$505,$606,$707
	DC.W	$808,$909,$A0A,$B0B,$C0C,$D0D,$E0E,$F0F
	DC.W	$F0F,$E0E,$D0D,$C0C,$B0B,$A0A,$909,$808
	DC.W	$707,$606,$505,$404,$303,$202,$101,$100

*****************************************************************************
*		Routine, die die Farben des Effekts wechselt					    *
*****************************************************************************

;	    __
;	   (((________.
;	    \_____.---|
;	     ____ |---|
;	  ___(°__||---|__
;	 /   ___  )__/_ /
;	/______)\   _/_/
;	     \___\ /\
;	       \__/g®m


FantaCop:
	LEA	COPBUF+8,A0				; erste Adresse mit dem Zyklus
	MOVEQ	#NUMLINES-1,D6		; Anzahl der zu erledigenden Zeilen
MOVE1:
	MOVE.W	2(A0),D0			; Speichern der ersten Farbe in d0
MOVE0:
	MOVE.W	2(A0),-2(A0)		; Kopiere die 32 Farben der Zeile
	MOVE.W	6(A0),2(A0)			; "zurück" an einen Ort.							
	MOVE.W	6+4(A0),2+4(A0)
	MOVE.W	6+4*2(A0),2+4*2(A0)
	MOVE.W	6+4*3(A0),2+4*3(A0)
	MOVE.W	6+4*4(A0),2+4*4(A0)
	MOVE.W	6+4*5(A0),2+4*5(A0)
	MOVE.W	6+4*6(A0),2+4*6(A0)
	MOVE.W	6+4*7(A0),2+4*7(A0)
	MOVE.W	6+4*8(A0),2+4*8(A0)
	MOVE.W	6+4*9(A0),2+4*9(A0)
	MOVE.W	6+4*10(A0),2+4*10(A0)
	MOVE.W	6+4*11(A0),2+4*11(A0)
	MOVE.W	6+4*12(A0),2+4*12(A0)
	MOVE.W	6+4*13(A0),2+4*13(A0)
	MOVE.W	6+4*14(A0),2+4*14(A0)
	MOVE.W	6+4*15(A0),2+4*15(A0)
	MOVE.W	6+4*16(A0),2+4*16(A0)
	MOVE.W	6+4*17(A0),2+4*17(A0)
	MOVE.W	6+4*18(A0),2+4*18(A0)
	MOVE.W	6+4*19(A0),2+4*19(A0)
	MOVE.W	6+4*20(A0),2+4*20(A0)
	MOVE.W	6+4*21(A0),2+4*21(A0)
	MOVE.W	6+4*22(A0),2+4*22(A0)
	MOVE.W	6+4*23(A0),2+4*23(A0)
	MOVE.W	6+4*24(A0),2+4*24(A0)
	MOVE.W	6+4*25(A0),2+4*25(A0)
	MOVE.W	6+4*26(A0),2+4*26(A0)
	MOVE.W	6+4*27(A0),2+4*27(A0)
	MOVE.W	6+4*28(A0),2+4*28(A0)
	MOVE.W	6+4*29(A0),2+4*29(A0)
	MOVE.W	6+4*30(A0),2+4*30(A0)
	MOVE.W	6+4*31(A0),2+4*31(A0)
	lea	4*32(a0),A0				; Wir zeigen auf die nächste Zeile
	MOVE.W	D0,-(A0)			; Legen Sie die erste als letzte gespeicherte Farbe ein,
								; um den Zyklus nicht zu unterbrechen.
	lea	14(a0),A0				; überspringe das Warten + bewege "extern"
	DBRA	d6,MOVE1			; Wir führen alle Zeilen aus
	RTS

*****************************************************************************

	SECTION	COPPY,DATA_C

COPLIST:
	dc.w	$100,$200			; bplcon0 - keine bitplanes.
COPBUF:
	ds.b	NUMLINES*12+numlines*$20*4 ; Raum für den Effekt
	dc.w	$ffff,$fffe			; Ende copperlist

	end
