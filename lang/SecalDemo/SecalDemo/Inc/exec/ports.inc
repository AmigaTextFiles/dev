include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/tasks.inc";

struct MsgPort is
  mp_Node:Node;
  mp_Flags:ubyte;
  mp_SigBit:ubyte;
  mp_SigTask:ulong;
  mp_MsgList:List;
;

def mp_SoftInt = mp_SigTask;

def PF_ACTION = 3;
def PA_SIGNAL = 0;
def PA_SOFTINT = 1;
def PA_IGNORE = 2;

struct Message is
  mn_Node:Node;
  mn_ReplyPort:ulong;
  mn_Length:uword;
;

