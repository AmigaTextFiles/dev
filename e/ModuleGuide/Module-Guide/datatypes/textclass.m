@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes/textclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT line
@{fg shine}(   0)@{fg text}   link:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   text:PTR TO CHAR
@{fg shine}(  12)@{fg text}   textlen:LONG
@{fg shine}(  16)@{fg text}   xoffset:INT
@{fg shine}(  18)@{fg text}   yoffset:INT
@{fg shine}(  20)@{fg text}   width:INT
@{fg shine}(  22)@{fg text}   height:INT
@{fg shine}(  24)@{fg text}   flags:INT
@{fg shine}(  26)@{fg text}   fgpen:CHAR
@{fg shine}(  27)@{fg text}   bgpen:CHAR
@{fg shine}(  28)@{fg text}   style:LONG
@{fg shine}(  32)@{fg text}   data:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

CONST TDTA_BUFFER=$8000112C,
      ID_CHRS=$43485253,
      LNF_LF=1,
      TDTA_BUFFERLEN=$8000112D,
      LNF_OBJECT=4,
      ID_FTXT=$46545854,
      TDTA_WORDSELECT=$8000112F,
      TDTA_LINELIST=$8000112E,
      TDTA_WORDWRAP=$80001131,
      LNF_SELECTED=8,
      TDTA_WORDDELIM=$80001130,
      LNF_LINK=2

#define TEXTDTCLASS/0
@endnode
