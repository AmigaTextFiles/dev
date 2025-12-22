
; Listing17j.s = Pobs.Good.S

***********************************************************
* This is yet another piece of source code that was compatability
* fixed and optimized by the Dancing Fool of Epsilon.  The
* original source SHOULD also be in this archive, if it isn't
* then jump up and down and yell "IDIOTS!" at the top of your
* lungs. :^)  Enjoy.

;------------------------------------------------!
; *OLD* testroutine, just for checking out how   !
; boring it is not to use the blitter......      !
; I have not modified the original code, which   !
; I wrote a long time ago.. This code CAN be     !
; Optimized in a LOT of ways. Please don't mail  !
; any "why do that, when you can do this", "You  !
; sure are inconsequent" (I was inconsequent!),  !
; "Slow code, this is much faster" (I can also   !
; make this routine faster...), "You brake every !
; bloody rule here boy.." (I did that yes, and   !
; still do, but very faster..:-), "Grrr." and    !
; so on. If you don't like it then get rid of it!!
; You can always use it to look at the patterns  !
; by changing the pointer-speeds!                !
;------------------------------------------------!

***********************************************************
* Other Macros
***********************************************************

CALL	MACRO
	jsr	_LVO\1(a6)
	ENDM

SwapBmaps	MACRO
	movem.l	ClearBmap,d0/d1
	move.l	VisualBmap,ClearBmap
	movem.l	d0-d1,ActiveBmap

	lea	bmapptrs+2,a0
	move.w	d1,4(a0)
	swap	d1
	move.w	d1,(a0)
	ENDM

ClearBmaps	MACRO
	move.l	ClearBmap,$dff054
	move.l	#$01000000,$dff040
	move.w	#0,$dff066
	move.w	#(height*64)+(width/2),$dff058
	ENDM

***********************************************************
* Other Equates
***********************************************************

 IFND	gb_ActiView
gb_ActiView	EQU	32
 ENDIF

 IFND	gb_CopInit
gb_CopInit	EQU	36
 ENDIF

width	EQU	40
height	EQU	256

***********************************************************

	section TheCode,code

	bsr.w	TakeSystem
	move.w #$20,$dff1dc	; pal
	move.l	#copper,$80-2(a5)
	move.w	#$83c0,$96-2(a5)	; turn on the dma we need
	move.w	#0,$1fc-2(a5)	; no aga

	bsr.b	main

;	move.w	#$0,$dff1dc	; ntsc!
	bsr.w	RestoreSystem
	rts

***********************************************************

main:
	bsr.w	InPtabs
	bsr.w	Rmasks

.loop:
	cmp.b	#$f4,$dff006
	bne.b	.loop
	
	SwapBmaps
	ClearBmaps

	bsr.w	Calc	
	bsr.w	Put	
	
	cmpi.w	#293-1,number
	beq.b	.1
	addq.w	#1,number
.1:
	btst.b	#6,$bfe001
	bne.b	.loop
	rts

***********************************************************

InPtabs:	lea	pob_xbuffer,a0
	moveq	#0,d0
.xloop:	move.w	d0,d1
	move.w	d0,d2
	and.w	#$000f,d1
	lsl.w	#6,d1
	move.w	d1,(a0)+
	and.w	#$fff0,d2
	ror.w	#3,d2
	move.w	d2,(a0)+
	addq.w	#1,d0
	cmpi.w	#width*8,d0
	bne.b	.xloop
	
	lea	pob_ybuffer,a0
	moveq	#0,d0
.yloop:	move.w	d0,d1
	mulu	#width,d1
	move.l	d1,(a0)+
	addq.w	#1,d0
	cmp.w	#height,d0
	bne.b	.yloop
	rts

***********************************************************

Rmasks:	moveq	#0,d7
	lea	shape_buffer,a1
.loop1:	lea	pob_shape,a0
	move.w	#16,d6
.loop2:	move.l	(a0)+,d0
	ror.l	d7,d0
	move.l	d0,(a1)+
	subq.w	#1,d6
	bne.b	.loop2
	addq.w	#1,d7
	cmpi.w	#16,d7
	bne.b	.loop1
	rts

***********************************************************

Calc:	move.w	#$eeee,d0
	move.w	#720,d6
	lea	sinx_pointer1,a0

	movem.l	(a0),a2/a3/a4/a5
	movem.w	sinx_add1,d2/d3/d4/d5

	adda.w	d2,a2
	cmp.w	(a2),d0
	bne.b	.bkip1
	suba.w	d6,a2

.bkip1:	adda.w	d3,a3
	cmp.w	(a3),d0
	bne.b	.bkip2
	suba.w	d6,a3

.bkip2:	adda.w	d4,a4
	cmp.w	(a4),d0
	bne.b	.bkip3
	suba.w	d6,a4

.bkip3:	adda.w	d5,a5
	cmp.w	(a5),d0
	bne.b	.bkip4
	suba.w	d6,a5

.bkip4:	movem.l	a2/a3/a4/a5,(a0)

	lea	coord_stack,a0
	movem.w	sinx_dist1,d3-d4/a1/a6

	move.w	d0,d5

	move.w	number,d7
.loop:	add.w	d3,a2
	add.w	d4,a3
	cmp.w	(a2),d5
	bne.b	.not_x1
	suba.w	d6,a2

.not_x1:	cmp.w	(a3),d5
	bne.b	.not_x2
	suba.w	d6,a3

.not_x2:	move.w	(a2),d0
	add.w	(a3),d0
	add.w	a1,a4
	add.w	a6,a5
	cmp.w	(a4),d5
	bne.b	.not_y1
	suba.w	d6,a4

.not_y1:	cmp.w	(a5),d5
	bne.b	.not_y2
	suba.w	d6,a5

.not_y2:	move.w	(a4),d1
	add.w	(a5),d1
	move.w	d0,(a0)+
	move.w	d1,(a0)+

	dbf	d7,.loop
	rts

***********************************************************

Put:	lea	pob_xbuffer,a0
	lea	pob_ybuffer,a1
	lea	shape_buffer,a4
	move.l	ActiveBmap,a6
	lea	coord_stack,a5

	move.w	number,d7
.loop:	movem.w	(a5)+,d0/d1

	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a0,d0.w),d0
	lea	width(a6,d0.w),a3
	add.l	(a1,d1.w),a3
	swap	d0
	lea	(a4,d0.w),a2
	
	movem.l	(a2),d0-d5
	or.l	d0,(width*0)(a3)
	or.l	d1,(width*1)(a3)
	or.l	d2,(width*2)(a3)
	or.l	d3,(width*3)(a3)
	or.l	d4,(width*4)(a3)
	or.l	d5,(width*5)(a3)

	dbf	d7,.loop
	rts

***********************************************************

TakeSystem:	movea.l	4.w,a6	; exec base
	lea	$dff002,a5	; custom chip base + 2

	lea	GraphicsName,a1	; "graphics.library"
	jsr	-$198(a6)	; ione
	move.l	d0,gfx_base	; save pointer to gfx base
	move.l	d0,a6	; for later callls...


	movea.l	4.w,a6	; exec base
	jsr	-$84(a6)	; Forbid - kill multitasking

	move.w	2-2(a5),d0	; dmaconr - old DMACON bits
	ori.w	#$8000,d0	; or it set bit for restore
	move.w	d0,OldDMACon	; save it

	move.w	$1c-2(a5),d0	; old INTEna bits
	ori.w	#$c000,d0	; or it set bit for restore
	move.w	d0,OldINTEna	; save it

	move.l	#$7fff7fff,$9a-2(a5)	; intena - kill all ints
	move.w	#$7fff,$96-2(a5)	; dmacon - kill all dma
	rts

***********************************************************

RestoreSystem:	lea	$dff002,a5	; custom chip base + 2

	; You must do these in this order or you're asking for trouble!
	move.l	#$7fff7fff,$9a-2(a5)	; intena - kill all ints
	move.w	#$7fff,$96-2(a5)	; dmacon - kill all dma
	move.w	OldDMACon,$96-2(a5)	; restore old dma bits
	move.w	OldINTEna,$9a-2(a5)	; restore old int bits

	move.l	gfx_base,a6	; gfx base
	move.l	$26(a6),$80-2(a5) ; restore system clist
	move.l	a6,a1
	movea.l	4.w,a6	; exec base
	jsr	-$19e(a6)	; CloseLibrary
	
	jsr	-$8a(a6)	; permit
	; there is no call to Permit() because it is implied by the return
	; to AmigaDOS! :^)
	rts

***********************************************************

	section	pants,data

sinx_pointer1:	dc.l	sin_xtab
sinx_pointer2:	dc.l	sin_xtab
siny_pointer1:	dc.l	sin_ytab
siny_pointer2:	dc.l	sin_ytab
sinx_add1:	dc.w	1*2	;change values here to obtain
sinx_add2:	dc.w	5*2	;new patterns
siny_add1:	dc.w	3*2
siny_add2:	dc.w	2*2
sinx_dist1:	dc.w	4*2
sinx_dist2:	dc.w	3*2
siny_dist1:	dc.w	1*2
siny_dist2:	dc.w	2*2
number:	dc.w	0	;number of 'pobs'

ClearBmap:	dc.l	screen+(height*width*2)
ActiveBmap:	dc.l	screen+(height*width)
VisualBmap:	dc.l	screen

GraphicsName:
	dc.b	"graphics.library",0
	EVEN

sin_xtab:	dc.w	75,76,78,79,80,82,83,84
	dc.w	85,87,88,89,91,92,93,94
	dc.w	96,97,98,99,101,102,103,104
	dc.w	106,107,108,109,110,111,112,114
	dc.w	115,116,117,118,119,120,121,122
	dc.w	123,124,125,126,127,128,129,130
	dc.w	131,132,132,133,134,135,136,136
	dc.w	137,138,139,139,140,141,141,142
	dc.w	142,143,144,144,145,145,145,146
	dc.w	146,147,147,147,148,148,148,149
	dc.w	149,149,149,149,150,150,150,150
	dc.w	150,150,150,150,150,150,150,150
	dc.w	150,149,149,149,149,149,148,148
	dc.w	148,147,147,147,146,146,145,145
	dc.w	145,144,144,143,142,142,141,141
	dc.w	140,139,139,138,137,136,136,135
	dc.w	134,133,132,132,131,130,129,128
	dc.w	127,126,125,124,123,122,121,120
	dc.w	119,118,117,116,115,114,113,111
	dc.w	110,109,108,107,106,104,103,102
	dc.w	101,99,98,97,96,94,93,92
	dc.w	91,89,88,87,85,84,83,82
	dc.w	80,79,78,76,75,74,72,71
	dc.w	70,68,67,66,65,63,62,61
	dc.w	59,58,57,56,54,53,52,51
	dc.w	49,48,47,46,44,43,42,41
	dc.w	40,39,38,36,35,34,33,32
	dc.w	31,30,29,28,27,26,25,24
	dc.w	23,22,21,20,19,18,18,17
	dc.w	16,15,14,14,13,12,11,11
	dc.w	10,9,9,8,8,7,6,6
	dc.w	5,5,5,4,4,3,3,3
	dc.w	2,2,2,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,1,1,1
	dc.w	1,1,2,2,2,3,3,3
	dc.w	4,4,5,5,5,6,6,7
	dc.w	8,8,9,9,10,11,11,12
	dc.w	13,14,14,15,16,17,18,18
	dc.w	19,20,21,22,23,24,25,26
	dc.w	27,28,29,30,31,32,33,34
	dc.w	35,36,37,39,40,41,42,43
	dc.w	44,46,47,48,49,51,52,53
	dc.w	54,56,57,58,59,61,62,63
	dc.w	65,66,67,68,70,71,72,74
	dc.w	75
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee

sin_ytab:	dc.w	57,59,60,61,62,63,64,65
	dc.w	66,66,67,68,69,70,71,72
	dc.w	73,74,75,76,77,78,79,80
	dc.w	81,82,83,84,84,85,86,87
	dc.w	88,89,90,90,91,92,93,94
	dc.w	94,95,96,97,97,98,99,100
	dc.w	100,101,102,102,103,103,104,105
	dc.w	105,106,106,107,107,108,108,109
	dc.w	109,110,110,110,111,111,112,112
	dc.w	112,112,113,113,113,114,114,114
	dc.w	114,114,114,115,115,115,115,115
	dc.w	115,115,115,115,115,115,115,115
	dc.w	115,115,114,114,114,114,114,114
	dc.w	113,113,113,112,112,112,112,111
	dc.w	111,110,110,110,109,109,108,108
	dc.w	107,107,106,106,105,105,104,103
	dc.w	103,102,102,101,100,100,99,98
	dc.w	97,97,96,95,94,94,93,92
	dc.w	91,90,90,89,88,87,86,85
	dc.w	84,84,83,82,81,80,79,78
	dc.w	77,76,75,74,73,72,71,70
	dc.w	69,68,67,66,66,65,64,63
	dc.w	62,61,60,59,58,56,55,54
	dc.w	53,52,51,50,49,49,48,47
	dc.w	46,45,44,43,42,41,40,39
	dc.w	38,37,36,35,34,33,32,31
	dc.w	31,30,29,28,27,26,25,25
	dc.w	24,23,22,21,21,20,19,18
	dc.w	18,17,16,15,15,14,13,13
	dc.w	12,12,11,10,10,9,9,8
	dc.w	8,7,7,6,6,5,5,5
	dc.w	4,4,3,3,3,3,2,2
	dc.w	2,1,1,1,1,1,1,0
	dc.w	0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,1,1
	dc.w	1,1,1,1,2,2,2,3
	dc.w	3,3,3,4,4,5,5,5
	dc.w	6,6,7,7,8,8,9,9
	dc.w	10,10,11,12,12,13,13,14
	dc.w	15,15,16,17,18,18,19,20
	dc.w	21,21,22,23,24,25,25,26
	dc.w	27,28,29,30,31,31,32,33
	dc.w	34,35,36,37,38,39,40,41
	dc.w	42,43,44,45,46,47,48,49
	dc.w	49,50,51,52,53,54,55,56
	dc.w	57
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee
	dc.w	$eeee,$eeee,$eeee,$eeee

pob_shape:
	dc.w	%0000000110000000,0
	dc.w	%0000000110000000,0
	dc.w	%0000011111100000,0
	dc.w	%0000011111100000,0
	dc.w	%0000000110000000,0
	dc.w	%0000000110000000,0

***********************************************************

	section	stuff,data_c

copper:
	dc.w	$1fc,0
	dc.l 	$008e2c81,$00902cc1
	dc.l	$00920038,$009400d0
	dc.l	$01080000,$010a0000
	dc.l 	$01001200,$01020000,$01040000
	dc.l	$01800000,$01820ff0
bmapptrs:
	dc.l 	$00e00000,$00e20000
	dc.l 	-2,-2

***********************************************************

	section	Screens,bss_c

screen:	ds.b	(height*width*3)+(width*50)

shape_buffer:	ds.l	256
pob_xbuffer:	ds.l	[width*8]
pob_ybuffer:	ds.l	height

***********************************************************

	section	OldPointers_and_such,bss

gfx_base	ds.l	1	; pointer to graphics base
OldView	ds.l    1	; old Work Bench view addr.

OldDMACon:	ds.w	1	; old dmacon bits
OldINTEna:	ds.w	1	; old intena bits

coord_stack:	ds.l	1500
