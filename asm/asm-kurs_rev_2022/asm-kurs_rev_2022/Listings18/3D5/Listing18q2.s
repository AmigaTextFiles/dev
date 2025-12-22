
; Listing18q2.s = FILLED-VECTOR.S

; filled vector example by matrix/plague


;The source is partially optimised (E.g. I never really had a slow routine!)
;It is also documented. However! There are certain things that you should
;keep to mind :-
;If you will be coding a vector-routine sometime, then you will need to keep
;The LINEDRAW routine.
;-This routine was not coded by me, it has been published in several
;-books, so there is no need to write a new one!
;-Also it is extremely fast anyway!

;The source is split into 3 main areas :-
;1) Calculate point rotation
;2) Calculate visible surfaces and draw lines between points
;3) Fill bitplanes.

;A general idea of matrix-maths is preferable but not necessary
;(My maths is terrible!)
;So, with that in mind, i have also included some text that has
;an explanation of vector calculation by kreator/anarchy. This should
;explain the actual point rotation a lot better than me.

;-To better understand kreators explanation i have included some source
;-which he gave away at the same time, this is similar to mine
;-but his follows the explanation, whereas mine does not.

;The bit that he doesn't tell you about is the surface calculation :-

;Put simply this calculates which way the vector points
;were rotated in, if the result is negative then the surface is anti-clockwise and not
;visible. Your actual surface structure must be defined clockwise (all points
;going clockwise).

;Have fun !!
;Signed : Matrix/Plague

;If it is not documented enough then contact me and i will try and answer
;any questions you may have.
;But it would be better to keep this source somewhere safe and use routines
;from it!

********************************************
** SYSTEM EQUATES AND CHIP RAM ASSIGNMENT **
********************************************

	SECTION	Matrix1,CODE_C

execbase	= 4
trap0		= $80
openlibrary	= -552
closelibrary	= -414

wblit	macro
wblt\@	btst	#6,$2(a6)
	bne.s	wblt\@
	endm

********************************************
** INITIALISATION AND START ROUTINES      **
********************************************

start	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#start2,trap0
	trap	#0
	movem.l	(sp)+,d0-d7/a0-a6
	moveq.l	#0,d0
	rts

start2	bsr.s	systemsetup
	bsr	doblits
	bsr	insertbitplanes
	bsr	insertsprites
	bsr	makecopper
	bsr	initcopper
	bsr	mainloop
	bsr	restoreos
	rte

********************************************
** STORE REGISTERS AND SET NEW CONTENTS   **
********************************************

systemsetup
	move.l	(execbase).w,a6
	lea	gfxname,a1
	moveq.l	#0,d0
	jsr	openlibrary(a6)
	move.l	d0,gfxbase
	lea	$dff000,a6
	bset	#1,$bfe001
	move.w	#32,$1dc(a6)
	clr.l	$0
	move.w	$1c(a6),intesave
	or.w	#$8000,intesave
	move.w	$1e(a6),intrsave
	or.w	#$8000,intrsave
	move.w	$2(a6),dmasave
	or.w	#$8000,dmasave
	move.w	$10(a6),adksave
	or.w	#$8000,adksave
sswbeam	move.l	$4(a6),d0
	and.l	#$1ff00,d0
	lsr.l	#8,d0
	cmpi.w	#305,d0
	bne.s	sswbeam
	move.w	#$7fff,$dff096
	move.w	#$87e0,$dff096
	move.w	#$7fff,$dff09a
	rts

********************************************
** DO ANY SETUP BLITS - PUTTING GRAPHICS  **
** INTO BITPLANES ETC                     **
********************************************

doblits	move.l	#-1,$44(a6)
	move.l	#0,$64(a6)
	move.l	#$01000000,$40(a6)
	wblit
	rts

********************************************
** INSERT THE BITPLANE POINTERS INTO THE  **
** COPPERLIST STRUCTURE			  **
********************************************

insertbitplanes
	move.l	#vecplane1,d0
	move.w	d0,vecpl1+6
	swap	d0
	move.w	d0,vecpl1+2
	swap	d0
	add.l	#40*171,d0
	move.w	d0,vecpl2+6
	swap	d0
	move.w	d0,vecpl2+2
	rts

********************************************
** INSERT THE HARDWARE SPRITE POINTERS    **
** INTO THE COPPERLIST STRUCTURE          **
********************************************

insertsprites
	rts

********************************************
** PERFORM ALL THE BORING COPPER TASKS    **
** SUCH AS MAKING LARGE COLOURED BARS     **
********************************************

makecopper
	rts

********************************************
** SWITCH ON THE COPPER START ADDRESS     **
********************************************

initcopper
	move.l	#newcopper,$80(a6)
	move.w	$88(a6),d0
	rts

********************************************
** RESTORE THE SAVED DMA/INTERRUPT        **
** REGISTERS AND THE STANDARD COPPER LIST **
********************************************

restoreos
	move.w	intesave,$9a(a6)
	move.w	intrsave,$9c(a6)
	move.w	dmasave,$96(a6)
	move.w	adksave,$9e(a6)
	move.l	gfxbase,a0
	move.l	38(a0),$80(a6)
	move.w	$88(a6),d0
	move.l	(execbase).w,a6
	move.l	gfxbase,a1
	jsr	closelibrary(a6)
	rts

********************************************
** THE MAIN PROGRAM LOOP                  **
********************************************

mainloop
	move.l	$4(a6),d0
	and.l	#$1ff00,d0
	cmpi.l	#$ff00,d0
	bne.s	mainloop
	bsr	filledvectors
	btst	#6,$bfe001
	bne.s	mainloop
	rts

********************************************
** FILLED-VECTOR ROUTINE V1.0             **
********************************************

sincos	macro
	move.w	64(a1,d6),d4	;get cosine value
	move.w	-64(a1,d6),d5	;get sine value
	move.w	d0,d2		;get copy of val1=val3
	move.w	d1,d3		;get copy of val2=val4
	muls	d4,d0		;get cosine value of val1
	muls	d5,d1		;get sine value of val2
	muls	d4,d3		;get cosine value val4
	muls	d5,d2		;get sine value val3
	sub.l	d1,d0		;val1=val1-val2
	add.l	d0,d0		;*2
	add.l	d2,d3		;val4=val3+val4
	add.l	d3,d3		;*2
	swap	d0		;get high word
	swap	d3		;get high word
	endm

calcrot	macro
	move.w	(a0)+,d0		;get x point
	move.w	(a0)+,d1		;get y point
	move.w	yrotate,d6		;y rotation angle
	sincos
	move.w	d0,xstore
	move.w	d3,d0
	move.w	(a0)+,d1		;get z point
	move.w	zrotate,d6		;z rotation angle
	sincos
	move.w	d0,ystore
	move.w	d3,d0
	move.w	xstore,d1
	move.w	xrotate,d6		;x rotation angle
	sincos
	move.w	ystore,d1
	endm

filledvectors
	subq.w	#4,xrotate		;inc/dec x-rotation angle
	and.w	#$1ff,xrotate
	addq.w	#2,yrotate		;inc/dec y-rotation angle
	and.w	#$1ff,yrotate
	addq.w	#2,zrotate		;inc/dec z-rotation angle
	and.w	#$1ff,zrotate

	lea	filpoints,a0	;get address of vector-points
	lea	vectorsine+64,a1	;get address of sinetable
	lea	filstore,a2		;get address of calculated point storage
				;area
	move.w	(a0)+,d7		;get number of points
filcalc	calcrot
	moveq.l	#10,d4
	move.w	#920,d2		;scale size:bigger number=bigger vector
	sub.w	d3,d2		;subtract coord z-size
	muls	d2,d0		;scale x
	asr.l	d4,d0		;scale x
	muls	d2,d1		;scale y
	asr.l	d4,d1		;scale y
	add.w	#97,d0		;centralise x-points
	add.w	#85,d1		;centralise y-points
	move.w	d0,(a2)+		;store x
	move.w	d1,(a2)+		;store y
	dbf	d7,filcalc		;do more ?

	move.l	#-1,$44(a6)
	move.l	#-$8000,$72(a6)
	move.w	#20,$60(a6)		;20=vectorplane size
	lea	filstore,a1		;get address of coord-storage area
	lea	filconnects,a2	;get line-connection list
	lea	filshift,a3		;get pre-calc line-shift table
	lea	llength,a5		;get pre-calc line-length table
	lea	filsurfaces,a6	;get address of surface structures
	move.w	(a6)+,filsurfaceno	;get number of surfaces on vector
fildrawlp1
	move.l	(a6)+,d7		;get number of sides to surface
	move.l	(a6)+,a4		;get address of surface list
	move.l	(a6)+,a0		;get address of bitplane to draw to
	move.l	(a6)+,filblitno	;get double-line flag
	move.w	(a4),d6		;calculate if surface visible
	move.w	(a2,d6),d4
	move.w	2(a2,d6),d5
	move.w	(a1,d4),d0
	sub.w	(a1,d5),d0
	move.w	2(a1,d4),d1
	sub.w	2(a1,d5),d1
	move.w	2(a4),d6
	move.w	(a2,d6),d4
	move.w	2(a2,d6),d5
	move.w	(a1,d4),d2
	sub.w	(a1,d5),d2
	move.w	2(a1,d4),d3
	sub.w	2(a1,d5),d3
	muls	d3,d0
	muls	d2,d1
	cmp.w	d0,d1
	bmi.s	filndraw2		;result negative-dont draw
	move.l	a6,-(a7)
	lea	$dff000,a6
	tst.l	filblitno
	beq.s	filns1
	st.b	filblit1
filns1	bsr	linedraw		;draw lines
	move.l	(a7)+,a6
filndraw2
	subq.w	#1,filsurfaceno
	tst.w	filsurfaceno
	bne.s	fildrawlp1
	lea	$dff000,a6

	bsr.s	fillblit		;Fill it

	move.l	vecplaneptr1,d0		;Double-Buffer
	move.l	vecplaneptr2,d1
	move.l	d1,vecplaneptr1
	move.l	d0,vecplaneptr2
	move.w	d0,vecpl1+6
	swap	d0
	move.w	d0,vecpl1+2
	swap	d0
	add.l	#40*171,d0
	move.w	d0,vecpl2+6
	swap	d0
	move.w	d0,vecpl2+2
	rts

********************************************
** FILL THE SOLID VECTOR PLANES AND THEN  **
** CLEAR THEM                             **
********************************************

fillblit
	lea	vecbuff3-(20*6),a0	;address bottom of vectorplane
	move.l	vecplaneptr1,a1	;get address of bitplane
	add.l	#((40*171)*2)-(40*6)-22,a1	;get address of bottom of bitplane
	wblit			;wait for previous linedraw to finish
	move.l	#$09f00012,$40(a6)	;set copy/fill/descending mode
				;descending mode needed for filling
	move.w	#0,$64(a6)
	move.w	#20,$66(a6)
	move.l	a0,$50(a6)		;vectorplane address
	move.l	a1,$54(a6)		;bitplane address
	move.w	#(168+165)*64+10,$58(a6)	;set bltsize
	wblit
	move.l	#$01000000,$40(a6)	;clear vectorplane
	move.w	#0,$66(a6)
	move.l	#vecbuff1,$54(a6)
	move.w	#(171*2)*64+10,$58(a6)
	wblit
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

linedraw
	move.w	(a4)+,d5
	move.w	(a2,d5),d6
	move.w	(a1,d6),d0		;get x1
	move.w	2(a1,d6),d1		;get y1
	move.w	2(a2,d5),d6
	move.w	(a1,d6),d2		;get x2
	move.w	2(a1,d6),d3		;get y2
	moveq.l	#20,d5			;vectorplane width (bytes)
	cmp.w	d1,d3
	bgt.s	line1
	exg	d0,d2
	exg	d1,d3
	beq	ldout
line1	movem.w	d0/d1/d2/d3/d5,-(a7)	;store coord registers
	move.w	d1,d4
	muls	d5,d4
	move.w	d0,d5
	add.l	a0,d4
	asr.w	#3,d5
	add.w	d5,d4
	moveq	#0,d5
	sub.w	d1,d3
	sub.w	d0,d2
	bpl.s	line2
	moveq	#1,d5
	neg.w	d2
line2	move.w	d3,d1
	add.w	d1,d1
	cmp.w	d2,d1
	dbhi	d3,line3
line3	move.w	d3,d1
	sub.w	d2,d1
	bpl.s	line4
	exg	d2,d3
line4	addx.w	d5,d5
	add.w	d2,d2
	move.w	d2,d1
	sub.w	d3,d2
	addx.w	d5,d5
	add.w	d0,d0
	wblit
	move.w	d2,$52(a6)
	sub.w	d3,d2
	add.w	d3,d3
	move.w	(a3,d0),$40(a6)
	move.b	oct(PC,d5.w),$43(a6)
	move.l	d4,$48(a6)
	move.l	d4,$54(a6)
	movem.w	d1/d2,$62(a6)
	move.w	(a5,d3),$58(a6)
	movem.w	(a7)+,d0/d1/d2/d3/d5	;restore coords
	tst.b	filblit1		;test if double-line needed
	beq.s	ldout
	lea	vecbuff2,a0		;address second plane
	bsr.s	linedraw2		;draw it
	lea	vecbuff1,a0		;address first plane again
ldout	dbf	d7,linedraw		;more ?
	clr.b	filblit1		;clear double-line toggle
	rts
	
********************************************
** OCTANTS FOR LINES - MUST BE HERE       **
** REMAIN PC-RELATIVE                     **
********************************************

oct		dc.l	$3431353,$b4b1757
	even

********************************************
** SECOND LINE-DRAWER ROUTINE WHEN BOTH   **
** PLANES NEEDED FOR SURFACE              **
********************************************

linedraw2
	move.w	d1,d4
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
	wblit
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

********************************************
** THE PROGRAMS USER-DEFINED COPPERLIST   **
********************************************

newcopper
	dc.w $1fc,0
	dc.w $120,$0,$122,$0,$124,$0,$126,$0
	dc.w $128,$0,$12a,$0,$12c,$0,$12e,$0
	dc.w $130,$0,$132,$0,$134,$0,$136,$0
	dc.w $138,$0,$13a,$0,$13c,$0,$13e,$0
	dc.w $108,$0,$10a,$0
	dc.w $92,$38,$94,$d0
	dc.w $8e,$1a64,$90,$39d1
	dc.w $180,$203,$102,$0,$104,$0
	dc.w $100,$0
veccop	dc.w $182,$a0e,$184,$608,$186,$80a
vecpl1	dc.w $e0,$0,$e2,$0
vecpl2	dc.w $e4,$0,$e6,$0
	dc.w $7101,$fffe
	dc.w $100,$2200
	dc.w $ffe1,$fffe
	dc.w $1d01,$fffe,$100,$0
	dc.w $ffff,$fffe

********************************************
** PROGRAM STORAGE AREA, USED FOR STORES  **
** FLAGS, COUNTERS ETC		      **
** AND ANY INCLUDE BINARY DIRECTIVES      **
********************************************

gfxname		dc.b	"graphics.library",0,0

gfxbase		dc.l	0
intesave	dc.w	0
intrsave	dc.w	0
dmasave		dc.w	0
adksave		dc.w	0
	even
xrotate		dc.w	0	;xrotate angle
yrotate		dc.w	0	;yrotate angle
zrotate		dc.w	0	;zrotate angle
xstore		dc.w	0	;x temp-storage area
ystore		dc.w	0	;y temp-storage area
filsurfaceno	dc.w	0	;number of sides on vector
filblitno	dc.l	0		;double-line flag
filblit1	dc.b	0		;double-line flag2
	even

filpoints	dc.w	8-1		;number of points (-1 for dbf)
		dc.w	 50,+50,+50
		dc.w	-50,+50,+50
		dc.w	-50,-50,+50
		dc.w	 50,-50,+50
		dc.w	 50,+50,-50
		dc.w	-50,+50,-50
		dc.w	-50,-50,-50
		dc.w	 50,-50,-50
conect		macro
		dc.w	\1*4,\2*4
		endm
filconnects	conect	0,1		;which points join to which !
		conect	1,2
		conect	2,3
		conect	3,0
		conect	4,5
		conect	5,6
		conect	6,7
		conect	7,4
		conect	0,4
		conect	1,5
		conect	2,6
		conect	3,7
filsurfaces		dc.w	6	;6 surfaces on a cube

		dc.l	3,fsurface1,vecbuff1,1	;3-1 sides per surface
					;list of points to draw to
					;address of bitplane to draw to
					;double-line flag
		dc.l	3,fsurface2,vecbuff1,0
		dc.l	3,fsurface3,vecbuff2,0
		dc.l	3,fsurface4,vecbuff1,0
		dc.l	3,fsurface5,vecbuff2,0
		dc.l	3,fsurface6,vecbuff1,1
ssurf		macro
		dc.w	\1*4,\2*4,\3*4,\4*4
		endm
fsurface1	ssurf	4,5,6,7			;which connecting lines form
					;to make a surface
fsurface2	ssurf	3,11,7,8
fsurface3	ssurf	0,9,4,8
fsurface4	ssurf	1,9,5,10
fsurface5	ssurf	2,10,6,11
fsurface6	ssurf	3,2,1,0
filstore	ds.w	8*2			;x/y storage area
a set 0					;table for line-shift vals
filshift
		rept	320
		dc.w	((a&$f)*$1000)+$a4a
a set a+1
		endr
a set 0
llength					;table for line length vals
		rept	320
		dc.w	a*64+2
a set a+1
		endr
;sine table for vector rotation
vectorsine		DC.W	$0000,$0324,$0647,$096A,$0C8B,$0FAB,$12C7,$15E1
		DC.W	$18F8,$1C0B,$1F19,$2223,$2527,$2826,$2B1F,$2E10
		DC.W	$30FB,$33DE,$36B9,$398C,$3C56,$3F17,$41CD,$447A
		DC.W	$471C,$49B3,$4C3F,$4EBF,$5133,$539A,$55F5,$5842
		DC.W	$5A82,$5CB3,$5ED7,$60EB,$62F1,$64E8,$66CF,$68A6
		DC.W	$6A6D,$6C23,$6DC9,$6F5E,$70E2,$7254,$73B5,$7504
		DC.W	$7641,$776B,$7884,$7989,$7A7C,$7B5C,$7C29,$7CE3
		DC.W	$7D89,$7E1D,$7E9C,$7F09,$7F61,$7FA6,$7FD8,$7FF5
		DC.W	$7FFF,$7FF5,$7FD8,$7FA6,$7F61,$7F09,$7E9C,$7E1D
		DC.W	$7D89,$7CE3,$7C29,$7B5C,$7A7C,$7989,$7884,$776B
		DC.W	$7641,$7504,$73B5,$7254,$70E2,$6F5E,$6DC9,$6C23
		DC.W	$6A6D,$68A6,$66CF,$64E8,$62F1,$60EB,$5ED7,$5CB3
		DC.W	$5A82,$5842,$55F5,$539A,$5133,$4EBF,$4C3F,$49B3
		DC.W	$471C,$447A,$41CD,$3F17,$3C56,$398C,$36B9,$33DE
		DC.W	$30FB,$2E10,$2B1F,$2826,$2527,$2223,$1F19,$1C0B
		DC.W	$18F8,$15E1,$12C7,$0FAB,$0C8B,$096A,$0647,$0324
		DC.W	$0000,$FCDB,$F9B8,$F695,$F374,$F054,$ED38,$EA1E
		DC.W	$E707,$E3F4,$E0E6,$DDDC,$DAD8,$D7D9,$D4E0,$D1EF
		DC.W	$CF04,$CC21,$C946,$C673,$C3A9,$C0E8,$BE32,$BB85
		DC.W	$B8E3,$B64C,$B3C0,$B140,$AECC,$AC65,$AA0A,$A7BD
		DC.W	$A57D,$A34C,$A128,$9F14,$9D0E,$9B17,$9930,$9759
		DC.W	$9592,$93DC,$9236,$90A1,$8F1D,$8DAB,$8C4A,$8AFB
		DC.W	$89BE,$8894,$877B,$8676,$8583,$84A3,$83D6,$831C
		DC.W	$8276,$81E2,$8163,$80F6,$809E,$8059,$8027,$800A
		DC.W	$8000,$800A,$8027,$8059,$809E,$80F6,$8163,$81E2
		DC.W	$8276,$831C,$83D6,$84A3,$8583,$8676,$877B,$8894
		DC.W	$89BE,$8AFB,$8C4A,$8DAB,$8F1D,$90A1,$9236,$93DC
		DC.W	$9592,$9759,$9930,$9B17,$9D0E,$9F14,$A128,$A34C
		DC.W	$A57D,$A7BD,$AA0A,$AC65,$AECC,$B140,$B3C0,$B64C
		DC.W	$B8E3,$BB85,$BE32,$C0E8,$C3A9,$C673,$C946,$CC21
		DC.W	$CF04,$D1EF,$D4E0,$D7D9,$DAD8,$DDDC,$E0E6,$E3F4
		DC.W	$E707,$EA1E,$ED38,$F054,$F374,$F695,$F9B8,$FCDB
		DC.W	$0000,$0324,$0647,$096A,$0C8B,$0FAB,$12C7,$15E1
		DC.W	$18F8,$1C0B,$1F19,$2223,$2527,$2826,$2B1F,$2E10
		DC.W	$30FB,$33DE,$36B9,$398C,$3C56,$3F17,$41CD,$447A
		DC.W	$471C,$49B3,$4C3F,$4EBF,$5133,$539A,$55F5,$5842
		DC.W	$5A82,$5CB3,$5ED7,$60EB,$62F1,$64E8,$66CF,$68A6
		DC.W	$6A6D,$6C23,$6DC9,$6F5E,$70E2,$7254,$73B5,$7504
		DC.W	$7641,$776B,$7884,$7989,$7A7C,$7B5C,$7C29,$7CE3
		DC.W	$7D89,$7E1D,$7E9C,$7F09,$7F61,$7FA6,$7FD8,$7FF5
		DC.W	$7FFF,$7FF5,$7FD8,$7FA6,$7F61,$7F09,$7E9C,$7E1D
		DC.W	$7D89,$7CE3,$7C29,$7B5C,$7A7C,$7989,$7884,$776B
		DC.W	$7641,$7504,$73B5,$7254,$70E2,$6F5E,$6DC9,$6C23
		DC.W	$6A6D,$68A6,$66CF,$64E8,$62F1,$60EB,$5ED7,$5CB3
		DC.W	$5A82,$5842,$55F5,$539A,$5133,$4EBF,$4C3F,$49B3
		DC.W	$471C,$447A,$41CD,$3F17,$3C56,$398C,$36B9,$33DE
		DC.W	$30FB,$2E10,$2B1F,$2826,$2527,$2223,$1F19,$1C0B
		DC.W	$18F8,$15E1,$12C7,$0FAB,$0C8B,$096A,$0647,$0324
		DC.W	$0000,$FCDB,$F9B8,$F695,$F374,$F054,$ED38,$EA1E
		DC.W	$E707,$E3F4,$E0E6,$DDDC,$DAD8,$D7D9,$D4E0,$D1EF
		DC.W	$CF04,$CC21,$C946,$C673,$C3A9,$C0E8,$BE32,$BB85
		DC.W	$B8E3,$B64C,$B3C0,$B140,$AECC,$AC65,$AA0A,$A7BD
		DC.W	$A57D,$A34C,$A128,$9F14,$9D0E,$9B17,$9930,$9759
		DC.W	$9592,$93DC,$9236,$90A1,$8F1D,$8DAB,$8C4A,$8AFB
		DC.W	$89BE,$8894,$877B,$8676,$8583,$84A3,$83D6,$831C
		DC.W	$8276,$81E2,$8163,$80F6,$809E,$8059,$8027,$800A
		DC.W	$8000,$800A,$8027,$8059,$809E,$80F6,$8163,$81E2
		DC.W	$8276,$831C,$83D6,$84A3,$8583,$8676,$877B,$8894
		DC.W	$89BE,$8AFB,$8C4A,$8DAB,$8F1D,$90A1,$9236,$93DC
		DC.W	$9592,$9759,$9930,$9B17,$9D0E,$9F14,$A128,$A34C
		DC.W	$A57D,$A7BD,$AA0A,$AC65,$AECC,$B140,$B3C0,$B64C
		DC.W	$B8E3,$BB85,$BE32,$C0E8,$C3A9,$C673,$C946,$CC21
		DC.W	$CF04,$D1EF,$D4E0,$D7D9,$DAD8,$DDDC,$E0E6,$E3F4
		DC.W	$E707,$EA1E,$ED38,$F054,$F374,$F695,$F9B8,$FCDB
vecplaneptr1	dc.l	vecplane1
vecplaneptr2	dc.l	vecplane2
	even
	cnop	0,4
vecbuff0	ds.b	80
vecbuff1	ds.b	20*171
vecbuff2	ds.b	20*172
vecbuff3	ds.b	80
vecplane1	ds.b	(40*171)*2
vecplane2	ds.b	(40*171)*2
		ds.b	80
	even

	end

