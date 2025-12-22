OPT MODULE, EXPORT

-> AmigaOS4 execbase.e by LS 2008

MODULE 'exec/lists'
MODULE 'exec/interrupts'
MODULE 'exec/libraries'
MODULE 'exec/tasks'
MODULE 'exec/interfaces'
MODULE 'exec/ports'
MODULE 'exec/nodes'

OBJECT execbase
  lib:lib
  softver:WORD
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
  chksum:WORD
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
  quantum:WORD
  elapsed:WORD
  sysflags:WORD
  idnestcnt:BYTE
  tdnestcnt:BYTE
  attnflags:WORD
  attnresched:WORD
  resmodules:LONG
  tasktrapcode:LONG
  taskexceptcode:LONG
  taskexitcode:LONG
  tasksigalloc:LONG
  tasktrapalloc:WORD
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
  reserved1[5]:ARRAY OF LONG
  mmulock:LONG         /* private */
  reserved2[3]:ARRAY OF LONG
/****** V39 Exec additions start here **************************************/
/* The following list and data element are used
   for V39 exec's low memory handler... */
  memhandlers:mlh /* The handler list */
  memHandler:LONG  /* Private! handler pointer */
/****** V50 Exec additions start here **************************************/
   maininterface:PTR TO interface /* ExecLibrary's primary interface */
   private01:LONG
   private02:LONG
   private03:LONG
   private04:LONG
   private05:LONG
   private06:ln
   private07:LONG
   emuws:LONG          /* Emulator Workspace. Legacy libraries might
                               access this field */

/* Yes, there are more additions, but you don't need to know what it is */
ENDOBJECT

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

