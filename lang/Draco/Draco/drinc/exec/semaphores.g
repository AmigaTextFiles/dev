type
„MsgPort_t=unknown34,
„MinNode_t=unknown8,
„Node_t=unknown14,

„Semaphore_t=struct{
ˆMsgPort_tsm_MsgPort;
ˆuintsm_Bids;
„},

„SemaphoreRequest_t=struct{
ˆMinNode_tsr_Link;
ˆ*Task_tsr_Waiter;
„},

„SignalSemaphore_t=struct{
ˆNode_tss_Link;
ˆuintss_NestCount;
ˆMinList_tss_WaitQueue;
ˆSemaphoreRequest_tss_MultipleLink;
ˆ*Task_tss_Owner;
ˆuintss_QueueCount;
„};

extern
„AddSemaphore(*SignalSemaphore_tss)void,
„AttemptSemaphore(*SignalSemaphore_tss)bool,
„FindSemaphore(*charname)*SignalSemaphore_t,
„InitSemaphore(*SignalSemaphore_tss)void,
„ObtainSemaphore(*SignalSemaphore_tss)void,
„ObtainSemaphoreList(*SignalSemaphore_tss)void,
„Procure(*Semaphore_tsm;*Message_tbidMessage)bool,
„ReleaseSemaphore(*SignalSemaphore_tss)void,
„ReleaseSemaphoreList(*SignalSemaphore_tss)void,
„RemSemaphore(*SignalSemaphore_tss)void,
„Vacate(*Semaphore_tsm)void;
