; Convert 8 bit chunky to 3 bitplanes planar

	MACHINE	68020





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x3_addx
; Chunky 2 Planar conversion, 3 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; a2 = scrambled buffer
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x3_addx
	cnop	0,4
_c2p_8x3_addx:
	push.l	a2

	lea		_c2p_8x3_addx_core,a2
	bsr.w	_cs2p_8

	pop.l	a2
	rts










; c2p_8x3_addx core procedure
; Chunky 2 Planar conversion, 3 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x3_addx_core
	cnop	0,4
_c2p_8x3_addx_core:

	move.l	d1,a2		; bplsize in a2

	move.l	d0,d7
	lsr.l	#5,d7		; 32 pixels per loop

	dbra.w	d7,.c2p_loop
	nop

	cnop	0,64
.c2p_loop:

	swap	d7
	move.w	#1,d7		; inner loop converts 16 pixels

.inner_loop:
	movem.l	(a0)+,d0-d3
		; D0 = 0, 1, 2, 3
		; D1 = 4, 5, 6, 7
		; D2 = 8, 9, 10, 11
		; D3 = 12, 13, 14, 15

		; D4 will contains bpl0
		; D5 will contains bpl1
		; D6 will contains bpl2

	lsl.l	#6,d0		; bit 0
	addx.l	d6,d6
	add.l	d0,d0		; bit 0
	addx.l	d5,d5
	add.l	d0,d0		; bit 0
	addx.l	d4,d4
	lsl.l	#6,d0		; bit 1
	addx.l	d6,d6
	add.l	d0,d0		; bit 1
	addx.l	d5,d5
	add.l	d0,d0		; bit 1
	addx.l	d4,d4
	lsl.l	#6,d0		; bit 2
	addx.l	d6,d6
	add.l	d0,d0		; bit 2
	addx.l	d5,d5
	add.l	d0,d0		; bit 2
	addx.l	d4,d4
	lsl.l	#6,d0		; bit 3
	addx.l	d6,d6
	add.l	d0,d0		; bit 3
	addx.l	d5,d5
	add.l	d0,d0		; bit 3
	addx.l	d4,d4
		; D0 = free to use

	lsl.l	#6,d1		; bit 0
	addx.l	d6,d6
	add.l	d1,d1		; bit 0
	addx.l	d5,d5
	add.l	d1,d1		; bit 0
	addx.l	d4,d4
	lsl.l	#6,d1		; bit 1
	addx.l	d6,d6
	add.l	d1,d1		; bit 1
	addx.l	d5,d5
	add.l	d1,d1		; bit 1
	addx.l	d4,d4
	lsl.l	#6,d1		; bit 2
	addx.l	d6,d6
	add.l	d1,d1		; bit 2
	addx.l	d5,d5
	add.l	d1,d1		; bit 2
	addx.l	d4,d4
	lsl.l	#6,d1		; bit 3
	addx.l	d6,d6
	add.l	d1,d1		; bit 3
	addx.l	d5,d5
	add.l	d1,d1		; bit 3
	addx.l	d4,d4
		; D1 = free to use

	lsl.l	#6,d2		; bit 0
	addx.l	d6,d6
	add.l	d2,d2		; bit 0
	addx.l	d5,d5
	add.l	d2,d2		; bit 0
	addx.l	d4,d4
	lsl.l	#6,d2		; bit 1
	addx.l	d6,d6
	add.l	d2,d2		; bit 1
	addx.l	d5,d5
	add.l	d2,d2		; bit 1
	addx.l	d4,d4
	lsl.l	#6,d2		; bit 2
	addx.l	d6,d6
	add.l	d2,d2		; bit 2
	addx.l	d5,d5
	add.l	d2,d2		; bit 2
	addx.l	d4,d4
	lsl.l	#6,d2		; bit 3
	addx.l	d6,d6
	add.l	d2,d2		; bit 3
	addx.l	d5,d5
	add.l	d2,d2		; bit 3
	addx.l	d4,d4
		; D2 = free to use

	lsl.l	#6,d3		; bit 0
	addx.l	d6,d6
	add.l	d3,d3		; bit 0
	addx.l	d5,d5
	add.l	d3,d3		; bit 0
	addx.l	d4,d4
	lsl.l	#6,d3		; bit 1
	addx.l	d6,d6
	add.l	d3,d3		; bit 1
	addx.l	d5,d5
	add.l	d3,d3		; bit 1
	addx.l	d4,d4
	lsl.l	#6,d3		; bit 2
	addx.l	d6,d6
	add.l	d3,d3		; bit 2
	addx.l	d5,d5
	add.l	d3,d3		; bit 2
	addx.l	d4,d4
	lsl.l	#6,d3		; bit 3
	addx.l	d6,d6
	add.l	d3,d3		; bit 3
	addx.l	d5,d5
	add.l	d3,d3		; bit 3
	addx.l	d4,d4
		; D3 = free to use

	dbra	d7,.inner_loop

	move.l	d6,0(a1,a2.l*2)	;write bpl2
	move.l	d5,0(a1,a2.l)	;write bpl1
	swap	d7
	move.l	d4,(a1)+		;write bpl0

	dbra	d7,.c2p_loop
.c2p_loop_end:

;	; DEBUG: trying to calculate the loop code size in bytes
;	lea		.c2p_loop,a0
;	lea		.c2p_loop_end,a1
;	move.l	a1,d0
;	sub.l	a0,d0	; 0x0de = 222 bytes
;	nop

			;------;
			; exit ;
			;------;

.c2p_exit:

	rts





	end

