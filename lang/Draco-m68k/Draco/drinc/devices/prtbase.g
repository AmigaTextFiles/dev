uintP_STKSIZE=0x800;

type
„Library_t=unknown34,
„MsgPort_t=unknown34,
„Segment_t=unknown4,
„IOExtPar_t=unknown62,
„IOExtSer_t=unknown82,
„timerequest_t=unknown40,
„Task_t=unknown92,
„Preferences_t=unknown224,
„Segment_t=unknown4,

„DeviceData_t=struct{
ˆLibrary_tdd_Device;
ˆ*bytedd_Segment;
ˆ*bytedd_ExecBase;
ˆ*bytedd_CmdVectors;
ˆ*bytedd_CmdBytes;
ˆuintdd_NumCommands;
„},

„PrinterData_t=struct{
ˆDeviceData_tpd_Device;
ˆMsgPort_tpd_Unit;
ˆSegment_tpd_PrinterSegment;
ˆuintpd_PrinterType;
ˆ*PrinterSegment_tpd_SegmentData;
ˆ*bytepd_PrintBuf;
ˆproc()intpd_PWrite;
ˆproc()intpd_PBothReady;
ˆunion{
ŒIOExtPar_tpd_p0;
ŒIOExtSer_tpd_s0;
ˆ}pd_ior0;
ˆunion{
ŒIOExtPar_tpd_p1;
ŒIOExtSer_tpd_s1;
ˆ}pd_ior1;
ˆtimerequest_tpd_TIOR;
ˆMsgPort_tpd_IORPort;
ˆTask_tpd_TC;
ˆ[P_STKSIZE]bytepd_Stk;
ˆushortpd_Flags;
ˆushortpd_pad;
ˆPreferences_tpd_Preferences;
ˆushortpd_PWaitEnabled;
„},

„PrinterExtendedData_t=struct{
ˆ*charped_PrinterName;
ˆproc()voidped_Init,ped_Expunge,ped_Open,ped_Close;
ˆushortped_PrinterClass,ped_ColorClass,ped_MaxColums,ped_NumCharSets;
ˆuintped_NumRows;
ˆulongped_MaxXDots,ped_MaxYDots;
ˆuintped_XDotsInch,ped_YDotsInch;
ˆ***charped_Commands;
ˆproc()intped_DoSpecial,ped_Render;
ˆulongped_TimeoutSecs;
ˆ**charped_8BitChars;
„},

„PrinterSegment_t=struct{
ˆSegment_tps_NextSegment;
ˆulongps_runAlert;
ˆuintps_Version,ps_Revision;
ˆPrinterExtendedData_tps_PED;
„};

ushort
„PPCB_GFXŒ=0,
„PPCF_GFXŒ=1<<PPCB_GFX,
„PPCB_COLORŠ=1,
„PPCF_COLORŠ=1<<PPCB_COLOR,

„PPC_BWALPHA‰=0,
„PPC_BWGFX‹=1,
„PPC_COLORGFXˆ=3,

„PCC_BW=1,
„PCC_YMC=2,
„PCC_YMC_BWŠ=3,
„PCC_YMCBŒ=4,

„PCC_4COLORŠ=0x4,
„PCC_ADDITIVEˆ=0x8,

„PCC_WB=0x9,
„PCC_BGR=0xa,
„PCC_BGR_WBŠ=0xb,
„PCC_BGRWŒ=0xc;
