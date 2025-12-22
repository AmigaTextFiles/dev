@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/semaphores.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT sm
@{fg shine}(   0)@{fg text}   mp:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(  34)@{fg text}   bids:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=36 */

@{fg shine}(----)@{fg text} OBJECT semaphoremessage
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   semaphore:PTR TO ss
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT ss
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   nestcount:INT
@{fg shine}(  16)@{fg text}   waitqueue:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}(  28)@{fg text}   multiplelink:ssr @{fg shine}(or ARRAY OF ssr)@{fg text}
@{fg shine}(  40)@{fg text}   owner:PTR TO tc
@{fg shine}(  44)@{fg text}   queuecount:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=46 */

@{fg shine}(----)@{fg text} OBJECT ssr
@{fg shine}(   0)@{fg text}   mln:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   waiter:PTR TO tc
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST SM_LOCKMSG=16,
      SM_SHARED=1,
      SM_EXCLUSIVE=0
@endnode
