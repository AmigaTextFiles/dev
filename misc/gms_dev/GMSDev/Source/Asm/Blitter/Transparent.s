;-------T-------T------------------------T----------------------------------;
;This an example of 3 circles blitted onto a planar screen at different
;levels of depth.  Move the green circle over the bouncing circles to get
;an idea of the effects you can achieve with a planar screen.
;
;The screen is double buffered and interlaced, just to be a bit different
;from the other demos.  The circles are removed from the screen using the
;CLEAR mode and a restore list.

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6

	;Load the Circle.

	lea	TAGS_Circle(pc),a0
	sub.l	a1,a1
	CALL	Init
	move.l	d0,PIC_Circle
	beq	.Exit

	move.l	PIC_Circle(pc),a0
	move.l	PIC_Bitmap(a0),a0
	move.l	a0,BmpC1
	move.l	a0,BmpC2
	move.l	a0,BmpC3

	;Initialise the Screen.

	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	;Initialise the Bobs.

	lea	BOB_List(pc),a0
	move.l	Screen(pc),a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	BOB_Circle1(pc),BLC1
	move.l	BOB_Circle2(pc),BLC2
	move.l	BOB_Circle3(pc),BLC3

	lea	RestoreTags(pc),a0
	move.l	Screen(pc),a1	;a1 = Screen.
	CALL	Init	;>> = Initialise the restore list.
	tst.l	d0	;d0 = Check for errors.
	beq.s	.Exit	;>> = Error, exit.

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
	CALL	Show

	bsr.s	Main

.Exit	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Free
	move.l	Restore(pc),a0
	CALL	Free
	lea	BOB_List(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	move.l	PIC_Circle(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:	moveq	#$00,d7

.loop	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query	;Go get port status.
	move.l	JoyData(pc),a0

	move.l	BOB_Circle1(pc),a1
	move.w	JD_XChange(a0),d0
	add.w	d0,BOB_XCoord(a1)
	move.w	JD_YChange(a0),d0
	add.w	d0,BOB_YCoord(a1)
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	bne.s	.done

	move.l	Screen(pc),a0
	move.l	BOB_Circle2(pc),a1
	movem.w	Circle2XV(pc),d0/d1
	bsr.s	MoveBob
	movem.w	d0/d1,Circle2XV

	move.l	BOB_Circle3(pc),a1
	movem.w	Circle3XV(pc),d0/d1
	bsr.s	MoveBob
	movem.w	d0/d1,Circle3XV

.draw	move.l	Restore(pc),a0
	CALL	Activate	;Clear all buffered bob's.

	move.l	BLTBase(pc),a6
	lea	BOB_List(pc),a1
	CALL	bltDrawBobList	;Go and draw all circles.

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	Screen(pc),a0
	CALL	scrSwapBuffers
	bra.s	.loop

.done	rts

;===========================================================================;
;                              MOVE A BOB
;===========================================================================;
;Function: Moves a bob, bouncing it across the screen.
;Requires: a1 = Bob to move.
;	   d0 = X Velocity
;	   d1 = Y Velocity
;Returns:  d0 = New X Velocity.
;	   d1 = New Y Velocity.

MoveBob:
	move.l	BOB_DestBitmap(a1),a2
	add.w	d0,BOB_XCoord(a1)
	add.w	d1,BOB_YCoord(a1)

.ChkLX	tst.w	BOB_XCoord(a1)
	bgt.s	.ChkTY
	neg.w	BOB_XCoord(a1)
	neg.w	d0

.ChkTY	tst.w	BOB_YCoord(a1)
	bgt.s	.ChkRX
	neg.w	BOB_YCoord(a1)
	neg.w	d1

.ChkRX	move.w	BMP_Width(a2),d2
	sub.w	BOB_Width(a1),d2
	cmp.w	BOB_XCoord(a1),d2
	bgt.s	.ChkBY
	move.w	d2,BOB_XCoord(a1)
	neg.w	d0

.ChkBY	move.w	BMP_Height(a2),d2
	sub.w	BOB_Height(a1),d2
	cmp.w	BOB_YCoord(a1),d2
	bgt.s	.done
	move.w	d2,BOB_YCoord(a1)
	neg.w	d1
.done	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

Circle2XV:	dc.w  +3
Circle2YV:	dc.w  +2
Circle3XV:	dc.w  -2
Circle3YV:	dc.w  -4

JoyData:	dc.l  0

;---------------------------------------------------------------------------;

RestoreTags:	dc.l  TAGS_RESTORE
Restore:	dc.l  0
		dc.l  RSA_Entries,3
		dc.l  TAGEND

;---------------------------------------------------------------------------;

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,640
		dc.l  GSA_Height,512
		dc.l  GSA_Attrib,SCR_DBLBUFFER
		dc.l  GSA_ScrMode,SM_LACED|SM_HIRES
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_Planes,3
		dc.l    BMA_Palette,.palette
		dc.l    BMA_Type,PLANAR
		dc.l    TAGEND,0
		dc.l  TAGEND

.palette	dc.l  PALETTE_ARRAY,8
		dc.l  $000000,$f00000,$00f000,$f0f000
		dc.l  $0000f0,$f000f0,$00f0f0,$f0f0f0

;---------------------------------------------------------------------------;

BOB_List:	dc.l  LIST1
BLC1:		dc.l  TAGS_Circle1
BLC2:		dc.l  TAGS_Circle2
BLC3:		dc.l  TAGS_Circle3
		dc.l  LISTEND

TAGS_Circle1:	dc.l  TAGS_BOB
BOB_Circle1:	dc.l  0
		dc.l  BBA_GfxCoords,CircleCoords
		dc.l  BBA_MaskCoords,CircleCoords
		dc.l  BBA_Width,96
		dc.l  BBA_Height,83
		dc.l  BBA_XCoord,100
		dc.l  BBA_YCoord,40
		dc.l  BBA_FPlane,1
		dc.l  BBA_Attrib,BBF_CLIP|BBF_MASK|BBF_CLEAR|BBF_CLRNOMASK
		dc.l  BBA_SrcBitmap
BmpC1:		dc.l  0
		dc.l  TAGEND

TAGS_Circle2:	dc.l  TAGS_BOB
BOB_Circle2:	dc.l  0
		dc.l  BBA_GfxCoords,CircleCoords
		dc.l  BBA_MaskCoords,CircleCoords
		dc.l  BBA_Width,96
		dc.l  BBA_Height,83
		dc.l  BBA_XCoord,278
		dc.l  BBA_YCoord,86
		dc.l  BBA_FPlane,0
		dc.l  BBA_Attrib,BBF_CLEAR|BBF_CLRNOMASK|BBF_CLIP
		dc.l  BBA_SrcBitmap
BmpC2:		dc.l  0
		dc.l  TAGEND

TAGS_Circle3:	dc.l  TAGS_BOB
BOB_Circle3:	dc.l  0
		dc.l  BBA_GfxCoords,CircleCoords
		dc.l  BBA_MaskCoords,CircleCoords
		dc.l  BBA_Width,96
		dc.l  BBA_Height,83
		dc.l  BBA_XCoord,450
		dc.l  BBA_YCoord,150
		dc.l  BBA_FPlane,2
		dc.l  BBA_Attrib,BBF_CLEAR|BBF_CLRNOMASK|BBF_CLIP
		dc.l  BBA_SrcBitmap
BmpC3:		dc.l  0
		dc.l  TAGEND

CircleCoords:	dc.w  0,0
		dc.l  -1

;===========================================================================;

TAGS_Circle:	dc.l  TAGS_PICTURE
PIC_Circle:	dc.l  0
		dc.l  PCA_Source,CircleFile
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_Type,PLANAR
		dc.l    BMA_Planes,1
		dc.l    BMA_MemType,MEM_BLIT
		dc.l    TAGEND,0
		dc.l  TAGEND


CircleFile:	FILENAME "GMS:Demos/Data/PIC.Circle"

;===========================================================================;

ProgName:	dc.b  "Transparency Demo",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "March 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Planar transparency demonstration.",0
		even

