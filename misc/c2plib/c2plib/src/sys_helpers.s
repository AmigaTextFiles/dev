; system helpers functions, avoid linking amiga libs

	MACHINE	68020

	XDEF       _SYS_AddTail
	XDEF       _SYS_AllocMem
	XDEF       _SYS_CloseLibrary
	XDEF       _SYS_DisownBlitter
	XDEF       _SYS_FreeMem
	XDEF       _SYS_InitBitMap
	XDEF       _SYS_OpenLibrary
	XDEF       _SYS_OwnBlitter
	XDEF       _SYS_Remove
	XDEF       _SYS_WaitBlit

pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM




	section    code





; SYS_AddTail
; Append node to tail of a list
; a0 = list
; a1 = node
	public	_SYS_AddTail
	cnop	0,4
_SYS_AddTail:
	push.l	a6
	move.l	4,a6
	jsr		_LVOAddTail(a6)
	pop.l	a6
	rts





; SYS_AllocMem
; Allocate memory given certain requirements
; d0 = byte size
; d1 = attributes
	public	_SYS_AllocMem
	cnop	0,4
_SYS_AllocMem:
	push.l	a6
	move.l	4,a6
	jsr		_LVOAllocMem(a6)
	pop.l	a6
	rts





; SYS_CloseLibrary
; Conclude access to a library
; a1 = library
	public	_SYS_CloseLibrary
	cnop	0,4
_SYS_CloseLibrary:
	push.l	a6
	move.l	4,a6
	jsr		_LVOCloseLibrary(a6)
	pop.l	a6
	rts





; SYS_DisownBlitter
; Return blitter to free state.
; a6 = gfx base
	public	_SYS_DisownBlitter
	cnop	0,4
_SYS_DisownBlitter:
	jsr		_LVODisownBlitter(a6)
	rts





; SYS_FreeMem
; Deallocate with knowledge
; a1 = memory block
; d0 = byte size
	public	_SYS_FreeMem
	cnop	0,4
_SYS_FreeMem:
	push.l	a6
	move.l	4,a6
	jsr		_LVOFreeMem(a6)
	pop.l	a6
	rts





; SYS_InitBitMap
; Initialize bit map structure with input values.
; a0 = bitmap
; d0 = depth
; d1 = width
; d2 = height
; a6 = gfx base
	public	_SYS_InitBitMap
	cnop	0,4
_SYS_InitBitMap:
	push.l	d2
	jsr		_LVOInitBitMap(a6)
	pop.l	d2
	rts





; SYS_OpenLibrary
; Gain access to a library
; a1 = lib name
; d0 = version
	public	_SYS_OpenLibrary
	cnop	0,4
_SYS_OpenLibrary:
	push.l	a6
	move.l	4,a6
	jsr		_LVOOpenLibrary(a6)
	pop.l	a6
	rts





; SYS_OwnBlitter
; Get the blitter for private usage.
; a6 = gfx base
	public	_SYS_OwnBlitter
	cnop	0,4
_SYS_OwnBlitter:
	jsr		_LVOOwnBlitter(a6)
	rts





; SYS_Remove
; Remove a node from a list
; a1 = node
	public	_SYS_Remove
	cnop	0,4
_SYS_Remove:
	push.l	a6
	move.l	4,a6
	jsr		_LVORemove(a6)
	pop.l	a6
	rts





; SYS_WaitBlit
; Wait for the blitter to be finished before proceeding with anything else.
; a6 = gfx base
	public	_SYS_WaitBlit
	cnop	0,4
_SYS_WaitBlit:
	jsr		_LVOWaitBlit(a6)
	rts



	end

