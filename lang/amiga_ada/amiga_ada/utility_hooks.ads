with System; use System;

with exec_nodes; use exec_nodes;

with incomplete_type; use incomplete_type;

package utility_hooks is

--#ifndef EXEC_TYPES_H
--#include "exec/types.h"
--#endif
--
--#ifndef EXEC_NODES_H
--#include "exec/nodes.h"
--#endif
--
--
type Hook;
type Hook_Ptr is access Hook;
type Hook is record
   h_MinNode : MinNode;
   h_Entry : System.Address;
   h_SubEntry : System.Address;
   h_Data : Integer_Ptr;
end record;

end utility_hooks;