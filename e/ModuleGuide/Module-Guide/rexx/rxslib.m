@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "rexx/rxslib.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT rxslib
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   flags:CHAR
@{fg shine}(  35)@{fg text}   shadow:CHAR
@{fg shine}(  36)@{fg text}   sysbase:LONG
@{fg shine}(  40)@{fg text}   dosbase:LONG
@{fg shine}(  44)@{fg text}   ieeedpbase:LONG
@{fg shine}(  48)@{fg text}   seglist:LONG
@{fg shine}(  52)@{fg text}   nil:LONG
@{fg shine}(  56)@{fg text}   chunk:LONG
@{fg shine}(  60)@{fg text}   maxnest:LONG
@{fg shine}(  64)@{fg text}   null:PTR TO nexxstr
@{fg shine}(  68)@{fg text}   false:PTR TO nexxstr
@{fg shine}(  72)@{fg text}   true:PTR TO nexxstr
@{fg shine}(  76)@{fg text}   rexx:PTR TO nexxstr
@{fg shine}(  80)@{fg text}   command:PTR TO nexxstr
@{fg shine}(  84)@{fg text}   stdin:PTR TO nexxstr
@{fg shine}(  88)@{fg text}   stdout:PTR TO nexxstr
@{fg shine}(  92)@{fg text}   stderr:PTR TO nexxstr
@{fg shine}(  96)@{fg text}   version:PTR TO CHAR
@{fg shine}( 100)@{fg text}   taskname:PTR TO CHAR
@{fg shine}( 104)@{fg text}   taskpri:LONG
@{fg shine}( 108)@{fg text}   taskseg:LONG
@{fg shine}( 112)@{fg text}   stacksize:LONG
@{fg shine}( 116)@{fg text}   rexxdir:PTR TO CHAR
@{fg shine}( 120)@{fg text}   ctable:PTR TO CHAR
@{fg shine}( 124)@{fg text}   notice:PTR TO CHAR
@{fg shine}( 128)@{fg text}   rexxport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}( 162)@{fg text}   readlock:INT
@{fg shine}( 164)@{fg text}   tracefh:LONG
@{fg shine}( 168)@{fg text}   tasklist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 182)@{fg text}   numtask:INT
@{fg shine}( 184)@{fg text}   liblist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 198)@{fg text}   numlib:INT
@{fg shine}( 200)@{fg text}   cliplist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 214)@{fg text}   numclip:INT
@{fg shine}( 216)@{fg text}   msglist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 230)@{fg text}   nummsg:INT
@{fg shine}( 232)@{fg text}   pgmlist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 246)@{fg text}   numpgm:INT
@{fg shine}( 248)@{fg text}   tracecnt:INT
@{fg shine}( 250)@{fg text}   avail:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=252 */

CONST RLFB_SUSP=2,
      RLFB_TRACE=0,
      RLFB_HALT=1,
      CTF_REXXSYM=8,
      CTB_REXXSYM=3,
      CTF_ALPHA=4,
      CTB_ALPHA=2,
      CTF_REXXOPR=16,
      CTB_REXXOPR=4,
      CTF_SPACE=1,
      CTB_SPACE=0,
      RXSTPRI=0,
      RLFMASK=7,
      RLFB_STOP=6,
      CTF_REXXSPC=$20,
      CTB_REXXSPC=5,
      RLFB_CLOSE=7,
      RXSCHUNK=$400,
      RXSNEST=$20,
      CTF_UPPER=$40,
      CTB_UPPER=6,
      CTF_LOWER=$80,
      CTB_LOWER=7,
      CTF_DIGIT=2,
      CTB_DIGIT=1,
      RXSSTACK=$1000

#define RXSDIR/0
#define RXSTNAME/0
#define RXSNAME/0
@endnode
