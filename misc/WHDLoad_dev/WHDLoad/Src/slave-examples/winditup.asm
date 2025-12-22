;*---------------------------------------------------------------------------
;  :Program.	winditup.asm
;  :Contents.	Slave for "Wind it up" from XYMOX Project
;  :Author.	wepl <wepl@whdload.de>
;  :Version.	$Id: winditup.asm 1.7 2002/02/19 21:09:47 wepl Exp wepl $
;  :History.	04.09.97 start
;		09.05.99 adapted for WHDload 10.0
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V2.9
;  :To Do.
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i

	IFD BARFLY
	OUTPUT	"dwart:xymox/winditup/WindItUp.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER					;disable supervisor warnings
	ENDC

;======================================================================

_base		SLAVE_HEADER			;ws_Security + ws_ID
		dc.w	10			;ws_Version
		dc.w	WHDLF_Disk|WHDLF_NoError ;ws_flags
		dc.l	$fb000			;ws_BaseMemSize
		dc.l	0			;ws_ExecInstall
		dc.w	_Start-_base		;ws_GameLoader
		dc.w	0			;ws_CurrentDir
		dc.w	0			;ws_DontCache
_keydebug	dc.b	0			;ws_keydebug
_keyexit	dc.b	$59			;ws_keyexit = F10
_expmem		dc.l	0			;ws_ExpMem
		dc.w	_name-_base		;ws_name
		dc.w	_copy-_base		;ws_copy
		dc.w	_info-_base		;ws_info

;============================================================================

	IFD	BARFLY
	IFND	.passchk
	DOSCMD	"WDate  >T:date"
.passchk
	ENDC
	ENDC

_name		dc.b	"Wind it up - Megamix 93",0
_copy		dc.b	"1993 XYMOX Project",0
_info		dc.b	"installed by Wepl",10
		dc.b	"Version 1.4 "
	IFD	BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
	EVEN

;======================================================================
_Start	;	A0 = resident loader
;======================================================================

		lea	(_resload,pc),a1
		move.l	a0,(a1)			;save for later use

		move.l	#CACRF_EnableI,d0	;enable instruction cache
		move.l	d0,d1    		;mask
		jsr	(resload_SetCACR,a0)

	;install keyboard quitter
		bsr	_SetupKeyboard

_restart	moveq	#0,d0			;offset
		move.l	#$5800,d1		;size
		moveq	#1,d2			;disk
		lea	$4fc04,a0		;destination
		move.l	(_resload,pc),a2
		jsr	(resload_DiskLoad,a2)

		patch	$50154,_1
		jmp	$50000			;decrunch

_1		patch	$13a4e,_loader
		patch	$21a2,_2
		jmp	$2008

_2		patch	$80176,_3
		jmp	$80000			;decrunch

_3		patch	$fa5b2,_loader
		patch	$f012c,_4
		jmp	$f0008

_4		clr.w	$526fe			;preserve ints
		patch	$52880,_5
		jmp	$52500

_5		move.w	#250,d2
.wait		waitvb	a0
		dbf	d2,.wait
		bra	_restart

_loader		move.w	#200,d2
.wait		waitvb
		dbf	d2,.wait
		mulu	#512*11,d0		;offset
		mulu	#512*11,d1		;size
		moveq	#1,d2			;disk
		move.l	(_resload,pc),a2
		jmp	(resload_DiskLoad,a2)

;--------------------------------

_resload	dc.l	0		;address of resident loader

;--------------------------------

_exit		pea	TDREASON_OK
		bra	_end
_debug		pea	TDREASON_DEBUG
_end		move.l	(_resload,pc),-(a7)
		add.l	#resload_Abort,(a7)
		rts

;======================================================================

	INCLUDE	Sources:whdload/keyboard.s

;======================================================================

	END
