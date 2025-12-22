with System; use System;
with Interfaces; use Interfaces;

with Incomplete_Type; use Incomplete_Type;

with exec_Nodes; use exec_Nodes;
with exec_Lists; use exec_Lists;

package exec_Ports is

type MsgPort;
type MsgPort_Ptr is access MsgPort;

type MsgPort is
	record
		mp_Node : Node;
		mp_Flags : Integer_8;
		mp_SigBit : Integer_8;
		mp_SigTask : AmigaTask_Ptr;
		mp_MsgList : List;
	end record;

type Message;
type Message_Ptr is access Message;

type Message is record
	A_Node : Node;
	ReplyPort : System.Address;
	Length : Integer_16;
end record;

end exec_Ports;