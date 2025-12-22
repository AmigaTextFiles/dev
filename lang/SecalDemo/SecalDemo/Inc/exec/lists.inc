include "inc/exec/nodes.inc";

struct List is
  lh_Head:ulong;
  lh_Tail:ulong;
  lh_TailPred:ulong;
  lh_Type:ubyte;
  l_pad:ubyte;
;

struct MinList is
  mlh_Head:ulong;
  mlh_Tail:ulong;
  mlh_TailPred:ulong;
;

