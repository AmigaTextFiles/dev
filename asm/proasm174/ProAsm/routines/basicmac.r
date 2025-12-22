
;---;  basicmac.r  ;-----------------------------------------------------------
*
*	****	MACROS FOR SELECTIVE ROUTINE ASSEMBLING    ****
*
*	Author		Stefan Walter
*	Version		1.02
*	Last Revision	30.03.93
*	Identifier	bam_defined
*	Prefix		bam_	(Basic Macros)
*				 ¯¯    ¯
*	Macros		CALL_, JUMP_, NEED_, BRAB_, JSRLIB_
*
;------------------------------------------------------------------------------

;------------------
	ifnd	bam_defined
bam_defined	=1

;------------------
*
* CALL_: Call a routine.
*
CALL_	MACRO
	bsr	\1
xxx_\1	SET	1
	ENDM

;------------------
*
* JUMP_: Jump to a routine.
*
JUMP_	MACRO
	bra	\1
xxx_\1	SET	1
	ENDM

;------------------
*
* BRAB_: Branch short to a routine.
*
BRAB_	MACRO
	bra.s	\1
xxx_\1	SET	1
	ENDM

;------------------
*
* NEED_: Just generate another routine.
*
NEED_	MACRO
xxx_\1	SET	1
	ENDM

;------------------
*
* JSRLIB_
*
JSRLIB_	MACRO	
	jsr	_LVO\1(a6)
	ENDM

;------------------------------------------------------------------------------

	ENDIF
	END

