****************************************************************************
*										*
*                   ****   Intuition Support  ****				*
*										*
*	Author		René Eberhard						*
*	Version		0.5							*
*	Last Revision	16-Jan-94						*
*	Identifier	int_support						*
*       Prefix		int_support   (intuition.library support)		*
*				 						*
*				 						*
*-----------------------------[ UPDATES ]----------------------------------*
*										*
*	-REB!	13-Jun-93	Start this Project			   *
*	-REB!	14-Jul-93	Request() added -> Clean version	   *
*	-REB!	16-Jul-93	Multiple use added			   *
*	-DAW!	16-Jan-94	Preferences default pointer used for V39   *
*										*
****************************************************************************
*---------------------------[ Functions ]----------------------------------*
*										*
* - SetBusyPointer, ClrBusyPointer						*
*										*
*---------------------------[ COMMENT ]------------------------------------*
*	    									*
****************************************************************************

	IFND	int_support
int_support	SET	1

intsupport_oldbase	equ __BASE
	BASE	intsupport_base

intsupport_base:
		
;---------------------------------------------------------------------------

	IFND	USE_NEWROUTINES
	NEED_	SetBusyPointer
	NEED_	ClrBusyPointer
	ENDIF
		
;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : SetBusyPointer							*
*										*
* SYNOPSIS: 									*
*       SetBusyPointer (Windowhandler)						*
*                       D0.L 							*
*										*
* RESULT  : BusyHandler or NULL for error					*
*										*
* COMMENT : This function creates a DATA hunk into the chip memory		*
*										*
****************************************************************************
	IFD	xxx_SetBusyPointer
SetBusyPointer:
	NEED_	ClrBusyPointer

	PUSHM.L	d1-a6
	move.l	d0,d7			;Store Windowhandler
	beq.s	\Rtn
		
;---------------[ Allocate request ]----------------------------------------

	move.l	AbsExecBase,a6		;Allocate Struct request
	move.l	#rq_SIZEOF+4,d0		;SIZE + WindowHandler
	move.l	#MEMF_CLEAR,d1
	JSRLIB_	AllocMem
	move.l	d0,d6			;Store returncode into D6.L
	beq.s	\Rtn			;Fail

	move.l	d0,a0
	move.l	d7,(a0)+		;Store WindowHandler
					;A0.L points now to Struct Request
;---------------------------------------------------------------------------

\Req:	PUSH.L	d0			;Store memoryblock
	move.l	IntBase(PC),a6		;A0.L initialized from above
	move.l	d7,a1			;Windowhandler
	JSRLIB_	Request
	POP.L	a1			;Initialize A1.L if there is a failure
	tst.l	d0
	bne.s	\SetP			;Fail

	move.l	AbsExecBase,a6		;Free Struct request
	move.l	#rq_SIZEOF+4,d0		;SIZE
	JSRLIB_	FreeMem
	clr.l	d6			;Error code
	bra.s	\Rtn

;---------------------------------------------------------------------------

\SetP:	move.l	d7,a0			;Windowhandler
	cmp.w	#39,LIB_VERSION(a6)
	blt.s	.v36
	lea	.setbusy(pc),a1
	JSRLIB_	SetWindowPointerA
	bra.s	\Rtn

.v36:	lea	int_support_SpriteData,a1
	moveq	#16,d0			;Height
	moveq	#16,d1			;Weight
	moveq	#-6,d2			;XOffset
	moveq	#0,d3			;YOffset
	JSRLIB_	SetPointer

\Rtn:	move.l	d6,d0			;Returncode into D0.L
	POPM.L	d1-a6
	rts

.setbusy:
	dc.l	WA_BusyPointer,1
	dc.l	WA_PointerDelay,1
	dc.l	TAG_DONE

;---------------[ Sprite Datas ]--------------------------------------------


	SECTION "Pointer_DATA",DATA,CHIP

int_support_SpriteData:
	dc.w	$0000,$0000,$0400,$07c0,$0000,$07c0,$0100,$0380
	dc.w	$0000,$07e0,$07c0,$1ff8,$1ff0,$3fec,$3ff8,$7fde
	dc.w	$3ff8,$7fbe,$7ffc,$ff7f,$7efc,$ffff,$7ffc,$ffff
	dc.w	$3ff8,$7ffe,$3ff8,$7ffe,$1ff0,$3ffc,$07c0,$1ff8
	dc.w	$0000,$07e0

	SECTION	__OldSection

	ENDC

;---------------------------------------------------------------------------
****************************************************************************
*										*
* NAME    : ClrBusyPointer							*
*										*
* SYNOPSIS: 									*
*       ClrBusyPointer (BusyHandler)						*
*                       D0.L 	     						*
*										*
****************************************************************************
	IFD	xxx_ClrBusyPointer
ClrBusyPointer:
	NEED_	SetBusyPointer

	PUSHM.L	d0-a6

	tst.l	d0
	beq.s	\Rtn			;No BusyHandler
	move.l	d0,a5			;Store BusyHandler

;---------------[ Remove request ]------------------------------------------

	move.l	(a5),d7			;Store WindowHandler
	beq.s	\Free			;No -> Free memoryblock
	move.l	d7,a1			;WindowHandler into A1.L for EndRequest()
	move.l	a5,a0			;BusyHandler
	addq.l	#4,a0			;Pointer to Struct Request
	move.l	IntBase(PC),a6
	JSRLIB_	EndRequest

;---------------[ Free memory ]---------------------------------------------

\Free:	move.l	AbsExecBase,a6			;Free Struct Request
	move.l	a5,a1				;Memoryblock
	move.l	#rq_SIZEOF+4,d0			;SIZE + WindowHandler
	JSRLIB_	FreeMem
	
;---------------[ Make original pointer ]-----------------------------------

\Clr:	move.l	IntBase(PC),a6
	move.l	d7,a0					;Windowhandler
	cmp.w	#39,LIB_VERSION(a6)
	blt.s	1$
	lea	.clrbusy(pc),a1
	JSRLIB_	SetWindowPointerA
	bra.s	\Rtn
1$:	JSRLIB_	ClearPointer

\Rtn:	POPM.L	d0-a6
	rts

.clrbusy:
	dc.l	WA_Pointer,0
	dc.l	TAG_DONE

	ENDC

;---------------------------------------------------------------------------
	BASE	intsupport_oldbase

	ENDC
;---------------------------------------------------------------------------
