include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";
include "inc/exec/tasks.inc";

struct SemaphoreRequest is
  sr_Link:MinNode;
  sr_Waiter:ulong;
;

struct SignalSemaphore is
  ss_Link:Node;
  ss_NestCount:word;
  ss_WaitQueue:MinList;
  ss_MultipleLink:SemaphoreRequest;
  ss_Owner:ulong;
  ss_QueueCount:word;
;

struct SemaphoreMessage is
  ssm_Message:Message;
  ssm_Semaphore:ulong;
;

def SM_SHARED = (1);
def SM_EXCLUSIVE = (0);

struct Semaphore is
  sm_MsgPort:MsgPort;
  sm_Bids:word;
;

def sm_LockMsg = mp_SigTask;

