include "inc/exec/types.inc";
include "inc/exec/libraries.inc";

def UTILITYNAME = "utility.library";

struct UtilityLibBase is
  ub_LibNode:Library;
  ub_Language:ubyte;
  ub_Reserved:ubyte;
;

