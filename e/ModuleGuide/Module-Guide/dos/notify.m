@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/notify.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT notifyrequest
@{fg shine}(   0)@{fg text}   name:PTR TO CHAR
@{fg shine}(   4)@{fg text}   fullname:PTR TO CHAR
@{fg shine}(   8)@{fg text}   userdata:LONG
@{fg shine}(  12)@{fg text}   flags:LONG
@{fg shine}(  16)@{fg text}   task:PTR TO tc
@{fg shine}(  16)@{fg text}   port:PTR TO mp
@{fg shine}(  20)@{fg text}   signalnum:CHAR
@{fg shine}(  21)@{fg text}   pada:CHAR
@{fg shine}(  22)@{fg text}   padb[2]:ARRAY OF CHAR
@{fg shine}(  24)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  40)@{fg text}   msgcount:LONG
@{fg shine}(  44)@{fg text}   handler:PTR TO mp
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=48 */

@{fg shine}(----)@{fg text} OBJECT notifymessage
@{fg shine}(   0)@{fg text}   execmessage:mn @{fg shine}(or ARRAY OF mn)@{fg text}
@{fg shine}(  20)@{fg text}   class:LONG
@{fg shine}(  24)@{fg text}   code:INT
@{fg shine}(  26)@{fg text}   nreq:PTR TO notifyrequest
@{fg shine}(  30)@{fg text}   donottouch:LONG
@{fg shine}(  34)@{fg text}   donottouch2:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=38 */

CONST NRB_WAIT_REPLY=3,
      NRF_WAIT_REPLY=8,
      NOTIFY_CODE=$1234,
      NRB_SEND_SIGNAL=1,
      NRF_SEND_SIGNAL=2,
      NRB_MAGIC=31,
      NRF_MAGIC=$80000000,
      NRB_NOTIFY_INITIAL=4,
      NRF_NOTIFY_INITIAL=16,
      NRB_SEND_MESSAGE=0,
      NRF_SEND_MESSAGE=1,
      NOTIFY_CLASS=$40000000,
      NR_HANDLER_FLAGS=$FFFF0000
@endnode
