@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/diskfont.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT afh
@{fg shine}(   0)@{fg text}   numentries:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=2 */

@{fg shine}(----)@{fg text} OBJECT taf
@{fg shine}(   0)@{fg text}   type:INT
@{fg shine}(   2)@{fg text}   attr:ttextattr @{fg shine}(or ARRAY OF ttextattr)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

@{fg shine}(----)@{fg text} OBJECT af
@{fg shine}(   0)@{fg text}   type:INT
@{fg shine}(   2)@{fg text}   attr:textattr @{fg shine}(or ARRAY OF textattr)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=10 */

@{fg shine}(----)@{fg text} OBJECT diskfontheader
@{fg shine}(   0)@{fg text}   df:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   fileid:INT
@{fg shine}(  16)@{fg text}   revision:INT
@{fg shine}(  18)@{fg text}   segment:LONG
@{fg shine}(  22)@{fg text}   name[32]:ARRAY OF CHAR
@{fg shine}(  54)@{fg text}   tf:textfont @{fg shine}(or ARRAY OF textfont)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=106 */

@{fg shine}(----)@{fg text} OBJECT fch
@{fg shine}(   0)@{fg text}   fileid:INT
@{fg shine}(   2)@{fg text}   numentries:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT tfc
@{fg shine}(   0)@{fg text}   filename[254]:ARRAY OF CHAR
@{fg shine}( 254)@{fg text}   tagcount:INT
@{fg shine}( 256)@{fg text}   ysize:INT
@{fg shine}( 258)@{fg text}   style:CHAR
@{fg shine}( 259)@{fg text}   flags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=260 */

@{fg shine}(----)@{fg text} OBJECT fc
@{fg shine}(   0)@{fg text}   filename[256]:ARRAY OF CHAR
@{fg shine}( 256)@{fg text}   ysize:INT
@{fg shine}( 258)@{fg text}   style:CHAR
@{fg shine}( 259)@{fg text}   flags:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=260 */

CONST DFH_ID=$F80,
      OFCH_ID=$F03,
      TFCH_ID=$F02,
      FCH_ID=$F00,
      AFF_TTATTR=$10000,
      MAXFONTPATH=$100,
      AFF_TAGGED=$10000,
      AFB_TAGGED=16,
      DFH_TAGLIST=18,
      AFF_SCALED=4,
      AFB_SCALED=2,
      AFF_MEMORY=1,
      AFB_MEMORY=0,
      AFF_DISK=2,
      AFB_DISK=1,
      AFF_BITMAP=8,
      AFB_BITMAP=3,
      MAXFONTNAME=$20
@endnode
