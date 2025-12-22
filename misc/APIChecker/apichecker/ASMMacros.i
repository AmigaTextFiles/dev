          IFND ASMMACROS_I
ASMMACROS_I  SET  1

;***************************************
;**** Usefull Assembler Macros V1.7 ****
;**** (C) 1992-95 Stefan Fuchs      ****
;***************************************

	IFND EXEC_TYPES_I
	INCLUDE "Work:Includes/IncludeV2.0.i/exec/types.i"
	ENDC

TRUE equ 1

;* Memory Attributes:
PUBLIC	= $1
CHIP	= $2
FAST	= $4		;Don't use
CLEAR	= $10000
LARGEST	= $20000

;--------------------------------------------------------------
;--------- CALL jump to Library function (and set LibraryBase)
;--------------------------------------------------------------

CALL	MACRO
	IFGT	NARG-2
		FAIL "Too many arguments for call makro"
	ENDIF
	IFEQ NARG-2
	move.l	\2,a6
	ENDIF
	jsr	\1(a6)
	ENDM

;--------------------------------------------------------------
;-------- BSREQ branch to subroutine if equal
;-------- BSREQ Subroutine[,Label after bsr]
;--------------------------------------------------------------
BSREQ	MACRO
	IFGT	NARG-2
		FAIL "Too many arguments for BSREQ makro"
	ENDIF
	bne BSREQ\@
	bsr \1
	IFEQ NARG-2
	bra \2
	ENDIF
BSREQ\@
	ENDM
;--------------------------------------------------------------
;-------- BSRNE branch to subroutine if not equal
;-------- BSRNE Subroutine[,Label after bsr]
;--------------------------------------------------------------
BSRNE	MACRO
	IFGT	NARG-2
		FAIL "Too many arguments for BSRNE makro"
	ENDIF
	beq BSRNE\@
	bsr \1
	IFEQ NARG-2
	bra \2
	ENDIF
BSRNE\@
	ENDM

;--------------------------------------------------------------
;-------- SKIPLISTHEADER  Returns a pointer to first node in a list
;-------- SKIPLISTHEADER ax,NOListErrorLabel,EmptyListErrorLabel
;---------ax includes pointer to ListHeader
;--------------------------------------------------------------
SKIPLISTHEADER	MACRO
	IFGT	NARG-3
		FAIL "Too many arguments for SKIPLISTHEADER makro"
	ENDIF
	tst.l (\1)
	beq \2
	move.l (\1),\1
	tst.l (\1)
	beq \3
	ENDM

;--------------------------------------------------------------
;-------- OPENLIB open a library and test returncode
;-------- OPENLIB LibNameLabel,Version[,Label to branch on Error]
;-------- Destroys d0-d1/a0-a1/a6
;--------------------------------------------------------------
OPENLIB	MACRO
	IFGT	NARG-3
		FAIL "Too many arguments for OPENLIB makro"
	ENDIF
	move.l #\1,a1
	moveq.l #\2,d0
	move.l 4.w,a6
	jsr -552(a6)
	IFEQ NARG-3
	tst.l d0
	beq \3
	ENDIF
	ENDM

;--------------------------------------------------------------
;-------- CLOSELIB test librarybase on non-null and close a library
;-------- CLOSELIB LibBaseLabel
;-------- Destroys d0-d1/a0-a1/a6
;--------------------------------------------------------------
CLOSELIB	MACRO
	IFGT	NARG-1
		FAIL "Too many arguments for CLOSELIB makro"
	ENDIF
	cmp.l #0,\1
	beq CLOSELIB\@
	move.l \1,a1
	move.l 4.w,a6
	jsr -414(a6)
CLOSELIB\@
	ENDM


	ENDC
