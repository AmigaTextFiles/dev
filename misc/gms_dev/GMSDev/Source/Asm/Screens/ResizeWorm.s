;-------T-------T------------------------T----------------------------------;
;This version of the Worm demo opens a specific screen size and resizes the
;320x256 background to fit this screen dimensions.  Then it blits the worm
;on top, which appears to be at an altered size because of the change of
;resolution.
;
;You can change the resolution if you like, just edit the settings below.

SCREENWIDTH   = 320	;Factor of 16
SCREENHEIGHT  =	256/2
SCREENMODE    =	SM_HIRES|SM_LACED
SCREENCOLOURS =	32

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	ScreenTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq	.Exit

;---------------------------------------------------------------------------;
;Load a picture into the background of the screen.  We have to set the
;correct palette and copy it to our second buffer as part of this process.

	lea	PIC_BackgroundTags(pc),a0
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq	.Exit

	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	move.l	GS_Bitmap(a0),a3
	move.l	PIC_Background(pc),a1
	move.l	PIC_Bitmap(a1),a2
	move.l	BMP_Palette(a2),BMP_Palette(a3)
	CALL	scrUpdatePalette

	move.l	DPKBase(pc),a6
	move.l	PIC_Background(pc),a0
	move.l	PIC_Bitmap(a0),a0
	move.l	Screen(pc),a1
	move.l	GS_Bitmap(a1),a1
	CALL	Copy

	move.l	BLTBase(pc),a6
	move.l	Screen(pc),a0
	moveq	#BUFFER2,d0
	moveq	#BUFFER1,d1
	CALL	bltCopyBuffer

;---------------------------------------------------------------------------;
;Initialise the restore object.

	move.l	DPKBase(pc),a6
	lea	RestoreTags(pc),a0
	move.l	Screen(pc),a1	;a1 = Screen.
	move.l	GS_Bitmap(a1),RBitmap	;ma = Bitmap for restore list.
	CALL	Init	;>> = Initialise the restore list.
	tst.l	d0	;d0 = Check for errors.
	beq.s	.Exit	;>> = Error, exit.

;---------------------------------------------------------------------------;
;Load the bob file in.  This contains the graphics data that we are going to
;draw to the screen.

	lea	BBT_Rambo(pc),a0
	move.l	Screen(pc),a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	lea	SMT_Rambo(pc),a0
	sub.l	a1,a1
	CALL	Init
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
	move.l	SND_Rambo(pc),a0
	CALL	Free
	move.l	BOB_Rambo(pc),a0
	CALL	Free
	move.l	Restore(pc),a0
	CALL	Free
	move.l	PIC_Background(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

SPEED	=	5
FIRESPEED =	0

Main:	moveq	#$00,d7

.Loop	move.l	DPKBase(pc),a6
	move.l	Restore(pc),a0
	CALL	Activate

	move.l	BOB_Rambo(pc),a0
	CALL	Draw	;Blit the bob.

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	Screen(pc),a0
	CALL	scrSwapBuffers

	addq.w	#1,d7

	move.l	DPKBase(pc),a6
	move.l	BOB_Rambo(pc),a1
	tst.b	FireState
	bne.s	.FireOn

	cmp.w	#SPEED,d7
	ble.s	.Move
	moveq	#$00,d7
	addq.w	#1,BOB_Frame(a1)
	cmp.w	#9,BOB_Frame(a1)
	blt.s	.Move
	clr.w	BOB_Frame(a1)
	bra.s	.Move

.FireOn	cmp.w	#FIRESPEED,d7
	ble.s	.Move
	moveq	#$00,d7
	cmp.w	#10,BOB_Frame(a1)
	bge.s	.On
	move.w	#9,BOB_Frame(a1)

.On	addq.w	#1,BOB_Frame(a1)
	cmp.w	#13,BOB_Frame(a1)
	blt.s	.Move
	clr.w	BOB_Frame(a1)
	clr.b	FireState
	move.l	SND_Rambo(pc),a0
	CALL	Activate

.Move	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	BOB_Rambo(pc),a1
	move.w	JD_XChange(a0),d0
	add.w	d0,BOB_XCoord(a1)
	move.w	JD_YChange(a0),d0
	add.w	d0,BOB_YCoord(a1)
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	.chkRMB
	st	FireState	;Set fire to on.
.chkRMB	btst	#JB_RMB,d0
	beq	.Loop
	rts

FireState:
	dc.b	0
	even

;===========================================================================;
;                                  DATA
;===========================================================================;

JoyData:	dc.l  0

;---------------------------------------------------------------------------;

RestoreTags:	dc.l  TAGS_RESTORE
Restore:	dc.l  0
		dc.l  RSA_Owner
RBitmap:	dc.l  0
		dc.l  RSA_Entries,1
		dc.l  RSA_Buffers,2
		dc.l  TAGEND

;---------------------------------------------------------------------------;

ScreenTags:	dc.l  TAGS_SCREEN
Screen:		dc.l  0
		dc.l  GSA_Width,SCREENWIDTH
		dc.l  GSA_Height,SCREENHEIGHT
		dc.l    GSA_BitmapTags,0
		dc.l    BMA_AmtColours,SCREENCOLOURS
		dc.l    TAGEND,0
		dc.l  GSA_Attrib,SCR_DBLBUFFER|SCR_CENTRE
		dc.l  GSA_ScrMode,SCREENMODE
		dc.l  TAGEND

;---------------------------------------------------------------------------;

PIC_BackgroundTags:
		dc.l  TAGS_PICTURE
PIC_Background:	dc.l  0
		dc.l    PCA_BitmapTags,0
		dc.l    BMA_Data
Data:		dc.l    0
		dc.l    BMA_Width,SCREENWIDTH
		dc.l    BMA_Height,SCREENHEIGHT
		dc.l    BMA_AmtColours,SCREENCOLOURS
		dc.l    TAGEND,0
		dc.l  PCA_ScrMode,SCREENMODE
		dc.l  PCA_Options,IMG_RESIZE
		dc.l  PCA_Source,.file
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/PIC.Green"

;---------------------------------------------------------------------------;

BBT_Rambo:	dc.l  TAGS_BOB
BOB_Rambo:	dc.l  0
		dc.l  BBA_GfxCoords,.frames
		dc.l  BBA_Width,32
		dc.l  BBA_Height,24
		dc.l  BBA_XCoord,50
		dc.l  BBA_YCoord,50
		dc.l  BBA_Attrib,BBF_GENMASKS|BBF_CLIP|BBF_RESTORE
		dc.l    BBA_SourceTags,ID_PICTURE
		dc.l      PCA_BitmapTags,0
		dc.l      BMA_MemType,MEM_BLIT
		dc.l      TAGEND,0
		dc.l    PCA_Source,.file
		dc.l    TAGEND,0
		dc.l  TAGEND

.frames		dc.w    0,00 ;X/Y Graphic
		dc.w   32,00 ;...
		dc.w   64,00
		dc.w   96,00
		dc.w  128,00
		dc.w  160,00
		dc.w  192,00
		dc.w  224,00
		dc.w  256,00
		dc.w  288,00
		dc.w    0,48
		dc.w   32,48
		dc.w   64,48
		dc.l  -1

.file		FILENAME "GMS:demos/data/PIC.Rambo"

;---------------------------------------------------------------------------;

SMT_Rambo:	dc.l  TAGS_SOUND
SND_Rambo:	dc.l  0
		dc.l  SA_Octave,OCT_C2S
		dc.l  SA_Volume,100
		dc.l  SA_Source,.file
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/SND.Rambo"

;===========================================================================;

ProgName:	dc.b  "Resize Worm",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "May 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Resizing demonstration.",0
		even
