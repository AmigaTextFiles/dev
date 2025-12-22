@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "resources/filesysres.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT filesysentry
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   dostype:LONG
@{fg shine}(  18)@{fg text}   version:LONG
@{fg shine}(  22)@{fg text}   patchflags:LONG
@{fg shine}(  26)@{fg text}   type:LONG
@{fg shine}(  30)@{fg text}   task:PTR TO tc
@{fg shine}(  34)@{fg text}   lock:LONG
@{fg shine}(  38)@{fg text}   handler:PTR TO CHAR
@{fg shine}(  42)@{fg text}   stacksize:LONG
@{fg shine}(  46)@{fg text}   priority:LONG
@{fg shine}(  50)@{fg text}   startup:LONG
@{fg shine}(  54)@{fg text}   seglist:LONG
@{fg shine}(  58)@{fg text}   globalvec:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=62 */

@{fg shine}(----)@{fg text} OBJECT filesysresource
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   creator:PTR TO CHAR
@{fg shine}(  18)@{fg text}   filesysentries:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

#define FSRNAME/0
@endnode
