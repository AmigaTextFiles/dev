;Leave Low Chip
;by Rafik/RDST Vitava 1993
;Usefull only for A1200

;	incdir	"TRASH'EM_ALL:include/"
	incdir	dh1:sources/include/
;	include	'Exec/exec.i'
	include	'Exec/exec_lib.i'
	include	'Exec/memory.i'
	include	'Exec/execbase.i'
	include	'Dos/dos_lib.i'

CALL:	MACRO
	jsr	_LVO\1(a6)
	ENDM

MemorySize	equ	$100000

Start:
	moveq	#MEMF_CHIP,d1
	CALLEXEC AvailMem
;	cmp.l	#MemorySize,d0
;	bmi.s	Error

	bsr.w	DODOS

	moveq	#0,d0
;	move.l	OutputHandle(pc),d1
	move.l	#Installed,d2
	moveq	#EIns-Installed,d3	;dîugoôê textu
	jsr	_LVOWrite(a5)		;write

	bsr.w	CUTDOS

	move.l	#EnP-StP,d0
	moveq	#MEMF_PUBLIC,d1
	CALL	AllocMem
	tst.l	d0
	beq.s	Error
	move.l	d0,a1
	move.l	a1,CoolCapture(a6)	;alloc adr

	move.l	#EnP-StP-1,d7	;copy my proggy
	lea	StP(pc),a0
.loop	move.b	(a0)+,(a1)+
	dbf	d7,.loop

Recalculate
	lea	SoftVer(a6),a0
	moveq	#0,d0
	moveq	#$18-1,d1
.loop	add.w	(a0)+,d0
	dbf	d1,.loop
	not.w	d0
	move.w	d0,(a0)

	moveq	#0,d0
	rts

Error:
	bsr.s	DODOS

	moveq	#0,d0
;	move.l	OutputHandle(pc),d1
	move.l	#ErrorInstall,d2
	moveq	#EErr-ErrorInstall,d3	;dîugoôê textu
	jsr	_LVOWrite(a5)		;write

	bsr.s	CUTDOS

	moveq	#0,d0
	rts

DODOS:
	lea	DosName(pc),a1
	moveq	#0,d0
	CALL	OpenLibrary
	move.l	d0,a5

	jsr	_LVOOutPut(a5)
	move.l	d0,d1
	rts
CUTDOS:
	move.l	a5,a1
	CALL	CloseLibrary
	rts
DosName:
	dc.b 'dos.library',0

;AFTER RESET
StP
	moveq	#-1,d0
.loop
	move.w	d0,$dff180
	dbf	d0,.loop
	move.l	#MemorySize,d0	;memory to alloc
	moveq	#MEMF_CHIP,d1
	CALLEXEC AllocMem
	moveq	#0,d0
	rts
EnP

Installed:
	dc.b ' Leave Low Chip',$a
	dc.b '    instaled',$a
	dc.b 'R.The.K/RDST 1993',$a
	dc.b 'Press reset to start',$a
EIns

ErrorInstall:
	dc.b $a
	dc.b "You don't have enought chip memory",$a
	dc.b "Can't install",$a
EErr:
