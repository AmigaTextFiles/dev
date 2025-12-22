
; Listing18c5.s = Lezione3d-4e.s

	section	WireFrame3d,code

; Wireframe
; Rotation mit Matrizen, die nicht so gut verstanden wird...

; System 3 Tabellen für X-, Y-, Z-Punkte und Linientabelle
; sintab STANDARD OLD1 als MINI-INTRO 3d

*****************************************************************************
	include "///Sources/startup2.s"		; copperlist speichern etc.
*****************************************************************************
	
WaitDisk EQU	%0				; wegen startup2
			;5432109876543210
DMASET	EQU	%1000001111000000	; copper, bitplane und blitter
;		 -----a-bcdefghij

;	a: Blitter Nasty
;	b: Bitplane DMA	   (Wenn es nicht gesetzt ist, verschwinden auch die sprites)
;	c: Copper DMA
;	d: Blitter DMA
;	e: Sprite DMA
;	f: Disk DMA
;	g-j: Audio 3-0 DMA


LarghSchermo	=	320
LunghSchermo	=	200


START:
	MOVE.W	#DMASET,$96(a5)		; DMACON - aktivieren bitplane, copper
	move.l	#Copperlist,$80(a5)	; Zeiger COP
	move.w	d0,$88(a5)			; Start COP
	move.w	#0,$1fc(a5)			; AGA deaktivieren
	move.w	#$c00,$106(a5)		; AGA deaktivieren
	move.w	#$11,$10c(a5)		; AGA deaktivieren
	move.l	#0,$108(a5)
	bsr.s	Main				; Do main stuff
	rts


Main:
	bsr.w	SetRotDp			; Init obs.ref.point

	bsr.w	PageUp
	bsr.w	ClWork
	bsr.w	PageDown
	bsr.w	ClWork				; Init both pages

	bsr.w	Inp_Chan			; Input and change parameters
	move.w	#2047,dist

mainlop1:
	bsr.w	PointRot
	bsr.w	Pers				; Do Perspective
	bsr.w	DrawN1				; Draw It
	bsr.w	PageUp				; Display It
	bsr.w	Inp_Chan			; Input new parameters
	bsr.w	ClWork

	bsr.w	PointRot			; Rotate
	bsr.w	Pers				; Perspective
	bsr.w	DrawN1				; Drawit
	bsr.w	PageDown			; Display It
	bsr.w	Inp_Chan			; Input Parameters
	bsr.w	ClWork

	btst	#6,$bfe001
	bne.s	mainlop1
mainend:
	bsr.s	PageUp
	rts

Inp_Chan:
	addq.w	#2,yangle



	addq.w	#1,xangle
	addq.w	#3,zangle
	CMP.w	#360,yangle
	blt.s	nosuby
	sub.w	#360,yangle
nosuby:
	CMP.w	#360,xangle
	blt.s	nosubx
	sub.w	#360,xangle
nosubx:

	CMP.w	#360,zangle
	blt.s	nosubz
	sub.w	#360,zangle
nosubz:
	sub.w	#15,dist
	CMP.w	#-990,dist
	bgt.s	NoClr
	move.w	#-990,dist
NoClr:
	rts

****************************
* Pass upper screen to VDC *
*  while drawing the other *
****************************

PageUp:
	move.l	d0,-(a7)
	move.l	#bitplane0,DrawPlane	; Rastport structure
	move.l	#bitplane,d0			; BitMap pointer
	move.w	d0,LowBMPtr
	swap	d0
	move.w	d0,HiBMPtr				; Copper fixes the rest
	bsr	WaitBot
	move.l	(a7)+,d0
	rts

****************************
* Pass lower screen to VDC *
*  while drawing the other *
****************************

PageDown:
	move.l	d0,-(a7)
	move.l	#bitplane,DrawPlane		; Rastport structure
	move.l	#bitplane0,d0			; BitMap pointer
	move.w	d0,LowBMPtr
	swap	d0
	move.w	d0,HiBMPtr				; Copper fixes the rest
	bsr	WaitBot
	move.l	(a7)+,d0
	rts

WaitBot:
	lea	$dff000,a6
	MOVE.L	4(A6),D0
	ANDI.L	#$1FF00,D0
	CMP.L	#$12000,D0
	BNE.S	WaitBot
	rts

*********************************************
* Reinigen Sie den Bildschirm mit dem 68000 *
*********************************************

ClWork:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	MOVE.L	DrawPlane(PC),a0
	MOVE.L	SP,OLDSP
	LEA	40*200(a0),SP				; ADD length OF SCREEN
	MOVEM.L	CLREG(PC),D0-D7/A0-A6	; CLEAR REGISTERS
;	MOVEM.L	D0-D7/A0-A6,-(SP)
	dcb.l	133,$48E7FFFE			; NOW CLEAR WITH CPU WHEN A BLIT IS IN PROG.
	movem.l	d0-d3,-(SP)
	MOVE.L	OLDSP(PC),SP			; 60 bytes every instruction!
	MOVEM.L	(SP)+,D0-D7/A0-A6
	RTS

CLREG:
	Dcb.L	15,0

OLDSP:
	dc.l	0

*****************************************************************************
*	Finden Sie den Sin / Cos-Wert für den Winkel X in d0			        *
*	Verwenden der Tabelle SINTAB.w mit 360 Werten für 360 Grad				*
*   bei der Eingabe möglich													*
*	Ausgabe: d1 = SIN(x), d2 = COS(x)									    *
*****************************************************************************

SinCos:
	TST.w	D0				; Winkel = Null?
	BPL.s	NOADDI			; wenn >0, gehe zu NOADDI
	ADD.w	#360,D0			; ansonsten füge ich 360 hinzu (der SIN von NULL
							; ist dasselbe wie der SIN von 360)
NOADDI:
	LEA	sintab(PC),A1		; Adresse Tabelle mit vorberechneten Sinus
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



*************************************************************
* Init the main diagonal of the risultante matrix with      *
* ones which were multiplied by 2^14. This subroutine must  *
* be called at least once before the call by rotate, or the *
* risultante matrix will only consist of zeros.             *
*************************************************************

matinit:
	moveq	#0,d1
	move.w	#16384,d2		; The initial value for
	move.w	d2,Matrix11		; the main diagonal of
	move.w	d1,Matrix12		; the risultante matrix
	move.w	d1,Matrix13		; all other elements 
	move.w	d1,Matrix21		; at zero.
	move.w	d2,Matrix22
	move.w	d1,Matrix23
	move.w	d1,Matrix31
	move.w	d1,Matrix32
	move.w	d2,Matrix33
	rts

***************************************************************
* Multiplication of the rotation matrix by the rotation       *
* matrix for rotation about the X-Axis                        *
***************************************************************

; Multiply matrix11-matrix33 with the rotation matrix for a rotation
; about the X-Axis

xrotate:
	move.w	xangle(PC),d0		; angel X in d0
	bsr.w	SinCos				; get the SINUS and COSINE of the angle
	move.w	d1,sinx				; and save them in SINX and COSX
	move.w	d2,cosx
	move.w	d1,d3				; copy SIN(x) in d2
	move.w	d2,d4				; copy COS(x) in d4
	move.w	Matrix11(PC),Rotx11	; The first column of the matrix
	move.w	Matrix21(PC),Rotx21	; Does not change with X rotation
	move.w	Matrix31(PC),Rotx31
	muls.w	Matrix12(PC),d2
	muls.w	Matrix13(PC),d1
	sub.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx12
	move.w	d3,d1
	move.w	d4,d2
	muls	Matrix22(PC),d2
	muls	Matrix23(PC),d1
	sub.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx22
	move.w	d3,d1
	move.w	d4,d2
	muls	Matrix32(PC),d2
	muls	Matrix33(PC),d1
	sub.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx32
	move.w	d3,d1
	move.w	d4,d2
	muls	Matrix12(PC),d1
	muls	Matrix13(PC),d2
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx13
	move.w	d3,d1
	move.w	d4,d2
	muls	Matrix22(PC),d1
	muls	Matrix23(PC),d2
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx23
	muls	Matrix32(PC),d3
	muls	Matrix33(PC),d4
	add.l	d3,d4
	lsl.l	#2,d4
	swap	d4
	move.w	d4,Rotx33
	lea	Rotx11(PC),a1
	lea	Matrix11(PC),a2
	moveq	#8,d7				; Number of matrix elements

roxlop1:	
	move.w	(a1)+,(a2)+			; Copy risultante matrix, which
	dbra	d7,roxlop1			; is still in ROTXnn, to MATRIXnn
	rts

***********************************************************
* Multiply the general rotation matrix by the Y-axis	  *
* rotation matrix. risultantes are stored in the general  *
* rotation matrix										  *
***********************************************************

yrotate:
	move.w	yangle(PC),d0		; Angle around which rotation is made
	bsr.w	SinCos				; derives SINUS and COSINE of the angle Y
	move.w	d1,siny				; and save them in SINY und COSY
	move.w	d2,cosy
	move.w	d1,d3				; Sine of Y-Angle copied in d3
	move.w	d2,d4				; Cosine of Y-angle copied in d4

	muls	Matrix11(PC),d2
	muls	Matrix13(PC),d1
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx11
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix21(PC),d2
	muls	Matrix23(PC),d1
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx21
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix31(PC),d2
	muls	Matrix33(PC),d1
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx31
	neg.w	d3	
	move.w	d3,d1					; -siny in the rotation mat.
	move.w	d4,d2

	move.w	Matrix12(PC),Rotx12
	move.w	Matrix22(PC),Rotx22		; The second column
	move.w	Matrix32(PC),Rotx32		; of the starting matrix
									; does not change.
	muls	Matrix11(PC),d1
	muls	Matrix13(PC),d2
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx13
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix21(PC),d1
	muls	Matrix23(PC),d2
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx23

	muls	Matrix31(PC),d3
	muls	Matrix33(PC),d4
	add.l	d3,d4
	lsl.l	#2,d4
	swap	d4
	move.w	d4,Rotx33

	moveq	#8,d7
	lea	Rotx11(PC),a1			; address of resulting matrix
	lea	Matrix11(PC),a2			; address of original matrix

yrotlop1:
	move.w	(a1)+,(a2)+			; Copy risultante matrix
	dbra	d7,yrotlop1			; to original matrix
	rts

********************************************
* Z-axis - Rotation matrix multiplications *
********************************************

zrotate:
	move.w	zangle(PC),d0
	bsr.w	SinCos				; derives the SINUS and COSINE of the angle Z
	move.w	d1,sinz				; and save them in SINZ and COSZ
	move.w	d2,cosz
	move.w	d1,d3				; copy the SIN(z) in d3
	move.w	d2,d4				; copy the COS(z) in d4

	muls.w	Matrix11(PC),d2
	muls.w	Matrix12(PC),d1
	sub.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx11
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix21(PC),d2
	muls	Matrix22(PC),d1
	sub.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx21
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix31(PC),d2
	muls	Matrix32(PC),d1
	sub.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx31
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix11(PC),d1
	muls	Matrix12(PC),d2
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx12
	move.w	d3,d1
	move.w	d4,d2

	muls	Matrix21(PC),d1
	muls	Matrix22(PC),d2
	add.l	d1,d2
	lsl.l	#2,d2
	swap	d2
	move.w	d2,Rotx22

	muls	Matrix31(PC),d3
	muls	Matrix32(PC),d4
	add.l	d3,d4
	lsl.l	#2,d4
	swap	d4
	move.w	d4,Rotx32

	move.w	Matrix13(PC),Rotx13		; The third column remains
	move.w	Matrix23(PC),Rotx23		; Unchanged
	move.w	Matrix33(PC),Rotx33

	moveq	#8,d7
	lea	Rotx11(PC),a1
	lea	Matrix11(PC),a2

zrotlop1:
	move.w	(a1)+,(a2)+				; Copy to general
	dbra	d7,zrotlop1				; rotation matrix
	rts

***************************************************************************
* Multiply every point whose Array address is in CoordZOggettoSpaz etc.   *
* by previous translation of the coordinate source to					  *
* point [offx,offy,offz], with the general rotation matrix.				  *
* The coordinate source of the risultante coordinates is then			  *
* moved to point [xoffs,yoffs,zoffs]									  *
***************************************************************************

rotate:
	move.w	NumeroPunti(PC),d0		; Number of points to be

	lea	Oggetto1(PC),a1				; coord X
	lea	Oggetto1+2(PC),a1			; coord Y
	lea	Oggetto1+4(PC),a1			; coord Z

	lea	pointxROT(PC),a4			; buffer where to put the coordinates
	lea	pointyROT(PC),a5			; rotate
	lea	pointzROT(PC),a6

rotate1:
	move.w	(a1)+,d1				; X-Coordinate
	add.w	offx(PC),d1
	move.w	d1,d4

	move.w	(a1)+,d2				; Y-Coordinate
	add.w	offy(PC),d2				; Translation to point[offx,offy,offz]
	move.w	d2,d5

	move.w	(a1)+,d3				; Z-Coordinate
	add.w	offz,d3
	move.w	d3,d6

	muls	Matrix11(PC),d1
	muls	Matrix21(PC),d2
	muls	Matrix31(PC),d3

	add.l	d1,d2
	add.l	d2,d3
	lsl.l	#2,d3
	swap	d3
	add.w	xoffs,d3
	move.w	d3,(a4)+				; Rotated X-Coordinate

	move.w	d4,d1
	move.w	d5,d2
	move.w	d6,d3

	muls	Matrix12(PC),d1
	muls	Matrix22(PC),d2
	muls	Matrix32(PC),d3
	add.l	d1,d2
	add.l	d2,d3
	lsl.l	#2,d3
	swap	d3
	add.w	yoffs(PC),d3
	move.w	d3,(a5)+				; Rotated Y-Coordinate

	muls	Matrix13(PC),d4
	muls	Matrix23(PC),d5
	muls	Matrix33(PC),d6
	add.l	d4,d5
	add.l	d5,d6
	lsl.l	#2,d6
	swap	d6
	add.w	zoffs(PC),d6
	move.w	d6,(a6)+				; Rotated Z-Coordinate

	dbra	d0,rotate1
	rts

*********************************************************************
* Perspective, calculated from the transformed points in the arrays *
* pointxROT, pointyROT and pointzROT the screen coordinates, which  *
* are then stored in the arrays pointxROTprimo and pointyROTprimo.  *
*********************************************************************

Pers:
	lea	pointxROT(PC),a1		; Beginning address of point arrays
	lea	pointyROT(PC),a2
	lea	pointzROT(PC),a3

	lea	pointxROTprimo(PC),a4	; Start address of display coordinate
	lea	pointyROTprimo(PC),a5	; array.

	move.w	NumeroPunti(PC),d0	; Number of points to be transformed
perlop:
	MOVE.w	(A3)+,D5			; coordinata Z dell'oggetto
	move.w	d5,d6
	MOVE.w	dist(PC),D4			; distanza dell'oggetto, fattore di
								; ingrandimento
	sub.w	d5,d4				; Dist minus Z-coordinate of obj.coord
	ext.l	d4
	lsl.l	#8,d4				; Times 256 for value fitting
	move.w	Zobs(PC),d3			; Projection center Z-coordinates
	ext.l	d3

	sub.l	d6,d3				; Minus z-coordinate of object
	bne.s	pers1

	moveq	#0,d1				; Catch division by zero
	addq.w	#2,a1
	addq.w	#2,a2
	move.w	d1,(a4)+			; val X interm.
	move.w	d1,(a5)+			; val Y interm.
	bra.s	perend1

pers1:
	divs.w	d3,d4
	move.w	d4,d3
	move.w	(a1)+,d1			; X-Coordinate of object
	move.w	d1,d2
	neg.w	d1
	muls	d1,d3				; Multiplied by perspective factor
	lsr.l	#8,d3				; /256 save value fitting

	add.w	d3,d2				; add to x-coordinate
	add.w	Xorigine(PC),d2		; add screen offset (center point)
	move.w	d2,(a4)+			; Display X-coordinate

	move.w	(a2)+,d1			; Y-Coordinate of object
	move.w	d1,d2
	neg.w	d1
	muls.w	d1,d4
	lsr.l	#8,d4				; /256

	add.w	d4,d2
	neg.w	d2					; Display offset, mirror of Y-Axis
	add.w	Yorigine(PC),d2		; Source at [X0,Y0]
	move.w	d2,(a5)+			; Display Y-Coordinate
perend1:
	dbra	d0,perlop			; Until all points transformed

	rts


************************************************
* Init the rotation reference point to [0,0,0] *
************************************************

SetRotDp:
	moveq	#0,d1
	move.w	d1,rotdpx
	move.w	d1,rotdpy
	move.w	d1,rotdpz
	move.w	d1,yangle		; Start rotation angle
	move.w	d1,xangle
	move.w	d1,zangle
	rts

***********************************************************
* Rotation around one point, the rotation reference point *
***********************************************************

PointRot:
	move.w	rotdpx(PC),d0	; Rotation reference point
	move.w	rotdpy(PC),d1
	move.w	rotdpz(PC),d2
	move.w	d0,xoffs
	move.w	d1,yoffs
	move.w	d2,zoffs		; add for back transformation
	neg.w	d0
	neg.w	d1
	neg.w	d2
	move.w	d0,offx			; subtract for transformation
	move.w	d1,offy
	move.w	d2,offz
	bsr.w	matinit
	bsr.w	zrotate
	bsr.w	yrotate
	bsr.w	xrotate
	bsr.w	rotate
	rts


******************************************************************************
******************************************************************************
**																			**
**		OBJECT DRAWING ROUTINES ON THE BITPLANE								**
**																		    **
******************************************************************************
******************************************************************************

**************************************************************
* Draw number of lines from array from lines in LineeOggetto *
**************************************************************

DrawN1:
	lea	pointxROTprimo(PC),a4		; Display X-Coordinate
	lea	pointyROTprimo(PC),a5		; Display Y-Coordinate

	move.w	NUMLineeOggetto(PC),d0	; Number of lines that connect
									; points of the solid
	lea	LineeOggetto(PC),a6			; address of line array

drlop:
	move.l	(a6)+,d1				; First line (P1,P2)
	lsl.w	#1,d1					; Times list element length (2)
	move.w	(a4,d1.w),d2			; X-Coordinate of 2nd point
	move.w	(a5,d1.w),d3			; Y-Coordinate of second point
	swap	d1						; now another point
	lsl.w	#1,d1					; *2 (words)
	move.w	(a4,d1.w),a2			; X-Coordinate of first point
	move.w	(a5,d1.w),a3			; Y-Coordinate of first point
	bsr.w	Drawl					; Draw line from P1 to P2
	dbra	d0,drlop				; Until all lines drawn
	rts

;


*******************************************************************
* Draw-line routine, The points are passed in D2,D3 (start point) *
* and A2, A3 (end point)                                          *
*******************************************************************

Drawl:
	movem.l	d0-d3/a0-a1,-(a7)
	move.l	d2,d0
	move.l	d3,d1					; X,y start
	move.l	a2,d2
	move.l	a3,d3					; X,y end
	bsr.s	Draw
	movem.l	(a7)+,d0-d3/a0-a1
	rts

****************
* Blitter Line *
****************

Draw:
	movem.l	d2-d7/a2-a3,-(a7)
	moveq	#$f,d4
	and.w	d2,d4					; low 4 bits
	sub.w	d3,d1					; Height
	mulu	#LarghSchermo/8,d3		; Start address
	sub.w	d2,d0					; Width
	blt.s	No1
	tst.w	d1
	blt.s	No2
	CMP.w	d0,d1
	bge.s	No3
	moveq	#$11,d7
	bra.s	OctSel					; Octant #
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
	add.l	d2,d3					; Total offset
	move.w	d1,d2
	sub.w	d0,d2
	bge.s	NoMinus
	ori.w	#$40,d7					; Sign = -
NoMinus:
	lea	$dff000,a0
	move.w	d2,a3
	move.w	#$ffff,d6				; LinePtrn
WaitBl:
		btst	#6,2(a0)
	bne.s	WaitBl
	move.w	d1,$62(a0)				; 4Y
	move.w	d2,d1
	sub.w	d0,d1
	move.w	d1,$64(a0)				; 4Y-4X
	moveq	#-1,d1
	move.l	d1,$44(a0)				; AFWM+ALWM
	move.w	#LarghSchermo/8,$60(a0) ; BitMap Width in bytes
	move.w	d7,d5
	addq.w	#1,d0
	asl.w	#6,d0
	addq.w	#2,d0					; Blitsize
	move.w	d4,d2
	swap	d4
	asr.l	#4,d4					; First pixelpos
	ori.w	#$b00,d4				; Use ABD
	move.w	#$8000,$74(a0)			; Index
	clr.w	d1
NoSpesh:
	move.l	DrawPlane,d7			; Pointer
	swap	d5
	move.w	d4,d5
	move.b	#$ca,d5					; MinTerms
	swap	d5
	add.l	d3,d7
WtBl2:
	btst	#6,2(a0)
	bne.s	WtBl2
	move.l	d5,$40(a0)				; bltCon0 & 1
	move.w	a3,$52(a0)				; 2Y-X
	move.l	d7,$48(a0)
	move.l	d7,$54(a0)				; Start address of line
	move.w	d6,$72(a0)				; Pattern
	move.w	d0,$58(a0)				; Size
	movem.l	(a7)+,d2-d7/a2-a3
	rts



******************************************************************************
*	definition of the solid 3d wireframe									 *
******************************************************************************


;	      (P4) -50,+50,+50______________+50,+50,+50 (P5)
;					     /|			   /|
;						/ |			  / |
;					   /  |			 /  |
;					  /   |			/   |
;	 (P0) -50,+50,-50/____|________/+50,+50,-50 (P1)
;					|     |       |     |
;					|     |_______|_____|+50,-50,+50 (P6)
;					|    /-50,-50,+50 (P7)
;					|   /	      |   /
;					|  /	      |  /
;					| /			  | /
;					|/____________|/+50,-50,-50 (P2)
;	 (P3) -50,-50,-50

Oggetto1:			; Here are the 8 points defined by the coordinates. X,Y,Z
	dc.w	-20,+20,-20	; P0 (X,Y,Z)
	dc.w	+20,+20,-20	; P1 (X,Y,Z)
	dc.w	+20,-20,-20	; P2 (X,Y,Z)
	dc.w	-20,-20,-20	; P3 (X,Y,Z)
	dc.w	-20,+20,+20	; P4 (X,Y,Z)
	dc.w	+20,+20,+20	; P5 (X,Y,Z)
	dc.w	+20,-20,+20	; P6 (X,Y,Z)
	dc.w	-20,-20,+20	; P7 (X,Y,Z)

NPuntiOggetto	= 8

***** What points should be connected with lines? ****

; connections:

; connections between the points: the order is as desired, but be careful not to trace
; the same line 2 times! A cube has 12 edges, in fact here are 12 connections

LineeOggetto:
lines:
	dc.w	0,1	; face in front
	dc.w	1,2
	dc.w	2,3
	dc.w	3,0

	dc.w	4,5	; face behind
	dc.w	5,6
	dc.w	6,7
	dc.w	7,4

	dc.w	0,4	; side edges
	dc.w	1,5
	dc.w	2,6
	dc.w	3,7

NLineeOggetto	= 12


******************************************************************************
******************************************************************************
**																		    **
**			TABLE OF SINUSES AND VARIABLES								    **
**																		    **
******************************************************************************
******************************************************************************

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


sintab:
	dc.w	0,286,572,857,1143,1428,1713,1997,2280
	dc.w	2563,2845,3126,3406,3686,3964,4240,4516
	dc.w	4790,5063,5334,5604,5872,6138,6402,6664
	dc.w	6924,7182,7438,7692,7943,8192,8438,8682
	dc.w	8923,9162,9397,9630,9860,10087,10311,10531
	dc.w	10749,10963,11174,11381,11585,11786,11982,12176
	dc.w	12365,12551,12733,12911,13085,13255,13421,13583
	dc.w	13741,13894,14044,14189,14330,14466,14598,14726
	dc.w	14849,14962,15082,15191,15296,15396,15491,15582
	dc.w	15668,15749,15826,15897,15964,16026,16083,16135
	dc.w	16182,16225,16262,16294,16322,16344,16362,16374
	dc.w	16382,16383

	dc.w	16382,16374,16362,16344,16322,16294,16262,16225
	dc.w	16182
	dc.w	16135,16083,16026,15964,15897,15826,15749,15668
	dc.w	15582,15491,15396,15296,15191,15082,14962,14849
	dc.w	14726,14598,14466,14330,14189,14044,13894,13741
	dc.w	13583,13421,13255,13085,12911,12733,12551,12365
	dc.w	12176,11982,11786,11585,11381,11174,10963,10749
	dc.w	10531,10311,10087,9860,9630,9397,9162,8923
	dc.w	8682,8438,8192,7943,7692,7438,7182,6924
	dc.w	6664,6402,6138,5872,5604,5334,5063,4790
	dc.w	4516,4240,3964,3686,3406,3126,2845,2563
	dc.w	2280,1997,1713,1428,1143,857,572,286,0

	dc.w	-286,-572,-857,-1143,-1428,-1713,-1997,-2280
	dc.w	-2563,-2845,-3126,-3406,-3686,-3964,-4240,-4516
	dc.w	-4790,-5063,-5334,-5604,-5872,-6138,-6402,-6664
	dc.w	-6924,-7182,-7438,-7692,-7943,-8192,-8438,-8682
	dc.w	-8923,-9162,-9397,-9630,-9860,-10087,-10311,-10531
	dc.w	-10749,-10963,-11174,-11381,-11585,-11786,-11982,-12176
	dc.w	-12365,-12551,-12733,-12911,-13085,-13255,-13421,-13583
	dc.w	-13741,-13894,-14044,-14189,-14330,-14466,-14598,-14726
	dc.w	-14849,-14962,-15082,-15191,-15296,-15396,-15491,-15582
	dc.w	-15668,-15749,-15826,-15897,-15964,-16026,-16083,-16135
	dc.w	-16182,-16225,-16262,-16294,-16322,-16344,-16362,-16374
	dc.w	-16382,-16383

	dc.w	-16382,-16374,-16362,-16344,-16322,-16294,-16262,-16225
	dc.w	-16182
	dc.w	-16135,-16083,-16026,-15964,-15897,-15826,-15749,-15668
	dc.w	-15582,-15491,-15396,-15296,-15191,-15082,-14962,-14849
	dc.w	-14726,-14598,-14466,-14330,-14189,-14044,-13894,-13741
	dc.w	-13583,-13421,-13255,-13085,-12911,-12733,-12551,-12365
	dc.w	-12176,-11982,-11786,-11585,-11381,-11174,-10963,-10749
	dc.w	-10531,-10311,-10087,-9860,-9630,-9397,-9162,-8923
	dc.w	-8682,-8438,-8192,-7943,-7692,-7438,-7182,-6924
	dc.w	-6664,-6402,-6138,-5872,-5604,-5334,-5063,-4790
	dc.w	-4516,-4240,-3964,-3686,-3406,-3126,-2845,-2563
	dc.w	-2280,-1997,-1713,-1428,-1143,-857,-572,-286,0


sinx:	dc.w	0			; Temporary storage for sin & cos
siny:	dc.w	0			; values
sinz:	dc.w	0

cosx:	dc.w	0
cosy:	dc.w	0
cosz:	dc.w	0


xangle:	dc.w	0			; Variables for passing angles
yangle:	dc.w	0			; to the rotation subroutine
zangle:	dc.w	0


Zobs:	dc.w	2000		; Z coordinate of the projection center (observer)

dist:	dc.w	-990

Rotx11:	dc.w	16384		; Space here for the resulting matrix
Rotx12:	dc.w	0			; of matrix multiplication
Rotx13:	dc.w	0
Rotx21:	dc.w	0
Rotx22:	dc.w	16384
Rotx23:	dc.w	0
Rotx31:	dc.w	0
Rotx32:	dc.w	0
Rotx33:	dc.w	16384

Matrix11:	dc.w	0		; Space here for the general rotation
Matrix12:	dc.w	0		; matrix
Matrix13:	dc.w	0
Matrix21:	dc.w	0
Matrix22:	dc.w	0
Matrix23:	dc.w	0
Matrix31:	dc.w	0
Matrix32:	dc.w	0
Matrix33:	dc.w	0

DrawPlane:
	dc.l	0


******************************************************************************
*		    routine data and variables										 *
******************************************************************************

NumeroPunti:
	dc.w	NPuntiOggetto-1	; Number of corner points of the object
NUMLineeOggetto:
	dc.w	NLineeOggetto-1	; Number of lines in the object


; X and Y coordinates of the ORIGIN of the axes with respect to the screen, in 
; this one case we place them in the center of the screen.

Xorigine:	dc.w	LarghSchermo/2	; 320/2 = 160, center X screen
Yorigine:	dc.w	LunghSchermo/2	; 200/2 = 100, center Y




rotdpx:	dc.w	0
rotdpy:	dc.w	0
rotdpz:	dc.w	0	; Rotation datum point


; buffer for points rotated in space

pointxROT:
	DS.W NPuntiOggetto
pointyROT:
	DS.W NPuntiOggetto
pointzROT:
	DS.W NPuntiOggetto


; Projected X and Y coordinates, i.e. in perspective, ready for
; be drawn

pointxROTprimo:
	DS.W NPuntiOggetto
pointyROTprimo:
	DS.W NPuntiOggetto


prox:	dc.w	0	; Coordinates of the projection center
proy:	dc.w	0	; on the positive Z-axis

offx:	dc.w	0
offy:	dc.w	0
offz:	dc.w	0
xoffs:	dc.w	0
yoffs:	dc.w	0
zoffs:	dc.w	0

loopc:	dc.l	0

******************************************************************************
******************************************************************************
**																			**
**			COPPERLIST AND BITPLANES										**
**																			**
******************************************************************************
******************************************************************************


		section	copper,data_C

Copperlist:
	dc.w	$0180,$0000,$0182,$fff
	dc.w	$0100,$1200,$00e0
HiBMPtr:
	dc.w	$0000,$00e2
LowBMPtr:
	dc.w	$0000,$0092,$0038,$0094,$00d0
	dc.w	$008e,$2c81,$0090,$f4c1
	dc.w	$108,0
	dc.w	$10a,0	
	dc.w	$0120
sp1h:	dc.w 0,$0122
sp1l:	dc.w 0,$0124
sp2h:	dc.w 0,$0126
sp2l:	dc.w 0,$0128
sp3h:	dc.w 0,$012a
sp3l:	dc.w 0,$012c,0,$012e,0,$0130,0,$0132,0,$0134,0
	dc.w $0136,0,$0138,0,$013a,0,$013c,0,$013e,0

	dc.w	$ffff,$fffe			; end copperlist


	section	planes,bss_C

bitplane0:
	ds.b	40*LunghSchermo
bitplane:
	ds.b	40*LunghSchermo

	end

