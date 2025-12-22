		********************************
		*                              *
		*            FarCom            *
		*  Macros, equates and structs *
		*                              *
		*     by Torsten Jürgeleit     *
		*                              *
		********************************

;---------------------------------------------------------------------------
; Support macros
;---------------------------------------------------------------------------

CALL	MACRO
	XREF	\1
	jsr	\1
	ENDM

LINKSYS	MACRO
	XREF	_LVO\1
	LINKLIB _LVO\1,\2
	ENDM

CALLSYS	MACRO
	XREF	_LVO\1
	CALLLIB _LVO\1
	ENDM

PUSH	MACRO
	movem.l	\1,-(sp)
	ENDM

PULL	MACRO
	movem.l	(sp)+,\1
	ENDM

;---------------------------------------------------------------------------
; Equates
;---------------------------------------------------------------------------

FM_ADDTXT		EQU	0
FM_REQTXT		EQU	1
FM_REQNUM		EQU	2

MAX_ARG_STRING_LEN	EQU	512

;---------------------------------------------------------------------------
; Structures
;---------------------------------------------------------------------------

	STRUCTURE FarMessage,0
	STRUCT	fm_ExecMessage,MN_SIZE
	USHORT	fm_Command
	APTR	fm_Identifier
	APTR	fm_Text
	LABEL	FarMessage_Sizeof
