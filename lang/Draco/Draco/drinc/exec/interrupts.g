type
„Node_t=unknown14,
„List_t=unknown14,

„Interrupt_t=struct{
ˆNode_tis_Node;
ˆarbptris_Data;
ˆproc()voidis_Code;
„},

„IntVector_t=struct{
ˆarbptriv_Data;
ˆproc()voidiv_Code;
ˆ*Node_tiv_Node;
„},

„SoftIntList_t=struct{
ˆList_tsh_List;
ˆuintsh_Pad;
„};

uint
„SIH_PRIMASK=0xf0,

„INTB_NMI„=15,
„INTF_NMI„=1<<15;

extern
„AddIntServer(ulongintNum;*Interrupt_ti)void,
„Cause(*Interrupt_tinterrupt)void,
„RemIntServer(ulongintNum;*Interrupt_ti)void,
„SetIntVector(ulongintNum;*Interrupt_ti)*Interrupt_t;
