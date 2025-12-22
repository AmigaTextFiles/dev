
; Listing8m5.s - Punktdruckroutine, verwendet in einer Schleife für die
;				 Berechnung y = a * x * x oder Parabeln

	Section	dotta,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"	; damit mache ich Einsparungen und 
									; schreib es nicht jedes mal neu!	
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche
; geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper und bitplane DMA aktivieren
;			 -----a-bcdefghij


START:
	MOVE.L	#BITPLANE,d0		; Adresse der Bitplane
	LEA	BPLPOINTERS,A1			; Bitplanepointer in der copperlist
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren

	lea	bitplane,a0				; Bitplane-Adresse, an der gedruckt werden soll

mouse:
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.s	CalcolaParabola		; y=a*x*x

	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2			; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0				; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0				; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	mouse
Finito:
	btst	#6,$bfe001			; Maus gedrückt?
	bne.s	Finito
	rts							; exit

;	  _       , _
;	 / \ , , /,/'
;	    \\\////
;	    /'';``\
;	   /       \
;	 _/ __  --- \_
;	(/ ___¯ ___  \)
;	/  --- (°  )  \
;	\    /  ¯¯¯   /
;	 \  ( .      /
;	  \_ o  ____/
;	   l____| T
;	      |   |xCz
;	      `---'

;	Y=a*x*x, Koeffizienten*d0*d0=d1

CalcolaParabola:
	Addq.W	#1,Miox				; das X erhöhen
	move.w	Miox(PC),d1
	Mulu.w	d1,d1				; x*x
	Mulu.w	Coeff(PC),d1		; y=a*x*x
	lsr.w	#8,d1				; dividiere durch 256 um das Y "zu erweitern"

	cmp.w	#255,MioY			; Sind wir unter dem Bildschirm?
	bhi.s	Riparti				; wenn ja, wir haben nur 1 Bildschirm !!! dann neu starten
	cmp.w	#319-160,MioX		; Sind wir ganz rechts auf dem Bildschirm?
	ble.s	NonFinito
Riparti:
	addq.w	#1,Coeff			; Addiere 1 zum Koeffizienten der Parabel
	cmp.w	#6,Coeff			; sind wir schon bei Coeff = 6
	beq.s	Finito				; Wenn ja, gehen wir raus!
	tst.w	Coeff				; Sind wir bei null
	bne.s	OkCoeff				; Wenn nicht, ist das in Ordnung
	addq.w	#1,Coeff			; sonst springen wir sofort auf 1!
OkCoeff:
	move.w	#-160,Miox			; und starten erneut mit X = -160 für die neue Parabel
	rts							; Diesmal gibt es nichts zu zeichnen.

NonFinito:
	move.w	d1,MioY

; wir zeichnen den Punkt:

	move.w	Miox(PC),d0			; Koordinate X
	add.w	#160,d0				; um 160 nach rechts verschieben, da das Ergebnis der
								; Berechnung im Bereich von -160 bis +160 liegt, damit
								; wird es auf die Koordinaten von 0 bis 320 normalisiert
								; ... auf diese Weise bewege ich die Parabel nach rechts.
	move.w	Mioy(PC),d1			; Koordinate Y
	bsr.s	plotPIX				; den Punkt auf die Koordinate X=d0, Y=d1 drucken

	rts


MioX:
	dc.w	-160				; Ich beginne von -160, um die Parabel zu "zentrieren".
MioY:
	dc.w	0

Coeff:
	dc.w	-5

*****************************************************************************
;			Routine zum Plotten eines Punktes
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

LargSchermo	equ	40				; Bildschirmbreite in Bytes.


PlotPIX:
	move.w	d0,d2				; Koordinate X in d2 kopieren 
	lsr.w	#3,d0				; den horizontalen Versatz finden, in dem wir
								; die X-Koordinate durch 8 teilen
	mulu.w	#largschermo,d1
	add.w	d1,d0				; den vertikalen zum horizontalen Versatz hinzufügen

	and.w	#%111,d2			; nur die ersten 3 Bits von X auswählen
								; (In Wirklichkeit wäre es der Rest der Division
								; durch 8, vorher gemacht)
	not.w	d2					; negieren

	bset.b	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts

*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:

	dc.w	$8E,$2c81			; DiwStrt
	dc.w	$90,$2cc1			; DiwStop
	dc.w	$92,$0038			; DdfStart
	dc.w	$94,$00d0			; DdfStop
	dc.w	$102,0				; BplCon1
	dc.w	$104,$24			; BplCon2 - Alle Sprites über der Bitplane
	dc.w	$108,0				; Bpl1Mod
	dc.w	$10a,0				; Bpl2Mod
			    ; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w	$e0,0,$e2,0			; erste bitplane

	dc.w	$0180,$000			; color0 - HINTERGRUND
	dc.w	$0182,$1af			; color1 - SCHRIFT

	dc.w	$FFFF,$FFFE			; Ende copperlist


*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256				; eine bitplane lowres 320x256

	end

In diesem Listing ist die einzige Änderung, dass wir auch negative Koeffizienten 
verwenden.

