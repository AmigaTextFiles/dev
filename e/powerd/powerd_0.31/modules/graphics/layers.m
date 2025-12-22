MODULE 'exec/lists',
       'exec/semaphores',
       'graphics/clip','graphics/text','graphics/gels'

CONST	LAYERSIMPLE=1,
		LAYERSMART=2,
		LAYERSUPER=4,
		LAYERUPDATING=16,
		LAYERBACKDROP=$40,
		LAYERREFRESH=$80,
		LAYERIREFRESH=$200,
		LAYERIREFRESH2=$400,
		LAYER_CLIPRECTS_LOST=$100

OBJECT Layer_Info
	top_layer:PTR TO Layer,
	check_lp:PTR TO Layer,
	obs:PTR TO ClipRect,
	FreeClipRects:PTR TO ClipRect,
	PrivateReserve1:LONG,
	PrivateReserve2:LONG,
	Lock:SS,
	gs_Head|Head:MLH,
	PrivateReserve3:WORD,
	PrivateReserve4:LONG,
	Flags:UWORD,
	fatten_count:BYTE,
	LockLayersCount:BYTE,
	PrivateReserve5:WORD,
	BlankHook:LONG,
	LayerInfo_extra:LONG

CONST	NEWLAYERINFO_CALLED=1,
		ALERTLAYERSNOMEM=$83010000,
		LAYERS_NOBACKFILL=1,
		LAYERS_BACKFILL=0
