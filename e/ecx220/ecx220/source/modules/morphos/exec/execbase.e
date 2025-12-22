OPT MODULE, EXPORT

-> MorphOS execbase.e by LS 2005 (some comments from original)

MODULE 'exec/lists'
MODULE 'exec/interrupts'
MODULE 'morphos/exec/libraries'
MODULE 'morphos/exec/tasks'
MODULE 'utility/tagitem'
MODULE 'exec/ports'

OBJECT execbase
  lib:lib
  softver:INT  -> This is unsigned
  lowmemchksum:INT
  chkbase:LONG
  coldcapture:LONG
  coolcapture:LONG
  warmcapture:LONG
  sysstkupper:LONG
  sysstklower:LONG
  maxlocmem:LONG
  debugentry:LONG
  debugdata:LONG
  alertdata:LONG
  maxextmem:LONG
  chksum:INT  -> This is unsigned
  ivtbe:iv
  ivdskblk:iv
  ivsoftint:iv
  ivports:iv
  ivcoper:iv
  ivvertb:iv
  ivblit:iv
  ivaud0:iv
  ivaud1:iv
  ivaud2:iv
  ivaud3:iv
  ivrbf:iv
  ivdsksync:iv
  ivexter:iv
  ivinten:iv
  ivnmi:iv
  thistask:PTR TO tc
  idlecount:LONG
  dispcount:LONG
  quantum:INT  -> This is unsigned
  elapsed:INT  -> This is unsigned
  sysflags:INT  -> This is unsigned
  idnestcnt:CHAR  -> This is signed
  tdnestcnt:CHAR  -> This is signed
  attnflags:INT  -> This is unsigned
  attnresched:INT  -> This is unsigned
  resmodules:LONG
  tasktrapcode:LONG
  taskexceptcode:LONG
  taskexitcode:LONG
  tasksigalloc:LONG
  tasktrapalloc:INT  -> This is unsigned
  memlist:lh
  resourcelist:lh
  devicelist:lh
  intrlist:lh
  liblist:lh
  portlist:lh
  taskready:lh
  taskwait:lh
  softints[5]:ARRAY OF sh
  lastalert[4]:ARRAY OF LONG
  vblankfrequency:CHAR
  powersupplyfrequency:CHAR
  semaphorelist:lh
  kickmemptr:LONG
  kicktagptr:LONG
  kickchecksum:LONG
  pad0:INT
  launchpoint:LONG
  ramlibprivate:LONG
  eclockfrequency:LONG
  cachecontrol:LONG
  taskid:LONG


  /* New ABox Emulation Entries
 */

  emulhandlesize:LONG        /* PPC EmulHandleSize..*private* */
  ppctrapmsgport:PTR TO mp   /* PPC ABox Exception MsgPort..*private* */
  reserved1[3]:ARRAY OF LONG
  mmulock:LONG

  patchpool:LONG             /* PatchPool Ptr needed by SetFunction..*private* */
  ppctaskexitcode:LONG       /* PPC Task exit function */
  debugflags:LONG            /* Exec Debug Flags..*private* */

  memhandlers:mlh
  memhandler:LONG

ENDOBJECT     /* SIZEOF=632 */

CONST AFB_68010=0,
      AFB_68020=1,
      AFB_68030=2,
      AFB_68040=3,
      AFB_68881=4,
      AFB_68882=5,
      AFB_FPU40=6,
      AFB_PRIVATE=15,
      AFF_68010=1,
      AFF_68020=2,
      AFF_68030=4,
      AFF_68040=8,
      AFF_68881=16,
      AFF_68882=$20,
      AFF_FPU40=$40,
      AFF_PRIVATE=$8000,
      CACRF_ENABLEI=1,
      CACRF_FREEZEI=2,
      CACRF_CLEARI=8,
      CACRF_IBE=16,
      CACRF_ENABLED=$100,
      CACRF_FREEZED=$200,
      CACRF_CLEARD=$800,
      CACRF_DBE=$1000,
      CACRF_WRITEALLOCATE=$2000,
      CACRF_ENABLEE=$40000000,
      CACRF_COPYBACK=$80000000,
      DMAF_CONTINUE=2,
      DMAF_NOMODIFY=4,
      DMAF_READFROMRAM=8


/****** Debug Flags...(don`t depend on them) **********/

CONST EXECDEBUGF_INITRESIDENT     = $1
CONST EXECDEBUGF_INITCODE         = $2
CONST EXECDEBUGF_FINDRESIDENT     = $4

CONST EXECDEBUGF_CREATELIBRARY    = $10
CONST EXECDEBUGF_SETFUNCTION      = $20
CONST EXECDEBUGF_NEWSETFUNCTION   = $40
CONST EXECDEBUGF_CHIPRAM          = $80

CONST EXECDEBUGF_ADDTASK          = $100
CONST EXECDEBUGF_REMTASK          = $200
CONST EXECDEBUGF_GETTASKATTR      = $400
CONST EXECDEBUGF_SETTASKATTR      = $800

CONST EXECDEBUGF_EXCEPTHANDLER    = $1000
CONST EXECDEBUGF_ADDDOSNODE       = $2000
CONST EXECDEBUGF_PCI              = $4000
CONST EXECDEBUGF_RAMLIB           = $8000

CONST EXECDEBUGF_NOLOGSERVER      = $10000
CONST EXECDEBUGF_NOLOGWINDOW      = $20000

/*
 * "env:MorphOS/LogPath" contains the logfile path,
 * If not specified it`s using "ram:.morphoslog"
 */
CONST EXECDEBUGF_LOGFILE          = $40000
CONST EXECDEBUGF_LOGKPRINTF       = $80000


/* Memory Tracking Flags
 */

CONST EXECDEBUGF_PERMMEMTRACK     = $100000
CONST EXECDEBUGF_MEMTRACK         = $200000


/* CyberGuardPPC Flags
 */

CONST EXECDEBUGF_CYBERGUARDDEADLY = $400000


/* PPCLib Flags
 */

CONST EXECDEBUGF_LOADSEG          = $01000000
CONST EXECDEBUGF_UNLOADSEG        = $02000000
CONST EXECDEBUGF_PPCSTART         = $04000000


/* UserFlags
 */

/*
 * Enables debug output for cybergraphx
 */
CONST EXECDEBUGF_CGXDEBUG         = $08000000

/*
 * Should be used to control user LibInit/DevInit Debug output
 */
CONST EXECDEBUGF_INIT             = $40000000

/*
 * Should be used to control logging
 */
CONST EXECDEBUGF_LOG              = $80000000


/*
 * Execbase list IDs
 */
CONST EXECLIST_DEVICE         = 0
CONST EXECLIST_INTERRUPT      = 1
CONST EXECLIST_LIBRARY        = 2
CONST EXECLIST_MEMHANDLER     = 3
CONST EXECLIST_MEMHEADER      = 4
CONST EXECLIST_PORT           = 5
CONST EXECLIST_RESOURCE       = 6
CONST EXECLIST_SEMAPHORE      = 7
CONST EXECLIST_TASK           = 8

/*
 * Execnotify hook message
 */
OBJECT execnotifymessage
  type:LONG
  flags:LONG
  extra:LONG
  extension:PTR TO tagitem
ENDOBJECT

CONST EXECNOTIFYF_REMOVE      = (1 SHL 0)        /* if clear, is ADD */
CONST EXECNOTIFYF_POST        = (1 SHL 1)        /* if clear, is PRE */

/*
 * AddExecNodeTagList tags
 */
CONST SAL_Dummy       = (TAG_USER + 1000)
CONST SAL_Type        = (SAL_Dummy + 1)
CONST SAL_Priority    = (SAL_Dummy + 2)
CONST SAL_Name        = (SAL_Dummy + 3)


