@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "rexx/rexxio.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT rexxmsgport
@{fg shine}(   0)@{fg text}   rrsizeof:rexxrsrc @{fg shine}(or ARRAY OF rexxrsrc)@{fg text}
@{fg shine}(  32)@{fg text}   port:mp @{fg shine}(or ARRAY OF mp)@{fg text}
@{fg shine}(  66)@{fg text}   replylist:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=80 */

@{fg shine}(----)@{fg text} OBJECT iobuff
@{fg shine}(   0)@{fg text}   node:rexxrsrc @{fg shine}(or ARRAY OF rexxrsrc)@{fg text}
@{fg shine}(  32)@{fg text}   rpt:LONG
@{fg shine}(  36)@{fg text}   rct:LONG
@{fg shine}(  40)@{fg text}   dfh:LONG
@{fg shine}(  44)@{fg text}   lock:LONG
@{fg shine}(  48)@{fg text}   bct:LONG
@{fg shine}(  52)@{fg text}   area[204]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=256 */

CONST DT_DIR=1,
      IOBPOS=28,
      DT_VOL=2,
      RXIO_WRITE=2,
      RXIO_BEGIN=-1,
      RXBUFFSZ=$CC,
      RXIO_END=1,
      ACTION_QUEUE=$7D3,
      RXIO_EXIST=-1,
      IOBEOF=25,
      IOBMODE=24,
      RXIO_STRF=0,
      DT_DEV=0,
      RXIO_APPEND=3,
      RXIO_READ=1,
      ACTION_STACK=$7D2,
      RXIO_CURR=0,
      IOBNAME=10

#define LLVERS/1
#define LLOFFSET/1
#define CLVALUE/1
@endnode
