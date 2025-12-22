
; Listing8m3.s - Punktdruckroutine, verwendet in einer Schleife zur
		; Berechnnung von y = x * x, d.h. eine ähnliche Kurve wie die, die sich
		; ergibt durch den Fall eines Steins bei einem Erdrutsch (Parabel!)

	Section	dotta,CODE

;	Include	"DaWorkBench.s"	; entferne das; vor dem Speichern mit "WO"

*****************************************************************************
	include	"/Sources/startup1.s"		; damit mache ich Einsparungen und 
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

	bsr.s	CalcolaPotenza		; y=x*x

	move.w	Miox(PC),d0			; Koordinate X
	move.w	Mioy(PC),d1			; Koordinate Y

	bsr.s	plotPIX				; den Punkt auf die Koordinate X=d0, Y=d1 drucken

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

;	 _.--._     _ 
;	|   _ .|   (_)
;	|   \__|   ||
;	|______|   ||
;	.-`--'-.   ||
;	| | |  |\__l|
;	|_| |__|__|_))
;	 ||_| |    ||
;	 |(_) |
;	 |    |
;	 |____|__
;	 |______/g®m

;	Y=x*x, d0*d0=d1

CalcolaPotenza:
	Addq.W	#1,Miox				; das X erhöhen
	move.w	Miox(PC),d1
	Mulu.w	d1,d1				; y=x*x
	lsr.w	#3,d1				; wir erweitern die Parabel ein wenig
	cmp.w	#255,d1				; sind wir am unteren Bildschirmrand?
	blo.s	NonFinito
	bra.s	Finito				; Wenn ja, gehen wir raus!
	addq.w	#1,Coeff			; Addiere 1 zum Winkelkoeffizienten
	cmp.w	#80,Coeff			; Haben wir schon 39 Zeilen gemacht?
NonFinito:
	move.w	d1,MioY
	rts

MioX:
	dc.w	0
MioY:
	dc.w	0
Coeff:
	dc.w	1

*****************************************************************************
;			Routine zum Plotten eines Punktes
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

LargSchermo	equ	40				; Bildschirmbreite in Bytes.

;	     _____
;	    / ¯¬~°\
;	  _/ \   / \_
;	 (/_(¯\ /¯)_\)
;	 / / ¯° °¯ \ \
;	/  __(___)__  \
;	\ (l_T_|_T_|) /
;	 \ \_T_T_T_/ /
;	  \_ ¯ ¯ ¯ _/ xCz
;	   `-------'

PlotPIX:
	move.w	d0,d2				; Koordinate X in d2 kopieren


; Wir finden den horizontalen Versatz, dh das X

	lsr.w	#3,d0				; den horizontalen Versatz finden wir indem wir
								; die X-Koordinate durch 8 dividieren, da der
								; Bildschirm aus Bits besteht, wir wissen das
								; die horizontale Zeile 320 Pixel breit ist
								; 320/8 = 40 Bytes. Mit der X-Koordinate welche
								; von 0 bis 320 geht, das heißt Bits müssen wir
								; in Bytes umwandeln und durch 8 teilen.
								; Auf diese Weise haben wir das Byte, in dem
								; wir unser Bit setzen.

; Nun finden wir den vertikalen Versatz, das ist das Y:

	mulu.w	#largschermo,d1		; die Breite einer Zeile mit der Anzahl der Zeilen
								; multiplizieren um den vertikalen Offset
								; vom Beginn des Bildschirms zu finden

; Schließlich finden wir den Versatz vom Anfang des Byte-Bildschirms, wo der
; Punkt (dh Bit), den wir mit der BSET-Anweisung setzen:

	add.w	d1,d0				; den vertikalen zum horizontalen Versatz hinzufügen

; Jetzt haben wir in d0 den Offset, in Bytes, vom Anfang des Bildschirms
; gefunden. Das Byte, in dem sich der einzustellende Punkt befindet. Wir müssen
; nun entscheiden, welches der 8 Bits des Bytes gesetzt sein muss.

; Jetzt finden wir heraus, welches Bit des Bytes wir setzen müssen:

	and.b	#%111,d2			; nur die ersten 3 Bits von X auswählen, dh
								; der Offset (Versatz) im Byte,
								; Wir erhalten in d2 das zu setzende Bit
								; (In Wirklichkeit wäre es der Rest der Division
								; durch 8, bset.b d2,memory)

	not.b	d2					; negieren

; Jetzt haben wir in d0 den Offset vom Anfang des Bildschirms, um das Byte zu
; finden und in d2 die Stelle des einzustellenden Bits innerhalb dieses Bytes 
; und in a0 die Bitplane-Adresse. Mit einer einzigen Anweisung können wir das
; Bit setzen:

	bset.b	d2,(a0,d0.w)		; Bit d2 des Bytes setzen, das d0 Bytes 
								; vom Anfang des Bildschirms entfernt ist
	rts							; Exit.

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
	ds.b	40*256			; eine bitplane lowres 320x256

	end

Mit dieser Variante kann man so etwas bewundern:

*
 *

  *


   *




    *






      *


Leider arbeiten wir nur mit ganzen Zahlen und die Pixel zwischen einem Punkt
und einem anderen die gebrochen sind, sind nicht verfügbar. Aber besser als
nichts! Diese Art von Kurve erhalten wir durch die Berechnung des Quadrats
von x und Zuweisen des Ergebnisses an y. Auf diese Weise haben wir:

X = 0	-> Y=X*X, d.h. 0*0, d.h. 0
X = 1	-> Y= 1*1, d.h. 1
X = 2	-> Y= 2*2, d.h. 4
X = 3	-> Y= 3*3, d.h. 9
X = 4	-> Y= 4*4, d.h. 16
X = 5	-> Y= 5*5, d.h. 25

Exponentiell (exp) nimmt das Y in Bezug auf X zu.

