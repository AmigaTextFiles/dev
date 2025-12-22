
; Listing18h2.s = dreckload.s

res=320
wpl=160			;res /2
color=0
Botline=$c0

;3D GRAPHICS DRIVER, CONVERTED BY ANTIACTION OF TETRAGON

	SECTION A,CODE_C

s:
 movem.l a0-a6/d0-d7,-(sp)		; Save registers
 movea.l 4.w,a6
 jsr	-$84(a6)			; Forbid - No multitask
 bsr.w	Start				; Init screen stuff
 bsr.w	Main				; Do main stuff
 bsr.w	Reset				; Reset screen stuff
 movea.l 4.w,a6
 jsr	-$8a(a6)			; Permit - multitask
 movem.l (sp)+,a0-a6/d0-d7		; Recall old registers
 rts

* Pass upper screen to VDC while drawing the other *


PageUp:
 move.l	d0,-(a7)
 move.l	#RAST,DrawPlane		; Rastport structure
 move.l	#BPLBUFFER,d0			; BitMap pointer
 move.w	d0,LowBMPtr
 swap	d0
 move.w	d0,HiBMPtr			; Copper fixes the rest


 bsr.s	WaitBot

 move.l	(a7)+,d0
 rts

Waitbot:
	lea	$dff000,a6
	MOVE.L	4(A6),D0
	ANDI.L	#$1FF00,D0
	CMP.L	#$12000,D0
	BNE.S	waitbot
	rts

* Pass lower screen to VDC while drawing the other *

PageDown:
 move.l	d0,-(a7)
 move.l	#BPLBUFFER,DrawPlane		; Rastport structure
 move.l	#RAST,d0			; BitMap pointer
 move.w	d0,LowBMPtr
 swap	d0
 move.w	d0,HiBMPtr			; Copper fixes the rest
 bsr.s	WaitBot
 move.l	(a7)+,d0
 rts


* Clear the screen *

clwork:
 btst	#14,$dff002
 bne.s	clwork

 move.l	DrawPlane,$dff054
 move.l	#$01000000,$dff040
 move.w	#0,$dff066
 move.w	#200*64+wpl,$dff058

 move.w	#$0f0,color
 rts

* Initialize stuff routine *

Start:

	movea.l	4.w,a6				;execbase in a6
	lea	GfxName(pc),a1
	jsr	-$198(a6)			; Open Gfx Library
	move.l	d0,GfxBase
	move.l	d0,a6
	move.w	#%0000001111100000,$dff096	;DMACON - disable dma
	move.l	$32(a6),OldCop			;save old coplist
	move.l	#CopList,$32(a6)		;point at my coplist
	move.w	#%1000011111100000,$dff096	;DMACON - enable dma
	move.w	#0,$dff088			;COPJMP1 - Start coplist
 	rts

Reset:
 move.l	GfxBase,a6
 move.w	#$0100,$dff096
 move.l	OldCop,$32(a6)
 move.w	#$8100,$dff096
 move.l	GfxBase,a1
 move.l	$4.w,a6
 jsr	-414(a6)
 rts

* Draw-line routine, The points are passed in D2,D3 (start point) *
* and A2, A3 (end point)						*

Drawl:
 movem.l d0-d3/a0-a1,-(a7)

 move.l	d2,d0
 move.l	d3,d1				; X,y start
 move.l	a2,d2
 move.l	a3,d3				; X,y end
 bsr.s	Draw

 movem.l (a7)+,d0-d3/a0-a1
 rts

* Blitter Line *

Draw:
 MOVE.W	#$400,$96(A0)
 movem.l d2-d7/a2-a3,-(a7)
 moveq	#$f,d4
 and.w	d2,d4				; low 4 bits
 sub.w	d3,d1				; Height
 mulu	#res/8,d3			; Start address
 sub.w	d2,d0				; Width
 blt.s	No1
 tst.w	d1
 blt.s	No2
 cmp.w	d0,d1
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
 cmp.w	d0,d1
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

 cmp.w	d0,d1
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
 cmp.w	d0,d1
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
 MOVE.W	#$8400,$96(A0)
WaitBl:
 btst	#14,2(a0)
 bne.s	WaitBl
Wait2Bl:
 btst	#14,2(a0)
 bne.s	Wait2Bl
 move.w	d1,$62(a0)			; 4Y
 move.w	d2,d1
 sub.w	d0,d1
 move.w	d1,$64(a0)			; 4Y-4X
 moveq	#-1,d1				; $FFFFFFFF in d1
 move.l	d1,$44(a0)			; AFWM+ALWM
 move.w	#res/8,$60(a0)			; BitMap Width in bytes
 move.w	d7,d5
 addq.w	#1,d0
 asl.w	#6,d0
 addq.w	#2,d0				; Blitsize
 move.w	d4,d2
 swap	d4
 asr.l	#4,d4				; First pixelpos
 ori.w	#$b00,d4			; Use ABD
 move.w	#$8000,$74(a0)			; Index
 clr.w d1
NoSpesh:
 move.l	DrawPlane,d7			; Pointer
 swap	d5
 move.w	d4,d5
 move.b	#$ca,d5				; MinTerms
 swap	d5
 add.l	d3,d7
 MOVE.W	#$8400,$96(A0)
WtBl2:
 btst	#14,2(a0)
 bne.s	WtBl2
Wt2Bl2:
 btst	#14,2(a0)
 bne.s	Wt2Bl2
 move.l	d5,$40(a0)			; BltCon0 & 1
 move.w	a3,$52(a0)			; 2Y-X
 move.l	d7,$48(a0)
 move.l	d7,$54(a0)			; Start address of line
 move.w	d6,$72(a0)			; Pattern
 move.w	d0,$58(a0)			; Size
 movem.l (a7)+,d2-d7/a2-a3
 rts

* Sine and cosine function, angle is passed in D0	*
* and the sine and cosine are returned in D1 and D2 *

sincos:
 MOVE.W	#$400,$96(A0)
 tst.w	d0				; Angle neg. add 360°
 bpl.s	noaddi
 addi.w	#360,d0
noaddi:
 move.l	#sintab,a1			; Beginning ad. of sinetable
 move.l	d0,d2				; Angle in d0 and d2
 lsl.w	#1,d0				; Angle times 2 as index
 move.w	0(a1,d0.w),d1			; Sine to D1
 cmpi.w	#270,d2				; Calc cosine through
 blt.s	plus9				; displacement of sine value
 subi.w	#270,d2				; by 90 degrees
 bra.s	sendsin
plus9:
 addi.w	#90,d2
sendsin:
 lsl.w	#1,d2
 move.w	(a1,d2.w),d2			; Cosine to D2

 rts					; And return

* Sine function						*
* Angle is passed in d0 and the sine returned in D1 *

sin:
 move.l	#sintab,a1
 tst.w	d0
 bpl.s	sin1
 addi.w	#360,d0
sin1:
 lsl.w	#1,d0
 move.w	(a1,d0.w),d1
 rts

* Init the main diagonal of the result Matrix with		*
* ones which were multiplied by 2^14. This subroutine must	*
* be called at least once before the call by rotate, or the *
* result Matrix will only consist of zeros.			*

matinit:
 MOVE.W	#$400,$96(A0)
 moveq	#0,d1
 move.w	#16384,d2			; The initial value for
 move.w	d2,Matrix11			; the main diagonal of
 move.w	d1,Matrix12			; the result Matrix
 move.w	d1,Matrix13			; all other elements 
 move.w	d1,Matrix21			; at zero.
 move.w	d2,Matrix22
 move.w	d1,Matrix23
 move.w	d1,Matrix31
 move.w	d1,Matrix32
 move.w	d2,Matrix33
 rts

* Multiplication of the rotation Matrix by the rotation	*
* Matrix for rotation about the X-Axis				*

xrotate:
 MOVE.W	#$400,$96(A0)
 move.w	Xangle,d0		; Multiply Matrix11-Matrix33
 bsr.w	sincos			; with the rotation Matrix
 move.w	d1,sinx			; for a rotation about the X-Axis
 move.w	d2,Cosx
 move.w	d1,d3
 move.w	d2,d4
 move.w	Matrix11,Rotx11		; The first column of the Matrix
 move.w	Matrix21,Rotx21		; Does not change with X rotation
 move.w	Matrix31,Rotx31
 muls	Matrix12,d2
 muls	Matrix13,d1
 sub.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx12
 move.w	d3,d1
 move.w	d4,d2
 muls	Matrix22,d2
 muls	Matrix23,d1
 sub.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx22
 move.w	d3,d1
 move.w	d4,d2
 muls	Matrix32,d2
 muls	Matrix33,d1
 sub.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx32
 move.w	d3,d1
 move.w	d4,d2
 muls	Matrix12,d1
 muls	Matrix13,d2
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx13
 move.w	d3,d1
 move.w	d4,d2
 muls	Matrix22,d1
 muls	Matrix23,d2
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx23
 muls	Matrix32,d3
 muls	Matrix33,d4
 add.l	d3,d4
 lsl.l	#2,d4
 swap	d4
 move.w	d4,Rotx33
 move.l	#Rotx11,a1
 move.l	#Matrix11,a2
 moveq	#8,d7			; Number of Matrix elements

Roxlop1:
 move.w	(a1)+,(a2)+		; Copy result Matrix, which
 dbra	d7,Roxlop1		; is still in Rotxnn, to Matrixnn
 rts

* Multiply the general rotation Matrix by the Y-axis		*
* rotation Matrix. Results are stored in the general		*
* rotation Matrix						*

yrotate:
 MOVE.W	#$400,$96(A0)
 move.w	Yangle,d0		; Angle around which rotation is made
 bsr.w	sincos
 move.w	d1,siny
 move.w	d2,Cosy
 move.w	d1,d3			; Sine of Y-Angle
 move.w	d2,d4			; Cosine of Y-angle

 muls	Matrix11,d2
 muls	Matrix13,d1
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx11
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix21,d2
 muls	Matrix23,d1
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx21
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix31,d2
 muls	Matrix33,d1
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx31
 neg.w	d3
 move.w	d3,d1				; -siny in the rotation mat.
 move.w	d4,d2

 move.w	Matrix12,Rotx12
 move.w	Matrix22,Rotx22			; The second column
 move.w	Matrix32,Rotx32			; of the starting Matrix
					; does not change.
 muls	Matrix11,d1
 muls	Matrix13,d2
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx13
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix21,d1
 muls	Matrix23,d2
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx23

 muls	Matrix31,d3
 muls	Matrix33,d4
 add.l	d3,d4
 lsl.l	#2,d4
 swap	d4
 move.w	d4,Rotx33

 moveq	#8,d7

 move.l	#Rotx11,a1			; Address of result Matrix
 move.l	#Matrix11,a2			; Address of original Matrix

yrotlop1:
 move.w	(a1)+,(a2)+			; Copy result Matrix
 dbra	d7,yrotlop1			; to original Matrix
 rts

* Z-axis - Rotation Matrix multiplications *

zrotate:
 MOVE.W	#$400,$96(A0)
 move.w	Zangle,d0
 bsr.w	sincos
 move.w	d1,sinz
 move.w	d2,Cosz
 move.w	d1,d3
 move.w	d2,d4

 muls	Matrix11,d2
 muls	Matrix12,d1
 sub.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx11
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix21,d2
 muls	Matrix22,d1
 sub.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx21
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix31,d2
 muls	Matrix32,d1
 sub.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx31
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix11,d1
 muls	Matrix12,d2
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx12
 move.w	d3,d1
 move.w	d4,d2

 muls	Matrix21,d1
 muls	Matrix22,d2
 add.l	d1,d2
 lsl.l	#2,d2
 swap	d2
 move.w	d2,Rotx22

 muls	Matrix31,d3
 muls	Matrix32,d4
 add.l	d3,d4
 lsl.l	#2,d4
 swap	d4
 move.w	d4,Rotx32

 move.w	Matrix13,Rotx13			; The third column remains
 move.w	Matrix23,Rotx23			; Unchanged
 move.w	Matrix33,Rotx33

 moveq	#8,d7
 move.l	#Rotx11,a1
 move.l	#Matrix11,a2

zrotlop1:
 move.w	(a1)+,(a2)+			; Copy to general
 dbra	d7,zrotlop1			; rotation Matrix
 rts

* Multiply every point whose Array address is in datx etc.	*
* by previous translation of the coordinate source to	 *
* point [offx,offy,offz], with the general rotation Matrix.	*
* The coordinate source of the result coordinates is then	*
* moved to point [xoffs,yoffs,zoffs]				*

rotate:
 MOVE.W	#$400,$96(A0)
 move.w	nummark,d0			; Number of points to be
 ext.l	d0				; transformed as counter
 subq.l	#1,d0

 move.l	datx,a1
 move.l	daty,a2
 move.l	datz,a3

 move.l	pointx,a4
 move.l	pointy,a5
 move.l	pointz,a6

rotate1:
 MOVE.W	#$400,$96(A0)
 move.w	(a1)+,d1			; X-Coordinate
 add.w	offx,d1
 move.w	d1,d4

 move.w	(a2)+,d2			; Y-Coordinate
 add.w	offy,d2			; Translation to point[offx,offy,offz]
 move.w	d2,d5

 move.w	(a3)+,d3			; Z-Coordinate
 add.w	offz,d3
 move.w	d3,d6

 muls	Matrix11,d1
 muls	Matrix21,d2
 muls	Matrix31,d3

 add.l	d1,d2
 add.l	d2,d3
 lsl.l	#2,d3
 swap	d3
 add.w	xoffs,d3
 move.w	d3,(a4)+			; Rotated X-Coordinate

 move.w	d4,d1
 move.w	d5,d2
 move.w	d6,d3

 muls	Matrix12,d1
 muls	Matrix22,d2
 muls	Matrix32,d3
 add.l	d1,d2
 add.l	d2,d3
 lsl.l	#2,d3
 swap	d3
 add.w	yoffs,d3
 move.w	d3,(a5)+		; Rotated Y-Coordinate

 muls	Matrix13,d4
 muls	Matrix23,d5
 muls	Matrix33,d6
 add.l	d4,d5
 add.l	d5,d6
 lsl.l	#2,d6
 swap	d6
 add.w	zoffs,d6
 move.w	d6,(a6)+		; Rotated Z-Coordinate

 dbra	d0,rotate1
 rts

* Perspective, calculated from the transformed points in the arrays *
* pointx, pointy and pointz the screen coordinates, which		*
* are then stored in the arrays xplot and yplot.			*

Pers:
 MOVE.W	#$400,$96(A0)
 move.l	pointx,a1		; Beginning address of point arrays
 move.l	pointy,a2
 move.l	pointz,a3

 move.l	xplot,a4		; Start address of display coordinate
 move.l	yplot,a5		; array.

 move.w	nummark,d0		; Number of points to be transformed
 ext.l	d0
 subq.l	#1,d0

perlop:
 MOVE.W	#$400,$96(A0)
 move.w	(a3)+,d5		; Z-coordinate of object
 move.w	d5,d6
 move.w	dist,d4			; Enlargement factor
 sub.w	d5,d4			; Dist minus Z-coordinate of obj.coord
 ext.l	d4
 lsl.l	#8,d4			; Times 256 for value fitting
 move.w	zobs,d3			; Projection center Z-coordinates
 ext.l	d3

 sub.l	d6,d3			; Minus z-coordinate of object
 bne.s	Pers1

 moveq	#0,d1			; Catch division by zero
 addq.l	#2,a1
 addq.l	#2,a2
 move.w	d1,(a4)+
 move.w	d1,(a5)+
 bra.s	perend1

Pers1:
 MOVE.W	#$400,$96(A0)
 divs	d3,d4
 move.w	d4,d3
 move.w	(a1)+,d1		; X-Coordinate of object
 move.w	d1,d2
 neg.w	d1
 muls	d1,d3			; Multiplied by Perspective factor
 lsr.l	#8,d3			; /256 save value fitting

 add.w	d3,d2			; Add to x-coordinate
 add.w	x0,d2			; Add screen offset (center point)
 move.w	d2,(a4)+		; Display X-coordinate

 move.w	(a2)+,d1		; Y-Coordinate of object
 move.w	d1,d2
 neg.w	d1
 muls	d1,d4
 lsr.l	#8,d4			; /256

 add.w	d4,d2
 neg.w	d2			; Display offset, mirror of Y-Axis
 add.w	y0,d2			; Source at [X0,Y0]
 move.w	d2,(a5)+		; Display Y-Coordinate
perend1:
 dbra	d0,perlop		; Until all points transformed

 move.w	#$ff0,color
 rts

* Draw number of lines from array from lines in linxy *

DrawN1:
 Move.l	xplot,a4		; Display X-Coordinate
 move.l	yplot,a5		; Display Y-Coordinate
 move.w	numline,d0		; Number of lines
 ext.l	d0
 subq.l	#1,d0			; As counter
 move.l	linxy,a6		; Address of line array

drlop:
 move.l	(a6)+,d1		; First line (P1,P2)
 subq.w	#1,d1			; Fit to list structure
 lsl.w	#1,d1			; Times list element length (2)
 move.w	(a4,d1.w),d2		; X-Coordinate of 2nd point
 move.w	(a5,d1.w),d3		; Y-Coordinate of second point
 swap	d1
 subq.w	#1,d1
 lsl.w	#1,d1
 move.w	(a4,d1.w),a2		; X-Coordinate of first point
 move.w	(a5,d1.w),a3		; Y-Coordinate of first point
 bsr.w	Drawl			; Draw line from P1 to P2
 dbra	d0,drlop		; Until all lines drawn
 rts

Main:

 bsr.w	GetReso

 bsr.w	Makewrld		; Create the world system
 bsr.w	worldset		; Pass the world parameters

 bsr.w	setrotdp		; Init obs.ref.point
 bsr.w	PageUp
 bsr.w	clwork
 bsr.w	PageDown
 bsr.w	clwork			; Init both pages

 bsr.s	Inp_Chan		; Input and change parameters
 move.w	#2047,dist

mainlop1:

 bsr.w	PointRot
 bsr.w	Pers			; Do Perspective
 bsr.s	DrawN1			; Draw It
 bsr.w	PageUp			; Display It

 bsr.s	Inp_Chan		; Input new parameters
 bsr.w	clwork
 bsr.w	PointRot		; Rotate
 bsr.w	Pers			; Perspective
 bsr.w	DrawN1			; Drawit
 bsr.w	PageDown
 bsr.s	Inp_Chan		; Input Parameters
 bsr.w	clwork

; bsr.s	myroutines....

 btst	#6,$bfe001
 beq.s	mainend
 bra.s	mainlop1

mainend:
 bsr.w	PageUp
 bsr.w	MIST1
 rts

Inp_Chan:
 addq.w	#3,HYangle
 addq.w	#3,HZangle
 cmpi.w	#360,HYangle
 blt.s	NosuB
 subi.w	#360,HYangle
NosuB:
 cmpi.w	#360,HZangle
 blt.s	NosuBz
 subi.w	#360,HZangle
NosuBz:
 subi.w	#15,dist
 cmpi.w	#-100,dist
 bgt.s	NoClr
 move.w	#-100,dist
NoClr:
 move.w	#$00f,color
 rts

* Init the rotation reference point to [0,0,0] *

setrotdp:
 moveq	#0,d1
 move.w	d1,rotdpx
 move.w	d1,rotdpy
 move.w	d1,rotdpz
 CLR.w	HYangle		; Start rotation angle
 CLR.w	HXangle
 CLR.w	HZangle
 rts

* Rotation around one point, the rotation reference point *

PointRot:
 MOVE.W	#$400,$96(A0)
 move.w	HXangle,Xangle	; Rotate the world around the angle
 move.w	HYangle,Yangle	; hXangle, hYangle, hZangle about the
 move.w	HZangle,Zangle
 move.w	rotdpx,d0	; Rotation reference point
 move.w	rotdpy,d1
 move.w	rotdpz,d2
 move.w	d0,xoffs
 move.w	d1,yoffs
 move.w	d2,zoffs	; Add for back transformation
 neg.w	d0
 neg.w	d1
 neg.w	d2
 move.w	d0,offx		; Subtract for transformation
 move.w	d1,offy
 move.w	d2,offz
 bsr.w	matinit
 bsr.w	zrotate
 bsr.w	yrotate
 bsr.w	xrotate
 bsr.w	rotate
 move.w	#$f00,color
 rts

* Creation of the world system from the object data *

Makewrld:
 MOVE.W	#$400,$96(A0)
 move.l	#ObjDatx,a1		; Create the world system by
 move.l	#ObjDaty,a2
 move.l	#ObjDatz,a3
 move.l	#worldx,a4
 move.l	#worldy,a5
 move.l	#worldz,a6
 move.w	hnummark,d0
 ext.l	d0
 subq.l	#1,d0
makewl1:
 move.w	(a1)+,(a4)+		; Copying the object data into the
 move.w	(a2)+,(a5)+		; world data
 move.w	(a3)+,(a6)+
 dbra	d0,makewl1
 move.w	hnumline,d0
 ext.l	d0
 subq.l	#1,d0
 move.l	#ObjLin,a1
 move.l	#wlinxy,a2
makewl2:
 move.l	(a1)+,(a2)+
 dbra	d0,makewl2
 rts

* Pass the world parameters to base variables *

worldset:
 MOVE.W	#$400,$96(A0)
 move.l	#worldx,datx		; Pass variables for rotation routine
 move.l	#worldy,daty
 move.l	#worldz,datz
 move.l	#viewx,pointx
 move.l	#viewy,pointy
 move.l	#viewz,pointz
 move.l	#wlinxy,linxy
 move.w	PictureX,x0
 move.w	PictureY,y0
 move.w	proz,zobs
 move.w	r1z1,dist
 move.l	#screenx,xplot
 move.l	#screeny,yplot
 move.w	hnumline,numline
 move.w	hnummark,nummark
 rts

GetReso:
 move.w	#170,PictureX
 move.w	#126,PictureY
 rts
	

MIST1:
 moveq	#0,d0
 move.l	$80.w,d0
 lsl	#$2,d0
 rts

* Variables for the basic program *

* Sine table starts here

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

x0:dc.w	0
y0:dc.w	0
z0:dc.w	0
z1:dc.w	0

linxy:dc.l	0		; Address of line array

nummark:dc.w	0		; Number of points
numline:dc.w	0		; Number of lines

pointx:dc.l	0		; Variables of point arrays for world,
pointy:dc.l	0		; view, and screen coordinates
pointz:dc.l	0

xplot:dc.l	0
yplot:dc.l	0

datx:dc.l	0
daty:dc.l	0
datz:dc.l	0

sinx:dc.w	0		; Temporary storage for sin & cos
siny:dc.w	0		; values
sinz:dc.w	0

Cosx:dc.w	0
Cosy:dc.w	0
Cosz:dc.w	0

var1:dc.w	0		; General variables
var2:dc.w	0
var3:dc.w	0

Xangle:dc.w	0		; Variables for passing angles
Yangle:dc.w	0		; to the rotation subroutine
Zangle:dc.w	0

leftx:dc.w	0
lefty:dc.w	0
rightx:dc.w	0
righty:dc.w	0

dist:dc.w	0
zobs:dc.w	1500

Rotx11:dc.w	16384		; Space here for the result Matrix
Rotx12:dc.w	0		; of Matrix multiplication
Rotx13:dc.w	0
Rotx21:dc.w	0
Rotx22:dc.w	16384
Rotx23:dc.w	0
Rotx31:dc.w	0
Rotx32:dc.w	0
Rotx33:dc.w	16384

Matrix11:dc.w	0		; Space here for the general rotation
Matrix12:dc.w	0		; Matrix
Matrix13:dc.w	0
Matrix21:dc.w	0
Matrix22:dc.w	0
Matrix23:dc.w	0
Matrix31:dc.w	0
Matrix32:dc.w	0
Matrix33:dc.w	0

DrawPlane:dc.l	0

CopList:
 dc.w $00e0
HiBMPtr:			;BPL0PTH - parte alta address del bitplane
 dc.w	$0000,$00e2
LowBMPtr:			;BPL0PTL - parte bassa...
 dc.w	$0000

; dc.w $00e4,$0006,$00e6,$2000	;puntatori agli eventuali altri bitplanes
; dc.w $00e8,$0006,$00ea,$5000
; dc.w $00ec,$0006,$00ee,$8000
; dc.w $00f0,$0005,$00f2,$b870
; dc.w $00f4,$0005,$00f6,$b898

 dc.w	$0120
sp1h:dc.w 0,$0122
sp1l:dc.w 0,$0124
sp2h:dc.w 0,$0126
sp2l:dc.w 0,$0128
sp3h:dc.w 0,$012a
sp3l:dc.w 0,$012c,0,$012e,0,$0130,0,$0132,0,$0134,0
	dc.w $0136,0,$0138,0,$013a,0,$013c,0,$013e,0

 dc.w $0180,$0000
 dc.w $0182,$0fff
 dc.w $0184,$0244
 dc.w $0186,$0455
 dc.w $0188,$08aa
 dc.w $018a,$0ddd
 dc.w $018c,$0000
 dc.w $018e,$0000
 dc.w $0190,$0000
 dc.w $0192,$0000
 dc.w $0194,$0000
 dc.w $0196,$0000
 dc.w $0198,$0000
 dc.w $019a,$0000
 dc.w $019c,$0000
 dc.w $019e,$0000
 dc.w $01a0,$0f40
 dc.w $01a2,$002c
 dc.w $01a4,$0000
 dc.w $01a6,$0000
 dc.w $01a8,$0000
 dc.w $01aa,$0000
 dc.w $01ac,$0000
 dc.w $01ae,$0000
 dc.w $01b0,$0000
 dc.w $01b2,$0000
 dc.w $01b4,$0000
 dc.w $01b6,$0000
 dc.w $01b8,$0000
 dc.w $01ba,$0000
 dc.w $01bc,$0000
 dc.w $01be,$0000

	dc.w	$0100,%0001001000000000	;BPLCON0: 1 BITPLANE LORES
	dc.w	$0102,$0000
	dc.w	$108,$0000,$010a,$0000
	dc.w	$008e,$2c81 
	dc.w	$0090,$2cc1
	dc.w	$0092,$0038
	dc.w	$0094,$00d0
	dc.w	$2901,$fffe

	dc.w	$ffff,$fffe	;FINE COPPERIST


GfxName:
 dc.b	"graphics.library",0
 even

GfxBase:dc.l	0

OldCop:dc.l	0

* variable data *

* Object definition *


ObjDatx:
 dc.w	-70,-66,-66,-57,-70,-66,-61,-66
 dc.w	-26,-50,-50,-46,-46,-40,-33,-43
 dc.w	-46,-46,-10,-10,-14,-14,-29,-29
 dc.w	-25,-25,5,5,70,60,-100,-90,-5,-5
 dc.w	10,15,15,10,14,14,11,11,30,30,26
 dc.w	30,30,26,30,30,20,30,61,51,59,59
 dc.w	40,50,31
 dc.w	5,5,70,60,-100,-90,-5,-5
ObjDaty:
 dc.w	-2,4,10,17,25,14,17,19,-5,25,0,4
 dc.w	7,7,-3,11,15,11,-8,15,25,5,29,10
 dc.w	5,14,-15,30,30,40,40,30,30,-5,-7
 dc.w	-3,20,20,23,26,26,23,-5,2,8,8,12
 dc.w	12,18,25,10,-18,15,15,24,29,10,10,-9
 dc.w	-15,30,30,40,40,30,30,-5	

ObjDatz:
 dc.w	0,0,0,0,0,0,0,0,0,0
 dc.w	0,0,0,0,0,0,0,0,0,0
 dc.w	0,0,0,0,0,0,-9,-9,-9,-9
 dc.w	-9,-9,-9,-9,0,0,0,0,0,0
 dc.w	0,0,0,0,0,0,0,0,0,0
 dc.w	0,0,0,0,0,0,0,0,0
 dc.w	9,9,9,9,9,9,9,9
***** What points should be connected with lines? ****

ObjLin:
 dc.w	1,2, 2,3, 3,4, 4,5, 5,1, 6,7, 7,8, 8,6
 dc.w	9,10,10,11,11,12,12,13,13,14,14,15,15,9,16,17
 dc.w	17,18,18,16,19,20,20,21,21,22,22,23,23,24,24,25,25,26
 dc.w	26,19,27,28,28,29,29,30,30,31,31,32,32,33,33,34,34,27
 dc.w	35,38,35,36,36,37,37,38,42,39,39,40,40,41,41,42,42,39,43,44
 dc.w	44,45,45,46,46,47,47,48,48,49,49,50,50,51,51,43,52,53
 dc.w	53,54,54,55,55,56,56,57,57,58,58,59,52,59
 dc.w	60,61,61,62,62,63,63,64,64,65,65,66,66,67,67,60
 dc.w	27,60,28,61,29,62,30,63,31,64,32,65,33,66,34,67

hnummark:dc.w	67	; Number of corner points of the object
hnumline:dc.w	76	; Number of lines in the object




HXangle:dc.w	0	; Rotation angle of the object around X axis
HYangle:dc.w	0
HZangle:dc.w	0

xwplus:dc.w	0	; Angle increment around x axis
ywplus:dc.w	0
zwplus:dc.w	0

PictureX:dc.w	res
PictureY:dc.w	100	; Origin location on screen

rotdpx:dc.w	0
rotdpy:dc.w	0
rotdpz:dc.w	0	; Rotation datum point

r1z1:dc.w	0
normz:dc.w	1500

plusrot:dc.l	0
first:dc.l	0
second:dc.w	0
delta1:dc.w	0

flag:dc.b	1
 even

diffz:dc.w	0
dx:dc.w		0
dy:dc.w		0
dz:dc.w		0

worldx:
	ds.w	100	; World coordinate array
worldy:
	ds.w	100
worldz:
	ds.w	100

viewx:
	ds.w	100	; View coordinate array
viewy:
	ds.w	100
viewz:
	ds.w	100

screenx:
	ds.w	100	; Display coordinate array
screeny:
	ds.w	100

wlinxy:
	ds.l	300	; Line array

pRox:
	dc.w	0	; Coordinates of the projection center
proy:
	dc.w	0	; on the positive Z-axis
proz:
	dc.w	2000

offx:
	dc.w	0
offy:
	dc.w	0
offz:
	dc.w	0
xoffs:
	dc.w	0
yoffs:
	dc.w	0
zoffs:
	dc.w	0
loopc:
	dc.l	0
RAST:
	DS.B	$8000
BPLBUFFER:
	DS.B	20000
	END
