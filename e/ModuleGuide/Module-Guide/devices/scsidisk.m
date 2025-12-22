@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/scsidisk.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT scsicmd
@{fg shine}(   0)@{fg text}   data:PTR TO INT
@{fg shine}(   4)@{fg text}   length:LONG
@{fg shine}(   8)@{fg text}   actual:LONG
@{fg shine}(  12)@{fg text}   command:PTR TO CHAR
@{fg shine}(  16)@{fg text}   cmdlength:INT
@{fg shine}(  18)@{fg text}   cmdactual:INT
@{fg shine}(  20)@{fg text}   flags:CHAR
@{fg shine}(  21)@{fg text}   status:CHAR
@{fg shine}(  22)@{fg text}   sensedata:PTR TO CHAR
@{fg shine}(  26)@{fg text}   senselength:INT
@{fg shine}(  28)@{fg text}   senseactual:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=30 */

CONST HFERR_DMA=$29,
      SCSIB_READ_WRITE=0,
      SCSIF_WRITE=0,
      DEVICES_SCSIDISK_I=1,
      HFERR_BADSTATUS=$2D,
      HFERR_PARITY=$2B,
      HFERR_SELFUNIT=$28,
      HFERR_SELTIMEOUT=$2C,
      HFERR_PHASE=$2A,
      SCSIF_READ=1,
      SCSIB_OLDAUTOSENSE=2,
      SCSIB_AUTOSENSE=1,
      SCSIF_OLDAUTOSENSE=6,
      SCSIF_AUTOSENSE=2,
      SCSIF_NOSENSE=0,
      HD_SCSICMD=28,
      HFERR_NOBOARD=$32
@endnode
