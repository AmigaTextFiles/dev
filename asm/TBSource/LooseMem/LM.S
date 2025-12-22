*************************************************
*						*
*		No (C)opyright 1992		*
*						*
*		by  Tomi Blinnikka		*
*						*
*	Don´t try to understand the code	*
*						*
* Version 0.00a	26/08/1992			*
*						*
* BUGS:	Dunno..					*
*						*
*************************************************

Osoite:		EQU	$c000000	;montako nollaa?

_LVOAllocAbs:	EQU	-$00cc

Start:		movem.l	d2-d7/a2-a6,-(sp)
		move.l	#800*1024,d0
		move.l	#Osoite,a1
		move.l	$4,a6
		jsr	_LVOAllocAbs(a6)
		movem.l	(sp)+,d2-d7/a2-a6
		rts

		END
