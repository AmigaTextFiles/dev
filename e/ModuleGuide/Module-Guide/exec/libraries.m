@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/libraries.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT lib
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:CHAR
@{fg shine}(  15)@{fg text}   pad:CHAR
@{fg shine}(  16)@{fg text}   negsize:INT
@{fg shine}(  18)@{fg text}   possize:INT
@{fg shine}(  20)@{fg text}   version:INT
@{fg shine}(  22)@{fg text}   revision:INT
@{fg shine}(  24)@{fg text}   idstring:PTR TO CHAR
@{fg shine}(  28)@{fg text}   sum:LONG
@{fg shine}(  32)@{fg text}   opencnt:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

CONST LIBF_DELEXP=8,
      LIB_OPEN=-6,
      LIB_BASE=-6,
      LIBF_SUMUSED=4,
      LIBF_SUMMING=1,
      LIBF_EXP0CNT=16,
      LIB_CLOSE=-12,
      LIB_NONSTD=-30,
      LIB_EXTFUNC=-24,
      LIB_RESERVED=4,
      LIBF_CHANGED=2,
      LIB_USERDEF=-30,
      LIB_VECTSIZE=6,
      LIB_EXPUNGE=-18
@endnode
