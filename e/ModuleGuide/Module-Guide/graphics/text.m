@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/text.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT textextent
@{fg shine}(   0)@{fg text}   width:INT
@{fg shine}(   2)@{fg text}   height:INT
@{fg shine}(   4)@{fg text}   extent:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT colortextfont
@{fg shine}(   0)@{fg text}   textfont:textfont @{fg shine}(or ARRAY OF textfont)@{fg text}
@{fg shine}(  52)@{fg text}   flags:INT
@{fg shine}(  54)@{fg text}   depth:CHAR
@{fg shine}(  55)@{fg text}   fgcolor:CHAR
@{fg shine}(  56)@{fg text}   low:CHAR
@{fg shine}(  57)@{fg text}   high:CHAR
@{fg shine}(  58)@{fg text}   planepick:CHAR
@{fg shine}(  59)@{fg text}   planeonoff:CHAR
@{fg shine}(  60)@{fg text}   colorfontcolors:PTR TO colorfontcolors
@{fg shine}(  64)@{fg text}   chardata[8]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=96 */

@{fg shine}(----)@{fg text} OBJECT colorfontcolors
@{fg shine}(   0)@{fg text}   reserved:INT
@{fg shine}(   2)@{fg text}   count:INT
@{fg shine}(   4)@{fg text}   colortable:PTR TO INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT textfontextension
@{fg shine}(   0)@{fg text}   matchword:INT
@{fg shine}(   2)@{fg text}   flags0:CHAR
@{fg shine}(   3)@{fg text}   flags1:CHAR
@{fg shine}(   4)@{fg text}   backptr:PTR TO textfont
@{fg shine}(   8)@{fg text}   origreplyport:PTR TO mp
@{fg shine}(  12)@{fg text}   tags:PTR TO tagitem
@{fg shine}(  16)@{fg text}   ofontpatchs:PTR TO INT
@{fg shine}(  20)@{fg text}   ofontpatchk:PTR TO INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT textfont
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   ysize:INT
@{fg shine}(  22)@{fg text}   style:CHAR
@{fg shine}(  23)@{fg text}   flags:CHAR
@{fg shine}(  24)@{fg text}   xsize:INT
@{fg shine}(  26)@{fg text}   baseline:INT
@{fg shine}(  28)@{fg text}   boldsmear:INT
@{fg shine}(  30)@{fg text}   accessors:INT
@{fg shine}(  32)@{fg text}   lochar:CHAR
@{fg shine}(  33)@{fg text}   hichar:CHAR
@{fg shine}(  34)@{fg text}   chardata:PTR TO CHAR
@{fg shine}(  38)@{fg text}   modulo:INT
@{fg shine}(  40)@{fg text}   charloc:PTR TO INT
@{fg shine}(  44)@{fg text}   charspace:PTR TO INT
@{fg shine}(  48)@{fg text}   charkern:PTR TO INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

@{fg shine}(----)@{fg text} OBJECT ttextattr
@{fg shine}(   0)@{fg text}   name:LONG
@{fg shine}(   4)@{fg text}   ysize:INT
@{fg shine}(   6)@{fg text}   style:CHAR
@{fg shine}(   7)@{fg text}   flags:CHAR
@{fg shine}(   8)@{fg text}   tags:PTR TO tagitem
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT textattr
@{fg shine}(   0)@{fg text}   name:LONG
@{fg shine}(   4)@{fg text}   ysize:INT
@{fg shine}(   6)@{fg text}   style:CHAR
@{fg shine}(   7)@{fg text}   flags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST CT_GREYFONT=2,
      CT_COLORFONT=1,
      TE0F_NOREMFONT=1,
      TE0B_NOREMFONT=0,
      FPF_DISKFONT=2,
      FPB_DISKFONT=1,
      FPF_ROMFONT=1,
      FPB_ROMFONT=0,
      FSF_COLORFONT=$40,
      FSB_COLORFONT=6,
      FPF_TALLDOT=8,
      FPB_TALLDOT=3,
      FSF_ITALIC=4,
      FSB_ITALIC=2,
      FPF_PROPORTIONAL=$20,
      FPB_PROPORTIONAL=5,
      FS_NORMAL=0,
      FSF_BOLD=2,
      FSB_BOLD=1,
      FSF_EXTENDED=8,
      FSB_EXTENDED=3,
      CT_ANTIALIAS=4,
      CT_COLORMASK=15,
      FPF_REMOVED=$80,
      FPB_REMOVED=7,
      FSF_UNDERLINED=1,
      FSB_UNDERLINED=0,
      CTF_MAPCOLOR=1,
      CTB_MAPCOLOR=0,
      FPF_REVPATH=4,
      FPB_REVPATH=2,
      FSF_TAGGED=$80,
      FSB_TAGGED=7,
      FPF_DESIGNED=$40,
      FPB_DESIGNED=6,
      MAXFONTMATCHWEIGHT=$7FFF,
      FPF_WIDEDOT=16,
      FPB_WIDEDOT=4,
      TA_DEVICEDPI=$80000001
@endnode
