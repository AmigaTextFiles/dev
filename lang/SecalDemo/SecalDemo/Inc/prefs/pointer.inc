include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";

struct PointerPrefs is
  pp_Reserved[4]:ulong;
  pp_Which:uword;
  pp_Size:uword;
  pp_Width:uword;
  pp_Height:uword;
  pp_Depth:uword;
  pp_YSize:uword;
  pp_X,pp_Y:uword;
;

def WBP_NORMAL = 0;
def WBP_BUSY = 1;

struct RGBTable is
  t_Red:ubyte;
  t_Green:ubyte;
  t_Blue:ubyte;
;

