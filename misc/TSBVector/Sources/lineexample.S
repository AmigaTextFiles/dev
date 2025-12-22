*******************************************************
***   Line Vector example for TSB's Vectordesigner  ***
***   --------------------------------------------  ***
***                                                 ***
***               written by ALLOC                  ***
***                                                 ***
*******************************************************
;---------------------------------------
; a  (return)
;(return)
; y  (return)
; jm (return)

>extern	"df0:readyobjects/lineship.l",lineobject
org	$30000
load	$30000

clear: 	MACRO
	lea	$dff000,a5
	move.l	?1,$54(a5)
	move.w	?2,d0       ;x
	move.w	?3,d1       ;y
	move.w	#$0,$66(a5)
	move.w	#%0000000100000000,$40(a5)
	move.w	#0,$42(a5)
	lsl.w	#6,d1
	or.w	d1,d0
	move.w	d0,$58(a5)
	ENDM


m:
	
 		lea	$dff000,a5
		movem.l	d0-d7/a0-a6,-(a7)
		moveq	#61,d0
		lea	zero,a0
		lea	8,a1
copyzero:	move.l	(a1)+,(a0)+
		dbf	d0,copyzero
		move.l	#raus,$020
raus:		move.w	#$2700,sr
		adda	#6,a7
		move.l	a7,sstack
		move.l	#stackend,a7
		move.w	$1c(a5),intbuff
		move.w	#$7fff,$9a(a5)
		move.w	#$7fff,$9c(a5)
		bra.L	main		
oson:		move.w	#$2700,sr
		move.w	#$7fff,$9a(a5)
		move.w	intbuff(pc),d0
		ori.w	#$8000,d0
		move.w	d0,$9a(a5)
		moveq	#61,d0
		lea	zero(pc),a0
		lea	8,a1
zeroback:	move.l	(a0)+,(a1)+
		dbf	d0,zeroback
		move.l	sstack(pc),a7
		move.w	#0,sr
		movem.l	(a7)+,d0-d7/a0-a6
		rts
grname:		dc.b	"graphics.library",0
		align	4

zero:		blk.l	62,0
		align	4
sstack:		dc.l	0
stack:		blk.b	4048
stackend:
		align	4

intbuff:	dc.l	0
		align	4
main:		
**********************
*** Voreinstellung ***
**********************

	lea	$dff000,a5
	move.l	#$ffffffff,$44(a5)
	move.w	#%1000010000000000,$96(a5)
	move.w	#%0000011111111111,$96(a5)
	move.l  #copperlist,$80(a5)
 	clr.w   $88(a5)
	move.w  #%1000011111000000,$96(a5)
	lea	hauptloop(pc),a4
	move.l	a4,$6c		
	move.w	#$c010,$9a(a5)
	move.w	#$2000,sr

************
*** Wait ***
************

wait:	
	move.l	$dff004,d0
	and.l	#$1ff00,d0
	cmp.l	#$ff00,d0
	ble.s	wait
	moveq	#0,d0
	bsr	v_lines

	move.l	workplane,a0
	move.l	showplane,workplane
	move.l	a0,showplane	
	btst	#6,$bfe001
	beq	end
	bra	wait		
**************************
******	Hauptteil  *******
**************************

hauptloop:
	move.w	#$10,$dff09c		
	movem.l	d0-d7/a0-a6,-(a7)
	lea	bob1adrs,a0
	move.l	showplane,d0
	moveq	#0,d7
planesset:
	swap	d0
	move.w	d0,2(a0)
	swap	d0
	move.w	d0,6(a0)
	add.l	#8,a0
	add.l	#[200*40],d0
	dbf	d7,planesset
hplend:
	movem.l	(a7)+,d0-d7/a0-a6
	rte				


workplane:
	dc.l	$60000
showplane:
	dc.l	$70000




***************
*** E N D E ***
***************


end:		
		lea	$dff000,a5
		move.l	4,a6
		lea	grname(pc),a1
		clr.l	d0
		jsr	-408(a6)
		move.l	d0,a4
		move.l	38(a4),$80(a5)
		clr.w	$88(a5)
		move.w	#$83f0,$96(a5)
		jmp	oson
		
copperlist:
                dc.w    $008e,$2981,$0090,$29c1
		dc.w	$0092,$0038,$0094,$00d0
 		dc.w    $0108,$0000,$010a,$0000
 	        dc.w    $0102,$0000,$0104,$0024
		dc.w	$120,$0,$122,$0
		dc.w	$124,$0,$126,$0
		dc.w	$128,$0,$12a,$0
		dc.w	$12c,$0,$12e,$0
		dc.w	$130,$0,$132,$0
		dc.w	$134,$0,$136,$0
		dc.w	$138,$0,$13a,$0
		dc.w	$13c,$0,$13e,$0
		dc.w	$100,$0200
		dc.w	$9c,$8010
tsbcolors:
		dc.w	$182,0,$182,$f00
		
		dc.w	$4809,$fffe
bob1adrs:
		dc.w	$00e0,$0006,$00e2,$4000
		dc.w	$4a09,$fffe
		dc.w	$100,$1200
		dc.w	$ffe1,$fffe
		dc.w	$0809,$fffe
		dc.w	$100,$0200
		dc.w	$ffff,$fffe

v_lines:
	move.w	#$f,$dff180
	clear	workplane,#20,#200
	addq.w	#2,anglex
	addq.w	#2,angley
	addq.w	#2,anglez
	move.w	#$1ff,d7
	and.w	d7,anglex
	and.w	d7,angley
	and.w	d7,anglez

	lea	lineobject,a6
	lea	drawtable,a5
lineloop:
	move.w	(a6)+,d0
	cmp.w	#$7fff,d0
	beq	lineloop2
	move.w	(a6)+,d1
	move.w	(a6)+,d2
	addq.l	#2,a6
	move.w	anglex(pc),a0
	move.w	angley(pc),a1
	move.w	anglez(pc),a2

	bsr	rotate
	add.w	#400,d2
	ext.l	d0
	ext.l	d1
	ext.l	d2
	asl.l	#8,d0
	asl.l	#8,d1
	divs	d2,d0
	divs	d2,d1
	add.w	#160,d0
	add.w	#100,d1
	move.w	d0,(a5)+
	move.w	d1,(a5)+
	bra	lineloop
lineloop2:
	move.w	#$7fff,(a5)
	
	lea	drawtable(pc),a5
	lea	lineobject+1024(pc),a6	
lineloop3:
	move.w	(a6)+,d5
	cmp.w	#$7fff,d5
	beq.s	lineloop4
	move.w	(a6)+,d6
	lsl.w	#2,d5
	lsl.w	#2,d6
	move.w	(a5,d5.w),d0
	move.w	2(a5,d5.w),d1
	move.w	(a5,d6.w),d2
	move.w	2(a5,d6.w),d3

	move.l	workplane,a0
	lea	40,a1
	bsr	linedraw
	bra	lineloop3
lineloop4:
	clr.w	$dff180
	rts

anglex:
	dc.w	0
angley:
	dc.w	0
anglez:
	dc.w	0

drawtable:
	blk.b	1000,0


lineobject:
	blk.b	2000,0


********************
*** 3-D Rotieren ***
********************
;d0,d1,d2   x,y,z
;a0,a1,a2   umx,umy,umz

rotate:
	movem.l	d3-d7/a3-a6,-(a7)
	lea	costable(pc),a3
	lea	sintable(pc),a4
	cmp.w	#0,a2
	beq	rot_1
	move.w	d0,d4
	move.w	d1,d5
	muls	(a3,a2.w),d4
	muls	(a4,a2.w),d5
	sub.l	d5,d4
	asr.l	#8,d4
	move.w	d4,d6
	move.w	d0,d4
	move.w	d1,d5
	muls	(a4,a2.w),d4
	muls	(a3,a2.w),d5
	add.l	d4,d5
	asr.l	#8,d5
	move.w	d5,d1
	move.w	d6,d0
rot_1:
	cmp.w	#0,a0
	beq	rot_2
	move.w	d2,d4
	move.w	d1,d5
	muls	(a3,a0.w),d4
	muls	(a4,a0.w),d5
	sub.l	d5,d4
	asr.l	#8,d4
	move.w	d4,d6
	move.w	d2,d4
	move.w	d1,d5
	muls	(a4,a0.w),d4
	muls	(a3,a0.w),d5
	add.l	d4,d5
	asr.l	#8,d5
	move.w	d5,d1
	move.w	d6,d2
rot_2:
	cmp.w	#0,a1
	beq	rot_end
	move.w	d0,d4
	move.w	d2,d5
	muls	(a3,a1.w),d4
	muls	(a4,a1.w),d5
	sub.l	d5,d4
	asr.l	#8,d4
	move.w	d4,d6
	move.w	d0,d4
	move.w	d2,d5
	muls	(a4,a1.w),d4
	muls	(a3,a1.w),d5
	add.l	d4,d5
	asr.l	#8,d5
	move.w	d5,d2
	move.w	d6,d0
rot_end:
	movem.l	(a7)+,d3-d7/a3-a6
	rts


costable:

	dc.w	256,256,256,255,255,254,253,252
	dc.w	251,250,248,247,245,243,241,239
	dc.w	237,234,231,229,226,223,220,216
	dc.w	213,209,206,202,198,194,190,185
	dc.w	181,177,172,167,162,157,152,147
	dc.w	142,137,132,126,121,115,109,104
	dc.w	98,92,86,80,74,68,62,56
	dc.w	50,44,38,31,25,19,13,6
	dc.w	0,-5,-12,-18,-24,-30,-37,-43
	dc.w	-49,-55,-61,-67,-73,-79,-85,-91
	dc.w	-97,-103,-108,-114,-120,-125,-131,-136
	dc.w	-141,-146,-151,-156,-161,-166,-171,-176
	dc.w	-180,-184,-189,-193,-197,-201,-205,-208
	dc.w	-212,-215,-219,-222,-225,-228,-230,-233
	dc.w	-236,-238,-240,-242,-244,-246,-247,-249
	dc.w	-250,-251,-252,-253,-254,-254,-255,-255
	dc.w	-255,-255,-255,-254,-254,-253,-252,-251
	dc.w	-250,-249,-247,-246,-244,-242,-240,-238
	dc.w	-236,-233,-230,-228,-225,-222,-219,-215
	dc.w	-212,-208,-205,-201,-197,-193,-189,-184
	dc.w	-180,-176,-171,-166,-161,-156,-151,-146
	dc.w	-141,-136,-131,-125,-120,-114,-108,-103
	dc.w	-97,-91,-85,-79,-73,-67,-61,-55
	dc.w	-49,-43,-37,-30,-24,-18,-12,-5
	dc.w	0,6,13,19,25,31,38,44
	dc.w	50,56,62,68,74,80,86,92
	dc.w	98,104,109,115,121,126,132,137
	dc.w	142,147,152,158,162,167,172,177
	dc.w	181,185,190,194,198,202,206,209
	dc.w	213,216,220,223,226,229,231,234
	dc.w	237,239,241,243,245,247,248,250
	dc.w	251,252,253,254,255,255,256,256



sintable:

	dc.w	0,-5,-12,-18,-24,-30,-37,-43
	dc.w	-49,-55,-61,-67,-73,-79,-85,-91
	dc.w	-97,-103,-108,-114,-120,-125,-131,-136
	dc.w	-141,-ªRªªª”ªªªTªªª”ªªªQ*ªªªªª‘$ªª’”ªª©I*ªª¥JEUURªIRª”¤Rª¤D¤URJªED¤JD¤UJJRª¥*ª©IERRDEDE$DIJRIRQ*ªª©Rªª©I*ªªI*ª©Rªª©I*ª©$ªª©Rªª©I*ª¤Rªª©Rªª©I*ª©Tªª©Rªª©I*ªª•*ª©Rªª©I*ªª©*ª©Rªª©I*ªªªªª©Rªª©I*ªªE*ª©Rªª©I*ªªªªª©Rªª©I*ª¤E*ª©Rªª©I*ªªTªª©Rªª©I*ªªJªª©Rªª©I*ªªªªª©Rªª©I*ª©*ªª©Rªª©I*ªª•*ª©Rªª©I*ªª•*ª©Rªª©I*ªªªD‰D‰UE)*U¤¥*ªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªU%%*ªªªJUU*ªª¤ªª©Dªªª©*ªªªªªªªDD‘Rªªª¤ª©*©)‘‘’”ªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªªª