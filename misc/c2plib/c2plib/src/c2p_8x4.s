; Convert 8 bit chunky to 4 bitplanes planar

	MACHINE	68020





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x4
; Chunky 2 Planar conversion, 4 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; a2 = scrambled buffer
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x4
	cnop	0,4
_c2p_8x4:

	bra.w	_c2p_8x4_mexg










; c2p_8x4_040
; Chunky 2 Planar conversion, 4 bit per pixel, optimized for 040+.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x4_040
	cnop	0,4
_c2p_8x4_040:

	bra.w	_c2p_8x4_mexg_040










; c2p_8x4_delta
; Chunky 2 Planar delta conversion, 4 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x4_delta
	cnop	0,4
_c2p_8x4_delta:

	movem.l	a2/a4,-(sp)

	lea		_c2p_8x4_mexg_040_core,a4
	lea		_cs2p_8_delta_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts










; c2p_8x4_delta_writeback
; Chunky 2 Planar delta conversion, 4 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x4_delta_writeback
	cnop	0,4
_c2p_8x4_delta_writeback:

	movem.l	a2/a4,-(sp)

	lea		_c2p_8x4_mexg_040_core,a4
	lea		_cs2p_8_delta_writeback_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts










; s2p_8x4
; Scrambled 2 Planar conversion, 4 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_s2p_8x4
	cnop	0,4
_s2p_8x4:

	bra.w	_s2p_8x4_mexg










; s2p_8x4_delta
; Scrambled 2 Planar delta conversion, 4 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_s2p_8x4_delta
	cnop	0,4
_s2p_8x4_delta:

	movem.l	a2/a4,-(sp)

	lea		_s2p_8x4_mexg_core,a4
	lea		_cs2p_8_delta_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts










; s2p_8x4_delta_writeback
; Scrambled 2 Planar delta conversion, 4 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_s2p_8x4_delta_writeback
	cnop	0,4
_s2p_8x4_delta_writeback:

	movem.l	a2/a4,-(sp)

	lea		_s2p_8x4_mexg_core,a4
	lea		_cs2p_8_delta_writeback_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts





	end
