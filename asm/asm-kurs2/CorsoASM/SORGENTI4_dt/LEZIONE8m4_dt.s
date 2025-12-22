
; Lezione8m4.s - Punktdruckroutine (Plot), verwendet in einer Schleife für die
				; Berechnung von y = a * x * x oder Parabeln

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

;	     ______
;	    /      \
;	   /   oo   \
;	   \___()___/
;	   /       ¬\
;	   \________/
;	   /       ¬\
;	 __\________/__
;	(_____/  \_____)CNT

;	Y=a*x*x, Koeffizienten*d0*d0=d1

CalcolaParabola:
	Addq.W	#1,Miox			; Erhöhen Sie das X
	move.w	Miox(PC),d1
	Mulu.w	d1,d1			; x*x
	Mulu.w	Coeff(PC),d1	; y=a*x*x
	lsr.w	#8,d1			; dividiere durch 256 das Y um "zu erweitern"

	cmp.w	#256,MioY		; Sind wir unter dem Bildschirm?
	bhi.s	Riparti			; dann haben wir nur 1 Bildschirm !!! wir teilen
	cmp.w	#319-160,MioX	; Sind wir ganz rechts auf dem Bildschirm?
	ble.s	NonFinito
Riparti:
	addq.w	#1,Coeff	; Addiere 1 zum Koeffizienten der Parabel
	cmp.w	#3,Coeff	; Haben wir schon 2 Gleichnisse gemacht?
	beq.s	Finito		; Wenn ja, gehen wir raus!
	move.w	#-160,Miox	; Beginnen Sie erneut mit X = -160 für die neue Parabel
	rts					; Diesmal gibt es nichts zu zeichnen.

NonFinito:
	move.w	d1,MioY

; Zeichnen wir den Punkt:

	move.w	Miox(PC),d0	; Koordinate X
	add.w	#160,d0		; gehe vorwärts 160, seit der Berechnung
						; von -160 bis +160, in dem ich die Koordinaten von 
						; 0 bis 320 normalisieren muss ... auf diese Weise
						; bewege ich die Parabel nach rechts.
	move.w	Mioy(PC),d1	; Koordinate  Y
	bsr.s	plotPIX		; Drucken Sie den Punkt auf die Koordinate. X=d0, Y=d1

	rts


MioX:
	dc.w	-160		; Ich beginne von -160, um die Parabel zu "zentrieren".
MioY:
	dc.w	0

Coeff:
	dc.w	1

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
							; von 8, vorher gemacht)
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

Die wichtigste Änderung hierbei ist, dass wir die Parabel in Richtung rechts
"verschoben" haben und "entdecken" auch den negativen Teil, der sich erhebt:

		**
      *	    *
   *	      *
 *		 0		*
       NULL

Wie Sie aus dem Schema ersehen können, ist die Kurve mit dem X kleiner als Null genau 
umgekehrt.
Um es dann zu sehen, fange einfach mit einem x von -160 an bis zu +160. 
Verschieben Sie dann das Ganze nach rechts von 160 und zentrieren Sie die
Parabel, mit einem einfachen ADD.W #160,d0. -160 wird 0 und +160 wird 320.

In diesem Beispiel haben wir auch einen Koeffizienten eingefügt, für den
multipliziere x * x und erhalte 2 Parabeln, eine "breitere" andere.

Eine letzte Anmerkung: um das Gleichnis "sichtbarer" und weniger punktiert zu machen.
Die Y-Koordinate wird durch 256 mit einem LSR #8 geteilt.

	lsr.w	#8,d1		; dividiere durch 256 das Y um "zu erweitern"

Wie Sie wissen, können Sie mit lsr durch Potenzen von 2 dividieren oder durch lsl 
multiplizieren, auch wenn es einem MULU oder DIVU nicht wirklich "ebenbürtig" ist. 
In diesem Fall aber funktioniert es ganz gut...

P.S: Ab diesem Listing wird die PlotPIX-Routine ohne Megakommentare 
von den vorherigen Listings sein...  es ist nutzlos, die Quelle zu verlängern!

