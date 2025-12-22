include "inc/exec/libraries.inc";
include "inc/exec/ports.inc";

struct Device is
  dd_Library:Library;
;

struct Unit is
  unit_MsgPort:MsgPort;
  unit_flags:ubyte;
  unit_pad:ubyte;
  unit_OpenCnt:uword;
;

def UNITF_ACTIVE = (1<<0);
def UNITF_INTASK = (1<<1);

