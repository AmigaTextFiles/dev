/* $Id: execbase.h 28407 2008-04-20 18:58:52Z schulz $ */
OPT NATIVE
MODULE 'target/exec/interrupts', 'target/exec/libraries', 'target/exec/lists', 'target/exec/tasks'
MODULE 'target/exec/types'
{#include <exec/execbase.h>}
NATIVE {EXEC_EXECBASE_H} CONST

/* Most fields are PRIVATE */
NATIVE {ExecBase} OBJECT execbase
/* Standard Library Structure */
    {LibNode}	lib	:lib

/* System Constants */
    {SoftVer}	softver	:UINT      /* OBSOLETE */
    {LowMemChkSum}	lowmemchksum	:INT
    {ChkBase}	chkbase	:IPTR
    {ColdCapture}	coldcapture	:APTR
    {CoolCapture}	coolcapture	:APTR
    {WarmCapture}	warmcapture	:APTR
    {SysStkUpper}	sysstkupper	:APTR  /* System Stack Bounds */
    {SysStkLower}	sysstklower	:APTR
    {MaxLocMem}	maxlocmem	:IPTR    /* Chip Memory Pointer */
    {DebugEntry}	debugentry	:APTR
    {DebugData}	debugdata	:APTR
    {AlertData}	alertdata	:APTR
    {MaxExtMem}	maxextmem	:APTR    /* Extended Memory Pointer (may be NULL) */
    {ChkSum}	chksum	:UINT       /* SoftVer to MaxExtMem */

/* Interrupts */
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

/* System Variables */
    {ThisTask}	thistask	:PTR TO tc       /* Pointer to currently running task
                                     (readable) */
    {IdleCount}	idlecount	:ULONG
    {DispCount}	dispcount	:ULONG
    {Quantum}	quantum	:UINT        /* # of ticks, a task may run */
    {Elapsed}	elapsed	:UINT        /* # of ticks, the current task has run */
    {SysFlags}	sysflags	:UINT
    {IDNestCnt}	idnestcnt	:BYTE
    {TDNestCnt}	tdnestcnt	:BYTE
    {AttnFlags}	attnflags	:UINT      /* Attention Flags (see below) (readable) */
    {AttnResched}	attnresched	:UINT
    {ResModules}	resmodules	:APTR
    {TaskTrapCode}	tasktrapcode	:APTR
    {TaskExceptCode}	taskexceptcode	:APTR
    {TaskExitCode}	taskexitcode	:APTR
    {TaskSigAlloc}	tasksigalloc	:ULONG
    {TaskTrapAlloc}	tasktrapalloc	:UINT

/* PRIVATE Lists */
    {MemList}	memlist	:lh
    {ResourceList}	resourcelist	:lh
    {DeviceList}	devicelist	:lh
    {IntrList}	intrlist	:lh
    {LibList}	liblist	:lh
    {PortList}	portlist	:lh
    {TaskReady}	taskready	:lh      /* Tasks that are ready to run */
    {TaskWait}	taskwait	:lh       /* Tasks that wait for some event */
    {SoftInts}	softints[5]	:ARRAY OF sh

/* Miscellaneous Stuff */
    {LastAlert}	lastalert[4]	:ARRAY OF SLONG

    {VBlankFrequency}	vblankfrequency	:UBYTE      /* (readable) */
    {PowerSupplyFrequency}	powersupplyfrequency	:UBYTE /* (readable) */
    	    	    	    	    	     /* AROS PRIVATE: VBlankFreq * PowerSupplyFreq = Timer Tick Rate */
    {SemaphoreList}	semaphorelist	:lh

/* Kickstart */
    {KickMemPtr}	kickmemptr	:APTR
    {KickTagPtr}	kicktagptr	:APTR
    {KickCheckSum}	kickchecksum	:APTR

/* Miscellaneous Stuff */
    {ex_Pad0}	pad0	:UINT            /* PRIVATE */
    {ex_LaunchPoint}	launchpoint	:IPTR     /* PRIVATE */
    {ex_RamLibPrivate}	ramlibprivate	:APTR
    {ex_EClockFrequency}	eclockfrequency	:ULONG /* (readable) */
    {ex_CacheControl}	cachecontrol	:ULONG    /* PRIVATE */
    {ex_TaskID}	taskid	:ULONG
    {ex_Reserved}	reserved1[5]	:ARRAY OF ULONG
    {ex_MMULock}	mmulock	:APTR         /* PRIVATE */
    {ex_Reserved2}	reserved2[3]	:ARRAY OF ULONG
    {ex_MemHandlers}	memhandlers	:mlh
    {ex_MemHandler}	memhandler	:APTR      /* PRIVATE */

/* Additional fields for AROS */
    {DebugAROSBase}	debugarosbase	:PTR TO lib
    {PlatformData}	platformdata	:PTR     /* different for all platforms */
ENDOBJECT

/* AttnFlags */
/* Processors */
NATIVE {AFB_68010}        CONST AFB_68010        = 0
NATIVE {AFF_68010}   CONST AFF_68010   = $1
NATIVE {AFB_68020}        CONST AFB_68020        = 1
NATIVE {AFF_68020}   CONST AFF_68020   = $2
NATIVE {AFB_68030}        CONST AFB_68030        = 2
NATIVE {AFF_68030}   CONST AFF_68030   = $4
NATIVE {AFB_68040}        CONST AFB_68040        = 3
NATIVE {AFF_68040}   CONST AFF_68040   = $8
/* Co-Processors */
NATIVE {AFB_68881}        CONST AFB_68881        = 4
NATIVE {AFF_68881}   CONST AFF_68881   = $10
NATIVE {AFB_68882}        CONST AFB_68882        = 5
NATIVE {AFF_68882}   CONST AFF_68882   = $20
NATIVE {AFB_FPU40}        CONST AFB_FPU40        = 6
NATIVE {AFF_FPU40}   CONST AFF_FPU40   = $40
NATIVE {AFB_PRIVATE}      CONST AFB_PRIVATE      = 15 /* PRIVATE */
NATIVE {AFF_PRIVATE} CONST AFF_PRIVATE = $8000

/* Cache */
NATIVE {CACRF_EnableI}       CONST CACRF_ENABLEI       = $1
NATIVE {CACRF_FreezeI}       CONST CACRF_FREEZEI       = $2
NATIVE {CACRF_ClearI}        CONST CACRF_CLEARI        = $8
NATIVE {CACRF_IBE}           CONST CACRF_IBE           = $10
NATIVE {CACRF_EnableD}       CONST CACRF_ENABLED       = $100
NATIVE {CACRF_FreezeD}       CONST CACRF_FREEZED       = $200
NATIVE {CACRF_ClearD}        CONST CACRF_CLEARD        = $800
NATIVE {CACRF_DBE}           CONST CACRF_DBE           = $1000
NATIVE {CACRF_WriteAllocate} CONST CACRF_WRITEALLOCATE = $2000
NATIVE {CACRF_InvalidateD}   CONST CACRF_INVALIDATED   = $8000
NATIVE {CACRF_EnableE}       CONST CACRF_ENABLEE       = $40000000
NATIVE {CACRF_CopyBack}      CONST CACRF_COPYBACK      = $80000000

/* DMA */
NATIVE {DMA_Continue}    CONST DMA_CONTINUE    = $2
NATIVE {DMA_NoModify}    CONST DMA_NOMODIFY    = $4
NATIVE {DMA_ReadFromRAM} CONST DMA_READFROMRAM = $8
