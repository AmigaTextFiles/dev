;*---------------------------------------------------------------------------
;  :Program.	battelisle.asm
;  :Contents.	Slave for "Battle Isle" from Blue Byte
;  :Author.	Wepl
;  :Original	v1 wepl@whdload.de
;		moon en Xaviar Bodenand
;  :Version.	$Id: battleisle.asm 0.14 2005/03/10 09:03:26 wepl Exp wepl $
;  :History.	04.03.00 started
;		16.04.00 finished
;		11.05.00 support for us-version added
;		24.11.00 keyboard fixed
;		20.12.00 small change
;		03.08.01 cleanup for new kickemu
;		30.11.02 support for french version added, variable keyboard layout
;		18.06.03 kickemu cache option used
;		10.03.05 support for en data2 added
;		14.07.07 debug_adr added
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Devpac 3.14, Barfly 2.9
;  :To Do.
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i

	IFD BARFLY
	OUTPUT	"wart:b/battleisle/BattleIsle.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER
	ENDC

UPPER	MACRO
		cmp.b	#"a",\1
		blo	.l\@
		cmp.b	#"z",\1
		bhi	.l\@
		sub.b	#$20,\1
.l\@
	ENDM

;============================================================================

CHIPMEMSIZE	= $66000
FASTMEMSIZE	= $49000
NUMDRIVES	= 1
WPDRIVES	= %0000

;BLACKSCREEN
;BOOTBLOCK
;BOOTDOS
BOOTEARLY
;CBDOSLOADSEG
;CBDOSREAD
CACHE
;DEBUG
;DISKSONBOOT
;DOSASSIGN
;FONTHEIGHT	= 8
;HDINIT
;HRTMON
;IOCACHE	= 1024
;MEMFREE	= $200
;NEEDFPU
;POINTERTICKS	= 1
;SETPATCH
;STACKSIZE	= 6000
;TRDCHANGEDISK

;============================================================================

slv_Version	= 16
slv_Flags	= WHDLF_NoError|WHDLF_Req68020
slv_keyexit	= $59	;F10

;============================================================================

	INCLUDE	Sources:whdload/kick13.s

;============================================================================

	IFD BARFLY
	IFND	.passchk
	DOSCMD	"WDate  >T:date"
.passchk
	ENDC
	ENDC

slv_name	dc.b	"Battle Isle",0
slv_copy	dc.b	"1991-93 Blue Byte",0
slv_info	dc.b	"adapted by Wepl",10
		dc.b	"Version 1.8 "
	IFD BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
slv_CurrentDir	dc.b	"data",0
_introe		dc.b	"intro.prg.en",0
_introd		dc.b	"intro.prg.de",0
_main		dc.b	"battle.prg",0
_desert		dc.b	"d01/battle20.prg",0
_moon		dc.b	"d02/mond.dwn",0

_extrad		dc.b	"LIB/PART.TAB",0	;only desert
		dc.b	"LIB/PATT.LIB",0

_extram		dc.b	"00.PAL",0		;both
		dc.b	"01.PAL",0
		dc.b	"AMOK.DAT",0
		dc.b	"BNIM/FAB00.ANI",0
		dc.b	"BNIM/FAB01.ANI",0
		dc.b	"GROUND.DAT",0
		dc.b	"KOCW.DAT",0
		dc.b	"LIB/PART.LIB",0
		dc.b	"LIB/PFIGHT.LIB",0
		dc.b	"MENU.PAL",0
		dc.b	"MENU.PCK",0

		dc.b	"UNIT.DAT",0		;only moon
		dc.b	"LOOSER.SND",0
		dc.b	"STATS.PCK",0
		dc.b	"WINNER.SND",0
		dc.b	"MOND.DWN",0
		dc.b	"BNIM/END.PAL",0
		dc.b	"BNIM/END.SND",0
		dc.b	"BNIM/HQ.PAL",0
		dc.b	"BNIM/TOT.ANI",0
		dc.b	"BNIM/TOT.PAL",0
		dc.b	"BNIM/END.ANI",0
		dc.b	"BNIM/HQ.SND",0
		dc.b	"BNIM/TOT.SND",0
		dc.b	"BNIM/HQ.ANI",0
		dc.b	"LIB/PBIGUNIT.LIB",0
		dc.b	"LIB/UNIT.LIB",0
		dc.b	"LIB/CURSOR.LIB",0
		dc.b	"GAME.PAL",0
		dc.b	"GAME.SND",0
		dc.b	"MAP02.LIB",0
		dc.b	"MAP04.LIB",0
		dc.b	"MAPINFO.DAT",0
		dc.b	"TITEL.TXT",0
		dc.b	"TITEL.PCK",0
	EVEN

_tab		;intro english
		dc.w	$dba2,0,0	;crc
		dc.w	_plie-_tab	;patch list
		dc.w	_introe-_tab	;file name
		dc.l	0,0		;patch keyboard

		;intro german
		dc.w	$eb46,0,0	;crc
		dc.w	_plid-_tab	;patch list
		dc.w	_introd-_tab	;file name
		dc.l	0,0		;patch keyboard

		;battle isle
		dc.w	$1c05,$9a61,$8223 ;crc german,english,french
		dc.w	_pl-_tab	;patch list
		dc.w	_main-_tab	;file name
		dc.l	$18cd		;patch keyboard 'Y'
		dc.l	$21e6c		;patch keyboard map

		;data disk 1
		dc.w	$7d5c,0,0	;crc
		dc.w	_pld-_tab	;patch list
		dc.w	_desert-_tab	;file name
		dc.l	$18cd		;patch keyboard 'Y'
		dc.l	$21e7c		;patch keyboard map

		;data disk 2
		dc.w	$E442,$ac90,0	;crc german,english
		dc.w	_plm-_tab	;patch list
		dc.w	_moon-_tab	;file name
		dc.l	$198f		;patch keyboard 'Y'
		dc.l	$22f24		;patch keyboard map

;============================================================================

_bootearly	move.l	(_resload,pc),a2	;a2 = resload

	;get tags
		lea	(_tag,pc),a0
		jsr	(resload_Control,a2)
		
		move.l	(_custom1),d0
		subq.l	#1,d0
		bmi	.badver
		cmp.l	#5,d0
		bhs	.badver
		
		mulu	#18,d0
		lea	(_tab,pc),a0
		movem.w	(a0,d0.l),d4-d6/a3-a4	;d4-d6 = crc
		add.l	a0,a3			;a3 = patchlist
		add.l	a0,a4			;a4 = name
		movem.l	(10,a0,d0.l),d0-d1
		move.l	d0,-(a7)		;patch keyboard 'Y'
		move.l	d1,-(a7)		;patch keyboard map

	;get filesize
		move.l	a4,a0
		jsr	(resload_GetFileSizeDec,a2)
		move.l	d0,d7			;d7 = length
		
	;load program
		move.l	d7,d0
		moveq	#0,d1
		move.l	(4),a6
		jsr	(_LVOAllocMem,a6)
		move.l	d0,a5			;a5 = address

		clr.l	-(a7)
		move.l	a5,-(a7)
		pea	WHDLTAG_DBGADR_SET
		move.l	a7,a0
		jsr	(resload_Control,a2)
		add.w	#12,a7

		move.l	a4,a0
		move.l	a5,a1
		jsr	(resload_LoadFileDecrunch,a2)

	;check version
		move.l	d7,d0
		move.l	a5,a0
		jsr	(resload_CRC16,a2)
		cmp.w	d4,D0
		beq	.verok
		cmp.w	d5,D0
		beq	.verok
		cmp.w	d6,D0
		beq	.verok
.badver		pea	TDREASON_WRONGVER
		jmp	(resload_Abort,a2)
.verok
	;disable doslib
		move.l	(4),a0
		add.w	#_LVOOpenLibrary+2,a0
		lea	_openlib_save,a1
		move.l	(a0),(a1)
		lea	_openlib,a1
		move.l	a1,(a0)

	;patch program
		move.l	a3,a0
		move.l	a5,a1
		jsr	(resload_Patch,a2)

	;patch keyboard
		tst.l	(a7)
		beq	.endkey
	;copy map
		move.l	(_keytrans),a0
		add.w	#128+16,a0
		move.l	(a7)+,a1
		add.l	a5,a1
		moveq	#3*16,d0
.key2		move.b	(a0)+,d1
		cmp.b	#'A',d1
		blo	.key3
		cmp.b	#'Z',d1
		bls	.key4
.key3		moveq	#-1,d1
.key4		move.b	d1,(a1)+
		dbf	d0,.key2
	;find 'Y' key
		moveq	#127,d0
		move.l	(_keytrans),a0
		add.w	#128,a0
.key1		cmp.b	#'y',-(a0)
		dbeq	d0,.key1
	;set 'Y' key
		move.l	(a7)+,a0
		add.l	a5,a0
		move.b	d0,(a0)
.endkey

	;disable cache
		move.l	#WCPUF_Exp_NCS,d0
		move.l	#WCPUF_Exp,d1
	;	jsr	(resload_SetCPU,a2)

	;start
		moveq	#1,d1				;os running
		jsr	(a5)

	;quit
.quit		pea	TDREASON_OK
		move.l	(_resload,pc),a2
		jmp	(resload_Abort,a2)

;---------------

_plie		PL_START
		PL_P	$5738,_load0
	;	PL_S	$5fa0,6				;blithog
		PL_PS	$6d60,_bplcon0
	;	PL_S	$7786,6				;blithog
		PL_END

_plid		PL_START
		PL_P	$5810,_load0
	;	PL_S	$6078,6				;blithog
		PL_PS	$6e38,_bplcon0
	;	PL_S	$785e,6				;blithog
		PL_END

_pl		PL_START
		PL_PS	$5d8,_intack71
		PL_P	$61c,_intack70
		PL_PS	$748,_cacheon1
		PL_B	$1e72b,$20
		PL_PS	$1e756,_ciawait
		PL_P	$1ee64,_load0
		PL_P	$1f28e,_save0
		PL_PS	$852,_allocbug
	;	PL_S	$1f6c6,6			;blithog
		PL_PS	$20492,_bplcon0
		PL_PS	$4d4,_key
	;	PL_B	$10ed2,$66			;beq -> bne
	;	PL_PS	$4fa,_keyfix
	;	PL_I	$10
		PL_END

_intack71	
		tst.w	(intreqr,a4)
		tst.w	(intreqr,a4)
		move.w	d0,(intreq,a4)
		move.w	d0,(intena,a4)
		addq.l	#2,(a7)
		rts

_intack70	tst.w	(intreqr,a4)
		tst.w	(intreqr,a4)
		tst.w	(intreqr,a4)
		tst.w	(intreqr,a4)
		movem.l	(a7)+,d0-d2/d7/a3-a5		;original
		rte					;original

_ciawait	move.b	#$7f,(ciaicr,a4)		;original
		tst.b	(ciaicr,a4)
		rts

_key		lea	(_ciaa),a1
	;check if keyboard has caused interrupt
		btst	#CIAICRB_SP,(ciaicr,a1)
		beq	.end
	;read keycode
		move.b	(ciasdr,a1),d0
	;set output to low and output mode (handshake)
		clr.b	(ciasdr,a1)
		or.b	#CIACRAF_SPMODE,(ciacra,a1)
	;calculate rawkeycode
		not.b	d0
		ror.b	#1,d0
	;set raw
		move.b	(a3),(1,a3)			;save last raw
		move.b	(2,a3),(3,a3)			;save last ascii
		move.b	d0,(a3)				;new raw
		st	(4,a3)
	;set ascii
		move.l	(a7),a0
		jsr	($576-$4d4-6,a0)

	;better would be to use the cia-timer to wait, but we arn't know if
	;they are otherwise used, so using the rasterbeam
	;required minimum waiting is 75 탎, one rasterline is 63.5 탎
	;a loop of 3 results in min=127탎 max=190.5탎
		moveq	#3-1,d1
.wait1		move.b	(_custom+vhposr),d0
.wait2		cmp.b	(_custom+vhposr),d0
	;move.w	$dff006,$dff180
		beq	.wait2
		dbf	d1,.wait1

	;set input mode
		and.b	#~(CIACRAF_SPMODE),(ciacra,a1)
.end		move.w	#INTF_PORTS,(intreq+_custom)
		tst.w	(intreqr+_custom)
		addq.l	#4,a7
		movem.l	(a7)+,d0-a6
		rte

	IFEQ 1
_keyfix
		move.b	$bfec01,d0
		beq	.1
		btst	#0,d0			;up/down
	;	eor	#4,ccr
.1		rts

	ENDC

_pld		PL_START
		PL_PS	$748,_cacheon1
		PL_P	$1ee74,_load1
		PL_P	$1f29e,_save1
		PL_PS	$852,_allocbug
	;	PL_S	$1f6d6,6			;blithog
		PL_PS	$204a2,_bplcon0
		PL_PS	$4d4,_key
		PL_END

_plm		PL_START
		PL_PS	$746,_cacheon2
		PL_P	$1ff1c,_load2
		PL_P	$20346,_save2
		PL_PS	$850,_allocbug
	;	PL_S	$2077e,6			;blithog
		PL_PS	$2154a,_bplcon0
		PL_PS	$4d4,_key
		PL_END

;---------------

_cacheon1	move.l	#$25a8,d0			;original

_cacheon	movem.l	d0-d1/a0-a1,-(a7)
		move.l	#WCPUF_Exp_CB,d0
		move.l	#WCPUF_Exp,d1
		move.l	_resload,a0
		jsr	(resload_SetCPU,a0)
		movem.l	(a7)+,_MOVEMREGS
		rts

_cacheon2	move.l	#$1df0,d0			;original
		bra	_cacheon

_bplcon0	move.w	(12,a6),d0			;original
		ror.w	#4,d0				;original
		or.w	#$200,d0			;enable color output
		rts

;---------------

_load2		move.l	(8,a7),a0
		addq.l	#4,a0
		movem.l	a2,-(a7)
		cmp.l	#"MAP/",(a0)
		beq	.sub
		cmp.l	#".DAT",(2,a0)			;savegames
		beq	.sub
		moveq	#35-1,d0
		lea	(_extram),a1
.chk		move.l	a0,a2
.cmp		move.b	(a2)+,d1
		UPPER	d1
		cmp.b	(a1)+,d1
		bne	.fail
		tst.b	d1
		beq	.sub
		bra	.cmp
.fail		subq.l	#1,a1
.s		tst.b	(a1)+
		bne	.s
		dbf	d0,.chk
		movem.l	(a7)+,_MOVEMREGS
		move.l	a0,(8,a7)
		bra	_loadfile

.sub		movem.l	(a7)+,_MOVEMREGS
		move.l	#"D02/",-(a0)
		bra	_loadfile

_load1		move.l	(8,a7),a0
		addq.l	#4,a0
		movem.l	a2,-(a7)
		cmp.l	#"MAP/",(a0)
		beq	.sub
		cmp.l	#".DAT",(2,a0)			;savegames
		beq	.sub
		moveq	#13-1,d0
		lea	(_extrad),a1
.chk		move.l	a0,a2
.cmp		move.b	(a2)+,d1
		UPPER	d1
		cmp.b	(a1)+,d1
		bne	.fail
		tst.b	d1
		beq	.sub
		bra	.cmp
.fail		subq.l	#1,a1
.s		tst.b	(a1)+
		bne	.s
		dbf	d0,.chk
		movem.l	(a7)+,_MOVEMREGS
		move.l	a0,(8,a7)
		bra	_loadfile

.sub		movem.l	(a7)+,_MOVEMREGS
		move.l	#"D01/",-(a0)
		bra	_loadfile


_load0		addq.l	#4,(8,a7)			;skip "BI?:"

	;in:
	;(4,a7)  memflag (-1=any 0=chip *=memptr)
	;(8,a7)  name
	;(12,a7) buffer $2028
	;out
	;d0 = mem
	;d1 = length
_loadfile	movem.l	d2-d3/a2/a6,-(a7)
		move.l	(_resload),a2
		tst.l	(_MOVEMBYTES+4,a7)
		beq	.calc
		bpl	.load

.calc
	illegal
	ifeq 1
		moveq	#8,d0				;length
		moveq	#0,d1				;offset
		move.l	(_MOVEMBYTES+8,a7),a0		;name
		move.l	a7,a1				;dest
		jsr	(resload_LoadFileOffset,a2)
		cmp.l	#"TPWM",(a7)
		beq	.packed
		cmp.l	#"RNC"<<8+1,(a7)
		beq	.packed
		cmp.l	#"RNC"<<8+2,(a7)
		beq	.packed
		cmp.l	#"IMP!",(a7)
		beq	.packed

		move.l	(_MOVEMBYTES+8,a7),a0		;name
		jsr	(resload_GetFileSize,a2)
		bra	.getmem

.packed		move.l	(4,a7),d0			;unpacked length

.getmem		moveq	#MEMF_CHIP,d1
		tst.l	(_MOVEMBYTES+4,a7)
		beq	.alloc
		moveq	#MEMF_ANY,d1
.alloc		move.l	(4),a6
		jsr	(_LVOAllocMem,a6)
		move.l	d0,(_MOVEMBYTES+4,a7)
	endc

.load		move.l	(_MOVEMBYTES+8,a7),a0		;name
		move.l	(_MOVEMBYTES+4,a7),a1		;dest
		jsr	(resload_LoadFileDecrunch,a2)
		move.l	d0,d1				;length
		move.l	(_MOVEMBYTES+4,a7),d0		;address
		movem.l	(a7)+,_MOVEMREGS
		
.end		rts

_save2		move.l	(4,a7),a0
		move.l	#"D02/",(a0)
		bra	_savefile

_save1		move.l	(4,a7),a0
		move.l	#"D01/",(a0)
		bra	_savefile

_save0		addq.l	#4,(4,a7)			;skip "BI?:"

	;in:
	;(4,a7)  name
	;(8,a7)  buffer
	;(12,a7) length
	;out
	;d0 = rc (0=success)
_savefile	movem.l	a2,-(a7)
		move.l	(_resload),a2
		move.l	(_MOVEMBYTES+12,a7),d0
		move.l	(_MOVEMBYTES+4,a7),a0
		move.l	(_MOVEMBYTES+8,a7),a1
		jsr	(resload_SaveFile,a2)
		moveq	#0,d0
		movem.l	(a7)+,_MOVEMREGS
		rts

_openlib	cmp.l	#"dos.",(a1)
		bne	.org
		move.l	#-$10000,d0
		rts
.org		move.l	_openlib_save,-(a7)
		rts

	;game allocates same memory again and again
_allocbug	move.l	(_bugmem),d0
		bne	.already

		move.l	(4,a7),d0
		move.l	#MEMF_CLEAR,d1
		move.l	a6,-(a7)
		move.l	4,a6
		jsr	(_LVOAllocMem,a6)
		move.l	(a7)+,a6
		lea	(_bugmem),a0
		move.l	d0,(a0)
		rts

.already	move.l	d0,a0
		move.l	(4,a7),d1
.clr		clr.l	(a0)+
		clr.l	(a0)+
		subq.l	#8,d1
		bhi	.clr
		rts

;---------------

_tag		dc.l	WHDLTAG_CUSTOM1_GET
_custom1	dc.l	0
		dc.l	WHDLTAG_KEYTRANS_GET
_keytrans	dc.l	0
		dc.l	0
		dc.l	0
_openlib_save	dc.l	0
_bugmem		dc.l	0

;============================================================================

	END
