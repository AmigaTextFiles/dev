
; Listings17o.s = Trainmenu.S
	
; Trainermenu by Einstein/Sceptic V0.985
; Sound and GFX by Flite/Sceptic
; Questions, bug reports or ideas .... leave me a messy on PALERIDER

; DO NOT SPREAD THIS SOURCE

auge		=	1024
obj		=	00

txtbpladda	=	2
linest		=	220

;------------------------------------------------------------------------------
setmenuwait	=	5	; VBI`s to wait between to possible number
				; changes in Trainmenu
xspeed		=	2	; Rotation Speed of Vectors x-,y-,zspeed
yspeed		=	1
zspeed		=	3
;------------------------------------------------------------------------------

wblit		macro
.wblit\@	btst	#14,$2(A5)
		bne.s	.wblit\@
		endm

start		movem.l	d0-a6,-(A7)

		lea	$dff000,a5

		move.w	$1c(A5),d0
		or.w	#$8000,d0
		move.w	d0,-(A7)

		move.w	$1e(A5),d0
		or.w	#$8000,d0
		move.w	d0,-(A7)
		
		move.w	#$7fff,$9a(a5)
		move.w	#$7fff,$9c(a5)
		
		lea	logo,a0
		lea	logobpl,a1
		moveq	#4-1,d7
.ilogobpl	move.l	a0,d0
		move.w	d0,6(a1)
		swap	d0
		move.w	d0,2(a1)
		addq.l	#8,a1
		lea	40(a0),a0
		dbf	d7,.ilogobpl

		lea	logo+44*40*4,a0
		lea	linebpl,a1
		moveq	#4-1,d7
.ilinebpl	move.l	a0,d0
		move.w	d0,6(a1)
		swap	d0
		move.w	d0,2(a1)
		addq.l	#8,a1
		lea	40(a0),a0
		dbf	d7,.ilinebpl
		
		lea	vecbpl1,a0
		lea	vecbpladr,a1
		move.l	a0,d0
		move.w	d0,6(A1)
		swap	d0
		move.w	d0,2(A1)

		lea	txtbpl,a0
		lea	txtbpladr,a1
		move.l	a0,d0
		move.w	d0,6(A1)
		swap	d0
		move.w	d0,2(A1)
		
		lea	txttab(pc),a0
		lea	offtab(pc),a1
		moveq	#0,d0
		move.w	#255-1,d7
.loop		move.l	a0,a2
		moveq	#-1,d1
.getoff		addq.b	#1,d1
		tst.b	(a2)
		beq.s	.notthere
		cmp.b	(a2)+,d0
		bne.s	.getoff
		move.b	d1,(a1)
		bra.s	.nf
.notthere	move.b	#55,(a1)
.nf		addq.l	#1,a1
		addq.b	#1,d0
		dbf	d7,.loop

		lea	scrolltxttab(pc),a0
		lea	scrollofftab(pc),a1
		moveq	#0,d0
		move.w	#255-1,d7
.sotloop	move.l	a0,a2
		moveq	#-1,d1
.sotgetoff	addq.b	#1,d1
		tst.b	(a2)
		beq.s	.sotnotthere
		cmp.b	(a2)+,d0
		bne.s	.sotgetoff
		move.b	d1,(a1)
		bra.s	.sotnf
.sotnotthere	move.b	#26,(a1)
.sotnf		addq.l	#1,a1
		addq.b	#1,d0
		dbf	d7,.sotloop

		bsr	mt_init
		
		move.l	pagetab(pc),a0
		lea	txtbpl,a1
		bsr	outtxt

		move.l	pagetab+4(pc),a0
		lea	txtbpl+320*linest/8,a1
		bsr	outtxt	

		lea	lines(pc),a0
		subq.w	#1,(A0)
		move.w	(A0)+,d7
.lineloop	move.w	(A0),d0
		asl.w	#2,d0
		move.w	d0,(a0)+
		move.w	(A0),d0
		asl.w	#2,d0
		move.w	d0,(a0)+
		dbf	d7,.lineloop

		lea	dots(pc),a0
		subq.w	#1,(A0)
		move.w	(A0)+,d7
.dotloop	move.w	(A0),d0
		sub.w	#160,d0
		move.w	d0,(A0)+
		move.w	(a0),d0
		sub.w	#128,d0
		move.w	d0,(A0)+
		dbf	d7,.dotloop

		move.l	$6c,-(a7)
		move.l	#vbi,$6c
		
		lea	coplist,a0
		move.l	a0,$80(A5)
		clr.w	$88(A5)
		
		move.w	#$c010,$9a(a5)

waitm		btst	#10,$dff016
		beq.w	prevpage
		btst	#6,$bfe001
		beq.w	nextpage
		bra.s	waitm		

endof		move.w	#1,fadeflag
.waitend1	tst.w	fadeflag
		bne.s	.waitend1

		bsr	buildtrainmenu

		lea	menustruct(pc),a0
		move.w	4(A0),d0
		mulu	#8,d0
		add.w	#$59,d0
		move.b	d0,mwait1
		add.b	#7,d0
		move.b	d0,mwait2

		move.l	#newcolors,newcoladr+2
		
		lea	menustruct(pc),a0
		moveq	#-1,d7
.sendloop	addq.w	#1,d7
		lea	16(a0),a0
		cmp.l	#-1,(A0)
		bne.s	.sendloop
		mulu	#10,d7
		move.w	d7,max

.waitoff1	btst	#6,$bfe001
		beq.s	.waitoff1
.waitoff2	btst	#10,$dff016
		beq.s	.waitoff2

		move.w	#1,fadeflag
.waitend2	tst.w	fadeflag
		bne.s	.waitend2

		lea	mwait1+4,a0
		moveq	#16-1,d7
.changecol	move.w	#$708,2(A0)
		addq.l	#4,a0
		dbf	d7,.changecol

		move.w	#1,menuflag
.waiton1	tst.w	menuflag
		bne.s	.waiton1
;******************************************************************************
;******************************************************************************
;******************************************************************************




; Insert Here your Routines which install some routines in mem
; or just set some Flags.. The selected state of the Gadgets can you
; get from the "menustruct" structure. 




;******************************************************************************
;******************************************************************************
;******************************************************************************
		move.l	4.w,a6
		lea	gfxname(pc),a1
		jsr	-408(A6)
		move.l	d0,a1
		move.l	38(A1),$80(A5)
		jsr	-414(A6)
		bsr	mt_end
		move.l	(a7)+,$6c
		move.w	#$8020,$96(a5)
		move.w	#$7fff,$9a(a5)
		move.w	#$7fff,$9c(a5)
		move.w	(a7)+,$9c(a5)
		move.w	(a7)+,$9a(a5)
		movem.l	(a7)+,d0-a6
		moveq	#0,d0
		rts
;------------------------------------------------------------------------------
buildtrainmenu	lea	txtbpl,a1
		lea	traintxt(pc),a0
		bsr	outtxt
		lea	txtbpl,a0
		lea	txtbpladr,a1
		move.l	a0,d0
		move.w	d0,6(A1)
		swap	d0
		move.w	d0,2(A1)
		rts

traintxt	dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"         unlimited live   : yo!         ",10
		dc.b	"                                        ",10
		dc.b	"         unlimited energy : yo!         ",10
		dc.b	"                                        ",10
		dc.b	"         start level      : 000         ",10
		dc.b	"                                        ",10
		dc.b	"                start game              ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	0
		even

yesnogad	macro
		dc.w	1	; Yes No Gad Flag
		dc.w	\1	; X-Pos of Txt
		dc.w	\2	; y-Pos
		dc.w	\3	; Buffer 1 - Yes/0-No
		dc.w	-1,-1,-1,-1	; Dummy
		endm

numbergad	macro
		dc.w	2
		dc.w	\1	; X- Pos
		dc.w	\2	; Y-Pos
		dc.w	\3	; Min
		dc.w	\4	; Max
		dc.w	\5	; Start Value
		dc.w	-1,-1	; Dummy
		endm		

startgamegad	macro
		dc.w	3
		dc.w	\1		; Y Pos
		dc.w	\2
		dc.w	-1,-1,-1,-1,-1; Dummy
		endm

;******************************************************************************
;******************************************************************************
;******************************************************************************
;******************************************************************************

; Insert here your wished gadgets .... Every gadget structure is 16 bytes long

; numbergadet
; dc.w	2		; Flag to mark that is is a numbergadget
; dc.w	x-pos		; X Position in Chars
; dc.w	y-pos		; Y Position in Rows of Chars
; dc.w	min		; Minimum of counter
; dc.w	max		; Maximum of Counter
; dc.w	startval	; Starting Value
; dc.w	-1,-1		; Dummy
; numbergadget x-pos,y-pos,min,max,startup

; yesnogadget
; dc.w	1		; Flag to mark that is is an yes no gadget
; dc.w	x-pos		; X position
; dc.w	y-pos		; Y Position
; dc.w	0		; Startup State (1-Yes/0-No)
; dc.w	-1,-1,-1,-1	; Dummy
; yesnogadget x-pos,y-pos,startup

; startgamegadget
; dc.w	3		; Flag to mark that it is an Startgamegadget
; dc.w	x-pos		; Only Dummy but to make it more easy 
; dc.w  y-pos		; Y Position
; dc.w	-1,-1,-1,-1,-1	; Dummy
; startgamegadget x-pos(dummy),y-pos



; The gadgets have to be in the struct from top to bottom

menustruct	yesnogad	28,5,1
		yesnogad	28,7,1
		numbergad	28,9,0,5,0
		startgamegad	28,11
		dc.l	-1

;******************************************************************************
;******************************************************************************
;******************************************************************************
;******************************************************************************
;------------------------------------------------------------------------------
vbi		movem.l	d0-a6,-(a7)
		lea	$dff000,a5
		bsr	makescroll
		bsr	executemenu
		bsr	move
		bsr	dovecs
		bsr	mt_music
		bsr	fadeover
		move.w	#$10,$9c(a5)
		movem.l	(A7)+,d0-a6
		rte
;------------------------------------------------------------------------------
executemenu	tst.w	menuflag
		beq.w	nomenu
		
		moveq	#0,d0
		move.b	$dff00a,d0
		move.w	d0,d1
		sub.w	oldmy(pc),d0				

		cmp.w	#-$30,d0
		blt.s	.noaccept
		cmp.w	#$30,d0
		bgt.s	.noaccept

		move.w	my(pc),d2
		add.w	d0,d2

		tst.w	d2
		bge.s	.okmove1
		moveq	#0,d2
.okmove1	cmp.w	max(pc),d2
		ble.s	.okmove2
		move.w	max(pc),d2
.okmove2	move.w	d2,my
.noaccept	move.w	d1,oldmy

		move.w	my(pc),d0
		divu	#10,d0
		lsl.w	#4,d0
		lea	menustruct(pc),a0
		add.w	d0,a0
		move.w	4(a0),d0
		lsl.w	#3,d0
		add.w	#$59,d0
		move.b	d0,mwait1
		add.b	#7,d0
		move.b	d0,mwait2		

		subq.w	#1,menuwait
		bne.w	nomenu
		move.w	#1,menuwait

		btst	#10,$dff016
		bne.w	.notright
		cmp.w	#2,(A0)			; Num Gad LMB (Add)
		bne.s	.notlnumgad

		moveq	#0,d0
		move.w	10(a0),d0
		subq.w	#1,d0
		cmp.w	6(a0),d0
		blt.w	nomenu
		move.w	d0,10(a0)
		
		divu	#100,d0
		add.b	#"0",d0
		move.b	d0,numtxt
		swap	d0
		ext.l	d0
		divu	#10,d0
		add.b	#"0",d0
		move.b	d0,numtxt+1
		swap	d0
		add.b	#"0",d0
		move.b	d0,numtxt+2
		moveq	#0,d0
		move.w	4(A0),d0
		mulu	#8*40,d0
		add.w	2(A0),d0

		lea	txtbpl,a1
		add.w	d0,a1
		lea	numtxt(pc),a0
		bsr	outtxt
		move.w	#setmenuwait,menuwait		
		bra.w	nomenu		

.notlnumgad	cmp.w	#1,(A0)		; Yes No Gad LMB
		bne.s	.notryesnogad
		move.w	4(A0),d0
		mulu	#8*40,d0
		add.w	2(A0),d0
		lea	txtbpl,a1
		add.w	d0,a1
		move.w	#1,6(a0)		
		lea	notxt(pc),a0
		bsr	outtxt
		bra.w	nomenu
.notryesnogad	cmp.w	#3,(a0)
		bne.s	.notright
		clr.w	menuflag
		bra.w	nomenu

.notright	btst	#6,$bfe001
		bne.w	nomenu

		cmp.w	#2,(A0)			; Num Gad LMB (Add)
		bne.s	.notrnumgad

		moveq	#0,d0
		move.w	10(a0),d0
		addq.w	#1,d0
		cmp.w	8(a0),d0
		bgt.w	nomenu
		move.w	d0,10(a0)
		
		divu	#100,d0
		add.b	#"0",d0
		move.b	d0,numtxt
		swap	d0
		ext.l	d0
		divu	#10,d0
		add.b	#"0",d0
		move.b	d0,numtxt+1
		swap	d0
		add.b	#"0",d0
		move.b	d0,numtxt+2
		moveq	#0,d0
		move.w	4(A0),d0
		mulu	#8*40,d0
		add.w	2(A0),d0

		lea	txtbpl,a1
		add.w	d0,a1
		lea	numtxt(pc),a0
		bsr	outtxt

		move.w	#setmenuwait,menuwait
		
		bra.s	nomenu		

.notrnumgad	cmp.w	#1,(a0)
		bne.s	.notlyesnogad
		move.w	4(A0),d0
		mulu	#8*40,d0
		add.w	2(A0),d0
		lea	txtbpl,a1
		add.w	d0,a1
		move.w	#1,6(a0)		
		lea	yestxt(pc),a0
		bsr	outtxt
		bra.s	nomenu
.notlyesnogad	cmp.w	#3,(a0)
		bne.s	nomenu
		clr.w	menuflag
nomenu		rts

;------------------------------------------------------------------------------
fadeover	tst.w	fadeflag
		beq.w	nofade

		moveq	#0,d6

newcoladr	lea	origcols,a0
		lea	tochangecols,a1
		moveq	#16-1,d7
.changeloop	move.w	2(a0),d0	
		move.w	d0,d1
		move.w	d1,d2
		move.w	2(a1),d3
		move.w	d3,d4
		move.w	d4,d5

		and.w	#$00f,d0
		and.w	#$0f0,d1
		and.w	#$f00,d2

		and.w	#$00f,d3
		and.w	#$0f0,d4
		and.w	#$f00,d5
		
		cmp.w	d0,d3
		beq.s	.nochange1
		blt.s	.okadd1
		subq.w	#1,d3
		moveq	#1,d6
		bra.s	.nochange1
.okadd1		moveq	#1,d6
		addq.w	#1,d3


.nochange1	cmp.w	d1,d4
		beq.s	.nochange2
		blt.s	.okadd2
		moveq	#1,d6
		sub.w	#$10,d4
		bra.s	.nochange2
.okadd2		moveq	#1,d6
		add.w	#$10,d4


.nochange2	cmp.w	d2,d5
		beq.s	.nochange3
		blt.s	.okadd3
		moveq	#1,d6
		sub.w	#$100,d5
		bra.s	.nochange3
.okadd3		moveq	#1,d6
		add.w	#$100,d5


.nochange3	or.w	d3,d4
		or.w	d4,d5
		move.w	d5,2(a1)
		addq.l	#4,a1
		addq.l	#4,a0
		dbf	d7,.changeloop

		tst.w	d6
		bne.s	nofade
		clr.w	fadeflag
nofade		rts
;------------------------------------------------------------------------------
makescroll	wblit
		move.l	#scrollbpl+10*40-2,a0
		move.l	a0,$50(A5)
		move.l	a0,$54(a5)
		move.l	#$19f00002,$40(a5)
		move.w	#0,$64(A5)
		move.w	#0,$66(A5)
		move.l	#-1,$44(A5)
		move.w	#10*64+20,$58(a5)
		wblit

		lea	logo+49*40*4,a0
		lea	scrollbpl,a1
		lea	scrollmask,a2
		move.l	a0,$54(A5)
		move.l	a1,$50(a5)
		move.l	a2,$4c(a5)
		move.l	#$0dc00000,$40(a5)
		move.l	#-1,$44(A5)
		move.w	#4,$64(a5)
		move.w	#0,$62(a5)
		move.w	#3*40+4,$66(A5)
		move.w	#9*64+18,$58(A5)
		wblit

; %11110000
; %11001100
; %10101010
; %11000000
		
		subq.w	#1,scrollcountt
		bne.s	.nnchar
		move.w	#8,scrollcountt
		move.l	scrollptr(pc),a0
		moveq	#0,d0
		move.b	(A0)+,d0
		bne.s	.okchar		
		move.l	#scrolltxt,a0
		move.b	(A0)+,d0
.okchar		move.l	a0,scrollptr
		lea	scrollfont,a0
		lea	scrollofftab(pc),a1
		move.b	(a1,d0.w),d0
		lea	(a0,d0.w),a0
		lea	scrollbpl+39,a1
		move.b	0*54(a0),0*40(a1)
		move.b	1*54(a0),1*40(a1)
		move.b	2*54(a0),2*40(a1)
		move.b	3*54(a0),3*40(a1)
		move.b	4*54(a0),4*40(a1)
		move.b	5*54(a0),5*40(a1)
		move.b	6*54(a0),6*40(a1)
.nnchar		rts

scrollcountt	dc.w	8		
scrollptr	dc.l	scrolltxt
;------------------------------------------------------------------------------
move		tst.w	scrolldir
		beq.w	.nomove
		cmp.w	#1,scrolldir
		bne.s	.noupscroll
		move.w	scrollcount(pc),d0
		cmp.w	#linest,d0
		ble.s	.okdd
		move.w	#linest,d0
.okdd		addq.w	#4,scrollcount
		mulu	#40,d0
		lea	txtbpl,a0
		add.l	a0,d0
		move.w	d0,txtbpladr+6
		swap	d0
		move.w	d0,txtbpladr+2
		cmp.w	#linest,scrollcount
		ble.s	.nomove
		bra.s	.nodownscrol

.noupscroll	cmp.w	#2,scrolldir
		bne.s	.nodownscrol
		subq.w	#4,scrollcount
		move.w	scrollcount(pc),d0
		tst.w	d0
		bge.s	.okdd2
		moveq	#0,d0
.okdd2		mulu	#40,d0
		lea	txtbpl,a0
		add.l	a0,d0
		move.w	d0,txtbpladr+6
		swap	d0
		move.w	d0,txtbpladr+2
		tst.w	scrollcount
		bge.s	.nomove
.nodownscrol	clr.w	scrolldir
.nomove		rts
;------------------------------------------------------------------------------
nextpage	move.w	#$400,d7
.wloop		btst	#10,$dff016
		beq.w	endof
		dbf	d7,.wloop

		lea	pagetab(pc),a0
		move.w	pagenum(pc),d0
		add.w	d0,d0
		add.w	d0,d0
		tst.l	4(a0,d0.w)
		bmi.w	waitm
		addq.w	#1,pagenum
		move.l	4(a0,d0.w),d7

		move.w	txtbpladr+2,d0
		swap	d0
		move.w	txtbpladr+6,d0

		cmp.l	#txtbpl,d0
		beq.s	.okpage

		lea	txtbpl+40*linest,a0
		lea	txtbpl,a1
		move.l	#linest*10-1,d6
.copy68000	move.l	(a0)+,(a1)+
		dbf	d6,.copy68000

		move.l	#txtbpl,d0
		move.w	d0,txtbpladr+6
		swap	d0
		move.w	d0,txtbpladr+2
		
.okpage		move.l	d7,a0
		lea	txtbpl+linest*40,a1
		bsr	outtxt	

		clr.w	scrollcount
		move.w	#1,scrolldir
.wlop		tst.w	scrolldir
		bne.s	.wlop
		bra.w	waitm

prevpage	move.w	#$400,d7
.wloop		btst	#6,$bfe001
		beq.w	endof
		dbf	d7,.wloop

		tst.w	pagenum
		beq.w	waitm
		subq.w	#1,pagenum
		move.w	pagenum(pc),d0
		add.w	d0,d0
		add.w	d0,d0
		lea	pagetab(pc),a0
		move.l	(A0,d0.w),d7

		move.w	txtbpladr+2,d0
		swap	d0
		move.w	txtbpladr+6,d0

		cmp.l	#txtbpl,d0
		bne.s	.okpage

		lea	txtbpl+40*linest,a1
		lea	txtbpl,a0
		move.l	#linest*10-1,d6
.copy68000	move.l	(a0)+,(a1)+
		dbf	d6,.copy68000

		move.l	#txtbpl+40*linest,d0
		move.w	d0,txtbpladr+6
		swap	d0
		move.w	d0,txtbpladr+2

.okpage		move.l	d7,a0
		lea	txtbpl,a1
		bsr	outtxt	

		move.w	#linest,scrollcount
		move.w	#2,scrolldir
.wlop		tst.w	scrolldir
		bne.s	.wlop
		bra.w	waitm

pagenum		dc.w	0
scrollcount	dc.w	0
scrolldir	dc.w	0
;------------------------------------------------------------------------------
dovecs		lea	dbadrs(pc),a0
		move.l	(A0),d0
		move.l	4(A0),(a0)+
		move.l	4(A0),(A0)+
		move.l	4(a0),(A0)+
		move.l	4(A0),(A0)+
		move.l	d0,(A0)
		
		lea	dbadrs+4(pc),a0
		lea	vecbpladr,a1
		moveq	#4-1,d7
.loop		move.l	(A0)+,d0
		add.l	#33*40,d0
		move.w	d0,6(A1)
		swap	d0
		move.w	d0,2(A1)
		addq.l	#8,a1
		dbf	d7,.loop

		wblit

		move.l	dbadrs(pc),a0
		lea	30*40(a0),a0
		move.l	a0,$54(A5)
		move.l	#$01000000,$40(A5)
		move.w	#0,$66(A5)
		move.w	#200*64+20,$58(A5)

		lea	sinus(pc),a6
		lea	xangle(pc),a4
		move.w	(a4),d0
		add.w	#xspeed,d0
		cmp.w	#360,d0
		blt.s	.xangleok
		sub.w	#360,d0
.xangleok	move.w	d0,(a4)
		add.w	d0,d0
		move.w	(a6,d0.w),d3
		add.w	#180,d0
		move.w	(a6,d0.w),d4
		
		lea	yangle(pc),a4
		move.w	(a4),d0
		add.w	#yspeed,d0
		cmp.w	#360,d0
		blt.s	.yangleok
		sub.w	#360,d0
.yangleok	move.w	d0,(a4)
		add.w	d0,d0
		move.w	(a6,d0.w),a0
		add.w	#90,d0
		move.w	90(a6,d0.w),a1
		
		lea	zangle(pc),a4
		move.w	(a4),d0
		add.w	#zspeed,d0
		cmp.w	#360,d0
		blt.s	.zangleok
		sub.w	#360,d0
.zangleok	move.w	d0,(a4)
		add.w	d0,d0
		move.w	(a6,d0.w),a2
		add.w	#180,d0
		move.w	(a6,d0.w),a3
		
		; d0 - x
 		; d1 - y
		; d2 - z
		; d3 - Sin Alpha
		; d4 - Cos Alpha
		; d5 - Calculate Òegisteò
		; d6 - Calculate Register
		; d7 - Loop Counter
		; a0 - Sin Beta
		; a1 - Cos Beta
		; a2 - Sin Gamma
		; a3 - Cos Gamma
		; a4 - Dots
		; a5 - $dff000
		; a6 - DestiDots
		; a7 - Stack
		
		lea	dots(pc),a4
		lea	coordbuf(pc),a6
		move.w	(a4)+,d7
.rotateloop	movem.w	(a4)+,d0-d1		; Get Coords
		moveq	#0,d2

		; x - Rotation
		move.w	d2,d5		; z - d5
		muls	d4,d5		; cos(alpha)*z
		move.w	d1,d6		; y - d6
		muls	d3,d6		; sin(alpha)*y		
		add.l	d6,d5		; cos(alpha)*z+sin(alpha)*y
		add.l	d5,d5
		swap	d5
		muls	d4,d1		; cos(alpha)*y
		move.w	d2,d6		; z - d6
		muls	d3,d6		; sin(alpha)*z
		sub.l	d6,d1		; cos(alpha)*y-sin(alpha)*z
		add.l	d1,d1
		swap	d1
		move.w	d5,d2		; new z - d2		

		; y - Rotation
		move.w	a1,d5
		muls	d0,d5		; cos(beta)*x
		move.w	a0,d6
		muls	d2,d6		; sin(beta)*z
		add.l	d6,d5		; cos(beta)*x+sin(beta)*z
		add.l	d5,d5
		swap	d5
		move.w	a1,d6
		muls	d6,d2		; cos(beta)*z	
		move.w	a0,d6
		muls	d0,d6		; sin(beta)*x
		sub.l	d6,d2		; cos(beta)*z-sin(beta)*z
		add.l	d2,d2
		swap	d2
		move.w	d5,d0
						
		; z - Rotation
		move.w	a3,d5
		muls	d0,d5		; cos(gamma)*x
		move.w	a2,d6
		muls	d1,d6		; sin(gamma)*y
		add.l	d6,d5
		add.l	d5,d5
		swap	d5
		move.w	a3,d6
		muls	d6,d1		; cos(gamma)*y
		move.w	a2,d6
		muls	d0,d6		; sin(gamma)*x
		sub.l	d6,d1		; cos(gamma)*y-sin(gamma)*x
		add.l	d1,d1
		swap	d1
		move.w	d5,d0

		; 3d(x,y,z) - 2d(x,y)
		moveq	#10,d6
		move.w	#auge,d5	;auge
		add.w	#obj,d2
		sub.w	d5,d2
		ext.l	d0
		asl.l	d6,d0
		divs	d2,d0		;punkt x*auge/(punkt z-auge)
		neg.w	d0		;wert negieren
		add.w	#160,d0		;x coord addi 
		move.w	d0,(a6)+	;x
		ext.l	d1
		asl.l	d6,d1
		divs	d2,d1		;punkt y*auge/(punkt z-auge)
		add.w	#128,d1		;y coord addi
		move.w	d1,(a6)+	;y

		dbf	d7,.rotateloop

		wblit
		move.w	#$ffff,$72(a5)	
		move.w	#$ffff,$44(a5)	
		move.w	#$8000,$74(a5)
		moveq	#40,d4
		move.w	d4,$60(a5)
		move.w	d4,$66(a5)

		lea	lines(pc),a1
		lea	coordbuf(pc),a2

		move.w	(A1)+,d7
.lineloop	movem.w	(a1)+,d4-d5
		movem.w	(a2,d4.w),d0-d1
		movem.w	(a2,d5.w),d2-d3
		move.l	dbadrs(pc),a0
		bsr	drawline
		dbf	d7,.lineloop

		wblit

		move.l	dbadrs(pc),a0
		lea	320*240/8(a0),a0
		move.l	a0,$50(A5)
		move.l	a0,$54(A5)
		move.l	#-$1,$44(A5)
		move.l	#$09f00012,$40(A5)
		move.w	#0,d0
		move.w	d0,$64(A5)
		move.w	d0,$66(A5)		
		move.w	#220*64+20,$58(A5)

		rts
;------------------------------------------------------------------------------
outtxt		lea	offtab(pc),a2
		lea	font,a3
		moveq	#0,d0
		move.l	a1,a6
.cloop		move.b	(a0)+,d0
		beq.s	.nnchar
		cmp.b	#10,d0
		bne.s	.noreturn
		add.l	#8*40,a6
		move.l	a6,a1
		bra.s	.cloop
.noreturn	move.b	(a2,d0.w),d0
		lea	(a3,d0.w),a4
		move.b	0*56(a4),0*40(a1)
		move.b	1*56(a4),1*40(a1)
		move.b	2*56(a4),2*40(a1)
		move.b	3*56(a4),3*40(a1)
		move.b	4*56(a4),4*40(a1)
		move.b	5*56(a4),5*40(a1)
		move.b	6*56(a4),6*40(a1)
		addq.l	#1,a1
		bra.s	.cloop
.nnchar		rts
;------------------------------------------------------------------------------
; d0,d1,d2,d3	Coords
;------------------------------------------------------------------------------
drawline	move.w	d7,-(A7)
		cmp.w	d1,d3
		bgt.s	nohi2
		exg	d0,d2
		exg	d1,d3
nohi2		move.w	d0,d4
		move.w	d1,d5
		mulu	#40,d5
		add.w	d5,a0
		lsr.w	#4,d4
		add.w	d4,d4
		lea	(a0,d4.w),a0
		sub.w	d0,d2
		sub.w	d1,d3
		moveq	#$f,d5
		and.l	d5,d0
		moveq	#0,d7
		move.w	d0,d4
		eor.w	d5,d4
		bset	d4,d7
		ror.l	#4,d0
		move	#4,d0
		tst.w	d2
		bpl.s	l12
		addq.w	#1,d0
		neg.w	d2
l12		cmp.w	d2,d3
		ble.s	l21
		exg	d2,d3
		subq.w	#4,d0
		add.w	d0,d0
l21		move.w	d3,d4
		sub.w	d2,d4
		add.w	d4,d4
		add.w	d4,d4
		add.w	d3,d3
		move.w	d3,d6
		sub.w	d2,d6
		bpl.s	l31
		or.w	#16,d0
l31		add.w	d3,d3
		add.w	d0,d0
		add.w	d0,d0
		addq.w	#1,d2
		lsl.w	#6,d2
		addq.w	#2,d2
		swap	d3
		move.w	d4,d3
		or.l	#$0b5a0003,d0
		wblit
		eor.w	d7,(a0)
		move.l	d3,$62(a5)
		move	d6,$52(a5)
		move.l	a0,$48(a5)
		move.l	a0,$54(a5)
		move.l	d0,$40(a5)
		move	d2,$58(a5)
		move.w	(A7)+,d7
		rts
	*****************************************
	* Pro-Packer v2.1 Replay-Routine.	*
	* Based upon the PT1.1B-Replayer	*
	* by Lars 'ZAP' Hamre/Amiga Freelancers.*
	* Modified by Estrup/Static Bytes.	*
	*****************************************

mt_lev6use=		0		; 0=NO, 1=YES
mt_finetuneused=	0		; 0=NO, 1=YES

mt_init	LEA	mt_data,A0
	MOVE.L	A0,mt_SongDataPtr
	LEA	250(A0),A1
	MOVE.W	#511,D0
	MOVEQ	#0,D1
mtloop	MOVE.L	D1,D2
	SUBQ.W	#1,D0
mtloop2	MOVE.B	(A1)+,D1
	CMP.W	D2,D1
	BGT.S	mtloop
	DBRA	D0,mtloop2
	ADDQ	#1,D2

	MOVE.W	D2,D3
	MULU	#128,D3
	ADD.L	#766,D3
	ADD.L	mt_SongDataPtr(PC),D3
	MOVE.L	D3,mt_LWTPtr

	LEA	mt_SampleStarts(PC),A1
	MULU	#128,D2
	ADD.L	#762,D2
	ADD.L	(A0,D2.L),D2
	ADD.L	mt_SongDataPtr(PC),D2
	ADDQ.L	#4,D2
	MOVE.L	D2,A2
	MOVEQ	#30,D0
mtloop3	MOVE.L	A2,(A1)+
	MOVEQ	#0,D1
	MOVE.W	(A0),D1
	ADD.L	D1,D1
	ADD.L	D1,A2
	LEA	8(A0),A0
	DBRA	D0,mtloop3

	OR.B	#2,$BFE001
	lea	mt_speed(PC),A4
	MOVE.B	#6,(A4)
	CLR.B	mt_counter-mt_speed(A4)
	CLR.B	mt_SongPos-mt_speed(A4)
	CLR.W	mt_PatternPos-mt_speed(A4)
mt_end	LEA	$DFF096,A0
	CLR.W	$12(A0)
	CLR.W	$22(A0)
	CLR.W	$32(A0)
	CLR.W	$42(A0)
	MOVE.W	#$F,(A0)
	RTS

mt_music
	MOVEM.L	D0-D4/D7/A0-A6,-(SP)
	lea	mt_speed(pc),a4
	ADDQ.B	#1,mt_counter
	MOVE.B	mt_counter(PC),D0
	CMP.B	mt_speed(PC),D0
	BLO.S	mt_NoNewNote
	CLR.B	mt_counter
	TST.B	mt_PattDelTime2
	BEQ.S	mt_GetNewNote
	BSR.S	mt_NoNewAllChannels
	BRA.W	mt_dskip

mt_NoNewNote
	BSR.S	mt_NoNewAllChannels
	BRA.W	mt_NoNewPosYet

mt_NoNewAllChannels
	LEA	$DFF090,A5
	LEA	mt_chan1temp-44(PC),A6
	BSR.W	mt_CheckEfx
	BSR.W	mt_CheckEfx
	BSR.W	mt_CheckEfx
	BRA.W	mt_CheckEfx

mt_GetNewNote
	MOVE.L	mt_SongDataPtr(PC),A0
	LEA	(A0),A3
	LEA	122(A0),A2	;pattpo
	LEA	762(A0),A0	;patterndata
	CLR.W	mt_DMACONtemp

	LEA	$DFF090,A5
	LEA	mt_chan1temp-44(PC),A6
	BSR.S	mt_DoVoice
	BSR.S	mt_DoVoice
	BSR.B	mt_DoVoice
	BSR.B	mt_DoVoice
	BRA.W	mt_SetDMA

mt_DoVoice
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE.B	mt_SongPos(PC),D0
	LEA	128(A2),A2
	MOVE.B	(A2,D0.W),D1
	MOVE.W	mt_PatternPos(PC),D2
	LSL	#7,D1
	LSR.W	#1,D2
	ADD.W	D2,D1
	LEA	$10(A5),A5
	LEA	44(A6),A6

	TST.L	(A6)
	BNE.S	mt_plvskip
	BSR.W	mt_PerNop
mt_plvskip
	MOVE.W	(A0,D1.W),D1
	LSL.W	#2,D1
	MOVE.L	A0,-(sp)
	MOVE.L	mt_LWTPtr(PC),A0
	MOVE.L	(A0,D1.W),(A6)
	MOVE.L	(sp)+,A0
	MOVE.B	2(A6),D2
	AND.L	#$F0,D2
	LSR.B	#4,D2
	MOVE.B	(A6),D0
	AND.B	#$F0,D0
	OR.B	D0,D2
	BEQ.B	mt_SetRegs
	MOVEQ	#0,D3
	LEA	mt_SampleStarts(PC),A1
	SUBQ	#1,D2
	MOVE	D2,D4
	ADD	D2,D2
	ADD	D2,D2
	LSL	#3,D4
	MOVE.L	(A1,D2.L),4(A6)
	MOVE.W	(A3,D4.W),8(A6)
	MOVE.W	(A3,D4.W),40(A6)
	MOVE.W	2(A3,D4.W),18(A6)
	MOVE.L	4(A6),D2	; Get start
	MOVE.W	4(A3,D4.W),D3	; Get repeat
	BEQ.S	mt_NoLoop
	MOVE.W	D3,D0		; Get repeat
	ADD.W	D3,D3
	ADD.L	D3,D2		; Add repeat
	ADD.W	6(A3,D4.W),D0	; Add replen
	MOVE.W	D0,8(A6)

mt_NoLoop
	MOVE.L	D2,10(A6)
	MOVE.L	D2,36(A6)
	MOVE.W	6(A3,D4.W),14(A6)	; Save replen
	MOVE.B	19(A6),9(A5)	; Set volume
mt_SetRegs
	MOVE.W	(A6),D0
	AND.W	#$0FFF,D0
	BEQ.W	mt_CheckMoreEfx	; If no note

	IF mt_finetuneused=1 THEN
	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0E50,D0
	BEQ.S	mt_DoSetFineTune
	ENDC

	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	CMP.B	#3,D0	; TonePortamento
	BEQ.S	mt_ChkTonePorta
	CMP.B	#5,D0
	BEQ.S	mt_ChkTonePorta
	CMP.B	#9,D0	; Sample Offset
	BNE.S	mt_SetPeriod
	BSR.W	mt_CheckMoreEfx
	BRA.S	mt_SetPeriod

mt_ChkTonePorta
	BSR.W	mt_SetTonePorta
	BRA.W	mt_CheckMoreEfx

mt_DoSetFineTune
	BSR.W	mt_SetFineTune

mt_SetPeriod
	MOVEM.L	D1/A1,-(SP)
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1

	IF mt_finetuneused=0 THEN
	MOVE.W	D1,16(A6)

	ELSE
mt_SetPeriod2
	LEA	mt_PeriodTable(PC),A1
	MOVEQ	#36,D7
mt_ftuloop
	CMP.W	(A1)+,D1
	BHS.S	mt_ftufound
	DBRA	D7,mt_ftuloop
mt_ftufound
	MOVEQ	#0,D1
	MOVE.B	18(A6),D1
	LSL	#3,D1
	MOVE	D1,D0
	LSL	#3,D1
	ADD	D0,D1
	MOVE.W	-2(A1,D1.W),16(A6)
	ENDC

	MOVEM.L	(SP)+,D1/A1

	MOVE.W	2(A6),D0
	AND.W	#$0FF0,D0
	CMP.W	#$0ED0,D0 ; Notedelay
	BEQ.W	mt_CheckMoreEfx

	MOVE.W	20(A6),$DFF096
	BTST	#2,30(A6)
	BNE.S	mt_vibnoc
	CLR.B	27(A6)
mt_vibnoc
	BTST	#6,30(A6)
	BNE.S	mt_trenoc
	CLR.B	29(A6)
mt_trenoc
	MOVE.L	4(A6),(A5)	; Set start
	MOVE.W	8(A6),4(A5)	; Set length
	MOVE.W	16(A6),6(A5)	; Set period
	MOVE.W	20(A6),D0
	OR.W	D0,mt_DMACONtemp
	BRA.W	mt_CheckMoreEfx
 
mt_SetDMA
	IF mt_lev6use=1 THEN
	lea	$bfd000,a3
	move.b	#$7f,$d00(a3)
	move.w	#$2000,$dff09c
	move.w	#$a000,$dff09a
	move.l	$78.w,mt_oldirq
	move.l	#mt_irq1,$78.w
	moveq	#0,d0
	move.b	d0,$e00(a3)
	move.b	#$a8,$400(a3)
	move.b	d0,$500(a3)
	move.b	#$11,$e00(a3)
	move.b	#$81,$d00(a3)
	OR.W	#$8000,mt_DMACONtemp
	BRA.w	mt_dskip

	ELSE
	OR.W	#$8000,mt_DMACONtemp
	bsr.w	mt_WaitDMA
	ENDC

	IF mt_lev6use=1 THEN
mt_irq1:tst.b	$bfdd00
	MOVE.W	mt_dmacontemp(pc),$DFF096
	move.w	#$2000,$dff09c
	move.l	#mt_irq2,$78.w
	rte

	ELSE
	MOVE.W	mt_dmacontemp(pc),$DFF096
	bsr.w	mt_WaitDMA
	ENDC

	IF mt_lev6use=1 THEN
mt_irq2:tst.b	$bfdd00
	movem.l	a5-a6,-(a7)
	ENDC

	LEA	$DFF0A0,A5
	LEA	mt_chan1temp(PC),A6
	MOVE.L	10(A6),(A5)
	MOVE.W	14(A6),4(A5)
	MOVE.L	54(A6),$10(A5)
	MOVE.W	58(A6),$14(A5)
	MOVE.L	98(A6),$20(A5)
	MOVE.W	102(A6),$24(A5)
	MOVE.L	142(A6),$30(A5)
	MOVE.W	146(A6),$34(A5)

	IF mt_lev6use=1 THEN
	move.b	#0,$bfde00
	move.b	#$7f,$bfdd00
	move.l	mt_oldirq(pc),$78.w
	move.w	#$2000,$dff09c
	movem.l	(a7)+,a5-a6
	rte
	ENDC

mt_dskip
	lea	mt_speed(PC),A4
	ADDQ.W	#4,mt_PatternPos-mt_speed(A4)
	MOVE.B	mt_PattDelTime-mt_speed(A4),D0
	BEQ.S	mt_dskc
	MOVE.B	D0,mt_PattDelTime2-mt_speed(A4)
	CLR.B	mt_PattDelTime-mt_speed(A4)
mt_dskc	TST.B	mt_PattDelTime2-mt_speed(A4)
	BEQ.S	mt_dska
	SUBQ.B	#1,mt_PattDelTime2-mt_speed(A4)
	BEQ.S	mt_dska
	SUBQ.W	#4,mt_PatternPos-mt_speed(A4)
mt_dska	TST.B	mt_PBreakFlag-mt_speed(A4)
	BEQ.S	mt_nnpysk
	SF	mt_PBreakFlag-mt_speed(A4)
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	CLR.B	mt_PBreakPos-mt_speed(A4)
	LSL	#2,D0
	MOVE.W	D0,mt_PatternPos-mt_speed(A4)
mt_nnpysk
	CMP.W	#256,mt_PatternPos-mt_speed(A4)
	BLO.S	mt_NoNewPosYet
mt_NextPosition	
	MOVEQ	#0,D0
	MOVE.B	mt_PBreakPos(PC),D0
	LSL	#2,D0
	MOVE.W	D0,mt_PatternPos-mt_speed(A4)
	CLR.B	mt_PBreakPos-mt_speed(A4)
	CLR.B	mt_PosJumpFlag-mt_speed(A4)
	ADDQ.B	#1,mt_SongPos-mt_speed(A4)
	AND.B	#$7F,mt_SongPos-mt_speed(A4)
	MOVE.B	mt_SongPos(PC),D1
	MOVE.L	mt_SongDataPtr(PC),A0
	CMP.B	248(A0),D1
	BLO.S	mt_NoNewPosYet
	CLR.B	mt_SongPos-mt_speed(A4)
mt_NoNewPosYet	
	TST.B	mt_PosJumpFlag-mt_speed(A4)
	BNE.S	mt_NextPosition
	MOVEM.L	(SP)+,D0-D4/D7/A0-A6
	RTS

mt_CheckEfx
	LEA	$10(A5),A5
	LEA	44(A6),A6
	BSR.W	mt_UpdateFunk
	MOVE.W	2(A6),D0
	AND.W	#$0FFF,D0
	BEQ.S	mt_PerNop
	MOVE.B	2(A6),D0
	MOVEQ	#$0F,D1
	AND.L	D1,D0
	BEQ.S	mt_Arpeggio
	SUBQ	#1,D0
	BEQ.W	mt_PortaUp
	SUBQ	#1,D0
	BEQ.W	mt_PortaDown
	SUBQ	#1,D0
	BEQ.W	mt_TonePortamento
	SUBQ	#1,D0
	BEQ.W	mt_Vibrato
	SUBQ	#1,D0
	BEQ.W	mt_TonePlusVolSlide
	SUBQ	#1,D0
	BEQ.W	mt_VibratoPlusVolSlide
	SUBQ	#8,D0
	BEQ.W	mt_E_Commands
SetBack	MOVE.W	16(A6),6(A5)
	ADDQ	#7,D0
	BEQ.W	mt_Tremolo
	SUBQ	#3,D0
	BEQ.W	mt_VolumeSlide
mt_Return2
	RTS

mt_PerNop
	MOVE.W	16(A6),6(A5)
	RTS

mt_Arpeggio
	MOVEQ	#0,D0
	MOVE.B	mt_counter(PC),D0
	DIVS	#3,D0
	SWAP	D0
	TST.W	D0
	BEQ.S	mt_Arpeggio2
	SUBQ	#2,D0
	BEQ.S	mt_Arpeggio1
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	LSR.B	#4,D0
	BRA.S	mt_Arpeggio3

mt_Arpeggio2
	MOVE.W	16(A6),6(A5)
	RTS

mt_Arpeggio1
	MOVE.B	3(A6),D0
	AND.W	#15,D0
mt_Arpeggio3
	ADD.W	D0,D0
	LEA	mt_PeriodTable(PC),A0

	IF mt_finetuneused=1 THEN
	MOVEQ	#0,D1
	MOVE.B	18(A6),D1
	LSL	#3,D1
	MOVE	D1,D2
	LSL	#3,D1
	ADD	D2,D1
	ADD.L	D1,A0
	ENDC

	MOVE.W	16(A6),D1
	MOVEQ	#36,D7
mt_arploop
	CMP.W	(A0)+,D1
	BHS.S	mt_Arpeggio4
	DBRA	D7,mt_arploop
	RTS

mt_Arpeggio4
	MOVE.W	-2(A0,D0.W),6(A5)
	RTS

mt_FinePortaUp
	TST.B	mt_counter
	BNE.S	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaUp
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	SUB.W	D0,16(A6)
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#113,D0
	BPL.S	mt_PortaUskip
	AND.W	#$F000,16(A6)
	OR.W	#113,16(A6)
mt_PortaUskip
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS	
 
mt_FinePortaDown
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	#$0F,mt_LowMask
mt_PortaDown
	CLR.W	D0
	MOVE.B	3(A6),D0
	AND.B	mt_LowMask(PC),D0
	MOVE.B	#$FF,mt_LowMask
	ADD.W	D0,16(A6)
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	CMP.W	#856,D0
	BMI.S	mt_PortaDskip
	AND.W	#$F000,16(A6)
	OR.W	#856,16(A6)
mt_PortaDskip
	MOVE.W	16(A6),D0
	AND.W	#$0FFF,D0
	MOVE.W	D0,6(A5)
	RTS

mt_SetTonePorta
	MOVEM.L	A0,-(SP)
	MOVE.W	(A6),D2
	AND.W	#$0FFF,D2
	LEA	mt_PeriodTable(PC),A0

	IF	mt_finetuneused=1 THEN
	MOVEQ	#0,D0
	MOVE.B	18(A6),D0
	ADD	D0,D0
	MOVE	D0,D7
	ADD	D0,D0
	ADD	D0,D0
	ADD	D0,D7
	LSL	#3,D0
	ADD	D7,D0
	ADD.L	D0,A0
	ENDC

	MOVEQ	#0,D0
mt_StpLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_StpFound
	ADDQ	#2,D0
	CMP.W	#37*2,D0
	BLO.S	mt_StpLoop
	MOVEQ	#35*2,D0
mt_StpFound
	BTST	#3,18(A6)
	BEQ.S	mt_StpGoss
	TST.W	D0
	BEQ.S	mt_StpGoss
	SUBQ	#2,D0
mt_StpGoss
	MOVE.W	(A0,D0.W),D2
	MOVE.L	(SP)+,A0
	MOVE.W	D2,24(A6)
	MOVE.W	16(A6),D0
	CLR.B	22(A6)
	CMP.W	D0,D2
	BEQ.S	mt_ClearTonePorta
	BGE.W	mt_Return2
	MOVE.B	#1,22(A6)
	RTS

mt_ClearTonePorta
	CLR.W	24(A6)
	RTS

mt_TonePortamento
	MOVE.B	3(A6),D0
	BEQ.S	mt_TonePortNoChange
	MOVE.B	D0,23(A6)
	CLR.B	3(A6)
mt_TonePortNoChange
	TST.W	24(A6)
	BEQ.W	mt_Return2
	MOVEQ	#0,D0
	MOVE.B	23(A6),D0
	TST.B	22(A6)
	BNE.S	mt_TonePortaUp
mt_TonePortaDown
	ADD.W	D0,16(A6)
	MOVE.W	24(A6),D0
	CMP.W	16(A6),D0
	BGT.S	mt_TonePortaSetPer
	MOVE.W	24(A6),16(A6)
	CLR.W	24(A6)
	BRA.S	mt_TonePortaSetPer

mt_TonePortaUp
	SUB.W	D0,16(A6)
	MOVE.W	24(A6),D0
	CMP.W	16(A6),D0
	BLT.S	mt_TonePortaSetPer
	MOVE.W	24(A6),16(A6)
	CLR.W	24(A6)

mt_TonePortaSetPer
	MOVE.W	16(A6),D2
	MOVE.B	31(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_GlissSkip
	LEA	mt_PeriodTable(PC),A0

	IF mt_finetuneused=1 THEN
	MOVEQ	#0,D0
	MOVE.B	18(A6),D0
	LSL	#3,D0
	MOVE	D0,D1
	LSL	#3,D0
	ADD	D1,D0
	ADD.L	D0,A0
	ENDC

	MOVEQ	#0,D0
mt_GlissLoop
	CMP.W	(A0,D0.W),D2
	BHS.S	mt_GlissFound
	ADDQ	#2,D0
	CMP.W	#36*2,D0
	BLO.S	mt_GlissLoop
	MOVEQ	#35*2,D0
mt_GlissFound
	MOVE.W	(A0,D0.W),D2
mt_GlissSkip
	MOVE.W	D2,6(A5) ; Set period
	RTS

mt_Vibrato
	MOVE.B	3(A6),D0
	BEQ.S	mt_Vibrato2
	MOVE.B	26(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_vibskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_vibskip
	MOVE.B	3(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_vibskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_vibskip2
	MOVE.B	D2,26(A6)
mt_Vibrato2
	MOVE.B	27(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVE.B	30(A6),D2
	AND.W	#$03,D2
	BEQ.S	mt_vib_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_vib_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_vib_set
mt_vib_rampdown
	TST.B	27(A6)
	BPL.S	mt_vib_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_vib_set
mt_vib_sine
	MOVE.B	0(A4,D0.W),D2
mt_vib_set
	MOVE.B	26(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#7,D2
	MOVE.W	16(A6),D0
	TST.B	27(A6)
	BMI.S	mt_VibratoNeg
	ADD.W	D2,D0
	BRA.S	mt_Vibrato3
mt_VibratoNeg
	SUB.W	D2,D0
mt_Vibrato3
	MOVE.W	D0,6(A5)
	MOVE.B	26(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,27(A6)
	RTS

mt_TonePlusVolSlide
	BSR.W	mt_TonePortNoChange
	BRA.W	mt_VolumeSlide

mt_VibratoPlusVolSlide
	BSR.S	mt_Vibrato2
	BRA.W	mt_VolumeSlide

mt_Tremolo
	MOVE.B	3(A6),D0
	BEQ.S	mt_Tremolo2
	MOVE.B	28(A6),D2
	AND.B	#$0F,D0
	BEQ.S	mt_treskip
	AND.B	#$F0,D2
	OR.B	D0,D2
mt_treskip
	MOVE.B	3(A6),D0
	AND.B	#$F0,D0
	BEQ.S	mt_treskip2
	AND.B	#$0F,D2
	OR.B	D0,D2
mt_treskip2
	MOVE.B	D2,28(A6)
mt_Tremolo2
	MOVE.B	29(A6),D0
	LEA	mt_VibratoTable(PC),A4
	LSR.W	#2,D0
	AND.W	#$001F,D0
	MOVEQ	#0,D2
	MOVE.B	30(A6),D2
	LSR.B	#4,D2
	AND.B	#$03,D2
	BEQ.S	mt_tre_sine
	LSL.B	#3,D0
	CMP.B	#1,D2
	BEQ.S	mt_tre_rampdown
	MOVE.B	#255,D2
	BRA.S	mt_tre_set
mt_tre_rampdown
	TST.B	27(A6)
	BPL.S	mt_tre_rampdown2
	MOVE.B	#255,D2
	SUB.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_rampdown2
	MOVE.B	D0,D2
	BRA.S	mt_tre_set
mt_tre_sine
	MOVE.B	0(A4,D0.W),D2
mt_tre_set
	MOVE.B	28(A6),D0
	AND.W	#15,D0
	MULU	D0,D2
	LSR.W	#6,D2
	MOVEQ	#0,D0
	MOVE.B	19(A6),D0
	TST.B	29(A6)
	BMI.S	mt_TremoloNeg
	ADD.W	D2,D0
	BRA.S	mt_Tremolo3
mt_TremoloNeg
	SUB.W	D2,D0
mt_Tremolo3
	BPL.S	mt_TremoloSkip
	CLR.W	D0
mt_TremoloSkip
	CMP.W	#$40,D0
	BLS.S	mt_TremoloOk
	MOVE.W	#$40,D0
mt_TremoloOk
	MOVE.W	D0,8(A5)
	MOVE.B	28(A6),D0
	LSR.W	#2,D0
	AND.W	#$003C,D0
	ADD.B	D0,29(A6)
	RTS
	
mt_SampleOffset
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	BEQ.S	mt_sononew
	MOVE.B	D0,32(A6)
mt_sononew
	MOVE.B	32(A6),D0
	LSL.W	#7,D0
	CMP.W	8(A6),D0
	BGE.S	mt_sofskip
	SUB.W	D0,8(A6)
	ADD.W	D0,D0
	ADD.L	D0,4(A6)
	RTS
mt_sofskip
	MOVE.W	#$0001,8(A6)
	RTS

mt_VolumeSlide
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	LSR.B	#4,D0
	TST.B	D0
	BEQ.S	mt_VolSlideDown
mt_VolSlideUp
	ADD.B	D0,19(A6)
	CMP.B	#$40,19(A6)
	BMI.S	mt_vsuskip
	MOVE.B	#$40,19(A6)
mt_vsuskip
	MOVE.B	19(A6),9(A5)
	RTS

mt_VolSlideDown
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
mt_VolSlideDown2
	SUB.B	D0,19(A6)
	BPL.S	mt_vsdskip
	CLR.B	19(A6)
mt_vsdskip
	MOVE.B	19(A6),9(A5)
	RTS

mt_PositionJump
	MOVE.B	3(A6),D0
	SUBQ	#1,D0
	MOVE.B	D0,mt_SongPos
mt_pj2	CLR.B	mt_PBreakPos
	ST 	mt_PosJumpFlag
	RTS

mt_VolumeChange
	MOVE.B	3(A6),D0
	CMP.B	#$40,D0
	BLS.S	mt_VolumeOk
	MOVEQ	#$40,D0
mt_VolumeOk
	MOVE.B	D0,19(A6)
	MOVE.B	D0,9(A5)
	RTS

mt_PatternBreak
	MOVEQ	#0,D0
	MOVE.B	3(A6),D0
	MOVE.W	D0,D2
	LSR.B	#4,D0
	ADD	D0,D0
	MOVE	D0,D1
	ADD	D0,D0
	ADD	D0,D0
	ADD	D1,D0
	AND.B	#$0F,D2
	ADD.B	D2,D0
	CMP.B	#63,D0
	BHI.S	mt_pj2
	MOVE.B	D0,mt_PBreakPos
	ST	mt_PosJumpFlag
	RTS

mt_SetSpeed
	MOVE.B	3(A6),D0
	BEQ.W	mt_Return2
	CLR.B	mt_counter
	MOVE.B	D0,mt_speed
	RTS

mt_CheckMoreEfx
	BSR.W	mt_UpdateFunk
	MOVE.B	2(A6),D0
	AND.B	#$0F,D0
	SUB.B	#9,D0
	BEQ.W	mt_SampleOffset
	SUBQ	#2,D0
	BEQ.W	mt_PositionJump
	SUBQ	#1,D0
	BEQ.B	mt_VolumeChange
	SUBQ	#1,D0
	BEQ.S	mt_PatternBreak
	SUBQ	#1,D0
	BEQ.S	mt_E_Commands
	SUBQ	#1,D0
	BEQ.S	mt_SetSpeed
	BRA.W	mt_PerNop

mt_E_Commands
	MOVE.B	3(A6),D0
	AND.W	#$F0,D0
	LSR.B	#4,D0
	BEQ.S	mt_FilterOnOff
	SUBQ	#1,D0
	BEQ.W	mt_FinePortaUp
	SUBQ	#1,D0
	BEQ.W	mt_FinePortaDown
	SUBQ	#1,D0
	BEQ.S	mt_SetGlissControl
	SUBQ	#1,D0
	BEQ.B	mt_SetVibratoControl

	IF mt_finetuneused=1 THEN
	SUBQ	#1,D0
	BEQ.B	mt_SetFineTune
	SUBQ	#1,D0

	ELSE
	SUBQ	#2,D0
	ENDC

	BEQ.B	mt_JumpLoop
	SUBQ	#1,D0
	BEQ.W	mt_SetTremoloControl
	SUBQ	#2,D0
	BEQ.W	mt_RetrigNote
	SUBQ	#1,D0
	BEQ.W	mt_VolumeFineUp
	SUBQ	#1,D0
	BEQ.W	mt_VolumeFineDown
	SUBQ	#1,D0
	BEQ.W	mt_NoteCut
	SUBQ	#1,D0
	BEQ.W	mt_NoteDelay
	SUBQ	#1,D0
	BEQ.W	mt_PatternDelay
	BRA.W	mt_FunkIt

mt_FilterOnOff
	MOVE.B	3(A6),D0
	AND.B	#1,D0
	ADD.B	D0,D0
	AND.B	#$FD,$BFE001
	OR.B	D0,$BFE001
	RTS	

mt_SetGlissControl
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,31(A6)
	OR.B	D0,31(A6)
	RTS

mt_SetVibratoControl
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	AND.B	#$F0,30(A6)
	OR.B	D0,30(A6)
	RTS

mt_SetFineTune
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	MOVE.B	D0,18(A6)
	RTS

mt_JumpLoop
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	BEQ.S	mt_SetLoop
	TST.B	34(A6)
	BEQ.S	mt_jumpcnt
	SUBQ.B	#1,34(A6)
	BEQ.W	mt_Return2
mt_jmploop 	MOVE.B	33(A6),mt_PBreakPos
	ST	mt_PBreakFlag
	RTS

mt_jumpcnt
	MOVE.B	D0,34(A6)
	BRA.S	mt_jmploop

mt_SetLoop
	MOVE.W	mt_PatternPos(PC),D0
	LSR	#2,D0
	MOVE.B	D0,33(A6)
	RTS

mt_SetTremoloControl
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,30(A6)
	OR.B	D0,30(A6)
	RTS

mt_RetrigNote
	MOVE.L	D1,-(SP)
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	BEQ.S	mt_rtnend
	MOVEQ	#0,d1
	MOVE.B	mt_counter(PC),D1
	BNE.S	mt_rtnskp
	MOVE.W	(A6),D1
	AND.W	#$0FFF,D1
	BNE.S	mt_rtnend
	MOVEQ	#0,D1
	MOVE.B	mt_counter(PC),D1
mt_rtnskp
	DIVU	D0,D1
	SWAP	D1
	TST.W	D1
	BNE.S	mt_rtnend
mt_DoRetrig
	MOVE.W	20(A6),$DFF096	; Channel DMA off
	MOVE.L	4(A6),(A5)	; Set sampledata pointer
	MOVE.W	8(A6),4(A5)	; Set length
	BSR.W	mt_WaitDMA
	MOVE.W	20(A6),D0
	BSET	#15,D0
	MOVE.W	D0,$DFF096
	BSR.W	mt_WaitDMA
	MOVE.L	10(A6),(A5)
	MOVE.L	14(A6),4(A5)
mt_rtnend
	MOVE.L	(SP)+,D1
	RTS

mt_VolumeFineUp
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.W	#$F,D0
	BRA.W	mt_VolSlideUp

mt_VolumeFineDown
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	BRA.W	mt_VolSlideDown2

mt_NoteCut
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	CMP.B	mt_counter(PC),D0
	BNE.W	mt_Return2
	CLR.B	19(A6)
	CLR.W	8(A5)
	RTS

mt_NoteDelay
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	CMP.B	mt_Counter(PC),D0
	BNE.W	mt_Return2
	MOVE.W	(A6),D0
	BEQ.W	mt_Return2
	MOVE.L	D1,-(SP)
	BRA.W	mt_DoRetrig

mt_PatternDelay
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.W	#$0F,D0
	TST.B	mt_PattDelTime2
	BNE.W	mt_Return2
	ADDQ.B	#1,D0
	MOVE.B	D0,mt_PattDelTime
	RTS

mt_FunkIt
	TST.B	mt_counter
	BNE.W	mt_Return2
	MOVE.B	3(A6),D0
	AND.B	#$0F,D0
	LSL.B	#4,D0
	AND.B	#$0F,31(A6)
	OR.B	D0,31(A6)
	TST.B	D0
	BEQ.W	mt_Return2
mt_UpdateFunk
	MOVEM.L	D1/A0,-(SP)
	MOVEQ	#0,D0
	MOVE.B	31(A6),D0
	LSR.B	#4,D0
	BEQ.S	mt_funkend
	LEA	mt_FunkTable(PC),A0
	MOVE.B	(A0,D0.W),D0
	ADD.B	D0,35(A6)
	BTST	#7,35(A6)
	BEQ.S	mt_funkend
	CLR.B	35(A6)

	MOVE.L	10(A6),D0
	MOVEQ	#0,D1
	MOVE.W	14(A6),D1
	ADD.L	D1,D0
	ADD.L	D1,D0
	MOVE.L	36(A6),A0
	ADDQ.L	#1,A0
	CMP.L	D0,A0
	BLO.S	mt_funkok
	MOVE.L	10(A6),A0
mt_funkok
	MOVE.L	A0,36(A6)
	NEG.B	(A0)
	SUBQ.B	#1,(A0)
mt_funkend
	MOVEM.L	(SP)+,D1/A0
	RTS

mt_WaitDMA
	MOVEQ	#3,D0
mt_WaitDMA2
	MOVE.B	$DFF006,D1
mt_WaitDMA3
	CMP.B	$DFF006,D1
	BEQ.S	mt_WaitDMA3
	DBF	D0,mt_WaitDMA2
	RTS

mt_FunkTable dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

mt_VibratoTable	
	dc.b   0, 24, 49, 74, 97,120,141,161
	dc.b 180,197,212,224,235,244,250,253
	dc.b 255,253,250,244,235,224,212,197
	dc.b 180,161,141,120, 97, 74, 49, 24

mt_PeriodTable
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

mt_chan1temp	blk.l	5
		dc.w	1
		blk.w	21
		dc.w	2
		blk.w	21
		dc.w	4
		blk.w	21
		dc.w	8
		blk.w	11

mt_SampleStarts	blk.l	31,0

mt_SongDataPtr	dc.l 0
mt_LWTPtr	dc.l 0
mt_oldirq	dc.l 0

mt_speed	dc.b 6
mt_counter	dc.b 0
mt_SongPos	dc.b 0
mt_PBreakPos	dc.b 0
mt_PosJumpFlag	dc.b 0
mt_PBreakFlag	dc.b 0
mt_LowMask	dc.b 0
mt_PattDelTime	dc.b 0
mt_PattDelTime2	dc.b 0,0
mt_PatternPos	dc.w 0
mt_DMACONtemp	dc.w 0


gfxname		dc.b	"graphics.library",0,0
oldvbi		dc.l	0
xangle		dc.w	0
yangle		dc.w	0
zangle		dc.w	0
coordbuf	blk.l	100,0
dbadrs		dc.l	vecbpl1
		dc.l	vecbpl2
		dc.l	vecbpl3
		dc.l	vecbpl4
		dc.l	vecbpl5
		
scrolltxt	dc.b	"hallo freaks ! wie geht es euch ?     "
		dc.b	"abcdefghijklmnopqrstuvwxyz?!><+=:'",$22
		dc.b	"-.,*/0123456789()                    ",0,0

scrolltxttab	dc.b	"abcdefghijklmnopqrstuvwxyz?!><+=:'",$22
		dc.b	"-.,*/0123456789() ",0,0

txttab		dc.b	"abcdefghijklmnopqrstuvwxyz1234567890-.:,;#+*!",$22
		dc.b	"$%&/()=?' ",0,0

offtab		blk.b	255,0
scrollofftab	blk.b	255,0
		even

dots		dc.w	$001F
		dc.l	$002800A9
		dc.l	$006700A9,$0076009A,$00280095,$00500095
		dc.l	$0049006D,$0028006D,$003E0057,$00760057
		dc.l	$0076006D,$00660082,$00910057,$008D00A9
		dc.l	$00B900A9,$00B90057,$00B90095,$00B9006D
		dc.l	$00850081,$00990095,$0099006D,$00BD00A9
		dc.l	$00D600A9,$00BD0057,$00FC0057,$00BD0076
		dc.l	$00EB0076,$00D6008A,$00BD006D,$00F4006D
		dc.l	$00F7008A,$0113006E

lines		dc.l	$001F0001
		dc.l	$00000002,$00010005,$00020003,$00000004
		dc.l	$00030006,$00040007,$00060008,$00070008
		dc.l	$00090009,$0005000B,$000A000C,$000A000D
		dc.l	$000C000B,$000E000E,$0010000D,$000F000F
		dc.l	$00120011,$00120013,$00110010,$00130015
		dc.l	$00140018,$00140019,$0018001C,$0019001B
		dc.l	$001C0016,$001B0017,$0016001A,$0015001D
		dc.l	$001A001E,$001D0017
		dc.w	$001E


sinus		dc.w	0,572,1144,1715,2286,2856,3425,3993
		dc.w	4560,5126,5690,6252,6813,7371,7927,8481
		dc.w	9032,9580,10126,10668,11207,11747,12275,12803
		dc.w	13328,13848,14364,14876,15383,15886,16383,16876
		dc.w	17364,17846,18323,18794,19260,19720,20173,20621
		dc.w	21062,21497,21925,22347,22762,23170,23571,23964
		dc.w	24351,24730,25101,25465,25821,26169,26509,26841
		dc.w	27165,27481,27788,28087,28377,28659,28932,29196
		dc.w	29451,29697,29934,30162,30381,30591,30791,30982
		dc.w	31163,31335,31498,31650,31794,31927,32051,32165
		dc.w	32269,32364,32448,32523,32588,32642,32687,32722
		dc.w	32747,32762,32767,32762,32747,32722,32687,32642
		dc.w	32587,32523,32448,32364,32269,32165,32051,31927
		dc.w	31794,31650,31498,31335,31163,30982,30791,30591
		dc.w	30381,30162,29934,29697,29451,29196,28932,28659
		dc.w	28377,28087,27788,27481,27165,26841,26509,26169
		dc.w	25821,25465,25101,24730,24351,23964,23571,23170
		dc.w	22762,22347,21925,21497,21062,20621,20173,19720
		dc.w	19260,18794,18323,17846,17364,16876,16384,15886
		dc.w	15383,14876,14364,13848,13328,12803,12275,11743
		dc.w	11207,10668,10126,9580,9032,8481,7927,7371
		dc.w	6813,6252,5690,5126,4560,3993,3425,2856
		dc.w	2286,1715,1144,572,0,-571,-1143,-1714
		dc.w	-2285,-2855,-3424,-3993,-4560,-5125,-5689,-6252
		dc.w	-6812,-7370,-7926,-8480,-9031,-9579,-10125,-10667
		dc.w	-11206,-11742,-12274,-12802,-13327,-13847,-14363,-14875
		dc.w	-15382,-15885,-16383,-16876,-17363,-17845,-18322,-18794
		dc.w	-19259,-19719,-20173,-20620,-21061,-21496,-21925,-22346
		dc.w	-22761,-23169,-23570,-23964,-24350,-24729,-25100,-25464
		dc.w	-25820,-26168,-26508,-26840,-27164,-27480,-27787,-28086
		dc.w	-28376,-28658,-28931,-29195,-29450,-29696,-29933,-30162
		dc.w	-30380,-30590,-30790,-30981,-31163,-31335,-31497,-31650
		dc.w	-31793,-31927,-32050,-32164,-32269,-32363,-32448,-32522
		dc.w	-32587,-32642,-32687,-32722,-32747,-32762,-32767,-32762
		dc.w	-32747,-32722,-32687,-32642,-32587,-32522,-32448,-32363
		dc.w	-32269,-32165,-32051,-31927,-31793,-31650,-31497,-31335
		dc.w	-31163,-30981,-30791,-30590,-30381,-30162,-29934,-29697
		dc.w	-29451,-29195,-28931,-28658,-28377,-28087,-27788,-27481
		dc.w	-27165,-26841,-26509,-26169,-25821,-25465,-25101,-24729
		dc.w	-24351,-23964,-23571,-23170,-22762,-22347,-21925,-21497
		dc.w	-21062,-20621,-20173,-19720,-19260,-18794,-18323,-17846
		dc.w	-17364,-16876,-16384,-15886,-15383,-14876,-14364,-13848
		dc.w	-13328,-12803,-12275,-11743,-11207,-10668,-10126,-9580
		dc.w	-9032,-8481,-7927,-7371,-6813,-6252,-5690,-5126
		dc.w	-4560,-3994,-3425,-2856,-2286,-1715,-1144,-572
		dc.w	0,572,1144,1715,2286,2856,3425,3993
		dc.w	4560,5126,5690,6252,6813,7371,7927,8481
		dc.w	9032,9580,10126,10668,11207,11743,12275,12803
		dc.w	13328,13848,14364,14876,15383,15886,16383,16876
		dc.w	17364,17846,18323,18794,19260,19720,20173,20621
		dc.w	21062,21497,21925,22347,22762,23170,23571,23964
		dc.w	24351,24730,25101,25465,25821,26169,26509,26841
		dc.w	27165,27481,27788,28087,28377,28659,28932,29196
		dc.w	29451,29697,29934,30162,30381,30591,30791,30982
		dc.w	31163,31335,31498,31650,31794,31927,32051,32165
		dc.w	32269,32364,32448,32523,32588,32642,32687,32722
		dc.w	32747,32762,32767,32762,32747,32722,32687,32642
		dc.w	32587,32523,32448,32364,32269,32165,32051,31927
		dc.w	31794,31650,31498,31335,31163,30982,30791,30591
		dc.w	30381,30162,29934,29697,29451,29196,28932,28659
		dc.w	28377,28087,27788,27481,27165,26841,26509,26169
		dc.w	25821,25465,25101,24730,24351,23964,23571,23170
		dc.w	22762,22347,21925,21497,21062,20621,20173,19720
		dc.w	19260,18794,18323,17846,17364,16876,16384,15886
		dc.w	15383,14876,14364,13848,13328,12803,12275,11743
		dc.w	11207,10668,10126,9580,9032,8481,7927,7371
		dc.w	6813,6252,5690,5126,4560,3993,3425,2856
		dc.w	2286,1715,1144,572,0
;------------------------------------------------------------------------------
newcolors	dc.l	$01a00fff,$01a20def,$01a40def,$01a60def
		dc.l	$01a80def,$01aa0def,$01ac0def,$01ae0def
		dc.l	$01b00def,$01b20def,$01b40def,$01b60def
		dc.l	$01b80def,$01ba0def,$01bc0def,$01be0def

pagetab		dc.l	page_00
		dc.l	page_01
		dc.l	page_02
		dc.l	-1

page_00		dc.b	"           are proud to present         ",10
		dc.b	"                 present:               ",10
		dc.b	"                                        ",10
		dc.b	"               name of game             ",10
		dc.b	"                                        ",10
		dc.b	"        original supplier ........      ",10
		dc.b	"----------------------------------------",10
		dc.b	"           intro credits go to:         ",10
		dc.b	"                                        ",10
		dc.b	"einstein of sceptic:              coding",10
		dc.b	"flite of sceptic:             gfx 'n sfx",10
		dc.b	"----------------------------------------",10
		dc.b	"            call these boards           ",10
		dc.b	"                                        ",10
		dc.b	"final eclipse      ++1 ***-***-**** ushq",10
		dc.b	"blast off          ++49 ****-*****  ghq ",10
		dc.b	"off side           ++45 ***-****-*  fhq ",10
		dc.b	"----------------------------------------",10
		dc.b	"              sceptic sites             ",10
		dc.b	"byte paradise      ++49 ****-*****(dist)",10
		dc.b	"perfect illusion   ++49 xxxx-xxxxx(dist)",10
		dc.b	"----------------------------------------",10
		dc.b	0

page_01		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"   the creeping greetz slime over to:   ",10
		dc.b	"   ----------------------------------   ",10
		dc.b	"                                        ",10
		dc.b	"  crack inc, nemesis, extreme, sceptic  ",10
		dc.b	"                                        ",10
		dc.b	"vision factory, crystal, exult, skid row",10
		dc.b	"                                        ",10
		dc.b	"abandon, anthrox, supplex, paf, alcatraz",10
		dc.b	"                                        ",10
		dc.b	"trsi, cyberactive, sanity, gothic, acume",10
		dc.b	"                                        ",10
		dc.b	"trailblazer, traveller, anarchy, amoniak",10
		dc.b	"                                        ",10
		dc.b	"sionics, silents, gods, symbiosis, leach",10
		dc.b	"                                        ",10
		dc.b	"               and scoopex!             ",10
		dc.b	"                                        ",10
		dc.b	"----------------------------------------",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	0		

page_02		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	"sceptic, we make the impossible possible",10
		dc.b	"----------------------------------------",10
		dc.b	"                                        ",10
		dc.b	"   contact us for more productions!     ",10
		dc.b	"                                        ",10
		dc.b	"               ansi gfx                 ",10
		dc.b	"                                        ",10
		dc.b	"           real d-paint gfx             ",10
		dc.b	"                                        ",10
		dc.b	"              chip tunes                ",10
		dc.b	"                                        ",10
		dc.b	"                intros                  ",10
		dc.b	"                                        ",10
		dc.b	"               chooser!                 ",10
		dc.b	"                                        ",10
		dc.b	"          and anything similar          ",10
		dc.b	"                                        ",10
		dc.b	"----------------------------------------",10
		dc.b	"                                        ",10
		dc.b	"                                        ",10
		dc.b	0
		even
		
fadeflag	dc.w	0
menuflag	dc.w	0
menuwait	dc.w	1
oldmy		dc.w	0
my		dc.w	0
max		dc.w	0
yestxt		dc.b	"yo!",0
notxt		dc.b	"nop",0
numtxt		dc.b	"000",0
;------------------------------------------------------------------------------
		section	data,data_c
		
coplist:
		dc.w	$1fc,0
		dc.w	$106,0
		dc.l	$008e2c81,$00902ce1
		dc.l	$00920038,$009400d0
		dc.l	$01020000
		dc.l	$01080000+40*3
		dc.l	$010a0000+40*3
logobpl		dc.l	$00e00000,$00e20000
		dc.l	$00e40000,$00e60000
		dc.l	$00e80000,$00ea0000
		dc.l	$00ec0000,$00ee0000
		dc.l	$01004200
		dc.l	$00960020,$01400000,$01420000

		dc.l	$01800000
		dc.l	$01820DCD
		dc.l	$01840EDF
		dc.l	$01860012
		dc.l	$01880DCE
		dc.l	$018A0CBD
		dc.l	$018C0BAC
		dc.l	$018E0A9B
		dc.l	$0190098A
		dc.l	$01920879
		dc.l	$01940768
		dc.l	$01960657
		dc.l	$01980546
		dc.l	$019A0435
		dc.l	$019C0324
		dc.l	$019E0213
		dc.l	$560ffffe,$01800102
		
		dc.l	$580ffffe,$01000000
		dc.l	$008e2c81,$00902ce1
		dc.l	$00920038,$009400d0
		dc.l	$01080000,$010a0000,$01020000

origcols	dc.l	$01800102,$01820335,$01840557,$01860557
		dc.l	$01880779,$018a0779,$018c0779,$018e0779
		dc.l	$0190099b,$0192099b,$0194099b,$0196099b
		dc.l	$0198099b,$019a099b,$019c099b,$019e099b

tochangecols	dc.l	$01a00fff,$01a20def,$01a40def,$01a60def
		dc.l	$01a80def,$01aa0def,$01ac0def,$01ae0def
		dc.l	$01b00def,$01b20def,$01b40def,$01b60def
		dc.l	$01b80def,$01ba0def,$01bc0def,$01be0def
		
		dc.l	$590ffffe
		dc.l	$01005200
vecbpladr	dc.l	$00e00000,$00e20000
		dc.l	$00e40000,$00e60000
		dc.l	$00e80000,$00ea0000
		dc.l	$00ec0000,$00ee0000
txtbpladr	dc.l	$00f00000,$00f20000

mwait1		dc.l	$600ffffe
		dc.l	$01800102,$01820335,$01840557,$01860557
		dc.l	$01880779,$018a0779,$018c0779,$018e0779
		dc.l	$0190099b,$0192099b,$0194099b,$0196099b
		dc.l	$0198099b,$019a099b,$019c099b,$019e099b

mwait2		dc.l	$700ffffe
		dc.l	$01800102,$01820335,$01840557,$01860557
		dc.l	$01880779,$018a0779,$018c0779,$018e0779
		dc.l	$0190099b,$0192099b,$0194099b,$0196099b
		dc.l	$0198099b,$019a099b,$019c099b,$019e099b

		dc.l	$ffdffffe,$009c8010

		dc.l	$150ffffe,$01000000
		dc.l	$008e2c81,$00902ce1
		dc.l	$00920038,$009400d0
		dc.l	$01080000+40*3,$010a0000+40*3
		dc.l	$01800000,$01820DCD,$01840EDF,$01860012
		dc.l	$01880DCE,$018A0CBD,$018C0BAC,$018E0A9B
		dc.l	$0190098A,$01920879,$01940768,$01960657
		dc.l	$01980546,$019A0435,$019C0324,$019E0213
		dc.l	$160ffffe
linebpl		dc.l	$00e00000,$00e20000
		dc.l	$00e40000,$00e60000
		dc.l	$00e80000,$00ea0000
		dc.l	$00ec0000,$00ee0000
		dc.l	$01004200

		dc.l	$1b3ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$1c3ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$1d3ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$1e3ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$1f3ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$203ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$213ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$223ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		dc.l	$233ffffe
		dc.l	$01820123,$01820225,$01820436,$01820447
		dc.l	$01820558,$01820669,$0182067a,$0182078b
		dc.l	$0182089b,$018209ac,$01820abd,$01820bcd
		dc.l	$01820cde,$01820dee,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820fff,$01820fff
		dc.l	$01820fff,$01820fff,$01820dee,$01820cde
		dc.l	$01820bcd,$01820abd,$018209ac,$0182089b
		dc.l	$0182078b,$0182067a,$01820669,$01820558
		dc.l	$01820447,$01820436,$01820225,$01820123,$01820000
		
		dc.l	$1f0ffffe
		dc.l	$01820fff		
		

		dc.l	$240ffffe,$01000000
		dc.l	$fffffffe
		
logo		incbin	sceptic-2hours.raw
mt_data		incbin	mod.sceptic-neve.pro
font		incbin	flitesmallfont.raw
scrollfont	incbin	scrollerfont.raw
scrollmask	incbin	scrollerfont.mskraw

		section	buffer,bss_c
vecbpl1		ds.b	320*270/8
vecbpl2		ds.b	320*270/8
vecbpl3		ds.b	320*270/8
vecbpl4		ds.b	320*270/8
vecbpl5		ds.b	320*270/8
scrollbpl	ds.b	20*40
txtbpl		ds.b	320*270*2/8
