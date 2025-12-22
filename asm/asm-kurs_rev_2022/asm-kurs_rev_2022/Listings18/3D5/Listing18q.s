
; Listing18q.s = 3dfilledvector.s

*****************************************************************************
* 	FIRST EVER 3D FILLED VECTOR ROUTINE BY TANGO/SEPULTURA					*
* 	      CHEERS TO ASLAM FOR THE PERSPECTIVE ROUTINE						*
*****************************************************************************

	section 3dvectors,code_c


blitwait	macro	
bw\@:	btst	#$0e,$dff002
	bne.s	bw\@
	endm

Cwait	MACRO
	DC.B	\1,\2+9,$FF,$FE	
	ENDM
Cmove	MACRO
	DC.W	\1,\2	
	ENDM

*********************************************************************************************
;Co-processor Macros

end_copper	Macro
	dc.w $ffff,$fffe
	Endm

set_pal	Macro
	dc.w $ffdf,$fffe
	Endm


*********************************************************************************************
	
save_all	Macro
	movem.l	a0-a6/d0-d7,-(sp)
	Endm
	
return_all	Macro
	movem.l	(sp)+,d0-d7/a0-a6
	Endm


******************************************************************************************

KillSys	macro
	MOVE.L	$4,A6
	move.l	$9c(A6),a6
	move.l	38(a6),oldcop
	MOVE.W	$DFF01C,IntEnSave
	MOVE.W	$DFF01E,IntRqSave
	MOVE.W	$DFF002,DMASave
	MOVE.W	$DFF010,ADKSave
	MOVE.W	#%0111111111111111,$DFF096	
	MOVE.W	#%0111111111111111,$DFF09A
	CLR.W	$DFF088
	MOVE.W	#%1000011111000000,$DFF096
	bra	otasasas

oldcop	dc.l	0
InitialSP	DC.L	0
IntEnSave	DC.W	0	
IntRqSave	DC.W	0
DMASave	DC.W	0
ADKSave	DC.W	0
otasasas	
	endm


ResSys	Macro
	MOVE.W	IntEnSave,D7
	BSET	#$F,D7
	MOVE.W	D7,$DFF09A
	MOVE.W	IntRqSave,D7
	BSET	#$F,D7
	MOVE.W	D7,$DFF09C
	MOVE.W	DMASave,D7
	BSET	#$F,D7
	MOVE.W	D7,$DFF096
	MOVE.W	ADKSave,D7
	BSET	#$F,D7
	MOVE.W	D7,$DFF09E
	move.l	oldcop,$dff080
	move.w	#0,$dff088
	endm
	

; 68000 status register bits.

; Custom chip registers.

custom:  equ $dff000
bltddat: equ $000
dmaconr: equ $002
vposr:   equ $004
vhposr:  equ $006
dskdatr: equ $009
intenar: equ $01c
intreqr: equ $01e
vposw:   equ $02a
vhposw:  equ $02c
copcon:  equ $02e
bltcon0: equ $040
bltcon1: equ $042
bltafwm: equ $044
bltalwm: equ $046
bltcpth: equ $048
bltcptl: equ $04a
bltbpth: equ $04c
bltbptl: equ $04e
bltapth: equ $050
bltaptl: equ $052
bltdpth: equ $054
bltdptl: equ $056
bltsize: equ $058
bltcmod: equ $060
bltbmod: equ $062
bltamod: equ $064
bltdmod: equ $066
bltcdat: equ $070
bltbdat: equ $072
bltadat: equ $074
cop1lch: equ $080
cop1lcl: equ $082
cop2lch: equ $084
cop2lcl: equ $086
copjmp1: equ $088
copjmp2: equ $08a
diwstrt: equ $08e
diwstop: equ $090
ddfstrt: equ $092
ddfstop: equ $094
dmacon:  equ $096
intena:  equ $09a
intreq:  equ $09c
bpl1pth: equ $0e0
bpl1ptl: equ $0e2
bpl2pth: equ $0e4
bpl2ptl: equ $0e6
bpl3pth: equ $0e8
bpl3ptl: equ $0ea
bpl4pth: equ $0ec
bpl4ptl: equ $0ee
bpl5pth: equ $0f0
bpl5ptl: equ $0f2
bpl6pth: equ $0f4
bpl6ptl: equ $0f6
bplcon0: equ $100
bplcon1: equ $102
bplcon2: equ $104
bpl1mod: equ $108
bpl2mod: equ $10a
bpl1dat: equ $110
bpl2dat: equ $112
bpl3dat: equ $114
bpl4dat: equ $116
bpl5dat: equ $118
bpl6dat: equ $11a
color00: equ $180
color01: equ $182
color02: equ $184
color03: equ $186
color04: equ $188
color05: equ $18a
color06: equ $18c
color07: equ $18e
color08: equ $190
color09: equ $192
color10: equ $194
color11: equ $196
color12: equ $198
color13: equ $19a
color14: equ $19c
color15: equ $19e
color16: equ $1a0
color17: equ $1a2
color18: equ $1a4
color19: equ $1a6
color20: equ $1a8
color21: equ $1aa
color22: equ $1ac
color23: equ $1ae
color24: equ $1b0
color25: equ $1b2
color26: equ $1b4
color27: equ $1b6
color28: equ $1b8
color29: equ $1ba
color30: equ $1bc
color31: equ $1be
	
*****************************************************************************
* 		 LOCAL EQUATES		*
*****************************************************************************

pointbuf	=	$65000
bitplanesize	=	40*200


*****************************************************************************
* 		KILL SYSTEM, SET UP COPPER LIST		*
*****************************************************************************

	killsys
	move.l	#$70000,a0
	move.l	#3000,d7
loop:
	clr.l	(a0)+
	dbf	d7,loop
	
	move.l	#newcopper,$dff080
	move.w	d0,$dff088
	move.w	#0,$dff1fc
	lea	custom,a5


*****************************************************************************
* 		MAIN ROUTINES CALLED EVERY VBI		*
*****************************************************************************

wait:	
	cmp.b	#$ff,$dff006
	bne.s	wait
	addq.w	#6,xrot
	addq.w	#2,yrot
	addq.w	#2,zrot
	and.w	#$1fe,xrot
	and.w	#$1fe,yrot
	and.w	#$1fe,zrot
	bsr	clear
	bsr	work
	bsr	perspective
	bsr	hiddenline
		bsr	onepassfill
	btst	#6,$bfe001
	bne	wait
	ressys
	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	moveq	#0,d0
	rts


*****************************************************************************
* 		FILL VECTOR SHAPE (ONE PASS)		*
*****************************************************************************

onepassfill:
	blitwait
	move.l	screen,a0
	add.l	#(40*400)-2,a0		; bottom of vector
	move.l	#$09f0000a,bltcon0(a5)	; fill+descending mode
	move.l	#-1,bltafwm(a5)
	move.l	a0,bltapth(a5)
	move.l	a0,bltdpth(a5)
	move.w	#0,bltamod(a5)
	move.w	#0,bltdmod(a5)
	move.w	#400<<6!20,bltsize(a5)
	rts


*****************************************************************************
* 		   VECTOR CALCULATIONS X,Y,Z		*
*****************************************************************************
; Preload d1-d3 with x,y,z respectively
;         d6,d5,d0 when routine done holds x,y,z respectively

;   x1 = x cos(a) - y sin(a)
;   y1 = y cos(a) + x sin(a)

calc:
	move.l	d1,d5
	move.l	d2,d6
	move.w	xrot,d4		; a
	muls	-64(a0,d4),d1	; xcos(a)
	muls	64(a0,d4),d2	; ysin(a)
	sub.l	d2,d1
	swap	d1		; d1 holds x1
	add.w	d1,d1
	move.l	d1,d7		; save x1 in d7
	muls	-64(a0,d4),d6
	muls	64(a0,d4),d5
	add.l	d6,d5
	swap	d5		; d5 holds y1
	add.w	d5,d5

;   y2 = y1 cos(b) -  z sin(b)
;   z1 = z  cos(b) + y1 sin(b)

	move.l	d5,d1		; save y1
	move.l	d3,d0		; save zrot
	move.w	yrot,d2	
	muls	-64(a0,d2),d5	; y1 cos(b)	
	muls	64(a0,d2),d3	; z sin(b)
	sub.l	d3,d5
	swap	d5		; d5 holds y2
	muls	-64(a0,d2),d0	; z cos(b)
	muls	64(a0,d2),d1	; y1 sin(b)
	add.l	d1,d0
	swap	d0		; d0 holds z1
	add.w	d0,d0

;   z2 = z1 cos(c) - x1 sin(c)
;   x2 = x1 cos(c) + z1 sin(c)

	move.w	zrot,d3
	move.l	d7,d6		; save x1
	move.l	d0,d4		; save z1
	muls	-64(a0,d3),d0	; z1 cos(c)
	muls	64(a0,d3),d7	; x1 sin(c)
	sub.l	d7,d0	
	swap	d0		; d0 holds z2
	muls	-64(a0,d3),d6	; x1 cos(c)
	muls	64(a0,d3),d4	; z1 sin(c)
	add.l	d4,d6	
	swap	d6		; d6 holds x2
	rts


*****************************************************************************
* 		  GET POINTS		*
*****************************************************************************

;   d6 = x, d5=y, d0=z 

work:
	lea	sine+64(pc),a0	; point to sinus table
	move.l	#pointbuf,a1	; where to store points
	lea	points(pc),a2
	move.w	(a2)+,d7	; amount
	move.w	d7,d6		; store amont of points 
morecalc:
	movem.w	(a2)+,d1-d3	; x,y,z
	save_all
	bsr	calc		; vector calculation
;	add.w	#160,d6		; set if no perspective wanted
;	add.w	#100,d5		; ie. get rid of semi-colons;;
	move.w	d6,(a1)+	; store x
	move.w	d5,(a1)+	; store y
	move.w	d0,(a1)+	; store z
	return_all
	addq.w	#6,a1		; next coordinates
	dbf	d7,morecalc
	rts


*****************************************************************************
* 		PERSPECTIVE ROUTINE (CHEERS ASLAM!)		*
*****************************************************************************

perspective:
	move.l	#pointbuf,a0
pers:
	move.w	(a0),d0		; get x
	move.w	2(a0),d1	; get y
	move.w	#300,d2		
	sub.w	4(a0),d2	; subtract z from d2
	muls	#300,d0		; x * 300
	muls	#300,d1		; y * 300
	divs	d2,d0		; x/z
	divs	d2,d1		; y/z
	add.w	#160,d0		; offset to centre of screen x-axis
	add.w	#100,d1		; as above but for screen y-axis
	move.w	d0,(a0)+	; store scaled x
	move.w	d1,(a0)+	; store scaled y
	move.w	d2,(a0)+	; store scaled z
	dbf	d6,pers		; until all points are done
	rts


*****************************************************************************
* 	   HIDDEN LINE ROUTINE (X2-X1)(Y3-Y2)-(Y2-Y1)(X3-X2)	*
*****************************************************************************

hiddenline:
	blitwait
	move.w	#40,$60(a5)		; screen in bytes
	move.l	#-$8000,$72(a5)	; set to line 
	move.l	#-1,$44(a5)		; mask


	lea	surfacelist(pc),a6	; point to surface list (ie.faces)
	move.l	#pointbuf,a2	; stored x,y,z's
	move.w	(a6)+,vert		; amount of faces
doagain:
	move.l	(a6)+,a4		; get which face to check
	move.l	a4,surface		; store face addr. in variable
	move.l	(a4)+,d7		; amount of faces and bitplane
	movem.w	(a4)+,d0-d2		; get which connections offset

;   HIDDEN LINE CALCULATION STARTS

	move.w	(a2,d2),d3		; x2
	sub.w	(a2,d0),d3		; x2-x1
	move.w	2(a2,d1),d4		; y3
	sub.w	2(a2,d2),d4		; y3-y2
	muls	d4,d3		; (x2-x1)(y3-y2)
	move.w	2(a2,d2),d4		; y1
	sub.w	2(a2,d0),d4		; y2-y1
	move.w	(a2,d1),d5		; x2
	sub.w	(a2,d2),d5		; x3-x2
	muls	d5,d4		; (y2-y1)(x3-x2)

	sub.l	d3,d4		; (x2-x1)(y3-y2)*(y2-y1)(x3-x2)
	bpl	notplot		; face negative don't draw

; DRAW SURFACE ROUTINE STARTS


	move.l	surface,a4
	move.w	(a4)+,d7		; amount of faces
	move.w	(a4)+,d6		; bitplane vector is on!
ahere:
	move.w	(a4)+,d4		
	move.w	(a2,d4),d0		; x1
	move.w	2(a2,d4),d1		; y1
	move.w	(a4),d4		
	move.w	(a2,d4),d2		; x2
	move.w	2(a2,d4),d3		; y2
	moveq	#0,d4		; used for bitplanes
	btst	#0,d6		; vector on plane 1 ?
	bne.s	nextplane		; no
	save_all		; yes
	bsr	lines		; draw lines of face
	return_all
nextplane:
	add.w	#bitplanesize,d4	; get to next bitplane
	btst	#1,d6			
	bne.s	nextplane2
	save_all
	bsr	lines
	return_all
nextplane2:
	dbf	d7,ahere
notplot:
	subq.w	#1,vert		; amount of faces to draw
	bne	doagain
	rts	


*****************************************************************************
* 		 CLEAR VECTOR		*
*****************************************************************************

clear:
	blitwait
	eor.l	#$6000,screen
	eor.w	#$6000,a1l+2
	eor.w	#$6000,a2l+2
	move.l	screen(pc),bltdpth(a5)
	move.w	#0,bltdmod(a5)
	move.l	#-1,bltafwm(a5)
	move.l	#$01000000,bltcon0(a5)
	move.w	#400<<6!20,bltsize(a5)
	rts


*****************************************************************************
*	  	LINEDRAW ROUTINE FOR USE WITH FILLING	*
*****************************************************************************

lines:
	move.w	#40,d5		; width
	move.l	screen,a0		; address to draw lines
	add.w	d4,a0		; d4 holds which bitplane face is on
	cmp.w	d1,d3
	bgt.s	line1
	exg	d0,d2
	exg	d1,d3
	beq.s	out
line1:	
	move.w	d1,d4
	muls	d5,d4
	move.w	d0,d5
	add.l	a0,d4
	asr.w	#3,d5
	add.w	d5,d4
	moveq	#0,d5
	sub.w	d1,d3
	sub.w	d0,d2
	bpl.s	line2
	moveq	#1,d5
	neg.w	d2
line2:	
	move.w	d3,d1
	add.w	d1,d1
	cmp.w	d2,d1
	dbhi	d3,line3
line3:	
	move.w	d3,d1
	sub.w	d2,d1
	bpl.s	line4
	exg	d2,d3
line4:	
	addx.w	d5,d5
	add.w	d2,d2
	move.w	d2,d1
	sub.w	d3,d2
	addx.w	d5,d5
	and.w	#15,d0
	ror.w	#4,d0
	or.w	#$a4a,d0
	blitwait
	move.w	d2,$52(a5)
	sub.w	d3,d2
	lsl.w	#6,d3
	addq.w	#2,d3
	move.w	d0,$40(a5)
	move.b	oct(pC,d5.w),$43(a5)
	move.l	d4,$48(a5)
	move.l	d4,$54(a5)
	movem.w	d1/d2,$62(a5)
	move.w	d3,$58(a5)
out:	
	rts
oct:	
	dc.l	$3431353,$b4b1757   


*****************************************************************************
* 		 POLICEMAN			*
*****************************************************************************

newcopper:
	cmove	dmacon,$0020
	cmove	diwstrt,$2c81	
	cmove	diwstop,$2cc1	
	cmove	ddfstrt,$0038
	cmove	ddfstop,$00d0
	cmove	bplcon1,0
	cmove	bpl1mod,0
	cmove	bpl2mod,0
	cmove	bplcon0,$2200
a1l
	cmove	bpl1ptl,$0000
a2l
	cmove	bpl2ptl,bitplanesize
	cmove	bpl1pth,$0007
	cmove	bpl2pth,$0007
	cmove	color00,$0000
	cmove	color01,$0f00
	cmove	color02,$0c00
	cmove	color03,$0a00
	cwait	240,0
	cmove	bplcon0,$0200
	end_copper


*****************************************************************************
* 			SINE TABLE		*
*****************************************************************************

sine:
	rept	2
	dc.w	32767,32757,32728,32678,32609,32521,32412,32285
	dc.w	32137,31971,31785,31580,31356,31113,30852,30571
	dc.w	30273,29956,29621,29268,28898,28510,28105,27683
	dc.w	27245,26790,26319,25832,25329,24811,24279,23731
	dc.w	23170,22594,22005,21403,20787,20159,19519,18868
	dc.w	18204,17530,16846,16151,15446,14732,14010,13279
	dc.w	12539,11793,11039,10278,9512,8739,7962,7179
	dc.w	6393,5602,4808,4011,3212,2411,1608,804
	dc.w	0,-803,-1607,-2409,-3211,-4010,-4807,-5601
	dc.w	-6391,-7178,-7961,-8738,-9511,-10277,-11038,-11792
	dc.w	-12538,-13277,-14009,-14731,-15445,-16150,-16845,-17529
	dc.w	-18203,-18866,-19518,-20158,-20786,-21401,-22004,-22593
	dc.w	-23169,-23730,-24278,-24810,-25328,-25831,-26318,-26789
	dc.w	-27244,-27682,-28104,-28509,-28897,-29267,-29620,-29955
	dc.w	-30272,-30570,-30851,-31112,-31355,-31579,-31784,-31970
	dc.w	-32136,-32284,-32411,-32520,-32608,-32677,-32727,-32756
	dc.w	-32766,-32756,-32727,-32677,-32608,-32520,-32411,-32284
	dc.w	-32136,-31970,-31784,-31579,-31355,-31112,-30851,-30570
	dc.w	-30272,-29955,-29620,-29267,-28897,-28509,-28104,-27682
	dc.w	-27244,-26789,-26318,-25831,-25328,-24810,-24278,-23730
	dc.w	-23169,-22593,-22004,-21401,-20786,-20158,-19518,-18866
	dc.w	-18203,-17529,-16845,-16150,-15445,-14731,-14009,-13277
	dc.w	-12538,-11792,-11038,-10277,-9511,-8738,-7961,-7178
	dc.w	-6391,-5601,-4807,-4010,-3211,-2409,-1607,-803
	dc.w	0,804,1608,2411,3212,4011,4808,5602
	dc.w	6393,7179,7962,8739,9512,10279,11039,11793
	dc.w	12540,13279,14010,14733,15446,16151,16846,17530
	dc.w	18204,18868,19519,20159,20787,21403,22005,22594
	dc.w	23170,23732,24279,24812,25329,25832,26319,26790
	dc.w	27245,27683,28105,28510,28898,29269,29621,29956
	dc.w	30273,30571,30852,31113,31356,31580,31785,31971
	dc.w	32137,32285,32412,32520,32609,32678,32727,32757
	endr


*****************************************************************************
* 			VARIABLES		*
*****************************************************************************

screen:	dc.l	$76000
xrot:	dc.l	0
yrot:	dc.l	0
zrot:	dc.l	0
surface: dc.l	0
vert:	dc.w	0	
 even


*****************************************************************************
* 		VECTOR X,Y,Z POINTS		*
*****************************************************************************

points:
; x,y,z
	dc.w	8-1		;amount of points
	dc.w	-100,-100,100	;0
	dc.w	-100,100,100	;1
	dc.w	100,-100,100	;2
	dc.w	100,100,100		;3

	dc.w	-100,-100,-100	;4
	dc.w	-100,100,-100	;5
	dc.w	100,-100,-100	;6
	dc.w	100,100,-100	;7


surfacelist:
	dc.w	6
	dc.l	face1
	dc.l	face2
	dc.l	face3
	dc.l	face4
	dc.l	face5
	dc.l	face6
	
face1:dc.w	4-1,1,0*6,1*6,3*6,2*6,0*6
face2:dc.w	4-1,2,1*6,5*6,7*6,3*6,1*6
face3:dc.w	4-1,4,3*6,7*6,6*6,2*6,3*6
face4:dc.w	4-1,1,6*6,7*6,5*6,4*6,6*6
face5:dc.w	4-1,2,4*6,0*6,2*6,6*6,4*6
face6:dc.w	4-1,4,4*6,5*6,1*6,0*6,4*6
 even
 end


