
	IFND MAPPING_I
MAPPING_I	SET	1

		INCLUDE	exec/semaphores.i

;====================================================================
;--------------------------------------------------------------------
;
;		CreateMappingEngine
;
;		erzeugt eine Mapping-Engine für RGB-Daten.
;
;	>	a0	Palette
;		a1	Taglist
;	<	d0	MappingEngine oder NULL
;
;	Tags	RND_RMHandler	- Default: der der Palette
;
;		RND_Histogram	- Linkt ein Histogramm ein eine MappingEngine
;
;		- Die Mapping-Engine erhält die Auflösung der Palette.
;
;		- Wird ein Histogramm an eine Mapping-Engine gekoppelt, so
;		muß es dieselbe Auflösung haben wie die Palette und vom
;		Typ TURBO sein. Die Mapping-Engine prüft, ob im Histogramm
;		Einträge hinzugekommen sind. Weil Histogramme nur wachsen können,
;		werden die fehlenden Einträge in der p1Table einfach ergänzt.
;
;		- Wenn kein Histogramm angegeben wird: Wenn sich
;		die Palette ändert, wird immer der komplette Farbraum
;		der p1Table berechnet. Hat die Palette eine gültige p2Table,
;		so werden ihre Daten übernommen und auch aktualisiert.
;
;		Implementierung: Paletten haben einen ListHeader,
;		die Mapping-Engines werden als Nodes eingeklinkt.
;		Ändert sich die Palette, werden die Nodes auf
;		'modified' gesetzt.
;
;--------------------------------------------------------------------

CreateMappingEngine:

		Lock		pal_semaphore(a0)

		movem.l	a0-a6/d1-d7,-(a7)
		
		move.l	a0,a2			; Palette
		move.l	a1,a3			; Taglist

		move.w	(pal_bitspergun,a2),d6	; Bitspergun

		move.l	(utilitybase,pc),a6

		GetTag	#RND_Histogram,#0,a3
		move.l	d0,a4			; Histogramm
		tst.l	d0
		beq.b	.nohist

		moveq	#0,d6
		move.b	(dhisto_type,a4),d6	; Bitspergun aus dem Histogramm
		bclr	#4,d6
		beq	.fail			; nur Turbohistogramme zulässig!

.nohist		move.l	(pal_memhandler,a2),d7
		GetTag	#RND_RMHandler,d7,a3
		move.l	d0,d5			; Memhandler

		move.l	d5,a0
		move.l	#map_SIZEOF,d0
		bsr	AllocRenderVec
		move.l	d0,a5
		tst.l	d0
		beq	.fail

	
		move.l	#-1,(map_numentries,a5)
		clr.l	(map_bitarray,a5)
		clr.l	(map_p1table,a5)
		st	(map_modified,a5)
		move.l	a2,(map_palette,a5)
		move.l	a4,(map_histogram,a5)
		move.l	d5,(map_memhandler,a5)
		move.w	d6,(map_bitspergun,a5)

		move.l	(execbase,pc),a6
		lea	(map_semaphore,a5),a0
		move.l	a0,a1
		moveq	#SS_SIZE/2-1,d0
.clrsl		clr.w	(a1)+
		dbf	d0,.clrsl
		jsr	(_LVOInitSemaphore,a6)

		move.l	(map_memhandler,a5),a0
		move.w	(map_bitspergun,a5),d0
		move.w	d0,d1
		add.w	d0,d1
		add.w	d0,d1			; Bits gesamt
		moveq	#1,d2
		lsl.l	d1,d2			; Bytes gesamt (p1Table)
		move.l	d2,d0
		bsr	AllocRenderVec
		move.l	d0,(map_p1table,a5)
		tst.l	d0
		beq.b	.fail


		tst.l	(map_histogram,a5)
		beq.b	.nohisto

		lsr.l	#3,d2			; Bytes für Bitarray
		move.l	d2,(map_bitarraysize,a5)
		move.l	d2,d0
		move.l	(map_memhandler,a5),a0
		bsr	AllocRenderVec
		move.l	d0,(map_bitarray,a5)
		tst.l	d0
		beq.b	.fail

		move.l	d0,a0
		move.l	d2,d0
		moveq	#0,d1
		bsr	TurboFillMem		; Bitarray zurücksetzen


.nohisto	lea	(map_node,a5),a1
		lea	([map_palette,a5],pal_maplist),a0
		ADDTAIL				; In Palette einklinken


	;	move.l	a5,a0
	;	bsr	UpdateMappingEngine	; Histogramm schon jetzt Updaten

	
		move.l	a5,d7
		bra.b	.raus

.fail		move.l	a5,d0
		beq.b	.nostruc

		move.l	d0,a0
		bsr	DeleteMappingEngine

.nostruc	moveq	#0,d7			; Fehler


.raus		move.l	d7,d0
		movem.l	(a7)+,a0-a6/d1-d7

		Unlock		pal_semaphore(a0)
		rts

;====================================================================



;--------------------------------------------------------------------
;
;		UpdateMappingEngine
;
;	>	a0	Mapping-Engine
;	<	d0	success
;
;		- die Mapping-Engine sollte exklusiv gelockt sein.
;
;		- das Histogramm muß die gleiche Auflösung haben
;		  wie die Palette
;
;		- Fehlerursachen: 
;		  - kein Speicher für p2table der richtigen Auflösung
;		  - kein Speicher für Turbo-Histogramm
;		  - weniger als 2 Farben in der Palette
;
;--------------------------------------------------------------------

UpdateMappingEngine:

		movem.l	d1/a0/a1/a5/d7,-(a7)

		moveq	#-1,d7				; SUCCESS

		move.l	a0,a5

		move.l	(map_palette,a5),a0
		Lock		pal_semaphore(a0)


		tst.b	(map_modified,a5)
		beq.b	.palette_ok			; FALSE

		tst.l	(map_histogram,a5)
		beq.b	.nohisto

		; ein Histogramm ist vorhanden, und die Palette hat sich
		; geändert: Bitarray zurücksetzen

		move.l	(map_bitarray,a5),a0
		move.l	(map_bitarraysize,a5),d0
		moveq	#0,d1
		bsr	TurboFillMem
		bra.b	.palette_ok


.nohisto	; kein Histogramm vorhanden, und die Palette hat sich
		; geändert: p1Table neu berechnen

		move.l	a5,a0
		bsr	map_updatep1table
		sf	(map_modified,a5)	; p1Table jetzt up-to-date


.palette_ok	move.l	(map_histogram,a5),d0
		beq.b	.nohisto2

		; sind neue Einträge im Histogramm hinzugekommen?
		; Diese müssen in der p1Table geupdatet werden

		move.l	d0,a0
		LockShared	dhisto_semaphore(a0)

		bsr	CountHistogram
		cmp.l	#NUMCOLORS_NOT_DEFINED,d0
		bne.b	.notundefined
		moveq	#0,d0
.notundefined	cmp.l	(map_numentries,a5),d0
		beq.b	.histonochange

		move.l	d0,(map_numentries,a5)

		move.l	(map_histogram,a5),a0
		bsr	MakeTurboHistogram
		move.l	d0,d7
		beq.b	.histofail

		move.l	d0,a1
		move.l	a5,a0	

		bsr.b	map_updatebitarray
		move.l	d0,d7
		sf	(map_modified,a5)	; p1Table jetzt up-to-date

.histofail

.histonochange	move.l	(map_histogram,a5),a0
		Unlock		dhisto_semaphore(a0)

.nohisto2	move.l	(map_palette,a5),a0
		Unlock		pal_semaphore(a0)

		move.l	d7,d0
		movem.l	(a7)+,d1/a0/a1/a5/d7
		rts


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;	>	a0	Mapping-Engine
;		a1	Turbohistogramm oder NULL
;	<	d0	success
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

map_updatebitarray:

		movem.l	d1-d7/a0-a6,-(a7)

		move.l	a0,a3

		moveq	#0,d7

		move.l	(map_bitarray,a3),d0
		beq	.raus		
		move.l	d0,a2
		move.l	(map_p1table,a3),d0
		beq	.raus		
		move.l	d0,a4
	;!	lea	(map_pentable,a3),a5
		move.l	(map_palette,a3),a6
		move.w	(map_bitspergun,a3),d4

		cmp.w	#2,(pal_numcolors,a6)	; keine Farben?
		blt.b	.raus

		lea	(.updbarray,pc),a3

		move.l	a6,a0
		;	bsr	PAL_AttemptP2Table
		bsr	PAL_CreateP2Table
		tst.l	d0
		beq.b	.nop2tab

		move.l	d0,d6
				
		cmp.w	(pal_p2bitspergun,a6),d4
		bne.b	.nop2tab

		lea	(.updbarrayp2,pc),a3	; p1 + bitarray + p2 updaten


.nop2tab	move.w	d4,d0			; Bitspergun
		move.l	a3,a0			; Funktion
		move.l	d6,a3			; p2table
		moveq	#7,d7
		TABLEEXECUTE

		moveq	#-1,d7

.raus		move.l	d7,d0
		movem.l	(a7)+,d1-d7/a0-a6
		rts


.updbarray	tst.l	(a1)+
		beq.b	.nocheck		; kein Eintrag im Histogramm

		bset	d7,(a2)			; Bit setzen und testen
		bne.b	.nocheck		; schon ein Eintrag im Bitfeld

		movem.l	d0-d7/a2,-(a7)
		lea	(pal_wordpalette,a6),a2
		move.w	(pal_numcolors,a6),d4
		lea	(quadtab,pc),a3
		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]¹
		move.b	d0,(a4)			; eintragen
		movem.l	(a7)+,d0-d7/a2

.nocheck	addq.w	#1,a4
		subq.w	#1,d7
		bpl.b	.bitok
		moveq	#7,d7
		addq.w	#1,a2
.bitok		rts



.updbarrayp2	tst.l	(a1)+
		beq.b	.nocheck2		; kein Eintrag im Histogramm

		bset	d7,(a2)			; Bit setzen und testen
		bne.b	.nocheck2		; schon ein Eintrag im Bitfeld

	;	move.w	(a3),d6			; Eintrag in p2Table
	;	bpl.b	.entry

		movem.l	d0-d5/d7/a2/a3,-(a7)
		lea	(pal_wordpalette,a6),a2
		move.w	(pal_numcolors,a6),d4
		lea	(quadtab,pc),a3
		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]¹
		move.w	d0,d6
		movem.l	(a7)+,d0-d5/d7/a2/a3

		move.b	d6,(a4)			; eintragen

.entry		move.w	d6,(a3)			; Zusätzlich in p2tab eintragen

.nocheck2	addq.w	#1,a4
		addq.w	#2,a3
		subq.w	#1,d7
		bpl.b	.bitok2
		moveq	#7,d7
		addq.w	#1,a2
.bitok2		rts


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;		berechnet die p1table einer Mapping-Engine neu.
;		ist eine gültige p2table vorhanden, werden ihre
;		Daten übernommen. Der gesamte Farbraum wird
;		aktualisiert, und die Daten werden auch der
;		ggf. vorhandenen p2Table zurückgeführt.
;
;	>	a0	Mapping-Engine
;	<	d0	success
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


map_updatep1table:
		movem.l	d1-d7/a0-a6,-(a7)

		moveq	#0,d7
		move.l	a0,a5			; Mapping-Engine
		move.l	(map_palette,a5),a0


		lea	(.updatep1only,pc),a6	; nur p1 updaten

		cmp.w	#2,(pal_numcolors,a0)	; weniger als 2 Farben?
		blt.b	.raus

		move.w	(map_bitspergun,a5),d4

		;	bsr	PAL_AttemptP2Table
		bsr	PAL_CreateP2Table
		tst.l	d0
		beq.b	.nop2tab
		move.l	d0,a4
		
		cmp.w	(pal_p2bitspergun,a0),d4
		bne.b	.nop2tab

		lea	(.updatep1p2,pc),a6	; p1+p2 updaten

.nop2tab	move.l	a6,a0			; Funktion

		move.w	d4,d0			; Bitspergun
		move.l	(map_p1table,a5),a1
		move.l	(map_palette,a5),a6
	;!	lea	(map_pentable,a5),a2

		TABLEEXECUTE

.raus		movem.l	(a7)+,d1-d7/a0-a6
		rts


		; berechnet p1Table und p2Table komplett
		; und übernimmt dabei vorhandene Daten aus der p2Table

.updatep1p2	move.w	(a4),d7
		bpl.b	.entry
		
		movem.l	d0-d5,-(a7)
		lea	(pal_wordpalette,a6),a2
		move.w	(pal_numcolors,a6),d4
		lea	(quadtab,pc),a3
		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]¹
		move.w	d0,d7
		movem.l	(a7)+,d0-d5

.entry		move.w	d7,(a4)+		; in p2tab updaten
		move.b	d7,(a1)+		; in p1tab ablegen
		rts


		; berechnet nur die p1Table

.updatep1only	movem.l	d0-d5,-(a7)
		lea	(pal_wordpalette,a6),a2
		move.w	(pal_numcolors,a6),d4
		lea	(quadtab,pc),a3
		FINDPEN_PALETTE			; trash: d1-d7/a2/[a3]¹
		move.w	d0,d7
		movem.l	(a7)+,d0-d5
		move.b	d7,(a1)+		; über Pentab konvertiert in p1tab ablegen
		rts

;--------------------------------------------------------------------



;====================================================================
;--------------------------------------------------------------------
;
;		DeleteMappingEngine
;
;	>	a0	Mapping-Engine
;
;--------------------------------------------------------------------

DeleteMappingEngine:

		move.l	a0,-(a7)

		move.l	([a7],map_palette),a0
		Lock		pal_semaphore(a0)

		lea	([a7],map_node),a1
		REMOVE

		move.l	([a7],map_palette),a0
		Unlock		pal_semaphore(a0)

		move.l	([a7],map_bitarray),d0
		beq.b	.nobarray
		move.l	d0,a0
		bsr	FreeRenderVec

.nobarray	move.l	([a7],map_p1table),d0
		beq.b	.nop1tab
		move.l	d0,a0
		bsr	FreeRenderVec

.nop1tab	move.l	(a7)+,a0
		bra	FreeRenderVec

;====================================================================




;====================================================================
;--------------------------------------------------------------------
;
;		MapRGBArray(engine,rgb,width,height,chunky,tags)
;
;	>	a0	Mapping-Engine
;		a1	RGB-Source
;		a2	Chunky-Dest
;		a3	Taglist
;		d0	Breite
;		d1	Höhe
;	<	d0	success	(CONV_SUCCESS / CONV_NOT_ENOUGH_MEMORY)
;
;		Tags:
;			RND_SourceWidth
;			RND_DestWidth
;			RND_PenTable
;
;--------------------------------------------------------------------

	STRUCTURE	maparr_localdata,0
		UWORD	maparr_width
		UWORD	maparr_height
		ULONG	maparr_sourcemodulo
		ULONG	maparr_destmodulo
		APTR	maparr_rgb
		APTR	maparr_chunky
		APTR	maparr_engine
		UWORD	maparr_width8
		UWORD	maparr_width1
	LABEL		maparr_SIZEOF		

;--------------------------------------------------------------------

MapRGBArray:
		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#maparr_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(maparr_engine,a5)
		move.l	a1,(maparr_rgb,a5)
		move.l	a2,(maparr_chunky,a5)
		move.w	d0,(maparr_width,a5)
		move.w	d1,(maparr_height,a5)

		moveq	#7,d1
		and.w	d0,d1
		subq.w	#1,d1
		move.w	d1,(maparr_width1,a5)
		lsr.w	#3,d0
		move.w	d0,(maparr_width8,a5)


		move.l	(utilitybase,pc),a6

		moveq	#0,d2
		move.w	(maparr_width,a5),d2

		GetTag	#RND_SourceWidth,d2,a3
		sub.l	d2,d0
		lsl.l	#2,d0
		move.l	d0,(maparr_sourcemodulo,a5)

		GetTag	#RND_DestWidth,d2,a3
		sub.l	d2,d0
		move.l	d0,(maparr_destmodulo,a5)

		GetTag	#RND_PenTable,#0,a3
		move.l	d0,a6



		move.l	(maparr_engine,a5),a0
		Lock	map_semaphore(a0)

		moveq	#CONV_NOT_ENOUGH_MEMORY,d7
		bsr	UpdateMappingEngine
		tst.l	d0
		beq.b	.raus

		move.l	(maparr_engine,a5),a0
		move.l	(map_p1table,a0),a2	; p1Table
		move.w	(map_bitspergun,a0),d0	; Auflösung der p1Table
		move.l	(maparr_rgb,a5),a0	; RGB
		move.l	(maparr_chunky,a5),a1	; Chunky


		move.l	a6,d1
		beq.b	.nopentab

		lea	(.map12p,pc),a4
		cmp.w	#4,d0
		beq.b	.ok
		lea	(.map15p,pc),a4
		cmp.w	#5,d0
		beq.b	.ok
		lea	(.map18p,pc),a4
		cmp.w	#6,d0
		beq.b	.ok
		illegal


.nopentab	lea	(.map12,pc),a4
		cmp.w	#4,d0
		beq.b	.ok
		lea	(.map15,pc),a4
		cmp.w	#5,d0
		beq.b	.ok
		lea	(.map18,pc),a4
		cmp.w	#6,d0
		beq.b	.ok
		illegal


.ok		jsr	(a4)

		moveq	#CONV_SUCCESS,d7

.raus
		move.l	(maparr_engine,a5),a0
		Unlock	map_semaphore(a0)

		move.l	d7,d0

		add.w	#maparr_SIZEOF,a7

		movem.l	(a7)+,d2-d7/a2-a6
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map12		move.w	(maparr_width8,a5),d0
		beq.w	.skip12_8
		move.w	d0,a3

.loop12_8
		move.l	(a0)+,d0
		lsr.l	#4,d0
		move.l	(a0)+,d1
		lsl.b	#4,d0
		move.l	(a0)+,d2
		lsr.l	#4,d1
		lsl.w	#4,d0
		move.l	(a0)+,d3
		lsl.b	#4,d1
		lsr.l	#4,d2
		move.l	(a0)+,d4
		lsl.b	#4,d2
		lsl.w	#4,d1
		move.l	(a0)+,d5
		lsr.l	#4,d3
		lsr.l	#4,d4
		move.l	(a0)+,d6
		lsl.b	#4,d3
		lsl.w	#4,d2
		move.l	(a0)+,d7
		lsr.l	#8,d0
		lsl.b	#4,d4
		lsl.w	#4,d3
		move.b	(a2,d0.l),d0
		lsr.l	#4,d5
		lsr.l	#8,d1
		lsl.w	#8,d0
		lsl.b	#4,d5
		move.b	(a2,d1.l),d0
		lsl.w	#4,d4
		lsr.l	#8,d2
		lsl.l	#8,d0
		lsr.l	#4,d6
		move.b	(a2,d2.l),d0
		lsr.l	#8,d3
		lsl.w	#4,d5
		lsl.l	#8,d0
		lsr.l	#8,d4
		move.b	(a2,d3.l),d0
		lsr.l	#4,d7
		lsr.l	#8,d5
		lsl.b	#4,d6
		move.b	(a2,d4.l),d1
		lsl.b	#4,d7
		lsl.w	#4,d6
		lsl.w	#8,d1
		lsl.w	#4,d7
		move.b	(a2,d5.l),d1
		lsr.l	#8,d6
		lsl.l	#8,d1
		lsr.l	#8,d7
		move.b	(a2,d6.l),d1
		lsl.l	#8,d1
		move.b	(a2,d7.l),d1

		move.l	d0,(a1)+
		subq.w	#1,a3
		move.l	d1,(a1)+

		move.w	a3,d3
		bne.w	.loop12_8

.skip12_8	move.w	(maparr_width1,a5),d1
		bmi.b	.skip12_1

.lop12_1	move.l	(a0)+,d0
		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0
		move.b	(a2,d0.l),(a1)+
		dbf	d1,.lop12_1

.skip12_1	add.l	(maparr_sourcemodulo,a5),a0
		add.l	(maparr_destmodulo,a5),a1
		subq.w	#1,(maparr_height,a5)
		bne	.map12
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map15		move.w	(maparr_width8,a5),d0
		beq.b	.skip15_8
		move.w	d0,a3

.loop15_8	move.l	(a0)+,d0
		lsr.l	#3,d0
		move.l	(a0)+,d1
		lsl.b	#3,d0
		move.l	(a0)+,d2
		lsr.l	#3,d1
		lsl.w	#3,d0
		move.l	(a0)+,d3
		lsl.b	#3,d1
		lsr.l	#3,d2
		move.l	(a0)+,d4
		lsl.b	#3,d2
		lsl.w	#3,d1
		move.l	(a0)+,d5
		lsr.l	#3,d3
		lsr.l	#3,d4
		move.l	(a0)+,d6
		lsl.b	#3,d3
		lsl.w	#3,d2
		move.l	(a0)+,d7
		lsr.l	#6,d0
		lsl.b	#3,d4
		lsl.w	#3,d3
		move.b	(a2,d0.l),(a1)+
		lsr.l	#3,d5
		lsr.l	#6,d1
		lsl.b	#3,d5
		move.b	(a2,d1.l),(a1)+
		lsl.w	#3,d4
		lsr.l	#6,d2
		lsr.l	#3,d6
		move.b	(a2,d2.l),(a1)+
		lsr.l	#6,d3
		lsl.w	#3,d5
		lsr.l	#6,d4
		move.b	(a2,d3.l),(a1)+		
		lsr.l	#3,d7
		lsr.l	#6,d5
		lsl.b	#3,d6
		move.b	(a2,d4.l),(a1)+		
		lsl.b	#3,d7
		lsl.w	#3,d6
		lsl.w	#3,d7
		move.b	(a2,d5.l),(a1)+		
		lsr.l	#6,d6
		lsr.l	#6,d7
		move.b	(a2,d6.l),(a1)+
		subq.w	#1,a3
		move.b	(a2,d7.l),(a1)+		
		move.w	a3,d3
		bne.b	.loop15_8

.skip15_8	move.w	(maparr_width1,a5),d1
		bmi.b	.skip15_1

.lop15_1	move.l	(a0)+,d0
		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0
		move.b	(a2,d0.l),(a1)+
		dbf	d1,.lop15_1

.skip15_1	add.l	(maparr_sourcemodulo,a5),a0
		add.l	(maparr_destmodulo,a5),a1
		subq.w	#1,(maparr_height,a5)
		bne	.map15
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map18		move.w	(maparr_width8,a5),d0
		beq.b	.skip18_8
		move.w	d0,a3

.loop18_8	move.l	(a0)+,d0
		lsr.l	#2,d0
		move.l	(a0)+,d1
		lsl.b	#2,d0
		move.l	(a0)+,d2
		lsr.l	#2,d1
		lsl.w	#2,d0
		move.l	(a0)+,d3
		lsl.b	#2,d1
		lsr.l	#2,d2
		move.l	(a0)+,d4
		lsl.b	#2,d2
		lsl.w	#2,d1
		move.l	(a0)+,d5
		lsr.l	#2,d3
		lsr.l	#2,d4
		move.l	(a0)+,d6
		lsl.b	#2,d3
		lsl.w	#2,d2
		move.l	(a0)+,d7
		lsr.l	#4,d0
		lsl.b	#2,d4
		lsl.w	#2,d3
		move.b	(a2,d0.l),(a1)+
		lsr.l	#2,d5
		lsr.l	#4,d1
		lsl.b	#2,d5
		move.b	(a2,d1.l),(a1)+
		lsl.w	#2,d4
		lsr.l	#4,d2
		lsr.l	#2,d6
		move.b	(a2,d2.l),(a1)+
		lsr.l	#4,d3
		lsl.w	#2,d5
		lsr.l	#4,d4
		move.b	(a2,d3.l),(a1)+		
		lsr.l	#2,d7
		lsr.l	#4,d5
		lsl.b	#2,d6
		move.b	(a2,d4.l),(a1)+		
		lsl.b	#2,d7
		lsl.w	#2,d6
		lsl.w	#2,d7
		move.b	(a2,d5.l),(a1)+		
		lsr.l	#4,d6
		lsr.l	#4,d7
		move.b	(a2,d6.l),(a1)+
		subq.w	#1,a3
		move.b	(a2,d7.l),(a1)+		
		move.w	a3,d3
		bne.b	.loop18_8

.skip18_8	move.w	(maparr_width1,a5),d1
		bmi.b	.skip18_1

.lop18_1	move.l	(a0)+,d0
		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0
		move.b	(a2,d0.l),(a1)+
		dbf	d1,.lop18_1

.skip18_1	add.l	(maparr_sourcemodulo,a5),a0
		add.l	(maparr_destmodulo,a5),a1
		subq.w	#1,(maparr_height,a5)
		bne	.map18
		rts


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map12p		move.w	(maparr_width8,a5),d0
		beq	.skip12p_8
		move.w	d0,a3

.loop12p_8

		movem.l	(a0)+,d0-d7

		lsr.l	#4,d0
		lsr.l	#4,d1
		lsr.l	#4,d2
		lsr.l	#4,d3
		lsr.l	#4,d4
		lsr.l	#4,d5
		lsr.l	#4,d6
		lsr.l	#4,d7

		lsl.b	#4,d0
		lsl.b	#4,d1
		lsl.b	#4,d2
		lsl.b	#4,d3
		lsl.b	#4,d4
		lsl.b	#4,d5
		lsl.b	#4,d6
		lsl.b	#4,d7

		lsl.w	#4,d0
		lsl.w	#4,d1
		lsl.w	#4,d2
		lsl.w	#4,d3
		lsl.w	#4,d4
		lsl.w	#4,d5
		lsl.w	#4,d6
	lsr.l	#8,d0
		lsl.w	#4,d7

		move.b	(a2,d0.l),d0
	lsr.l	#8,d1
		and.w	#$00ff,d0
		move.b	(a2,d1.l),d1
	lsr.l	#8,d2
		and.w	#$00ff,d1
		move.b	(a2,d2.l),d2
	lsr.l	#8,d3
		and.w	#$00ff,d2
		move.b	(a2,d3.l),d3
	lsr.l	#8,d4
		and.w	#$00ff,d3
		move.b	(a2,d4.l),d4
	lsr.l	#8,d5
		and.w	#$00ff,d4
		move.b	(a2,d5.l),d5
	lsr.l	#8,d6
		and.w	#$00ff,d5
		move.b	(a2,d6.l),d6
	lsr.l	#8,d7
		and.w	#$00ff,d6
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d7

		move.b	(a6,d0.w),d0
		move.b	(a6,d1.w),d1
		move.b	(a6,d2.w),d2
		move.b	(a6,d3.w),d3
		move.b	(a6,d4.w),d4
		move.b	(a6,d5.w),d5
		move.b	(a6,d6.w),d6
		move.b	(a6,d7.w),d7

		move.b	d0,(a1)+
		move.b	d1,(a1)+
		move.b	d2,(a1)+
		move.b	d3,(a1)+
		move.b	d4,(a1)+
		move.b	d5,(a1)+
		move.b	d6,(a1)+
	subq.w	#1,a3
		move.b	d7,(a1)+

		
		


	IFNE	0
		move.l	(a0)+,d0
		lsr.l	#4,d0
		move.l	(a0)+,d1
		lsl.b	#4,d0
		move.l	(a0)+,d2
		lsr.l	#4,d1
		lsl.w	#4,d0
		move.l	(a0)+,d3
		lsl.b	#4,d1
		lsr.l	#4,d2
		move.l	(a0)+,d4
		lsl.b	#4,d2
		lsl.w	#4,d1
		move.l	(a0)+,d5
		lsr.l	#4,d3
		lsr.l	#4,d4
		move.l	(a0)+,d6
		lsl.b	#4,d3
		lsl.w	#4,d2
		move.l	(a0)+,d7
		lsr.l	#8,d0
		lsl.b	#4,d4
		lsl.w	#4,d3
		move.b	(a2,d0.l),d0
		lsr.l	#4,d5
		lsr.l	#8,d1
		lsl.b	#4,d5
		move.b	(a2,d1.l),d1
		lsl.w	#4,d4
		lsr.l	#8,d2
		lsr.l	#4,d6
		move.b	(a2,d2.l),d2
		lsr.l	#8,d3
		lsl.w	#4,d5
		lsr.l	#8,d4
		move.b	(a2,d3.l),d3
		lsr.l	#4,d7
		lsr.l	#8,d5
		lsl.b	#4,d6
		move.b	(a2,d4.l),d4
		lsl.b	#4,d7
		lsl.w	#4,d6
		lsl.w	#4,d7
		move.b	(a2,d5.l),d5
		lsr.l	#8,d6
		lsr.l	#8,d7
		move.b	(a2,d6.l),d6
		subq.w	#1,a3
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0

		move.b	(a6,d0.w),d0
		and.w	#$00ff,d1
		lsl.w	#8,d0
		and.w	#$00ff,d2
		move.b	(a6,d1.w),d0
		and.w	#$00ff,d3
		lsl.l	#8,d0
		and.w	#$00ff,d4
		move.b	(a6,d2.w),d0
		and.w	#$00ff,d5
		lsl.l	#8,d0
		and.w	#$00ff,d6
		move.b	(a6,d3.w),d0

		and.w	#$00ff,d7

		move.b	(a6,d4.w),d1
		lsl.w	#8,d1
		move.b	(a6,d5.w),d1
		lsl.l	#8,d1
		move.b	(a6,d6.w),d1
		lsl.l	#8,d1
		move.b	(a6,d7.w),d1

		move.l	d0,(a1)+
		move.l	d1,(a1)+

	ENDC
		
		move.w	a3,d3
		bne	.loop12p_8

.skip12p_8	move.w	(maparr_width1,a5),d1
		bmi.b	.skip12p_1

		move.w	#$00ff,d2
.lop12p_1	move.l	(a0)+,d0
		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.lop12p_1

.skip12p_1	add.l	(maparr_sourcemodulo,a5),a0
		add.l	(maparr_destmodulo,a5),a1
		subq.w	#1,(maparr_height,a5)
		bne	.map12p
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map15p		move.w	(maparr_width8,a5),d0
		beq	.skip15p_8
		move.w	d0,a3

.loop15p_8	move.l	(a0)+,d0
		lsr.l	#3,d0
		move.l	(a0)+,d1
		lsl.b	#3,d0
		move.l	(a0)+,d2
		lsr.l	#3,d1
		lsl.w	#3,d0
		move.l	(a0)+,d3
		lsl.b	#3,d1
		lsr.l	#3,d2
		move.l	(a0)+,d4
		lsl.b	#3,d2
		lsl.w	#3,d1
		move.l	(a0)+,d5
		lsr.l	#3,d3
		lsr.l	#3,d4
		move.l	(a0)+,d6
		lsl.b	#3,d3
		lsl.w	#3,d2
		move.l	(a0)+,d7
		lsr.l	#6,d0
		lsl.b	#3,d4
		lsl.w	#3,d3
		move.b	(a2,d0.l),d0
		lsr.l	#3,d5
		lsr.l	#6,d1
		lsl.b	#3,d5
		move.b	(a2,d1.l),d1
		lsl.w	#3,d4
		lsr.l	#6,d2
		lsr.l	#3,d6
		move.b	(a2,d2.l),d2
		lsr.l	#6,d3
		lsl.w	#3,d5
		lsr.l	#6,d4
		move.b	(a2,d3.l),d3
		lsr.l	#3,d7
		lsr.l	#6,d5
		lsl.b	#3,d6
		move.b	(a2,d4.l),d4
		lsl.b	#3,d7
		lsl.w	#3,d6
		lsl.w	#3,d7
		move.b	(a2,d5.l),d5
		lsr.l	#6,d6
		lsr.l	#6,d7
		move.b	(a2,d6.l),d6
		subq.w	#1,a3
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		move.b	(a6,d7.w),(a1)+

		move.w	a3,d3
		bne	.loop15p_8

.skip15p_8	move.w	(maparr_width1,a5),d1
		bmi.b	.skip15p_1

		move.w	#$00ff,d2
.lop15p_1	move.l	(a0)+,d0
		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.lop15p_1

.skip15p_1	add.l	(maparr_sourcemodulo,a5),a0
		add.l	(maparr_destmodulo,a5),a1
		subq.w	#1,(maparr_height,a5)
		bne	.map15p
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map18p		move.w	(maparr_width8,a5),d0
		beq	.skip18p_8
		move.w	d0,a3

.loop18p_8	move.l	(a0)+,d0
		lsr.l	#2,d0
		move.l	(a0)+,d1
		lsl.b	#2,d0
		move.l	(a0)+,d2
		lsr.l	#2,d1
		lsl.w	#2,d0
		move.l	(a0)+,d3
		lsl.b	#2,d1
		lsr.l	#2,d2
		move.l	(a0)+,d4
		lsl.b	#2,d2
		lsl.w	#2,d1
		move.l	(a0)+,d5
		lsr.l	#2,d3
		lsr.l	#2,d4
		move.l	(a0)+,d6
		lsl.b	#2,d3
		lsl.w	#2,d2
		move.l	(a0)+,d7
		lsr.l	#4,d0
		lsl.b	#2,d4
		lsl.w	#2,d3
		move.b	(a2,d0.l),d0
		lsr.l	#2,d5
		lsr.l	#4,d1
		lsl.b	#2,d5
		move.b	(a2,d1.l),d1
		lsl.w	#2,d4
		lsr.l	#4,d2
		lsr.l	#2,d6
		move.b	(a2,d2.l),d2
		lsr.l	#4,d3
		lsl.w	#2,d5
		lsr.l	#4,d4
		move.b	(a2,d3.l),d3
		lsr.l	#2,d7
		lsr.l	#4,d5
		lsl.b	#2,d6
		move.b	(a2,d4.l),d4
		lsl.b	#2,d7
		lsl.w	#2,d6
		lsl.w	#2,d7
		move.b	(a2,d5.l),d5
		lsr.l	#4,d6
		lsr.l	#4,d7
		move.b	(a2,d6.l),d6
		subq.w	#1,a3
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		move.b	(a6,d7.w),(a1)+

		move.w	a3,d3
		bne	.loop18p_8

.skip18p_8	move.w	(maparr_width1,a5),d1
		bmi.b	.skip18p_1

		move.w	#$00ff,d2
.lop18p_1	move.l	(a0)+,d0
		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.lop18p_1

.skip18p_1	add.l	(maparr_sourcemodulo,a5),a0
		add.l	(maparr_destmodulo,a5),a1
		subq.w	#1,(maparr_height,a5)
		bne	.map18p
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 



;====================================================================


;====================================================================
;--------------------------------------------------------------------
;
;		MapChunkyArray(engine,source,palette,width,height,dest,tags)
;
;	>	a0	Mapping-Engine
;		a1	Chunky-Source
;		a2	Source-Palette
;		a3	Chunky-Dest
;		a4	Taglist
;		d0	Breite
;		d1	Höhe
;	<	d0	success	(CONV_SUCCESS / CONV_NOT_ENOUGH_MEMORY)
;
;		Tags:
;			RND_SourceWidth
;			RND_DestWidth
;			RND_PenTable
;
;--------------------------------------------------------------------

	STRUCTURE	mapcha_localdata,0
		UWORD	mapcha_width
		UWORD	mapcha_height
		ULONG	mapcha_sourcemodulo
		ULONG	mapcha_destmodulo
		APTR	mapcha_source
		APTR	mapcha_sourcepalette
		APTR	mapcha_dest
		APTR	mapcha_engine
		UWORD	mapcha_width8
		UWORD	mapcha_width1
	LABEL		mapcha_SIZEOF		

;--------------------------------------------------------------------

MapChunkyArray:
		movem.l	d2-d7/a2-a6,-(a7)

		sub.w	#mapcha_SIZEOF,a7
		move.l	a7,a5

		move.l	a0,(mapcha_engine,a5)
		move.l	a1,(mapcha_source,a5)
		move.l	a2,(mapcha_sourcepalette,a5)
		move.l	a3,(mapcha_dest,a5)
		move.w	d0,(mapcha_width,a5)
		move.w	d1,(mapcha_height,a5)

		moveq	#7,d1
		and.w	d0,d1
		subq.w	#1,d1
		move.w	d1,(mapcha_width1,a5)
		lsr.w	#3,d0
		move.w	d0,(mapcha_width8,a5)


		move.l	(utilitybase,pc),a6

		moveq	#0,d2
		move.w	(mapcha_width,a5),d2

		GetTag	#RND_SourceWidth,d2,a4
		sub.l	d2,d0
		lsl.l	#2,d0
		move.l	d0,(mapcha_sourcemodulo,a5)

		GetTag	#RND_DestWidth,d2,a4
		sub.l	d2,d0
		move.l	d0,(mapcha_destmodulo,a5)

		GetTag	#RND_PenTable,#0,a4
		move.l	d0,a6



		move.l	(mapcha_engine,a5),a0
		Lock	map_semaphore(a0)

		moveq	#CONV_NOT_ENOUGH_MEMORY,d7
		bsr	UpdateMappingEngine
		tst.l	d0
		beq.b	.raus

		move.l	(mapcha_engine,a5),a0
		move.l	(map_p1table,a0),a2	; p1Table
		move.w	(map_bitspergun,a0),d0	; Auflösung der p1Table
		move.l	(mapcha_source,a5),a0	; Chunky
		move.l	(mapcha_dest,a5),a1	; Chunky


		move.l	a6,d1
		beq.b	.nopentab

		lea	(.map12p,pc),a4
		cmp.w	#4,d0
		beq.b	.ok
		lea	(.map15p,pc),a4
		cmp.w	#5,d0
		beq.b	.ok
		lea	(.map18p,pc),a4
		cmp.w	#6,d0
		beq.b	.ok
		illegal


.nopentab	lea	(.map12,pc),a4
		cmp.w	#4,d0
		beq.b	.ok
		lea	(.map15,pc),a4
		cmp.w	#5,d0
		beq.b	.ok
		lea	(.map18,pc),a4
		cmp.w	#6,d0
		beq.b	.ok
		illegal


.ok		move.l	a4,d6
		lea	([mapcha_sourcepalette,a5],pal_palette),a4
		jsr	(d6.l)

		moveq	#CONV_SUCCESS,d7

.raus
		move.l	(mapcha_engine,a5),a0
		Unlock	map_semaphore(a0)

		move.l	d7,d0

		add.w	#mapcha_SIZEOF,a7

		movem.l	(a7)+,d2-d7/a2-a6
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map12		move.w	(mapcha_width8,a5),d0
		beq	.skip12_8
		move.w	d0,a3

.loop12_8	moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		move.l	(a4,d2.w*4),d2
		move.l	(a4,d3.w*4),d3
		move.l	(a4,d4.w*4),d4
		move.l	(a4,d5.w*4),d5
		move.l	(a4,d6.w*4),d6
		move.l	(a4,d7.w*4),d7

		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0

		lsr.l	#4,d1
		lsl.b	#4,d1
		lsl.w	#4,d1
		lsr.l	#8,d1

		lsr.l	#4,d2
		lsl.b	#4,d2
		lsl.w	#4,d2
		lsr.l	#8,d2

		lsr.l	#4,d3
		lsl.b	#4,d3
		lsl.w	#4,d3
		lsr.l	#8,d3

		lsr.l	#4,d4
		lsl.b	#4,d4
		lsl.w	#4,d4
		lsr.l	#8,d4

		lsr.l	#4,d5
		lsl.b	#4,d5
		lsl.w	#4,d5
		lsr.l	#8,d5

		lsr.l	#4,d6
		lsl.b	#4,d6
		lsl.w	#4,d6
		lsr.l	#8,d6

		lsr.l	#4,d7
		lsl.b	#4,d7
		lsl.w	#4,d7
		lsr.l	#8,d7

		move.b	(a2,d0.l),(a1)+
		move.b	(a2,d1.l),(a1)+
		move.b	(a2,d2.l),(a1)+
		move.b	(a2,d3.l),(a1)+
		move.b	(a2,d4.l),(a1)+
		move.b	(a2,d5.l),(a1)+
		move.b	(a2,d6.l),(a1)+
		move.b	(a2,d7.l),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop12_8

.skip12_8	move.w	(mapcha_width1,a5),d1
		bmi.b	.skip12_1

		moveq	#0,d2
.lop12_1	move.b	(a0)+,d2
		move.l	(a4,d2.w*4),d0
		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0
		move.b	(a2,d0.l),(a1)+
		dbf	d1,.lop12_1

.skip12_1	add.l	(mapcha_sourcemodulo,a5),a0
		add.l	(mapcha_destmodulo,a5),a1
		subq.w	#1,(mapcha_height,a5)
		bne	.map12
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map15		move.w	(mapcha_width8,a5),d0
		beq	.skip15_8
		move.w	d0,a3

.loop15_8	moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		move.l	(a4,d2.w*4),d2
		move.l	(a4,d3.w*4),d3
		move.l	(a4,d4.w*4),d4
		move.l	(a4,d5.w*4),d5
		move.l	(a4,d6.w*4),d6
		move.l	(a4,d7.w*4),d7

		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0

		lsr.l	#3,d1
		lsl.b	#3,d1
		lsl.w	#3,d1
		lsr.l	#6,d1

		lsr.l	#3,d2
		lsl.b	#3,d2
		lsl.w	#3,d2
		lsr.l	#6,d2

		lsr.l	#3,d3
		lsl.b	#3,d3
		lsl.w	#3,d3
		lsr.l	#6,d3

		lsr.l	#3,d4
		lsl.b	#3,d4
		lsl.w	#3,d4
		lsr.l	#6,d4

		lsr.l	#3,d5
		lsl.b	#3,d5
		lsl.w	#3,d5
		lsr.l	#6,d5

		lsr.l	#3,d6
		lsl.b	#3,d6
		lsl.w	#3,d6
		lsr.l	#6,d6

		lsr.l	#3,d7
		lsl.b	#3,d7
		lsl.w	#3,d7
		lsr.l	#6,d7

		move.b	(a2,d0.l),(a1)+
		move.b	(a2,d1.l),(a1)+
		move.b	(a2,d2.l),(a1)+
		move.b	(a2,d3.l),(a1)+
		move.b	(a2,d4.l),(a1)+
		move.b	(a2,d5.l),(a1)+
		move.b	(a2,d6.l),(a1)+
		move.b	(a2,d7.l),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop15_8

.skip15_8	move.w	(mapcha_width1,a5),d1
		bmi.b	.skip15_1

		moveq	#0,d2
.lop15_1	move.b	(a0)+,d2
		move.l	(a4,d2.w*4),d0
		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0
		move.b	(a2,d0.l),(a1)+
		dbf	d1,.lop15_1

.skip15_1	add.l	(mapcha_sourcemodulo,a5),a0
		add.l	(mapcha_destmodulo,a5),a1
		subq.w	#1,(mapcha_height,a5)
		bne	.map15
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map18		move.w	(mapcha_width8,a5),d0
		beq	.skip18_8
		move.w	d0,a3

.loop18_8	moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		move.l	(a4,d2.w*4),d2
		move.l	(a4,d3.w*4),d3
		move.l	(a4,d4.w*4),d4
		move.l	(a4,d5.w*4),d5
		move.l	(a4,d6.w*4),d6
		move.l	(a4,d7.w*4),d7

		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0

		lsr.l	#2,d1
		lsl.b	#2,d1
		lsl.w	#2,d1
		lsr.l	#4,d1

		lsr.l	#2,d2
		lsl.b	#2,d2
		lsl.w	#2,d2
		lsr.l	#4,d2

		lsr.l	#2,d3
		lsl.b	#2,d3
		lsl.w	#2,d3
		lsr.l	#4,d3

		lsr.l	#2,d4
		lsl.b	#2,d4
		lsl.w	#2,d4
		lsr.l	#4,d4

		lsr.l	#2,d5
		lsl.b	#2,d5
		lsl.w	#2,d5
		lsr.l	#4,d5

		lsr.l	#2,d6
		lsl.b	#2,d6
		lsl.w	#2,d6
		lsr.l	#4,d6

		lsr.l	#2,d7
		lsl.b	#2,d7
		lsl.w	#2,d7
		lsr.l	#4,d7

		move.b	(a2,d0.l),(a1)+
		move.b	(a2,d1.l),(a1)+
		move.b	(a2,d2.l),(a1)+
		move.b	(a2,d3.l),(a1)+
		move.b	(a2,d4.l),(a1)+
		move.b	(a2,d5.l),(a1)+
		move.b	(a2,d6.l),(a1)+
		move.b	(a2,d7.l),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop18_8

.skip18_8	move.w	(mapcha_width1,a5),d1
		bmi.b	.skip18_1

		moveq	#0,d2
.lop18_1	move.b	(a0)+,d2
		move.l	(a4,d2.w*4),d0
		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0
		move.b	(a2,d0.l),(a1)+
		dbf	d1,.lop18_1

.skip18_1	add.l	(mapcha_sourcemodulo,a5),a0
		add.l	(mapcha_destmodulo,a5),a1
		subq.w	#1,(mapcha_height,a5)
		bne	.map18
		rts


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map12p		move.w	(mapcha_width8,a5),d0
		beq	.skip12p_8
		move.w	d0,a3

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

.loop12p_8
		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		move.l	(a4,d2.w*4),d2
		move.l	(a4,d3.w*4),d3
		move.l	(a4,d4.w*4),d4
		move.l	(a4,d5.w*4),d5
		move.l	(a4,d6.w*4),d6
		move.l	(a4,d7.w*4),d7

		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0

		lsr.l	#4,d1
		lsl.b	#4,d1
		lsl.w	#4,d1
		lsr.l	#8,d1

		lsr.l	#4,d2
		lsl.b	#4,d2
		lsl.w	#4,d2
		lsr.l	#8,d2

		lsr.l	#4,d3
		lsl.b	#4,d3
		lsl.w	#4,d3
		lsr.l	#8,d3

		lsr.l	#4,d4
		lsl.b	#4,d4
		lsl.w	#4,d4
		lsr.l	#8,d4

		lsr.l	#4,d5
		lsl.b	#4,d5
		lsl.w	#4,d5
		lsr.l	#8,d5

		lsr.l	#4,d6
		lsl.b	#4,d6
		lsl.w	#4,d6
		lsr.l	#8,d6

		lsr.l	#4,d7
		lsl.b	#4,d7
		lsl.w	#4,d7
		lsr.l	#8,d7

		move.b	(a2,d0.l),d0
		move.b	(a2,d1.l),d1
		move.b	(a2,d2.l),d2
		move.b	(a2,d3.l),d3
		move.b	(a2,d4.l),d4
		move.b	(a2,d5.l),d5
		move.b	(a2,d6.l),d6
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		move.b	(a6,d7.w),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop12p_8

.skip12p_8	move.w	(mapcha_width1,a5),d1
		bmi.b	.skip12p_1

		move.w	#$00ff,d2
		moveq	#0,d3
.lop12p_1	move.b	(a0)+,d3
		move.l	(a4,d3.w*4),d0
		lsr.l	#4,d0
		lsl.b	#4,d0
		lsl.w	#4,d0
		lsr.l	#8,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.lop12p_1

.skip12p_1	add.l	(mapcha_sourcemodulo,a5),a0
		add.l	(mapcha_destmodulo,a5),a1
		subq.w	#1,(mapcha_height,a5)
		bne	.map12p
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map15p		move.w	(mapcha_width8,a5),d0
		beq	.skip15p_8
		move.w	d0,a3

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

.loop15p_8
		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		move.l	(a4,d2.w*4),d2
		move.l	(a4,d3.w*4),d3
		move.l	(a4,d4.w*4),d4
		move.l	(a4,d5.w*4),d5
		move.l	(a4,d6.w*4),d6
		move.l	(a4,d7.w*4),d7

		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0

		lsr.l	#3,d1
		lsl.b	#3,d1
		lsl.w	#3,d1
		lsr.l	#6,d1

		lsr.l	#3,d2
		lsl.b	#3,d2
		lsl.w	#3,d2
		lsr.l	#6,d2

		lsr.l	#3,d3
		lsl.b	#3,d3
		lsl.w	#3,d3
		lsr.l	#6,d3

		lsr.l	#3,d4
		lsl.b	#3,d4
		lsl.w	#3,d4
		lsr.l	#6,d4

		lsr.l	#3,d5
		lsl.b	#3,d5
		lsl.w	#3,d5
		lsr.l	#6,d5

		lsr.l	#3,d6
		lsl.b	#3,d6
		lsl.w	#3,d6
		lsr.l	#6,d6

		lsr.l	#3,d7
		lsl.b	#3,d7
		lsl.w	#3,d7
		lsr.l	#6,d7

		move.b	(a2,d0.l),d0
		move.b	(a2,d1.l),d1
		move.b	(a2,d2.l),d2
		move.b	(a2,d3.l),d3
		move.b	(a2,d4.l),d4
		move.b	(a2,d5.l),d5
		move.b	(a2,d6.l),d6
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		move.b	(a6,d7.w),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop15p_8

.skip15p_8	move.w	(mapcha_width1,a5),d1
		bmi.b	.skip15p_1

		move.w	#$00ff,d2
		moveq	#0,d3
.lop15p_1	move.b	(a0)+,d3
		move.l	(a4,d3.w*4),d0
		lsr.l	#3,d0
		lsl.b	#3,d0
		lsl.w	#3,d0
		lsr.l	#6,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.lop15p_1

.skip15p_1	add.l	(mapcha_sourcemodulo,a5),a0
		add.l	(mapcha_destmodulo,a5),a1
		subq.w	#1,(mapcha_height,a5)
		bne	.map15p
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

.map18p		move.w	(mapcha_width8,a5),d0
		beq	.skip18p_8
		move.w	d0,a3

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7

.loop18p_8
		move.b	(a0)+,d0
		move.b	(a0)+,d1
		move.b	(a0)+,d2
		move.b	(a0)+,d3
		move.b	(a0)+,d4
		move.b	(a0)+,d5
		move.b	(a0)+,d6
		move.b	(a0)+,d7
		
		move.l	(a4,d0.w*4),d0
		move.l	(a4,d1.w*4),d1
		move.l	(a4,d2.w*4),d2
		move.l	(a4,d3.w*4),d3
		move.l	(a4,d4.w*4),d4
		move.l	(a4,d5.w*4),d5
		move.l	(a4,d6.w*4),d6
		move.l	(a4,d7.w*4),d7

		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0

		lsr.l	#2,d1
		lsl.b	#2,d1
		lsl.w	#2,d1
		lsr.l	#4,d1

		lsr.l	#2,d2
		lsl.b	#2,d2
		lsl.w	#2,d2
		lsr.l	#4,d2

		lsr.l	#2,d3
		lsl.b	#2,d3
		lsl.w	#2,d3
		lsr.l	#4,d3

		lsr.l	#2,d4
		lsl.b	#2,d4
		lsl.w	#2,d4
		lsr.l	#4,d4

		lsr.l	#2,d5
		lsl.b	#2,d5
		lsl.w	#2,d5
		lsr.l	#4,d5

		lsr.l	#2,d6
		lsl.b	#2,d6
		lsl.w	#2,d6
		lsr.l	#4,d6

		lsr.l	#2,d7
		lsl.b	#2,d7
		lsl.w	#2,d7
		lsr.l	#4,d7

		move.b	(a2,d0.l),d0
		move.b	(a2,d1.l),d1
		move.b	(a2,d2.l),d2
		move.b	(a2,d3.l),d3
		move.b	(a2,d4.l),d4
		move.b	(a2,d5.l),d5
		move.b	(a2,d6.l),d6
		move.b	(a2,d7.l),d7

		and.w	#$00ff,d0
		move.b	(a6,d0.w),(a1)+
		move.w	#$00ff,d0
		and.w	d0,d1
		move.b	(a6,d1.w),(a1)+
		and.w	d0,d2
		move.b	(a6,d2.w),(a1)+
		and.w	d0,d3
		move.b	(a6,d3.w),(a1)+
		and.w	d0,d4
		move.b	(a6,d4.w),(a1)+
		and.w	d0,d5
		move.b	(a6,d5.w),(a1)+
		and.w	d0,d6
		move.b	(a6,d6.w),(a1)+
		and.w	d0,d7
		move.b	(a6,d7.w),(a1)+

		subq.w	#1,a3
		move.w	a3,d3
		bne	.loop18p_8

.skip18p_8	move.w	(mapcha_width1,a5),d1
		bmi.b	.skip18p_1

		move.w	#$00ff,d2
		moveq	#0,d3
.lop18p_1	move.b	(a0)+,d3
		move.l	(a4,d3.w*4),d0
		lsr.l	#2,d0
		lsl.b	#2,d0
		lsl.w	#2,d0
		lsr.l	#4,d0
		move.b	(a2,d0.l),d0
		and.w	d2,d0
		move.b	(a6,d0.w),(a1)+
		dbf	d1,.lop18p_1

.skip18p_1	add.l	(mapcha_sourcemodulo,a5),a0
		add.l	(mapcha_destmodulo,a5),a1
		subq.w	#1,(mapcha_height,a5)
		bne	.map18p
		rts

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 



;====================================================================

	ENDC

