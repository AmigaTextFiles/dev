;*---------------------------------------------------------------------------
;  :Program.	worldsoflegend.islave.asm
;  :Contents.	Imager for SaveDisk - Worlds of Legend
;  :Author.	Wepl
;  :Version.	$Id: worldsoflegend.islave.asm 1.1 2000/03/01 00:10:12 jah Exp $
;  :History.	01.03.00 converted from whdload slave
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V2.9
;  :To Do.
;---------------------------------------------------------------------------*
;
;	Disk format:
;	Disk 1:		0-1	standard
;			2-157	$1800 bytes sync=4489
;
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	RawDic.i

	IFD BARFLY
	OUTPUT	"Develop:Installs/worldsoflegend Install/SaveDisk.ISlave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	ENDC

;======================================================================

	SECTION a,CODE

		SLAVE_HEADER
		dc.b	1		; Slave version
		dc.b	0		; Slave flags
		dc.l	_disk1		; Pointer to the first disk structure
		dc.l	_text		; Pointer to the text displayed in the imager window

		dc.b	"$VER: "
_text		dc.b	"Worlds of Legend - SaveDisk - Imager",10
		dc.b	"Done by Wepl, Version 1.0 "
	DOSCMD	"WDate >T:date"
	INCBIN	"T:date"
		dc.b	".",0
	EVEN

_f0		dc.b	"EMPIRE0",0
_f1		dc.b	"EMPIRE1",0
_f2		dc.b	"EMPIRE2",0
_f3		dc.b	"EMPIRE3",0
_f4		dc.b	"EMPIRE4",0
_f5		dc.b	"EMPIRE5",0
_f6		dc.b	"EMPIRE6",0
_f7		dc.b	"EMPIRE7",0
_f8		dc.b	"EMPIRE8",0
_f9		dc.b	"EMPIRE9",0

_disk1		dc.l	0		; Pointer to next disk structure
		dc.w	1		; Disk structure version
		dc.w	0		; Disk flags
		dc.l	_tl1		; List of tracks which contain data
		dc.l	0		; UNUSED, ALWAYS SET TO 0!
		dc.l	_fl1		; List of files to be saved
		dc.l	0		; Table of certain tracks with CRC values
		dc.l	0		; Alternative disk structure, if CRC failed
		dc.l	0		; Called before a disk is read
		dc.l	0		; Called after a disk has been read

_tl1		TLENTRY	0,146,$1600,SYNC_STD,DMFM_STD
		TLEND

_fl1		FLENTRY	_f0,512*$384,$6e00
		FLENTRY	_f1,512*$3CA,$6e00
		FLENTRY	_f2,512*$410,$6e00
		FLENTRY	_f3,512*$456,$6e00
		FLENTRY	_f4,512*$49C,$6e00
		FLENTRY	_f5,512*$4E2,$6e00
		FLENTRY	_f6,512*$528,$6e00
		FLENTRY	_f7,512*$56E,$6e00
		FLENTRY	_f8,512*$5B4,$6e00
		FLENTRY	_f9,512*$5FA,$6e00
		FLEND

	END

