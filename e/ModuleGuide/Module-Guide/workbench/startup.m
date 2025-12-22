@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "workbench/startup.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT wbarg
@{fg shine}(   0)@{fg text}   lock:LONG
@{fg shine}(   4)@{fg text}   name:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT wbstartup
@{fg shine}(   0)@{fg text}   message:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   process:PTR TO mp
@{fg shine}(  24)@{fg text}   segment:LONG
@{fg shine}(  28)@{fg text}   numargs:LONG
@{fg shine}(  32)@{fg text}   toolwindow:PTR TO CHAR
@{fg shine}(  36)@{fg text}   arglist:PTR TO wbarg
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

CONST WORKBENCH_STARTUP_I=1
@endnode
