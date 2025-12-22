@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/configvars.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT currentbinding
@{fg shine}(   0)@{fg text}   configdev:PTR TO configdev
@{fg shine}(   4)@{fg text}   filename:PTR TO CHAR
@{fg shine}(   8)@{fg text}   productstring:PTR TO CHAR
@{fg shine}(  12)@{fg text}   tooltypes:PTR TO LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT configdev
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:CHAR
@{fg shine}(  15)@{fg text}   pad:CHAR
@{fg shine}(  16)@{fg text}   rom:expansionrom @{fg shine}(or ARRAY OF expansionrom)@{fg text}
@{fg shine}(  32)@{fg text}   boardaddr:LONG
@{fg shine}(  36)@{fg text}   boardsize:LONG
@{fg shine}(  40)@{fg text}   slotaddr:INT
@{fg shine}(  42)@{fg text}   slotsize:INT
@{fg shine}(  44)@{fg text}   driver:LONG
@{fg shine}(  48)@{fg text}   nextcd:PTR TO configdev
@{fg shine}(  52)@{fg text}   unused[4]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=68 */

CONST CDF_PROCESSED=8,
      CDB_PROCESSED=3,
      CDF_SHUTUP=1,
      CDB_SHUTUP=0,
      CDF_CONFIGME=2,
      CDB_CONFIGME=1,
      CDF_BADMEMORY=4,
      CDB_BADMEMORY=2
@endnode
