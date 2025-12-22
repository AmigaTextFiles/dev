
; *-*-*  RAT System Control  *-*-*
; Use:	d0-d7/a0/a4/a5
; IN:	a0 sprite struct
;	a4 rat DATAs
;	a5 DFF000
; OUT:	d2 y pos (no offs)
;	d3 x pos (no offs)

rat_up_out	moveq	#0,d2
		bra.b	rat_x_chk
rat_sx_out	moveq	#0,d3
		bra.b	rat_end_chk

rat_CTRL				; CALCOLO DELLO SPOSTAMENTO
		moveq	#0,d6		; sono fatti miei !!!
		movem.w	(a4),d1-d7	; get: oldpos / y / x / limits (4)
					;	 D1    D2  D3    D4-D7
		move.w	$a(a5),d0	; posizione attulale
		move.w	d0,(a4)		; salva
		sub.w	d1,d0		; delta
		beq.b	rat_end		; non s'e` mosso, fine ...
		moveq	#0,d1		; clr x
		move.b	d0,d1
		asr.w	#8,d0		; delta y D0 ( + coordinata )
		ext.w	d1		; delta x D1 (-> coordinata x)
		bpl.b	rat_y_chk	; se il dx e' negativo deve essere dy+1
rat_bug		addq.w	#1,d0
rat_y_chk	add.w	d0,d2		; add dy alla y
		bmi.b	rat_up_out
		cmp.w	d4,d2		; check lim down
		ble.b	rat_x_chk	; =< ?
		move.w	d4,d2		; max down
rat_x_chk	add.w	d1,d3		; add dx alla x
		bmi.b	rat_sx_out
		cmp.w	d5,d3		; check lim dx
		ble.b	rat_end_chk
		move.w	d5,d3		; max dx
rat_end_chk	movem.w	d2-d3,2(a4)	; save y,x

rat_CALC	moveq	#0,d0		; init spr control words
		add.w	d2,d6		; + y offs => VSTART
		add.w	d3,d7		; + x offs => HSTART
		move.w	d6,d5		; copy VStart
		add.w	#spr_h,d5	; calc VSTOP
		asl.w	#8,d6		; shift 8
		bcc.b	rat_no_VS8	; il bit 8 vert-start non e' settato
		addq.w	#4,d0		; set VS8
rat_no_VS8	asr.w	#1,d7		; HStart bit 8-1
		bcc.b	rat_no_HS0	; il bit 0 h-start non e' settato
		addq.w	#1,d0		; set HS0
rat_no_HS0	move.b	d7,d6		; SPR CTRL word 1 <= D6
		swap	d6
		or.l	d6,d0		; FIX SPRCTRL 1 in D0
		asl.w	#8,d5		; shift 8
		bcc.b	rat_no_VSt8	; il bit 8 vert-stop non e' settato
		addq.w	#2,d0		; set VStop8
rat_no_VSt8	or.w	d5,d0		; SPR CTRL word 2 <= D0
		move.l	d0,(a0)
;		bset	#7,d0		; SET ATTACHMENT
;		move.l	d0,spr_size(a0)
rat_END		rts


bar_h		= 40
bar_w		= 704
bar_bpl		= 4
bar_size	= scr_bytes*bar_h
bar_y		= scr_y+scr_h-bar_h


spr_h		= 16			; POINTER constants
spr_w		= 16
spr_size	= spr_h*4+8

rat_bar_data	dc.w	0	; old pos
		dc.w	0,0	; y , x
		dc.w    bar_h-1,bar_w/2-1,bar_y,scr_x-9
		;	 h box ,  w box  /  y   ,  x   offsets

