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

	SECTION	"Demo",CODE

;===========================================================================;
;                             INITIALISE DEMO
;===========================================================================;

	STARTDPK

Start:	MOVEM.L	A0-A6/D1-D7,-(SP)
	move.l	DPKBase(pc),a6
	lea	OBJFileName(pc),a0	;a0 = Name of the object file.
	moveq	#ID_OBJECTFILE,d0	;d0 = ID_OBJECTFILE
	CALL	Load	;>> = Go and load it.
	move.l	d0,ObjectFile	;MA = Save the base.
	beq	.Exit	;>> = Quit if error.

	;Open the objects module.

	lea	ObjModTags(pc),a0	;a0 = Module tags.
	sub.l	a1,a1	;a1 = No container.
	CALL	Init	;>> = Initialise Cards Interface.
	tst.l	d0	;d0 = Check for error.
	beq	.Exit	;>> = Error, exit.
	move.l	d0,a0	;a0 = Card module.
	move.l	MOD_ModBase(a0),OBJBase	;ma = Store jump table.

	move.l	OBJBase(pc),a6
	move.l	ObjectFile(pc),a0	;a0 = Object Base.
	lea	Objects(pc),a1	;a1 = A list of objects to get.
	CALL	PullObjectList	;>> = Get our objects.
	tst.l	d0	;d0 = Success?
	bne.s	.Exit	;>> = Quit if error.

	;Initialise the screen.

	move.l	DPKBase(pc),a6
	move.l	Screen(pc),a0	;a0 = Screen tags.
	sub.l	a1,a1	;a1 = No container.
	CALL	Init	;>> = Initialise the screen.
	tst.l	d0	;MA = Save pointer to the Screen.
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
	move.l	ObjectFile(pc),a0
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

JoyData:	dc.l  0
ObjectFile:	dc.l  0
OBJBase:	dc.l  0
OBJFileName:	FILENAME "GMS:demos/data/Screen.obj"

Objects:	dc.l  OBJECTLIST,0
		dc.l  TXT_Screen
Screen:		dc.l  0
		dc.l  TXT_Picture
Picture:	dc.l  0
		dc.l  LISTEND

TXT_Screen:	dc.b  "Screen",0
		even
TXT_Picture:	dc.b  "Picture",0
		even

ObjModTags:	dc.l  TAGS_MODULE
ObjModule:	dc.l  0
		dc.l  MODA_Name,ObjName
		dc.l  TAGEND

ObjName:	dc.b  "objects.mod",0
		even

;===========================================================================;

ProgName:	dc.b  "Object List Demo",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "October 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Object demonstration.",0
		even

