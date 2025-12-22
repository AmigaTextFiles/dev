*
* $Id: rawio.asm 1.3 1998/04/12 17:29:55 olsen Exp olsen $
*
* :ts=8
*
* Wipeout -- Traces and munges memory and detects memory trashing
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
