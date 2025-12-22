 IFND ERROR_I
ERROR_I=1
;*---------------------------------------------------------------------------
;  :Author.	Bert Jahn
;  :Contens.	macros for error handling
;  :EMail.	wepl@kagi.com
;  :Address.	Franz-Liszt-Straße 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: error.i 1.5 2000/01/03 23:42:03 jah Exp wepl $
;  :History.	30.12.95 separated from WRip.asm
;		18.01.96 IFD Label replaced by IFD Symbol
;			 because Barfly optimize problems
;		17.01.99 _PrintError* optimized
;		26.12.99 fault string initialisation added in _PrintErrorDOS
;  :Requires.	-
;  :Copyright.	This program is free software; you can redistribute it and/or
;		modify it under the terms of the GNU General Public License
;		as published by the Free Software Foundation; either version 2
;		of the License, or (at your option) any later version.
;		This program is distributed in the hope that it will be useful,
;		but WITHOUT ANY WARRANTY; without even the implied warranty of
;		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;		GNU General Public License for more details.
;		You can find the full GNU GPL online at: http://www.gnu.org
;  :Language.	68000 Assembler
;  :Translator.	Barfly V1.130
;---------------------------------------------------------------------------*
*##
*##	error.i
*##
*##	_PrintError	subsystem(d0) error(a0) operation(a1)
*##	_PrintErrorDOS	operation(a0)
*##	_PrintErrorTD	error(d0.b) operation(a0)

	dc.b	"$Id: error.i 1.5 2000/01/03 23:42:03 jah Exp wepl $"
	EVEN

		IFND	DOSIO_I
			INCLUDE	dosio.i
		ENDC
		IFND	STRINGS_I
			INCLUDE	strings.i
		ENDC
		IFND	DEVICES_I
			INCLUDE	devices.i
		ENDC

;----------------------------------------
; Ausgabe eines Fehlers
; Übergabe :	D0 = CPTR Subsystem | NIL
;		A0 = CPTR Art des Fehlers | NIL
;		A1 = CPTR bei Operation | NIL
; Rückgabe :	-

PrintError	MACRO
	IFND	PRINTERROR
PRINTERROR = 1
		IFND	PRINTARGS
			PrintArgs
		ENDC

_PrintError	movem.l	d0/a1,-(a7)
		move.l	a0,-(a7)
		lea	(.txt),a0
		move.l	a7,a1
		bsr	_PrintArgs
		add.w	#12,a7
		rts
		
.txt		dc.b	155,"1m%s",155,"22m (%s/%s)",10,0
		EVEN
	ENDC
		ENDM

;----------------------------------------
; Ausgabe eines DOS-Fehlers
; Übergabe :	A0 = CPTR Operation die zu Fehler führte | NIL
; Rückgabe :	-

PrintErrorDOS	MACRO
	IFND	PRINTERRORDOS
PRINTERRORDOS = 1
		IFND	PRINTERROR
			PrintError
		ENDC

_PrintErrorDOS	movem.l	d2-d4/a0/a6,-(a7)
		move.l	(gl_dosbase,GL),a6
		jsr	(_LVOIoErr,a6)
		move.l	d0,d1			;code
		moveq	#0,d2			;header
		moveq	#64,d4			;buffer length
		sub.l	d4,a7
		clr.b	(a7)
		move.l	a7,d3			;buffer
		jsr	(_LVOFault,a6)
		lea	(_dosname),a0
		move.l	a0,d0			;subsystem
		move.l	a7,a0			;error
		move.l	(12,a7,d4.l),a1		;operation
		bsr	_PrintError
		add.l	d4,a7
		movem.l	(a7)+,d2-d4/a0/a6
		rts
	ENDC
		ENDM

;----------------------------------------
; Ausgabe eines Trackdisk Errors
; Übergabe :	D0 = BYTE errcode
;		A0 = CPTR Operation | NIL
; Rückgabe :	-

PrintErrorTD	MACRO
	IFND	PRINTERRORTD
PRINTERRORTD=1
		IFND	DOSTRING
			DoString
		ENDC
		IFND	PRINTERROR
			PrintError
		ENDC

_PrintErrorTD	move.l	a0,-(a7)
		ext.w	d0
		lea	(_trackdiskerrors),a0
		bsr	_DoString
		move.l	d0,a0			;error
		lea	(.devaccess),a1
		move.l	a1,d0			;subsystem
		move.l	(a7)+,a1		;operation
		bra	_PrintError

.devaccess	dc.b	'device access',0
		EVEN
		IFND	TRACKDISKERRORS
			trackdiskerrors
		ENDC
	ENDC
		ENDM
 ENDC
