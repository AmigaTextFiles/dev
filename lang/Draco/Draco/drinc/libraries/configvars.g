type
„Node_t=unknown14,
„ExpansionRom_t=unknown16,

„ConfigDev_t=struct{
ˆNode_tcd_Node;
ˆushortcd_Flags;
ˆushortcd_Pad;
ˆExpansionRom_tcd_Rom;
ˆulongcd_BoardAddr;
ˆulongcd_BoardSize;
ˆuintcd_SlotAddr;
ˆuintcd_SlotSize;
ˆ*bytecd_Driver;
ˆ*ConfigDev_tcd_NextCD;
ˆ[4]ulongcd_Unused;
„},

„CurrentBinding_t=struct{
ˆ*ConfigDev_tcb_ConfigDev;
ˆ*charcb_FileName;
ˆ*charcb_ProductString;
ˆ**charcb_ToolTypes;
„};

ushort
„CDB_SHUTUPŠ=0,
„CDB_CONFIGMEˆ=1,

„CDF_SHUTUPŠ=0x01,
„CDF_CONFIGMEˆ=0x02;
