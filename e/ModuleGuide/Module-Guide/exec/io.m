@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/io.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT iostd
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   device:PTR TO dd
@{fg shine}(  24)@{fg text}   unit:PTR TO unit
@{fg shine}(  28)@{fg text}   command:INT
@{fg shine}(  30)@{fg text}   flags:CHAR
@{fg shine}(  31)@{fg text}   error:CHAR
@{fg shine}(  32)@{fg text}   actual:LONG
@{fg shine}(  36)@{fg text}   length:LONG
@{fg shine}(  40)@{fg text}   data:LONG
@{fg shine}(  44)@{fg text}   offset:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=48 */

@{fg shine}(----)@{fg text} OBJECT io
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   device:PTR TO dd
@{fg shine}(  24)@{fg text}   unit:PTR TO unit
@{fg shine}(  28)@{fg text}   command:INT
@{fg shine}(  30)@{fg text}   flags:CHAR
@{fg shine}(  31)@{fg text}   error:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

CONST CMD_INVALID=0,
      IOF_QUICK=1,
      IOB_QUICK=0,
      CMD_WRITE=3,
      CMD_FLUSH=8,
      CMD_START=7,
      CMD_UPDATE=4,
      CMD_STOP=6,
      CMD_CLEAR=5,
      CMD_RESET=1,
      CMD_NONSTD=9,
      DEV_ABORTIO=$FFFFFFDC,
      CMD_READ=2,
      DEV_BEGINIO=-30
@endnode
