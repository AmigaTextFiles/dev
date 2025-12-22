	BOPT	uo+

*************************************
* IDString, Name, Version der Library

IDSTRING	macro
		dc.b	"SettingsWindow.mcc 1.00 (19.07.98) ©1997 Ingo Weinhold",0
	endm

LIBNAME	macro
		dc.b	"SettingsWindow.mcc",0
	endm

Version	equ	0
Revision	equ	40
Pri		equ	0
*************************************



	INCDIR	"tool:Barfly/include_i/"
	INCLUDE	"exec/types.i"
	INCLUDE	"exec/initializers.i"
	INCLUDE	"exec/libraries.i"
	INCLUDE	"exec/lists.i"
	INCLUDE	"exec/nodes.i"
	INCLUDE	"exec/resident.i"
	INCLUDE	"exec/alerts.i"
	INCLUDE	"libraries/dos.i"

CALLSYS	macro
		jsr _LVO\1(a6)
	endm

XLIB		macro
		XREF	_LVO\1
	endm


	STRUCTURE	MyLib,LIB_SIZE
		ULONG	ml_SysLib
*		ULONG	ml_DosLib
		ULONG	ml_SegList
		UBYTE	ml_Flags
		UBYTE	ml_pad
		LABEL	MyLib_Sizeof


	XLIB	OpenLibrary
	XLIB	CloseLibrary
	XLIB	FreeMem
	XLIB	Remove
	XLIB	Alert



Start:
	moveq		#0,d0
	rts



Resident:
	dc.w	RTC_MATCHWORD
	dc.l	Resident
	dc.l	CodeEnde
	dc.b	RTF_AUTOINIT
	dc.b	Version
	dc.b	NT_LIBRARY
	dc.b	Pri
	dc.l	LibName
	dc.l	IDString
	dc.l	Init

LibName:		LIBNAME

IDString:	dc.b "$VER: "
				IDSTRING
				ds.w	0


Init:
	dc.l	MyLib_Sizeof
	dc.l	FuncTable
	dc.l	DataTable
	dc.l	InitRoutine


FuncTable:
;	Sys-Routinen

	dc.l	Open
	dc.l	Close
	dc.l	Expunge
	dc.l	Null

;	eigene Routinen

	dc.l	MCC_GetClass
	dc.l	-1



DataTable:
	INITBYTE	LH_TYPE,NT_LIBRARY
	INITLONG	LN_NAME,LibName
	INITBYTE	LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
	INITWORD	LIB_VERSION,Version
	INITWORD	LIB_REVISION,Revision
	INITLONG	LIB_IDSTRING,IDString
	dc.l	0


;>= D0 = Zeiger auf Lib-Struktur
;>= A0 = Zeiger auf SegList der Library
;>= A6 = ExecBase

;=> D0 = Zeiger auf Lib-Struktur

InitRoutine:
	move.l	a5,-(a7)
	move.l	d0,a5
	move.l	a6,ml_SysLib(a5)
	move.l	a0,ml_SegList(a5)

	XREF		_MCC_Init

	move.l	a5,a6
	jsr		_MCC_Init
	tst.l		d0
	bne.s		2$

	move.l	a5,d0
	bra.s		1$
2$:
	clr.l		d0
1$:
	move.l	ml_SysLib(a5),a6
	move.l	(a7)+,a5
	rts


;>= A6 = Zeiger auf Lib-Struktur

;>= D0 = Zeiger auf Lib-Struktur


Open:
	addq.w	#1,LIB_OPENCNT(a6)
	bclr		#LIBB_DELEXP,ml_Flags(a6)
	move.l	a6,d0
	rts


Close:
	clr.l		d0
	subq.w	#1,LIB_OPENCNT(a6)
	bne.s		1$
	btst		#LIBB_DELEXP,ml_Flags(a6)
	beq.s		1$
	bsr		Expunge
1$:
	rts


;>= A6 = Zeiger auf Library

;=> D0 = Zeiger auf SegList der Library

Expunge:
	movem.l	d2/a5-a6,-(a7)
	move.l	a6,a5
	tst.w		LIB_OPENCNT(a5)
	beq.s		1$
	bset		#LIBB_DELEXP,ml_Flags(a5)
	clr.l		d0
	bra.s		Expunge_end

1$:
	XREF		_MCC_Cleanup
	jsr		_MCC_Cleanup

	move.l	ml_SysLib(a5),a6
	move.l	ml_SegList(a5),d2
	move.l	a5,a1
	CALLSYS	Remove

*	move.l	ml_DosLib(a5),a1
*	CALLSYS	CloseLibrary
	clr.l		d0
	move.l	a5,a1
	move.w	LIB_NEGSIZE(a5),d0
	sub.l		d0,a1
	add.w		LIB_POSSIZE(a5),d0
	CALLSYS	FreeMem
	move.l	d2,d0

Expunge_end:
	movem.l	(a7)+,d2/a5-a6
	rts


Null:
	moveq		#0,d0
	rts



	XREF		_MCC_GetClass
MCC_GetClass:
	jsr		_MCC_GetClass
	rts


CodeEnde:

	END

