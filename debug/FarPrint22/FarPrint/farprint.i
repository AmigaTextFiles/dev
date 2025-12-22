*
* Macro package to use FarPrint from within assembler programs
*

* Commands for FarPrint

FM_ADDTXT	EQU	0
FM_REQTXT	EQU	1
FM_REQNUM	EQU	2

* SendText <'format string'>,arg1,arg2,...,arg9
*
*	Builds an argument string and passes it to SendIt()

SendText	MACRO
	IFD FARPRINT				; only if FARPRINT set
	NOLIST
	IFGE	NARG-1				; any args ?
		movem.l	d0-d7/a0-a6,-(sp)	; save all regs
; first stack up to eight arguments for the SendText routine
	IFGE	NARG-9
		LIST
		move.l	\9,-(sp)		; stack arg8
		NOLIST
	ENDC
	IFGE	NARG-8
		LIST
		move.l	\8,-(sp)		; stack arg7
		NOLIST
	ENDC
	IFGE	NARG-7
		LIST
		move.l	\7,-(sp)		; stack arg6
		NOLIST
	ENDC
	IFGE	NARG-6
		LIST
		move.l	\6,-(sp)		; stack arg5
		NOLIST
	ENDC
	IFGE	NARG-5
		LIST
		move.l	\5,-(sp)		; stack arg4
		NOLIST
	ENDC
	IFGE	NARG-4
		LIST
		move.l	\4,-(sp)		; stack arg3
		NOLIST
	ENDC
	IFGE	NARG-3
		LIST
		move.l	\3,-(sp)		; stack arg2
		NOLIST
	ENDC
	IFGE	NARG-2
		LIST
		move.l	\2,-(sp)		; stack arg1
		NOLIST
	ENDC
; Now the actual SendText call itself, only if there is an argument string
STKOFF	SET	NARG<<2				; actual stack space used
		LIST
		pea.l	str\@			; push format string address
		jsr	_SendText#		; call SendText function
		lea.l	STKOFF(sp),sp		; scrap stuff on stack
		bra	skip\@

str\@		dc.b	\1,0			; the actual string
		CNOP	0,2

skip\@		movem.l	(sp)+,d0-d7/a0-a6	; restore all regs
	ENDC
	LIST
	ENDC					; end FARPRINT conditional
	ENDM

* RequestString <'identifier string'>,buffer
*
*	Requests a string to be entered by the user.
*	Identifier points to a string which is to
*	identify the calling process.

RequestString	MACRO
	IFD FARPRINT				; only if FARPRINT set
	NOLIST
	IFEQ	NARG-2				; two args ?
		LIST
		movem.l	d1-d7/a0-a6,-(sp)	; save all regs
		move.w	#FM_REQTXT,-(sp)	; push command
		pea.l	str\@			; push identifier address
		move.l	\2,-(sp)		; push buffer address
		jsr	_SendIt#		; call SendIt function
		add.w	#10,sp			; scrap stuff on stack
		bra	skip\@

str\@		dc.b	\1,0			; the actual string
		CNOP	0,2

skip\@		movem.l	(sp)+,d1-d7/a0-a6	; restore all regs
	ENDC
	LIST
	ENDC					; end FARPRINT conditional
	ENDM

* RequestNumber <'identifier string'>
*
*	Requests a number to be entered by the user.
*	Identifier points to a string which is to
*	identify the calling process.

RequestNumber	MACRO
	IFD FARPRINT				; only if FARPRINT set
	NOLIST
	IFEQ	NARG-1				; one arg ?
		LIST
		movem.l	d1-d7/a0-a6,-(sp)	; save all regs
		move.w	#FM_REQNUM,-(sp)	; push command
		pea.l	str\@			; push identifier address
		clr.l	-(sp)			; push buffer address
		jsr	_SendIt#		; call SendIt function
		add.w	#10,sp			; scrap stuff on stack
		bra	skip\@

str\@		dc.b	\1,0			; the actual string
		CNOP	0,2

skip\@		movem.l	(sp)+,d1-d7/a0-a6	; restore all regs
	ENDC
	LIST
	ENDC					; end FARPRINT conditional
	ENDM

* AllocMem <'identifier string'>
*
*	Call AllocMem() and send address of memory block, size and memory
*	attributes to FarPrint.
*	Identifier points to a string which is to
*	identify the calling process.

AllocMem	MACRO
	IFNE	NARG-1				; one arg ?
		FAIL	'Invalid num of arguments for AllocMem'
	ELSE
	IFD MEMWATCH				; only if MEMWATCH set
		movem.l	d2-d3,-(sp)		; save regs

		move.l	d0,d2			; save size
		move.l	d1,d3			; save attr
		jsr	_LVOAllocMem#(a6)

		movem.l	d0-d7/a0-a6,-(sp)	; save all regs
		move.l	d0,-(sp)		; push mem ptr
		move.l	d3,-(sp)		; push attr
		move.l	d2,-(sp)		; push size
		pea.l	str\@			; push string address
		jsr	_SendText#		; call SendText function
		add.w	#16,sp			; scrap stuff on stack
		bra	skip\@

str\@		dc.b	\1,' : AllocMem(size=%ld, attr=$%lx)=$%lx',0	; the actual string
		CNOP	0,2

skip\@		movem.l	(sp)+,d0-d7/a0-a6	; restore all regs
		movem.l	(sp)+,d2-d3		; restore regs
	ELSE					; else MEMWATCH conditional
		jsr	_LVOAllocMem#(a6)
	ENDC					; end MEMWATCH conditional
	ENDC
	ENDM

* FreeMem <'identifier string'>
*
*	Call FreeMem() and send address of memory block and size to FarPrint.
*	Identifier points to a string which is to
*	identify the calling process.

FreeMem		MACRO
	IFNE	NARG-1				; one arg ?
		FAIL	'Invalid num of arguments for FreeMem'
	ELSE
	IFD MEMWATCH				; only if MEMWATCH set
		movem.l	d0-d7/a0-a6,-(sp)	; save all regs
		move.l	d0,-(sp)		; push size
		move.l	a1,-(sp)		; push ptr
		pea.l	str\@			; push string address
		jsr	_SendText#		; call SendText function
		add.w	#12,sp			; scrap stuff on stack
		bra	skip\@

str\@		dc.b	\1,' : FreeMem(ptr=$%lx, size=%ld)',0	; the actual string
		CNOP	0,2

skip\@		movem.l	(sp)+,d0-d7/a0-a6	; restore all regs
	ENDC					; end MEMWATCH conditional

		jsr	_LVOFreeMem#(a6)

	ENDC
	ENDM
