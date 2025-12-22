include "inc/utility/hooks.inc";
include "inc/intuition/classusr.inc";

struct Class is
  cl_Dispatcher:Hook;
  cl_Reserved:ulong;
  cl_Super:ulong;
  cl_ID:ulong;
  cl_InstOffset:uword;
  cl_InstSize:uword;
  cl_UserData:ulong;
  cl_SubclassCount:ulong;
  cl_ObjectCount:ulong;
  cl_Flags:ulong;
;

def CLF_INLIST = $00000001;

struct _Object is
  o_Node:MinNode;
  o_Class:ulong;
;

