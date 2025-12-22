;*---------------------------------------------------------------------------
;  :Program.	newyorkwarriors.asm
;  :Contents.	Slave for "New York Warriors" from Arcadia Systems
;  :Author.	Wepl
;  :Original	v1 sascha steinert
;		v2 chris vella
;  :Version.	$Id: newyorkwarriors.asm 1.3 2001/11/22 20:25:27 wepl Exp wepl $
;  :History.	30.08.01 started
;		09.09.01 support for v2 added
;		21.11.01 more bugs fixed
;		22.11.01 finished
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Devpac 3.14, Barfly 2.9
;  :To Do.
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i
	INCLUDE	lvo/intuition.i

	IFD BARFLY
	OUTPUT	"wart:n/newyorkwarriors/NewYorkWarriors.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER
	ENDC

_hadr	= $120
_allocmem = $124
MEMLOG	= 0

;============================================================================

CHIPMEMSIZE	= $ff000
FASTMEMSIZE	= $00000
NUMDRIVES	= 1
WPDRIVES	= %1111

BLACKSCREEN
;DISKSONBOOT
;HRTMON
;MEMFREE	= $130
;NEEDFPU
;SETPATCH

;============================================================================

KICKSIZE	= $40000			;34.005
BASEMEM		= CHIPMEMSIZE
EXPMEM		= KICKSIZE+FASTMEMSIZE

;============================================================================

_base		SLAVE_HEADER			;ws_Security + ws_ID
		dc.w	13			;ws_Version
		dc.w	WHDLF_EmulPriv|WHDLF_NoError	;ws_flags
		dc.l	BASEMEM			;ws_BaseMemSize
		dc.l	0			;ws_ExecInstall
		dc.w	_start-_base		;ws_GameLoader
		dc.w	_data-_base		;ws_CurrentDir
		dc.w	0			;ws_DontCache
_keydebug	dc.b	0			;ws_keydebug
_keyexit	dc.b	$59			;ws_keyexit = F10
_expmem
	IFNE MEMLOG
		dc.l	EXPMEM+$10000		;ws_ExpMem
	ELSE
		dc.l	EXPMEM			;ws_ExpMem
	ENDC
		dc.w	_name-_base		;ws_name
		dc.w	_copy-_base		;ws_copy
		dc.w	_info-_base		;ws_info

;============================================================================

	IFD BARFLY
	DOSCMD	"WDate  >T:date"
	ENDC

_name		dc.b	"New York Warriors",0
_copy		dc.b	"1990 Arcadia Systems",0
_info		dc.b	"adapted and fixed by Wepl",10
		dc.b	"Version 1.1 "
	IFD BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
_data		dc.b	"data",0
_main		dc.b	"z",0
_highs		dc.b	"highs",0
_intname	dc.b	"intuition.library",0
	EVEN

;============================================================================
_start	;	A0 = resident loader
;============================================================================

	IFEQ 1
		sub.l	#$1000,a7
		move.l	a0,a2
		lea	_ny,a0
		lea	$1000,a1
		jsr	(resload_LoadFileDecrunch,a2)
		lea	$1000,a0
		sub.l	a1,a1
		jsr	(resload_Relocate,a2)
	mc68020
		movec	vbr,a0
		lea	_trace,a1
		move.l	a1,$24(a0)
		move	#$a700,sr
		jmp	$104e

_trace		;cmp.w	#-1,d7
		;beq	_ill
		cmp.l	#$1126,(2,a7)
		beq	_f1
		cmp.l	#$1148,(2,a7)
		beq	_ill
		nop
		rte
_f1		move.l	d2,d3
		add.l	#2,(2,a7)
		rte
_ill		illegal

_ny		dc.b	"newyork",0
	ENDC

	;initialize kickstart and environment
		bra	_boot

_bootearly	move.l	(_resload,pc),a2	;a2 = resload

	;enable cache
	;	move.l	#WCPUF_Base_NC|WCPUF_Exp_NC|WCPUF_Slave_CB|WCPUF_IC|WCPUF_DC|WCPUF_BC|WCPUF_SS|WCPUF_SB|WCPUF_NWA,d0
	;	move.l	#0,d0
	;	move.l	#WCPUF_All,d1
	;	jsr	(resload_SetCPU,a2)

		lea	_intname,a1
		move.l	(4),a6
		jsr	(_LVOOldOpenLibrary,a6)
		move.l	d0,a6
		lea	_newscreen,a0
		jsr	(_LVOOpenScreen,a6)

		move.l	#54200,d0
		moveq	#MEMF_CHIP,d1
		move.l	(4),a6
		jsr	(_LVOAllocMem,a6)
		move.l	d0,a5			;a5 = main

		lea	(_main),a0
		move.l	a5,a1
		jsr	(resload_LoadFileDecrunch,a2)
		
		move.l	a5,a0
		sub.l	a1,a1
		jsr	(resload_Relocate,a2)
		
		lea	_pl1,a0
		lea	$af94,a1
		lea	_go1,a4
		cmp.l	#$4efa02a6,(a5)
		beq	.ok
		lea	_pl2,a0
		lea	$bbd8,a1
		lea	(a5),a4
		cmp.l	#$4efa04c6,(a5)
		beq	.ok
		pea	TDREASON_WRONGVER
		jmp	(resload_Abort,a2)

.ok		add.l	a5,a1
		move.l	a1,_hadr
		move.l	a5,a1
		jsr	(resload_Patch,a2)
		
		lea	_highs,a0
		jsr	(resload_GetFileSize,a2)
		tst.l	d0
		beq	.nohighs
		lea	_highs,a0
		move.l	_hadr,a1
		jsr	(resload_LoadFileDecrunch,a2)
		bsr	_crypt
.nohighs
		clr.l	-(a7)
		pea	(a5)
		pea	WHDLTAG_DBGADR_SET
		move.l	a7,a0
		jsr	(resload_Control,a2)

	IFEQ MEMLOG
		move.l	(4),a0
		move.l	(_LVOAllocMem+2,a0),(_allocmem)
		pea	_allocfix
		move.l	(a7)+,(_LVOAllocMem+2,a0)
	ELSE
	move.l	_expmem,a1
	add.l	#KICKSIZE,a1
	pea	($10,a1)
	move.l	(a7)+,(a1)+
	move.l	4,a0
	move.l	_LVOAllocMem+2(a0),(a1)+
	move.l	_LVOFreeMem+2(a0),(a1)+
	move.l	_LVOAvailMem+2(a0),(a1)+
	pea	.alloc
	move.l	(a7)+,_LVOAllocMem+2(a0)
	pea	.free
	move.l	(a7)+,_LVOFreeMem+2(a0)
	pea	.avail
	move.l	(a7)+,_LVOAvailMem+2(a0)
	bra	.xxx
.alloc	move.l	_expmem,a0
	add.l	#KICKSIZE,a0
	add.l	#16,(a0)
	sub.l	#4,a7
	pea	.ret
	move.l	(4,a0),-(a7)
	move.l	(a0),a0
	move.l	a0,(8,a7)
	move.l	(12,a7),(-16,a0)
	move.b	#"A",(-16,a0)
	move.l	d0,(-12,a0)
	move.l	d1,(-8,a0)
	rts
.free	move.l	_expmem,a0
	add.l	#KICKSIZE,a0
	add.l	#16,(a0)
	sub.l	#4,a7
	pea	.ret
	move.l	(8,a0),-(a7)
	move.l	(a0),a0
	move.l	a0,(8,a7)
	move.l	(12,a7),(-16,a0)
	move.b	#"F",(-16,a0)
	move.l	d0,(-12,a0)
	move.l	a1,(-8,a0)
	rts
.avail	move.l	_expmem,a0
	add.l	#KICKSIZE,a0
	add.l	#16,(a0)
	sub.l	#4,a7
	pea	.ret
	move.l	(12,a0),-(a7)
	move.l	(a0),a0
	move.l	a0,(8,a7)
	move.l	(12,a7),(-16,a0)
	move.b	#"V",(-16,a0)
	move.l	d1,(-12,a0)
	rts
.ret	move.l	(a7)+,a0
	move.l	d0,-(a0)
	rts
.xxx
	ENDC
		sub.l	a0,a0			;cli argument string
		jsr	(a4)
		illegal
		
_go1		move.w	#0,d0			;start level? but does not work...
		move.l	a5,a4
		add.l	#$ab0c+$7ffe,a4
		jmp	($2c2,a5)

_pl1	PL_START
	PL_S	$d26,$32-$26		;open doslib
	PL_PS	$30,_load1
	PL_PS	$4a,_load2
	PL_S	$82ce,$dc-$ce
	PL_P	$82e0,_load3
	PL_R	$6282			;insert disk 2
	PL_PS	$1654,_loadseg
	PL_PS	$17da,_unloadseg
	PL_P	$82f8,_open
	PL_P	$8310,_seek
	PL_P	$8328,_read
	PL_P	$8340,_close
	PL_PS	$1e06,_f1v1
	PL_S	$cae,$cc6-$cae		;cia accesses
	PL_PS	$5842,_b1
	PL_P	$6abe,_saveh
	PL_PS	$574a,_b2
	PL_PS	$169c,_f2
	PL_END

_pl2	PL_START
	PL_S	$8,$20-$8		;always allocate MEMF_ANY
	PL_S	$78,$90-$78		;loading 'static0'
	PL_PS	$9a,_load4		;loading 'static0'
	PL_S	$124,2			;loading 'segment?'
	PL_S	$128,$140-$128		;loading 'segment?'
	PL_PS	$144,_load4		;loading 'segment?'
	PL_S	$15c,$162-$15c		;loading 'segment?'
	PL_S	$28c,$2aa-$28c		;loading 'nyw2:#?'
	PL_PS	$2b4,_load4		;loading 'nyw2:#?'
	PL_R	$efc			;cia access
	PL_S	$f5c,$32-$26		;open doslib
	PL_PS	$192e,_loadseg2
	PL_PS	$1976,_f2
	PL_PS	$1ab4,_unloadseg
	PL_PS	$210a,_f1v2
	PL_PS	$6180,_b2
	PL_PS	$63f8,_b1
	PL_R	$6e82			;insert disk 2
	PL_P	$76fc,_saveh
	;PL_S	$82ce,$dc-$ce
	;PL_P	$82e0,_load3
	PL_S	$8e2e,2			;dont reduce mem for instruments
	PL_P	$8f10,_open
	PL_P	$8f28,_seek
	PL_P	$8f40,_read
	PL_P	$8f58,_close
	PL_END

	;game does not test return value correctly!
_allocfix	pea	.1
		move.l	(_allocmem),-(a7)
		rts
.1		tst.l	d0
		rts

_load4		move.l	a2,-(a7)
		move.l	d2,a1
		move.l	_resload,a2
		jsr	(resload_LoadFileDecrunch,a2)
		move.l	(a7)+,a2
		addq.l	#4,(a7)
		rts

_f2		subq.w	#1,d0
.lp		move.w	(a1)+,(a0)+
		dbf	d0,.lp
		rts

_saveh		bsr	_crypt
		move.l	#$b00c-$af94,d0
		lea	_highs,a0
		move.l	_hadr,a1
		move.l	_resload,a2
		jsr	(resload_SaveFile,a2)
		bsr	_crypt
		movem.l	(a7)+,d2-d7/a2-a3/a5
		rts

_crypt		movem.l	d0/a1,-(a7)
		move.l	_hadr,a1
		move.l	#$b00c-$af94-1,d0
.lp		eor.b	d0,(a1)+
		dbf	d0,.lp
		movem.l	(a7)+,d0/a1
		rts

_b2		move.l	(a0)+,d2
		and.l	#$fffff,d2
		move.l	d2,(bltbpt,a3)
		move.l	(a0)+,(bltcpt,a3)
		add.l	#2,(a7)
		rts

_b1		BLITWAIT
		move.l	a1,(a5)
		move.l	d1,(a3)
		rts

_f1v1		cmp.l	#0,a5
		bne	.ok
.1		add.l	#$1e64-$1e06-6,(a7)
		rts
.ok		cmp.l	(-4,a5),a3
		bne	.1
		rts
_f1v2		cmp.l	#0,a5
		bne	.ok
.1		add.l	#$216c-$210a-6,(a7)
		rts
.ok		cmp.l	(-4,a5),a3
		bne	.1
		rts

_open		movem.l	d1/a1/a6,-(a7)
		move.l	4,a6
		moveq	#8,d0
		moveq	#0,d1
		jsr	(_LVOAllocMem,a6)
		move.l	d0,a0
		clr.l	(a0)+
		move.l	(a7)+,(a0)
		movem.l	(a7)+,a1/a6
		rts
_seek		move.l	d1,a0
		move.l	(a0),d0
		tst.w	d3
		beq	.cur
		cmp.w	#1,d3
		beq	.end
.beg		move.l	d2,(a0)
		rts
.cur		add.l	d2,(a0)
		rts
.end		movem.l	d0-d1/a0,-(a7)
		move.l	d2,(a0)+
		move.l	(a0),a0
		move.l	_resload,a1
		jsr	(resload_GetFileSize,a1)
		move.l	(8,a7),a0
		add.l	d0,(a0)
		movem.l	(a7)+,d0-d1/a0
		rts
_read		move.l	d1,a1
		movem.l	d1/a1-a2,-(a7)
		move.l	(a1)+,d1	;offset
		move.l	(a1),a0		;filename
		move.l	d2,a1		;buffer
		move.l	d3,d0		;length
		move.l	_resload,a2
		jsr	(resload_LoadFileOffset,a2)
		movem.l	(a7)+,d1/a1-a2
		add.l	d3,(a1)
		move.l	d3,d0
		rts
_close		move.l	a6,-(a7)
		move.l	d1,a1
		move.l	#8,d0
		move.l	4,a6
		jsr	(_LVOFreeMem,a6)
		move.l	(a7)+,a6
		rts

_load1		move.l	d1,a1		;filename
		rts
_load2		move.l	a2,-(a7)
		move.l	_resload,a2
		move.l	a1,a0
		move.l	d2,a1
		jsr	(resload_LoadFileDecrunch,a2)
		move.l	d0,d2
		move.l	(a7)+,a2
		add.l	#6,(a7)
		rts
_load3		move.l	_resload,a2
		move.l	d2,a1
		jsr	(resload_LoadFileDecrunch,a2)
		move.l	d0,d1
		movem.l	(a7)+,d2-d4/a2
		rts

_loadseg2	addq.l	#5,a0			;skip "NYW2:"
_loadseg	move.l	a0,-(a7)
		move.l	#16508,d0		;max len of 'object?'
		move.l	d0,-(a7)
		moveq	#0,d1
		move.l	(4),a6
		jsr	(_LVOAllocMem,a6)
		move.l	d0,a2
		move.l	(a7)+,(a2)
		move.l	(a7)+,a0
		lea	(4,a2),a1
		move.l	_resload,a6
		jsr	(resload_LoadFileDecrunch,a6)
		lea	(4,a2),a0
		sub.l	a1,a1
		jsr	(resload_Relocate,a6)
		move.l	a2,d0
		lsr.l	#2,d0
		rts
_unloadseg	lsl.l	#2,d1
		move.l	d1,a1
		move.l	(a1),d0
		move.l	(4),a6
		jsr	(_LVOFreeMem,a6)
		addq.l	#2,(a7)
		rts

_newscreen	dc.w	0		;LeftEdge
		dc.w	0		;TopEdge
		dc.w	320		;Width
		dc.w	-1		;Height
		dc.w	1		;Depth
		dc.b	0,0		;DetailPen,BlockPen
		dc.w	0		;ViewModes
		dc.w	$10f		;Type
		dc.l	0		;Font
		dc.l	0		;Title
		dc.l	0		;Gadgets
		dc.l	0		;CustomBitmap

;============================================================================

	INCLUDE	Sources:whdload/kick13.s

;============================================================================

	END
