@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/screenmode.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT screenmodeprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   displayid:LONG
@{fg shine}(  20)@{fg text}   width:INT
@{fg shine}(  22)@{fg text}   height:INT
@{fg shine}(  24)@{fg text}   depth:INT
@{fg shine}(  26)@{fg text}   control:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

CONST ID_SCRM=$5343524D,
      SMF_AUTOSCROLL=1,
      SMB_AUTOSCROLL=0
@endnode
