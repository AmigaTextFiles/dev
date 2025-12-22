@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/filehandler.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT devicenode
@{fg shine}(   0)@{fg text}   next:PTR TO CHAR
@{fg shine}(   4)@{fg text}   type:LONG
@{fg shine}(   8)@{fg text}   task:PTR TO mp
@{fg shine}(  12)@{fg text}   lock:LONG
@{fg shine}(  16)@{fg text}   handler:PTR TO CHAR
@{fg shine}(  20)@{fg text}   stacksize:LONG
@{fg shine}(  24)@{fg text}   priority:LONG
@{fg shine}(  28)@{fg text}   startup:LONG
@{fg shine}(  32)@{fg text}   seglist:LONG
@{fg shine}(  36)@{fg text}   globalvec:LONG
@{fg shine}(  40)@{fg text}   name:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT filesysstartupmsg
@{fg shine}(   0)@{fg text}   unit:LONG
@{fg shine}(   4)@{fg text}   device:PTR TO CHAR
@{fg shine}(   8)@{fg text}   environ:LONG
@{fg shine}(  12)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT dosenvec
@{fg shine}(   0)@{fg text}   tablesize:LONG
@{fg shine}(   4)@{fg text}   sizeblock:LONG
@{fg shine}(   8)@{fg text}   secorg:LONG
@{fg shine}(  12)@{fg text}   surfaces:LONG
@{fg shine}(  16)@{fg text}   sectorperblock:LONG
@{fg shine}(  20)@{fg text}   blockspertrack:LONG
@{fg shine}(  24)@{fg text}   reserved:LONG
@{fg shine}(  28)@{fg text}   prealloc:LONG
@{fg shine}(  32)@{fg text}   interleave:LONG
@{fg shine}(  36)@{fg text}   lowcyl:LONG
@{fg shine}(  40)@{fg text}   highcyl:LONG
@{fg shine}(  44)@{fg text}   numbuffers:LONG
@{fg shine}(  48)@{fg text}   bufmemtype:LONG
@{fg shine}(  52)@{fg text}   maxtransfer:LONG
@{fg shine}(  56)@{fg text}   mask:LONG
@{fg shine}(  60)@{fg text}   bootpri:LONG
@{fg shine}(  64)@{fg text}   dostype:LONG
@{fg shine}(  68)@{fg text}   baud:LONG
@{fg shine}(  72)@{fg text}   control:LONG
@{fg shine}(  76)@{fg text}   bootblocks:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=80 */

CONST DE_DOSTYPE=16,
      DE_BUFMEMTYPE=12,
      DE_MEMBUFTYPE=12,
      DE_BLKSPERTRACK=5,
      DE_UPPERCYL=10,
      DE_SIZEBLOCK=1,
      DE_SECORG=2,
      DE_PREFAC=7,
      DE_CONTROL=18,
      DE_BOOTPRI=15,
      DE_MASK=14,
      DE_LOWCYL=9,
      DE_BAUD=17,
      DE_NUMHEADS=3,
      DE_RESERVEDBLKS=6,
      DE_BOOTBLOCKS=19,
      DE_INTERLEAVE=8,
      DE_MAXTRANSFER=13,
      DE_NUMBUFFERS=11,
      DE_SECSPERBLK=4,
      DE_TABLESIZE=0
@endnode
