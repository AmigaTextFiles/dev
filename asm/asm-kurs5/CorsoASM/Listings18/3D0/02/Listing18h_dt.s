; Listing18h.s = MINI-INTRO3d2.s

	section	WireFrame3d,code

; System 3 Tabellen für X-, Y-, Z-Punkte und Linientabelle
; sintab STANDARD OLD1 als MINI-INTRO 3d

*****************************************************************************
	;include	"Assembler2:sorgenti4/startup1.s" ; save copperlist etc.
*****************************************************************************
	include	"startup2.s"
WaitDisk EQU	%0				; because startup2
													
			;5432109876543210
DMASET	EQU	%1000001111000000	; copper, bitplane und blitter
;		 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die Sprites)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA


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

	
*************************************************
*	Main Loop				*
*************************************************

WAIT:	
	BSR.w	SWAP				; Swap Screen
	ADDQ.W	#1,ZANGLE			; rotation around the axis that comes to us
								; meeting, we would see it as a point.,
								; therefore the object rotates like the hands of
								; a watch if SUB, or in the sense
								; anticlockwise if ADD.
	;ADDQ.W	#2,YANGLE			; rotation around VERTICAL axis |
	;ADDQ.W	#1,XANGLE			; rotation around a HORIZONTAL axis --
	BSR.w	ROTATE				; Rotate 3d Image
	BSR.w	PERS				; Calculate Perspective
	bsr.w	drawn1

WAITPOS:
	CMP.B 	#$FF,$DFF006		; Wait for beam
	BNE.s	WAITPOS

	btst	#2,$dff016
	bne.s	NoZoom
	sub.w	#10,DIST			; push the solid away
NoZoom:

	ANDI.B 	#$40,$BFE001		; Wait for Mouse Button
	BNE.s 	WAIT

	rts


SCREEN:
	DC.L bitplane0
SCREEN1:
	DC.L bitplane



*************************************************
*	Clear routine								*
*	A1	=	Address to clear					*
*************************************************
**********************************
* Clean the screen with the 68000 *
**********************************

CLWork:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	MOVE.L	SP,OLDSP
	LEA	40*LunghSchermo(a1),SP		; ADD length OF SCREEN
	MOVEM.L	CLREG(PC),D0-D7/A0-A6	; CLEAR REGISTERS
;	MOVEM.L	D0-D7/A0-A6,-(SP)
	dcb.l	170,$48E7FFFE			; NOW CLEAR WITH CPU WHEN A BLIT IS IN PROG.
	movem.l	d0-d7/a0-a1,-(SP)
	MOVE.L	OLDSP(PC),SP			; 60 bytes every instruction!
	MOVEM.L	(SP)+,D0-D7/A0-A6
	RTS

CLREG:
	Dcb.L	15,0

OLDSP:
	dc.l	0


DrawPlane:
	dc.l	bitplane

	
*************************************************
*	Swap Logical and Physical Screens			*
*************************************************

SWAP:
	MOVE.L 	SCREEN(PC),D0
	CMP.L 	DrawPlane(PC),D0		; Is current screen=screen1
	BNE.s	SWAPIT					; No then branch
	MOVE.L 	SCREEN(PC),D0			; Display Screen1
	BSR.s	INSSCRN					; Insert it Into Copper
	MOVE.L 	SCREEN1(PC),DrawPlane	; Screen2 = Logical 
	MOVE.L 	SCREEN1(PC),A1			; Address to Clear
	BSR.w	CLWork					; Do it !!!
  	RTS
  	
SWAPIT:
	MOVE.L 	SCREEN1(PC),D0			; Use screen2
	BSR.s	INSSCRN					; Insert screen
	MOVE.L 	SCREEN(PC),DrawPlane	; screen1=logical
	MOVE.L 	SCREEN(PC),A1			; address to clear
	BSR.w	CLWork
	RTS
	
INSSCRN:
	LEA	BOT,A0						; Insert Screen into Copper
	MOVE 	D0,6(A0)
	SWAP 	D0
	MOVE 	D0,2(A0)
	RTS

*********************************************************************
* Perspective, calculated from the transformed points in the arrays *
* pointxROT, pointyROT and pointzROT the screen coordinates, which  *
* are then stored in the arrays pointxROTprimo and pointyROTprimo.  *
*********************************************************************

PERS:

;	addresses of tables containing points rotated in space

	LEA	pointxROT(PC),A1		; address table of rotated Xs
	LEA	pointyROT(PC),A2		; table rotated Y 
	LEA	pointzROT(PC),A3		; table rotated Z

; addresses of the tables where to put the X and Y coordinates of the
; points prospectively projected on the plane.

	LEA	pointxROTprimo(PC),A4	; table projected X coordinate 
	LEA	pointyROTprimo(PC),A5	; table projected Y coordinate

	MOVE.w	NumeroPunti(PC),D0	; number of points to project
	EXT.L 	D0
PERLOP:
	MOVE.w	(A3)+,D5			; Z coordinate of the object
	MOVE.w	D5,D6
	MOVE.w	DIST(PC),D4			; distance of the object, factor of
								; magnification
	SUB.w	D5,D4				; (distance) - (Z coordinate of the object)
	EXT.L 	D4
	LSL.L 	#8,D4				; multiply *256
	MOVE.w	ZOBS(PC),D3			; Z coordinate of the projection center
	EXT.L	D3

	SUB.L	D6,D3				; minus the Z coordinate of the object
	BNE.s	PERS1

	MOVEQ	#0,D1				; Catch division by zero
	ADDQ.w	#2,A1
	ADDQ.w	#2,A2
	MOVE.w	D1,(A4)+			; val X interm.
	MOVE.w	D1,(A5)+			; val Y interm.
	BRA.s	PEREND1

PERS1:
	DIVS.w	D3,D4
	MOVE.w	D4,D3
	MOVE.w	(A1)+,D1			; X coordinate of the object
	MOVE.w	D1,D2
	NEG.w	D1
	MULS.w	D1,D3				; Multiply by the perspective factor
	LSR.L	#8,D3				; divide by 256

	ADD.w	D3,D2				; add to coordinate X

	ADD.w	Xorigine(PC),D2		; + X position of the origin of the axes, that is
								; the center of the screen: 320/2 = 160
								; in fact [X0, Y0] = [160,100]	
	MOVE.w	D2,(A4)+			; val X interm

	MOVE.w	(A2)+,D1			; Y coordinate of the object
	MOVE.w	D1,D2
	NEG.w	D1
	MULS.W	D1,D4
	LSR.L	#8,D4				; divide by 256

	ADD.w	D4,D2
	neg.w	d2					; Display offset, mirror of Y-Axis
	ADD.W 	Yorigine(PC),D2		; + Y position of the origin of the axes, that is
								; the center of the screen: 200/2 = 100
								; in fact [X0, Y0] = [160,100]
	MOVE	D2,(A5)+			; val Y interm
PEREND1:
	DBRA 	D0,PERLOP			; repeat NumeroPunti times for all points.
	RTS							; until you've screened them all

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

; den SIN und COS des Winkels X finden

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
	LEA	CoordXOggettoSpaz(PC),A0	; Koordinate X
	LEA	CoordYOggettoSpaz(PC),A1	; Koordinate Y
	LEA	CoordZOggettoSpaz(PC),A2	; Koordinate Z

; Zielkoordinaten::
	LEA	pointxROT(PC),A3		; Tabelle für gedrehte Punkte X
	LEA	pointyROT(PC),A4		; Tabelle für gedrehte Punkte Y
	LEA	pointzROT(PC),A5		; Tabelle für gedrehte Punkte Z

	MOVE.w	NumeroPunti(PC),D0
RLOOP:
ZROTATE:
	MOVE.w	ZSIN(PC),D1
	MOVE.w	ZCOS(PC),D2
	MOVE.w	(A0),D3				; CoordXOggettoSpaz - nächste Koordinate X
								; aus der Punkttabelle des Objekts
	MULS.w	D3,D2				; multiplizieren CoordXOggettoSpaz*ZCOS
	MOVE.w	(A1),D3				; CoordYOggettoSpaz - nächste Koordinate Y
	MULS.w	D3,D1				; multiplizieren CoordYOggettoSpaz*ZSIN
	SUB.L 	D1,D2				; (CoordXOggettoSpaz*ZCOS)-(CoordYOggettoSpaz*ZSIN)

	LSR.L 	#8,D2				; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2				; um den wirklichen Wert zu finden

	MOVE.w	D2,D5				; den erhaltenen Wert in d5 speichern

;

	MOVE.w	ZSIN(PC),D1
	MOVE.w	ZCOS(PC),D2
	MOVE.w	(A0)+,D3			; CoordXOggettoSpaz - nächste Koordinate X
	MULS.w	D3,D1				; multiplizieren CoordXOggettoSpaz*ZSIN
	MOVE.w	(A1)+,D3			; CoordYOggettoSpaz - nächste Koordinate Y
	MULS.w	D3,D2				; multiplizieren CoordYOggettoSpaz*ZCOS
	ADD.L	D1,D2				; (CoordXOggettoSpaz*ZSIN)+(CoordYOggettoSpaz*ZCOS)

	LSR.L 	#8,D2				; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2				; um den wirklichen Wert zu finden

	MOVE 	D2,D6				; den erhaltenen Wert in d6 speichern

YROTATE:
	MOVE.w	YSIN(PC),D1
	MOVE.w	YCOS(PC),D2
	MOVE.w	(A2),D3				; CoordZOggettoSpaz - nächste Koordinate Z
	MULS.w	D3,D2				; multiplizieren CoordZOggettoSpaz*YCOS
	MOVE.w	D5,D3				; (CoordXOggettoSpaz*ZCOS)-(CoordYOggettoSpaz*ZSIN) in d3
	MULS.w	D3,D1				; multipliziert mit YSIN
	SUB.L 	D1,D2				; sottrai il valore trovato a YCOS

	LSR.L 	#8,D2				; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2				; um den wirklichen Wert zu finden

	MOVE.w	D2,D7				; den erhaltenen Wert in d7 speichern

;

	MOVE.w	YSIN(PC),D1
	MOVE.w	YCOS(PC),D2
	MOVE.w	(A2)+,D3			; CoordZOggettoSpaz - nächste Koordinate Z
	MULS.w	D3,D1				; multiplizieren CoordZOggettoSpaz*YSIN
	MOVE.w	D5,D3				; (CoordXOggettoSpaz*ZCOS)-(CoordYOggettoSpaz*ZSIN) in d3
	MULS.w	D3,D2				; multipliziert mit YCOS
	ADD.L 	D1,D2				; addiere den erhaltenen Wert zu (CoordZOggettoSpaz*YSIN)

	LSR.L 	#8,D2				; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2				; um den wirklichen Wert zu finden

****\
	MOVE.w	D2,D5				; COORD X GEDREHT OK - den erhaltenen Wert in d5 speichern
****/

XROTATE:
	MOVE.w	XSIN(PC),D1
	MOVE.w	XCOS(PC),D2
	MOVE.w	D6,D4				; d4=(CoordXOggettoSpaz*ZSIN)+(CoordYOggettoSpaz*ZCOS)
	MOVE.w	D6,D3				; idem d3
	MULS.w	D3,D2				; multipliziert mit XCOS
	MOVE.w	D7,D3
	MULS.w	D3,D1
	SUB.L 	D1,D2

	LSR.L 	#8,D2				; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2				; um den wirklichen Wert zu finden

****\
	MOVE 	D2,D6				; COORD Y GEDREHT OK - den erhaltenen Wert in d6 speichern
****/

	MOVE 	XSIN(PC),D1
	MOVE 	XCOS(PC),D2
	MOVE 	D4,D3
	MULS 	D3,D1
	MOVE 	D7,D3
	MULS 	D3,D2
	ADD.L 	D1,D2

	LSR.L 	#8,D2				; 14-Bit-Shift rechts, geteilt durch 16384,
	LSR.L 	#6,D2				; um den wirklichen Wert zu finden

****\
	MOVE 	D2,D7				; COORD Z GEDREHT OK - den erhaltenen Wert in d7 speichern
****/

	MOVE 	D5,(A3)+			; speichern in pointxROT
	MOVE 	D6,(A4)+			; speichern in pointyROT
	MOVE 	D7,(A5)+			; speichern in pointzROT

	DBRA 	D0,RLOOP			; Führen Sie NumeroPunti-Zeiten aus, um alle
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
							; k * 360 Grad (oder 2 kPi griechisch) ist subtrahieren wir
							; 270, dann addiere 90 (270 + 90 = 360),
							; zuerst den Kosinus des griechischen 2kPi finden.
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
******************************************************************************
**																			**
**		BITPLANE OBJEKTZEICHNUNGS-ROUTINE									**
**																			**
******************************************************************************
******************************************************************************

**************************************************************
* Draw number of lines from array from lines in LineeOggetto *
**************************************************************

drawn1:
	lea	pointxROTprimo(PC),a4	; Display X-Coordinate
	lea	pointyROTprimo(PC),a5	; Display Y-Coordinate

	move.w	NUMLineeOggetto(PC),d0	; Number of lines that connect
								; points of the solid
	ext.l	d0
	lea	LineeOggetto(PC),a6		; address of line array

drlop:
	move.l	(a6)+,d1			; First line (P1,P2)
	subq.w	#1,d1				; Fit to list structure
	lsl.w	#1,d1				; Times list element length (2)
	move.w	(a4,d1.w),d2		; X-Coordinate of 2nd point
	move.w	(a5,d1.w),d3		; Y-Coordinate of second point
	swap	d1
	subq.w	#1,d1
	lsl.w	#1,d1
	move.w	(a4,d1.w),a2		; X-Coordinate of first point
	move.w	(a5,d1.w),a3		; Y-Coordinate of first point
	bsr.w	Drawl				; Draw line from P1 to P2
	dbra	d0,drlop			; Until all lines drawn
	rts

;


*******************************************************************
* Draw-line routine, The points are passed in D2,D3 (start point) *
* and A2, A3 (end point)                                          *
*******************************************************************

Drawl:
	movem.l	d0-d3/a0-a1,-(a7)
	move.l	d2,d0
	move.l	d3,d1				; X,y start
	move.l	a2,d2
	move.l	a3,d3				; X,y end
	bsr.s	BlitDraw
	movem.l	(a7)+,d0-d3/a0-a1
	rts

****************
* Blitter Line *
****************

BlitDraw:
	movem.l	d2-d7/a2-a3,-(a7)
	moveq	#$f,d4
	and.w	d2,d4				; low 4 bits
	sub.w	d3,d1				; Height
	mulu	#LarghSchermo/8,d3	; Start address
	sub.w	d2,d0				; Width
	blt.s	No1
	tst.w	d1
	blt.s	No2
	CMP.w	d0,d1
	bge.s	No3
	moveq	#$11,d7
	bra.s	OctSel				; Octant #
No3:
	moveq	#1,d7
	exg	d1,d0
OctSel:
	bra.s	No4
No2:
	neg.w	d1
	CMP.w	d0,d1
	bge.s	Skip
	moveq	#$19,d7
	bra.s	No4
Skip:
	moveq	#5,d7
	exg	d1,d0
No4:
	bra.s	OctsSel
No1:
	neg.w	d0
	tst.w	d1
	blt.s	No11

	CMP.w	d0,d1
	bge.s	No12
	moveq	#$15,d7
	bra.s	OctSel2

No12:
	moveq	#9,d7
	exg	d1,d0
OctSel2:
	bra.s	OctsSel
No11:
	neg.w	d1
	CMP.w	d0,d1
	bge.s	No13
	moveq	#$1d,d7
	bra.s	OctsSel
No13:
	moveq	#$d,d7
	exg	d1,d0
OctsSel:
	add.w	d1,d1
	asr.w	#3,d2
	ext.l	d2
	add.l	d2,d3				; Total offset
	move.w	d1,d2
	sub.w	d0,d2
	bge.s	NoMinus
	ori.w	#$40,d7				; Sign = -
NoMinus:
	lea	$dff000,a0
	move.w	d2,a3
	move.w	#$ffff,d6			; LinePtrn
WaitBl:
	btst	#6,2(a0)
	bne.s	WaitBl
	move.w	d1,$62(a0)			; 4Y
	move.w	d2,d1
	sub.w	d0,d1
	move.w	d1,$64(a0)			; 4Y-4X
	moveq	#-1,d1
	move.l	d1,$44(a0)			; AFWM+ALWM
	move.w	#LarghSchermo/8,$60(a0)	; BitMap Width in bytes
	move.w	d7,d5
	addq.w	#1,d0
	asl.w	#6,d0
	addq.w	#2,d0				; Blitsize
	move.w	d4,d2
	swap	d4
	asr.l	#4,d4				; First pixelpos
	ori.w	#$b00,d4			; Use ABD
	move.w	#$8000,$74(a0)		; Index
	clr.w	d1
NoSpesh:
	move.l	DrawPlane(PC),d7	; Pointer
	swap	d5
	move.w	d4,d5
	move.b	#$ca,d5				; MinTerms
	swap	d5
	add.l	d3,d7
WtBl2:
	btst	#6,2(a0)
	bne.s	WtBl2
	move.l	d5,$40(a0)			; bltCon0 & 1
	move.w	a3,$52(a0)			; 2Y-X
	move.l	d7,$48(a0)
	move.l	d7,$54(a0)			; Start address of line
	move.w	d6,$72(a0)			; Pattern
	move.w	d0,$58(a0)			; Size
	movem.l	(a7)+,d2-d7/a2-a3
	rts


******************************************************************************
;	definition of the solid 3d wireframe
******************************************************************************


CoordXOggettoSpaz:
	dc.w	0,40,0,-40,-15,0,15,0,-15,15
	dc.w	0,35,0,-35

CoordYOggettoSpaz:
	dc.w	40,0,-40,0,15,15,15,-25,10,10
	dc.w	35,0,-35,0

CoordZOggettoSpaz:
	dc.w	0,0,0,0,10,10,10,10,10,10
	dc.w	20,20,20,20

***** What points should be connected with lines? ****

; connections:

LineeOggetto:
	dc.w	1,2, 2,3, 3,4, 4,1, 5,7, 6,8, 5,9, 7,10
	dc.w	11,12, 12,13, 13,14, 14,11, 1,11, 2,12
	dc.w	3,13,4,14

NPuntiOggetto	= 14
NLineeOggetto	= 16


******************************************************************************
;		    routine data and variables										 *
******************************************************************************


NumeroPunti:
	DC.W NPuntiOggetto-1
NUMLineeOggetto:
	DC.W NLineeOggetto-1


ZOBS:	dc.w	1500	; Z coordinate of the projection center (observer)

DIST:	dc.w	3000

XANGLE:	DC.W	0
YANGLE:	DC.W	0
ZANGLE:	DC.W	0

XSIN:	DC.W 0
XCOS:	DC.W 0

YSIN:	DC.W 0
YCOS:	DC.W 0

ZSIN:	DC.W 0
ZCOS:	DC.W 0


; X and Y coordinates of the ORIGIN of the axes with respect to the screen, in this one
; case we place them in the center of the screen.

Xorigine:	dc.w	LarghSchermo/2	; 320/2 = 160, center X of the screen
Yorigine:	dc.w	LunghSchermo/2	; 200/2 = 100, center Y

; buffer for points rotated in space

pointxROT:
	DS.W	NPuntiOggetto
pointyROT:
	DS.W	NPuntiOggetto
pointzROT:
	DS.W	NPuntiOggetto


; Projected X and Y coordinates, i.e. in perspective, ready for
; be drawn

pointxROTprimo:
	DS.W	NPuntiOggetto
pointyROTprimo:
	DS.W	NPuntiOggetto


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
* dividieren mit dem "vergrößerte" Wert, dann dividiert man das			*
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


	Section	Copperlist,data_C

COPPERLIST:
	DC.W $120,0
	DC.W $122,0
	DC.W $008e,$2C81
	DC.W $0090,$20C1
	DC.W $0092,$0038
	DC.W $0094,$00d0
	DC.W $0108,0
	DC.W $010a,0
	DC.W $0102,0
	DC.W $100,%0001001000000000
	DC.W $180,0,$182,$FFFF,$184,$ffff
BOT:
	DC.W $E0,0,$E2,0
	DC.W $FFFF,$FFFE

	section	planes,bss_C

bitplane0:
	ds.b	40*LunghSchermo

bitplane:
	ds.b	40*LunghSchermo

	end

