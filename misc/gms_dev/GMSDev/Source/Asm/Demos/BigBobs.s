;-------T-------T------------------------T----------------------------------;

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"

MAX_IMAGES =	20

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6	;Load bob picture.
	lea	PIC_BobTags(pc),a0
	CALL	Init
	tst.l	d0
	beq	.Exit

	move.l	PIC_Bobs(pc),a1
	move.l	a1,BallPic
	move.l	a1,LacedPic

	move.l	PIC_Bitmap(a1),a2
	move.l	BMP_Palette(a2),GSPalette

	moveq	#ID_RASTER,d0	;Get raster object.
	CALL	Get
	move.l	d0,Raster
	beq.s	.Exit

	move.l	Raster(pc),a0	;a0 = Raster
	lea	RastCList(pc),a1	;a1 = Colourlist
	move.l	a1,RAS_Command(a0)	;a0 = Raster->Command = Colourlist;
	move.l	a0,RSH_Prev(a1)	;a1 = Colourlist->Prev = Raster;

	lea	ScreenTags(pc),a0	;Initialise screen.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

;--------------------------------------------------------------------------;
;Initialise restore and bob objects.

	lea	RestoreTags(pc),a0	;a0 = Restore tags.
	move.l	Screen(pc),a1	;a1 = Screen.
	CALL	Init	;>> = Initialise the restore.
	tst.l	d0	;d0 = Check for errors.
	beq.s	.Exit	;>> = Error, exit.

	lea	TAGS_Ball(pc),a0	;Initialise the Ball mbob.
	move.l	Screen(pc),a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	lea	TAGS_Interlaced(pc),a0	;Initialise "HiRes Interlaced" bob.
	move.l	Screen(pc),a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

;--------------------------------------------------------------------------;
;Initialise joydata object.

	moveq	#ID_JOYDATA,d0	;Get joydata structure for reading
	CALL	Get	;port 0.
	move.l	d0,JoyData
	beq.s	.Exit
	move.l	d0,a0	;Initialise the joydata structure.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	Screen(pc),a0
	CALL	Display

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	BOB_Interlaced(pc),a0
	CALL	Free
	move.l	MBOB_Ball(pc),a0
	CALL	Free
	move.l	Raster(pc),a0
	CALL	Free
	move.l	Restore(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	move.l	PIC_Bobs(pc),a0
	CALL	Free
	move.l	Raster(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                DEMO CODE
;===========================================================================;

Main:	move.l	Screen(pc),a2	;a2 = Screen.
	move.l	GS_Bitmap(a2),a3	;a3 = Bitmap.

	move.l	BOB_Interlaced(pc),a1	;a1 = Bob to draw.
	move.w	GS_Width(a2),d0
	sub.w	BOB_Width(a1),d0
	move.w	d0,BOB_XCoord(a1)

	move.l	DPKBase(pc),a6	;a6 = DPKBase.
	move.l	GS_MemPtr2(a2),BMP_Data(a3)
	move.l	BOB_Interlaced(pc),a0	;a0 = Bob to draw.
	CALL	Draw	;>> = Draw the Bob

	move.l	GS_MemPtr1(a2),BMP_Data(a3)
	move.l	BOB_Interlaced(pc),a0	;a0 = Bob to draw.
	CALL	Draw	;>> = Draw the Bob

	moveq	#$00,d7
	move.l	MBOB_Ball(pc),a1
	move.l	MB_EntryList(a1),a2	;a2 = First entry.
	move.w	MB_AmtEntries(a1),d2	;a2 = Amount of entries.
	subq.w	#1,d2	;d2 = --1 for loop.
	moveq	#$00,d3

.create	eor.w	#1,d3
	moveq	#8,d1	;Set Y speed here.
	CALL	FastRandom
	addq.w	#2,d0
	move.w	d0,BE_YSpeed(a2)
	move.w	#8,d1	;Set X speed here.
	CALL	FastRandom
	addq.w	#1,d0
	move.w	d0,BE_XSpeed(a2)
	tst.w	d3
	beq.s	.posx
	neg.w	BE_XSpeed(a2)

.posx	move.l	Screen(pc),a0
	move.w	GS_Height(a0),d1	;Starting Y coordinate.
	asr.w	#1,d1
	CALL	FastRandom
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,BE_YCoord(a2)

	move.w	GS_Width(a0),d1	;Starting X coordinate.
	CALL	FastRandom
	move.w	d0,BE_XCoord(a2)

	moveq	#12,d1
	CALL	FastRandom
	move.w	d0,BE_Frame(a2)
	move.b	.Sets(pc,d0.w),BE_Set+1(a2)
	move.w	#1,BE_FChange(a2)
	move.w	d3,BE_Locked(a2)

	lea	NBE_SIZEOF(a2),a2
	dbra	d2,.create
	bra.s	Loop

.Sets	dc.b	0,0,0,0
	dc.b	1,1,1,1
	dc.b	2,2,2,2

;---------------------------------------------------------------------------;

Loop:	move.l	Screen(pc),a0	;a0 = Screen.
	move.l	MBOB_Ball(pc),a1
	addq.w	#1,d7
	move.l	MB_EntryList(a1),a2	;a2 = First entry.
	move.w	MB_AmtEntries(a1),d2
	subq.w	#1,d2
.update	bsr.s	UpdateBob
	lea	NBE_SIZEOF(a2),a2
	dbra	d2,.update

	move.l	DPKBase(pc),a6
	move.l	Restore(pc),a0
	CALL	Activate

	move.l	MBOB_Ball(pc),a0	;a0 = Bob to draw.
	CALL	Draw	;>> = Draw the Bob.

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	Screen(pc),a0
	CALL	scrSwapBuffers

	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	Loop
	rts

;===========================================================================;
;                               UPDATE A BOB
;===========================================================================;
;Function: Moves the entity according to its internal settings.
;Requires: a1 = Bob structure.
;	   a2 = Entry to update.

GRAVITY =	1

UpdateBob:
	move.l	MB_DestBitmap(a1),a0	;a0 = Bitmap
	move.w	BE_YCoord(a2),d0	;d0 = YCoord
	add.w	BE_YSpeed(a2),d0	;d0 = (YCoord)+YSpeed
	cmp.w	BMP_Height(a0),d0	;d0 = Should this bob bounce?
	blt.s	.NoBounce	;>> = No.
	neg.w	BE_YSpeed(a2)	;a2 = Bounce the bob!
	addq.w	#GRAVITY,BE_YSpeed(a2)	;a2 = Gravity pushes the bob down.
	bra.s	.CheckX
.NoBounce
	move.w	d0,BE_YCoord(a2)	;d0 = Save the change.
	addq.w	#GRAVITY,BE_YSpeed(a2)	;a2 = Gravity pushes the bob down.

.CheckX	move.w	BE_XCoord(a2),d0
	add.w	BE_XSpeed(a2),d0
	cmp.w	BMP_Width(a0),d0
	bcs.s	.NoXBounce
	neg.w	BE_XSpeed(a2)
	bra.s	.Animate
.NoXBounce
	move.w	d0,BE_XCoord(a2)

;---------------------------------------------------------------------------;

.Animate
	tst.w	BE_Locked(a2)
	beq.s	.exit
	move.w	d7,d6
	and.w	#%00000011,d6
	bne.s	.exit
	move.w	BE_FChange(a2),d1
	bgt.s	.Positive

.Negative
	cmp.w	#1,BE_Set(a2)
	bgt.s	.NBlue
	beq.s	.NGreen
.NRed	add.w	d1,BE_Frame(a2)
	tst	BE_Frame(a2)
	bge.s	.exit
	move.w	#1,BE_FChange(a2)
	clr.w	BE_Frame(a2)
	rts

.NGreen	add.w	d1,BE_Frame(a2)
	cmp.w	#4,BE_Frame(a2)
	bge.s	.done
	move.w	#1,BE_FChange(a2)
	move.w	#4,BE_Frame(a2)
	rts

.NBlue	add.w	d1,BE_Frame(a2)
	cmp.w	#8,BE_Frame(a2)
	bge.s	.done
	move.w	#1,BE_FChange(a2)
	move.w	#8,BE_Frame(a2)
.exit	rts

.Positive
	cmp.w	#1,BE_Set(a2)
	bgt.s	.PBlue
	beq.s	.PGreen
.PRed	add.w	d1,BE_Frame(a2)
	cmp.w	#3,BE_Frame(a2)
	ble.s	.done
	move.w	#-1,BE_FChange(a2)
	move.w	#2,BE_Frame(a2)
	rts

.PGreen	add.w	d1,BE_Frame(a2)
	cmp.w	#7,BE_Frame(a2)
	ble.s	.done
	move.w	#-1,BE_FChange(a2)
	move.w	#6,BE_Frame(a2)
	rts

.PBlue	add.w	d1,BE_Frame(a2)
	cmp.w	#11,BE_Frame(a2)
	ble.s	.done
	move.w	#-1,BE_FChange(a2)
	move.w	#10,BE_Frame(a2)
.done	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

  STRUCTURE	NBE,BE_SIZEOF	;Definition for the mutated Entry-
	WORD	BE_XSpeed	;list in the Ball bob.
	WORD	BE_YSpeed
	WORD	BE_Set	;0 = Red, 1 = Green, 2 = Blue.
	WORD	BE_FChange
	WORD	BE_Locked
	LABEL	NBE_SIZEOF

JoyData:	dc.l  0

;---------------------------------------------------------------------------;

RestoreTags:	dc.l  TAGS_RESTORE
Restore:	dc.l  0
		dc.l  RSA_Entries,MAX_IMAGES
		dc.l  TAGEND

;---------------------------------------------------------------------------;

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Raster
Raster:		dc.l  0
		dc.l  GSA_Width,640
		dc.l  GSA_Height,512
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l  GSA_ScrMode,SM_HIRES|SM_LACED
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette
GSPalette:	dc.l    0
		dc.l    TAGEND,0
		dc.l  TAGEND

RastCList:	dc.w  ID_RASTCOLOURLIST,1
		dc.l  0,0,0
		dc.w  300,30	;YCoord, Skip
		dc.l  0	;Colour
		dc.l  .colours	;Values

.colours	dc.l  $100000,$200000,$300000,$400000,$500000,$600000,$700000
		dc.l  -1

;---------------------------------------------------------------------------;

PIC_BobTags:	dc.l  TAGS_PICTURE
PIC_Bobs:	dc.l  0
		dc.l  PCA_Options,IMG_RESIZE
		dc.l  PCA_Source,.file
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_Width,96*2
		dc.l    BMA_Height,71*2
		dc.l    BMA_MemType,MEM_VIDEO
		dc.l    TAGEND,0
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/PIC.HRPulse"

;---------------------------------------------------------------------------;

TAGS_Ball:	dc.l  TAGS_MBOB
MBOB_Ball:	dc.l  0
		dc.l  MBA_AmtEntries,MAX_IMAGES
		dc.l  MBA_GfxCoords,BallFrames
		dc.l  MBA_Width,32
		dc.l  MBA_Height,32
		dc.l  MBA_EntryList,Images
		dc.l  MBA_Attrib,BBF_GENMASKS|BBF_CLRNOMASK|BBF_CLEAR|BBF_CLIP
		dc.l  MBA_Source
BallPic:	dc.l  0
		dc.l  MBA_EntrySize,NBE_SIZEOF
		dc.l  TAGEND

BallFrames:	dc.w  00,32*0	;RED
		dc.w  00,32*1
		dc.w  00,32*2
		dc.w  00,32*3
		dc.w  32,32*0	;GREEN
		dc.w  32,32*1
		dc.w  32,32*2
		dc.w  32,32*3
		dc.w  64,32*0	;BLUE
		dc.w  64,32*1
		dc.w  64,32*2
		dc.w  64,32*3
		dc.l  -1

;---------------------------------------------------------------------------;

TAGS_Interlaced	dc.l  TAGS_BOB
BOB_Interlaced:	dc.l  0
		dc.l  BBA_GfxCoords,LacedFrames
		dc.l  BBA_Width,96*2
		dc.l  BBA_Height,7*2
		dc.l  BBA_Attrib,BBF_GENMASKS|BBF_CLIP
		dc.l  BBA_Source
LacedPic:	dc.l  0
		dc.l  TAGEND

LacedFrames:	dc.w  0,16*4*2	;X/Y Graphic
		dc.l  -1

;---------------------------------------------------------------------------;

	SECTION	Images,BSS

Images	ds.b	NBE_SIZEOF*MAX_IMAGES	;X/Y/Frame/Speed/Set/FChange/Locked

;===========================================================================;

ProgName:	dc.b  "Big Bouncing Bobs",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "January 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Multiple bobs demo.",0
		even

