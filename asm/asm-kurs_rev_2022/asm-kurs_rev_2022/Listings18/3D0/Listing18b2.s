
; Listing18b2.s = Lezione3d-2b.s

	section	DotCube3d,code

; ROTATION X,Y,Z + Translation X,Y,Z (Dot-Cube)
; Zuerst die Rotation um die Mitte, dann erfolgt die Translation.

*****************************************************************************
	include "///Sources/startup2.s"		; copperlist speichern etc.
*****************************************************************************
	
			;5432109876543210
DMASET	EQU	%1000001111000000	; copper, bitplane und blitter
WaitDisk EQU	%0				; wegen startup2
LarghSchermo	=	320
LunghSchermo	=	256

START:
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#COPPERLIST,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.l	#0,$108(a5)

	move.b	$dff00a,mouse_y		; JOY0DAT vertikale Mausposition
	move.b	$dff00b,mouse_x		; horizontale Mausposition

LoopMain:
	lea	$dff000,a5
	MOVE.L	#$1ff00,d1			; Bit zur Auswahl durch UND
	MOVE.L	#$12c00,d2			; warte auf Zeile $12c
Waity1:
	MOVE.L	4(A5),D0			; VPOSR und VHPOSR - $dff004/$dff006
	AND.L	D1,D0				; wählen Sie nur die Bits der vertikalen Pos.
	CMP.L	D2,D0				; warte auf Zeile $12c
	BNE.S	Waity1

	BSR.w	ScambiaEpulisci		; Bildschirme im Doppelpuffer tauschen und
								; alten Bildschirm reinigen

	ADDQ.W	#1,ZANGLE			; Drehung um die Achse, die auf uns zu kommt
								; wir würden es als einen Punkt sehen .,
								; daher dreht sich das Objekt wie die Zeiger
								; einer Uhr, wenn SUB oder
								; gegen den Uhrzeigersinn, wenn ADD.
	ADDQ.W	#2,YANGLE			; Drehung um die VERTIKALE Achse |
	ADDQ.W	#1,XANGLE			; Drehung um eine HORIZONTALE Achse --

	BSR.w	ROTATE				; 3D-Bild drehen

	bsr.w	LeggiMouse			; Liest die Bewegung der Maus um
								; die X- und Y-Translationswerte zu aktualisieren


; Jetzt mit der rechten und linken Taste der Maus können wir eine Translation
; in Bezug auf die Z-Achse ausführen, die das Objekt näher oder weiter weg bringt.

	btst.b	#6,$bfe001			; linke Maustaste?
	bne.s	NonAllontana
	cmp.w	#40*50,ZADD			; sind wir sehr weit weg?
	beq.s	NonAllontana		; wenn ja, anhalten
	ADD.W	#40,ZADD			; Translation von uns weg
NonAllontana:
	btst.b	#2,$dff016			; rechte Maustaste?
	bne.s	NonAvvicina
	CMP.W	#-40,ZADD			; sind wir zu uns sehr nah?
	beq.s	NonAvvicina			; wenn ja, das reicht!
	SUB.W	#40,ZADD			; Translation der Annäherung an uns
	btst.b	#6,$bfe001			; wird auch die linke Taste gedrückt?
	beq.s	ESCIMI				; Wenn ja, dann raus!
NonAvvicina:

	BSR.w	TRASLAZIONE			; TRANSLATION des Objekts gemäß den Werten
								; der Variablen XADD, YADD und ZADD.

	BSR.w	PROSPETTIVA			; PERSPEKTIVE PROJEKTION. Die bewegten Punkte
								; werden auf den "Monitor" projiziert.

	bsr.w	DisegnaOggetto		; Objekt zeichnen (einfache X-, Y-Punkte)

	bra.w 	LoopMain			; Bereit für den nächsten Frame
ESCIMI:
	rts

****************************************************************************
* Translationsroutine, die einfach den Wert der Variablen XADD, YADD, ZADD * 
* zu den Objektkoordinaten addiert, wodurch die "Verschiebung" im Raum     *
* verursacht wird.														   * 
****************************************************************************

TRASLAZIONE:
	LEA	PuntiXYZtraslati(PC),A0	; Tabelle für gedrehte Punkte X,
								; das ist das Ziel!
	MOVE.w	#NPuntiOggetto-1,D7	; Anzahl der zu bewegenden Punkte
TRLOOP:
	movem.w	(a0)+,d0/d1/d2		; X in d0, Y in d1, Z in d2
	add.w	XADD(PC),d0			; X Translation (+ = rechts, - = links)
	add.w	YADD(PC),d1			; Y Translation (+ = unten, - = oben)
	add.w	ZADD(PC),d2			; Z Translation (+ = zurück, - = vorwärts)
	move.w	D0,-6(A0)			; X speichern in PuntiXYZtraslati
	move.w	D1,-4(A0)			; Y speichern in PuntiXYZtraslati
	move.w	D2,-2(A0)			; Z speichern in PuntiXYZtraslati
	DBRA 	D7,TRLOOP			; Führen Sie Anzahl der Punkte-Male aus, um
	RTS							; alle Punkte zu drehen.

XADD:
	dc.w	0
YADD:
	dc.w	0
ZADD:
	dc.w	0

******************************************************************************
; Diese Routine liest die Maus und aktualisiert die Werte in den
; XADD- und YADD-Variablen, die für die Translation verwendet werden.
******************************************************************************

LeggiMouse:
	move.b	$dff00a,d1			; JOY0DAT vertikale Mausposition
	move.b	d1,d0				; Kopie in d0
	sub.b	mouse_y(PC),d0		; alte Mausposition subtrahieren
	beq.s	no_vert				; wenn die Differenz = 0 ist, wird die Maus gestoppt
	ext.w	d0					; wandelt das Byte in ein Wort um
								; (siehe am Ende der Listings)
	add.w	d0,YADD				; Würfelposition ändern
no_vert:
  	move.b	d1,mouse_y			; speichern der Mausposition für das nächste Mal

	move.b	$dff00b,d1			; horizontale Mausposition
	move.b	d1,d0				; Kopie in d0
	sub.b	mouse_x(PC),d0		; alte Position subtrahieren
	beq.s	no_oriz				; wenn die Differenz = 0 ist, wird die Maus gestoppt
	ext.w	d0					; wandelt das Byte in ein Wort um
								; (siehe am Ende der Listings)
	add.w	d0,XADD				; Würfelposition ändern 
no_oriz:
  	move.b	d1,mouse_x			; speichern der Mausposition für das nächste Mal
	RTS

mouse_y:	dc.b	0			; hier wird das Y der Maus gespeichert
mouse_x:	dc.b	0			; Hier wird das X der Maus gespeichert

****************************************************************************
* ROUTINE, DIE DIE PERSPEKTIVE DER ROTATION DURCHFÜHRT.					   *
*																		   *
* Quelle: Tabelle "PuntiXYZtraslati", mit 3 Koordinaten XYZ pro Punkt	   *
*																		   *
* Ziel: Tabelle "PuntiXYproiettati", mit 2 Koordinaten X¹,Y¹			   *
*																		   *
* Die einzige andere Variable ist der Abstand Z des Beobachters vom        *
* Bildschirm, was in diesem Fall 256 ist, so dass Sie eine "ASL #8"        *
* anstelle von einer zeitintensiven Multiplikation ausführen können.	   *
****************************************************************************

PROSPETTIVA:
	LEA	PuntiXYZtraslati(PC),A0	 ; Adresse Tab. der X,Y,Z aus
								 ; Projektion (bereits bewegt)
	LEA	PuntiXYproiettati(PC),A1 ; Tabelle, wo die  projizierten Koordinaten X¹,Y¹
								 ; platziert werden sollen.
	MOVE.w	#LarghSchermo/2,D3  ; X Bildschirmmitte (für Mitte)
	MOVE.W 	#LunghSchermo/2,D4  ; Y Bildschirmmitte (für Mitte)

	MOVE.w	#NPuntiOggetto-1,D7	; Anzahl der zu projizierenden Punkte
Proiez:
	MOVEM.W	(a0)+,d0-d2			; Koord. X in d0, Y in d1, Z in d2
	ASL.L	#8,d0				; (MULS #256) DistZossSchermo*Xogg
	ASL.L	#8,d1				; (MULS #256) DistZossSchermo*Yogg
	ADD.W	#256,d2			    ; Zogg+DistZossSchermo
	DIVS.w	D2,D0				; (DistZoss_Schermo*Xogg)/(Zogg+DistZossSchermo)
	DIVS.w	D2,D1				; (DistZoss_Schermo*Yogg)/(Zogg+DistZossSchermo)
	ADD.W	d3,D0				; + Koordinate X Mitte des Bildschirms (zur Mitte)
	ADD.W 	d4,D1				; + Koordinate Y Mitte des Bildschirms (zur Mitte)
	MOVEM.W	D0-D1,(A1)			; speichern der projizierten und bewegten X¹- und Y¹-Werte
	ADDQ.W	#2+2,A1				; zu den nächsten 2 Werten springen
	DBRA 	D7,Proiez			; Wiederholen Sie NumberPoints-Zeiten für alle Punkte.
	RTS							; bis alle gescreent sind

*************************************************************************
*	DREHUNG DES BILDES DURCH DIE X-, Y- UND Z-WINKEL					*
*																		*
* 1) Zunächst werden der SINUS und KOSINUS der Winkel X, Y, Z unter		*
*  Verwendung der SINCOS-Subroutine gefunden, die sie wiederum von		*
*  einer Tabelle (SINTAB), die aus 360 Werten besteht, d.h. 1 Wert      *
*  für jeden möglichen Grad (von 0 bis 360) ableitet. Beachten Sie,     *
*  dass ein Trick verwendet wird, um Zahlen mit Kommas zu vermeiden:	*
*  die Werte der Sintab, die zwischen -1 und +1 liegen sollten, werden  *
*  mit  16384, was einer 14-Bit-Verschiebung nach links entspricht      *
*  multipliziert. Mit diesen "Integer" -Werten können wir die           *
*  Multiplikation ohne Kommas durchführen, und sobald die Operationen   *
*  abgeschlossen sind, können wir die Zahl mit LSRs teilen, in dem wir  *
*  sie um 14 Bit nach rechts verschieben.								*
*																		*
* 2) Erhalten Sie den SINUS und KOSINUS der 3 Winkel,				    *
*   Berechnungen für die Rotation erforderlich:						    *
*																	    *
*	X rotation X1,Y1 Becomes											*
*																		*
*	X2 = X1 COS(THETA) - Y1 SIN(THETA)									*
*	Y2 = Y1 COS(THETA) + X1 SIN(THETA)									*
*																		*
*	Y rotation X2,Y2 Becomes											*
*																		*
*	X3 = X2 COS(THETA) - Y2 SIN(THETA)									*
*	Y3 = Y2 COS(THETA) + X2 SIN(THETA)									*
*																		*
*	Z rotation X3,Y3 Becomes											*
*																		*
*	X4 = X3 COS(THETA) - Y3 SIN(THETA)									*
*	Y4 = Y3 COS(THETA) + X3 SIN(THETA)									*
*																		*
*	Where THETA is angle to rotate by.									*
*************************************************************************

ROTATE:

; den SINUS (ZSIN) und den KOSINUS (ZCOS) für den Winkel Z (ZANGLE) finden

	CMP.w 	#360,ZANGLE		; ist der Z-Winkel> 360 Grad?
	BLT.s	ZOK				; weniger als 360? wenn ja ZOK
	CLR.w	ZANGLE			; wenn es mehr als 360 sind, ZANGLE zurücksetzen
ZOK:
	CMP.w	#-360,ZANGLE	; haben wir -360 Grad erreicht?
	BGT.s	Z1OK			; wenn noch nicht, Z1OK
	CLR.w	ZANGLE			; wenn wir kleiner als -360 sind, ZANGLE zurücksetzen
Z1OK:
	MOVE.w	ZANGLE(PC),D0
	BSR.w	SINCOS			; den SINCOS-Wert für den Winkel in d0 finden 
							; Ausgabe: d1 = SIN, d2 = COS
	MOVE.w	D1,ZSIN			; Werte in Variablen einfügen
	MOVE.w	D2,ZCOS

; den SIN und COS des Winkels Y finden

	CMP.w	#360,YANGLE		; ist der Y-Winkel >360 Grad?
	BLT.s	YOK				; wenn <360°, OK
	CLR.w	YANGLE			; sonst zurücksetzen
YOK:
	CMP.w	#-360,YANGLE	; sind wir bei -360°?
	BGT.s	Y1OK			; wenn >360°, OK
	CLR.w	YANGLE			; sonst zurücksetzen
Y1OK:
	MOVE.w	YANGLE(PC),D0
	BSR.w	SINCOS			; den SIN und COS der Ecke mit der TABELLE finden
	MOVE.w	D1,YSIN			; und in die Variablen setzen
	MOVE.w	D2,YCOS

; den SIN und COS des Winkels Z finden

	CMP.w	#360,XANGLE		; ist der Winkel X > als -360°?
	BLT.s	XOK				; wenn kleiner, ist das in Ordnung
	CLR.w	XANGLE			; sonst zurücksetzen
XOK:
	CMP.w	#-360,XANGLE	; ist der Winkel X < als -360°?
	BGT.s	X1OK			; Wenn ja, ist das in Ordnung
	CLR.w	XANGLE			; sonst zurücksetzen
X1OK:
	MOVE.w	XANGLE(PC),D0
	BSR.w	SINCOS			; den SINUS und KOSINUS des Winkels aus der 
	MOVE.w	D1,XSIN			; Tabelle finden und in XSIN und XCOS setzen
	MOVE.w	D2,XCOS

; Quellkoordinaten:

	lea	Oggetto1(PC),a0		; Koordinate X
	lea	Oggetto1+2(PC),a1	; Koordinate Y
	lea	Oggetto1+4(PC),a2	; Koordinate Z

*************************************************************************
* rotation az
* x1 = x0*cos(az) - y0*sin(az)
* y1 = x0*sin(az) + y0*cos(az) 
* z1 = z0

* rotation ax
* y2 = y1*cos(ax) - z1*sin(ax)
* z2 = y1*sin(ax) + z1*cos(ax)
* x2 = x1

* rotation ay
* z3 = z2*cos(ay) - x2*sin(ay)
* x3 = z2*sin(ay) + x2*cos(ay)
* y3 = y2
*************************************************************************

; Zielkoordinaten::

	LEA	PuntiXYZtraslati(PC),A3	; Adresse Tab. des X,Y,Z aus
							; Projektion nach Translation und Rotation

	MOVE.w	#NPuntiOggetto-1,D0	; Anzahl der zu projizierenden Punkte
RLOOP1:
; rotation az
; x1 = x0*cos(az) - y0*sin(az)
; y1 = x0*sin(az) + y0*cos(az) 
; z1 = z0 da um die z-Achse gedreht wird

ZROTATE:
	MOVE.w	ZSIN(PC),D1		; d1=sin(az)
	MOVE.w	ZCOS(PC),D2		; d2=cos(az)
	MOVE.w	(A0),D3			; d3=X0
	MOVE.w	(A1),D4			; d4=Y0
	MOVE.w	(A2),D7			; d7=Z1=Z0	hier unverändert
	MULS.w	D3,D2			; d2=X0*cos(az)
	MULS.w	D4,D1			; d1=Y0*sin(az)
	SUB.L 	D1,D2			; d2=X1=X0*cos(az)-Y0*sin(az)
	LSR.L 	#8,D2			; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2			; um den wirklichen Wert zu finden
	MOVE.w	D2,D5			; Ergebnis X1, den erhaltenen Wert in d5 speichern

	MOVE.w	ZSIN(PC),D1		; d1=sin(az)
	MOVE.w	ZCOS(PC),D2		; d2=cos(az)
	; d3=X0	; d4=Y0	; d5=X1	; d6=frei ; d7=Z1=Z0 hier unverändert
	MULS.w	D3,D1			; d1=X0*sin(az)
	MULS.w	D4,D2			; d2=Y0*cos(az)
	ADD.L	D1,D2			; d2=Y1=X0*sin(az)+Y0*cos(az)
	LSR.L 	#8,D2			; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2			; um den wirklichen Wert zu finden
	MOVE 	D2,D6			; Ergebnis Y1, den erhaltenen Wert in d6 speichern
	addq.w	#2*3,a0			; zum nächsten X gehen
	addq.w	#2*3,a1			; zum nächsten Y gehen
	addq.w	#2*3,a2			; zum nächsten Z gehen
	; d5=X1, d6=Y1, d7=z1

; rotation ax
; y2 = y1*cos(ax) - z1*sin(ax)
; z2 = y1*sin(ax) + z1*cos(ax)
; x2 = x1 da um die x-Achse gedreht wird

XROTATE:
	MOVE.w	XSIN(PC),D1		; d1=sin(ax)
	MOVE.w	XCOS(PC),D2		; d2=cos(ax)
	; d3=frei ; d4=frei	; d5=X2=X1	hier unverändert ; d6=Y1 ; d7=Z1	
	MULS.w	D6,D2			; d2=Y1*cos(ax)
	MULS.w	D7,D1			; d1=Z1*sin(ax)
	SUB.L 	D1,D2			; d2=Y2=Y1*cos(ax)-Z1*sin(ax)
	LSR.L 	#8,D2			; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2			; um den wirklichen Wert zu finden
	MOVE.w	D2,D3			; Ergebnis Y2, den erhaltenen Wert in d3 speichern

	MOVE.w	XSIN(PC),D1		; d1=sin(ax)
	MOVE.w	XCOS(PC),D2		; d2=cos(ax)
	; d3=Y2	; d4=frei ; d5=X2=X1 ; d6=Y1 ; d7=Z1	
	MULS.w	D6,D1			; d1=Y1*sin(ax)
	MULS.w	D7,D2			; d2=Z1*cos(ax)	
	ADD.L	D1,D2			; d2=Z2=Y1*sin(ax)+Z1*cos(ax)
	LSR.L 	#8,D2			; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2			; um den wirklichen Wert zu finden
	MOVE 	D2,D6			; Ergebnis Z2, den erhaltenen Wert in d6 speichern
	; d5=X2, d3=Y2, d6=Z2 
	
; rotation ay
; z3 = z2*cos(ay) - x2*sin(ay)
; x3 = z2*sin(ay) + x2*cos(ay)
; y3 = y2 da um die y-Achse gedreht wird

YROTATE:
	MOVE.w	YSIN(PC),D1		; d1=sin(ay)
	MOVE.w	YCOS(PC),D2		; d2=cos(ay)
	; d3=Y3=Y2 ; d4=frei ; d5=X2 ; d6=Z2 ; d7=frei
	MULS.w	D6,D2			; d2=Z2*cos(ay)
	MULS.w	D5,D1			; d1=X2*sin(ay)
	SUB.L 	D1,D2			; d2=Z3=Z2*cos(ay)-X2*sin(aY)
	LSR.L 	#8,D2			; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2			; um den wirklichen Wert zu finden
	MOVE.w	D2,D4			; Ergebnis Z3, den erhaltenen Wert in d4 speichern

	MOVE.w	YSIN(PC),D1		; d1=sin(ay)
	MOVE.w	YCOS(PC),D2		; d2=cos(ay)
	; d3=Y3=Y2 ; d4=Z3	; d5=X2	; d6=Z2	; d7=frei
	MULS.w	D6,D1			; d1=Z2*sin(ay)
	MULS.w	D5,D2			; d2=X2*cos(ay)
	ADD.L	D1,D2			; d2=X3=Z2*sin(ay)+X2*cos(ay)
	LSR.L 	#8,D2			; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2			; um den wirklichen Wert zu finden
	;MOVE 	D2,D6			; Ergebnis X3, den erhaltenen Wert in d6 speichern
	; d2=X3 d3=Y3, d4=Z3 
	
	MOVE.w	D2,(A3)+		; speichern in pointxROT
	MOVE.w	D3,(A3)+		; speichern in pointyROT
	MOVE.w	D4,(A3)+		; speichern in pointzROT

	DBRA 	D0,RLOOP1		; Führen Sie NumeroPunti-Zeiten aus, um alle
							; Punkte zu drehen.
	RTS

*****************************************************************************
*	Finden Sie den Sin / Cos-Wert für den Winkel X in d0			        *
*	Verwenden der Tabelle SINTAB.w mit 360 Werten für 360 Grad				*
*   bei der Eingabe möglich													*
*	Ausgabe: d1 = SIN(x), d2 = COS(x)									    *
*****************************************************************************

SINCOS:
	TST.w	D0				; Winkel = Null?
	BPL.s	NOADDI			; wenn >0, gehe zu NOADDI
	ADD.w	#360,D0			; ansonsten füge ich 360 hinzu (der SIN von NULL
							; ist dasselbe wie der SIN von 360)
NOADDI:
	LEA	SINTAB(PC),A1		; Adresse Tabelle mit vorberechneten Sinus
	MOVE.L 	D0,D2			; Kopieren Sie den Winkel in d2, da Sie 
							; sowohl den Sinus als auch den Cosinus finden müssen

; den Sinus finden

	add.w	d0,D0			; ich multipliziere d0 * 2, das ist der gegebene Winkel
							; da die Tabelle aus Wörtern besteht (2 Bytes)
	MOVE.w	0(A1,D0.w),D1	; um den richtigen Sinuswert des Winkels
							; in der SINTAB zu finden
; den Kosinus finden

	CMP.w	#270,D2			; der Winkel beträgt >270 Grad? (270+90=360!)
	BLT.s	PLUS90			; Wenn nicht, gehen Sie zu PLUS90, das 90 Grad hinzufügt
							; zum Erhalten des Kosinuswinkels
	SUB.w	#270,D2			; wenn >270, entfernen Sie 270, andernfalls durch Hinzufügen
							; von 90, um den Kosinus abzuleiten, würden wir den Wert
							; 360 überschreiten; da der Kosinus gleich jedem 
							; k * 360 Grad (oder 2 kPi) ist subtrahieren wir
							; 270, dann addiere 90 (270 + 90 = 360),
							; zuerst den Kosinus des 2kPi finden.
	BRA.s	SENDSIN

PLUS90:
	ADD.w	#90,D2			; Ich füge 90 Grad hinzu, da der KOSINUS 
							; gleich Sinus + 90 Grad ist
SENDSIN:
	add.w	d2,D2			; Ich multipliziere den Winkel * 2 , da die
							; Tabelle aus Wörtern (2 Bytes) besteht 
	MOVE.w	(A1,D2),D2		; um den richtigen KOSINUS-Wert zu finden
	RTS						; aus der Tabelle durch Hinzufügen von d2 zur Adresse
							; Beginn der Tabelle.


******************************************************************************
**	ROUTINE ZUM ZEICNEN DES 3D OBJEKTES AUF DER BITPLANE (mit Punkten!)	    **
******************************************************************************

DisegnaOggetto:
	lea	PuntiXYproiettati(PC),a4 ; Puffer Koordinate X¹ und Y¹
	moveq	#NPuntiOggetto-1,d7	; Anzahl der zu zeichnenden Punkte
	move.l	DrawPlane(pc),a0	; aktuelle Bildschirmadresse in a0
PlottaLoop:
	movem.w	(a4)+,d0-d1			; Koord X¹ in d0 und Koord Y¹ in d1
	bsr.s	PlotPIX				; Punkt drucken auf Koordinate X=d0, Y=d1
	dbra	d7,PlottaLoop		; alle Punkte drucken
	rts

*****************************************************************************
;			Routine zur Darstellung von Punkten (dots)
*****************************************************************************

;	Eingabeparameter PlotPIX:
;
;	a0 = Adresse bitplane Ziel
;	d0.w = Koordinate X (0-319)
;	d1.w = Koordinate Y (0-255)

Largschermo	equ	40				; Bildschirmbreite in Bytes

PlotPIX:
	cmp.w	#320,d0				; sind wir raus?
	blo.s	Ok1
	rts
Ok1:
	cmp.w	#256,d1				; sind wir raus?
	blo.s	Ok2
	rts
Ok2:
	move.w	d0,d2				; Kopie der X Koordinate in d2
	lsr.w	#3,d0				; In der Zwischenzeit finden Sie den horizontalen Versatz,
								; durch Teilen der X-Koordinate durch 8.
	mulu.w	#Largschermo,d1
	add.w	d1,d0				; Summenversatz vertikal bis horizontal

	and.w	#%111,d2			; Wählen Sie nur die ersten 3 Bits von X
								; (Eigentlich wäre es der Rest der Division
								; für 8 früher gemacht)
	not.w	d2

	bset.b	d2,(a0,d0.w)		; Setzt das d2-Bit des entfernten Bytes d0 Bytes
								; vom Anfang des Bildschirms.
	rts


*************************************************
*	Swap Logical and Physical Screens			*
*************************************************

ScambiaEpulisci:
	MOVE.L 	SCREEN(PC),D0
	CMP.L 	DrawPlane(PC),D0		; Is current screen=screen1
	BNE.s	SWAPIT					; No then branch
	;MOVE.L 	SCREEN(PC),D0		; Display Screen1
	BSR.s	PuntaPlaneInCop			; Insert it Into Copper
	MOVE.L 	SCREEN1(PC),DrawPlane	; Screen2 = Logical 
	MOVE.L 	SCREEN1(PC),A1			; Address to Clear
	BSR.w	CpuClearScreen			; Do it !!!
  	RTS
  	
SWAPIT:
	MOVE.L 	SCREEN1(PC),D0			; Use screen2
	BSR.s	PuntaPlaneInCop			; Insert screen
	MOVE.L 	SCREEN(PC),DrawPlane	; screen1=logical
	MOVE.L 	SCREEN(PC),A1			; address to clear
	BSR.w	CpuClearScreen
	RTS
	
PuntaPlaneInCop:
	LEA	BplPointer,A0				; Zeiger copperlist
	MOVE 	D0,6(A0)				; auf die plane zeigen 
	SWAP 	D0
	MOVE 	D0,2(A0)
	RTS


DrawPlane:
	dc.l	Bitplane

; Zeiger auf die 2 Bildschirme für das Double Buffering

SCREEN:
	dc.l Bitplane0
SCREEN1:
	dc.l Bitplane

******************************************************************************
*	Bildschirm CLEAR-Routine über den Prozessor
*
*	A1 = Adresse des zu reinigenden Bildschirms
******************************************************************************

CpuClearScreen:
	MOVEM.L	D0-D7/A0-A6,-(SP)	; alle Register speichern
	MOVE.L	SP,OLDSP			; Speichern des STACK POINTER, um ihn zu verwenden
	LEA	40*LunghSchermo(a1),SP	; Laden Sie die hohe Adresse, also
								; das Ende des Bildschirms, da Movems
								; "rückwärts" reinigen.
	MOVEM.L	CLREG(PC),D0-D7/A0-A6	; Wir setzen alle Register mit nur
								; einem Movem aus einem Puffer von Nullen zurück.

; Lassen Sie uns nun den Speicher mit vielen ausgeführten "MOVEM.L D0-D7/A0-A6,-(SP)" 
; nacheinander löschen. Jeder Befehl setzt 60 Bytes zurück (15 Register long, das
; macht 15*4=60 Bytes) und schreibe in -(SP). Passen Sie auf, dass es vom Ende des
; Bildschirms (unten) beginnt und "nach oben geht" und so den Speicher zurückgeht.
; In hex wird das Movem als "$48E7FFFE" zusammengesetzt, es ist also genug
; eine "dcb.l number_instructions, $48e7fffe" einzugeben.

	dcb.l	170,$48E7FFFE		; 60*170=10200 bytes löschen

	movem.l	d0-d7/a0-a1,-(SP)	; die Letzten 40 bytes... (total 10240)

	MOVE.L	OLDSP(PC),SP		; den alten SP zurücksetzen
	MOVEM.L	(SP)+,D0-D7/A0-A6	; Wert der Register zurücksetzen
	RTS

; 15 Longs gelöscht, um in die Register geladen zu werden, um sie zu löschen

CLREG:
	dcb.l	15,0

OLDSP:
	dc.l	0

************************************************************************************
* Definition des 3D-Volumenkörpers durch die X-, Y-, Z-Koordinaten seiner Punkte.  *
************************************************************************************

;	WENIGER< X >MEHR'		WENIGER			MEHR'
;							 ^				/|
;							 Y		       Z
;							 v		     |/
;							MEHR'		   WENIGER

;	      (P4) -50,-50,+50______________+50,-50,+50 (P5)
;					     /|			   /|
;					    / |		      / |
;					   /  |			 /  |
;					  /   |			/   |
;	 (P0) -50,-50,-50/____|________/+50,-50,-50 (P1)
;					|     |       |     |
;				    |     |_______|_____|+50,+50,+50 (P6)
;					|    /-50,+50,+50 (P7)
;					|   /	      |   /
;					|  /	      |  /
;					| /			  | /
;					|/____________|/+50,+50,-50 (P2)
;	 (P3) -50,+50,-50

Oggetto1:  ; Hier sind die 8 durch die Koordinate  X, Y, Z definierten Punkte.
	dc.w	-50,-50,-50	; P0 (X,Y,Z)
	dc.w	+50,-50,-50	; P1 (X,Y,Z)
	dc.w	+50,+50,-50	; P2 (X,Y,Z)
	dc.w	-50,+50,-50	; P3 (X,Y,Z)
	dc.w	-50,-50,+50	; P4 (X,Y,Z)
	dc.w	+50,-50,+50	; P5 (X,Y,Z)
	dc.w	+50,+50,+50	; P6 (X,Y,Z)
	dc.w	-50,+50,+50	; P7 (X,Y,Z)

NPuntiOggetto	= 8

******************************************************************************
*		    Daten und Variablen der Routine									 *
******************************************************************************

XANGLE:	DC.W	0
YANGLE:	DC.W	0
ZANGLE:	DC.W	0

XSIN:	DC.W 0
XCOS:	DC.W 0

YSIN:	DC.W 0
YCOS:	DC.W 0

ZSIN:	DC.W 0
ZCOS:	DC.W 0

; X- und Y-Koordinaten des URSPRUNGS der Achsen in Bezug auf den Bildschirm 
; in diesem Fall platzieren wir sie in der Mitte.

; --------------------------------------------------------------------------

; Puffer für geänderte Punkte (gedreht und / oder bewegt im 3D-Raum).

PuntiXYZtraslati:
	DS.W	NPuntiOggetto*3

; --------------------------------------------------------------------------

; Koordinaten X¹ und Y¹ projiziert, dh perspektivisch, bereit gezeichnet zu
; werden. Die Koordinaten werden paarweise im Puffer gespeichert
; Aufeinanderfolgende X¹ und Y¹: XY, XY, XY, XY, XY ..., ein Wort für jede Koordinate.

PuntiXYproiettati:
	DS.W	NPuntiOggetto*2

*************************************************************************
*		Daten für die Tabelle der Sinus / Cosinus:						*
*																		*
* Die Verwendung von Gleitkommazahlen macht Berechnungen zu groß,		*
* um  3D-Bilder in Echtzeit erstellen zu können.						*
* Zum Beispiel ist der SIN(1°) 0,01745, der SIN(2°) ist 0,03489 usw.	*
* In diesem Fall haben wir ein "Erweiterung" verwendet, in der Tat alle *
* Werte werden zuerst mit 16384 multipliziert.							*
* Tatsächlich ist 0,01745*16384 gleich 286, 0,3489*16384 gleich 572, 	*
* usw. für die anderen Werte in der SINTAB.								*
* Der Trick zur Geschwindigkeit ist das Multiplizieren mit 16384		*
* es bedeutet SHIFT 14 Bit nach links, um die Werte	zu finden			* 
* Wert nur SHIFT nach rechts von 14 Bit mit diesen 2 Anweisungen:	    *
*																		*
*	LSR.L 	#8,D2	; 14 bit shift nach rechts							*
*	LSR.L 	#6,D2	; Teilen durch 16384								*
*																		*
* Auf diese Weise entfernen wir das Komma, und multiplizieren und		*
* dividieren mit dem "vergrößerten" Wert, dann dividiert man das		*
* Ergebnis durch 16384 mit den zwei zuvor gesehene LSRs.				*
* Diese Tabelle ist im Dezimalformat, um das ihren Inhalt besser zu		*
* verstehen. Wenn Sie es mit "IS" noch einmal machen möchten, 			*
* sind die Parameter natürlich:											*
*																		*
* BEG>0																	*
* END>360																*
* AMOUNT>360															*
* AMPLITUDE>16384														*
* YOFFSET>0																*
* SIZE (B/W/L)>W														*
* MULTIPLIER>1															*
*																		*
*************************************************************************

SINTAB:
	DC.W 0,286,572,857,1143,1428,1713,1997,2280
	DC.W 2563,2845,3126,3406,3686,3964,4240,4516
	DC.W 4790,5063,5334,5604,5872,6138,6402,6664
	DC.W 6924,7182,7438,7692,7943,8192,8438,8682	
	DC.W 8923,9162,9397,9630,9860,10087,10311,10531
	DC.W 10749,10963,11174,11381,11585,11786,11982,12176
	DC.W 12365,12551,12733,12911,13085,13255,13421,13583
	DC.W 13741,13894,14044,14189,14330,14466,14598,14726
	DC.W 14849,14968,15082,15191,15296,15396,15491,15582
	DC.W 15668,15749,15826,15897,15964,16026,16083,16135
	DC.W 16182,16225,16262,16294,16322,16344,16362,16374
	DC.W 16382,16384
	DC.W 16382
	DC.W 16374,16362,16344,16322,16294,16262,16225,16182
	DC.W 16135,16083,16026,15964,15897,15826,15749,15668	
	DC.W 15582,15491,15396,15296,15191,15082,14967,14849
	DC.W 14726,14598,14466,14330,14189,14044,13894,13741	
	DC.W 13583,13421,13255,13085,12911,12733,12551,12365
	DC.W 12176,11982,11786,11585,11381,11174,10963,10749
	DC.W 10531,10311,10087,9860,9630,9397,9162,8923
	DC.W 8682,8438,8192,7943,7692,7438,7182,6924
	DC.W 6664,6402,6138,5872,5604,5334,5063,4790
	DC.W 4516,4240,3964,3686,3406,3126,2845,2563
	DC.W 2280,1997,1713,1428,1143,857,572,286,0
	DC.W -286,-572,-857,-1143,-1428,-1713,-1997,-2280
	DC.W -2563,-2845,-3126,-3406,-3686,-3964,-4240,-4516
	DC.W -4790,-5063,-5334,-5604,-5872,-6138,-6402,-6664
	DC.W -6924,-7182,-7438,-7692,-7943,-8192,-8438,-8682	
	DC.W -8923,-9162,-9397,-9630,-9860,-10087,-10311,-10531
	DC.W -10749,-10963,-11174,-11381,-11585,-11786,-11982,-12176
	DC.W -12365,-12551,-12733,-12911,-13085,-13255,-13421,-13583
	DC.W -13741,-13894,-14044,-14189,-14330,-14466,-14598,-14726
	DC.W -14849,-14968,-15082,-15191,-15296,-15396,-15491,-15582
	DC.W -15668,-15749,-15826,-15897,-15964,-16026,-16083,-16135
	DC.W -16182,-16225,-16262,-16294,-16322,-16344,-16362,-16374
	DC.W -16382,-16384
	DC.W -16382
	DC.W -16374,-16362,-16344,-16322,-16294,-16262,-16225,-16182
	DC.W -16135,-16083,-16026,-15964,-15897,-15826,-15749,-15668	
	DC.W -15582,-15491,-15396,-15296,-15191,-15082,-14967,-14849
	DC.W -14726,-14598,-14466,-14330,-14189,-14044,-13894,-13741	
	DC.W -13583,-13421,-13255,-13085,-12911,-12733,-12551,-12365
	DC.W -12176,-11982,-11786,-11585,-11381,-11174,-10963,-10749
	DC.W -10531,-10311,-10087,-9860,-9630,-9397,-9162,-8923
	DC.W -8682,-8438,-8192,-7943,-7692,-7438,-7182,-6924
	DC.W -6664,-6402,-6138,-5872,-5604,-5334,-5063,-4790
	DC.W -4516,-4240,-3964,-3686,-3406,-3126,-2845,-2563
	DC.W -2280,-1997,-1713,-1428,-1143,-857,-572,-286
	dc.w 0

; --------------------------------------------------------------------------

	Section	Copperlist,data_C

COPPERLIST:
	DC.W	$120,0
	DC.W	$122,0
	DC.W	$008e,$2C81
	DC.W	$0090,$20C1
	DC.W	$0092,$0038
	DC.W	$0094,$00d0
	DC.W	$0108,0
	DC.W	$010a,0
	DC.W	$0102,0
	DC.W	$100,%0001001000000000
	DC.W	$180,0,$182,$FFFF,$184,$ffff
BplPointer:
	DC.W	$E0,0,$E2,0
	DC.W	$FFFF,$FFFE

	section	planes,bss_C

Bitplane0:
	ds.b	40*LunghSchermo

Bitplane:
	ds.b	40*LunghSchermo

	end

