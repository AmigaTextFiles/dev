
; Listing18e4.s = DotPlotterok2.s

* -------------	Dot plotting by M J Cross ©1992 -----------------------	*

* -------------	Plotting using the 68000 in a single frame (312 dots) 	*

;	Orrore: CLEAR SCREEN col blitter, bah....

ScreenWidth	equ	40
ScreenHeight	equ	200
PlaneSize	equ	ScreenWidth*ScreenHeight

NumberOfPlanes	equ	1


X_Add		equ	8
Y_Add		equ	6

X_Add2		equ	2
Y_Add2		equ	2

Debug		equ	1	; seleziona il controllo delle linee raster


		Section	Main,Code_C

s:
	MOVEM.L	D0-D7/A0-A6,-(SP)
	lea     GraphicsName(pc),a1
	MOVE.L	4.w,A6
	JSR	-$198(A6)	; oldopenlib
	beq.w	Exit
	lea	s(PC),a6	; A6 - Always variables
	move.l	d0,a1
	move.l	$26(a1),SystemCopper-s(a6)	
	MOVE.L	A6,-(A7)
	MOVE.L	4.w,A6
	JSR	-$019E(A6)
	MOVE.L	(A7)+,A6	;CloseLibrary

	bsr	InitVariables

	MOVE.L	A6,-(A7)
	MOVE.L	4.w,A6
	JSR	-$84(A6)
	MOVE.L	(A7)+,A6

	move.w	2(a5),SystemDma-s(a6)		; savedma
	move.w	$1c(a5),SystemInts-s(a6)
	move.w	#$7fff,d0
	MOVE.W	D0,$96(A5)
	MOVE.W	D0,$9A(A5)
	MOVE.L	#THECOPPERLIST,$80(A5)
	MOVE.W	D0,$88(A5)
	MOVE.W	#0,$1FC(A5)
	MOVE.W	#$87C0,$96(A5)

InterruptLoop:
	move.l	4(a5),d7	; vposr
	andi.l	#$1ff00,d7
	lsr.l	#8,d7
	cmpi.l	#173,d7
	bne.s	InterruptLoop

	IFNE	Debug
	move.w	#$0f0,$180(a5)	* Count those rasters!
	ENDC

	bsr.s	ClearScreen
	bsr.w	Plot

	IFNE	Debug
	move.w	#$000,$180(a5)
	ENDC
	
	bsr.w	Mouse

	tst.w	QuitFlag-s(a6)
	beq.s	InterruptLoop

	move.w	SystemInts-s(a6),d0
	ORI.W	#$C000,D0
	move.w	d0,$9a(a5)		;intena
	move.w 	SystemDma-s(a6),d0
	ORI.W	#$8000,D0
	MOVE.W	D0,$96(A5)
	move.l 	SystemCopper-s(a6),$80(a5)
	move.w	d0,$88(a5)
	move.l	Physical-s(a6),a1
	move.l	#PlaneSize*NumberOfPlanes,d0
	MOVE.L	4.w,A6
	JSR	-$D2(A6)	; freemem
	move.l	4.w,a6
	jsr	-$8a(a6)	; Permit
Exit:
	MOVEM.L	(SP)+,D0-D7/A0-A6
	moveq.l	#0,d0
	rts
		

* -------------	Variable list -------------------------------------	*

Physical:
	dc.l	0
SystemCopper:
	dc.l	0
SystemDma:
	dc.w	0
SystemInts:
	dc.w	0
QuitFlag:
	dc.w	0
Count:
	dc.w	0



ClearScreen:
	movea.l	Physical-s(a6),a0
	move.w	#%000100000000,$40(a5)		; bltcon0 - only DEST, so CLEAR
	move.w	#0,$66(a5)					; bltdmod
	move.l	a0,$54(a5)					; bltdpt
	move.w	#(161<<6)!20,$58(a5)		; bltsize: 161 lines, 20 words width
Wait:
	btst	#6,2(a5)					; waitblit
	bne.s	Wait
	rts
		
* -------------	Plot the dots -----------------------------------------	*

Plot:
	move.l	XSinePtr(pc),a1
	addq.w	#X_Add2,a1
				
	cmpa.l	#XSinePtr+XSineSize,a1
	ble.s	CheckYSine
	move.l	#XSine,XSinePtr
	move.l	XSinePtr,a1

CheckYSine:
	move.l	a1,XSinePtr

	move.l	YSinePtr(pc),a2
	addq.l	#Y_Add2,a2

	cmpa.l	#YSinePtr+YSineSize,a2
	ble	SineFine
	move.l	#YSine,YSinePtr
	move.l	YSinePtr,a2

SineFine:
	move.l	a2,YSinePtr

	move.w	Count-s(a6),d7
	cmpi.w	#308,d7
	bge.s	Enough
	addq.w	#1,Count-s(a6)

Enough:
	movea.l	Physical-s(a6),a0

AllDots:
	move.w	(a1),d0			* X
	move.w	(a2),d1			* Y
	divu	#8,d0			* Find X Shift
	add.w	d0,d1			
	clr.w	d0
	swap	d0
	not.w	d0
	bset	d0,(a0,d1.w)
	adda.w	#X_Add,a1
	adda.w	#Y_Add,a2
	dbra	d7,AllDots
	rts

* -------------	Test mouse and blitter --------------------------------	*

Mouse		btst	#6,$bfe001	;Ciaapra
		seq	QuitFlag-s(a6)
		rts


* -------------	Memory & screen handling routines ---------------------	*

AllocateScreens	move.l	#PlaneSize*NumberOfPlanes,d0
		move.l	#$10002,d1		;MEMF_CHIP!MEMF_CLEAR

		MOVE.L	A6,-(A7)
		MOVE.L	$00000004,A6
		JSR	-$C6(A6)
		MOVE.L	(A7)+,A6

		move.l	d0,Physical-s(a6)
		beq	Exit
		rts


UpdateCopper	move.l	Physical-s(a6),d0
		lea	Planes,a1
		moveq.l	#NumberOfPlanes-1,d2
UCLoop		move.w	d0,4(a1)
		swap	d0
		move.w	d0,(a1)
		swap	d0
		addi.w	#PlaneSize,d0
		addq.l	#8,a1
		dbf	d2,UCLoop
		rts
		
		
* -------------	Stop sprite interferance ------------------------------	*

ClearSprites	lea	Sprites,a0
		moveq.l	#16-1,d0
ClrSpriteLoop	move.w	#0,(a0)
		addq.l	#4,a0
		dbf	d0,ClrSpriteLoop
		rts

		


* -------------	Initialise variables ----------------------------------	*

InitVariables	lea	$dff000,a5
		bsr	ClearSprites		
		bsr	AllocateScreens		
		bsr	UpdateCopper
		clr.w	QuitFlag-s(a6)
		move.w	#0,Count-s(a6)
		move.l	#XSine,XSinePtr
		move.l	#YSine,YSinePtr
		rts


* -------------	Variables ---------------------------------------------	*
		
		even

GraphicsName	dc.b	"graphics.library",0,0

		even
		
* ---------------------------------------------------------------------	*

XSinePtr	dc.l	XSine

XSine
		rept	10
		dc.w	0,0,0,1,1,1,2,2
		dc.w	3,3,4,5,6,7,8,9
		dc.w	10,11,12,14,15,16,18,19
		dc.w	21,23,24,26,28,30,32,34
		dc.w	36,38,40,42,45,47,49,52
		dc.w	54,57,59,62,64,67,70,72
		dc.w	75,78,81,84,86,89,92,95
		dc.w	98,101,104,107,110,113,116,120
		dc.w	123,126,129,132,135,138,141,145
		dc.w	148,151,154,157,160,163,166,170
		dc.w	173,176,179,182,185,188,191,194
		dc.w	197,200,202,205,208,211,214,216
		dc.w	219,222,224,227,229,232,234,237
		dc.w	239,241,244,246,248,250,252,254
		dc.w	256,258,260,262,263,265,267,268
		dc.w	270,271,272,274,275,276,277,278
		dc.w	279,280,281,282,283,283,284,284
		dc.w	285,285,285,286,286,286
		dc.w	286,286,286,286,285,285,285,284
		dc.w	284,283,283,282,281,280,279,278
		dc.w	277,276,275,274,272,271,270,268
		dc.w	267,265,263,262,260,258,256,254
		dc.w	252,250,248,246,244,241,239,237
		dc.w	234,232,229,227,224,222,219,216
		dc.w	214,211,208,205,202,200,197,194
		dc.w	191,188,185,182,179,176,173,170
		dc.w	166,163,160,157,154,151,148,145
		dc.w	141,138,135,132,129,126,123,120
		dc.w	116,113,110,107,104,101,98,95
		dc.w	92,89,86,84,81,78,75,72
		dc.w	70,67,64,62,59,57,54,52
		dc.w	49,47,45,42,40,38,36,34
		dc.w	32,30,28,26,24,23,21,19
		dc.w	18,16,15,14,12,11,10,9
		dc.w	8,7,6,5,4,3,3,2
		dc.w	2,1,1,1,0,0,0,0
		endr
		
XSineSize	equ	(*-XSinePtr)/2

* ---------------------------------------------------------------------	*

YSinePtr	dc.l	YSine

A		Set	ScreenWidth

YSine
		rept	10
		dc.w	160*A,160*A,160*A,160*A,159*A,159*A,159*A,158*A
		dc.w	157*A,157*A,156*A,155*A,154*A,153*A,152*A,151*A
		dc.w	150*A,149*A,148*A,146*A,145*A,143*A,142*A,140*A
		dc.w	138*A,137*A,135*A,133*A,131*A,129*A,127*A,125*A
		dc.w	123*A,121*A,119*A,116*A,114*A,112*A,109*A,107*A
		dc.w	105*A,102*A,100*A,97*A,95*A,93*A,90*A,88*A
		dc.w	85*A,83*A,80*A,77*A,75*A,72*A,70*A,67*A
		dc.w	65*A,63*A,60*A,58*A,55*A,53*A,51*A,48*A
		dc.w	46*A,44*A,41*A,39*A,37*A,35*A,33*A,31*A
		dc.w	29*A,27*A,25*A,23*A,22*A,20*A,18*A,17*A
		dc.w	15*A,14*A,12*A,11*A,10*A,9*A,8*A,7*A
		dc.w	6*A,5*A,4*A,3*A,3*A,2*A,1*A,1*A
		dc.w	1*A,0*A,0*A,0*A
		dc.w	0*A,0*A,0*A,0*A
		dc.w	1*A,1*A,1*A,2*A,3*A,3*A,4*A,5*A
		dc.w	6*A,7*A,8*A,9*A,10*A,11*A,12*A,14*A
		dc.w	15*A,17*A,18*A,20*A,22*A,23*A,25*A,27*A
		dc.w	29*A,31*A,33*A,35*A,37*A,39*A,41*A,44*A
		dc.w	46*A,48*A,51*A,53*A,55*A,58*A,60*A,63*A
		dc.w	65*A,67*A,70*A,72*A,75*A,77*A,80*A,83*A
		dc.w	85*A,88*A,90*A,93*A,95*A,97*A,100*A,102*A
		dc.w	105*A,107*A,109*A,112*A,114*A,116*A,119*A,121*A
		dc.w	123*A,125*A,127*A,129*A,131*A,133*A,135*A,137*A
		dc.w	138*A,140*A,142*A,143*A,145*A,146*A,148*A,149*A
		dc.w	150*A,151*A,152*A,153*A,154*A,155*A,156*A,157*A
		dc.w	157*A,158*A,159*A,159*A,159*A,160*A,160*A,160*A
		
		endr

YSineSize	equ	(*-YSinePtr)/2


* -------------	The copper list ---------------------------------------	*

		Section	Copper,Data_C

TheCopperList:
	dc.l	$8E2C81,$90F4C1,$920038,$9400D0,$1020000,$1040000
	dc.l	$1080000,$10A0000
	dc.w	$100,((NumberOfPlanes<<12)!$200) ;1200
	dc.w	$180
COLOURS:
	dc.w	0,$182,$AC0,$184,$F00,$186,$F0,$188,$E00,$18A
	dc.w	$AAA,$18C,$982,$18E,0,$190,0,$192,0,$194,0,$196,0
	dc.w	$198,0,$19A,0,$19C,0,$19E,0,$120
SPRITES:
	dc.w	0,$122,0,$124,0,$126,0,$128,0,$12A,0,$12C,0,$12E
	dc.w	0,$130,0,$132,0,$134,0,$136,0,$138,0,$13A,0,$13C
	dc.w	0,$13E,0,$E0
PLANES:
	dc.w	0,$E2,0
	dc.w	$FFFF,$FFFE	; end of cop

		End

   
