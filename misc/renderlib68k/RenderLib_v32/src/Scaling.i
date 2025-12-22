
	IFND SCALING_I
SCALING_I	SET	1

;====================================================================
;--------------------------------------------------------------------
;
;		Scale
;
;	>	a0	ScaleEngine
;		a1	Source
;		a2	Dest
;		a3	TagList
;	<	d0	CONV_...
;
;--------------------------------------------------------------------

Scale		movem.l	d2-d5/d7/a4-a6,-(a7)


		sub.w	#conv_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(conv_engine,a5)		; Scale-Engine eintragen
		move.l	a1,(conv_source,a5)
		move.l	a2,(conv_dest,a5)

		move.w	(eng_destwidth,a0),(conv_width,a5)
		move.w	(eng_pixelformat,a0),(conv_colormode,a5)

		move.l	(utilitybase,pc),a6

		move.w	(eng_sourcewidth,a0),d2
		move.w	(eng_destwidth,a0),d3
		move.w	(eng_destheight,a0),(conv_height,a5)

		GetTag	#RND_SourceWidth,d2,a3
		move.w	d0,(conv_totalsourcewidth,a5)

		GetTag	#RND_DestWidth,d3,a3
		move.w	d0,(conv_totaldestwidth,a5)

		GetTag	#RND_LineHook,#0,a3
		move.l	d0,d4

		clr.w	(conv_sourcex,a5)
		clr.w	(conv_sourcey,a5)
		clr.w	(conv_destx,a5)
		clr.w	(conv_desty,a5)

		moveq	#CONV_NOT_ENOUGH_MEMORY,d7


		move.l	(conv_engine,a5),a6

		jsr	([eng_initfunc,a6])
		tst.w	d0
		beq	.raus

		move.w	(conv_height,a5),d5
		subq.w	#1,d5

		tst.l	d4
		bne.b	.hooks

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.nohooks	jsr	([conv_func,a5])
		add.l	d0,a0
		add.l	d1,a1
		dbf	d5,.nohooks
		bra	.success

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.hooks

.lop			move.l	d4,d0
			beq.b	.nolcb1

			moveq	#0,d3
			move.w	(conv_sourceline,a5),d3		; !!!
			
			moveq	#LMSGTYPE_LINE_FETCH,d2		; Messagetyp
			move.l	a0,d1				; Objekt
			LINECALLBACK
			tst.w	d0
			beq.w	.cbabort

.nolcb1
		jsr	([conv_func,a5])
		add.l	d0,a0

			move.l	d4,d0
			beq.b	.nolcb2

			move.l	d1,-(a7)			
			moveq	#0,d3
			move.w	(conv_height,a5),d3
			sub.w	d5,d3				; Count
			subq.l	#1,d3
			moveq	#LMSGTYPE_LINE_RENDERED,d2	; Messagetyp
			move.l	a1,d1				; Objekt
			LINECALLBACK
			move.l	(a7)+,d1
			tst.w	d0
			beq.b	.cbabort

.nolcb2

		add.l	d1,a1
		dbf	d5,.lop

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

.success	moveq	#CONV_SUCCESS,d7
		bra.b	.raus

.cbabort	moveq	#CONV_CALLBACK_ABORTED,d7


.raus		jsr	([conv_closefunc,a5])
		
		add.w	#conv_SIZEOF,a7		

		move.l	d7,d0

		movem.l	(a7)+,d2-d5/d7/a4-a6
		rts

;--------------------------------------------------------------------
;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		ScaleOrdinate
;
;		skaliert eine einzelne Ordinate
;		nach demselben Algo, mit dem
;		Scaling-Engines erzeugt werden.
;
;	>	d0	Startwert
;		d1	Zielwert
;		d2	zu skalierende Ordinate (Start)
;	<	d0	skalierte Ordinate
;
;--------------------------------------------------------------------

ScaleOrdinate:	movem.l	d2-d3,-(a7)

		lea	(.offsetcallback,pc),a0
		exg	d0,d1

		bsr	CalcScaleOffsets
		bra.b	.offsetok

.offsetcallback	move.w	d0,d3	; merken
		moveq	#-1,d0	; continue
		dbf	d2,.ok
		moveq	#0,d0	; abort
.ok		rts

.offsetok	moveq	#0,d0
		move.w	d3,d0

		movem.l	(a7)+,d2-d3
		rts

;--------------------------------------------------------------------
;====================================================================



;--------------------------------------------------------------------
;
;		GenerateScale8
;		(keine Interpolierung)
;
;	>	a0	Memhandler
;		d0	SourceBreite
;		d1	SourceHöhe
;		d2	DestBreite
;		d3	DestHöhe
;	<	d0	ScaleEngine
;
;--------------------------------------------------------------------

GenerateScale8	movem.l	d2-d7/a2,-(a7)

		move.w	d0,d4
		move.w	d1,d5
		move.w	d2,d6
		move.w	d3,d7

		; ScaleEngine: header + 2*destheight + 4*destwidth + 2

		moveq	#0,d0
		move.w	d7,d0
		add.l	d0,d0
		moveq	#0,d1
		move.w	d6,d1
		lsl.l	#2,d1
		add.l	d1,d0
		add.l	#2+sce_SIZEOF,d0
		bsr	AllocRenderVec
		tst.l	d0
		beq	.nomem

		move.l	d0,a2

		clr.l	(sce_linebuffer,a2)
		move.w	#PIXFMT_CHUNKY_CLUT,(eng_pixelformat,a2)



		lea	(sce_SIZEOF,a2),a1

		move.w	d4,(eng_sourcewidth,a2)
		move.w	d5,(eng_sourceheight,a2)
		move.w	d6,(eng_destwidth,a2)
		move.w	d7,(eng_destheight,a2)


		; Offset-Tabelle erzeugen

		move.w	d5,d0
		move.w	d7,d1
		lea	(.offsetcallback,pc),a0

		moveq	#0,d2				; last offset
		moveq	#-1,d3				; erster Wert

		bsr	CalcScaleOffsets
		bra.b	.offsetok

.offsetcallback	tst.w	d3
		bmi.b	.first

		move.w	d0,d3
		sub.w	d2,d3				; Delta-Offset
		move.w	d3,(a1)+
		move.w	d0,d2
		moveq	#-1,d0				; continue
		rts

.first		move.w	d0,d2
		moveq	#0,d3
		moveq	#-1,d0				; continue
		rts

.offsetok	move.w	d5,d3
		sub.w	d2,d3
		move.w	d3,(a1)+			; letzter Wert


		; Zeilencode erzeugen

		move.l	a1,(sce_code,a2)

		moveq	#-1,d2				; last offset
		moveq	#0,d3				; equal offset count - 1

		move.w	d4,d0
		move.w	d6,d1				; dest
		lea	(.codecallback,pc),a0

		bsr	CalcScaleOffsets
		bra.b	.codeok
		
.template1	move.b	$1234(a0),(a1)+
.template2	rts
.template3	move.b	$1234(a0),d0
.template4	move.b	d0,(a1)+

.codecallback	exg	d0,d2

		cmp.w	d2,d0
		bne.b	.newoffs
		
		addq.w	#1,d3

		cmp.w	#1,d3
		bne.b	.more
		
		move.w	(.template3,pc),(-4.w,a1)	; move.w $....(a0),d0
		move.w	(.template4,pc),(a1)+		; move.w d0,(a1)+

.more		move.w	(.template4,pc),(a1)+		; move.w d0,(a1)+
		moveq	#-1,d0
		rts

.newoffs	moveq	#0,d3

		move.w	(.template1,pc),(a1)+		; move.w $....(a0),(a1)+
		move.w	d2,(a1)+			; $xxxx
		moveq	#-1,d0
		rts


.codeok		move.w	(.template2,pc),(a1)+
		
		move.l	a2,d0
.nomem		
		movem.l	(a7)+,d2-d7/a2
		rts

;--------------------------------------------------------------------

;--------------------------------------------------------------------
;
;		GenerateScale24
;		(keine Interpolierung)
;
;	>	a0	Memhandler
;		d0	SourceBreite
;		d1	SourceHöhe
;		d2	DestBreite
;		d3	DestHöhe
;	<	d0	ScaleEngine
;
;--------------------------------------------------------------------

GenerateScale24	movem.l	d2-d7/a2,-(a7)

		move.w	d0,d4
		move.w	d1,d5
		move.w	d2,d6
		move.w	d3,d7

		; ScaleEngine: header + 2*destheight + 4*destwidth + 2

		moveq	#0,d0
		move.w	d7,d0
		add.l	d0,d0
		moveq	#0,d1
		move.w	d6,d1
		lsl.l	#2,d1
		add.l	d1,d0
		add.l	#2+sce_SIZEOF,d0
		bsr	AllocRenderVec
		tst.l	d0
		beq	.nomem


		move.l	d0,a2
		move.w	#PIXFMT_0RGB_32,(eng_pixelformat,a2)


		lea	(sce_SIZEOF,a2),a1

		move.w	d4,(eng_sourcewidth,a2)
		move.w	d5,(eng_sourceheight,a2)
		move.w	d6,(eng_destwidth,a2)
		move.w	d7,(eng_destheight,a2)


		; Offset-Tabelle erzeugen

		move.w	d5,d0
		move.w	d7,d1
		lea	(.offsetcallback,pc),a0

		moveq	#0,d2				; last offset
		moveq	#-1,d3				; erster Wert

		bsr.b	CalcScaleOffsets
		bra.b	.offsetok

.offsetcallback	tst.w	d3
		bmi.b	.first

		move.w	d0,d3
		sub.w	d2,d3				; Delta-Offset
		move.w	d3,(a1)+
		move.w	d0,d2
		moveq	#-1,d0				; continue
		rts

.first		move.w	d0,d2
		moveq	#0,d3
		moveq	#-1,d0				; continue
		rts

.offsetok	move.w	d5,d3
		sub.w	d2,d3
		move.w	d3,(a1)+			; letzter Wert


		; Zeilencode erzeugen

		move.l	a1,(sce_code,a2)

		moveq	#-1,d2				; last offset
		moveq	#0,d3				; equal offset count - 1

		move.w	d4,d0
		move.w	d6,d1				; dest
		lea	(.codecallback,pc),a0

		bsr.b	CalcScaleOffsets
		bra.b	.codeok
		
.template1	move.l	$1234(a0),(a1)+
.template2	rts
.template3	move.l	$1234(a0),d0
.template4	move.l	d0,(a1)+

.codecallback	lsl.w	#2,d0

		exg	d0,d2

		cmp.w	d2,d0
		bne.b	.newoffs
		
		addq.w	#1,d3

		cmp.w	#1,d3
		bne.b	.more
		
		move.w	(.template3,pc),(-4.w,a1)	; move.l $....(a0),d0
		move.w	(.template4,pc),(a1)+		; move.l d0,(a1)+

.more		move.w	(.template4,pc),(a1)+		; move.l d0,(a1)+
		moveq	#-1,d0
		rts

.newoffs	moveq	#0,d3

		move.w	(.template1,pc),(a1)+		; move.l $....(a0),(a1)+

		move.w	d2,(a1)+			; $xxxx
		moveq	#-1,d0
		rts


.codeok		move.w	(.template2,pc),(a1)+
		
		move.l	a2,d0
.nomem		
		movem.l	(a7)+,d2-d7/a2
		rts

;--------------------------------------------------------------------



;--------------------------------------------------------------------
;
;		CalcScaleOffsets
;
;		Erzeugt mittels Bresenham-Algorithmus
;		die Source-Offsets für eine Skalierung.
;		Mit dem jeweiligen Offset wird eine
;		Callback-Funktion aufgerufen. Der Callback
;		wird <ziel> mal aufgerufen.
;
;	>	d0	UWORD	start
;		d1	UWORD	ziel
;		a0	FPTR	Callback
;
;		Konventionen für CALLBACK:
;
;	>	d0	UWORD	Offset
;		a0	FPTR	Callback
;	<	d0	BOOL	Continue?
;
;		Abgesehen von d0 und a0 wird der Callback mit den
;		Original-Registerinhalten aufgerufen. Er darf alle
;		Register benutzen und verändern. Die Änderungen der
;		Registerinhalte bleiben ebenfalls erhalten und werden
;		nach Beendigung von CalcScaleOffsets sogar
;		zurückgeliefert. Es ist, als sei CalcScaleOffsets
;		gar nicht vorhanden - eine Art virtuelle Funktion
;		als Überbau für den Callback.
;
;--------------------------------------------------------------------

CalcScaleOffsets
		movem.l	d2-d6,-(a7)
		
		cmp.w	d1,d0
		blt.b	.enlarge
		bgt.b	.shrink


.equal		moveq	#0,d2
		move.w	d0,d3
		subq.w	#1,d3

.eqloop		move.w	d2,d0

		movem.l	d2-d6/a0,-(a7)
		movem.l	(6*4,a7),d2-d6
		jsr	(a0)
		movem.l	d2-d6,(6*4,a7)
		movem.l	(a7)+,d2-d6/a0
		
		tst.l	d0
		beq.b	.ok		; abort
		addq.w	#1,d2
		dbf	d3,.eqloop	
		bra.b	.ok


.shrink		moveq	#0,d2
		move.w	d1,d2
		add.l	d2,d2		; SourceSub
		
		moveq	#0,d3
		move.w	d0,d3
		add.l	d3,d3		; DestAdd
		
		moveq	#0,d4
		move.w	d0,d4		; Start Akku
		bra.b	.continue				

				
.enlarge	move.w	d1,d2
		mulu.w	d0,d2		; SourceSub
		
		move.w	d0,d3
		mulu.w	d0,d3		; DestAdd
		
		moveq	#0,d4
		move.w	d0,d4		; Start Akku


.continue	moveq	#-1,d5		; Source Count
		move.w	d1,d6		; Dest Count
		
.get		addq.w	#1,d5
		sub.l	d2,d4		; -Source
		bpl.b	.get

.put		move.w	d5,d0		; Offset

		movem.l	d2-d6/a0,-(a7)
		movem.l	(6*4,a7),d2-d6
		jsr	(a0)
		movem.l	d2-d6,(6*4,a7)
		movem.l	(a7)+,d2-d6/a0

		tst.l	d0
		beq.b	.ok		; abort
		subq.w	#1,d6
		beq.b	.ok

		add.l	d3,d4		; +Dest
		bmi.b	.put
		bra.b	.get

.ok		movem.l	(a7)+,d2-d6
		rts

;--------------------------------------------------------------------






;------------------------------------------------------------------------------
;
;	Init_Scale
;
;	>	a5	Conv-Struktur
;			s,d,sx,sy,dx,dy,width,height,tswidth,tdwidth
;			engine,colormode
;	<	a0	Source
;		a1	Dest
;
;------------------------------------------------------------------------------

Init_Scale	moveq	#0,d1				; shift
		move.w	(conv_colormode,a5),d0

		btst	#PIXFMTB_RGB,d0
		beq.b	.noshift
		moveq	#2,d1

.noshift	moveq	#0,d0
		move.w	(conv_totaldestwidth,a5),d0
		lsl.l	d1,d0
		move.l	d0,(conv_destoffset,a5)

		moveq	#0,d0
		move.w	(conv_totalsourcewidth,a5),d0
		lsl.l	d1,d0
		move.l	d0,(conv_sourceoffset,a5)



		lea	(Func_Scale,pc),a1
		move.l	a1,(conv_func,a5)

		lea	(Func_Scale_close,pc),a1
		move.l	a1,(conv_closefunc,a5)



		moveq	#0,d0
		move.w	(conv_sourcey,a5),d0
		mulu.l	(conv_sourceoffset,a5),d0
		lea	([conv_source,a5],d0.l),a0
		move.w	(conv_sourcex,a5),d0
		lsl.w	d1,d0
		add.w	d0,a0				; Source

		moveq	#0,d0
		move.w	(conv_desty,a5),d0
		mulu.l	(conv_destoffset,a5),d0
		lea	([conv_dest,a5],d0.l),a1
		move.w	(conv_destx,a5),d0
		lsl.w	d1,d0
		add.w	d0,a1				; Dest

		clr.w	([conv_engine,a5],sce_line)	; Y-Position
		
		clr.w	(conv_sourceline,a5)		; !!!

		moveq	#-1,d0
		rts		

;------------------------------------------------------------------------------
;
;	Func_Scale
;
;------------------------------------------------------------------------------

		cnop	0,4

Func_Scale	move.l	a1,-(a7)
		move.l	a6,-(a7)

		move.l	(conv_engine,a5),a6
		
		jsr	([sce_code,a6])

		move.w	(sce_line,a6),d1		; y

		move.w	(sce_SIZEOF,a6,d1.w*2),d0	; Offset
		add.w	d0,(conv_sourceline,a5)		; !!!! eintragen

		addq.w	#1,d1				; y hochzählen
		cmp.w	(conv_height,a5),d1
		blt.b	.yok
		moveq	#0,d1
.yok		move.w	d1,(sce_line,a6)

		mulu.w	(conv_sourceoffset+2,a5),d0	; SourceOffset
		move.l	(conv_destoffset,a5),d1		; DestOffset

		move.l	(a7)+,a6
		move.l	(a7)+,a1
		rts

;------------------------------------------------------------------------------
;
;	Func_Scale_Close
;
;------------------------------------------------------------------------------

Func_Scale_close

		rts

;------------------------------------------------------------------------------


;//////////////////////////////////////////////////////////////////////////////



;------------------------------------------------------------------------------
;
;	a0	Sourcebuffer
;	a5	Conv


FetchLine	movem.l	a1-a2/d0,-(a7)

		move.l	(conv_engine,a5),a2

		moveq	#0,d0
		move.w	(eng_sourcewidth,a2),d0

		lsl.l	#2,d0
		move.l	(sce_linebuffer,a2),a1

		bsr.l	TurboCopyMem

		movem.l	(a7)+,a1-a2/d0
		rts


FetchNewLine	movem.l	a0-a3/d0-d3,-(a7)

		move.l	(conv_engine,a5),a2

		move.w	(sce_line,a2),d2
		move.w	(sce_SIZEOF,a2,d2.w*2),d2
		move.w	d2,d3
		beq	.nonew

		mulu.w	(conv_sourceoffset+2,a5),d2
		add.l	d2,a0

		moveq	#0,d0
		move.w	(eng_sourcewidth,a2),d0

		lsl.l	#2,d0
		move.l	(sce_linebuffer,a2),a1

		bsr.l	TurboCopyMem
		
		move.w	d3,d2
		subq.w	#1,d2
		beq.b	.nonew
		
		move.l	a0,a1
		move.l	(sce_deltabuffer,a2),a0
		move.w	(eng_sourcewidth,a2),d0
		mulu.w	#12,d0
		moveq	#0,d1
		bsr.l	TurboFillMem
		move.l	a1,a0

		moveq	#0,d0


.mixloopy	move.w	(eng_sourcewidth,a2),d1
		subq.w	#1,d1
		move.l	a0,-(a7)
		move.l	(sce_deltabuffer,a2),a1

.mixloopx	addq.w	#1,a0
		move.b	(a0)+,d0
		add.l	d0,(a1)+
		move.b	(a0)+,d0
		add.l	d0,(a1)+
		move.b	(a0)+,d0
		add.l	d0,(a1)+

		dbf	d1,.mixloopx

		move.l	(a7)+,a0
		add.w	(conv_sourceoffset+2,a5),a0
		
		dbf	d2,.mixloopy
		
		move.w	(eng_sourcewidth,a2),d1
		subq.w	#1,d1
		move.l	(sce_deltabuffer,a2),a0
		move.l	(sce_linebuffer,a2),a1
.mixloop2	clr.b	(a1)+
		move.l	(a0)+,d0
		divu.w	d3,d0
		move.b	d0,(a1)+
		move.l	(a0)+,d0
		divu.w	d3,d0
		move.b	d0,(a1)+
		move.l	(a0)+,d0
		divu.w	d3,d0
		move.b	d0,(a1)+
		dbf	d1,.mixloop2


.nonew		movem.l	(a7)+,a0-a3/d0-d3
		rts


;------------------------------------------------------------------------------
;
;	Init_ScaleI
;
;	>	a5	Conv-Struktur
;			s,d,sx,sy,dx,dy,width,height,tswidth,tdwidth
;			engine,colormode
;	<	a0	Source
;		a1	Dest
;
;------------------------------------------------------------------------------

Init_ScaleI	move.l	a2,-(a7)

		move.l	(conv_engine,a5),a2

		sub.l	a0,a0				;!!!! noch kein memhandler
		moveq	#0,d0
		move.w	(eng_sourcewidth,a2),d0
		lsl.l	#2,d0
		bsr	AllocRenderVec
		tst.l	d0
		beq	.fail
		move.l	d0,(sce_linebuffer,a2)

		sub.l	a0,a0				;!!!! noch kein memhandler
		moveq	#0,d0
		move.w	(eng_sourcewidth,a2),d0
		mulu.w	#12,d0
		bsr	AllocRenderVec
		tst.l	d0
		bne	.succeed

		move.l	(sce_linebuffer,a2),a0
		bsr	FreeRenderVec
		clr.l	(sce_linebuffer,a2)
		moveq	#0,d0
		bra.b	.fail

.succeed	move.l	d0,(sce_deltabuffer,a2)


		moveq	#0,d1				; shift
		move.w	(conv_colormode,a5),d0

		btst	#PIXFMTB_RGB,d0
		beq.b	.noshift
		moveq	#2,d1

.noshift	moveq	#0,d0
		move.w	(conv_totaldestwidth,a5),d0
		lsl.l	d1,d0
		move.l	d0,(conv_destoffset,a5)

		moveq	#0,d0
		move.w	(conv_totalsourcewidth,a5),d0
		lsl.l	d1,d0
		move.l	d0,(conv_sourceoffset,a5)



		lea	(Func_ScaleI,pc),a1
		move.l	a1,(conv_func,a5)

		lea	(Func_ScaleI_close,pc),a1
		move.l	a1,(conv_closefunc,a5)



		moveq	#0,d0
		move.w	(conv_sourcey,a5),d0
		mulu.l	(conv_sourceoffset,a5),d0
		lea	([conv_source,a5],d0.l),a0
		move.w	(conv_sourcex,a5),d0
		lsl.w	d1,d0
		add.w	d0,a0				; Source

		moveq	#0,d0
		move.w	(conv_desty,a5),d0
		mulu.l	(conv_destoffset,a5),d0
		lea	([conv_dest,a5],d0.l),a1
		move.w	(conv_destx,a5),d0
		lsl.w	d1,d0
		add.w	d0,a1				; Dest

		clr.w	(sce_line,a2)			; Y-Position

		bsr	FetchLine

		moveq	#-1,d0

.fail		move.l	(a7)+,a2
		rts		

;------------------------------------------------------------------------------
;
;	Func_Scale
;
;------------------------------------------------------------------------------

		cnop	0,4

Func_ScaleI	movem.l	a1-a2/a6/d2,-(a7)
		move.l	a0,-(a7)

		move.l	(conv_engine,a5),a6

		move.l	(sce_linebuffer,a6),a0

		jsr	([sce_code,a6])


		move.l	(a7)+,a0

		bsr	FetchNewLine

		move.w	(sce_line,a6),d1		; y
		move.w	(sce_SIZEOF,a6,d1.w*2),d0	; Offset
		mulu.w	(conv_sourceoffset+2,a5),d0	; SourceOffset
		move.l	(conv_destoffset,a5),d1		; DestOffset

		addq.w	#1,(sce_line,a6)		; y hochzählen

		movem.l	(a7)+,a1-a2/a6/d2
		rts

;------------------------------------------------------------------------------
;
;	Func_Scale_Close
;
;------------------------------------------------------------------------------

Func_ScaleI_close
		move.l	([conv_engine,a5],sce_deltabuffer),a0
		bsr	FreeRenderVec

		move.l	([conv_engine,a5],sce_linebuffer),a0
		bra	FreeRenderVec

;------------------------------------------------------------------------------






	ENDC

