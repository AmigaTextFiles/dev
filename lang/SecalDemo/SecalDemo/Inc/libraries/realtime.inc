include "inc/exec/types.inc";
include "inc/exec/lists.inc";
include "inc/exec/libraries.inc";
include "inc/utility/tagitem.inc";
include "inc/utility/hooks.inc";

def TICK_FREQ = 1200;

struct Conductor is
  cdt_Link:Node;
  cdt_Reserved0:uword;
  cdt_Players:MinList;
  cdt_ClockTime:ulong;
  cdt_StartTime:ulong;
  cdt_ExternalTime:ulong;
  cdt_MaxExternalTime:ulong;
  cdt_Metronome:ulong;
  cdt_Reserved1:uword;
  cdt_Flags:uword;
  cdt_State:ubyte;
;

def CONDUCTF_EXTERNAL = (1<<0);
def CONDUCTF_GOTTICK = (1<<1);
def CONDUCTF_METROSET = (1<<2);
def CONDUCTF_PRIVATE = (1<<3);

def CONDUCTB_EXTERNAL = 0;
def CONDUCTB_GOTTICK = 1;
def CONDUCTB_METROSET = 2;
def CONDUCTB_PRIVATE = 3;

def CONDSTATE_STOPPED = 0;
def CONDSTATE_PAUSED = 1;
def CONDSTATE_LOCATE = 2;
def CONDSTATE_RUNNING = 3;

def CONDSTATE_METRIC = -1;
def CONDSTATE_SHUTTLE = -2;
def CONDSTATE_LOCATE_SET = -3;

struct Player is
  pl_Link:Node;
  pl_Reserved0:byte;
  pl_Reserved1:byte;
  pl_Hook:ulong;
  pl_Source:ulong;
  pl_Task:ulong;
  pl_MetricTime:long;
  pl_AlarmTime:long;
  pl_UserData:ulong;
  pl_PlayerID:uword;
  pl_Flags:uword;
;

def PLAYERF_READY = (1<<0);
def PLAYERF_ALARMSET = (1<<1);
def PLAYERF_QUIET = (1<<2);
def PLAYERF_CONDUCTED = (1<<3);
def PLAYERF_EXTSYNC = (1<<4);

def PLAYERB_READY = 0;
def PLAYERB_ALARMSET = 1;
def PLAYERB_QUIET = 2;
def PLAYERB_CONDUCTED = 3;
def PLAYERB_EXTSYNC = 4;

def PLAYER_Base = (TAG_USER+64);

def PLAYER_Hook = (PLAYER_Base+1);
def PLAYER_Name = (PLAYER_Base+2);
def PLAYER_Priority = (PLAYER_Base+3);
def PLAYER_Conductor = (PLAYER_Base+4);
def PLAYER_Ready = (PLAYER_Base+5);
def PLAYER_AlarmTime = (PLAYER_Base+12);
def PLAYER_Alarm = (PLAYER_Base+13);
def PLAYER_AlarmSigTask = (PLAYER_Base+6);
def PLAYER_AlarmSigBit = (PLAYER_Base+8);
def PLAYER_Conducted = (PLAYER_Base+7);
def PLAYER_Quiet = (PLAYER_Base+9);
def PLAYER_UserData = (PLAYER_Base+10);
def PLAYER_ID = (PLAYER_Base+11);
def PLAYER_ExtSync = (PLAYER_Base+14);
def PLAYER_ErrorCode = (PLAYER_Base+15);

def PM_TICK = 0;
def PM_STATE = 1;
def PM_POSITION = 2;
def PM_SHUTTLE = 3;

struct pmTime is
  pmt_Method:ulong;
  pmt_Time:ulong;
;

struct pmState is
  pms_Method:ulong;
  pms_OldState:ulong;
;

def RT_CONDUCTORS = 0;

def RTE_NOMEMORY = 801;
def RTE_NOCONDUCTOR = 802;
def RTE_NOTIMER = 803;
def RTE_PLAYING = 804;

struct RealTimeLibBase is
  rtb_LibNode:Library;
  rtb_Reserved0[2]:ubyte;
  rtb_Time:ulong;
  rtb_TimeFrac:ulong;
  rtb_Reserved1:uword;
  rtb_TickErr:word;
;

def RealTime_TickErr_Min = -705;
def RealTime_TickErr_Max = 705;

