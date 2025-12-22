include "inc/exec/types.inc";
include "inc/exec/io.inc";

def UNIT_MICROHZ = 0;
def UNIT_VBLANK = 1;
def UNIT_ECLOCK = 2;
def UNIT_WAITUNTIL = 3;
def UNIT_WAITECLOCK = 4;

def TIMERNAME = "timer.device";

struct timeval is
  tv_secs:ulong;
  tv_micro:ulong;
;

struct EClockVal is
  ev_hi:ulong;
  ev_lo:ulong;
;

struct timerequest is
  tr_node:IORequest;
  tr_time:timeval;
;

def TR_ADDREQUEST = CMD_NONSTD;
def TR_GETSYSTIME = (CMD_NONSTD+1);
def TR_SETSYSTIME = (CMD_NONSTD+2);

