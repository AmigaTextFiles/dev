@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes/pictureclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT colorregister
@{fg shine}(   0)@{fg text}   red:CHAR
@{fg shine}(   1)@{fg text}   green:CHAR
@{fg shine}(   2)@{fg text}   blue:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT bitmapheader
@{fg shine}(   0)@{fg text}   width:INT
@{fg shine}(   2)@{fg text}   height:INT
@{fg shine}(   4)@{fg text}   left:INT
@{fg shine}(   6)@{fg text}   top:INT
@{fg shine}(   8)@{fg text}   depth:CHAR
@{fg shine}(   9)@{fg text}   masking:CHAR
@{fg shine}(  10)@{fg text}   compression:CHAR
@{fg shine}(  11)@{fg text}   pad:CHAR
@{fg shine}(  12)@{fg text}   transparent:INT
@{fg shine}(  14)@{fg text}   xaspect:CHAR
@{fg shine}(  15)@{fg text}   yaspect:CHAR
@{fg shine}(  16)@{fg text}   pagewidth:INT
@{fg shine}(  18)@{fg text}   pageheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

CONST ID_DEST=$44455354,
      ID_CAMG=$43414D47,
      PDTA_COLORTABLE2=$800010CF,
      PDTA_SCREEN=$800010D4,
      MSKHASALPHA=4,
      PDTA_MODEID=$800010C8,
      PDTA_NUMALLOC=$800010D2,
      MSKHASMASK=1,
      PDTA_GREGS=$800010CD,
      PDTA_CREGS=$800010CC,
      PDTA_SPARSETABLE=$800010DA,
      PDTA_COLORTABLE=$800010CE,
      PDTA_REMAP=$800010D3,
      PDTA_NUMCOLORS=$800010D1,
      PDTA_NUMSPARSE=$800010D9,
      PDTA_BITMAPHEADER=$800010C9,
      MSKHASTRANSPARENTCOLOR=2,
      ID_CMAP=$434D4150,
      ID_GRAB=$47524142,
      ID_BMHD=$424D4844,
      PDTA_GRAB=$800010D6,
      CMPNONE=0,
      MSKNONE=0,
      ID_CRNG=$43524E47,
      MSKLASSO=3,
      ID_BODY=$424F4459,
      ID_ILBM=$494C424D,
      PDTA_ALLOCATED=$800010D0,
      CMPBYTERUN1=1,
      CMPBYTERUN2=2,
      ID_SPRT=$53505254,
      PDTA_CLASSBITMAP=$800010D8,
      PDTA_DESTBITMAP=$800010D7,
      PDTA_FREESOURCEBITMAP=$800010D5,
      PDTA_BITMAP=$800010CA,
      PDTA_COLORREGISTERS=$800010CB

#define PICTUREDTCLASS/0
@endnode
