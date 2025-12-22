include "inc/exec/types.inc";
include "inc/exec/nodes.inc";

struct Hook is
  h_MinNode:MinNode;
  h_Entry:ulong;
  h_SubEntry:ulong;
  h_Data:ulong;
;

