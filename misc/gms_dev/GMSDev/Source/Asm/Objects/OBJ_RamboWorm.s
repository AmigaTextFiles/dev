;-------T-------T------------------------T----------------------------------;
;This example blits a Worm from an IFF file onto a double buffered screen.
;The RESTORE mode is used to put the background back.
;
;All structures defined externally.

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
	lea	OBJFileName(pc),a0	;a0 = Object FileName.
	moveq	#ID_OBJECTFILE,d0	;d0 = Object DataBase.
	CALL	Load
	move.l	d0,ObjectData
	beq	.Exit

	;Open the objects module.

	lea	ObjModTags(pc),a0	;a0 = Module tags.
	sub.l	a1,a1	;a1 = No container.
	CALL	Init	;>> = Initialise Cards Interface.
	tst.l	d0	;d0 = Check for error.
	beq	.Exit	;>> = Error, exit.
	move.l	d0,a0	;a0 = Card module.
	move.l	MOD_ModBase(a0),OBJBase	;ma = Store jump table.

	move.l	OBJBase(pc),a6
	move.l	ObjectData(pc),a0	;a0 = Object Base.
	lea	Objects(pc),a1	;a1 = A list of objects to get.
	CALL	PullObjectList	;>> = Get our objects.
	tst.l	d0	;d0 = Check for error.
	bne	.Exit	;>> = Quit if error.

;---------------------------------------------------------------------------;

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
	move.l	Screen(pc),a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

;---------------------------------------------------------------------------;
;Load the bob file in.  This contains the graphics data that we are
;going to draw to the screen.

	move.l	BOB_Rambo(pc),a0
	move.l	Screen(pc),a1
	CALL	Init
	tst.l	d0
	beq.s	.Exit

;---------------------------------------------------------------------------;
;Load sounds and initialise joydata object.

	move.l	SND_Rambo(pc),a0
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

;---------------------------------------------------------------------------;
;Display our screen and start the demo.

	move.l	Screen(pc),a0
	CALL	Display

	bsr.s	Main

;---------------------------------------------------------------------------;
;Free the allocations.

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
	move.l	ObjectData(pc),a0
	CALL	Free
	move.l	ObjModule(pc),a0
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
	move.l	Restore(pc),a0	;a0 = Restore.
	CALL	Activate	;>> = Restore the backgrounds.

	move.l	BOB_Rambo(pc),a0
	CALL	Draw	;>> = Blit the bob.

	move.l	SCRBase(pc),a6
	move.l	Screen(pc),a0
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

ObjectData:	dc.l  0
JoyData:	dc.l  0
Screen:		dc.l  0
PIC_Background:	dc.l  0
BackgroundFile:	FILENAME "GMS:demos/data/PIC.Green"

OBJFileName:	FILENAME "GMS:demos/data/Worm.obj"

Objects:	dc.l  OBJECTLIST,0
		dc.l  TXT_Worm
BOB_Rambo:	dc.l  0
		dc.l  TXT_SNDRambo
SND_Rambo:	dc.l  0
		dc.l  LISTEND

TXT_Worm:	dc.b  "Worm",0
TXT_BOBPicture:	dc.b  "BOBPicture",0
TXT_SNDRambo:	dc.b  "SNDRambo",0
		even

RestoreTags:	dc.l  TAGS_RESTORE
Restore:	dc.l  0
		dc.l  RSA_Entries,1
		dc.l  TAGEND

;---------------------------------------------------------------------------;

ObjModTags:	dc.l  TAGS_MODULE
ObjModule:	dc.l  0
		dc.l  MODA_Name,ObjName
		dc.l  TAGEND

ObjName:	dc.b  "objects.mod",0
		even

OBJBase:	dc.l  0

;===========================================================================;

ProgName:	dc.b  "Rambo Worm",0
ProgAuthor:	dc.b  "Paul Manias",0
ProgDate:	dc.b  "August 1998",0
ProgCopyright:	dc.b  "DreamWorld Productions (c) 1996-1998.  Freely distributable.",0
ProgShort:	dc.b  "Simple demonstration.",0
		even

