MODULE 'powerpc/portsPPC','utility/tagitem'
/* private structure */

OBJECT TaskLink
  Node:MinNode,
  Task:APTR,
  Sig:ULONG,
  Used:UWORD

/* task structure for ppc. fields not commented are private*/
OBJECT TaskPPC
  Task:Task,                    /* exec task structure */
  StackSize:ULONG,              /* stack size: read only */
  StackMem:APTR,
  ContextMem:APTR,
  TaskPtr:APTR,
  Flags:ULONG,                  /* flags (see below): read only */
  Link:TaskLink,
  BATStorage:APTR,
  Core:ULONG,
  TableLink:MinNode,
  Table:APTR,                    /* task's page table: read only */
  DebugData:ULONG,              /* free space for debuggers */
  Pad:UWORD,
  Timestamp:ULONG,
  Timestamp2:ULONG,
  Elapsed:ULONG,
  Elapsed2:ULONG,
  Totalelapsed:ULONG,
  Quantum:ULONG,
  Priority:ULONG,
  Prioffset:ULONG,
  PowerPCBase:APTR,
  Desired:ULONG,
  CPUusage:ULONG,               /* CPU usage: read only */
  Busy:ULONG,                   /* busy time: read only */
  Activity:ULONG,               /* activity: read only */
  Id:ULONG,                     /* task ID: read only */
  Nice:ULONG,                   /* NICE value: read only */
  Msgport:PTR TO MsgPortPPC,    /* Msg port: read only */
  TaskPools:List,               /* private: for V15-MM */
  PoolMem:ULONG,                /* private: for V15-MM */
  MessageRIP:PTR TO Message,    /* private */
  ExcData:APTR                   /* private */

/* don't depend on sizeof(TaskPPC) */
CONST NT_PPCTASK=100,
/* tc_State (additional task states) */
 TS_CHANGING=7
/* tp_Flags */
FLAG TASKPPC_SYSTEM=0,
 TASKPPC_BAT=1,
 TASKPPC_THROW=2,
 TASKPPC_CHOWN=3,
 TASKPPC_ATOMIC=4
/* tags passed to CreateTaskPPC */
#define TASKATTR_TAGS        (TAG_USER+$100000)
#define TASKATTR_CODE        (TASKATTR_TAGS+0)    /* entry code */
#define TASKATTR_EXITCODE    (TASKATTR_TAGS+1)    /* exit code */
#define TASKATTR_NAME        (TASKATTR_TAGS+2)    /* task name */
#define TASKATTR_PRI         (TASKATTR_TAGS+3)    /* task priority */
#define TASKATTR_STACKSIZE   (TASKATTR_TAGS+4)    /* task stacksize */
#define TASKATTR_R2          (TASKATTR_TAGS+5)    /* smalldata/TOC base */
#define TASKATTR_R3          (TASKATTR_TAGS+6)    /* first parameter */
#define TASKATTR_R4          (TASKATTR_TAGS+7)
#define TASKATTR_R5          (TASKATTR_TAGS+8)
#define TASKATTR_R6          (TASKATTR_TAGS+9)
#define TASKATTR_R7          (TASKATTR_TAGS+10)
#define TASKATTR_R8          (TASKATTR_TAGS+11)
#define TASKATTR_R9          (TASKATTR_TAGS+12)
#define TASKATTR_R10         (TASKATTR_TAGS+13)
#define TASKATTR_SYSTEM      (TASKATTR_TAGS+14)   /* private */
#define TASKATTR_MOTHERPRI   (TASKATTR_TAGS+15)   /* inherit mothers pri */
#define TASKATTR_BAT         (TASKATTR_TAGS+16)   /* BAT MMU setup (BOOL) */
#define TASKATTR_NICE        (TASKATTR_TAGS+18)   /* initial NICE value (-20..20)*/
#define TASKATTR_INHERITR2   (TASKATTR_TAGS+19)   /* inherit r2 from parent task
                                                   (overrides TASKATTR_R2) (V15+) */
#define TASKATTR_ATOMIC      (TASKATTR_TAGS+20) /* noninterruptable task */
#define TASKATTR_NOTIFYMSG   (TASKATTR_TAGS+21) /* notification upon task death (V16+) */
/* taskptr structure */

OBJECT TaskPtr
  Node:Node,
  Task:APTR

/* return values of ChangeStack */
ENUM CHSTACK_SUCCESS=-1,
 CHSTACK_NOMEM,
/* parameter to ChangeMMU */
 CHMMU_STANDARD,
 CHMMU_BAT
/* tags passed to SnoopTask */
#define SNOOP_TAGS           (TAG_USER+$103000)
#define SNOOP_CODE           (SNOOP_TAGS+0)       /* pointer to callback function */
#define SNOOP_DATA           (SNOOP_TAGS+1)       /* custom data, passed in r2 */
#define SNOOP_TYPE           (SNOOP_TAGS+2)       /* snoop type (see below) */
/* possible values of SNOOP_TYPE */
ENUM SNOOP_START=1,                        /*monitor task start */
 SNOOP_EXIT                        /*monitor task exit */
/* possible values for the CreatorCPU parameter of the callback function */
ENUM CREATOR_PPC=1,
 CREATOR_68K
