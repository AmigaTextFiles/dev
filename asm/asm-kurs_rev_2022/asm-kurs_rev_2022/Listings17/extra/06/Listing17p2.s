
; Listings17p2.s = zoom.s

************************************************************************
; zoom pic 4 bitplanes (320*200), 8000 bytes + 16 col tab (20) 320
; save the PIC as RAW BLIT !!! not normal RAW!
************************************************************************

	section	ZOOM,code_c

start:
	movem.l	d0-d7/a0-a6,-(SP)
	move.l	4.w,a6			;forbid (eigentlich nicht notwendig,
	jsr	-$84(a6)		;da irqs später aus)	

	lea	grname(pc),a1
	jsr	-$198(a6)	; open gfx lib
	move.l	d0,graphicsbase

	lea	$dff000,a5
	move.w	$1c(a5),intenaold
	move.w	#$7fff,$9a(a5)		;no ints

	move.w	#$03f0,$96(a5)

makecop:
	move.w	#$2c07,d0	; wait word 1 (start = $2c)
	move.w	#$fffe,d1	; wait word 2
	move.l	#$01080078,d2	; bpl1mod (120)
	move.l	#$010a0078,d3	; bpl2mod (120)
	move.w	#$0100,d4	; add value for WAIT ($2c,$2d,$2e...)
	move.w	#$f507,d5	; last line = f5 (245)
	lea	cpl_mod-6(pc),a0

cop_init1:
	move.w	d0,(a0)+	; place wait num
	move.w	d1,(a0)+	; place $FFFE
	move.l	d2,(a0)+	; place BPL1MOD
	move.l	d3,(a0)+	; place BPL2MOD
	add.w	d4,d0		; add 1 to wait ($2c,$2d,$2e...)
	cmp.w	d5,d0		; last line?
	blo.b	cop_init1

	lea	col1,a0		; color tab
	lea	colcop,a1	; colors in coplist
	moveq	#15,d0		; num of colours -1 (now 16 colours)

cop_init2:
	move.w	(a0)+,(a1)	; place colour RGB value
	addq.l	#4,a1		; next colreg in coplist
	dbf	d0,cop_init2

	move.l	#COPPERLIST,$80(a5)	; point cop
	move.w	#0,$88(a5)	; start cop
	move.w	#0,$1fc(a5)	; start cop
	move.w	#$c00,$106(a5)	; start cop
	move.w	#$11,$10c(a5)	; start cop

	move.l	#planes1,planepointer1
	move.l	#planes2,planepointer2
	clr.w	bildnr

	move.l	planepointer1(pc),d0	; planes1 addr in d0
	lea	planep,a0
	moveq	#3,d1		; num of planes -1 (now 4 planes 16 colors)
planepoint:
	move.w	d0,2(a0)
	swap	d0
	move.w	d0,6(a0)
	swap	d0
	addi.l	#40,d0		; add 1 LINE val...
	addq.l	#8,a0		; next pointers in cop
	dbra	d1,planepoint

	move.w	#$87c0,$96(a5)

	bsr.w	tabinit
	bsr.s	hauptprogramm

	move.w	#$03f0,$96(a5)

	move.w	intenaold(pc),d0
	bset	#15,d0
	move.w	d0,$9a(a5)
	move.l	graphicsbase(pc),a1
	move.l	$26(a1),$80(a5)		; point old cop
	move.w	#0,$88(a5)		; start old cop
	jsr	-414(a6)
	move.w	#$83f0,$96(a5)
error:
	jsr	-$8a(a6)
	movem.l	(SP)+,d0-d7/a0-a6
	moveq	#0,d0
	rts

intenaold:	dc.w	0

hauptprogramm:
	clr.w	bildnr

ranzoomen:
	btst.b	#10,$16(a5)	; right mouse button
	beq.w	ende
	btst	#6,$bfe001
	bne.b	ranzoomen

	move.w	bildnr(pc),d0
	move.l	planepointer1(pc),a0
	lea	160(a0),a0
	move.l	planepointer2(pc),a1
	lea	160(a1),a1
	lea	origpic,a4
	bsr.w	vergroessern
	bsr.b	umschalten
	addq.w	#1,bildnr
	cmpi.w	#160,bildnr
	blt.b	ranzoomen

	subq.w	#1,bildnr

	move.l	#$20000,d0;

verz:				;wait quando e' tutta grande
	subq.l	#1,d0
	bne.b	verz

wegzoomen:
	btst	#10,$16(a5)	; right mouse button
	beq.b	ende
	btst	#6,$bfe001
	bne.b	wegzoomen

	move.w	bildnr(pc),d0
	move.l	planepointer1(pc),a0
	lea	160(a0),a0
	move.l	planepointer2(pc),a1
	lea	160(a1),a1
	bsr.w	verkleinern
	bsr.b	umschalten
	subq.w	#1,bildnr
	bpl.b	wegzoomen
	bra.w	hauptprogramm

ende:
	rts

bildnr:		dc.w	0

****************************************************************************

umschalten:
	move.l	planepointer1(pc),d0
	move.l	planepointer2(pc),d1
	exg	d0,d1
	move.l	d0,planepointer1
	move.l	d1,planepointer2

waitrast:
	MOVE.L	4(A5),D1	; $DFF004
	LSR.L	#8,D1
	ANDI.W	#%111111111,D1	; Select only the VPOS bits
	CMPI.W	#246,D1		; wait line num
	blo.b	waitrast

				; planepointer in d0
	lea	planep,a0
	moveq	#3,d1		; num of planes -1 (now 4 planes 16 colors)
planepoint2:
	move.w	d0,2(a0)
	swap	d0
	move.w	d0,6(a0)
	swap	d0
	addi.l	#40,d0		; add 1 LINE val...
	addq.l	#8,a0		; next pointers in cop
	dbra	d1,planepoint2

	move.l	#cpl_mod,d0

	btst.b	#6,2(a5)	; end of blit work
waitblit1:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit1

	move.l	d0,$54(a5)		;bltdpt
	move.w	#-40,$74(a5)		;bltadat
	move.w	#10,$66(a5)		;bltdmod
	move.l	#$ffffffff,$44(a5)	;mask
	move.l	#$01f00000,$40(a5)	;bltcon0, bltcon1
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#$3241,$58(a5)		;bltsize

	move.w	bildnr(pc),d1
	add.w	d1,d1
	add.w	d1,d1
	lea	modtabzeiger(pc),a0
	move.l	(a0,d1.w),a0

	move.w	(a0)+,d1		;offset
	move.w	(a0)+,d2		;anzahl = blt-height
	beq.b	um_next

	lsl.w	#6,d2
	addq.w	#1,d2			;bltsize

	ext.l	d1
	add.l	d0,d1			;startadresse.

	btst.b	#6,2(a5)	; end of blit work
waitblit2:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit2

	move.l	a0,$50(a5)		;bltapt
	move.l	d1,$54(a5)		;bltdpt
	move.w	#$09f0,$40(a5)		;bltcon0
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#0,$64(a5)		;bltamod
	move.w	d2,$58(a5)		;bltsize

um_next:
	btst.b	#6,2(a5)	; end of blit work
waitblit3:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit3

	move.l	d0,$50(a5)		;bltapt
	addq.l	#4,d0
	move.l	d0,$54(a5)		;bltdpt
	move.w	#10,$64(a5)		;bltamod
	move.w	#$09f0,$40(a5)		;bltcon0
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#$3241,$58(a5)		;bltsize

	btst.b	#6,2(a5)	; end of blit work
waitblit4:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit4

	rts

**********************************************************************
;			 TABS INIT
**********************************************************************

tabinit:
	lea	zeilentab(pc),a0
	lea	bittab(pc),a1

	moveq	#15,d0		;

ti_loop1:
	lea	worttab(pc),a2
	move.w	(a1)+,d1
	move.w	#9,d2

ti_loop2:
	move.w	(a2)+,d3
	asl.w	#4,d3
	add.w	d1,d3
	move.w	d3,(a0)+
	dbf	d2,ti_loop2

	dbf	d0,ti_loop1

	lea	arbeitstab(pc),a0
	move.w	#159,d0
	move.w	#2000,d1

ti_loop3:
	move.w	d1,(a0)+
	dbf	d0,ti_loop3

	lea	zeilentab(pc),a0
	lea	einftab(pc),a1
	lea	arbeitstab(pc),a2
	clr.w	d0

ti_loop4:
	move.w	(a0,d0.w),d1
	moveq	#-2,d2

ti_loop5:
	addq.w	#2,d2
	cmp.w	(a2,d2.w),d1
	bgt.b	ti_loop5

	lea	318(a2),a3
	lea	(a2,d2.w),a4

ti_loop6:
	move.w	-(a3),2(a3)
	cmpa.l	a4,a3
	bhi.b	ti_loop6

	move.w	d1,(a4)

	lsr.w	#1,d2
	move.w	d2,(a1)+
	addq.w	#2,d0
	cmp.w	#160*2,d0
	blo.b	ti_loop4

	lea	vielfachentab(pc),a2
	clr.w	(a2)+

	move.w	#120,d0
	move.w	#160,d1
	move.w	#200,d2

ti_loop10:
	move.w	d0,(a2)+
	add.w	d1,d0
	dbf	d2,ti_loop10

;modulotabelle aufbauen

	lea	modulotab(pc),a0
	lea	modtabzeiger(pc),a1
	lea	vielfachentab(pc),a2
	moveq	#1,d7			;n = breite /2

	move.l	a0,(a1)+		;offset auf daten in modtab für
	clr.l	(a0)+			;bildnr. 0 (nichts sichtbar)

ti_loop9:
	move.l	a0,(a1)+		;offset auf daten in modtab für
					;jeweilige bildnr.
	moveq	#0,d6			;register für coplistoffsets

	move.w	d7,d0			;n
	move.w	d7,d2
	mulu	#$a000,d0
	move.l	#$640000,d1
	sub.l	d0,d1
	swap	d1			;= erste zeile, in der modulos
					;aus tab geschrieben werden
	add.w	d1,d1
	add.w	d1,d1			;4*
	add.w	d1,d6			;+
	add.w	d1,d1			;8*
	add.w	d1,d6			;=12* (da move mod1; mod2; wait =
					;(3 copperbefehle)
	add.l	d0,d0
	swap	d0			;= 2n* 200/320 = höhe

	move.l	#$a000,d1
	divu	d2,d1
	swap	d1
	clr.w	d1
	lsr.l	#8,d1			;$a000/n * $100  als $10000er-bruch

	moveq	#0,d2
	moveq	#0,d4

;in d0: anzahl (eigentlich anzahl-1 wegen zeile 0) -> schleifenvar.
;in d1: zähler zum aufaddieren
;d2: aufaddierungsregister
;d3:
;d4: jeweils letzte zeile
;d6: coplistoffset
;a0: modtab
;a1: modzeiger
;a2: vielfachentab

	move.w	d6,(a0)+		;coplistoffset schreiben
	move.w	d0,(a0)+		;anzahl-1 schreiben
	addq.w	#1,-2(a0)		;+1 = anzahl (bltsize-höhe)

	bra.b	ti_loop7

ti_loop8:
	add.l	d1,d2			;zähler aufaddieren
	swap	d2			;= i-te zeile
	move.w	d2,d3			;darzustellende origzeile

	sub.w	d4,d3			;- letzte origzeile = zeilendifferenz
	add.w	d3,d3			;*2 = vielfachenoffset

;	move.w	d3,(a0)+
	move.w	(a2,d3.w),(a0)+		;mod aus vftab nach modtab schreiben
	move.w	d2,d4
	swap	d2

ti_loop7:
	dbf	d0,ti_loop8

	move.w	#201,d3			;von letzter zeile (d4) auf orgzeile 201
	sub.w	d4,d3			;zeilendifferenz
	add.w	d3,d3
	move.w	(a2,d3.w),(a0)+
;	move.w	d3,(a0)+
	addq.w	#1,d7
	cmp.w	#160,d7
	bls.b	ti_loop9
	rts

****************************************************************************
verkleinern:
****************************************************************************

;a0 quellpuffer
;a1 zielpuffer
;bildnr. in d0

	lea	$dff000,a5

	add.w	d0,d0
	lea	einftab(pc),a2
	move.w	#$9f,d6
	sub.w	(a2,d0.w),d6

	move.l	a0,a2			;pufferadr. kopieren
	move.l	a1,a3

	move.w	d6,d7
	not.w	d7
	and.w	#$f,d7			;bitnr. links in   d7
	lsr.w	#4,d6			;breite-1 in w. in d6
	move.w	d6,d5
	add.w	d5,d5			;breite-2 in b. in d5

*** linker teil

	moveq	#38,d0
	sub.w	d5,d0
	move.w	d6,d1
	addi.w	#$c801,d1

	btst.b	#6,2(a5)	; end of blit work
waitblit5:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit5

	move.l	#$fffffffe,$44(a5)	;bltfwm,bltlwm (mask)
	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.w	d0,$64(a5)		;bltamod
	move.w	d0,$66(a5)		;bltdmod
	move.l	#$19f00000,$40(a5)	;bltcon0,bltcon1
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	d1,$58(a5)		;bltsize

*** linker teil rechtes wort

	adda.w	d5,a0
	adda.w	d5,a1
	clr.w	d4
	bset	d7,d4
	subq.w	#1,d4
;beq nächste blitteroperation
	moveq	#38,d2

	btst.b	#6,2(a5)	; end of blit work
waitblit6:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit6

	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.l	a1,$4c(a5)		;bltbpt
	move.w	d2,$62(a5)		;bltbmod
	move.w	d2,$64(a5)		;bltamod
	move.w	d2,$66(a5)		;bltdmod
	move.w	#$ffff,$46(a5)		;bltlwm
	move.w	d4,$70(a5)		;bltcdat
	move.w	#$0de4,$40(a5)		;bltcon0
	move.b	#$e4,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#$c801,$58(a5)		;bltsize

*** mitte

	moveq	#18,d2
	sub.w	d5,d2			;breite mitte in w.
	beq.b	vk_nextblit		;falls 0, nächste operation
	moveq	#40,d3
	sub.w	d2,d3
	sub.w	d2,d3
	addi.w	#$c800,d2
	addq.w	#2,a0
	addq.w	#2,a1

	btst.b	#6,2(a5)	; end of blit work
waitblit7:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit7

	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.w	d3,$64(a5)		;bltamod
	move.w	d3,$66(a5)		;bltdmod
	move.w	#$09f0,$40(a5)		;bltcon0
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	d2,$58(a5)		;bltsize

*** rechter teil

vk_nextblit:
	lea	$7d00-2(a2),a2
	lea	$7d00-2(a3),a3

	btst.b	#6,2(a5)	; end of blit work
waitblit7b:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit7b

	movem.l	a2/a3,$50(a5)		;bltapt,bltdpt
	move.w	#$7fff,$46(a5)		;bltlwm
	move.w	d0,$64(a5)		;bltamod
	move.w	d0,$66(a5)		;bltdmod
	move.l	#$19f00002,$40(a5)	;bltcon0,bltcon1
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	d1,$58(a5)		;bltsize

*** rechter teil linkes wort

	eori.w	#$f,d7
	addq.w	#1,d7
	clr.w	d4
	bset d7,d4
;	subq.w	#1,d7
	subq.w	#1,d4
	not.w	d4
;beq ende (==> rts)

	moveq	#38,d2
	suba.w	d5,a2
	suba.w	d5,a3

	btst.b	#6,2(a5)	; end of blit work
waitblit8:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit8

	movem.l	a2/a3,$50(a5)		;bltapt,bltdpt
	move.l	a3,$4c(a5)		;bltbpt
	move.w	d2,$62(a5)		;bltbmod
	move.w	d2,$64(a5)		;bltamod
	move.w	d2,$66(a5)		;bltdmod
	move.w	#$ffff,$46(a5)		;bltlwm
	move.w	d4,$70(a5)		;bltcdat
	move.w	#$0de4,$40(a5)		;bltcon0
	move.b	#$e4,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#$c801,$58(a5)		;bltsize
	rts

****************************************************************************
vergroessern:
****************************************************************************

;a0 quellpuffer
;a1 zielpuffer
;bildnr. in d0
;a4 zeiger auf originalbild

	lea	$dff000,a5

	lea	einftab(pc),a2
	add.w	d0,d0
	move.w	d0,-(a7)		;tabellenoffset auf stack retten
	move.w	#$9f,d6
	sub.w	(a2,d0.w),d6

	move.l	a0,a2			;pufferadr. kopieren
	move.l	a1,a3

	move.w	d6,d7
	and.w	#$f,d7			;bitpos rechts in d7
	lsr.w	#4,d6			;breite-1 in w. d6
	move.w	d6,d5
	add.w	d5,d5			;breite-2 in b. in d5

*** rechter teil

	lea	38(a0),a0
	lea	38(a1),a1
	suba.w	d5,a0			;startadr.
	suba.w	d5,a1

	moveq	#38,d0
	sub.w	d5,d0			;modulo
	move.w	d6,d1
	addi.w	#$c801,d1		;size

	btst.b	#6,2(a5)	; end of blit work
waitblit9:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit9

	move.l	#$ffffffff,$44(a5)	;fwm,lwm
	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.w	d0,$64(a5)		;bltamod
	move.w	d0,$66(a5)		;bltdmod
	move.l	#$19f00000,$40(a5)	;bltcon0,bltcon1
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	d1,$58(a5)		;bltsize

*** rechter teil linkes wort

	lea	$7d00-4(a2),a0
	lea	$7d00-2(a3),a1		;startadr.
	suba.w	d5,a0
	suba.w	d5,a1

	clr.w	d4
	addq.w	#1,d7
	bset d7,d4
	subq.w	#1,d7
	subq.w	#1,d4			;maske
	not.w	d4
;	beq	next_blit_op

	moveq	#38,d2			;modulo

	btst.b	#6,2(a5)	; end of blit work
waitblit10:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit10

	move.l	a1,$4c(a5)		;bltbpt
	move.l	a1,$50(a5)		;bltapt
	move.l	a1,$54(a5)		;bltdpt
	move.w	d2,$62(a5)		;bltbmod
	move.w	d2,$64(a5)		;bltamod
	move.w	d2,$66(a5)		;bltdmod
	move.w	d4,$70(a5)		;bltcdat
	move.l	#$1de40002,$40(a5)	;bltcon0,bltcon1
	move.b	#$e4,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#$c801,$58(a5)		;bltsize

;next_blit_op:
	subq.w	#2,a1

*** mitte

	moveq	#18,d2
	sub.w	d5,d2                     ;breite mitte in w.
	beq.b	vgr_nextblit		;falls 0, nächste operation
	moveq	#40,d3
	sub.w	d2,d3
	sub.w	d2,d3			;modulo

	btst.b	#6,2(a5)	; end of blit work
waitblit11:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit11

	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.w	d3,$64(a5)		;bltamod
	move.w	d3,$66(a5)		;bltdmod
	move.w	d2,d3
	addi.w	#$c800,d2
	move.w	#$09f0,$40(a5)		;bltcon0
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	d2,$58(a5)		;bltsize

	add.w	d3,d3
	suba.w	d3,a0
	suba.w	d3,a1

*** linker teil

vgr_nextblit:

	btst.b	#6,2(a5)	; end of blit work
waitblit12:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit12

	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.w	d0,$64(a5)		;bltamod
	move.w	d0,$66(a5)		;bltdmod
	move.w	#$19f0,$40(a5)		;bltcon0
	move.b	#$f0,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	d1,$58(a5)		;bltsize

*** linker teil rechtes wort

	lea	(a3,d5.w),a1
	moveq	#38,d2
	clr.w	d4
	eori.w	#$f,d7
	bset	d7,d4
	subq.w	#1,d4
;	beq	nextop

	btst.b	#6,2(a5)	; end of blit work
waitblit13:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit13

	move.l	a1,$4c(a5)		;bltbpt
	move.l	a1,$50(a5)		;bltapt
	move.l	a1,$54(a5)		;bltdpt
	move.w	d2,$62(a5)		;bltbmod
	move.w	d2,$64(a5)		;bltamod
	move.w	d2,$66(a5)		;bltdmod
	move.w	d4,$70(a5)		;bltcdat
	move.l	#$1de40000,$40(a5)	;bltcon0,bltcon1
	move.b	#$e4,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#$c801,$58(a5)		;bltsize

;daten, die jetzt noch benötigt werden:
;d5 (breite-2) in bytes
;a3 zielpuffer
;a4 zeiger auf originalbild
;d7 bitnummer einfügstelle links

	move.w	(a7)+,d0			;bildnr.

*** zeile links einfügen

	lea	zeilentab(pc),a2
	move.w	(a2,d0.w),d6		;origzeile zeilentab
	move.w	#$9f,d1
	sub.w	d6,d1			;origzeile $9f-zeilentab
	move.w	d1,d2
	not.w	d2
	and.w	#$f,d2			;bitpos origzeile links
	lsr.w	#4,d1
	add.w	d1,d1                     ;offset in origbild in bytes

	lea	(a4,d1.w),a0		;quelle origbild
	lea	(a3,d5.w),a1		;ziel a/d
	bsr.b	einfuegen

*** zeile rechts einfügen

	neg.w	d1
	lea	38(a4,d1.w),a0
	neg.w	d5
	lea	38(a3,d5.w),a1
	eor	#$f,d7
	eor	#$f,d2
	bsr.b	einfuegen
	rts

einfuegen:
	clr.w	d4
	bset	d7,d4

	move.w	d2,d3
	sub.w	d7,d3
	bmi.b	ef_desc

;ascending

	ror.w	#4,d3			;barrelshifter-bits positionieren
	or.w	#$0de4,d3

	btst.b	#6,2(a5)	; end of blit work
waitblit14:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit14

	movem.l	a0/a1,$50(a5)		;bltapt,bltdpt
	move.l	a1,$4c(a5)		;bltbpt
	move.w	d3,$40(a5)		;bltcon0
	move.b	d3,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#0,$42(a5)		;bltcon1
	move.w	d4,$70(a5)		;bltcdat
	move.w	#$c801,$58(a5)		;bltsize
	rts

ef_desc:
	neg.w	d3
	ror.w	#4,d3
	or.w	#$0de4,d3

	lea	799*40(a0),a0
	lea	799*40(a1),a1

	btst.b	#6,2(a5)	; end of blit work
waitblit15:
	btst.b	#6,2(a5)	; end of blit work
	bne.b	waitblit15

	movem.l	a0/a1,$50(a5)			;bltapt, bltdpt
	move.l	a1,$4c(a5)			;bltbpt
	move.w	d3,$40(a5)			;bltcon0
	move.b	d3,$5b(a5)		; bltcon0l ECS faster minterms
	move.w	#2,$42(a5)			;bltcon1
	move.w	d4,$70(a5)			;bltcdat
	move.w	#$c801,$58(a5)			;bltsize
	rts

zeilentab:	dcb.w	160,0
einftab: 	dcb.w	160,0
arbeitstab:	dcb.w	160,0
worttab:	dc.w	0,5,7,3,9,1,6,4,8,2
bittab:		dc.w	8,12,4,14,2,10,6,15,0,3,13,5,11,9,7,1
grname:		dc.b	"graphics.library",0
		even
graphicsbase:	dc.l	0

COPPERLIST:
	dc.w	$8e,$2c81	; diwstart
	dc.w	$90,$f5c1	; diwstop
	dc.w	$92,$0038	; ddfstrt
	dc.w	$94,$00d0	; ddfstop
	dc.w	$100,%0100001000000000	; 16 colors
	dc.w	$102,$000

planep:
	dc.w	$e2,0,$e0,0,$e6,0,$e4,0,$ea,0,$e8,0,$ee,0,$ec,0
	dc.w	0,0,0

cpl_mod:			; bplmod + and -
	dcb.b	6,0
	dcb.b	200*12

	dc.w	$1fc,0		; RESETS AGA BURTS
	dc.w	$106,$c00	; RESET AGA
	dc.w	$10c,$11	; RESET AGA
colcop:

	dc.w $0180,$0,$0182,$0,$0184,$0,$0186,$0
	dc.w $0188,$0,$018a,$0,$018c,$0,$018e,$0
	dc.w $0190,$0,$0192,$0,$0194,$0,$0196,$0
	dc.w $0198,$0,$019a,$0,$019c,$0,$019e,$0
	dc.w $01a0,$0,$01a2,$0,$01a4,$0,$01a6,$0
	dc.w $01a8,$0,$01aa,$0,$01ac,$0,$01ae,$0
	dc.w $01b0,$0,$01b2,$0,$01b4,$0,$01b6,$0
	dc.w $01b8,$0,$01ba,$0,$01bc,$0,$01be,$0

	dc.w	$ffff,$fffe
	dc.w	$ffff,$fffe

planepointer1:	dc.l	planes1
planepointer2:	dc.l	planes2


vielfachentab:	dcb.w	202,0
modtabzeiger:	dcb.l	161,0
modulotab:	dcb.b	33044		;format dc.w coplistoffset, anzahl,
                           		;wert1, wert2, ...
planes1:	dcb.b	32320,0		;same length of PIC
planes2:	dcb.b	32320,0		;same length of PIC

origpic:	;incbin	"hd1:zoom1.raw"
	incbin	"testpic.raw"	; this is the PIC!

col1:
					; colors tab
		dc.w	$042
		dc.w	$000
		dc.w	$bbb
		dc.w	$fff
	
		dc.w	$b3b
		dc.w	$ee0
		dc.w	$a95
		dc.w	$a43
	
		dc.w	$f60
		dc.w	$fa8
		dc.w	$fc0
		dc.w	$080

		dc.w	$0d0
		dc.w	$dff
		dc.w	$adf
		dc.w	$00a

