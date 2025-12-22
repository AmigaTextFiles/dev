
; Lezione8m.s - Punktdruckroutine (Plot), verwendet in einer Schleife für
			 ; eine Linie machen.

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

Coeff	equ	1	; Winkelkoeffizient, m

START:
;	 ZEIGER AUF BITPLANE

	MOVE.L	#BITPLANE,d0
	LEA	BPLPOINTERS,A1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	MOVE.W	#DMASET,$96(a5)		; DMACON - abilita bitplane, copper
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

;	Y=m*x, oder am besten m*x=y, d.h. Coeff*d0=d1

	Addq.W	#1,Miox		; Erhöhen Sie das X
	move.w	Miox(PC),d1
	Mulu.w	#Coeff,d1	; Y=m*x
	cmp.w	#255,d1		; Sind wir am unteren Bildschirmrand?
	bhi.s	Finito
	move.w	Miox(PC),d0	; X

	bsr.s	plotPIX		; Drucken Sie den Punkt auf die Koordinate. X=d0, Y=d1

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

MioX:
	dc.w	0

*****************************************************************************
;			Routine zum Plotten eines Punktes (dots)
*****************************************************************************

;	Eingehende Parameter von PlotPIX:
;
;	a0 = Ziel-Bitplane-Adresse
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

LargSchermo	equ	40	; Bildschirmbreite in Bytes.

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
	move.w	d0,d2		; Kopieren Sie die Koordinate X in d2


; Wir finden den horizontalen Versatz, dh das X

	lsr.w	#3,d0		; In der Zwischenzeit finden Sie den horizontalen Versatz,
						; dividiert durch 8 die X-Koordinate
						; Bildschirm aus Bits, wir kennen das
						; Die horizontale Linie ist also 320 Pixel breit
						; 320/8 = 40 Bytes. Mit der X-Koordinate welche
						; von 0 bis 320 geht, das heißt Bits müssen wir
						; in Bytes umwandeln und durch 8 teilen.
						; Auf diese Weise haben wir das Byte, in dem
						; wir unser Bit setzen.

; Nun finden wir den vertikalen Versatz, das ist der Y:

	mulu.w	#largschermo,d1	; multiplizieren Sie die Breite einer Linie mit
						; Anzahl der Zeilen, den Offset zu finden
						; vertikal vom Beginn des Bildschirms

; Schließlich finden wir den Versatz vom Anfang des Byte-Bildschirms, wo der
; Punkt (dh Bit), den wir mit der BSET-Anweisung setzen:

	add.w	d1,d0	; Fügen Sie den vertikalen zum horizontalen Versatz hinzu

; Jetzt müssen wir in d0 den Offset, in Bytes, vom Anfang des Bildschirms finden
; Das Byte, in dem sich der einzustellende Punkt befindet. Wir müssen also 
; entscheiden, welches der 8 Bits des Bytes gesetzt sein müssen.

; Jetzt finden wir heraus, welches Bit des Bytes wir setzen müssen:

	and.w	#%111,d2	; Wählen Sie nur die ersten 3 Bits von X aus, dh
						; der Offset (Versatz) im Byte,
						; Wir erhalten in d2 das zu setzende Bit
						; (In Wirklichkeit wäre es der Rest der Division
						; von 8, vorher gemacht)

	not.w	d2			; Gegenteil

; Jetzt haben wir in d0 den Offset vom Anfang des Bildschirms, um das Byte zu finden,
; in d2 die Anzahl der innerhalb dieses Bits einzustellenden Bits und in a0 die
; Bitplane-Adresse. Mit einer einzigen Anweisung können wir das Bit setzen:

	bset.b	d2,(a0,d0.w)	; Setzen Sie das Bit d2 des bytefernen Bytes d0
							; vom Anfang des Bildschirms.
	rts			; Exit.

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

Mit einer Schleife machen wir eine Linie. Wir wissen, dass die "Formel" einer Linie 
y = m * x ist, wobei m eine Zahl ist, die als Winkelkoeffizient bezeichnet wird und 
die Neigung der Geraden selbst bestimmt.
Für diejenigen die mit Mathematik, zurückgesetzt wurden, hier in Kürze, was passiert:
Wenn wir haben, X=0 ist, ist das Y 
Wir erhalten, indem wir das X mit m multiplizieren, das hier mit einer EQU am Anfang 
definiert ist des Listings. Angenommen, Coeff ist = 1:

X = 0	-> Y=Coeff*X, d.h. 1*0, d.h. 0

deshalb, X=0 und Y=0

In der Schleife erhöhen wir das X um 1. Dies passiert mit der nächsten Schleife:

X = 1	-> Y= 1*1, nämlich 1

dann...

X = 2	-> Y=2

Kurz gesagt, das Y ist immer gleich X, weil wir es mit Coeff = 1 multiplizieren.
Daraus ergibt sich folgende Zeile:

11
  22
    33
      44
	55
	  66
	    77
	      88
		...

Ist es klar, wie es bei 45 Grad ist ??? Versuchen Sie, den Koeffizienten durch Setzen 
von m zu ändern. Beispiel 2. In diesem Fall passiert Folgendes:

X = 0	-> Y=Coeff*X, d.h. 2*0, d.h. 0
X = 1	-> Y= 2*1, d.h. 2
X = 2	-> Y= 2*2, d.h. 4
X = 3	-> Y= 2*3, d.h. 6
X = 4	-> Y= 2*4, d.h. 8
X = 5	-> Y= 2*5, d.h. 10

Die resultierende Zeile wird':

12

 24

  36

   48

    510


D. H. mehr nach links, und es geht nicht weiter. Zwischen einem Punkt und dem nächsten 
befinden sich "Löcher", weil wir nur mit ganzen Zahlen und Werten arbeiten. Zum Beispiel,
zwischen 2 und 3 verlassen wir die "Leere". Wir werden später sehen, dass es viele 
Möglichkeiten gibt emulierte Gleitkommazahlen auch ohne mathematische Coprozessoren 
zu verwenden, zum Beispiel, um 3D-Berechnungen durchzuführen.

