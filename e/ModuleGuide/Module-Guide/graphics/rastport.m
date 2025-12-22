@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/rastport.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT areainfo
@{fg shine}(   0)@{fg text}   vctrtbl:PTR TO INT
@{fg shine}(   4)@{fg text}   vctrptr:PTR TO INT
@{fg shine}(   8)@{fg text}   flagtbl:PTR TO CHAR
@{fg shine}(  12)@{fg text}   flagptr:PTR TO CHAR
@{fg shine}(  16)@{fg text}   count:INT
@{fg shine}(  18)@{fg text}   maxcount:INT
@{fg shine}(  20)@{fg text}   firstx:INT
@{fg shine}(  22)@{fg text}   firsty:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT rastport
@{fg shine}(   0)@{fg text}   layer:PTR TO layer
@{fg shine}(   4)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(   8)@{fg text}   areaptrn:PTR TO INT
@{fg shine}(  12)@{fg text}   tmpras:PTR TO tmpras
@{fg shine}(  16)@{fg text}   areainfo:PTR TO areainfo
@{fg shine}(  20)@{fg text}   gelsinfo:PTR TO gelsinfo
@{fg shine}(  24)@{fg text}   mask:CHAR
@{fg shine}(  25)@{fg text}   fgpen:CHAR
@{fg shine}(  26)@{fg text}   bgpen:CHAR
@{fg shine}(  27)@{fg text}   aolpen:CHAR
@{fg shine}(  28)@{fg text}   drawmode:CHAR
@{fg shine}(  29)@{fg text}   areaptsz:CHAR
@{fg shine}(  30)@{fg text}   linpatcnt:CHAR
@{fg shine}(  31)@{fg text}   dummy:CHAR
@{fg shine}(  32)@{fg text}   flags:INT
@{fg shine}(  34)@{fg text}   lineptrn:INT
@{fg shine}(  36)@{fg text}   cp_x:INT
@{fg shine}(  38)@{fg text}   cp_y:INT
@{fg shine}(  40)@{fg text}   minterms[8]:ARRAY OF CHAR
@{fg shine}(  48)@{fg text}   penwidth:INT
@{fg shine}(  50)@{fg text}   penheight:INT
@{fg shine}(  52)@{fg text}   font:PTR TO textfont
@{fg shine}(  56)@{fg text}   algostyle:CHAR
@{fg shine}(  57)@{fg text}   txflags:CHAR
@{fg shine}(  58)@{fg text}   txheight:INT
@{fg shine}(  60)@{fg text}   txwidth:INT
@{fg shine}(  62)@{fg text}   txbaseline:INT
@{fg shine}(  64)@{fg text}   txspacing:INT
@{fg shine}(  66)@{fg text}   rp_user:PTR TO LONG
@{fg shine}(  70)@{fg text}   longreserved[2]:ARRAY OF LONG
@{fg shine}(  78)@{fg text}   wordreserved[7]:ARRAY OF INT
@{fg shine}(  92)@{fg text}   reserved[8]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=100 */

@{fg shine}(----)@{fg text} OBJECT gelsinfo
@{fg shine}(   0)@{fg text}   sprrsrvd:CHAR
@{fg shine}(   1)@{fg text}   flags:CHAR
@{fg shine}(   2)@{fg text}   gelhead:PTR TO vs
@{fg shine}(   6)@{fg text}   geltail:PTR TO vs
@{fg shine}(  10)@{fg text}   nextline:PTR TO INT
@{fg shine}(  14)@{fg text}   lastcolor:PTR TO LONG
@{fg shine}(  18)@{fg text}   collhandler:PTR TO colltable
@{fg shine}(  22)@{fg text}   leftmost:INT
@{fg shine}(  24)@{fg text}   rightmost:INT
@{fg shine}(  26)@{fg text}   topmost:INT
@{fg shine}(  28)@{fg text}   bottommost:INT
@{fg shine}(  30)@{fg text}   firstblissobj:LONG
@{fg shine}(  34)@{fg text}   lastblissobj:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

@{fg shine}(----)@{fg text} OBJECT tmpras
@{fg shine}(   0)@{fg text}   rasptr:PTR TO CHAR
@{fg shine}(   4)@{fg text}   size:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST RP_AOLPEN=27,
      RPF_DBUFFER=4,
      RP_LINPATCNT=30,
      FRST_DOT=1,
      ONE_DOT=2,
      RPF_ONE_DOT=2,
      RPF_FRST_DOT=1,
      RP_MASK=24,
      RP_INVERSVID=4,
      RP_LINEPTRN=$22,
      RP_AREAPTRN=8,
      RP_COMPLEMENT=2,
      RP_AREAPTSZ=29,
      FRST_DOTN=0,
      ONE_DOTN=1,
      RP_JAM1=0,
      RP_JAM2=1,
      RPF_AREAOUTLINE=8,
      RPF_NOCROSSFILL=$20,
      RPF_TXSCALE=1,
      RP_FLAGS=$20
@endnode
