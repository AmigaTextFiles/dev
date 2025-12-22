
	IFND TEXTURE_I
TEXTURE_I	SET	1

;------------------------------------------------------------------------------

	STRUCTURE	texture_engine,0

		STRUCT	txt_engine,eng_SIZEOF	; Engine-Header


		APTR	txt_memhandler

		
		;	flächendaten (von createscaleengine):

		WORD	txt_topmostpoint	; y oberster Polygonpunkt
		WORD	txt_botmostpoint	; y unterster Polygonpunkt

		UWORD	txt_totalsourcewidth2	; gesamtbreite 2^n
		UWORD	txt_pad

		APTR	txt_sourcetab		; source-Floatpoint-x/y-Table
						; 16*höhe der textur (dc.l xl/yl/xr/yr)
		APTR	txt_desttab		; screen-dest-x/y-Table
						; 4*effektive höhe des trapezes (dc.w xl/xr)

		STRUCT	txt_coordinates,2*8	; Koordinaten a,b,c,d

		STRUCT	txt_indextab,16		; zwei Tabllen, je für links+rechts
		STRUCT	txt_anzahltab,16	; korrespondiert zu indextab

		STRUCT	txt_rectcoord,16	; Source-Koordinaten auf der Textur

		APTR	txt_func		; Subfunktion


		;	zeilendaten (laufzeit):

		UWORD	txt_line		; aktuelle Zeile
		UWORD	txt_height		; gesamthöhe des Trapezes
		UWORD	txt_firstdrawline	; erste zu zeichnende Zeile (-1 gar nicht)
		UWORD	txt_lastdrawline	; letzte zu zeichnende Zeile
		APTR	txt_sourcetabptr
		APTR	txt_desttabptr

	LABEL		txt_SIZEOF


;--------------------------------------------------------------------
;
;		Init_DrawTexture
;
;	>	a5	Conv-Struktur
;			s, d, sx, sy, dx, dy, width, height, tdwidth
;			engine
;	<	a0	Source
;		a1	Dest
;
;--------------------------------------------------------------------

Init_DrawTexture:

		movem.l	a2-a4/a6/d0-d7,-(a7)

		move.l	(conv_engine,a5),a6

		move.w	(eng_pixelformat,a6),d6


		;	Subroutine ausfindig machen


		moveq	#0,d0
		move.w	(conv_totalsourcewidth,a5),d0


		;	2^n für Breite finden
		
		moveq	#0,d1
		moveq	#15,d2
		bset	d2,d1
.find2nlop	subq.w	#1,d2
		lsr.w	#1,d1
		cmp.w	d1,d0
		blt.b	.find2nlop
		move.w	d2,(txt_totalsourcewidth2,a6)

		moveq	#1,d1
		lsl.w	d2,d1
		cmp.w	d1,d0
		beq.b	.draw_2n


.drawx		lea	(func_drawx_8,pc),a0
		lea	(func_drawx_24,pc),a1
		bra.b	.cont

.draw_2n	lea	(func_draw2n_8,pc),a0
		lea	(func_draw2n_24,pc),a1
		
		move.w	(conv_totalsourcewidth,a5),d0
		mulu.w	(eng_sourceheight,a6),d0
		cmp.l	#$10000,d0
		bge.b	.cont
	
	;	lea	(func_draw256_8,pc),a0
	;	lea	(func_draw2n_24small,pc),a1
	;	cmp.w	#256,(conv_totalsourcewidth,a5)
	;	beq.b	.cont
		
		lea	(func_draw2n_8small,pc),a0
		lea	(func_draw2n_24small,pc),a1
	;	bra.b	.cont

.cont		cmp.w	#PIXFMT_CHUNKY_CLUT,d6
		beq.b	.pixfmtok
		move.l	a1,a0
.pixfmtok	move.l	a0,(txt_func,a6)


		lea	(Func_DrawTextureLine,pc),a1
		move.l	a1,(conv_func,a5)

		lea	(Func_Texture_Close,pc),a1
		move.l	a1,(conv_closefunc,a5)		



		move.w	#-1,(txt_firstdrawline,a6)
		clr.w	(txt_line,a6)

		move.l	(txt_sourcetab,a6),a2
		move.l	(txt_desttab,a6),a4


		; clipping

		move.w	(txt_botmostpoint,a6),d1	; untersten Polypunkt holen
		blt.b	.raus				; wenn kleiner 0, raus

		move.w	(txt_topmostpoint,a6),d0	; obersten Polypunkt holen
		ext.l	d0

		move.w	(conv_height,a5),d2
		cmp.w	d2,d0			; oberster Punkt > scrheight?
		bge.b	.raus			; wenn größer screenhöhe, raus

		tst.w	d0			; oberster Punkt >= 0 ?
		bge.b	.clpcont		; ok, kein Clipping oben

		asl.l	#2,d0			; Desttab (4 Byte / Eintrag)
		sub.l	d0,a4			; auf erste sichtbare Zeile
		asl.l	#2,d0			; Sourcetab (16 Byte / Eintrag)
		sub.l	d0,a2			; auf erste sichtbare Zeile
		moveq	#0,d0

.clpcont	move.w	d0,(txt_firstdrawline,a6)
		move.l	a2,(txt_sourcetabptr,a6)
		move.l	a4,(txt_desttabptr,a6)

.raus

		;	Start Source/Dest berechnen

		moveq	#0,d2
		move.w	(conv_totalsourcewidth,a5),d2

		moveq	#0,d1				; Source = Texturmitte
		move.w	(eng_sourcewidth,a6),d1
		moveq	#0,d0
		move.w	(eng_sourceheight,a6),d0
		lsr.w	#1,d0
		mulu.l	d2,d0
		lsr.w	#1,d1
		add.l	d1,d0
		move.w	(conv_sourcey,a5),d1
		mulu.l	d2,d1
		add.l	d1,d0
		moveq	#0,d1
		move.w	(conv_sourcex,a5),d1
		add.l	d1,d0
		cmp.w	#PIXFMT_CHUNKY_CLUT,d6
		beq.b	.sourceok
		lsl.l	#2,d0
.sourceok	lea	([conv_source,a5],d0.l),a0

		
		move.w	(conv_totaldestwidth,a5),d2
		moveq	#0,d0
		move.w	(conv_desty,a5),d0
		mulu.l	d2,d0
		moveq	#0,d1
		move.w	(conv_destx,a5),d1
		add.l	d1,d0
		cmp.w	#PIXFMT_CHUNKY_CLUT,d6
		beq.b	.destok
		lsl.l	#2,d0
.destok		lea	([conv_dest,a5],d0.l),a1


		movem.l	(a7)+,a2-a4/a6/d0-d7
		moveq	#-1,d0

Func_Texture_Close
		rts

;--------------------------------------------------------------------



;------------------------------------------------------------------------------

InitTextureEngine:

		bsr	.calcindextables	; Index-left/right-Tables


		clr.l	(txt_sourcetab,a5)
		clr.l	(txt_desttab,a5)


		moveq	#0,d2
		move.w	(txt_botmostpoint,a5),d2
		sub.w	(txt_topmostpoint,a5),d2
		addq.w	#1,d2
		move.w	d2,(txt_height,a5)
		tst.w	d2
		ble.b	.fail

		move.l	d2,d0
		lsl.l	#4,d0
		move.l	(txt_memhandler,a5),a0
		bsr	AllocRenderVec
		tst.l	d0
		beq.b	.fail
		move.l	d0,(txt_sourcetab,a5)
	
		move.l	d2,d0
		lsl.l	#2,d0
		move.l	(txt_memhandler,a5),a0
		bsr	AllocRenderVec
		tst.l	d0
		beq.b	.fail
		move.l	d0,(txt_desttab,a5)


		bsr	.calcdesttables		; Dest-left/right-Tables
		tst.w	d0			; Fehler?
		bne.b	.fail			; es kann nicht gezeichnet werden!



		;	Sourcekoordinaten

		lea	(txt_rectcoord,a5),a0
		move.w	(eng_sourcewidth,a5),d0
		move.w	(eng_sourceheight,a5),d1

		move.w	d0,d2
		move.w	d1,d3
		lsr.w	#1,d0
		lsr.w	#1,d1
		neg.w	d0
		neg.w	d1
		add.w	d0,d2
		add.w	d1,d3
		subq.w	#1,d2
		subq.w	#1,d3
		move.w	d0,(a0)+
		move.w	d1,(a0)+
		move.w	d2,(a0)+
		move.w	d1,(a0)+
		move.w	d2,(a0)+
		move.w	d3,(a0)+
		move.w	d0,(a0)+
		move.w	d3,(a0)+

		bsr	.calcsourcetables	; Source-left/right-Tables

		moveq	#-1,d0
		rts


.fail		move.l	(txt_sourcetab,a5),a0
		bsr	FreeRenderVec
		move.l	(txt_desttab,a5),a0
		bsr	FreeRenderVec

		moveq	#0,d0
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.calcindextables

;		Dest-Koordinaten holen, nach y sortieren,
;		größten und kleinsten Wert und deren Indizes ermitteln

		lea	(txt_coordinates,a5),a0
		lea	(txt_indextab,a5),a1

		movem.l	(a0),d0-d3	; die y-Ordinaten jetzt in d0.w-d3.w

		moveq	#0*4,d4		; Indizes (*4, weil zwei Words)
		moveq	#1*4,d5
		moveq	#2*4,d6
		moveq	#3*4,d7

		cmp.w	d0,d1		; Bubblesort mit 4 Elementen
		ble.s	.srt1		; und deren Indizes kann komplett
		exg	d0,d1		; in Registern durchgeführt werden
		exg	d4,d5
.srt1		cmp.w	d1,d2
		ble.s	.srt2
		exg	d1,d2
		exg	d5,d6
.srt2		cmp.w	d2,d3
		ble.s	.srt3
		exg	d2,d3
		exg	d6,d7

.srt3		cmp.w	d0,d1
		ble.s	.srt4
		exg	d0,d1
		exg	d4,d5
.srt4		cmp.w	d1,d2
		ble.s	.srt5
		exg	d1,d2
		exg	d5,d6

.srt5		cmp.w	d0,d1
		ble.s	.srt6
		exg	d0,d1
		exg	d4,d5

.srt6		move.w	d7,d1

		move.w	d3,(txt_topmostpoint,a5)	; obersten Punkt ablegen
		move.w	d0,(txt_botmostpoint,a5)	; untersten Punkt ablegen
	
		;	Größter Wert jetzt in d0
		;	Index des kleinsten in d1

		;	Drehsinn des Trapezes ermitteln

		movem.w	(a0),d2-d7	; 3 Koordinaten holen
		sub.w	d2,d4		; und Vektorprodukt bilden
		sub.w	d3,d5
		sub.w	d2,d6
		sub.w	d3,d7
		muls.w	d4,d7
		muls.w	d5,d6

		moveq	#4,d5		; linksdrehend: +4 links, -4 rechts

		sub.l	d6,d7
		bmi.s	.turnsleft

		moveq	#-4,d5		; rechtsdrehend: -4 links, +4 rechts

.turnsleft	;	jetzt Polygon-Indextables für links/rechts ermitteln

		moveq	#12,d6
		move.w	d1,d7			; Ausgangspunkt m merken
		bsr.b	.calcindices		; Indextabelle links berechnen
		move.w	d7,d1			; Ausgangspunkt m wieder holen
		neg.w	d5			; Bewegungsrichtung umkehren

.calcindices	move.w	d1,d2			; d1: Index Ausgangspunkt
		add.w	d5,d2			; d5: Delta-Index (+/- 4)
		and.w	d6,d2			; d6: 12
		move.w	2(a0,d2.w),d4		; b=y(n)
		cmp.w	d4,d0			; b=ende?
		beq.b	.indx1			; Fälle 1 und 3
		cmp.w	2(a0,d1.w),d4		; b=y(m)?
		bne.b	.indx2			; Fälle 2, 6 und 7
		move.w	d2,(a1)+		; n eintragen
		add.w	d5,d2
		and.w	d6,d2			; n=n+1
		move.w	d2,(a1)+		; n eintragen
		cmp.w	2(a0,d2.w),d0		; y(n)=ende?
		beq.b	.indxend		; Fälle 4 und 8
		add.w	d5,d2			; Fall 5
		and.w	d6,d2			; n=n+1
		bra.b	.indx3
.indx2		move.w	d1,(a1)+		; m eintragen
		move.w	d2,(a1)+		; n eintragen
		add.w	d5,d2
		and.w	d6,d2			; n=n+1			
		cmp.w	2(a0,d2.w),d0		; y(n)=ende?
		beq.b	.indx3			; Fälle 2 und 6
		move.w	d2,d1			; Fall 7
		add.w	d5,d2
		and.w	d6,d2			; n=n+1
.indx1		move.w	d1,(a1)+		; m eintragen
.indx3		move.w	d2,(a1)+		; n eintragen
.indxend	move.w	#-1,(a1)+		; Endmarke eintragen
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.calcdesttables					; Dest-Tables berechnen

		lea	(txt_indextab,a5),a0	; Index-Table
		lea	(txt_coordinates,a5),a1	; Dest-Koordinaten
		lea	(txt_anzahltab,a5),a3	; Anzahl-Borderdelta-Tabelle
		move.l	(txt_desttab,a5),a4	; Dest-Left

		move.l	a4,a2
		bsr.b	.calcdtab		; linke Seite berechnen

		tst.w	d0			; Fehler aufgetreten?
		bne.b	.raus

		lea	2(a4),a2		; Dest-Right

.calcdtab	move.w	(a0)+,d0		; Punkt-Index Ursprung
		move.l	(a1,d0.w),d1		; x/y Ursprung holen
	
.cdlop		move.w	(a0)+,d2		; Punkt-Index Ziel
		bmi.b	.cdend			; Endmarke erreicht

		move.l	(a1,d2.w),d3		; x/y Ziel holen

		move.w	d2,d4			; Ziel-Punktindex merken
		move.l	d3,d5			; Ziel-X/Y merken

		move.l	d1,d0
		swap	d0			; d0/d1: x/y Ursprung

		move.l	d3,d2
		swap	d2			; d2/d3: x/y Ziel

		sub.w	d0,d2			; Differenzen x/y bilden
		sub.w	d1,d3
	;	beq.b	.cdtfail


		move.w	d3,(a3)+		; Anzahl in Anzahltab eintragen

	tst.w	d3
	beq.b	.cdskip	;!!!
		
		swap	d0			; FFLP von Ursprung-X bilden
		clr.w	d0

		ext.l	d3
		swap	d2
		clr.w	d2
		divs.l	d3,d2

		; jetzt:	d0		FFLP von Ursprung-X
		;		d1		Ursprung-Y
		;		d2		FFLP von Delta-X
		;		d3		Anzahl-Y

		subq.w	#1,d3

.cdlop2		swap	d0
		move.w	d0,(a2)			; x ablegen
		addq.w	#4,a2
		swap	d0
		add.l	d2,d0
		dbf	d3,.cdlop2
.cdskip
		move.w	d4,d0			; Ziel-Index -> Ursprung-Index
		move.l	d5,d1			; x/y Ziel -> x/y Ursprung

		bra.b	.cdlop

.cdend		swap	d1
		move.w	d1,(a2)			; last-x

		moveq	#0,d0
.raus		rts

.cdtfail	moveq	#-1,d0			; FAIL!!!
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.calcsourcetables				; Source-Tables berechnen

		lea	(txt_anzahltab,a5),a3	; Anzahl-Borderdelta-Table
		lea	(txt_indextab,a5),a0	; a0: Index-Table

		lea	(txt_rectcoord,a5),a1	; Source-Koordinaten

		move.l	(txt_sourcetab,a5),a4
		move.l	a4,a2

		bsr.b	.calcstab		; linke Seite berechnen

		lea	8(a4),a2		; rechte Seite berechnen

.calcstab	move.w	(a0)+,d0		; Punkt-Index Ursprung
		move.l	(a1,d0.w),d1		; x/y Ursprung holen
	
.cslop		move.w	(a0)+,d2		; Punkt-Index Ziel
		bmi.b	.csend			; Endmarke erreicht

		move.l	(a1,d2.w),d3		; x/y Ziel holen

		move.w	d2,d5			; Ziel-Punktindex merken
		move.l	d3,d6			; Ziel-X/Y merken

		move.l	d1,d0
		swap	d0			; d0/d1: x/y Ursprung

		move.l	d3,d2
		swap	d2			; d2/d3: x/y Ziel

		sub.w	d0,d2			; Differenzen x/y bilden
		sub.w	d1,d3

		swap	d0			; FFLP von Ursprung-X bilden
		clr.w	d0
		swap	d1			; FFLP von Ursprung-Y bilden
		clr.w	d1

		move.w	(a3)+,d4		; Qutiont/Zähler aus Anzahltab
	beq.b	.csskip

		ext.l	d4

		swap	d2
		clr.w	d2
		divs.l	d4,d2

		swap	d3
		clr.w	d3
		divs.l	d4,d3
		

		; jetzt:	d0		FFLP von Ursprung-X
		;		d1		FFLP von Ursprung-Y
		;		d2		FFLP von Delta-X
		;		d3		FFLP von Delta-Y

		subq.w	#1,d4

.cslop2		move.l	d0,(a2)+		; Border-X ablegen
		add.l	d2,d0
		move.l	d1,(a2)+		; Border-Y ablegen
		addq.w	#8,a2
		add.l	d3,d1
		dbf	d4,.cslop2

.csskip

		move.w	d5,d0			; Ziel-Index -> Ursprung-Index
		move.l	d6,d1			; x/y Ziel -> x/y Ursprung

		bra.b	.cslop

.csend		move.l	d1,d0
		clr.w	d0
		swap	d1
		clr.w	d1
		move.l	d0,(a2)+		; last x
		move.l	d1,(a2)+		; last y

		rts

;------------------------------------------------------------------------------


;==============================================================================


;------------------------------------------------------------------------------
;
;	func_drawtextureline
;
;	>	a0	sourcebuffer (textur)
;		a1	destbuffer
;		a5	convdata
;	<	d0	source-offset
;		d1	dest-offset
;
;------------------------------------------------------------------------------

		cnop	0,16

Func_DrawTextureLine

		movem.l	a1-a4/a6/d2-d7,-(a7)

		move.l	(conv_engine,a5),a6


		move.w	(txt_firstdrawline,a6),d1
		bmi	.drend

		move.w	(txt_line,a6),d0
		cmp.w	d1,d0
		blt	.drend

		move.w	(txt_topmostpoint,a6),d1
		add.w	(txt_height,a6),d1

		cmp.w	d1,d0
		bge.b	.drend


		move.l	(txt_desttabptr,a6),a2
		move.l	(a2)+,d0			; dest xanfang / xende
		move.l	a2,(txt_desttabptr,a6)

		move.l	(txt_sourcetabptr,a6),a2
		movem.l	(a2)+,d2-d5			; ffp x/y anfang / ende
		move.l	a2,(txt_sourcetabptr,a6)


		move.l	d0,d1				; d1: endx
		swap	d0				; d0: startx
		move.w	d1,d7				; endx
		blt.b	.drend				; kleiner 0 - nicht zeichnen

		move.w	(conv_width,a5),d6		; zeichenbreite
		cmp.w	d6,d0				; startx größer zeichenbreite?
		bge.b	.drend				; dann nicht zeichnen
	
		sub.w	d0,d1				; breite
		ble.b	.drend				; kleiner gleich null - nicht zeichnen

		sub.l	d2,d4				; d4: X-Differenz (FLP)
		sub.l	d3,d5				; d5: Y-Differenz (FLP)

		ext.l	d1

	IFEQ    USEFPU

		divs.l	d1,d4				; Deltas bilden
	;;		beq.b	.drend		;!!!
		
		divs.l	d1,d5
	;;		beq.b	.drend		;!!!

	ELSE
		fmove.l	d4,fp4
		fdiv.l	d1,fp4
		fmove.l	fp4,d4
	;;		beq.b	.drend		;!!!
		fmove.l	d5,fp5
		fdiv.l	d1,fp5
		fmove.l	fp5,d5
	;;		beq.b	.drend		;!!!

	ENDC


		cmp.w	d6,d7
		blt.b	.cl1

		sub.w	d6,d7				; rechten rand clippen
		sub.w	d7,d1


.cl1		tst.w	d0
		bge.b	.cl2

		add.w	d0,d1				; linken rand clippen
		neg.w	d0

		move.w	d0,d6
		ext.l	d6
		muls.l	d4,d6
		add.l	d6,d2

		ext.l	d0
		muls.l	d5,d0
		add.l	d0,d3

		moveq	#0,d0


.cl2		tst.w	d1
		ble.b	.drend


		jsr	([txt_func,a6])


.drend		addq.w	#1,(txt_line,a6)		; y+1
		

		moveq	#0,d0				; source bleibt
		moveq	#0,d1
		move.w	(conv_totaldestwidth,a5),d1	; dest eine Zeile weiter

		move.w	(eng_pixelformat,a6),d2
		cmp.w	#PIXFMT_CHUNKY_CLUT,d2
		beq.b	.ok
		lsl.l	#2,d1		
.ok
		movem.l	(a7)+,a1-a4/a6/d2-d7
		rts


;------------------------------------------------------------------------------
;
;		func_drawx_8
;		func_drawx_24
;
;		Breite beliebig, großer Adreßraum
;
;------------------------------------------------------------------------------

		cnop	0,16

func_drawx_8	add.w	d0,a1
		
		move.w	(conv_totalsourcewidth,a5),d7

.lop	
		move.l	d3,d0
		swap	d0
		muls.w	d7,d0
		move.l	d2,d6
		swap	d6
		add.l	d5,d3
		ext.l	d6
		add.l	d4,d2
		add.l	d6,d0
		move.b	(a0,d0.l),(a1)+

		subq.w	#1,d1
		bne.b	.lop

		rts


		cnop	0,16

func_drawx_24	add.w	d0,a1
		add.w	d0,a1
		add.w	d0,a1
		add.w	d0,a1

		move.w	(conv_totalsourcewidth,a5),d7
	
.lop
		move.l	d3,d0
		swap	d0
		muls.w	d7,d0
		move.l	d2,d6
		swap	d6
		add.l	d5,d3
		ext.l	d6
		add.l	d4,d2
		add.l	d6,d0
		move.l	(a0,d0.l*4),(a1)+

		subq.w	#1,d1
		bne.b	.lop

		rts


;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
;
;		func_draw2n_8
;		func_draw2n_24
;
;		Breite 2^n, großer Adreßraum
;
;------------------------------------------------------------------------------

		cnop	0,16

func_draw2n_8
		add.w	d0,a1			; dest

		move.w	(txt_totalsourcewidth2,a6),d0

		asr.l	#8,d2
		asr.l	#8,d4
		
		asr.l	#8,d3
		asr.l	#8,d5
		asl.l	d0,d3
		asl.l	d0,d5

		moveq	#-1,d7		; Maske
		lsl.l	d0,d7			; $ffffff00
		swap	d7			; $ff00ffff
		clr.w	d7			; $ff000000
		asr.l	#8,d7			; $ffff0000

.drloop2n1l	move.l	d3,d0		; y	$--YYYYyy
		and.l	d7,d0		;       $--YY0000
		add.l	d5,d3
		add.l	d2,d0		; x	$--YYXXxx
		asr.l	#8,d0		;	$----YYXX
		add.l	d4,d2
		move.b	(a0,d0.l),(a1)+

		subq.w	#1,d1
		bne.b	.drloop2n1l

		rts


		cnop	0,16


func_draw2n_24
		add.w	d0,a1			; dest
		add.w	d0,a1
		add.w	d0,a1
		add.w	d0,a1

		move.w	(txt_totalsourcewidth2,a6),d0

		asr.l	#8,d2
		asr.l	#8,d4
		
		asr.l	#8,d3
		asr.l	#8,d5
		asl.l	d0,d3
		asl.l	d0,d5

		moveq	#-1,d7		; Maske
		lsl.l	d0,d7			; $ffffff00
		swap	d7			; $ff00ffff
		clr.w	d7			; $ff000000
		asr.l	#8,d7			; $ffff0000

.drloop2n1l	move.l	d3,d0		; y	$--YYYYyy
		and.l	d7,d0		;       $--YY0000
		add.l	d5,d3
		add.l	d2,d0		; x	$--YYXXxx
		asr.l	#8,d0		;	$----YYXX
		add.l	d4,d2
		move.l	(a0,d0.l*4),(a1)+

		subq.w	#1,d1
		bne.b	.drloop2n1l

		rts

;------------------------------------------------------------------------------
;
;		func_draw2n_8small
;		func_draw2n_24small
;
;		Breite 2^n, kleiner Adreßraum
;
;------------------------------------------------------------------------------

		cnop	0,4

func_draw2n_8small
		add.w	d0,a1			; dest

		move.w	(txt_totalsourcewidth2,a6),d0

		asl.l	d0,d3			; start
		asl.l	d0,d5			; modulo

		moveq	#-1,d7			; Maske
		lsl.l	d0,d7
		swap	d7
		clr.w	d7
		move.l	d7,a3

		move.w	d1,d6
		lsr.w	#2,d6
		move.w	d6,a4			; 4er durchläufe
		and.w	#3,d1
		beq.b	.no2n1


.drloop2n1	move.l	d3,d0
		and.l	d7,d0
		add.l	d5,d3
		add.l	d2,d0
		swap	d0
		add.l	d4,d2
		move.b	(a0,d0.w),(a1)+

		subq.w	#1,d1
		bne.b	.drloop2n1

.no2n1		move.w	a4,d0
		beq.b	.raus

		move.l	d3,d0

.drloop2n4	move.l	a3,d7

		and.l	d7,d0
		add.l	d5,d3
		add.l	d2,d0
		move.l	d3,d1
		swap	d0
		and.l	d7,d1
		add.l	d4,d2
		move.b	(a0,d0.w),d0

		add.l	d5,d3
		add.l	d2,d1
		move.l	d3,d6
		swap	d1
		and.l	d7,d6
		add.l	d4,d2
		move.b	(a0,d1.w),d1
	
		add.l	d5,d3
		add.l	d2,d6
		and.l	d3,d7
		swap	d6
		add.l	d4,d2
		add.l	d2,d7
		move.b	(a0,d6.w),d6

		swap	d7
		move.b	(a0,d7.w),d7

		add.l	d5,d3
		move.b	d0,(a1)+
		add.l	d4,d2
		move.b	d1,(a1)+
		move.l	d3,d0
		move.b	d6,(a1)+
		subq.w	#1,a4
		move.b	d7,(a1)+
			
		move.w	a4,d1
		bne.b	.drloop2n4

.raus		rts


func_draw2n_24small
		add.w	d0,a1			; dest
		add.w	d0,a1			; dest
		add.w	d0,a1			; dest
		add.w	d0,a1			; dest

		move.w	(txt_totalsourcewidth2,a6),d0

		asl.l	d0,d3			; start
		asl.l	d0,d5			; modulo

		moveq	#-1,d7			; Maske
		lsl.l	d0,d7
		swap	d7
		clr.w	d7
		move.l	d7,a3

		move.w	d1,d6
		lsr.w	#2,d6
		move.w	d6,a4			; 4er durchläufe
		and.w	#3,d1
		beq.b	.no2n1


.drloop2n1	move.l	d3,d0
		and.l	d7,d0
		add.l	d5,d3
		add.l	d2,d0
		swap	d0
		add.l	d4,d2
		move.l	(a0,d0.w*4),(a1)+

		subq.w	#1,d1
		bne.b	.drloop2n1

.no2n1		move.w	a4,d0
		beq.b	.raus

		move.l	d3,d0

.drloop2n4	move.l	a3,d7

		and.l	d7,d0
		add.l	d5,d3
		add.l	d2,d0
		move.l	d3,d1
		swap	d0
		and.l	d7,d1
		add.l	d4,d2
		move.l	(a0,d0.w*4),d0

		add.l	d5,d3
		add.l	d2,d1
		move.l	d3,d6
		swap	d1
		and.l	d7,d6
		add.l	d4,d2
		move.l	(a0,d1.w*4),d1
	
		add.l	d5,d3
		add.l	d2,d6
		and.l	d3,d7
		swap	d6
		add.l	d4,d2
		add.l	d2,d7
		move.l	(a0,d6.w*4),d6

		swap	d7
		move.l	(a0,d7.w*4),d7

		add.l	d5,d3
		move.l	d0,(a1)+
		add.l	d4,d2
		move.l	d1,(a1)+
		move.l	d3,d0
		move.l	d6,(a1)+
		subq.w	#1,a4
		move.l	d7,(a1)+
			
		move.w	a4,d1
		bne.b	.drloop2n4

.raus		rts

;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
;
;		func_draw256_8
;		func_draw256_24
;
;		Breite 2^n, großer Adreßraum
;
;------------------------------------------------------------------------------

		cnop	0,16

func_draw256_8
		add.w	d0,a1			; dest

		move.w	(txt_totalsourcewidth2,a6),d0

		asl.l	#8,d3	;	akt-Y	$YYyyyy..
		move.w	d2,d3	;	akt-Xlo	$YYyyxxxx
		swap	d3	;		$xx..YYyy
		swap	d2	;	akt-Xhi	$....XXXX

		asl.l	#8,d5	;	delta-Y	$YYyyyy..
		move.w	d4,d5	;		$YYyyxxxx
		swap	d5	;		$xx..YYyy
		
		moveq	#0,d0
		moveq	#0,d4

		; d2:	x-hi		....XXXX
		; d3:	xy		xx..YYyy
		; d4:			....0000
		; d5:	delta		xx..YYyy
		
.drloop256n1	move.w	d3,d0
		move.b	d2,d0
		move.b	(a0,d0.l),(a1)+
		add.l	d5,d3
		addx.w	d4,d2
		subq.w	#1,d1
		bne.b	.drloop256n1

.raus		rts


	ENDC


