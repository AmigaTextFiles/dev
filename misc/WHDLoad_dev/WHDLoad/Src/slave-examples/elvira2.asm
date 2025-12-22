;*---------------------------------------------------------------------------
;  :Program.	elvira2.asm
;  :Contents.	Slave for "Elvira 2" from Accolade
;  :Author.	Wepl
;  :Original	v1 
;  :Version.	$Id: elvira2.asm 1.9 2007/03/04 16:59:05 wepl Exp wepl $
;  :History.	24.01.02 started
;		09.05.02 copyprotection removed
;		11.12.02 spanish version added
;		04.03.07 italian version added
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
	OUTPUT	"wart:e/elvira2/Elvira2.Slave"
	BOPT	O+				;enable optimizing
	BOPT	OG+				;enable optimizing
	BOPT	ODd-				;disable mul optimizing
	BOPT	ODe-				;disable mul optimizing
	BOPT	w4-				;disable 64k warnings
	SUPER
	ENDC

;============================================================================

CHIPMEMSIZE	= $80000
FASTMEMSIZE	= $80000
NUMDRIVES	= 1
WPDRIVES	= %0000

BLACKSCREEN
;DEBUG
;DISKSONBOOT
HDINIT
;HRTMON
IOCACHE		= 28000
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

_name		dc.b	"Elvira 2 - The Jaws of Cerberus",0
_copy		dc.b	"1991 Accolade",0
_info		dc.b	"adapted by Wepl",10
		dc.b	"Version 1.3 "
	IFD BARFLY
		INCBIN	"T:date"
	ENDC
		dc.b	0
_data		dc.b	"data",0
_runit		dc.b	"runit",0
_args		dc.b	"gameamiga",10
_args_end
		dc.b	0
	EVEN

;============================================================================
_start	;	A0 = resident loader
;============================================================================

_bootdos

	;open doslib
		lea	(_dosname,pc),a1
		move.l	(4),a6
		jsr	(_LVOOldOpenLibrary,a6)
		move.l	d0,a6			;A6 = dosbase
		
	;load exe
		lea	(_runit),a0
		move.l	a0,d1
		jsr	(_LVOLoadSeg,a6)
		move.l	d0,d7			;D7 = segment
		beq	.end

	;check version
		lea	(_runit),a0
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
		
		lea	(_plde),a0
		cmp.w	#$62ca,d0
		beq	.p
		lea	(_plen),a0
		cmp.w	#$93df,d0
		beq	.p
		lea	(_ples),a0
		cmp.w	#$f3be,d0
		beq	.p
		lea	(_plfr),a0
		cmp.w	#$929a,d0
		beq	.p
		lea	(_plit),a0
		cmp.w	#$2ab,d0
		beq	.p
		pea	TDREASON_WRONGVER
		jmp	(resload_Abort,a2)
		
	;patch
.p		move.l	d7,a1
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
		move.l	(4,a7),d2		;D2 = stacksize
		sub.l	#5*4,d2			;required for MANX stack check
		movem.l	d2/d7/a2/a6,-(a7)
		jsr	(4,a1)
		movem.l	(a7)+,d2/d7/a2/a6

		pea	TDREASON_OK
		jmp	(resload_Abort,a2)

	ifeq 1
	;remove exe
		move.l	d7,d1
		jsr	(_LVOUnLoadSeg,a6)
	endc

.end		moveq	#0,d0
		rts

_plde	PL_START
	PL_S	$23a6,$bc-$a6	;disable DeleteFile
	PL_PS	$1906e,_dbffix
	PL_W	$1906e+6,$1f4
	PL_PS	$19120,_dbffix
	PL_W	$19120+6,$5000
	PL_PS	$1c58a,_dbffix
	PL_W	$1c58a+6,$50
	PL_PS	$1c5a0,_dbffix
	PL_W	$1c5a0+6,$30
	PL_END

_plen	PL_START
	PL_S	$23a6,$bc-$a6	;disable DeleteFile
	PL_PS	$19052,_dbffix
	PL_W	$19052+6,$1f4
	PL_PS	$19104,_dbffix
	PL_W	$19104+6,$5000
	PL_PS	$1c56e,_dbffix
	PL_W	$1c56e+6,$30
	PL_PS	$1c584,_dbffix
	PL_W	$1c584+6,$50
	PL_END

_ples	PL_START
	PL_S	$23a6,$bc-$a6	;disable DeleteFile
	PL_PS	$1905c,_dbffix
	PL_W	$1905c+6,$1f4
	PL_PS	$1910e,_dbffix
	PL_W	$1910e+6,$5000
	PL_PS	$1c578,_dbffix
	PL_W	$1c578+6,$30
	PL_PS	$1c58e,_dbffix
	PL_W	$1c58e+6,$50
	PL_END

_plfr	PL_START
	PL_S	$23a6,$bc-$a6	;disable DeleteFile
	PL_PS	$19062,_dbffix
	PL_W	$19062+6,$1f4
	PL_PS	$19114,_dbffix
	PL_W	$19114+6,$5000
	PL_PS	$1c57e,_dbffix
	PL_W	$1c57e+6,$50
	PL_PS	$1c594,_dbffix
	PL_W	$1c594+6,$30
	PL_END

_plit	PL_START
	PL_S	$23a6,$bc-$a6	;disable DeleteFile
	PL_PS	$19066,_dbffix
	PL_W	$19066+6,$1f4
	PL_PS	$19118,_dbffix
	PL_W	$19118+6,$5000
	PL_PS	$1c582,_dbffix
	PL_W	$1c582+6,$50
	PL_PS	$1c598,_dbffix
	PL_W	$1c598+6,$30
	PL_END

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

;---------------
; IN:	D0 = ULONG bytes read
;	D1 = ULONG offset in file
;	A0 = CPTR name of file
;	A1 = APTR memory buffer
; OUT:	-

; that removes the copyprotection...

_cb_dosRead
		move.l	a0,a2
.1		tst.b	(a2)+
		bne	.1
		lea	.name,a3
		move.l	a3,a4
.2		tst.b	(a4)+
		bne	.2
		sub.l	a4,a2
		add.l	a3,a2		;first char to check
.4		move.b	(a2)+,d2
		cmp.b	#"A",d2
		blo	.3
		cmp.b	#"Z",d2
		bhi	.3
		add.b	#$20,d2
.3		cmp.b	(a3)+,d2
		bne	.no
		tst.b	d2
		bne	.4

	;check position
		move.l	d0,d2
		add.l	d1,d2
		lea	.data,a2
		moveq	#0,d3
.next		movem.w	(a2)+,d3-d4
		tst.w	d3
		beq	.no
		cmp.l	d1,d3
		blo	.next
		cmp.l	d2,d3
		bhs	.next
		sub.l	d1,d3
		move.b	d4,(a1,d3.l)
		bra	.next

.no		rts

.name		dc.b	"tables01",0	;lower case!
	EVEN
.data		dc.w	$4278,$c	;original = 0b
		dc.w	$45b4,$c	;original = 0b
		dc.w	0

;============================================================================

	INCLUDE	Sources:whdload/kick13.s

;============================================================================

	END
