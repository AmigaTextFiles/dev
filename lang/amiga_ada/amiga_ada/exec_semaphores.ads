with Interfaces; use Interfaces;

with Incomplete_Type; use Incomplete_Type;

with exec_Nodes; use exec_Nodes;
with exec_Ports; use exec_Ports;
with exec_Lists; use exec_Lists;

--#ifndef EXEC_NODES_H
--#include "exec/nodes.h"
--#endif 
--
--#ifndef EXEC_LISTS_H
--#include "exec/lists.h"
--#endif 
--
--#ifndef EXEC_PORTS_H
--#include "exec/ports.h"
--#endif 
--
--#ifndef EXEC_TASKS_H
--#include "exec/tasks.h"
--#endif 

package exec_semaphores is

type SemaphoreRequest;
type SemaphoreRequest_Ptr is access SemaphoreRequest;
NullSemaphoreRequest_Ptr : constant SemaphoreRequest_Ptr := Null;
type SemaphoreRequest is record
   sr_Link : MinNode;
   sr_Waiter : AmigaTask_Ptr;
end record;

type SignalSemaphore;
type SignalSemaphore_Ptr is access SignalSemaphore;
NullSignalSemaphore_Ptr : constant SignalSemaphore_Ptr := Null;
type SignalSemaphore is record
   ss_Link : Node;
   ss_NestCount : Integer_16;
   ss_WaitQueue : MinList;
   ss_MultipleLink : SemaphoreRequest;
   ss_Owner : AmigaTask_Ptr;
   ss_QueueCount : Integer_16;
end record;

type Semaphore;
type Semaphore_Ptr is access Semaphore;
NullSemaphore_Ptr : constant Semaphore_Ptr := Null;
type Semaphore is record
   sm_MsgPort : MsgPort;
   sm_Bids : Integer_16;
end record;

--sm_LockMsg : constant Unsigned_32 := mp_SigTask;

end exec_Semaphores;