@DATABASE "gg:doc/NDK/Guide/Include/devices/hardblocks.h"
@MASTER   "gg:os-include/devices/hardblocks.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:23
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/hardblocks.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/hardblocks.h" LINK File}


@{b}Structures@{ub}

@{"BadBlockBlock" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 137}   @{"BadBlockEntry" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 132}   @{"FileSysHeaderBlock" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 175}  @{"LoadSegBlock" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 208}
@{"PartitionBlock" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 151}  @{"RigidDiskBlock" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 65}  


@{b}#defines@{ub}

@{"IDNAME_BADBLOCK" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 148}     @{"IDNAME_FILESYSHEADER" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 205}  @{"IDNAME_LOADSEG" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 218}
@{"IDNAME_PARTITION" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 167}    @{"IDNAME_RIGIDDISK" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 111}      @{"PBFB_BOOTABLE" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 169}
@{"PBFB_NOMOUNT" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 171}        @{"PBFF_BOOTABLE" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 170}         @{"PBFF_NOMOUNT" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 172}
@{"RDB_LOCATION_LIMIT" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 113}  @{"RDBFB_CTRLRID" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 125}         @{"RDBFB_DISKID" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 123}
@{"RDBFB_LAST" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 115}          @{"RDBFB_LASTLUN" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 117}         @{"RDBFB_LASTTID" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 119}
@{"RDBFB_NORESELECT" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 121}    @{"RDBFB_SYNCH" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 128}           @{"RDBFF_CTRLRID" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 126}
@{"RDBFF_DISKID" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 124}        @{"RDBFF_LAST" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 116}            @{"RDBFF_LASTLUN" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 118}
@{"RDBFF_LASTTID" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 120}       @{"RDBFF_NORESELECT" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 122}      @{"RDBFF_SYNCH" LINK "gg:doc/NDK/Guide/Include/devices/hardblocks.h/File" 129}

@ENDNODE
@NODE File "devices/hardblocks.h"
#ifndef DEVICES_HARDBLOCKS_H
#define DEVICES_HARDBLOCKS_H
/*
**      $VER: hardblocks.h 44.2 (20.10.1999)
**      Includes Release 45.1
**
**      File System identifier blocks for hard disks
**
**      (C) Copyright 1988-2001 Amiga, Inc.
**      (C) Copyright 1999 Joanne Dow licensed to Amiga, Inc.
**          All Rights Reserved
*/

/*      Changes
**        Expanded envec
**        Added storage for driveinit name up to 31 letters.
**        Added storage for filesysten name up to 83 letters.
**/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif /* EXEC_TYPES_H */


/*--------------------------------------------------------------------
 *
 *      This file describes blocks of data that exist on a hard disk
 *      to describe that disk.  They are not generically accessable to
 *      the user as they do not appear on any DOS drive.  The blocks
 *      are tagged with a unique identifier, checksummed, and linked
 *      together.  The root of these blocks is the RigidDiskBlock.
 *
 *      The RigidDiskBlock must exist on the disk within the first
 *      @{"RDB_LOCATION_LIMIT" LINK File 113} blocks.  This inhibits the use of the zero
 *      cylinder in an AmigaDOS partition: although it is strictly
 *      possible to store the RigidDiskBlock data in the reserved
 *      area of a partition, this practice is discouraged since the
 *      reserved blocks of a partition are overwritten by "Format",
 *      "Install", "DiskCopy", etc.  The recommended disk layout,
 *      then, is to use the first cylinder(s) to store all the drive
 *      data specified by these blocks: i.e. partition descriptions,
 *      file system load images, drive bad block maps, spare blocks,
 *      etc.
 *
 *      Though all descriptions in this file contemplate 512 blocks
 *      per track this desecription works functionally with any block
 *      size. The LSEG blocks should make most efficient use of the
 *      disk block size possible, for example. While this specification
 *      can support 256 byte sectors that is deprecated at this time.
 *
 *      This version adds some modest storage spaces for inserting
 *      the actual source filename for files installed on the RDBs
 *      as either DriveInit code or Filesystem code. This makes
 *      creating a mountfile suitable for use with the "C:Mount"
 *      command that can be used for manually mounting the disk if
 *      ever required.
 *
 *------------------------------------------------------------------*/

/*
 *  NOTE
 *      optional block addresses below contain $ffffffff to indicate
 *      a @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} address, as zero is a valid address
 */
struct RigidDiskBlock {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_ID;             /* 4 character identifier */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_SummedLongs;    /* size of this checksummed structure */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    rdb_ChkSum;         /* block checksum (longword sum to zero) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_HostID;         /* SCSI Target ID of host */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_BlockBytes;     /* size of disk blocks */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Flags;          /* see below for defines */
    /* block list heads */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_BadBlockList;   /* optional bad block list */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_PartitionList;  /* optional first partition block */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_FileSysHeaderList; /* optional file system header block */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_DriveInit;      /* optional drive-specific init code */
                                /* DriveInit(lun,rdb,ior): "C" stk & d0/a0/a1 */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Reserved1[6];   /* set to $ffffffff */
    /* physical drive characteristics */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Cylinders;      /* number of drive cylinders */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Sectors;        /* sectors per track */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Heads;          /* number of drive heads */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Interleave;     /* interleave */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Park;           /* landing zone cylinder */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Reserved2[3];
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_WritePreComp;   /* starting cylinder: write precompensation */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_ReducedWrite;   /* starting cylinder: reduced write current */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_StepRate;       /* drive step rate */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Reserved3[5];
    /* logical drive characteristics */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_RDBBlocksLo;    /* low block of range reserved for hardblocks */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_RDBBlocksHi;    /* high block of range for these hardblocks */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_LoCylinder;     /* low cylinder of partitionable disk area */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_HiCylinder;     /* high cylinder of partitionable data area */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_CylBlocks;      /* number of blocks available per cylinder */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_AutoParkSeconds; /* zero for no auto park */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_HighRDSKBlock;  /* highest block used by RDSK */
                                /* (not including replacement bad blocks) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   rdb_Reserved4;
    /* drive identification */
    char    rdb_DiskVendor[8];
    char    rdb_DiskProduct[16];
    char    rdb_DiskRevision[4];
    char    rdb_ControllerVendor[8];
    char    rdb_ControllerProduct[16];
    char    rdb_ControllerRevision[4];
    char    rdb_DriveInitName[40]; // jdow: Filename for driveinit source
                                   // jdow: as a terminated string.
};

#define IDNAME_RIGIDDISK        0x5244534B      /* 'RDSK' */

#define RDB_LOCATION_LIMIT      16

#define RDBFB_LAST      0       /* no disks exist to be configured after */
#define RDBFF_LAST      0x01L   /*   this one on this controller */
#define RDBFB_LASTLUN   1       /* no LUNs exist to be configured greater */
#define RDBFF_LASTLUN   0x02L   /*   than this one at this SCSI Target ID */
#define RDBFB_LASTTID   2       /* no Target IDs exist to be configured */
#define RDBFF_LASTTID   0x04L   /*   greater than this one on this SCSI bus */
#define RDBFB_NORESELECT 3      /* don't bother trying to perform reselection */
#define RDBFF_NORESELECT 0x08L  /*   when talking to this drive */
#define RDBFB_DISKID    4       /* rdb_Disk... identification valid */
#define RDBFF_DISKID    0x10L
#define RDBFB_CTRLRID   5       /* rdb_Controller... identification valid */
#define RDBFF_CTRLRID   0x20L
                                /* added 7/20/89 by commodore: */
#define RDBFB_SYNCH     6       /* drive supports scsi synchronous mode */
#define RDBFF_SYNCH     0x40L   /* CAN BE DANGEROUS TO USE IF IT DOESN'T! */

/*------------------------------------------------------------------*/
struct BadBlockEntry {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbe_BadBlock;       /* block number of bad block */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbe_GoodBlock;      /* block number of replacement block */
};

struct BadBlockBlock {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbb_ID;             /* 4 character identifier */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbb_SummedLongs;    /* size of this checksummed structure */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    bbb_ChkSum;         /* block checksum (longword sum to zero) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbb_HostID;         /* SCSI Target ID of host */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbb_Next;           /* block number of the next BadBlockBlock */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   bbb_Reserved;
    @{"struct BadBlockEntry" LINK File 132} bbb_BlockPairs[61]; /* bad block entry pairs */
    /* note [61] assumes 512 byte blocks */
};

#define IDNAME_BADBLOCK         0x42414442      /* 'BADB' */

/*------------------------------------------------------------------*/
struct PartitionBlock {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_ID;              /* 4 character identifier */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_SummedLongs;     /* size of this checksummed structure */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    pb_ChkSum;          /* block checksum (longword sum to zero) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_HostID;          /* SCSI Target ID of host */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_Next;            /* block number of the next PartitionBlock */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_Flags;           /* see below for defines */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_Reserved1[2];
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_DevFlags;        /* preferred flags for @{"OpenDevice" LINK "gg:doc/NDK/Guide/exec/OpenDevice"} */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pb_DriveName[32];   /* preferred DOS device name: @{"BSTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 131} form */
                                /* (not used if this name is in use) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_Reserved2[15];   /* filler to 32 longwords */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_Environment[20]; /* environment vector for this partition */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   pb_EReserved[12];   /* reserved for future environment vector */
};

#define IDNAME_PARTITION        0x50415254      /* 'PART' */

#define PBFB_BOOTABLE   0       /* this partition is intended to be bootable */
#define PBFF_BOOTABLE   1L      /*   (expected directories and files exist) */
#define PBFB_NOMOUNT    1       /* do not mount this partition (e.g. manually */
#define PBFF_NOMOUNT    2L      /*   mounted, but space reserved here) */

/*------------------------------------------------------------------*/
struct FileSysHeaderBlock {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_ID;             /* 4 character identifier */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_SummedLongs;    /* size of this checksummed structure */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    fhb_ChkSum;         /* block checksum (longword sum to zero) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_HostID;         /* SCSI Target ID of host */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Next;           /* block number of next FileSysHeaderBlock */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Flags;          /* see below for defines */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Reserved1[2];
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_DosType;        /* file system description: match this with */
                                /* partition environment's @{"DE_DOSTYPE" LINK "gg:doc/NDK/Guide/Include/dos/filehandler.h/File" 74} entry */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Version;        /* release version of this code */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_PatchFlags;     /* bits set for those of the following that */
                                /*   need to be substituted into a standard */
                                /*   device node for this file system: e.g. */
                                /*   0x180 to substitute SegList & GlobalVec */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Type;           /* device node type: zero */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Task;           /* standard dos "task" field: zero */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Lock;           /* not used for devices: zero */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Handler;        /* filename to loadseg: zero placeholder */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_StackSize;      /* stacksize to use when starting task */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    fhb_Priority;       /* task priority when starting task */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    fhb_Startup;        /* startup msg: zero placeholder */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    fhb_SegListBlocks;  /* first of linked list of LoadSegBlocks: */
                                /*   note that this entry requires some */
                                /*   processing before substitution */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    fhb_GlobalVec;      /* BCPL global vector when starting task */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   fhb_Reserved2[23];  /* (those reserved by PatchFlags) */
    char    fhb_FileSysName[84]; /* File system file name as loaded. */
};

#define IDNAME_FILESYSHEADER    0x46534844      /* 'FSHD' */

/*------------------------------------------------------------------*/
struct LoadSegBlock {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lsb_ID;             /* 4 character identifier */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lsb_SummedLongs;    /* size of this checksummed structure */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    lsb_ChkSum;         /* block checksum (longword sum to zero) */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lsb_HostID;         /* SCSI Target ID of host */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lsb_Next;           /* block number of the next LoadSegBlock */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   lsb_LoadData[123];  /* data for "loadseg" */
    /* note [123] assumes 512 byte blocks */
};

#define IDNAME_LOADSEG          0x4C534547      /* 'LSEG' */

#endif  /* DEVICES_HARDBLOCKS_H */
@ENDNODE
