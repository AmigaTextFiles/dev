
VERSION		EQU	1	; version
REVISION	EQU	4	; revision

		output	"libs:own.library"	; output name (if not implemented in your asm compiler
						; then manually copy the output file to your libs as
						; own.library)

		incdir	"ainc:"			; your OS include dir
		include	"exec/types.i"
		include	"exec/initializers.i"
		include	"exec/libraries.i"
		include	"exec/lists.i"
		include	"exec/resident.i"
		include	"lvo.i"			; you can just uncomment those xref's and link with
						; amiga.lib if you don't have lvo include
		incdir	""			; progdir:
		include	"own.i"

begin		moveq	#-1,d0			; If someone execute's this one...
		rts

; RTC_MATCHWORD indicates where RomTag-structure begins.
; Next there is poiter to the structure itself. This is meant to prevent
; interpreting any code as RomTag by mistake.

; RTF_AUTOINIT flag will make the Exec to do the initialization of jump tables for this library
; according to the tables below. (InitStuff)

ROMTag		dc.w	RTC_MATCHWORD		; UWORD RT_MATCHWORD
		dc.l	ROMTag			; APTR  RT_MATCHTAG
		dc.l	EndOfLib		; APTR  RT_ENDSKIP
		dc.b	RTF_AUTOINIT		; UBYTE RT_FLAGS
		dc.b	VERSION			; UBYTE RT_VERSION
		dc.b	NT_LIBRARY		; UBYTE RT_TYPE
		dc.b	0			; BYTE  RT_PRI
		dc.l	LibName			; APTR  RT_NAME
		dc.l	LibId			; APTR  RT_IDSTRING
		dc.l	InitStuff		; APTR  RT_INIT

LibName		LIBRARYNAME
LibId		dc.b	'Library Identification string 1.4 (dd.mm.yyyy)',13,10,0
		ds.w	0

InitStuff	dc.l	LibraryBase_SIZEOF	; Structure size
		dc.l	Functions		; Jump table address
		dc.l	LibBaseData		; Information for the initialization
		dc.l	InitRoutine		; Own initialization routine

Functions	dc.l	r_Open			; Open routine address
		dc.l	r_Close			; Close routine address
		dc.l	r_Expunge		; Expunge routine address
		dc.l	r_Null			; ** Reserved **
		dc.l	r_First			; First user routine address
		dc.l	-1			; Table ends

LibBaseData	INITBYTE	LN_TYPE,NT_LIBRARY
		INITLONG	LN_NAME,LibName
		INITBYTE	LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
		INITWORD	LIB_VERSION,VERSION
		INITWORD	LIB_REVISION,REVISION
		INITLONG	LIB_IDSTRING,LibId
		dc.l		0



InitRoutine	move.l	a5,-(sp)		; Save A5
		move.l	d0,a5			; Library Base address
		move.l	a6,libb_SysLib(a5)	; Store ExecBase to library data
		move.l	a0,libb_SegList(a5)	; Store SegList to library data

; If any other initialization operations are required put them here

		move.l	a5,d0			; Return the Base addres in D0
		move.l	(sp)+,a5		; Restore A5
		rts

r_Open		addq.w	#1,LIB_OPENCNT(a6)	; New user for this library so increase opencount
		bclr	#LIBB_DELEXP,libb_Flags(a6) ; ...Expunge is forbid
		move.l	a6,d0			; Return BASE address in D0
		rts

r_Close		moveq	#0,d0			; Return value
		subq.w	#1,LIB_OPENCNT(a6)	; Decrease open count
		bne.s	1$			; Is there any users?
		btst	#LIBB_DELEXP,libb_Flags(a6) ; No, so we test if there are delayed Expunge request?
		beq.s	1$
		bsr	r_Expunge		; Yes! so we jump to expunge
1$		rts				; Return where ever we were called from.

r_Expunge	movem.l	d2/a5-a6,-(sp)		; Save registers
		move.l	a6,a5			; Library base address
		move.l	libb_SysLib(a5),a6	; ExecBase
		tst.w	LIB_OPENCNT(a5)		; Library still having users?
		beq.s	1$
		bset	#LIBB_DELEXP,libb_Flags(a5) ; Yes! -> Delayed expunge
		moveq	#0,d0			; We return NULL
		movem.l	(sp)+,d2/a5-a6
		rts
1$		move.l	libb_SegList(a5),d2	; Save SegList-address to D2
		move.l	a5,a1
;		xref	_LVORemove		; And we remove the library...
		jsr	_LVORemove(a6)		; ... from the system list

; Any other clean up's needed? If so then do those here

		moveq	#0,d0			; clear D0
		move.l	a5,a1			; Library base
		move.w	LIB_NEGSIZE(a5),d0	; Library negative size
		sub.l	d0,a1			; Points at the start of memory block
		add.w	LIB_POSSIZE(a5),d0	; Add library positive size
;		xref	_LVOFreeMem		; And we...
		jsr	_LVOFreeMem(a6)		; ... free the memory
		move.l	d2,d0			; Restore SegList
		movem.l	(sp)+,d2/a5-a6
		rts

r_Null		moveq	#0,d0			; Reserved routine HAVE TO RETURN NULL IN D0
		rts

******* Here are the user library routines *******

r_First
;		movem.l	d2-d4/a2,-(sp)	; Save any Data/Address registers exept d0,d1,a0,a1
					; which can be altered freely
; Your routine code goes here

;		** Example code **

		FPU			; will enable floating point unit code generation

		fmove.l	d0,fp0		; example code will return squareroot of the LONG you passed to it
		fsqrt	fp0		; only the integerpart is returned!!
		fmove.l	fp0,d0		; as you can see we doesn't need to save those registers in this
					; example code because we doesn't use any of those registers!!

;		movem.l	(sp)+,d2-d4/a2	; Restore the saved registers
		rts

**************************************************

EndOfLib	cnop	0,2
end

