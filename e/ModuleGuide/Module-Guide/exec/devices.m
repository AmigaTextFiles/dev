@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/devices.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT unit
@{fg shine}(   0)@{fg text}   mp:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(  34)@{fg text}   flags:CHAR
@{fg shine}(  35)@{fg text}   pad:CHAR
@{fg shine}(  36)@{fg text}   opencnt:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

@{fg shine}(----)@{fg text} OBJECT dd
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=34 */

CONST UNITF_ACTIVE=1,
      UNITF_INTASK=2
@endnode
