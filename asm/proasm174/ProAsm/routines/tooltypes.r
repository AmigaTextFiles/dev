
;---;  tooltypes.r  ;----------------------------------------------------------
*
*	****	GET TOOLTYPES FROM A WWORKBENCH PROGRAM    ****
*
*	Author		Stefan Walter
*	Version		1.08
*	Last Revision	25.05.93
*	Identifier	gtt_defined
*	Prefix		gtt_	(Get tooltypes)
*				 ¯   ¯   ¯
*	Functions	OpenIcon, CloseIcon, GetToolType
*
*	Note:	Dos.library should already be opened with OpenDosLib or
*		by EasyLibraryHandler.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	gtt_defined
gtt_defined	=1

;------------------
gtt_oldbase	equ __base
	base	gtt_base
gtt_base:

;------------------

;------------------------------------------------------------------------------
*
* OpenIcon	Prepare everything to read tooltypes from a WB program.
*
* INPUT:	a0	WB message
*
* RESULT:	d0	0: Error, -1: OK   (CCR set)
*
;------------------------------------------------------------------------------

;------------------
OpenIcon:

;------------------
; Do everything.
;
\start:
	movem.l	d1-a6,-(sp)
	lea	gtt_base(pc),a4
	move.l	a0,d7

	lea	gtt_iconname(pc),a1
	move.l	4.w,a6
	jsr	-408(a6)		;OldOpenLibrary()
	move.l	d0,gtt_iconbase(a4)
	beq.s	\error

\changedir:
	moveq	#0,d4
	move.l	d7,a2
	move.l	36(a2),a3		;ArgList
	move.l	(a3),d1
	beq.s	\error2			;no lock=>can't be
	IFD     ely_defined
	move.l	DosBase(pc),a6
	ELSE
	bsr	GetDosBase
	ENDIF
	jsr	-126(a6)		;CurrentDir()
	move.l	d0,gtt_oldlock(a4)	;remember old lock

\getdiskobject:
	move.l	4(a3),a0		;name
	move.l	gtt_iconbase(pc),a6
	jsr	-78(a6)			;GetDiskObject()
	move.l	d0,gtt_object(a4)
	beq.s	\error3
	move.l	d0,a0
	lea	54(a0),a0		;ToolTypeArray
	move.l	a0,gtt_array(a4)

\okay:
	st.b	gtt_open(a4)
	moveq	#-1,d0
\exit:	movem.l	(sp)+,d1-a6
	rts

;------------------
; Errors => Clean up
;
\error3:
	move.l	gtt_oldlock(pc),d1
	IFD     ely_defined
	move.l	DosBase(pc),a6
	ELSE
	bsr	GetDosBase
	ENDIF
	jsr	-126(a6)		;CurrentDir()

\error2:
	move.l	gtt_iconbase(pc),a1
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()

\error:
	clr.b	gtt_open(a4)
	moveq	#0,d0
	bra.s	\exit
	
;------------------

;------------------------------------------------------------------------------
*
* CloseIcon	Free all resources used for icon handling.
*
;------------------------------------------------------------------------------

;------------------
CloseIcon:

;------------------
; Do everything.
;
\start:	movem.l	d0-a6,-(sp)
	lea	gtt_base(pc),a4
	tst.b	gtt_open(a6)
	beq.s	\done
	clr.b	gtt_open(a6)

	move.l	gtt_object(pc),a0
	move.l	gtt_iconbase(pc),a6
	jsr	-90(a6)			;FreeDiskObj()

	move.l	gtt_oldlock(pc),d1
	IFD     ely_defined
	move.l	DosBase(pc),a6
	ELSE
	bsr	GetDosBase
	ENDIF
	jsr	-126(a6)		;CurrentDir()

	move.l	gtt_iconbase(pc),a1
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()

\done:
	movem.l	(sp)+,d0-a6
	rts
	
;------------------

;------------------------------------------------------------------------------
*
* GetToolType	Get the argument after a tool type
*
* INPUT		a0	Buffer
*		a1	ToolType to search for
*		d0	Maximum length (zero excluded)
*
* RESULT	d0	Length of copied text or -1 if no such ToolType (CCR)
*
;------------------------------------------------------------------------------

;------------------
GetToolType:

;------------------
; Do everything.
;
\start:
	movem.l	d1-a6,-(sp)
	lea	gtt_base(pc),a4
	move.l	a0,d7
	move.l	d0,d6

	move.l	gtt_array(pc),a0
	move.l	gtt_iconbase(pc),a6
	jsr	-96(a6)			;FindToolType()
	tst.l	d0
	beq.s	\error

	move.l	d0,a1
	move.l	d7,a0
	moveq	#-1,d0
\copy:	addq.l	#1,d0
	move.b	(a1)+,(a0)+
	beq.s	\done
	subq.l	#1,d6
	bne.s	\copy

\done:	tst.l	d0
	bra.s	\exit

\error:	moveq	#-1,d0
\exit:	movem.l	(sp)+,d1-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
gtt_iconname:	dc.b	"icon.library",0,0
gtt_iconbase:	dc.l	0
gtt_oldlock:	dc.l	0
gtt_array:	dc.l	0
gtt_object:	dc.l	0

gtt_open:	dc.b	0	;set if all open
		dc.b	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	gtt_oldbase

;------------------
	endif

	end

