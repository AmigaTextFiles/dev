
;         /\
;    ____/  \____   
;    \   \  /|  / 				 $VER: RenderLibrary v31.0
;==== \   \/ | / =========================================================
;----- \   | |/ ----------------------------------------------------------
;       \  | /
;        \ |/	RenderLibrary
;         \/	by Bifat / TEK neoscientists
;
;-------------------------------------------------------------------------

		INCDIR	include:

		INCLUDE	exec/execbase.i
		INCLUDE	exec/resident.i
		INCLUDE	exec/initializers.i

		INCLUDE	exec/semaphores.i
		INCLUDE	exec/memory.i
		INCLUDE	graphics/gfx.i

		INCLUDE	LVO/exec_lib.i
		INCLUDE	LVO/utility_lib.i

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		INCLUDE	render/Render.i
		INCLUDE	render/RenderHooks.i
		INCLUDE	LVO/Render_Lib.i

;-------------------------------------------------------------------------
	ifnd	HAVE_CPUFPU
CPU60		EQU	1
CPU40		EQU	0
CPU20		EQU	0
USEFPU		EQU	0
	endc

;-------------------------------------------------------------------------

Lib_Ver		EQU	32
Lib_Rev		EQU	0
Lib_Pri		EQU	0

;-------------------------------------------------------------------------

VersionName:	MACRO
		dc.b	'render.library'
		ENDM
VersionString:	MACRO

	IFNE	CPU60
		dc.b	'68060'
	ENDC
	IFNE	CPU40
		dc.b	'68040'
	ENDC
	IFNE	CPU20
		dc.b	'68020'
	ENDC
		dc.b	' 32.0'
		ENDM
VersionDate:	MACRO
		dc.b	' (27-Jun-2017)',0
		ENDM

;-------------------------------------------------------------------------

	STRUCTURE 	RenderLib,LIB_SIZE
		ULONG	rendlib_SysLib
		ULONG	rendlib_SegList
	LABEL		RenderLib_SIZEOF

;=========================================================================
;*************************************************************************

		SECTION "INIT_CODE",CODE

;*************************************************************************
;=========================================================================

		moveq	#20,d0
		rts

;=========================================================================

		cnop	0,4
RomTag:		dc.w	RTC_MATCHWORD

		dc.l	RomTag
		dc.l	EndTag

		dc.b	RTF_AUTOINIT
		dc.b	Lib_Ver
		dc.b	NT_LIBRARY
		dc.b	Lib_Pri

		dc.l	Lib_Name
		dc.l	Lib_Id
		dc.l	InitTab

;-------------------------------------------------------------------------

Lib_Name:	VersionName
		cnop	0,2

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		dc.b	0,0
		dc.b	"$VER: "
Lib_Id:		VersionName
		VersionString
		VersionDate
		dc.b	13,10,0
		cnop	0,4

;-------------------------------------------------------------------------
;
;		initialization table
;
;-------------------------------------------------------------------------

InitTab:	dc.l	RenderLib_SIZEOF
		dc.l	FuncTab
		dc.l	DataTab
		dc.l	LibInit

;-------------------------------------------------------------------------
;
;		library function table
;
;-------------------------------------------------------------------------

FuncTab:	dc.l	LibOpen
		dc.l	LibClose
		dc.l	LibExpunge
		dc.l	LibNull

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		dc.l	TurboFillMem
		dc.l	TurboCopyMem
		dc.l	_CreateRenderMemHandler
		dc.l	DeleteRenderMemHandler
		dc.l	AllocRenderMem
		dc.l	FreeRenderMem
		dc.l	AllocRenderVec
		dc.l	FreeRenderVec
		dc.l	CreateHistogram
		dc.l	DeleteHistogram
		dc.l	QueryHistogram
		dc.l	AddRGB
		dc.l	_AddRGBImage
		dc.l	AddChunkyImage
		dc.l	ExtractPalette
		dc.l	Render
		dc.l	_Planar2Chunky	
		dc.l	Chunky2RGB
		dc.l	_Chunky2BitMap
		dc.l	CreateScaleEngine
		dc.l	DeleteScaleEngine
		dc.l	Scale		
		dc.l	ConvertChunky
		dc.l	_CreateConversionTable
		dc.l	CreatePalette
		dc.l	DeletePalette
		dc.l	ImportPalette
		dc.l	ExportPalette
		dc.l	CountRGB
		dc.l	BestPen
		dc.l	FlushPalette
		dc.l	SortPalette
		dc.l	AddHistogram
		dc.l	ScaleOrdinate
		dc.l	CreateHistogramPointerArray
		dc.l	CountHistogram
		dc.l	CreateMappingEngine
		dc.l	DeleteMappingEngine
		dc.l	MapRGBArray
		dc.l	RGBArrayDiversity
		dc.l	ChunkyArrayDiversity
		dc.l	MapChunkyArray
		dc.l	InsertAlphaChannel
		dc.l	ExtractAlphaChannel
		dc.l	ApplyAlphaChannel
		dc.l	MixRGBArray
		dc.l	AllocRenderVecClear
		dc.l	CreateAlphaArray
		dc.l	MixAlphaChannel
		dc.l	TintRGBArray
		dc.l	GetPaletteAttrs		; internal
		dc.l	RemapArray		; internal

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		dc.l	-1

;-------------------------------------------------------------------------
;
;		data initialization table
;
;-------------------------------------------------------------------------

DataTab:	INITBYTE	LN_TYPE, NT_LIBRARY
		INITLONG	LN_NAME, Lib_Name
		INITBYTE	LIB_FLAGS, LIBF_SUMUSED + LIBF_CHANGED
		INITWORD	LIB_VERSION, Lib_Ver
		INITWORD	LIB_REVISION, Lib_Rev
		INITLONG	LIB_IDSTRING, Lib_Id
		dc.l   0

;-------------------------------------------------------------------------
;
;		LibInit
;
;	>	a0	segment list
;		d0	library base
;		a6	exec base
;	<	d0	library base (NULL if initialization failed)
;
;-------------------------------------------------------------------------

LibInit:	move.l	a5,-(sp)

		lea	(execbase,pc),a5
		move.l	a6,(a5)

		move.l	d0,a5
		move.l	a6,rendlib_SysLib(a5)
		move.l	a0,rendlib_SegList(a5)


		moveq	#0,d0

		; mindestens 68020 vorhanden?

		btst	#AFB_68020,AttnFlags+1(a6)
		beq.b	libinit_fail


		; Utility-Library öffnen

		lea	(utilityname,pc),a1
		moveq	#36,d0
		jsr	(_LVOOpenLibrary,a6)
		lea	(utilitybase,pc),a0
		move.l	d0,(a0)
		beq.b	libinit_fail


		; alles Okay

		move.l	a5,d0


libinit_fail	move.l	(sp)+,a5
		rts

;-------------------------------------------------------------------------
;
;		LibOpen
;
;	>	a6	library base
;	<	d0	library base
;
;-------------------------------------------------------------------------

LibOpen:	addq.w	#1,LIB_OPENCNT(a6)

		bclr	#LIBB_DELEXP,LIB_FLAGS(a6)

		move.l	a6,d0
LibOpen_rts	rts

;-------------------------------------------------------------------------
;
;		LibClose
;
;	>	a6	library base
;	<	d0	library's segment list if library can be removed
;
;-------------------------------------------------------------------------

LibClose:	moveq	#0,d0

		subq.w	#1,LIB_OPENCNT(a6)
		bne.b	LibOpen_rts

		btst	#LIBB_DELEXP,LIB_FLAGS(a6)
		beq.b	LibOpen_rts

;-------------------------------------------------------------------------
;
;		LibExpunge
;
;	>	a6	library base
;	<	d0	library's segment list if library can be removed
;
;-------------------------------------------------------------------------

LibExpunge:	moveq	#0,d0

		tst.w	LIB_OPENCNT(a6)
		beq.b	LibExpunge_real

		bset	#LIBB_DELEXP,LIB_FLAGS(a6)

		rts

;-------------------------------------------------------------------------
;		Library-Node aus Liste entfernen
;-------------------------------------------------------------------------

LibExpunge_real	move.l	a1,-(sp)


		; Libraries schließen

		move.l	a6,a5

		move.l	rendlib_SysLib(a5),a6
		move.l	(utilitybase,pc),a1
		jsr	(_LVOCloseLibrary,a6)

		move.l	a5,a6

		move.l	a6,a1
		REMOVE

;-------------------------------------------------------------------------
;		Sprungtabelle freigeben
;-------------------------------------------------------------------------

		move.l	a6,a1
		move.w  LIB_NEGSIZE(a6),d0

		sub.l	d0,a1
		add.w   LIB_POSSIZE(a6),d0

		move.l	a6,a5
		move.l	rendlib_SysLib(a5),a6
		jsr	(_LVOFreeMem,a6)
		move.l	a5,a6

		move.l	rendlib_SegList(a6),d0
		move.l	(sp)+,a1
		rts

;-------------------------------------------------------------------------
;
;		LibNull
;
;	<	d0	NULL
;
;-------------------------------------------------------------------------

LibNull:	moveq		#0,d0
		rts

;=========================================================================

		INCLUDE	"makros.i"
		INCLUDE	"squareroot.i"
		INCLUDE	"RenderMakros.i"

		INCLUDE	"Interface.i"
		INCLUDE	"Structures.i"
		INCLUDE	"Konstanten.i"
		INCLUDE	"TurboFillMem.i"
		INCLUDE	"TurboCopyMem.i"
		INCLUDE	"tables.i"
		INCLUDE	"Alpha.i"
		INCLUDE	"Mapping.i"
		INCLUDE	"Rendering.i"
		INCLUDE	"Dither_FS.i"
		INCLUDE	"Dither_Random.i"
		INCLUDE	"Dither_EDD.i"

;-------------------------------------------------------------------------

		cnop	0,4
execbase	dc.l	0
utilitybase	dc.l	0
utilityname	dc.b	"utility.library",0
		even

;-------------------------------------------------------------------------

		INCLUDE "zufall.i"
		INCLUDE	"MemHandler.i"
		INCLUDE	"Histogram.i"
		INCLUDE	"Palette.i"
		INCLUDE	"Conversions.i"
		INCLUDE	"mediancut.i"
		INCLUDE "Quantize.i"
		INCLUDE	"TextureMapping.i"
		INCLUDE "Engine.i"
		INCLUDE	"Scaling.i"

;-------------------------------------------------------------------------
EndTag:		END
;=========================================================================
