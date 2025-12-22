
;---;  scripts.r  ;------------------------------------------------------------
*
*	****	ROUTINES TO DEAL WITH BATCHES    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	21.07.92
*	Identifier	sab_defined
*	Prefix		sab_	(scripts and batches)
*				 ¯       ¯   ¯
*	Functions	OpenScript, CloseScript, GetScriptCom, GetScriptArgs
*	Macros		AddSArg_, AddSCom_
*
;-------------------------------------------------------------------------------
*
*
*
;-------------------------------------------------------------------------------

;------------------
	ifnd	sab_defined
sab_defined	=1

;------------------
sab_oldbase	equ __base
	base	sab_base
sab_base:

;------------------

;------------------------------------------------------------------------------
*
* AddSCom_	Add a command to the command list.
*
* USAGE		AddSCom_ name,flags,arg1info,arg2info,...
;------------------------------------------------------------------------------

;------------------
AddSCom_
;------------------

;------------------------------------------------------------------------------
*
* EndSCom_	End the command list.
*
* USAGE		EndSCom_
*
;------------------------------------------------------------------------------

;------------------
EndSCom_	macro	

;------------------
; Simply a dc.w 0.
;
	dc.w	0
	endm

;------------------

;------------------------------------------------------------------------------
*
* OpenScript	Opens a script and inits for reading it.
*
* INPUT:	a0	Script name
*
* RESULT:	d0	Addres of script or 0 if failed
*		ccr	On d0
*
;------------------------------------------------------------------------------

;------------------
OpenScript:

;------------------
; Do all.
;
\start:
	movem.l	d1-a6,-(sp)
	lea	sab_base(pc),a4
	moveq	#1,d0
	move.l	d0,sab_linenr(a4)

	move.l	a0,d0
	moveq	#0,d1
	moveq	#1,d2
	bsr	LoadFile
	move.l	d2,sab_length(a4)
	move.l	d0,sab_script(a4)
	beq.s	\done
	move.l	d0,sab_current(a4)

\done:
	movem.l	(sp)+,d1-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* CloseScript	Closes the opened script.
*
;------------------------------------------------------------------------------

;------------------
CloseScript:

;------------------
; Do all.
;
\start:
	movem.l	d0-a6,-(sp)
	lea	sab_script(pc),a0
	tst.l	(a0)
	beq.s	\done
	move.l	(a0),a1
	clr.l	(a0)
	move.l	sab_length(pc),d0
	move.l	4.w,a6
	jsr	-210(a6)		;FreeMem()

\done:
	movem.l	8sp)+,d0-a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* GetScriptCom	Get next 'command line' from script and extract command info.
*
* INPUT		a0	Buffer (200 bytes)
*
* RESULT	a0	Pointer in buffer on first argument
*		a1	Pointer to command info struct or 0
*		d0	Line length or 0 if no more lines
*		d1	Line number
*		ccr	On d0
*
;------------------------------------------------------------------------------

;------------------
CetScriptCom:

;------------------
; Do all.
;
\start:
	movem.l	d2-d7/a2-a6,-(sp)
	lea	sab_base(pc),a4
	move.l	a0,d7
	
	move.l	sab_current(pc),a0
	move.l	d7,a1
	move.l	sab_linenr(pc),d1
	bsr	CopyLine
	move.l	a0,sab_current(a4)
	move.l	d1,sab_linenr(a4)
	tst.l	d0
	beq.s	\done

\findcommand:
	
\done:
	tst.l	d0
	movem.l	(sp)+,d2-d7/a2-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
	include	dosfile.r
	include	parse.r

;------------------
; Script handling
;
sab_script:	dc.l	0
sab_length:	dc.l	0
sab_current:	dc.l	0
sab_linenr:	dc.l	0

;--------------------------------------------------------------------

;------------------
	base	sab_oldbase

;------------------
	endif

	end

