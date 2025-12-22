/* $VER: execbase.h 39.6 (18.1.1993) */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/interrupts', 'target/exec/libraries', 'target/exec/tasks'
MODULE 'target/exec/types'
{#include <exec/execbase.h>}
NATIVE {EXEC_EXECBASE_H} CONST

/* Definition of the Exec library base structure (pointed to by location 4).
** Most fields are not to be viewed or modified by user programs.  Use
** extreme caution.
*/
NATIVE {ExecBase} OBJECT execbase
	{LibNode}	lib	:lib /* Standard library node */

/******** Static System Variables ********/

	{SoftVer}	softver	:UINT	/* kickstart release number (obs.) */
	{LowMemChkSum}	lowmemchksum	:INT	/* checksum of 68000 trap vectors */
	{ChkBase}	chkbase	:ULONG	/* system base pointer complement */
	{ColdCapture}	coldcapture	:APTR	/* coldstart soft capture vector */
	{CoolCapture}	coolcapture	:APTR	/* coolstart soft capture vector */
	{WarmCapture}	warmcapture	:APTR	/* warmstart soft capture vector */
	{SysStkUpper}	sysstkupper	:APTR	/* system stack base   (upper bound) */
	{SysStkLower}	sysstklower	:APTR	/* top of system stack (lower bound) */
	{MaxLocMem}	maxlocmem	:ULONG	/* top of chip memory */
	{DebugEntry}	debugentry	:APTR	/* global debugger entry point */
	{DebugData}	debugdata	:APTR	/* global debugger data segment */
	{AlertData}	alertdata	:APTR	/* alert data segment */
	{MaxExtMem}	maxextmem	:APTR	/* top of extended mem, or null if none */

	{ChkSum}	chksum	:UINT	/* for all of the above (minus 2) */

/****** Interrupt Related ***************************************/

	{IntVects[0]}	ivtbe	:iv
	{IntVects[1]}	ivdskblk	:iv
	{IntVects[2]}	ivsoftint	:iv
	{IntVects[3]}	ivports	:iv
	{IntVects[4]}	ivcoper	:iv
	{IntVects[5]}	ivvertb	:iv
	{IntVects[6]}	ivblit	:iv
	{IntVects[7]}	ivaud0	:iv
	{IntVects[8]}	ivaud1	:iv
	{IntVects[9]}	ivaud2	:iv
	{IntVects[10]}	ivaud3	:iv
	{IntVects[11]}	ivrbf	:iv
	{IntVects[12]}	ivdsksync	:iv
	{IntVects[13]}	ivexter	:iv
	{IntVects[14]}	ivinten	:iv
	{IntVects[15]}	ivnmi	:iv

/****** Dynamic System Variables *************************************/

	{ThisTask}	thistask	:PTR TO tc /* pointer to current task (readable) */

	{IdleCount}	idlecount	:ULONG	/* idle counter */
	{DispCount}	dispcount	:ULONG	/* dispatch counter */
	{Quantum}	quantum	:UINT	/* time slice quantum */
	{Elapsed}	elapsed	:UINT	/* current quantum ticks */
	{SysFlags}	sysflags	:UINT	/* misc internal system flags */
	{IDNestCnt}	idnestcnt	:BYTE	/* interrupt disable nesting count */
	{TDNestCnt}	tdnestcnt	:BYTE	/* task disable nesting count */

	{AttnFlags}	attnflags	:UINT	/* special attention flags (readable) */

	{AttnResched}	attnresched	:UINT	/* rescheduling attention */
	{ResModules}	resmodules	:APTR	/* resident module array pointer */
	{TaskTrapCode}	tasktrapcode	:APTR
	{TaskExceptCode}	taskexceptcode	:APTR
	{TaskExitCode}	taskexitcode	:APTR
	{TaskSigAlloc}	tasksigalloc	:ULONG
	{TaskTrapAlloc}	tasktrapalloc	:UINT


/****** System Lists (private!) ********************************/

	{MemList}	memlist	:lh
	{ResourceList}	resourcelist	:lh
	{DeviceList}	devicelist	:lh
	{IntrList}	intrlist	:lh
	{LibList}	liblist	:lh
	{PortList}	portlist	:lh
	{TaskReady}	taskready	:lh
	{TaskWait}	taskwait	:lh

	{SoftInts}	softints[5]	:ARRAY OF sh

/****** Other Globals *******************************************/

	{LastAlert}	lastalert[4]	:ARRAY OF VALUE

	/* these next two variables are provided to allow
	** system developers to have a rough idea of the
	** period of two externally controlled signals --
	** the time between vertical blank interrupts and the
	** external line rate (which is counted by CIA A's
	** "time of day" clock).  In general these values
	** will be 50 or 60, and may or may not track each
	** other.  These values replace the obsolete AFB_PAL
	** and AFB_50HZ flags.
	*/
	{VBlankFrequency}	vblankfrequency	:UBYTE	/* (readable) */
	{PowerSupplyFrequency}	powersupplyfrequency	:UBYTE	/* (readable) */

	{SemaphoreList}	semaphorelist	:lh

	/* these next two are to be able to kickstart into user ram.
	** KickMemPtr holds a singly linked list of MemLists which
	** will be removed from the memory list via AllocAbs.  If
	** all the AllocAbs's succeeded, then the KickTagPtr will
	** be added to the rom tag list.
	*/
	{KickMemPtr}	kickmemptr	:APTR	/* ptr to queue of mem lists */
	{KickTagPtr}	kicktagptr	:APTR	/* ptr to rom tag queue */
	{KickCheckSum}	kickchecksum	:APTR	/* checksum for mem and tags */

/****** V36 Exec additions start here **************************************/

	{ex_Pad0}	pad0	:UINT		/* Private internal use */
	{ex_LaunchPoint}	launchpoint	:ULONG		/* Private to Launch/Switch */
	{ex_RamLibPrivate}	ramlibprivate	:APTR
	/* The next ULONG contains the system "E" clock frequency,
	** expressed in Hertz.	The E clock is used as a timebase for
	** the Amiga's 8520 I/O chips. (E is connected to "02").
	** Typical values are 715909 for NTSC, or 709379 for PAL.
	*/
	{ex_EClockFrequency}	eclockfrequency	:ULONG	/* (readable) */
	{ex_CacheControl}	cachecontrol	:ULONG	/* Private to CacheControl calls */
	{ex_TaskID}	taskid	:ULONG		/* Next available task ID */

	{ex_Reserved1}	reserved1[5]	:ARRAY OF ULONG

	{ex_MMULock}	mmulock	:APTR		/* private */

	{ex_Reserved2}	reserved2[3]	:ARRAY OF ULONG

/****** V39 Exec additions start here **************************************/

	/* The following list and data element are used
	 * for V39 exec's low memory handler...
	 */
	{ex_MemHandlers}	memhandlers	:mlh	/* The handler list */
	{ex_MemHandler}	memhandler	:APTR		/* Private! handler pointer */
ENDOBJECT


/****** Bit defines for AttnFlags (see above) ******************************/

/*  Processors and Co-processors: */
NATIVE {AFB_68010}	CONST AFB_68010	= 0	/* also set for 68020 */
NATIVE {AFB_68020}	CONST AFB_68020	= 1	/* also set for 68030 */
NATIVE {AFB_68030}	CONST AFB_68030	= 2	/* also set for 68040 */
NATIVE {AFB_68040}	CONST AFB_68040	= 3	/* also set for 68060 */
NATIVE {AFB_68881}	CONST AFB_68881	= 4	/* also set for 68882 */
NATIVE {AFB_68882}	CONST AFB_68882	= 5
NATIVE {AFB_FPU40}	CONST AFB_FPU40	= 6	/* Set if 68040 FPU */
NATIVE {AFB_68060}	CONST AFB_68060	= 7
/*
 * The AFB_FPU40 bit is set when a working 68040 FPU
 * is in the system.  If this bit is set and both the
 * AFB_68881 and AFB_68882 bits are not set, then the 68040
 * math emulation code has not been loaded and only 68040
 * FPU instructions are available.  This bit is valid *ONLY*
 * if the AFB_68040 bit is set.
 */

NATIVE {AFB_PRIVATE}	CONST AFB_PRIVATE	= 15	/* Just what it says */

NATIVE {AFF_68010}	CONST AFF_68010	= $1
NATIVE {AFF_68020}	CONST AFF_68020	= $2
NATIVE {AFF_68030}	CONST AFF_68030	= $4
NATIVE {AFF_68040}	CONST AFF_68040	= $8
NATIVE {AFF_68881}	CONST AFF_68881	= $10
NATIVE {AFF_68882}	CONST AFF_68882	= $20
NATIVE {AFF_FPU40}	CONST AFF_FPU40	= $40
NATIVE {AFF_68060}	CONST AFF_68060	= $80

NATIVE {AFF_PRIVATE}	CONST AFF_PRIVATE	= $8000

/* #define AFB_RESERVED8   8 */
/* #define AFB_RESERVED9   9 */


/****** Selected flag definitions for Cache manipulation calls **********/

NATIVE {CACRF_EnableI}	    CONST CACRF_ENABLEI	    = $1  /* Enable instruction cache */
NATIVE {CACRF_FreezeI}	    CONST CACRF_FREEZEI	    = $2  /* Freeze instruction cache */
NATIVE {CACRF_ClearI}	    CONST CACRF_CLEARI	    = $8  /* Clear instruction cache  */
NATIVE {CACRF_IBE}	    CONST CACRF_IBE	    = $10  /* Instruction burst enable */
NATIVE {CACRF_EnableD}	    CONST CACRF_ENABLED	    = $100  /* 68030 Enable data cache  */
NATIVE {CACRF_FreezeD}	    CONST CACRF_FREEZED	    = $200  /* 68030 Freeze data cache  */
NATIVE {CACRF_ClearD}	    CONST CACRF_CLEARD	    = $800 /* 68030 Clear data cache	 */
NATIVE {CACRF_DBE}	    CONST CACRF_DBE	    = $1000 /* 68030 Data burst enable */
NATIVE {CACRF_WriteAllocate} CONST CACRF_WRITEALLOCATE = $2000 /* 68030 Write-Allocate mode
					(must always be set!)	 */
NATIVE {CACRF_EnableE}	    CONST CACRF_ENABLEE	    = $40000000 /* Master enable for external caches */
				     /* External caches should track the */
				     /* state of the internal caches */
				     /* such that they do not cache anything */
				     /* that the internal cache turned off */
				     /* for. */
NATIVE {CACRF_CopyBack}	    CONST CACRF_COPYBACK	    = $80000000 /* Master enable for copyback caches */

NATIVE {DMA_Continue}	    CONST DMA_CONTINUE	    = $2  /* Continuation flag for CachePreDMA */
NATIVE {DMA_NoModify}	    CONST DMA_NOMODIFY	    = $4  /* Set if DMA does not update memory */
NATIVE {DMA_ReadFromRAM}     CONST DMA_READFROMRAM     = $8  /* Set if DMA goes *FROM* RAM to device */
