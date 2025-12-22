@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "rexx/storage.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT srcnode
@{fg shine}(   0)@{fg text}   succ:PTR TO srcnode
@{fg shine}(   4)@{fg text}   pred:PTR TO srcnode
@{fg shine}(   8)@{fg text}   ptr:LONG
@{fg shine}(  12)@{fg text}   size:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT rexxtask
@{fg shine}(   0)@{fg text}   global[200]:ARRAY OF CHAR
@{fg shine}( 200)@{fg text}   msgport:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}( 234)@{fg text}   flags:CHAR
@{fg shine}( 235)@{fg text}   sigbit:CHAR
@{fg shine}( 236)@{fg text}   clientid:LONG
@{fg shine}( 240)@{fg text}   msgpkt:LONG
@{fg shine}( 244)@{fg text}   taskid:LONG
@{fg shine}( 248)@{fg text}   port:LONG
@{fg shine}( 252)@{fg text}   errtrap:LONG
@{fg shine}( 256)@{fg text}   stackptr:LONG
@{fg shine}( 260)@{fg text}   header1:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 274)@{fg text}   header2:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 288)@{fg text}   header3:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 302)@{fg text}   header4:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}( 316)@{fg text}   header5:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=330 */

@{fg shine}(----)@{fg text} OBJECT rexxrsrc
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   func:INT
@{fg shine}(  16)@{fg text}   base:LONG
@{fg shine}(  20)@{fg text}   size:LONG
@{fg shine}(  24)@{fg text}   arg1:PTR TO CHAR
@{fg shine}(  28)@{fg text}   arg2:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT rexxmsg
@{fg shine}(   0)@{fg text}   mn:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   taskblock:LONG
@{fg shine}(  24)@{fg text}   libbase:LONG
@{fg shine}(  28)@{fg text}   action:LONG
@{fg shine}(  32)@{fg text}   result1:LONG
@{fg shine}(  36)@{fg text}   result2:LONG
@{fg shine}(  40)@{fg text}   args[16]:ARRAY OF LONG
@{fg shine}( 104)@{fg text}   passport:PTR TO mp
@{fg shine}( 108)@{fg text}   commaddr:PTR TO CHAR
@{fg shine}( 112)@{fg text}   fileext:PTR TO CHAR
@{fg shine}( 116)@{fg text}   stdin:LONG
@{fg shine}( 120)@{fg text}   stdout:LONG
@{fg shine}( 124)@{fg text}   avail:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=128 */

@{fg shine}(----)@{fg text} OBJECT rexxarg
@{fg shine}(   0)@{fg text}   size:LONG
@{fg shine}(   4)@{fg text}   length:INT
@{fg shine}(   6)@{fg text}   flags:CHAR
@{fg shine}(   7)@{fg text}   hash:CHAR
@{fg shine}(   8)@{fg text}   buff[8]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT nexxstr
@{fg shine}(   0)@{fg text}   ivalue:LONG
@{fg shine}(   4)@{fg text}   length:INT
@{fg shine}(   6)@{fg text}   flags:CHAR
@{fg shine}(   7)@{fg text}   hash:CHAR
@{fg shine}(   8)@{fg text}   buff[8]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

CONST MEMQUANT=16,
      RRTYPE=8,
      KEEPNUM=$9A,
      NSF_DPNUM=$28,
      RTFB_SUSP=2,
      NXADDLEN=9,
      RRT_PORT=2,
      MEMQUICK=1,
      RXADDCON=$A000000,
      RTFB_TRACE=0,
      RTFB_HALT=1,
      RXTCOPN=$C000000,
      NSF_FLOAT=$20,
      NSB_FLOAT=5,
      NUMLISTS=5,
      MAXRMARG=15,
      NSF_ALPHA=6,
      RXFF_TOKEN=$80000,
      RXFB_TOKEN=19,
      RXREMCON=$B000000,
      RRT_LIB=1,
      MEMMASK=-16,
      RXARGMASK=15,
      RXCODEMASK=$FF000000,
      RXFF_NONRET=$100000,
      RXFB_NONRET=20,
      RXADDLIB=$8000000,
      RXFF_RESULT=$20000,
      RXFB_RESULT=17,
      ACTION=28,
      NSF_EXT=$40,
      NSB_EXT=6,
      MEMCLEAR=$10000,
      RTFB_CLOSE=7,
      RXREMLIB=$9000000,
      RXCLOSE=$3000000,
      RXQUERY=$4000000,
      RRT_HOST=4,
      RXFF_STRING=$40000,
      RXFB_STRING=18,
      NSF_STRING=2,
      NSB_STRING=1,
      RESULT1=$20,
      KEEPSTR=$86,
      NSF_NUMBER=8,
      NSB_NUMBER=3,
      RESULT2=$24,
      RXTCCLS=$D000000,
      RXFB_NOIO=16,
      RRT_ANY=0,
      PORTLIST=$13C,
      FILELIST=$12E,
      MEMLIST=$120,
      FREELIST=$112,
      ENVLIST=$104,
      RXFUNC=$2000000,
      RXCOMM=$1000000,
      NSF_OWNED=$C1,
      NSF_BINARY=16,
      NSB_BINARY=4,
      RTFB_WAIT=6,
      NSF_INTNUM=26,
      NSF_NOTNUM=4,
      NSB_NOTNUM=2,
      RXADDFH=$7000000,
      NSF_KEEP=1,
      NSB_KEEP=0,
      RRT_FILE=3,
      GLOBALSZ=$C8,
      RRT_CLIP=5,
      RRSIZE=20,
      NSF_SOURCE=$80,
      NSB_SOURCE=7,
      RTFB_TCUSE=3,
      RRNAME=10

#define ARG0/1
#define ARG1/1
#define ARG2/1
#define IVALUE/1
@endnode
