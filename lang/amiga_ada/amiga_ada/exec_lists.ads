with System; use System;
with Interfaces; use Interfaces;
with Incomplete_Type; use Incomplete_Type;
with exec_Nodes; use exec_Nodes;

package exec_Lists is

type List;
type List_Ptr is access List;
NullList_Ptr : constant List_Ptr := Null;

type List is
	record
		lh_Head : Node_Ptr;
		lh_Tail : Node_Ptr;
		lh_TailPred : Node_Ptr;
		lh_Type_Pad : Integer_16;
	end record;

type MinList;
type MinList_Ptr is access MinList;
NullMinList_Ptr : constant MinList_Ptr := Null;
type MinList is record
   mlh_Head : MinNode_Ptr;
   mlh_Tail : MinNode_Ptr;
   mlh_TailPred : MinNode_Ptr;
end record;

end exec_Lists;
