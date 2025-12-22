@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/pointer.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT rgbtable
@{fg shine}(   0)@{fg text}   red:CHAR
@{fg shine}(   1)@{fg text}   green:CHAR
@{fg shine}(   2)@{fg text}   blue:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=4 */

@{fg shine}(----)@{fg text} OBJECT pointerprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   which:INT
@{fg shine}(  18)@{fg text}   size:INT
@{fg shine}(  20)@{fg text}   width:INT
@{fg shine}(  22)@{fg text}   ieight:INT
@{fg shine}(  24)@{fg text}   depth:INT
@{fg shine}(  26)@{fg text}   ysize:INT
@{fg shine}(  28)@{fg text}   x:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=30 */

CONST WBP_NORMAL=0,
      WBP_BUSY=1,
      ID_PNTR=$504E5452
@endnode
