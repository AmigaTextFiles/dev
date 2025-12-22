
; Listing18s3.s = vec_3d_filled_glenz.s

	;example of a Glenz vector, this routine is boring.....
	

 	Section Copperlist,code_C

;	opt	c-,o+,w-
;	opt	d+

scale	= 200
bgc	= $dff1fe
killsys	= 1

	include	"object.i"

Start:	lea	$dff000,a5		; hardware base address

	Move.w	$1c(a5),OldInt	; Save Old Interupts
	Move.w	$02(a5),OldDma	; Save Old DMA

	Move.w	#$7fff,$9a(a5)	; Clear DMA
	Move.w	#$7fff,$96(a5)	; Clear Interupts
	Move.w	#$7fff,$9c(a5)	; Clear Interupt Requests
	
	Move.b	#$7f,$bfed01	; kill timers (rem me for disk)
	Move.l	$6c.w,OldV3		; save level 3 int

	Move.l	#my_level3,$6c.w	; put new copper interupt
	Move.l	#my_copper,$80(a5) 	; Address of copper 1
	Move.w	#$c010,$9a(a5)	; Start interupts

	Move.w	#$83ef,$96(a5)	; Start DMA ( 83ff for disk dma)
	Move.w	#1,$88(a5)		; Strobe for copper start
	move.w	#0,$1fc(a5)

.wait	move.l	$dff004,d0
	and.l	#$1ff00,d0
	cmp.l	#$ff00,d0
	bne.s	.wait
	
	move.l	Screen1,d0			; store address of bitplane0
	move.w	d0,bitplane0_lo		; into the copper list
	swap	d0
	move.w	d0,bitplane0_hi
	swap	d0
	add.l	#40*256,d0
	move.w	d0,bitplane1_lo		; into the copper list
	swap	d0
	move.w	d0,bitplane1_hi
	swap	d0
	add.l	#40*256,d0
	move.w	d0,bitplane2_lo		; into the copper list
	swap	d0
	move.w	d0,bitplane2_hi

	move.l	screen1,d0
	move.l	screen2,screen1
	move.l	d0,screen2

	bsr	filled_vectors

	btst	#2,$dff016
	beq	.skip

	lea	cube_3d_1,a3
	add.w	#4,obj_arot(a3)
	and.w	#$1fe,obj_arot(a3)
	add.w	#2,obj_brot(a3)
	and.w	#$1fe,obj_brot(a3)
	add.w	#4,obj_crot(a3)
	and.w	#$1fe,obj_crot(a3)

.skip	btst	#6,$bfe001
	bne	.wait


	lea	$dff000,a5		; hardware base address
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

	*****************************************************
	
my_level3:	Movem.l	d0-d7/a0-a6,-(a7)	; New copper
	Move.w	#$10,$dff09c	; Serviced Interupt

Exit:	Movem.l	(a7)+,d0-d7/a0-a6
	Rte			; Return from Interupt

	*****************************************************

wait_blit:	
.loop	Btst	#6,$dff002
	Bne.s	.loop
	
	rts


filled_vectors:
	Move.l	#scrbuf1,a0
	Lea	$dff000,a6

	bsr	wait_blit
	
	move.w	#$f00,bgc		; start cls
				; and convert 3d			; co-ords to 2d
	Move.l	#$1f00000,$dff040
	Move.l	#scrbuf1+4,$dff054
	move.l	#0,$dff074
	move.w	#8,$dff066
	Move.w	#768*64+16,$dff058
	
	lea	cube_3d_1,a3
	bsr	scale_3d

	move.w	#$888,bgc		; calc which surfaces
				; need to be hidden
	bsr	hide_lines

	move.w	#$fff,bgc		; wait for blitter

	bsr	wait_blit

	move.w	#$00f,bgc		; draw lines

	lea	cube_3d_1,a3
	bsr	plot_2d_object
	
	move.w	#$800,bgc		; start fill
	
	bsr	fill_screen
	
	move.w	#$444,bgc		; finished
					; but blitter
.wait3	Btst	#6,$dff002
	Bne.s	.wait3

	move.w	#$000,bgc		; finished

	Rts

	*************************************
fill_screen:
	lea	$dff000,a6

	lea	scrbuf1,a0
	move.l	screen1,a1
	add.l	#768*40-6,a0
	add.l	#768*40-6,a1

	bsr	wait_blit

	move.l	#$09f00012,$40(a6)	;set copy/fill/descending mode				;descending mode needed for filling
	move.w	#8,$64(a6)
	move.w	#8,$66(a6)
	move.l	a0,$50(a6)		;vectorplane address
	move.l	a1,$54(a6)		;bitplane address
	move.w	#768*64+16,$58(a6)	;set bltsize

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
 	
 	bsr	wait_blit

	*** setup blitter for line draw ***
	
	move.l	#0,$dff040		; clr blitcon0,blitcon1
	Move.l	#-1,$dff044		; fwm, lwm
	move.l	#0,$dff050		; a source
	Move.w	#40,$dff060		; modo
	Move.l	#$ffff8000,$dff072	; line draw fn
	
	move.l	36(a3),a1		;get coord buffer
	move.l	40(a3),a5		;get surface buffer

	move.l	0(a3),a2		; connect list
	move.l	8(a3),a6		; surface list

	move.w	16(a3),no_of_surf	;get number of surfaces on vector

.next_surf	move.l	(a6)+,d7		;get number of sides to surface
	move.l	(a6)+,a4		;get address of surface list
	move.l	(a6)+,a0		;get address of screen memory
	move.l	(a6)+,multiplane	;is face on more that one plane

	; check if surface visible

	move.l	(a5)+,d0
	move.l	d0,d6
	and.l	#$f0000000,d6
	beq	.glenz
	and.l	#$0fffffff,d0

	cmp.l	#scrbuf1+256*40,a0
	bgt	.dont_draw
	
	lea	256*40(a0),a0
	
.glenz	move.l	d0,a4
	
.loop	move.w	(a4)+,d5
	move.w	0(a2,d5),d6		; 1st connect
	movem.w	(a1,d6),d0-d1	; get x1,y1
	move.w	2(a2,d5),d6		; 2nd connect
	movem.w	(a1,d6),d2-d3	; get x2,y2

	cmp.w	d1,d3
	bgt.s	.NormalDraw
	exg	d0,d2
	exg	d1,d3
	beq	.NoDraw

.NormalDraw	movem.l	d0-d7/a0-a6,-(a7)
	move.w	#40,d5		; screen width
	Lea	$dff000,a6
	lea	filshift,a3		; pre-calc line-shift table
	lea	llength,a5		; pre-calc line-length table
	Bsr	LineDraw
	movem.l	(a7)+,d0-d7/a0-a6

.Nodraw	dbf	d7,.loop

.dont_draw	sub.w	#1,no_of_surf
	bpl	.next_surf

	rts

	*************************************************
	
hide_lines:
	move.l	36(a3),a1		;get coord-storage area
	move.l	40(a3),a5		;get surface draw buffer

	move.l	0(a3),a2		; connect list
	move.l	8(a3),a6		; surface list

	move.w	16(a3),no_of_surf	;get number of surfaces on vector

.next_surf	move.l	(a6)+,d7		;get number of sides to surface
	move.l	(a6)+,a4		;get address of surface list
	move.l	(a6)+,a0		;get address of screen memory
	move.l	(a6)+,multiplane	;is face on more that one plane

	;calculate if surface visible

	move.l	a4,(a5)

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
	cmp.w	d0,d1	
	bpl	.dont_draw
	
	move.l	a4,(a5)
	or.l	#$f0000000,(a5)
	
.dont_draw	lea	4(a5),a5
	sub.w	#1,no_of_surf
	bpl	.next_surf

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
	add.l	d5,d4		; was .w, bug fixed
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

.wait	Btst	#6,$dff002
	Bne.s	.wait

	move.w	d2,$52(a6)		; a source
	sub.w	d3,d2
	add.w	d3,d3
	move.w	(a3,d0),$40(a6)	; blitcon0
	move.b	oct(PC,d5.w),$43(a6)	; blitcon1
	move.l	d4,$48(a6)		; c source
	move.l	d4,$54(a6)		; d dest
	movem.w	d1/d2,$62(a6)	; b mod & a mod
	move.w	(a5,d3),$58(a6)	; size

	movem.w	(a7)+,d0/d1/d2/d3/d5	;restore coords
	rts
	
oct:	dc.l	$3431353,$b4b1757

********************************************
** SECOND LINE-DRAWER ROUTINE WHEN BOTH   **
** PLANES NEEDED FOR SURFACE              **
********************************************

linedraw2:	move.w	d1,d4
	muls	d5,d4
	move.w	d0,d5
	add.l	a0,d4
	asr.w	#3,d5
	add.w	d5,d4
	moveq	#0,d5
	sub.w	d1,d3
	sub.w	d0,d2
	bpl.s	line5
	moveq	#1,d5
	neg.w	d2
line5	move.w	d3,d1
	add.w	d1,d1
	cmp.w	d2,d1
	dbhi	d3,line6
line6	move.w	d3,d1
	sub.w	d2,d1
	bpl.s	line7
	exg	d2,d3
line7	addx.w	d5,d5
	add.w	d2,d2
	move.w	d2,d1
	sub.w	d3,d2
	addx.w	d5,d5
	add.w	d0,d0

.wait	Btst	#6,$dff002
	Bne.s	.wait

	move.w	d2,$52(a6)
	sub.w	d3,d2
	add.w	d3,d3
	move.w	(a3,d0),$40(a6)
	move.b	oct(PC,d5.w),$43(a6)
	move.l	d4,$48(a6)
	move.l	d4,$54(a6)
	movem.w	d1/d2,$62(a6)
	move.w	(a5,d3),$58(a6)
	rts


	*************************************




	Section	copdat,Data_c

oldint:	dc.l	0
olddma:	dc.l	0
oldv3:	dc.l	0

my_copper:		dc.w	$100,$3200		; 4 bp - lores - 
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
		dc.w	$182,$f88
		dc.w	$184,$f44
		dc.w	$186,$f00
		dc.w	$188,$4f4
		dc.w	$18a,$8f8
		dc.w	$18c,$cfc
		dc.w	$18e,$fff
		
		dc.w	  $e0
bitplane0_hi:	dc.w	0,$e2
bitplane0_lo:	dc.w	0,$e4
bitplane1_hi:	dc.w	0,$e6
bitplane1_lo:	dc.w	0,$e8
bitplane2_hi:	dc.w	0,$ea
bitplane2_lo:	dc.w	0

		dc.w	$0101,$fffe
		dc.w	$9c,$8010	; irq set bits - ?
		dc.w	$ffff,$fffe	; end of copper list
	
gfxlib:		dc.b	"graphics.library",0
		even

screen1:		dc.l	screena
screen2:		dc.l	screenb

***********************************************************************

	section	stuff,data


a set 0
filshift
		REPT	320
		dc.w	((a&$f)*$1000)+$a4a
a set a+1
		endr
a set 0
llength				;table for line length vals
		REPT	320
		dc.w	a*64+2
a set a+1
		ENDR


no_of_surf:	dc.l	0
multiplane:	dc.l	0

cube_3d_1:	dc.l	cube_connect
	dc.l	cube_points
	dc.l	cube_surfaces
	dc.w	8-1		; points
	dc.w	12-1		; connects
	dc.w	12-1		; surfaces
	Dc.w	$1ac	; a
	Dc.w	$e0	; b
	Dc.w	$1b6	; c
	Dc.w	0	; x
	Dc.w	0	; y
	Dc.w	0	; z
	dc.w	380	; depth
	dc.w	160	; scrn x
	dc.w	128	; scrn y
	dc.l	cube_buff	; buffer for x,y co-ords
	dc.l	conn_buff	; buffer for connects

cube_points:	Dc.w	+100,+100,+100
		Dc.w	-100,+100,+100
		Dc.w	-100,-100,+100
		Dc.w	+100,-100,+100		
		Dc.w	+100,+100,-100
		Dc.w	-100,+100,-100
		Dc.w	-100,-100,-100
		Dc.w	+100,-100,-100
		
cube_connect:	Dc.w	0*4,1*4 ; 0
		Dc.w	1*4,2*4 ; 1
		Dc.w	2*4,3*4 ; 2
		Dc.w	3*4,0*4 ; 3
		
		Dc.w	4*4,5*4 ; 4	
		Dc.w	5*4,6*4 ; 5
		Dc.w	6*4,7*4 ; 6
		Dc.w	7*4,4*4 ; 7
		
		Dc.w	0*4,4*4 ; 8
		Dc.w	1*4,5*4 ; 9
		Dc.w	2*4,6*4 ; 10
		Dc.w	3*4,7*4 ; 11

		dc.w	05*4,07*4 ; 12
		dc.w	06*4,04*4 ; 13

		dc.w	07*4,00*4 ; 14
		dc.w	03*4,04*4 ; 15

		dc.w	00*4,05*4 ; 16
		dc.w	04*4,01*4 ; 17

		dc.w	01*4,06*4 ; 18
		dc.w	02*4,05*4 ; 19

		dc.w	02*4,07*4 ; 20
		dc.w	03*4,06*4 ; 21
		
		dc.w	02*4,00*4 ; 22
		dc.w	03*4,01*4 ; 23

cube_s1:		dc.w	04*4,12*4,06*4,13*4 ;which connect lines form to make a surface
cube_s2:		dc.w	14*4,11*4,15*4,08*4
cube_s3:		dc.w	16*4,09*4,17*4,08*4
cube_s4:		dc.w	18*4,09*4,19*4,10*4
cube_s5:		dc.w	02*4,20*4,06*4,21*4
cube_s6:		dc.w	03*4,22*4,01*4,23*4

cube_s7:		dc.w	04*4,05*4,06*4,07*4	;which connecting lines form to make a surface
cube_s8:		dc.w	03*4,11*4,07*4,08*4
cube_s9:		dc.w	00*4,09*4,04*4,08*4
cube_s10:		dc.w	01*4,09*4,05*4,10*4
cube_s11:		dc.w	02*4,10*4,06*4,11*4
cube_s12:		dc.w	03*4,02*4,01*4,00*4


cube_surfaces:	dc.l	4-1,cube_s1,scrbuf1,0
		dc.l	4-1,cube_s2,scrbuf1,0
		dc.l	4-1,cube_s3,scrbuf1,0
		dc.l	4-1,cube_s4,scrbuf1,0
		dc.l	4-1,cube_s5,scrbuf1,0
		dc.l	4-1,cube_s6,scrbuf1,0
		dc.l	4-1,cube_s7,scrbuf1+256*40,0
		dc.l	4-1,cube_s8,scrbuf1+256*40,0
		dc.l	4-1,cube_s9,scrbuf1+256*40,0
		dc.l	4-1,cube_s10,scrbuf1+256*40,0
		dc.l	4-1,cube_s11,scrbuf1+256*40,0
		dc.l	4-1,cube_s12,scrbuf1+256*40,0
	

cube_buff:		ds.l	10*50
conn_buff:		ds.l	10*5

Sintable:	incbin	"sin.maxi"
	incbin	"sin.maxi"

	section	small,bss_c
	
scrbuf1:		ds.l	10*768
screena:		ds.l	10*768
screenb:		ds.l	10*768


	end
	

