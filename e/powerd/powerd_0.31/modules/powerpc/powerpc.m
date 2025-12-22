MODULE  'exec/libraries'

#define POWERPCNAME 'powerpc.library'

OBJECT PPCBase
  LibNode:Library,
  SysLib:APTR,
  DosLib:APTR,
  SegList:APTR,
  NearBase:APTR,
  Flags:UBYTE,
  DosVer:UBYTE

/* tagitem values for GetHALInfo (V14+) */
#define HINFO_TAGS             (TAG_USER+$103000)
#define HINFO_ALEXC_HIGH       (HINFO_TAGS+0)     /* High word of emulated
                                                    alignment exceptions */
#define HINFO_ALEXC_LOW        (HINFO_TAGS+1)     /* Low word of ... */
/* tagitem values for SetScheduling (V14+) */
#define SCHED_TAGS             (TAG_USER+$104000)
#define SCHED_REACTION         (SCHED_TAGS+0)     /* reaction of low activity tasks */
/* tagitem values for GetInfo */
#define GETINFO_TAGS     (TAG_USER+$102000)
#define GETINFO_CPU      (GETINFO_TAGS+0)   /* CPU type (see below) */
#define GETINFO_PVR      (GETINFO_TAGS+1)   /* PVR type (see below) */
#define GETINFO_ICACHE   (GETINFO_TAGS+2)   /* Instruction cache state */
#define GETINFO_DCACHE   (GETINFO_TAGS+3)   /* Data cache state */
#define GETINFO_PAGETABLE  (GETINFO_TAGS+4)   /* Page table location */
#define GETINFO_TABLESIZE  (GETINFO_TAGS+5)   /* Page table size */
#define GETINFO_BUSCLOCK  (GETINFO_TAGS+6)    /* PPC bus clock */
#define GETINFO_CPUCLOCK  (GETINFO_TAGS+7)    /* PPC CPU clock */
#define GETINFO_CPULOAD  (GETINFO_TAGS+8)   /* Total CPU usage */
#define GETINFO_SYSTEMLOAD  (GETINFO_TAGS+9)  /* Total system usage */
/* PPCINFO_ICACHE / PPCINFO_DCACHE */

FLAG CACHE_ON_UNLOCKED=0,
 CACHE_ON_LOCKED=1,
 CACHE_OFF_UNLOCKED=2,
 CACHE_OFF_LOCKED=3

FLAG CPU_603=4,
 CPU_603E=8,
 CPU_604=12,
 CPU_604E=16,
 CPU_620=20,
 CPU_G3=21,  /* added by DMX */
 CPU_G4=22,  /* added by DMX */
 CPU_G5=23  /* added by DMX */

OBJECT PPCArgs
  Code:APTR,           /* Code Entry / Basevariable (OS Callback) */
  Offset:LONG,        /* Offset into Library-Jumptable (OS Callback) */
  Flags:ULONG,        /* see below */
  Stack:APTR,          /* Pointer to first argument to be copied or NULL */
  StackSize:ULONG,    /* Size of stack area to be copied or 0 */
  Regs[15]:ULONG,     /* Registervalues to be transferred */
  FRegs[8]:DOUBLE     /* FPU Registervalues to be transferred */

/* PP_Flags */
CONST PPF_ASYNC=(1<<0),   /* call PPC/68K asynchron */
 PPF_LINEAR=(1<<1),   /* pass r3-r10/f1-f8 (V15+) */
 PPF_THROW=(1<<2)   /* throw exception before entering function */
/* status returned by RunPPC, WaitForPPC, Run68K and WaitFor68K */

ENUM PPERR_SUCCESS, /* success */
 PPERR_ASYNCERR,  /* synchron call after asynchron call */
 PPERR_WAITERR   /* WaitFor[PPC/68K] after synchron call */
/* Offsets into the RegisterArrays.for 68K Callbacks */

ENUM PPREG_D0,
 PPREG_D1,
 PPREG_D2,
 PPREG_D3,
 PPREG_D4,
 PPREG_D5,
 PPREG_D6,
 PPREG_D7,
 PPREG_A0,
 PPREG_A1,
 PPREG_A2,
 PPREG_A3,
 PPREG_A4,
 PPREG_A5,
 PPREG_A6

ENUM PPREG_FP0,
 PPREG_FP1,
 PPREG_FP2,
 PPREG_FP3,
 PPREG_FP4,
 PPREG_FP5,
 PPREG_FP6,
 PPREG_FP7
#ifndef POWERPCLIB_V7
/* use max. version 7 of powerpc.library -> */
/* ppc.library can be used instead of WarpKernal */
/* V7 is recommended for "simple" applications */
/* Cache flags (required by SetCache/SetCache68K) */
ENUM CACHE_DCACHEOFF=1,
 CACHE_DCACHEON,
 CACHE_DCACHELOCK,
 CACHE_DCACHEUNLOCK,
 CACHE_DCACHEFLUSH,
 CACHE_ICACHEOFF,
 CACHE_ICACHEON,
 CACHE_ICACHELOCK,
 CACHE_ICACHEUNLOCK,
 CACHE_ICACHEINV,
 CACHE_DCACHEINV
/* Hardware flags (required by SetHardware) */
ENUM HW_TRACEON=1,              /* enable singlestep mode */
 HW_TRACEOFF,                    /* disable singlestep mode */
 HW_BRANCHTRACEON,               /* enable branch trace mode */
 HW_BRANCHTRACEOFF,              /* disable branch trace mode */
 HW_FPEXCON,                     /* enable FP exceptions */
 HW_FPEXCOFF,                    /* disable FP exceptions */
 HW_SETIBREAK,                   /* set instruction breakpoint */
 HW_CLEARIBREAK,                 /* clear instruction breakpoint */
 HW_SETDBREAK,                   /* set data breakpoint (604[E] only) */
 HW_CLEARDBREAK                 /* clear data breakpoint (604[E] only) */
/* return values of SetHardware */
ENUM HW_AVAILABLE=-1,               /* feature available */
 HW_NOTAVAILABLE               /* feature not available */
/* return values of GetPPCState */
FLAG PPCSTATE_POWERSAVE=0,              /* PPC is in power save mode */
 PPCSTATE_APPACTIVE=1,              /* PPC application tasks are active */
 PPCSTATE_APPRUNNING=2              /* PPC application task is running */
/* FP flags (required by ModifyFPExc) */

FLAG FP_EN_OVERFLOW=0,         /* enable overflow exception */
 FP_EN_UNDERFLOW=1,         /* enable underflow exception */
 FP_EN_ZERODIVIDE=2,         /* enable zerodivide exception */
 FP_EN_INEXACT=3,         /* enable inexact op. exception */
 FP_EN_INVALID=4,         /* enable invalid op. exception */
 FP_DIS_OVERFLOW=5,         /* disable overflow exception */
 FP_DIS_UNDERFLOW=6,         /* disable underflow exception */
 FP_DIS_ZERODIVIDE=7,         /* disable zerodivide exception */
 FP_DIS_INEXACT=8,         /* disable inexact op. exception */
 FP_DIS_INVALID=9         /* disable invalid op. exception */

CONST FPF_ENABLEALL=$0000001f,     /* enable all FP exceptions */
 FPF_DISABLEALL=$000003e0     /* disable all FP exceptions */
/* tags passed to SetExcHandler (exception handler attributes) */
#define EXCATTR_TAGS     (TAG_USER+$101000)
#define EXCATTR_CODE     (EXCATTR_TAGS+0)   /* exception code (required) */
#define EXCATTR_DATA     (EXCATTR_TAGS+1)   /* exception data */
#define EXCATTR_TASK     (EXCATTR_TAGS+2)   /* ppc task address (or NULL) */
#define EXCATTR_EXCID    (EXCATTR_TAGS+3)   /* exception ID */
#define EXCATTR_FLAGS    (EXCATTR_TAGS+4)   /* see below */
#define EXCATTR_NAME     (EXCATTR_TAGS+5)   /* identification name */
#define EXCATTR_PRI      (EXCATTR_TAGS+6)   /* handler priority */
/* EXCATTR_FLAGS (either EXC_GLOBAL or EXC_LOCAL, resp. */
/*                EXC_SMALLCONTEXT or EXC_LARGECONTEXT must be */
/*                specified) */
FLAG EXC_GLOBAL=0,        /* global handler */
 EXC_LOCAL=1,        /* local handler */
 EXC_SMALLCONTEXT=2,        /* small context structure */
 EXC_LARGECONTEXT=3,        /* large context structure */
 EXC_ACTIVE=4        /* private */
/* EXCATTR_EXCID (Exception ID) */
FLAG EXC_MCHECK=2,              /* machine check exception */
 EXC_DACCESS=3,              /* data access exception */
 EXC_IACCESS=4,              /* instruction access exception */
 EXC_INTERRUPT=5,             /* external interrupt (V15+) */
 EXC_ALIGN=6,              /* alignment exception */
 EXC_PROGRAM=7,              /* program exception */
 EXC_FPUN=8,              /* FP unavailable exception */
 EXC_SC=12,             /* system call exception */
 EXC_TRACE=13,             /* trace exception */
 EXC_PERFMON=15,             /* performance monitor exception */
 EXC_IABR=19             /* IA breakpoint exception */

OBJECT EXCContext
 ExcID:ULONG,
 [CUNION
  SRR0:ULONG,
  PC:APTR
 ENDUNION]:UPC,
 SRR1:ULONG,
 DAR:ULONG,
 DSISR:ULONG,
 CR:ULONG,
 CTR:ULONG,
 LR:ULONG,
 XER:ULONG,
 FPSCR:ULONG,
 GPR[32]:ULONG,
 FPR[32]:DOUBLE

OBJECT XContext
  ExcID:ULONG,
  R3:ULONG

ENUM EXCRETURN_NORMAL, /* allow the next exc handlers to complete */
 EXCRETURN_ABORT       /* exception is immediately leaved, all */
                       /* other exception handlers are ignored */
