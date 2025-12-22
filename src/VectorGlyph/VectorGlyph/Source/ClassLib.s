******************************************************************************
*
* $VER: ClassLib.asm (5.9.97)
*
* Copyright (C) 1995,96,97 by Bernardo Innocenti
*
******************************************************************************
*
* This source is based on the RomTag.asm source I've found somewhere :-)
*
*
	INCLUDE "exec/types.i"
	INCLUDE "exec/macros.i"
	INCLUDE "exec/libraries.i"
	INCLUDE "exec/lists.i"
	INCLUDE "exec/alerts.i"
	INCLUDE "exec/initializers.i"
	INCLUDE "exec/resident.i"
	INCLUDE "exec/execbase.i"
	INCLUDE "libraries/dos.i"

	INCLUDE "exec/funcdef.i"
	INCLUDE "exec/exec_lib.i"


; BOOPSI class libraries should use this structure as the base for their
; library data.  This allows developers to obtain the class pointer for
; performing object-less inquiries.

	STRUCTURE ClassBase,0
	STRUCT	 cl_Lib,LIB_SIZE	; Embedded library
	UWORD	 cl_Pad			; Align the structure
	APTR	 cl_Class		; Class pointer
	APTR	 cl_SegList		; SegList pointer
	LABEL	 ClassLibrary_SIZEOF

;---------------------------------------------------------------------------

	XDEF	_LibFuncTable
	XDEF	_LibDataTable

	XREF	_LibName
	XREF	_LibId
	XREF	__UserLibInit
	XREF	__UserLibCleanup

	XREF	__GetEngine

;---------------------------------------------------------------------------

	SECTION	Code

; First executable location, must return an error to the caller

	moveq   #-1,d0
	rts

;---------------------------------------------------------------------------

_ROMTAG:
	DC.W	RTC_MATCHWORD	; UWORD RT_MATCHWORD
	DC.L	_ROMTAG		; APTR  RT_MATCHTAG
	DC.L	_ENDCODE	; APTR  RT_ENDSKIP
	DC.B	RTF_AUTOINIT	; UBYTE RT_FLAGS
	DC.B	LIBVERSION	; UBYTE RT_VERSION
	DC.B	NT_LIBRARY	; UBYTE RT_TYPE
	DC.B	0		; BYTE  RT_PRI	<--- WARNING: Using negative values here will cause trouble!
	DC.L	_LibName	; APTR  RT_NAME
	DC.L	_LibId		; APTR  RT_IDSTRING
	DC.L	_LibInitTable	; APTR  RT_INIT


* The RomTag specified that we were RTF_AUTOINIT. This means that rt_Init
* points to the table below. (Without RTF_AUTOINIT it would point to a
* routine to run.)
*
* Our library base is a standard struct Library, followed by a WORD
* pad, a pointer to the boopsi Class structure of the external
* boopsi class and a pointer to our SegList.  The SegList pointer
* will be returned by LibExpunge() in order to have our code UnloadSeg()'ed
* The Class pointer will be initialized by UserLibInit().

_LibInitTable:
	dc.l	ClassLibrary_SIZEOF
	dc.l	_LibFuncTable
	dc.l	_LibDataTable
	dc.l	_LibInit



* Table of functions included in this library; the first 4 are the same
* for any library and for internal Exec use only.


_LibFuncTable:
	dc.l	_LibOpen
	dc.l	_LibClose
	dc.l	_LibExpunge
	dc.l	_LibExtFunc
	dc.l	__GetEngine
	dc.l	-1

;V_DEF	MACRO
;	dc.w	\1 + (* - _LibFuncTable)
;	ENDM
;
;_LibFuncTable:
;	dc.w	-1		; It's weird: the cool way didn't work for me :-(
;	V_DEF	_LibOpen
;	V_DEF	_LibClose
;	V_DEF	_LibExpunge
;	V_DEF	_LibExtFunc
;	V_DEF	__GetEngine
;	dc.w	-1



_LibDataTable
	INITBYTE	LN_TYPE,NT_LIBRARY
	INITLONG	LN_NAME,_LibName
	INITBYTE	LN_PRI,-5
	INITBYTE	LIB_FLAGS,(LIBF_SUMUSED!LIBF_CHANGED)
	INITWORD	LIB_VERSION,LIBVERSION
	INITWORD	LIB_REVISION,LIBREVISION
	INITLONG	LIB_IDSTRING,_LibId
	dc.w		0


	CNOP	0,4


* The following function will be called at startup time.
*
* Inputs:
*	LibPtr (d0) - Pointer to the library base, initialized due to the
* 			specifications in DataTable
* 	SegList (a0) - BPTR to the segment list
* 	_SysBase (a6) - The usual ExecBase pointer
*
* Result:
*	LibPtr, if all was okay and the library may be linked into the
* 	system library list. NULL otherwise.
*
_LibInit:
	move.l	d0,a1
	move.l	a0,cl_SegList(a1)		; Save SegList

; Check CPU for 68020 or better
	IFD		_MC68020_
	move.w	AttnFlags(a6),d1
	btst.w	#AFB_68020,d1
	beq.s	fail$
	ENDC

	move.l	a6,-(sp)			; Save SysBase
	move.l	d0,a6				; Put our base in a6
	jsr	__UserLibInit			; Call user init
	move.l	a6,a1				; save our base to a1
	move.l	(sp)+,a6			; Retrieve SysBase
	tst.l	d0
	beq.s	fail$
	rts

fail$
	bsr	FreeBase			; Free library base
	moveq	#0,d0
	rts


* The following functions are called from exec.library/OpenLibrary(),
* exec.library/CloseLibrary() and exec.library/ExpungeLibrary(),
* respectively. Exec passes our library base pointer in A6.
*
* Task switching will be turned off while these functions are being
* executed, so they must be as short as possible.  As the data inside
* the library base is protected with Forbid(), these functions must
* not make calls which would explicitly or implicitly turn on multitasking.
* This includes opening other disk based libraries.  The problem may be
* overcame by protecting the library base with a SignalSemaphore.
*


* This function is called from exec.library/OpenLibrary().
*
* Inputs:
*	LibPtr (a6) - Pointer to the library base
*	Version (d0) - The suggested version number
*
* Result:
*	LibPtr, if successful, NULL otherwise
*

_LibOpen:
	addq.w	#1,LIB_OPENCNT(a6)
	bclr.b	#LIBB_DELEXP,LIB_FLAGS(a6)	; Prevent delayed expunge
	move.l	a6,d0
	rts



* This function is called from exec/CloseLibrary().
*
* Inputs:
*	LibPtr (A6) - pointer to the library base as returned from OpenLibrary().
*
* Result:
*	Segment list of the library (see arguments of _LibInit), if there
* 	was a delayed expunge and the library is no longer open, NULL
* 	otherwise.
*
_LibClose:
	subq.w	#1,LIB_OPENCNT(a6)
	tst.w	LIB_OPENCNT(a6)
	bne.s	.NoExpunge
	btst.b	#LIBB_DELEXP,LIB_FLAGS(a6)
	beq.s	.NoExpunge

	bra.s	_LibExpunge

.NoExpunge
	moveq.l	#0,d0
	rts



* This function is called from exec.library/RemoveLibrary().
*
* Inputs:
*	LibPtr (A6) - pointer to the library base.
*
* Result:
*	Segment list of the library (see arguments of _LibInit()),
*	if the library isn't opened currently, NULL otherwise.
*

_LibExpunge:

	; Flag library base for delayed expunge
	bset.b	#LIBB_DELEXP,LIB_FLAGS(a6)
	tst.w	LIB_OPENCNT(a6)		; Only expunge if OpenCnt == 0
	bne.s	.DoNotExpunge

.NotOpen

	jsr	__UserLibCleanup	; Call user cleanup code
	tst.l	d0
	beq.s	.DoNotExpunge

	move.l	cl_SegList(a6),-(sp)	; Save SegList pointer

	move.l	a6,a1
	REMOVE				; Remove us from Exec library list.


; Free the library base

	move.l	a6,a1			; LibBase
	move.l	a6,-(sp)		; Save A6
	move.l	4.w,a6			; Load SysBase
	bsr		FreeBase		; Free our library base
	move.l	(sp)+,a6		; Restore A6

	move.l	(sp)+,d0		; Return our SegList
	rts

.DoNotExpunge

; NOTE: I'm falling in _LibExtFunc from here!



* Dummy function to return 0

_LibExtFunc:
	moveq	#0,d0
	rts


* Frees our library base
*
* Inputs:
*	LibBase (a1) - Pointer to Library structure.
*	SysBase (a6) - Pointer to SysBase
*
FreeBase:
	moveq.l	#0,d0
	move.l	a1,a0
	move.w	LIB_NEGSIZE(a0),d0
	suba.l	d0,a1			; Get pointer to real start of library base
	add.w	LIB_POSSIZE(a0),d0	; Total library size (LIB_POSSIZE + LIB_NEGSIZE)
	jsr		_LVOFreeMem(a6)
	rts

;-----------------------------------------------------------------------

_ENDCODE

	END
