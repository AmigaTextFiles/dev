; Turrican 2 disk image reader

NO_INCLUDES=1

	IFD	ADF
	include	adfreader.asm
	ELSE
	include	diskreader.asm
	ENDC

	BUFFER	TRACKBUFFER

; track 0: dos track
; $60000 loader after bootblock, 2048 bytes
	DOSREAD	#0
	WRITE	#2048,#1024

; track 1: hiscores track (done in readturr2hisc.asm)
; - $4489 MFM sync
; - unused byte (encoded as 2 bytes MFM)
; - longword checksum. XOR of all proceeding raw MFM data, then
;   odd bits masked out and XOR by $12345678 (encoded as MFM long)
; - unused longword (encoded as 8 bytes MFM), not included in checksum
; - 400 bytes hiscore data (encoded as 100 8-byte MFM encoded longwords)

; tracks 2-159:
; - $9521 MFM sync
; - unused byte (encoded as 2 bytes MFM)
; - 6800 bytes of data (stored as 1700 8-byte MFM encoded longwords)
; - longword checksum, which is XOR of all preceding raw MFM data, then
;   odd bits masked out (encoded as MFM long)

	moveq	#2,d7	; d7 = tracknumber
.nxttrk	RAWREAD	d7	; read track
	RESYNC	#$9521	; resync track

	lea	TRACKBUFFER,a0	; beginning of buffer
	lea	4(a0),a1	; beginning of data in buffer

	move.w	#(6800/4)-1,d0
	moveq	#0,d3		; accumulated checksum
	move.l	#$55555555,d4	; 0101010101010...
.decode	movem.l	(a1)+,d1/d2	; read 8-byte MFM encoded long
	eor.l	d1,d3		; checksum raw MFM data
	eor.l	d2,d3
	and.l	d4,d1		; decode MFM long
	and.l	d4,d2
	add.l	d1,d1
	or.l	d2,d1
	move.l	d1,(a0)+	; write long
	dbra	d0,.decode

	movem.l	(a1)+,d1/d2	; get stored checksum
	and.l	d4,d1		; decode
	and.l	d4,d2
	add.l	d1,d1
	or.l	d2,d1
	and.l	d4,d3		; mask odd bits out
	cmp.l	d1,d3		; verify checksum
	beq.s	.ok
	cmp.b	#159,d7
	beq.s	.ok
	FAILURE	cksum(pc)

.ok	WRITE	#6800

	addq.w	#1,d7
	cmp.w	#160,d7
	bne.s	.nxttrk
	rts

cksum	dc.b	"bad checksum",0
