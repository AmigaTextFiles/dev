; Convert 8 bit chunky to 1 bitplane planar

	MACHINE	68020

	XDEF       _c2p_8x1_mexg

mexg	MACRO	src,dest,mask,tmp	; bits in mask are swapped
	move.\0	\1,\4
	eor.\0	\2,\4
	and.\0	\3,\4
	eor.\0	\4,\1
	eor.\0	\4,\2
	ENDM

pop   MACRO reg
	move.\0 (sp)+,\1
	ENDM

push  MACRO reg
	move.\0 \1,-(sp)
	ENDM





	section    code





; c2p_8x1_mexg
; Chunky 2 Planar conversion, 1 bit per pixel.
; a0 = chunky buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_c2p_8x1_mexg
	cnop	0,4
_c2p_8x1_mexg:
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

	move.l	num_pixels(sp),d7
	lsr.l	#5,d7		; 32 pixels per loop
	subq.l	#1,d7		; loop counter

	bra.s	.c2p_loop
	nop

	cnop	0,64
.c2p_loop:
	move.w	d7,a4		; loop counter in a4
	movem.l	(a0)+,d0-d7
		; D0 = 0, 1, 2, 3
		; D1 = 4, 5, 6, 7
		; D2 = 8, 9, 10, 11
		; D3 = 12, 13, 14, 15
		; D4 = 16, 17, 18, 19
		; D5 = 20, 21, 22, 23
		; D6 = 24, 25, 26, 27
		; D7 = 28, 29, 30, 31
	ror.l	#8,d2
	ror.l	#8,d3
	swap	d4
	swap	d5
	rol.l	#8,d6
	rol.l	#8,d7
		; D0 = 0, 1, 2, 3
		; D1 = 4, 5, 6, 7
		; D2 = 11, 8, 9, 10
		; D3 = 15, 12, 13, 14
		; D4 = 18, 19, 16, 17
		; D5 = 22, 23, 20, 21
		; D6 = 25, 26, 27, 24
		; D7 = 29, 30, 31, 28

	move.w	d0,a6
	move.w	d1,a5
	move.w	d4,d0	; D0 = 0, 1, 16, 17
	move.w	d5,d1	; D1 = 4, 5, 20, 21
	move.w	a6,d4	; D4 = 18, 19, 2, 3
	move.w	a5,d5	; D5 = 22, 23, 6, 7
	move.w	d2,a6
	move.w	d3,a5
	move.w	d6,d2	; D2 = 11, 8, 27, 24
	move.w	d7,d3	; D3 = 15, 12, 31, 28
	move.w	a6,d6	; D6 = 25, 26, 9, 10
	move.w	a5,d7	; D7 = 29, 30, 13, 14
		; D0 = 0, 1, 16, 17
		; D1 = 4, 5, 20, 21
		; D2 = 11, 8, 27, 24
		; D3 = 15, 12, 31, 28
		; D4 = 18, 19, 2, 3
		; D5 = 22, 23, 6, 7
		; D6 = 25, 26, 9, 10
		; D7 = 29, 30, 13, 14

mask_bytes	equ	$FF00FF00

	;move.l	d3,a3	; A3 = 15, 12, 31, 28
	;move.l	#mask_bytes,d3
	move.l	d7,a5	; A5 = 29, 30, 13, 14 : D7 = scratch

	move.l	d0,d7
	and.l	#mask_bytes,d0	; D0 = 0, _, 16, _
	eor.l	d0,d7	; D7 = _, 1, _, 17
	eor.l	d2,d0
	and.l	#mask_bytes,d2	; D2 = 11, _, 27, _
	eor.l	d2,d0	; D0 = 0, 8, 16, 24
	eor.l	d4,d2
	and.l	#mask_bytes,d4	; D4 = 18, _, 2, _
	eor.l	d4,d2	; D2 = 11, 19, 27, 3
	eor.l	d6,d4
	ror.l	#8,d2	; D2 = 3, 11, 19, 27
	and.l	#mask_bytes,d6	; D6 = 25, _, 9, _
	eor.l	d6,d4	; D4 = 18, 26, 2, 10
	or.l	d7,d6	; D6 = 25, 1, 9, 17
	swap	d4		; D4 = 2, 10, 18, 26

	rol.l	#8,d6	; D6 = 1, 9, 17, 25

	;exg.l	a3,d0	; D0 = 15, 12, 31, 28 : A3 = 0, 8, 16, 24
	move.l	d6,a6	; A6 = 1, 9, 17, 25
	move.l	a5,d7	; D7 = 29, 30, 13, 14 : A5 = scratch

	move.l	d1,d6
	and.l	#mask_bytes,d1	; D1 = 4, _, 20, _
	eor.l	d1,d6	; D6 = _, 5, _, 21
	eor.l	d3,d1
	and.l	#mask_bytes,d3	; D3 = 15, _, 31, _
	eor.l	d3,d1	; D1 = 4, 12, 20, 28
	eor.l	d5,d3
	and.l	#mask_bytes,d5	; D5 = 22, _, 6, _
	eor.l	d5,d3	; D3 = 15, 23, 31, 7
	eor.l	d7,d5
	ror.l	#8,d3	; D3 = 7, 15, 23, 31
	and.l	#mask_bytes,d7	; D7 = 29, _, 13, _
	eor.l	d7,d5	; D5 = 22, 30, 6, 14
	or.l	d6,d7	; D7 = 29, 5, 13, 21

	swap	d5		; D5 = 6, 14, 22, 30
	rol.l	#8,d7	; D7 = 5, 13, 21, 29

		; D0 = 0, 8, 16, 24
		; A6 = 1, 9, 17, 25
		; D4 = 2, 10, 18, 26
		; D2 = 3, 11, 19, 27
		; D1 = 4, 12, 20, 28
		; D7 = 5, 13, 21, 29
		; D5 = 6, 14, 22, 30
		; D3 = 7, 15, 23, 31
		; A3 = ...free...
		; D6 = ...free...
		; A5 = ...free...

	; arrange registers as if they were read by movem 
	; move.l	d3,d3	; D3 = 7, 15, 23, 31
	; move.l	d2,d2	; D2 = 3, 11, 19, 27
	; move.l	d5,d5	; D5 = 6, 14, 22, 30
	; move.l	d4,d4	; D4 = 2, 10, 18, 26
	; ;move.l	a3,d0	; D0 = 0, 8, 16, 24
	; move.l	d1,d1	; D1 = 4, 12, 20, 28
	; move.l	d7,d7	; D7 = 5, 13, 21, 29
	move.l	a6,d6	; D6 = 1, 9, 17, 25

		; D0 = 0, 8, 16, 24
		; D6 = 1, 9, 17, 25
		; D4 = 2, 10, 18, 26
		; D2 = 3, 11, 19, 27
		; D1 = 4, 12, 20, 28
		; D7 = 5, 13, 21, 29
		; D5 = 6, 14, 22, 30
		; D3 = 7, 15, 23, 31



	;------------------------------------
	; INIT: CHUNKY DATA (1 BYTE PER ROW)
	;------------------------------------

		;---------------------
		;D0 = a7a6a5a4a3a2a1a0
		;d6 = b7b6b5b4b3b2b1b0
		;d4 = c7c6c5c4c3c2c1c0
		;d2 = d7d6d5d4d3d2d1d0
		;d1 = e7e6e5e4e3e2e1e0
		;d7 = f7f6f5f4f3f2f1f0
		;d5 = g7g6g5g4g3g2g1g0
		;d3 = h7h6h5h4h3h2h1h0
		;---------------------



	;--------------------------------------------
	; STEP 1: ROTATE LEFT, 7-N BITS PER N-TH ROW
	;--------------------------------------------

	rol.l	#1,d5
	rol.l	#2,d7
	rol.l	#3,d1

	;move.l	d5,d6		; superscalar interleaving, see below

	rol.l	#6,d6
	rol.l	#4,d2
	rol.l	#5,d4
	rol.l	#7,d0

		;---------------------
		;D0 = a0i7i6i5i4i3i2i1
		;d6 = b1b0j7j6j5j4j3j2
		;d4 = c2c1c0k7k6k5k4k3
		;d2 = d3d2d1d0l7l6l5l4
		;d1 = e4e3e2e1e0m7m6m5
		;d7 = f5f4f3f2f1f0n7n6
		;d5 = g6g5g4g3g2g1g0o7
		;d3 = h7h6h5h4h3h2h1h0
		;---------------------



	;--------------------------
	; STEP 2: SWAP SINGLE BITS
	;--------------------------

mask_bits	equ	$AAAAAAAA
	;move.l	#$AAAAAAAA,d5
		;d5 = 1 0 1 0 1 0 1 0

	;mexg.l	d0,d6,#mask_bits,d7
	eor.l	d6,d0
	and.l	#mask_bits,d0
	eor.l	d0,d6
		;MASK 1 0 1 0 1 0 1 0
		;d6 = a0b0i6j6i4j4i2j2

	;mexg.l	d4,d2,#mask_bits,d7
	eor.l	d2,d4
	and.l	#mask_bits,d4
	eor.l	d4,d2
		;MASK 1 0 1 0 1 0 1 0
		;d2 = c2d2c0d0k6l6k4l4

	;exg.l	a6,d6
		;a6 = g6g5g4g3g2g1g0o7
		;d6 = a0b0i6j6i4j4i2j2

	;mexg.l	d1,d7,#mask_bits,d7
	eor.l	d7,d1
	and.l	#mask_bits,d1
	eor.l	d1,d7
		;MASK 1 0 1 0 1 0 1 0
		;d7 = e4f4e2f2e0f0m6n6

	;mexg.l	d5,d3,#mask_bits,d7
	eor.l	d3,d5
	and.l	#mask_bits,d5
	eor.l	d5,d3
		;MASK 1 0 1 0 1 0 1 0
		;d3 = g6h6g4h4g2h2g0h0

		;---------------------
		;D0 = available
		;d6 = a0b0i6j6i4j4i2j2
		;d4 = available
		;d2 = c2d2c0d0k6l6k4l4
		;d1 = available
		;d7 = e4f4e2f2e0f0m6n6
		;d5 = available
		;d3 = g6h6g4h4g2h2g0h0
		;---------------------



	;---------------------------
	; STEP 3: SWAP COUPLED BITS
	;---------------------------

mask_couples_1	equ	$99999999
	;move.l	#$99999999,d5
		;d5 = 1 0 0 1 1 0 0 1

mask_couples_2	equ	$CCCCCCCC
	;ror.l	#1,d5	; #$CCCCCCCC
		;d5 = 1 1 0 0 1 1 0 0

	;mexg.l	d7,d3,#mask_couples_2,d7
	eor.l	d3,d7
	and.l	#mask_couples_2,d7
	eor.l	d7,d3
		;MASK 1 1 0 0 1 1 0 0
		;d3 = e4f4g4h4e0f0g0h0

	;exg.l	a6,d6
		;d6 = f5g5h5e1f1g1h1m5
		;a6 = a0b0i6j6i4j4i2j2

	;mexg.l	d2,d6,#mask_couples_2,d7
	eor.l	d2,d6
	and.l	#mask_couples_2,d6
	eor.l	d6,d2
		;MASK 1 1 0 0 1 1 0 0
		;d2 = a0b0c0d0i4j4k4l4

		;---------------------
		;D0 = available
		;d6 = available
		;d1 = available
		;d2 = a0b0c0d0i4j4k4l4
		;d4 = available
		;d7 = available
		;d5 = available
		;d3 = e4f4g4h4e0f0g0h0
		;---------------------



	;----------------------
	; STEP 4: SWAP NIBBLES
	;----------------------

mask_nibbles_1	equ	$F0F0F0F0
	;move.l	#$F0F0F0F0,d5
		;d5 = 1 1 1 1 0 0 0 0

	;mexg.l	d3,d2,#mask_nibbles_1,d7
	eor.l	d3,d2
	and.l	#mask_nibbles_1,d2
	eor.l	d2,d3
		;MASK 1 1 1 1 0 0 0 0
		;d3 = a0b0c0d0e0f0g0h0

	move.l	d3,(a1)+			;write bpl0
		;d3 = free for use

mask_nibbles_2	equ	$E1E1E1E1
	;rol.l	#1,d5	; #$E1E1E1E1
		;d5 = 1 1 1 0 0 0 0 1

mask_nibbles_3	equ	$C3C3C3C3
	;rol.l	#1,d5	; #$C3C3C3C3
		;d5 = 1 1 0 0 0 0 1 1

mask_nibbles_4	equ	$87878787
	;rol.l	#1,d5	; #$87878787
		;d5 = 1 0 0 0 0 1 1 1

	move.w	a4,d7

	dbra	d7,.c2p_loop
.c2p_loop_end:

;	; DEBUG: trying to calculate the loop code size in bytes
;	lea		.c2p_loop,a0
;	lea		.c2p_loop_end,a1
;	move.l	a1,d0
;	sub.l	a0,d0	; 0xee = 238 bytes
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










; s2p_8x1_mexg
; Scrambled 2 Planar conversion, 1 bit per pixel.
; a0 = scrambled buffer
; a1 = raster address
; d0 = num pixels to convert
; d1 = bitplane size
	public	_s2p_8x1_mexg
	cnop	0,4
_s2p_8x1_mexg:

	movem.l	d2-d7/a2-a6,-(sp)

	move.l	d1,a2			;bplsize in a2

	lsr.l	#5,d0			;32 pixels per loop
	subq.l	#1,d0
	move.l	d0,d7

	bra.s	.s2p_loop
	nop		; avoid compiler warning "short-branch to following instruction turned into a nop"

	cnop	0,64
.s2p_loop:

	move.w	d7,a4



	;------------------------------------
	; INIT: CHUNKY DATA (1 BYTE PER ROW)
	;------------------------------------

	movem.l	(a0)+,d0-d6/a5

		;---------------------
		;D0 = a7a6a5a4a3a2a1a0
		;D1 = b7b6b5b4b3b2b1b0
		;D2 = c7c6c5c4c3c2c1c0
		;D3 = d7d6d5d4d3d2d1d0
		;D4 = e7e6e5e4e3e2e1e0
		;D5 = f7f6f5f4f3f2f1f0
		;D6 = g7g6g5g4g3g2g1g0
		;A5 = h7h6h5h4h3h2h1h0
		;---------------------



	;--------------------------------------------
	; STEP 1: ROTATE LEFT, 7-N BITS PER N-TH ROW
	;--------------------------------------------

	rol.l	#1,d6
	rol.l	#2,d5
	rol.l	#3,d4

	;move.l	d6,a6		; superscalar interleaving, see below

	rol.l	#6,d1
	rol.l	#4,d3
	rol.l	#5,d2
	rol.l	#7,d0

		;---------------------
		;D0 = a0i7i6i5i4i3i2i1
		;D1 = b1b0j7j6j5j4j3j2
		;D2 = c2c1c0k7k6k5k4k3
		;D3 = d3d2d1d0l7l6l5l4
		;D4 = e4e3e2e1e0m7m6m5
		;D5 = f5f4f3f2f1f0n7n6
		;D6 = g6g5g4g3g2g1g0o7
		;A5 = h7h6h5h4h3h2h1h0
		;---------------------



	;--------------------------
	; STEP 2: SWAP SINGLE BITS
	;--------------------------

;mask_bits	equ	$AAAAAAAA
	;move.l	#$AAAAAAAA,d6
		;D6 = 1 0 1 0 1 0 1 0

	;mexg.l	d0,d1,#mask_bits,d7
	eor.l	d1,d0
	and.l	#mask_bits,d0
	eor.l	d0,d1
		;MASK 1 0 1 0 1 0 1 0
		;D1 = a0b0i6j6i4j4i2j2

	;mexg.l	d2,d3,#mask_bits,d7
	eor.l	d3,d2
	and.l	#mask_bits,d2
	eor.l	d2,d3
		;MASK 1 0 1 0 1 0 1 0
		;D3 = c2d2c0d0k6l6k4l4

	;exg.l	d1,a6
		;D1 = g6g5g4g3g2g1g0o7
		;A6 = a0b0i6j6i4j4i2j2

	;mexg.l	d4,d5,#mask_bits,d7
	eor.l	d5,d4
	and.l	#mask_bits,d4
	eor.l	d4,d5
		;MASK 1 0 1 0 1 0 1 0
		;D5 = e4f4e2f2e0f0m6n6

	move.l	a5,d2
		;D2 = h7h6h5h4h3h2h1h0

	;mexg.l	d6,d2,#mask_bits,d7
	eor.l	d2,d6
	and.l	#mask_bits,d6
	eor.l	d6,d2
		;MASK 1 0 1 0 1 0 1 0
		;D2 = g6h6g4h4g2h2g0h0

		;---------------------
		;D0 = available
		;D1 = a0b0i6j6i4j4i2j2
		;A5 = available
		;D3 = c2d2c0d0k6l6k4l4
		;D4 = available
		;D5 = e4f4e2f2e0f0m6n6
		;D6 = available
		;D2 = g6h6g4h4g2h2g0h0
		;---------------------


	;---------------------------
	; STEP 3: SWAP COUPLED BITS
	;---------------------------

;mask_couples_1	equ	$99999999
	;move.l	#$99999999,d6
		;D6 = 1 0 0 1 1 0 0 1

;mask_couples_2	equ	$CCCCCCCC
	;ror.l	#1,d6	; #$CCCCCCCC
		;D6 = 1 1 0 0 1 1 0 0

	;mexg.l	d5,d2,#mask_couples_2,d7
	eor.l	d2,d5
	and.l	#mask_couples_2,d5
	eor.l	d5,d2
		;MASK 1 1 0 0 1 1 0 0
		;D2 = e4f4g4h4e0f0g0h0

	;move.l	a6,d1
		;A6 = f5g5h5e1f1g1h1m5
		;D1 = a0b0i6j6i4j4i2j2

	;mexg.l	d3,d1,#mask_couples_2,d7
	eor.l	d3,d1
	and.l	#mask_couples_2,d1
	eor.l	d1,d3
		;MASK 1 1 0 0 1 1 0 0
		;D3 = a0b0c0d0i4j4k4l4

		;---------------------
		;D0 = available
		;D1 = available
		;D4 = available
		;D3 = a0b0c0d0i4j4k4l4
		;A5 = available
		;D5 = available
		;D6 = available
		;D2 = e4f4g4h4e0f0g0h0
		;---------------------



	;----------------------
	; STEP 4: SWAP NIBBLES
	;----------------------

;mask_nibbles_1	equ	$F0F0F0F0
	;move.l	#$F0F0F0F0,d6
		;D6 = 1 1 1 1 0 0 0 0

	;mexg.l	d2,d3,#mask_nibbles_1,d7
	eor.l	d2,d3
	and.l	#mask_nibbles_1,d3
	eor.l	d3,d2
		;MASK 1 1 1 1 0 0 0 0
		;D2 = a0b0c0d0e0f0g0h0

	move.w	a4,d7
	move.l	d2,(a1)+			;write bpl0
		;D2 = free for use

;mask_nibbles_2	equ	$E1E1E1E1
	;rol.l	#1,d6	; #$E1E1E1E1
		;D6 = 1 1 1 0 0 0 0 1

;mask_nibbles_3	equ	$C3C3C3C3
	;rol.l	#1,d6	; #$C3C3C3C3
		;D6 = 1 1 0 0 0 0 1 1

;mask_nibbles_4	equ	$87878787
	;rol.l	#1,d6	; #$87878787
		;D6 = 1 0 0 0 0 1 1 1

	dbra	d7,.s2p_loop
.s2p_loop_end:

;	; DEBUG: trying to calculate the loop code size in bytes
;	lea		.s2p_loop,a0
;	lea		.s2p_loop_end,a1
;	move.l	a1,d0
;	sub.l	a0,d0	; 0x64 = 100 bytes
;	nop

			;------;
			; exit ;
			;------;

.s2p_exit:

	movem.l	(sp)+,d2-d7/a2-a6
	rts





	end

