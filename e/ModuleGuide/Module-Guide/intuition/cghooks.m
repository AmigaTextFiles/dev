@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/cghooks.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT pgx
@{fg shine}(   0)@{fg text}   container:ibox @{fg shine}(or ARRAY OF ibox)@{fg text}
@{fg shine}(   8)@{fg text}   newknob:ibox @{fg shine}(or ARRAY OF ibox)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT gadgetinfo
@{fg shine}(   0)@{fg text}   screen:PTR TO screen
@{fg shine}(   4)@{fg text}   window:PTR TO window
@{fg shine}(   8)@{fg text}   requester:PTR TO requester
@{fg shine}(  12)@{fg text}   rastport:PTR TO rastport
@{fg shine}(  16)@{fg text}   layer:PTR TO layer
@{fg shine}(  20)@{fg text}   domain:ibox @{fg shine}(or ARRAY OF ibox)@{fg text}
@{fg shine}(  28)@{fg text}   detailpen:CHAR
@{fg shine}(  29)@{fg text}   blockpen:CHAR
@{fg shine}(  30)@{fg text}   drinfo:PTR TO drawinfo
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

#define CUSTOM_HOOK/1
@endnode
