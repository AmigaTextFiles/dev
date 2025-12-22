@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/hardblocks.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT loadsegblock
@{fg shine}(   0)@{fg text}   id:LONG
@{fg shine}(   4)@{fg text}   summedlongs:LONG
@{fg shine}(   8)@{fg text}   chksum:LONG
@{fg shine}(  12)@{fg text}   hostid:LONG
@{fg shine}(  16)@{fg text}   next:LONG
@{fg shine}(  20)@{fg text}   loaddata[123]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=512 */

@{fg shine}(----)@{fg text} OBJECT filesysheaderblock
@{fg shine}(   0)@{fg text}   id:LONG
@{fg shine}(   4)@{fg text}   summedlongs:LONG
@{fg shine}(   8)@{fg text}   chksum:LONG
@{fg shine}(  12)@{fg text}   hostid:LONG
@{fg shine}(  16)@{fg text}   next:LONG
@{fg shine}(  20)@{fg text}   flags:LONG
@{fg shine}(  24)@{fg text}   reserved1[2]:ARRAY OF LONG
@{fg shine}(  32)@{fg text}   dostype:LONG
@{fg shine}(  36)@{fg text}   version:LONG
@{fg shine}(  40)@{fg text}   patchflags:LONG
@{fg shine}(  44)@{fg text}   type:LONG
@{fg shine}(  48)@{fg text}   task:LONG
@{fg shine}(  52)@{fg text}   lock:LONG
@{fg shine}(  56)@{fg text}   handler:LONG
@{fg shine}(  60)@{fg text}   stacksize:LONG
@{fg shine}(  64)@{fg text}   priority:LONG
@{fg shine}(  68)@{fg text}   startup:LONG
@{fg shine}(  72)@{fg text}   seglistblocks:LONG
@{fg shine}(  76)@{fg text}   globalvec:LONG
@{fg shine}(  80)@{fg text}   reserved2[23]:ARRAY OF LONG
@{fg shine}( 172)@{fg text}   reserved3[21]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=256 */

@{fg shine}(----)@{fg text} OBJECT partitionblock
@{fg shine}(   0)@{fg text}   id:LONG
@{fg shine}(   4)@{fg text}   summedlongs:LONG
@{fg shine}(   8)@{fg text}   chksum:LONG
@{fg shine}(  12)@{fg text}   hostid:LONG
@{fg shine}(  16)@{fg text}   next:LONG
@{fg shine}(  20)@{fg text}   flags:LONG
@{fg shine}(  24)@{fg text}   reserved1[2]:ARRAY OF LONG
@{fg shine}(  32)@{fg text}   devflags:LONG
@{fg shine}(  36)@{fg text}   drivename[32]:ARRAY OF CHAR
@{fg shine}(  68)@{fg text}   reserved2[15]:ARRAY OF LONG
@{fg shine}( 128)@{fg text}   environment[17]:ARRAY OF LONG
@{fg shine}( 196)@{fg text}   ereserved[15]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=256 */

@{fg shine}(----)@{fg text} OBJECT badblockblock
@{fg shine}(   0)@{fg text}   id:LONG
@{fg shine}(   4)@{fg text}   summedlongs:LONG
@{fg shine}(   8)@{fg text}   chksum:LONG
@{fg shine}(  12)@{fg text}   hostid:LONG
@{fg shine}(  16)@{fg text}   next:LONG
@{fg shine}(  20)@{fg text}   reserved:LONG
@{fg shine}(  24)@{fg text}   blockpairs:badblockentry @{fg shine}(or ARRAY OF badblockentry)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=512 */

@{fg shine}(----)@{fg text} OBJECT badblockentry
@{fg shine}(   0)@{fg text}   badblock:LONG
@{fg shine}(   4)@{fg text}   goodblock:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT rigiddiskblock
@{fg shine}(   0)@{fg text}   id:LONG
@{fg shine}(   4)@{fg text}   summedlongs:LONG
@{fg shine}(   8)@{fg text}   chksum:LONG
@{fg shine}(  12)@{fg text}   hostid:LONG
@{fg shine}(  16)@{fg text}   blockbytes:LONG
@{fg shine}(  20)@{fg text}   flags:LONG
@{fg shine}(  24)@{fg text}   badblocklist:LONG
@{fg shine}(  28)@{fg text}   partitionlist:LONG
@{fg shine}(  32)@{fg text}   filesysheaderlist:LONG
@{fg shine}(  36)@{fg text}   driveinit:LONG
@{fg shine}(  40)@{fg text}   reserved1[6]:ARRAY OF LONG
@{fg shine}(  64)@{fg text}   cylinders:LONG
@{fg shine}(  68)@{fg text}   sectors:LONG
@{fg shine}(  72)@{fg text}   heads:LONG
@{fg shine}(  76)@{fg text}   interleave:LONG
@{fg shine}(  80)@{fg text}   park:LONG
@{fg shine}(  84)@{fg text}   reserved2[3]:ARRAY OF LONG
@{fg shine}(  96)@{fg text}   writeprecomp:LONG
@{fg shine}( 100)@{fg text}   reducedwrite:LONG
@{fg shine}( 104)@{fg text}   steprate:LONG
@{fg shine}( 108)@{fg text}   reserved3[5]:ARRAY OF LONG
@{fg shine}( 128)@{fg text}   rdbblockslo:LONG
@{fg shine}( 132)@{fg text}   rdbblockshi:LONG
@{fg shine}( 136)@{fg text}   locylinder:LONG
@{fg shine}( 140)@{fg text}   hicylinder:LONG
@{fg shine}( 144)@{fg text}   cylblocks:LONG
@{fg shine}( 148)@{fg text}   autoparkseconds:LONG
@{fg shine}( 152)@{fg text}   highrdskblock:LONG
@{fg shine}( 156)@{fg text}   reserved4:LONG
@{fg shine}( 160)@{fg text}   diskvendor[8]:ARRAY OF CHAR
@{fg shine}( 168)@{fg text}   diskproduct[16]:ARRAY OF CHAR
@{fg shine}( 184)@{fg text}   diskrevision[4]:ARRAY OF CHAR
@{fg shine}( 188)@{fg text}   controllervendor[8]:ARRAY OF CHAR
@{fg shine}( 196)@{fg text}   controllerproduct[16]:ARRAY OF CHAR
@{fg shine}( 212)@{fg text}   controllerrevision[4]:ARRAY OF CHAR
@{fg shine}( 216)@{fg text}   reserved5[10]:ARRAY OF LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=256 */

CONST RDBFF_DISKID=16,
      RDBFB_DISKID=4,
      IDNAME_BADBLOCK=$42414442,
      RDBFF_LASTLUN=2,
      RDBFB_LASTLUN=1,
      RDBFF_SYNCH=$40,
      RDBFB_SYNCH=6,
      PBFF_BOOTABLE=1,
      PBFF_BOOTABLE=0,
      IDNAME_PARTITION=$50415254,
      RDBFF_LASTTID=4,
      RDBFB_LASTTID=2,
      IDNAME_FILESYSHEADER=$46534844,
      RDBFF_NORESELECT=8,
      RDBFB_NORESELECT=3,
      RDB_LOCATION_LIMIT=16,
      RDBFF_CTRLRID=$20,
      RDBFB_CTRLRID=5,
      PBFF_NOMOUNT=2,
      PBFF_NOMOUNT=1,
      IDNAME_RIGIDDISK=$5244534B,
      RDBFF_LAST=1,
      RDBFB_LAST=0,
      IDNAME_LOADSEG=$4C534547
@endnode
