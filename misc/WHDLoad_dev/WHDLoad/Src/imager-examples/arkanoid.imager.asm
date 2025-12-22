;*---------------------------------------------------------------------------
;  :Program.	arkanoid.imager.asm
;  :Contents.	Imager for Arkanoid
;  :Author.	Wepl
;  :Version.	$Id: arkanoid.imager.asm 1.3 1999/05/17 23:14:46 jah Exp $
;  :History.	26.07.98 started
;		24.11.98 insert disk fixed, index flag removed
;		17.05.99 file size for "Arkanoid.2" incremented for PAL-version
;  :Requires.	-
;  :Copyright.	Public Domain
;  :Language.	68000 Assembler
;  :Translator.	Barfly V2.9
;  :To Do.
;---------------------------------------------------------------------------*
;
;	Disk format:
;	Disk 1:		0-1	standard
;			2-61	$1a20 bytes sync=9521,...
;			62-159	unused
;
;	Image format:
;	Disk 1		2-10	Arkanoid.1
;			12-41	Arkanoid.2
;			50-61	Arkanoid.3
;
;---------------------------------------------------------------------------*

	INCDIR	Includes:
	INCLUDE	devices/trackdisk.i
	INCLUDE	dos/dos.i
	INCLUDE	intuition/intuition.i
	INCLUDE	lvo/dos.i
	INCLUDE	lvo/exec.i
	INCLUDE	lvo/intuition.i
	INCLUDE	patcher.i

	IFD BARFLY
	OUTPUT	"C:Parameter/arkanoid.imager"
	BOPT	O+ OG+			;enable optimizing
	BOPT	ODd- ODe-		;disable mul optimizing
	ENDC

;======================================================================

	SECTION a,CODE

		moveq	#-1,d0
		rts
		dc.l	_Table
		dc.l	"PTCH"

;======================================================================

_Table		dc.l	PCH_ADAPTOR,.adname		;name adaptor
		dc.l	PCH_NAME,.name			;description of parameter
		dc.l	PCH_FILECOUNT,3			;number of cycles
		dc.l	PCH_FILENAME,.filenamearray	;file names
		dc.l	PCH_DATALENGTH,_lengtharray	;file lengths
		dc.l	PCH_DISKNAME,.disknamearray	;disk names
		dc.l	PCH_SPECIAL,.specialarray	;functions
		dc.l	PCH_STATE,.statearray		;state texts
		dc.l	PCH_MINVERSION,.patcherver	;minimum patcher version required
		dc.l	PCH_INIT,_Init			;init routine
		dc.l	PCH_FINISH,_Finish		;finish routine
		dc.l	PCH_ERRORINPARAMETER,_Finish	;finish routine
		dc.l	TAG_DONE

.filenamearray	dc.l	.f1
		dc.l	.f2
		dc.l	.f3
.disknamearray	dc.l	.d
		dc.l	.d
		dc.l	.d
.specialarray	dc.l	_Special
		dc.l	_Special
		dc.l	_Special
.statearray	dc.l	.insertdisk
		dc.l	.insertdisk
		dc.l	.insertdisk

.f1		dc.b	"Arkanoid.1",0
.f2		dc.b	"Arkanoid.2",0
.f3		dc.b	"Arkanoid.3",0
.d		dc.b	"ArkanoidI",0

.adname		dc.b	"Done by Wepl.",0
.name		dc.b	"Arkanoid, Diskimager for HD-Install",0
.patcherver	dc.b	"V1.05"
.insertdisk	dc.b	'Please insert your original writepro-',10
		dc.b	'tected disk in the source drive.',0
	IFD BARFLY
		dc.b	"$VER: "
	DOSCMD	"WDate >T:date"
	INCBIN	"T:date"
		dc.b	0
	ENDC
	EVEN

;======================================================================

_Init		moveq	#0,d0				;source drive
		move.l	PTB_INHIBITDRIVE(a5),a0		;inhibit drive
		jsr	(a0)
		tst.l	d0
		bne	.error
		
		moveq	#0,d0				;source drive
		move.l	PTB_OPENDEVICE(a5),a0		;open source device
		jsr	(a0)
		tst.l	d0
		bne	.error
		rts

.error		bsr	_Finish
		moveq	#-1,d0
		rts

;======================================================================

_Finish		moveq	#0,d0				;source drive
		move.l	PTB_ENABLEDRIVE(a5),a0		;deinhibit drive
		jmp	(a0)

;======================================================================

RAWREADLEN	= $7c00
BYTESPERTRACK	= $1a20

;======================================================================

_lengtharray	dc.l	53760
		dc.l	194432+$6c
		dc.l	80120
_starttrack	dc.b	2
		dc.b	12
		dc.b	50
_counttrack	dc.b	9
		dc.b	30
		dc.b	12

_sync		dc.w	0
_nexttrack	dc.w	0

;======================================================================

_Special	moveq	#-1,d7				;D7 = return code (default=error)

		cmp.w	#0,d6				;first cycle ?
		bne	.notfirst

.idisk		bsr	_InsertDisk
		tst.l	d0
		beq	.nodisk
		
	;check for disk in drive
		move.l	(PTB_DEVICESOURCEPTR,a5),a1
		move.w	#TD_CHANGESTATE,(IO_COMMAND,a1)
		move.l	(4).w,a6
		jsr	(_LVODoIO,a6)
		tst.l	(IO_ACTUAL,a1)
		bne	.idisk
.notfirst
		move.w	#$9521,(_sync)			;initial sync for each file

		moveq	#0,d2				;D2 = start/actual track
		move.b	(_starttrack,pc,d6.w),d2
		moveq	#0,d3				;D3 = amount of tracks
		move.b	(_counttrack,pc,d6.w),d3
		move.l	(PTB_ADDRESSOFFILE,a5),a2	;A2 = file address

.next		move.l	d2,d0
		move.l	d3,d1
		bsr	_Display
	IFEQ 0
		moveq	#5-1,d4				;D4 = retries decoding
.decretry	moveq	#5-1,d5				;D5 = retries rawread
.tdretry	move.l	(PTB_DEVICESOURCEPTR,a5),a1
		move.l	(PTB_SPACE,a5),(IO_DATA,a1)	;track is to load in ptb_space
		move.l	#RAWREADLEN,(IO_LENGTH,a1)	;double length of track to decode the index-sync-read data
		move.l	d2,(IO_OFFSET,a1)
		move.w	#TD_RAWREAD,(IO_COMMAND,a1)
		move.b	#0,(IO_FLAGS,a1)
		move.l	(4).w,a6
		jsr	(_LVODoIO,a6)
		tst.l	d0
		beq	.tdok
		dbf	d5,.tdretry
		bra	.tderr
	ELSE
	IFEQ 1
		movem.l	d2-d4/a2-a3,-(a7)
		lea	(.name),a0			;format string
		move.w	d2,d0
		lsr.w	#1,d0
		and.w	#1,d2
		movem.w	d0/d2,-(a7)
		move.l	a7,a1				;arg array
		lea	(_PutChar),a2
		sub.l	#100-4,a7
		move.l	a7,a3				;buffer
		move.l	(4),a6
		jsr	(_LVORawDoFmt,a6)
		move.l	a7,d1
		move.l	#MODE_OLDFILE,d2
		move.l	(PTB_DOSBASE,a5),a6
		jsr	(_LVOOpen,a6)
		add.l	#100,a7
		move.l	d0,d4
		beq	.err
		move.l	d4,d1
		move.l	(PTB_SPACE,a5),d2
		addq.l	#2,d2				;because decoder will not read first word
		move.l	#RAWREADLEN-2,d3
		jsr	(_LVORead,a6)
		move.l	d4,d1
		jsr	(_LVOClose,a6)
		moveq	#-1,d0
.err		movem.l	(a7)+,d2-d4/a2-a3
		tst.l	d0
		beq	.tderr
		moveq	#0,d4				;no retries
		bra	.tdok
.name		dc.b	"ram:track_%02d_head_%02d",0,0
	ELSE
		movem.l	d2-d6,-(a7)
		move.l	d2,d6
		moveq	#0,d5
		sub.w	#168*4,a7
		lea	.name,a0
		move.l	a0,d1
		move.l	#MODE_OLDFILE,d2
		move.l	(PTB_DOSBASE,a5),a6
		jsr	(_LVOOpen,a6)
		move.l	d0,d4
		beq	.err
		move.l	d4,d1
		move.l	#16,d2
		move.l	#OFFSET_BEGINNING,d3
		jsr	(_LVOSeek,a6)			;skip header
		move.l	d4,d1
		move.l	a7,d2
		move.l	#168*4,d3
		jsr	(_LVORead,a6)
		cmp.l	d0,d3
		bne	.close
		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
.0		cmp.w	d0,d6
		beq	.1
		move.l	(a7,d1.l),d3
		and.l	#$ffff,d3
		beq	.2
		add.l	d3,d2
		add.l	#16,d2				;skip track headline
.2		addq.l	#1,d0
		addq.l	#4,d1
		bra	.0
.1		move.l	d4,d1
		add.l	#16,d2				;skip track headline
		move.l	#OFFSET_CURRENT,d3
		jsr	(_LVOSeek,a6)
		move.l	d4,d1
		move.l	(PTB_SPACE,a5),d2
		move.l	#RAWREADLEN,d3
		jsr	(_LVORead,a6)
		cmp.l	d0,d3
		bne	.close
		moveq	#-1,d5
.close		move.l	d4,d1
		jsr	(_LVOClose,a6)
.err		add.w	#168*4,a7
		move.l	d5,d0
		movem.l	(a7)+,d2-d6
		tst.l	d0
		beq	.tderr
		moveq	#0,d4				;no retries
		bra	.tdok
.name		dc.b	"develop:cracks/arkanoid/ark.wwp",0
	ENDC
.decretry
	ENDC
.tdok
		move.l	(PTB_SPACE,a5),a0		;source
		move.l	a2,a1				;destination
		bsr	_Decode
		tst.l	d0
		beq	.decok
		dbf	d4,.decretry
		bra	.decerr
.decok
		add.l	#BYTESPERTRACK,a2
		move.w	(_nexttrack),d2			;one tracks further
		subq.w	#1,d3				;one track less
		bne	.next

		moveq	#0,d7				;return code
		cmp.w	#2,d6				;last cycle ?
		bne	.quit
		bra	.motoff
.decerr
.tderr		bsr	_ReadError

	;switch motor off
.motoff		move.l	(PTB_DEVICESOURCEPTR,a5),a1
		clr.l	(IO_LENGTH,a1)
		move.w	#TD_MOTOR,(IO_COMMAND,a1)
		move.l	(4).w,a6
		jsr	(_LVODoIO,a6)
.nodisk
	;enable drive
		tst.b	d7
		beq	.quit
		bsr	_Finish
		
.quit		move.l	d7,d0
		rts

;======================================================================
; IN:	A0 = raw
;	A1 = dest
; OUT:	D0 = error

GetW	MACRO
		cmp.l	a0,a5
		bls	.error
		move.l	(a0),\1
		lsr.l	d5,\1
	ENDM
GetW2	MACRO
		cmp.l	a2,a5
		bls	.error
		move.l	(a2),\1
		lsr.l	d5,\1
	ENDM
GetWI	MACRO
		GetW	\1
		addq.l	#2,a0
	ENDM
GetWI2	MACRO
		GetW2	\1
		addq.l	#2,a2
	ENDM
GetLI	MACRO
		GetWI	\1
		swap	\1
		GetWI	\2
		move.w	\2,\1
	ENDM
GetLI2	MACRO
		GetWI2	\1
		swap	\1
		GetWI2	\2
		move.w	\2,\1
	ENDM
GetL2	MACRO
		GetWI2	\1
		swap	\1
		GetW2	\2
		move.w	\2,\1
		subq.l	#2,a2
	ENDM

_Decode		movem.l	d1-a6,-(a7)
		move.l	a7,a6			;A6 = return stack
		lea	(RAWREADLEN,a0),a5	;A5 = end of raw data

	;find sync
.sync1		moveq	#16-1,d5		;D5 = shift count
.sync2		GetW	d0
		cmp.w	(_sync),d0
		beq	.sync3
.sync_retry	dbf	d5,.sync2
		addq.l	#2,a0
		bra	.sync1

.sync3		move.l	a0,-(a7)		;save this point for new try

		addq.l	#2,a0			;skip sync
		
		lea	(_buffer),a3

		MOVEQ	#1,D0			;size
	;	MOVEQ	#0,D1			;offset
		BSR.B	.sub
		MOVEQ	#1,D0
	;	MOVEQ	#2,D1
		BSR.B	.sub
		MOVEQ	#1,D0
	;	MOVEQ	#4,D1
		BSR.B	.sub
		MOVEQ	#1,D0
	;	MOVEQ	#6,D1
		BSR.B	.sub
		MOVE.L	#$D10,D0
	;	MOVEQ	#8,D1
		BSR.B	.sub
		MOVEQ	#1,D0
	;	MOVE.L	#$1A28,D1
		BSR.B	.sub
		MOVEQ	#1,D0
	;	MOVE.L	#$1A2A,D1
		BSR.B	.sub

		lea	(_buffer),a3
		move.l	a3,a2
		CLR.W	D0
		MOVE.W	#$D14,D2
.1		MOVE.W	(A2)+,D1
		EOR.W	D1,D0
		ROR.W	#1,D0
		DBRA	D2,.1
		cmp.w	(_buffer+$1a2a),d0
		bne	.fail

		lea	(8,a3),a0
		move.w	(6,a3),d0
		subq.w	#1,d0
.2		move.b	(a0)+,(a1)+
		dbf	d0,.2

		move.w	(a3)+,d0
		beq	.3
		move.w	d0,(_sync)
.3		move.w	(a3),(_nexttrack)

		bra	.success

.fail		move.l	(a7)+,a0
		bra	.sync_retry		;try again

.success	moveq	#0,d0
.quit		move.l	a6,a7
		movem.l	(a7)+,d1-a6
		rts
.error
	IFEQ 1
		lea	.snc,a0
		move.w	_sync,d0
.s1		cmp.w	(a0)+,d0
		bne	.s1
		move.w	(a0),(_sync)
		beq	.s2
		move.l	a6,a7
		movem.l	(a7)+,d1-a6
		bra	_Decode
.snc		dc.w	$9521,$5259,$2559,$2145,$2541,$4252,$4489,$448A,$5241,$5412,$A424,$A425,$A429,$A484,0
.s2
	ENDC
		moveq	#-1,d0
		bra	.quit


.sub		MOVEA.L	A0,A2
		ADDA.L	D0,A2
		ADDA.L	D0,A2
		MOVE.W	#$AAAA,D3
		MOVE.W	#$5555,D4
		SUBQ.L	#1,D0
.5		GetWI	d1			;MOVE.W	(A0)+,D1
		ADD.W	D1,D1
		AND.W	D3,D1
		GetWI2	d2			;MOVE.W	(A2)+,D2
		AND.W	D4,D2
		OR.W	D1,D2
		MOVE.W	D2,(A3)+
		DBRA	D0,.5
		move.l	a2,a0
		rts

;======================================================================

_InsertDisk	sub.l	a0,a0				;window
		pea	(.gadgets)
		pea	(.text)
		pea	(.titel)
		clr.l	-(a7)
		pea	(EasyStruct_SIZEOF)
		move.l	a7,a1				;easyStruct
		sub.l	a2,a2				;IDCMP_ptr
		move.l	d6,-(a7)
		addq.l	#1,(a7)
		move.l	a7,a3				;Args
		move.l	(PTB_INTUITIONBASE,a5),a6
		jsr	(_LVOEasyRequestArgs,a6)
		add.w	#6*4,a7
		rts

.titel		dc.b	"Insert Disk",0
.text		dc.b	"Insert your orginal disk %ld",10
		dc.b	"into the source drive !",0
.gadgets	dc.b	"OK|Cancel",0,0

;======================================================================

_ReadError	sub.l	a0,a0				;window
		pea	(.gadgets)
		pea	(.text)
		pea	(.titel)
		clr.l	-(a7)
		pea	(EasyStruct_SIZEOF)
		move.l	a7,a1				;easyStruct
		sub.l	a2,a2				;IDCMP_ptr
		move.l	d2,-(a7)
		move.l	a7,a3				;Args
		move.l	(PTB_INTUITIONBASE,a5),a6
		jsr	(_LVOEasyRequestArgs,a6)
		add.w	#6*4,a7
		rts

.titel		dc.b	"Error",0
.text		dc.b	"Can't read track %ld",0
.gadgets	dc.b	"OK",0

;======================================================================
; IN:	D0 = actual tracknumber
;	D1 = tracks left to do

_Display	movem.l	d0-d1/a0-a3/a6,-(a7)
		lea	(.text),a0		;format string
		move.l	d1,-(a7)
		move.l	d0,-(a7)
		move.l	a7,a1			;arg array
		lea	(_PutChar),a2
		sub.l	#100-8,a7
		move.l	a7,a3			;buffer
		move.l	(4),a6
		jsr	(_LVORawDoFmt,a6)
		move.l	a7,a0
		move.l	(PTB_DISPLAY,a5),a6
		jsr	(a6)
		add.l	#100,a7
		movem.l	(a7)+,d0-d1/a0-a3/a6
		rts

.text		dc.b	"reading track %ld, left %ld",0

_PutChar	move.b	d0,(a3)+
		rts

;======================================================================

	SECTION b,BSS

_buffer		dsb	$1a2c

	END

