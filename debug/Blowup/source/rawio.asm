*
* $Id: rawio.asm 1.2 1998/04/18 15:45:16 olsen Exp olsen $
*
* :ts=8
*
* Blowup -- Catches and displays task errors
*
* Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
* Public Domain
*

	section	text,code

*****************************************************************************

	xdef	_SerPutChar
	xref	KPutChar	; in debug.lib

_SerPutChar:
	bra	KPutChar

*****************************************************************************

	xdef	_ParPutChar
	xref	PRawPutChar

_ParPutChar:
	bra	PRawPutChar	; in ddebug.lib

*****************************************************************************

	end
