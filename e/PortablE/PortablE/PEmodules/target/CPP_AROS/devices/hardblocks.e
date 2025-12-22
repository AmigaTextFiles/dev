/* $Id: hardblocks.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <devices/hardblocks.h>}
NATIVE {DEVICES_HARDBLOCK_H} CONST

NATIVE {RigidDiskBlock} OBJECT rigiddiskblock
    {rdb_ID}	id	:ULONG
    {rdb_SummedLongs}	summedlongs	:ULONG
    {rdb_ChkSum}	chksum	:VALUE
    {rdb_HostID}	hostid	:ULONG
    {rdb_BlockBytes}	blockbytes	:ULONG
    {rdb_Flags}	flags	:ULONG
    {rdb_BadBlockList}	badblocklist	:ULONG
    {rdb_PartitionList}	partitionlist	:ULONG
    {rdb_FileSysHeaderList}	filesysheaderlist	:ULONG
    {rdb_DriveInit}	driveinit	:ULONG
    {rdb_Reserved1}	reserved1[6]	:ARRAY OF ULONG
    {rdb_Cylinders}	cylinders	:ULONG
    {rdb_Sectors}	sectors	:ULONG
    {rdb_Heads}	heads	:ULONG
    {rdb_Interleave}	interleave	:ULONG
    {rdb_Park}	park	:ULONG
    {rdb_Reserved2}	reserved2[3]	:ARRAY OF ULONG
    {rdb_WritePreComp}	writeprecomp	:ULONG
    {rdb_ReducedWrite}	reducedwrite	:ULONG
    {rdb_StepRate}	steprate	:ULONG
    {rdb_Reserved3}	reserved3[5]	:ARRAY OF ULONG
    {rdb_RDBBlocksLo}	rdbblockslo	:ULONG
    {rdb_RDBBlocksHi}	rdbblockshi	:ULONG
    {rdb_LoCylinder}	locylinder	:ULONG
    {rdb_HiCylinder}	hicylinder	:ULONG
    {rdb_CylBlocks}	cylblocks	:ULONG
    {rdb_AutoParkSeconds}	autoparkseconds	:ULONG
    {rdb_HighRDSKBlock}	highrdskblock	:ULONG
    {rdb_Reserved4}	reserved4	:ULONG
    {rdb_DiskVendor}	diskvendor[8]	:ARRAY OF CHAR
    {rdb_DiskProduct}	diskproduct[16]	:ARRAY OF CHAR
    {rdb_DiskRevision}	diskrevision[4]	:ARRAY OF CHAR
    {rdb_ControllerVendor}	controllervendor[8]	:ARRAY OF CHAR
    {rdb_ControllerProduct}	controllerproduct[16]	:ARRAY OF CHAR
    {rdb_ControllerRevision}	controllerrevision[4]	:ARRAY OF CHAR
    {rdb_DriveInitName}	driveinitname[40]	:ARRAY OF CHAR
ENDOBJECT

NATIVE {IDNAME_RIGIDDISK}	CONST IDNAME_RIGIDDISK	= $5244534B  /* 'RDSK' */

NATIVE {RDB_LOCATION_LIMIT}	CONST RDB_LOCATION_LIMIT	= 16

NATIVE {RDBFB_LAST}	    	CONST RDBFB_LAST	    	= 0
NATIVE {RDBFB_LASTLUN}	    	CONST RDBFB_LASTLUN	    	= 1
NATIVE {RDBFB_LASTTID}	    	CONST RDBFB_LASTTID	    	= 2
NATIVE {RDBFB_NORESELECT}    	CONST RDBFB_NORESELECT    	= 3
NATIVE {RDBFB_DISKID}	    	CONST RDBFB_DISKID	    	= 4
NATIVE {RDBFB_CTRLRID}	    	CONST RDBFB_CTRLRID	    	= 5
NATIVE {RDBFB_SYNCH}	    	CONST RDBFB_SYNCH	    	= 6

NATIVE {RDBFF_LAST}	    	CONST RDBFF_LAST	    	= $1
NATIVE {RDBFF_LASTLUN}	    	CONST RDBFF_LASTLUN	    	= $2
NATIVE {RDBFF_LASTTID}	    	CONST RDBFF_LASTTID	    	= $4
NATIVE {RDBFF_NORESELECT}    	CONST RDBFF_NORESELECT    	= $8
NATIVE {RDBFF_DISKID}	    	CONST RDBFF_DISKID	    	= $10
NATIVE {RDBFF_CTRLRID}	    	CONST RDBFF_CTRLRID	    	= $20
NATIVE {RDBFF_SYNCH}	    	CONST RDBFF_SYNCH	    	= $40

NATIVE {BadBlockEntry} OBJECT badblockentry
    {bbe_BadBlock}	badblock	:ULONG
    {bbe_GoodBlock}	goodblock	:ULONG
ENDOBJECT

NATIVE {BadBlockBlock} OBJECT badblockblock
    {bbb_ID}	id	:ULONG
    {bbb_SummedLongs}	summedlongs	:ULONG
    {bbb_ChkSum}	chksum	:VALUE
    {bbb_HostID}	hostid	:ULONG
    {bbb_Next}	next	:ULONG
    {bbb_Reserved}	reserved	:ULONG
    {bbb_BlockPairs}	blockpairs[61]	:ARRAY OF badblockentry
ENDOBJECT

NATIVE {IDNAME_BADBLOCK}		CONST IDNAME_BADBLOCK		= $42414442  /* "BADB" */

NATIVE {PartitionBlock} OBJECT partitionblock
    {pb_ID}	id	:ULONG
    {pb_SummedLongs}	summedlongs	:ULONG
    {pb_ChkSum}	chksum	:VALUE
    {pb_HostID}	hostid	:ULONG
    {pb_Next}	next	:ULONG
    {pb_Flags}	flags	:ULONG
    {pb_Reserved1}	reserved1[2]	:ARRAY OF ULONG
    {pb_DevFlags}	devflags	:ULONG
    {pb_DriveName}	drivename[32]	:ARRAY OF UBYTE
    {pb_Reserved2}	reserved2[15]	:ARRAY OF ULONG
    {pb_Environment}	environment[20]	:ARRAY OF ULONG
    {pb_EReserved}	ereserved[12]	:ARRAY OF ULONG
ENDOBJECT

NATIVE {IDNAME_PARTITION}	CONST IDNAME_PARTITION	= $50415254  /* "PART" */

NATIVE {PBFB_BOOTABLE}	    	CONST PBFB_BOOTABLE	    	= 0
NATIVE {PBFB_NOMOUNT}	    	CONST PBFB_NOMOUNT	    	= 1

NATIVE {PBFF_BOOTABLE}	    	CONST PBFF_BOOTABLE	    	= 1
NATIVE {PBFF_NOMOUNT}	    	CONST PBFF_NOMOUNT	    	= 2

NATIVE {FileSysHeaderBlock} OBJECT filesysheaderblock
    {fhb_ID}	id	:ULONG
    {fhb_SummedLongs}	summedlongs	:ULONG
    {fhb_ChkSum}	chksum	:VALUE
    {fhb_HostID}	hostid	:ULONG
    {fhb_Next}	next	:ULONG
    {fhb_Flags}	flags	:ULONG
    {fhb_Reserved1}	reserved1[2]	:ARRAY OF ULONG
    {fhb_DosType}	dostype	:ULONG
    {fhb_Version}	version	:ULONG
    {fhb_PatchFlags}	patchflags	:ULONG
    {fhb_Type}	type	:ULONG
    {fhb_Task}	task	:ULONG
    {fhb_Lock}	lock	:ULONG
    {fhb_Handler}	handler	:ULONG
    {fhb_StackSize}	stacksize	:ULONG
    {fhb_Priority}	priority	:VALUE
    {fhb_Startup}	startup	:VALUE
    {fhb_SegListBlocks}	seglistblocks	:VALUE
    {fhb_GlobalVec}	globalvec	:VALUE
    {fhb_Reserved2}	reserved2[23]	:ARRAY OF ULONG
    {fhb_FileSysName}	filesysname[84]	:ARRAY OF CHAR
ENDOBJECT


NATIVE {IDNAME_FILESYSHEADER}	CONST IDNAME_FILESYSHEADER	= $46534844  /* "FSHD" */

NATIVE {LoadSegBlock} OBJECT loadsegblock
    {lsb_ID}	id	:ULONG
    {lsb_SummedLongs}	summedlongs	:ULONG
    {lsb_ChkSum}	chksum	:VALUE
    {lsb_HostID}	hostid	:ULONG
    {lsb_Next}	next	:ULONG
    {lsb_LoadData}	loaddata[123]	:ARRAY OF ULONG
ENDOBJECT

NATIVE {IDNAME_LOADSEG}		CONST IDNAME_LOADSEG		= $4C534547  /* "LSEG" */
