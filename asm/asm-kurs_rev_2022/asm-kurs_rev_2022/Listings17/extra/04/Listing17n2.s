
; Listings17n2.s = IFTmenuOK.s

bltddat     EQU   $000
dmaconr     EQU   $002
vposr       EQU   $004
vhposr      EQU   $006
dskdatr     EQU   $008
joy0dat     EQU   $00A
joy1dat     EQU   $00C
clxdat      EQU   $00E

adkconr     EQU   $010
pot0dat     EQU   $012
pot1dat     EQU   $014
potinp      EQU   $016
serdatr     EQU   $018
dskbytr     EQU   $01A
intenar     EQU   $01C
intreqr     EQU   $01E

dskpt       EQU   $020
dsklen      EQU   $024
dskdat      EQU   $026
refptr      EQU   $028
vposw       EQU   $02A
vhposw      EQU   $02C
copcon      EQU   $02E


bltcon0     EQU   $040
bltcon1     EQU   $042
bltafwm     EQU   $044
bltalwm     EQU   $046
bltcpt      EQU   $048
bltbpt      EQU   $04C
bltapt      EQU   $050
bltdpt      EQU   $054
bltsize     EQU   $058

bltcmod     EQU   $060
bltbmod     EQU   $062
bltamod     EQU   $064
bltdmod     EQU   $066

bltcdat     EQU   $070
bltbdat     EQU   $072
bltadat     EQU   $074

dsksync     EQU   $07E

cop1lc      EQU   $080
cop2lc      EQU   $084
copjmp1     EQU   $088
copjmp2     EQU   $08A
copins      EQU   $08C
diwstrt     EQU   $08E
diwstop     EQU   $090
ddfstrt     EQU   $092
ddfstop     EQU   $094
dmacon      EQU   $096
clxcon      EQU   $098
intena      EQU   $09A
intreq      EQU   $09C
adkcon      EQU   $09E

bplpt       EQU   $0E0

bplcon0     EQU   $100
bplcon1     EQU   $102
bplcon2     EQU   $104
bpl1mod     EQU   $108
bpl2mod     EQU   $10A

bpldat      EQU   $110

spr0dat     EQU   $144


color       EQU   $180

findtask	equ -294 
findname	equ -276
waitport	equ -384
getmsg	equ -372
replymsg	equ -378
allocmem	equ -198
allocabs	equ -204
freemem	equ -210
disable	equ -120
enable	equ -126
forbid	equ -132
permit	equ -138
superstate	equ -150
supervisor	equ -30
openlibrary	equ -552
closelibrary  equ -414
opendevice	equ -444
closedevice	equ -450
doio	equ -456
addport	equ -354
remport	equ -360
findresident	equ -96
typeofmem	equ -534
open	equ -30
close	equ -36
read	equ -42
execute	equ -222

closewb	equ -78
openwb	equ -210


		section	caz,code	
start:
	movem.l d1-d7/a0-a6,-(a7)
	bsr.s killsys
	bsr main

enablesys:
	bsr waitof
	move.l oldcop1loc(pc),cop1lc(a6)
	move.l old6c(pc),$6c.w
	bsr waitof
	move.w d0,copjmp1(a6)
	move.w olddmacon(pc),dmacon(a6)
	bsr waitof
	bsr waitof
	move.w oldintena(pc),intena(a6)
	movem.l (a7)+,d1-d7/a0-a6
	moveq #0,d0
	rts

askblitter:
	btst #14,dmaconr(a5)
come_on_blit:
	btst #14,dmaconr(a5)
	bne.s come_on_blit
	rts

killsys:
	move.l $4.w,a6
	lea gfxname(pc),a1
	moveq #0,d0
	jsr openlibrary(a6)
	move.l d0,a0
	lea oldcop1loc(pc),a1
	move.l 38(a0),(a1)
	lea $dff000,a5
	bsr.s askblitter
	move.w intenar(a5),d0
	or.w #$8000,d0
	lea oldintena(pc),a1
	move.w d0,(a1)
	move.w dmaconr(a5),d0
	or.w #$8000,d0
	lea olddmacon(pc),a1
	move.w d0,(a1)
	move.w #$7fff,dmacon(a5)
	move.w #$7fff,intena(a5)
	moveq #0,d0
	move.l d0,spr0dat(a5)
	lea old6c(pc),a1
	move.l $6c.w,(a1)
	rts


gfxname:
	dc.b "graphics.library",0

	cnop 0,2
			
oldintena:	dc.w 0
olddmacon:	dc.w 0
oldcop1loc:	dc.l 0
old6c:		dc.l 0


	
		
WAITBLIT	MACRO
	BTST #14,DMACONR(A6)
BLITTING\@	BTST #14,DMACONR(A6)
	BNE.S BLITTING\@
	ENDM

toolnumber=19   	;* anzahl tools+docs... eintragen
infolines=48		;* anzahl der verwendeten zeilen für
		;* den infotext eintragen

scrollspeed=2		;* zulässige werte 1,2,4


clickdelay=10
move_up_speed=6
fall_down_speed=14
menutxtcol0=$baa
menutxtcol1=$a78
menutxtcol2=$946
menutxtcol=$815

hilitecol=$24b
line=42
interline=54
planesize=256*line
sinareaheight=137
planesize.up=147*line
planesize.45=200*line
planesize.menu=(150+10*(toolnumber+2))*line
planesize.info=(200+10*infolines)*line
planesize.u=136*line
planesize.i=136*line
planesize.l=100*line
planesize.s=20*line
menuoffset=147
maxposition=menuoffset+toolnumber*10-56
maxposition.i=menuoffset+infolines*10-82
minposition=82
delay.i=2

main:
	lea	$dff000,a6
	lea	menuscreen,a1
	bsr	planeentry.m
	lea	upperbox,a1
	bsr	planeentry.u
	lea	interscreen,a1
	bsr	planeentry.i
	lea	menuscreen,a1
	adda.l	#logo-menuscreen,a1
	bsr	planeentry.l
	lea	menuscreen,a1
	adda.l	#scrollscreen-menuscreen,a1
	bsr	planeentry.s
	lea	menuscreen,a1
	adda.l	#noise-menuscreen,a1
	bsr	planeentry.n
	bsr	enter_sprites
	lea	menuscreen,a5
;	adda.l	#mt_init-menuscreen,a5
;	jsr	(a5)
	move.w	#$8240,dmacon(a6)
	bsr	print_menu
	bsr	print_info
	bsr	print_number
	lea	coplist,a1
	lea	vbi(pc),a2
	move.l	a2,$6c.w
	bsr	waitof
	move.l	a1,cop1lc(a6)
	move.w	d0,copjmp1(a6)
	move.w	#$83e0,dmacon(a6)
	move.w	#$c020,intena(a6)
	bsr	wait_choice
	
	moveq	#15,d3
blitz:
	cmp.b	#$ff,vhposr(a6)
	bne.s	blitz
wait.eol:
	cmp.b	#$ff,vhposr(a6)
	beq.s	wait.eol
	bsr.s	blend
	dbf	d3,blitz
	move.w	#$20,intena(a6)
	move.w	#$7fff,dmacon(a6)
	moveq	#0,d7
	lea	spr0dat(a6),a0
	moveq	#7,d1
clr_sprites:
	move.l	d7,(a0)
	lea	8(a0),a0
	dbf	d1,clr_sprites
	move.w	d7,$a8(a6)
	move.w	d7,$b8(a6)
	move.w	d7,$c8(a6)
	move.w	d7,$d8(a6)
	move.w	d0,$100.w
	rts

blend:
	moveq	#-1,d4 	;dest.color $fff
	lea	color0.1+2,a0
	moveq	#22,d7
	bsr.s	colfade
	lea	colors1+2,a0
	moveq	#6,d7
	bsr.s	colfade
	lea	4(a0),a0
	moveq	#6,d7
	bsr.s	colfade
	lea	colors.n+2,a0
	moveq	#6,d7
	bsr.s	colfade
	lea	4(a0),a0
	moveq	#6,d7
	bsr.s	colfade
	lea	colors.l+2,a0
	moveq	#14,d7
	bsr.s	colfade
	lea	color.lb+2,a0
	moveq	#0,d7
	bsr.s	colfade
	lea	4(a0),a0
	moveq	#6,d7
	bsr.s	colfade
	
	rts
	
colfade:
	move.w	(a0),d1
	bsr.s	inc_red
	bsr.s	inc_green
	bsr.s	inc_blue
	move.w	d1,(a0)
	lea	4(a0),a0
	dbf	d7,colfade
	rts

inc_red:
	move.w d1,d2
	move.w d4,d5
	move.w #$0f00,d6
	and.w d6,d2
	and.w d6,d5
	cmp.w d2,d5
	beq.s no_ired
	addi.w #$0100,d2
	andi.w #$00ff,d1
	or.w d2,d1
no_ired:
	rts
inc_green:
	move.w d1,d2
	move.w d4,d5
	move.w #$00f0,d6
	and.w d6,d2
	and.w d6,d5
	cmp.w d2,d5
	beq.s no_igreen
	addi.w #$0010,d2
	andi.w #$0f0f,d1
	or.w d2,d1
no_igreen:
	rts
inc_blue:
	move.w d1,d2
	move.w d4,d5
	move.w #$000f,d6
	and.w d6,d2
	and.w d6,d5
	cmp.w d2,d5
	beq.s no_igreen
	addq.w #1,d2
	andi.w #$0ff0,d1
	or.w d2,d1
no_iblue:
	rts
			


wait_choice:
	move.w	finished(pc),d0
	beq.s	wait_choice
	rts

waitof:
	move.l	vposr(a6),d7
	and.l	#$0001ff00,d7
	cmp.l	#$00013600,d7
	bne.s	waitof
wait_eol:
	cmp.b	#$36,vhposr(a6)
	beq.s	wait_eol
	rts

planeentry.u;
	move.l	a1,d1	;a1 wird akt. screenadresse
	lea	bplanes.u+2,a0	
	moveq	#1,d0
next.plu:
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	add.l	#planesize.u,d1
	dbf	d0,next.plu
	rts

planeentry.s:
	move.l	a1,d1	;a1 wird akt. screenadresse
	lea	bplanes.s+2,a0	
	moveq	#1,d0
next.pls:
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	add.l	#planesize.s,d1
	dbf	d0,next.pls
	rts

planeentry.n:
	move.l	a1,d1	;a1 wird akt. screenadresse
	lea	bplane.n+2,a0	
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	swap	d1
	move.w	d1,(a0)
	rts

planeentry.i:
	move.l	a1,d1	;a1 wird akt. screenadresse
	lea	bplane.i+2,a0	
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	swap	d1
	move.w	d1,(a0)
	rts

planeentry.l:
	move.l	a1,d1	;a1 wird akt. screenadresse
	lea	bplanes.l+2,a0	
	moveq	#3,d0
next.plo:
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	add.l	#planesize.l,d1
	dbf	d0,next.plo
	rts


print_menu:
	lea	menuscreen,a1
	move.l	a1,a4
	lea	menutext,a4		;menutext-menuscreen,a4
	lea	menuoffset*line(a1),a1
	bsr	print
	rts

print_info:
	lea	menuscreen,a1
	move.l	a1,a4
	lea	infoscreen-menuscreen(a1),a1
;	adda.l	#infotext-menuscreen,a4
	lea	menuoffset*line(a1),a1
;	bsr	print
	rts

print_number:
	move.w	#30*64+1,d3 ;bltsize
	move.w	#$09f0,d0 ;bltcon0-wert A-->D 
       	moveq	#0,d1
	moveq	#-1,d2
	lea	menuscreen,a4
	lea	packnumber,a4
	lea	menuscreen,a1
	adda.l	#logo+28+55*line-menuscreen,a1
	lea	numbers,a0
	moveq	#0,d4
	move.b	(a4)+,d4		
       	subi.b	#$30,d4
       	add.w	d4,d4
       	lea	(a0,d4.w),a2
       	bsr.s	printnum
	lea	2(a1),a1
       	moveq	#0,d4
	move.b	(a4)+,d4		
       	subi.b	#$30,d4
       	add.w	d4,d4
       	lea	(a0,d4.w),a2
printnum:
	move.l	a1,a3
	moveq	#3,d7
	WAITBLIT
	move.w	#18,bltamod(a6)
       	move.w	#line-2,bltdmod(a6)
       	move.l	d2,bltafwm(a6) 
       	move.w	d0,bltcon0(a6) 
       	move.w	d1,bltcon1(a6) 
blitnextplane:
	WAITBLIT
	move.l	a2,bltapt(a6)
  	move.l	a3,bltdpt(a6)
 	move.w	d3,bltsize(a6)
        lea	600(a2),a2
        lea	planesize.l(a3),a3
        dbf	d7,blitnextplane	
        rts

*******************************
print
*******************************
;parameter:
;a4:zeiger auf nullterminierten textblock (länge=n*32 zeichen)
;a1:zeiger auf linke obere ecke des zu druckenden textes

	lea	font8,a0		
       	move.w	#7*64+1,d3 ;bltsize
	move.w	#%0000110111101100,d2 ;bltcon0-wert (A AND C) OR D 
       	moveq	#-1,d5
       	move.l	#$00ffff00,d4
next_line:
    	moveq	#15,d0 ;16 doppelzeichen/zeile	
next_2chars:
	moveq	#0,d1
       	move.b	(a4)+,d1
       	subi.b	#$20,d1
       	lea	(a0,d1.w),a3 ;blitsource A im font8: d1 aus CHAR
	moveq	#0,d6 ;shiftwerte für A und B rücksetzen
	bclr	#15,d2
	move.w	a3,d1
	btst	#0,d1
	beq.s	print_lchar
	subq.w	#1,a3
	suba.w	#line,a1
	add.w	#64,d3
	bset	#15,d2
	*bset 	#15,d6

print_lchar:
	WAITBLIT
	move.w	#58,bltamod(a6)
       	move.w	#line-2,bltbmod(a6)
       	move.w	#line-2,bltdmod(a6)
       	move.l	d5,bltafwm(a6) 
       	move.w	d2,bltcon0(a6) 
       	move.w	d6,bltcon1(a6) 
 	move.l	a3,bltapt(a6)
  	move.l	a1,bltbpt(a6)
  	move.l	a1,bltdpt(a6)
  	move.w	d4,bltcdat(a6)
  	move.w	d3,bltsize(a6)
              
        btst	#0,d1
	beq.s	no_corr
	adda.w	#line,a1
	subi.w	#64,d3
no_corr:
	swap	d4
	moveq	#0,d1
       	move.b	(a4)+,d1
       	subi.b	#$20,d1
       	lea	(a0,d1.w),a3 ;blitsource A im font8: d1 aus CHAR
	moveq	#0,d6 ;shiftwerte für A und B rücksetzen
	bset	#15,d2
	move.w	a3,d1
	btst	#0,d1
	beq.s	print_rchar
	subq.w	#1,a3
	bclr	#15,d2
print_rchar	WAITBLIT
	move.w	#58,bltamod(a6)
       	move.w	#line-2,bltbmod(a6)
       	move.w	#line-2,bltdmod(a6)
       	move.l	d5,bltafwm(a6) 
       	move.w	d2,bltcon0(a6) 
       	move.w	d6,bltcon1(a6) 
  	move.l	a3,bltapt(a6)
  	move.l	a1,bltbpt(a6)
  	move.l	a1,bltdpt(a6)
  	move.w	d4,bltcdat(a6)
  	move.w	d3,bltsize(a6)
        swap 	d4
	lea	2(a1),a1	
	dbf	d0,next_2chars
	
	lea	10+9*line(a1),a1  ;linefeed im destination range
	tst.b	(a4)
	bne	next_line
	rts

count.i:
	dc.w	delay.i
interference:
	waitblit
	moveq	#0,d0
	move.w	d0,bltcon1(a6)
	moveq	#21,d0
	move.w	d0,bltamod(a6)
	move.w	#-(2*17+interline),d0
	move.w	d0,bltbmod(a6)
	moveq	#9,d0
	move.w	d0,bltdmod(a6)
	lea	interscreen+4*line-2,a1
	move.l	a1,bltdpt(a6)
	lea	count.i(pc),a0
	subq.w	#1,(a0)
	bne	end_inter
	move.w	#delay.i,(a0)
	lea	menuscreen,a0
	lea	inter,a0
	lea	vsin(pc),a1
	cmp.w	#64,(a1)
	bne.s	no_vreset
	moveq	#0,d0
	move.w	d0,(a1)
no_vreset:
	addq.w	#2,(a1)
	moveq	#0,d1
	move.w	(a1)+,d1
	move.w	(a1,d1.w),d1
	lea	(a0,d1.w),a0
	lea	hsin(pc),a1
	cmp.w	#154,(a1)
	bne.s	no_hreset
	moveq	#-2,d0
	move.w	d0,(a1)
no_hreset:
	addq.w	#2,(a1)
	;moveq	#0,d1
	move.w	(a1)+,d1
	move.w	(a1,d1.w),d1
	ror.l	#4,d1
	tst.w	d1
	beq.s	no_add
	add.w	d1,d1
	lea	(a0,d1.w),a0
no_add:
	swap	d1
	move.w	#$f000,d0
	sub.w	d1,d0
	move.w	d0,d1
	move.l	a0,bltapt(a6)
	or.w	#$0dc0,d0
	move.w	d0,bltcon0(a6)
	moveq	#-1,d0
	rol.w	#4,d1
	asl.w	d1,d0
	move.l	d0,bltafwm(a6)
	lea	menuscreen,a0
	lea	inter+127*interline,a0
	lea	vsin1(pc),a1
	cmp.w	#64,(a1)
	bne.s	no_vreset1
	moveq	#0,d0
	move.w	d0,(a1)
no_vreset1:
	addq.w	#2,(a1)
	moveq	#0,d1
	move.w	(a1),d1
	lea	4(a1),a1
	move.w	(a1,d1.w),d1
	lea	(a0,d1.w),a0
	lea	hsin1(pc),a1
	cmp.w	#154,(a1)
	bne.s	no_hreset1
	moveq	#-2,d0
	move.w	d0,(a1)
no_hreset1:
	addq.w	#2,(a1)
	move.w	(a1),d1
	lea	4(a1),a1
	move.w	(a1,d1.w),d1
	ror.l	#4,d1
	tst.w	d1
	beq.s	no_add1
	add.w	d1,d1
	lea	(a0,d1.w),a0
no_add1:
	swap	d1
	move.w	#$f000,d0
	sub.w	d1,d0
	move.l	a0,bltbpt(a6)
	move.w	d0,bltcon1(a6)
	move.w	#128*64+17,bltsize(a6)
end_inter:
	rts

hsin1:	dc.w	100
hsin:	dc.w	34
	incbin	sintabh.ud

vsin1:	dc.w	48
vsin:	dc.w	-2
	incbin	sintabv.ud

debug_inter:
	lea	menuscreen,a0
	adda.l	#interscreen-menuscreen+40+3*line,a0
	moveq	#0,d2
	moveq	#127,d1
debug_line:
	move.w	d2,(a0)
	lea	line(a0),a0
	dbf	d1,debug_line
	rts

noisecounter:
	dc.w 0

make_noise:
	lea	menuscreen,a1
	adda.l	#noise-menuscreen,a1
	lea	noisecounter(pc),a0
	add.w	#19*line,(a0)
	move.w	(a0),d0
	cmp.w	#57*line,d0
	bne.s	no_nreset
	moveq	#0,d0
	move.w	d0,(a0)
no_nreset:
	lea	(a1,d0.w),a1
	move.b	$bfe601,d0
	and.w	#$3,d0
	subq.w	#1,d0
	bmi.s	no_lineadd
lineadd:
	lea	line(a1),a1
	dbf	d0,lineadd	
no_lineadd:
	bsr	planeentry.n
	rts

stopper:	dc.w	0
initstopscrll:
	and.w	#$f,d1
	mulu.w	#50,d1
	lea	stopper(pc),a1
	move.w	d1,(a1)
stopscroll:
	subq.w	#1,(a1)
	rts

reset_scroll:
	move.w	d1,-(a0)
	bra.s	get_scrptr

scroller:
	lea	stopper(pc),a1
	tst.w	(a1)
	bne.s	stopscroll
	lea	menuscreen,a0
	move.l	a0,a1
	lea	scrolltext,a0
	adda.l	#scrollscreen-menuscreen+2*line+33,a1
	subq.w	#1,(a0)
	bne.s	scroll1pix	
	move.w	#(8/scrollspeed),(a0)+
get_scrptr:
	move.w	(a0),d0
	moveq	#0,d1
	addq.w	#1,(a0)+
	move.b	(a0,d0.w),d1
	beq.s	reset_scroll
	bmi.s	initstopscrll
	subi.b	#$20,d1
	lea	font16,a0
	lea	(a0,d1.w),a0		
	moveq	#13,d2
nextchrline:
	move.b	(a0),(a1)
	lea	480/8(a0),a0
	lea	line(a1),a1
	dbf	d2,nextchrline		
	lea	6*line(a1),a1
	moveq	#13,d2
nextchrline2:
	move.b	(a0),(a1)
	lea	480/8(a0),a0
	lea	line(a1),a1
	dbf	d2,nextchrline2		
scroll1pix:
	lea	menuscreen,a0
	adda.l	#scrollscreen-menuscreen+2*line,a0
	lea	-2(a0),a1
	WAITBLIT
	move.w	#(16-scrollspeed)*4096,d0
	or.w	#$09f0,d0
	move.w	d0,bltcon0(a6)
	move.w	#14*64+18,d3 ;bltsize
	moveq	#6,d0
	move.w	d0,bltamod(a6)
	move.w	d0,bltdmod(a6)
	moveq	#-1,d0
	move.l	d0,bltafwm(a6)
	moveq	#0,d0
	move.w	d0,bltcon1(a6)
	
	move.l	a0,bltapt(a6)
	move.l	a1,bltdpt(a6)
	move.w	d3,bltsize(a6)
	lea	planesize.s(a0),a0
	lea	planesize.s(a1),a1
	WAITBLIT
	move.l	a0,bltapt(a6)
	move.l	a1,bltdpt(a6)
	move.w	d3,bltsize(a6)
endscroll:
	rts

waitline:
	cmp.b	#180,vhposr(a6)
	bne.s	waitline
	rts
	
vbi:
	movem.l	d0-d7/a0-a6,-(a7)
	lea	$dff000,a6
	bsr	debug_inter
	bsr	scroller
	bsr	make_noise
	
	bsr.s	waitline
	bsr	interference
	lea	menuscreen,a5
;	adda.l	#mt_music-menuscreen,a5
;	jsr	(a5)
	
	lea	delay(pc),a0
	subq.w	#1,(a0)
	bne.s	endvbi
	moveq	#1,d0
	move.w	d0,(a0)
	
	move.w	show_info(pc),d0
	bpl.s	handle_info
	
	bsr	ask_mouse
	bsr	move_plane
	bsr.s	get_number
endvbi:
	move.w	#$20,intreq(a6)
	movem.l	(a7)+,d0-d7/a0-a6
	rte

handle_info:
	bsr	ask_mouse
	bsr	move_plane.i
	bsr.s	ask_lmb
	bra.s	endvbi
	
ask_lmb:
	move.w	fall_down(pc),d0
	bne.s	no_lmb
	btst	#6,$bfe001
	bne.s	no_lmb
	lea	fall_down(pc),a0
	moveq	#-1,d0
	move.w	d0,(a0)
no_lmb:
	rts

get_number:
	move.w	fall_down(pc),d0
	bne.s	moving
	lea	valid_choice(pc),a0
	moveq	#0,d0
	move.w	abs_position(pc),d0
	subi.w	#2*(minposition-1),d0
	lsr.w	#1,d0
	addi.w	#10,d0
	divu.w	#10,d0
	swap	d0
	cmpi.w	#4,d0
	bpl.s	not_exactly
	swap	d0
	cmp.w	#toolnumber+1,d0
	bpl.s	internal
	move.w	#hilitecol,d2
	btst	#6,$bfe001
	bne.s	hilite
	move.w	d0,(a0)
	lea	fall_down(pc),a0
	moveq	#-1,d0
	move.w	d0,(a0)	;set fall_down
	move.w	#menutxtcol,d2
hilite:
	lea	choiceras+2,a0
	moveq	#7,d1
activate:
	move.w	d2,(a0)
	lea	4(a0),a0
	dbf	d1,activate
moving:
	rts

internal:
	move.w	#hilitecol,d2
	cmp.w	#toolnumber+2,d0
	bne.s	hilite
	btst	#6,$bfe001
	bne.s	hilite
	lea	fall_down(pc),a0
	moveq	#-1,d0
	move.w	d0,(a0)	;set fall_down
	move.w	#menutxtcol,d2
	bra.s	hilite

not_exactly:
	moveq	#0,d0
	move.w	d0,(a0)
	lea	choiceras+2,a0
	move.w	#menutxtcol,d0
	moveq	#7,d1
deactivate:
	move.w	d0,(a0)
	lea	4(a0),a0
	dbf	d1,deactivate
	rts

delay:		dc.w	clickdelay
show_info:	dc.w	-1

finished:	dc.w	0	;reihenfolge nicht ändern
valid_choice:	dc.w	0	;
init_mouse:	dc.w	-1
oldmouse_y:	dc.w	0	;reihenfolge nicht ändern
abs_position:	dc.w	0	;
min_position:	dc.w	0	;
max_position:	dc.w	0	;
aim_position:	dc.w	0	;
fall_down:	dc.w	1	;1=move_up -1=fall 0=normal

ask_mouse:
	move.w	init_mouse(pc),d0
	bmi	get_started
	move.w	fall_down(pc),d0
	beq.s	do_really_ask
	
	move.w	fall_down(pc),d0
	bmi.s	fall
move_up:
	lea	abs_position(pc),a0
	addi.w	#move_up_speed,(a0)
	move.w	aim_position(pc),d1
	cmp.w	(a0),d1
	bpl.s	move_on1
	move.w	d1,(a0)
	moveq	#0,d0
	lea	fall_down(pc),a0
	move.w	d0,(a0)
	lea	oldmouse_y(pc),a0
	move.b	joy0dat(a6),d0
	move.w	d0,(a0)
move_on1:
	rts

fall:
	lea	abs_position(pc),a0
	subi.w	#fall_down_speed,(a0)
	moveq	#0,d1
	cmp.w	(a0),d1
	bmi.s	move_on2
	move.w	d1,(a0)
	lea	valid_choice(pc),a0
	move.w	(a0),d0
	beq.s	nothing_sel
	move.w	(a0),d0
	move.w	d0,-(a0)	;set finished with (valid_choice)
	rts

nothing_sel:
	lea	fall_down(pc),a0
	move.w	d0,(a0)
	lea	show_info(pc),a0
	neg.w	(a0)	;toggle show_info
	lea	delay(pc),a0
	move.w	#clickdelay,(a0)
	lea	init_mouse(pc),a0
	moveq	#-1,d0
	move.w	d0,(a0)
move_on2:
	rts
	

do_really_ask:
	moveq	#0,d1
	move.b	joy0dat(a6),d1
	lea	oldmouse_y(pc),a0
	move.w	(a0),d0
	move.w	d1,(a0)+
	sub.b	d0,d1
	bpl.s	inc_pos
	neg.b	d1
	move.w	(a0),d0
	sub.w	d1,d0
	lea	min_position(pc),a1
	cmp.w	(a1),d0
	bpl.s	no_minimum
	move.w	(a1),d0
no_minimum:
	move.w	d0,(a0)
	rts

inc_pos:
	move.w	(a0),d0
	add.w	d1,d0
	lea	max_position(pc),a1
	cmp.w	(a1),d0
	bmi.s	no_maximum
	move.w	(a1),d0
no_maximum:
	move.w	d0,(a0)
	rts

get_started:
	lea	init_mouse(pc),a0
	moveq	#0,d0
	move.w	d0,(a0)+
	move.b	joy0dat(a6),d0
	move.w	d0,(a0)+
	move.w	show_info(pc),d0
	bpl.s	initinfomouse
	moveq	#0,d0
	move.w	d0,(a0)+
	move.w	#minposition*2,(a0)+
	move.w	#(maxposition+1)*2,(a0)+
	move.w	#maxposition*2,(a0)+
	moveq	#1,d0
	move.w	d0,(a0)	;set move_up
	rts

initinfomouse:
	moveq	#0,d0
	move.w	d0,(a0)+
	move.w	#minposition*2,(a0)+
	move.w	#(maxposition.i+1)*2,(a0)+
	move.w	#minposition*2,(a0)+
	moveq	#1,d0
	move.w	d0,(a0)	;set move_up
	rts

move_plane.i:
	moveq	#0,d1
	move.w	abs_position(pc),d1
	lsr.w	#1,d1
	;move.w	d1,color(a6)
	mulu.w	#line,d1
	lea	menuscreen,a1
	lea	infoscreen-menuscreen(a1),a1
	lea	(a1,d1.l),a1
	bsr.s	planeentry.m
	rts

planeentry.m:
	move.l	a1,d1	;a1 wird akt. screenadresse
	lea	bplane.m+2,a0	
	swap	d1
	move.w	d1,(a0)
	lea	4(a0),a0
	swap	d1
	move.w	d1,(a0)
	rts

move_plane:
	move.w	abs_position(pc),d1
	lsr.w	#1,d1
	;move.w	d1,color(a6)
	mulu.w	#line,d1
	lea	menuscreen,a1
	lea	(a1,d1.w),a1
	bsr.s	planeentry.m
	rts



enter_sprites:
	lea	menuscreen,a0
	lea	sprdat0,a0
	lea	232*8(a0),a1
	lea	232*8(a1),a2
	lea	232*8(a2),a3
	lea	menuscreen,a4
	lea	sprcontrols,a4
	
	move.l	(a4)+,(a0)
	lea	232*4(a0),a0
	move.l	(a4)+,(a0)
	
	move.l	(a4)+,(a1)
	lea	232*4(a1),a1
	move.l	(a4)+,(a1)
	
	move.l	(a4)+,(a2)
	lea	232*4(a2),a2
	move.l	(a4)+,(a2)
	
	move.l	(a4)+,(a3)
	lea	232*4(a3),a3
	move.l	(a4)+,(a3)
	
	move.l	#$01200000,d6
	move.l	#$00020000,d5
	lea	sprpointers,a1
	lea	menuscreen,a0
	lea	sprdat0,a0
	move.l	a0,d0
	moveq	#7,d7
nextspr:
	swap	d0
	move.w	d0,d6
	move.l	d6,(a1)+
	add.l	d5,d6
	swap	d0
	move.w	d0,d6
	move.l	d6,(a1)+
	addi.l	#232*4,d0
	add.l	d5,d6
	dbf	d7,nextspr
	rts


inter:
	incbin	ud.interfer.raw

sprcontrols:
	dc.l $35c51c02
	dc.l $35c51c82
	
	dc.l $35cd1c02
	dc.l $35cd1c82
	
	dc.l $35d51c02
	dc.l $35d51c82

	dc.l $35dd1c02
	dc.l $35dd1c82
	

sprdat0:
	incbin ud.ift.spr ;4 attached sprites mit ctrl-words 64*230

	even
menutext:
	dc.b "       D COPY VERSION 3.1       "
	dc.b " DAS MODULE PLAYER VERSION 1.44 "
	dc.b "    DISK CATALOG VERSION 1.3    "
        DC.B "      DOS TRACE VERSION 1.0     "
        DC.B "     ICON TRACE VERSION 1.0     "
        DC.B "     MULTI TOOL VERSION 1.4     " 
        DC.B "     PERVERTER VERSION 1.12     "
        DC.B "     PROTRACKER VERSION 2.95    "
        DC.B "     PROTRACKER VERSION 3.10    "
        DC.B "     SCYP MONITOR VERSION 1.7   "
        DC.B "     THE CRYPTER VERSION 1.2    "
        DC.B "       VIRUS Z VERSION 3.07     "
	dc.b " DOC      MODULE PLAYER     DOC "
	dc.b " DOC      DISK CATALOG      DOC "
	DC.B " DOC        DOS TRACE       DOC "
	dc.b " DOC       ICON TRACE       DOC "
        DC.B " DOC       MULTI TOOL       DOC "
        DC.B " DOC        SCYP MON        DOC "
        DC.B " DOC         VIRUS Z        DOC "
;        dc.b " DOC     SELF DEFENDER      DOC "
;        DC.B " DOC        ST PLAYER       DOC "
;        DC.B " DOC     TOUCH COMMANDER    DOC "
;        DC.B " DOC      VIRUS CHECKER     DOC "
;        DC.B " DOC         BEERMON        DOC "
;        DC.B " DOC          REORG         DOC "
;        DC.B " DOC        SNOOPDOS        DOC "
;        DC.B " DOC       SPY SYSTEM       DOC "
;        DC.B " DOC      STONE CRACKER     DOC "
	dc.b "                                "
	dc.b "      PLEASE READ ME FIRST      "
	dc.w 0
	
	;siehe menutext
	
packnumber:	dc.b "62" ; immer 2 ziffern
infotext:	dc.b " USE RAT TO SCROLL LMB FOR MENU "

        dc.b "                                "
        dc.b "  TO AVOID RELOADING THIS MENU  "
        dc.b "  JUST PRESS BOTH MOUSEBUTTONS  "  
        dc.b "      TO SELECT AN PROGRAM      "
        dc.b "                                "
	dc.b " THE INFECTED ONES ARE:         "
	dc.b "                                "
	dc.b " BEATHOVEN................MUSIC "
	dc.b " BUCKLY................GRAPHICS "
	DC.B " ERNIE.................HARDWARE "
	DC.B " GADGET................SWAPPING "
	DC.B " HOBBES...................MUSIC "
	DC.B " MARLEY..................CODING "
	dc.b " SARON.................SWAPPING "
	DC.B " SPIV..................GRAPHICS "
	DC.B " COACH..................TRAINER "
	DC.B "                                "
	DC.B "  CREDITS FOR THIS PACK-MENU:   "
	DC.B "                                "
	DC.B " MUSIC................BEATHOVEN "
	DC.B " GRAPHICS..................SPIV "
	DC.B " CODING..................MARLEY "
	DC.B " COMPACTING...............SARON "
	DC.B "                                "
        dc.B "                                "
	DC.B "  FOR SAMPLE SWAPPING CONTACT:  "
	DC.B "                                "
	DC.B "   MICHAEL (BEATHOVEN) SCHEUCH  "
	DC.B "     ALBERT-EINSTEIN-STR.10     "
	DC.B "        W-4920 LEMGO 1          "
	DC.B "           GERMANY              "
;	DC.B "                                "
;	DC.B "                                "
;	DC.B "                                "
;	DC.B "                                "
;	DC.B "                                "
	DC.B "                                "
	DC.B "    CONTACT OUR MAILSWAPPER:    "
	DC.B "                                "
	DC.B "      DIRK (GADGET) TIETZ       "
	DC.B "      BORNHARDTSTRASSE 10       "
	DC.B "         W-3380 GOSLAR          " 
	DC.B "            GERMANY             "
        DC.B "                                "
        DC.B " IMPORTANT NOTE:                "
        DC.B "                                "
        DC.B " I HAVE NOT THE TIME TO CHECK   "
        DC.B " ALL FILES IF THEY ARE PIRACY OR"
        dc.b " COPYRIGHTED! SO PLEASE DELETE  "
        DC.B " THEM AND INFORM THE INFECT     "
	DC.B " MEMBERS!!   THANX ......       "
	DC.B " THE UTILITY DISKS ARE PD SOFT! "

inftxtend:
	dc.w 0

	;der scrolltext kann mit f1..f9(..ff) 1 bis 9 (..15)
	;sekunden angehalten werden
	;und muß mit ,0 enden
scrolltext:
	dc.w (8/scrollspeed),0
	dc.b "                        THE BEGINNING OF JULY 1993 "
	DC.B "        "
	DC.B "      ITS TIME FOR A NEW      "
	dc.b "          UTILITY DREAM         ",$f3  
	dc.b "   NUMBER 62          "
	DC.B "    FROM  "
	DC.B "        '-- I N F E C T --'      ",$f3
	DC.B "THERE IS NO MEDICINE AGAINST      "
	DC.B "       GREETINGS TO ALL OUR FRIENDS AND CONTACTS!!  "
	DC.B "     VOTE FOR US IN THE CHARTS        "
	DC.B "       BYE BYE      SARON OF INFECT   "
	DC.B "                                 ",0
	
	even

	section	coppona,data_C

coplist:
	dc.w $1fc,0
	dc.w $106,$c00
	dc.w $10c,$11
	dc.w $0100,$3200
	dc.w $0102,$0040 ;links von interfer sind 4 pixel für kasten 
		   ;(gerade bpls) !!
	dc.w $0104,$0038 
	dc.w $008e,$2881
	dc.w $0090,$28c9
dfetchstart:
	dc.w $0092,$0038
dfetchstop:
	dc.w $0094,$00d4
modulo0:
	dc.w $0108,$0000
modulo1:
	dc.w $010a,$0000
sprpointers:
	dcb.l 8*2,0
color0.1:
	dc.w $0180,$014
	dc.w $0182,$0237
	dc.w $0188,$0679
	dc.w $018a,$0ccb
	dc.w $0184,$bbb
	dc.w $0186,$bbb
	dc.w $018c,$bbb
	dc.w $018e,$bbb
colors.def:
	dc.w	$1a2,$eaf,$1a4,$c8d,$1a6,$a6b
	dc.w	$1a8,$949,$1aa,$727,$1ac,$526,$1ae,$214
	dc.w	$1b0,$013,$1b2,$125,$1b4,$247,$1b6,$358
	dc.w	$1b8,$27a,$1ba,$28c,$1bc,$1ad,$1be,$1bf
bplanes.u:
	dc.w $00e0,$0000
	dc.w $00e2,$0000
	dc.w $00e8,$0000
	dc.w $00ea,$0000
bplane.i:
	dc.w $00e4,$0000
	dc.w $00e6,$0000
	
	dc.w $2b01,$fffe
	dc.w $0100,$4200
bplane.m:
	dc.w $00ec,$0000
	dc.w $00ee,$0000
	dc.w $0190,menutxtcol0
	dc.w $0192,menutxtcol0
	dc.w $0194,menutxtcol0
	dc.w $0196,menutxtcol0
	dc.w $0198,menutxtcol0
	dc.w $019a,menutxtcol0
	dc.w $019c,menutxtcol0
	dc.w $019e,menutxtcol0
	dc.w $2c07,$fffe
	dc.w $0190,menutxtcol1
	dc.w $0192,menutxtcol1
	dc.w $0194,menutxtcol1
	dc.w $0196,menutxtcol1
	dc.w $0198,menutxtcol1
	dc.w $019a,menutxtcol1
	dc.w $019c,menutxtcol1
	dc.w $019e,menutxtcol1
	dc.w $2d07,$fffe
	dc.w $0190,menutxtcol2
	dc.w $0192,menutxtcol2
	dc.w $0194,menutxtcol2
	dc.w $0196,menutxtcol2
	dc.w $0198,menutxtcol2
	dc.w $019a,menutxtcol2
	dc.w $019c,menutxtcol2
	dc.w $019e,menutxtcol2
	dc.w $2e07,$fffe
	dc.w $0190,menutxtcol
	dc.w $0192,menutxtcol
	dc.w $0194,menutxtcol
	dc.w $0196,menutxtcol
	dc.w $0198,menutxtcol
	dc.w $019a,menutxtcol
	dc.w $019c,menutxtcol
	dc.w $019e,menutxtcol
	
	dc.w $6a07,$fffe
choiceras:
	dc.w $0190,menutxtcol
	dc.w $0192,menutxtcol
	dc.w $0194,menutxtcol
	dc.w $0196,menutxtcol
	dc.w $0198,menutxtcol
	dc.w $019a,menutxtcol
	dc.w $019c,menutxtcol
	dc.w $019e,menutxtcol
	dc.w $7407,$fffe
	dc.w $0190,menutxtcol
	dc.w $0192,menutxtcol
	dc.w $0194,menutxtcol
	dc.w $0196,menutxtcol
	dc.w $0198,menutxtcol
	dc.w $019a,menutxtcol
	dc.w $019c,menutxtcol
	dc.w $019e,menutxtcol
	
	dc.w $7607,$fffe ;change lower spritecolors
colors1:
	dc.w	$1b2,$023,$1b4,$143,$1b6,$153
	dc.w	$1b8,$275,$1ba,$297,$1bc,$3a8,$1be,$3ca
	
	dc.w	$9607,$fffe ;change higher spritecolors
	dc.w	$1a2,$eb2,$1a4,$c92,$1a6,$b61
	dc.w	$1a8,$941,$1aa,$821,$1ac,$522,$1ae,$312
	
	dc.w $aa07,$fffe
	dc.w $0190,menutxtcol2
	dc.w $0192,menutxtcol2
	dc.w $0194,menutxtcol2
	dc.w $0196,menutxtcol2
	dc.w $0198,menutxtcol2
	dc.w $019a,menutxtcol2
	dc.w $019c,menutxtcol2
	dc.w $019e,menutxtcol2
	
	dc.w $ab07,$fffe
	dc.w $0190,menutxtcol1
	dc.w $0192,menutxtcol1
	dc.w $0194,menutxtcol1
	dc.w $0196,menutxtcol1
	dc.w $0198,menutxtcol1
	dc.w $019a,menutxtcol1
	dc.w $019c,menutxtcol1
	dc.w $019e,menutxtcol1
	
	dc.w $ac07,$fffe
	dc.w $0190,menutxtcol0
	dc.w $0192,menutxtcol0
	dc.w $0194,menutxtcol0
	dc.w $0196,menutxtcol0
	dc.w $0198,menutxtcol0
	dc.w $019a,menutxtcol0
	dc.w $019c,menutxtcol0
	dc.w $019e,menutxtcol0
	
	dc.w $ad07,$fffe
	dc.w $0100,$3200
	
	dc.w $b101,$fffe
	dc.w $0102,$0000 	
	dc.w $0100,$3200
bplanes.s:
	dc.w $00e0,$0000
	dc.w $00e2,$0000
	dc.w $00e4,$0000
	dc.w $00e6,$0000
bplane.n:
	dc.w $00e8,$0000
	dc.w $00ea,$0000
colors.n:
	dc.w $0188,$0014 ;die noisefarben
	dc.w $018a,$0014
	dc.w $018c,$0014
	dc.w $018e,$0014
	dc.w $0182,$0368 ;scrollerfarben
	dc.w $0184,$06AB
	dc.w $0186,$09FF
	
	dc.w	$b607,$fffe ;change lower spritecolors
	dc.w	$1b2,$224,$1b4,$444,$1b6,$655
	dc.w	$1b8,$876,$1ba,$a87,$1bc,$ca8,$1be,$eb9
	
	dc.w $c307,$fffe
	dc.w $0100,$1200
colors.l:
	dc.w $0182,$0014
	dc.w $0184,$0679
	dc.w $0186,$0237
	dc.w $0188,$0AAC
	dc.w $018a,$088B
	dc.w $018c,$066A
	dc.w $018e,$0448
	dc.w $0190,$0227
	dc.w $0192,$0116
	dc.w $0194,$0005
	dc.w $0196,$0F9E
	dc.w $0198,$0D6C
	dc.w $019a,$0C4A
	dc.w $019c,$0A28
	dc.w $019e,$0906
	dc.w $c407,$fffe
	dc.w $0100,$4200 	
bplanes.l:
	dc.w $00e0,$0000
	dc.w $00e2,$0000
	dc.w $00e4,$0000
	dc.w $00e6,$0000
	dc.w $00e8,$0000
	dc.w $00ea,$0000
	dc.w $00ec,$0000
	dc.w $00ee,$0000
color.lb:
	dc.w $0182,$0CCB
	
	dc.w	$d607,$fffe ;change higher spritecolors
	dc.w	$1a2,$dbf,$1a4,$b9d,$1a6,$97c
	dc.w	$1a8,$75a,$1aa,$539,$1ac,$327,$1ae,$225
	
	dc.w $ffff,$fffe

font8:		incbin	ud.font8_8.raw
font16:		incbin	ud.font8_16.raw
numbers:	incbin	ud.numbers.raw

upperbox:
	incbin ud.upper.raw


;	section	buffers,bss_C

interscreen:	ds.l (planesize.i)/4
menuscreen:	ds.l (planesize.menu)/4
infoscreen:	ds.l (planesize.info)/4
scrollscreen:	ds.l (2*planesize.s)/4
noise:
	incbin ud.noise.raw
logo:
;	incbin ud.logo.raw
	DCB.B	16800,$56

	end
