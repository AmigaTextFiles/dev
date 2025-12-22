@DATABASE "gg:doc/NDK/Guide/Include/exec/execbase.h"
@MASTER   "gg:os-include/exec/execbase.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/execbase.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/execbase.h" LINK File}


@{b}Structures@{ub}

@{"ExecBase" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 34}


@{b}#defines@{ub}

@{"AFB_68010" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 157}            @{"AFB_68020" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 158}      @{"AFB_68030" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 159}      @{"AFB_68040" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 160}
@{"AFB_68060" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 164}            @{"AFB_68881" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 161}      @{"AFB_68882" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 162}      @{"AFB_FPU40" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 163}
@{"AFB_PRIVATE" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 174}          @{"AFF_68010" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 176}      @{"AFF_68020" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 177}      @{"AFF_68030" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 178}
@{"AFF_68040" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 179}            @{"AFF_68060" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 183}      @{"AFF_68881" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 180}      @{"AFF_68882" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 181}
@{"AFF_FPU40" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 182}            @{"AFF_PRIVATE" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 185}    @{"CACRF_ClearD" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 199}   @{"CACRF_ClearI" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 195}
@{"CACRF_CopyBack" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 209}       @{"CACRF_DBE" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 200}      @{"CACRF_EnableD" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 197}  @{"CACRF_EnableE" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 203}
@{"CACRF_EnableI" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 193}        @{"CACRF_FreezeD" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 198}  @{"CACRF_FreezeI" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 194}  @{"CACRF_IBE" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 196}
@{"CACRF_WriteAllocate" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 201}  @{"DMA_Continue" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 211}   @{"DMA_NoModify" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 212}   @{"DMA_ReadFromRAM" LINK "gg:doc/NDK/Guide/Include/exec/execbase.h/File" 213}

@ENDNODE
@NODE File "exec/execbase.h"
#ifndef EXEC_EXECBASE_H
#define EXEC_EXECBASE_H
/*
**      $VER: execbase.h 39.6 (18.1.1993)
**      Includes Release 45.1
**
**      Definition of the @{"exec.library" LINK "gg:doc/NDK/Guide/exec/MAIN"} base structure.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif /* EXEC_LISTS_H */

#ifndef EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif /* EXEC_INTERRUPTS_H */

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif /* EXEC_LIBRARIES_H */

#ifndef EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif /* EXEC_TASKS_H */


/* Definition of the Exec library base structure (pointed to by location 4).
** Most fields are not to be viewed or modified by user programs.  Use
** extreme caution.
*/
struct ExecBase {
        @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} LibNode; /* Standard library node */

/******** Static System Variables ********/

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   SoftVer;        /* kickstart release number (obs.) */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    LowMemChkSum;   /* checksum of 68000 trap vectors */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ChkBase;        /* system base pointer complement */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ColdCapture;    /* coldstart soft capture vector */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    CoolCapture;    /* coolstart soft capture vector */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    WarmCapture;    /* warmstart soft capture vector */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    SysStkUpper;    /* system stack base   (upper bound) */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    SysStkLower;    /* top of system stack (lower bound) */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   MaxLocMem;      /* top of chip memory */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    DebugEntry;     /* global debugger entry point */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    DebugData;      /* global debugger data segment */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    AlertData;      /* alert data segment */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    MaxExtMem;      /* top of extended mem, or null if none */

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ChkSum; /* for all of the above (minus 2) */

/****** Interrupt Related ***************************************/

        @{"struct  IntVector" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 29} IntVects[16];

/****** Dynamic System Variables *************************************/

        @{"struct  Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *ThisTask; /* pointer to current task (readable) */

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   IdleCount;      /* idle counter */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   DispCount;      /* dispatch counter */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Quantum;        /* time slice quantum */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Elapsed;        /* current quantum ticks */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   SysFlags;       /* misc internal system flags */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    IDNestCnt;      /* interrupt disable nesting count */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    TDNestCnt;      /* task disable nesting count */

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   AttnFlags;      /* special attention flags (readable) */

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   AttnResched;    /* rescheduling attention */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ResModules;     /* resident module array pointer */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    TaskTrapCode;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    TaskExceptCode;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    TaskExitCode;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   TaskSigAlloc;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   TaskTrapAlloc;


/****** System Lists (private!) ********************************/

        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} MemList;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} ResourceList;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} DeviceList;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} IntrList;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} LibList;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} PortList;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} TaskReady;
        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} TaskWait;

        @{"struct  SoftIntList" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 36} SoftInts[5];

/****** Other Globals *******************************************/

        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    LastAlert[4];

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
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   VBlankFrequency;        /* (readable) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   PowerSupplyFrequency;   /* (readable) */

        @{"struct  List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} SemaphoreList;

        /* these next two are to be able to kickstart into user ram.
        ** KickMemPtr holds a singly linked list of MemLists which
        ** will be removed from the memory list via @{"AllocAbs" LINK "gg:doc/NDK/Guide/exec/AllocAbs"}.  If
        ** all the @{"AllocAbs" LINK "gg:doc/NDK/Guide/exec/AllocAbs"}'s succeeded, then the KickTagPtr will
        ** be added to the rom tag list.
        */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    KickMemPtr;     /* ptr to queue of mem lists */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    KickTagPtr;     /* ptr to rom tag queue */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    KickCheckSum;   /* checksum for mem and tags */

/****** V36 Exec additions start here **************************************/

        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ex_Pad0;                /* Private internal use */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ex_LaunchPoint;         /* Private to Launch/Switch */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ex_RamLibPrivate;
        /* The next @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} contains the system "E" clock frequency,
        ** expressed in Hertz.  The E clock is used as a timebase for
        ** the Amiga's 8520 I/O chips. (E is connected to "02").
        ** Typical values are 715909 for @{"NTSC" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 138}, or 709379 for @{"PAL" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 140}.
        */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ex_EClockFrequency;     /* (readable) */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ex_CacheControl;        /* Private to @{"CacheControl" LINK "gg:doc/NDK/Guide/exec/CacheControl"} calls */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ex_TaskID;              /* Next available task ID */

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ex_Reserved1[5];

        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ex_MMULock;             /* private */

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ex_Reserved2[3];

/****** V39 Exec additions start here **************************************/

        /* The following list and data element are used
         * for V39 exec's low memory handler...
         */
        @{"struct  MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} ex_MemHandlers; /* The handler list */
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    ex_MemHandler;          /* Private! handler pointer */
};


/****** Bit defines for AttnFlags (see above) ******************************/

/*  Processors and Co-processors: */
#define AFB_68010       0       /* also set for 68020 */
#define AFB_68020       1       /* also set for 68030 */
#define AFB_68030       2       /* also set for 68040 */
#define AFB_68040       3       /* also set for 68060 */
#define AFB_68881       4       /* also set for 68882 */
#define AFB_68882       5
#define AFB_FPU40       6       /* Set if 68040 FPU */
#define AFB_68060       7
/*
 * The @{"AFB_FPU40" LINK File 163} bit is set when a working 68040 FPU
 * is in the system.  If this bit is set and both the
 * @{"AFB_68881" LINK File 161} and @{"AFB_68882" LINK File 162} bits are not set, then the 68040
 * math emulation code has not been loaded and only 68040
 * FPU instructions are available.  This bit is valid *ONLY*
 * if the @{"AFB_68040" LINK File 160} bit is set.
 */

#define AFB_PRIVATE     15      /* Just what it says */

#define AFF_68010       (1L<<0)
#define AFF_68020       (1L<<1)
#define AFF_68030       (1L<<2)
#define AFF_68040       (1L<<3)
#define AFF_68881       (1L<<4)
#define AFF_68882       (1L<<5)
#define AFF_FPU40       (1L<<6)
#define AFF_68060       (1L<<7)

#define AFF_PRIVATE     (1L<<15)

/* #define AFB_RESERVED8   8 */
/* #define AFB_RESERVED9   9 */


/****** Selected flag definitions for Cache manipulation calls **********/

#define CACRF_EnableI       (1L<<0)  /* Enable instruction cache */
#define CACRF_FreezeI       (1L<<1)  /* Freeze instruction cache */
#define CACRF_ClearI        (1L<<3)  /* Clear instruction cache  */
#define CACRF_IBE           (1L<<4)  /* Instruction burst enable */
#define CACRF_EnableD       (1L<<8)  /* 68030 Enable data cache  */
#define CACRF_FreezeD       (1L<<9)  /* 68030 Freeze data cache  */
#define CACRF_ClearD        (1L<<11) /* 68030 Clear data cache   */
#define CACRF_DBE           (1L<<12) /* 68030 Data burst enable */
#define CACRF_WriteAllocate (1L<<13) /* 68030 Write-Allocate mode
                                        (must always be set!)    */
#define CACRF_EnableE       (1L<<30) /* Master enable for external caches */
                                     /* External caches should track the */
                                     /* state of the internal caches */
                                     /* such that they do not cache anything */
                                     /* that the internal cache turned off */
                                     /* for. */
#define CACRF_CopyBack      (1L<<31) /* Master enable for copyback caches */

#define DMA_Continue        (1L<<1)  /* Continuation flag for @{"CachePreDMA" LINK "gg:doc/NDK/Guide/exec/CachePreDMA"} */
#define DMA_NoModify        (1L<<2)  /* Set if DMA does not update memory */
#define DMA_ReadFromRAM     (1L<<3)  /* Set if DMA goes *FROM* RAM to device */


#endif  /* EXEC_EXECBASE_H */
@ENDNODE
