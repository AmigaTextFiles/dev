/* $Id: execbase.h,v 1.22 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/interrupts', 'target/exec/libraries', 'target/exec/interfaces', 'target/exec/tasks'
MODULE 'target/exec/types'
{#include <exec/execbase.h>}
NATIVE {EXEC_EXECBASE_H} CONST

/* Definition of the Exec library base structure (pointed to by location 4).
 * Most fields are not to be viewed or modified by user programs. Use
 * extreme caution.
 */

NATIVE {ExecBase} OBJECT execbase
    {LibNode}	lib	:lib /* Standard library node */

/******** Static System Variables ********/

    {SoftVer}	softver	:UINT        /* kickstart release number (obs.) */
    {LowMemChkSum}	lowmemchksum	:INT   /* checksum of 68000 trap vectors */
    {ChkBase}	chkbase	:ULONG        /* system base pointer complement */
    {ColdCapture}	coldcapture	:APTR    /* coldstart soft capture vector */
    {CoolCapture}	coolcapture	:APTR    /* coolstart soft capture vector */
    {WarmCapture}	warmcapture	:APTR    /* warmstart soft capture vector */
    {SysStkUpper}	sysstkupper	:APTR    /* system stack base   (upper bound) */
    {SysStkLower}	sysstklower	:APTR    /* top of system stack (lower bound) */
    {MaxLocMem}	maxlocmem	:ULONG      /* top of chip memory */
    {DebugEntry}	debugentry	:APTR     /* global debugger entry point */
    {DebugData}	debugdata	:APTR      /* global debugger data segment */
    {AlertData}	alertdata	:APTR      /* alert data segment */
    {MaxExtMem}	maxextmem	:APTR      /* top of extended mem, or null if none */

    {ChkSum}	chksum	:UINT         /* for all of the above (minus 2) */

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

    {ThisTask}	thistask	:PTR TO tc  /* pointer to current task (readable) */

    {IdleCount}	idlecount	:ULONG      /* idle counter */
    {DispCount}	dispcount	:ULONG      /* dispatch counter */
    {Quantum}	quantum	:UINT        /* time slice quantum */
    {Elapsed}	elapsed	:UINT        /* current quantum ticks */
    {SysFlags}	sysflags	:UINT       /* misc internal system flags */
    {IDNestCnt}	idnestcnt	:BYTE      /* interrupt disable nesting count */
    {TDNestCnt}	tdnestcnt	:BYTE      /* task disable nesting count */

    {AttnFlags}	attnflags	:UINT      /* special attention flags (readable) */

    {AttnResched}	attnresched	:UINT    /* rescheduling attention */
    {ResModules}	resmodules	:APTR     /* resident module array pointer */
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
       system developers to have a rough idea of the
       period of two externally controlled signals --
       the time between vertical blank interrupts and the
       external line rate (which is counted by CIA A's
       "time of day" clock).  In general these values
       will be 50 or 60, and may or may not track each
       other.  These values replace the obsolete AFB_PAL
       and AFB_50HZ flags. */
    {VBlankFrequency}	vblankfrequency	:UBYTE      /* (readable) */
    {PowerSupplyFrequency}	powersupplyfrequency	:UBYTE /* (readable) */

    {SemaphoreList}	semaphorelist	:lh

    /* these next two are to be able to kickstart into user ram.
       KickMemPtr holds a singly linked list of MemLists which
       will be removed from the memory list via AllocAbs.  If
       all the AllocAbs's succeeded, then the KickTagPtr will
       be added to the rom tag list. */
    {KickMemPtr}	kickmemptr	:APTR     /* ptr to queue of mem lists */
    {KickTagPtr}	kicktagptr	:APTR     /* ptr to rom tag queue */
    {KickCheckSum}	kickchecksum	:APTR   /* checksum for mem and tags */

/****** V36 Exec additions start here **************************************/

    {ex_Pad0}	pad0	:UINT        /* Private internal use */
    {ex_LaunchPoint}	launchpoint	:ULONG /* Private to Launch/Switch */
    {ex_RamLibPrivate}	ramlibprivate	:APTR

    /* The next ULONG contains the system "E" clock frequency,
       expressed in Hertz.  The E clock is used as a timebase for
       the Amiga's 8520 I/O chips. (E is connected to "02").
       Typical values are 715909 for NTSC, or 709379 for PAL. */
    {ex_EClockFrequency}	eclockfrequency	:ULONG /* (readable) */
    {ex_CacheControl}	cachecontrol	:ULONG    /* Private to CacheControl calls */
    {ex_TaskID}	taskid	:ULONG          /* Next available task ID */

    {ex_Reserved1}	reserved1[5]	:ARRAY OF ULONG

    {ex_MMULock}	mmulock	:APTR         /* private */

    {ex_Reserved2}	reserved2[3]	:ARRAY OF ULONG

/****** V39 Exec additions start here **************************************/

    /* The following list and data element are used
       for V39 exec's low memory handler... */
    {ex_MemHandlers}	memhandlers	:mlh /* The handler list */
    {ex_MemHandler}	memhandler	:APTR  /* Private! handler pointer */

/****** V50 Exec additions start here **************************************/
    {MainInterface}	maininterface	:PTR TO interface /* ExecLibrary's primary interface */
    {Private01}	private01	:APTR
    {Private02}	private02	:ULONG
    {Private03}	private03	:APTR
    {Private04}	private04	:APTR
    {Private05}	private05	:APTR
    {Private06}	private06	:lh
    {Private07}	private07	:APTR
    {EmuWS}	emuws	:APTR          /* Emulator Workspace. Legacy libraries might 
                               access this field */

/* Yes, there are more additions, but you don't need to know what it is */
ENDOBJECT

/****** Bit defines for AttnFlags (see above) ******************************/

/*  Processors and Co-processors: */
NATIVE {enAttnFlagBits} DEF
NATIVE {AFB_68010}   CONST AFB_68010   = 0 /* also set for 68020 */
NATIVE {AFB_68020}   CONST AFB_68020   = 1 /* also set for 68030 */
NATIVE {AFB_68030}   CONST AFB_68030   = 2 /* also set for 68040 */
NATIVE {AFB_68040}   CONST AFB_68040   = 3 /* also set for 68060 */
NATIVE {AFB_68881}   CONST AFB_68881   = 4 /* also set for 68882 */
NATIVE {AFB_68882}   CONST AFB_68882   = 5
NATIVE {AFB_FPU40}   CONST AFB_FPU40   = 6 /* Set if 68040 FPU */
NATIVE {AFB_68060}   CONST AFB_68060   = 7

NATIVE {AFB_603}     CONST AFB_603     = 8
NATIVE {AFB_604}     CONST AFB_604     = 9
NATIVE {AFB_750}     CONST AFB_750     = 10
NATIVE {AFB_7400}    CONST AFB_7400    = 11
NATIVE {AFB_ALTIVEC} CONST AFB_ALTIVEC = 12
NATIVE {AFB_4XX}     CONST AFB_4XX     = 13

NATIVE {AFB_PRIVATE} CONST AFB_PRIVATE = 15 /* Just what it says */


NATIVE {enAttnFlags} DEF
NATIVE {AFF_68010}   CONST AFF_68010   = $1
NATIVE {AFF_68020}   CONST AFF_68020   = $2
NATIVE {AFF_68030}   CONST AFF_68030   = $4
NATIVE {AFF_68040}   CONST AFF_68040   = $8
NATIVE {AFF_68881}   CONST AFF_68881   = $10
NATIVE {AFF_68882}   CONST AFF_68882   = $20
NATIVE {AFF_FPU40}   CONST AFF_FPU40   = $40
NATIVE {AFF_68060}   CONST AFF_68060   = $80

NATIVE {AFF_603}     CONST AFF_603     = $100
NATIVE {AFF_604}     CONST AFF_604     = $200
NATIVE {AFF_750}     CONST AFF_750     = $400
NATIVE {AFF_7400}    CONST AFF_7400    = $800
NATIVE {AFF_ALTIVEC} CONST AFF_ALTIVEC = $1000
NATIVE {AFF_4XX}     CONST AFF_4XX     = $2000

NATIVE {AFF_PRIVATE} CONST AFF_PRIVATE = $8000


/****** Selected flag definitions for Cache manipulation calls **********/
NATIVE {CACRF_EnableI}       CONST CACRF_ENABLEI       = $1 /* Enable instruction cache */
NATIVE {CACRF_FreezeI}       CONST CACRF_FREEZEI       = $2 /* Freeze instruction cache */
NATIVE {CACRF_ClearI}        CONST CACRF_CLEARI        = $8 /* Clear instruction cache  */
NATIVE {CACRF_IBE}           CONST CACRF_IBE           = $10 /* Instruction burst enable */
NATIVE {CACRF_EnableD}       CONST CACRF_ENABLED       = $100 /* Enable data cache  */
NATIVE {CACRF_FreezeD}       CONST CACRF_FREEZED       = $200 /* Freeze data cache  */
NATIVE {CACRF_ClearD}        CONST CACRF_CLEARD        = $800 /* Clear data cache
                                         (flush to memory first) */
NATIVE {CACRF_DBE}           CONST CACRF_DBE           = $1000 /* 68030 Data burst enable */
NATIVE {CACRF_WriteAllocate} CONST CACRF_WRITEALLOCATE = $2000 /* 68030 Write-Allocate mode
                                         (must always be set!) */
NATIVE {CACRF_InvalidateD}   CONST CACRF_INVALIDATED   = $8000 /* Invalidate data cache (no writeback) */
NATIVE {CACRF_EnableE}       CONST CACRF_ENABLEE       = $40000000 /* Master enable for external caches.
                                         External caches should track the
                                         state of the internal caches
                                         such that they do not cache anything
                                         that the internal cache turned off
                                         for. */
NATIVE {CACRF_CopyBack}      CONST CACRF_COPYBACK      = $80000000 /* Master enable for copyback caches */

NATIVE {enDMAFlags} DEF
NATIVE {DMA_Continue}     CONST DMA_CONTINUE     = $2      /* Continuation flag for CachePreDMA */
NATIVE {DMAF_Continue}    CONST DMAF_CONTINUE    = DMA_CONTINUE 
NATIVE {DMA_NoModify}     CONST DMA_NOMODIFY     = $4      /* Set if DMA does not update memory */
NATIVE {DMAF_NoModify}    CONST DMAF_NOMODIFY    = DMA_NOMODIFY
NATIVE {DMA_ReadFromRAM}  CONST DMA_READFROMRAM  = $8      /* Set if DMA goes *FROM* RAM to device */
NATIVE {DMAF_ReadFromRAM} CONST DMAF_READFROMRAM = DMA_READFROMRAM


/****************************************************************************/

/* The only fixed address in the Amiga memory space. */
NATIVE {AbsExecBase} DEF
