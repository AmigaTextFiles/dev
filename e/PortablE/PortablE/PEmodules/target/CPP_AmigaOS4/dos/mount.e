/* $Id: mount.h,v 1.29 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/dos/dos', 'target/dos/errors'
MODULE 'target/utility/tagitem', 'target/exec/types'
{#include <dos/mount.h>}
NATIVE {DOS_MOUNT_H} CONST

/*
 * The type of device to mount
 */

/* A file system, which is associated with a block storage device */
NATIVE {MDT_FileSystem}  CONST MDT_FILESYSTEM  = 0

/* Any other kind which does not require a block storage device */
NATIVE {MDT_Handler}     CONST MDT_HANDLER     = 1

/****************************************************************************/

/*
 * Control tags which describe the device MountDevice() should mount
 */

NATIVE {MD_Dummy} CONST MD_DUMMY = (TAG_USER+4000)

/* Sector size in bytes (ULONG); must be a multiple of 4 */
NATIVE {MD_SectorSize} CONST MD_SECTORSIZE = (MD_DUMMY+1)

/* Number of surfaces the file system should use (ULONG) */
NATIVE {MD_Surfaces}   CONST MD_SURFACES   = (MD_DUMMY+2)

/* Number of sectors that make up a data block (ULONG) */
NATIVE {MD_SectorsPerBlock} CONST MD_SECTORSPERBLOCK = (MD_DUMMY+3)

/* Number of sectors that make up a track (ULONG) */
NATIVE {MD_SectorsPerTrack} CONST MD_SECTORSPERTRACK = (MD_DUMMY+4)

/* Number of sectors at the beginning of the partition which
   should not be touched by the file system (ULONG) */
NATIVE {MD_Reserved} CONST MD_RESERVED = (MD_DUMMY+5)

/* Number of sectors at the end of the partition which
   should not be touched by the file system (ULONG) */
NATIVE {MD_PreAlloc} CONST MD_PREALLOC = (MD_DUMMY+6)

/* Lowest cylinder number used by the file system (ULONG) */
NATIVE {MD_LowCyl}   CONST MD_LOWCYL   = (MD_DUMMY+7)

/* Highest cylinder number used by the file system (ULONG) */
NATIVE {MD_HighCyl}  CONST MD_HIGHCYL  = (MD_DUMMY+8)

/* Number of data buffers the file system is to use (ULONG) */
NATIVE {MD_NumBuffers} CONST MD_NUMBUFFERS = (MD_DUMMY+9)

/* The type of memory to use for data buffers (ULONG) */
NATIVE {MD_BufMemType} CONST MD_BUFMEMTYPE = (MD_DUMMY+10)

/* Maximum number of bytes the device driver can transfer
   in a single step (ULONG) */
NATIVE {MD_MaxTransfer} CONST MD_MAXTRANSFER = (MD_DUMMY+11)

/* Bit mask which covers the address range which the device driver
   can access (ULONG) */
NATIVE {MD_Mask} CONST MD_MASK = (MD_DUMMY+12)

/* File system signature, e.g. ID_DOS_DISK (ULONG) */
NATIVE {MD_DOSType} CONST MD_DOSTYPE = (MD_DUMMY+13)

/* Transmission speed (bits/second) to be used by the handler (ULONG) */
NATIVE {MD_Baud} CONST MD_BAUD = (MD_DUMMY+14)

/* Control information for the handler/file system (STRPTR). */
NATIVE {MD_Control} CONST MD_CONTROL = (MD_DUMMY+15)

/* Name of the exec device driver this file system is to use (STRPTR). */
NATIVE {MD_Device} CONST MD_DEVICE = (MD_DUMMY+16)

/* Exec device driver unit number to be used by this file system (ULONG). */
NATIVE {MD_Unit} CONST MD_UNIT = (MD_DUMMY+17)

/* Flags to use when the file system opens the exec device driver (ULONG). */
NATIVE {MD_Flags} CONST MD_FLAGS = (MD_DUMMY+18)

/* Size of the stack to allocate for the file system (ULONG). */
NATIVE {MD_StackSize} CONST MD_STACKSIZE = (MD_DUMMY+19)

/* Priority to start the file system process with (LONG). */
NATIVE {MD_Priority} CONST MD_PRIORITY = (MD_DUMMY+20)

/* Global vector number (LONG). */
NATIVE {MD_GlobVec} CONST MD_GLOBVEC = (MD_DUMMY+21)

/* The number to store as the file system startup data (LONG). */
NATIVE {MD_StartupNumber} CONST MD_STARTUPNUMBER = (MD_DUMMY+22)

/* The string to store as the file system startup data (STRPTR). */
NATIVE {MD_StartupString} CONST MD_STARTUPSTRING = (MD_DUMMY+23)

/* Whether the file system parameters should be initialized from the
   FileSystem.resource or not (BOOL). */
NATIVE {MD_IgnoreFSR} CONST MD_IGNOREFSR = (MD_DUMMY+24)

/* Whether the file system should be activated immediately after it
   has been mounted (BOOL). */
NATIVE {MD_Activate} CONST MD_ACTIVATE = (MD_DUMMY+25)

/* Name of the handler which implements the file system (STRPTR). */
NATIVE {MD_Handler} CONST MD_HANDLER = (MD_DUMMY+26)

/* The segment list which refers to the code which implements the
   file system (BPTR). */
NATIVE {MD_SegList} CONST MD_SEGLIST = (MD_DUMMY+27)

/* The port which implements the file system (struct MsgPort *). */
NATIVE {MD_Port} CONST MD_PORT = (MD_DUMMY+28)

/* The function which implements the file system (VOID (*)(VOID)). */
NATIVE {MD_Entry} CONST MD_ENTRY = (MD_DUMMY+29)

/****************************************************************************/

/*
 * All error codes defined for MountDevice() can be found in the
 * <dos/errors.h> header file.
 */

/****************************************************************************/

/*
 * Flags for DismountDevice()
 */
 
NATIVE {DMDF_KEEPDEVICE}          CONST DMDF_KEEPDEVICE          = $1
NATIVE {DMDF_REMOVEDEVICE}        CONST DMDF_REMOVEDEVICE        = $2
NATIVE {DMDF_FORCE_DISMOUNT}      CONST DMDF_FORCE_DISMOUNT      = $4
