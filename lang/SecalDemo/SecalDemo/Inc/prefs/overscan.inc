include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";
include "inc/graphics/gfx.inc";

def OSCAN_MAGIC = $fedcba89;

struct OverscanPrefs is
  os_Reserved:ulong;
  os_Magic:ulong;
  os_HStart:uword;
  os_HStop:uword;
  os_VStart:uword;
  os_VStop:uword;
  os_DisplayID:ulong;
  os_ViewPos:Point;
  os_Text:Point;
  os_Standard:Rectangle;
;

