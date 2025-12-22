@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/configregs.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT diagarea
@{fg shine}(   0)@{fg text}   config:CHAR
@{fg shine}(   1)@{fg text}   flags:CHAR
@{fg shine}(   2)@{fg text}   size:INT
@{fg shine}(   4)@{fg text}   diagpoint:INT
@{fg shine}(   6)@{fg text}   bootpoint:INT
@{fg shine}(   8)@{fg text}   name:INT
@{fg shine}(  10)@{fg text}   reserved01:INT
@{fg shine}(  12)@{fg text}   reserved02:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

@{fg shine}(----)@{fg text} OBJECT expansioncontrol
@{fg shine}(   0)@{fg text}   interrupt:CHAR
@{fg shine}(   1)@{fg text}   z3_highbase:CHAR
@{fg shine}(   2)@{fg text}   baseaddress:CHAR
@{fg shine}(   3)@{fg text}   shutup:CHAR
@{fg shine}(   4)@{fg text}   reserved14:CHAR
@{fg shine}(   5)@{fg text}   reserved15:CHAR
@{fg shine}(   6)@{fg text}   reserved16:CHAR
@{fg shine}(   7)@{fg text}   reserved17:CHAR
@{fg shine}(   8)@{fg text}   reserved18:CHAR
@{fg shine}(   9)@{fg text}   reserved19:CHAR
@{fg shine}(  10)@{fg text}   reserved1a:CHAR
@{fg shine}(  11)@{fg text}   reserved1b:CHAR
@{fg shine}(  12)@{fg text}   reserved1c:CHAR
@{fg shine}(  13)@{fg text}   reserved1d:CHAR
@{fg shine}(  14)@{fg text}   reserved1e:CHAR
@{fg shine}(  15)@{fg text}   reserved1f:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT expansionrom
@{fg shine}(   0)@{fg text}   type:CHAR
@{fg shine}(   1)@{fg text}   product:CHAR
@{fg shine}(   2)@{fg text}   flags:CHAR
@{fg shine}(   3)@{fg text}   reserved03:CHAR
@{fg shine}(   4)@{fg text}   manufacturer:INT
@{fg shine}(   6)@{fg text}   serialnumber:LONG
@{fg shine}(  10)@{fg text}   initdiagvec:INT
@{fg shine}(  12)@{fg text}   reserved0c:CHAR
@{fg shine}(  13)@{fg text}   reserved0d:CHAR
@{fg shine}(  14)@{fg text}   reserved0e:CHAR
@{fg shine}(  15)@{fg text}   reserved0f:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

CONST DAC_NEVER=0,
      ERFF_ZORRO_III=16,
      ERFB_ZORRO_III=4,
      ERT_ZORROIII=$80,
      ERTF_DIAGVALID=16,
      ERTB_DIAGVALID=4,
      ERT_TYPEBIT=6,
      ERT_ZORROII=$C0,
      EZ3_CONFIGAREAEND=$7FFFFFFF,
      DAC_BINDTIME=$20,
      DAC_CONFIGTIME=16,
      DAC_BOOTTIME=$30,
      EZ3_SIZEGRANULARITY=$80000,
      ERFF_EXTENDED=$20,
      ERFB_EXTENDED=5,
      ERT_Z3_SSBIT=0,
      ECIF_INTERRUPTING=$80,
      ECIB_INTERRUPTING=7,
      ERFF_MEMSPACE=$80,
      ERFB_MEMSPACE=7,
      ERT_Z3_SSMASK=15,
      ERT_MEMMASK=7,
      ERT_TYPEMASK=$C0,
      E_SLOTMASK=$FFFF,
      E_MEMORYBASE=$200000,
      EZ3_EXPANSIONBASE=$FF000000,
      E_EXPANSIONBASE=$E80000,
      ECIF_INTENA=2,
      ECIB_INTENA=1,
      ECIF_RESET=8,
      ECIB_RESET=3,
      EZ3_CONFIGAREA=$40000000,
      E_MEMORYSLOTS=$80,
      E_EXPANSIONSLOTS=8,
      E_SLOTSHIFT=16,
      ERTF_MEMLIST=$20,
      ERTB_MEMLIST=5,
      ECIF_INT7PEND=$40,
      ECIF_INT6PEND=$20,
      ECIF_INT2PEND=16,
      ECIB_INT7PEND=6,
      ECIB_INT6PEND=5,
      ECIB_INT2PEND=4,
      ERT_MEMBIT=0,
      ERFF_NOSHUTUP=$40,
      ERFB_NOSHUTUP=6,
      DAC_BUSWIDTH=$C0,
      DAC_WORDWIDE=$80,
      DAC_BYTEWIDE=$40,
      DAC_NIBBLEWIDE=0,
      ERT_Z3_SSSIZE=4,
      ERT_MEMSIZE=3,
      ERT_TYPESIZE=2,
      E_MEMORYSIZE=$800000,
      E_EXPANSIONSIZE=$80000,
      E_SLOTSIZE=$10000,
      ERTF_CHAINEDCONFIG=8,
      ERTB_CHAINEDCONFIG=3,
      ERT_NEWBOARD=$C0

#define ERT_SLOTSNEEDED/1
#define ERT_MEMNEEDED/1
#define EC_MEMADDR/1
@endnode
