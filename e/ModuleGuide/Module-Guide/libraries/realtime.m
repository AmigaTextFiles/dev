@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/realtime.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT realtimebase
@{fg shine}(   0)@{fg text}   lib:lib @{fg shine}(or ARRAY OF lib)@{fg text}
@{fg shine}(  34)@{fg text}   reserved0[2]:ARRAY OF CHAR
@{fg shine}(  36)@{fg text}   time:LONG
@{fg shine}(  40)@{fg text}   timefrac:LONG
@{fg shine}(  44)@{fg text}   reserved1:INT
@{fg shine}(  46)@{fg text}   tickerr:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=48 */

@{fg shine}(----)@{fg text} OBJECT pmstate
@{fg shine}(   0)@{fg text}   method:LONG
@{fg shine}(   4)@{fg text}   oldstate:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT pmtime
@{fg shine}(   0)@{fg text}   method:LONG
@{fg shine}(   4)@{fg text}   time:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT player
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   reserved0:CHAR
@{fg shine}(  15)@{fg text}   reserved1:CHAR
@{fg shine}(  16)@{fg text}   hook:PTR TO hook
@{fg shine}(  20)@{fg text}   source:PTR TO conductor
@{fg shine}(  24)@{fg text}   task:PTR TO tc
@{fg shine}(  28)@{fg text}   metrictime:LONG
@{fg shine}(  32)@{fg text}   alarmtime:LONG
@{fg shine}(  36)@{fg text}   userdata:LONG
@{fg shine}(  40)@{fg text}   playerid:INT
@{fg shine}(  42)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=44 */

@{fg shine}(----)@{fg text} OBJECT conductor
@{fg shine}(   0)@{fg text}   ln:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   reserved0:INT
@{fg shine}(  16)@{fg text}   players:mlh @{fg shine}(or ARRAY OF mlh)@{fg text}
@{fg shine}(  28)@{fg text}   clocktime:LONG
@{fg shine}(  32)@{fg text}   starttime:LONG
@{fg shine}(  36)@{fg text}   externaltime:LONG
@{fg shine}(  40)@{fg text}   maxexternaltime:LONG
@{fg shine}(  44)@{fg text}   metronome:LONG
@{fg shine}(  48)@{fg text}   reserved1:INT
@{fg shine}(  50)@{fg text}   flags:INT
@{fg shine}(  52)@{fg text}   state:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=54 */

CONST CONDUCTB_PRIVATE=3,
      CONDUCTF_PRIVATE=8,
      PLAYERB_ALARMSET=1,
      PLAYERF_ALARMSET=2,
      PLAYER_ERRORCODE=$8000004F,
      PLAYER_ALARMSIGTASK=$80000046,
      PLAYER_ALARMTIME=$8000004C,
      PLAYER_PRIORITY=$80000043,
      PLAYER_USERDATA=$8000004A,
      PM_STATE=1,
      PLAYER_EXTSYNC=$8000004E,
      PLAYERB_EXTSYNC=4,
      PLAYERF_EXTSYNC=16,
      PLAYER_QUIET=$80000049,
      PLAYERB_QUIET=2,
      PLAYERF_QUIET=4,
      PLAYER_BASE=$80000040,
      RTE_PLAYING=$324,
      RTE_NOCONDUCTOR=$322,
      PLAYER_CONDUCTOR=$80000044,
      CONDSTATE_PAUSED=1,
      CONDUCTB_EXTERNAL=0,
      CONDUCTF_EXTERNAL=1,
      RTE_NOTIMER=$323,
      PM_POSITION=2,
      PM_SHUTTLE=3,
      CONDSTATE_SHUTTLE=-2,
      REALTIME_TICKERR_MIN=$FFFFFD3F,
      PLAYER_READY=$80000045,
      PLAYERB_READY=0,
      PLAYERF_READY=1,
      PLAYER_ID=$8000004B,
      TICK_FREQ=$4B0,
      CONDSTATE_STOPPED=0,
      PM_TICK=0,
      CONDUCTB_GOTTICK=1,
      CONDUCTF_GOTTICK=2,
      RT_CONDUCTORS=0,
      PLAYER_CONDUCTED=$80000047,
      PLAYERB_CONDUCTED=3,
      PLAYERF_CONDUCTED=8,
      CONDSTATE_RUNNING=3,
      PLAYER_ALARM=$8000004D,
      CONDSTATE_LOCATE=2,
      RTE_NOMEMORY=$321,
      PLAYER_HOOK=$80000041,
      PLAYER_ALARMSIGBIT=$80000048,
      CONDSTATE_LOCATE_SET=-3,
      CONDUCTB_METROSET=2,
      CONDUCTF_METROSET=4,
      REALTIME_TICKERR_MAX=$2C1,
      PLAYER_NAME=$80000042,
      CONDSTATE_METRIC=-1
@endnode
