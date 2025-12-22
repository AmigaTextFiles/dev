;-------T-------T------------------------T----------------------------------;
;This is the same as the RamboWorm demo but it doesn't free any of its
;resources!  This would normally crash our machine but the system can
;recover from such an instance and give back everything that was allocated.
;
;If you need proof that the resource tracking works, take a memory count
;before you run the program and then compare the values to the memory
;after running the demo.


	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	BackgroundFile(pc),a0
	moveq	#ID_PICTURE,d0
	CALL	Load
	move.l	d0,PIC_Background
	beq	.Exit

	moveq	#ID_SCREEN,d0
	CALL	Get
	move.l	d0,Screen
	beq	.Exit

	;Copy picture details to screen.

	move.l	PIC_Background(pc),a0
	move.l	PIC_Bitmap(a0),a2
	move.l	Screen(pc),a1
	move.l	#SCR_DBLBUFFER,GS_Attrib(a1)
	CALL	CopyStructure

;---------------------------------------------------------------------------;
;Initialise the screen.

	move.l	Screen(pc),a0	;Initialise the screen.
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

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
	CALL	Init	;>> = Initialise the restore list.
	tst.l	d0	;d0 = Check for errors.
	beq.s	.Exit	;>> = Error, exit.

;---------------------------------------------------------------------------;
;Load the bob file in.  This contains the graphics data that we are
;going to draw to the screen.

	lea	BBT_Rambo(pc),a0	;a0 = Object.
	move.l	Screen(pc),a1	;a1 = Container.
	CALL	Init	;>> = Initialise bob to screen.
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

.Exit
;	move.l	DPKBase(pc),a6
;	move.l	JoyData(pc),a0	;Everything that should be freed
;	CALL	Free	;has been commented out.  We won't
;	move.l	SND_Rambo(pc),a0	;crash though, thanks to resource
;	CALL	Free	;tracking.
;	move.l	BOB_Rambo(pc),a0
;	CALL	Free
;	move.l	Restore(pc),a0
;	CALL	Free
;	move.l	PIC_Background(pc),a0
;	CALL	Free
;	move.l	Screen(pc),a0
;	CALL	Free
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
	move.l	Restore(pc),a0	;a0 = Restore list.
	CALL	Activate	;>> = Restore the backgrounds.

	move.l	BOB_Rambo(pc),a0
	CALL	Draw	;>> = Blit the bob.

	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL	;>> = Wait for VBL.

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
Screen:		dc.l  0
PIC_Background:	dc.l  0
BackgroundFile:	FILENAME "GMS:demos/data/PIC.Green"

;---------------------------------------------------------------------------;

RestoreTags:	dc.l  TAGS_RESTORE
Restore:	dc.l  0
		dc.l  RSA_Entries,1
		dc.l  TAGEND

;---------------------------------------------------------------------------;

BBT_Rambo:	dc.l  TAGS_BOB
BOB_Rambo:	dc.l  0
		dc.l  BBA_GfxCoords,.frames
		dc.l  BBA_Width,32
		dc.l  BBA_Height,24
		dc.l  BBA_XCoord,150
		dc.l  BBA_YCoord,150
		dc.l  BBA_ClipLX,32
		dc.l  BBA_ClipRX,320-32
		dc.l  BBA_ClipTY,32
		dc.l  BBA_ClipBY,256-32
		dc.l  BBA_Attrib,BBF_RESTORE|BBF_CLIP|BBF_GENMASKS
		dc.l    BBA_SourceTags,ID_PICTURE
		dc.l    PCA_Source,.file
		dc.l      PCA_BitmapTags,0
		dc.l      BMA_MemType,MEM_BLIT
		dc.l      TAGEND,0
		dc.l    TAGEND,0
		dc.l  TAGEND

.frames		dc.w    0,00   ;0 GraphicX / GraphicY
		dc.w   32,00   ;1 ...
		dc.w   64,00   ;2
		dc.w   96,00   ;3
		dc.w  128,00   ;4
		dc.w  160,00   ;5
		dc.w  192,00   ;6
		dc.w  224,00   ;7
		dc.w  256,00   ;8
		dc.w  288,00   ;9
		dc.w    0,48   ;10
		dc.w   32,48   ;11
		dc.w   64,48   ;12
		dc.l  -1

.file		FILENAME "GMS:demos/data/PIC.Rambo"

;---------------------------------------------------------------------------;

SMT_Rambo:	dc.l  TAGS_SOUND
SND_Rambo:	dc.l  0
		dc.l  SA_Octave,OCT_C2S
		dc.l  SA_Volume,100
		dc.l  SA_Source,.file
		dc.l  SA_Attrib,SDF_STOPLAST
		dc.l  TAGEND

.file		FILENAME "GMS:demos/data/SND.Rambo"

;===========================================================================;

ProgName:	dc.b  "Resource Tracking Demo",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "February 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Bob demo.",0
		even

