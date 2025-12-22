
; Listing18r5.s = vec_3d_filled_3col_cb.s
	
	;example of a 8 colour, lighsourced, copper blitting vector
	;written by shagratt/LSD
	;
	;a technique of drawing & filling the vector object with the
	;copperlist, this means never waiting for the blitter, so no
	;processor time wasted!

 	Section Copperlist,code_C

;	opt	c-,o+,w-
;	opt	d+

scale	= 200
bgc	= $dff1fe

cb_wait	MACRO

	move.w	#$180,(a6)+
	move.w	a6,(a6)+

	move.w	#$0021,(a6)+
	move.w	#$00fe,(a6)+

	ENDM

cb_move	MACRO
	move.w	\1,(a6)+
	move.w	\2,(a6)+
	ENDM
	
cb_end	MACRO

	move.w	#$180,(a6)+
	move.w	#$000,(a6)+

	move.w	#$ffff,(a6)+
	move.w	#$fffe,(a6)+
	ENDM
	
	


	rsreset	
obj_ptr_connect	rs.l	1
obj_ptr_points	rs.l	1
obj_ptr_surface	rs.l	1
obj_no_points	rs.w	1
obj_no_connects	rs.w	1
obj_no_surfaces	rs.w	1
obj_Arot		rs.w	1
obj_Brot		rs.w	1
obj_Crot		rs.w	1
obj_Xpos		rs.w	1
obj_Ypos		rs.w	1
obj_Zpos		rs.w	1
obj_depth		rs.w	1
obj_x		rs.w	1
obj_y		rs.w	1
obj_buffer		rs.l	1

start:	lea	$dff000,a5		; hardware base address

	Move.w	$1c(a5),OldInt	; Save Old Interupts
	Move.w	$02(a5),OldDma	; Save Old DMA

	Move.w	#$7fff,$9a(a5)	; Clear DMA
	Move.w	#$7fff,$96(a5)	; Clear Interupts
	Move.w	#$7fff,$9c(a5)	; Clear Interupt Requests
	
	Move.b	#$7f,$bfed01	; kill timers (rem me for disk)
	Move.l	$6c.w,OldV3		; save level 3 int

	Move.l	#my_level3,$6c.w	; put new copper interupt
	Move.l	#my_copper,$80(a5) 	; Address of copper 1
	Move.l	#dead_cop2,$84(a5) 	; Address of copper 1
	Move.w	#$c020,$9a(a5)	; Start interupts
	Move.w	#$02,$2e(a5)	; copper danger on

	Move.w	#$83ef,$96(a5)	; Start DMA ( 83ff for disk dma)
	Move.w	#1,$88(a5)		; Strobe for copper start
	move.w	#0,$1fc(a5)	; no aga
	
.wait	btst	#6,$bfe001
	bne	.wait
	
	************** res tore sys ***************

	lea	$dff000,a5		; hardware base address
	Move.w	#$0000,$2e(a5)	; copper danger off
	move.l	#0,$80(a5)		; blank copper list
	move.l	#0,$84(a5)		; if gfx lib not open (slayer boot)
	move.w	#0,$180(a5)		; bgc to black
	
	Move.l	OldV3,$6c.w		; restore old l3
	
	Lea	GfxLib,a1		; Pointer to Library Text
	move.l	4.w,a6
	jsr	-132(a6)		; forbid
	Move.l	4.w,a6		; Exec
	Moveq.l	#0,d0		; Clear D0
	Jsr	-$228(a6)		; Open Library
	cmp.l	#0,d0
	beq	no_gfx_lib		; if gfx lib not open dont restore copper lib (slayer boot)
	
	Move.l	d0,a1			
	Move.l	$26(a1),$80(a5)	; restore copper 1
	Move.l	$32(a1),$84(a5)	; restore copper 2
no_gfx_lib:

	Move.w	OldInt,d0		; start old interupts
	Or.w	#$8000,d0
	Move.w	d0,$9a(a5)
	Move.w	OldDma,d0		; start old DMA
	Or.w	#$8000,d0
	Move.w	d0,$96(a5)
	Move.b	#$9b,$bfed01	; Start Timers
	Move.l	4.w,a6		; Close Gfx lib
	Jsr	-$19e(a6)
	move.l	4.w,a6
	jsr	-138(a6)		; permit

	move.w	#0,$bfec00		; clear kbd

	Moveq.l	#0,d0		; No errors
	Rts			; Exit

Error:	moveq	#0,d0			; fin
	rts

keys:	btst	#6,$bfe001
	bne.s	keys
	rts

	**********************************




	**********************************

my_level3:	Movem.l	d0-d7/a0-a6,-(a7)	; New copper
	Move.w	#$20,$dff09c	; Serviced Interupt

	move.w	#$400,$dff180

	bsr	filled_vectors

	move.w	#$444,$dff180

	move.l	screen1,d0
	move.l	screen2,screen1
	move.l	screen3,screen2
	move.l	d0,screen3

	move.l	Screen1,d0			; store address of bitplane0
	move.w	d0,bitplane0_lo		; into the copper list
	swap	d0
	move.w	d0,bitplane0_hi
	swap	d0
	add.l	#40*256,d0
	move.w	d0,bitplane1_lo		; into the copper list
	swap	d0
	move.w	d0,bitplane1_hi

	btst	#2,$dff016
	beq	.skip

	lea	cube_3d_1,a3
	
	add.w	#4,obj_brot(a3)
	and.w	#$1fe,obj_brot(a3)

	;cmp.w	#188,obj_ypos(a3)
	;beq	.skip
	;add.w	#2,obj_ypos(a3)
.skip
Exit:	Movem.l	(a7)+,d0-d7/a0-a6
	Rte			; Return from Interupt

	**********************************

filled_vectors:
	move.l	copper_blit_ptr+0,a6

	; clear screen with copper bliting

	cb_wait
		
	move.l	#scrbuf1+4,d0
	cb_move	#$42,#$0000
	cb_move	#$40,#$01f0
	cb_move	#$56,d0
	swap	d0
	cb_move	#$54,d0
	cb_move	#$74,#$0000
	cb_move	#$66,#40-16*2
	cb_move	#$58,#512*64+16
	cb_wait

	move.l	a6,-(a7)	
	lea	cube_3d_1,a3
	bsr	scale_3d
	move.l	(a7)+,a6

	lea	cube_3d_1,a3
	bsr	plot_2d_object
	
	bsr	fill_screen
	
	cb_end

	move.l	copper_blit_ptr+0,d0
	move.l	copper_blit_ptr+4,copper_blit_ptr+0
	move.l	d0,copper_blit_ptr+4

	move.l	d0,$dff084

	rts
	
	*************************************
fill_screen:
	move.l	#scrbuf1,d0
	move.l	screen1,d1
	add.l	#512*40-6,d0
	add.l	#512*40-6,d1

	cb_move	#$40,#$09f0
	cb_move	#$42,#$0012
	cb_move	#$64,#40-16*2
	cb_move	#$66,#40-16*2
	cb_move	#$52,d0
	swap	d0
	cb_move	#$50,d0
	cb_move	#$56,d1
	swap	d1
	cb_move	#$54,d1
	cb_move	#$58,#512*64+16
	
	cb_wait
	
	rts


	*************************************

scale_3d:	lea	sintable+64,a1	

	movem.l	 0(a3),a4/a5	; connect, co-ords
	move.w	12(a3),d7		; no of points-1
	move.l	36(a3),a6
.loop	

	**** rotate object *****

	movem.w	(a5)+,d0-d1		; get obj x,y
	Move	d0,d2
	Move	d1,d3

	Move	22(a3),d6		; c rot
	Move	 64(a1,d6),d4	; sine
	Move	-64(a1,d6),d5	; cosine
	Muls	d4,d0
	Muls	d5,d1
	Sub.l	d1,d0
	Add.l	d0,d0
	Swap	d0		;d0 holds intermediate x coord
	Muls	d5,d2
	Muls	d4,d3
	Add.l	d3,d2
	Add.l	d2,d2
	Swap	d2		;d2 holds intermediate y coord
	Move	d2,d4

	Move	(a5)+,d1		;z coord
	Move	d1,d3
	Move	18(a3),d6		; a rot
	Move	 64(a1,d6),d5	; sine
	Move	-64(a1,d6),d6	; cosine
	Muls	d5,d2
	Muls	d6,d1
	Sub.l	d1,d2
	Add.l	d2,d2
	Swap	d2		;d2 holds the final y coord
	Muls	d5,d3
	Muls	d6,d4
	Add.l	d4,d3
	Add.l	d3,d3
	Swap	d3		;d3 holds intermediate z coord

	Move	d0,d1
	Move	d3,d4
	Move	20(a3),d6		; b rot
	Move	 64(a1,d6),d5	; sine
	Move	-64(a1,d6),d6	; cosine
	Muls	d5,d3
	Muls	d6,d0
	Sub.l	d0,d3
	Add.l	d3,d3
	Swap	d3		;d3 holds the final z coord
	Muls	d6,d4
	Muls	d5,d1
	Add.l	d4,d1
	Add.l	d1,d1
	Swap	d1		;d1 holds the final x coord


	**** scale object ****

	move.w	d3,d5
	move.w	d2,d4
	move.w	d1,d3

	add.w	24(a3),d3		; x
	add.w	26(a3),d4		; y
	add.w	28(a3),d5		; z
 
 	add.w	30(a3),d5		; depth
	add.w	#scale,d5
	move.l	#scale<<16,d6
	
	divu	d5,d6

	*** calc x 2d point **

	muls	d6,d3
	add.l	d3,d3
	swap	d3
	
	*** calc y 2d point **

	muls	d6,d4
	add.l	d4,d4
	swap	d4

	*** centre of screen **

	add.w	32(a3),d3
	add.w	34(a3),d4

	movem.w	d3-d4,(a6)
	lea	4(a6),a6

	dbf	d7,.loop

	move.w	14(a3),d7		; no of lines -1

	rts

	*************************************

plot_2d_object:
 	
	moveq.l	#40,d5		; screen width
	bsr	LinePrep

	move.l	36(a3),a1		;get address of coord-storage area

	move.l	0(a3),a2		; connect list
	move.l	8(a3),a5		; surface list

	move.w	16(a3),no_of_surf	;get number of surfaces on vector

.next_surf	move.l	00(a5),d7		;get number of sides to surface
	move.l	04(a5),a4		;get address of surface list
	move.l	12(a5),multiplane	;is face on more that one plane
	move.l	16(a5),a0		; get address of col register

	;calculate if surface visible

	move.w	0(a4),d6		; get point on surface
	move.w	0(a2,d6),d4		; get connect for point
	move.w	2(a2,d6),d5		; get next connect for point
	move.w	0(a1,d4),d0		; get x screen co-ord for contect
	sub.w	0(a1,d5),d0		; sub y screen co-ord for contect
	move.w	2(a1,d4),d1		; get x screen co-ord for contect
	sub.w	2(a1,d5),d1		; sub y screen co-ord for contect
	move.w	2(a4),d6		; get next point on surface

	move.w	0(a2,d6),d4		; get connect for point
	move.w	2(a2,d6),d5		; get next connect for point
	
	move.w	0(a1,d4),d2		; get x screen co-ord for contect
	sub.w	0(a1,d5),d2		; sub y screen co-ord for contect
	move.w	2(a1,d4),d3		; get x screen co-ord for contect
	sub.w	2(a1,d5),d3		; sub y screen co-ord for contect
	muls	d3,d0		; multi (y-x) co-ord surface connect 2 by (y-x) co-ord surface connect 1
	muls	d2,d1		; multi (y-x) co-ord surface connect 2 by (y-x) co-ord surface connect 1
	sub.w	d0,d1
	cmp.w	#0,d1
	bpl	.dont_draw
	
	lsr.w	#8,d1		; div 512
	lsr.w	#3,d1		; div 8
	and.w	#$f,d1		; keep 0-15
	move.w	d1,d0
	asl.w	#4,d0
	or.w	d0,d1
	asl.w	#4,d0
	or.w	d0,d1
	move.w	d1,2(a0)		; store ls value
	
	move.l	08(a5),a0		;get address of screen memory
	
.loop	move.w	(a4)+,d5
	move.w	0(a2,d5),d6		; 1st connect
	movem.w	(a1,d6),d0-d1	; get x1,y1
	move.w	2(a2,d5),d6		; 2nd connect
	movem.w	(a1,d6),d2-d3	; get x2,y2
	
	cmp.w	d1,d3
	bgt.s	.Draw
	exg	d0,d2
	exg	d1,d3
	beq	.NoDraw

.Draw	tst.l	multiplane
	beq	.normaldraw

	movem.l	d0-d7/a0-a5,-(a7)
	moveq.l	#40,d5		; screen width
	lea	scrbuf1,a0
	lea	filshift,a3		; pre-calc line-shift table
	lea	llength,a5		; pre-calc line-length table
	Bsr	ClipLineDraw
	movem.l	(a7)+,d0-d7/a0-a5

	movem.l	d0-d7/a0-a5,-(a7)
	moveq.l	#40,d5		; screen width
	lea	scrbuf1+40*256,a0
	lea	filshift,a3		; pre-calc line-shift table
	lea	llength,a5		; pre-calc line-length table
	Bsr	ClipLineDraw
	movem.l	(a7)+,d0-d7/a0-a5

	bra	.nodraw

.normaldraw	movem.l	d0-d7/a0-a5,-(a7)
	moveq.l	#40,d5		; screen width
	lea	filshift,a3		; pre-calc line-shift table
	lea	llength,a5		; pre-calc line-length table
	Bsr	ClipLineDraw
	movem.l	(a7)+,d0-d7/a0-a5

.Nodraw	dbf	d7,.loop

.dont_draw	lea	20(a5),a5		; next surface
	sub.w	#1,no_of_surf
	bpl	.next_surf

	rts
	
	*************************************

ClipLineDraw:
	cmp.w	#255,d1
	bgt	.clip1
	cmp.w	#255,d3
	bgt	.clip2
	
	bra	LineDraw
	
.clip1	move.w	#255,d1
	bra	LineDraw
	
.clip2	move.w	#255,d3
	bra	LineDraw
	
	*************************************

	
LineDrawNeeds	MACRO

FilShift:	incbin	"LineDrawStuff1.Bin"
LLength:	incbin	"LineDrawStuff2.Bin"

		ENDM

lineprep:	*** setup blitter for line draw ***
	
	cb_move	#$40,#$0000
	cb_move	#$42,#$0000
	cb_move	#$44,#-1
	cb_move	#$46,#-1
	cb_move	#$50,#0
	cb_move	#$52,#0
	cb_move	#$60,d5
	cb_move	#$72,#$ffff
	cb_move	#$74,#$8000
	
	rts

	********************************************
	** FILLED LINEDRAW ROUTINE                **
	**			      **
	** PRELOAD :		      **
	** $DFF060=SCREENWIDTH (WORD)	      **
	** $DFF072=-$8000 (LONGWORD)	      **
	** $DFF044=-1 (LONGWORD)	      **
	**			      **
	** INPUT :			      **
	** D0=X1 D1=Y1 D2=X2 D3=Y2                **
	** A0=SCREEN ADDRESS                      **
	** A3=X-SHIFT TABLE		      **
	** A5=LINE-SIZE TABLE		      **
	********************************************

LineDraw:	movem.w	d0/d1/d2/d3/d5,-(a7)	;store coord registers
	move.w	d1,d4
	muls	d5,d4
	move.w	d0,d5
	add.l	a0,d4
	asr.w	#3,d5
	ext.l	d5		; bug fixed by me,
	add.l	d5,d4		; was adding word to long!
	moveq	#0,d5
	sub.w	d1,d3
	sub.w	d0,d2
	bpl.s	.line2
	moveq	#1,d5
	neg.w	d2
.line2	move.w	d3,d1
	add.w	d1,d1
	cmp.w	d2,d1
	dbhi	d3,.line3
.line3	move.w	d3,d1
	sub.w	d2,d1
	bpl.s	.line4
	exg	d2,d3
.line4	addx.w	d5,d5
	add.w	d2,d2
	move.w	d2,d1
	sub.w	d3,d2
	addx.w	d5,d5
	add.w	d0,d0

	cb_move	#$52,d2
	;move.w	d2,$52(a6)		; a source
	sub.w	d3,d2
	add.w	d3,d3
	
	move.w	(a3,d0),d7
	cb_move	#$40,d7
	;move.w	(a3,d0),$40(a6)	; blitcon0
	
	moveq	#0,d7
	move.b	oct(PC,d5.w),d7
	cb_move	#$42,d7
	
	;move.b	oct(PC,d5.w),$43(a6)	; blitcon1
	cb_move	#$4a,d4
	cb_move	#$56,d4
	swap	d4
	cb_move	#$48,d4
	cb_move	#$54,d4
	;move.l	d4,$48(a6)		; c source
	;move.l	d4,$54(a6)		; d dest
	
	cb_move	#$62,d1
	cb_move	#$64,d2
	;movem.w	d1/d2,$62(a6)	; b mod & a mod
	
	move.w	(a5,d3),d7
	cb_move	#$58,d7
	;move.w	(a5,d3),$58(a6)	; size

	cb_wait 

	movem.w	(a7)+,d0/d1/d2/d3/d5	;restore coords
	rts
	
oct:	dc.l	$3431353,$b4b1757

	*************************************




	Section	copdat,Data_c

oldint:		dc.l	0
olddma:		dc.l	0
oldv3:		dc.l	0
gfxlib:		dc.b	"graphics.library",0
		even

my_copper:		dc.w	$100,$2200		; 4 bp - lores - 
		dc.w	$102,$00		; hsr
		dc.w	$104,0		; bp control reg
		dc.w	$108,0		; bp modulo - odd
		dc.w	$10a,0		; bp modulo - even
		dc.w	$180,0		; colour 0 to black
		dc.w	$1fc,0
				
		dc.w	$120,0,$122,0
		dc.w	$124,0,$126,0
		dc.w	$128,0,$12a,0
		dc.w	$12c,0,$12e,0		
		dc.w	$130,0,$132,0
		dc.w	$134,0,$136,0
		dc.w	$138,0,$13a,0
		dc.w	$13c,0,$13e,0
		
		dc.w	$092,$38	; bp start horz
		dc.w	$094,$d0	; bp stop horz
		dc.w	$08e,$2c8c	; bp window start left
		dc.w	$090,$2ae3	; bp window bot right
		
cmap:		dc.w	$180,0
ls_col1:		dc.w	$182,$fff
ls_col2:		dc.w	$184,$fff
ls_col3:		dc.w	$186,$fff
		
		dc.w	  $e0
bitplane0_hi:	dc.w	0,$e2
bitplane0_lo:	dc.w	0,$e4
bitplane1_hi:	dc.w	0,$e6
bitplane1_lo:	dc.w	0
			
		dc.w	$0101,$ff00	; end of pal screen
		
		;dc.w	$9c,$8010		
		dc.w	$8a,$0	; strobe copper 2
		dc.w	$ffff,$fffe	; end of copper list



dead_cop2:		dc.w	$0001,$7ffe	; wait for xpos 1,and the blitter
		dc.w	$ffff,$fffe	; end of copper list

screen1:		dc.l	screena
screen2:		dc.l	screenb
screen3:		dc.l	screenc

***********************************************************************

	section	stuff,data
	
copper_blit_ptr:	dc.l	copper_blit_spc1
		dc.l	copper_blit_spc2
		

no_of_surf:	dc.l	0
multiplane:	dc.l	0

cube_3d_1:	dc.l	cube_connect
	dc.l	cube_points
	dc.l	cube_surfaces
	dc.w	8-1		; points
	dc.w	0		; connects
	dc.w	6-1		; surfaces
	Dc.w	204	; a
	Dc.w	0	; b
	Dc.w	204	; c
	Dc.w	0	; x
	Dc.w	0	; y
	Dc.w	0	; z
	dc.w	500	; depth
	dc.w	160	; scrn x
	dc.w	128	; scrn y
	dc.l	cube_buff	; buffer

cube_points:	Dc.w	+100,+100,+100
		Dc.w	-100,+100,+100
		Dc.w	-100,-100,+100
		Dc.w	+100,-100,+100
		Dc.w	+100,+100,-100
		Dc.w	-100,+100,-100
		Dc.w	-100,-100,-100
		Dc.w	+100,-100,-100

cube_connect:	Dc.w	0*4,1*4
		Dc.w	1*4,2*4
		Dc.w	2*4,3*4
		Dc.w	3*4,0*4
		Dc.w	4*4,5*4
		Dc.w	5*4,6*4
		Dc.w	6*4,7*4
		Dc.w	7*4,4*4
		Dc.w	0*4,4*4
		Dc.w	1*4,5*4
		Dc.w	2*4,6*4
		Dc.w	3*4,7*4

cube_surfaces:	dc.l	4-1,cube_s1,scrbuf1+256*40,0,ls_col1
		dc.l	4-1,cube_s2,scrbuf1,1,ls_col2
		dc.l	4-1,cube_s3,scrbuf1,0,ls_col3
		dc.l	4-1,cube_s4,scrbuf1,1,ls_col2
		dc.l	4-1,cube_s5,scrbuf1,0,ls_col3
		dc.l	4-1,cube_s6,scrbuf1+256*40,0,ls_col1

cube_s1:		dc.w	4*4,05*4,6*4,7*4	;which connecting lines form to make a surface
cube_s2:		dc.w	3*4,11*4,7*4,8*4
cube_s3:		dc.w	0*4,09*4,4*4,8*4
cube_s4:		dc.w	1*4,09*4,5*4,10*4
cube_s5:		dc.w	2*4,10*4,6*4,11*4
cube_s6:		dc.w	3*4,02*4,1*4,0*4


cube_buff:		dcb.l	10*50,0
cube_buff2:		dcb.l	10*50,0

	;incdir	"dh0:data/misc/"

Sintable:	
	incbin	"sin.maxi"
	incbin	"sin.maxi"

	LineDrawNeeds

	section	small,bss_c
	
copper_blit_spc1:	ds.l	100*32
copper_blit_spc2:	ds.l	100*32

screena:		ds.l	10*512
screenb:		ds.l	10*512
screenc:		ds.l	10*512
scrbuf1:		ds.l	10*512

	end

