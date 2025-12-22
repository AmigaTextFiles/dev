**
** Generic Library Startup Code Version 1.0
** Written by Tom Bampton
**
** (c) Copyright 1998 Eden Developments
**     All Rights Reserved.
**
		
		section	code
		
		include	exec/types.i
		include exec/initializers.i
		include exec/libraries.i
		include exec/lists.i
		include exec/alerts.i
		include exec/resident.i
		include exec/memory.i
		include libraries/dos.i
		
		include exec/exec_lib.i
		
		include library.i
		
		IFND		LibraryBase_SIZEOF
		
		STRUCTURE	LibraryBase,LIB_SIZE
		UBYTE		lb_Flags
		UBYTE		lb_Pad
		ULONG		lb_SysLib
		ULONG		lb_DosLib
		ULONG		lb_SegList
		LABEL		LibraryBase_SIZEOF
		
		ENDC
		
Start		moveq	#-1,d0
		rts
		
RomTag:		dc.w	RTC_MATCHWORD
		dc.l	RomTag
		dc.l	EndCode
		dc.b	RTF_AUTOINIT
		dc.b	VERSION
		dc.b	NT_LIBRARY
		dc.b	0		; Priority
		dc.l	LibName
		dc.l	IDString
		dc.l	InitTable

; Names et al
LibName:	LIBRARYNAME
IDString:	VSTRING
dosName:	DOSNAME

; Force word alignment		
		ds.w	0
		
InitTable:	dc.l	LibraryBase_SIZEOF
		dc.l	funcTable
		dc.l	dataTable
		dc.l	initRoutine
		
funcTable:	dc.l	Open
		dc.l	Close
		dc.l	Expunge
		dc.l	Null
		
		; Library Routines, ended with -1
		include	functable.i
		
		dc.l	-1
		
dataTable:	INITBYTE	LN_TYPE,NT_LIBRARY
		INITLONG	LN_NAME,LibName
		INITBYTE	LIB_FLAGS,LIBF_SUMUSED|LIBF_CHANGED
		INITWORD	LIB_VERSION,VERSION
		INITWORD	LIB_REVISION,REVISION
		INITLONG	LIB_IDSTRING,IDString
		dc.l		0
		
initRoutine:	move.l	a5,-(sp)
		move.l	d0,a5
		move.l	a6,lb_SysLib(a5)
		move.l	a0,lb_SegList(a5)
		
		lea	dosName(pc),a1
		moveq	#0,d0
		jsr	_LVOOpenLibrary(a6)
		
		move.l	d0,lb_DosLib
		bne.s	.openedok
		ALERT	AG_OpenLib|AO_DOSLib
		
		IFD	EL_GIMMEINIT
		move.l	a5,d0
		move.l	lb_SegList(a5),a0
		bsr	UserInit
		ENDC
		
.openedok	move.l	a5,d0
		move.l	(sp)+,a5
		rts
		
; System Interface Commands

Open		addq.w	#1,LIB_OPENCNT(a6)
		bclr	#LIBB_DELEXP,lb_Flags(a6)
		IFD	EL_GIMMEOPEN
		bsr	UserOpen
		ENDC
		move.l	a6,d0
		rts
		
Close		moveq	#0,d0
		
		IFD	EL_GIMMECLOSE
		bsr	UserClose
		ENDC
		
		subq.w	#1,LIB_OPENCNT(a6)
		bne.s	.close
		
		btst	#LIBB_DELEXP,lb_Flags(a6)
		beq.s	.close
		
		bsr	Expunge
.close		rts

Expunge		movem.l	d2/a5/a6,-(sp)
		move.l	a6,a5
		move.l	lb_SysLib(a5),a6
		
		tst.w	LIB_OPENCNT(a5)
		beq.s	.nodelexp
		
		bset	#LIBB_DELEXP,lb_Flags(a5)
		moveq	#0,d0
		bra.s	.endexp

.nodelexp	move.l	lb_SegList(a5),d2
		move.l	a5,a1
		jsr	_LVORemove(a6)
		
		move.l	lb_DosLib(a5),a1
		jsr	_LVOCloseLibrary(a6)
		
		moveq	#0,d0
		move.l	a5,a1
		move.w	LIB_NEGSIZE(a5),d0
		
		sub.l	d0,a1
		add.w	LIB_POSSIZE(a5),d0
		jsr	_LVOFreeMem(a6)
		
		IFD	EL_GIMMEEXP
		move.l	a5,a6
		bsr	UserExpunge
		ENDC
		
		move.l	d2,d0
.endexp		movem.l	(sp)+,d2/a5/a6
		rts
		
Null		moveq	#0,d0
		rts
		
; Library Specific Functions

		include	functions.asm
		
EndCode		end
