@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/layers.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT layer_info
@{fg shine}(   0)@{fg text}   top_layer:PTR TO layer
@{fg shine}(   4)@{fg text}   check_lp:PTR TO layer
@{fg shine}(   8)@{fg text}   obs:PTR TO cliprect
@{fg shine}(  12)@{fg text}   freecliprects:PTR TO cliprect
@{fg shine}(  16)@{fg text}   privatereserve1:LONG
@{fg shine}(  20)@{fg text}   privatereserve2:LONG
@{fg shine}(  24)@{fg text}   lock:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}(  70)@{fg text}   gs_head:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}(  82)@{fg text}   privatereserve3:INT
@{fg shine}(  84)@{fg text}   privatereserve4:LONG
@{fg shine}(  88)@{fg text}   flags:INT
@{fg shine}(  90)@{fg text}   fatten_count:CHAR
@{fg shine}(  91)@{fg text}   locklayerscount:CHAR
@{fg shine}(  92)@{fg text}   privatereserve5:INT
@{fg shine}(  94)@{fg text}   blankhook:LONG
@{fg shine}(  98)@{fg text}   layerinfo_extra:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=102 */

CONST LAYERIREFRESH=$200,
      LAYERREFRESH=$80,
      ALERTLAYERSNOMEM=$83010000,
      LAYERSMART=2,
      LAYERUPDATING=16,
      LAYERBACKDROP=$40,
      LAYERIREFRESH2=$400,
      LAYER_CLIPRECTS_LOST=$100,
      NEWLAYERINFO_CALLED=1,
      LAYERSIMPLE=1,
      LAYERSUPER=4,
      LAYERS_BACKFILL=0,
      LAYERS_NOBACKFILL=1
@endnode
