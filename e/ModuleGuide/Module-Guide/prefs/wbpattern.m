@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/wbpattern.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT wbpatternprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   which:INT
@{fg shine}(  18)@{fg text}   flags:INT
@{fg shine}(  20)@{fg text}   revision:CHAR
@{fg shine}(  21)@{fg text}   depth:CHAR
@{fg shine}(  22)@{fg text}   datalength:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

CONST WBP_SCREEN=2,
      WBPF_NOREMAP=16,
      WBP_ROOT=0,
      ID_PTRN=$5054524E,
      WBP_DRAWER=1,
      PAT_HEIGHT=16,
      DEFPATDEPTH=2,
      MAXDEPTH=3,
      PAT_WIDTH=16,
      WBPF_PATTERN=1
@endnode
