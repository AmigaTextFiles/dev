ShowModule v1.10 (c) 1992 $#%!
now showing: "cdplay.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT cdvolume
(   0)   output[4]:ARRAY OF CHAR
(   4)   volume[4]:ARRAY OF CHAR
(----) ENDOBJECT     /* SIZEOF=8 */

(----) OBJECT cdtime
(   0)   trackcurbase:LONG
(   4)   trackremainbase:LONG
(   8)   trackcompletebase:LONG
(  12)   allcurbase:LONG
(  16)   allremainbase:LONG
(  20)   allcompletebase:LONG
(----) ENDOBJECT     /* SIZEOF=24 */

(----) OBJECT cdptoc
(   0)   tocsize:LONG
(   4)   firsttrack:CHAR
(   5)   lasttrack:CHAR
(   6)   track:cdtrack (or ARRAY OF cdtrack)
(----) ENDOBJECT     /* SIZEOF=1006 */

(----) OBJECT cdtrack
(   0)   position:LONG
(   4)   flags:LONG
(   8)   subchan:CHAR
(----) ENDOBJECT     /* SIZEOF=10 */

(----) OBJECT cdinquiry
(   0)   flags:LONG
(   4)   devicetype:CHAR
(   5)   ansiversion:CHAR
(   6)   responseformat:CHAR
(   7)   isoversion:CHAR
(   8)   ecmaversion:CHAR
(  10)   vendorid[10]:ARRAY OF CHAR
(  20)   productid[18]:ARRAY OF CHAR
(  38)   revisionlevel[6]:ARRAY OF CHAR
(  44)   vendorspecific[22]:ARRAY OF CHAR
(  66)   reserved[36]:ARRAY OF CHAR
(----) ENDOBJECT     /* SIZEOF=102 */

(----) OBJECT cdcapacity
(   0)   maxsector:LONG
(   4)   sectorsize:LONG
(   8)   capacity:LONG
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT cdrequest
(   0)   request:PTR TO iostd
(   4)   msgport:PTR TO mp
(   8)   capacity:PTR TO cdcapacity
(  12)   inquiry:PTR TO cdinquiry
(  16)   toc:PTR TO cdptoc
(  20)   time:PTR TO cdtime
(  24)   volume:PTR TO cdvolume
(  28)   id[20]:ARRAY OF CHAR
(  48)   active:CHAR
(  49)   currenttrack:CHAR
(  50)   currentaddress:LONG
(  54)   scsisense:CHAR
(  55)   scsidata:CHAR
(  56)   tocbuf:CHAR
(----) ENDOBJECT     /* SIZEOF=58 */

CONST DEVTYPE_SCANNER=6,
      RESP_SCSI_1=0,
      ANSI_SCSI_1=1,
      RESP_SCSI_2=2,
      ANSI_SCSI_2=2,
      DEVTYPE_PROCESSOR=3,
      DEVTYPE_WRITE_ONCE=4,
      TOC_SUBCHAN_NOT_AVAIL=0,
      DEVTYPE_COMMUNICATIONS=9,
      DEVTYPE_CDROM=5,
      DEVTYPE_OPTICAL=7,
      SCSI_STAT_PAUSED=3,
      SCSI_STAT_PLAYING=1,
      RESP_CCS=1,
      DEVTYPE_UNKNOWN=-1,
      SCSI_STAT_STOPPED=2,
      TOC_SUBCHAN_MEDIA_CATALOG_NUM=2,
      ANSI_NONE=0,
      DEVTYPE_SEQUENTIAL_ACCESS=1,
      DEVTYPE_DIRECT_ACCESS=0,
      DEVTYPE_PRINTER=2,
      TOC_SUBCHAN_RESERVED=-1,
      DEVTYPE_ASC_IT8_1=10,
      TOC_SUBCHAN_CURRENT_POS=1,
      DEVTYPE_ASC_IT8_2=11,
      SCSI_STAT_NO_DISK=0,
      DEVTYPE_MEDIUM_CHANGER=8,
      TOC_SUBCHAN_ISRC=3,
      CDPLAYVERSION=$25

#define IFLAG_PRE_EMPHASIS/0
#define IFLAG_AUDIO_TRACK/0
#define base2min/1
#define IFLAG_AENC/0
#define IFLAG_COPY_PROHIBITED/0
#define IFLAG_32WIDE_DATA/0
#define IFLAG_16WIDE_DATA/0
#define IFLAG_REL_ADDRESS/0
#define IFLAG_SYNC/0
#define bchg/2
#define IFLAG_REMOVABLE/0
#define IFLAG_SOFTRESET/0
#define base2sec/1
#define IFLAG_TRMIOP/0
#define bset/2
#define IFLAG_CMDQUE/0
#define IFLAG_LINKED/0
#define btst/2
#define IFLAG_2_CHAN/0
#define CDPLAYNAME/0

