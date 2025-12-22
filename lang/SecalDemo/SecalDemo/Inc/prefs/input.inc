include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";
include "inc/devices/timer.inc";

struct InputPrefs is
  ip_Keymap[16]:byte;
  ip_PointerTicks:uword;
  ip_DoubleClick:timeval;
  ip_KeyRptDelay:timeval;
  ip_KeyRptSpeed:timeval;
  ip_MouseAccel:word;
;

