/* $VER: exectags.h 53.38 (31.1.2010) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <exec/exectags.h>}
NATIVE {EXEC_EXECTAGS_H} CONST

/* 
 * Tag items used by AllocSysObject
 */

NATIVE {ASO_NoTrack}         CONST ASO_NOTRACK         = (TAG_USER +  1) /* Don't track this object (i.e. do not free automatically) */
NATIVE {ASO_MemoryOvr}       CONST ASO_MEMORYOVR       = (TAG_USER +  2) /* Memory type override */

/* IORequest */
NATIVE {ASOIOR_Size}         CONST ASOIOR_SIZE         = (TAG_USER + 10) /* Size of the object */
NATIVE {ASOIOR_ReplyPort}    CONST ASOIOR_REPLYPORT    = (TAG_USER + 11) /* ReplyPort to use */
NATIVE {ASOIOR_Duplicate}    CONST ASOIOR_DUPLICATE    = (TAG_USER + 12) /* Source IO request to duplicate */

/* Hook */
NATIVE {ASOHOOK_Size}        CONST ASOHOOK_SIZE        = (TAG_USER + 10) /* Size of the object */
NATIVE {ASOHOOK_Entry}       CONST ASOHOOK_ENTRY       = (TAG_USER + 11) /* The hook's entry */
NATIVE {ASOHOOK_Subentry}    CONST ASOHOOK_SUBENTRY    = (TAG_USER + 12) /* The hook's subentry field */
NATIVE {ASOHOOK_Data}        CONST ASOHOOK_DATA        = (TAG_USER + 13) /* The hook's user data */

/* Interrupt */
NATIVE {ASOINTR_Size}        CONST ASOINTR_SIZE        = (TAG_USER + 10) /* Size of the object */
NATIVE {ASOINTR_Code}        CONST ASOINTR_CODE        = (TAG_USER + 11) /* Code pointer */
NATIVE {ASOINTR_Data}        CONST ASOINTR_DATA        = (TAG_USER + 12) /* Data pointer */

/* List */
NATIVE {ASOLIST_Size}        CONST ASOLIST_SIZE        = (TAG_USER + 10) /* Size of the object */ 
NATIVE {ASOLIST_Type}        CONST ASOLIST_TYPE        = (TAG_USER + 11) /* Type to set for the list */
NATIVE {ASOLIST_Min}         CONST ASOLIST_MIN         = (TAG_USER + 12) /* Create a minlist */

/* DMAEntry array */
NATIVE {ASODMAE_Size}        CONST ASODMAE_SIZE        = (TAG_USER + 10) /* Raw size of the object */
NATIVE {ASODMAE_NumEntries}  CONST ASODMAE_NUMENTRIES  = (TAG_USER + 11) /* Number of entries */

/* List node */
NATIVE {ASONODE_Size}        CONST ASONODE_SIZE        = (TAG_USER + 10) /* Size of the node */
NATIVE {ASONODE_Min}         CONST ASONODE_MIN         = (TAG_USER + 11) /* Make it a MinNode */
NATIVE {ASONODE_Type}        CONST ASONODE_TYPE        = (TAG_USER + 12) /* Node's type */
NATIVE {ASONODE_Pri}         CONST ASONODE_PRI         = (TAG_USER + 13) /* Node's priority */
NATIVE {ASONODE_Name}        CONST ASONODE_NAME        = (TAG_USER + 14) /* Pointer to a node string */

/* Message port */
NATIVE {ASOPORT_Size}        CONST ASOPORT_SIZE        = (TAG_USER + 10) /* Size of the object */
NATIVE {ASOPORT_AllocSig}    CONST ASOPORT_ALLOCSIG    = (TAG_USER + 11) /* Allocate a signal */
NATIVE {ASOPORT_Action}      CONST ASOPORT_ACTION      = (TAG_USER + 12) /* Action at message arrival (see ports.h, enMsgPortActions) */
NATIVE {ASOPORT_Pri}         CONST ASOPORT_PRI         = (TAG_USER + 13) /* Priority used when the port is added to a list */
NATIVE {ASOPORT_Name}        CONST ASOPORT_NAME        = (TAG_USER + 14) /* Name for the port */
NATIVE {ASOPORT_Signal}      CONST ASOPORT_SIGNAL      = (TAG_USER + 15) /* Preallocted signal number */
NATIVE {ASOPORT_Target}      CONST ASOPORT_TARGET      = (TAG_USER + 16) /* MsgPort's target, either a task, or ar softint */
NATIVE {ASOPORT_Public}      CONST ASOPORT_PUBLIC      = (TAG_USER + 17) /* Make the port public */
NATIVE {ASOPORT_CopyName}    CONST ASOPORT_COPYNAME    = (TAG_USER + 18) /* Copy the name string */


/* Message */
NATIVE {ASOMSG_Size}         CONST ASOMSG_SIZE         = (TAG_USER + 10) /* Size of the object */
NATIVE {ASOMSG_ReplyPort}    CONST ASOMSG_REPLYPORT    = (TAG_USER + 11) /* Reply port */
NATIVE {ASOMSG_Length}       CONST ASOMSG_LENGTH       = (TAG_USER + 12) /* Message length */
NATIVE {ASOMSG_Name}         CONST ASOMSG_NAME         = (TAG_USER + 13) /* Name to put into the node */

/* Signal semaphore */
NATIVE {ASOSEM_Size}         CONST ASOSEM_SIZE         = (TAG_USER + 10) /* Size of the object */
NATIVE {ASOSEM_Name}         CONST ASOSEM_NAME         = (TAG_USER + 11) /* Name */
NATIVE {ASOSEM_Pri}          CONST ASOSEM_PRI          = (TAG_USER + 12) /* Node's priority (only used on public semaphores) */
NATIVE {ASOSEM_Public}       CONST ASOSEM_PUBLIC       = (TAG_USER + 13) /* Semaphore is public and will be added to the system */
NATIVE {ASOSEM_CopyName}     CONST ASOSEM_COPYNAME     = (TAG_USER + 14) /* Copy the name string */

/* TagItem array */
NATIVE {ASOTAGS_Size}        CONST ASOTAGS_SIZE        = (TAG_USER + 10) /* Raw size of the object, i.e. in bytes */
NATIVE {ASOTAGS_NumEntries}  CONST ASOTAGS_NUMENTRIES  = (TAG_USER + 11) /* Number of tagitems */

/* Memory Pool */
NATIVE {ASOPOOL_MFlags}      CONST ASOPOOL_MFLAGS      = (TAG_USER + 10) /* Memory flags/requirements for this pool */
NATIVE {ASOPOOL_Puddle}      CONST ASOPOOL_PUDDLE      = (TAG_USER + 11) /* Size of each puddle */
NATIVE {ASOPOOL_Threshold}   CONST ASOPOOL_THRESHOLD   = (TAG_USER + 12) /* Largest alloction size that goes into the puddle */
NATIVE {ASOPOOL_Protected}   CONST ASOPOOL_PROTECTED   = (TAG_USER + 13) /* Protect pool with a semaphore */
NATIVE {ASOPOOL_Name}        CONST ASOPOOL_NAME        = (TAG_USER + 14) /* Name for the pool (for informational purpose only) */
NATIVE {ASOPOOL_CopyName}    CONST ASOPOOL_COPYNAME    = (TAG_USER + 15) /* Copy the name string */
NATIVE {ASOPOOL_LockMem}     CONST ASOPOOL_LOCKMEM     = (TAG_USER + 16) /* Lock memory allocated */
	
/* Item Pool */
NATIVE {ASOITEM_MFlags}      CONST ASOITEM_MFLAGS      = (TAG_USER + 10) /* Memory flags for the pool */
NATIVE {ASOITEM_ItemSize}    CONST ASOITEM_ITEMSIZE    = (TAG_USER + 11) /* Size of individual items */
NATIVE {ASOITEM_BatchSize}   CONST ASOITEM_BATCHSIZE   = (TAG_USER + 12) /* Amount of items to be allocated in one batch */
NATIVE {ASOITEM_MaxSize}     CONST ASOITEM_MAXSIZE     = (TAG_USER + 13) /* Maximum amount of items allowed in pool */
NATIVE {ASOITEM_GCPolicy}    CONST ASOITEM_GCPOLICY    = (TAG_USER + 14) /* Garbage collection policy */
NATIVE {ASOITEM_GCParameter} CONST ASOITEM_GCPARAMETER = (TAG_USER + 15) /* Garbage collection parameter */
NATIVE {ASOITEM_Constructor} CONST ASOITEM_CONSTRUCTOR = (TAG_USER + 16) /* Constructor hook */
NATIVE {ASOITEM_Destructor}  CONST ASOITEM_DESTRUCTOR  = (TAG_USER + 17) /* Destructor hook */
NATIVE {ASOITEM_Protected}   CONST ASOITEM_PROTECTED   = (TAG_USER + 18) /* Protect pool with a semaphore */

/* Mutex */
NATIVE {ASOMUTEX_Recursive}  CONST ASOMUTEX_RECURSIVE  = (TAG_USER + 10) /* Make mutex recursive */

/* Item pool GCPolicy types */
NATIVE {enItemPoolGCPolicy} DEF
NATIVE {ITEMGC_NONE}       CONST ITEMGC_NONE       = 0
NATIVE {ITEMGC_AFTERCOUNT} CONST ITEMGC_AFTERCOUNT = 1


/* Kernel memory cache */
NATIVE {ASOKMEM_Name}        CONST ASOKMEM_NAME        = (TAG_USER + 10) /* Name of the cache */
NATIVE {ASOKMEM_Type}        CONST ASOKMEM_TYPE        = (TAG_USER + 11) /* Type, private or shared */
NATIVE {ASOKMEM_Size}        CONST ASOKMEM_SIZE        = (TAG_USER + 12) /* Object size */
NATIVE {ASOKMEM_Alignment}   CONST ASOKMEM_ALIGNMENT   = (TAG_USER + 13) /* Object Alignment */
NATIVE {ASOKMEM_Constructor} CONST ASOKMEM_CONSTRUCTOR = (TAG_USER + 14) /* Constructor */
NATIVE {ASOKMEM_Destructor}  CONST ASOKMEM_DESTRUCTOR  = (TAG_USER + 15) /* Destructor */
NATIVE {ASOKMEM_Colored}     CONST ASOKMEM_COLORED     = (TAG_USER + 16) /* Use cache slab coloring */
NATIVE {ASOKMEM_Compact}     CONST ASOKMEM_COMPACT     = (TAG_USER + 17) /* Force cache to be compact, even
                                             * if this means the slab internal
                                             * fragmentation will be above the
                                             * threshold
                                             */

/* Kernel memory cache type */
NATIVE {enKMemCacheType} DEF
NATIVE {KMEMT_PRIVATE}     CONST KMEMT_PRIVATE     = 0
NATIVE {KMEMT_SHARED}      CONST KMEMT_SHARED      = 1



/* Resource map */
NATIVE {ASORMAP_Base}        CONST ASORMAP_BASE        = (TAG_USER + 10) /* Resource range base */
NATIVE {ASORMAP_Size}        CONST ASORMAP_SIZE        = (TAG_USER + 11) /* Resource range size */
NATIVE {ASORMAP_Quantum}     CONST ASORMAP_QUANTUM     = (TAG_USER + 12) /* Minimal quantum for one single
                                             * allocation
                                             */
NATIVE {ASORMAP_CacheMax}    CONST ASORMAP_CACHEMAX    = (TAG_USER + 13) /* Maximum size for quantum caches.
											 * All allocations smaller or equal
											 * to this size will come from 
											 * quantum caches
											 */


/* Tags for AllocVecTagList (V51) */
NATIVE {AVT_Type}            CONST AVT_TYPE            = (TAG_USER + 1)
NATIVE {AVT_Contiguous}      CONST AVT_CONTIGUOUS      = (TAG_USER + 2)
NATIVE {AVT_Lock}            CONST AVT_LOCK            = (TAG_USER + 3)
NATIVE {AVT_Alignment}       CONST AVT_ALIGNMENT       = (TAG_USER + 4)
NATIVE {AVT_PhysicalAlignment} CONST AVT_PHYSICALALIGNMENT = (TAG_USER + 5)
NATIVE {AVT_Clear}           CONST AVT_CLEAR           = (TAG_USER + 6)
NATIVE {AVT_ClearWithValue}	CONST AVT_CLEARWITHVALUE	= (TAG_USER + 6)
NATIVE {AVT_ClearValue}		CONST AVT_CLEARVALUE		= (TAG_USER + 6)
NATIVE {AVT_Wait}            CONST AVT_WAIT            = (TAG_USER + 7)
NATIVE {AVT_NoExpunge}       CONST AVT_NOEXPUNGE       = (TAG_USER + 8)

/* Tags for AllocNamedMemory (V51) */
NATIVE {ANMT_CheckSum}       CONST ANMT_CHECKSUM       = (TAG_USER + 1)
NATIVE {ANMT_Error}          CONST ANMT_ERROR          = (TAG_USER + 2)

/* Possible values for ANMT_Error */
NATIVE {enAllocNamedMemoryErrors} DEF
NATIVE {ANMERROR_NOERROR}        CONST ANMERROR_NOERROR        = 0
NATIVE {ANMERROR_NOMEMORY}       CONST ANMERROR_NOMEMORY       = 1
NATIVE {ANMERROR_DUPLICATENAME}  CONST ANMERROR_DUPLICATENAME  = 2
NATIVE {ANMERROR_PARAMETER}      CONST ANMERROR_PARAMETER      = 3


/* Tags for GetCPUInfo */
NATIVE {GCIT_NumberOfCPUs}   CONST GCIT_NUMBEROFCPUS   = (TAG_USER +  1)
NATIVE {GCIT_Family}         CONST GCIT_FAMILY         = (TAG_USER +  2)
NATIVE {GCIT_Model}          CONST GCIT_MODEL          = (TAG_USER +  3)
NATIVE {GCIT_ModelString}    CONST GCIT_MODELSTRING    = (TAG_USER +  4)
NATIVE {GCIT_Version}        CONST GCIT_VERSION        = (TAG_USER +  5)
NATIVE {GCIT_VersionString}  CONST GCIT_VERSIONSTRING  = (TAG_USER +  6)
NATIVE {GCIT_FrontsideSpeed} CONST GCIT_FRONTSIDESPEED = (TAG_USER +  7)
NATIVE {GCIT_ProcessorSpeed} CONST GCIT_PROCESSORSPEED = (TAG_USER +  8)
NATIVE {GCIT_L1CacheSize}    CONST GCIT_L1CACHESIZE    = (TAG_USER +  9)
NATIVE {GCIT_L2CacheSize}    CONST GCIT_L2CACHESIZE    = (TAG_USER + 10)
NATIVE {GCIT_L3CacheSize}    CONST GCIT_L3CACHESIZE    = (TAG_USER + 11)
NATIVE {GCIT_VectorUnit}     CONST GCIT_VECTORUNIT     = (TAG_USER + 12)
NATIVE {GCIT_Extensions}     CONST GCIT_EXTENSIONS     = (TAG_USER + 13)
NATIVE {GCIT_CacheLineSize}  CONST GCIT_CACHELINESIZE  = (TAG_USER + 14)
NATIVE {GCIT_CPUPageSize}    CONST GCIT_CPUPAGESIZE    = (TAG_USER + 15)
NATIVE {GCIT_ExecPageSize}   CONST GCIT_EXECPAGESIZE   = (TAG_USER + 16)
NATIVE {GCIT_TimeBaseSpeed}	CONST GCIT_TIMEBASESPEED	= (TAG_USER + 17)

/* Family codes */
NATIVE {enCPUFamiliy} DEF
NATIVE {CPUFAMILY_UNKNOWN} CONST CPUFAMILY_UNKNOWN = 0
NATIVE {CPUFAMILY_60X}     CONST CPUFAMILY_60X     = 1
NATIVE {CPUFAMILY_7X0}     CONST CPUFAMILY_7X0     = 2
NATIVE {CPUFAMILY_74XX}    CONST CPUFAMILY_74XX    = 3
NATIVE {CPUFAMILY_4XX}     CONST CPUFAMILY_4XX     = 4


/* Model codes */
NATIVE {enCPUModel} DEF
NATIVE {CPUTYPE_UNKNOWN}        CONST CPUTYPE_UNKNOWN        = 0
NATIVE {CPUTYPE_PPC603E}        CONST CPUTYPE_PPC603E        = 1
NATIVE {CPUTYPE_PPC604E}        CONST CPUTYPE_PPC604E        = 2
NATIVE {CPUTYPE_PPC750CXE}      CONST CPUTYPE_PPC750CXE      = 3
NATIVE {CPUTYPE_PPC750FX}       CONST CPUTYPE_PPC750FX       = 4
NATIVE {CPUTYPE_PPC750GX}       CONST CPUTYPE_PPC750GX       = 5
NATIVE {CPUTYPE_PPC7410}        CONST CPUTYPE_PPC7410        = 6
NATIVE {CPUTYPE_PPC74XX_VGER}   CONST CPUTYPE_PPC74XX_VGER   = 7
NATIVE {CPUTYPE_PPC74XX_APOLLO} CONST CPUTYPE_PPC74XX_APOLLO = 8
NATIVE {CPUTYPE_PPC405LP}       CONST CPUTYPE_PPC405LP       = 9
NATIVE {CPUTYPE_PPC405EP}       CONST CPUTYPE_PPC405EP       = 10
NATIVE {CPUTYPE_PPC405GP}       CONST CPUTYPE_PPC405GP       = 11
NATIVE {CPUTYPE_PPC405GPR}      CONST CPUTYPE_PPC405GPR      = 12
NATIVE {CPUTYPE_PPC440EP}       CONST CPUTYPE_PPC440EP       = 13
NATIVE {CPUTYPE_PPC440GP}       CONST CPUTYPE_PPC440GP       = 14
NATIVE {CPUTYPE_PPC440GX}       CONST CPUTYPE_PPC440GX       = 15
NATIVE {CPUTYPE_PPC440SX}       CONST CPUTYPE_PPC440SX       = 16
NATIVE {CPUTYPE_PPC440SP}       CONST CPUTYPE_PPC440SP       = 17


/* Vector unit types */
NATIVE {enVectorUnitType} DEF
NATIVE {VECTORTYPE_NONE}    CONST VECTORTYPE_NONE    = 0
NATIVE {VECTORTYPE_ALTIVEC} CONST VECTORTYPE_ALTIVEC = 1
NATIVE {VECTORTYPE_VMX}     CONST VECTORTYPE_VMX     = 2



/****************************************************************************/

/*
 * Object types for AllocSysObject
 */
NATIVE {enAllocSysObjectTypes} DEF
NATIVE {ASOT_IOREQUEST} CONST ASOT_IOREQUEST = 0 /* IORequest */
NATIVE {ASOT_HOOK}      CONST ASOT_HOOK      = 1 /* Hook */
NATIVE {ASOT_INTERRUPT} CONST ASOT_INTERRUPT = 2 /* Interrupt structure */
NATIVE {ASOT_LIST}      CONST ASOT_LIST      = 3 /* List and MinList */
NATIVE {ASOT_DMAENTRY}  CONST ASOT_DMAENTRY  = 4 /* DMAEntry array */
NATIVE {ASOT_NODE}      CONST ASOT_NODE      = 5 /* List node and MinNode */
NATIVE {ASOT_PORT}      CONST ASOT_PORT      = 6 /* Message port */
NATIVE {ASOT_MESSAGE}   CONST ASOT_MESSAGE   = 7 /* Exec Message */
NATIVE {ASOT_SEMAPHORE} CONST ASOT_SEMAPHORE = 8 /* Signal Semaphore */
NATIVE {ASOT_TAGLIST}   CONST ASOT_TAGLIST   = 9 /* TagItem list */
NATIVE {ASOT_MEMPOOL}   CONST ASOT_MEMPOOL   = 10 /* Memory pool */
NATIVE {ASOT_ITEMPOOL}  CONST ASOT_ITEMPOOL  = 11 /* Item pool */
NATIVE {ASOT_RMAP}      CONST ASOT_RMAP      = 12 /* Resource map */
NATIVE {ASOT_MUTEX}     CONST ASOT_MUTEX     = 13 /* Mutex */


/****************************************************************************/

/* Tag items for CreateLibrary */
NATIVE {CLT_Vector68K}     CONST CLT_VECTOR68K     = (TAG_USER +  1)
NATIVE {CLT_InitData}      CONST CLT_INITDATA      = (TAG_USER +  2)
NATIVE {CLT_InitFunc}      CONST CLT_INITFUNC      = (TAG_USER +  3)
NATIVE {CLT_Seglist}       CONST CLT_SEGLIST       = (TAG_USER +  8)
NATIVE {CLT_Interfaces}    CONST CLT_INTERFACES    = (TAG_USER +  9)
NATIVE {CLT_DataSize}      CONST CLT_DATASIZE      = (TAG_USER + 10)
NATIVE {CLT_Legacy}        CONST CLT_LEGACY        = (TAG_USER + 11)
NATIVE {CLT_NoLegacyIFace} CONST CLT_NOLEGACYIFACE = (TAG_USER + 12)

/****************************************************************************/

/* Message types for debugger hook */
NATIVE {enDebugMessage} DEF
NATIVE {DBHMT_EXCEPTION} CONST DBHMT_EXCEPTION = 1
NATIVE {DBHMT_REMTASK}   CONST DBHMT_REMTASK   = 2
NATIVE {DBHMT_OPENLIB}   CONST DBHMT_OPENLIB   = 3
NATIVE {DBHMT_CLOSELIB}  CONST DBHMT_CLOSELIB  = 4
NATIVE {DBHMT_ADDTASK}   CONST DBHMT_ADDTASK   = 5


/****************************************************************************/

/* Tags for AddTask/CreateTask */
NATIVE {AT_Param1}         CONST AT_PARAM1         = (TAG_USER + 1)
NATIVE {AT_Param2}         CONST AT_PARAM2         = (TAG_USER + 2)
NATIVE {AT_Param3}         CONST AT_PARAM3         = (TAG_USER + 3)
NATIVE {AT_Param4}         CONST AT_PARAM4         = (TAG_USER + 4)
NATIVE {AT_Param5}         CONST AT_PARAM5         = (TAG_USER + 5)
NATIVE {AT_Param6}         CONST AT_PARAM6         = (TAG_USER + 6)
NATIVE {AT_Param7}         CONST AT_PARAM7         = (TAG_USER + 7)
NATIVE {AT_Param8}         CONST AT_PARAM8         = (TAG_USER + 8)
NATIVE {AT_Child}	  CONST AT_CHILD	  = (TAG_USER + 9)

NATIVE {CT_LockStack}      CONST CT_LOCKSTACK      = (TAG_USER + 20)

/****************************************************************************/

/* Tags for NewStackRun */
NATIVE {NSR_Dummy}         CONST NSR_DUMMY         = (TAG_USER+500)
NATIVE {NSR_StackSize}     CONST NSR_STACKSIZE     = (NSR_DUMMY+1)     /* Initial stack size */
NATIVE {NSR_MinStackSize}  CONST NSR_MINSTACKSIZE  = (NSR_DUMMY+2)     /* Absolute minimal stack size */
NATIVE {NSR_LockStack}     CONST NSR_LOCKSTACK     = (NSR_DUMMY+3)     /* Lock the stack in memory to prevent paging */
NATIVE {NSR_Arg1}          CONST NSR_ARG1          = (NSR_DUMMY+10)    /* Parameters passed to the function */
NATIVE {NSR_Arg2}          CONST NSR_ARG2          = (NSR_DUMMY+11)
NATIVE {NSR_Arg3}          CONST NSR_ARG3          = (NSR_DUMMY+12)
NATIVE {NSR_Arg4}          CONST NSR_ARG4          = (NSR_DUMMY+13)
NATIVE {NSR_Arg5}          CONST NSR_ARG5          = (NSR_DUMMY+14)
NATIVE {NSR_Arg6}          CONST NSR_ARG6          = (NSR_DUMMY+15)
