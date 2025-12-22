@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/trackdisk.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT publicunit
@{fg shine}(   0)@{fg text}   unit:unit @{fg shine}(or ARRAY OF unit)@{fg text}
@{fg shine}(  38)@{fg text}   comp01track:INT
@{fg shine}(  40)@{fg text}   comp10track:INT
@{fg shine}(  42)@{fg text}   comp11track:INT
@{fg shine}(  44)@{fg text}   stepdelay:LONG
@{fg shine}(  48)@{fg text}   settledelay:LONG
@{fg shine}(  52)@{fg text}   retrycnt:CHAR
@{fg shine}(  53)@{fg text}   pubflags:CHAR
@{fg shine}(  54)@{fg text}   currtrk:INT
@{fg shine}(  56)@{fg text}   calibratedelay:LONG
@{fg shine}(  60)@{fg text}   counter:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=64 */

@{fg shine}(----)@{fg text} OBJECT drivegeometry
@{fg shine}(   0)@{fg text}   sectorsize:LONG
@{fg shine}(   4)@{fg text}   totalsectors:LONG
@{fg shine}(   8)@{fg text}   cylinders:LONG
@{fg shine}(  12)@{fg text}   cylsectors:LONG
@{fg shine}(  16)@{fg text}   heads:LONG
@{fg shine}(  20)@{fg text}   tracksectors:LONG
@{fg shine}(  24)@{fg text}   bufmemtype:LONG
@{fg shine}(  28)@{fg text}   devicetype:CHAR
@{fg shine}(  29)@{fg text}   flags:CHAR
@{fg shine}(  30)@{fg text}   reserved:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT ioexttd
@{fg shine}(   0)@{fg text}   iostd:iostd @{fg shine}(or ARRAY OF iostd)@{fg text}
@{fg shine}(  48)@{fg text}   count:LONG
@{fg shine}(  52)@{fg text}   seclabel:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=56 */

CONST DG_SCANNER=6,
      TDERR_BADDRIVETYPE=$21,
      TD_GETDRIVETYPE=18,
      TD_REMOVE=12,
      TDF_EXTCOM=$8000,
      ETD_RAWWRITE=$8011,
      ETD_WRITE=$8003,
      TD_RAWWRITE=17,
      TD_CHANGENUM=13,
      DG_PROCESSOR=3,
      TDERR_BADSECHDR=27,
      TDERR_NOSECHDR=21,
      ETD_FORMAT=$800B,
      TD_FORMAT=11,
      TD_PROTSTATUS=15,
      DRIVE3_5=1,
      TDERR_NOMEM=31,
      TDERR_BADSECID=23,
      ETD_UPDATE=$8004,
      TD_CHANGESTATE=14,
      IOTDF_WORDSYNC=$20,
      IOTDB_WORDSYNC=5,
      IOTDF_INDEXSYNC=16,
      IOTDB_INDEXSYNC=4,
      DG_CDROM=5,
      TD_EJECT=23,
      TD_SECTOR=$200,
      TDERR_BADHDRSUM=24,
      TDPF_NOCLICK=1,
      TDPB_NOCLICK=0,
      DGF_REMOVABLE=1,
      DGB_REMOVABLE=0,
      DG_COMMUNICATION=9,
      ETD_CLEAR=$8005,
      TDERR_POSTRESET=$23,
      TDERR_TOOFEWSECS=26,
      NUMSECS=11,
      TDERR_SEEKERROR=30,
      NUMUNITS=4,
      ETD_SEEK=$800A,
      TD_SEEK=10,
      TD_GETNUMTRACKS=19,
      TD_SECSHIFT=9,
      DG_UNKNOWN=31,
      TDERR_NOTSPECIFIED=20,
      TD_GETGEOMETRY=22,
      DG_SEQUENTIAL_ACCESS=1,
      DG_DIRECT_ACCESS=0,
      TDERR_WRITEPROT=28,
      TD_LASTCOMM=24,
      ETD_MOTOR=$8009,
      TD_MOTOR=9,
      TDERR_BADUNITNUM=$20,
      TDF_ALLOW_NON_3_5=1,
      TDB_ALLOW_NON_3_5=0,
      DG_PRINTER=2,
      TDERR_BADSECPREAMBLE=22,
      TD_REMCHANGEINT=21,
      TD_ADDCHANGEINT=20,
      TDERR_BADSECSUM=25,
      ETD_RAWREAD=$8010,
      ETD_READ=$8002,
      TD_RAWREAD=16,
      DG_OPTICAL_DISK=7,
      TDERR_DISKCHANGED=29,
      DG_WORM=4,
      DRIVE3_5_150RPM=3,
      TDERR_DRIVEINUSE=$22,
      DG_MEDIUM_CHANGER=8,
      DRIVE5_25=2,
      TD_LABELSIZE=16

#define TD_NAME/0
@endnode
