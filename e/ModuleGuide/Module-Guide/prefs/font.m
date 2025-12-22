@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/font.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT fontprefs
@{fg shine}(   0)@{fg text}   reserved[3]:ARRAY OF LONG
@{fg shine}(  12)@{fg text}   reserved2:INT
@{fg shine}(  14)@{fg text}   type:INT
@{fg shine}(  16)@{fg text}   frontpen:CHAR
@{fg shine}(  17)@{fg text}   backpen:CHAR
@{fg shine}(  18)@{fg text}   drawmode:CHAR
@{fg shine}(  20)@{fg text}   textattr:textattr @{fg shine}(or ARRAY OF textattr)@{fg text}
@{fg shine}(  28)@{fg text}   name[128]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=156 */

CONST FP_SCREENFONT=2,
      FP_SYSFONT=1,
      FP_WBFONT=0,
      ID_FONT=$464F4E54,
      FONTNAMESIZE=$80
@endnode
