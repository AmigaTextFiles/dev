MODULE 'exec/tasks','exec/libraries','utility/hooks'

OBJECT Conductor
  Link:Node,
  Reserved0:UWORD,
  Players:MinList,
  ClockTime:ULONG,
  StartTime:ULONG,
  ExternalTime:ULONG,
  MaxExternalTime:ULONG,
  Metronome:ULONG,
  Reserved1:UWORD,
  Flags:UWORD,
  State:UBYTE

#define CONDUCTF_EXTERNAL  (1<<0)  
#define CONDUCTF_GOTTICK   (1<<1)  
#define CONDUCTF_METROSET  (1<<2)  
#define CONDUCTF_PRIVATE   (1<<3)  

OBJECT Player
  Link:Node,
  Reserved0:BYTE,
  Reserved1:BYTE,
  Hook:PTR TO Hook,
  Source:PTR TO Conductor,
  Task:PTR TO Task,
  MetricTime:LONG,
  AlarmTime:LONG,
  UserData:VOID,
  PlayerID:UWORD,
  Flags:UWORD

#define PLAYERF_READY     (1<<0)  
#define PLAYERF_ALARMSET   (1<<1)  
#define PLAYERF_QUIET     (1<<2)  
#define PLAYERF_CONDUCTED  (1<<3)  
#define PLAYERF_EXTSYNC    (1<<4)  
#define PLAYERB_READY     0
#define PLAYERB_ALARMSET   1
#define PLAYERB_QUIET     2
#define PLAYERB_CONDUCTED  3
#define PLAYERB_EXTSYNC    4
#define PLAYER_Base       (TAG_USER+64)
#define PLAYER_Hook       (PLAYER_Base+1)  
#define PLAYER_Name       (PLAYER_Base+2)  
#define PLAYER_Priority      (PLAYER_Base+3)  
#define PLAYER_Conductor     (PLAYER_Base+4)  
#define PLAYER_Ready      (PLAYER_Base+5)  
#define PLAYER_AlarmTime     (PLAYER_Base+12) 
#define PLAYER_Alarm      (PLAYER_Base+13) 
#define PLAYER_AlarmSigTask  (PLAYER_Base+6)  
#define PLAYER_AlarmSigBit   (PLAYER_Base+8)  
#define PLAYER_Conducted     (PLAYER_Base+7)  
#define PLAYER_Quiet      (PLAYER_Base+9)  
#define PLAYER_UserData      (PLAYER_Base+10)
#define PLAYER_ID       (PLAYER_Base+11)
#define PLAYER_ExtSync      (PLAYER_Base+14) 
#define PLAYER_ErrorCode     (PLAYER_Base+15) 

OBJECT pmTime
  Method:ULONG,
  Time:ULONG

OBJECT pmState
  Method:ULONG,
  OldState:ULONG

OBJECT RealTimeBase
  LibNode:Library,
  Reserved0[2]:UBYTE,
  Time:ULONG,
  TimeFrac:ULONG,
  Reserved1:UWORD,
  TickErr:WORD

CONST RealTime_TickErr_Min=-705,
 RealTime_TickErr_Max=705,
 TICK_FREQ=1200,
 CONDUCTB_EXTERNAL=0,
 CONDUCTB_GOTTICK=1,
 CONDUCTB_METROSET=2,
 CONDUCTB_PRIVATE=3,
 CONDSTATE_STOPPED=0,
 CONDSTATE_PAUSED=1,
 CONDSTATE_LOCATE=2,
 CONDSTATE_RUNNING=3,
 CONDSTATE_METRIC=-1,
 CONDSTATE_SHUTTLE=-2,
 CONDSTATE_LOCATE_SET=-3,
 RT_CONDUCTORS=0,
 RTE_NOMEMORY=801,
 RTE_NOCONDUCTOR=802,
 RTE_NOTIMER=803,
 RTE_PLAYING=804,
 PM_TICK=0,
 PM_STATE=1,
 PM_POSITION=2,
 PM_SHUTTLE=3
