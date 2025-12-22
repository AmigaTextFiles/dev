/* $VER: hardblocks.h 44.2 (20.10.1999) */
OPT NATIVE
MODULE 'target/exec/types'
{MODULE 'devices/hardblocks'}

NATIVE {rigiddiskblock} OBJECT rigiddiskblock
    {id}	id	:ULONG		/* 4 character identifier */
    {summedlongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {chksum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {hostid}	hostid	:ULONG		/* SCSI Target ID of host */
    {blockbytes}	blockbytes	:ULONG	/* size of disk blocks */
    {flags}	flags	:ULONG		/* see below for defines */
    /* block list heads */
    {badblocklist}	badblocklist	:ULONG	/* optional bad block list */
    {partitionlist}	partitionlist	:ULONG	/* optional first partition block */
    {filesysheaderlist}	filesysheaderlist	:ULONG /* optional file system header block */
    {driveinit}	driveinit	:ULONG	/* optional drive-specific init code */
				/* DriveInit(lun,rdb,ior): "C" stk & d0/a0/a1 */
    {reserved1}	reserved1[6]	:ARRAY OF ULONG	/* set to $ffffffff */
    /* physical drive characteristics */
    {cylinders}	cylinders	:ULONG	/* number of drive cylinders */
    {sectors}	sectors	:ULONG	/* sectors per track */
    {heads}	heads	:ULONG		/* number of drive heads */
    {interleave}	interleave	:ULONG	/* interleave */
    {park}	park	:ULONG		/* landing zone cylinder */
    {reserved2}	reserved2[3]	:ARRAY OF ULONG
    {writeprecomp}	writeprecomp	:ULONG	/* starting cylinder: write precompensation */
    {reducedwrite}	reducedwrite	:ULONG	/* starting cylinder: reduced write current */
    {steprate}	steprate	:ULONG	/* drive step rate */
    {reserved3}	reserved3[5]	:ARRAY OF ULONG
    /* logical drive characteristics */
    {rdbblockslo}	rdbblockslo	:ULONG	/* low block of range reserved for hardblocks */
    {rdbblockshi}	rdbblockshi	:ULONG	/* high block of range for these hardblocks */
    {locylinder}	locylinder	:ULONG	/* low cylinder of partitionable disk area */
    {hicylinder}	hicylinder	:ULONG	/* high cylinder of partitionable data area */
    {cylblocks}	cylblocks	:ULONG	/* number of blocks available per cylinder */
    {autoparkseconds}	autoparkseconds	:ULONG /* zero for no auto park */
    {highrdskblock}	highrdskblock	:ULONG	/* highest block used by RDSK */
				/* (not including replacement bad blocks) */
    {reserved4}	reserved4	:ULONG
    /* drive identification */
    {diskvendor}	diskvendor[8]	:ARRAY OF CHAR
    {diskproduct}	diskproduct[16]	:ARRAY OF CHAR
    {diskrevision}	diskrevision[4]	:ARRAY OF CHAR
    {controllervendor}	controllervendor[8]	:ARRAY OF CHAR
    {controllerproduct}	controllerproduct[16]	:ARRAY OF CHAR
    {controllerrevision}	controllerrevision[4]	:ARRAY OF CHAR
    {driveinitname}	driveinitname[40]	:ARRAY OF CHAR -> jdow: Filename for driveinit source
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
NATIVE {badblockentry} OBJECT badblockentry
    {badblock}	badblock	:ULONG	/* block number of bad block */
    {goodblock}	goodblock	:ULONG	/* block number of replacement block */
ENDOBJECT

NATIVE {badblockblock} OBJECT badblockblock
    {id}	id	:ULONG		/* 4 character identifier */
    {summedlongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {chksum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {hostid}	hostid	:ULONG		/* SCSI Target ID of host */
    {next}	next	:ULONG		/* block number of the next BadBlockBlock */
    {reserved}	reserved	:ULONG
    {blockpairs}	blockpairs[61]	:ARRAY OF badblockentry /* bad block entry pairs */
    /* note [61] assumes 512 byte blocks */
ENDOBJECT

NATIVE {IDNAME_BADBLOCK}		CONST IDNAME_BADBLOCK		= $42414442	/* 'BADB' */

/*------------------------------------------------------------------*/
NATIVE {partitionblock} OBJECT partitionblock
    {id}	id	:ULONG		/* 4 character identifier */
    {summedlongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {chksum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {hostid}	hostid	:ULONG		/* SCSI Target ID of host */
    {next}	next	:ULONG		/* block number of the next PartitionBlock */
    {flags}	flags	:ULONG		/* see below for defines */
    {reserved1}	reserved1[2]	:ARRAY OF ULONG
    {devflags}	devflags	:ULONG	/* preferred flags for OpenDevice */
    {drivename}	drivename[32]	:ARRAY OF UBYTE	/* preferred DOS device name: BSTR form */
				/* (not used if this name is in use) */
    {reserved2}	reserved2[15]	:ARRAY OF ULONG	/* filler to 32 longwords */
    {environment}	environment[20]	:ARRAY OF ULONG	/* environment vector for this partition */
    {ereserved}	ereserved[12]	:ARRAY OF ULONG	/* reserved for future environment vector */
ENDOBJECT

NATIVE {IDNAME_PARTITION}	CONST IDNAME_PARTITION	= $50415254	/* 'PART' */

CONST PBFB_BOOTABLE	= 0	/* this partition is intended to be bootable */
NATIVE {PBFF_BOOTABLE}	CONST PBFF_BOOTABLE	= $1	/*   (expected directories and files exist) */
CONST PBFB_NOMOUNT	= 1	/* do not mount this partition (e.g. manually */
NATIVE {PBFF_NOMOUNT}	CONST PBFF_NOMOUNT	= $2	/*   mounted, but space reserved here) */

/*------------------------------------------------------------------*/
NATIVE {filesysheaderblock} OBJECT filesysheaderblock
    {id}	id	:ULONG		/* 4 character identifier */
    {summedlongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {chksum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {hostid}	hostid	:ULONG		/* SCSI Target ID of host */
    {next}	next	:ULONG		/* block number of next FileSysHeaderBlock */
    {flags}	flags	:ULONG		/* see below for defines */
    {reserved1}	reserved1[2]	:ARRAY OF ULONG
    {dostype}	dostype	:ULONG	/* file system description: match this with */
				/* partition environment's DE_DOSTYPE entry */
    {version}	version	:ULONG	/* release version of this code */
    {patchflags}	patchflags	:ULONG	/* bits set for those of the following that */
				/*   need to be substituted into a standard */
				/*   device node for this file system: e.g. */
				/*   $180 to substitute SegList & GlobalVec */
    {type}	type	:ULONG		/* device node type: zero */
    {task}	task	:ULONG		/* standard dos "task" field: zero */
    {lock}	lock	:ULONG		/* not used for devices: zero */
    {handler}	handler	:ULONG	/* filename to loadseg: zero placeholder */
    {stacksize}	stacksize	:ULONG	/* stacksize to use when starting task */
    {priority}	priority	:VALUE	/* task priority when starting task */
    {startup}	startup	:VALUE	/* startup msg: zero placeholder */
    {seglistblocks}	seglistblocks	:VALUE	/* first of linked list of LoadSegBlocks: */
				/*   note that this entry requires some */
				/*   processing before substitution */
    {globalvec}	globalvec	:VALUE	/* BCPL global vector when starting task */
    {reserved2}	reserved2[23]	:ARRAY OF ULONG	/* (those reserved by PatchFlags) */
    {filesysname}	filesysname[84]	:ARRAY OF CHAR /* File system file name as loaded. */
ENDOBJECT

NATIVE {IDNAME_FILESYSHEADER}	CONST IDNAME_FILESYSHEADER	= $46534844	/* 'FSHD' */

/*------------------------------------------------------------------*/
NATIVE {loadsegblock} OBJECT loadsegblock
    {id}	id	:ULONG		/* 4 character identifier */
    {summedlongs}	summedlongs	:ULONG	/* size of this checksummed structure */
    {chksum}	chksum	:VALUE		/* block checksum (longword sum to zero) */
    {hostid}	hostid	:ULONG		/* SCSI Target ID of host */
    {next}	next	:ULONG		/* block number of the next LoadSegBlock */
    {loaddata}	loaddata[123]	:ARRAY OF ULONG	/* data for "loadseg" */
    /* note [123] assumes 512 byte blocks */
ENDOBJECT

NATIVE {IDNAME_LOADSEG}		CONST IDNAME_LOADSEG		= $4C534547	/* 'LSEG' */
