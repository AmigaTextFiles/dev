
;---;  readargs.r  ;-----------------------------------------------------------
*
*	****	INTERFACE TO READARGS    ****
*
*	Author		Stefan Walter
*	Version		1.01
*	Last Revision	22.05.93
*	Identifier	rda_defined
*	Prefix		rda_	(ReadArgs)
*				 ¯  ¯¯
*	Functions	OpenArgs, CloseArgs, (GetOneArg)
*
*	Flags		rda_GETARG set 1 if GetOneArg also needed.
*
*	Note:	Dos.library should already be opened with OpenDosLib or
*		by EasyLibraryHandler.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	rda_defined
rda_defined	=1

;------------------
rda_oldbase	equ __base
	base	rda_base
rda_base:

	IFD     ely_defined
	IFND	DOS.LIB
	FAIL	dos.library needed: DOS.LIB SET 1
	ENDIF
	ENDIF

;------------------

;------------------------------------------------------------------------------
*
* OpenArgs	Prepare to read args later.
*
* INPUT:	a0	Template
*		a1	Array of LONGS with enough of them!
*
* RESULT:	d0	0: Error, -1: OK
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
OpenArgs:

;------------------
; Do everything.
;
\start:	movem.l	d1-a6,-(sp)
	IFD     ely_defined
	move.l	DosBase(pc),a6
	ELSE
	bsr	GetDosBase
	ENDIF
	move.l	a0,d1
	move.l	a1,d2
	moveq	#0,d3
	jsr	-798(a6)		;ReadArgs()
	lea	rda_rdargs(pc),a0
	move.l	d0,(a0)
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* CloseArgs	Free RDArgs structure. Call is safe!
*
;------------------------------------------------------------------------------

;------------------
CloseArgs:

;------------------
; Do everything.
;
\start:	movem.l	d0-a6,-(sp)
	lea	rda_rdargs(pc),a0
	move.l	(a0),d1
	beq.s	\done
	clr.l	(a0)
	IFD     ely_defined
	move.l	DosBase(pc),a6
	ELSE
	bsr	GetDosBase
	ENDIF
	jsr	-858(a6)		;FreeArgs()
\done:	movem.l	(sp)+,d0-a6
	rts
	
;------------------

	IFD	rda_GETARG

;------------------------------------------------------------------------------
*
* GetOneArg	Get one argument from buffer.
*
* INPUT		a0	Template.
*		a1	Buffer.
*		a2	Keyword to search for.
*
* RESULT	d0	Contents of LONG, or 0.
*		ccr	On d0.
*
;------------------------------------------------------------------------------

;------------------
GetOneArg:

;------------------
; Do everything.
;
\start:	movem.l	d1-a6,-(sp)
	IFD     ely_defined
	move.l	DosBase(pc),a6
	ELSE
	bsr	GetDosBase
	ENDIF
	move.l	a1,a4
	move.l	a0,d1
	move.l	a2,d2
	jsr	-804(a6)		;FindArg()
	moveq	#-1,d1
	cmp.l	d1,d0
	beq.s	\error
	lsl.l	#2,d0
	move.l	(a4,d0.l),d0
	bra.s	\exit

\error:	moveq	#0,d0
\exit:	movem.l	(sp)+,d1-a6
	rts

;------------------
	ENDIF

;--------------------------------------------------------------------

;------------------
rda_rdargs:	dc.l	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	rda_oldbase

;------------------
	endif

	end

