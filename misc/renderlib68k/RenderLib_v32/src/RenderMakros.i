
	IFND	RENDERMAKROS_I
RENDERMAKROS_I		SET	1

;----------------------------------------------------------------------
;
;		DIVERSITY
;
;	>	d0	RGB1
;		d1	RGB2
;	<	d0	Diversity
;
;	trash:	d1-d3
;
;----------------------------------------------------------------------

DIVERSITY:		MACRO

		moveq	#0,d2
		move.b	d0,d2		; Blau
		moveq	#0,d3
		move.b	d1,d3
		sub.w	d2,d3
		muls.w	d3,d3

		move.w	d0,d2		; Grün
		lsr.w	#8,d1
		lsr.w	#8,d2
			swap	d0		; Rot
		sub.w	d1,d2
		muls.w	d2,d2
		
			swap	d1		
		sub.w	d1,d0
		muls.w	d0,d0
		add.l	d3,d0
		add.l	d2,d0

			ENDM

;----------------------------------------------------------------------


;----------------------------------------------------------------------
;
;		TABLEEXECUTE
;
;		führt eine Tabellenschleife mit den angegebenen
;		BitsPerGun aus und stellt der Callback-Funktion
;		den jeweils zugehörigen interpolierten RGB-Wert
;		zur Verfügung.
;		
;	>	a0	Callback-Funktion
;		d0	BitsPerGun
;	trash:	d0-d6
;
;		Konventionen:
;
;		a)	Der aktuelle RGB-Wert befindet sich in d0.
;		b)	Das Makro verändert alle Datenregister außer d7.
;		c)	Der Callback muß die Register d0-d5/a0 retten.
;
;		Die Callbackfunktion sollte in unmittelbarer Nähe
;		zum Makro liegen, damit der ICache zum Tragen kommt.
;
;----------------------------------------------------------------------

TABLEEXECUTE:		MACRO

		move.w	d0,d4			; BitsPerGun

		move.w	#255,d0
		lsr.b	d4,d0
		move.w	d0,d1
		swap	d1
		move.b	d0,d1
		lsl.w	#8,d1
		move.b	d0,d1			; AND-Maske

		moveq	#0,d0			; aktueller RGB
		moveq	#0,d2			; Rot und Grün
		moveq	#0,d3			; Blau
		moveq	#1,d5
		lsl.w	d4,d5
		subq.w	#1,d5			; Zähler
			
.rlop\@		bfins	d2,d0{8:d4}		; ROT einfügen
		swap	d2

.glop\@		bfins	d2,d0{16:d4}		; GRÜN einfügen

.blop\@		bfins	d3,d0{24:d4}		; BLAU einfügen

		move.l	d0,d6
		lsr.l	d4,d6
		and.l	d1,d6
		not.l	d1
		and.l	d1,d0
		or.l	d6,d0
		not.l	d1

		jsr	(a0)

		addq.w	#1,d3
		and.w	d5,d3
		bne.b	.blop\@

		addq.w	#1,d2
		and.w	d5,d2
		bne.b	.glop\@

		swap	d2
		addq.w	#1,d2
		and.w	d5,d2
		bne.b	.rlop\@

			ENDM

;----------------------------------------------------------------------



;----------------------------------------------------------------------
;
;		FINDPEN_PALETTE2
;
;	>	d0.w	Rot
;		d1.w	Grün
;		d2.w	Blau
;		d4	Numcolors
;		a2	WordPalette
;		[a3	QuadTable]¹
;	<	d0	ULONG	Diversity:BestPen
;
;	trash:	d3-d7/a2/[a3]¹
;
;	¹ a3 wird nur in der 60er-Version getrasht. Dort
;	  wird aber auch keine QuadTable benötigt.
;
;----------------------------------------------------------------------

FINDPEN_PALETTE2:	MACRO

	IFNE	CPU60

		moveq	#50,d7
		swap	d7

		subq.w	#1,d4
		move.w	d4,-(a7)
		move.l	(a2)+,d3

.fplopp\@	move.w	d1,d5
		move.w	d2,d6
		sub.w	d3,d5
		sub.w	(a2)+,d6
		muls.w	d5,d5
		swap	d3
		sub.w	d0,d3
		muls.w	d3,d3
		add.l	d3,d5
		muls.w	d6,d6
		move.l	(a2)+,d3
		add.l	d6,d5
		cmp.l	d5,d7
		ble.b	.fpnotbet\@
		move.w	d4,a3
		move.l	d5,d7
		beq.b	.fpraus\@
.fpnotbet\@	dbf	d4,.fplopp\@

.fpraus\@	divu.w	#3,d7
		move.w	d7,d0
		swap	d0
		move.w	(a7)+,d0
		sub.w	a3,d0

	ELSE


		subq.w	#1,d4
		move.w	d4,-(a7)

		moveq	#-1,d3			; unmögliche Diversität

.findlop\@	move.l	(a2)+,d5		; rot:grün

		sub.w	d1,d5
		move.w	(a3,d5.w*2),d7		; grün
		swap	d5
		sub.w	d0,d5			; rot
		add.w	(a3,d5.w*2),d7

		move.w	(a2)+,d5		; blau
		sub.w	d2,d5
		add.w	(a3,d5.w*2),d7

		cmp.w	d7,d3
		bls.b	.worse\@

		move.w	d4,d6		; pen
		move.w	d7,d3		; new best diversity
		beq.b	.found\@

.worse\@	dbf	d4,.findlop\@

.found\@	move.w	d3,d0
		swap	d0		; diversity
		move.w	(a7)+,d0
		sub.w	d6,d0		; pen

	ENDC
			ENDM

;----------------------------------------------------------------------
;
;		FINDPEN_PALETTE
;
;	>	d0	RGB
;		d4	Numcolors
;		a2	WordPalette
;		a3	QuadTab
;	<	d0	ULONG	Diversity:BestPen
;
;	trash:	d1-d7/a2/a3¹
;
;----------------------------------------------------------------------

FINDPEN_PALETTE:	MACRO

		moveq	#0,d2
		move.b	d0,d2			; BLAU
		bfextu	d0{16:8},d1		; GRÜN
		swap	d0			; ROT

		FINDPEN_PALETTE2

			ENDM

	IFNE	0

;----------------------------------------------------------------------
;
;		FINDPEN_TREE
;
;		ermittelt den besten Pen in einem NICHT
;		oder nur TEILWEISE vorberechneten Renderbaum.
;
;	>	d0	RGB
;		d1	Relevanzmaske
;		d3	Offset Color Zero
;		d4	Numcolors
;		a2	Tree-Root
;		a3	Quadtab
;		a4	Wordpalette
;	<	d2.b	Bestpen
;
;	trash:	d0,d1,a2,[a3]
;
;----------------------------------------------------------------------

FINDPEN_TREE:		MACRO

		and.l	d1,d0

		cmp.l	(a2),d0
		beq.b	.found

		move.l	d0,d2

.notfnd		lsr.l	#1,d2			; jetzt shift nach rechts!
		bcc.b	.left

.right		move.l	(rNode_right,a2),a2

		cmp.l	(a2),d0
		beq.b	.found

		lsr.l	#1,d2
		bcs.b	.right

.left		move.l	(rNode_left,a2),a2

		cmp.l	(a2),d0
		bne.b	.notfnd

.found		move.w	(rNode_validated,a2),d2
		bpl.b	.okay

		movem.l	d1/d3-d7/a2,-(a7)

		move.l	d0,d3
		move.w	(rend_bitspergun,a6),d7
		lsr.l	d7,d3
		not.l	d1
		and.l	d1,d3
		or.l	d3,d0
		
;			move.l	(rend_filter,a6),d5
;			beq.b	.nofilt
;			move.l	d0,d2
;			move.l	d5,d0
;			move.l	(rend_histogram,a6),d1
;			FILTERCALLBACK
;.nofilt
		move.l	a4,a2			; Wordpalette
		FINDPEN_PALETTE			; besten Pen finden
		movem.l	(a7)+,d1/d3-d7/a2

		move.w	d0,d2
		add.w	d3,d2
		move.w	d2,(rNode_validated,a2)
.okay
			ENDM

;----------------------------------------------------------------------

	ENDC

;----------------------------------------------------------------------
;
;		PROGRESSCALLBACK
;
;		Handhabt einen Progress-Callback
;
;	>	d0	Hook
;		d1	Objekt
;		d2	PMSGTYPE
;		d3	Count
;		d4	Total
;
;	<	d0	Rückgabewert des Callbacks oder TRUE
;
;----------------------------------------------------------------------

PROGRESSCALLBACK:	MACRO

		movem.l	a0/a1/a2/a6,-(a7)

		move.l	d4,-(a7)	; Total
		move.l	d3,-(a7)	; Count
		move.l	d2,-(a7)	; PMSGTYPE

		move.l	d1,a2		; Objekt
		move.l	a7,a1		; Message
		move.l	d0,a0		; Hook

		move.l	(utilitybase,pc),a6
		jsr	(_LVOCallHookPkt,a6)

		add.w	#12,a7		; Stack korrigieren

		movem.l	(a7)+,a0/a1/a2/a6

		ENDM

;----------------------------------------------------------------------

;----------------------------------------------------------------------
;
;		LINECALLBACK
;
;		Handhabt einen Line-Callback
;
;	>	d0	Hook
;		d1	Objekt (=Buffer)
;		d2	LMSGTYPE
;		d3	Count
;
;	<	d0	Rückgabewert des Callbacks oder TRUE
;
;----------------------------------------------------------------------

LINECALLBACK:	MACRO

		movem.l	a0/a1/a2/a6,-(a7)

		move.l	d3,-(a7)	; Count
		move.l	d2,-(a7)	; LMSGTYPE

		move.l	d1,a2		; Objekt
		move.l	a7,a1		; Message
		move.l	d0,a0		; Hook

		move.l	(utilitybase,pc),a6
		jsr	(_LVOCallHookPkt,a6)

		addq.w	#8,a7		; Stack korrigieren

		movem.l	(a7)+,a0/a1/a2/a6

		ENDM

;----------------------------------------------------------------------

;----------------------------------------------------------------------
;
;		FILTERCALLBACK
;
;		Handhabt einen Filter-Callback
;
;	>	d0	Hook
;		d1	Histogramm
;		d2	RGB
;
;	<	d0	gefilterter RGB
;
;----------------------------------------------------------------------

FILTERCALLBACK:	MACRO

		movem.l	a0/a1/a2/a6,-(a7)

		move.l	d2,-(a7)	; RND_FMsg_RGB

		move.l	d1,a2		; Objekt
		move.l	a7,a1		; Message
		move.l	d0,a0		; Hook

		move.l	(utilitybase,pc),a6
		jsr	(_LVOCallHookPkt,a6)

		addq.w	#4,a7		; Stack korrigieren

		movem.l	(a7)+,a0/a1/a2/a6

		ENDM

;----------------------------------------------------------------------



;---------------------------------------------------------------------
;
;		BestPenHAM8	threshold, bitspergun_p2table
;
;	>	d0	newRGB
;		d1	oldRGB
;		a2	Palette
;		a3	DivTab (auch mit 060er!)
;	<	d0	Chunky
;		d1	newRGB
;
;	trash:	a6,d2-d7
;
;---------------------------------------------------------------------

BESTPENHAM8:		MACRO

		moveq	#-1,d6			; erster Pixel pro Zeile
	;	tst.b	(conv_firstpixel,a5)	; muß Basisfarbe sein!
	;	bne	.first\@

		cmp.l	d0,d1			; == oldRGB?
		bne.b	.notequal\@

		;	neue Farbe entspricht exakt der alten Farbe

		swap	d0
		lsr.b	#2,d0
		or.b	#%10000000,d0
		bra	.raus\@

.notequal\@	;	Modify-Varianten und Abweichungen berechnen

		;	a6	rg[B]
		;	d4	r[G]b
		;	d5	[R]gb
		;	d6	d(R-r) + d(G-g) + d(B-[B])
		;	d1.lo	d(R-r) + d(G-[G]) + d(B-b)
		;	d1.hi	d(R-[R]) + d(G-g) + d(B-b)

		move.l	d1,d3		; rgb
		move.l	d1,d4		; rgb
		move.w	#255,d6
		move.l	d1,d5		; rgb

		and.w	d6,d1		; b
		moveq	#0,d2
		move.b	d0,d2		; B
		move.w	d2,d7		; B
		lsr.b	#2,d2
		bfins	d2,d3{24:6}	; rg[B]

		cmp.l	d3,d0
		bne.b	.notbmod\@
		or.b	#%01000000,d2
		move.l	d3,d1			; newRGB
		move.b	d2,d0			; Chunky
		bra	.raus\@

.notbmod\@	move.l	d3,a6		; rg[B]
		and.w	d6,d3		; [B]
		sub.w	d7,d3		; [B]-B
		move.w	(a3,d3.w*2),d6	; d([B]-B)
		sub.w	d1,d7		; B-b
		move.w	(a3,d7.w*2),d7	; d(B-b)
		move.w	d7,d1		;		HI
		swap	d1
		move.w	d7,d1		;		LO

		bfextu	d4{16:8},d3	; g
		bfextu	d0{16:8},d2	; G
		move.w	d2,d7		; G
		lsr.b	#2,d2
		bfins	d2,d4{16:6}	; r[G]b
		cmp.l	d4,d0
		bne.b	.notgmod\@

		or.b	#%11000000,d2
		move.l	d4,d1			; newRGB
		move.b	d2,d0			; Chunky
		bra	.raus\@

.notgmod\@	bfextu	d4{16:8},d2	; [G]
		sub.w	d7,d2		; [G]-G
		add.w	(a3,d2.w*2),d1	; d([G]-G)	LO
		sub.w	d3,d7		; G-g
		move.w	(a3,d7.w*2),d2	; d(G-g)
		swap	d1
		add.w	d2,d1		;		HI
		add.w	d2,d6

		move.l	d5,d3
		swap	d3		; r
		move.l	d0,d2
		swap	d2		; R
		move.w	d2,d7		; R
		lsr.b	#2,d2
		bfins	d2,d5{8:6}	; [R]gb
		cmp.l	d5,d0
		bne.b	.notrmod\@

		or.b	#%10000000,d2
		move.l	d5,d1			; newRGB
		move.b	d2,d0			; Chunky
		bra	.raus\@

.notrmod\@	move.l	d5,d2
		swap	d2		; [R]
		sub.w	d7,d2		; [R]-R
		add.w	(a3,d2.w*2),d1	; d([R]-R)	HI
		sub.w	d3,d7		; R-r
		move.w	(a3,d7.w*2),d2	; d(R-r)
		swap	d1
		add.w	d2,d1		;		LO
		add.w	d2,d6


		;	beste Modifikation ermitteln

		move.l	a6,d2			; BLAU neuer IST
		bfextu	d2{24:6},d3		; Modify-Blau-Anteil
		or.b	#%01000000,d3		; Blau-Modify

		cmp.w	d1,d6
		bls.b	.nG\@
		
		move.w	d1,d6			; neuer BEST
		move.l	d4,d2			; neuer IST
		bfextu	d2{16:6},d3		; Modify-Grün-Anteil
		or.b	#%11000000,d3		; Grün-Modify
		
.nG\@		swap	d1
		cmp.w	d1,d6
		bls.b	.nR\@
		
		move.w	d1,d6			; neuer BEST
		move.l	d5,d2			; neuer IST
		bfextu	d2{8:6},d3		; Modify-Rot-Anteil
		or.b	#%10000000,d3		; Rot-Modify

.nR\@
		;	Sieger feststellen

		move.l	d2,d1
.first\@	move.l	d0,d7				; RGB merken
		sf	(conv_firstpixel,a5)

		and.l	#$ffffff,d0			;!!!

		move.l	(conv_p2HAM1,a5),d5
		lsr.l	d5,d0
		lsl.b	d5,d0
		lsl.w	d5,d0
		swap	d5
		lsr.l	d5,d0

	;	bfextu	d0{16:d5},d2			; Index auf p2Table berechnen
	;	move.w	(a6)+,d4
	;	lsr.l	d4,d0
	;	move.w	(a6)+,d4
	;	bfins	d0,d2{d4:d5}
	;	move.w	(a6)+,d4
	;	bfins	d0,d2{d4:d5}

		lea	([conv_p2table,a5],d0.l),a6

		move.w	(a6),d0				; Eintrag holen
		bmi.b	.fndpal\@			; nicht gültig

		;	Eintrag ist gültig.
		;	Diversität ausrechnen

		and.w	#$ff,d0

		move.l	(a2,d0.w*4),d2			; newRGB

		swap	d0
		moveq	#0,d5
		move.b	d2,d5
		moveq	#0,d4
		move.b	d7,d4
		sub.w	d4,d5
		move.w	(a3,d5.w*2),d0
		bfextu	d2{16:8},d5
		bfextu	d7{16:8},d4
		sub.w	d4,d5
		add.w	(a3,d5.w*2),d0
		move.l	d7,d4
		swap	d4
		move.l	d2,d5
		swap	d5
		sub.w	d4,d5
		add.w	(a3,d5.w*2),d0

		cmp.w	d0,d6			; besser als Modifikation?
		bls	.usemod\@		; nein

		cmp.w	#\1,d0			; Diversität jenseits Threshold?
		blt.b	.fndpal\@		; kann nicht benutzt werden

		swap	d0			; Pen
		move.l	d2,d1			; newRGB
		move.b	(conv_pentab,a5,d0.w),d0
		bra.b	.raus\@

.fndpal\@	move.l	d7,d0
		movem.l	d1/d2/d3/d6/a2/a3,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE
		movem.l	(a7)+,d1/d2/d3/d6/a2/a3

		move.w	d0,(a6)			; immer eintragen

		swap	d0

		cmp.w	d0,d6			; besser als Modifikation?
		bls.b	.usemod\@		; nein

		swap	d0			; Pen
		move.l	(a2,d0.w*4),d1		; newRGB
		move.b	(conv_pentab,a5,d0.w),d0
		bra.b	.raus\@

.usemod\@	move.b	d3,d0			; Chunky

.raus\@
			ENDM

;---------------------------------------------------------------------
;
;		BestPenHAM6
;
;	>	d0	newRGB
;		d1	oldRGB
;		a2	Palette
;		a3	DivTab (auch mit 060er!)
;	<	d0	Chunky
;		d1	newRGB
;
;	trash:	a6,d2-d7
;
;---------------------------------------------------------------------

BESTPENHAM6:		MACRO

		moveq	#-1,d6			; erster Pixel pro Zeile
	;	tst.b	(conv_firstpixel,a5)	; muß Basisfarbe sein!
	;	bne	.first\@

		cmp.l	d0,d1			; == oldRGB?
		bne.b	.notequal\@

		;	neue Farbe entspricht exakt der alten Farbe

		swap	d0
		lsr.b	#4,d0
		or.b	#%00100000,d0
		bra	.raus\@

.notequal\@	;	Modify-Varianten und Abweichungen berechnen

		;	a6	rg[B]
		;	d4	r[G]b
		;	d5	[R]gb
		;	d6	d(R-r) + d(G-g) + d(B-[B])
		;	d1.lo	d(R-r) + d(G-[G]) + d(B-b)
		;	d1.hi	d(R-[R]) + d(G-g) + d(B-b)

		
		move.l	d1,d3		; rgb
		move.l	d1,d4		; rgb
		move.w	#255,d6
		move.l	d1,d5		; rgb

		and.w	d6,d1		; b
		moveq	#0,d2
		move.b	d0,d2		; B
		move.w	d2,d7		; B
		lsr.b	#4,d2
		bfins	d2,d3{24:4}	; rg[B]

		cmp.l	d3,d0
		bne.b	.notbmod\@
		or.b	#%00010000,d2
		move.l	d3,d1			; newRGB
		move.b	d2,d0			; Chunky
		bra	.raus\@

.notbmod\@	move.l	d3,a6		; rg[B]
		and.w	d6,d3		; [B]
		sub.w	d7,d3		; [B]-B
		move.w	(a3,d3.w*2),d6	; d([B]-B)
		sub.w	d1,d7		; B-b
		move.w	(a3,d7.w*2),d7	; d(B-b)
		move.w	d7,d1		;		HI
		swap	d1
		move.w	d7,d1		;		LO

		bfextu	d4{16:8},d3	; g
		bfextu	d0{16:8},d2	; G
		move.w	d2,d7		; G
		lsr.b	#4,d2
		bfins	d2,d4{16:4}	; r[G]b
		cmp.l	d4,d0
		bne.b	.notgmod\@

		or.b	#%00110000,d2
		move.l	d4,d1			; newRGB
		move.b	d2,d0			; Chunky
		bra	.raus\@

.notgmod\@	bfextu	d4{16:8},d2	; [G]
		sub.w	d7,d2		; [G]-G
		add.w	(a3,d2.w*2),d1	; d([G]-G)	LO
		sub.w	d3,d7		; G-g
		move.w	(a3,d7.w*2),d2	; d(G-g)
		swap	d1
		add.w	d2,d1		;		HI
		add.w	d2,d6

		move.l	d5,d3
		swap	d3		; r
		move.l	d0,d2
		swap	d2		; R
		move.w	d2,d7		; R
		lsr.b	#4,d2
		bfins	d2,d5{8:4}	; [R]gb
		cmp.l	d5,d0
		bne.b	.notrmod\@

		or.b	#%00100000,d2
		move.l	d5,d1			; newRGB
		move.b	d2,d0			; Chunky
		bra	.raus\@

.notrmod\@	move.l	d5,d2
		swap	d2		; [R]
		sub.w	d7,d2		; [R]-R
		add.w	(a3,d2.w*2),d1	; d([R]-R)	HI
		sub.w	d3,d7		; R-r
		move.w	(a3,d7.w*2),d2	; d(R-r)
		swap	d1
		add.w	d2,d1		;		LO
		add.w	d2,d6


		;	beste Modifikation ermitteln

		move.l	a6,d2			; BLAU neuer IST
		bfextu	d2{24:4},d3		; Modify-Blau-Anteil
		or.b	#%00010000,d3		; Blau-Modify

		cmp.w	d1,d6
		bls.b	.nG\@
		
		move.w	d1,d6			; neuer BEST
		move.l	d4,d2			; neuer IST
		bfextu	d2{16:4},d3		; Modify-Grün-Anteil
		or.b	#%00110000,d3		; Grün-Modify
		
.nG\@		swap	d1
		cmp.w	d1,d6
		bls.b	.nR\@
		
		move.w	d1,d6			; neuer BEST
		move.l	d5,d2			; neuer IST
		bfextu	d2{8:4},d3		; Modify-Rot-Anteil
		or.b	#%00100000,d3		; Rot-Modify

.nR\@
		;	Sieger feststellen

		move.l	d2,d1
.first\@	move.l	d0,d7				; RGB merken
		sf	(conv_firstpixel,a5)

		and.l	#$ffffff,d0			;!!!

		move.l	(conv_p2HAM1,a5),d5
		lsr.l	d5,d0
		lsl.b	d5,d0
		lsl.w	d5,d0
		swap	d5
		lsr.l	d5,d0

	;	lea	(conv_p2HAM1,a5),a6
	;	move.w	(a6)+,d5
	;	bfextu	d0{16:d5},d2			; Index auf p2Table berechnen
	;	move.w	(a6)+,d4
	;	lsr.l	d4,d0
	;	move.w	(a6)+,d4
	;	bfins	d0,d2{d4:d5}
	;	move.w	(a6)+,d4
	;	bfins	d0,d2{d4:d5}

		lea	([conv_p2table,a5],d0.l),a6

		move.w	(a6),d0				; Eintrag holen
		bmi.b	.fndpal\@			; nicht gültig

		;	Eintrag ist gültig.
		;	Diversität ausrechnen

		and.w	#$ff,d0

		move.l	(a2,d0.w*4),d2			; newRGB

		swap	d0
		moveq	#0,d5
		move.b	d2,d5
		moveq	#0,d4
		move.b	d7,d4
		sub.w	d4,d5
		move.w	(a3,d5.w*2),d0
		bfextu	d2{16:8},d5
		bfextu	d7{16:8},d4
		sub.w	d4,d5
		add.w	(a3,d5.w*2),d0
		move.l	d7,d4
		swap	d4
		move.l	d2,d5
		swap	d5
		sub.w	d4,d5
		add.w	(a3,d5.w*2),d0

		cmp.w	d0,d6			; besser als Modifikation?
		bls.b	.usemod\@		; nein

		swap	d0			; Pen
		move.l	d2,d1			; newRGB
		move.b	(conv_pentab,a5,d0.w),d0
		bra.b	.raus\@

.fndpal\@	move.l	d7,d0
		movem.l	d1/d2/d3/d6/a2/a3,-(a7)

		move.l	(conv_wordpalette,a5),a2
		move.w	(conv_numcolors,a5),d4
		FINDPEN_PALETTE
		movem.l	(a7)+,d1/d2/d3/d6/a2/a3

		move.w	d0,(a6)			; immer eintragen

		swap	d0

		cmp.w	d0,d6			; besser als Modifikation?
		bls.b	.usemod\@		; nein

		swap	d0			; Pen
		move.l	(a2,d0.w*4),d1		; newRGB
		move.b	(conv_pentab,a5,d0.w),d0
		bra.b	.raus\@

.usemod\@	move.b	d3,d0			; Chunky

.raus\@
			ENDM

;---------------------------------------------------------------------

	ENDC
