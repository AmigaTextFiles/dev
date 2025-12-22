NO_INCLUDES=1
MESSAGES=1
	include	adfreader.asm

; track 0: dos track (5632 bytes)

	WRITEDOS #0

; track 1:
; - $4489 MFM sync
; - $2aaa MFM ID
; - 6144 bytes of data (1536 * 8-byte MFM encoded longwords)
; - longword checksum (1 * 8-byte MFM encoded longword)

; tracks 2-159 except track 43:
; - $4489 MFM sync
; - $2aa5 MFM ID
; - cylinder number, eg 1-79 (1 * 4-byte MFM encoded word)
; - 6656 bytes of data (1664 * 8-byte MFM longwords)
; - longword checksum (1 * 8-byte MFM longword)

; track 43:
; - $4489 MFM sync
; - $2aa5 MFM ID
; - 6144 bytes of data (1536 * 8-byte MFM encoded longwords)
; - longword checksum (1 * 8-byte MFM encoded longword)

; checksums of tracks are coded by longword adds of all decoded data

; The WHD slave uses reversed disk-sides from track 2 onwards, so the
; track saving order is 0, 1, 3,2, 5,4, 7,6, 9,8, ...

GETMFM	MACRO	; gets one mfm longword
	movem.l	(a1)+,d1/d2
	and.l	d4,d1
	and.l	d4,d2
	add.l	d1,d1
	or.l	d2,d1
	ENDM

	move.l	#$55555555,d4	; d4 = 0101010101010...
	moveq	#0,d7		; d7 = track

.nxttrk	move.l	d7,d1
	eori.b	#1,d1
	RAWREAD	d1
	RESYNC	#$4489

	lea	__trk,a0	; beginning of buffer
	move.l	a0,a1		; find beginning of data in buffer
.again	cmp.w	#$4489,(a1)+	; and skip first word ($2aa5/$2aaa)
	beq.s	.again

	cmp.b	#0,d7		; tracks 1 and 43 are different to the rest
	beq.s	.shrtrk
	cmp.b	#42,d7
	beq.s	.shrtrk
	addq	#4,a1

	move.w	#(6656/4)-1,d0
	bra.s	.cont
.shrtrk	move.w	#(6144/4)-1,d0
.cont
	moveq	#0,d3		; accumulated checksum
.decode	GETMFM
	move.l	d1,(a0)+	; write long
	add.l	d1,d3		; checksum decoded data
	dbra	d0,.decode
	GETMFM			; get stored checksum
	cmp.l	d1,d3		; verify checksum
	bne.s	.fail

	move.l	#6656,d1
	cmp.b	#0,d7		; track 1 = 6144 bytes
	bne.s	.ntrk1
	addq.b	#1,d7		; next track = 3 (then 2, 5, 4, 7, 6...)
	move.w	#6144,d1
.ntrk1	WRITE	d1		; save to diskfile

	addq.w	#1,d7
	cmp.w	#160,d7
	bne	.nxttrk
	rts

.fail	FAILURE	cksum(pc)
cksum	dc.b	'bad checksum',0
