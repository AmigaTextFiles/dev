
	IFND RENDER_STRUCTURES_I
RENDER_STRUCTURES_I	SET	1

;------------------------------------------------------------------------
;
;		MemHandler
;
;------------------------------------------------------------------------

	STRUCTURE	_RenderMemHandler_,0
		APTR	rmh_poolheader		; v39 exec pool header or NULL
		APTR	rmh_privateheader	; private pool header or NULL
		UWORD	rmh_type			; memory ressource type
		ULONG	rmh_nestcount		; Verschachtelungszähler
		ULONG	rmh_memflags		; Flags für MEMF_PUBLIC
		STRUCT	rmh_semaphore,SS_SIZE		; pool semaphore
	LABEL		rmh_SIZEOF

;-------------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		RenderNode
;
;-------------------------------------------------------------------------

	STRUCTURE	rNode,0
		ULONG	rNode_RGB
		ULONG	rNode_count
		UBYTE	rNode_validated
		UBYTE	rNode_pen
		UWORD	rNode_diversity
		APTR	rNode_left
		APTR	rNode_right
	LABEL		rNode_SIZEOF

;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
;
;		TreeAnchor
;
;-------------------------------------------------------------------------

	STRUCTURE	treeAnchor,0

		APTR	treeAnchor_next		; Zeiger auf nächsten Block
		APTR	treeAnchor_prev		; Zeiger auf vorherigen Block

		APTR	treeAnchor_memhandler	; der Memhandler dieses Blocks
		ULONG	treeAnchor_blocksize	; Gesamtgröße des Blocks (inklusive Header)
		UWORD	treeAnchor_maxnodes	; max. Anzahl Knoten in diesem Block
		UWORD	treeAnchor_freenodes	; akt. Anzahl Knoten in diesem Block

	LABEL		treeAnchor_SIZEOF		

;------------------------------------------------------------------------


;------------------------------------------------------------------------
;
;		Histogram
;
;------------------------------------------------------------------------

	STRUCTURE	_DynamicHistogram_,0

	; konstant:

		APTR	dhisto_memhandler	; Speicherverwaltung
		ULONG	dhisto_andmask		; Relevanzmaske
		UBYTE	dhisto_type		; HSTYPE des Histogramms
		UBYTE	dhisto_pad1
		UWORD	dhisto_pad2


	; protected:

		STRUCT	dhisto_semaphore,SS_SIZE

		ULONG	dhisto_numcolors	; Farben im Histogramm
		ULONG	dhisto_numpixels	; Anzahl Pixel

		APTR	dhisto_turbo		; bei Turbo-Histogrammen
		ULONG	dhisto_turbosize	; Größe der Tabelle [Bytes]

		APTR	dhisto_table		; bei Table-Histogrammen
		ULONG	dhisto_tablesize	; Größe der Tabelle [Bytes]

		APTR	dhisto_tree		; Ankerzeiger auf Digitalbaum
		UBYTE	dhisto_treevalid	; Baum gültig?
		UBYTE	dhisto_conversion	; aktueller Zustand HSCONVTYPE_

	LABEL		dhisto_SIZEOF

;--------------------------------------------------------------------


;--------------------------------------------------------------------
;
;		Engine
;
;--------------------------------------------------------------------

	STRUCTURE	_Engine_,0
		ULONG	eng_ID		; Identifier
		UWORD	eng_sourcewidth
		UWORD	eng_sourceheight
		UWORD	eng_destwidth
		UWORD	eng_destheight
		UWORD	eng_pixelformat
		UWORD	eng_pad
		APTR	eng_initfunc	; Engine Init
		APTR	eng_func	; Einsprung in die Engine
		APTR	eng_closefunc	; Engine Close
	LABEL		eng_SIZEOF


ENGINE_SCALING	EQU	'S'<<24+'C'<<16+'A'<<8+'L'
ENGINE_TEXTURE	EQU	'T'<<24+'E'<<16+'X'<<8+'T'

;--------------------------------------------------------------------
;
;		Scale-Engine
;
;--------------------------------------------------------------------

	STRUCTURE	_ScaleEngine_,0
		STRUCT	sce_engine,eng_SIZEOF
		APTR	sce_code	; Einsprung in den Offsetcode
		UWORD	sce_line	; Y-Zähler
		UWORD	sce_pad
		APTR	sce_linebuffer
		APTR	sce_deltabuffer
	LABEL		sce_SIZEOF
	;		y-delta-offset-table
	;		x-code

;--------------------------------------------------------------------



;--------------------------------------------------------------------
;
;		Interface
;
;--------------------------------------------------------------------

	STRUCTURE	prm_data,0
		ULONG	prm_a0
		ULONG	prm_a1
		ULONG	prm_a2
		ULONG	prm_a3
		ULONG	prm_a4
		ULONG	prm_d0
		ULONG	prm_d1
		ULONG	prm_d2
		ULONG	prm_d3
		ULONG	prm_d4
		ULONG	prm_d5
		ULONG	prm_d6
	LABEL		prm_SIZEOF

;--------------------------------------------------------------------



;-------------------------------------------------------------------------
;
;		Palette
;
;-------------------------------------------------------------------------

	STRUCTURE	_Palette_,0

		; nicht veränderlich

		UWORD	pal_bitspergun		; Default - nicht unbedingt real!
		UWORD	pal_pad1
		APTR	pal_memhandler

		; Palette

		STRUCT	pal_palette,256*4
		STRUCT	pal_wordpalette,256*3*2

		UWORD	pal_numcolors

		UWORD	pal_p2HAM1		; p2-Parameter HAM
		UWORD	pal_p2HAM2
		UWORD	pal_p2bitspergun	; tatsächliche Bits_per_gun
		UBYTE	pal_p2valid		; BOOL
		UBYTE	pal_pad2
		UWORD	pal_pad3
		APTR	pal_p2table		; die Tabelle
		ULONG	pal_p2size		; Größe in Bytes

		STRUCT	pal_maplist,MLH_SIZE	; Liste der Mapping-Engines

		STRUCT	pal_semaphore,SS_SIZE	; Semaphore für veränderliche Daten

	LABEL		pal_SIZEOF

;-------------------------------------------------------------------------


;------------------------------------------------------------------------------
;
;		Mapping-Engine
;
;--------------------------------------------------------------------

	STRUCTURE	mappingEngine,0
		STRUCT	map_node,MLN_SIZE	; Verkettung mit der Palette
		UBYTE	map_modified		; TRUE oder FALSE.
		UBYTE	map_pad1
		UWORD	map_pad2

		APTR	map_memhandler
		APTR	map_palette
		APTR	map_histogram
		ULONG	map_numentries		; Anzahl Einträge im Histogramm
		APTR	map_bitarray
		ULONG	map_bitarraysize	; In Bytes
		APTR	map_p1table

		UWORD	map_bitspergun

		STRUCT	map_semaphore,SS_SIZE	; Semaphore für veränderliche Daten
	LABEL		map_SIZEOF

;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
;
;		convert
;
;------------------------------------------------------------------------------

	STRUCTURE	_convert_localdata_,0

		; Diese Felder werden von der Init-Funktion ausgefüllt:

		APTR	conv_func		; Zeilenfunktion
		APTR	conv_closefunc		; Abschlußfunktion

			UWORD	conv_user1	; "user"-Parameter
			UWORD	conv_user2
	;		UWORD	conv_user3
	;		UWORD	conv_user4

		APTR	conv_engine		; Engine
		ULONG	conv_sourceoffset	; Zeilenbreite Source [Bytes]
		ULONG	conv_destoffset		; Zeilenbreite Dest [Bytes]


		; vor Aufruf der Init-Funktion auszufüllen:
		
		APTR	conv_source		; Source Array
		APTR	conv_dest		; Dest Array
		UWORD	conv_width		; zu konvertierende Breite (dest)
		UWORD	conv_sourcex		; source X
		UWORD	conv_sourcey		; source Y
		UWORD	conv_destx		; dest X
		UWORD	conv_desty		; dest Y


		UWORD	conv_totalsourcewidth	; Gesamtbreite Source Array
		UWORD	conv_totaldestwidth	; Gesamtbreite Dest Array
		UWORD	conv_sourcecolormode	; Colormode Source
		UWORD	conv_colormode		; Colormode (Dest)
		UWORD	conv_dithermode		; Dithermode (Dest)
		APTR	conv_memhandler		; Memhandler
		APTR	conv_sourcepalette	; Palette Source
		APTR	conv_destpalette	; Palette Dest
		UWORD	conv_offsetcolorzero

		UWORD	conv_numcolors
		APTR	conv_wordpalette

		APTR	conv_mapengine

		APTR	conv_p2table		; p2Table
		UWORD	conv_p2bitspergun 
		UWORD	conv_p2HAM1		; p2Parameter (HAM)
		UWORD	conv_p2HAM2
		
		UWORD	conv_height		; (dest, nur beim Skalieren)

		APTR	conv_pentabptr		; externe pentab oder NULL
		STRUCT	conv_pentab,256		; Pentab für Chunky-Konvertierungen

		UWORD	conv_sourceline		; aktuelle sourcezeile


		; HAM
		
		ULONG	conv_oldRGB


		; Dithering

		ULONG	conv_fsbufsize		; Größe eines FloydSteinberg-Buffers
		APTR	conv_thislinebuffer	; FloydSteinberg-Buffer aktuelle Zeile
		APTR	conv_nextlinebuffer	; FloydSteinberg-Buffer nächste Zeile
		UWORD	conv_xcount		; Schleifenzähler bei FS-Dither
		UBYTE	conv_firstpixel		; Flag: ist es der erste Pixel der Zeile?
		UBYTE	conv_pad1
		APTR	conv_ditherfunc
		UWORD	conv_ditheramount
		
		UWORD	conv_directionflipflop	; for bidirectional rendering


		; Misc
		
		ULONG	conv_bgcolor
		ULONG	conv_bgpen
		

	LABEL		conv_SIZEOF			

;------------------------------------------------------------------------------


	ENDC
