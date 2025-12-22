	IFND	EXEC_TYPES_I
	IFND	SYSTEM_TYPES_I
SYSTEM_TYPES_I	SET   1
EXEC_TYPES_I	SET   1

**
**	$VER: types.i (November 1997)
**
**	(C) Copyright 1997 DreamWorld Productions.
**	    Based on Commodore type definitions.
**

CALL	MACRO
	jsr	_LVO\1(a6)
	ENDM

STRUCTURE   MACRO	;structure name, initial offset
\1	    EQU     0
SOFFSET     SET     \2
	    ENDM

FPTR	    MACRO	;function pointer (32 bits - all bits valid)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	    ENDM

BOOL	    MACRO	;boolean (16 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	    ENDM

BYTE	    MACRO	;byte (8 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+1
	    ENDM

UBYTE	    MACRO	;unsigned byte (8 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+1
	    ENDM

WORD	    MACRO	;word (16 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	    ENDM

UWORD	    MACRO	;unsigned word (16 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	    ENDM

LONG	    MACRO	;long (32 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	    ENDM

ULONG	    MACRO	;unsigned long (32 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	    ENDM

FLOAT	    MACRO	;C float (32 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	    ENDM

DOUBLE	    MACRO	;C double (64 bits)
\1	    EQU	    SOFFSET
SOFFSET	    SET	    SOFFSET+8
	    ENDM

APTR	    MACRO	;untyped pointer (32 bits - all bits valid)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	    ENDM

CPTR	    MACRO	;obsolete
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+4
	    ENDM

RPTR	    MACRO	;unsigned relative pointer (16 bits)
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+2
	    ENDM

LABEL	    MACRO	;Define a label without bumping the offset
\1	    EQU     SOFFSET
	    ENDM

STRUCT	    MACRO	;Define a sub-structure
\1	    EQU     SOFFSET
SOFFSET     SET     SOFFSET+\2
	    ENDM

**
** Enumerated variables.  Use ENUM to set a base number, and EITEM to assign
** incrementing values.  ENUM can be used to set a new base at any time.
**

ENUM	    MACRO   ;[new base]
	    IFC     '\1',''
EOFFSET	    SET	    0		; Default to zero
	    ENDC
	    IFNC    '\1',''
EOFFSET	    SET     \1
	    ENDC
	    ENDM

EITEM	    MACRO   ;label
\1	    EQU     EOFFSET
EOFFSET     SET     EOFFSET+1
	    ENDM

BITDEF	    MACRO   ; prefix,&name,&bitnum
	    BITDEF0 \1,\2,B_,\3
\@BITDEF    SET     1<<\3
	    BITDEF0 \1,\2,F_,\@BITDEF
	    ENDM

BITDEF0     MACRO   ; prefix,&name,&type,&value
\1\3\2	    EQU     \4
	    ENDM

	ENDC	; SYSTEM_TYPES_I
	ENDC    ; EXEC_TYPES_I
