uint
„COPPER_MOVE=0,
„COPPER_WAIT=1,
„CPRNXTBUFƒ=2,
„CPR_NT_LOF‚=0x8000,
„CPR_NT_SHT‚=0x4000;

type
„CopIns_t=struct{
ˆuintci_OpCode;
ˆunion{
Œ*CopList_tci_nxtlist;
Œstruct{
union{
”uintci_VWaitPos;
”uintci_DestAddr;
}u1;
union{
”uintci_HWaitPos;
”uintci_DestData;
}u2;
Œ}u4;
ˆ}u3;
„},

„cprlist_t=struct{
ˆ*cprlist_tcprl_Next;
ˆ*uintcprl_start;
ˆuintcprl_MaxCount;
„},

„CopList_t=struct{
ˆ*CopList_tcl_Next;
ˆ*CopList_tcl__CopList;
ˆ*ViewPort_tcl__ViewPort;
ˆ*CopIns_tcl_CopIns;
ˆ*CopIns_tcl_CopPtr;
ˆ*uintcl_CopLStart;
ˆ*uintcl_CopSStart;
ˆuintcl_Count;
ˆuintcl_MaxCount;
ˆuintcl_DyOffset;
„},

„UCopList_t=struct{
ˆ*UCopList_tucl_Next;
ˆ*CopList_tucl_FirstCopList;
ˆ*CopList_tucl_CopList;
„},

„copinit_t=struct{
ˆ[4]uintci_diagstrt;
ˆ[(2*8*2)+2+(2*2)+2]uintci_sprstrtup;
ˆ[2]uintci_sprstop;
„};

extern
„CBump(*UCopList_tucl)void,
„FreeCopList(*CopList_tcl)void,
„FreeCprList(*cprlist_tcl)void;
