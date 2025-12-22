@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/timer.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT timerequest
@{fg shine}(   0)@{fg text}   io:io @{fg shine}(or ARRAY OF io)@{fg text}
@{fg shine}(  32)@{fg text}   time:timeval @{fg shine}(or ARRAY OF timeval)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT eclockval
@{fg shine}(   0)@{fg text}   hi:LONG
@{fg shine}(   4)@{fg text}   lo:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT timeval
@{fg shine}(   0)@{fg text}   secs:LONG
@{fg shine}(   4)@{fg text}   micro:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST UNIT_MICROHZ=0,
      TR_SETSYSTIME=11,
      TR_GETSYSTIME=10,
      UNIT_WAITECLOCK=4,
      UNIT_ECLOCK=2,
      UNIT_VBLANK=1,
      TR_ADDREQUEST=9,
      UNIT_WAITUNTIL=3

#define TIMERNAME/0
@endnode
