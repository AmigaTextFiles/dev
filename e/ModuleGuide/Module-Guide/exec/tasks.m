@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/tasks.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT stackswapstruct
@{fg shine}(   0)@{fg text}   lower:LONG
@{fg shine}(   4)@{fg text}   upper:LONG
@{fg shine}(   8)@{fg text}   pointer:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT etask
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   parent:PTR TO tc
@{fg shine}(  24)@{fg text}   uniqueid:LONG
@{fg shine}(  28)@{fg text}   children:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}(  40)@{fg text}   trapalloc:INT
@{fg shine}(  42)@{fg text}   trapable:INT
@{fg shine}(  44)@{fg text}   result1:LONG
@{fg shine}(  48)@{fg text}   result2:LONG
@{fg shine}(  52)@{fg text}   taskmsgport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=86 */

@{fg shine}(----)@{fg text} OBJECT tc
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:CHAR
@{fg shine}(  15)@{fg text}   state:CHAR
@{fg shine}(  16)@{fg text}   idnestcnt:CHAR
@{fg shine}(  17)@{fg text}   tdnestcnt:CHAR
@{fg shine}(  18)@{fg text}   sigalloc:LONG
@{fg shine}(  22)@{fg text}   sigwait:LONG
@{fg shine}(  26)@{fg text}   sigrecvd:LONG
@{fg shine}(  30)@{fg text}   sigexcept:LONG
@{fg shine}(  34)@{fg text}   etask:PTR TO etask
@{fg shine}(  34)@{fg text}   trapalloc:INT
@{fg shine}(  36)@{fg text}   trapable:INT
@{fg shine}(  38)@{fg text}   exceptdata:LONG
@{fg shine}(  42)@{fg text}   exceptcode:LONG
@{fg shine}(  46)@{fg text}   trapdata:LONG
@{fg shine}(  50)@{fg text}   trapcode:LONG
@{fg shine}(  54)@{fg text}   spreg:LONG
@{fg shine}(  58)@{fg text}   splower:LONG
@{fg shine}(  62)@{fg text}   spupper:LONG
@{fg shine}(  66)@{fg text}   switch:LONG
@{fg shine}(  70)@{fg text}   launch:LONG
@{fg shine}(  74)@{fg text}   mementry:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(  88)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=92 */

CONST TF_SWITCH=$40,
      TB_SWITCH=6,
      TS_INVALID=0,
      CHILD_ACTIVE=4,
      TF_ETASK=8,
      TB_ETASK=3,
      TF_PROCTIME=1,
      TB_PROCTIME=0,
      CHILD_EXITED=3,
      SIGF_SINGLE=16,
      SIGB_SINGLE=4,
      SYS_TRAPALLOC=$8000,
      SYS_SIGALLOC=$FFFF,
      SIGF_DOS=$100,
      SIGB_DOS=8,
      SIGF_INTUITION=$20,
      SIGB_INTUITION=5,
      TS_EXCEPT=5,
      TF_EXCEPT=$20,
      TB_EXCEPT=5,
      SIGF_NET=$80,
      SIGB_NET=7,
      TS_REMOVED=6,
      TS_READY=3,
      CHILD_NOTNEW=1,
      SIGF_BLIT=16,
      SIGB_BLIT=4,
      TF_STACKCHK=16,
      TB_STACKCHK=4,
      TS_WAIT=4,
      TS_ADDED=1,
      TF_LAUNCH=$80,
      TB_LAUNCH=7,
      SIGF_CHILD=2,
      SIGB_CHILD=1,
      CHILD_NOTFOUND=2,
      SIGF_ABORT=1,
      SIGB_ABORT=0,
      TS_RUN=2
@endnode
