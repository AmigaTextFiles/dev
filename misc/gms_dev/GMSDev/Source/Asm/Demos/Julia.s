;-------T-------T------------------------T----------------------------------;
;A fractal generator, not orginally written by myself but now works with GMS.

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;==========================================================================;
;                             INITIALISE DEMO
;==========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	Exit

	move.l	Screen(pc),a0
	CALL	Display

	bra.s	Julia

Exit:	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;==========================================================================;
;                                DRAW JULIA
;==========================================================================;

Julia:	lea	DataArea(pc),a5
	move.l	#$fffffffe,(a5)+	;a5 = $fffffffe+
	move.l	#$80000014,(a5)+	;a5 = mask & word per raster count

StartJulia:
	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a0
	CALL	Clear

	move.l	Screen(pc),a0
	move.l	GS_MemPtr1(a0),a0
	lea	JuliaData(pc),a6
	move.l	(a6)+,(a5)	;a5 = ?
.JuliaFound
	move.w	(a5),MValue	;initial m
	move.w	(a6),PixStep	;pixel step
	move.w	(a6)+,RastStep	;raster step
	move.l	(a6)+,C1C2	;initial c1 and c2
	move.w	#256,LinesLeft(a5)	;vertical height
	lea	256*40(a0),a1
	lea	256*40(a1),a2
	lea	256*40(a2),a3
	lea	$04000000,a6	;for magnitude test

	lea	256*40(a3),a4

	MOVEM.L	A6/A0-A1/D0-D1,-(SP)
	move.l	SCRBase(pc),a6
	CALL	scrWaitVBL
	MOVEM.L	(SP)+,A6/A0-A1/D0-D1

PixelLoop:
	move.w	(a5),d1	;d1 = Initial X
	move.w	InitialY(a5),d0	;d0 = Initial Y
	moveq	#30,d7	;d7 = 30.
	movem.w	C1C2(pc),d4-d5	;MA : d4/d5 = C1/C2
	move.w	d0,d2	;d2 = Initial Y
	move.w	d1,d3	;d3 = Initial X
	bra.s	CheckMagnitude

IterateJulia:
	sub.l	d3,d2	;x^2 - y^2
	lsl.l	#4,d2	;fix decimal point
	swap	d2	;...
	add.w	d4,d2	;x1 = x^2 - y^2 + c1

	move.w	d1,d3	;y
	muls	d0,d3	;x * y
	lsl.l	#5,d3	;fix decimal point and multiply by 2
	swap	d3	;...
	add.w	d5,d3	;y1 = 2 * x * y + c2

	move.w	d2,d0	;x = x1
	move.w	d3,d1	;y = y1

CheckMagnitude:
	muls	d2,d2	;x^2
	muls	d3,d3	;y^2
	move.l	d2,d6
	add.l	d3,d6	;z = x^2 + y^2
	cmp.l	a6,d6	;escaped yet?
	dbhi	d7,IterateJulia

	move.w	PixelMask(a5),d6
	moveq	#0,d5
	move.b	JumpTable+1(pc,d7.w),d5
	jmp	JumpTable(pc,d5.w)

JumpTable:
	dc.b	Plot00-JumpTable
	dc.b	Plot31-JumpTable
	dc.b	Plot30-JumpTable
	dc.b	Plot29-JumpTable
	dc.b	Plot28-JumpTable
	dc.b	Plot27-JumpTable
	dc.b	Plot26-JumpTable
	dc.b	Plot25-JumpTable
	dc.b	Plot24-JumpTable
	dc.b	Plot23-JumpTable
	dc.b	Plot22-JumpTable
	dc.b	Plot21-JumpTable
	dc.b	Plot20-JumpTable
	dc.b	Plot19-JumpTable
	dc.b	Plot18-JumpTable
	dc.b	Plot01-JumpTable
	dc.b	Plot16-JumpTable
	dc.b	Plot15-JumpTable
	dc.b	Plot14-JumpTable
	dc.b	Plot13-JumpTable
	dc.b	Plot12-JumpTable
	dc.b	Plot11-JumpTable
	dc.b	Plot10-JumpTable
	dc.b	Plot09-JumpTable
	dc.b	Plot08-JumpTable
	dc.b	Plot07-JumpTable
	dc.b	Plot06-JumpTable
	dc.b	Plot05-JumpTable
	dc.b	Plot04-JumpTable
	dc.b	Plot03-JumpTable
	dc.b	Plot02-JumpTable
	dc.b	Plot17-JumpTable

Plot22:	or.w	d6,(a4)
	or.w	d6,(a2)
	or.w	d6,(a1)
	bra.b	Plot00

Plot21:	or.w	d6,(a4)
	or.w	d6,(a2)
	or.w	d6,(a0)
	bra.b	Plot00

Plot20:	or.w	d6,(a4)
	or.w	d6,(a2)
	bra.b	Plot00

Plot18:	or.w	d6,(a4)
	or.w	d6,(a1)
	bra.b	Plot00

Plot26:	or.w	d6,(a4)
Plot10:	or.w	d6,(a3)
	or.w	d6,(a1)
	bra.b	Plot00

Plot23:	or.w	d6,(a4)
	or.w	d6,(a2)
	or.w	d6,(a1)
	or.w	d6,(a0)
	bra.b	Plot00

Plot19:	or.w	d6,(a4)
	or.w	d6,(a1)
	or.w	d6,(a0)
	bra.b	Plot00

Plot27:	or.w	d6,(a4)
Plot11:	or.w	d6,(a3)
	or.w	d6,(a1)
	or.w	d6,(a0)
	bra.b	Plot00

Plot17:	or.w	d6,(a4)
	or.w	d6,(a0)
	bra.b	Plot00

Plot25:	or.w	d6,(a4)
Plot09:	or.w	d6,(a3)
	or.w	d6,(a0)
	bra.b	Plot00

Plot29:	or.w	d6,(a4)
Plot13:	or.w	d6,(a3)
Plot05:	or.w	d6,(a2)
	or.w	d6,(a0)
	bra.b	Plot00

Plot16:	or.w	d6,(a4)
	bra.b	Plot00

Plot24:	or.w	d6,(a4)
Plot08:	or.w	d6,(a3)
	bra.b	Plot00

Plot28:	or.w	d6,(a4)
Plot12:	or.w	d6,(a3)
Plot04:	or.w	d6,(a2)
	bra.b	Plot00

Plot30:	or.w	d6,(a4)
Plot14:	or.w	d6,(a3)
Plot06:	or.w	d6,(a2)
Plot02:	or.w	d6,(a1)
	bra.b	Plot00

Plot31:	or.w	d6,(a4)
Plot15:	or.w	d6,(a3)
Plot07:	or.w	d6,(a2)
Plot03:	or.w	d6,(a1)
Plot01:	or.w	d6,(a0)

Plot00:	MOVE.L	D0,-(SP)
	move.w	PixStep(pc),d0
	add.w	d0,(a5)	;pixel "step"
	MOVE.L	(SP)+,D0

	ror.w	PixelMask(a5)	;shift mask over
	bpl.w	PixelLoop

	addq.w	#2,a0
	addq.w	#2,a1
	addq.w	#2,a2
	addq.w	#2,a3
	addq.w	#2,a4
	subq.w	#1,WordsInRaster(a5)	; subtract from word counter
	bne.w	PixelLoop

	btst.b	#6,$bfe001
	beq	Exit

	move.w	#320/16,WordsInRaster(a5) ; words per raster
	btst.b	#2,$dff016	;new julia?
	beq.b	NewJulia

RasterInit:
	move.w	MValue(pc),(a5)	;inital M value
RasterAdd:
	MOVE.L	D0,-(SP)
	move.w	RastStep(pc),d0
	add.w	d0,InitialY(a5)	; raster "step"
	MOVE.L	(SP)+,D0
	subq.w	#1,LinesLeft(a5)
	bne.w	PixelLoop

WaitMouse:
	btst.b	#6,$bfe001
	beq	Exit
	btst.b	#2,$dff016
	bne.b	WaitMouse

NewJulia:
	btst.b	#2,$dff016
	beq.b	NewJulia
	bra.w	StartJulia

;===========================================================================;
;                                  DATA
;===========================================================================;

MValue:		dc.w  0
PixStep:	dc.w  0
RastStep:	dc.w  0
C1C2:		dc.l  0

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,320
		dc.l  GSA_Height,256
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Type,PLANAR
		dc.l    BMA_Palette,.palette
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,32
		dc.l  $000000,$803010,$0000e0,$0000d0,$0000c0,$0000b0,$0000a0,$000090
		dc.l  $000080,$000070,$100060,$200050,$300040,$400030,$500020,$601010
		dc.l  $702000,$0000f0,$904020,$a05030,$b06040,$c07050,$d08060,$c09070
		dc.l  $b0a080,$a090a0,$9080b0,$807090,$706070,$505050,$304030,$103010

JuliaData:
	dc.l	$f800eb00
	dc.w	$0018,$0100,$0ad0,$ec00

	dc.l	$fd21eeae
	dc.w	$0225,$000d,$f420,$fd43

	dc.l	$ef000010
	dc.w	$0600,$0100,$f226,$fd56

	dc.l	$0015ee00
	dc.w	$fb40,$ede2,$f0b2,$001d

	dc.l	$05c0ff00
	dc.w	$ef12,$e812,$001d,$f320
	dc.l	0


		rsset -4
PixelMask	rs.w  1	;mask to "OR" with bitplanes
WordsInRaster	rs.w  1	;number of words left in current raster
InitialX	rs.w  1	;inital x
InitialY	rs.w  1	;inital y
LinesLeft	rs.w  1	;number of lines left to draw

		dc.l  0
DataArea:	ds.b  40

;===========================================================================;

ProgName:	dc.b  "Julia",0
ProgAuthor:	dc.b  "Original Author Unknown",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "Freely distributable.",0
ProgShort:	dc.b  "Julia generator.",0
		even

