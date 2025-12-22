;*---------------------------------------------------------------------------
;  :Program.	Hardwired.asm
;  :Contents.	Slave for "Hardwired" from Crionics and Silents
;  :Author.	Mr.Larmer of Wanted Team & Wepl
;  :Version.	$Id: hardwired.asm 1.3 2001/01/28 23:27:10 jah Exp jah $
;  :History.	09.11.97
;		22.12.97 (Wepl) adapted for Barfly
;			 start message
;			 wait part 1 added
;			 blit fix (box to logo)
;			 restart
;		10.12.00 rework, adapted for whdload v10+
;		28.01.01 Transformation of pixelized vectors fixed for 50 mhz 68030 (Harry)
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Devpac 3.14, Barfly, AsmOne
;  :To Do.
;---------------------------------------------------------------------------*

	INCLUDE	whoami.i

	IFD HARRY
	INCDIR	asm-one:Include2.0/
	INCLUDE LIBRARIES/DOS_LIB.I
	INCLUDE	LIBRARIES/DOS.I
	INCLUDE EXEC/EXEC_LIB.I
	INCLUDE	EXEC/MEMORY.I
	INCLUDE	GRAPHICS/GRAPHICS_LIB.I
	INCLUDE INTUITION/INTUITION_LIB.I
	INCLUDE INTUITION/INTUITION.I
	INCLUDE	OWN/CCRMAKRO
	INCLUDE	own/whdload.i
	INCLUDE	own/whdmacros.i
	ENDC

	IFD WEPL
	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i
	OUTPUT	"DWArt:crionicssilents/hardwired/Hardwired.slave"
	BOPT	O+			;enable optimizing
	BOPT	OG+			;enable optimizing
	BOPT	ODd-			;disable mul optimizing
	BOPT	ODe-			;disable mul optimizing
	BOPT	w4-			;disable 64k warnings
	BOPT	wo-			;disable opt warnings
	SUPER				;disable supervisor warnings
	ENDC

;DEBUG
 IFD DEBUG
PATCHCOUNT
 ENDC

;============================================================================

_base		SLAVE_HEADER			;ws_Security + ws_ID
		dc.w	10			;ws_Version
		dc.w	WHDLF_Disk|WHDLF_NoError|WHDLF_EmulTrap	;ws_flags
		dc.l	$100000			;ws_BaseMemSize
		dc.l	0			;ws_ExecInstall
		dc.w	Start-_base		;ws_GameLoader
		dc.w	0			;ws_CurrentDir
		dc.w	0			;ws_DontCache
_keydebug	dc.b	0			;ws_keydebug
_keyexit	dc.b	$59			;ws_keyexit = F10
EXPMEM = $1000
_expmem		dc.l    EXPMEM                  ;ws_ExpMem
		dc.w    _name-_base             ;ws_name
		dc.w    _copy-_base             ;ws_copy
		dc.w    _info-_base             ;ws_info

;============================================================================

	IFD BARFLY
	DOSCMD  "WDate  >T:date"
	ENDC

_name		dc.b	"Hardwired",0
_copy		dc.b	"1991 Crionics/Silents",0
_info		dc.b	"installed and fixed by Mr.Larmer & Wepl & Harry",10
		dc.b	"Version 1.1 "
	IFD BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
	EVEN

;======================================================================
Start	;	A0 = resident loader
;======================================================================

		lea	_resload(pc),a1
		move.l	a0,(a1)			;save for later use

		move.l	(_expmem),a7
		add.l	#EXPMEM-8,a7

_start		bsr	_CacheOn
		
		move	#0,sr			;user mode

		move.l	#0,d0			;offset
		move.l	#$2c00,d1		;size
		moveq	#1,d2			;disk
		lea	$7c00,a0		;data
		move.l	(_resload),a3
		jsr	(resload_DiskLoad,a3)

		skip	$80be-$8030,$8030	;skip checking cpu speed and ext memory

		clr.w	$80ca			;fix destroyed start message
		lea	$87f8,a0
		lea	($340,a0),a1
		lea	($d0,a0),a2
.cp		move.l	(a1)+,(a0)+
		cmp.l	a2,a0
		blo	.cp

		pea	_1
		move.l	(a7)+,$80fc

		jmp	$8000

_1		skip	$244-$21e,$21e		; clear mem

		move.w	#$6008,$386.w		; skip set address in jmp 0

		pea	Patch3(pc)
		move.l	(A7)+,$3D0.w

		move.w	#$4EF9,$3F4.w
		pea	Load(pc)
		move.l	(A7)+,$3F6.w

		jmp	$200

Patch3		move.w	#$4EF9,$E3350
		pea	Load(pc)
		move.l	(A7)+,$E3352

		patch	$e40b2,_ChangeDisk
		
		patchs	$e420e,_coff

		move.l	#$4E714EB9,$E44D0
		pea	Patch5(pc)
		move.l	(A7)+,$E44D4
		
	IFD DEBUG
		ret	$e4e62
		nops	1,$e427a		;skip "credits"
		ret	$e468a			;skip "zoom scroll"
		ret	$e4730			;skip "cube"
		ret	$e47a6			;skip "shade bobs"
	;	ret	$e4850			;skip "glenz"
	;	ret	$e9d0a			;skip "spline"
	ENDC
	
	;	st	$e7df6
	;	patchs	$e48d0,_gl1
	;	patch	$e48c6,_gl1
	;	ill	$e7d70
		
		move.w	#$082c,$f868e		;btst #14,(2,a6) --> btst #14,(2,a4)
		lea	$f7000,a0
		lea	$f9000,a1
		lea	$10,a2
		bsr	_blitfix_imm_58a6
		
	;	patchs	$e4de0,_af1

	;	patch	$fa5b0,.bw1

		move.l	#$c9444eb9,$f91c6	;patch vbi of pixelized vectors
		pea	waitl2c(pc)
		move.l	(a7)+,$f91ca
		
		jmp	$e3fbc

waitl2c		move.l	d0,-(a7)		;wait to fix transformation of pixelized v.
.1		move.l	$dff004,d0
		and.l	#$3ff00,d0
		cmp.l	#$2c00,d0
		bls.s	.1
		move.l	(a7)+,d0
		cmp.w	#$c8,$f93ae
		rts

	ifeq 1
_af1		cmp.w	#40,$dff006
		bls	_af1
		tst.l	$e4e5a
		rts
	endc

	ifeq 1
_gl1		waitvb
		move.l	#$e4920,$e4e5a
		jmp	$e48d0
	endc

_ChangeDisk	lea	DiskNr(pc),A0
		move.w	#2,(A0)

	IFND DEBUG
		bsr	_CacheOff
		
		jsr	$fa11a			;the first part

.wait		cmp.w	#$390,$fc82e
		blo	.wait

		bsr	_CacheOn
	ENDC

		jmp	$e40de

_coff		bsr	_CacheOff
		jmp	$e2ae8			;original

Patch5		pea	Patch6(pc)
		move.l	(A7)+,$AC68E

		clr.l	$DFF1BC
		jmp	(A0)

Patch6		move.w	#$4EF9,$35EB0
		pea	Load(pc)
		move.l	(A7)+,$35EB2

		move.l	#$4E714EB9,$36154
		pea	Patch7(pc)
		move.l	(A7)+,$36158

		jmp	$360C0
Patch7
		pea	_restart
		move.l	(A7)+,$80.w

		move.w	#$4E40,$3D308		; use trap #0 for exit

		move.l	$36234,A0
		jmp	(A0)

_restart	waitvb
		move.w	#$7fff,_custom+dmacon
		move.w	#$7fff,_custom+intena
		lea	$80000,a7
		lea	(DiskNr),a0
		move.w	#1,(a0)
		bra	_start

DiskNr		dc.w	1

Load		movem.l	D0-A2,-(A7)
		mulu	#$1600,D0
		mulu	#$1600,D1
		move.w	DiskNr(pc),d2
		move.l	_resload(pc),a2
		jsr	resload_DiskLoad(a2)
		movem.l	(A7)+,D0-A2
		rts

;--------------------------------

_CacheOn	movem.l	d0-d1/a0-a1,-(a7)
		moveq	#CACRF_EnableI,d0
		moveq	#CACRF_EnableI,d1
		move.l	(_resload),a0
		jsr	(resload_SetCACR,a0)
		movem.l	(a7)+,d0-d1/a0-a1
		rts

_CacheOff	movem.l	d0-d1/a0-a1,-(a7)
		moveq	#0,d0
		moveq	#CACRF_EnableI,d1
		move.l	(_resload),a0
		jsr	(resload_SetCACR,a0)
		movem.l	(a7)+,d0-d1/a0-a1
		rts

;--------------------------------

_resload	dc.l	0		;address of resident loader

;======================================================================

	INCLUDE	Sources:whdload/blitfix_imm_58a6.s

;======================================================================

	END


