; Convert 8 bit chunky to 5 bitplanes planar

	MACHINE	68020





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x5
; Chunky 2 Planar conversion, 5 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; a2 = scrambled buffer
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x5
	cnop	0,4
_c2p_8x5:

	bra.w	_c2p_8x5_mexg










; c2p_8x5_040
; Chunky 2 Planar conversion, 5 bit per pixel, optimized for 040+.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x5_040
	cnop	0,4
_c2p_8x5_040:

	bra.w	_c2p_8x5_mexg_040










; c2p_8x5_delta
; Chunky 2 Planar delta conversion, 5 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x5_delta
	cnop	0,4
_c2p_8x5_delta:

	movem.l	a2/a4,-(sp)

	lea		_c2p_8x5_mexg_040_core,a4
	lea		_cs2p_8_delta_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts










; c2p_8x5_delta_writeback
; Chunky 2 Planar delta conversion, 5 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x5_delta_writeback
	cnop	0,4
_c2p_8x5_delta_writeback:

	movem.l	a2/a4,-(sp)

	lea		_c2p_8x5_mexg_040_core,a4
	lea		_cs2p_8_delta_writeback_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts










; s2p_8x5
; Scrambled 2 Planar conversion, 5 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_s2p_8x5
	cnop	0,4
_s2p_8x5:

	bra.w	_s2p_8x5_mexg










; s2p_8x5_delta
; Scrambled 2 Planar delta conversion, 5 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_s2p_8x5_delta
	cnop	0,4
_s2p_8x5_delta:

	movem.l	a2/a4,-(sp)

	lea		_s2p_8x5_mexg_core,a4
	lea		_cs2p_8_delta_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts










; s2p_8x5_delta_writeback
; Scrambled 2 Planar delta conversion, 5 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; a3 = reference address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_s2p_8x5_delta_writeback
	cnop	0,4
_s2p_8x5_delta_writeback:

	movem.l	a2/a4,-(sp)

	lea		_s2p_8x5_mexg_core,a4
	lea		_cs2p_8_delta_writeback_core,a2
	bsr.w	_cs2p_8_core

	movem.l	(sp)+,a2/a4
	rts





	end
