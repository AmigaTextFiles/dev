	IFND	REQUESTLONG_I
REQUESTLONG_I	SET	1
**
**	$VER: requestlong.i 1.0 (16.10.99)
**	Includes Release 1.0
**
**	Structures and constants for RequestLong
**
**	(C) Copyright 1999 Harry "Piru" Sintonen.
**	    All Rights Reserved
**

	IFND	EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC

	BITDEF	RL,ALLOWHEX,0		; allow entering of hex number (you must use $ or 0x prefix then)
	BITDEF	RL,INITHEX,1		; show initial value in hex (only with ALLOWHEX)
	BITDEF	RL,UNSIGNED,2		; only unsigned number, default signed/unsigned
	BITDEF	RL,SHOWDEF,3		; if set value pointed by a0 is shown as default
	BITDEF	RL,FOLLOWMOUSE,4	; follow mouse pointer, default is center on visible screen
	BITDEF	RL,ALLOWEMPTY,5		; allow entering if no number
	BITDEF	RL,ESCISRETURN,6	; if ESC key is same as return

	ENDC	; REQUESTLONG_I
