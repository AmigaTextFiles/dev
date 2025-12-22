-> exec/tasks.e (MorphOS)

OPT MODULE, EXPORT

MODULE 'exec/nodes', 'exec/lists', 'exec/ports', 'utility/tagitem'

OBJECT tc
  ln:ln
  flags:CHAR
  state:CHAR
  idnestcnt:CHAR  -> This is signed
  tdnestcnt:CHAR  -> This is signed
  sigalloc:LONG
  sigwait:LONG
  sigrecvd:LONG
  sigexcept:LONG
  trapalloc:INT  -> This is unsigned
  trapable:INT  -> This is unsigned
  exceptdata:LONG
  exceptcode:LONG
  trapdata:LONG
  trapcode:LONG
  spreg:LONG
  splower:LONG
  spupper:LONG
  switch:LONG  /* MOS OBSOLETE */
  launch:LONG  /* MOS OBSOLETE */
  mementry:lh
  userdata:LONG
  /* ECX union */
  etask:PTR TO etask @ trapalloc
ENDOBJECT     /* SIZEOF=92 */

CONST TB_PROCTIME=0,
      TB_ETASK=3,
      TB_STACKCHK=4,
      TB_EXCEPT=5,
      TB_SWITCH=6,
      TB_LAUNCH=7,
      TF_PROCTIME=1,
      TF_ETASK=8,
      TF_STACKCHK=16,
      TF_EXCEPT=$20,
      TF_SWITCH=$40,
      TF_LAUNCH=$80,
      TS_INVALID=0,
      TS_ADDED=1,
      TS_RUN=2,
      TS_READY=3,
      TS_WAIT=4,
      TS_EXCEPT=5,
      TS_REMOVED=6,
      SIGB_ABORT=0,
      SIGB_CHILD=1,
      SIGB_BLIT=4,
      SIGB_SINGLE=4,
      SIGB_INTUITION=5,
      SIGB_NET=7,
      SIGB_DOS=8,
      SIGF_ABORT=1,
      SIGF_CHILD=2,
      SIGF_BLIT=16,
      SIGF_SINGLE=16,
      SIGF_INTUITION=$20,
      SIGF_NET=$80,
      SIGF_DOS=$100,
      SYS_SIGALLOC=$FFFF,
      SYS_TRAPALLOC=$8000


OBJECT tasktrapmessage
   message:mn   /* Message Header */
   task:PTR TO tc   /* connected Task */
   version:LONG   /* version of the structure */
   type:LONG   /* Exception Type */
   dar:LONG   /* Exception Address Register */
   dsisr:LONG   /* Exception DSISR Reg */

        /* This is undiscovered land...
         * never assume a size of this structure
         */
ENDOBJECT

CONST VERSION_TASKTRAPMESSAGE  = $0

OBJECT etask
  mn:mn
  parent:PTR TO tc
  uniqueid:LONG
  children:mlh
  trapalloc:INT  -> This is unsigned
  trapable:INT  -> This is unsigned
  result1:LONG
  result2:LONG
  taskmsgport:mp
  /* Don't touch!!!!!!!!!..there'll be an interface
    * sooner than later.
    * New Entries...most of the above entries
    * are only their for structure compatability.
    * They have no meaning as the OS never supported
    * them.
    */

   /* A Task Pool for the task.
    */
   mempool:LONG

   /* PPC's Stack Lower Ptr
    * The initial stack is allocated through
    * AllocVec, so a FreeVec(ETask->PPCSPLower);
    * would work.
    * If you use PPCStackSwap you must allocate
    * your stack block with AllocVec();
    */
   ppcsplower:LONG

   /* PPC's Stack Upper Ptr
    */
   ppcspupper:LONG
   ppcregframe:LONG
   ppclibdata:LONG

   /* On a PPC exception this msgport
    * is sent an exception msg....
    * the task is stopped until somebody
    * wakes it up again.
    * (asynchron exception interface)
         * If this Port is NULL the message is
         * sent to SysBase->ex_PPCTrapMsgPort.
    */
   ppctrapmsgport:PTR TO mp
   ppctrapmessage:PTR TO tasktrapmessage

   /* This is undiscovered land...
    * never assume a size of this structure
    */
ENDOBJECT


OBJECT taskinitextension
   /* Must be filled with TRAP_PPCTASK */
   trap:INT
   extension:INT   /* Must be set to 0 */
   tags:PTR TO tagitem
ENDOBJECT

CONST TASKTAG_DUMMY         =  TAG_USER + $100000

/* Ptr to an ULONG Errorfield where a better error description
 * can be stored.
 */
CONST TASKTAG_ERROR         =  TASKTAG_DUMMY + $0

/* Code type
 * can be stored.
 */
CONST TASKTAG_CODETYPE      =  TASKTAG_DUMMY + $1

/* Start PC
 * code must be of TASKTAG_CODETYPE
 */
CONST TASKTAG_PC            =  TASKTAG_DUMMY + $2

/* Final PC
 * code must be of TASKTAG_CODETYPE
 */
CONST TASKTAG_FINALPC       =  TASKTAG_DUMMY + $3

/* Stacksize...Default 8192
 */
CONST TASKTAG_STACKSIZE     =  TASKTAG_DUMMY + $4

/* Std Stacksize...
 * Default(use the stack defined by tc_SPLower..tc_SPUpper)
 */
CONST TASKTAG_STACKSIZE_M68K = TASKTAG_DUMMY + $5

/*
 * specify task name, name is copied
 */
CONST TASKTAG_NAME          =  TASKTAG_DUMMY + $6

/*
 * tc_UserData
*/
CONST TASKTAG_USERDATA       = TASKTAG_DUMMY + $7

/*
 * Task priority
 */
CONST TASKTAG_PRI           =  TASKTAG_DUMMY + $8

/*
 * Pool's Puddlesize
 */
CONST TASKTAG_POOLPUDDLE    =  TASKTAG_DUMMY + $9

/*
 * Pool's ThreshSize
 */
CONST TASKTAG_POOLTHRESH    =  TASKTAG_DUMMY + $a


/* PPC First Argument..gpr3
 */
CONST TASKTAG_PPC_ARG1     =   TASKTAG_DUMMY + $10

/* PPC First Argument..gpr4
 */
CONST TASKTAG_PPC_ARG2     here`s not such id the functionaFirst Argument..gpr5
 */
CONST TASKTAG_PPC_ARG3      =  TASKTAG_DUMMY + $12

/* PPC First Argument..gpr6
 */
CONST TASKTAG_PPC_ARG4     =   TASKTAG_DUMMY + $13

/* PPC First Argument..gpr7
 */
CONST TASKTAG_PPC_ARG5     =   TASKTAG_DUMMY + $14

/* PPC First Argument..gpr8
 */
CONST TASKTAG_PPC_ARG6     =   TASKTAG_DUMMY + $15

/* PPC First Argument..gpr9
 */
CONST TASKTAG_PPC_ARG7     =   TASKTAG_DUMMY + $16

/* PPC First Argument..gpr10
 */
CONST TASKTAG_PPC_ARG8     =   TASKTAG_DUMMY + $17



/*
 * Startup message to be passed to task/process, ReplyMsg'd at RemTask()
 * ti_Data: struct Message *
 */
CONST TASKTAG_STARTUPMSG    =  TASKTAG_DUMMY + $18

/*
 * Create internal MsgPort for task/process, deleted at RemTask()
 * ti_Data: struct MsgPort **, can be NULL
 */
CONST TASKTAG_TASKMSGPORT   =  TASKTAG_DUMMY + $19




CONST CODETYPE_M68K  = $0
/*
 * System V4 ABI
 */
CONST CODETYPE_PPC   = $1


CONST TASKERROR_OK       = 0
CONST TASKERROR_NOMEMORY = 1


/*
 * Stack swap structure as passed to StackSwap() and PPCStackSwap()
 */
OBJECT stackswapstruct
  lower:LONG
  upper:LONG
  pointer:LONG
ENDOBJECT     /* SIZEOF=12 */


OBJECT ppcstackswapargs
   args[8]:ARRAY OF LONG  /* R3..R10 */
ENDOBJECT



/*
 * NewGetTaskAttrsA(),  NewSetTaskAttrsA() tags
 */

CONST TASKINFOTYPE_ALLTASK            = $0
CONST TASKINFOTYPE_NAME               = $1
CONST TASKINFOTYPE_PRI                = $2
CONST TASKINFOTYPE_TYPE               = $3
CONST TASKINFOTYPE_STATE              = $4
CONST TASKINFOTYPE_FLAGS              = $5
CONST TASKINFOTYPE_SIGALLOC           = $6
CONST TASKINFOTYPE_SIGWAIT            = $7
CONST TASKINFOTYPE_SIGRECVD           = $8
CONST TASKINFOTYPE_SIGEXCEPT          = $9
CONST TASKINFOTYPE_EXCEPTDATA         = $a
CONST TASKINFOTYPE_EXCEPTCODE         = $b
CONST TASKINFOTYPE_TRAPDATA           = $c
CONST TASKINFOTYPE_TRAPCODE           = $d
CONST TASKINFOTYPE_STACKSIZE_M68K     = $e
CONST TASKINFOTYPE_STACKSIZE          = $f
CONST TASKINFOTYPE_USEDSTACKSIZE_M68K = $10
CONST TASKINFOTYPE_USEDSTACKSIZE      = $11
CONST TASKINFOTYPE_TRAPMSGPORT        = $12
CONST TASKINFOTYPE_STARTUPMSG         = $13
CONST TASKINFOTYPE_TASKMSGPORT        = $14
CONST TASKINFOTYPE_POOLPTR            = $15
CONST TASKINFOTYPE_POOLMEMFLAGS       = $16
CONST TASKINFOTYPE_POOLPUDDLESIZE     = $17
CONST TASKINFOTYPE_POOLTHRESHSIZE     = $18

/*
 * Task Scheduler statistics (exec 50.42)
 */
CONST TASKINFOTYPE_NICE                  = $19
CONST TASKINFOTYPE_AGETICKS              = $1a
CONST TASKINFOTYPE_CPUTIME               = $1b
CONST TASKINFOTYPE_LASTSECCPUTIME        = $1c
CONST TASKINFOTYPE_RECENTCPUTIME         = $1d
CONST TASKINFOTYPE_VOLUNTARYCSW          = $1e
CONST TASKINFOTYPE_INVOLUNTARYCSW        = $1f
CONST TASKINFOTYPE_LASTSECVOLUNTARYCSW   = $20
CONST TASKINFOTYPE_LASTSECINVOLUNTARYCSW = $21
/* Added in exec 50.45 */
CONST TASKINFOTYPE_LAUNCHTIMETICKS       = $22
CONST TASKINFOTYPE_LAUNCHTIMETICKS1978   = $23
CONST TASKINFOTYPE_PID                   = $24


CONST TASKINFOTYPE_68K_NEWFRAME       = $50

CONST TASKINFOTYPE_PPC_SRR0           = $100
CONST TASKINFOTYPE_PPC_SRR1           = $101
CONST TASKINFOTYPE_PPC_LR             = $102
CONST TASKINFOTYPE_PPC_CTR            = $103
CONST TASKINFOTYPE_PPC_CR             = $104
CONST TASKINFOTYPE_PPC_XER            = $105
CONST TASKINFOTYPE_PPC_GPR            = $106
CONST TASKINFOTYPE_PPC_FPR            = $107
CONST TASKINFOTYPE_PPC_FPSCR          = $108
CONST TASKINFOTYPE_PPC_VSCR           = $109
CONST TASKINFOTYPE_PPC_VMX            = $10a
CONST TASKINFOTYPE_PPC_VSAVE          = $10b
CONST TASKINFOTYPE_PPC_FRAME          = $10c
CONST TASKINFOTYPE_PPC_FRAMESIZE      = $10d
CONST TASKINFOTYPE_PPC_NEWFRAME       = $10e

CONST TASKINFOTAG_DUMMY       = TAG_USER + $110000
/* Used with TASKINFOTYPE_ALLTASK
 */
CONST TASKINFOTAG_HOOK        = TASKINFOTAG_DUMMY + $0
/* Used with TASKINFOTYPE_PPC_GPR,TASKINFOTYPE_PPC_FPR,TASKINFOTYPE_PPC_VMX
 * to define the copy area
 */
CONST TASKINFOTAG_REGSTART    = TASKINFOTAG_DUMMY + $1
/* Used with TASKINFOTYPE_PPC_GPR,TASKINFOTYPE_PPC_FPR,TASKINFOTYPE_PPC_VMX
 * to define the copy area
 */
CONST TASKINFOTAG_REGCOUNT    = TASKINFOTAG_DUMMY + $2

/*
 * NewSetTaskAttrsA(..,&TaskFrame68k,sizeof(struct TaskFrame68k),TASKINFOTYPE_68K_NEWFRAME,...);
 *
 */
OBJECT taskframe68k
   pc:LONG
   sr:INT
   xn[15]:ARRAY OF LONG
ENDOBJECT


/*
 * Don't depend on these
 */
CONST DEFAULT_PPCSTACKSIZE   = 32768
CONST DEFAULT_M68KSTACKSIZE  = 2048
CONST DEFAULT_TASKPUDDLESIZE = 4096
CONST DEFAULT_TASKTHRESHSIZE = 4096

