
		; Cavitas imager by Codetapper!

		incdir	Include:
		include	RawDIC.i

		OUTPUT	"Cavitas.islave"

		IFND	.passchk
		DOSCMD	"WDate  >T:date"
.passchk
		ENDC

;=====================================================================

		SLAVE_HEADER
		dc.b	1			;Slave version
		dc.b	0			;Slave flags
		dc.l	DSK_1			;Pointer to the first disk structure
		dc.l	Text			;Pointer to the text displayed in the imager window

		dc.b	"$VER: "
Text:		dc.b	"Cavitas imager V0.1",10
		dc.b	"by Codetapper/Action "
		INCBIN	"T:date"
		dc.b	0
		cnop	0,4

DSK_1		dc.l	0			;Pointer to next disk structure
		dc.w	1			;Disk structure version
		dc.w	DFLG_NORESTRICTIONS	;Disk flags
		dc.l	TL_1			;List of tracks which contain data
		dc.l	0			;UNUSED, ALWAYS SET TO 0!
		dc.l	FL_NULL			;List of files to be saved
		dc.l	0			;Table of certain tracks with CRC values
		dc.l	0			;Alternative disk structure, if CRC failed
		dc.l	0			;Called before a disk is read
		dc.l	_SaveDisk		;Called after a disk has been read

TL_1		TLENTRY 000,159,$1600,SYNC_STD,DMFM_STD
		TLEND

;=====================================================================

_SaveDisk	move.l	#2,d0			;d0 = Track number
		jsr	rawdic_ReadTrack(a5)	;a1 = Track buffer

		lea	_Buffer(pc),a3
		move.l	#($1600/4)-1,d0
_CopyToBuffer	move.l	(a1)+,(a3)+
		dbf	d0,_CopyToBuffer

		lea	_Buffer(pc),a3

_RipNextFile	lea	($20,a3),a3
		move.l	(a3),d3			;d3 = First sector
		move.l	(4,a3),d4		;d4 = Length (bytes)
		lea	(8,a3),a4		;a4 = Filename

		tst.b	(a4)			;Check if finished
		beq	_OK

_RipNextSector	move.l	d3,d1
		divu.w	#11,d1
		moveq	#0,d0
		move.w	d1,d0			;d0 = Track number
		jsr	rawdic_ReadTrack(a5)	;a1 = Track buffer

		swap 	d1
		mulu	#$200,d1
		add.l	d1,a1			;a1 = Offset
		move.l	(a1)+,d3		;d3 = Next sector
		move.l	d4,d0
		cmp.l	#$1fc,d0
		blt	_LastChunk
		move.l	#$1fc,d0
_LastChunk	sub.l	d0,d4
		move.l	a4,a0			;a0 = Filename
		jsr	rawdic_AppendFile(a5)

		tst.l	d4
		beq	_RipNextFile

		bra	_RipNextSector

_OK		moveq	#IERR_OK,d0
		rts

_Buffer		ds.l	$1600/4
