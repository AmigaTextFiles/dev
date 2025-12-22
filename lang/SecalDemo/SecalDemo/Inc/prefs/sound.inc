include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct SoundPrefs is
  sop_Reserved[4]:long;
  sop_DisplayQueue:word;
  sop_AudioQueue:word;
  sop_AudioType:uword;
  sop_AudioVolume:uword;
  sop_AudioPeriod:uword;
  sop_AudioDuration:uword;
  sop_AudioFileName[256]:byte;
;

def SPTYPE_BEEP = 0;
def SPTYPE_SAMPLE = 1;

