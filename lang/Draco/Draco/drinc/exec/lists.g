type
„List_t=struct{
ˆ*Node_tlh_Head;
ˆ*Node_tlh_Tail;
ˆ*Node_tlh_TailPred;
ˆbytelh_Type;
ˆbytel_pad;
„},

„MinList_t=struct{
ˆ*MinNode_tmlh_Head;
ˆ*MinNode_tmlh_Tail;
ˆ*MinNode_tmlh_TailPred;
„};

extern
„AddHead(*List_tlist;*Node_tnode)void,
„AddTail(*List_tlist;*Node_tnode)void,
„Enqueue(*List_tlist;*Node_tnode)void,
„FindName(*List_tlist;*charname)*Node_t,
„Insert(*List_tlist;*Node_tnode;*List_tlistNode)void,
„NewList(*List_tlist)void,
„RemHead(*List_tlist)*Node_t,
„Remove(*Node_tnode)void,
„RemTail(*List_tlist)*Node_t;
