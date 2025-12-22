include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct PrefHeader is
  ph_Version:ubyte;
  ph_Type:ubyte;
  ph_Flags:ulong;
;

