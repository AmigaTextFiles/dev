@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "intuition/classes.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT object
@{fg shine}(   0)@{fg text}   node:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   class:PTR TO iclass
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT iclass
@{fg shine}(   0)@{fg text}   dispatcher:hook @{fg shine}(or ARRAY OF hook)@{fg text}
@{fg shine}(  20)@{fg text}   reserved:LONG
@{fg shine}(  24)@{fg text}   super:PTR TO iclass
@{fg shine}(  28)@{fg text}   id:LONG
@{fg shine}(  32)@{fg text}   instoffset:INT
@{fg shine}(  34)@{fg text}   instsize:INT
@{fg shine}(  36)@{fg text}   userdata:LONG
@{fg shine}(  40)@{fg text}   subclasscount:LONG
@{fg shine}(  44)@{fg text}   objectcount:LONG
@{fg shine}(  48)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=52 */

CONST CLF_INLIST=1,
      CLB_INLIST=0,
      OJ_CLASS=8

#define SIZEOF_INSTANCE/1
#define INST_DATA/2
#define _OBJECT/1
#define BASEOBJECT/1
#define _OBJ/1
#define OCLASS/1
@endnode
