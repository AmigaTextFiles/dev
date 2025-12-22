@DATABASE "gg:doc/NDK/Guide/Include/devices/trackdisk.h"
@MASTER   "gg:os-include/devices/trackdisk.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:45
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/trackdisk.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/trackdisk.h" LINK File}


@{b}Structures@{ub}

@{"DriveGeometry" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 135}  @{"IOExtTD" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 117}  @{"TDU_PublicUnit" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 238}


@{b}#defines@{ub}

@{"DG_CDROM" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 155}            @{"DG_COMMUNICATION" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 159}    @{"DG_DIRECT_ACCESS" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 150}
@{"DG_MEDIUM_CHANGER" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 158}   @{"DG_OPTICAL_DISK" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 157}     @{"DG_PRINTER" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 152}
@{"DG_PROCESSOR" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 153}        @{"DG_SCANNER" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 156}          @{"DG_SEQUENTIAL_ACCESS" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 151}
@{"DG_UNKNOWN" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 160}          @{"DG_WORM" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 154}             @{"DGB_REMOVABLE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 163}
@{"DGF_REMOVABLE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 164}       @{"DRIVE3_5" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 201}            @{"DRIVE3_5_150RPM" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 203}
@{"DRIVE5_25" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 202}           @{"ETD_CLEAR" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 107}           @{"ETD_FORMAT" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 105}
@{"ETD_MOTOR" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 103}           @{"ETD_RAWREAD" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 108}         @{"ETD_RAWWRITE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 109}
@{"ETD_READ" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 102}            @{"ETD_SEEK" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 104}            @{"ETD_UPDATE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 106}
@{"ETD_WRITE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 101}           @{"IOTDB_INDEXSYNC" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 171}     @{"IOTDB_WORDSYNC" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 177}
@{"IOTDF_INDEXSYNC" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 172}     @{"IOTDF_WORDSYNC" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 178}      @{"NUMSECS" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 38}
@{"NUMUNITS" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 39}            @{"TD_ADDCHANGEINT" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 88}     @{"TD_CHANGENUM" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 81}
@{"TD_CHANGESTATE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 82}      @{"TD_EJECT" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 91}            @{"TD_FORMAT" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 79}
@{"TD_GETDRIVETYPE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 86}     @{"TD_GETGEOMETRY" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 90}      @{"TD_GETNUMTRACKS" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 87}
@{"TD_LABELSIZE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 183}        @{"TD_LASTCOMM" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 92}         @{"TD_MOTOR" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 77}
@{"TD_NAME" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 72}             @{"TD_PROTSTATUS" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 83}       @{"TD_RAWREAD" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 84}
@{"TD_RAWWRITE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 85}         @{"TD_REMCHANGEINT" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 89}     @{"TD_REMOVE" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 80}
@{"TD_SECSHIFT" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 51}         @{"TD_SECTOR" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 50}           @{"TD_SEEK" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 78}
@{"TDB_ALLOW_NON_3_5" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 191}   @{"TDERR_BadDriveType" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 226}  @{"TDERR_BadHdrSum" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 217}
@{"TDERR_BadSecHdr" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 220}     @{"TDERR_BadSecID" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 216}      @{"TDERR_BadSecPreamble" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 215}
@{"TDERR_BadSecSum" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 218}     @{"TDERR_BadUnitNum" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 225}    @{"TDERR_DiskChanged" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 222}
@{"TDERR_DriveInUse" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 227}    @{"TDERR_NoMem" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 224}         @{"TDERR_NoSecHdr" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 214}
@{"TDERR_NotSpecified" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 213}  @{"TDERR_PostReset" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 228}     @{"TDERR_SeekError" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 223}
@{"TDERR_TooFewSecs" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 219}    @{"TDERR_WriteProt" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 221}     @{"TDF_ALLOW_NON_3_5" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 192}
@{"TDF_EXTCOM" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 74}          @{"TDPB_NOCLICK" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 256}        @{"TDPF_NOCLICK" LINK "gg:doc/NDK/Guide/Include/devices/trackdisk.h/File" 257}

@ENDNODE
@NODE File "devices/trackdisk.h"
#ifndef DEVICES_TRACKDISK_H
#define DEVICES_TRACKDISK_H

/*
**
**      $VER: trackdisk.h 33.13 (28.11.1990)
**      Includes Release 45.1
**
**      trackdisk device structure and value definitions
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#ifndef EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif

#ifndef EXEC_DEVICES_H
#include <@{"exec/devices.h" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File"}>
#endif

/*
 *--------------------------------------------------------------------
 *
 * Physical drive constants
 *
 *--------------------------------------------------------------------
 */

/* OBSOLETE -- use the @{"TD_GETNUMTRACKS" LINK "gg:doc/NDK/Guide/trackdisk/TD_GETNUMTRACKS"} command! */
/*#define       NUMCYLS 80*/            /*  normal # of cylinders */
/*#define       MAXCYLS (NUMCYLS+20)*/  /* max # cyls to look for during cal */
/*#define       NUMHEADS 2*/
/*#define       NUMTRACKS (NUMCYLS*NUMHEADS)*/

#define NUMSECS 11
#define NUMUNITS 4

/*
 *--------------------------------------------------------------------
 *
 * Useful constants
 *
 *--------------------------------------------------------------------
 */

/*-- sizes before mfm encoding */
#define TD_SECTOR 512
#define TD_SECSHIFT 9           /* log @{"TD_SECTOR" LINK File 50} */

/*
 *--------------------------------------------------------------------
 *
 * Driver Specific Commands
 *
 *--------------------------------------------------------------------
 */

/*
 *-- @{"TD_NAME" LINK File 72} is a generic macro to get the name of the driver.  This
 *-- way if the name is ever changed you will pick up the change
 *-- automatically.
 *--
 *-- Normal usage would be:
 *--
 *-- char internalName[] = @{"TD_NAME" LINK File 72};
 *--
 */

#define TD_NAME "trackdisk.device"

#define TDF_EXTCOM (1<<15)              /* for internal use only! */


#define @{"TD_MOTOR" LINK "gg:doc/NDK/Guide/trackdisk/TD_MOTOR"}        (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)  /* control the disk's motor */
#define @{"TD_SEEK" LINK "gg:doc/NDK/Guide/trackdisk/TD_SEEK"}         (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)  /* explicit seek (for testing) */
#define @{"TD_FORMAT" LINK "gg:doc/NDK/Guide/trackdisk/TD_FORMAT"}       (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)  /* format disk */
#define TD_REMOVE       (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)  /* notify when disk changes */
#define @{"TD_CHANGENUM" LINK "gg:doc/NDK/Guide/trackdisk/TD_CHANGENUM"}    (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+4)  /* number of disk changes */
#define @{"TD_CHANGESTATE" LINK "gg:doc/NDK/Guide/trackdisk/TD_CHANGESTATE"}  (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+5)  /* is there a disk in the drive? */
#define @{"TD_PROTSTATUS" LINK "gg:doc/NDK/Guide/trackdisk/TD_PROTSTATUS"}   (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+6)  /* is the disk write protected? */
#define @{"TD_RAWREAD" LINK "gg:doc/NDK/Guide/trackdisk/TD_RAWREAD"}      (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+7)  /* read raw bits from the disk */
#define @{"TD_RAWWRITE" LINK "gg:doc/NDK/Guide/trackdisk/TD_RAWWRITE"}     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+8)  /* write raw bits to the disk */
#define @{"TD_GETDRIVETYPE" LINK "gg:doc/NDK/Guide/trackdisk/TD_GETDRIVETYPE"} (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+9)  /* get the type of the disk drive */
#define @{"TD_GETNUMTRACKS" LINK "gg:doc/NDK/Guide/trackdisk/TD_GETNUMTRACKS"} (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+10) /* # of tracks for this type drive */
#define @{"TD_ADDCHANGEINT" LINK "gg:doc/NDK/Guide/trackdisk/TD_ADDCHANGEINT"} (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+11) /* @{"TD_REMOVE" LINK File 80} done right */
#define @{"TD_REMCHANGEINT" LINK "gg:doc/NDK/Guide/trackdisk/TD_REMCHANGEINT"} (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+12) /* remove softint set by ADDCHANGEINT */
#define @{"TD_GETGEOMETRY" LINK "gg:doc/NDK/Guide/trackdisk/TD_GETGEOMETRY"}  (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+13) /* gets the disk geometry table */
#define @{"TD_EJECT" LINK "gg:doc/NDK/Guide/trackdisk/TD_EJECT"}        (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+14) /* for those drives that support it */
#define TD_LASTCOMM     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+15)

/*
 *
 * The disk driver has an "extended command" facility.  These commands
 * take a superset of the normal IO Request block.
 *
 */

#define ETD_WRITE       (@{"CMD_WRITE" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 52}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_READ        (@{"CMD_READ" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 51}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_MOTOR       (@{"TD_MOTOR" LINK File 77}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_SEEK        (@{"TD_SEEK" LINK File 78}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_FORMAT      (@{"TD_FORMAT" LINK File 79}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_UPDATE      (@{"CMD_UPDATE" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 53}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_CLEAR       (@{"CMD_CLEAR" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 54}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_RAWREAD     (@{"TD_RAWREAD" LINK File 84}|@{"TDF_EXTCOM" LINK File 74})
#define ETD_RAWWRITE    (@{"TD_RAWWRITE" LINK File 85}|@{"TDF_EXTCOM" LINK File 74})

/*
 *
 * extended IO has a larger than normal io request block.
 *
 */

struct IOExtTD {
        @{"struct  IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27} iotd_Req;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   iotd_Count;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   iotd_SecLabel;
};

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
struct DriveGeometry {
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_SectorSize;          /* in bytes */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_TotalSectors;        /* total # of sectors on drive */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_Cylinders;           /* number of cylinders */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_CylSectors;          /* number of sectors/cylinder */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_Heads;               /* number of surfaces */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_TrackSectors;        /* number of sectors/track */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dg_BufMemType;          /* preferred buffer memory type */
                                        /* (usually @{"MEMF_PUBLIC" LINK "gg:doc/NDK/Guide/Include/exec/memory.h/File" 69}) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   dg_DeviceType;          /* codes as defined in the SCSI-2 spec*/
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   dg_Flags;               /* flags, including removable */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dg_Reserved;
};

/* device types */
#define DG_DIRECT_ACCESS        0
#define DG_SEQUENTIAL_ACCESS    1
#define DG_PRINTER              2
#define DG_PROCESSOR            3
#define DG_WORM                 4
#define DG_CDROM                5
#define DG_SCANNER              6
#define DG_OPTICAL_DISK         7
#define DG_MEDIUM_CHANGER       8
#define DG_COMMUNICATION        9
#define DG_UNKNOWN              31

/* flags */
#define DGB_REMOVABLE           0
#define DGF_REMOVABLE           1

/*
** raw read and write can be synced with the index pulse.  This flag
** in io request's IO_FLAGS field tells the driver that you want this.
*/

#define IOTDB_INDEXSYNC 4
#define IOTDF_INDEXSYNC (1<<4)
/*
** raw read and write can be synced with a $4489 sync pattern.  This flag
** in io request's IO_FLAGS field tells the driver that you want this.
*/
#define IOTDB_WORDSYNC  5
#define IOTDF_WORDSYNC (1<<5)


/* labels are @{"TD_LABELSIZE" LINK File 183} bytes per sector */

#define TD_LABELSIZE 16

/*
** This is a bit in the FLAGS field of @{"OpenDevice" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}.  If it is set, then
** the driver will allow you to open all the disks that the trackdisk
** driver understands.  Otherwise only 3.5" disks will succeed.
*/

#define TDB_ALLOW_NON_3_5       0
#define TDF_ALLOW_NON_3_5       (1<<0)

/*
**  If you set the @{"TDB_ALLOW_NON_3_5" LINK File 191} bit in @{"OpenDevice" LINK "gg:doc/NDK/Guide/exec/OpenDevice"}, then you don't
**  know what type of disk you really got.  These defines are for the
**  @{"TD_GETDRIVETYPE" LINK "gg:doc/NDK/Guide/trackdisk/TD_GETDRIVETYPE"} command.  In addition, you can find out how many
**  tracks are supported via the @{"TD_GETNUMTRACKS" LINK "gg:doc/NDK/Guide/trackdisk/TD_GETNUMTRACKS"} command.
*/

#define DRIVE3_5        1
#define DRIVE5_25       2
#define DRIVE3_5_150RPM 3

/*
 *--------------------------------------------------------------------
 *
 * Driver error defines
 *
 *--------------------------------------------------------------------
 */

#define TDERR_NotSpecified      20      /* general catchall */
#define TDERR_NoSecHdr          21      /* couldn't even find a sector */
#define TDERR_BadSecPreamble    22      /* sector looked wrong */
#define TDERR_BadSecID          23      /* ditto */
#define TDERR_BadHdrSum         24      /* header had incorrect checksum */
#define TDERR_BadSecSum         25      /* data had incorrect checksum */
#define TDERR_TooFewSecs        26      /* couldn't find enough sectors */
#define TDERR_BadSecHdr         27      /* another "sector looked wrong" */
#define TDERR_WriteProt         28      /* can't write to a protected disk */
#define TDERR_DiskChanged       29      /* no disk in the drive */
#define TDERR_SeekError         30      /* couldn't find track 0 */
#define TDERR_NoMem             31      /* ran out of memory */
#define TDERR_BadUnitNum        32      /* asked for a unit > @{"NUMUNITS" LINK File 39} */
#define TDERR_BadDriveType      33      /* not a drive that trackdisk groks */
#define TDERR_DriveInUse        34      /* someone else allocated the drive */
#define TDERR_PostReset         35      /* user hit reset; awaiting doom */

/*
 *--------------------------------------------------------------------
 *
 * public portion of the unit structure
 *
 *--------------------------------------------------------------------
 */

struct TDU_PublicUnit {
        @{"struct  Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} tdu_Unit;          /* base message port */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tdu_Comp01Track;        /* track for first precomp */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tdu_Comp10Track;        /* track for second precomp */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tdu_Comp11Track;        /* track for third precomp */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tdu_StepDelay;          /* time to wait after stepping */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tdu_SettleDelay;        /* time to wait after seeking */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tdu_RetryCnt;           /* # of times to retry */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tdu_PubFlags;           /* public flags, see below */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tdu_CurrTrk;            /* track the heads are over... */
                                        /* ONLY ACCESS WHILE UNIT IS STOPPED! */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tdu_CalibrateDelay;     /* time to wait after stepping */
                                        /* during a recalibrate */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tdu_Counter;            /* counter for disk changes... */
                                        /* ONLY ACCESS WHILE UNIT IS STOPPED! */
};

/* flags for tdu_PubFlags */
#define TDPB_NOCLICK    0
#define TDPF_NOCLICK    (1L << 0)

#endif  /* DEVICES_TRACKDISK_H */
@ENDNODE
