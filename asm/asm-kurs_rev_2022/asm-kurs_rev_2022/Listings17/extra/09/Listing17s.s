
; Listing17s.s = DC_intro032+.s		; A1200.config


	******************************************
	*					 *
	*	    © Dual Crew 1993	 	 *
	*					 *
	******************************************

*************>  Cøde :	Nzø
*************>	GFX  :	Red Devil
*************>	Music:	MutLeY

		Section	BauBau,Code_C

;		opt	c-,o+,w+

lines1		equ	180
lines2		equ	46
lines3		equ	17
lines4		equ	31

charhi		equ	16

music		equ	1
		

* blitter registers

bltcon0	equ	$40
bltcon1	equ	$42
bltafwm	equ	$44
bltalwm	equ	$46
bltcpth	equ	$48
bltcptl	equ	$4a
bltbpth	equ	$4c
bltbptl	equ	$4e
bltapth	equ	$50
bltaptl	equ	$52
bltdpth	equ	$54
bltdptl	equ	$56
bltsize	equ	$58
bltcmod	equ	$60
bltbmod	equ	$62
bltamod	equ	$64
bltdmod	equ	$66
bltcdat	equ	$70
bltbdat	equ	$72
bltadat	equ	$74

		jmp 	program

		dc.b	10,10,10,10,'Thats it.. get the fuckin file editor '
		dc.b	'out.. by a book and learn to code shitty intros!! '
		dc.b	10,10,10,10,10
		cnop	0,4

program		lea	$dff000,a5
		
		bsr	killsysx

		bsr	init_copper1

		IFNE	music
		moveq	#0,d0			;0-8
		bsr	mt_init
		ENDC

		lea	newlevel3(pc),a1
		lea	$6c.w,a2
		move.l	a1,(a2)
		
		move	#$c020,$9a(a5)

		move.w	#0,$dff1fc
		bsr	routines
		bsr	intro

		lea	copperlist(pc),a0
		move.l	a0,$80(a5)
		move.w	d0,$88(a5)
		move.w	#0,$1fc(a5)

		move	#1,allow_wr
		move	#1,allow_sc

beam0		move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$12000,d7
		bne.s	beam0

		bsr.s	routines

		btst	#6,$bfe001
		bne.s	beam0

		lea	systemsave(pc),a4
		move.l	12(a4),$68.w
		move.l	16(a4),$6c.w
		move	8(a4),$9a(a5)
		move	10(a4),$96(a5)
		move.l	(a4),$80(a5)
		move.l	4(a4),$84(a5)

fadecli2	move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$13000,d7
		bne.s	fadecli2
		moveq	#1,d5
		bsr	mt_music
		lea	systemsave(pc),a4
		move.l	4(a4),a0
		lea	6(a0),a1
		lea	savepal(pc),a0
		moveq	#4-1,d7
		moveq	#6,d6
		bsr	fader
		tst	d1
		beq.s	fadecli2

		IFNE	music
		bsr	mt_end
		ENDC
		move.l	4.w,a6
		jsr	-$7e(a6)
		moveq	#0,d0
		rts

routines	bsr	wave
		bsr	manager
		bsr	animate_spr		
		bsr	writer
		bsr	copy
		bsr	clear
		rts

*****************************************************************************

newlevel3	move	sr,-(sp)		;sr onto stack
		movem.l	d0-d7/a0-a6,-(sp)	;all regs to stack
		lea	$dff000,a5
		move 	#$20,$9c(a5)

		bsr	scroll		

		IFNE	music
		moveq	#0,d5
		bsr	mt_music
		ENDC
	
		movem.l	(sp)+,d0-d7/a0-a6
		move	(sp)+,sr
		rte

init_copper1	lea	systemsave(pc),a4
		move.l	4(a4),a0
		lea	6(a0),a1
		lea	savepal(pc),a0
		move	(a1),(a0)+
		move	4(a1),(a0)+
		move	8(a1),(a0)+
		move	12(a1),(a0)+
		bsr	update3
		lea	multable(pc),a0
		move	#144-1,d1
		moveq	#0,d0
multab		move	d0,(a0)+
		add	#44,d0
		dbf	d1,multab
		lea	screen,a2
kccp		clr.l	(a2)+
		cmp.l	#screen+$10000,a2
		bne.s	kccp		
		lea	logo,a0
		lea	screen+((44*4)*6),a1
rtt		move	(a0)+,(a1)+
		cmp.l	#logoend,a0
		blo.s	rtt
		lea	sprxpos(pc),a4		;initialise sonic
		move.l	#$017000d0,(a4)
		lea	sprframe(pc),a4
		clr	(a4)
		lea	screen,a0
		lea	bits1(pc),a1
		lea	bits1_1(pc),a2
		moveq	#4-1,d1
		move.l	a0,d0
setloop1	move	d0,6(a1)
		move	d0,6(a2)
		swap	d0
		move	d0,2(a1)
		move	d0,2(a2)
		swap	d0
		lea	8(a1),a1
		lea	8(a2),a2
		add.l	#44,d0
		dbf	d1,setloop1
		lea	scrollbuffer+2,a0
		lea	bits2(pc),a1
		moveq	#2-1,d1
		move.l	a0,d0
setloop2	move	d0,6(a1)
		swap	d0
		move	d0,2(a1)
		swap	d0
		lea	8(a1),a1
		add.l	#48*30,d0
		dbf	d1,setloop2
		lea	pal(pc),a0
		lea	palette(pc),a1
		lea	p16(pc),a2
		moveq	#16-1,d0
setp1		move	(a0),2(a1)
		move	(a0)+,2(a2)
		lea	4(a1),a1
		lea	4(a2),a2
		dbf	d0,setp1
		lea	block1(pc),a0
		move	#lines1-1,d1
		move.l	#$1c09fffe,d2
insert1		move.l	d2,(a0)+
		move.l	#$00f00000,(a0)+
		move.l	#$00f20000,(a0)+
		move.l	#$01a00000,(a0)+		
		add.l	#$01000000,d2
		dbf	d1,insert1
		lea	block2(pc),a0
		moveq	#lines2-1,d1
		move.l	#$d209fffe,d2
insert2		move.l	d2,(a0)+
		move.l	#$00e00000,(a0)+
		move.l	#$00e20000,(a0)+
		move.l	#$01820000,(a0)+		
		add.l	#$01000000,d2
		dbf	d1,insert2
		lea	block3(pc),a0
		moveq	#lines3-1,d1
		move.l	#$2109fffe,d2
insert3		move.l	d2,(a0)+
		move.l	#$00e00000,(a0)+
		move.l	#$00e20000,(a0)+
		move.l	#$01800015,(a0)+
		move.l	#$01820000,(a0)+
		add.l	#$01000000,d2
		dbf	d1,insert3
		lea	blockblur(pc),a0
		moveq	#lines4-1,d1
		move.l	#$0209fffe,d2
insert4		move.l	#$00e40000,(a0)+
		move.l	#$00e60000,(a0)+
		move.l	d2,(a0)+
		add.l	#$01000000,d2
		dbf	d1,insert4
		lea	cline(pc),a0
		move.l	#$01800015,d0
		moveq	#59-1,d1
setcline	move.l	d0,(a0)+
		dbf	d1,setcline
		move.l	#$01800015,d0
		move.l	d0,(a0)
		bset	#1,$bfe001
		rts	

*****************************************************************************

*	Intro part

*****************************************************************************

intro		move.l	#250-1,d6	
intro1		move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$13000,d7
		bne.s	intro1
		dbf	d6,intro1

		bsr	fadecli
		lea	copperlist2(pc),a0
		move.l	a0,$80(a5)
		move.w	#0,$1fc(a5)
		move.w	d0,$88(a5)
		move	#$83e0,$96(a5)
		bsr.s	makeline
		bsr.s	moveline
		addq	#1,allow_so
		bsr	fadelogoup

		move.l	#250-1,d6	
intro2		move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$13000,d7
		bne.s	intro2
		dbf	d6,intro2

frame		movem.l	d6/d7,-(sp)
		moveq	#5,d6
frame1		move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$12000,d7
		bne.s	frame1
		dbf	d6,frame1
		movem.l	(sp)+,d6/d7
		rts

makeline	lea	cline(pc),a0
		moveq	#59-1,d0
lineup		move	#$fff,2(a0)
		lea	4(a0),a0
		bsr.s	frame
		dbf	d0,lineup
		rts

moveline	lea	upline(pc),a0
		move	#$100,d0
		move	#$fff,6(a0)
		move	#$004,14(a0)
bump		sub	d0,(a0)
		sub	d0,8(a0)
		bsr.s	frame
		cmp	#9,(a0)
		bne.s	bump
		rts

fadecli		move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$13000,d7
		bne.s	fadecli
		lea	systemsave(pc),a4
		move.l	4(a4),a0
		lea	6(a0),a1
		lea	blank(pc),a0
		moveq	#4-1,d7
		moveq	#6,d6
		bsr.s	fader
		tst	d1
		beq.s	fadecli
		rts

fadelogoup	move.l	4(a5),d7
		and.l	#$1ff00,d7
		cmp.l	#$13000,d7
		bne.s	fadelogoup
		lea	pal(pc),a0
		lea	logopal+2(pc),a1
		moveq	#16-1,d7
		moveq	#6,d6
		bsr.s	fader
		tst	d1
		beq.s	fadelogoup
		rts

fader		movem.l	a0-a2/d0/d2-d7,-(sp)	
		lea	fadebits(pc),a2
		addq.b	#1,(a2)
		cmp.b	(a2),d6
		bne.s	ntt1
		clr.b	(a2)
		addq.b	#1,1(a2)
		cmp.b	#16,1(a2)
		bne.s	floop1
		moveq	#-1,d1
		clr.w	(a2)
		bra.s	ntt2
floop1		move	(a0)+,d6
		move	(a1),d5
		cmp	d5,d6
		beq.s	nextc
		bsr.s	mask		
		cmp	d2,d3
		blt.s	minus
		neg	d4
minus		sub	d4,(a1)
nextc		lea	4(a1),a1
		dbf	d7,floop1
ntt1		moveq	#0,d1
ntt2		movem.l	(sp)+,a0-a2/d0/d2-d7
		rts


mask		moveq	#0,d4
		move	d6,d3
		move	d5,d2
		and	#$f,d6
		and	#$f,d5
		cmp.b	d5,d6
		beq.s	okblue
		addq	#1,d4
okblue		move	d3,d6
		move	d2,d5
		and	#$f0,d6
		and	#$f0,d5
		cmp.b	d5,d6
		beq.s	okgreen
		add	#$10,d4
okgreen		move	d3,d6
		move	d2,d5
		and	#$f00,d6
		and	#$f00,d5
		cmp	d5,d6
		beq.s	okred
		add	#$100,d4
okred		rts

*****************************************************************************

*	Main part

*****************************************************************************

manager		tst	changing
		beq.s	working
		cmp	#1,changing
		beq.s	colzdown
		bra.s	colzup

working		lea	pauser(pc),a0
		cmp	#50*5,(a0)
		bne.s	not_ready
		clr	(a0)
		addq	#1,changing
		bra.s	there
not_ready	addq	#1,(a0)
there		rts

colzdown	lea	gfx_offset(pc),a0
		add.l	#44,(a0)
		cmp.l	#44*144,(a0)
		bne.s	waitamo
		bsr.s	update3
		addq	#1,changing
waitamo		rts

colzup		lea	gfx_offset(pc),a0
		sub.l	#44,(a0)
		tst.l	(a0)
		bne.s	waitamo2
		clr	changing
waitamo2	rts

update3		moveq	#4-1,d7				;fetch sinedata
		lea	vbar_datalist2(pc),a1
		lea	wave_chan1(pc),a2
		move	(a1),d0
		cmp	#33,2(a1,d0.w)
		bne.s	ok_v91
		clr	(a1)
		bra.s	update3
ok_v91		addq	#8,(a1)
		lea	2(a1,d0.w),a1
setx		move	(a1)+,(a2)+
		dbf	d7,setx
update4		moveq	#0,d0
		lea	which_gfx(pc),a0
		lea	fx_gfx(pc),a1
		move.b	(a0),d0
		tst.b	1(a0,d0.w)
		bpl.s	ok_v92
		clr.b	(a0)
		bra.s	update4
ok_v92		move.b	1(a0,d0.w),d0
		addq.b	#1,(a0)
		tst.b	d0
		bne.s	set1
		move.l	#fx_gfx1,(a1)
		bra.s	update5
set1		move.l	#fx_gfx2,(a1)
update5		moveq	#0,d0
		lea	which_offset(pc),a0
		lea	offset(pc),a1
		move.b	(a0),d0
		tst.b	1(a0,d0.w)
		bpl.s	ok_v93
		clr.b	(a0)
		bra.s	update5
ok_v93		move.b	1(a0,d0.w),1(a1)
		addq.b	#1,(a0)
		lea	col_offsets1(pc),a0
		lea	clist_offset1(pc),a1
		bsr.s	update6
		lea	col_offsets2(pc),a0
		lea	clist_offset2(pc),a1
		bsr.s	update6
		rts

update6		moveq	#0,d0
		move	(a0),d0
		tst	2(a0,d0.w)
		bpl.s	ok_v94
		clr	(a0)
		bra.s	update6
ok_v94		move	2(a0,d0.w),d0
		move.l	d0,(a1)
		addq	#2,(a0)
		rts

wave		lea	block1(pc),a1
		lea	wavecols(pc),a6
		move.l	gfx_offset(pc),d4
		move.l	(a6),a4
		move.l	4(a6),a6
		add.l	clist_offset1(pc),a4
		add.l	clist_offset2(pc),a6
		lea	sine,a3
		lea	wave_crp(pc),a2
		move	(a2),d6
		move	wave_chan1(pc),d7
		add	d7,(a2)
		move	2(a2),d5
		move	wave_chan2(pc),d7
		add	d7,2(a2)
		move	#lines1-1,d7
loop55		move	d6,d0
		add	wave_freq1(pc),d6
		and	#$1ff,d0
		add	d0,d0
		move	(a3,d0.w),d0
		move	d5,d2
		add	wave_freq2(pc),d5
		and	#$1ff,d2
		add	d2,d2
		add	(a3,d2.w),d0
		move	(a3,d2.w),d2
		add	d2,d0
		lsr	#3,d0
		movem.l	d0/d5/d6,-(sp)
		bsr	blob
		movem.l	(sp)+,d0/d5/d6
		dbf	d7,loop55

		lea	fake(pc),a1
		moveq	#2-1,d7
adjust1		move	d6,d0
		add	wave_freq1(pc),d6
		and	#$1ff,d0
		add	d0,d0
		move	(a3,d0.w),d0
		move	d5,d2
		add	wave_freq2(pc),d5
		and	#$1ff,d2
		add	d2,d2
		add	(a3,d2.w),d0
		move	(a3,d2.w),d2
		add	d2,d0
		lsr	#3,d0
		movem.l	d0/d5/d6,-(sp)
		bsr	blob2
		movem.l	(sp)+,d0/d5/d6
		dbf	d7,adjust1

		lea	block2(pc),a1
		move	#lines2-1,d7
loop45		move	d6,d0
		add	wave_freq1(pc),d6
		and	#$1ff,d0
		add	d0,d0
		move	(a3,d0.w),d0
		move	d5,d2
		add	wave_freq2(pc),d5
		and	#$1ff,d2
		add	d2,d2
		add	(a3,d2.w),d0
		move	(a3,d2.w),d2
		add	d2,d0
		lsr	#3,d0
		movem.l	d0/d5/d6,-(sp)
		bsr	blob
		movem.l	(sp)+,d0/d5/d6
		dbf	d7,loop45

		lea	blockblur(pc),a1
		move	#lines4-1,d7
adjust2		move	d6,d0
		add	wave_freq1(pc),d6
		and	#$1ff,d0
		add	d0,d0
		move	(a3,d0.w),d0
		move	d5,d2
		add	wave_freq2(pc),d5
		and	#$1ff,d2
		add	d2,d2
		add	(a3,d2.w),d0
		move	(a3,d2.w),d2
		add	d2,d0
		lsr	#3,d0
		movem.l	d0/d5/d6,-(sp)
		bsr	blob3
		movem.l	(sp)+,d0/d5/d6
		dbf	d7,adjust2

		lea	block3(pc),a1
		move	#lines3-1,d7
loop56		move	d6,d0
		add	wave_freq1(pc),d6
		and	#$1ff,d0
		add	d0,d0
		move	(a3,d0.w),d0
		move	d5,d2
		add	wave_freq2(pc),d5
		and	#$1ff,d2
		add	d2,d2
		add	(a3,d2.w),d0
		move	(a3,d2.w),d2
		add	d2,d0
		lsr	#3,d0
		movem.l	a0/d0/d5/d6,-(sp)
		lea	multable(pc),a0
		bsr.s	blob4
		movem.l	(sp)+,a0/d0/d5/d6
		dbf	d7,loop56
		rts

blob4		move	d0,d6
		move	offset(pc),d3
		beq.s	skip_lsr4
		lsr	d3,d6
skip_lsr4	add	d6,d6
		add	d0,d0
		move.l	fx_gfx(pc),d5
		add	(a0,d0.w),d5
		sub.l	d4,d5
		move	d5,10(a1)
		swap	d5
		move	d5,6(a1)	
		move	(a6,d6.w),18(a1)
		lea	20(a1),a1
		rts

blob		move	d0,d6
		move	offset(pc),d3
		beq.s	skip_lsr
		lsr	d3,d6
skip_lsr	add	d6,d6
		add	d0,d0
		move.l	fx_gfx(pc),d5
		add	multable(pc,d0.w),d5
		sub.l	d4,d5
		move	d5,10(a1)
		swap	d5
		move	d5,6(a1)	
		move	(a6,d6.w),14(a1)
		lea	16(a1),a1
		rts
		
blob2		move	d0,d6
		move	offset(pc),d3
		beq.s	skip_lsr2
		lsr	d3,d6
skip_lsr2	add	d0,d0
		add	d6,d6
		move.l	fx_gfx(pc),d5
		add	multable(pc,d0.w),d5
		sub.l	d4,d5
		move	d5,14(a1)
		swap	d5
		move	d5,10(a1)	
		move	(a6,d6.w),18(a1)
		lea	52(a1),a1
		rts

blob3		add	d0,d0
		move.l	fx_gfx(pc),d5
		add	multable(pc,d0.w),d5
		sub.l	d4,d5
		move	d5,6(a1)
		swap	d5
		move	d5,2(a1)	
		lea	12(a1),a1
		rts

multable	ds.w	144


writer		tst	allow_wr
		beq	skip_wr
		tst	npause
		beq.s	cont1
		subq	#1,npause
		bra	skip_wr
cont1		movem.l	a0-a4/d0-d7,-(sp)
		move.l	textptr(pc),a2
		lea	textpos(pc),a3
next		cmp.b	#-2,(a2)
		bne.s	not_page
		moveq	#0,d0
		move.b	1(a2),d0
		mulu	#50,d0
		move	d0,npausetemp
		clr.l	(a3)
		clr	allow_wr
		move	#1,allow_co
		lea	text(pc),a2	
		bra	done
not_page	cmp.b	#-1,(a2)
		bne.s	not_looped
		moveq	#0,d0
		move.b	1(a2),d0
		mulu	#50,d0
		move	d0,npausetemp
		clr.l	(a3)
		clr	allow_wr
		move	#1,allow_co
		lea	2(a2),a2	
		bra.s	done
not_looped	cmp.b	#13,(a2)
		bne.s	no_return
		clr	(a3)
		add	#(44*4)*charhi,2(a3)
		lea	1(a2),a2
		bra.s	next
no_return	move.b	(a2)+,d0
		sub.b	#32,d0
		and	#$ff,d0
		add	d0,d0
		lea	font2,a0
		lea	charbuffer,a1
		lea	(a0,d0.w),a0
		move	(a3),d5
		move	2(a3),d6
		lea	(a1,d5.w),a1
		lea	(a1,d6.w),a1
		move.l	#-1,bltafwm(a5)
		move.l	#$09f00000,bltcon0(a5)
		move	#(944/8)-2,bltamod(a5)
		move	#44-2,bltdmod(a5)
		move.l	a0,bltapth(a5)
		move.l	a1,bltdpth(a5)
		move	#(64*(16*4))+1,bltsize(a5)
		bsr	waitbli
		addq	#2,(a3)
done		move.l	a2,textptr
		movem.l	(sp)+,a0-a4/d0-d7
skip_wr		rts

copy		tst	allow_co
		beq	skip_co
		tst	npause
		beq.s	cont2
		subq	#1,npause
		bra	skip_co
cont2		moveq	#5-1,d7
		moveq	#0,d6
blinds1		lea	charbuffer,a0
		lea	screen+(176*100),a1
		lea	copy_offset(pc),a2
		move.l	(a2),d0
		lea	(a0,d0.l),a0
		lea	(a1,d0.l),a1
		lea	(a0,d6.l),a0
		lea	(a1,d6.l),a1
		move.l	#-1,bltafwm(a5)
		move.l	#$09f00000,bltcon0(a5)
		moveq	#0,d0
		move	d0,bltamod(a5)
		move	d0,bltdmod(a5)
		move.l	a0,bltapth(a5)
		move.l	a1,bltdpth(a5)
		move	#(64*(1*4))+22,bltsize(a5)
		bsr	waitbli
		add.l	#(44*4)*16,d6
		dbf	d7,blinds1
		add.l	#44*4,(a2)
		cmp.l	#(44*4)*16,(a2)
		bne.s	skip_co
		clr.l	(a2)
		clr	allow_co
		move	#1,allow_cl
		move	npausetemp(pc),npause		;onscreen
skip_co		rts

clear		tst	allow_cl
		beq.s	skip_cl
		tst	npause
		beq.s	cont3
		subq	#1,npause
		bra.s	skip_cl
cont3		move	#1,allow_wr
		moveq	#5-1,d7
		moveq	#0,d6
blinds2		lea	screen+(176*100),a1
		lea	(a1,d6.l),a1
		lea	copy_offset(pc),a2
		move.l	(a2),d0
		lea	(a1,d0.l),a1
		move.l	#-1,bltafwm(a5)
		move.l	#$01000000,bltcon0(a5)
		clr	bltdmod(a5)
		move.l	a1,bltdpth(a5)
		move	#(64*(1*4))+22,bltsize(a5)
		bsr	waitbli
		add.l	#(44*4)*16,d6
		dbf	d7,blinds2
		add.l	#44*4,(a2)
		cmp.l	#(44*4)*16,(a2)
		bne.s	skip_cl
		clr.l	(a2)
		clr	allow_cl
skip_cl		rts

scroll		tst	allow_sc
		beq.s	nosc
		lea	scrolled(pc),a0
		addq	#1,(a0)
		cmp	#4,(a0)
		bne.s	normals
		clr	(a0)
		bsr.s	newchar
normals		lea	scrollbuffer,a1
		lea	2(a1),a0
		moveq	#1,d7
plane4		movem.l	a0-a1,-(sp)
		move.l	#-1,bltafwm(a5)
		move.l	#$c9f00000,bltcon0(a5)
		moveq	#48-46,d0
		move	d0,bltamod(a5)
		move	d0,bltdmod(a5)
		move.l	a0,bltapth(a5)
		move.l	a1,bltdpth(a5)
		move	#(64*30)+23,bltsize(a5)
		bsr	waitbli
		movem.l	(sp)+,a0-a1
		lea	48*30(a1),a1
		lea	48*30(a0),a0
		dbf	d7,plane4
nosc		rts

newchar		movem.l	a0-a4/d0-d7,-(sp)
		move.l	scrollpoint(pc),a2
		tst.b	(a2)
		bpl.s	no_loop
		lea	scroller(pc),a2
no_loop		move.b	(a2)+,d0
		move.l	a2,scrollpoint
		cmp.b	#'b',d0
		bne.s	notr
		moveq	#8,d0
		bra.s	r
notr		cmp.b	#'a',d0
		bne.s	notDC
		moveq	#4,d0
		bra.s	r		
notDC		sub.b	#32,d0
		and	#$ff,d0
		add	d0,d0
r		lea	font1,a0
		lea	scrollbuffer+44,a1
		lea	(a0,d0.w),a0
		moveq	#1,d7
plane2		movem.l	a0-a1,-(sp)
		move.l	#-1,bltafwm(a5)
		move.l	#$09f00000,bltcon0(a5)
		move	#(944/8)-2,bltamod(a5)
		move	#48-2,bltdmod(a5)
		move.l	a0,bltapth(a5)
		move.l	a1,bltdpth(a5)
		move	#(64*30)+1,bltsize(a5)
		bsr.s	waitbli
		movem.l	(sp)+,a0-a1
		lea	48*30(a1),a1
		lea	$dd4(a0),a0
		dbf	d7,plane2
		movem.l	(sp)+,a0-a4/d0-d7
		rts

waitbli		move	#$8400,$96(a5)
wb1		btst	#14,2(a5)
		bne.s	wb1
wb2		btst	#14,2(a5)
		bne.s	wb2
		move	#$400,$96(a5)
		rts

animate_spr	tst	allow_so
		beq.s	there1

		lea	sprxpos(pc),a4		;initialise sonic
		subq	#2,(a4)
		cmp	#$120,(a4)
		bne.s	there1
		clr	allow_so

there1		lea	framecount(pc),a4	
		addq	#1,(a4)		;just makes sure frame is
		cmp	#5,(a4)		;updated at a certain rate.
		bne.s	noadvframe
		clr	(a4)
		lea	sprframe(pc),a4
		move.l	splist(pc),a2
		cmp.b	#-1,(a2)
		bne.s	nol8
		lea	spdat(pc),a2		
nol8		move.b	(a2)+,1(a4)
		move.l	a2,splist
noadvframe	moveq	#0,d0		;find our sprite frame..
		move	sprframe(pc),d0
		move.l	#(200*6),d1
		muls	d0,d1
		lea	spritedata,a1
		lea	(a1,d1.l),a1
		bsr	spritepoint	;set the copperlist		
		move	sprxpos(pc),d0
		move	sprypos(pc),d1
		add	#$70,d0		;add a little..
		moveq	#48,d4		;sprite height
		moveq	#0,d2		;sprite control word
		move.b	d1,d2		;put low byte of sprypos in con
		asl	#8,d2		;move along
		move	d0,d3		;keep sprxpos safe
		asr	#1,d3		;get rid of lsb
		move.b	d3,d2		;put low byte of sprxpos in con
		swap	d2		;swap control regs
		move	d1,d3		;keep sprypos
		add	d4,d3		;add height to sprypos for end.
		move.b	d3,d2		;put low byte of vend in con
		asl	#8,d2		;move along
		btst	#0,d0		;check sprxpos lsb
		beq.s	nosethlow
		or	#1,d2		;put lsb status into con
nosethlow	btst	#8,d1		;check sprypos msb
		beq.s	nosetvhigh
		or	#4,d2		;put msb status into con
nosetvhigh	btst	#8,d3		;check vertend msb
		beq.s	nosetvend
		or	#2,d2		;put vend msb into control
nosetvend	bclr	#7,d2		;set no attach
		move.l	d2,(a1)
		bset	#7,d2		;set attach
		move.l	d2,200(a1)
		add.l	#$00080000,d2
		bclr	#7,d2		;set no attach
		move.l	d2,400(a1)
		bset	#7,d2		;set attach
		move.l	d2,600(a1)
		add.l	#$00080000,d2
		bclr	#7,d2		;set no attach
		move.l	d2,800(a1)
		bset	#7,d2		;set attach
		move.l	d2,1000(a1)
		rts

spritepoint	lea	spritelist1(pc),a0	
		bsr.s	setemup
		lea	spritelist2(pc),a0	;this routine just sets
setemup		move.l	a1,-(sp)	  	;the copperlist sprite
		moveq	#6-1,d7	  		;pointers...
setsprites	move.l	a1,d0	 
		move	d0,6(a0)	 
		swap	d0	 
		move	d0,2(a0)	 
		lea	8(a0),a0
		lea	200(a1),a1
		dbf	d7,setsprites	 
		move.l	(sp)+,a1
		rts


mt_init	lea	$dff000,a4
	lea	songs(pc),a1
	lea	stuff(pc),a0
	moveq	#0,d1
	muls	#3,d0
	clr.b	(a0)
	move.b	(a1,d0.w),3(a0)
	move.b	2(a1,d0.w),2(a0)
	move.b	1(a1,d0.w),d1
	lsl	#4,d1
	move	d1,4(a0)
	clr	8(a0)
	lea	mt_data,a0
	lea	module(pc),a1
	move.l	a0,(a1)
	move.l	a0,a1
	lea	$3b8(a1),a1
	moveq	#$7f,d0
	moveq	#0,d1
mt_loop	move.l	d1,d2
	subq	#1,d0
mt_lop2	move.b	(a1)+,d1
	cmp.b	d2,d1
	bgt.s	mt_loop
	dbf	d0,mt_lop2
	addq.b	#1,d2
	lea	mt_samplestarts(pc),a1
	asl.l	#8,d2
	asl.l	#2,d2
	add.l	#$43c,d2
	add.l	a0,d2
	move.l	d2,a2
	moveq	#$1e,d0
mt_lop3	clr.l	(a2)
	move.l	a2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	asl.l	#1,d1
	add.l	d1,a2
	lea	$1e(a0),a0
	dbf	d0,mt_lop3
	bset	#1,$bfe001
	bra.s	vol0

mt_end	lea	$dff000,a4
	bclr	#1,$bfe001
	move	#$f,$96(a4)
vol0	clr	$a8(a4)
	clr	$b8(a4)
	clr	$c8(a4)
	clr	$d8(a4)
	rts

mt_music
	movem.l	d0-d4/a0-a3/a5-a6,-(a7)
	lea	$dff000,a4
	move.l	module(pc),a0
	lea	stuff(pc),a1
	tst	d5
	beq.s	normal
	addq	#1,8(a1)
	cmp	#$40,8(a1)
	ble.s	normal
	move	#$40,8(a1)
	moveq	#-1,d5
normal	addq.b	#1,(a1)
	move.b	(a1),D0
	cmp.b	mt_speed(pc),D0
	blt.s	mt_nonew
	clr.b	(a1)
	bra	mt_getnew
mt_nonew
	lea	mt_voice1(pc),a6
	lea	$a0(a4),a5
	bsr	mt_checkcom
	lea	mt_voice2(pc),a6
	lea	$b0(a4),a5
	bsr	mt_checkcom
	lea	mt_voice3(pc),a6
	lea	$c0(a4),a5
	bsr	mt_checkcom
	lea	mt_voice4(pc),a6
	lea	$d0(a4),a5
	bsr	mt_checkcom
	bra	mt_endr

mt_arpeggio
	moveq	#0,d0
	move.b	mt_counter(pc),d0
	divs	#3,d0
	swap	d0
	cmp	#0,d0
	beq.s	mt_arp2
	cmp	#2,d0
	beq.s	mt_arp1
	moveq	#0,d0
	move.b	3(a6),d0
	lsr.b	#4,d0
	bra.s	mt_arp3
mt_arp1	moveq	#0,d0
	move.b	3(a6),d0
	and.b	#$f,d0
	bra.s	mt_arp3
mt_arp2	move.w	$10(a6),d2
	bra.s	mt_arp4
mt_arp3	asl.w	#1,d0
	moveq	#0,d1
	move.w	$10(a6),d1
	lea	mt_periods(pc),a0
	moveq	#$24,d7
mt_arpl	move.w	(a0,d0.w),d2
	cmp.w	(a0),d1
	bge.s	mt_arp4
	lea	2(a0),a0
	dbf	d7,mt_arpl
	rts

mt_arp4	move.w	d2,6(a5)
	rts

mt_getnew
	move.l	module(pc),a0
	lea	stuff(pc),a5
	move.l	a0,a3
	move.l	a0,a2
	lea	$c(a3),a3
	lea	$3b8(a2),a2
	lea	$43c(a0),a0
	moveq	#0,d0
	move.l	d0,d1
	move.b	3(a5),d0
	move.b	(a2,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add	4(a5),d1
	clr	6(a5)

	lea	$a0(a4),a5
	lea	mt_voice1(pc),a6
	bsr.s	mt_playvoice
	lea	$b0(a4),a5
	lea	mt_voice2(pc),a6
	bsr.s	mt_playvoice
	lea	$c0(a4),a5
	lea	mt_voice3(pc),a6
	bsr.s	mt_playvoice
	lea	$d0(a4),a5
	lea	mt_voice4(pc),a6
	bsr.s	mt_playvoice
	bra	mt_setdma

mt_playvoice
	move.l	(a0,d1.l),(a6)
	addq.l	#4,d1
	moveq	#0,d2
	move.b	2(a6),d2
	and.b	#$f0,d2
	lsr.b	#4,d2
	move.b	(a6),d0
	and.b	#$f0,d0
	or.b	d0,d2
	tst.b	d2
	beq.s	mt_setregs
	moveq	#0,d3
	lea	mt_samplestarts(pc),a1
	move.l	d2,d4
	subq.l	#1,d2
	asl.l	#2,d2
	mulu	#$1e,d4
	move.l	(a1,d2.l),$4(a6)
	move.w	(a3,d4.l),$8(a6)
	move.w	$2(a3,d4.l),$12(a6)
	move.w	$4(a3,d4.l),d3
	tst.w	d3
	beq.s	mt_noloop
	move.l	4(a6),d2
	asl.w	#1,d3
	add.l	d3,d2
	move.l	d2,$a(a6)
	move.w	$4(a3,d4.l),d0
	add.w	$6(a3,d4.l),d0
	move.w	d0,8(a6)
	move.w	$6(a3,d4.l),$e(a6)
	bsr.s	mt_setmaxvol
	bra.s	mt_setregs
mt_noloop
	move.l	$4(a6),d2
	add.l	d3,d2
	move.l	d2,$a(a6)
	move.w	$6(a3,d4.l),$e(a6)
	bsr.s	mt_setmaxvol

mt_setregs
	move.w	(a6),d0
	and.w	#$fff,d0
	beq	mt_checkcom2
	move.b	2(a6),d0
	and.b	#15,d0
	cmp.b	#3,d0
	bne.s	mt_setperiod
	bsr	mt_setmyport
	bra	mt_checkcom2

mt_setmaxvol
	move	d0,-(sp)
	move	$12(a6),d0
	sub	maxvolume(pc),d0
	bpl.s	sok
	move	#0,d0
sok	move	d0,8(a5)
   	move	(sp)+,d0
	rts

mt_setperiod
	lea	stuff(pc),a1
	move	(a6),$10(a6)
	and	#$fff,$10(a6)
	move	$14(a6),d0
	move	d0,$96(a4)
	clr.b	$1b(a6)
	move.l	4(a6),(a5)
	move	8(a6),4(a5)
	move	$10(a6),d0
	and	#$fff,d0
	move	d0,6(a5)
	move	$14(a6),d0
	or	d0,6(a1)
	bra	mt_checkcom2

mt_setdma
	lea	stuff(pc),a1
	move	#$12c,d0
mt_wait	dbf	d0,mt_wait
	move	6(a1),d0
	or	#$8000,d0
	move	d0,$96(a4)
	move	#$12c,d0
mt_wai2	dbf	d0,mt_wai2
	lea	mt_voice4(pc),a6
	move.l	$a(a6),$d0(a4)
	move.w	$e(a6),$d4(a4)
	lea	mt_voice3(pc),a6
	move.l	$a(a6),$c0(a4)
	move.w	$e(a6),$c4(a4)
	lea	mt_voice2(pc),a6
	move.l	$a(a6),$b0(a4)
	move.w	$e(a6),$b4(a4)
	lea	mt_voice1(pc),a6
	move.l	$a(a6),$a0(a4)
	move.w	$e(a6),$a4(a4)
	add	#$10,4(a1)
	cmp	#$400,4(a1)
	bne.s	mt_endr

mt_nex	lea	stuff(pc),a1
	clr	4(a1)
	clr.b	1(a1)
	addq.b	#1,3(a1)
	and.b	#$7f,3(a1)
	move.b	3(a1),d1
	move.l	module(pc),a5
	lea	$3b6(a5),a5
	cmp.b	(a5),d1
	bne.s	mt_endr
	clr.b	3(a1)
mt_endr	tst.b	1(a1)
	bne.s	mt_nex
gud	movem.l	(a7)+,d0-d4/a0-a3/a5-a6
	rts

mt_setmyport
	move	(a6),d2
	and	#$fff,d2
	move	d2,$18(a6)
	move	$10(a6),d0
	clr.b	$16(a6)
	cmp	d0,d2
	beq.s	mt_clrport
	bge.s	mt_rt
	move.b	#1,$16(a6)
	rts

mt_clrport
	clr	$18(a6)
mt_rt	rts

mt_myport
	move.b	3(a6),d0
	beq.s	mt_myslide
	move.b	d0,$17(a6)
	clr.b	3(a6)
mt_myslide
	tst.w	$18(a6)
	beq.s	mt_rt
	moveq	#0,d0
	move.b	$17(a6),d0
	tst.b	$16(a6)
	bne.s	mt_mysub
	add.w	d0,$10(a6)
	move.w	$18(a6),d0
	cmp.w	$10(a6),d0
	bgt.s	mt_myok
	move.w	$18(a6),$10(a6)
	clr.w	$18(a6)
mt_myok	move.w	$10(a6),$6(a5)
	rts

mt_mysub
	sub.w	d0,$10(a6)
	move.w	$18(a6),d0
	cmp.w	$10(a6),d0
	blt.s	mt_myok
	move.w	$18(a6),$10(a6)
	clr.w	$18(a6)
	move.w	$10(a6),$6(a5)
	rts

mt_vib	move.b	3(a6),d0
	beq.s	mt_vi
	move.b	d0,$1a(a6)

mt_vi	move.b	$1b(a6),d0
	lsr	#2,d0
	and	#$1f,d0
	moveq	#0,d2
	move.b	mt_sin(pc,d0.w),d2
	move.b	$1a(a6),d0
	and	#15,d0
	mulu	d0,d2
	lsr	#6,d2
	move	$10(a6),d0
	tst.b	$1b(a6)
	bmi.s	mt_vibmin
	add	d2,d0
	bra.s	mt_vib2

mt_sin	dc.b	$00,$18,$31,$4a,$61,$78,$8d,$a1,$b4,$c5,$d4,$e0,$eb,$f4,$fa,$fd
	dc.b	$ff,$fd,$fa,$f4,$eb,$e0,$d4,$c5,$b4,$a1,$8d,$78,$61,$4a,$31,$18

mt_vibmin
	sub	d2,d0
mt_vib2	move	d0,$6(a5)
	move.b	$1a(a6),d0
	lsr	#2,d0
	and	#$3c,d0
	add.b	d0,$1b(a6)
	rts

mt_nop	move.w	$10(a6),$6(a5)
	rts

mt_checkcom
	move	2(a6),d0
	and	#$fff,d0
	beq.s	mt_nop
	move.b	2(a6),d0
	and.b	#15,d0
	tst.b	d0
	beq	mt_arpeggio
	cmp.b	#$1,d0
	beq.s	mt_portup
	cmp.b	#$2,d0
	beq	mt_portdown
	cmp.b	#$3,d0
	beq	mt_myport
	cmp.b	#$4,d0
	beq	mt_vib
	move	$10(a6),$6(a5)
	cmp.b	#$a,d0
	beq.s	mt_volslide
	rts

mt_volslide
	moveq	#0,d0
	move.b	3(a6),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	mt_voldown
	add	d0,$12(a6)
	cmp	#$40,$12(a6)
	bmi.s	mt_vol2
	move	#$40,$12(a6)
mt_vol2	bra	mt_setmaxvol

mt_voldown
	moveq	#0,d0
	move.b	3(a6),d0
	and.b	#$f,d0
	sub	d0,$12(a6)
	bpl.s	mt_vol3
	clr	$12(a6)
mt_vol3	bra	mt_setmaxvol

mt_portup
	moveq	#0,d0
	move.b	3(a6),d0
	sub	d0,$10(a6)
	move	$10(a6),d0
	and	#$fff,d0
	cmp	#$71,d0
	bpl.s	mt_por2
	and	#$f000,$10(a6)
	or	#$71,$10(a6)
mt_por2	move	$10(a6),d0
	and	#$fff,d0
	move	d0,$6(a5)
	rts

mt_portdown
	clr	d0
	move.b	3(a6),d0
	add	d0,$10(a6)
	move	$10(a6),d0
	and	#$fff,d0
	cmp	#$358,d0
	bmi.s	mt_por3
	and	#$f000,$10(a6)
	or	#$358,$10(a6)
mt_por3	move	$10(a6),d0
	and	#$fff,d0
	move	d0,$6(a5)
	rts

mt_checkcom2	
	lea	stuff(pc),a1
	move.b	2(a6),d0
	and.b	#15,d0
	cmp.b	#$d,d0
	beq.s	mt_pattbreak
	cmp.b	#$b,d0
	beq.s	mt_posjmp
	cmp.b	#$c,d0
	beq.s	mt_setvol
	cmp.b	#$f,d0
	beq.s	mt_setspeed
	rts


mt_pattbreak
	not.b	1(a1)
	rts

mt_posjmp
	move.b	3(a6),d0
	subq.b	#1,d0
	move.b	d0,3(a1)
	not.b	1(a1)
	rts

mt_setvol
	move	d0,-(sp)
	cmp.b	#$40,3(a6)
	ble.s	mt_vol4
	move.b	#$40,$3(a6)
mt_vol4	move.b	3(a6),d0
	sub.b	maxvolume+1(pc),d0
	bpl.s	.ok
	moveq	#0,d0
.ok	move.b	d0,$8+1(a5)
	move	(sp)+,d0
	rts

mt_setspeed
	move.b	3(a6),d0
	and	#$1f,d0
	beq.s	mt_rts2
	clr.b	(a1)
	move.b	d0,2(a1)
mt_rts2	rts

module		dc.l	0		;songs: pattern,pattpos(0-63),speed

songs		dc.b	0,0,8
		dc.b	7,0,6
		dc.b	7,16,6
		dc.b	7,32,6
		dc.b	8,0,6
		dc.b	8,32,6
		dc.b	9,0,6
		dc.b	7,48,6
		dc.b	8,56,6
		EVEN
stuff
mt_counter	dc.b	0
mt_break	dc.b	0
mt_speed	dc.b	0
mt_songpos	dc.b	0
mt_pattpos	dc.w	0
mt_dmacon	dc.w	0
maxvolume	dc.w	0 	0=maximum

mt_samplestarts	ds.l	$1f
mt_voice1	ds.w	10
		dc.w	1
		ds.w	3
mt_voice2	ds.w	10
		dc.w	2
		ds.w	3
mt_voice3	ds.w	10
		dc.w	4
		ds.w	3
mt_voice4	ds.w	10
		dc.w	8
		ds.w	3
mt_periods
	dc.w	$0358,$0328,$02fa,$02d0,$02a6,$0280,$025c,$023a,$021a,$01fc,$01e0
	dc.w	$01c5,$01ac,$0194,$017d,$0168,$0153,$0140,$012e,$011d,$010d,$00fe
	dc.w	$00f0,$00e2,$00d6,$00ca,$00be,$00b4,$00aa,$00a0,$0097,$008f,$0087
	dc.w	$007f,$0078,$0071,$0000,$0000



killsysx	move.l	$4.w,a6
		jsr	-$78(a6)
		lea	gfxname(pc),a1
		moveq	#0,d0
		jsr	-552(a6)
		move.l	d0,a6
		move	#$8000,d7	
		lea	systemsave(pc),a4
		move.l	$26(a6),(a4)
		move.l	$32(a6),4(a4)
		move	$1c(a5),d0
		move	2(a5),d1
		or	d7,d0
		and	#$3ff,d1
		or	d7,d1
		move	d0,$8(a4)
		move	d1,$a(a4)
		move	#$7fff,$9a(a5)
		move	#$20,$96(a5)
		move.l	$68.w,12(a4)
		move.l	$6c.w,16(a4)
		rts

gfxname		dc.b	"graphics.library",0
		even

systemsave	ds.l	5

*****************************************************************************

splist		dc.l	spdat
spdat		REPT	3
		dc.b	0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
		ENDR
		REPT	2
		dc.b	8,9,10,11,12,13,14,15,8,9,10,11,12,13,14,15
		ENDR
		dc.b	-1
		EVEN

textptr		dc.l	text0

*Textwriter options : -1 to end a page and pause value (secs) after!
*		      -2 to end a page and pause value as above and loop
*		      13 to next line

*alignment               123456789012345678901

text0		dc.b	"                     ",13
		dc.b	"                     ",13
		dc.b	"                     ",13
		dc.b	"                     ",13
		dc.b	"                     ",13
		dc.b	-1,6
text		dc.b	" THE UK CO-OPERATION ",13
		dc.b	"  MUSICDISK PROJECT  ",13
		dc.b	"CALLED -SONIC ATTACK-",13
		dc.b	"IS NEARING COMPLETION",13
		dc.b	"    AT LONG LAST!    ",13
		dc.b	-1,6
text2		dc.b	" SO, IF YOU ARE A UK ",13
		dc.b	" BASED MUSICIAN, AND ",13
		dc.b	"  WOULD LIKE TO GET  ",13
		dc.b	"   INVOLVED IN THE   ",13
		dc.b	"  PROJECT, WRITE TO  ",13
		dc.b	-1,6
text3		dc.b	"    * RED DEVIL *    ",13
		dc.b	"   47 MOXLEY ROAD    ",13
		dc.b	"      DARLASTON      ",13
		dc.b	"    WEST MIDLANDS    ",13
		dc.b	"      WS10  7RE      ",13
		dc.b	-1,10
text4 		dc.b	"                     ",13
		dc.b	"*-*-*-*-*-*-*-*-*-*-*",13
		dc.b	"CREDIT FOR THIS INTRO",13
		dc.b	"*-*-*-*-*-*-*-*-*-*-*",13
		dc.b	"                     ",13
		dc.b	-1,4
text5		dc.b	"*********************",13
		dc.b	"    CODING BY NZO    ",13
		dc.b	"GRAPHICS BY RED DEVIL",13
		dc.b	"   MUSIC BY MUTLEY   ",13
		dc.b	"*********************",13
		dc.b	-1,5
text6		dc.b	"   CALL OUR BOARDS   ",13
		dc.b	"*-*-*-*-*-*-*-*-*-*-*",13
		dc.b	"   GURUS DREAM WHQ   ",13
		dc.b	"     46-8-282760     ",13
		dc.b	"  9 NODES, 6.4 GIGS  ",13
		dc.b	-1,7
text7 		dc.b	"  COMPLEX CORROSION  ",13
		dc.b	"    1-612-7730522    ",13
		dc.b	"*-*-*-*-*-*-*-*-*-*-*",13
		dc.b	"  FORGOTTEN REALMS   ",13
		dc.b	"    44-272-696594    ",13
		dc.b	-1,7
text8		dc.b	"    EASTERN FRONT    ",13
		dc.b	"     358-PRIVATE     ",13
		dc.b	"*-*-*-*-*-*-*-*-*-*-*",13
		dc.b	"    SECRET WORLD     ",13
		dc.b	"   49-30-885-4598    ",13
		DC.B	-1,7
text9		dc.b	"                     ",13
		dc.b	"  LOOK OUT FOR MORE  ",13
		dc.b	"  SMART PRODUCTIONS  ",13
		dc.b	"  FROM US VERY SOON  ",13
		dc.b	"                     ",13
		dc.b	-2,4
		EVEN

*		'a' = Dual Crew Logo 
*		'#' = 'Of'
*		'b' = '®'

scrollpoint	dc.l	scroller0
scroller0	dc.b	"                                                   "
scroller	dc.b	"WELCOME TO A NEW PRODUCTION FROM     a DUAL CREW a   "
		dc.b	"THIS IS JUST TO ANNOUNCE THAT WE ARE STILL LOOKING "
		DC.B	"FOR ANY EXCELLENT UK MUSICIAN THAT HASN'T SUBMITTED "
		DC.B	"A TUNE FOR SONIC ATTACKb. IF YOU'DE LIKE TO GET "
		DC.B	"INVOLVED, WRITE TO THE ADDRESS ABOVE NOW!             "
		dc.b	"GREETINGS FROM RED DEVIL TO ZEPHYR, IRIDON AND ALL THE SHINING "
		DC.B	"IVE SPOKEN WITH RECENTLY...    DWEL, TOM COPPER#ALCATRAZ   "
		DC.B	"MYSTIK, KREST, JUDGE DROKK#ANARCHY   FAIRFAX#ANDROMEDA   "
		DC.B	"MANX, MARVIN, WINTERMUTE, ICE, BLACK CAT, HYDRO, FAST EDDIE, "
		DC.B	"POT NOODLE, CEVIN KEY, MASCOT, MYRMURTH, THARGOID#ANTHROX   "
		DC.B	"PRAYER#BANAL PROJECTS   STRATOS, DHM#COMPLEX   NIGHTSHADE, "
		dc.b	"ONE, OHIO#CRUSADERS   WINGER, LEVIATHON, MAVE#CRYSTAL   "
		DC.B	"ELWOOD, DEXTER#DELICIOUS   HYBRID, FLIGHTY, NO.5, INTREQ, "
		dc.b	"YAZ, FLAME#DIGITAL   ASSASSIN, MINT SAUCE#DIMENSION X   "
		DC.B	"RA#DREAMDEALERS   REFLEX, RCF, ZIPTRONIX#ELEVATION   "
		DC.B	"GROO AND RUFFERTO#ESSENCE   MATTI JE TEPPO#FAIRLIGHT   "
		DC.B	"SHERWIN#FRAXION   CALVIN#GENOCIDE   JAY ONE, HOLLYWOOD, "
		dc.b	"SEC4#JETSET   RWO#KEFRENS   THE PRIDE, MAJIC MUSHROOM, "
		dc.b	"PARADROID, KR33, NUKE, FACET, DAN#LEMON.   PAZZA#LSD   "
		DC.B	"TDK#MELON DEZIGN   RADAR, LINEBACKER, ACTION MAN#MINISTRY   "
		DC.B	"RATTLE, RAMJET#PMC   MAT, WONDERBOY, RAIDER, RAZOR "
		dc.b	"BLADE#RAZOR 1911   JOHN, KRIS, META#REBELS   MUTLEY#RELAY   "
		DC.B	"SPYCATCHER, HI-LITE, BUTCH, ZODIAK#SCOOPEX   "
		DC.B	"COUGAR, CRUISER#SANITY   D-SIGN, WOTW, D-ZIRE, BAROCK, "
		dc.b	"RAVE#SILENTS   COAXIAL#SKID ROW   AXE!#SUBMISSION   "
		DC.B	"DENNIS T#SUPPLEX   ALI BABA#TARKUS TEAM   GRAY ONE, PEACHY, "
		dc.b	"FADE ONE, FORNAX#TRSI   HEIN DESIGN#VISION   DARKIE#WIZZCAT                    "
		dc.b	-1
		EVEN

waitpage	dc.w	0
textpos		dc.w	0,0
fadebits	dc.b	0,0
pauser		dc.w	2*40
changing	dc.w	0

scrolled	dc.w	0
sprxpos		dc.w	0		;sprite x position
sprypos		dc.w	0		;sprite y position
sprframe	dc.w	0		;current sprite frame
framecount	dc.w	0		;frame count for speed..

wave_chan1	dc.w	0
wave_chan2	dc.w	0
wave_freq1	dc.w	0
wave_freq2	dc.w	0
wave_crp	dc.w	0,0
wavecols	dc.l	cols2,cols1
fx_gfx		dc.l	fx_gfx1
offset		dc.w	0
clist_offset1	dc.l	0
clist_offset2	dc.l	0
gfx_offset	dc.l	143*44
blank		REPT	16
		dc.w	$015
		ENDR
allow_so	dc.w	0
allow_wr	dc.w	0
allow_co	dc.w	0
allow_cl	dc.w	0
allow_sc	dc.w	0
npause		dc.w	0
npausetemp	dc.w	0
copy_offset	dc.l	0
savepal		ds.w	4

vbar_datalist2	dc.w	0
		dc.w	11,21,-8,-7
		dc.w	257,-245,-255,-259
		dc.w	-15,15,-15,-14
		dc.w	-276,2,213,4
		dc.w	-260,4,249,-11
		dc.w	-2,-14,-19,-5
		dc.w	3,1,17,-11
		dc.w	7,-11,2,6
		dc.w	-251,221,2,-19
		dc.w	-11,251,-18,-259
		dc.w	18,18,18,-18
		dc.w	-9,-4,2,-1
		dc.w	-11,2,-1,3
		dc.w	-255,5,215,3
		dc.w	7,-275,2,256
		dc.w	9,-255,11,250
		dc.w	2,-3,-1,-1
		dc.w	-255,251,261,-257
		dc.w	-259,256,-5,-3
		dc.w	-251,253,258,-255
		dc.w	11,8,-15,-7
		dc.w	-3,5,3,-254
		dc.w	254,6,-250,-2
		dc.w	-255,-2,257,-1
		dc.w	28,-28,1,-9
		dc.w	13,-8,9,-19
		dc.w	254,7,-250,-3
		dc.w	47,-253,-43,258
		dc.w	47,-41,5,-3
		dc.w	-5,253,-2,-263
		dc.w	-251,-7,266,1
		dc.w	258,254,255,-257
		dc.w	249,-9,-257,6
		dc.w	-9,6,-1,-2
		dc.w	-3,5,3,-254
		dc.w	33

which_gfx	dc.b	0
		dc.b	0,0,1,0,0,1,0,1,0,0,0,1,1,1,0,0,1,0,0,1,1,1,0,1
		dc.b	1,1,0,0,1,0,0,1,0,1,1,1,1,0,1,0,1,0,1,0,0,1,1
		dc.b	-1
		EVEN
which_offset	dc.b	0
		dc.b	1,0,2,3,1,2,2,1,2,1,0,2,1,3,1,1,3,2,0,2,2,0,2
		dc.b	1,2,3,1,2,3,0,1,2,2,1,3,1,2,1,3,1,2,1,3,2,0,2
		dc.b	-1
		EVEN
col_offsets1	dc.w	0
		dc.w	40,80,120,40,0,20,16,100,50,32,10,0,12,60
		dc.w	70,90,100,30,20,100,200,20,10,40,0,70
		dc.w	16,32,48,56,64,80,96,110,120,130,140,150,160
		dc.w	0,50,76,170,180,32,160,40,132
		dc.w	-1
col_offsets2	dc.w	0
		dc.w	70,90,100,30,20,100,200,20,10,40,0,70
		dc.w	40,80,120,40,0,20,16,100,50,32,10,0,12,60
		dc.w	20,16,32,102,30,2,40,36,120,60,28,180
		dc.w	50,210,30,10,170
		dc.w	-1
		EVEN

pal		dc.w	$15,$eee,$ddd,$ccc,$bbb,$aaa,$999,$888
		dc.w	$677,$567,$256,$036,$03f,$02d,$00b,$002

copperlist	dc.w	$8e,$1b41,$90,$40f1,$92,$30,$94,$d8,$104,$24,$102,0
		dc.w	$100,$5200,$108,44*4-44,$10a,44*4-44
spritelist1	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0,$12a,0,$12c,0,$12e,0
		dc.w	$130,0,$132,0,$134,0,$136,0,$138,0,$13a,0,$13c,0,$13e,0

bits1		dc.w	$e0,0,$e2,0,$e4,0,$e6,0,$e8,0,$ea,0,$ec,0,$ee,0

palette		dc.w	$180,0,$182,0,$184,0,$186,0,$188,0,$18a,0,$18c,0,$18e,0		
		dc.w	$190,0,$192,0,$194,0,$196,0,$198,0,$19a,0,$19c,0,$19e,0		
p16		dc.w	$1a0,0,$1a2,0,$1a4,0,$1a6,0,$1a8,0,$1aa,0,$1ac,0,$1ae,0		
		dc.w	$1b0,0,$1b2,0,$1b4,0,$1b6,0,$1b8,0,$1ba,0,$1bc,0,$1be,0		

block1		ds.w	lines1*8	;ends $cf09

fake		dc.w	$d009,$fffe,$100,$1200
		dc.w	$e0,0,$e2,0,$182,0
		Dc.w	$1a0,0,$1a2,$fff,$1a4,$ccc,$1a6,$888
		Dc.w	$1a8,$555,$1aa,$79f,$1ac,$38f,$1ae,$16d

		dc.w	$d109,$fffe,$100,$1200
		dc.w	$e0,0,$e2,0,$182,0
		Dc.w	$1b0,$249,$1b2,$227,$1b4,$fcb,$1b6,$f98
		Dc.w	$1b8,$c76,$1ba,$f22,$1bc,$c00,$1be,$800

block2		ds.w	lines2*8
		
		dc.w	$ffd9,$fffe,$100,$1200

		dc.w	$0009,$fffe,$100,$200,$108,4
		dc.w	$180,$fff,$182,$fc8,$184,$a84,$186,$542
		dc.w	$192,$18
		dc.w	$0109,$fffe,$100,$3600
		dc.w	$180,$4
bits2		dc.w	$e0,0,$e2,0,$e8,0,$ea,0

blockblur	ds.w	lines4*6

		dc.w	$2009,$fffe,$100,$1200,$180,$fff
		dc.w	$108,0

block3		ds.w	lines3*10
		dc.w	$ffff,$fffe
		dc.w	$ffff,$fffe

copperlist2	dc.w	$8e,$1b41,$90,$40f1,$92,$30,$94,$d8,$104,$24,$102,0,$96,$8220
		dc.w	$100,$4200,$108,44*4-44,$10a,44*4-44,$180,$015
spritelist2	dc.w	$120,0,$122,0,$124,0,$126,0,$128,0,$12a,0,$12c,0,$12e,0
		dc.w	$130,0,$132,0,$134,0,$136,0,$138,0,$13a,0,$13c,0,$13e,0

		Dc.w	$1a0,0,$1a2,$fff,$1a4,$ccc,$1a6,$888
		Dc.w	$1a8,$555,$1aa,$79f,$1ac,$38f,$1ae,$16d
		Dc.w	$1b0,$249,$1b2,$227,$1b4,$fcb,$1b6,$f98
		Dc.w	$1b8,$c76,$1ba,$f22,$1bc,$c00,$1be,$800

bits1_1		dc.w	$e0,0,$e2,0,$e4,0,$e6,0,$e8,0,$ea,0,$ec,0,$ee,0

logopal		dc.w	$180,$015,$182,$015,$184,$015,$186,$015,$188,$015,$18a,$015,$18c,$015,$18e,$015
		dc.w	$190,$015,$192,$015,$194,$015,$196,$015,$198,$015,$19a,$015,$19c,$015,$19e,$015		

		dc.w	$ffd9,$fffe,$100,$200

upline		dc.w	$1e09,$fffe,$180,$015
		dc.w	$1f09,$fffe,$180,$015

		dc.w	$2009,$fffe
cline		ds.l	59+1

		dc.w	$ffff,$fffe
		dc.w	$ffff,$fffe

		Section	'Non-chip',DATA

cols1		incbin	bigcopper_cols
cols2		incbin	smallcopper_cols
colzend		EVEN
;sine		incbin	sine(512*300).dat
sine		incbin	sine512x300.dat

		Section	'GFX',DATA_C

		ds.l	(44*144)/4
fx_gfx1		incbin	sin1.352x144x1
		ds.l	(44*144)/4
fx_gfx2		incbin	sin2.352x144x1
font1		incbin	safont1.944x30x2.bit
font2		incbin	safont2.944x16x4.ilbm
logo		incbin	dc_logo352x85x4.ilbm
logoend		EVEN
spritedata	incbin	sonic.dat

		Section	'Music',DATA_C

		IFNE	music
mt_data		incbin	mod.shitty-beeper
		ENDC

		Section	'Screens',BSS_C

scrollbuffer	ds.l	(48*32*2)/4
charbuffer	ds.l	(44*4)*80
screen		ds.l	$4010

