@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/overscan.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT overscanprefs
@{fg shine}(   0)@{fg text}   reserved:LONG
@{fg shine}(   4)@{fg text}   magic:LONG
@{fg shine}(   8)@{fg text}   hstart:INT
@{fg shine}(  10)@{fg text}   hstop:INT
@{fg shine}(  12)@{fg text}   vstart:INT
@{fg shine}(  14)@{fg text}   vstop:INT
@{fg shine}(  16)@{fg text}   displayid:LONG
@{fg shine}(  20)@{fg text}   viewpos:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  24)@{fg text}   text:tpoint @{fg shine}(or ARRAY OF tpoint)@{fg text}
@{fg shine}(  28)@{fg text}   standard:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

CONST OSCAN_MAGIC=$FEDCBA89,
      ID_OSCN=$4F53434E
@endnode
