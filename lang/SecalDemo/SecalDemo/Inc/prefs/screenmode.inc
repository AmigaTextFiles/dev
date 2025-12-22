include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct ScreenModePrefs is
  smp_Reserved[4]:ulong;
  smp_DisplayID:ulong;
  smp_Width:uword;
  smp_Height:uword;
  smp_Depth:uword;
  smp_Control:uword;
;

def SMB_AUTOSCROLL = 1;

def SMF_AUTOSCROLL = (1<<0);

