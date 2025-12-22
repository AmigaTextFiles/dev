@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/execbase.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT execbase
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   softver:INT
@{fg shine}(  36)@{fg text}   lowmemchksum:INT
@{fg shine}(  38)@{fg text}   chkbase:LONG
@{fg shine}(  42)@{fg text}   coldcapture:LONG
@{fg shine}(  46)@{fg text}   coolcapture:LONG
@{fg shine}(  50)@{fg text}   warmcapture:LONG
@{fg shine}(  54)@{fg text}   sysstkupper:LONG
@{fg shine}(  58)@{fg text}   sysstklower:LONG
@{fg shine}(  62)@{fg text}   maxlocmem:LONG
@{fg shine}(  66)@{fg text}   debugentry:LONG
@{fg shine}(  70)@{fg text}   debugdata:LONG
@{fg shine}(  74)@{fg text}   alertdata:LONG
@{fg shine}(  78)@{fg text}   maxextmem:LONG
@{fg shine}(  82)@{fg text}   chksum:INT
@{fg shine}(  84)@{fg text}   ivtbe:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}(  96)@{fg text}   ivdskblk:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 108)@{fg text}   ivsoftint:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 120)@{fg text}   ivports:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 132)@{fg text}   ivcoper:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 144)@{fg text}   ivvertb:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 156)@{fg text}   ivblit:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 168)@{fg text}   ivaud0:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 180)@{fg text}   ivaud1:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 192)@{fg text}   ivaud2:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 204)@{fg text}   ivaud3:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 216)@{fg text}   ivrbf:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 228)@{fg text}   ivdsksync:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 240)@{fg text}   ivexter:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 252)@{fg text}   ivinten:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 264)@{fg text}   ivnmi:iv @{fg shine}(or ARRAY OF iv)@{fg text}
@{fg shine}( 276)@{fg text}   thistask:PTR TO tc
@{fg shine}( 280)@{fg text}   idlecount:LONG
@{fg shine}( 284)@{fg text}   dispcount:LONG
@{fg shine}( 288)@{fg text}   quantum:INT
@{fg shine}( 290)@{fg text}   elapsed:INT
@{fg shine}( 292)@{fg text}   sysflags:INT
@{fg shine}( 294)@{fg text}   idnestcnt:CHAR
@{fg shine}( 295)@{fg text}   tdnestcnt:CHAR
@{fg shine}( 296)@{fg text}   attnflags:INT
@{fg shine}( 298)@{fg text}   attnresched:INT
@{fg shine}( 300)@{fg text}   resmodules:LONG
@{fg shine}( 304)@{fg text}   tasktrapcode:LONG
@{fg shine}( 308)@{fg text}   taskexceptcode:LONG
@{fg shine}( 312)@{fg text}   taskexitcode:LONG
@{fg shine}( 316)@{fg text}   tasksigalloc:LONG
@{fg shine}( 320)@{fg text}   tasktrapalloc:INT
@{fg shine}( 322)@{fg text}   memlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 336)@{fg text}   resourcelist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 350)@{fg text}   devicelist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 364)@{fg text}   intrlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 378)@{fg text}   liblist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 392)@{fg text}   portlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 406)@{fg text}   taskready:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 420)@{fg text}   taskwait:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 434)@{fg text}   softints:sh @{fg shine}(or ARRAY OF sh)@{fg text}
@{fg shine}( 514)@{fg text}   lastalert[4]:ARRAY OF LONG
@{fg shine}( 530)@{fg text}   vblankfrequency:CHAR
@{fg shine}( 531)@{fg text}   powersupplyfrequency:CHAR
@{fg shine}( 532)@{fg text}   semaphorelist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 546)@{fg text}   kickmemptr:LONG
@{fg shine}( 550)@{fg text}   kicktagptr:LONG
@{fg shine}( 554)@{fg text}   kickchecksum:LONG
@{fg shine}( 558)@{fg text}   pad0:INT
@{fg shine}( 560)@{fg text}   launchpoint:LONG
@{fg shine}( 564)@{fg text}   ramlibprivate:LONG
@{fg shine}( 568)@{fg text}   eclockfrequency:LONG
@{fg shine}( 572)@{fg text}   cachecontrol:LONG
@{fg shine}( 576)@{fg text}   taskid:LONG
@{fg shine}( 580)@{fg text}   reserved1[5]:ARRAY OF LONG
@{fg shine}( 600)@{fg text}   mmulock:LONG
@{fg shine}( 604)@{fg text}   reserved2[3]:ARRAY OF LONG
@{fg shine}( 616)@{fg text}   memhandlers:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}( 628)@{fg text}   memhandler:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=632 */

CONST AFF_PRIVATE=$8000,
      AFB_PRIVATE=15,
      CACRF_COPYBACK=$80000000,
      CACRF_ENABLED=$100,
      CACRF_ENABLEE=$40000000,
      CACRF_ENABLEI=1,
      AFF_FPU40=$40,
      AFB_FPU40=6,
      CACRF_DBE=$1000,
      CACRF_CLEARD=$800,
      AFF_68010=1,
      AFB_68010=0,
      CACRF_IBE=16,
      CACRF_CLEARI=8,
      DMAF_READFROMRAM=8,
      AFF_68020=2,
      AFB_68020=1,
      AFF_68030=4,
      AFB_68030=2,
      DMAF_CONTINUE=2,
      AFF_68040=8,
      AFB_68040=3,
      AFF_68881=16,
      AFB_68881=4,
      AFF_68882=$20,
      AFB_68882=5,
      CACRF_WRITEALLOCATE=$2000,
      CACRF_FREEZED=$200,
      CACRF_FREEZEI=2,
      DMAF_NOMODIFY=4
@endnode
