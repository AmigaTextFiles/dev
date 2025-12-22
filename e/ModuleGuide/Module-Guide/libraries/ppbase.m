@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/ppbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST PPVERSION=$23

@{fg shine}(----)@{fg text} OBJECT ppbase
@{fg shine}(   0)@{fg text}   lib:substructure
@{fg shine}(  34)@{fg text}   flags:CHAR
@{fg shine}(  35)@{fg text}   pad:CHAR
@{fg shine}(  36)@{fg text}   seglist:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

CONST DECR_COL0=0,
      DECR_COL1=1,
      DECR_POINTER=2,
      DECR_SCROLL=3,
      DECR_NONE=4,
      PP_OPENERR=-1,
      PP_READERR=-2,
      PP_NOMEMORY=-3,
      PP_CRYPTED=-4,
      PP_PASSERR=-5,
      PP_UNKNOWNPP=-6,
      PP_EMPTYFILE=-7,
      SPEEDUP_BUFFLARGE=0,
      SPEEDUP_BUFFMEDIUM=1,
      SPEEDUP_BUFFSMALL=2,
      CRUN_FAST=0,
      CRUN_MEDIOCRE=1,
      CRUN_GOOD=2,
      CRUN_VERYGOOD=3,
      CRUN_BEST=4,
      PP_CRUNCHABORTED=0,
      PP_BUFFEROVERFLOW=-1
@endnode
