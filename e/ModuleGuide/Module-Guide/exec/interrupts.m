@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/interrupts.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT sh
@{fg shine}(   0)@{fg text}   lh:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(  14)@{fg text}   pad:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT iv
@{fg shine}(   0)@{fg text}   data:LONG
@{fg shine}(   4)@{fg text}   code:LONG
@{fg shine}(   8)@{fg text}   node:PTR TO ln
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT is
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   data:LONG
@{fg shine}(  18)@{fg text}   code:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=22 */

CONST SIH_PRIMASK=$F0,
      SF_SAR=$8000,
      INTF_NMI=$8000,
      INTB_NMI=15,
      SIH_QUEUES=5,
      SF_SINT=$2000,
      SF_TQE=$4000
@endnode
