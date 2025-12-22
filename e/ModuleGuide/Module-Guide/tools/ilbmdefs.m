@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "tools/ilbmdefs.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT bmhd
@{fg shine}(   0)@{fg text}   w:INT
@{fg shine}(   2)@{fg text}   h:INT
@{fg shine}(   4)@{fg text}   x:INT
@{fg shine}(   6)@{fg text}   y:INT
@{fg shine}(   8)@{fg text}   planes:CHAR
@{fg shine}(   9)@{fg text}   masking:CHAR
@{fg shine}(  10)@{fg text}   compression:CHAR
@{fg shine}(  12)@{fg text}   transcolour:INT
@{fg shine}(  14)@{fg text}   xaspect:CHAR
@{fg shine}(  15)@{fg text}   yaspect:CHAR
@{fg shine}(  16)@{fg text}   pagew:INT
@{fg shine}(  18)@{fg text}   pageh:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT picinfo
@{fg shine}(   0)@{fg text}   bmhd:LONG
@{fg shine}(   4)@{fg text}   modeid:LONG
@{fg shine}(   8)@{fg text}   colours:LONG
@{fg shine}(  12)@{fg text}   palraw:LONG
@{fg shine}(  16)@{fg text}   pal4:LONG
@{fg shine}(  20)@{fg text}   pal32:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

CONST ILBMNB_COLOURS4=1,
      ILBMNF_COLOURS4=2,
      ILBML_GETSCREEN=$80000004,
      ILBML_SCREEN=$80000001,
      ILBML_GETCHUNKY=$80000005,
      ILBML_CHUNKY=$80000002,
      ILBML_SCREENTAGS=$80000006,
      ILBML_NOCOLOUR=$80000007,
      ILBMNB_COLOURS32=0,
      ILBMNF_COLOURS32=1,
      ILBML_GETBITMAP=$80000003,
      ILBML_BITMAP=$80000000
@endnode
