OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'exec/ports'
MODULE 'exec/io'

#define CDPLAYNAME 'cdplay.library'
CONST CDPLAYVERSION = 37

#define base2min(val)  ((val)/75/60)

#define base2sec(val)  Mod(((val)/75),60)

#define btst(n,m)  (n AND m)

#define bchg(n,m)          (n := IF (n AND m) THEN (n AND (NOT m)) ELSE ( n OR m))

#define bset(n,m)          (n := n OR m)

OBJECT cdrequest
    request           : PTR TO iostd
    msgport           : PTR TO mp
    capacity          : PTR TO cdcapacity
    inquiry           : PTR TO cdinquiry
    toc               : PTR TO cdptoc
    time              : PTR TO cdtime
    volume            : PTR TO cdvolume

    id[20]            : ARRAY OF CHAR
    active            : CHAR
    currenttrack      : CHAR
    currentaddress

    scsisense         : CHAR
    scsidata          : CHAR
    tocbuf            : CHAR
ENDOBJECT

OBJECT cdcapacity
    maxsector
    sectorsize
    capacity
ENDOBJECT

CONST DEVTYPE_DIRECT_ACCESS       =    $00
CONST DEVTYPE_SEQUENTIAL_ACCESS   =    $01
CONST DEVTYPE_PRINTER             =    $02
CONST DEVTYPE_PROCESSOR           =    $03
CONST DEVTYPE_WRITE_ONCE          =    $04
CONST DEVTYPE_CDROM               =    $05
CONST DEVTYPE_SCANNER             =    $06
CONST DEVTYPE_OPTICAL             =    $07
CONST DEVTYPE_MEDIUM_CHANGER      =    $08
CONST DEVTYPE_COMMUNICATIONS      =    $09
CONST DEVTYPE_ASC_IT8_1           =    $0A
CONST DEVTYPE_ASC_IT8_2           =    $0B
CONST DEVTYPE_UNKNOWN             =     -1

CONST ANSI_NONE          =   $00
CONST ANSI_SCSI_1        =   $01
CONST ANSI_SCSI_2        =   $02

CONST RESP_SCSI_1          =   $00
CONST RESP_CCS             =   $01
CONST RESP_SCSI_2          =   $02

CONST IFLAG_REMOVABLE                 = 1 SHL 0
CONST IFLAG_AENC                      = 1 SHL 1
CONST IFLAG_REL_ADDRESS               = 1 SHL 2
CONST IFLAG_16WIDE_DATA               = 1 SHL 3
CONST IFLAG_32WIDE_DATA               = 1 SHL 4
CONST IFLAG_SYNC                      = 1 SHL 5
CONST IFLAG_LINKED                    = 1 SHL 6
CONST IFLAG_CMDQUE                    = 1 SHL 7
CONST IFLAG_SOFTRESET                 = 1 SHL 8
CONST IFLAG_TRMIOP                    = 1 SHL 9

OBJECT cdinquiry
    flags
    devicetype          : CHAR
    ansiversion         : CHAR
    responseformat      : CHAR
    isoversion          : CHAR
    ecmaversion         : CHAR
    vendorid[9]         : ARRAY OF CHAR
    productid[17]       : ARRAY OF CHAR
    revisionlevel[5]    : ARRAY OF CHAR
    vendorspecific[21]  : ARRAY OF CHAR
    reserved[36]        : ARRAY OF CHAR
ENDOBJECT

CONST TOC_SUBCHAN_NOT_AVAIL                 =  $00
CONST TOC_SUBCHAN_CURRENT_POS               =  $01
CONST TOC_SUBCHAN_MEDIA_CATALOG_NUM         =  $02
CONST TOC_SUBCHAN_ISRC                      =  $03
CONST TOC_SUBCHAN_RESERVED                  =  -1

CONST IFLAG_PRE_EMPHASIS                              = 1 SHL 0
CONST IFLAG_COPY_PROHIBITED                           = 1 SHL 1
CONST IFLAG_AUDIO_TRACK                               = 1 SHL 2
CONST IFLAG_2_CHAN                                    = 1 SHL 3

OBJECT cdtrack
    position,
    flags,
    subchan             : CHAR
ENDOBJECT

OBJECT cdptoc
    tocsize
    firsttrack          : CHAR
    lasttrack           : CHAR
    track[100]          : ARRAY OF cdtrack
ENDOBJECT

OBJECT cdtime
    trackcurbase
    trackremainbase
    trackcompletebase
    allcurbase
    allremainbase
    allcompletebase
ENDOBJECT

OBJECT cdvolume
    output[4]           : ARRAY OF CHAR
    volume[4]           : ARRAY OF CHAR
ENDOBJECT

CONST SCSI_STAT_NO_DISK      = 0
CONST SCSI_STAT_PLAYING      = 1
CONST SCSI_STAT_STOPPED      = 2
CONST SCSI_STAT_PAUSED       = 3
