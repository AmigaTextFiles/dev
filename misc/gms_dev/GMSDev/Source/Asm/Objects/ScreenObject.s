;-------T-------T------------------------T---------------------------------;
;This demo will open a screen, based on the parameters in an external object
;file.  This allows a VERY high level of external editing that will alter
;how this program behaves, without having to reassemble it.
;
;This feature is highly important as it allows up to 100% configurability of
;your game, which previously has only been available to applications using
;libraries such as MUI.  However, it is even more powerful than this as
;graphic artists could not only create new datasets for your game, but also
;alter the dimensions, colours, resolution, attributes (and more) of your
;Bobs and Screens.  Support for code segments is also available, so
;external functions could be altered and improved by programmers.  This will
;ensure that your game has a long lasting future as it keeps up with current
;technology and additions to GMS.
;
;I hope you make the most of external objects, its worth it!

	INCDIR	"GMSDev:Includes/"
	INCLUDE	"dpkernel/dpkernel.i"
	INCLUDE	"files/objects.i"
	INCLUDE	"modules/objects.i"

	SECTION	"Objects",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	OBJFileName(pc),a0
	moveq	#ID_OBJECTFILE,d0
	CALL	Load
	move.l	d0,ObjectBase
	beq	.Exit

	;Open the objects module.

	lea	ObjModTags(pc),a0	;a0 = Module tags.
	sub.l	a1,a1	;a1 = No container.
	CALL	Init	;>> = Initialise Cards Interface.
	tst.l	d0	;d0 = Check for error.
	beq	.Exit	;>> = Error, exit.
	move.l	d0,a0	;a0 = Card module.
	move.l	MOD_ModBase(a0),OBJBase	;ma = Store jump table.

	;Load the file, then start
	;getting our objects.

	move.l	OBJBase(pc),a6
	move.l	ObjectBase(pc),a0	;a0 = Object Base.
	lea	TXT_ScreenName(pc),a1	;a1 = The name of the object to get.
	CALL	PullObject	;>> = Get our GameScreen object.
	move.l	d0,Screen	;a0 = Screen tags of our object.
	beq	.Exit	;>> = Quit if error.

	move.l	OBJBase(pc),a6
	move.l	ObjectBase(pc),a0	;a0 = Object Base.
	lea	TXT_PictureName(pc),a1	;a1 = The name of the object to get.
	CALL	PullObject	;>> = Get our GameScreen object.
	move.l	d0,Picture	;>> = Picture tags of our object.
	beq.s	.Exit	;>> = Quit if error.

	;Initialise the screen.

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0	;a0 = Screen tags
	sub.l	a1,a1
	CALL	Init	;>> = Initialise the screen.
	tst.l	d0	;ma = Save pointer to the GameScreen.
	beq.s	.Exit	;>> = Quit if error.

	;Initialise the picture.

	move.l	Picture(pc),a0
	move.l	Screen(pc),a1
	move.l	PIC_Bitmap(a0),a2
	move.l	GS_MemPtr1(a1),BMP_Data(a2)
	sub.l	a1,a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
	move.l	Picture(pc),a1
	move.l	GS_Bitmap(a0),a2
	move.l	PIC_Bitmap(a1),a1
	move.l	BMP_Palette(a1),BMP_Palette(a2)
	CALL	scrUpdatePalette

	move.l	DPKBase(pc),a6
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
	move.l	Picture(pc),a0
	CALL	Free
	move.l	Screen(pc),a0
	CALL	Free
	move.l	ObjectBase(pc),a0
	CALL	Free
	move.l	ObjModule(pc),a0
	CALL	Free
	MOVEM.L	(SP)+,A0-A6/D1-D7
	moveq	#ERR_OK,d0
	rts

;===========================================================================;
;                                MAIN LOOP
;===========================================================================;

Main:	move.l	SCRBase(pc),a6
	CALL	scrWaitAVBL

	move.l	DPKBase(pc),a6
	move.l	JoyData(pc),a0
	CALL	Query
	move.l	JoyData(pc),a0
	move.l	JD_Buttons(a0),d0
	btst	#JB_LMB,d0
	beq.s	Main
	rts

;===========================================================================;
;                                  DATA
;===========================================================================;

Screen:		dc.l  0
Picture:	dc.l  0
JoyData:	dc.l  0
ObjectBase:	dc.l  0
OBJBase:	dc.l  0
OBJFileName:	FILENAME "GMS:demos/data/Screen.obj"

TXT_ScreenName:	dc.b  "Screen",0
		even
TXT_PictureName	dc.b  "Picture",0
		even

ObjModTags:	dc.l  TAGS_MODULE
ObjModule:	dc.l  0
		dc.l  MODA_Name,ObjName
		dc.l  TAGEND

ObjName:	dc.b  "objects.mod",0
		even

;===========================================================================;

ProgName:	dc.b  "Screen Object",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "February 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Screen Object demonstration.",0
		even

