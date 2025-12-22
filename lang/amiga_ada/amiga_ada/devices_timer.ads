with Interfaces; use Interfaces;

with exec_io; use exec_io;

package devices_timer is
--
--#include <exec/types.h>
--#include <exec/io.h>
--
UNIT_MICROHZ : constant Integer := 0;
UNIT_VBLANK : constant Integer := 1;
UNIT_ECLOCK : constant Integer := 2;
UNIT_WAITUNTIL : constant Integer := 3;
UNIT_WAITECLOCK : constant Integer := 4;
TIMERNAME : constant String := "timer.device";

type timeval;
type timeval_Ptr is access timeval;
type timeval is record
    tv_secs : Unsigned_32;
    tv_micro : Unsigned_32;
end record;

type EClockVal;
type EClockVal_Ptr is access EClockVal;
type EClockVal is record
    ev_hi : Unsigned_32;
    ev_lo : Unsigned_32;
end record;

type timerequest;
type timerequest_Ptr is access timerequest;
type timerequest is record
    tr_node : IORequest;
    tr_time : timeval;
end record;

TR_ADDREQUEST : constant Integer := CMD_NONSTD;
TR_GETSYSTIME : constant Integer := (CMD_NONSTD+1);
TR_SETSYSTIME : constant Integer := (CMD_NONSTD+2);

end devices_timer;