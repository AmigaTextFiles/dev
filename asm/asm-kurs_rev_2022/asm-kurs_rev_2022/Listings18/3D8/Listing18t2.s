
; Listing18t2.s = vector2.s

; Assemble and die!!!
; Angus, there are 2 modules on this disk 'okkie' & 'scoopex theme'


	Section vectors,code_c	*All code to chip memory

no_stars	equ	48
	
	bsr	killsystem	*Get rid of O.S
	bsr	allocate	*Allocate memory
	bsr	setcopper	*Set up copper list
	bsr	setscreen	*Set screen parameters,palette
	bsr	startup		*Start up DMA channels
	bsr	makesine
	bsr	getmouse
	bsr	convertascii
;	bsr	mt_init
	bsr	set_stars
	bsr	set_sprites
	
	move.w	#-4,styvel

	lea	vtable,a0
	move.l	a0,vtable_ptr

	move.w	#200,ocount

	move.w	#400,zpos
	bsr	fistobj
	move.w	#-1,texture
	move.w	#$8000,linesize
loop:
	bsr	flipframe
	bsr	erase
	bsr	movestars
	move.l	point_data_ptr,a6
	bsr	calcobject
	bsr	demotasks
	move.l	face_data_ptr,a6
	bsr	plotobject_filled
	bsr	demotasks
	bsr	nextobject
	bsr	demotasks
	tst.w	ret_flag
	beq.s	loop		*If not pressed - continue loop

;	bsr	mt_end
	bsr	deallocate
	bsr	revivesystem	*Bring back O.S
	clr.l	d0		*Keep EXEC happy
	rts

****************************************

greets:
	move.w	gscroll,d0
	beq	greets_noscroll
	subq	#1,d0
	move.w	d0,gscroll
	cmp.w	#48,d0
	bpl	greets_ret
g_wb:
	btst	#6,dmaconr+custom
	bne.s	g_wb
	move.w	#40-12,bltamod+custom
	move.w	#40-12,bltdmod+custom
	move.w	#$09f0,bltcon0+custom
	move.w	#0,bltcon1+custom
	lea	pic+4+plwidth*(8+64*4),a0
	move.l	a0,bltdpth+custom
	lea	40(a0),a0
	move.l	a0,bltapth+custom
	move.w	#(64*47)+6,bltsize+custom
g_wb2:
	btst	#6,dmaconr+custom
	bne.s	g_wb2
	rts

greets_noscroll:
	move.l	glet_ptr,a0
	moveq	#0,d2
	move.b	(a0)+,d2
	cmp.l	#greets_end,a0
	bne.s	g_2
	move.l	#greets_start,a0
g_2:
	move.l	a0,glet_ptr
	move.w	gx,d0
	move.w	gy,d1
	addq	#1,d0
	cmp.w	#12,d0
	bne.s	g_3
	moveq	#0,d0
	addq	#1,d1
	cmp.w	#6,d1
	bne.s	g_3
	move.w	#0,d1
	move.w	#70,gscroll
g_3:
	move.w	d0,gx
	move.w	d1,gy
	bsr	printsmall
greets_ret
	rts

gscroll:
	dc.w	0

glet_ptr:
	dc.l	0

gx:	dc.w	-1
gy:	dc.w	0


convertascii:
;	lea	text(pc),a0
;	move.l	a0,nextlt_ptr
;	lea	charset,a2
;	bsr	conv_loop

	lea	greets_start,a0
	move.l	a0,glet_ptr
	lea	gset,a2
conv_loop:
	move.b	(a0),d0
	bmi.s	conv_end
	cmp.b	#"*",d0
	bne.s	conv_dosearch
	move.b	#100,(a0)+
	bra.s	conv_notfound
conv_dosearch:
	move.l	a2,a1
	moveq	#-1,d2
conv_find:
	addq	#1,d2
	move.b	(a1)+,d3
	beq.s	conv_notfound
	cmp.b	d3,d0
	bne.s	conv_find
	move.b	d2,(a0)+
conv_notfound:
	bra.s	conv_loop
conv_end:
	rts

charset:
	dc.b	" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!?,.'&()-{}[]:>;<"
gset:
	dc.b	" abcdefghijklmnopqrstuvwxyz.-:?!"

*********************************************

wait:
	move.l	#50,d7
.wait	bsr	delay
	dbra	d7,.wait
	rts

****************************************

greets_start:
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "

	dc.b	"            "
	dc.b	" thr  send  "
	dc.b	"greetings to"
	dc.b	"these people"
	dc.b	"            "
	dc.b	" no order!! "

	dc.b	"            "
	dc.b	"fred        "
	dc.b	"phenomena   "
	dc.b	"digi wizard "
	dc.b	"scoopex uk  "
	dc.b	"            "

	dc.b	"            "
	dc.b	"excel uk    "
	dc.b	"choas       "
	dc.b	"megadeth    "
	dc.b	"pseudo ops  "
	dc.b	"            "

	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "

	dc.b    "            "
	dc.b	"thr members "
	dc.b 	"are...      "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	
	dc.b	"            "
	dc.b	"studiomaster"
	dc.b    "  musician  "
	dc.b	"  swapper   "
	dc.b	"  leader    "
	dc.b	"            "

	dc.b	"            "
	dc.b	"dragonflight"
	dc.b	"            "
	dc.b	"  graphics  "
	dc.b	"   leader   "
	dc.b	"            "

	dc.b	"            "
	dc.b	"   legend   "
	dc.b	"            "
	dc.b	"   coder    "
	dc.b	"   graphics "
	dc.b	"            "

	dc.b	"            "
	dc.b	"   lazarus  "
	dc.b	"            "
	dc.b	"    coder   "
	dc.b	"            "
	dc.b   	"            "

	dc.b	"            "
	dc.b	"     ash    "
	dc.b	"            "
	dc.b	"   swapper  "
	dc.b	"            "
	dc.b	"            "

	dc.b	"            "
	dc.b	"    saint   "
	dc.b	"            "
	dc.b	"   swapper  "
	dc.b	"            "
	dc.b	"            "

	dc.b	"            "
	dc.b	" magic inc. "
	dc.b	"            "
	dc.b	"  musician  "
	dc.b	"            "
	dc.b	"            "

	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "
	dc.b	"            "

greets_end:
	dc.b	$ff
	even
****************************************


printsmall:	;d0=x,d1=y,d2=letter
	lea	smallfont,a0
	lea	(a0,d2.w),a0
	lsl.w	#3,d1
	mulu	#40,d1
	lea	pic+4+plwidth*(8+64*4),a1
	lea	(a1,d0.w),a1
	add.l	d1,a1
	
	move.w	#7,d7
print_loop:
	move.b	(a0),(a1)
	lea	32(a0),a0
	lea	40(a1),a1
	dbra	d7,print_loop
	rts


****************************************


RotateObject:

	tst.w	rotate_flag
	bmi	ro_ret
	lea	xangle,a0
	lea	xavel,a1
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0),d2
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1),d5

	move.l	vtable_ptr,a6
	move.w	rcount,d7	*Check for next rotation
	subq	#1,d7
	bpl.s	ro_2	
	addq	#6,a6		*Do next rotation
	move.w	#90,d7
	cmp.l	#endvtable,a6
	bne.s	ro_1
	lea	vtable,a6
ro_1:
	move.l	a6,vtable_ptr
ro_2:
	move.w	d7,rcount
				*Do current rotaton-alter angular velocities
	btst	#0,d7
	beq.s	ro_done
	cmp.w	(a6)+,d3
	beq.s	ro_do_y
	ble.s	ro_xu
	subq	#2,d3
ro_xu:
	addq	#1,d3
ro_do_y
	cmp.w	(a6)+,d4
	beq.s	ro_do_z
	ble.s	ro_yu
	subq	#2,d4
ro_yu:
	addq	#1,d4
ro_do_z:
	cmp.w	(a6),d5
	beq.s	ro_done
	ble.s	ro_zu
	subq	#2,d5
ro_zu:
	addq	#1,d5
ro_done:			*Change angles
	add.b	d3,d0
	add.b	d4,d1
	add.b	d5,d2
	move.w	d5,(a1)
	move.w	d4,-(a1)
	move.w	d3,-(a1)
	move.w	d2,(a0)
	move.w	d1,-(a0)
	move.w	d0,-(a0)
	move.w	d5,styvel
ro_ret:
	rts

****************************************

demotasks:
	btst	#4,intreqr+1+custom
	beq.s	not_time_for_demo_tasks
	move.w	#$10,intreq+custom
	movem.l	d0-d7/a0-a6,-(sp)
;	bsr	mt_music
;	bsr	calcequal
	bsr	RotateObject
	bsr	scroll_bar
;	bsr	print
	bsr	move_pointer
	bsr	greets
	move.w	joy0dat+custom,d0
	move.w	d0,omouse
	movem.l	(sp)+,d0-d7/a0-a6
not_time_for_demo_tasks
	rts

****************************************


nextobject:
	btst	#7,$bfe001
	beq.s	donext
	move.w	ocount,d0
	subq	#1,d0
	cmp.w	#300-$10,d0
	bgt.s	don2
	cmp.w	#$d,d0
	bgt	don1
	asl.w	texture
	tst.w	d0
	bmi.s	donext
don1:
	move.w	d0,ocount
	rts
don2:
	asr.w	texture
	move.w	d0,ocount
	rts
donext:
	move.w	#300,ocount
;	bsr	shrink
	move.w	object(pc),d0
	add.w	#1,d0
	tst.w	d0
	bpl.s	nxt_de
	move.w	#no_objects-1,d0
nxt_de:
	cmp.w	#no_objects,d0
	bne.s	nxtob0
	moveq	#0,d0
nxtob0:
	move.w	d0,object
	lsl.w	#4,d0
	lea	object_list,a3
	lea	(a3,d0.w),a3
	movem.l	(a3)+,a0-a2
	move.l	a0,point_data_ptr
	move.l	a1,line_data_ptr
	move.l	a2,face_data_ptr
	move.w	#$8000,texture
;	bsr	enlarge
notnext:
	rts

****************************************

fistobj:
	lea	point_data11(pc),a0
	lea	line_data11(pc),a1
	lea	face_data11(pc),a2
	move.l	a0,point_data_ptr
	move.l	a1,line_data_ptr
	move.l	a2,face_data_ptr
	rts

****************************************

**********************************
**				**
**      3-D VECTOR GRAPHICS 	**
**				**
**********************************

************************************************
*  ROTATION ROUTINE (D0,D1,D2)->(D0,D2)        *
*	sine,cosine->D4,D5		       *
************************************************


Do_Rotate
	move.w	d0,d2		*Duplicate X,Y for matrix multiply ...
	move.w	d1,d3
	muls	d4,d0		* d0 = Xcos0		
	muls	d4,d3		* d3 = Ycos0
	muls	d5,d1		* d1 = Ysin0
	muls	d5,d2		* d2 = Xsin0
	sub.l	d1,d0		* d0 = Xcos0-Ysin0
	add.l	d3,d2		* d2 = Xsin0+Ycos0
	asr.l	#7,d0		* Remove bits of fractional accuracy ...
	asr.l	#7,d2		*Result in (d0,d2) !
	rts

*********************************************************
*							*
*	SINE TABLE GENERATOR - uses Sines from		*
*	   (0-126) to complete (0-510) & cosine		*
*							*
*********************************************************

makesine:			*Sine...
	lea	sine+2,a0
	lea	256(a0),a1
	lea	256(a0),a2
	lea	512(a0),a3
	move.l	#63,d7
ms_loop1:
	move.w	(a0),d0
	move.w	d0,512(a0)
 	move.w	d0,(a0)+
	move.w	d0,-(a1)
	move.w	d0,512(a1)
	sub.w	#1,d0
	neg.w	d0
	add.w	#2,d0
	move.w	d0,512(a2)
	move.w	d0,(a2)+
	move.w	d0,-(a3)
	move.w	d0,512(a3)	
	dbra	d7,ms_loop1
				*Cosine
	lea	sine+128,a0
	lea	cosine,a1
	lea	512(a1),a2
	move.l	#127,d7
mcs_loop:
	move.w	(a0)+,d0
	move.w	d0,(a1)+
	move.w	d0,-(a2)
	dbra	d7,mcs_loop
	rts

********************************************

xsin	dc.w	0
ysin	dc.w	0
zsin	dc.w	0
xcos	dc.w	0
ycos	dc.w	0
zcos	dc.w	0

line_buffer:
	ds.b	1024

****************************************************


*****************************************
*					*
*	OLD ROUTINES START HERE....	*
*					*
*****************************************

*******************************
*      STARFIELD ROUTINE      *
*******************************

movestars:
	move.w	#no_stars-1,d7
	lea	stdata,a0
	move.w	#768,d3
	move.w	#160,d4
	move.w	#$7,d5
	move.w	#40,d6
	move.w	#%10000000,a2
	move.w	#%11000000,a3
	move.l	bitmap1_ptr,a6
	lea	plwidth*128(a6),a6
mstloop:
	movem.w	(a0),d0-d2	* Get x,y,z
	subq	#8,d2
	cmp.w	#256,d2
	bpl.s	mst1
	add.w	d3,d2		* d3=starfield depth
mst1:				* Do perspective...
	movem.w	d0-d2,(a0)
	addq	#6,a0
	ext.l	d0
	ext.l	d1
	asl.l	#8,d0
	asl.l	#8,d1
	divs	d2,d0
	divs	d2,d1		* (d0,d1)=x,y

	move.w	d2,a4
	add.w	d4,d0		* d4=mid screen x
	move.w	d0,d2		* d2=shift
	lsr.w	#3,d0		* d0=byte count
	and.w	d5,d2
	muls	d6,d1
	lea	(a6,d0.w),a1
	add.l	d1,a1		* a1 now = screen...
	cmp.w	#256+256,a4
	bpl.s	st_size1
	move.w	a3,d0
	bra.s	st_size2
st_size1:
	move.w	a2,d0
st_size2:
	lsr.w	d2,d0
	or.b	d0,(a1)		* plot the star
	cmp.w	#256+128,a4
	bpl.s	st_size3
	or.b	d0,40(a1)
st_size3:
	bsr	demotasks
	dbra	d7,mstloop	* Next star or quit
	rts

*********************************
*				*
*   VECTOR TRANSFORMATIONS	*
*				*
*********************************

calcobject:
	lea	data_2d,a5
	move.w	(a6)+,d7
	lea	sine,a0
	lea	cosine,a1
	lea	xangle,a2

	move.w	(a2)+,d2
	lsl.w	#1,d2
	move.w	(a0,d2.w),d4	*Get sine 
	move.w	(a1,d2.w),d5	*And cosine
	movem.w	d4-d5,xsine

	move.w	(a2)+,d2
	lsl.w	#1,d2
	move.w	(a0,d2.w),d4	*Get sine 
	move.w	(a1,d2.w),d5	*And cosine
	movem.w	d4-d5,ysine

	move.w	(a2),d2
	lsl.w	#1,d2
	move.w	(a0,d2.w),d4	*Get sine 
	move.w	(a1,d2.w),d5	*And cosine
	movem.w	d4-d5,zsine


calcloop_3d:
	move.w	yptr(a6),d0	*Get Y in D0
	move.w	zptr(a6),d1	*Get Z in D1
	movem.w	xsine,d4/d5
	jsr	rotate		*Do rotation around X axis
	move.w	d2,d6		*Store Z in d6
	move.w	d0,d1		*put Y in D1

	move.w	xptr(a6),d0	*Get x in d0
	movem.w	zsine,d4/d5	*D1 is already set as Y
	jsr	rotate		*Do rotation around Z axis

	move.w	d6,d1		*Get Z back from stack,st
	move.w	d2,d6		*and store Y
	movem.w	ysine,d4/d5
	jsr	rotate		*Do rotation around Y axis

	move.w	d6,d1		*get y (d1)co-ord,x & z (d0,d2)are already set

	add.w	xpos,d0
	add.w	ypos,d1
	ext.l	d0		* Perspective Projection .....
	ext.l	d1
	asl.l	#8,d0		* Screen is 256 units away from eye.....
	asl.l	#8,d1
	add.w	zpos,d2
	divs	d2,d0		* Do inversly proportional shrink...
	divs	d2,d1
	add.w	#160,d0		* Set to centre of screen ....
	add.w	#128,d1		* Done !!!!

	move.w	d0,(a5)+	*Store 2d co-ords
	move.w	d1,(a5)+
	addq	#6,a6
	bsr	demotasks
	dbra	d7,calcloop_3d	*Do next point of end loop
	rts

xsine:	dc.w	0,0
ysine:	dc.w	0,0
zsine:	dc.w	0,0


****************************************
* PLOT OBJECT WITH HIDDEN LINE REMOVAL *
****************************************

plotobject_filled:
	lea	data_2d,a5
	moveq	#0,d7
	move.w	(a6)+,d7
	bmi.s	pf_notri
plotloopfl_3d:			* TRIANGLES.....
	move.w	(a6)+,d6	*Get start point in D5
	lsl.w	#2,d6
	move.w	(a5,d6.w),d0	* Get start X
	move.w	2(a5,d6.w),d1	* Get start Y

	move.w	(a6)+,d6	*Get middle point in D5
	lsl.w	#2,d6
	move.w	(a5,d6.w),d2
	move.w	2(a5,d6.w),d3	

	move.w	(a6)+,d6	*Get end point in D5
	lsl.w	#2,d6
	move.w	(a5,d6.w),d4
	move.w	2(a5,d6.w),d5	

	move.w	(a6)+,d6
	bsr	fillfacet		* and draw face,incl. check
	bsr	demotasks
	dbra	d7,plotloopfl_3d	* Draw next line,or end loop
pf_notri:
	moveq	#0,d7		*QUADRILATERALS....
	move.w	(a6)+,d7
	bmi.s	pf_noqud
plotloopflq_3d:
	move.w	(a6)+,d6	*Get point1 in D5
	lsl.w	#2,d6
	move.w	(a5,d6.w),d0	* Get start X
	move.w	2(a5,d6.w),d1	* Get start Y

	move.w	(a6)+,d6	*Get point2 in D5
	lsl.w	#2,d6
	move.w	(a5,d6.w),d2
	move.w	2(a5,d6.w),d3	

	move.w	(a6)+,d6	*Get point3 in D5
	lsl.w	#2,d6
	move.w	(a5,d6.w),d4
	move.w	2(a5,d6.w),d5	

	move.w	(a6)+,d6	*Get point4 in D5
	
	lsl.w	#2,d6
	move.w	(a5,d6.w),a0
	move.w	2(a5,d6.w),a1
	move.w	a0,txq
	move.w	a1,tyq	

	move.w	(a6)+,d6
	bsr	fillfaceq		* and draw face,incl. check
	bsr	demotasks
	dbra	d7,plotloopflq_3d	* Draw next line,or end loop
pf_noqud:
	bsr	demotasks
	rts


****************
* ERASE BITMAP *
****************

erase:	
	btst	#6,dmaconr+custom
	bne.s	erase

	move.l	bitmap1_ptr,a0		* Get bitmap pointer
	move.w	#0,bltdmod+custom		* No modulo
	move.w	#%0000100100000000,bltcon0+custom	*No minterm,only enable D
	move.w	#0,bltcon1+custom		* No special modes
	move.w	#0,bltddat+custom

	moveq	#3,d7
erase_blit:
	btst	#6,dmaconr+custom
	bne.s	erase_blit
	lea	plwidth*48(a0),a0
	move.l	a0,bltdpth+custom
	move.w	#(160*64)+20,bltsize+custom	*Trigger blit !
	lea	plsize-plwidth*48(a0),a0
	dbra	d7,erase_blit
	rts

*********************************
*   DO PERSPECTIVE PROJECTION   *
*********************************

project:			* (x,y,z)=(d0,d1,d2) , (xc,yc,zc)=(d3,d4,d5)
	muls	d5,d0		* D0 = (x*zc)
	muls	d5,d1		* D1 = (y*zc)
	muls	d2,d3		* D3 = (z*xc)
	muls	d2,d4		* D4 = (z*yc)
	sub.w	d5,d2		* D2 = (z-zc)
	sub.l	d0,d3		* D3 = (z*xc - x*zc)
	sub.l	d1,d4		* D4 = (z*yc - y*zc)
	divs	d2,d3		* D2 = (z*xc - x*zc) / (z-zc)
	divs	d2,d4		* D2 = (z*yc - y*zc) / (z-zc)
	rts			* d3 = screen x , d4 = screen y !

*******************
*   DO ROTATION   *
*******************

rotate:				* Sine/Cosine preset in d4/d5
	move.w	d0,d2		*Duplicate X,Y for matrix multiply ...
	move.w	d1,d3
	muls	d4,d0		* d0 = Xcos0		
	muls	d4,d3		* d3 = Ycos0
	muls	d5,d1		* d1 = Ysin0
	muls	d5,d2		* d2 = Xsin0
	sub.l	d1,d0		* d0 = Xcos0-Ysin0
	add.l	d3,d2		* d2 = Xsin0+Ycos0
	asr.l	#7,d0		* Remove bits of fractional accuracy ...
	asr.l	#7,d2		*Result in (d0,d2) !
	rts

*****************************************
*	DRAW LINE FOR AREA FILL		*
*****************************************

maxy:	dc.w	0

draw_fill:			* (d0,d1) -> (d2,d3) uses D4, A0
	bsr	demotasks
	sub.w	d0,d2
;	bpl.s	df_upperedge
;	addq.w	#1,d1
;	addq.w	#1,d3
df_upperedge:
	sub.w	d1,d3
	bpl.s	df_leftedge
	subq.w	#1,d0
	bpl.s	df_leftedge
	addq.w	#1,d0
df_leftedge:
	movem.w	d2-d4,-(sp)
	move.w	d0,d2
	move.w	d1,d3
	move.w	d2,d4
	lsr.w	#3,d2
	and.b	#$7,d4
	mulu	spare_width,d3
	ext.l	d2
	add.l	d2,d3
	move.l	spare_ptr,a0
	add.l	d3,a0
	move.b	#$80,d2
	lsr.b	d4,d2
;	eor.b	d2,(a0)
	movem.w	(sp)+,d2-d4
	move.b	d0,d4
	lsl.w	#8,d4
	lsl.w	#4,d4
	or.w	#%101100000000+$5a,d4
	move.l	spare_ptr,a0
	lsr.w	#3,d0
	and.l	#$fffe,d0
	mulu	spare_width,d1
	add.l	d0,a0
	add.l	d1,a0
	moveq	#0,d0
	neg.w	d3
	tst.w	d2
	bpl.s	df_xp
	eor.b	#%011,d0
	neg.w	d2
df_xp:	tst.w	d3
	bpl.s	df_yp
	eor.b	#%111,d0
	neg.w	d3
df_yp:	subq.w	#1,d3
	bpl.s	df_yvpa
	moveq	#0,d3
df_yvpa:
	addq.w	#1,d2
	bpl.s	df_yvp
	moveq	#0,d2
df_yvp:
	cmp.w	d2,d3
	bmi.s	df_xg
	move.w	d3,d1
	beq	nodrawf
	eor.b	#%001,d0
	exg	d2,d3
	bra.s	df_calc
df_xg:	move.w	d2,d1
	beq	nodrawf
df_calc:
	btst	#6,dmaconr+custom
	bne.s	df_calc
;	clr.b	(a0)
	bsr	demotasks
	move.l	a0,bltcpth+custom
	move.l	a0,bltdpth+custom
	moveq	#0,d6
	move.b	ft_octs(pc,d0.w),d6
	bra.s	df_skip

ft_octs:
	dc.b	%0011011,%0000111,%0001111,%0011111
	dc.b	%0010111,%0001011,%0000011,%0010011

df_skip:
	addq.w	#1,d1
	lsl.w	#6,d1
	addq	#2,d1
g_wb3:
	btst	#6,dmaconr+custom
	bne.s	g_wb3

	move.w	d4,bltcon0+custom
	move.w	spare_width,bltcmod+custom
	move.w	spare_width,bltdmod+custom
	move.w	#%1000000000000000,bltadat+custom
	move.w	#$ffff,bltbdat+custom
	move.w	d3,d0
	lsl.w	#1,d0
	sub.w	d2,d0
	bge.s	df_nosign
	or.w	#$40,d6
df_nosign:
	move.w	d6,bltcon1+custom
	move.w	d0,bltaptl+custom
	lsl.w	#2,d3
	move.w	d3,bltbmod+custom
	sub.w	d2,d0
	lsl.w	#1,d0
	move.w	d0,bltamod+custom
	move.w	d1,bltsize+custom	*Trigger blit!

;	move.b	#-1,(a0)
nodrawf:
	rts

firstpoint:
	dc.w	0,0,0,0,0

spare_width:	dc.w	0



******************************************************
* DRAW  FILLED QUADRILATERAL,INC ANTICLOCKWISE CHECK *
******************************************************


fillfaceq:		*(d0,d1)-(d2,d3)-(d4,d5) in colour d6
	movem.l	a5/a6/d7,-(sp)
	move.w	d0,a6		*Store values...
	move.w	d1,a1
	move.w	d2,a2
	move.w	d3,a3
	move.w	d4,a4
	move.w	d5,a5
	
	sub.w	d2,d4		*Make vectors...
	sub.w	d3,d5		(d2,d3)=a
	sub.w	d0,d2		(d4,d5)=b
	sub.w	d1,d3

	muls	d2,d5
	muls	d3,d4
	sub.l	d5,d4
	bpl	dft_nodrawt

	move.w	a6,d0		* Min X
	cmp.w	a2,d0
	blt.s	dfq_1
	move.w	a2,d0
dfq_1:
	cmp.w	a4,d0
	blt.s	dfq_2
	move.w	a4,d0
dfq_2:
	cmp.w	txq,d0
	blt.s	dfq_2a
	move.w	txq,d0
dfq_2a:
	move.w	a1,d1		* Min y
	cmp.w	a3,d1
	blt.s	dfq_3
	move.w	a3,d1
dfq_3:
	cmp.w	a5,d1
	blt.s	dfq_4
	move.w	a5,d1
dfq_4:
	cmp.w	tyq,d1
	blt.s	dfq_4a
	move.w	tyq,d1
dfq_4a:
	move.w	a6,d2		* Max X
	cmp.w	a2,d2
	bgt.s	dfq_5
	move.w	a2,d2
dfq_5:
	cmp.w	a4,d2
	bgt.s	dfq_6
	move.w	a4,d2
dfq_6:
	cmp.w	txq,d2
	bgt.s	dfq_6a
	move.w	txq,d2
dfq_6a:
	move.w	a1,d3		* Max y
	cmp.w	a3,d3
	bgt.s	dfq_7
	move.w	a3,d3
dfq_7:
	cmp.w	a5,d3
	bgt.s	dfq_8
	move.w	a5,d3
dfq_8:
	cmp.w	tyq,d3
	bgt.s	dfq_8a
	move.w	tyq,d3
dfq_8a:
	sub.w	#16,d0
	sub.w	d0,a6		* Make co-ords relative...
	sub.w	d0,a2
	sub.w	d0,a4
	sub.w	d0,txq
	sub.w	d1,a1
	sub.w	d1,a3
	sub.w	d1,a5
	sub.w	d1,tyq
	move.w	d3,maxy
	
	sub.w	d0,d2
	sub.w	d1,d3
	
	addq.w	#1,d3
	lsr.w	#3,d2		; Width
	and.l	#$fffe,d2
	addq	#4,d2
	move.w	d2,spare_width

	move.w	d0,d4		; Shift
	and.w	#$f,d4
	ror.w	#4,d4

	lsr.w	#3,d0
	and.l	#$fffe,d0
	mulu	#40,d1
	add.l	d1,d0
	add.l	bitmap1_ptr,d0	; D0= Screen address

	move.l	spare_ptr,d1

	move.w	d3,d5
	lsl.w	#7,d3
	add.w	d2,d3
	lsr.w	#1,d3		; D3= Blit size

ffq_wb1:
	btst	#6,dmaconr+custom
	bne.s	ffq_wb1
	move.w	#0,bltcon1+custom
	move.w	#$0100,bltcon0+custom
	move.w	#0,bltdmod+custom
	move.l	d1,bltdpth+custom
	move.w	d3,bltsize+custom

	movem.l	d0/d1,-(sp)
	movem.w	d2-d6,-(sp)

dfq_dodrawt				*Draw the edges...
	move.w	a6,d0
	move.w	a1,d1
	move.w	a2,d2
	move.w	a3,d3
	bsr	draw_fill		*(d0,d1)->(d2,d3)
	move.w	a2,d0
	move.w	a3,d1
	move.w	a4,d2
	move.w	a5,d3
	bsr	draw_fill		*(d2,d3)->(d4,d5)
	move.w	a4,d0
	move.w	a5,d1
	move.w	txq,d2
	move.w	tyq,d3
	bsr	draw_fill		*(d2,d3)->(tx,ty)
	move.w	txq,d0
	move.w	tyq,d1
	move.w	a6,d2
	move.w	a1,d3
	bsr	draw_fill		*(tx,ty)->(d0,d1)

	bra	fft_entry

*************************************************
* DRAW  FILLED TRIANGLE,INC ANTICLOCKWISE CHECK *
*************************************************

fillfacet:		*(d0,d1)-(d2,d3)-(d4,d5) in colour d6
	movem.l	a5/a6/d7,-(sp)
	move.w	d0,a6		*Store values...
	move.w	d1,a1
	move.w	d2,a2
	move.w	d3,a3
	move.w	d4,a4
	move.w	d5,a5
	
	sub.w	d2,d4		*Make vectors...
	sub.w	d3,d5		(d2,d3)=a
	sub.w	d0,d2		(d4,d5)=b
	sub.w	d1,d3

	muls	d2,d5
	muls	d3,d4
	sub.l	d5,d4
	bpl	dft_nodrawt

	move.w	a6,d0		* Min X
	cmp.w	a2,d0
	blt.s	dft_1
	move.w	a2,d0
dft_1:
	cmp.w	a4,d0
	blt.s	dft_2
	move.w	a4,d0
dft_2:
	move.w	a1,d1		* Min y
	cmp.w	a3,d1
	blt.s	dft_3
	move.w	a3,d1
dft_3:
	cmp.w	a5,d1
	blt.s	dft_4
	move.w	a5,d1
dft_4:
	move.w	a6,d2		* Max X
	cmp.w	a2,d2
	bgt.s	dft_5
	move.w	a2,d2
dft_5:
	cmp.w	a4,d2
	bgt.s	dft_6
	move.w	a4,d2
dft_6:
	move.w	a1,d3		* Max y
	cmp.w	a3,d3
	bgt.s	dft_7
	move.w	a3,d3
dft_7:
	cmp.w	a5,d3
	bgt.s	dft_8
	move.w	a5,d3
dft_8:
	sub.w	#16,d0
	sub.w	d0,a6		* Make co-ords relative...
	sub.w	d0,a2
	sub.w	d0,a4
	sub.w	d1,a1
	sub.w	d1,a3
	sub.w	d1,a5
	move.w	d3,maxy
	
	sub.w	d0,d2
	sub.w	d1,d3
	
	addq.w	#1,d3
	lsr.w	#3,d2		; Width
	and.l	#$fffe,d2
	addq	#4,d2
	move.w	d2,spare_width

	move.w	d0,d4		; Shift
	and.w	#$f,d4
	ror.w	#4,d4

	lsr.w	#3,d0
	and.l	#$fffe,d0
	mulu	#40,d1
	add.l	d1,d0
	add.l	bitmap1_ptr,d0	; D0= Screen address

	move.l	spare_ptr,d1

	move.w	d3,d5
	lsl.w	#7,d3
	add.w	d2,d3
	lsr.w	#1,d3		; D3= Blit size

fft_wb1:
	btst	#6,dmaconr+custom
	bne.s	fft_wb1
	move.w	#0,bltcon1+custom
	move.w	#$0100,bltcon0+custom
	move.w	#0,bltdmod+custom
	move.l	d1,bltdpth+custom
	move.w	d3,bltsize+custom

	movem.l	d0/d1,-(sp)
	movem.w	d2-d6,-(sp)

dft_dodrawt				*Draw the edges...
	move.w	a6,d0
	move.w	a1,d1
	move.w	a2,d2
	move.w	a3,d3
	bsr	draw_fill		*(d0,d1)->(d2,d3)
	move.w	a4,d0
	move.w	a5,d1
	move.w	a6,d2
	move.w	a1,d3
	bsr	draw_fill		*(d4,d5)->(d0,d1
	move.w	a2,d0
	move.w	a3,d1
	move.w	a4,d2
	move.w	a5,d3
	bsr	draw_fill		*(d2,d3)->(d4,d5)

fft_entry:
	movem.w	(sp)+,d2-d6
	movem.l	(sp)+,d0/d1

					* DO AREA FILL...
fft_wb3:
	btst	#6,dmaconr+custom
	bne.s	fft_wb3
	move.w	#0,bltamod+custom
	move.w	#0,bltdmod+custom
	move.w	#$09f0,bltcon0+custom
	move.w	#%01010,bltcon1+custom
	cmp.w	#4,d5
	ble.s	fft_dontfill
	subq.w	#1,d5
	mulu	d2,d5
	add.l	d1,d5
	subq.l	#2,d5
	move.l	d5,bltapth+custom
	move.l	d5,bltdpth+custom
	sub.w	#%10000000,d3
	move.w	d3,bltsize+custom
	add.w	#%10000000,d3
fft_dontfill:
	neg.w	d2
	add.w	#40,d2
fft_wb2:
	btst	#6,dmaconr+custom
	bne.s	fft_wb2
	move.w	spare_width,bltamod+custom	

	move.w	d2,bltcmod+custom
	move.w	d2,bltdmod+custom
	or.w	#$bca,d4
	move.w	d4,bltcon0+custom
	move.w	#0,bltcon1+custom
	move.w	#0,bltamod+custom
	moveq	#3,d7
	and.w	#$f,d6
	lsl.w	#3,d6
	lea	patterns(pc,d6.w),a1
	move.w	texture,d4
fft_blitloop:
	btst	#6,dmaconr+custom
	bne.s	fft_blitloop
	move.w	(a1)+,d6
	and.w	d4,d6
	move.w	d6,bltbdat+custom
	move.l	d0,bltcpth+custom
	move.l	d0,bltdpth+custom
	move.l	d1,bltapth+custom
	move.w	d3,bltsize+custom
	add.l	#plsize,d0
	dbra	d7,fft_blitloop
dft_nodrawt:
	movem.l	(sp)+,a5/a6/d7
	rts

patterns:
	dc.w	 0, 0, 0, 0
	dc.w	-1, 0, 0, 0
	dc.w	 0,-1, 0, 0
	dc.w	-1,-1, 0, 0
	dc.w	 0, 0,-1, 0
	dc.w	-1, 0,-1, 0
	dc.w	 0,-1,-1, 0
	dc.w	-1,-1,-1, 0
	dc.w	 0, 0, 0,-1
	dc.w	-1, 0, 0,-1
	dc.w	 0,-1, 0,-1
	dc.w	-1,-1, 0,-1
	dc.w	 0, 0,-1,-1
	dc.w	-1, 0,-1,-1
	dc.w	 0,-1,-1,-1
	dc.w	-1,-1,-1,-1


******************
* DATA,WORKSPACE *
******************

xangle	dc.w	0
yangle	dc.w	0
zangle	dc.w	0
xavel	dc.w	0
yavel	dc.w	0
zavel	dc.w	0
xpos	dc.w	0
ypos	dc.w	0
zpos	dc.w	512
xvel	dc.w	0
yvel	dc.w	0
zvel	dc.w	0

txq:	dc.w	0
tyq	dc.w	0

xc	equ	160	*Centre of perspective projection
yc	equ	128
zc	equ	-640

xptr	equ	0
yptr	equ	2
zptr	equ	4

*************************************
*	MAIN LOOP SUBROUTINES	    *
*************************************

*************************
*			*
*	MOVE SPRITE 	*
*			*
*************************

move_sprite:				*moves sprite
	move.l	sprites_ptr,a6
	lsl.w	#8,d2
	lea	(a6,d2.w),a6
move_reuse:
	add.w	#$81,d0		*value=height/2
	add.w	#$2c,d1
	move.w	d1,d2
	lsl.w	#8,d2
	roxl.b	#2,d2
	add.w	#16,d1			*value-height of sprites
	move.w	d1,d3
	lsl.w	#8,d3
	roxl.b	#1,d3
	or.b	d2,d3
	lsr.w	#1,d0
	move.b	d0,d2
	roxl.b	#1,d3
	or.w	#128,d3
	movem.w	d2-d3,(a6)
	rts

****************************************

rotate_flag:
	dc.w	0

move_pointer:
	clr.w	rotate_flag
	btst	#6,$bfe001
	beq.s	button_pressed
	bsr	getmouse
	add.w	px,d0
	bpl.s	mp1
	moveq	#0,d0
mp1:	cmp.w	#319,d0
	bmi.s	mp2
	move.w	#319,d0
mp2:
	add.w	py,d1
	bpl.s	mp3
	moveq	#0,d1
mp3:	cmp.w	#63,d1
	bmi.s	mp4
	move.w	#63,d1
mp4:
	movem.w	d0/d1,px
	moveq	#0,d2
	bsr	move_sprite
	movem.w	px,d0/d1
	moveq	#1,d2
	bsr	move_sprite
mp_ret:
	rts

button_pressed:
	move.w	px,d0
	sub.w	#235,d0
	bmi.s	mp_ret
	cmp.w	#48,d0
	bpl.s	mp_ret
	move.w	py,d1
	cmp.w	#32,d1
	bpl.s	mp_ret
	lsr.w	#4,d0
	lsr.w	#4,d1
	mulu	#3,d1
	add.w	d1,d0
	move.w	d0,d2
	lsl.w	#2,d2
	bsr	getmouse
	move.l	icon_table(pc,d2.w),a0
	jmp	(a0)

icon_table:
	dc.l	i_nextobject
	dc.l	i_lastobject
	dc.l	i_rotate
	dc.l	i_inout
	dc.l	i_move
	dc.l	i_quit


i_nextobject:
	move.w	#$c,ocount
	rts
i_lastobject:
	move.w	#$c,ocount
	sub.w	#2,object
	rts
i_rotate:
	add.w	xangle,d0
	add.w	zangle,d1
	and.w	#$ff,d0
	and.w	#$ff,d1
	move.w	d0,xangle
	move.w	d1,zangle
	move.w	#-1,rotate_flag
	rts

i_inout:
	bsr	getmouse
	neg.w	d1
	add.w	zpos,d1
ld_1:	cmp.w	#400,d1
	bhi.s	ld0
	move.w	#400,d1
ld0:
	move.w	d1,zpos
	rts
i_move:
	add.w	xpos,d0
	cmp.w	#80,d0
	blt.s	i_m1
	move.w	#80,d0
i_m1:	cmp.w	#-80,d0
	bgt.s	i_m2
	move.w	#-80,d0
i_m2:
	move.w	d0,xpos

	add.w	ypos,d1
	cmp.w	#80,d1
	blt.s	i_m3
	move.w	#80,d1
i_m3:	cmp.w	#-80,d1
	bgt.s	i_m4
	move.w	#-80,d1
i_m4:

	move.w	d1,ypos
	rts
i_quit:
	move.w	#-1,ret_flag
	rts

ret_flag:	dc.w	0
px:	dc.w	0
py:	dc.w	0


****************************************

************************************

scroll_bar:
	move.w	#0,bltalwm+custom
	move.l	nextlt_ptr,a0
	cmp.b	#100,(a0)
	beq.s	noplot
	move.w	#-1,bltalwm+custom
	move.l	scrollbuffer_ptr(pc),a1
	lea	2(a1),a0
s_wait:	btst	#6,dmaconr+custom
	bne.s	s_wait
	move.w	#%1100100111110000,bltcon0+custom
	move.w	#0,bltcon1+custom
	move.w	#0,bltamod+custom
	move.w	#0,bltdmod+custom
	move.w	#%0000111111111111,bltafwm+custom
	move.w	#3,d0		*Loop to blit 4 planes
s_blit:
	btst	#6,dmaconr+custom
	bne.s	s_blit
	move.l	a0,bltapth+custom
	move.l	a1,bltdpth+custom
	move.w	#(64*lty)+(bufferwidth/2),bltsize+custom
	lea	buffersize(a0),a0
	lea	buffersize(a1),a1
	dbra	d0,s_blit
noplot:
	move.w	#-1,bltafwm+custom
	rts

*************************************

delay:					*Wait for start of vertical blank	
	btst	#4,intreqr+1+custom
	beq.s	delay
	move.w	#$10,intreq+custom
	rts

*****************************************

getmouse:
	move.w	joy0dat+custom,d0
	sub.w	omouse,d0
	move.w	d0,d1
	lsr.w	#8,d1
	ext.w	d0
	ext.w	d1
	rts

*****************************************

flipframe:
	btst	#4,intreqr+1+custom
	beq.s	flipframe
	
	bsr	demotasks

	move.l	bitmap_ptr(pc),d1
	move.l	copscr2_ptr(pc),a0
	eor.w	#1,frame
	cmp.w	#1,frame
	beq.s	flipframe2

	add.l	#plwidth*48,d1
	move.w	#$00E0,d0		*Set bitplane pointer for main screen
	move.l	#plsize,d2
	moveq	#3,d7

	bsr	setcopperpointers
	sub.l	#plwidth*48,d1
	move.l	d1,bitmap1_ptr
	rts
flipframe2:
	move.l	d1,bitmap1_ptr
	add.l	#plsize*4+plwidth*48,d1
	move.l	a0,copscr2_ptr
	move.w	#$00E0,d0		*Set bitplane pointer for main screen
	move.l	#plsize,d2
	moveq	#3,d7
	bsr	setcopperpointers
	rts

*****************************************
*	SETUP SUBROUTINES          	*
*****************************************

**********************************


set_sprites
	lea	pointer0+4,a0
	moveq	#0,d2
	bsr	sprite_image
	lea	pointer1+4,a0
	moveq	#1,d2
	bsr	sprite_image
	rts

pointer0:
	dc.w	$0000,$0000
	dc.w	$0000,$0000
	dc.w	$6000,$2000
	dc.w	$3000,$6000
	dc.w	$7800,$7000
	dc.w	$7C00,$1800
	dc.w	$1E00,$4E00
	dc.w	$6C00,$4A00
	dc.w	$6B80,$7200
	dc.w	$3940,$7EC0
	dc.w	$57E0,$4FE0
	dc.w	$34C0,$33C0
	dc.w	$4B00,$0400
	dc.w	$2400,$5480
	dc.w	$0200,$0100
	dc.w	$0380,$0280
	dc.w	$0000,$0000
	dc.w	$0000,$0000

pointer1:
	dc.w	$0000,$0000
	dc.w	$6000,$6000
	dc.w	$9000,$9000
	dc.w	$A800,$A800
	dc.w	$B400,$B400
	dc.w	$DA00,$9A00
	dc.w	$ED00,$8D00
	dc.w	$F180,$8080
	dc.w	$FCC0,$8040
	dc.w	$FFE0,$8020
	dc.w	$BFF0,$8010
	dc.w	$CFE0,$8020
	dc.w	$FFC0,$80C0
	dc.w	$FFC0,$8840
	dc.w	$76C0,$7440
	dc.w	$0640,$0440
	dc.w	$0380,$0380
	dc.w	$0000,$0000



*********************************

sprite_image:	;(A0 = source image data, D2 = dest. sprite number)
	lsl.w	#8,d2
	move.l	sprites_ptr,a1
	lea	4(a1,d2.w),a1
	move.w	#15,d7
sprite_iloop:
	move.l	(a0)+,d0
	move.l	d0,68(a1)	* Set re-use
	move.l	d0,136(a1)	* Set re-use
	move.l	d0,(a1)+
	dbra	d7,sprite_iloop
	rts
	

***********************************

randomize:			* Get random number in range 0-D5
	ror.l	#3,d7		* Ranndomize D7
	swap	d7
	rol.w	#2,d7
	eor.w	d6,d7
	swap	d6
	rol.w	#4,d6
	sub.l	d7,d6
	ror.l	#7,d6
	mulu	d7,d5		* Get number to correct range in d5
	asr.l	#8,d5
	asr.l	#8,d5		* Done!!!
	rts
	

************************************

set_stars:
	move.l	#$12345678,d6	* Set random seeds...
	move.l	#$abcdefed,d7
	lea	stdata,a0
	move.w	#no_stars-1,d4
sstloop:
	move.w	#320,d5		* X
	bsr	randomize
	sub.w	#160,d5
	move.w	d5,(a0)+
	move.w	#160,d5		* Y
	bsr	randomize
	sub.w	#80,d5
	move.w	d5,(a0)+
	move.w	#768,d5		* Z
	bsr	randomize
	add.w	#256,d5
	move.w	d5,(a0)+	
	dbra	d4,sstloop
	rts

************************************



*********************************************

colmap:
	dc.w	$000,$fff,$ccc,$999,$777,$555
	dc.w	$f32,$c31,$921,$720,$510
	dc.w	$58f,$46d,$34c,$22b,$119

setcopper:
	move.l	copperlist_ptr(pc),a0
	move.l	#$01800000,(a0)+
	move.w	#$0120,d0		*Set sprite pointers:
	move.l	sprites_ptr,d1
	move.l	#$100,d2
	moveq	#7,d7
	bsr	setcopperpointers

	move.l	#bplcon0*$10000+$5200,(a0)+
	move.w	#$00E0,d0		*Set bitplane pointers for Icon Panel
	move.l	#pic,d1
	move.l	#plwidth*64,d2
	moveq	#4,d7
	bsr	setcopperpointers
	move.l	a0,coppal
	moveq	#31,d7
	lea	pic+plwidth*5*64,a1
	bsr	setcopperpalette

	move.w	#bpl1mod,(a0)+
	move.w	#0,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#0,(a0)+

	move.l	#$3401fffe,d1
	move.l	#$02000000,d2
	move.w	#color16,d0
	moveq	#23,d7
	lea	greet_cols,a1
	bsr	setcopperbar

	move.l	#$6c01fffe,(a0)+
	move.l	a0,copscr2_ptr
	move.w	#$00E0,d0		*Set bitplane pointers for main screen
	move.l	bitmap2_ptr(pc),d1
	add.l	#48*plwidth,d1
	move.l	#plsize,d2
	moveq	#3,d7
	bsr	setcopperpointers

	move.w	#bplcon0,(a0)+
	move.w	#$4200,(a0)+

	moveq	#15,d7
	lea	colmap,a1
	bsr	setcopperpalette

	move.l	#$ff09fffe,(a0)+
	move.l	#$ffddfffe,(a0)+

	move.l	#$0c01fffe,(a0)+

	move.w	#$00E0,d0		*Set bitplane pointers for scroll text
	move.l	scrollbuffer_ptr(pc),d1
	move.l	#buffersize,d2
	moveq	#3,d7
	bsr	setcopperpointers
	move.l	#$0182014d,(a0)+
	move.w	#bplcon0,(a0)+
	move.w	#$4200,(a0)+
	move.w	#bpl1mod,(a0)+
	move.w	#bufferwidth-plwidth,(a0)+
	move.w	#bpl2mod,(a0)+
	move.w	#bufferwidth-plwidth,(a0)+

;	lea	font_data+fontplsize*4,a1
;	moveq	#31,d7
;	bsr	setcopperpalette
	
	move.l	#$1c01fffe,(a0)+	* Wait for end of display
	move.w	#intreq,(a0)+
	move.w	#%1000000000010000,(a0)+


	move.l	#$FFFFFFFE,(a0)+	*End copper list
	clr.w	$dff180
	move.w	#$8cf,$dff182
	rts

coppal:	dc.l	0

greet_cols:
	dc.w	$080,$090,$0a0,$0b0,$0c0,$1d1,$2e2,$3f3
	dc.w	$4f4,$5f5,$6f6,$7f7,$8f8,$9f9,$afa,$bfb
	dc.w	$cfc,$dfd,$efe,$dfd,$efe,$fff,$fff,$fff
	dc.w	$afa,$9f9,$8f8,$7f7,$6f6,$5f5,$4f4,$3f3

************************

setcopperpointers:
	move.w	d0,(a0)+
	add.w	#2,d0
	swap	d1
	move.w	d1,(a0)+
	move.w	d0,(a0)+
	add.w	#2,d0
	swap	d1
	move.w	d1,(a0)+
	add.l	d2,d1
	dbra	d7,setcopperpointers
	rts

setcopperbar:
	move.l	d1,(a0)+
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	add.l	d2,d1
	dbra	d7,setcopperbar
	rts

setcopperpalette:
	move.w	#$0180,d0
.setcopperpalette
	move.w	d0,(a0)+
	move.w	(a1)+,(a0)+
	addq	#2,d0
	dbra	d7,.setcopperpalette
	rts

*****************************************

setscreen:
	clr.w	bplcon1+custom
	move.w	#$0038,ddfstrt+custom
	move.w	#$00d0,ddfstop+custom
	move.w	#$2C81,diwstrt+custom
	move.w	#$1CC1,diwstop+custom
	move.w	#$FFFF,bltafwm+custom
	move.w	#$FFFF,bltalwm+custom
	rts

*****************************************

allocate:
	move.l	#(plsize*8)+(buffersize*4)+(coppersize)+(spritesize*8)+(plsize),d0
	move.l	#chip+clear,d1
	move.l	execbase,a6
	jsr	allocmem(a6)
	

	lea	bitmap_ptr(pc),a0
	move.l	d0,(a0)+
	move.l	d0,(a0)+		*Bitmap 1 pointer
	add.l	#plsize*4,d0
	move.l	d0,(a0)+
	add.l	#plsize*4,d0
	move.l	d0,(a0)+		*Scroll buffer pointer
	add.l	#buffersize*4,d0
	move.l	d0,(a0)+		*Copperlist pointer
	add.l	#coppersize,d0
	move.l	d0,(a0)+		*Sprite pointer
	add.l	#spritesize*8,d0
	move.l	d0,spare_ptr

	rts

*****************************************

deallocate:
	move.l	#(plsize*8)+(buffersize*4)+(coppersize)+(spritesize*8)+(plsize),d0
	move.l	bitmap_ptr(pc),a1
	move.l	execbase,a6
	jsr	freemem(a6)
	rts

*****************************************		

startup:
	move.l	copperlist_ptr(pc),a0
	move.l	a0,cop1lc+custom	*Tell system where copper is
	move.w	copjmp1+custom,d0	*And start it
	move.w	#0,$dff1fc	; reset AGA
	move.w	#$87e0,dmacon+custom	*Enable Dma.

	move.w	#40-12,bltdmod+custom
	move.l	#pic+4+plwidth*8,bltdpth+custom
	move.w	#$0100,bltcon0+custom
	move.w	#0,bltcon1+custom
	move.w	#(64*48)+6,bltsize+custom
g_wb4:
	btst	#6,dmaconr+custom
	bne.s	g_wb4

	rts

*****************************************


killsystem:
	move.l	execbase,a6			*Get pointer to EXEC
	lea	gfxname(pc),a1
	moveq	#0,d0
	jsr	openlib(a6)		*Openoldlibrary
	move.l	d0,a1
	move.l	38(a1),syscop
	move.w	intenar+custom,d0
	or.w	#$8000,d0
	move.w	d0,interrupts
	move.w	dmaconr+custom,d0
	or.w	#$8000,d0
	move.w	d0,dmacontrol

	move.w	#$7fff,intena+custom	*All interrupts off
	move.w	#$7fff,dmacon+custom	*All dma off
	rts

*****************************************

revivesystem:
	move.l	execbase,a6

	move.w	dmacontrol(pc),dmacon+custom
	move.w	interrupts(pc),intena+custom
	move.w	#$7fff,intreq+custom
	clr.w	aud0vol+custom
	clr.w	aud1vol+custom
	clr.w	aud2vol+custom
	clr.w	aud3vol+custom

	move.l	syscop(pc),d0
	move.l	d0,cop1lc+custom

	move.l	execbase,a6			*Get pointer to EXEC 
	lea	intname(pc),a1
	moveq	#0,d0
	jsr	-552(a6)
	move.l	d0,a6
	jsr	-390(a6)
	rts

************************************
*         EQUATES                     *
***************************************


* HARDWARE REGISTERS *

custom 	EQU $dff000
bltddat	EQU $000
dmaconr	EQU $002
vposr	EQU $004
vhposr	EQU $006
dskdatr	EQU $008
joy0dat	EQU $00A
joy1dat	EQU $00C
clxdat	EQU $00E
adkconr	EQU $010
pot0dat	EQU $012
pot1dat	EQU $014
potinp	EQU $016
serdatr	EQU $018
dskbytr	EQU $01A
intenar	EQU $01C
intreqr	EQU $01E
dskpt	EQU $020
dsklen	EQU $024
dskdat	EQU $026
refptr	EQU $028
vposw	EQU $02A
vhposw	EQU $02C
copcon	EQU $02E
serdat	EQU $030
serper	EQU $032
potgo	EQU $034
joytest	EQU $036
strequ	EQU $038
strvbl	EQU $03A
strhor	EQU $03C
strlong	EQU $03E
bltcon0	EQU $040
bltcon1	EQU $042
bltafwm	EQU $044
bltalwm	EQU $046
bltcpth	EQU $048
bltbpth	EQU $04C
bltapth	EQU $050
bltaptl	EQU $052
bltdpth	EQU $054
bltsize	EQU $058
bltcmod	EQU $060
bltbmod	EQU $062
bltamod	EQU $064
bltdmod	EQU $066
bltcdat	EQU $070
bltbdat	EQU $072
bltadat	EQU $074
dsksync	EQU $07E
cop1lc	EQU $080
cop2lc	EQU $084
copjmp1	EQU $088
copjmp2	EQU $08A
copins	EQU $08C
diwstrt	EQU $08E
diwstop	EQU $090
ddfstrt	EQU $092
ddfstop	EQU $094
dmacon	EQU $096
clxcon	EQU $098
intena	EQU $09A
intreq	EQU $09C
adkcon	EQU $09E
aud0lc	EQU $0A0
aud1lc	EQU $0b0
aud2lc	EQU $0c0
aud3lc	EQU $0d0
aud0len	EQU $a4
aud1len	EQU $b4
aud2len	EQU $c4
aud3len	EQU $d4
aud0per	EQU $a6
aud1per	EQU $b6
aud2per	EQU $c6
aud3per	EQU $d6
aud0vol	EQU $a8
aud1vol	EQU $b8
aud2vol	EQU $c8
aud3vol	EQU $d8
aud0dat	EQU $aa
aud1dat	EQU $ba
aud2dat	EQU $ca
aud3dat	EQU $da
bpl1pth	EQU $0E0
bpl2pth	EQU $0E4
bpl3pth	EQU $0E8
bpl4pth	EQU $0EC
bpl5pth	EQU $0F0
bpl6pth	EQU $0F4
bplcon0	EQU $100
bplcon1	EQU $102
bplcon2	EQU $104
bpl1mod	EQU $108
bpl2mod	EQU $10A
bpldat	EQU $110
sprpt	EQU $120
spr	EQU $140
sd_pos	EQU $00
sd_ctl	EQU $02
sd_dataa 	EQU $04
sd_datab 	EQU $08
color00	EQU $180
color01	EQU $182
color02	EQU $184
color03	EQU $186
color04	EQU $188
color05	EQU $18a
color06	EQU $18c
color07	EQU $18e
color08	EQU $190
color09	EQU $192
color10	EQU $194
color11	EQU $196
color12	EQU $198
color13	EQU $19a
color14	EQU $19c
color15	EQU $19e
color16	EQU $1a0
color17	EQU $1a2
color18	EQU $1a4
color19	EQU $1a6
color20	EQU $1a8
color21	EQU $1aa
color22	EQU $1ac
color23	EQU $1ae
color24	EQU $1b0
color25	EQU $1b2
color26	EQU $1b4
color27	EQU $1b6
color28	EQU $1b8
color29	EQU $1ba
color30	EQU $1bc
color31	EQU $1be
diskreg	EQU $bfd100
skeys	EQU $bfec01



* EXEC LIBRARY *

execbase	equ	4
openlib		equ	-30-378
closelib	equ	-414
forbid		equ	-132
permit		equ	-138
allocmem	equ	-198
allocabs	equ	-204
freemem		equ	-210
chip		equ	$2
clear		equ	$10000

* DOS LIBRARY *

mode_old	equ	1005
mode_new	equ	1006
read		equ	-42
write		equ	-48

* PROGRAM EQUATES *

ltx		equ	2	*In BYTES
lty		equ	16
plwidth		equ	40
plsize		equ	plwidth*256
bufferwidth	equ	plwidth+ltx
buffersize	equ	bufferwidth*(lty+4)
coppersize	equ	8192
spritesize	equ	256
fontplwidth	equ	32	
fontplsize	equ	fontplwidth*5*lty
picplsize	equ	40*62

***************************************
*         DATA                        *
***************************************

* WORKSPACE FOR MAIN PROGRAM *

styvel	dc.w	0
texture	dc.w	$8000
linesize	dc.w	-1
object	dc.w	0
cycle	dc.w	0
old_y	dc.w	0
omouse	dc.w	0
wobx	dc.w	0
size	dc.w	16
svel	dc.w	0
frame	dc.w	0
rcount	dc.w	0
count	dc.w	0
ocount	dc.w	0
stdata	ds.w	no_stars*3

* POINTERS TO ALLOCATED MEMORY,ETC *

bitmap_ptr		dc.l	0
bitmap1_ptr		dc.l	0
bitmap2_ptr		dc.l	0
scrollbuffer_ptr	dc.l	0
copperlist_ptr		dc.l	0
sprites_ptr		dc.l	0
spare_ptr		dc.l	0
equbar_ptr		dc.l	0
wob_ptr			dc.l	0
nextlt_ptr		dc.l	0
copscr2_ptr		dc.l	0
point_data_ptr		dc.l	0
line_data_ptr		dc.l	0
face_data_ptr		dc.l	0
vtable_ptr		dc.l	0

* WORKSPACE FOR SETUP ROUTINES *

dosbase	dc.l 0
handle	dc.l 0
syscop 	dc.l 0

interrupts	dc.w 0
dmacontrol	dc.w 0


* LIBRARY NAMES *

intname	dc.b "intuition.library",0
gfxname	dc.b "graphics.library",0
dosrod	dc.b 'dos.library',0
	even


* BINARY DATA *

SDAT:	dc.w	032,134,221,331,013,167,218,395,071,162,238,354
	dc.w	023,188,234,314,054,125,278,394,069,123,293,346
	dc.w	032,134,221,331,013,167,218,395,071,162,238,354
	dc.w	023,188,234,314,054,125,278,394,069,123,293,346
	dc.w	032,134,221,331,013,167,218,395,071,162,238,354
	dc.w	023,188,234,314,054,125,278,394,069,123,293,346

sprite_data:	ds.b	$100*7
SPR7:	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.W	0,0,1,1,0,0,1,0,0,0,1,1,0,0,3,0
	DC.L	0
	

	even

cvectors:
	dc.w	$011,$101,$110,$001

coltb1:	dc.w	$f00,$f11,$f22,$f33,$f44,$f55,$f66,$f77
	dc.w	$f88,$f99,$faa,$fbb,$fcc,$fdd,$fee,$fff
	dc.w	$fff,$fee,$fdd,$fcc,$fbb,$faa,$f99,$f88
	dc.w	$f77,$f66,$f55,$f44,$f33,$f22,$f11,$f00
	

coltb2:	dc.w	$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999,$888
	dc.w	$777,$666,$555,$444,$333,$222,$111,$000

coltb3:	dc.w	$000,$fff,$fff,$fff,$eee,$eee,$ccc,$ccc
	dc.w	$aaa,$aaa,$888,$888,$666,$666,$444,$444

	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	
coltb4:
	dc.w	$aef,$bff,$cff,$dff,$eff
	dc.w	$fff,$ffe,$ffd,$ffc,$ffb,$ffa,$ff9,$ff8
	dc.w	$fe7,$fd6,$fc5,$fb4,$fa3,$f92,$f81,$f70
	dc.w	$e60,$d50,$c40,$b30,$a20,$910,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$000

coltb5:
	dc.w	$000,$000,$100,$200,$300,$400,$500,$600
	dc.w	$700,$800,$910,$a20,$b30,$c40,$d50,$e60
	dc.w	$f70,$f81,$f92,$fa3,$fb4,$fc5,$fd6,$fe7
	dc.w	$ff8,$ff9,$ffa,$ffb,$ffc,$ffd,$ffe,$fff
	dc.w	$fff,$ffe,$ffd,$ffc,$ffb,$ffa,$ff9,$ff8
	dc.w	$fe7,$fd6,$fc5,$fb4,$fa3,$f92,$f81,$f70
	dc.w	$e60,$d50,$c40,$b30,$a20,$910,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$000
coltb5_end:
	dc.w	$000,$000,$100,$200,$300,$400,$500,$600
	dc.w	$700,$800,$910,$a20,$b30,$c40,$d50,$e60
	dc.w	$f70,$f81,$f92,$fa3,$fb4,$fc5,$fd6,$fe7
	dc.w	$ff8,$ff9,$ffa,$ffb,$ffc,$ffd,$ffe,$fff
	dc.w	$fff,$ffe,$ffd,$ffc,$ffb,$ffa,$ff9,$ff8
	dc.w	$fe7,$fd6,$fc5,$fb4,$fa3,$f92,$f81,$f70
	dc.w	$e60,$d50,$c40,$b30,$a20,$910,$800,$700
	dc.w	$600,$500,$400,$300,$200,$100,$000,$000



vtable:
	dc.w	0,3,0
	dc.w	2,1,1
	dc.w	2,0,2
	dc.w	0,2,1
	dc.w	2,3,0
	dc.w	1,1,2
	dc.w	0,3,0
	dc.w	1,2,0
	dc.w	-2,0,-2
	dc.w	2,2,0
	dc.w	1,2,1
	dc.w	0,3,-2
	dc.w	-1,3,0
	dc.w	-2,-2,0
	dc.w	3,0,0
endvtable:	


*****************************************
point_data0:		*DIAMOND
	dc.w	9
	dc.w	-80,-60,0, -60,-80,0, 60,-80,0, 80,-60,0
	dc.w	80,60,0,   60,80,0,   -60,80,0, -80,60,0
	dc.w	0,0,-40,     0,0,40

line_data0:
	dc.w	-1

face_data0:
	dc.w	15
	dc.w	0,1,8,1, 1,2,8,6, 2,3,8,2, 3,4,8,7, 4,5,8,3, 5,6,8,8, 6,7,8,2, 7,0,8,7
	dc.w	1,0,9,3, 2,1,9,8, 3,2,9,4, 4,3,9,9, 5,4,9,5, 6,5,9,10, 7,6,9,4, 0,7,9,9
	dc.w	-1

**********************************************
point_data1:		*MAMBA-ISH SHIP
	dc.w	17
	dc.w	0,0,-60,  -95,0,60,  -40,30,60,  40,30,60, 95,0,60
	dc.w	0,5,-40,  -20,25,40,  20,25,40
	dc.w	-50,5,60, 50,5,60,  30,25,60,  -30,25,60
	dc.w	-15,0,50,  -15,0,-30, -35,0,50,  15,0,50,  15,0,-30, 35,0,50

face_data1:
	dc.w	6
	dc.w	1,0,2,  2,0,3,  3,0,4,  4,0,1, 5,7,6, 12,13,14, 17,16,15
	dc.w	1
	dc.w	1,2,3,4,  11,10,9,8

line_data1
	dc.w	-1

**********************************************
point_data2:		* EQUALIZER
	dc.w	16
e1r:
 	dc.w	-30,0,0,  -10,0,0,  10,0,0,  30,0,0
	dc.w	-35,0,-5, -15,0,-5, 5,0,-5, 25,0,-5
	dc.w	-25,0,-5, -5,0,-5, 15,0,-5, 35,0,-5
	dc.w	-40,0,-10,  40,0,-10,  40,0,70,  -40,0,70
	dc.w	0,-40,0

face_data2:
	dc.w	7
	dc.w	16,12,15,   16,13,12,   16,15,14,   16,14,13
	dc.w	0,4,8,      1,5,9,      2,6,10,     3,7,11
	
	dc.w	0
	dc.w	12,13,14,15

line_data2:
	dc.w	-1

***********************************************

point_data3:		* ???
	dc.w	9
	dc.w	-40,-60,0,   40,-60,0,   60,0,0,   40,60,0,   -40,60,0,   -60,0,0
	dc.w	0,0,-20,     -40,-70,20,   40,-70,20,   0,40,20

line_data3:
	dc.w	-1

face_data3:
	dc.w	9
	dc.w	5,7,0,   1,8,2,   9,4,3,   7,9,8
	dc.w	5,0,6,   0,1,6,   1,2,6,   2,3,6,   3,4,6,   4,5,6
	dc.w	2
	dc.w	0,7,8,1,   9,3,2,8,   4,9,7,5
	
***********************************************
point_data4:		*PENCIL
	dc.w	12
	dc.w	-15,0,60,  -10,-15,60,  10,-15,60,  15,0,60,  10,15,60,  -10,15,60
	dc.w	-15,0,-60,  -10,-15,-60,  10,-15,-60,  15,0,-60,  10,15,-60,  -10,15,-60
	dc.w	0,0,-100

line_data4:
	dc.w	-1

face_data4:
	dc.w	5
	dc.w	6,7,12,   7,8,12,   8,9,12,   9,10,12,   10,11,12,   11,6,12
	dc.w	7
	dc.w	0,1,7,6,  1,2,8,7,  2,3,9,8,  3,4,10,9,  4,5,11,10,  5,0,6,11
	dc.w	3,2,1,0,  0,5,4,3

************************************************
point_data5:		* ??? v 2
	dc.w	8
	dc.w	-20,-60,0,   20,-60,0,   -40,-30,0,   40,-30,0,   -22,60,0,   22,60,0
	dc.w	-18,-40,20,   18,-40,20,  0,0,-10

line_data5:
	dc.w	-1

face_data5:
	dc.w	9
	dc.w	2,6,0,   7,3,1,   2,4,6,   5,3,7,   0,1,8,  1,3,8,  3,5,8,   5,4,8,   4,2,8,   2,0,8
	dc.w	1
	dc.w	0,6,7,1,  6,4,5,7

************************************************
	*FLOOR GRID:
point_data6:		* EQUALIZER
	dc.w	16
e2r:
 	dc.w	-30,0,0,  -10,0,0,  10,0,0,  30,0,0
	dc.w	-35,0,-5, -15,0,-5, 5,0,-5, 25,0,-5
	dc.w	-25,0,-5, -5,0,-5, 15,0,-5, 35,0,-5
	dc.w	-40,0,-10,  40,0,-10,  40,0,70,  -40,0,70
	dc.w	0,-40,0

face_data6:
	dc.w	7
	dc.w	16,12,15,   16,13,12,   16,15,14,   16,14,13
	dc.w	0,4,8,      1,5,9,      2,6,10,     3,7,11
	
	dc.w	0
	dc.w	12,13,14,15

line_data6:
	dc.w	-1

************************************************

point_data7:
	dc.w	23
	dc.w	-70,25,0,   -10,25,0,   -10,5,0,   40,5,0,   50,15,0,   10,15,0,   10,25,0,   70,25,0
	dc.w	40,-5,0,    60,-25,0,   50,-25,0,  30,-5,0,  20,-5,0,   20,-25,0,  10,-25,0,  10,-5,0
	dc.w	-10,-5,0,   -10,-25,0,  -20,-25,0, -20,15,0, -30,15,0,  -30,-25,0, -40,-25,0, -40,15,0
	dc.w	-60,15,0
line_data7:
	dc.w	23
	dc.w	0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,7, 7,8, 8,9, 9,10, 10,11, 11,12, 12,13
	dc.w	13,14, 14,15, 15,16, 16,17, 17,18, 18,19, 19,20, 20,21, 21,22, 22,23, 23,0
face_data7:
	dc.w	-1,-1

************************************************

point_data8:
	dc.w	31
	dc.w	-30,-65,-20,   30,-65,-20,   65,-30,-20,   65,30,-20
	dc.w	30,65,-20,     -30,65,-20,   -65,30,-20,   -65,-30,-20

	dc.w	-30,-65,20,   30,-65,20,   65,-30,20,   65,30,20
	dc.w	30,65,20,     -30,65,20,   -65,30,20,   -65,-30,20

	dc.w	-20,-50,0,    20,-50,0,     50,-20,0,    50,20,0
	dc.w	20,50,0,     -20,50,0,     -50,20,0,    -50,-20,0

	dc.w	-20,-20,-30,  20,-20,-30,  20,20,-30,   -20,20,-30
	dc.w	-20,-20,30,  20,-20,30,  20,20,30,   -20,20,30

line_data8:
	dc.w	-1
face_data8:
	dc.w	-1
	dc.w	29

	dc.w	16,17,9,8,8,   17,18,10,9,13,  18,19,11,10,9, 19,20,12,11,14
	dc.w	20,21,13,12,10, 21,22,14,13,15, 22,23,15,14,9, 23,16,8,15,14

	dc.w	0,1,17,16,7,    1,2,18,17,12,   2,3,19,18,8,   3,4,20,19,13
	dc.w	4,5,21,20,9,    5,6,22,21,14,   6,7,23,22,8,   7,0,16,23,13

	dc.w	28,29,25,24,2,    29,30,26,25,3,   30,31,27,26,4,   31,28,24,27,3
	dc.w	31,30,29,28,1,    24,25,26,27,5

	dc.w	8,9,1,0,6,     9,10,2,1,11,   10,11,3,2,7,   11,12,4,3,12
	dc.w	12,13,5,4,8,    13,14,6,5,13,   14,15,7,6,7,    15,8,0,7,12

************************************************

point_data9:
	dc.w	9
	dc.w	-30,40,0,   30,40,0,   70,-10,0,   70,-40,0
	dc.w	-70,-40,0,  -70,-10,0
	dc.w	-30,-20,-20, 30,-20,-20,  -30,-20,20,  30,-20,20

line_data9:
	dc.w	-1
face_data9:
	dc.w	9
	dc.w	6,4,8,  7,9,3
	dc.w	7,2,1,  1,2,9,     7,3,2,   2,3,9
	dc.w	4,6,5,  4,5,8,     5,6,0,   0,8,5
	dc.w	2
	dc.w	7,6,8,9,  6,7,1,0,   9,8,0,1


************************************************

point_data10:
	dc.w	14
	dc.w	-20,-10,-40,   20,-10,-40,   0,20,-40
	dc.w	-50,-30,-60,   -20,-30,-50,  20,-30,-50
	dc.w	50,-30,-60,    30,0,-50,     20,20,-50
	dc.w	0,50,-60,      -20,20,-50,   -30,0,-50
	dc.w	-10,-10,60,    10,-10,60,    0,10,60

line_data10:
	dc.w	-1
face_data10:
	dc.w	13
	dc.w	12,11,4,     7,13,5,    8,10,14,   2,0,1,  0,2,1
	dc.w	3,12,4,   11,12,3,      13,6,5,    13,7,6,   14,9,8,   14,10,9
	dc.w	3,4,11,   5,6,7,   10,8,9
	dc.w	-1

***********************************************

point_data11:
	dc.w	15
	dc.w	-20,-80,-5,    20,-80,-5,    -20,-60,-5,    20,-60,-5,   -80,20,0,    80,20,0
	dc.w	-80,50,0,     80,50,0,     -20,80,5,        20,80,5,     -20,0,15,    20,0,15
	dc.w	-20,40,15,    20,40,15,    -20,35,-10,      20,35,-10
line_data11:
	dc.w	-1
face_data11:
	dc.w	7
	dc.w	12,6,14,5,     13,15,7,5,    1,11,3,9,    2,10,0,9,    13,9,15,4,    8,12,14,4
	dc.w	3,11,5,7,      2,4,10,7
	dc.w	8
	dc.w	0,10,11,1,6,   10,12,13,11,7,   4,6,12,10,8,   11,13,7,5,8,   12,8,9,13,9
	dc.w	14,15,9,8,8,   0,1,15,14,9,     2,14,6,4,10,    3,5,7,15,10

***********************************************

point_data12:		; Another ELITE-ish ship...
	dc.w	11
	dc.w	-20,-60,0,     20,-60,0
	dc.w	-40,30,-10,    -40,30,10,    40,40,-10,    40,30,10
	dc.w	0,30,-20,      0,30,20
	dc.w	-20,70,-15,    -20,70,15,    20,70,-15,   20,70,15
line_data12:
	dc.w	-1

face_data12:
	dc.w	13
	dc.w	0,7,1,11,	0,3,7,12,	1,7,5,12,	7,9,11,14
	dc.w	3,9,7,13,	7,11,5,13
	dc.w	0,1,6,1,	0,6,2,2,	1,4,6,2,	6,10,8,4
	dc.w	2,6,8,3,	6,4,10,3
	dc.w	1,5,4,3,	2,3,0,3
	dc.w	3
	dc.w	4,5,11,10,14,	10,11,9,8,10,	8,9,3,2,14

***********************************************

object_list:
	dc.l	point_data8,line_data8,face_data8,0
	dc.l	point_data0,line_data0,face_data0,0
	dc.l	point_data12,line_data12,face_data12,0
	dc.l	point_data11,line_data11,face_data11,0


object_list_end:
	dc.l	point_data0,line_data0,face_data0,0
	dc.l	point_data11,line_data11,face_data11,0
	dc.l	point_data10,line_data10,face_data10,0
	dc.l	point_data8,line_data8,face_data8,0
	dc.l	point_data9,line_data9,face_data9,0
	dc.l	point_data1,line_data1,face_data1,0
	dc.l	point_data2,line_data2,face_data2,0
	dc.l	point_data3,line_data3,face_data3,0
	dc.l	point_data4,line_data4,face_data4,0
	dc.l	point_data5,line_data5,face_data5,0
	dc.l	point_data6,line_data6,face_data6,0
	dc.l	point_data7,line_data7,face_data7,0


no_objects	equ	4


************************************************

data_2d: 
	ds.l	64

dtable:
	ds.b	20*20

********************************************








********************************************

sine:
	dc.w	0,3,6,9,12,15,18,22
	dc.w	25,28,31,34,37,40,43,46
	dc.w	49,52,55,57,60,63,66,68
	dc.w	71,74,76,79,81,84,86,88
	dc.w	90,93,95,97,99,101,103,104
	dc.w	106,108,109,111,113,114,115,117
	dc.w	118,119,120,121,122,123,123,124
	dc.w	125,125,126,126,126,127,127,127,127
	ds.w	64*3-1
	ds.w	64*4
cosine:
	ds.w	256

	dc.w	$000,$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999
	dc.w	$888,$777,$666,$555,$444,$333,$222,$111
	dc.w	$000,$fea,$cb3,$870
	dc.w	$000,$fea,$cb3,$870
	dc.w	$000,$fea,$cb3,$870
	dc.w	$000,$fea,$cb3,$870

pulse_table:
	dc.w	$000,$001,$002,$003,$004,$005,$006,$007
	dc.w	$008,$009,$00a,$00b,$00c,$00d,$00e,$00f
	dc.w	$00f,$01f,$02f,$03f,$04f,$05f,$06f,$07f
	dc.w	$08f,$09f,$0af,$0bf,$0cf,$0df,$0ef,$0ff
	dc.w	$0ff,$1ff,$2ff,$3ff,$4ff,$5ff,$6ff,$7ff
	dc.w	$8ff,$9ff,$aff,$bff,$cff,$dff,$eff,$fff
	dc.w	$fff,$eee,$ddd,$ccc,$bbb,$aaa,$999,$888
	dc.w	$777,$666,$555,$444,$333,$222,$111,$000

pulse:	dc.w	0

	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	dc.w	$000,$afc,$7c3,$380
	
	dc.w	$340,$450,$340,$010
	dc.w	$450,$561,$450,$010
	dc.w	$560,$672,$560,$010
	dc.w	$670,$783,$670,$010

pic:
	incbin	"iconpanel.raw"
smallfont:
	incbin	"smallfont.raw"

