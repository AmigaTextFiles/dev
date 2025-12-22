
/*----------------------------------*\
| Amiga-E Module execbase.e(.m) with |
| definitions for 68060 CPU          |
|                                    |
| Done by Midnight/CRZ               |
|                                    |
| This one is very similar to the    |
| original (typed) module. I've just |
| added the definitions for the      |
| 68060 CPU (and internal FPU).      |
|                                    |
| Contact me for any reason at:      |
|   J. Stötzer                       |
|   An der Hasel 195                 |
|   98527 Suhl/Germany               |
|                                    |
| E-Mail: stoetzer@rz.tu-ilmenau.de  |
\*----------------------------------*/


OPT MODULE
OPT EXPORT

MODULE 'exec/lists',
       'exec/libraries',
       'exec/interrupts',
       'exec/tasks'

OBJECT execbase
  lib:lib
  softver:INT
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
  chksum:INT
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
  quantum:INT
  elapsed:INT
  sysflags:INT
  idnestcnt:CHAR
  tdnestcnt:CHAR
  attnflags:INT
  attnresched:INT
  resmodules:LONG
  tasktrapcode:LONG
  taskexceptcode:LONG
  taskexitcode:LONG
  tasksigalloc:LONG
  tasktrapalloc:INT
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
  mmulock:LONG
  reserved2[3]:ARRAY OF LONG
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
      AFB_FPU60=6,
      AFB_68060=7,                      -> Definition for 68060 CPU
      AFB_PRIVATE=15,
      AFF_68010=1,
      AFF_68020=2,
      AFF_68030=4,
      AFF_68040=8,
      AFF_68881=16,
      AFF_68882=$20,
      AFF_FPU40=$40,
      AFF_FPU60=$40,
      AFF_68060=$80,                    -> Definition for 68060 CPU
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
