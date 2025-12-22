@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/exall.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT exallcontrol
@{fg shine}(   0)@{fg text}   entries:LONG
@{fg shine}(   4)@{fg text}   lastkey:LONG
@{fg shine}(   8)@{fg text}   matchstring:PTR TO CHAR
@{fg shine}(  12)@{fg text}   matchfunc:PTR TO hook
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT exalldata
@{fg shine}(   0)@{fg text}   next:PTR TO exalldata
@{fg shine}(   4)@{fg text}   name:PTR TO CHAR
@{fg shine}(   8)@{fg text}   type:LONG
@{fg shine}(  12)@{fg text}   size:LONG
@{fg shine}(  16)@{fg text}   prot:LONG
@{fg shine}(  20)@{fg text}   days:LONG
@{fg shine}(  24)@{fg text}   mins:LONG
@{fg shine}(  28)@{fg text}   ticks:LONG
@{fg shine}(  32)@{fg text}   comment:PTR TO CHAR
@{fg shine}(  36)@{fg text}   owneruid:INT
@{fg shine}(  38)@{fg text}   ownergid:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

CONST ED_TYPE=2,
      ED_DATE=5,
      ED_PROTECTION=4,
      ED_COMMENT=6,
      ED_OWNER=7,
      ED_SIZE=3,
      ED_NAME=1
@endnode
