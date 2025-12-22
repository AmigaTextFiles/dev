			opt		c+,l-

	incdir	include/
	include	intuition/intuitionbase.i
	include	intuition/intuition.i

;******************************
;* Trace Open and LoadSeg		*
;* © J.Tyberghein 29 sep 89	*
;******************************

SysBase			equ	4
	;ExecBase routines
_LVOOldOpenLibrary	equ	-408
_LVOCloseLibrary		equ	-414
_LVOForbid				equ	-132
_LVOPermit				equ	-138
_LVOWaitPort			equ	-384
_LVOGetMsg				equ	-372
_LVOReplyMsg			equ	-378
	;DosBase routines
_LVOOpen					equ	-30
_LVOOutput				equ	-60
_LVOWrite				equ	-48
_LVOLoadSeg				equ	-150
	;IntuitionBase routines
_LVOOpenWindow			equ	-204
_LVOCloseWindow		equ	-72
_LVOSetWindowTitles	equ	-276
	;Graphics routines
_LVOText					equ	-60
_LVOMove					equ	-240
_LVOScrollRaster		equ	-396
_LVOSetAPen				equ	-342

CALLEXEC	macro
			move.l (SysBase).w,a6
			jsr _LVO\1(a6)
			endm

CALLGRAF	macro
			move.l GfxBase,a6
			jsr _LVO\1(a6)
			endm

CALLINT	macro
			move.l IntBase,a6
			jsr _LVO\1(a6)
			endm

CALLDOS	macro
			move.l DosBase,a6
			jsr _LVO\1(a6)
			endm

	;*** Start code ***

		move.l	a0,ComLin
		move.l	d0,ComLinLen
	;DosLibrary
		lea		DosLib,a1
		CALLEXEC	OldOpenLibrary
		move.l	d0,DosBase
	;IntuitionLibrary
		lea		IntLib,a1
		CALLEXEC	OldOpenLibrary
		move.l	d0,IntBase
	;GfxLibrary
		lea		GfxLib,a1
		CALLEXEC	OldOpenLibrary
		move.l	d0,GfxBase

	;Get current OutputHandle
		CALLDOS	Output
		move.l	d0,OutputHandle

	;Check arguments
		move.b	#0,SmallWin
		lea		NWin,a0
		move.w	#300,nw_Width(a0)
		cmp.l		#3,ComLinLen
		blt.s		NoSmallWin
		move.w	#350,nw_Width(a0)
		move.l	ComLin,a0
		cmp.b		#'s',2(a0)
		bne.s		ErrorArg
		move.b	#1,SmallWin
		lea		NWin,a0
		move.w	#10,nw_Height(a0)
		move.l	#0,nw_FirstGadget(a0)
NoSmallWin:
		move.l	ComLin,a0
		cmp.b		#'o',(a0)
		beq.s		OpenTrace
		cmp.b		#'l',(a0)
		beq.s		LoadSegTrace
ErrorArg:
		move.l	OutputHandle,d1
		move.l	#UsageString,d2
		move.l	#UsageStringLen,d3
		CALLDOS	Write
		bra		ErrorOW
OpenTrace:
		move.l	#_LVOOpen,Offset
		move.l	#WoTitle,WinTitle
		move.l	#-1,DosNum
		bra.s		Continue
LoadSegTrace:
		move.l	#_LVOLoadSeg,Offset
		move.l	#WlTitle,WinTitle
		move.l	#-19,DosNum

Continue:
		tst.b		SmallWin
		beq.s		NoSmW
		move.l	#0,WinTitle
NoSmW:
		bsr		OpenWin
		tst.l		d0
		beq		ErrorOW

	;Install Patch
		CALLEXEC	Forbid
		move.l	DosBase,a0
		move.l	Offset,d0
		move.w	(a0,d0),SaveSetF
		move.l	2(a0,d0),SaveSetF+2
		move.w	#$4ef9,(a0,d0)
		move.l	#Patch,2(a0,d0)
		move.l	DosBase,d0
		add.l		#$4e,d0
		move.l	d0,LabelJmp+2
		CALLEXEC	Permit

	;Wait for windowclose or gadget
WaitUser:
		move.l	UserPort,a0
		CALLEXEC	WaitPort
		move.l	UserPort,a0
		CALLEXEC	GetMsg
		move.l	d0,a0
		move.l	im_Class(a0),d2
		move.w	im_Code(a0),d3
		move.l	a0,a1
		CALLEXEC	ReplyMsg
		and.l		#MOUSEBUTTONS,d2
		beq.s		TheEnd
		cmp.w		#MENUUP,d3
		bne.s		WaitUser
	;The user pressed the right mouse button, so move the window to the first screen
		move.l	Win,a0
		CALLINT	CloseWindow
		bsr		OpenWin
		tst.l		d0
		bne.s		WaitUser
		bsr		EndPatch
		bra.s		ErrorOW

TheEnd:
		bsr		EndPatch
		move.l	Win,a0
		CALLINT	CloseWindow

ErrorOW:
		move.l	GfxBase,a1
		CALLEXEC	CloseLibrary
		move.l	DosBase,a1
		CALLEXEC	CloseLibrary
		move.l	IntBase,a1
		CALLEXEC	CloseLibrary
		rts

	;*** Restore patch ***
EndPatch:
		CALLEXEC	Forbid
		move.l	DosBase,a0
		move.l	Offset,d0
		move.w	SaveSetF,(a0,d0)
		move.l	SaveSetF+2,2(a0,d0)
		CALLEXEC	Permit
		rts

	;*** Open window on first screen ***
	;-> d0 = 0 if error
	;***
OpenWin:
		move.l	IntBase,a1
		lea		NWin,a0
		move.l	ib_FirstScreen(a1),nw_Screen(a0)
		move.l	WinTitle,nw_Title(a0)
		CALLINT	OpenWindow
		tst.l		d0
		beq.s		ErrorOWi
		move.l	d0,Win
		move.l	d0,a0
		move.l	wd_RPort(a0),rp
		move.l	wd_UserPort(a0),UserPort
		moveq		#1,d0
ErrorOWi:
		rts

	;*** New patch function ***
	;Print file name
	;***
Patch:
		movem.l	a6/d1-d5,-(a7)
		tst.b		SmallWin
		bne.s		SkipDraw
		move.l	d1,-(a7)				;We have a large window
		move.l	rp,a1
		moveq		#0,d0
		moveq		#10,d1
		moveq		#2,d2
		moveq		#12,d3
		move.l	#286,d4
		move.l	#51,d5
		CALLGRAF	ScrollRaster		;Scroll window one line up
		move.l	rp,a1
		moveq		#1,d0					;White
		CALLGRAF	SetAPen
		move.l	rp,a1
		moveq		#10,d0
		moveq		#0,d1
		move.w	#50,d1
		CALLGRAF	Move
		move.l	(a7)+,d1				;Restore string ptr (argument in d1)
		move.l	rp,a1
		move.l	d1,a0
		bsr		StrLen
		cmp.l		#34,d0
		ble.s		AllRight
		moveq		#34,d0
AllRight:
		move.l	d1,a0
		CALLGRAF	Text
		bra.s		ContPatch
SkipDraw:
		move.l	Win,a0
		moveq		#32,d0
		move.l	d1,a1
		lea		String,a2
LoopSWT:
		move.b	(a1),(a2)+
		tst.b		(a1)+
		beq.s		TheEndSWT
		subq.l	#1,d0
		bne.s		LoopSWT
		move.b	#0,(a2)+
TheEndSWT:
		lea		String,a1
		move.l	#0,a2
		CALLINT	SetWindowTitles
ContPatch:
		movem.l	(a7)+,a6/d1-d5
		move.l	DosNum,d0
LabelJmp:
		jmp		$00000000

	;*** String length ***
	;a0 = string address
	;-> d0 = length
	;***
StrLen:
		moveq		#-1,d0
LoopSL:
		addq.l	#1,d0
		tst.b		(a0)+
		bne.s		LoopSL
		rts

	EVEN
DosBase:			dc.l	0
IntBase:			dc.l	0
GfxBase:			dc.l	0
	;Old SetFunction address
SaveSetF:		dc.w	0
					dc.l	0
rp:				dc.l	0				;RastPort
Win:				dc.l	0				;Window
UserPort:		dc.l	0				;Window user port
OutputHandle:	dc.l	0
Offset:			dc.l	0				;Offset of function
WinTitle:		dc.l	0				;Current window title
DosNum:			dc.l	0				;Number for dos.library (intern)
ComLin:			dc.l	0				;Address of arguments to this command
ComLinLen:		dc.l	0				;Length of argumentstring
SmallWin:		dc.b	0				;1 if a small window is required

String:			ds.b	35				;Space for windowtitle


	;Library names
DosLib:			dc.b	"dos.library",0
IntLib:			dc.b	"intuition.library",0
GfxLib:			dc.b	"graphics.library",0

WoTitle:			dc.b	"Open trace",0
WlTitle:			dc.b	"LoadSeg trace",0

UsageString:	dc.b	"Usage: Trace o | l [s]",10,0
UsageStringLen	equ	*-UsageString

	EVEN
	;Window
NWin:
		dc.w		0,0,300,58
		dc.b		2,1
		dc.l		CLOSEWINDOW+MOUSEBUTTONS
		dc.l		WINDOWDEPTH+WINDOWDRAG+WINDOWCLOSE+RMBTRAP+REPORTMOUSE
		dc.l		0
		dc.l		0
		dc.l		0
		dc.l		0,0
		dc.w		0,0,0,0
		dc.w		CUSTOMSCREEN

	END


