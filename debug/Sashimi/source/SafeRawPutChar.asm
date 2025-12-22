*
* $Id: SafeRawPutChar.asm 1.1 1998/09/11 22:03:16 olsen Exp olsen $
*
* Sashimi -- intercepts raw serial debugging output on your own machine
*
* Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
* Public Domain
*
* :ts=8
*

	section	text,code

	xref	_NewRawPutChar

	xdef	_SafeRawPutChar

_SafeRawPutChar:

	movem.l	a0-a1,-(sp)
	bsr	_NewRawPutChar
	movem.l	(sp)+,a0-a1
	rts

	end
