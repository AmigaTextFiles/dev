@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/memory.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT mc
@{fg shine}(   0)@{fg text}   next:PTR TO mc
@{fg shine}(   4)@{fg text}   bytes:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT mh
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   attributes:INT
@{fg shine}(  16)@{fg text}   first:PTR TO mc
@{fg shine}(  20)@{fg text}   lower:LONG
@{fg shine}(  24)@{fg text}   upper:LONG
@{fg shine}(  28)@{fg text}   free:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT memhandlerdata
@{fg shine}(   0)@{fg text}   requestsize:LONG
@{fg shine}(   4)@{fg text}   requestflags:LONG
@{fg shine}(   8)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT me
@{fg shine}(   0)@{fg text}   reqs:LONG
@{fg shine}(   0)@{fg text}   addr:LONG
@{fg shine}(   4)@{fg text}   length:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT ml
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   numentries:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

CONST MEMF_FAST=4,
      MEMF_24BITDMA=$200,
      MEM_ALL_DONE=-1,
      MEMF_LOCAL=$100,
      MEMF_REVERSE=$40000,
      MEM_BLOCKMASK=7,
      MEMF_LARGEST=$20000,
      MEMF_CLEAR=$10000,
      MEMF_PUBLIC=1,
      MEMF_CHIP=2,
      MEMF_KICK=$400,
      MEMF_ANY=0,
      MEM_TRY_AGAIN=1,
      MEMF_TOTAL=$80000,
      MEMHF_RECYCLE=1,
      MEM_DID_NOTHING=0,
      MEM_BLOCKSIZE=8,
      MEMF_NO_EXPUNGE=$80000000
@endnode
