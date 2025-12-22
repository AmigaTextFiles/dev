@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/ports.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT mn
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   replyport:PTR TO mp
@{fg shine}(  18)@{fg text}   length:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT mp
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:CHAR
@{fg shine}(  15)@{fg text}   sigbit:CHAR
@{fg shine}(  16)@{fg text}   sigtask:LONG
@{fg shine}(  20)@{fg text}   msglist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

CONST PA_IGNORE=2,
      PA_SOFTINT=1,
      MP_SOFTINT=16,
      PF_ACTION=3,
      PA_SIGNAL=0
@endnode
