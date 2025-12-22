;TOSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
;
;load wb 16 colors:
;Rafik 96.XI.23

	incdir	hd1:sources/
	include	macra.s


_OldOpenLibrary:	equ	-408
_LoadRGB32:	equ	-882

		lea	GfxName,a1
		moveq	#0,D0
		EXEC
		CALL	OldOpenLibrary
		move.l	d0,GfxBase
		ml d0,a6

	ml 34(a6),a0	;actiview
	ml (a0),a0	;vp
	lea	Table(pc),a1	;table
	CALL	LoadRGB32

		q0 d0
		rts

GfxBase:	dc.l	0

Table:
		dc.w	$0010,$0000,$7300,$0000,$7300,$0000,$7300,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$BB00,$0000
		dc.w	$BB00,$0000,$BB00,$0000,$2E00,$0000,$5100,$0000
		dc.w	$8000,$0000,$5500,$0000,$5D00,$0000,$5500,$0000
		dc.w	$8800,$0000,$9200,$0000,$8800,$0000,$8800,$0000
		dc.w	$7300,$0000,$6300,$0000,$DD00,$0000,$9300,$0000
		dc.w	$8300,$0000,$0000,$0000,$0000,$0000,$FF00,$0000
		dc.w	$3200,$0000,$3200,$0000,$3200,$0000,$6000,$0000
		dc.w	$8000,$0000,$6000,$0000,$E200,$0000,$D100,$0000
		dc.w	$7700,$0000,$FF00,$0000,$D400,$0000,$CB00,$0000
		dc.w	$7A00,$0000,$6000,$0000,$4800,$0000,$D200,$0000
		dc.w	$D200,$0000,$D200,$0000,$E500,$0000,$5D00,$0000
		dc.w	$5D00,$0000,$0000,$0000

GfxName:	dc.b	'graphics.library',0
