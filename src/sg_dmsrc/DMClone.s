;	====================================================================
;	NAME:	DMClone	Game Engine	Final Public Release Version (?) :-)
;	AUTHOR:	Richard Tew	aka	Soltan Gris
;	DATE:	05/08/94		VERSION:		1.00
;	ABOUT:	This source is freely distributable on the conditions:
;		a)	If it used, in part or all in the production of any-
;			thing, permission is granted, with the sole condition
;			that due credit is given to me also stating that
;			'Richard Tew's DMClone Source was used in the creation
;			of this' or words to that effect are shown in the
;			program - *in sight* :)
;		b)	This base version is not redistributed in *ANY* form
;			with claims to creation by anyone else. Permission
;			is granted to distribute it, *when _majorly_ updated*
;			but credit must also be given to me as per (a). :)
;			also, my addresses etc.. must be left included..
;		c)	Anything else I can't think of now.
;	CONTACT:Snail-Mail:	146 Alford Forest Rd,
;				Ashburton,
;				New Zealand.
;		E-Mail:		MISC1664@csc.canterbury.ac.nz
;	====================================================================
; NOTE: If you don't have the sg_dmbin.lha file this is the Aminet release,
; and it will not compile. Otherwise, it should compile fine with a few 
; changes.. :) The reason for this is that Aminet won't keep the graphics as
; they are semi-legal, having been ripped from Dungeon Master.. Sorry..
;	====================================================================
;	Includes:

	include	"hardware/customregisters.i"
	include	"exec/exec_lib.i"
	include	"exec/memory.i"
	include	"graphics/gfxbase.i"
	
;	--------------------------------------------------------------------
;	Equates:

	include	"DMInclude.s"
	include	"DMWrkspc.s"

;	--------------------------------------------------------------------

;	Code:
;	a6=ExecBase
;	a5=Custom
;	a4=Workspace

;	====================================================================
;	User Definitions:
;	--------------------------------------------------------------------

StartDirection	equ	East	; Why? Why not?

;	====================================================================

	SECTION	WorldOfGreyhawk,CODE
	
	move.l	4.w,a6
	jsr	_LVOForbid(a6)
	
	bsr	Setup
	tst.l	d0
	bne	SetupError

	lea	CurrentButtonTable(pc),a0
	lea	GameBtnRtnTable(pc),a1
	move.l	a1,(a0)

	move.b	#1,wk_PrtCoordFlag(a4)

;	--------------------------------------------------------------------

	bsr	DrawCurrentView
	bsr	DrawScreenObjects

;	--------------------------------------------------------------------

WaitVPos:
	move.l	vposr(a5),d1
	and.l	#$1FF00,d1
	cmp.l	#$13700,d1
	bne.s	WaitVPos

	bsr	GetMouseCoords
	bsr	CheckCoords
	bsr	MoveMouse	
	tst.b	wk_PrtCoordFlag(a4)
	beq.s	GameSkipCoords

	bsr	PrintCoords
GameSkipCoords
	bsr	CheckSpriteSlct
	tst.b	wk_QuitFlag(a4)
	beq.s	WaitVPos	

;	--------------------------------------------------------------------

	bsr	CloseDown

Exit	jsr	_LVOPermit(a6)
	moveq	#0,d0
	rts

;	====================================================================

Setup	lea	$DFF000,a5

	move.l	#300,d0
	move.l	#(MEMF_CLEAR!MEMF_PUBLIC),d1
	jsr	_LVOAllocMem(a6)
	move.l	d0,a4
	beq	WorkMemAllocError

	move.w	dmaconr(a5),wk_DMAConSave(a4)
	move.w	intenar(a5),wk_IntenaSave(a4)

	move.w	joy0dat(a5),wk_OldJoy0Dat(a4)
	move.w	joy1dat(a5),wk_OldJoy1Dat(a4)

	move.w	#0,wk_SpriteXCoord(a4)
	move.w	#0,wk_SpriteYCoord(a4)
	move.w	#StartDirection,wk_FaceDirec(a4)
	move.w	#1,wk_XCoord(a4)
	move.w	#7,wk_YCoord(a4)

;	--------------------------------------------------------------------
	
	move.l	#NumPlanes*10240,d0
	move.l	#(MEMF_CLEAR!MEMF_CHIP),d1
	jsr	_LVOAllocMem(a6)

	move.l	d0,wk_PF1_Bitplane1(a4)
	beq	PlaneMem1AllocError
	lea	CprPln1,a0
	bsr	InstallAddrToCopper

	add.l	#BytesPerLine,d0
	move.l	d0,wk_PF1_Bitplane2(a4)
	lea	CprPln2,a0
	bsr	InstallAddrToCopper

	add.l	#BytesPerLine,d0
	move.l	d0,wk_PF1_Bitplane3(a4)
	lea	CprPln3,a0
	bsr	InstallAddrToCopper

	add.l	#BytesPerLine,d0
	move.l	d0,wk_PF1_Bitplane4(a4)
	lea	CprPln4,a0
	bsr	InstallAddrToCopper

;	--------------------------------------------------------------------

	move.l	#NumPlanes*10240,d0
	move.l	#(MEMF_CLEAR!MEMF_CHIP),d1
	jsr	_LVOAllocMem(a6)
	move.l	d0,wk_PF2_Bitplane1(a4)
	beq	PlaneMem2AllocError
	add.l	#BytesPerLine,d0
	move.l	d0,wk_PF2_Bitplane2(a4)
	add.l	#BytesPerLine,d0
	move.l	d0,wk_PF2_Bitplane3(a4)
	add.l	#BytesPerLine,d0
	move.l	d0,wk_PF2_Bitplane4(a4)

;	--------------------------------------------------------------------

	lea	CprSpr1,a0
	move.l	#SpriteData,d0
	bsr	InstallAddrToCopper

	lea	CprSpr2,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper
	lea	CprSpr3,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper
	lea	CprSpr4,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper
	lea	CprSpr5,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper
	lea	CprSpr6,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper
	lea	CprSpr7,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper
	lea	CprSpr8,a0
	lea	wk_BlankSprite(a4),a1
	move.l	a1,d0
	bsr	InstallAddrToCopper

;	--------------------------------------------------------------------

	lea	CopperList,a0
	move.l	a0,cop1lch(a5)
	clr.w	copjmp1(a5)

;	move.l	$6C.w,wk_OldIrq(a4)
;	lea	NewIrq(pc),a0
;	move.l	a0,$6C.w

	move.w	#%1000001111100000,dmacon(a5)
;	move.w	#$c020,intena(a5)
	moveq	#0,d0
	rts

;	--------------------------------------------------------------------

InstallAddrToCopper
	move.w	d0,6(a0)	; Store the lo-word
	swap	d0		; Make the hi-word available
	move.w	d0,2(a0)	; Store the hi-word
	swap	d0		; Restore the old value in d0
	rts

;	--------------------------------------------------------------------

PlaneMem1AllocError
	moveq	#1,d0
	rts

;	--------------------------------------------------------------------

PlaneMem2AllocError
	moveq	#2,d0
	rts

;	--------------------------------------------------------------------

WorkMemAllocError
	moveq	#3,d0	
	rts
	
;	--------------------------------------------------------------------

SetupError
	cmp.l	#1,d0
	beq.s	PlaneError
	cmp.l	#2,d0
	beq	Plane2Error
	bra	Exit

;	--------------------------------------------------------------------

PlaneError
	bsr.s	FreeWorkMem
	bra	Exit	

;	====================================================================

CloseDown
;	move.l	wk_OldIrq(a4),$6C.w

	move.w	wk_DMAConSave(a4),d0
	or.w	#%1000000000000000,d0
	move.w	d0,dmacon(a5)

	move.w	wk_IntenaSave(a4),d0
	or.w	#%1100000000000000,d0
	move.w	d0,intena(a5)

	lea	GfxName(pc),a1
	jsr	_LVOOldOpenLibrary(a6)
	move.l	d0,a1

	move.l	gb_copinit(a1),cop1lch(a5)
	clr.w	copjmp1(a5)

	jsr	_LVOCloseLibrary(a6)

	move.l	#4*10240,d0
	move.l	wk_PF2_Bitplane1(a4),a1
	jsr	_LVOFreeMem(a6)

;	--------------------------------------------------------------------

Plane2Error
	move.l	#4*10240,d0
	move.l	wk_PF1_Bitplane1(a4),a1
	jsr	_LVOFreeMem(a6)

FreeWorkMem
	move.l	#300,d0
	move.l	a4,a1
	jsr	_LVOFreeMem(a6)
	
	rts

;	====================================================================

newirq:	movem.l	d0-d7/a0-a6,-(SP)

	bsr	GetMouseCoords
	bsr	CheckCoords
	bsr	MoveMouse

	movem.l	(SP)+,d0-d7/a0-a6
	move.w	#$20,$9c(a5)
	rte

;	====================================================================
;	FUNCTION:	WaitBlitter
;	USAGE:		To wait for the blitter to finish it's current blit, if any..
;	--------------------------------------------------------------------

WaitBlitter
	btst	#14,dmaconr(a5)
	bne.s	WaitBlitter
	rts

;	====================================================================
;	FUNCTION: CheckCoords
;	USAGE:    To ensure the mouse pointer doesn't exceed screen boundaries..
;	--------------------------------------------------------------------

CheckCoords
	move.w	wk_SpriteXCoord(a4),d0
	cmp.w	#0,d0
	bge.s	SpriteXIsHighEnough
	move.w	#0,wk_SpriteXcoord(a4)
SpriteXIsHighEnough
	cmp.w	#320,d0
	ble.s	SpriteXIsLowEnough
	move.w	#320,wk_SpriteXCoord(a4)
SpriteXIsLowEnough	
	move.w	wk_SpriteYCoord(a4),d0
	cmp.w	#0,d0
	bge.s	SpriteYIsHighEnough
	move.w	#0,wk_SpriteYCoord(a4)
SpriteYIsHighEnough
	cmp.w	#256,d0
	ble.s	SpriteYIsLowEnough
	move.w	#256,wk_SpriteYCoord(a4)
SpriteYIsLowEnough		
	rts

;	====================================================================
;	FUNCTION: GetMouseCoords
;	USAGE:    To work out sprite movement from JOY0DAT..
;	--------------------------------------------------------------------

GetMouseCoords
	move.w	joy0dat(a5),d0
	move.w	wk_OldJoy0Dat(a4),d1
	move.w	d0,d2
	and.w	#%1111111100000000,d1
	and.w	#%1111111100000000,d2
	asr.w	#8,d1
	asr.w	#8,d2
	sub.w	d2,d1
	move.w	d1,d2
	bpl.s	LBC002232
	eor.w	#%1111111111111111,d2
LBC002232
	cmp.w	#128,d2
	bcs.s	LBC00223C
	move.w	#0,d1
LBC00223C
	sub.w	d1,wk_SpriteYCoord(a4)
	move.w	wk_OldJoy0Dat(a4),d1
	move.w	d0,d2
	and.w	#%0000000011111111,d1
	and.w	#%0000000011111111,d2
	sub.w	d2,d1
	move.w	d1,d2
	bpl.s	LBC002276
	eor.w	#%1111111111111111,d2
LBC002276
	cmp.w	#128,d2
	bcs.s	LBC002280
	move.w	#0,d1
LBC002280
	sub.w	d1,wk_SpriteXCoord(a4)
	move.w	d0,wk_OldJoy0Dat(a4)
	rts

MoveMouse
	lea	SpriteData,a0
	move.b	#1,3(a0)
	move.w	wk_SpriteXCoord(a4),d0
	add.w	#128,d0
	btst	#0,d0
	bne.s	SprWidthIsEven
	and.b	#$FE,3(a0)
SprWidthIsEven
	asr.w	#1,d0
	move.b	d0,1(a0)
	move.w	wk_SpriteYCoord(a4),d0
	add.w	#44,d0
	btst	#8,d0
	beq.s	SprStrtIsGT200
	or.b	#%0100,3(a0)
SprStrtIsGT200
	move.b	d0,0(a0)
	add.w	#13,d0
	btst	#8,d0
	beq.s	SprStopIsGT200
	or.b	#0010,3(a0)
SprStopIsGT200
	move.b	d0,2(a0)
	rts
	
;	====================================================================
;	FUNCTION: CheckSpriteSlct
;	USAGE:    To check if any buttons have been pressed..
;	--------------------------------------------------------------------

CheckSpriteSlct
	btst	#06,Ciaapra
	beq.s	CallButtonRoutine
	btst	#10,potinp(a5)
	beq.s	RMouseClicked
	rts

RMouseClicked
	move.b	#1,wk_QuitFlag(a4)
	rts	

CallButtonRoutine
	move.w	wk_SpriteXCoord(a4),d0
	move.w	wk_SpriteYCoord(a4),d1

	move.l	CurrentButtonTable(pc),a0
TestIfEnd
	cmp.l	#0,8(a0)
	beq.s	UnknownCoords
	move.w	0(a0),d2
	move.w	2(a0),d3
	move.w	4(a0),d4
	move.w	6(a0),d5
	cmp.w	d0,d2
	bgt.s	TryNextCoordSet
	cmp.w	d0,d4
	ble.s	TryNextCoordSet
	cmp.w	d1,d3
	bgt.s	TryNextCoordSet
	cmp.w	d1,d5
	ble.s	TryNextCoordSet
	move.l	8(a0),a0
	jmp	(a0)

TryNextCoordSet
	lea	12(a0),a0
	bra.s	TestIfEnd
UnknownCoords
	rts
	
Quit	move.b	#1,wk_QuitFlag(a4)
	rts

;	====================================================================
;	FUNCTION:	UpdateMap
;	USE:		Draw map.
;	PARAMS:		None
;	RESULT:		None
;	--------------------------------------------------------------------

; Width equals 7 squares. Ditto for height.

UpdateMap
	rts	

;	====================================================================
;	FUNCTION: PrintCoords
;	USE:	  Prints sprite coords ,Direction on the screen
;	PARAMS:	  None
;	RESULT:	  None
;	--------------------------------------------------------------------

PrintCoords
;	move.l	#0,wk_CharBuffer(a4)
;	move.w	wk_SpriteXCoord(a4),d0
;	bsr	ConvHexToAsc
;	bsr	PrintXCoord

	move.l	#0,wk_CharBuffer(a4)
	move.w	wk_XCoord(a4),d0
	bsr	ConvHexToAsc
	bsr	PrintXCoord

	move.l	#0,wk_CharBuffer(a4)
	move.w	wk_YCoord(a4),d0
	bsr	ConvHexToAsc
	bsr	PrintYCoord

;	move.l	#0,wk_CharBuffer(a4)
;	move.w	wk_SpriteYCoord(a4),d0
;	bsr	ConvHexToAsc
;	bsr.s	PrintYCoord

	cmp.w	#NORTH,wk_FaceDirec(a4)
	bne.s	SkipNBit
	moveq	#'N',d0
	bra.s	PrintCompassDirec

SkipNBit
	cmp.w	#EAST,wk_FaceDirec(a4)
	bne.s	SkipEBit
	moveq	#'E',d0
	bra.s	PrintCompassDirec

SkipEBit
	cmp.w	#SOUTH,wk_FaceDirec(a4)
	bne.s	SkipSBit
	moveq	#'S',d0
	bra.s	PrintCompassDirec

SkipSBit
	cmp.w	#WEST,wk_FaceDirec(a4)
	bne.s	SkipWBit
	moveq	#'W',d0
	bra.s	PrintCompassDirec

SkipWBit
	moveq	#'?',d0
PrintCompassDirec
	move.l	wk_PF1_Bitplane2(a4),a0
	moveq	#17,d1
	moveq	#30,d2
	bsr	DrawCharacter
NoDirec
	rts

PrintYCoord
	moveq	#0,d0
	move.l	wk_PF1_Bitplane2(a4),a0
	move.b	wk_CharBuffer(a4),d0
	moveq	#7,d1
	moveq	#30,d2
	bsr	DrawCharacter

	moveq	#0,d0
	move.l	wk_PF1_Bitplane2(a4),a0
	move.b	wk_CharBuffer+1(a4),d0
	moveq	#8,d1
	moveq	#30,d2
	bsr	DrawCharacter

	moveq	#0,d0
	move.l	wk_PF1_Bitplane2(a4),a0
	move.b	wk_CharBuffer+2(a4),d0
	moveq	#9,d1
	moveq	#30,d2
	bra	DrawCharacter

PrintXCoord
	moveq	#0,d0
	move.l	wk_PF1_Bitplane2(a4),a0
	move.b	wk_CharBuffer(a4),d0
	moveq	#0,d1
	moveq	#30,d2
	bsr	DrawCharacter

	moveq	#0,d0
	move.l	wk_PF1_Bitplane2(a4),a0
	move.b	wk_CharBuffer+1(a4),d0
	moveq	#1,d1
	moveq	#30,d2
	bsr.s	DrawCharacter

	moveq	#0,d0
	move.l	wk_PF1_Bitplane2(a4),a0
	move.b	wk_CharBuffer+2(a4),d0
	moveq	#2,d1
	moveq	#30,d2
	bra.s	DrawCharacter

;	====================================================================
;	FUNCTION: ConvHexToAsc
;	USE:	  Converts a hex number to ascii
;	PARAMS:	  d0=Hex number
;	RESULT:	  Buffer=Ascii number
;	--------------------------------------------------------------------

ConvHexToAsc
	lea	wk_CharBuffer(a4),a0
	ext.l	d0

	move	d0,d2
	lsr	#8,d2	
	bsr	pn_Nibble
	move.b	d2,0(a0)
	move	d0,d2
	lsr	#4,d2	
	bsr	pn_Nibble
	move.b	d2,1(a0)
	move	d0,d2
	bsr	pn_Nibble
	move.b	d2,2(a0)
	rts

pn_Nibble
	and	#%1111,d2
	add	#$30,d2
	cmp	#$3a,d2
	bcs	pn_ok
	add	#7,d2
pn_ok	rts

;	====================================================================
;	FUNCTION: DrawCharacter
;	USE:	  Prints a character at specified X,Y coords.
;	PARAMS:	  d0=Character d1=XCoord d2=YCoord
;	RESULT:	  Character printed on screen.
;	--------------------------------------------------------------------

DrawCharacter
	btst	#7,d0
	sne	d3
	and.w	#%0000000001111111,d0
	sub.b	#' ',d0
	bpl.s	StillPositive
	moveq	#96,d0
StillPositive
	lsl.w	#3,d0
	lea	CharSetData(pc),a1
	add.w	d0,a1
	bsr.s	GetScreenXYOffsets
	moveq	#8-1,d0
CopyCharData
	move.b	(a1)+,d1
	eor.b	d3,d1
	move.b	d1,(a0)
	add.w	#(NumPlanes)*BytesPerLine,a0
	dbra	d0,CopyCharData
	rts

GetScreenXYOffsets
	move.w	d2,d0	; Y Coord
	mulu	#(NumPlanes-1)*BytesPerLine*8,d0
AddXOffset
	add.w	d1,d0	; X Coord
	add.w	d0,a0
	rts

;	====================================================================

ClearWindow
;	Move.l	wk_PF1_Bitplane1(a4),a0
;	bsr	WaitBlitter
;	bsr	ClearWinPln

;	Move.l	wk_PF1_Bitplane2(a4),a0
;	bsr	WaitBlitter
;	bsr	ClearWinPln

;	Move.l	wk_PF1_Bitplane3(a4),a0
;	bsr	WaitBlitter
;	bsr	ClearWinPln
	rts

ClearWinPln
	move.l	#136,d0
	mulu	#NumPlanes*BytesPerLine,d0
	add.l	d0,a0
	MOVE.L	A0,bltdpth(a5)
	move.l	#$FFFFFFFF,bltafwm(a5)
	MOVE.W	#BytesPerLine-Window_Width,bltdmod(a5)
	MOVE.w	#0,bltcon1(a5)
	MOVE.w	#%0000000100000000,bltcon0(a5)
	Move.w	#Window_Length*NumPlanes*64+Window_Width/2,Bltsize(a5)

	Rts

;	====================================================================
;	FUNCTION: DrawScreenObjects
;	USE:	  Draws arrows, map in window.
;	PARAMS:	  None.
;	RESULT:	  None.
;	--------------------------------------------------------------------

DrawScreenObjects
	lea	ArrowsBin,a1
	move.l	wk_PF1_Bitplane3(a4),a0
	move	#Arrows_XStart,d0
	move	#Arrows_YStart,d1
	move	d0,d2
	lsr	#4,d0
	add	d0,d0
	mulu	#NumPlanes*BytesPerLine,d1
	add	d1,d0
	lea	(a0,d0),a0
	Bsr	WaitBlitter
	Move.l	a0,Bltdpth(a5)
	move.l	a1,Bltapth(a5)
	Move.l	#$ffffffff,Bltafwm(a5)
	Move.w	#0,Bltamod(a5)
	Move.w	#NumPlanes*BytesPerLine-Arrows_Width,Bltdmod(a5)
	And	#$0f,d2
	Ror	#4,d2
	Move	d2,d0
	Swap	d0
	Move	d2,d0
	Or.l	#$9f00000,d0
	Move.l	d0,Bltcon0(a5)
	Move	#Arrows_Length*Arrows_Nopln*64+Arrows_Width/2,Bltsize(a5)
	rts

;	====================================================================
;	FUNCTION: DrawWindowBackground
;	USE:	  Draws a picture in window
;	PARAMS:	  a1=Source address
;		  a0=Dest address
;	RESULT:	  None
;	--------------------------------------------------------------------

DrawWindowBackground
	Move	#BkGrd_XStart,d0
	Move	#BkGrd_YStart,d1
	Move	d0,d2
	Lsr	#4,d0
	Add	d0,d0
	Mulu	#NumPlanes*BytesPerLine,d1
	Add	d1,d0
	Lea	(a0,d0),a0
	Bsr	WaitBlitter
	Move.l	a0,Bltdpth(a5)		; Dest screen
	Move.l	a0,Bltcpth(a5)		; Source screen
	Move.l	a2,Bltbpth(a5)		; BOB Mask pointer
	Move.l	a1,Bltapth(a5)		; Actual BOB pointer
	Move.l	#$ffff0000,Bltafwm(a5)
	Move.w	#0,Bltamod(a5)
	Move.w	#0,Bltbmod(a5)
	Move.w	#BytesPerLine-BkGrd_Width,Bltcmod(a5)
	Move.w	#BytesPerLine-BkGrd_Width,Bltdmod(a5)
	And	#$0f,d2
	Ror	#4,d2
	Move	d2,d0
	Swap	d0
	Move	d2,d0
	Or.l	#$fe20000,d0
	Move.l	d0,Bltcon0(a5)
	Move	#BkGrd_Length*Bkgrd_Nopln*64+BkGrd_Width/2,Bltsize(a5)
	Rts

DrawBackground
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	BackGroundBin,a1
	lea	BackGroundMask,a2
	bra	DrawWindowBackground

CopyWindow
	Move	#BkGrd_XStart,d0
	Move	#BkGrd_YStart,d1
	Move	d0,d2
	Lsr	#4,d0
	Add	d0,d0
	Mulu	#BkGrd_NoPln*BytesPerLine,d1
	Add	d1,d0
	Lea	(a0,d0),a0
	Lea	(a1,d0),a1
	Bsr	WaitBlitter
	Move.l	a0,Bltdpth(a5)
	Move.l	a1,Bltapth(a5)
	Move.l	#$ffffffff,Bltafwm(a5)
	Move.w	#BytesPerLine-(BkGrd_Width-2),Bltamod(a5)
	Move.w	#BytesPerLine-(BkGrd_Width-2),Bltdmod(a5)
	And	#$0f,d2
	Ror	#4,d2
	Move	d2,d0
	Swap	d0
	Move	d2,d0
	Or.l	#$9f00000,d0	; Straight copy a => d channels
	Move.l	d0,Bltcon0(a5)
	Move	#BkGrd_Length*Bkgrd_Nopln*64+(BkGrd_Width-2)/2,Bltsize(a5)
	Rts

CopyView
	move.l	wk_PF1_Bitplane1(a4),a0
	move.l	wk_PF2_Bitplane1(a4),a1
	bra.s	CopyWindow

;	====================================================================
;	FUNCTION: DrawCurrentView
;	USE:	  Refreshes the view window.
;	PARAMS:	  None.
;	RESULT:	  None.
;	--------------------------------------------------------------------

DrawCurrentView
	bsr	DrawBackground
	move.w	wk_FaceDirec(a4),d6
	cmp.w	#NORTH,d6
	beq.s	DrawNorthView
	cmp.w	#EAST,d6
	beq.s	DrawEastView
	cmp.w	#SOUTH,d6
	beq.s	DrawSouthView
	cmp.w	#WEST,d6
	beq.s	DrawWestView
	move.w	#$00F0,color00(a4)
	rts

DrawNorthView
	lea	ViewNArray(pc),a0
	move.l	a0,wk_CurrentArray(a4)
	bsr.s	DrawView
	bra.s	CopyView

DrawEastView
	lea	ViewEArray(pc),a0
	move.l	a0,wk_CurrentArray(a4)
	bsr.s	DrawView
	bra	CopyView

DrawSouthView
	lea	ViewSArray(pc),a0
	move.l	a0,wk_CurrentArray(a4)
	bsr.s	DrawView
	bra	CopyView

DrawWestView
	lea	ViewWArray(pc),a0
	move.l	a0,wk_CurrentArray(a4)
	bsr.s	DrawView
	bra	CopyView
	
DrawView
	move.w	Wall_N2_03Y(a0),d0
	ext.l	d0
	move.w	Wall_N2_03X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryP2_03
	bsr	DrawN2_03Wall
TryP2_03
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_P2_03Y(a0),d0
	ext.l	d0
	move.w	Wall_P2_03X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryN1_03
	bsr	DrawP2_03Wall
TryN1_03
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_N1_03Y(a0),d0
	ext.l	d0
	move.w	Wall_N1_03X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryP1_03
	bsr	DrawN1_03Wall
TryP1_03
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_P1_03Y(a0),d0
	ext.l	d0
	move.w	Wall_P1_03X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	Try00_03
	bsr	DrawP1_03Wall
Try00_03
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_00_03Y(a0),d0
	ext.l	d0
	move.w	Wall_00_03X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryN2_02
	bsr	Draw00_03Wall
TryN2_02
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_N2_02Y(a0),d0
	ext.l	d0
	move.w	Wall_N2_02X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryP2_02
	bsr	DrawN2_02Wall
TryP2_02
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_P2_02Y(a0),d0
	ext.l	d0
	move.w	Wall_P2_02X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryN1_02
	bsr	DrawP2_02Wall
TryN1_02
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_N1_02Y(a0),d0
	ext.l	d0
	move.w	Wall_N1_02X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryP1_02
	bsr	DrawN1_02Wall
TryP1_02
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_P1_02Y(a0),d0
	ext.l	d0
	move.w	Wall_P1_02X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	Try00_02
	bsr	DrawP1_02Wall
Try00_02
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_00_02Y(a0),d0
	ext.l	d0
	move.w	Wall_00_02X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryN1_01
	bsr	Draw00_02Wall
TryN1_01
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_N1_01Y(a0),d0
	ext.l	d0
	move.w	Wall_N1_01X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryP1_01
	bsr	DrawN1_01Wall
TryP1_01
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_P1_01Y(a0),d0
	ext.l	d0
	move.w	Wall_P1_01X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	Try00_01
	bsr	DrawP1_01Wall
Try00_01
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_00_01Y(a0),d0
	ext.l	d0
	move.w	Wall_00_01X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryN1_00
	bsr	Draw00_01Wall
TryN1_00
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_N1_00Y(a0),d0
	ext.l	d0
	move.w	Wall_N1_00X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	TryP1_00
	bsr	DrawN1_00Wall
TryP1_00
	move.l	wk_CurrentArray(a4),a0
	move.w	Wall_P1_00Y(a0),d0
	ext.l	d0
	move.w	Wall_P1_00X(a0),d1
	ext.l	d1
	add.w	wk_YCoord(a4),d0
	add.w	wk_XCoord(a4),d1
	bsr	GetCoordTableOffset
	beq.s	WallsDone
	bsr	DrawP1_00Wall
WallsDone
	rts

;	--------------------------------------------------------------------

DrawN1_00Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallN1_00Bin,a1			; BOB binary
	lea	WallN1_00MBin,a2		; BOB Mask binary
	Move	#WallN1_00_XStart,d0		; Dest X coord
	Move	#WallN1_00_YStart,d1		; Dest Y coord
	Move	#BytesPerLine-Wall01_00_Width,d2
	Move	#Wall01_00_Height*Wall01_00_Nopln*64+Wall01_00_Width/2,d3
	bra	DrawBOB

DrawP1_00Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallP1_00Bin,a1
	lea	WallP1_00MBin,a2		; Temp Mask
	Move	#WallP1_00_XStart,d0
	Move	#WallP1_00_YStart,d1
	Move	#BytesPerLine-Wall01_00_Width,d2
	Move	#Wall01_00_Height*Wall01_00_Nopln*64+Wall01_00_Width/2,d3
	bra	DrawBOB

DrawN1_01Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallN1_01Bin,a1
	lea	WallN1_01MBin,a2		; Temp Mask
	Move	#WallN1_01_XStart,d0
	Move	#WallN1_01_YStart,d1
	Move	#BytesPerLine-Wall01_01_Width,d2
	Move	#Wall01_01_Height*Wall01_01_NoPln*64+Wall01_01_Width/2,d3
	bra	DrawBOB

DrawP1_01Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallP1_01Bin,a1
	lea	WallP1_01MBin,a2		; Temp Mask
	Move	#WallP1_01_XStart,d0
	Move	#WallP1_01_YStart,d1
	Move	#BytesPerLine-Wall01_01_Width,d2
	Move	#Wall01_01_Height*Wall01_01_NoPln*64+Wall01_01_Width/2,d3
	bra	DrawBOB

Draw00_01Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	Wall00_01Bin,a1
	lea	Wall00_01MBin,a2		; Temp Mask
	Move	#Wall00_01_XStart,d0
	Move	#Wall00_01_YStart,d1
	Move	#BytesPerLine-Wall00_01_Width,d2
	Move	#Wall01_01_Height*Wall01_01_NoPln*64+Wall00_01_Width/2,d3
	bra	DrawBOB

DrawN2_02Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallN2_02Bin,a1
	lea	WallN2_02MBin,a2		; Temp Mask
	Move	#WallN2_02_XStart,d0
	Move	#WallN2_02_YStart,d1
	Move	#BytesPerLine-Wall02_02_Width,d2
	Move	#Wall02_02_Height*Wall00_02_Nopln*64+Wall02_02_Width/2,d3
	bra	DrawBOB

DrawP2_02Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallP2_02Bin,a1
	lea	WallP2_02MBin,a2		; Temp Mask
	Move	#WallP2_02_XStart,d0
	Move	#WallP2_02_YStart,d1
	Move	#BytesPerLine-Wall02_02_Width,d2
	Move	#Wall02_02_Height*Wall00_02_Nopln*64+Wall02_02_Width/2,d3
	bra	DrawBOB

DrawN1_02Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallN1_02Bin,a1
	lea	WallN1_02MBin,a2		; Temp Mask
	Move	#WallN1_02_XStart,d0
	Move	#WallN1_02_YStart,d1
	Move	#BytesPerLine-Wall01_02_Width,d2
	Move	#Wall01_02_Height*Wall00_02_Nopln*64+Wall01_02_Width/2,d3
	bra	DrawBOB

DrawP1_02Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallP1_02Bin,a1
	lea	WallP1_02MBin,a2		; Temp Mask
	Move	#WallP1_02_XStart,d0
	Move	#WallP1_02_YStart,d1
	Move	#BytesPerLine-Wall01_02_Width,d2
	Move	#Wall01_02_Height*Wall00_02_Nopln*64+Wall01_02_Width/2,d3
	bra	DrawBOB

Draw00_02Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	Wall00_02Bin,a1
	lea	Wall00_02MBin,a2		; Temp Mask
	Move	#Wall00_02_XStart,d0
	Move	#Wall00_02_YStart,d1
	Move	#BytesPerLine-Wall00_02_Width,d2
	Move	#Wall01_02_Height*Wall00_02_Nopln*64+Wall00_02_Width/2,d3
	bra	DrawBOB

DrawN2_03Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallN2_03Bin,a1
	lea	WallN2_03MBin,a2		; Temp Mask
	Move	#WallN2_03_XStart,d0
	Move	#WallN2_03_YStart,d1
	Move	#BytesPerLine-Wall02_03_Width,d2
	Move	#Wall02_03_Height*Wall00_03_Nopln*64+Wall02_03_Width/2,d3
	bra	DrawBOB

DrawP2_03Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallP2_03Bin,a1
	lea	WallP2_03MBin,a2		; Temp Mask
	Move	#WallP2_03_XStart,d0
	Move	#WallP2_03_YStart,d1
	Move	#BytesPerLine-Wall02_03_Width,d2
	Move	#Wall02_03_Height*Wall00_03_Nopln*64+Wall02_03_Width/2,d3
	bra	DrawBOB

DrawN1_03Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallN1_03Bin,a1
	lea	WallN1_03MBin,a2		; Temp Mask
	Move	#WallN1_03_XStart,d0
	Move	#WallN1_03_YStart,d1
	Move	#BytesPerLine-Wall01_03_Width,d2
	Move	#Wall01_03_Height*Wall00_03_Nopln*64+Wall01_03_Width/2,d3
	bra	DrawBOB

DrawP1_03Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	WallP1_03Bin,a1
	lea	WallP1_03MBin,a2		; Temp Mask
	Move	#WallP1_03_XStart,d0
	Move	#WallP1_03_YStart,d1
	Move	#BytesPerLine-Wall01_03_Width,d2
	Move	#Wall01_03_Height*Wall00_03_Nopln*64+Wall01_03_Width/2,d3
	bra	DrawBOB

Draw00_03Wall
	move.l	wk_PF2_Bitplane1(a4),a0
	lea	Wall00_03Bin,a1
	lea	Wall00_03MBin,a2		; Temp Mask
	Move	#Wall00_03_XStart,d0
	Move	#Wall00_03_YStart,d1
	Move	#BytesPerLine-Wall00_03_Width,d2
	Move	#Wall01_03_Height*Wall00_03_Nopln*64+Wall00_03_Width/2,d3
	bra	DrawBOB

;	====================================================================
;	FUNCTION: DrawBOB
;	USE:	  Draws 1 pln of the bob on the screen.
;	PARAMS:	  A0 = Bitplane address.
;		  A1 = BOB data address.
;		  A2 = BOB mask address.
;		  D0 = X position.
;		  D1 = Y position.
;		  D2 = Screen_Width-'BOB_Width'.
;		  D3 = BOB's Bltsize.
;	RESULT:	  None.
;	--------------------------------------------------------------------

DrawBOB
	Move	d0,d4			; Save X value for shifts.
	Lsr	#4,d0
	Add	d0,d0
	Mulu	#NumPlanes*BytesPerLine,d1	; Get screen line offset.
	Add	d1,d0			; Add X position offset.
	Lea	(a0,d0),a0		; Add final offset to screen address.
	Bsr	WaitBlitter
	Move.l	a1,Bltapth(a5)		; BOB data.
	Move.l	a2,Bltbpth(a5)		; BOB mask data.
	Move.l	a0,Bltcpth(a5)		; Source screen address.
	Move.l	a0,Bltdpth(a5)		; Dest screen address.
	Move.l	#$ffff0000,Bltafwm(a5)
	Move.w	#0,Bltamod(a5)
	Move.w	#0,Bltbmod(a5)
	Move.w	d2,Bltcmod(a5)
	Move.w	d2,Bltdmod(a5)
	And	#$0f,d4
	Ror	#4,d4
	Move	d4,d0
	Swap	d0
	Move	d4,d0
	Or.l	#$fe20000,d0	; Use all channels, Mask, Image
	Move.l	d0,Bltcon0(a5)
	Move	d3,Bltsize(a5)
	Rts

;	====================================================================
;	FUNCTION: GetCurrentCoordOffset
;	USE:	  Gets the offset of current position in the
;		  map array.
;	PARAMS:	  None
;	RESULT:	  D0 = Offset
;	--------------------------------------------------------------------

GetCurrentCoordOffset
	move.w	wk_YCoord(a4),d0
	tst.w	d0
	beq.s	gcc_GetXOffset
	mulu	#15,d0
gcc_GetXOffset
	add.w	wk_XCoord(a4),d0
	rts

;	====================================================================
;	FUNCTION: GetCoordTableOffset
;	USE:	  Gets the offset of any position in the map array.
;	PARAMS:	  D0 = Test Y coord
;		  D1 = Test X Coord
;	RESULT:	  D0 = Offset
;	--------------------------------------------------------------------

GetCoordTableOffset
	move.l	CurrentMap(pc),a1
	add.w	d1,a1	; Get X Offset
	mulu	#15,d0
	add.w	d0,a1
	tst.b	0(a1)
	rts

TurnLeft
	cmp.w	#NORTH,wk_FaceDirec(a4)
	ble.s	tl_IsNowWest
	sub.w	#1,wk_FaceDirec(a4)
	bra	DrawCurrentView

tl_IsNowWest
	move.w	#WEST,wk_FaceDirec(a4)
	bra	DrawCurrentView

TurnRight
	cmp.w	#WEST,wk_FaceDirec(a4)
	bge.s	tr_IsNowNorth
	add.w	#1,wk_FaceDirec(a4)
	bra	DrawCurrentView

tr_IsNowNorth
	move.w	#NORTH,wk_FaceDirec(a4)
	bra	DrawCurrentView

MoveForward
	move.w	wk_YCoord(a4),d0
	move.w	wk_XCoord(a4),d1
	move.w	wk_FaceDirec(a4),d2
	lea	MoveArray(pc),a0
mf_TryNext
	cmp.w	ma_Direc(a0),d2
	beq.s	mf_FoundOurDirection
	cmp.w	#WEST,ma_Direc(a0)
	bne.s	mf_IncAddress
	move.w	#$00F0,color00(a5)
	rts

mf_IncAddress
	lea	ma_NxtDirec(a0),a0
	bra.s	mf_TryNext
	
mf_FoundOurDirection
	add.w	ma_ForwardX(a0),d1
	add.w	ma_ForwardY(a0),d0
	move.w	d1,d7	; New X Coord
	ext.l	d1
	move.w	d0,d6	; New Y Coord
	ext.l	d0
	bsr	GetCoordTableOffset
	bne.s	mf_NoChange
	move.w	d6,wk_YCoord(a4)
	move.w	d7,wk_XCoord(a4)
	bra	DrawCurrentView

mf_NoChange
	rts	

MoveLeft
	move.w	wk_YCoord(a4),d0
	move.w	wk_XCoord(a4),d1
	move.w	wk_FaceDirec(a4),d2
	lea	MoveArray(pc),a0
ml_TryNext
	cmp.w	ma_Direc(a0),d2
	beq.s	ml_FoundOurDirection
	cmp.w	#WEST,ma_Direc(a0)
	bne.s	ml_IncAddress
	move.w	#$00F0,color00(a5)
	rts

ml_IncAddress
	lea	ma_NxtDirec(a0),a0
	bra.s	ml_TryNext
	
ml_FoundOurDirection
	add.w	ma_LeftX(a0),d1
	add.w	ma_LeftY(a0),d0
	move.w	d1,d7	; New X Coord
	ext.l	d1
	move.w	d0,d6	; New Y Coord
	ext.l	d0
	bsr	GetCoordTableOffset
	bne.s	ml_NoChange
	move.w	d6,wk_YCoord(a4)
	move.w	d7,wk_XCoord(a4)
	bra	DrawCurrentView

ml_NoChange
	rts	

MoveBackward
	move.w	wk_YCoord(a4),d0
	move.w	wk_XCoord(a4),d1
	move.w	wk_FaceDirec(a4),d2
	lea	MoveArray(pc),a0
mb_TryNext
	cmp.w	ma_Direc(a0),d2
	beq.s	mb_FoundOurDirection
	cmp.w	#WEST,ma_Direc(a0)
	bne.s	mb_IncAddress
	move.w	#$00F0,color00(a5)
	rts

mb_IncAddress
	lea	ma_NxtDirec(a0),a0
	bra.s	mb_TryNext
	
mb_FoundOurDirection
	add.w	ma_BackwardX(a0),d1
	add.w	ma_BackwardY(a0),d0
	move.w	d1,d7	; New X Coord
	ext.l	d1
	move.w	d0,d6	; New Y Coord
	ext.l	d0
	bsr	GetCoordTableOffset
	bne.s	mb_NoChange
	move.w	d6,wk_YCoord(a4)
	move.w	d7,wk_XCoord(a4)
	bra	DrawCurrentView

mb_NoChange
	rts

MoveRight
	move.w	wk_YCoord(a4),d0
	move.w	wk_XCoord(a4),d1
	move.w	wk_FaceDirec(a4),d2
	lea	MoveArray(pc),a0
mr_TryNext
	cmp.w	ma_Direc(a0),d2
	beq.s	mr_FoundOurDirection
	cmp.w	#WEST,ma_Direc(a0)
	bne.s	mr_IncAddress
	move.w	#$00F0,color00(a5)
	rts

mr_IncAddress
	lea	ma_NxtDirec(a0),a0
	bra.s	mr_TryNext
	
mr_FoundOurDirection
	add.w	ma_RightX(a0),d1
	add.w	ma_RightY(a0),d0
	move.w	d1,d7	; New X Coord
	ext.l	d1
	move.w	d0,d6	; New Y Coord
	ext.l	d0
	bsr	GetCoordTableOffset
	bne.s	mr_NoChange
	move.w	d6,wk_YCoord(a4)
	move.w	d7,wk_XCoord(a4)
	bra	DrawCurrentView

mr_NoChange
	rts	

;	====================================================================

CurrentButtonTable
	dc.l	GameBtnRtnTable

;	--------------------------------------------------------------------

GameBtnRtnTable
	dc.w	101,175
	dc.w	134,187
	dc.l	Quit

;	dc.w	101,151
;	dc.w	122,170
;	dc.l	LeftHand

;	dc.w	125,151
;	dc.w	145,170
;	dc.l	RightHand

	dc.w	234,128
	dc.w	261,148
	dc.l	TurnLeft
	dc.w	264,128
	dc.w	289,148
	dc.l	MoveForward
	dc.w	291,128
	dc.w	318,148
	dc.l	TurnRight

	dc.w	234,150
	dc.w	261,170
	dc.l	MoveLeft
	dc.w	264,150
	dc.w	289,170
	dc.l	MoveBackward
	dc.w	291,150
	dc.w	318,170
	dc.l	MoveRight
	dc.w	0,0
	dc.w	0,0
	dc.l	0

;	====================================================================
;	   These are the offset tables to calculate what is in front of the PC.
;	one table for each direction N,E,S,W. These offsets are taken off the map.
;	--------------------------------------------------------------------

ViewNArray
;		X , Y	X , Y	X, Y	X, Y	X, Y	
	dc.w	-2,-3,	-1,-3,	0,-3,	1,-3,	2,-3
	dc.w	-2,-2,	-1,-2,	0,-2,	1,-2,	2,-2
	dc.w		-1,-1,	0,-1,	1,-1
	dc.w		-1,00,	0,00,	1,00

;	--------------------------------------------------------------------

ViewEArray
;		X, Y	X, Y	X,Y	X,Y	X,Y
	dc.w	3,-2,	3,-1,	3,0,	3,1,	3,2
	dc.w	2,-2,	2,-1,	2,0,	2,1,	2,2
	dc.w		1,-1,	1,0,	1,1
	dc.w		0,-1,	0,0,	0,1

;	--------------------------------------------------------------------

ViewSArray
;		X,Y	X,Y	X,Y	X, Y	X, Y	
	dc.w	2,3,	1,3,	0,3,	-1,3,	-2,3
	dc.w	2,2,	1,2,	0,2,	-1,2,	-2,2
	dc.w		1,1,	0,1,	-1,1
	dc.w		1,0,	0,0,	-1,0

;	--------------------------------------------------------------------

ViewWArray
;		X, Y	X, Y	X, Y	X , Y	X , Y	
	dc.w	-3,2,	-3,1,	-3,0,	-3,-1,	-3,-2
	dc.w	-2,2,	-2,1,	-2,0,	-2,-1,	-2,-2
	dc.w		-1,1,	-1,0,	-1,-1
	dc.w		00,1,	00,0,	00,-1

;	====================================================================
;	   This is the offset table to find the offset of the current position the
;	PC will move to depending on the direction the char may be facing.
;	--------------------------------------------------------------------

MoveArray
;	Direction	Forward	Left	Right	Backward
;			X,Y	X,Y	X,Y	X,Y	
	dc.w	NORTH,	0,-1,	-1,0,	1,0,	0,1
	dc.w	EAST,	1,0,	0,-1,	0,1,	-1,0
	dc.w	SOUTH,	0,1,	1,0,	-1,0,	0,-1
	dc.w	WEST,	-1,0,	0,1,	0,-1,	1,0

;	====================================================================

CurrentMap
	dc.l	MapArray01	; This is ptr to change for level changes
	
;	--------------------------------------------------------------------

MapArray01
;	Offs    0,1,2,3,4,5,6,7,8,9,A,B,C,D,E

	dc.b	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1	; 0
	dc.b	1,0,0,0,0,0,0,0,0,0,0,0,0,0,1	; 1
	dc.b	1,0,1,1,1,0,1,1,1,1,0,0,0,0,1	; 2
	dc.b	1,0,0,0,0,0,1,0,0,1,0,0,0,0,1	; 3
	dc.b	1,0,1,1,0,1,1,0,0,1,1,1,0,1,1	; 4
	dc.b	1,0,0,1,0,1,0,0,0,1,0,0,0,0,1	; 5
	dc.b	1,0,0,0,0,0,0,0,0,1,0,0,0,0,1	; 6
	dc.b	1,0,0,0,0,0,1,1,1,1,1,0,0,0,1	; 7
	dc.b	1,0,0,0,0,0,0,1,0,0,1,1,0,1,1	; 8
	dc.b	1,0,0,1,0,1,0,1,0,0,1,0,0,0,1	; 9
	dc.b	1,0,1,1,0,1,0,0,0,0,1,0,1,0,1	; 10
	dc.b	1,0,0,0,0,1,0,1,0,0,1,0,0,0,1	; 11
	dc.b	1,0,0,0,1,1,0,1,0,0,0,0,1,0,1	; 12
	dc.b	1,0,0,0,1,0,0,1,0,0,0,0,0,0,1	; 13
	dc.b	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1	; 14
	even

;	====================================================================

CharSetData
	include	"DMFont.s"

;	====================================================================

GfxName	dc.b	'graphics.library',0
	even

;	====================================================================

GameColorTable
	dc.w	$000,$666,$888,$620
	dc.w	$0cc,$840,$080,$0c0
	dc.w	$f00,$fa0,$c86,$ff0
	dc.w	$444,$aaa,$00f,$fff

;	====================================================================

	SECTION	Gfx,DATA_C
	
CopperList
	Mov	$4200,bplcon0	; Lowres, Color Burst, 4 bitplanes
	Mov	$0000,bplcon1
	Mov	(NumPlanes-1)*BytesPerLine,bpl1mod
	Mov	(NumPlanes-1)*BytesPerLine,bpl2mod
	Mov	$38,ddfstrt	; PAL 320*256
	Mov	$D0,ddfstop
	Mov	$2C81,diwstrt
	Mov	$2CC1,diwstop
CopperListColors
	Mov	$0000,color00	; Monster, item and wall colors
	Mov	$0666,color01
	Mov	$0888,color02
	Mov	$0620,color03
	Mov	$00CC,color04
	Mov	$0840,color05
	Mov	$0080,color06
	Mov	$00C0,color07
	Mov	$0F00,color08
	Mov	$0FA0,color09
	Mov	$0C86,color10
	Mov	$0FF0,color11
	Mov	$0444,color12
	Mov	$0AAA,color13
	Mov	$000F,color14
	Mov	$0FFF,color15


CprSpr1
	Mov	0,spr0pth
	Mov	0,spr0ptl
CprSpr2
	Mov	0,spr1pth
	Mov	0,spr1ptl
CprSpr3
	Mov	0,spr2pth
	Mov	0,spr2ptl
CprSpr4
	Mov	0,spr3pth
	Mov	0,spr3ptl
CprSpr5
	Mov	0,spr4pth
	Mov	0,spr4ptl
CprSpr6
	Mov	0,spr5pth
	Mov	0,spr5ptl
CprSpr7
	Mov	0,spr6pth
	Mov	0,spr6ptl
CprSpr8
	Mov	0,spr7pth
	Mov	0,spr7ptl

CprPln1
	Mov	0,bpl1pth
	Mov	0,bpl1ptl
CprPln2
	Mov	0,bpl2pth
	Mov	0,bpl2ptl
CprPln3
	Mov	0,bpl3pth
	Mov	0,bpl3ptl
CprPln4
	Mov	0,bpl4pth
	Mov	0,bpl4ptl
;CprPln5
;	Mov	0,bpl5pth
;	Mov	0,bpl5ptl
;CprPln6
;	Mov	0,bpl6pth
;	Mov	0,bpl6ptl

	Wait	254,255		; Just to be safe, wait twice..
	Wait	254,255		; Just to be safe, wait twice..

;	====================================================================
;	The mouse pointer binary
;	--------------------------------------------------------------------

SpriteData
	dc.l	$9A88B700	; Control Data = ????
MouseData
	dc.l	$C0004000
	dc.l	$7000B000
	dc.l	$3C004C00
	dc.l	$3F004300
	dc.l	$1FC020C0
	dc.l	$1FC02000
	dc.l	$0F001100
	dc.l	$0D801280
	dc.l	$04C00940
	dc.l	$046008A0
	dc.l	$00200040,0,0

;	====================================================================
;	Various Miscellaneous Binaries:
;	--------------------------------------------------------------------

	incdir	'Programming:Assembler/'	; My current directory in which
						; the files reside...

; Keep in mind you may need to change the above path for where you have placed
; the binaries.. unless, this is the Aminet release..

ArrowsBin	incbin	"DMC_Arrows.bin"	; Movement arrows
BackGroundBin	incbin	"DMC_BackGrnd.bin"	; The background gfx
BackGroundMask	incbin	"DMC_BackGrndM.bin"

;	--------------------------------------------------------------------
;	Walls Front Layer:

WallN1_00Bin	incbin	"DMC_Wall_-1_0_.bin"
WallN1_00MBin	incbin	"DMC_Wall_-1_0_M.bin"
WallP1_00Bin	incbin	"DMC_Wall_1_0_.bin"
WallP1_00MBin	incbin	"DMC_Wall_1_0_M.bin"

;	--------------------------------------------------------------------
;	Walls 1st Layer:

WallN1_01Bin	incbin	"DMC_Wall_-1_1_.bin"
WallN1_01MBin	incbin	"DMC_Wall_-1_1_M.bin"
WallP1_01Bin	incbin	"DMC_Wall_1_1_.bin"
WallP1_01MBin	incbin	"DMC_Wall_1_1_M.bin"
Wall00_01Bin	incbin	"DMC_Wall_0_1_.bin"
Wall00_01MBin	incbin	"DMC_Wall_0_1_M.bin"

;	--------------------------------------------------------------------
;	Walls 2nd Layer:

WallN1_02Bin	incbin	"DMC_Wall_-1_2_.bin"
WallN1_02MBin	incbin	"DMC_Wall_-1_2_M.bin"
WallN2_02Bin	incbin	"DMC_Wall_-2_2_.bin"
WallN2_02MBin	incbin	"DMC_Wall_-2_2_M.bin"
WallP1_02Bin	incbin	"DMC_Wall_1_2_.bin"
WallP1_02MBin	incbin	"DMC_Wall_1_2_M.bin"

WallP2_02Bin	incbin	"DMC_Wall_2_2_.bin"
WallP2_02MBin	incbin	"DMC_Wall_2_2_M.bin"
Wall00_02Bin	incbin	"DMC_Wall_0_2_.bin"
Wall00_02MBin	incbin	"DMC_Wall_0_2_M.bin"

;	--------------------------------------------------------------------
;	Walls 3rd Layer:

WallN1_03Bin	incbin	"DMC_Wall_-1_3_.bin"
WallN1_03MBin	incbin	"DMC_Wall_-1_3_M.bin"
WallN2_03Bin	incbin	"DMC_Wall_-2_3_.bin"
WallN2_03MBin	incbin	"DMC_Wall_-2_3_M.bin"
WallP1_03Bin	incbin	"DMC_Wall_1_3_.bin"
WallP1_03MBin	incbin	"DMC_Wall_1_3_M.bin"
WallP2_03Bin	incbin	"DMC_Wall_2_3_.bin"
WallP2_03MBin	incbin	"DMC_Wall_2_3_M.bin"
Wall00_03Bin	incbin	"DMC_Wall_0_3_.bin"
Wall00_03MBin	incbin	"DMC_Wall_0_3_M.bin"
		incbin	"DMC_Wall_0_3_M.bin"	; Hmmm?
		incbin	"DMC_Wall_0_3_M.bin"
		incbin	"DMC_Wall_0_3_M.bin"



;	====================================================================
	END
