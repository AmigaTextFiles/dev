@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/expansionbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT expansionbase
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   flags:CHAR
@{fg shine}(  35)@{fg text}   private01:CHAR
@{fg shine}(  36)@{fg text}   private02:LONG
@{fg shine}(  40)@{fg text}   private03:LONG
@{fg shine}(  44)@{fg text}   private04:currentbinding @{fg shine}(or ARRAY OF currentbinding)@{fg text}
@{fg shine}(  60)@{fg text}   private05:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(  74)@{fg text}   mountlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=88 */

@{fg shine}(----)@{fg text} OBJECT bootnode
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:INT
@{fg shine}(  16)@{fg text}   devicenode:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

CONST EE_OK=0,
      EBF_SILENTSTART=$40,
      EBB_SILENTSTART=6,
      EBF_START_CC0=$80,
      EBB_START_CC0=7,
      EBF_BADMEM=4,
      EBB_BADMEM=2,
      EBF_SHORTMEM=2,
      EBB_SHORTMEM=1,
      EE_BADMEM=$2C,
      EBF_KICKBACK33=16,
      EBB_KICKBACK33=4,
      EBF_KICKBACK36=$20,
      EBB_KICKBACK36=5,
      EBF_DOSFLAG=8,
      EBB_DOSFLAG=3,
      EBF_CLOGGED=1,
      EBB_CLOGGED=0,
      EE_NOMEMORY=$2A,
      EE_NOEXPANSION=$29,
      EE_NOBOARD=$2B,
      EE_LASTBOARD=$28
@endnode
