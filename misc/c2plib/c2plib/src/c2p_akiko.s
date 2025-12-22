; Akiko CD32 c2p conversion

	incdir '../bin/targets/include/sdk/'

	include 'graphics/gfxbase.i'


	MACHINE	68020


pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_akiko_8x1
; C2P conversion 1 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	public	_c2p_akiko_8x1
	cnop	0,4
_c2p_akiko_8x1:
	movem.l	a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	bsr.s	_c2p_akiko_8x1_core

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,a5/a6
	rts





; c2p_akiko_8x1 core procedure
; C2P conversion 1 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x1_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)+	; write bpl0

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x2
; C2P conversion 2 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x2
	cnop	0,4
_c2p_akiko_8x2:
	movem.l	a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x2_core,a2
	bsr.w	_cs2p_8

.loop_end
	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,a2/a5/a6
	rts





; c2p_akiko_8x2 core procedure
; C2P conversion 2 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x2_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl1

	sub.l	d1,a1

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x3
; C2P conversion 3 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x3
	cnop	0,4
_c2p_akiko_8x3:
	movem.l	d7/a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x3_core,a2
	bsr.w	_cs2p_8

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,d7/a2/a5/a6
	rts





; c2p_akiko_8x3 core procedure
; C2P conversion 3 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x3_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	d1,d7
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	add.l	d1,d7
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl1
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl2

	sub.l	d7,a1

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x4
; C2P conversion 4 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x4
	cnop	0,4
_c2p_akiko_8x4:
	movem.l	d7/a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x4_core,a2
	bsr.w	_cs2p_8

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,d7/a2/a5/a6
	rts





; c2p_akiko_8x4 core procedure
; C2P conversion 4 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x4_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	d1,d7
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	add.l	d1,d7
	add.l	d1,d7
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl1
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl2
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl3

	sub.l	d7,a1

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x5
; C2P conversion 5 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x5
	cnop	0,4
_c2p_akiko_8x5:
	movem.l	d7/a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x5_core,a2
	bsr.w	_cs2p_8

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,d7/a2/a5/a6
	rts





; c2p_akiko_8x5 core procedure
; C2P conversion 5 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x5_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	d1,d7
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	asl.l	#2,d7
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl1
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl2
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl3
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl4

	sub.l	d7,a1

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x6
; C2P conversion 6 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x6
	cnop	0,4
_c2p_akiko_8x6:
	movem.l	d7/a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x6_core,a2
	bsr.w	_cs2p_8

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,d7/a2/a5/a6
	rts





; c2p_akiko_8x6 core procedure
; C2P conversion 6 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x6_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	d1,d7
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	asl.l	#2,d7
	add.l	d1,d7
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl1
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl2
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl3
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl4
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl5

	sub.l	d7,a1

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x7
; C2P conversion 7 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x7
	cnop	0,4
_c2p_akiko_8x7:
	movem.l	d7/a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x7_core,a2
	bsr.w	_cs2p_8

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,d7/a2/a5/a6
	rts





; c2p_akiko_8x7 core procedure
; C2P conversion 7 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfx base
	cnop	0,4
_c2p_akiko_8x7_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	d1,d7
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	asl.l	#2,d7
	add.l	d1,d7
	add.l	d1,d7
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl1
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl2
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl3
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl4
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl5
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl6

	sub.l	d7,a1

	dbra.w	d0,.loop

.loop_end
	rts





; c2p_akiko_8x8
; C2P conversion 8 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; d2 = bitplane row size
; d3 = row modulo
; a5 = gfx base
	public	_c2p_akiko_8x8
	cnop	0,4
_c2p_akiko_8x8:
	movem.l	d7/a2/a5/a6,-(sp)
	move.l	a5,a6
	jsr		_SYS_OwnBlitter
	jsr		_SYS_WaitBlit

	lea		_c2p_akiko_8x8_core,a2
	bsr.w	_cs2p_8

	jsr		_SYS_DisownBlitter
	movem.l	(sp)+,d7/a2/a5/a6
	rts





; c2p_akiko_8x8 core procedure
; C2P conversion 8 bit per pixel using Akiko. (V40+)
; a0 = source chunky prt
; a1 = dest planar ptr
; d0 = number of pixels to convert
; d1 = bitplane size (in bytes)
; a5 = gfxbase
	cnop	0,4
_c2p_akiko_8x8_core:
	asr.l	#5,d0		; we will process 32 pixels per cycle
	move.l	d1,d7
	move.l	gb_ChunkyToPlanarPtr(a5),a5
	asl.l	#3,d7
	sub.l	d1,d7
	dbra.w	d0,.loop
	bra.s	.loop_end

	cnop	0,16
.loop:
	; write 32 pixels (4 @time) to Akiko
	move.l	(a0)+,(a5)	; 4
	move.l	(a0)+,(a5)	; 8
	move.l	(a0)+,(a5)	; 12
	move.l	(a0)+,(a5)	; 16
	move.l	(a0)+,(a5)	; 20
	move.l	(a0)+,(a5)	; 24
	move.l	(a0)+,(a5)	; 28
	move.l	(a0)+,(a5)	; 32

	; read the converted bits and write it to bitplanes
	move.l	(a5),(a1)	; write bpl0
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl1
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl2
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl3
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl4
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl5
	add.l	d1,a1
	move.l	(a5),(a1)	; write bpl6
	add.l	d1,a1
	move.l	(a5),(a1)+	; write bpl7

	sub.l	d7,a1

	dbra.w	d0,.loop

.loop_end
	rts



	end

