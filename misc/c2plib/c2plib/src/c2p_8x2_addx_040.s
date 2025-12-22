; optimized version for CPU with bigger instruction cache (040+)

	MACHINE	68040





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x2_addx_040
; Chunky 2 Planar conversion, 2 bit per pixel, optimized for 040+.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
; d2 = bitplane row size
; d3 = row modulo
	public	_c2p_8x2_addx_040
	cnop	0,4
_c2p_8x2_addx_040:
	push.l	a2

	lea		_c2p_8x2_addx_040_core,a2
	bsr.w	_cs2p_8

	pop.l	a2
	rts










; c2p_8x2_addx_040 core procedure
; Chunky 2 Planar conversion, 2 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x2_addx_040_core
	cnop	0,4
_c2p_8x2_addx_040_core:

  ; pre-pass to optimize columns

;start
	move.l	d1,a2		; bplsize in a2

	move.l	d0,d7
	lsr.l	#5,d7		; 32 pixels per loop

	dbra.w	d7,.c2p_loop
	nop

	cnop	0,64
.c2p_loop:
	movem.l	(a0)+,d0-d4/a3-a5
		; D0 = 0, 1, 2, 3
		; D1 = 4, 5, 6, 7
		; D2 = 8, 9, 10, 11
		; D3 = 12, 13, 14, 15
		; D4 = 16, 17, 18, 19
		; A3 = 20, 21, 22, 23
		; A4 = 24, 25, 26, 27
		; A5 = 28, 29, 30, 31

		; D5 will contains bpl0
		; D6 will contains bpl1

	lsl.l	#7,d0		; bit 0
	addx.l	d6,d6
	add.l	d0,d0		; bit 0
	addx.l	d5,d5
	lsl.l	#7,d0		; bit 1
	addx.l	d6,d6
	add.l	d0,d0		; bit 1
	addx.l	d5,d5
	lsl.l	#7,d0		; bit 2
	addx.l	d6,d6
	add.l	d0,d0		; bit 2
	addx.l	d5,d5
	lsl.l	#7,d0		; bit 3
	addx.l	d6,d6
	add.l	d0,d0		; bit 3
	addx.l	d5,d5
		; D0 = free to use

	lsl.l	#7,d1		; bit 4
	addx.l	d6,d6
	add.l	d1,d1		; bit 4
	addx.l	d5,d5
	lsl.l	#7,d1		; bit 5
	addx.l	d6,d6
	add.l	d1,d1		; bit 5
	addx.l	d5,d5
	lsl.l	#7,d1		; bit 6
	addx.l	d6,d6
	add.l	d1,d1		; bit 6
	addx.l	d5,d5
	lsl.l	#7,d1		; bit 7
	addx.l	d6,d6
	add.l	d1,d1		; bit 7
	addx.l	d5,d5
		; D1 = free to use

	move.l	a3,d0		; moved here to optimize superscalar pipeline
		; D0 = 20, 21, 22, 23

	lsl.l	#7,d2		; bit 8
	addx.l	d6,d6
	add.l	d2,d2		; bit 8
	addx.l	d5,d5
	lsl.l	#7,d2		; bit 9
	addx.l	d6,d6
	add.l	d2,d2		; bit 9
	addx.l	d5,d5
	lsl.l	#7,d2		; bit 10
	addx.l	d6,d6
	add.l	d2,d2		; bit 10
	addx.l	d5,d5
	lsl.l	#7,d2		; bit 11
	addx.l	d6,d6
	add.l	d2,d2		; bit 11
	addx.l	d5,d5
		; D2 = free to use

	lsl.l	#7,d3		; bit 12
	addx.l	d6,d6
	add.l	d3,d3		; bit 12
	addx.l	d5,d5
	lsl.l	#7,d3		; bit 13
	addx.l	d6,d6
	add.l	d3,d3		; bit 13
	addx.l	d5,d5
	lsl.l	#7,d3		; bit 14
	addx.l	d6,d6
	add.l	d3,d3		; bit 14
	addx.l	d5,d5
	lsl.l	#7,d3		; bit 15
	addx.l	d6,d6
	add.l	d3,d3		; bit 15
	addx.l	d5,d5
		; D3 = free to use

	move.l	a4,d1		; moved here to optimize superscalar pipeline
		; D1 = 24, 25, 26, 27

	lsl.l	#7,d4		; bit 16
	addx.l	d6,d6
	add.l	d4,d4		; bit 16
	addx.l	d5,d5
	lsl.l	#7,d4		; bit 17
	addx.l	d6,d6
	add.l	d4,d4		; bit 17
	addx.l	d5,d5
	lsl.l	#7,d4		; bit 18
	addx.l	d6,d6
	add.l	d4,d4		; bit 18
	addx.l	d5,d5
	lsl.l	#7,d4		; bit 19
	addx.l	d6,d6
	add.l	d4,d4		; bit 19
	addx.l	d5,d5
		; D4 = free to use

	lsl.l	#7,d0		; bit 20
	addx.l	d6,d6
	add.l	d0,d0		; bit 20
	addx.l	d5,d5
	lsl.l	#7,d0		; bit 21
	addx.l	d6,d6
	add.l	d0,d0		; bit 21
	addx.l	d5,d5
	lsl.l	#7,d0		; bit 22
	addx.l	d6,d6
	add.l	d0,d0		; bit 22
	addx.l	d5,d5
	lsl.l	#7,d0		; bit 23
	addx.l	d6,d6
	add.l	d0,d0		; bit 23
	addx.l	d5,d5
		; D0 = free to use

	move.l	a5,d2		; moved here to optimize superscalar pipeline
		; D2 = 28, 29, 30, 31

	lsl.l	#7,d1		; bit 24
	addx.l	d6,d6
	add.l	d1,d1		; bit 24
	addx.l	d5,d5
	lsl.l	#7,d1		; bit 25
	addx.l	d6,d6
	add.l	d1,d1		; bit 25
	addx.l	d5,d5
	lsl.l	#7,d1		; bit 26
	addx.l	d6,d6
	add.l	d1,d1		; bit 26
	addx.l	d5,d5
	lsl.l	#7,d1		; bit 27
	addx.l	d6,d6
	add.l	d1,d1		; bit 27
	addx.l	d5,d5
		; D1 = free to use

	lsl.l	#7,d2		; bit 28
	addx.l	d6,d6
	add.l	d2,d2		; bit 28
	addx.l	d5,d5
	lsl.l	#7,d2		; bit 29
	addx.l	d6,d6
	add.l	d2,d2		; bit 29
	addx.l	d5,d5
	lsl.l	#7,d2		; bit 30
	addx.l	d6,d6
	add.l	d2,d2		; bit 30
	addx.l	d5,d5
	lsl.l	#7,d2		; bit 31
	addx.l	d6,d6
	; superscalar interleaving
	move.l	d6,0(a1,a2.l)	;write bpl1
	add.l	d2,d2		; bit 31
	addx.l	d5,d5
		; D2 = free to use

	move.l	d5,(a1)+		;write bpl0

	dbra	d7,.c2p_loop
.c2p_loop_end:

;	; DEBUG: trying to calculate the loop code size in bytes
;	lea		.c2p_loop,a0
;	lea		.c2p_loop_end,a1
;	move.l	a1,d0
;	sub.l	a0,d0	; 0x114 = 276 bytes
;	nop

			;------;
			; exit ;
			;------;

.c2p_exit:

	rts
  




	end

