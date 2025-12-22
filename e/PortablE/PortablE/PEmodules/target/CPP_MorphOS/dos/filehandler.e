/* $VER: filehandler.h 44.1 (24.8.99) */
OPT NATIVE
MODULE 'target/exec/ports', 'target/dos/dos_shared'
MODULE 'target/exec/types', 'target/dos/dos'
{#include <dos/filehandler.h>}
NATIVE {DOS_FILEHANDLER_H} CONST

/* The disk "environment" is a longword array that describes the
 * disk geometry.  It is variable sized, with the length at the beginning.
 * Here are the constants for a standard geometry.
 */

NATIVE {DosEnvec} OBJECT dosenvec
    {de_TableSize}	tablesize	:ULONG	     /* Size of Environment vector */
    {de_SizeBlock}	sizeblock	:ULONG	     /* in longwords: Physical disk block size */
    {de_SecOrg}	secorg	:ULONG	     /* not used; must be 0 */
    {de_Surfaces}	surfaces	:ULONG	     /* # of heads (surfaces). drive specific */
    {de_SectorPerBlock}	sectorperblock	:ULONG /* N de_SizeBlock sectors per logical block */
    {de_BlocksPerTrack}	blockspertrack	:ULONG /* blocks per track. drive specific */
    {de_Reserved}	reserved	:ULONG	     /* DOS reserved blocks at start of partition. */
    {de_PreAlloc}	prealloc	:ULONG	     /* DOS reserved blocks at end of partition */
    {de_Interleave}	interleave	:ULONG     /* usually 0 */
    {de_LowCyl}	lowcyl	:ULONG	     /* starting cylinder. typically 0 */
    {de_HighCyl}	highcyl	:ULONG	     /* max cylinder. drive specific */
    {de_NumBuffers}	numbuffers	:ULONG     /* Initial # DOS of buffers.  */
    {de_BufMemType}	bufmemtype	:ULONG     /* type of mem to allocate for buffers */
    {de_MaxTransfer}	maxtransfer	:ULONG    /* Max number of bytes to transfer at a time */
    {de_Mask}	mask	:ULONG	     /* Address Mask to block out certain memory */
    {de_BootPri}	bootpri	:VALUE	     /* Boot priority for autoboot */
    {de_DosType}	dostype	:ULONG	     /* ASCII (HEX) string showing filesystem type;
									      * 0X444F5300 is old filesystem,
									      * 0X444F5301 is fast file system */
    {de_Baud}	baud	:ULONG	     /* Baud rate for serial handler */
    {de_Control}	control	:ULONG	     /* Control word for handler/filesystem */
    {de_BootBlocks}	bootblocks	:ULONG     /* Number of blocks containing boot code */

ENDOBJECT

/* these are the offsets into the array */
/* DE_TABLESIZE is set to the number of longwords in the table minus 1 */

NATIVE {DE_TABLESIZE}	CONST DE_TABLESIZE	= 0	/* minimum value is 11 (includes NumBuffers) */
NATIVE {DE_SIZEBLOCK}	CONST DE_SIZEBLOCK	= 1	/* in longwords: standard value is 128 */
NATIVE {DE_SECORG}	CONST DE_SECORG	= 2	/* not used; must be 0 */
NATIVE {DE_NUMHEADS}	CONST DE_NUMHEADS	= 3	/* # of heads (surfaces). drive specific */
NATIVE {DE_SECSPERBLK}	CONST DE_SECSPERBLK	= 4	/* not used; must be 1 */
NATIVE {DE_BLKSPERTRACK} CONST DE_BLKSPERTRACK = 5	/* blocks per track. drive specific */
NATIVE {DE_RESERVEDBLKS} CONST DE_RESERVEDBLKS = 6	/* unavailable blocks at start.	 usually 2 */
NATIVE {DE_PREFAC}	CONST DE_PREFAC	= 7	/* not used; must be 0 */
NATIVE {DE_INTERLEAVE}	CONST DE_INTERLEAVE	= 8	/* usually 0 */
NATIVE {DE_LOWCYL}	CONST DE_LOWCYL	= 9	/* starting cylinder. typically 0 */
NATIVE {DE_UPPERCYL}	CONST DE_UPPERCYL	= 10	/* max cylinder.  drive specific */
NATIVE {DE_NUMBUFFERS}	CONST DE_NUMBUFFERS	= 11	/* starting # of buffers.  typically 5 */
NATIVE {DE_MEMBUFTYPE}	CONST DE_MEMBUFTYPE	= 12	/* type of mem to allocate for buffers. */
NATIVE {DE_BUFMEMTYPE}	CONST DE_BUFMEMTYPE	= 12	/* same as above, better name
				 * 1 is public, 3 is chip, 5 is fast */
NATIVE {DE_MAXTRANSFER}	CONST DE_MAXTRANSFER	= 13	/* Max number bytes to transfer at a time */
NATIVE {DE_MASK}		CONST DE_MASK		= 14	/* Address Mask to block out certain memory */
NATIVE {DE_BOOTPRI}	CONST DE_BOOTPRI	= 15	/* Boot priority for autoboot */
NATIVE {DE_DOSTYPE}	CONST DE_DOSTYPE	= 16	/* ASCII (HEX) string showing filesystem type;
				 * 0X444F5300 is old filesystem,
				 * 0X444F5301 is fast file system */
NATIVE {DE_BAUD}		CONST DE_BAUD		= 17	/* Baud rate for serial handler */
NATIVE {DE_CONTROL}	CONST DE_CONTROL	= 18	/* Control word for handler/filesystem */
NATIVE {DE_BOOTBLOCKS}	CONST DE_BOOTBLOCKS	= 19	/* Number of blocks containing boot code */

/* The file system startup message is linked into a device node's startup
** field.  It contains a pointer to the above environment, plus the
** information needed to do an exec OpenDevice().
*/
NATIVE {FileSysStartupMsg} OBJECT filesysstartupmsg
    {fssm_Unit}	unit	:ULONG	/* exec unit number for this device */
    {fssm_Device}	device	:BSTR	/* null terminated bstring to the device name */
    {fssm_Environ}	environ	:BPTR	/* ptr to environment table (see above) */
    {fssm_Flags}	flags	:ULONG	/* flags for OpenDevice() */
ENDOBJECT


/* The include file "libraries/dosextens.h" has a DeviceList structure.
 * The "device list" can have one of three different things linked onto
 * it.	Dosextens defines the structure for a volume.  DLT_DIRECTORY
 * is for an assigned directory.  The following structure is for
 * a dos "device" (DLT_DEVICE).
*/

NATIVE {DeviceNode} OBJECT devicenode
    {dn_Next}	next	:BPTR	/* singly linked list */
    {dn_Type}	type	:ULONG	/* always 0 for dos "devices" */
    {dn_Task}	task	:PTR TO mp	/* standard dos "task" field.  If this is
									 * null when the node is accesses, a task
									 * will be started up */
    {dn_Lock}	lock	:BPTR	/* not used for devices -- leave null */
    {dn_Handler}	handler	:BSTR	/* filename to loadseg (if seglist is null) */
    {dn_StackSize}	stacksize	:ULONG	/* stacksize to use when starting task */
    {dn_Priority}	priority	:VALUE	/* task priority when starting task */
    {dn_Startup}	startup	:BPTR	/* startup msg: FileSysStartupMsg for disks */
    {dn_SegList}	seglist	:BPTR	/* code to run to start new task (if necessary).
											 * if null then dn_Handler will be loaded. */
    {dn_GlobalVec}	globalvec	:BPTR	/* BCPL global vector to use when starting
				 * a task.  -1 means that dn_SegList is not
				 * for a bcpl program, so the dos won't
				 * try and construct one.  0 tell the
				 * dos that you obey BCPL linkage rules,
				 * and that it should construct a global
				 * vector for you.
				 */
    {dn_Name}	name	:BSTR	/* the node name, e.g. '\3','D','F','3' */
ENDOBJECT
