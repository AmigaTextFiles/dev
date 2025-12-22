;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;
;run bootblock
;rtk/rdst/sct Gdynia 95.04.06

xOpenTrackDisk:		move.l	4.w,a6
			sub.l	a1,a1
			jsr	FindTask(a6)

			lea	DiskRep(pc),a1
			move.l	d0,16(a1)
			jsr	AddPort(a6)
			lea	DiskIO(pc),a1
;			lea	DiskRep(pc),a5
			move.l	#DiskRep,14(a1)
			moveq	#0,d0
			move.l	d0,d1
			lea	TrackDiskName(pc),a0
			jsr	-444(a6)	;open device
					;devname,Unit,request,flags
			tst.l	d0
			bne.s	OpenTrackDisk_Error

*************************************************************************
xReadSector:
;a0 buffer adr
			lea	$1f0000,a0
			movem.l	d0-d7/a0-a6,-(sp)

			lea	DiskIO(pc),a1
			move.l	#DiskRep,14(a1)	;set reply port ?
			move.w	#2,28(a1)	;COM READ
			move.l	a0,40(a1)	;READ ADRES
			move.l	#2*512,d1
			move.l	d1,36(a1)	;LENGHT
			move.l	#0,44(a1)	;OFFSET*512
			move.l	4.w,a6
			jsr	-456(a6)	;DOIO

			movem.l	(sp)+,d0-d7/a0-a6
			lea	DiskIO(pc),a1
			jmp	$c(a0)
			rts

OpenTrackDisk_Error:
			moveq	#-1,d0
			rts


TrackDiskName:	dc.b	'trackdisk.device',0

		even
DiskIO:		dcb.l	20,0
DiskRep:	dcb.l	8,0


OldOpenLibrary				EQU			-408
CloseLibrary				EQU			-414
FindTask				EQU			-294
WaitPort				EQU			-384
AddPort					EQU			-354
RemPort					EQU			-360
OpenDevice				EQU			-444
CloseDevice				EQU			-450
DoIO					EQU			-456
SendIO					EQU			-462
