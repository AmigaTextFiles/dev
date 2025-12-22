@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/gfx.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT tpoint
@{fg shine}(   0)@{fg text}   x:INT
@{fg shine}(   2)@{fg text}   y:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT rect32
@{fg shine}(   0)@{fg text}   minx:LONG
@{fg shine}(   4)@{fg text}   miny:LONG
@{fg shine}(   8)@{fg text}   maxx:LONG
@{fg shine}(  12)@{fg text}   maxy:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT rectangle
@{fg shine}(   0)@{fg text}   minx:INT
@{fg shine}(   2)@{fg text}   miny:INT
@{fg shine}(   4)@{fg text}   maxx:INT
@{fg shine}(   6)@{fg text}   maxy:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT bitmap
@{fg shine}(   0)@{fg text}   bytesperrow:INT
@{fg shine}(   2)@{fg text}   rows:INT
@{fg shine}(   4)@{fg text}   flags:CHAR
@{fg shine}(   5)@{fg text}   depth:CHAR
@{fg shine}(   6)@{fg text}   pad:INT
@{fg shine}(   8)@{fg text}   planes[8]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

CONST BMF_STANDARD=8,
      BMB_STANDARD=3,
      BMF_MINPLANES=16,
      BMB_MINPLANES=4,
      BMF_INTERLEAVED=4,
      BMB_INTERLEAVED=2,
      BMF_DISPLAYABLE=2,
      BMB_DISPLAYABLE=1,
      DENISE=1,
      BMF_CLEAR=1,
      BMB_CLEAR=0,
      BMA_HEIGHT=0,
      BMA_DEPTH=4,
      BITCLR=0,
      BMA_WIDTH=8,
      AGNUS=1,
      BITSET=$8000,
      BMA_FLAGS=12

#define RASSIZE/2
@endnode
