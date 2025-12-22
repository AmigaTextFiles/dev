@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/record.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT recordlock
@{fg shine}(   0)@{fg text}   fh:LONG
@{fg shine}(   4)@{fg text}   offset:LONG
@{fg shine}(   8)@{fg text}   length:LONG
@{fg shine}(  12)@{fg text}   mode:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

CONST REC_SHARED_IMMED=3,
      REC_EXCLUSIVE_IMMED=1,
      REC_SHARED=2,
      REC_EXCLUSIVE=0
@endnode
