	XLIB	AllocIdentifier

	LIB malloc, Bind_bank_s1



; **************************************************************************************************
;
;	Allocate memory for	symbol identifier string
;
;	IN: HL  =	local pointer to identifier (with initial length byte and null-terminated).
;			The local	pointer must not be	in SEGMENT 1.
;
;   OUT: BHL =	extended pointer to	allocated	memory with identifier,
;			otherwise	NULL	if no room
;	    Fc = 0 if memory allocated, otherwise Fc	= 1
;
; Registers changed	after return:
;
;	......../IXIY	same
;	AFBCDEHL/....	different
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
.AllocIdentifier	LD	A,(HL)				; get length of identifier
				INC	A					; length of identifier +	length byte
				INC	A					; length of identfifier + null-terminator
				LD	C,A
				EX	DE,HL				; preserve local pointer	in DE
				CALL	malloc				; get memory for id. (always bound	into	segment)
				RET	C					; Ups - no room ...
				EX	DE,HL				; HL	= local 'from'	pointer (in segment	0)
				PUSH	DE
				PUSH	BC					; preserve extended	pointer to memory in BDE
				LD	B,0					; C = length of string
				LDIR						; copy string into extended address
				POP	BC
				POP	HL					; return extended pointer to string in BHL
				CP	A					; Fc	= 0,	identifier allocated...
				RET
