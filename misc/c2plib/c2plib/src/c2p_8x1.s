; Convert 8 bit chunky to 1 bitplane planar

	MACHINE	68020





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x1
; Chunky 2 Planar conversion, 1 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1
	cnop	0,4
_c2p_8x1:
	bra.w	_c2p_8x1_addx










; c2p_8x1_040
; Chunky 2 Planar conversion, 1 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1_040
	cnop	0,4
_c2p_8x1_040:
	bra.w	_c2p_8x1_addx










; c2p_8x1_delta
; Chunky 2 Planar delta conversion, 1 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1_delta
	cnop	0,4
_c2p_8x1_delta:

	push.l	a4

	lea		_c2p_8x1_addx,a4
	bsr.w	_cs2p_8_delta

	pop.l	a4
	rts










; c2p_8x1_delta_writeback
; Chunky 2 Planar delta conversion, 1 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1_delta_writeback
	cnop	0,4
_c2p_8x1_delta_writeback:

	push.l	a4

	lea		_c2p_8x1_addx,a4
	bsr.w	_cs2p_8_delta_writeback

	pop.l	a4
	rts










; s2p_8x1
; Scrambled 2 Planar conversion, 1 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_s2p_8x1
	cnop	0,4
_s2p_8x1:
	bra.w	_s2p_8x1_mexg










; s2p_8x1_delta
; Scrambled 2 Planar delta conversion, 1 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_s2p_8x1_delta
	cnop	0,4
_s2p_8x1_delta:

	push.l	a4

	lea		_s2p_8x1_mexg,a4
	bsr.w	_cs2p_8_delta

	pop.l	a4
	rts










; s2p_8x1_delta_writeback
; Scrambled 2 Planar delta conversion, 1 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_s2p_8x1_delta_writeback
	cnop	0,4
_s2p_8x1_delta_writeback:

	push.l	a4

	lea		_s2p_8x1_mexg,a4
	bsr.w	_cs2p_8_delta_writeback

	pop.l	a4
	rts





	end

