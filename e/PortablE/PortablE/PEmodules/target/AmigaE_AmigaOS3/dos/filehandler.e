/* $VER: filehandler.h 44.1 (24.8.99) */
OPT NATIVE
MODULE 'target/exec/ports', 'target/dos/dos_shared'
MODULE 'target/exec/types', 'target/dos/dos'
{MODULE 'dos/filehandler'}

NATIVE {dosenvec} OBJECT dosenvec
    {tablesize}	tablesize	:ULONG	     /* Size of Environment vector */
    {sizeblock}	sizeblock	:ULONG	     /* in longwords: Physical disk block size */
    {secorg}	secorg	:ULONG	     /* not used; must be 0 */
    {surfaces}	surfaces	:ULONG	     /* # of heads (surfaces). drive specific */
    {sectorperblock}	sectorperblock	:ULONG /* N de_SizeBlock sectors per logical block */
    {blockspertrack}	blockspertrack	:ULONG /* blocks per track. drive specific */
    {reserved}	reserved	:ULONG	     /* DOS reserved blocks at start of partition. */
    {prealloc}	prealloc	:ULONG	     /* DOS reserved blocks at end of partition */
    {interleave}	interleave	:ULONG     /* usually 0 */
    {lowcyl}	lowcyl	:ULONG	     /* starting cylinder. typically 0 */
    {highcyl}	highcyl	:ULONG	     /* max cylinder. drive specific */
    {numbuffers}	numbuffers	:ULONG     /* Initial # DOS of buffers.  */
    {bufmemtype}	bufmemtype	:ULONG     /* type of mem to allocate for buffers */
    {maxtransfer}	maxtransfer	:ULONG    /* Max number of bytes to transfer at a time */
    {mask}	mask	:ULONG	     /* Address Mask to block out certain memory */
    {bootpri}	bootpri	:VALUE	     /* Boot priority for autoboot */
    {dostype}	dostype	:ULONG	     /* ASCII (HEX) string showing filesystem type;
									      * 0X444F5300 is old filesystem,
									      * 0X444F5301 is fast file system */
    {baud}	baud	:ULONG	     /* Baud rate for serial handler */
    {control}	control	:ULONG	     /* Control word for handler/filesystem */
    {bootblocks}	bootblocks	:ULONG     /* Number of blocks containing boot code */

ENDOBJECT

/* these are the offsets into the array */

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

NATIVE {filesysstartupmsg} OBJECT filesysstartupmsg
    {unit}	unit	:ULONG	/* exec unit number for this device */
    {device}	device	:BSTR	/* null terminated bstring to the device name */
    {environ}	environ	:BPTR	/* ptr to environment table (see above) */
    {flags}	flags	:ULONG	/* flags for OpenDevice() */
ENDOBJECT


NATIVE {devicenode} OBJECT devicenode
    {next}	next	:BPTR	/* singly linked list */
    {type}	type	:ULONG	/* always 0 for dos "devices" */
    {task}	task	:PTR TO mp	/* standard dos "task" field.  If this is
									 * null when the node is accesses, a task
									 * will be started up */
    {lock}	lock	:BPTR	/* not used for devices -- leave null */
    {handler}	handler	:BSTR	/* filename to loadseg (if seglist is null) */
    {stacksize}	stacksize	:ULONG	/* stacksize to use when starting task */
    {priority}	priority	:VALUE	/* task priority when starting task */
    {startup}	startup	:BPTR	/* startup msg: FileSysStartupMsg for disks */
    {seglist}	seglist	:BPTR	/* code to run to start new task (if necessary).
											 * if null then dn_Handler will be loaded. */
    {globalvec}	globalvec	:BPTR	/* BCPL global vector to use when starting
				 * a task.  -1 means that dn_SegList is not
				 * for a bcpl program, so the dos won't
				 * try and construct one.  0 tell the
				 * dos that you obey BCPL linkage rules,
				 * and that it should construct a global
				 * vector for you.
				 */
    {name}	name	:BSTR	/* the node name, e.g. '\3','D','F','3' */
ENDOBJECT
