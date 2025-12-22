include "inc/exec/nodes.inc";

struct ExtendedNode is
  xln_Succ:ulong;
  xln_Pred:ulong;
  xln_Type:ubyte;
  xln_Pri:byte;
  xln_Name:ulong;
  xln_Subsystem:ubyte;
  xln_Subtype:ubyte;
  xln_Library:long;
  xln_Init:ulong;
;

def SS_GRAPHICS = $02;

def VIEW_EXTRA_TYPE = 1;
def VIEWPORT_EXTRA_TYPE = 2;
def SPECIAL_MONITOR_TYPE = 3;
def MONITOR_SPEC_TYPE = 4;

