
;---;  amigaguide.r  ;---------------------------------------------------------
*
*	****	AmigaGuide support routines    ****
*
*	Author		Daniel Weber
*	Version		0.10
*	Last Revision	15.10.93
*	Identifier	agu_defined
*       Prefix		agu_	(AmigaGuide)
*				 ¯    ¯¯
*	Functions	ShowAmigaGuide
*
;------------------------------------------------------------------------------

	IFND	agu_defined
agu_defined	SET	1

;------------------
agu_oldbase	EQU __BASE
	base	agu_base
agu_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on


;------------------------------------------------------------------------------
*
* ShowAmigaGuide	- show an AmigaGuide file
*
* INPUT:	a0:	pointer to a NewAmigaGuide structure (see include files)
*
* RESULT:	<none>
*
* NOTES:	following entries of the NAG structure should be set up:
*		nag_Name, nag_ScreenName (if not WB), nag_BaseName,
*		nag_Node (here you may select a specific node such
*		as MAIN or SIMShortCuts etc. - <name> defined in a *.guide file
*		@Node <name>)
*
*		f.e.:	nag_Name     -> dc.b "asm:asx/asxhelp.guide",0
*			nag_BaseName -> dc.b "ASX.guide",0
*			nag_Node     -> dc.b "MAIN",0
*
;------------------------------------------------------------------------------
	IFD	xxx_ShowAmigaGuide
ShowAmigaGuide:
	apushm
	move.l	AmigaGuideBase(pc),d0		;only supported if amigaguide
	beq.s	.out				;available

	move.l	a0,a5

	IFD	cws_homedir
	move.l	cws_homedir(pc),(a5)	;nag_Lock
	bne.s	1$
	ENDC

	move.l	DosBase(pc),a6
	jsr	-600(a6)		;GetProgramDir()
	move.l	d0,(a5)			;nag_Lock
	beq.s	.out

1$:	move.l	AmigaGuideBase(pc),a6
	move.l	a5,a0
	sub.l	a1,a1
	jsr	-54(a6)			;OpenAmigaGuideA()
	move.l	d0,a0			;(this way the program waits...)
	jsr	-66(a6)			;CloseAmigaGuide()

.out:	apopm
	rts

	ENDC

;--------------------------------------------------------------------

	base	agu_oldbase
	opt	rcl

;------------------
	ENDIF

 end

