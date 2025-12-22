; optimized version for CPU with bigger instruction cache (040+)

	MACHINE	68020





pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x1_addx
; Chunky 2 Planar conversion, 1 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1_addx
	cnop	0,4
_c2p_8x1_addx:
	movem.l	d2-d7/a2-a6,-(sp)

  ; pre-pass to optimize columns

;start
	push.l	a6
	push.l	a0
	push.l	a1
	push.l	d0
	push.l	d1

; local variables displacements relative to (sp)
library		equ	16
chunky		equ	12
raster		equ	8
num_pixels	equ	4
bpl_size	equ	0

	move.l	chunky(sp),a0
	move.l	raster(sp),a1

	move.l	d1,a2		; bplsize in a2

	move.l	num_pixels(sp),d6
	lsr.l	#5,d6		; 32 pixels per loop
	subq.l	#1,d6		; loop counter

	bra.s	.c2p_loop
	nop

	cnop	0,64
.c2p_loop:
	movem.l	(a0)+,d0-d5/a3-a4
		; D0 = 0, 1, 2, 3
		; D1 = 4, 5, 6, 7
		; D2 = 8, 9, 10, 11
		; D3 = 12, 13, 14, 15
		; D4 = 16, 17, 18, 19
		; D5 = 20, 21, 22, 23
		; A3 = 24, 25, 26, 27
		; A4 = 28, 29, 30, 31

		; D7 will contains bpl0

	lsl.l	#8,d0		; test bit 0
	addx.l	d7,d7
	lsl.l	#8,d0		; test bit 1
	addx.l	d7,d7
	lsl.l	#8,d0		; test bit 2
	addx.l	d7,d7
	lsl.l	#8,d0		; test bit 3
	addx.l	d7,d7
		; D0 = free to use

	lsl.l	#8,d1		; test bit 4
	addx.l	d7,d7
	lsl.l	#8,d1		; test bit 5
	addx.l	d7,d7
	lsl.l	#8,d1		; test bit 6
	addx.l	d7,d7
	lsl.l	#8,d1		; test bit 7
	addx.l	d7,d7
		; D1 = free to use

	lsl.l	#8,d2		; test bit 8
	addx.l	d7,d7
	lsl.l	#8,d2		; test bit 9
	addx.l	d7,d7
	lsl.l	#8,d2		; test bit 10
	addx.l	d7,d7
	lsl.l	#8,d2		; test bit 11
	addx.l	d7,d7
		; D2 = free to use

	move.l	a3,d0		; moved here to optimize superscalar pipeline
		; D0 = 24, 25, 26, 27

	lsl.l	#8,d3		; test bit 12
	addx.l	d7,d7
	lsl.l	#8,d3		; test bit 13
	addx.l	d7,d7
	lsl.l	#8,d3		; test bit 14
	addx.l	d7,d7
	lsl.l	#8,d3		; test bit 15
	addx.l	d7,d7
		; D3 = free to use

	lsl.l	#8,d4		; test bit 16
	addx.l	d7,d7
	lsl.l	#8,d4		; test bit 17
	addx.l	d7,d7
	lsl.l	#8,d4		; test bit 18
	addx.l	d7,d7
	lsl.l	#8,d4		; test bit 19
	addx.l	d7,d7
		; D4 = free to use

	lsl.l	#8,d5		; test bit 20
	addx.l	d7,d7
	lsl.l	#8,d5		; test bit 21
	addx.l	d7,d7
	lsl.l	#8,d5		; test bit 22
	addx.l	d7,d7
	lsl.l	#8,d5		; test bit 23
	addx.l	d7,d7
		; D5 = free to use

	move.l	a4,d1		; moved here to optimize superscalar pipeline
		; D1 = 28, 29, 30, 31

	lsl.l	#8,d0		; test bit 24
	addx.l	d7,d7
	lsl.l	#8,d0		; test bit 25
	addx.l	d7,d7
	lsl.l	#8,d0		; test bit 26
	addx.l	d7,d7
	lsl.l	#8,d0		; test bit 27
	addx.l	d7,d7
		; D0 = free to use

	lsl.l	#8,d1		; test bit 28
	addx.l	d7,d7
	lsl.l	#8,d1		; test bit 29
	addx.l	d7,d7
	lsl.l	#8,d1		; test bit 30
	addx.l	d7,d7
	lsl.l	#8,d1		; test bit 31
	addx.l	d7,d7
		; D1 = free to use
					
	move.l	d7,(a1)+			;write bpl0
		;d7 = free for use

	dbra	d6,.c2p_loop
.c2p_loop_end:

;	; DEBUG: trying to calculate the loop code size in bytes
;	lea		.c2p_loop,a0
;	lea		.c2p_loop_end,a1
;	move.l	a1,d0
;	sub.l	a0,d0	; 0x8e = 142 bytes
;	nop

			;------;
			; exit ;
			;------;

.c2p_exit:

	pop.l	d1
	pop.l	d0
	pop.l	a1
	pop.l	a0
	pop.l	a6

	movem.l	(sp)+,d2-d7/a2-a6
	rts
  
	end

