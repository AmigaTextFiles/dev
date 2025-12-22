type
ÑLibrary_tÅ=ÅunknownÅ34;

*charÅEXPANSIONNAMEÅ=Å"expansion.library";

uint
ÑADNB_STARTPROCÜ=Å0,
ÑADNF_STARTPROCÜ=Å1Å<<ÅADNB_STARTPROC;

extern
ÑOpenExpansionLibrary(ulongÅversion)*Library_t,
ÑCloseExpansionLibrary()void,
ÑAddDosNode(longÅbootPri;ÅulongÅflags;Å*DeviceNode_tÅdeviceNode)bool,
ÑMakeDosNode(*ulongÅparameterPkt)*DeviceNode_t,
ÑAddConfigDev(*ConfigDev_tÅconfigDev)void,
ÑAllocBoardMem(ulongÅslotSpec)long,
ÑAllocConfigDev()*ConfigDev_t,
ÑAllocExpansionMem(ulongÅnumSlots,ÅslotOffset)long,
ÑConfigBoard(ulongÅboard;Å*ConfigDev_tÅconfigDev)bool,
ÑConfigChain(ulongÅbaseAddr)bool,
ÑFindConfigDev(*ConfigDev_tÅoldConfigDev;ÅlongÅmanu,Åproduct)*ConfigDev_t,
ÑFreeBoardMem(ulongÅstartSlot,ÅslotSpec)void,
ÑFreeConfigDev(*ConfigDev_tÅconfigDev)void,
ÑFreeExpansionMem(longÅstartSlot;ÅulongÅnumSlots)void,
ÑGetCurrentBinding(*CurrentBinding_tÅcurrentBinding;ÅulongÅsize)uint,
ÑObtainConfigBinding()void,
ÑReadExpansionByte(*byteÅboard;ÅulongÅoffset)int,
ÑReadExpansionRom(*byteÅboard;Å*ConfigDev_tÅconfigDev)bool,
ÑReleaseConfigBinding()void,
ÑRemConfigDev(*ConfigDev_tÅconfigDev)void,
ÑSetCurrentBinding(*CurrentBinding_tÅcurrentBinding;ÅulongÅsize)void,
ÑWriteExpansionByte(*byteÅboard;ÅulongÅoffset,ÅbyteVal)bool;
