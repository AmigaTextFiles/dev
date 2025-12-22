with System; use System;
with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with Incomplete_Type; use Incomplete_Type;

package exec_Nodes is

type Node;
type Node_Ptr is access Node;

type Node is record
	ln_Succ : Node_Ptr;
	ln_Pred : Node_Ptr;
	ln_Type_Pri : Integer_16;
	ln_Name : Chars_Ptr;
end record;

type MinNode;
type MinNode_Ptr is access MinNode;
NullMinNode_Ptr : constant MinNode_Ptr := Null;
type MinNode is record
   mln_Succ : MinNode_Ptr;
   mln_Pred : MinNode_Ptr;
end record;

NT_UNKNOWN	: constant Unsigned_32 := 0;
NT_TASK		: constant Unsigned_32 := 1;
NT_INTERRUPT	: constant Unsigned_32 := 2;
NT_DEVICE	: constant Unsigned_32 := 3;
NT_MSGPORT	: constant Unsigned_32 := 4;
NT_MESSAGE	: constant Unsigned_32 := 5;
NT_FREEMSG	: constant Unsigned_32 := 6;
NT_REPLYMSG	: constant Unsigned_32 := 7;
NT_RESOURCE	: constant Unsigned_32 := 8;
NT_LIBRARY	: constant Unsigned_32 := 9;
NT_MEMORY	: constant Unsigned_32 := 10;
NT_SOFTINT	: constant Unsigned_32 := 11;
NT_FONT		: constant Unsigned_32 := 12;
NT_PROCESS	: constant Unsigned_32 := 13;
NT_SEMAPHORE	: constant Unsigned_32 := 14;
NT_SIGNALSEM	: constant Unsigned_32 := 15;
NT_BOOTNODE	: constant Unsigned_32 := 16;
NT_KICKMEM	: constant Unsigned_32 := 17;
NT_GRAPHICS	: constant Unsigned_32 := 18;
NT_DEATHMESSAGE	: constant Unsigned_32 := 19;
NT_USER		: constant Unsigned_32 := 254;
NT_EXTENDED	: constant Unsigned_32 := 255;

end exec_Nodes;

