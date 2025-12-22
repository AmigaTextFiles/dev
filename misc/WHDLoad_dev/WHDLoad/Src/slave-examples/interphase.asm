;*---------------------------------------------------------------------------
;  :Program.	interphase.asm
;  :Contents.	Slave for "Interphase"
;  :Author.	wepl <wepl@whdload.de>
;  :Version.	$Id: interphase.asm 1.14 2002/02/19 21:09:47 wepl Exp wepl $
;  :History.	06.02.98 started
;		28.04.98 finished
;		02.05.98 flushcache inserted, now runs with cache enabled
;		15.06.98 savegame routine moved to external file
;		08.05.99 adapted for WHDLoad 10.0
;		23.01.00 adapted for changed whdmacros.i 10.5
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly 2.9, PhxAss 4.38
;  :To Do.
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	whdload.i
	INCLUDE	whdmacros.i

	IFD	BARFLY
	OUTPUT	"wart:i/interphase/Interphase.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER					;disable supervisor warnings
	ENDC

;============================================================================

_base		SLAVE_HEADER			;ws_Security + ws_ID
		dc.w	10			;ws_Version
		dc.w	WHDLF_Disk|WHDLF_NoError|WHDLF_EmulTrap|WHDLF_NoDivZero	;ws_flags
		dc.l	$80000			;ws_BaseMemSize
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

_name		dc.b	"Interphase",0
_copy		dc.b	"1989,1990 Mirrorsoft Ltd.",0
_info		dc.b	"installed & fixed by Wepl",10
		dc.b	"version 1.13 "
	IFD	BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
	EVEN

;============================================================================
_Start	;	A0 = resident loader
;============================================================================
;
;	Image format:
;	Disk 1		tracks 2-75 = 373760
;
;============================================================================

		lea	(_resload,pc),a1
		move.l	a0,(a1)				;save for later using

		moveq	#0,d0				;offset
		move.l	#$1c+$48c0,d1			;size
		moveq	#1,d2				;disk
		lea	$400,a0				;destination
		move.l	(_resload,pc),a1
		jsr	(resload_DiskLoad,a1)

		skip	6,$400+$98			;dma on
		ret	$400+$4532			;vector init
		patch	$400+$146,_1

		jmp	$400

_1		move.l	#$6400,d0			;offset
		move.l	#$1c+$545c6,d1			;size
		moveq	#1,d2				;disk
		move.l	$300,a0				;destination
		move.l	(_resload,pc),a1
		jsr	(resload_DiskLoad,a1)

		move.w	#$4e40,$400+$212		;trap #0
		lea	(_2,pc),a0
		move.l	a0,$80

		jmp	$400+$1ae

_2		move.w	#500,$400+$129c			;time to wait
		patch	$400+$30a0,_int6c
		skip	$280-$26e,$400+$26e		;drive stuff
		patch	$400+$2f0,_3
		jsr	$400+$114c			;clr screen
		bsr	_waitvb
		move.w	#$87d0,(_custom+dmacon)
		jsr	$400+$45e			;original
		addq.l	#2,(2,a7)
		rte

_int6c		subq.w	#1,$400+$129c
		btst	#6,$bfe001
		beq	.q
		btst	#7,$bfe001
		beq	.q
		btst	#2,(_custom+potinp)
		bne	.n
.q		move.w	#-1,$400+$129c
.n		move.w	#$20,(_custom+intreq)
_rte		rte

_3		bsr	_waitvb
		move.w	#$7fff,(_custom+intena)
		move.w	#$7fff,(_custom+dmacon)
		move.w	#$7fff,(_custom+intreq)
	;	sub.w	#10,$a08			;ignore unwanted ports interrupts
		pea	(_keyint,pc)
		move.l	(a7)+,$602
		skip	$5a56-$548a,$548a		;rn copylock
		patch	$25f4,_savegame
		patch	$2608,_loadgame

		move.l	(_resload,pc),a0
		jsr	(resload_FlushCache,a0)		;to fix af if icache enabled

		lea	$400,a0
		jmp	(a0)

;--------------------------------

_keyint		movem.l	d0-d1/a1,-(a7)
		lea	(_ciaa),a1
		btst	#CIAICRB_SP,(ciaicr,a1)		;check int reason
		beq	.int2_exit
		move.b	(ciasdr,a1),d0			;read code
		clr.b	(ciasdr,a1)			;output LOW (handshake)
		or.b	#CIACRAF_SPMODE,(ciacra,a1)	;to output
		not.b	d0
		ror.b	#1,d0

		move.b	d0,$591
		jsr	$a52

		cmp.b	(_keyexit,pc),d0
		beq	_exit

		cmp.b	#$5f,d0
		bne	.1
		eor.w	#$f16c,$775a			;trainer (John Selck)
		move.w	#$210,$4ec
.1
		moveq	#2-1,d1				;wait because handshake min 75 탎
.int2_w1	move.b	(_custom+vhposr),d0
.int2_w2	cmp.b	(_custom+vhposr),d0		;one line is 63.5 탎
		beq	.int2_w2
		dbf	d1,.int2_w1			;(min=127탎 max=190.5탎)

		and.b	#~(CIACRAF_SPMODE),(ciacra,a1)	;to input
.int2_exit	move.w	#INTF_PORTS,(intreq+_custom)
		movem.l	(a7)+,d0-d1/a1
		rte

;--------------------------------

_loadgame	move.l	#100,d0
		lea	$65000,a1			;free mem for screen
		bsr	_sg_load
		move.w	#$4100,(_custom+bplcon0)
		move.w	#320/8*3,(_custom+bpl1mod)
	;	move.l	#$00000eee,(color,a6)
		moveq	#0,d2
		rts

_savegame	move.l	#100,d0
		lea	$65000,a1			;free mem for screen
		bsr	_sg_save
		move.w	#$4100,(_custom+bplcon0)
		move.w	#320/8*3,(_custom+bpl1mod)
	;	move.l	#$00000eee,(color,a6)
		moveq	#0,d2
		rts

;--------------------------------

_waitvb		waitvb
		rts

_exit		pea	TDREASON_OK
		move.l	(_resload,pc),-(a7)
		add.l	#resload_Abort,(a7)
		rts

;--------------------------------

_resload	dc.l	0				;address of resident loader

;============================================================================

	INCLUDE	Sources:whdload/savegame.s

;============================================================================

	END
