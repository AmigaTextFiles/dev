
		Section	FixMfmDevice,Code

			Opt o+,d+,c-,ow2-

		Incdir	Inx:
		Include	LVO.Gs
		Include	Macros.I
		Include	Reqtools.I
		Include	Libraries/XfdMaster.I
		Include	Libraries/XfdMaster_Lib.I
		;Include	Libraries/Reqtools_Lib.I
		;Include	Libraries/PowerPacker_Lib.I


NastyPrint

;-------------------------------------------------------------
;Init regs
		Lea	Vars(PC),a5
		Move.l	4.w,a6
		Move.l	a6,_Execbase(a5)

;-------------------------------------------------------------
;Open libs
		Lea	RTName(PC),a1
		Moveq.l	#0,d0
		Call	OpenLibrary
		Move.l	d0,_RTBase(a5)
		Beq.b	NoReqTools

		Move.l	d0,a0
		Move.l	RT_DOSBase(a0),_DosBase(a5)

		Lea	XFDName(PC),a1
		Moveq.l	#0,d0
		Call	OpenLibrary
		Move.l	d0,_XFDBase(a5)

;------------------------------------------------------------

		Bsr.b	ReadFile
		Tst.l	d0
		Bne.b	.FileError

		Tst.l	_XFDBase(a5)
		Beq.b	.DontTryDecrunch
		Bsr	DecrunchFile
.DontTryDecrunch

;------------------------------------------------------------
;print file
		Bsr	FixFile
		Bsr	WriteFile
		Bsr	FreeFileMemory
.FileError


;------------------------------------------------------------
;close libs
		Move.l	_Execbase(a5),a6
		Tst.l	_XFDBase(a5)
		Beq.b	.DidntOpen
		Move.l	_XFDBase(a5),a1
		Call	CloseLibrary
.DidntOpen
		Move.l	_RTBase(a5),a1
		Call	CloseLibrary

NoReqTools	Move.l	_DosBase(a5),a1
		Call	CloseLibrary
		Moveq.l	#0,d0
NoDos		Rts

;-----------------------------------------------------------------------

		Include	Code:FixMFMDevice/ReadFile.s
		Include	Code:FixMFMDevice/DecrunchFile.s
		Include	Code:FixMFMDevice/FixFile.s
		Include	Code:FixMFMDevice/WriteFile.s
		Include	Code:FixMFMDevice/FreeFileMem.s
		Include	Code:FixMFMDevice/EasyRequestor.s

;-----------------------------------------------------------------------
DosName		dc.b	"dos.library",0
RTName		dc.b	"reqtools.library",0
XFDName		dc.b	"xfdmaster.library",0

DecrunchErrorTxt
		Dc.b	"Decrunch ERROR!",10
		Dc.b	"%s",0
OKText		Dc.b	"_Okay",0

PathNameBuffer	Dc.b	"DEVS:mfm.device",0
OldMfmName	Dc.b	"DEVS:mfm.device.old",0
		Even

EZReqTaglist	Dc.l	RT_ReqPos,ReqPos_Pointer
		Dc.l	RT_LockWindow,1
		Dc.l	RT_UnderScore,"_"
		Dc.l	RTEZ_Flags,EZReqF_CenterText
		Dc.l	Tag_End

		RsReset
_ExecBase	Rs.l	1
_DosBase	Rs.l	1
_RTBase		Rs.l	1
_XFDBase	Rs.l	1

PrintFVarStack	Rs.l	1
FilenamePtr	Rs.l	1

LoadAddr	Rs.l	1
LoadFilereqmem	Rs.l	1
EZReqMem	Rs.l	1
LoadFileSize	Rs.l	1
LoadBufferSize	Rs.l	1
MyXFDBufferInfo	Rs.l	1

VarsSize	Rs.b	0
Vars		Dcb.l	VarsSize,0
