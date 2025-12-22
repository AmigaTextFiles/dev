;-------T-------T------------------------T----------------------------------;
;This is a demonstration of raining bobs, which I use as a test routine to
;see how fast some of my blitter routines are.  It's a good example of using
;MBOB's, try out different MAX_IMAGES values to see how many you can get on
;screen.  **120** 16 colour 16x8 bobs just manage to run at full speed on my
;A1200+FAST, change the value if you have a faster machine (600 can be very
;interesting :-).
;
;Technical notes
;---------------
;This demo takes direct advantage of some special GMS blitting features,
;such as restorelist clearing without masks (gain: 10%), and 16 pixel
;alignment (gain: 15%).  That allows us to have 25% more BOB's on screen!
;
;The fact that GMS will use the CPU to draw and clear images when the blitter
;is busy gives a boost of about 20%+ on an '020, so the overall advantage
;over a bog standard blitting function (eg BltBitmap()) is at least 40%.
;Given that such a function would have to be called 120 times with newly
;calculated parameters each time to draw, and 120 times to do the clears, we
;are probably looking at least 65% faster... is that good enough?

	INCDIR	"INCLUDES:"
	INCLUDE	"dpkernel/dpkernel.i"

MAX_IMAGES =	120

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	TAGS_BobsPicture(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	PIC_Bobs(pc),a1
	move.l	a1,RainPic
	move.l	PIC_Bitmap(a1),a2
	move.l	BMP_Palette(a2),GPalette

	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	move.l	d0,Screen
	beq.s	.Exit

	lea	RestoreTags(pc),a0
	move.l	Screen(pc),a1	;a1 = Screen.
	CALL	Init	;>> = Initialise the restore list.
	tst.l	d0	;d0 = Check for errors.
	beq.s	.Exit	;>> = Error, exit.

	lea	TAGS_RainBob(pc),a0
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a1
	CALL	Init	;>> = Initialise the Bob.
	tst.l	d0
	beq.s	.Exit

	moveq	#ID_JOYDATA,d0	;Get joydata structure.
	CALL	Get
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
	move.l	MBOB_Rain(pc),a0
	CALL	Free
	move.l	Restore(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	move.l	PIC_Bobs(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                DEMO CODE
;===========================================================================;

Main:	moveq	#$00,d7
	move.l	MBOB_Rain(pc),a1

	move.l	Screen(pc),a0	;a0 = Screen.
	move.l	MB_EntryList(a1),a2	;a2 = First entry.
	move.w	MB_AmtEntries(a1),d2
	subq.w	#1,d2
.create	bsr	RegenerateBob

	move.l	DPKBase(pc),a6
	move.w	GS_Height(a0),d1
	CALL	FastRandom
	move.w	d0,BE_YCoord(a2)

	lea	NBE_SIZEOF(a2),a2
	dbra	d2,.create

;---------------------------------------------------------------------------;
;                                     MAIN LOOP
;---------------------------------------------------------------------------;

Loop:	move.l	Screen(pc),a0	;a0 = Screen.
	move.l	MBOB_Rain(pc),a1
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

	move.l	MBOB_Rain(pc),a0	;a0 = Bob to draw.
	CALL	Draw	;>> = Draw the mbob.

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

UpdateBob:
	move.w	BE_YCoord(a2),d0	;d0 = YCoord
	add.w	BE_Speed(a2),d0	;d0 = (YCoord)+YSpeed
	cmp.w	GS_Height(a0),d0
	blt.s	.YOkay
	bsr	RegenerateBob
	bra.s	.Animate
.YOkay	move.w	d0,BE_YCoord(a2)

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
;                            REGENERATE BOB ENTITY
;===========================================================================;
;Function: Regenerates an entity with completely new data.
;Requires: a2 = Entry to update.

RegenerateBob:
	move.l	DPKBase(pc),a6
	move.w	GS_Width(a0),d1
	CALL	FastRandom
	subq.w	#4,d0
	and.w	#%1111111111111000,d0
	move.w	d0,BE_XCoord(a2)

	moveq	#8,d1
	CALL	FastRandom
	addq.w	#2,d0
	move.w	d0,BE_Speed(a2)

	moveq	#12,d1
	CALL	FastRandom
	move.w	d0,BE_Frame(a2)
	move.b	.Sets(pc,d0.w),BE_Set+1(a2)

	move.w	#-8,BE_YCoord(a2)
	move.w	#1,BE_FChange(a2)
	eor.w	#1,BE_Locked(a2)
	rts

.Sets	dc.b	0,0,0,0
	dc.b	1,1,1,1
	dc.b	2,2,2,2

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0

RestoreTags:	dc.l  TAGS_RESTORE
Restore:	dc.l  0
		dc.l  RSA_Entries,MAX_IMAGES
		dc.l  TAGEND

;---------------------------------------------------------------------------;

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Palette
GPalette:	dc.l    0
		dc.l    TAGEND,0
		dc.l  TAGEND

;---------------------------------------------------------------------------;

TAGS_BobsPicture:
		dc.l  TAGS_PICTURE
PIC_Bobs:	dc.l  0
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_MemType,MEM_VIDEO
		dc.l    TAGEND,0
		dc.l  PCA_Source,.filename
		dc.l  TAGEND

.filename	FILENAME "GMS:demos/data/PIC.Pulse"

;---------------------------------------------------------------------------;

  ;This is a mutated entrylist that we use for the raining bobs.

  STRUCTURE	NBE,BE_SIZEOF
	WORD	BE_Speed	;Speed of this particular bob.
	WORD	BE_Set	;0 = Red, 1 = Green, 2 = Blue.
	WORD	BE_FChange
	WORD	BE_Locked	;Is it animated or not.
	LABEL	NBE_SIZEOF

TAGS_RainBob:	dc.l  TAGS_MBOB
MBOB_Rain:	dc.l  0
		dc.l  MBA_AmtEntries,MAX_IMAGES
		dc.l  MBA_GfxCoords,RainFrames
		dc.l  MBA_Width,8
		dc.l  MBA_Height,8
		dc.l  MBA_EntryList,Images
		dc.l  MBA_Attrib,BBF_CLIP|BBF_GENMASKS|BBF_CLEAR|BBF_CLRNOMASK
		dc.l  MBA_Source
RainPic:	dc.l  0
		dc.l  MBA_EntrySize,NBE_SIZEOF
		dc.l  TAGEND

RainFrames:	dc.w   0,8*0	;RED
		dc.w   0,8*1
		dc.w   0,8*2
		dc.w   0,8*3
		dc.w   8,8*0	;GREEN
		dc.w   8,8*1
		dc.w   8,8*2
		dc.w   8,8*3
		dc.w  16,8*0	;BLUE
		dc.w  16,8*1
		dc.w  16,8*2
		dc.w  16,8*3
		dc.l  -1

;---------------------------------------------------------------------------;

	SECTION	Images,BSS

Images:	ds.b	NBE_SIZEOF*MAX_IMAGES	;X/Y/Frame/Speed/Set/FChange/Locked

;===========================================================================;

ProgName:	dc.b  "Raining Bobs",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "May 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Multiple bobs demonstration.",0
		even

