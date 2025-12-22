
;---;  memory.r  ;--------------------------------------------------------------
*
*	****	MEMORY HANDLING ROUTINES    ****
*
*	Author		Stefan Walter
*	Version		1.01
*	Last Revision	04.09.92
*	Identifier	mem_defined
*       Prefix		mem_	(memory)
*				 ¯¯¯
*	Functions	AllocMemory, FreeMemory, FreeAllMemory, EnchainMemory
*			(AllocEMemory, FreeEMemory, FreeEAllMemory)
*
*	Flags		mem_SMARTASS set 1 if the additional routines required
*
;------------------------------------------------------------------------------

;------------------
	ifnd	mem_defined
mem_defined	=1

;------------------
mem_oldbase	equ __base
	base	mem_base
mem_base:

;------------------
	ifd	mem_SMARTASS

;------------------

;------------------------------------------------------------------------------
*
* AllocEMemory	Allocate memory and link it to a given list list of memory
*		blocks.
*
* INPUT:	d0	Number of bytes to allocate
*		d1	Requirements
*		a0	Pointer to anchor containing the list pointer
*
* RESULT:	d0	Address of memory or zero if not available
*
;------------------------------------------------------------------------------

;------------------
AllocEMemory:

;------------------
; Set anchor, Allocate and reload anchor.
;
\start:
	pea	AllocMemory(pc)
	bsr	mem_MultiList
	addq.l	#4,sp
	rts

mem_MultiList:
	move.l	a1,-(sp)
	lea	mem_anchor(pc),a1
	move.l	(a1),-(sp)
	move.l	(a0),(a1)
	pea	\return
	move.l	-16(sp),-(sp)

\return:
	move.l	(a1),(a0)
	move.l	(sp)+,(a1)
	move.l	(sp)+,a1
	rts

;------------------
	
;------------------------------------------------------------------------------
*
* FreeEMemory	Free a block of memory in a given list.
*
* INPUT:	d0	Address of block
*		a0	Pointer to anchor containing list
*
* RESULT:	d0	0 if not existing, -1 if done
*
;------------------------------------------------------------------------------

;------------------
FreeEMemory:

;------------------
; Set anchor, Free and reload anchor.
;
\find:
	pea	FreeMemory(pc)
	bsr	mem_MultiList
	addq.l	#4,sp
	rts

;------------------

;------------------------------------------------------------------------------
*
* FreeEAllMemory	Free all memory in given list.
*
* INPUT:	a0	Pointer to anchor containing list
*
;------------------------------------------------------------------------------

;------------------
FreeEAllMemory:

;------------------
; Set anchor, Free and reload anchor.
;
\start:
	pea	FreeAllMemory(pc)
	bsr	mem_MultiList
	addq.l	#4,sp
	rts

;------------------
	endif

;------------------

;------------------------------------------------------------------------------
*
* AllocMemory	Allocate memory and link it to a list of memory blocks.
*
* INPUT:	d0	Number of bytes to allocate
*		d1	Requirements
*
* RESULT:	d0	Address of memory or zero if not available
*
;------------------------------------------------------------------------------

;------------------
AllocMemory:

;------------------
; Allocate length+8 for link.
;
\start:
	movem.l	d1-a6,-(sp)
	move.l	4.w,a6
	addq.l	#8,d0
	move.l	d0,d7
	jsr	-198(a6)
	tst.l	d0
	beq.s	\done

;------------------
; Link to list.
;
\link:
	move.l	d7,d1
	bsr	EnchainMemory
	addq.l	#8,d0

;------------------
; Memory allocated or not.
;
\done:
	tst.l	d0
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* FreeMemory	Free a block of memory.
*
* INPUT:	d0	Address of block
*
* RESULT:	d0	0 if not existing, -1 if done
*
;------------------------------------------------------------------------------

;------------------
FreeMemory:

;------------------
; Find node and free it.
;
\find:
	movem.l	d1-a6,-(sp)
	lea	mem_anchor(pc),a1

\loop:
	move.l	a1,a0
	move.l	(a1),d1
	beq.s	\error
	move.l	d1,a1
	addq.l	#8,d1
	cmp.l	d0,d1
	bne.s	\loop

\found:
	move.l	(a1),(a0)	;unlink
	move.l	4(a1),d0
	move.l	4.w,a6
	jsr	-210(a6)
	moveq	#-1,d0
	bra.s	\done

\error:
	moveq	#0,d0

;------------------
; Memory freed or not.
;
\done:
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* FreeAllMemory		Free all memory in list.
*
;------------------------------------------------------------------------------

;------------------
FreeAllMemory:

;------------------
; Free all in list.
;
\free:
	movem.l	d0-a6,-(sp)
	move.l	4.w,a6
	move.l	mem_anchor(pc),a5
	bra.s	\next
\loop:
	move.l	a5,a1
	move.l	(a5),a5
	move.l	4(a1),d0
	jsr	-210(a6)
\next:
	move.l	a5,d0
	bne.s	\loop

\done:
	lea	mem_anchor(pc),a5
	clr.l	(a5)
	movem.l	(sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* EnchainMemory		Link a memory block at head of our structure.
*
* INPUT:	d0	Address of block
*		d1	Length including structure length (8)
*
;------------------------------------------------------------------------------

;------------------
EnchainMemory:

;------------------
; Link Memory in list.
;
\link:
	movem.l	a4/a5,-(sp)
	move.l	d0,a4
	lea	mem_anchor(pc),a5
	move.l	(a5),(a4)
	move.l	d0,(a5)
	move.l	d1,4(a4)
	movem.l	(sp)+,a4/a5
	rts
	
;------------------

;--------------------------------------------------------------------

;------------------
mem_anchor:	dc.l	0	;the anchor

;------------------

;--------------------------------------------------------------------

;------------------
	base	mem_oldbase

;------------------
	endif

 end

