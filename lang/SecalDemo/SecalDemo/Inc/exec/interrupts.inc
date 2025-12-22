include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";

struct Interrupt is
  is_Node:Node;
  is_Data:ulong;
  is_Code:ulong;
;

struct IntVector is
  iv_Data:ulong;
  iv_Code:ulong;
  iv_Node:ulong;
;

struct SoftIntList is
  sh_List:List;
  sh_Pad:uword;
;

def SIH_PRIMASK = ($f0);

def INTB_NMI = 15;
def INTF_NMI = (1<<15);

