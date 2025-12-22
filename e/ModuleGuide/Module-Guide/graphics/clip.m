@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/clip.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT cliprect
@{fg shine}(   0)@{fg text}   next:PTR TO cliprect
@{fg shine}(   4)@{fg text}   prev:PTR TO cliprect
@{fg shine}(   8)@{fg text}   lobs:PTR TO layer
@{fg shine}(  12)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(  16)@{fg text}   minx:INT
@{fg shine}(  18)@{fg text}   miny:INT
@{fg shine}(  20)@{fg text}   maxx:INT
@{fg shine}(  22)@{fg text}   maxy:INT
@{fg shine}(  24)@{fg text}   p1_:LONG
@{fg shine}(  28)@{fg text}   p2_:LONG
@{fg shine}(  32)@{fg text}   reserved:LONG
@{fg shine}(  36)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT layer
@{fg shine}(   0)@{fg text}   front:PTR TO layer
@{fg shine}(   4)@{fg text}   back:PTR TO layer
@{fg shine}(   8)@{fg text}   cliprect:PTR TO cliprect
@{fg shine}(  12)@{fg text}   rp:PTR TO rastport
@{fg shine}(  16)@{fg text}   minx:INT
@{fg shine}(  18)@{fg text}   miny:INT
@{fg shine}(  20)@{fg text}   maxx:INT
@{fg shine}(  22)@{fg text}   maxy:INT
@{fg shine}(  24)@{fg text}   reserved[4]:ARRAY OF CHAR
@{fg shine}(  28)@{fg text}   priority:INT
@{fg shine}(  30)@{fg text}   flags:INT
@{fg shine}(  32)@{fg text}   superbitmap:PTR TO bitmap
@{fg shine}(  36)@{fg text}   supercliprect:PTR TO cliprect
@{fg shine}(  40)@{fg text}   window:LONG
@{fg shine}(  44)@{fg text}   scroll_x:INT
@{fg shine}(  46)@{fg text}   scroll_y:INT
@{fg shine}(  48)@{fg text}   cr:PTR TO cliprect
@{fg shine}(  52)@{fg text}   cr2:PTR TO cliprect
@{fg shine}(  56)@{fg text}   crnew:PTR TO cliprect
@{fg shine}(  60)@{fg text}   supersavercliprects:PTR TO cliprect
@{fg shine}(  64)@{fg text}   cliprects_:PTR TO cliprect
@{fg shine}(  68)@{fg text}   layerinfo:PTR TO layer_info
@{fg shine}(  72)@{fg text}   lock:ss @{fg shine}(or ARRAY OF ss)@{fg text}
@{fg shine}( 118)@{fg text}   backfill:PTR TO hook
@{fg shine}( 122)@{fg text}   reserved1:LONG
@{fg shine}( 126)@{fg text}   clipregion:PTR TO region
@{fg shine}( 130)@{fg text}   savecliprects:PTR TO region
@{fg shine}( 134)@{fg text}   reserved2[22]:ARRAY OF CHAR
@{fg shine}( 156)@{fg text}   damagelist:PTR TO region
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=160 */

CONST LR_RASTPORT=12,
      LR_BACK=4,
      CR_PREV=4,
      CR_LOBS=8,
      CR_NEEDS_NO_LAYERBLIT_DAMAGE=2,
      LR_FRONT=0,
      ISGRTRX=4,
      ISGRTRY=8,
      ISLESSX=1,
      ISLESSY=2,
      NEWLOCKS=1,
      CR_NEEDS_NO_CONCEALED_RASTERS=1
@endnode
