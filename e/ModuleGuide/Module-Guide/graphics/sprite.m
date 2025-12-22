@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/sprite.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT extsprite
@{fg shine}(   0)@{fg text}   simplesprite:simplesprite @{fg shine}(or ARRAY OF simplesprite)@{fg text}
@{fg shine}(  12)@{fg text}   wordwidth:INT
@{fg shine}(  14)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT simplesprite
@{fg shine}(   0)@{fg text}   posctldata:PTR TO INT
@{fg shine}(   4)@{fg text}   height:INT
@{fg shine}(   6)@{fg text}   x:INT
@{fg shine}(   8)@{fg text}   y:INT
@{fg shine}(  10)@{fg text}   num:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST GSTAG_SOFTSPRITE=$82000024,
      GSTAG_ATTACHED=$82000022,
      SPRITEA_ATTACHED=$81000008,
      SPRITEA_OLDDATAFORMAT=$8100000A,
      GSTAG_SCANDOUBLED=$83000000,
      SPRITEA_YREPLICATION=$81000004,
      SPRITEA_XREPLICATION=$81000002,
      GSTAG_SPRITE_NUM=$82000020,
      SPRITEA_OUTPUTHEIGHT=$81000006,
      SPRITEA_WIDTH=$81000000
@endnode
