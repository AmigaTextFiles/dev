;*---------------------------------------------------------------------------
;  :Program.	oscar.asm
;  :Contents.	Slave for "Oscar"
;  :Author.	wepl <wepl@whdload.de>
;  :Original.	v1 Desktop Dynamite <wepl@whdload.de>
;		v2
;		v3 CD³²
;		v4 CD³² Diggers Bundle
;  :Version.	$Id: oscar.asm 1.15 2006/05/07 19:41:34 wepl Exp wepl $
;  :History.	20.05.96
;		16.06.97 updated for slave version 2
;		15.08.97 update for key managment
;		15.07.98 cache on 68040+ disabled
;		08.05.99 adapted for WHDLoad 10.0, access faults removed
;		08.12.99 support for v2 added
;		16.01.00 support for v3 added
;		23.02.01 support for v4 added, underwater bug fixed
;		26.03.02 decruncher moved to fastmem
;		18.01.06 version bumped
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V2.9
;  :To Do.
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i
	INCLUDE	libraries/lowlevel.i

	IFD BARFLY
	OUTPUT	"wart:o/oscar/Oscar.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER					;disable supervisor warnings
	ENDC

	STRUCTURE	globals,$100
		LONG	_resload
		LONG	_chipptr
		LONG	_clist
		BYTE	_decinit

;============================================================================

_base		SLAVE_HEADER			;ws_Security + ws_ID
		dc.w	10			;ws_Version
		dc.w	WHDLF_NoError		;ws_flags
_upchip		dc.l	$181000			;ws_BaseMemSize 
						;floppy vers need only $177000
		dc.l	0			;ws_ExecInstall
		dc.w	_Start-_base		;ws_GameLoader
		dc.w	_data-_base		;ws_CurrentDir
		dc.w	0			;ws_DontCache
_keydebug	dc.b	0			;ws_keydebug
_keyexit	dc.b	$59			;ws_keyexit = F10
_expmem		dc.l	$1000			;ws_ExpMem
		dc.w	_name-_base		;ws_name
		dc.w	_copy-_base		;ws_copy
		dc.w	_info-_base		;ws_info

;============================================================================

	IFD BARFLY
	IFND	.passchk
	DOSCMD	"WDate  >T:date"
.passchk
	ENDC
	ENDC

_data		dc.b	"data",0
_name		dc.b	"Oscar",0
_copy		dc.b	"1993 Flair Software",0
_info		dc.b	"installed & fixed by Wepl",10
		dc.b	"version 1.9 "
	IFD BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
	EVEN

;============================================================================
_Start		;	A0 = resident loader
;============================================================================

	;save resload base
		move.l	a0,(_resload)			;save
		move.l	a0,a5				;A5 = resload
		sf	(_decinit)			;decruncher not init

	;set stackpointers
		move.l	(_expmem),a7
		add.w	#$ff0,a7
		lea	(-$400,a7),a0
		move	a0,usp

	;set start address for emulated exec.AllocMem
		move.l	#$400,(_chipptr)

	;load main
		lea	(_exe,pc),a0			;name
		move.l	(_chipptr),a1			;address
		move.l	a1,a4				;A4 = executable
		jsr	(resload_LoadFileDecrunch,a5)
	;relocate main
		move.l	a4,a0				;address
		sub.l	a1,a1				;taglist
		jsr	(resload_Relocate,a5)
		add.l	d0,(_chipptr)
	;check version & apply patches
		lea	(_pexe1,pc),a0			;patchlist
		cmp.l	#$2f2d4,d0
		beq	.patch
		lea	(_pexe2,pc),a0			;patchlist
		cmp.l	#$2cf58,d0
		beq	.patch
		lea	(_pexe3,pc),a0			;patchlist
		cmp.l	#$a80d8,d0
		beq	.patch
		lea	(_pexe4,pc),a0			;patchlist
		cmp.l	#$300a0,d0
		beq	.patch
		pea	TDREASON_WRONGVER
		jmp	(resload_Abort,a5)
		
.patch		move.l	a4,a1				;address
		jsr	(resload_Patch,a5)

	;init ints
		lea	(_vbi,pc),a0
		move.l	a0,($6c)
		bsr	_SetupKeyboard			;required for cd versions

	;init dma
		lea	(_clist),a0
		move.l	#-2,(a0)
		move.l	a0,(_custom+cop1lc)

	;start main
		move	#0,sr
		jmp	($3e,a4)

_pexe1		PL_START
		PL_P	$8b4e,_allocmem			;emulate
		PL_S	$276,$2a8-$276			;disable os-stuff
		PL_P	$7b1a,_loader
		PL_PS	$8dfc,_decrunch
		PL_W	$1ce2,$e841			;lsr.w  -> asr.w
		PL_W	$1ce4,$c3fc			;mulu   -> muls
		PL_W	$1cfc,$d0c1			;adda.l -> adda.w
		PL_W	$1e0e,$e841			;lsr.w  -> asr.w
		PL_W	$1e10,$c3fc			;mulu   -> muls
		PL_W	$1e28,$d0c1			;adda.l -> adda.w
		PL_S	$9764,$99fc-$9764		;copylock
		PL_PS	$23fa2,_dbf1
		PL_PS	$23fb8,_dbf1
		PL_PS	$246e2,_dbf1
		PL_PS	$246f8,_dbf1
		PL_PS	$2558a,_dbf2
		PL_PS	$255ee,_dbf2
		PL_END

_pexe2		PL_START
		PL_P	$8b56,_allocmem			;emulate
		PL_S	$276,$2a8-$276			;disable os-stuff
		PL_P	$7b22,_loader
		PL_PS	$8e04,_decrunch
		PL_W	$1cbc,$e841			;lsr.w  -> asr.w
		PL_W	$1cbe,$c3fc			;mulu   -> muls
		PL_W	$1cd6,$d0c1			;adda.l -> adda.w
		PL_W	$1de8,$e841			;lsr.w  -> asr.w
		PL_W	$1dea,$c3fc			;mulu   -> muls
		PL_W	$1e02,$d0c1			;adda.l -> adda.w
		PL_S	$976c,$9a04-$976c		;copylock
		PL_PS	$21c26,_dbf1
		PL_PS	$21c3c,_dbf1
		PL_PS	$22366,_dbf1
		PL_PS	$2237c,_dbf1
		PL_PS	$2320e,_dbf2
		PL_PS	$23272,_dbf2
		PL_END

_pexe3		PL_START
		PL_P	$76fc,_allocmem			;emulate
		PL_S	$200,$254-$200			;disable os-stuff
	;	PL_W	$b48e,$4e73			;jmp to org vbi -> rte
		PL_S	$750e,$86-$e			;skip os-restore
		PL_S	$75a8,10			;skip open
		PL_PS	$75de,_loadercd
		PL_S	$7630,14+$14			;skip os-save
		PL_PS	$330,_enabledma
		PL_W	$199c,$e841			;lsr.w  -> asr.w
		PL_W	$199e,$c3fc			;mulu   -> muls
		PL_W	$19b0,$d0c1			;adda.l -> adda.w
		PL_W	$1ac2,$e841			;lsr.w  -> asr.w
		PL_W	$1ac4,$c3fc			;mulu   -> muls
		PL_W	$1ad6,$d0c1			;adda.l -> adda.w
		PL_PS	$2d8fc,_dbf1
		PL_PS	$2d912,_dbf1
		PL_PS	$2e03c,_dbf1
		PL_PS	$2e052,_dbf1
		PL_PS	$2eed2,_dbf2
		PL_PS	$2ef36,_dbf2
		PL_END

_pexe4		PL_START
		PL_S	$3e,$b4-$3e			;skip os
		PL_PS	$b4,_getlang
		PL_P	$89ec,_allocmem			;emulate
		PL_S	$2e0,$326-$2e0			;disable os-stuff
		PL_S	$797a,$cc-$7a			;skip os-restore
		PL_S	$79ee,10			;skip open
		PL_PS	$7a24,_loadercd
		PL_S	$7a54,$68-$54			;skip os-save
		PL_W	$1ccc,$e841			;lsr.w  -> asr.w
		PL_W	$1cce,$c3fc			;mulu   -> muls
		PL_W	$1ce6,$d0c1			;adda.l -> adda.w
		PL_W	$1df8,$e841			;lsr.w  -> asr.w
		PL_W	$1dfa,$c3fc			;mulu   -> muls
		PL_W	$1e12,$d0c1			;adda.l -> adda.w
		PL_R	$b5c0				;cd.device
		PL_R	$b614				;cd.device
		PL_PS	$afe2,_readjoy			;lowlevel.ReadJoyPort
	;	PL_PS	$b01e,_readjoy			;lowlevel.ReadJoyPort
	;	PL_PS	$b03e,_readjoy			;lowlevel.ReadJoyPort
	;	PL_PS	$b060,_readjoy			;lowlevel.ReadJoyPort
		PL_PS	$22e0c,_dbf1
		PL_PS	$22e22,_dbf1
		PL_PS	$2354c,_dbf1
		PL_PS	$23562,_dbf1
		PL_PS	$243f4,_dbf2
		PL_PS	$24458,_dbf2
		PL_END

;--------------------------------

_getlang	clr.l	-(a7)
		clr.l	-(a7)
		pea	WHDLTAG_LANG_GET
		move.l	a7,a0
		move.l	(_resload),a1
		jsr	(resload_Control,a1)
		addq.l	#4,a7
		move.l	(a7)+,d0
		addq.l	#4,a7
		rts

;--------------------------------

_dbf2
_dbf1		movem.l	d0-d1,-(a7)
		moveq	#8,d1
.1		move.b	($dff006),d0
.2		cmp.b	($dff006),d0
		beq	.2
		dbf	d1,.1
		movem.l	(a7)+,d0-d1
		addq.l	#2,(a7)
		rts

;--------------------------------

_vbi		move.w	#INTF_VERTB,(_custom+intreq)
		rte

;--------------------------------

_allocmem	addq.l	#7,d0				;round up
		and.b	#$f8,d0

		move.l	(_chipptr),a1
		add.l	d0,(_chipptr)
	IFEQ 1
		move.l	(_chipptr),d1
		cmp.l	(_upchip,pc),d1
		blo	.0
		illegal
.0
	ENDC
		move.l	a1,a0
		lsr.l	#3,d0
.clr		clr.l	(a0)+
		clr.l	(a0)+
		subq.l	#1,d0
		bne	.clr
		move.l	a1,d0
		rts

;--------------------------------

_loader		addq.l	#4,a0				;skip "df0:"
		move.l	a2,-(a7)
		move.l	(_resload),a2
		jsr	(resload_LoadFileDecrunch,a2)
		move.l	(a7)+,a2
		moveq	#0,d0				;return code
		rts

_decrunch	bset	#0,(_decinit)
		bne	.initok
		movem.l	d0/a0-a1,-(a7)
		move.l	(12,a7),a0
		move.l	(_expmem,pc),a1
		move.w	#($9266-$8e02)/4-1,d0
.cp		move.l	(a0)+,(a1)+
		dbf	d0,.cp
		move.l	(_resload),a0
		jsr	(resload_FlushCache,a0)
		movem.l	(a7)+,d0/a0-a1

.initok		addq.l	#4,a7
		cmp.l	#"TSM!",(a0)
		bne	.rts

		movem.l	d0-d7/a0-a6,-(a7)
		addq.l	#4,a0
		move.l	(_expmem,pc),-(a7)
.rts		rts

_loadercd	addq.l	#6,a0				;skip "Oscar:"
		move.l	d2,a1
		move.l	(_resload),a2
		jsr	(resload_LoadFileDecrunch,a2)
		add.l	#14,(a7)
		rts

;--------------------------------

_enabledma	move.w	#$c028,(intena,a6)
		waitvb	a6
		move.w	#$86e0!DMAF_RASTER,(dmacon,a6)
		rts

;--------------------------------

_readjoy	move.l	d2,-(a7)

		moveq	#0,d0
		btst	#7,$bfe001
		bne	.1
		bset	#JPB_BUTTON_RED,d0
.1		move.w	_custom+potinp,d1
		btst	#14,D1
		bne	.2
		bset	#JPB_BUTTON_BLUE,d0
.2
		move.w	_custom+joy1dat,d1
		move.w	d1,d2
		btst	#1,d1
		beq	.left_off
		bset	#JPB_JOY_RIGHT,d0
		bra	.vert_test
.left_off	btst	#9,d1
		beq	.vert_test
		bset	#JPB_JOY_LEFT,d0
.vert_test	lsr.w	#1,d1
		eor.w	d2,d1
		btst	#0,d1
		beq	.back_off
		bset	#JPB_JOY_DOWN,d0
		bra	.exit
.back_off	btst	#8,d1
		beq	.exit
		bset	#JPB_JOY_UP,d0
.exit
		move.l	(a7)+,d2
		rts

;--------------------------------

_exe		dc.b	"exe",0

;============================================================================

		INCLUDE	sources:whdload/keyboard.s

;============================================================================

	END
