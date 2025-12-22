type
„Node_t=unknown14,
„List_t=unknown14,

„MsgPort_t=struct{
ˆNode_tmp_Node;
ˆshortmp_Flags;
ˆshortmp_SigBit;
ˆ*Task_tmp_SigTask;
ˆList_tmp_MsgList;
„};

byte
„PF_ACTION‰=3,

„PA_SIGNAL‰=0,
„PA_SOFTINTˆ=1,
„PA_IGNORE‰=2;

type
„Message_t=struct{
ˆNode_tmn_Node;
ˆ*MsgPort_tmn_ReplyPort;
ˆuintmn_Length;
„};

extern
„AddPort(*MsgPort_tport)void,
„CreatePort(*charname;shortpri)*MsgPort_t,
„DeletePort(*MsgPort_tport)void,
„FindPort(*charname)*MsgPort_t,
„GetMsg(*MsgPort_tport)*Message_t,
„PutMsg(*MsgPort_tport;*Message_tmsg)void,
„RemPort(*MsgPort_tport)void,
„ReplyMsg(*Message_tmsg)void,
„WaitPort(*MsgPort_tport)*Message_t;
