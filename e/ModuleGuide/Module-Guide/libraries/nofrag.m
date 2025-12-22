@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/nofrag.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT nofragbase
@{fg shine}(   0)@{fg text}   lib:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

CONST NOFRAG_VERSION=2,
      NOFRAG_REVISION=2

@{fg shine}(----)@{fg text} OBJECT memoryblock
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   previous:LONG
@{fg shine}(   8)@{fg text}   requirements:LONG
@{fg shine}(  12)@{fg text}   bytesused:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT memoryitem
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   previous:LONG
@{fg shine}(   8)@{fg text}   block:LONG
@{fg shine}(  12)@{fg text}   size:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT blocklist
@{fg shine}(   0)@{fg text}   first:LONG
@{fg shine}(   4)@{fg text}   end:LONG
@{fg shine}(   8)@{fg text}   last:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT itemlist
@{fg shine}(   0)@{fg text}   first:LONG
@{fg shine}(   4)@{fg text}   end:LONG
@{fg shine}(   8)@{fg text}   last:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT memorychain
@{fg shine}(   0)@{fg text}   blocks:substructure
@{fg shine}(  12)@{fg text}   items:substructure
@{fg shine}(  24)@{fg text}   blocksize:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

CONST MINALLOC=16
@endnode
