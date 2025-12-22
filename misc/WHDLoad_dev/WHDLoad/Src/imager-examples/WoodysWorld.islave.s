
		; Woody's World Imager (c) 1993 Vision
		;
		; Written by Codetapper/Action! Thanks to Chris Vella 
		; for sending the original MFM data!
		;
		; All 3 disks: Tracks 000-000: Standard DOS (not imaged)
		;              Tracks 001-159: Sync $448a, length $1600 bytes
		;
		; Currently this slave can be used to read the game disk
		; from data grabbed from a MFMWarp file and it can also
		; be easily adjusted to rip all files from the game. 
		; However there are hundreds of small files which does
		; not help in caching so I have left this install using
		; optimised disk images.

		incdir	include:
		include	RawDIC.i

		IFD	BARFLY
		OUTPUT	"WoodysWorld.islave"

		IFND	.passchk
		DOSCMD	"WDate  >T:date"
.passchk
		ENDC
		ENDC

;=====================================================================

;READ_FROM_MFM	equ	0		; Read from MFM Warp dump
MIN_TRACK_MFM	equ	1		; I have MFM data starting track 1
MAX_TRACK_MFM	equ	20		; I have MFM data ending track 20
MFM_DATA_SIZE	equ	$3400		; GrabMFM saves $3400 bytes MFM/track
;RIP_FILES	equ	0		; Rip files from disk image

;=====================================================================

		SLAVE_HEADER
		dc.b	1		; Slave version
		dc.b	0		; Slave flags
		dc.l	DSK_1		; Pointer to the first disk structure
		dc.l	Text		; Pointer to the text displayed in the imager window

		dc.b	"$VER: "
Text		dc.b	"Woody's World imager V0.1",10
		dc.b	"by Codetapper/Action "
		IFD	BARFLY
		INCBIN	"T:date"
		ELSE
		dc.b	"(26.11.2001)"
		ENDC
		dc.b	0
		cnop	0,4

;=====================================================================

DSK_1		dc.l	DSK_2		; Pointer to next disk structure
		dc.w	1		; Disk structure version
		dc.w	DFLG_NORESTRICTIONS	;Disk flags
		dc.l	TL_123		; List of tracks which contain data
		dc.l	0		; UNUSED, ALWAYS SET TO 0!
		dc.l	FL_1		; List of files to be saved
		dc.l	0		; Table of certain tracks with CRC values
		dc.l	0		; Alternative disk structure, if CRC failed
		dc.l	0		; Called before a disk is read
		dc.l	0		; Called after a disk has been read

DSK_2		dc.l	DSK_3		; Pointer to next disk structure
		dc.w	1		; Disk structure version
		dc.w	DFLG_NORESTRICTIONS	;Disk flags
		dc.l	TL_123		; List of tracks which contain data
		dc.l	0		; UNUSED, ALWAYS SET TO 0!
		dc.l	FL_2		; List of files to be saved
		dc.l	0		; Table of certain tracks with CRC values
		dc.l	0		; Alternative disk structure, if CRC failed
		dc.l	0		; Called before a disk is read
		dc.l	0		; Called after a disk has been read

DSK_3		dc.l	0		; Pointer to next disk structure
		dc.w	1		; Disk structure version
		dc.w	DFLG_NORESTRICTIONS	;Disk flags
		dc.l	TL_123		; List of tracks which contain data
		dc.l	0		; UNUSED, ALWAYS SET TO 0!
		dc.l	FL_3		; List of files to be saved
		dc.l	0		; Table of certain tracks with CRC values
		dc.l	0		; Alternative disk structure, if CRC failed
		dc.l	0		; Called before a disk is read
		dc.l	0		; Called after a disk has been read

TL_123		TLENTRY 001,159,$1600,$448a,_RipWoodysWorld
		TLEND

FL_1:		FLENTRY FL_Disk1,$0,$d1c00
		FLEND

FL_2:		FLENTRY	FL_Disk2,$0,$b5200
		FLEND

FL_3:		FLENTRY FL_Disk3,$0,$99a00
		FLEND

FL_Disk1:	dc.b	"Disk.1",0
FL_Disk2:	dc.b	"Disk.2",0
FL_Disk3:	dc.b	"Disk.3",0
		EVEN

;=====================================================================

_RipWoodysWorld	move.l	a1,a4			;a4 = Destination

		IFD	READ_FROM_MFM
		cmp.w	#MIN_TRACK_MFM,d0	;Minimum track in incbin'd MFM data
		blt	_NoMFM
		cmp.w	#MAX_TRACK_MFM,d0	;Maximum track in incbin'd MFM data
		bgt	_NoMFM
		subq.l	#1,d0
		lea	_MFMData(pc),a0
		mulu	#MFM_DATA_SIZE,d0	;Multiply track number x track size
		add.l	d0,a0			;to work out offset for data
_NoMFM		ENDC

		move.l	a0,a5
		subq	#2,a0			;a0 = On sync $448a
		add.l	#$1b00*2,a5		;a5 = End of valid MFM data

		move.l	#$55555555,d4
		moveq	#11-1,d2

_FindSync	cmpi.w	#$448A,(a0)
		beq.b	_SkipSync
		addq.l	#2,a0
		cmp.l	a0,a5			;Safety
		blt	_NoSector
		bra.b	_FindSync

_SkipSync	cmpi.w	#$448A,(a0)
		bne.b	_NowPastSync
		addq.l	#2,a0
		cmp.l	a0,a5			;Safety
		blt	_NoSector
		bra.b	_SkipSync

_NowPastSync	move.l	(a0)+,d0
		move.l	(a0)+,d1
		and.l	d4,d0
		and.l	d4,d1
		lsl.l	#1,d0
		or.l	d1,d0
		lea	_1(pc),a6
		move.b	d0,(a6)
		swap	d0
		lea	_2(pc),a6
		move.b	d0,(a6)
		lsr.l	#8,d0
		swap	d0
		lea	_3(pc),a6
		move.b	d0,(a6)
		adda.w	#$20,a0
		adda.w	#$10,a0
		move.l	a4,a1			;a4 = Destination
		clr.l	d3
		move.b	d0,d3
		lsl.l	#8,d3
		lsl.l	#1,d3
		adda.l	d3,a1
		move.w	#$7F,d3
		movea.l	a0,a2
		adda.w	#$200,a2
_DecodeSector	move.l	(a0)+,d0
		move.l	(a2)+,d1
		and.l	d4,d0
		and.l	d4,d1
		lsl.l	#1,d0
		or.l	d1,d0
		move.l	d0,(a1)+
		dbra	d3,_DecodeSector
		lea	_1(pc),a6
		cmpi.b	#1,(a6)			;Check on last loop
		bne.b	_Skip
		move.w	#$448A,d4
_FindNext448a	cmp.w	(a2),d4
		beq.b	_Next448aFound
		addq.l	#2,a2
		cmp.l	a2,a5			;Safety
		blt	_NoSector
		bra.b	_FindNext448a

_Next448aFound	move.l	#$55555555,d4
		bra.b	_KeepGoing

_Skip		addq.l	#6,a2
_KeepGoing	movea.l	a2,a0
		dbra	d2,_FindSync

_OK		moveq	#IERR_OK,d0
		rts

_NoSector	moveq	#IERR_NOSECTOR,d0
		rts

_1		dc.w	0			;Last loop flag
_2		dc.w	0
_3		dc.w	0
		EVEN

;=====================================================================

		IFD	RIP_FILES		;Not used but does work :)
_SaveDisk	cmp.w	#1,d0			;D0.w=Disknumber
		bne	_NotDisk1		;A5=RawDIC function library base

		;move.l	#$0,d0			;d0 = Offset in image
		;move.l	#$400,d1		;d1 = Length
		;lea	_Bootblock(pc),a0	;a0 = Filename
		;jsr	rawdic_SaveDiskFile(a5)

_NotDisk1	moveq	#1,d0			;d0 = Track number
		jsr	rawdic_ReadTrack(a5)	;a1 = Track buffer

		lea	($404,a1),a1

_NextCrackFile	cmp.l	#'XXXX',(a1)
		beq	_OK

		move.l	$14(a1),d0		;d0 = Offset in image
		move.l	$10(a1),d1		;d1 = Length
		move.l	a1,a0			;a0 = Filename
		add.w	#$10,a0
		move.b	#0,(a0)			;Add null for safety
_ClearSpaces	subq	#1,a0
		cmp.b	#' ',(a0)
		bne	_SaveFile
		move.b	#0,(a0)
		bra	_ClearSpaces
_SaveFile	move.l	a1,a0
		jsr	rawdic_SaveDiskFile(a5)

		lea	($1c,a1),a1
		bra	_NextCrackFile

;_Bootblock	dc.b	"Bootblock",0
		EVEN
		ENDC

;=====================================================================

		IFD	READ_FROM_MFM
_MFMData	incbin	"ram:MFMData"
		ENDC

