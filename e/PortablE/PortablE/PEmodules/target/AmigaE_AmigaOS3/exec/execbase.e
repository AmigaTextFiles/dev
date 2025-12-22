/* $VER: execbase.h 39.6 (18.1.1993) */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/interrupts', 'target/exec/libraries', 'target/exec/tasks'
MODULE 'target/exec/types'
{MODULE 'exec/execbase'}

NATIVE {execbase} OBJECT execbase
	{lib}	lib	:lib /* Standard library node */

/******** Static System Variables ********/

	{softver}	softver	:UINT	/* kickstart release number (obs.) */
	{lowmemchksum}	lowmemchksum	:INT	/* checksum of 68000 trap vectors */
	{chkbase}	chkbase	:ULONG	/* system base pointer complement */
	{coldcapture}	coldcapture	:APTR	/* coldstart soft capture vector */
	{coolcapture}	coolcapture	:APTR	/* coolstart soft capture vector */
	{warmcapture}	warmcapture	:APTR	/* warmstart soft capture vector */
	{sysstkupper}	sysstkupper	:APTR	/* system stack base   (upper bound) */
	{sysstklower}	sysstklower	:APTR	/* top of system stack (lower bound) */
	{maxlocmem}	maxlocmem	:ULONG	/* top of chip memory */
	{debugentry}	debugentry	:APTR	/* global debugger entry point */
	{debugdata}	debugdata	:APTR	/* global debugger data segment */
	{alertdata}	alertdata	:APTR	/* alert data segment */
	{maxextmem}	maxextmem	:APTR	/* top of extended mem, or null if none */

	{chksum}	chksum	:UINT	/* for all of the above (minus 2) */

/****** Interrupt Related ***************************************/

	{ivtbe}     ivtbe    :iv
	{ivdskblk}  ivdskblk :iv
	{ivsoftint} ivsoftint:iv
	{ivports}   ivports  :iv
	{ivcoper}   ivcoper  :iv
	{ivvertb}   ivvertb  :iv
	{ivblit}    ivblit   :iv
	{ivaud0}    ivaud0   :iv
	{ivaud1}    ivaud1   :iv
	{ivaud2}    ivaud2   :iv
	{ivaud3}    ivaud3   :iv
	{ivrbf}     ivrbf    :iv
	{ivdsksync} ivdsksync:iv
	{ivexter}   ivexter  :iv
	{ivinten}   ivinten  :iv
	{ivnmi}     ivnmi    :iv

/****** Dynamic System Variables *************************************/

	{thistask}	thistask	:PTR TO tc /* pointer to current task (readable) */

	{idlecount}	idlecount	:ULONG	/* idle counter */
	{dispcount}	dispcount	:ULONG	/* dispatch counter */
	{quantum}	quantum	:UINT	/* time slice quantum */
	{elapsed}	elapsed	:UINT	/* current quantum ticks */
	{sysflags}	sysflags	:UINT	/* misc internal system flags */
	{idnestcnt}	idnestcnt	:BYTE	/* interrupt disable nesting count */
	{tdnestcnt}	tdnestcnt	:BYTE	/* task disable nesting count */

	{attnflags}	attnflags	:UINT	/* special attention flags (readable) */

	{attnresched}	attnresched	:UINT	/* rescheduling attention */
	{resmodules}	resmodules	:APTR	/* resident module array pointer */
	{tasktrapcode}	tasktrapcode	:APTR
	{taskexceptcode}	taskexceptcode	:APTR
	{taskexitcode}	taskexitcode	:APTR
	{tasksigalloc}	tasksigalloc	:ULONG
	{tasktrapalloc}	tasktrapalloc	:UINT


/****** System Lists (private!) ********************************/

	{memlist}	memlist	:lh
	{resourcelist}	resourcelist	:lh
	{devicelist}	devicelist	:lh
	{intrlist}	intrlist	:lh
	{liblist}	liblist	:lh
	{portlist}	portlist	:lh
	{taskready}	taskready	:lh
	{taskwait}	taskwait	:lh

	{softints}	softints[5]	:ARRAY OF sh

/****** Other Globals *******************************************/

	{lastalert}	lastalert[4]	:ARRAY OF VALUE

	{vblankfrequency}	vblankfrequency	:UBYTE	/* (readable) */
	{powersupplyfrequency}	powersupplyfrequency	:UBYTE	/* (readable) */

	{semaphorelist}	semaphorelist	:lh

	{kickmemptr}	kickmemptr	:APTR	/* ptr to queue of mem lists */
	{kicktagptr}	kicktagptr	:APTR	/* ptr to rom tag queue */
	{kickchecksum}	kickchecksum	:APTR	/* checksum for mem and tags */

/****** V36 Exec additions start here **************************************/

	{pad0}	pad0	:UINT		/* Private internal use */
	{launchpoint}	launchpoint	:ULONG		/* Private to Launch/Switch */
	{ramlibprivate}	ramlibprivate	:APTR
	{eclockfrequency}	eclockfrequency	:ULONG	/* (readable) */
	{cachecontrol}	cachecontrol	:ULONG	/* Private to CacheControl calls */
	{taskid}	taskid	:ULONG		/* Next available task ID */

	{reserved1}	reserved1[5]	:ARRAY OF ULONG

	{mmulock}	mmulock	:APTR		/* private */

	{reserved2}	reserved2[3]	:ARRAY OF ULONG

/****** V39 Exec additions start here **************************************/

	{memhandlers}	memhandlers	:mlh	/* The handler list */
	{memhandler}	memhandler	:APTR		/* Private! handler pointer */
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

NATIVE {CACRF_ENABLEI}	    CONST CACRF_ENABLEI	    = $1  /* Enable instruction cache */
NATIVE {CACRF_FREEZEI}	    CONST CACRF_FREEZEI	    = $2  /* Freeze instruction cache */
NATIVE {CACRF_CLEARI}	    CONST CACRF_CLEARI	    = $8  /* Clear instruction cache  */
NATIVE {CACRF_IBE}	    CONST CACRF_IBE	    = $10  /* Instruction burst enable */
NATIVE {CACRF_ENABLED}	    CONST CACRF_ENABLED	    = $100  /* 68030 Enable data cache  */
NATIVE {CACRF_FREEZED}	    CONST CACRF_FREEZED	    = $200  /* 68030 Freeze data cache  */
NATIVE {CACRF_CLEARD}	    CONST CACRF_CLEARD	    = $800 /* 68030 Clear data cache	 */
NATIVE {CACRF_DBE}	    CONST CACRF_DBE	    = $1000 /* 68030 Data burst enable */
NATIVE {CACRF_WRITEALLOCATE} CONST CACRF_WRITEALLOCATE = $2000 /* 68030 Write-Allocate mode
					(must always be set!)	 */
NATIVE {CACRF_ENABLEE}	    CONST CACRF_ENABLEE	    = $40000000 /* Master enable for external caches */
				     /* External caches should track the */
				     /* state of the internal caches */
				     /* such that they do not cache anything */
				     /* that the internal cache turned off */
				     /* for. */
NATIVE {CACRF_COPYBACK}	    CONST CACRF_COPYBACK	    = $80000000 /* Master enable for copyback caches */

NATIVE {DMA_CONTINUE}	    CONST DMA_CONTINUE	    = $2  /* Continuation flag for CachePreDMA */
NATIVE {DMA_NOMODIFY}	    CONST DMA_NOMODIFY	    = $4  /* Set if DMA does not update memory */
NATIVE {DMA_READFROMRAM}     CONST DMA_READFROMRAM     = $8  /* Set if DMA goes *FROM* RAM to device */
