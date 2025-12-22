;*---------------------------------------------------------------------------
;  :Program.	wildwestworld.asm
;  :Contents.	Slave for "Wild West World" from Software 2000
;  :Author.	Wepl
;  :Original	v1.x Christian Sauer
;		v1.3
;		v2.0
;  :Version.	$Id: wildwestworld.asm 1.9 2004/01/18 13:34:17 wepl Exp wepl $
;  :History.	07.08.00 started
;		03.08.01 some steps forward ;)
;		30.01.02 final beta
;		24.04.02 final
;		24.07.02 setmap added (v2.0)
;		05.08.02 1.1 release
;		20.08.02 v1.x added
;		06.10.02 v2.1en added
;		03.03.03 cleanup, correct stack on startup
;		18.01.04 df0 assign update
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Devpac 3.14, Barfly 2.9
;  :To Do.
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i
	INCLUDE	lvo/dos.i

	IFD BARFLY
	OUTPUT	"wart:wi/wildwestworld/WildWestWorld.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER
	ENDC

;============================================================================

CHIPMEMSIZE	= $100000
FASTMEMSIZE	= $0000
NUMDRIVES	= 1
WPDRIVES	= %0000

BLACKSCREEN
;DEBUG
;DISKSONBOOT
DOSASSIGN
HDINIT
;HRTMON
IOCACHE		= 10000
;MEMFREE	= $200
;NEEDFPU
;SETPATCH

;============================================================================

KICKSIZE	= $40000			;34.005
BASEMEM		= CHIPMEMSIZE
EXPMEM		= KICKSIZE+FASTMEMSIZE

;============================================================================

_base		SLAVE_HEADER			;ws_Security + ws_ID
		dc.w	15			;ws_Version
		dc.w	WHDLF_NoError|WHDLF_EmulPriv|WHDLF_Examine	;ws_flags
		dc.l	BASEMEM			;ws_BaseMemSize
		dc.l	0			;ws_ExecInstall
		dc.w	_boot-_base		;ws_GameLoader
		dc.w	_data-_base		;ws_CurrentDir
		dc.w	0			;ws_DontCache
_keydebug	dc.b	0			;ws_keydebug
_keyexit	dc.b	$59			;ws_keyexit = F10
_expmem		dc.l	EXPMEM			;ws_ExpMem
		dc.w	_name-_base		;ws_name
		dc.w	_copy-_base		;ws_copy
		dc.w	_info-_base		;ws_info

;============================================================================

	IFD BARFLY
	DOSCMD	"WDate  >T:date"
	ENDC

_disk1		dc.b	"df0",0
_name		dc.b	"Wild West World",0
_copy		dc.b	"1990 Software 2000",0
_info		dc.b	"adapted by Wepl",10
		dc.b	"Version 1.3 "
	IFD BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
_data		dc.b	"data",0
_program	dc.b	"www_start",0
_program2	dc.b	"wildwestworld",0
_args		dc.b	10
_args_end	dc.b	0
_setmap		dc.b	"setmap d",10,0
	EVEN

;============================================================================

_bootdos	lea	(_saveregs),a0
		movem.l	d1-d6/a2-a6,(a0)
		move.l	(a7)+,(44,a0)

	;open doslib
		lea	(_dosname,pc),a1
		move.l	(4),a6
		jsr	(_LVOOldOpenLibrary,a6)
		lea	(_dosbase),a0
		move.l	d0,(a0)
		move.l	d0,a6			;A6 = dosbase

	;assigns
		lea	(_disk1),a0
		sub.l	a1,a1
		bsr	_dos_assign

	;check version
		lea	_program2,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		jsr	(_LVOOpen,a6)
		move.l	d0,d1
		move.l	#300,d3
		sub.l	d3,a7
		move.l	a7,d2
		jsr	(_LVORead,a6)
		move.l	d3,d0
		move.l	a7,a0
		move.l	(_resload),a2
		jsr	(resload_CRC16,a2)
		add.l	d3,a7
		
		moveq	#10,d2
		lea	(_pl1_10),a3
		lea	(_pl2_10),a4
		cmp.w	#$4299,d0
		beq	.vok
		moveq	#13,d2
		lea	(_pl1_13),a3
		lea	(_pl2_13),a4
		cmp.w	#$6687,d0
		beq	.vok
		moveq	#20,d2
	;	lea	(_pl1_20),a3
	;	lea	(_pl2_20),a4
		cmp.w	#$7303,d0
		beq	.vok
		moveq	#21,d2
	;	lea	(_pl1_21),a3
		lea	(_pl2_21),a4
		cmp.w	#$dd8e,d0
		beq	.vok
		pea	TDREASON_WRONGVER
		jmp	(resload_Abort,a2)
.vok

	;setmap
		cmp.b	#20,d2
		bne	.nosetmap
		lea	_setmap,a0
		move.l	a0,d1
		moveq	#0,d2
		moveq	#0,d3
		jsr	(_LVOExecute,a6)
.nosetmap
		lea	(_pl2),a0
		move.l	a4,(a0)

	;load exe
		lea	_program,a0
		move.l	a0,d1
		jsr	(_LVOLoadSeg,a6)
		move.l	d0,d7			;D7 = segment
		beq	.end

	;patch
		move.l	a3,a0
		move.l	d7,a1
		jsr	(resload_PatchSeg,a2)

	IFD DEBUG
	;set debug
		clr.l	-(a7)
		move.l	d7,-(a7)
		pea	WHDLTAG_DBGSEG_SET
		move.l	a7,a0
		jsr	(resload_Control,a2)
		add.w	#12,a7
	ENDC

	;call
		move.l	d7,a1
		add.l	a1,a1
		add.l	a1,a1
		moveq	#_args_end-_args,d0
		lea	(_args,pc),a0
		movem.l	(_saveregs),d1-d6/a2-a6
		jsr	(4,a1)

	;remove exe
		move.l	d7,d1
		move.l	(_dosbase),a6
		jsr	(_LVOUnLoadSeg,a6)

	;load exe
		lea	_program2,a0
		move.l	a0,d1
		jsr	(_LVOLoadSeg,a6)
		move.l	d0,d7			;D7 = segment
		beq	.end

	;patch
		move.l	(_pl2),a0
		move.l	d7,a1
		move.l	(_resload),a2
		jsr	(resload_PatchSeg,a2)

	IFD DEBUG
	;set debug
		clr.l	-(a7)
		move.l	d7,-(a7)
		pea	WHDLTAG_DBGSEG_SET
		move.l	a7,a0
		jsr	(resload_Control,a2)
		add.w	#12,a7
	ENDC

	;call
		move.l	d7,a1
		add.l	a1,a1
		add.l	a1,a1
		moveq	#_args_end-_args,d0
		lea	(_args,pc),a0
		movem.l	(_saveregs),d1-d6/a2-a6
		jsr	(4,a1)

		pea	TDREASON_OK
		jmp	(resload_Abort,a2)

	IFEQ 1
	;remove exe
		move.l	d7,d1
		move.l	(_dosbase),a6
		jsr	(_LVOUnLoadSeg,a6)
	ENDC

.end		moveq	#0,d0
		move.l	(_saverts),-(a7)
		rts

_pl1_10		PL_START
		PL_PS	$bfc,_dbffix
		PL_W	$bfc+6,$32c
		PL_PS	$c12,_dbffix
		PL_W	$c12+6,$32c
		PL_END
_pl1_13
_pl1_20
_pl1_21		PL_START
		PL_PS	$d16,_dbffix
		PL_W	$d16+6,$32c
		PL_PS	$d2c,_dbffix
		PL_W	$d2c+6,$32c
		PL_END

_pl2_10		PL_START
		PL_P	$2e566,_smc1
		PL_PS	$2e76c,_dbffix
		PL_W	$2e76c+6,$1f4
		PL_END
_pl2_13
_pl2_20		PL_START
		PL_P	$926,_smc1
		PL_PS	$b2c,_dbffix
		PL_W	$b2c+6,$1f4
		PL_END

_pl2_21		PL_START
		PL_P	$138,_smc1
		PL_END

_smc1		move.b	#6,(a4)			;original
		bra	_flushcache

_dbffix		movem.l	d0-d1/a0,-(a7)
		move.l	(12,a7),a0
		moveq	#0,d0
		move.w	(a0)+,d0
		divu	#34,d0
.1		move.b	$dff006,d1
.2		cmp.b	$dff006,d1
		beq	.2
		dbf	d0,.1
		movem.l	(a7)+,d0-d1/a0
		addq.l	#2,(a7)
		rts

;============================================================================

	INCLUDE	Sources:whdload/kick13.s

;============================================================================

_saveregs	ds.l	11
_saverts	dc.l	0
_dosbase	dc.l	0
_pl2		dc.l	0

;============================================================================

	END
