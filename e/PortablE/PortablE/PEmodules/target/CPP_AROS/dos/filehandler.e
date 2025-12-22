/* $Id: filehandler.h 25328 2007-03-04 12:57:35Z rob $ */
OPT NATIVE
MODULE 'target/exec/ports', 'target/exec/types', 'target/dos/bptr', 'target/dos/dos'
MODULE 'target/dos/dosextens', 'target/exec/devices'
{#include <dos/filehandler.h>}
NATIVE {DOS_FILEHANDLER_H} CONST

NATIVE {DosEnvec} OBJECT dosenvec
    {de_TableSize}	tablesize	:IPTR      /* Size of this structure. Must be at least
                               11 (DE_NUMBUFFERS). */
    {de_SizeBlock}	sizeblock	:IPTR      /* Size in longwords of a block on the disk. */
    {de_SecOrg}	secorg	:IPTR         /* Unused. Must be 0 for now. */
    {de_Surfaces}	surfaces	:IPTR       /* Number of heads/surfaces in drive. */
    {de_SectorPerBlock}	sectorperblock	:IPTR /* Unused. Must be 1 for now. */
    {de_BlocksPerTrack}	blockspertrack	:IPTR /* Number of blocks on a track. */
    {de_Reserved}	reserved	:IPTR       /* Number of reserved blocks at beginning of
                               volume. */
    {de_PreAlloc}	prealloc	:IPTR       /* Number of reserved blocks at end of volume. */
    {de_Interleave}	interleave	:IPTR
    {de_LowCyl}	lowcyl	:IPTR         /* First cylinder. */
    {de_HighCyl}	highcyl	:IPTR        /* Last cylinder. */
    {de_NumBuffers}	numbuffers	:IPTR     /* Number of buffers for drive. */
    {de_BufMemType}	bufmemtype	:IPTR     /* Type of memory for buffers. See <exec/memory.h>.
                            */
    {de_MaxTransfer}	maxtransfer	:IPTR    /* How many bytes may be transferred together? */
    {de_Mask}	mask	:IPTR           /* Memory address mask for DMA devices. */
    {de_BootPri}	bootpri	:IPTR        /* Priority of Autoboot. */
    {de_DosType}	dostype	:IPTR        /* Type of disk. See <dos/dos.h> for definitions.
                            */
    {de_Baud}	baud	:IPTR           /* Baud rate to use. */
    {de_Control}	control	:IPTR        /* Control word. */
    {de_BootBlocks}	bootblocks	:IPTR     /* Size of bootblock. */
ENDOBJECT

NATIVE {DE_TABLESIZE}    CONST DE_TABLESIZE    = 0
NATIVE {DE_SIZEBLOCK}    CONST DE_SIZEBLOCK    = 1
NATIVE {DE_BLOCKSIZE}    CONST DE_BLOCKSIZE    = 2
NATIVE {DE_NUMHEADS}     CONST DE_NUMHEADS     = 3
NATIVE {DE_SECSPERBLOCK} CONST DE_SECSPERBLOCK = 4
NATIVE {DE_BLKSPERTRACK} CONST DE_BLKSPERTRACK = 5
NATIVE {DE_RESERVEDBLKS} CONST DE_RESERVEDBLKS = 6
NATIVE {DE_PREFAC}       CONST DE_PREFAC       = 7
NATIVE {DE_INTERLEAVE}   CONST DE_INTERLEAVE   = 8
NATIVE {DE_LOWCYL}       CONST DE_LOWCYL       = 9
NATIVE {DE_HIGHCYL}      CONST DE_HIGHCYL      = 10
NATIVE {DE_UPPERCYL}     CONST DE_UPPERCYL     = DE_HIGHCYL
NATIVE {DE_NUMBUFFERS}   CONST DE_NUMBUFFERS   = 11
NATIVE {DE_BUFMEMTYPE}   CONST DE_BUFMEMTYPE   = 12
NATIVE {DE_MEMBUFTYPE}   CONST DE_MEMBUFTYPE   = DE_BUFMEMTYPE
NATIVE {DE_MAXTRANSFER}  CONST DE_MAXTRANSFER  = 13
NATIVE {DE_MASK}         CONST DE_MASK         = 14
NATIVE {DE_BOOTPRI}      CONST DE_BOOTPRI      = 15
NATIVE {DE_DOSTYPE}      CONST DE_DOSTYPE      = 16
NATIVE {DE_BAUD}         CONST DE_BAUD         = 17
NATIVE {DE_CONTROL}      CONST DE_CONTROL      = 18
NATIVE {DE_BOOTBLOCKS}   CONST DE_BOOTBLOCKS   = 19


NATIVE {FileSysStartupMsg} OBJECT filesysstartupmsg
    {fssm_Unit}	unit	:ULONG    /* Unit number of device used. */
    {fssm_Device}	device	:BSTR  /* Device name. */
    {fssm_Environ}	environ	:BPTR /* Pointer to disk environment array, like the one
                           above. */
    {fssm_Flags}	flags	:ULONG   /* Flags to be passed to OpenDevice(). */
ENDOBJECT


NATIVE {DeviceNode} OBJECT devicenode
      /* PRIVATE pointer to next entry. In AmigaOS this used to be a BPTR. */
    {dn_Next}	next	:PTR TO doslist
      /* Type of this node. Has to be DLT_DEVICE. */
    {dn_Type}	type	:ULONG

    {dn_Task}	task	:PTR TO mp   /* dol_Task field */
    {dn_Lock}	lock	:BPTR	/* dol_Lock field */

    {dn_Handler}	handler	:BSTR    /* Null-terminated device name for handler. */
    {dn_StackSize}	stacksize	:ULONG  /* Initial stacksize for packet-handler task */
    {dn_Priority}	priority	:VALUE   /* Initial priority for packet-handler task */
    {dn_Startup}	startup	:BPTR    /* (struct FileSysStartupMsg *) see above */
    {dn_NoAROS3}	noaros3[2]	:ARRAY OF BPTR /* PRIVATE */

    /* For the following two fields, see comments in <dos/dosextens.h>.
       Both fields specify the name of the handler. */
    {dn_OldName}	oldname	:BSTR
    {dn_NewName}	name	:/*STRPTR*/ ARRAY OF CHAR

    {dn_Device}	device	:PTR TO dd
    {dn_Unit}	unit	:PTR TO unit
ENDOBJECT
NATIVE {dn_Name} DEF
