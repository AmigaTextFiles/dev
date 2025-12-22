/* $Id: performancemonitor.h,v 1.7 2005/09/24 15:10:37 dwuerkner Exp $ */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <resources/performancemonitor.h>}
NATIVE {_RESOURCES_PERFORMANCEMONITOR_H} DEF

/* Event items that can be counted by Performance Monitor counters */
NATIVE {enPerformanceMonitorItems} DEF
NATIVE {PMCI_Hold}           CONST PMCI_HOLD           = 0 /* Hold current value (disable counter) */
NATIVE {PMCI_CPUCycles}      CONST PMCI_CPUCYCLES      = 1 /* Number of CPU cycles */
NATIVE {PMCI_Instr}          CONST PMCI_INSTR          = 2 /* Number of CPU finished instructions */
NATIVE {PMCI_FPUInstr}       CONST PMCI_FPUINSTR       = 3 /* Number of instructions completed by FPU */
NATIVE {PMCI_Transition}     CONST PMCI_TRANSITION     = 4 /* Number of transitions of RTC bit from 0 to 1
                                */
NATIVE {PMCI_InstrDisp}      CONST PMCI_INSTRDISP      = 5 /* Number of CPU instructions dispatched */
NATIVE {PMCI_EIEIO}          CONST PMCI_EIEIO          = 6 /* Number of eieio instructions completed */
NATIVE {PMCI_SYNC}           CONST PMCI_SYNC           = 7 /* Number of sync instructions completed */
NATIVE {PMCI_L1DCacheHits}   CONST PMCI_L1DCACHEHITS   = 8 /* Number of L1 data cache hits */
NATIVE {PMCI_L1ICacheHits}   CONST PMCI_L1ICACHEHITS   = 9 /* Number of L1 instruction cache hits */
NATIVE {PMCI_L2DCacheHits}   CONST PMCI_L2DCACHEHITS   = 10 /* Number of L2 data cache hits */
NATIVE {PMCI_L2ICacheHits}   CONST PMCI_L2ICACHEHITS   = 11 /* Number of L2 instruction cache hits */
NATIVE {PMCI_L1DCacheMiss}   CONST PMCI_L1DCACHEMISS   = 12 /* Number of L1 data cache misses */
NATIVE {PMCI_L1ICacheMiss}   CONST PMCI_L1ICACHEMISS   = 13 /* Number of L1 instruction cache misses */
NATIVE {PMCI_L2DCacheMiss}   CONST PMCI_L2DCACHEMISS   = 14 /* Number of L2 data cache misses */
NATIVE {PMCI_L2ICacheMiss}   CONST PMCI_L2ICACHEMISS   = 15 /* Number of L2 instruction cache misses */
NATIVE {PMCI_L2Hits}         CONST PMCI_L2HITS         = 16 /* Number of hits in L2 cache */
NATIVE {PMCI_L1LoadThresh}   CONST PMCI_L1LOADTHRESH   = 17 /* Number of L1 loads that exceed the threshold
                                */
NATIVE {PMCI_ValidEA}        CONST PMCI_VALIDEA        = 18 /* Number of valid virtual addresses delivered
                                  to the memory subsystem */
NATIVE {PMCI_UnresolvedBra}  CONST PMCI_UNRESOLVEDBRA  = 19 /* Number of unresolved branches */
NATIVE {PMCI_InstrBreak}     CONST PMCI_INSTRBREAK     = 20 /* Number of times an executed instruction's
                                  address matches the IABR */
NATIVE {PMCI_DataBreak}      CONST PMCI_DATABREAK      = 21 /* Number of times a generated virtual address
                                  matches the DABR */
NATIVE {PMCI_NumItems}       CONST PMCI_NUMITEMS       = 22 
NATIVE {PMCI_INVALID}        CONST PMCI_INVALID        = $8000



/* Tag items for EventControl */
NATIVE {PMECT_Disable}        CONST PMECT_DISABLE        = (TAG_USER + 1) /* Disable event generation */
NATIVE {PMECT_Enable}         CONST PMECT_ENABLE         = (TAG_USER + 2) /* Enable even generation   */

/* Tag items for MonitorControl */
NATIVE {PMMCT_FreezeCounters} CONST PMMCT_FREEZECOUNTERS = (TAG_USER + 1) /* Define freeze count conditions
                                             */
NATIVE {PMMCT_RTCBitSelect}   CONST PMMCT_RTCBITSELECT   = (TAG_USER + 3) /* Select bit for sampling */
NATIVE {PMMCT_Threshold}      CONST PMMCT_THRESHOLD      = (TAG_USER + 4) /* Define threshold for events */
NATIVE {PMMCT_GetThreshold}   CONST PMMCT_GETTHRESHOLD   = (TAG_USER + 5) /* Get the currently active
                                               threshold */
NATIVE {PMMCT_Trigger}        CONST PMMCT_TRIGGER        = (TAG_USER + 6) /* Put Performance Monitor into
                                               triggered mode */


/* Values for PMMCT_Count[Enable|Disable] */
NATIVE {enPerformanceMonitorCountControl} DEF
NATIVE {PMMC_Always}   CONST PMMC_ALWAYS   = $01 /* Always freeze */
NATIVE {PMMC_Super}    CONST PMMC_SUPER    = $02 /* Freeze in supervisor mode */
NATIVE {PMMC_User}     CONST PMMC_USER     = $04 /* Freeze in user mode */
NATIVE {PMMC_Marked}   CONST PMMC_MARKED   = $08 /* Freeze if marked */
NATIVE {PMMC_Unmarked} CONST PMMC_UNMARKED = $10  /* Freeze if not marked */


/* Values for PMMCT_RTCBitSelect */
NATIVE {enPerformanceMonitorRTCBitSelect} DEF
NATIVE {PMMC_BIT0}  CONST PMMC_BIT0  = 0 /* Pick bit 0 (i.e. the least significant bit) */
NATIVE {PMMC_BIT8}  CONST PMMC_BIT8  = 1 /* Pick bit 8 */
NATIVE {PMMC_BIT12} CONST PMMC_BIT12 = 2 /* Pick bit 12 */
NATIVE {PMMC_BIT16} CONST PMMC_BIT16 = 3  /* Pick bit 16 */



/* Query items for Query() */
NATIVE {enPerformanceMonitorQueryItems} DEF
NATIVE {PMQI_NumCounters}    CONST PMQI_NUMCOUNTERS    = 1 /* Number of counters available */
NATIVE {PMQI_IBreakPoint}    CONST PMQI_IBREAKPOINT    = 2 /* A boolean value determining whether an
                                instruction breakpoint register is available
                                or not. */
NATIVE {PMQI_BreakPointMask} CONST PMQI_BREAKPOINTMASK = 3  /* A boolean value determining whether masking for
                                instruction or data breakpoints is available */


/* Predefined interrupt vectors */
NATIVE {PMIV_RTCEvent} CONST PMIV_RTCEVENT = $80000001 /* Clock interrupt */
NATIVE {PMIV_Monitor}  CONST PMIV_MONITOR  = $80000002 /* General monitor interrupt */

/* Values for SetBreakpoint */
NATIVE {enPerformanceMonitorBreakpointTypes} DEF
NATIVE {PMBP_Data} CONST PMBP_DATA = 0
NATIVE {PMBP_Inst} CONST PMBP_INST = 1



/* Values for EventControl */
NATIVE {enPerformanceMonitorEventControlItems} DEF
NATIVE {PMEC_Timer}           CONST PMEC_TIMER           = $8001
NATIVE {PMEC_MasterInterrupt} CONST PMEC_MASTERINTERRUPT = $8002


/* Tag items for EventControl */
->NATIVE {PMECT_Disable} CONST PMECT_DISABLE = (TAG_USER + 1)
->NATIVE {PMECT_Enable}  CONST PMECT_ENABLE  = (TAG_USER + 2)
