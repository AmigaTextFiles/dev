uint
„LAYERSIMPLE‰=0x0001,
„LAYERSMARTŠ=0x0002,
„LAYERSUPERŠ=0x0004,
„LAYERUPDATING‡=0x0010,
„LAYERBACKDROP‡=0x0040,
„LAYERREFRESHˆ=0x0080,
„LAYER_CLIPRECTS_LOST=0x0100;

ulong
„LMN_REGIONŠ=-1;

type
„MinList_t=unknown12,
„SignalSemaphore_t=unknown46,
„List_t=unknown14,

„Layer_Info_t=struct{
ˆ*Layerli_top_layer;
ˆ*Layerli_check_lp;
ˆ*Layerli_obs;
ˆMinList_tli_FreeClipRects;
ˆSignalSemaphore_tli_Lock;
ˆList_tli_gs_Head;
ˆulongli_longreserved;
ˆuintli_Flags;
ˆushortli_fatten_count;
ˆushortli_LockLayersCount;
ˆuintli_LayerInfo_extra_size;
ˆ*uintli_blitbuff;
ˆ*LayerInfo_extra_tli_LayerInfo_extra;
„};

ulong
„NEWLAYERINFO_CALLED=1,
„ALERTLAYERSNOMEM„=0x83010000;

/*layerfunctionsandLayer_tareinclip.g*/
