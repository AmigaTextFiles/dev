
; Lezione8m5.s - Punktdruckroutine (Plot), verwendet in einer Schleife für die
;				 Berechnung y = a * x * x oder Parabeln

	Section	dotta,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"startup1.s"	; damit mache ich Einsparungen und schreib es 
							; nicht jedes mal neu!	
*****************************************************************************


; Mit DMASET entscheiden wir, welche DMA-Kanäle geöffnet und welche geschlossen werden sollen

			;5432109876543210
DMASET	EQU	%1000001110000000	; copper und bitplane DMA aktivieren
;			 -----a-bcdefghij


START:
;	ZEIGER AUF BITPLANE

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
								; und sprites.

	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; Deaktivieren Sie die AGA
	move.w	#$c00,$106(a5)		; Deaktivieren Sie die AGA
	move.w	#$11,$10c(a5)		; Deaktivieren Sie die AGA

	lea	bitplane,a0		; Bitplane-Adresse, an der gedruckt werden soll

mouse:
	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile = $130 (304)
Waity1:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile = $130 (304)
	BNE.S	Waity1

	bsr.s	CalcolaParabola	; y=a*x*x

	MOVE.L	#$1ff00,d1	; Bit zur Auswahl durch UND
	MOVE.L	#$13000,d2	; Warte auf Zeile = $130 (304)
Aspetta:
	MOVE.L	4(A5),D0	; VPOSR und VHPOSR - $dff004/$dff006
	ANDI.L	D1,D0		; Wählen Sie nur die Bits der vertikalen Pos.
	CMPI.L	D2,D0		; Warte auf Zeile = $130 (304)
	BEQ.S	Aspetta

	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	mouse
Finito:
	btst	#6,$bfe001	; Maus gedrückt?
	bne.s	Finito
	rts					; exit

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
	Addq.W	#1,Miox			; Erhöhen Sie das X
	move.w	Miox(PC),d1
	Mulu.w	d1,d1			; x*x
	Mulu.w	Coeff(PC),d1	; y=a*x*x
	lsr.w	#8,d1			; dividiere durch 256 um das Y "zu erweitern"

	cmp.w	#255,MioY		; Sind wir unter dem Bildschirm?
	bhi.s	Riparti			; dann haben wir nur 1 Bildschirm !!! wir teilen
	cmp.w	#319-160,MioX	; Sind wir ganz rechts auf dem Bildschirm?
	ble.s	NonFinito
Riparti:
	addq.w	#1,Coeff	; Addiere 1 zum Koeffizienten der Parabel
	cmp.w	#6,Coeff	; Wir sind schon bei Coeff = 6
	beq.s	Finito		; Wenn ja, gehen wir raus!
	tst.w	Coeff		; Sind wir bei null
	bne.s	OkCoeff		; Wenn nicht, ist das in Ordnung
	addq.w	#1,Coeff	; sonst springen wir sofort auf 1!
OkCoeff:
	move.w	#-160,Miox	; Beginnen Sie erneut mit X = -160 für die neue Parabel
	rts					; Diesmal gibt es nichts zu plotten.

NonFinito:
	move.w	d1,MioY

; Zeichnen wir den Punkt:

	move.w	Miox(PC),d0	; Koordinate X
	add.w	#160,d0		; gehe vorwärts 160, seit der Berechnung
						; von -160 bis +160, in dem ich mich normalisieren muss
						; koordiniere 0 bis 320 ... auf diese Weise habe ich
						; die Parabel nach rechts bewegt.
	move.w	Mioy(PC),d1	; Koordinate Y
	bsr.s	plotPIX		; Drucken Sie den Punkt auf die Koordinate. X = d0, Y = d1

	rts


MioX:
	dc.w	-160	; Ich beginne von -160, um die Parabel zu "zentrieren".
MioY:
	dc.w	0

Coeff:
	dc.w	-5

*****************************************************************************
;			Routine zum Plotten eines Punktes (dots)
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

LargSchermo	equ	40			; Bildschirmbreite in Bytes.


PlotPIX:
	move.w	d0,d2			; Kopieren Sie die Koordinate X in d2
	lsr.w	#3,d0			; In der Zwischenzeit finden Sie den horizontalen Versatz,
							; Teilen Sie die X-Koordinate durch 8.
	mulu.w	#largschermo,d1
	add.w	d1,d0			; Offset vertikal bis horizontal

	and.w	#%111,d2		; Wählen Sie nur die ersten 3 Bits von X aus
							; (In Wirklichkeit wäre es der Rest der Division
							; für 8, vorher gemacht)
	not.w	d2

	bset.b	d2,(a0,d0.w)	; Setzen Sie das Bit d2 des bytefernen Bytes d0
							; vom Anfang des Bildschirms.
	rts

*****************************************************************************

	SECTION	GRAPHIC,DATA_C

COPPERLIST:

	dc.w	$8E,$2c81	; DiwStrt
	dc.w	$90,$2cc1	; DiwStop
	dc.w	$92,$0038	; DdfStart
	dc.w	$94,$00d0	; DdfStop
	dc.w	$102,0		; BplCon1
	dc.w	$104,$24	; BplCon2 - Alle Sprites über der Bitplane
	dc.w	$108,0		; Bpl1Mod
	dc.w	$10a,0		; Bpl2Mod
				 ; 5432109876543210
	dc.w	$100,%0001001000000000	; 1 bitplane LOWRES 320x256

BPLPOINTERS:
	dc.w $e0,0,$e2,0	; erste bitplane

	dc.w	$0180,$000	; color0 - HINTERGRUND
	dc.w	$0182,$1af	; color1 - SCHRIFT

	dc.w	$FFFF,$FFFE	; Ende copperlist


*****************************************************************************

	SECTION	MIOPLANE,BSS_C

BITPLANE:
	ds.b	40*256	; eine bitplane lowres 320x256

	end

In diesem Listing ist die einzige Änderung, dass wir auch negative Koeffizienten 
verwenden.

