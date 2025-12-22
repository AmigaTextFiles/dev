/* $Id: trackdisk.h,v 1.12 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/io', 'target/exec/devices'
MODULE 'target/exec/types'
{#include <devices/trackdisk.h>}
NATIVE {DEVICES_TRACKDISK_H} CONST

/*
 *--------------------------------------------------------------------
 *
 * Physical drive constants
 *
 *--------------------------------------------------------------------
 */

/* OBSOLETE -- use the TD_GETNUMTRACKS command! */
/*#define NUMCYLS   80*/           /*  normal # of cylinders */
/*#define MAXCYLS   (NUMCYLS+20)*/ /* max # cyls to look for during cal */
/*#define NUMHEADS  2*/
/*#define NUMTRACKS (NUMCYLS*NUMHEADS)*/

NATIVE {NUMSECS}  CONST NUMSECS  = 11
NATIVE {NUMUNITS}  CONST NUMUNITS  = 4

/*
 *--------------------------------------------------------------------
 *
 * Useful constants
 *
 *--------------------------------------------------------------------
 */

/*-- sizes before mfm encoding */
NATIVE {TD_SECTOR}    CONST TD_SECTOR    = 512
NATIVE {TD_SECSHIFT}    CONST TD_SECSHIFT    = 9    /* log TD_SECTOR */

/*
 *--------------------------------------------------------------------
 *
 * Driver Specific Commands
 *
 *--------------------------------------------------------------------
 */

/*
 *-- TD_NAME is a generic macro to get the name of the driver.    This
 *-- way if the name is ever changed you will pick up the change
 *-- automatically.
 *--
 *-- Normal usage would be:
 *--
 *-- char internalName[] = TD_NAME;
 *--
 */

NATIVE {TD_NAME} CONST
#define TD_NAME td_name
STATIC td_name = 'trackdisk.device'

NATIVE {TDF_EXTCOM} CONST TDF_EXTCOM = $8000 /* for internal use only! */

NATIVE {TD_MOTOR}        CONST TD_MOTOR        = (CMD_NONSTD+0)  /* control the disk's motor */
NATIVE {TD_SEEK}         CONST TD_SEEK         = (CMD_NONSTD+1)  /* explicit seek (for testing) */
NATIVE {TD_FORMAT}       CONST TD_FORMAT       = (CMD_NONSTD+2)  /* format disk */
NATIVE {TD_REMOVE}       CONST TD_REMOVE       = (CMD_NONSTD+3)  /* notify when disk changes */
NATIVE {TD_CHANGENUM}    CONST TD_CHANGENUM    = (CMD_NONSTD+4)  /* number of disk changes */
NATIVE {TD_CHANGESTATE}  CONST TD_CHANGESTATE  = (CMD_NONSTD+5)  /* is there a disk in the drive? */
NATIVE {TD_PROTSTATUS}   CONST TD_PROTSTATUS   = (CMD_NONSTD+6)  /* is the disk write protected? */
NATIVE {TD_RAWREAD}      CONST TD_RAWREAD      = (CMD_NONSTD+7)  /* read raw bits from the disk */
NATIVE {TD_RAWWRITE}     CONST TD_RAWWRITE     = (CMD_NONSTD+8)  /* write raw bits to the disk */
NATIVE {TD_GETDRIVETYPE} CONST TD_GETDRIVETYPE = (CMD_NONSTD+9)  /* get the type of the disk drive */
NATIVE {TD_GETNUMTRACKS} CONST TD_GETNUMTRACKS = (CMD_NONSTD+10) /* # of tracks for this type drive */
NATIVE {TD_ADDCHANGEINT} CONST TD_ADDCHANGEINT = (CMD_NONSTD+11) /* TD_REMOVE done right */
NATIVE {TD_REMCHANGEINT} CONST TD_REMCHANGEINT = (CMD_NONSTD+12) /* remove softint set by ADDCHANGEINT */
NATIVE {TD_GETGEOMETRY}  CONST TD_GETGEOMETRY  = (CMD_NONSTD+13) /* gets the disk geometry table */
NATIVE {TD_EJECT}        CONST TD_EJECT        = (CMD_NONSTD+14) /* for those drives that support it */
NATIVE {TD_LASTCOMM}     CONST TD_LASTCOMM     = (CMD_NONSTD+15)

/*
 *
 * The disk driver has an "extended command" facility.    These commands
 * take a superset of the normal IO Request block.
 *
 */

NATIVE {ETD_WRITE}    CONST ETD_WRITE    = (CMD_WRITE OR TDF_EXTCOM)
NATIVE {ETD_READ}     CONST ETD_READ     = (CMD_READ OR TDF_EXTCOM)
NATIVE {ETD_MOTOR}    CONST ETD_MOTOR    = (TD_MOTOR OR TDF_EXTCOM)
NATIVE {ETD_SEEK}     CONST ETD_SEEK     = (TD_SEEK OR TDF_EXTCOM)
NATIVE {ETD_FORMAT}   CONST ETD_FORMAT   = (TD_FORMAT OR TDF_EXTCOM)
NATIVE {ETD_UPDATE}   CONST ETD_UPDATE   = (CMD_UPDATE OR TDF_EXTCOM)
NATIVE {ETD_CLEAR}    CONST ETD_CLEAR    = (CMD_CLEAR OR TDF_EXTCOM)
NATIVE {ETD_RAWREAD}  CONST ETD_RAWREAD  = (TD_RAWREAD OR TDF_EXTCOM)
NATIVE {ETD_RAWWRITE} CONST ETD_RAWWRITE = (TD_RAWWRITE OR TDF_EXTCOM)

/*
 *
 * extended IO has a larger than normal io request block.
 *
 */

NATIVE {IOExtTD} OBJECT ioexttd
    {iotd_Req}	iostd	:iostd
    {iotd_Count}	count	:ULONG
    {iotd_SecLabel}	seclabel	:ULONG
ENDOBJECT

/*
 *  This is the structure returned by TD_DRIVEGEOMETRY
 *  Note that the layout can be defined three ways:
 *
 *  1. TotalSectors
 *  2. Cylinders and CylSectors
 *  3. Cylinders, Heads, and TrackSectors.
 *
 *  #1 is most accurate, #2 is less so, and #3 is least accurate.  All
 *  are usable, though #2 and #3 may waste some portion of the available
 *  space on some drives.
 */
NATIVE {DriveGeometry} OBJECT drivegeometry
    {dg_SectorSize}	sectorsize	:ULONG   /* in bytes */
    {dg_TotalSectors}	totalsectors	:ULONG /* total # of sectors on drive */
    {dg_Cylinders}	cylinders	:ULONG    /* number of cylinders */
    {dg_CylSectors}	cylsectors	:ULONG   /* number of sectors/cylinder */
    {dg_Heads}	heads	:ULONG        /* number of surfaces */
    {dg_TrackSectors}	tracksectors	:ULONG /* number of sectors/track */
    {dg_BufMemType}	bufmemtype	:ULONG   /* preferred buffer memory type */
                           /* (usually MEMF_PUBLIC) */
    {dg_DeviceType}	devicetype	:UBYTE   /* codes as defined in the SCSI-2 spec*/
    {dg_Flags}	flags	:UBYTE        /* flags, including removable */
    {dg_Reserved}	reserved	:UINT
ENDOBJECT

/* device types */
NATIVE {DG_DIRECT_ACCESS}      CONST DG_DIRECT_ACCESS      = 0
NATIVE {DG_SEQUENTIAL_ACCESS}  CONST DG_SEQUENTIAL_ACCESS  = 1
NATIVE {DG_PRINTER}            CONST DG_PRINTER            = 2
NATIVE {DG_PROCESSOR}          CONST DG_PROCESSOR          = 3
NATIVE {DG_WORM}               CONST DG_WORM               = 4
NATIVE {DG_CDROM}              CONST DG_CDROM              = 5
NATIVE {DG_SCANNER}            CONST DG_SCANNER            = 6
NATIVE {DG_OPTICAL_DISK}       CONST DG_OPTICAL_DISK       = 7
NATIVE {DG_MEDIUM_CHANGER}     CONST DG_MEDIUM_CHANGER     = 8
NATIVE {DG_COMMUNICATION}      CONST DG_COMMUNICATION      = 9
NATIVE {DG_UNKNOWN}           CONST DG_UNKNOWN           = 31

/* flags */
NATIVE {DGB_REMOVABLE} CONST DGB_REMOVABLE = 0
NATIVE {DGF_REMOVABLE} CONST DGF_REMOVABLE = 1

/*
** raw read and write can be synced with the index pulse.  This flag
** in io request's IO_FLAGS field tells the driver that you want this.
*/
NATIVE {IOTDB_INDEXSYNC} CONST IOTDB_INDEXSYNC = 4
NATIVE {IOTDF_INDEXSYNC} CONST IOTDF_INDEXSYNC = $10

/*
** raw read and write can be synced with a $4489 sync pattern.    This flag
** in io request's IO_FLAGS field tells the driver that you want this.
*/
NATIVE {IOTDB_WORDSYNC}  CONST IOTDB_WORDSYNC  = 5
NATIVE {IOTDF_WORDSYNC}  CONST IOTDF_WORDSYNC  = $20

/* labels are TD_LABELSIZE bytes per sector */
NATIVE {TD_LABELSIZE} CONST TD_LABELSIZE = 16

/*
** This is a bit in the FLAGS field of OpenDevice.  If it is set, then
** the driver will allow you to open all the disks that the trackdisk
** driver understands.    Otherwise only 3.5" disks will succeed.
*/
NATIVE {TDB_ALLOW_NON_3_5} CONST TDB_ALLOW_NON_3_5 = 0
NATIVE {TDF_ALLOW_NON_3_5} CONST TDF_ALLOW_NON_3_5 = $1

/*
**  If you set the TDB_ALLOW_NON_3_5 bit in OpenDevice, then you don't
**  know what type of disk you really got.  These defines are for the
**  TD_GETDRIVETYPE command.  In addition, you can find out how many
**  tracks are supported via the TD_GETNUMTRACKS command.
*/
NATIVE {DRIVE3_5}        CONST DRIVE3_5        = 1
NATIVE {DRIVE5_25}       CONST DRIVE5_25       = 2
NATIVE {DRIVE3_5_150RPM} CONST DRIVE3_5_150RPM = 3

/*
 *--------------------------------------------------------------------
 *
 * Driver error defines
 *
 *--------------------------------------------------------------------
 */

NATIVE {TDERR_NotSpecified}   CONST TDERR_NOTSPECIFIED   = 20 /* general catchall */
NATIVE {TDERR_NoSecHdr}       CONST TDERR_NOSECHDR       = 21 /* couldn't even find a sector */
NATIVE {TDERR_BadSecPreamble} CONST TDERR_BADSECPREAMBLE = 22 /* sector looked wrong */
NATIVE {TDERR_BadSecID}       CONST TDERR_BADSECID       = 23 /* ditto */
NATIVE {TDERR_BadHdrSum}      CONST TDERR_BADHDRSUM      = 24 /* header had incorrect checksum */
NATIVE {TDERR_BadSecSum}      CONST TDERR_BADSECSUM      = 25 /* data had incorrect checksum */
NATIVE {TDERR_TooFewSecs}     CONST TDERR_TOOFEWSECS     = 26 /* couldn't find enough sectors */
NATIVE {TDERR_BadSecHdr}      CONST TDERR_BADSECHDR      = 27 /* another "sector looked wrong" */
NATIVE {TDERR_WriteProt}      CONST TDERR_WRITEPROT      = 28 /* can't write to a protected disk */
NATIVE {TDERR_DiskChanged}    CONST TDERR_DISKCHANGED    = 29 /* no disk in the drive */
NATIVE {TDERR_SeekError}      CONST TDERR_SEEKERROR      = 30 /* couldn't find track 0 */
NATIVE {TDERR_NoMem}          CONST TDERR_NOMEM          = 31 /* ran out of memory */
NATIVE {TDERR_BadUnitNum}     CONST TDERR_BADUNITNUM     = 32 /* asked for a unit > NUMUNITS */
NATIVE {TDERR_BadDriveType}   CONST TDERR_BADDRIVETYPE   = 33 /* not a drive that trackdisk groks */
NATIVE {TDERR_DriveInUse}     CONST TDERR_DRIVEINUSE     = 34 /* someone else allocated the drive */
NATIVE {TDERR_PostReset}      CONST TDERR_POSTRESET      = 35 /* user hit reset; awaiting doom */

/*
 *--------------------------------------------------------------------
 *
 * public portion of the unit structure
 *
 *--------------------------------------------------------------------
 */

NATIVE {TDU_PublicUnit} OBJECT publicunit
    {tdu_Unit}	unit	:unit           /* base message port */
    {tdu_Comp01Track}	comp01track	:UINT    /* track for first precomp */
    {tdu_Comp10Track}	comp10track	:UINT    /* track for second precomp */
    {tdu_Comp11Track}	comp11track	:UINT    /* track for third precomp */
    {tdu_StepDelay}	stepdelay	:ULONG      /* time to wait after stepping */
    {tdu_SettleDelay}	settledelay	:ULONG    /* time to wait after seeking */
    {tdu_RetryCnt}	retrycnt	:UBYTE       /* # of times to retry */
    {tdu_PubFlags}	pubflags	:UBYTE       /* public flags, see below */
    {tdu_CurrTrk}	currtrk	:UINT        /* track the heads are over... */
                                    /* ONLY ACCESS WHILE UNIT IS STOPPED! */
    {tdu_CalibrateDelay}	calibratedelay	:ULONG /* time to wait after stepping */
                                    /* during a recalibrate */
    {tdu_Counter}	counter	:ULONG        /* counter for disk changes... */
                                    /* ONLY ACCESS WHILE UNIT IS STOPPED! */
ENDOBJECT

/* flags for tdu_PubFlags */
NATIVE {TDPB_NOCLICK} CONST TDPB_NOCLICK = 0
NATIVE {TDPF_NOCLICK} CONST TDPF_NOCLICK = $1
