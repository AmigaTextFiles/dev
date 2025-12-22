@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "diskfont/glyph.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT glyphwidthentry
@{fg shine}(   0)@{fg text}   node:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   code:INT
@{fg shine}(  10)@{fg text}   width:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

@{fg shine}(----)@{fg text} OBJECT glyphmap
@{fg shine}(   0)@{fg text}   bmmodulo:INT
@{fg shine}(   2)@{fg text}   bmrows:INT
@{fg shine}(   4)@{fg text}   blackleft:INT
@{fg shine}(   6)@{fg text}   blacktop:INT
@{fg shine}(   8)@{fg text}   blackwidth:INT
@{fg shine}(  10)@{fg text}   blackheight:INT
@{fg shine}(  12)@{fg text}   xorigin:LONG
@{fg shine}(  16)@{fg text}   yorigin:LONG
@{fg shine}(  20)@{fg text}   x0:INT
@{fg shine}(  22)@{fg text}   y0:INT
@{fg shine}(  24)@{fg text}   x1:INT
@{fg shine}(  26)@{fg text}   y1:INT
@{fg shine}(  28)@{fg text}   width:LONG
@{fg shine}(  32)@{fg text}   bitmap:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT glyphengine
@{fg shine}(   0)@{fg text}   library:PTR TO lib
@{fg shine}(   4)@{fg text}   name:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST DISKFONT_GLYPH_I=1
@endnode
