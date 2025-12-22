/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: hardblocks.h
 *	Created ..: Wednesday 19-Feb-92 09:25:36
 *	Revision .: 2
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	10-Apr-92   Torsten Jürgeleit      Add structure for standard
 *                                         hardblock header
 *	17-Mar-92   Torsten Jürgeleit      New error codes HBERR_NO_DEVICE
 *                                         and HBERR_NO_HOST_ID
 *	19-Feb-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Defines, structures, prototypes and pragmas for hardblocks functions
 *
 * $Revision Header ********************************************************/

#ifndef LIBRARIES_HARDBLOCKS_H
#define LIBRARIES_HARDBLOCKS_H

	/* Includes */

#ifndef	EXEC_TYPES_H
#include <exec/types.h>
#endif	/* EXEC_TYPES_H */

#ifndef	DEVICES_HARDBLOCKS_H
#include <devices/hardblocks.h>
#endif	/* DEVICES_HARDBLOCKS_H */

#ifndef	DEVICES_SCSIDISK_H
#include <devices/scsidisk.h>
#endif	/* DEVICES_SCSIDISK_H */

#ifndef	LIBRARIES_DOSEXTENS_H
#include <libraries/dosextens.h>
#endif	LIBRARIES_DOSEXTENS_H

	/* Defines for hardblocks */

#define HardBlocksName		"hardblocks.library"
#define HardBlocksVersion	1L

#define HB_NULL			0xffffffff

	/* Standard hardblock header structure (common to most hardblocks) */

struct HardBlockHeader {
	ULONG	hbh_ID;			/* 4 character identifier */
	ULONG	hbh_SummedLongs;	/* size of block in longwords */
	ULONG	hbh_ChkSum;		/* block checksum (longword sum to zero) */
	ULONG	hbh_HostID;		/* SCSI Target ID of host */
	ULONG	hbh_Next;		/* block number of next block */
};
	/* Custom hardblock structure used for BadBlock and LoadSeg lists */

struct DataBlock {
	ULONG	db_ID;			/* 4 character identifier */
	ULONG	db_BlockLongs;		/* size of block in longwords */
	ULONG	db_ChkSum;		/* block checksum (longword sum to zero) */
	ULONG	db_HostID;		/* SCSI Target ID of host */
	ULONG	db_Data[1];		/* first longword of data */
};
	/* Error codes */

#define HBERR_INVALID_PARAMETERS	1
#define HBERR_OUT_OF_MEM		2
#define HBERR_NO_DEVICE			3	/* selected device don't exist */
#define HBERR_NO_BOARD			4	/* selected board from unit num don't exist */
#define HBERR_NO_HOST_ID		5	/* can't find target id of controller for rdb_HostID */
#define HBERR_DEVICE_OPEN_FAILED	6	/* selected device unit don't exist or isn't ready */
#define HBERR_DEVICE_READ_FAILED	7
#define HBERR_DEVICE_WRITE_FAILED	8
#define HBERR_NO_HD_SCSI_CMD		9
#define HBERR_SELF_UNIT			10	/* cannot issue SCSI command to self */
#define HBERR_DMA			11	/* DMA error */
#define HBERR_PHASE			12	/* illegal or unexpected SCSI phase */
#define HBERR_PARITY			13	/* SCSI parity error */
#define HBERR_SELECT_TIMEOUT		14	/* Select timed out */
#define HBERR_BAD_STATUS		15	/* status and/or sense error */
#define HBERR_INQUIRY_FAILED		16
#define HBERR_MODE_SENSE_FAILED		17
#define HBERR_SCSI_CMD_FAILED		18
#define HBERR_UNIT_NOT_READY		19
#define HBERR_NO_DIRECT_ACCESS		20
#define HBERR_INVALID_BLOCK_SIZE	21	/* wrong rdb_BlockBytes */
#define HBERR_INVALID_HARDBLOCKS_AREA	22	/* incorrect rdb_RDBBlocksLo/Hi */
#define HBERR_HARDBLOCKS_AREA_TOO_SMALL	23	/* reserved area (rdb_RDBBlocksLo/Hi) too small for hardblocks */
#define HBERR_INVALID_BLOCK_NUM		24	/* block num greater than num of last logical block of device unit */
#define HBERR_INVALID_BLOCK_PTR		25	/* odd aligned ptr to block in memory */
#define HBERR_UNKNOWN_ID		26	/* block with unsupported id */
#define HBERR_INVALID_ID		27
#define HBERR_INVALID_SUMMED_LONGS	28
#define HBERR_INVALID_CHECKSUM		29
#define HBERR_NO_RIGIDDISK		30
#define HBERR_INVALID_RIGIDDISK		31
#define HBERR_INVALID_BADBLOCK		32
#define HBERR_INVALID_PARTITION		33
#define HBERR_INVALID_FILESYSHEADER	34
#define HBERR_MISSING_FILESYSTEM	35
#define HBERR_INVALID_FILESYSTEM	36
#define HBERR_INVALID_DRIVEINIT		37
#define HBERR_INVALID_LOADSEG		38
#define HBERR_BREAK_ABORT		39	/* function was terminated by <ctrl c> */
#define HBERR_FILE_OPEN_FAILED		40
#define HBERR_FILE_SEEK_FAILED		41
#define HBERR_FILE_READ_FAILED		42
#define HBERR_FILE_WRITE_FAILED		43

	/* Prototypes */

USHORT LoadHardBlocks(struct RigidDiskBlock  *rdb, BYTE *device, ULONG unit);
USHORT SaveHardBlocks(struct RigidDiskBlock  *rdb, BYTE *device, ULONG unit);
USHORT RestoreHardBlocks(struct RigidDiskBlock  *rdb, BYTE *file);
USHORT BackupHardBlocks(struct RigidDiskBlock  *rdb, BYTE *file);
USHORT PrintHardBlocks(struct RigidDiskBlock  *rdb, BPTR fh);
USHORT FreeHardBlocks(struct RigidDiskBlock  *rdb);
USHORT RemoveHardBlocks(BYTE *device, ULONG unit);
USHORT InitRigidDiskBlock(struct RigidDiskBlock  *rdb, BYTE *device,
								ULONG unit);
USHORT LastHardBlockNum(struct RigidDiskBlock  *rdb);

	/* Pragmas for Manx and Lattice */

#ifndef	__NO_PRAGMAS
#ifdef	AZTEC_C
#pragma amicall(HardBlocksBase, 0x1e, LoadHardBlocks(a0,a1,d0))
#pragma amicall(HardBlocksBase, 0x24, SaveHardBlocks(a0,a1,d0))
#pragma amicall(HardBlocksBase, 0x2a, RestoreHardBlocks(a0,a1))
#pragma amicall(HardBlocksBase, 0x30, BackupHardBlocks(a0,a1))
#pragma amicall(HardBlocksBase, 0x36, PrintHardBlocks(a0,a1))
#pragma amicall(HardBlocksBase, 0x3c, FreeHardBlocks(a0))
#pragma amicall(HardBlocksBase, 0x42, RemoveHardBlocks(a0,d0))
#pragma amicall(HardBlocksBase, 0x48, InitRigidDiskBlock(a0,a1,d0))
#pragma amicall(HardBlocksBase, 0x4e, LastHardBlockNum(a0))
#else	/* AZTEC_C */
#pragma libcall HardBlocksBase LoadHardBlocks 1e 9803
#pragma libcall HardBlocksBase SaveHardBlocks 24 9803
#pragma libcall HardBlocksBase RestoreHardBlocks 2a 9802
#pragma libcall HardBlocksBase BackupHardBlocks 30 9802
#pragma libcall HardBlocksBase PrintHardBlocks 36 9802
#pragma libcall HardBlocksBase FreeHardBlocks 3c 801
#pragma libcall HardBlocksBase RemoveHardBlocks 42 802
#pragma libcall HardBlocksBase InitRigidDiskBlock 48 9803
#pragma libcall HardBlocksBase LastHardBlockNum 4e 801
#endif	/* AZTEC_C */
#endif	/* __NO_PRAGMAS */

#endif	/* LIBRARIES_HARDBLOCKS_H */
