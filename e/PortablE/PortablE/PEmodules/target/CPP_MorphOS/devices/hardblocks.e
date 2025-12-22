/* $VER: hardblocks.h 44.2 (20.10.1999) */
OPT NATIVE
MODULE 'target/exec/types'
{#include <devices/hardblocks.h>}
NATIVE {DEVICES_HARDBLOCKS_H} CONST

/*--------------------------------------------------------------------
 *
 *	This file describes blocks of data that exist on a hard disk
 *	to describe that disk.	They are not generically accessable to
 *	the user as they do not appear on any DOS drive.  The blocks
 *	are tagged with a unique identifier, checksummed, and linked
 *	together.  The root of these blocks is the RigidDiskBlock.
 *
 *	The RigidDiskBlock must exist on the disk within the first
 *	RDB_LOCATION_LIMIT blocks.  This inhibits the use of the zero
 *	cylinder in an AmigaDOS partition: although it is strictly
 *	possible to store the RigidDiskBlock data in the reserved
 *	area of a partition, this practice is discouraged since the
 *	reserved blocks of a partition are overwritten by "Format",
 *	"Install", "DiskCopy", etc.  The recommended disk layout,
 *	then, is to use the first cylinder(s) to store all the drive
 *	data specified by these blocks: i.e. partition descriptions,
 *	file system load images, drive bad block maps, spare blocks,
 *	etc.
 *
 *	Though all descriptions in this file contemplate 512 blocks
 *	per track this desecription works functionally with any block
 *	size. The LSEG blocks should make most efficient use of the
 *	disk block size possible, for example. While this specification
 *	can support 256 byte sectors that is deprecated at this time.
 *
 *	This version adds some modest storage spaces for inserting
 *	the actual source filename for files installed on the RDBs
 *	as either DriveInit code or Filesystem code. This makes
 *	creating a mountfile suitable for use with the "C:Mount"
 *	command that can be used for manually mounting the disk if
 *	ever required.
 *
 *------------------------------------------------------------------*/

/*
 *  NOTE
 *	optional block addresses below contain $ffffffff to indicate
 *	a NULL address, as zero is a valid address
 */
NATIVE {RigidDiskBlock} OBJECT rigiddiskblock
    {rdb_ID}	id	:ULONG		/* 4 character identifier */
    {rdb_SummedLongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {rdb_ChkSum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {rdb_HostID}	hostid	:ULONG		/* SCSI Target ID of host */
    {rdb_BlockBytes}	blockbytes	:ULONG	/* size of disk blocks */
    {rdb_Flags}	flags	:ULONG		/* see below for defines */
    /* block list heads */
    {rdb_BadBlockList}	badblocklist	:ULONG	/* optional bad block list */
    {rdb_PartitionList}	partitionlist	:ULONG	/* optional first partition block */
    {rdb_FileSysHeaderList}	filesysheaderlist	:ULONG /* optional file system header block */
    {rdb_DriveInit}	driveinit	:ULONG	/* optional drive-specific init code */
				/* DriveInit(lun,rdb,ior): "C" stk & d0/a0/a1 */
    {rdb_Reserved1}	reserved1[6]	:ARRAY OF ULONG	/* set to $ffffffff */
    /* physical drive characteristics */
    {rdb_Cylinders}	cylinders	:ULONG	/* number of drive cylinders */
    {rdb_Sectors}	sectors	:ULONG	/* sectors per track */
    {rdb_Heads}	heads	:ULONG		/* number of drive heads */
    {rdb_Interleave}	interleave	:ULONG	/* interleave */
    {rdb_Park}	park	:ULONG		/* landing zone cylinder */
    {rdb_Reserved2}	reserved2[3]	:ARRAY OF ULONG
    {rdb_WritePreComp}	writeprecomp	:ULONG	/* starting cylinder: write precompensation */
    {rdb_ReducedWrite}	reducedwrite	:ULONG	/* starting cylinder: reduced write current */
    {rdb_StepRate}	steprate	:ULONG	/* drive step rate */
    {rdb_Reserved3}	reserved3[5]	:ARRAY OF ULONG
    /* logical drive characteristics */
    {rdb_RDBBlocksLo}	rdbblockslo	:ULONG	/* low block of range reserved for hardblocks */
    {rdb_RDBBlocksHi}	rdbblockshi	:ULONG	/* high block of range for these hardblocks */
    {rdb_LoCylinder}	locylinder	:ULONG	/* low cylinder of partitionable disk area */
    {rdb_HiCylinder}	hicylinder	:ULONG	/* high cylinder of partitionable data area */
    {rdb_CylBlocks}	cylblocks	:ULONG	/* number of blocks available per cylinder */
    {rdb_AutoParkSeconds}	autoparkseconds	:ULONG /* zero for no auto park */
    {rdb_HighRDSKBlock}	highrdskblock	:ULONG	/* highest block used by RDSK */
				/* (not including replacement bad blocks) */
    {rdb_Reserved4}	reserved4	:ULONG
    /* drive identification */
    {rdb_DiskVendor}	diskvendor[8]	:ARRAY OF CHAR
    {rdb_DiskProduct}	diskproduct[16]	:ARRAY OF CHAR
    {rdb_DiskRevision}	diskrevision[4]	:ARRAY OF CHAR
    {rdb_ControllerVendor}	controllervendor[8]	:ARRAY OF CHAR
    {rdb_ControllerProduct}	controllerproduct[16]	:ARRAY OF CHAR
    {rdb_ControllerRevision}	controllerrevision[4]	:ARRAY OF CHAR
    {rdb_DriveInitName}	driveinitname[40]	:ARRAY OF CHAR -> jdow: Filename for driveinit source
				   -> jdow: as a terminated string.
ENDOBJECT

NATIVE {IDNAME_RIGIDDISK}	CONST IDNAME_RIGIDDISK	= $5244534B	/* 'RDSK' */

NATIVE {RDB_LOCATION_LIMIT}	CONST RDB_LOCATION_LIMIT	= 16

NATIVE {RDBFB_LAST}	CONST RDBFB_LAST	= 0	/* no disks exist to be configured after */
NATIVE {RDBFF_LAST}	CONST RDBFF_LAST	= $01	/*   this one on this controller */
NATIVE {RDBFB_LASTLUN}	CONST RDBFB_LASTLUN	= 1	/* no LUNs exist to be configured greater */
NATIVE {RDBFF_LASTLUN}	CONST RDBFF_LASTLUN	= $02	/*   than this one at this SCSI Target ID */
NATIVE {RDBFB_LASTTID}	CONST RDBFB_LASTTID	= 2	/* no Target IDs exist to be configured */
NATIVE {RDBFF_LASTTID}	CONST RDBFF_LASTTID	= $04	/*   greater than this one on this SCSI bus */
NATIVE {RDBFB_NORESELECT} CONST RDBFB_NORESELECT = 3	/* don't bother trying to perform reselection */
NATIVE {RDBFF_NORESELECT} CONST RDBFF_NORESELECT = $08	/*   when talking to this drive */
NATIVE {RDBFB_DISKID}	CONST RDBFB_DISKID	= 4	/* rdb_Disk... identification valid */
NATIVE {RDBFF_DISKID}	CONST RDBFF_DISKID	= $10
NATIVE {RDBFB_CTRLRID}	CONST RDBFB_CTRLRID	= 5	/* rdb_Controller... identification valid */
NATIVE {RDBFF_CTRLRID}	CONST RDBFF_CTRLRID	= $20
				/* added 7/20/89 by commodore: */
NATIVE {RDBFB_SYNCH}	CONST RDBFB_SYNCH	= 6	/* drive supports scsi synchronous mode */
NATIVE {RDBFF_SYNCH}	CONST RDBFF_SYNCH	= $40	/* CAN BE DANGEROUS TO USE IF IT DOESN'T! */

/*------------------------------------------------------------------*/
NATIVE {BadBlockEntry} OBJECT badblockentry
    {bbe_BadBlock}	badblock	:ULONG	/* block number of bad block */
    {bbe_GoodBlock}	goodblock	:ULONG	/* block number of replacement block */
ENDOBJECT

NATIVE {BadBlockBlock} OBJECT badblockblock
    {bbb_ID}	id	:ULONG		/* 4 character identifier */
    {bbb_SummedLongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {bbb_ChkSum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {bbb_HostID}	hostid	:ULONG		/* SCSI Target ID of host */
    {bbb_Next}	next	:ULONG		/* block number of the next BadBlockBlock */
    {bbb_Reserved}	reserved	:ULONG
    {bbb_BlockPairs}	blockpairs[61]	:ARRAY OF badblockentry /* bad block entry pairs */
    /* note [61] assumes 512 byte blocks */
ENDOBJECT

NATIVE {IDNAME_BADBLOCK}		CONST IDNAME_BADBLOCK		= $42414442	/* 'BADB' */

/*------------------------------------------------------------------*/
NATIVE {PartitionBlock} OBJECT partitionblock
    {pb_ID}	id	:ULONG		/* 4 character identifier */
    {pb_SummedLongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {pb_ChkSum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {pb_HostID}	hostid	:ULONG		/* SCSI Target ID of host */
    {pb_Next}	next	:ULONG		/* block number of the next PartitionBlock */
    {pb_Flags}	flags	:ULONG		/* see below for defines */
    {pb_Reserved1}	reserved1[2]	:ARRAY OF ULONG
    {pb_DevFlags}	devflags	:ULONG	/* preferred flags for OpenDevice */
    {pb_DriveName}	drivename[32]	:ARRAY OF UBYTE	/* preferred DOS device name: BSTR form */
				/* (not used if this name is in use) */
    {pb_Reserved2}	reserved2[15]	:ARRAY OF ULONG	/* filler to 32 longwords */
    {pb_Environment}	environment[20]	:ARRAY OF ULONG	/* environment vector for this partition */
    {pb_EReserved}	ereserved[12]	:ARRAY OF ULONG	/* reserved for future environment vector */
ENDOBJECT

NATIVE {IDNAME_PARTITION}	CONST IDNAME_PARTITION	= $50415254	/* 'PART' */

NATIVE {PBFB_BOOTABLE}	CONST PBFB_BOOTABLE	= 0	/* this partition is intended to be bootable */
NATIVE {PBFF_BOOTABLE}	CONST PBFF_BOOTABLE	= $1	/*   (expected directories and files exist) */
NATIVE {PBFB_NOMOUNT}	CONST PBFB_NOMOUNT	= 1	/* do not mount this partition (e.g. manually */
NATIVE {PBFF_NOMOUNT}	CONST PBFF_NOMOUNT	= $2	/*   mounted, but space reserved here) */

/*------------------------------------------------------------------*/
NATIVE {FileSysHeaderBlock} OBJECT filesysheaderblock
    {fhb_ID}	id	:ULONG		/* 4 character identifier */
    {fhb_SummedLongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {fhb_ChkSum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {fhb_HostID}	hostid	:ULONG		/* SCSI Target ID of host */
    {fhb_Next}	next	:ULONG		/* block number of next FileSysHeaderBlock */
    {fhb_Flags}	flags	:ULONG		/* see below for defines */
    {fhb_Reserved1}	reserved1[2]	:ARRAY OF ULONG
    {fhb_DosType}	dostype	:ULONG	/* file system description: match this with */
				/* partition environment's DE_DOSTYPE entry */
    {fhb_Version}	version	:ULONG	/* release version of this code */
    {fhb_PatchFlags}	patchflags	:ULONG	/* bits set for those of the following that */
				/*   need to be substituted into a standard */
				/*   device node for this file system: e.g. */
				/*   $180 to substitute SegList & GlobalVec */
    {fhb_Type}	type	:ULONG		/* device node type: zero */
    {fhb_Task}	task	:ULONG		/* standard dos "task" field: zero */
    {fhb_Lock}	lock	:ULONG		/* not used for devices: zero */
    {fhb_Handler}	handler	:ULONG	/* filename to loadseg: zero placeholder */
    {fhb_StackSize}	stacksize	:ULONG	/* stacksize to use when starting task */
    {fhb_Priority}	priority	:VALUE	/* task priority when starting task */
    {fhb_Startup}	startup	:VALUE	/* startup msg: zero placeholder */
    {fhb_SegListBlocks}	seglistblocks	:VALUE	/* first of linked list of LoadSegBlocks: */
				/*   note that this entry requires some */
				/*   processing before substitution */
    {fhb_GlobalVec}	globalvec	:VALUE	/* BCPL global vector when starting task */
    {fhb_Reserved2}	reserved2[23]	:ARRAY OF ULONG	/* (those reserved by PatchFlags) */
    {fhb_FileSysName}	filesysname[84]	:ARRAY OF CHAR /* File system file name as loaded. */
ENDOBJECT

NATIVE {IDNAME_FILESYSHEADER}	CONST IDNAME_FILESYSHEADER	= $46534844	/* 'FSHD' */

/*------------------------------------------------------------------*/
NATIVE {LoadSegBlock} OBJECT loadsegblock
    {lsb_ID}	id	:ULONG		/* 4 character identifier */
    {lsb_SummedLongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {lsb_ChkSum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {lsb_HostID}	hostid	:ULONG		/* SCSI Target ID of host */
    {lsb_Next}	next	:ULONG		/* block number of the next LoadSegBlock */
    {lsb_LoadData}	loaddata[123]	:ARRAY OF ULONG	/* data for "loadseg" */
    /* note [123] assumes 512 byte blocks */
ENDOBJECT

NATIVE {IDNAME_LOADSEG}		CONST IDNAME_LOADSEG		= $4C534547	/* 'LSEG' */
