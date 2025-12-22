(DeviceData (dd_Device 0 Library) (dd_Segment 34 byte . t) (dd_ExecBase 38 
byte . t) (dd_CmdVectors 42 byte . t) (dd_CmdBytes 46 byte . t) (
dd_NumCommands 50 . 2))

(PrinterData (pd_Device 0 DeviceData) (pd_Unit 52 MsgPort) (
pd_PrinterSegment 86 . 4) (pd_PrinterType 90 . 2) (pd_SegmentData 92 
PrinterSegment . t) (pd_PrintBuf 96 byte . t) (pd_PWrite 100 (int) . t) (
pd_PBothReady 104 (int) . t) (pd_ior0 union 108 ((0 0 IOExtPar) (0 62 
IOExtSer))) (pd_ior1 union 190 ((0 0 IOExtPar) (0 62 IOExtSer))) (pd_TIOR 
272 timerequest) (pd_IORPort 312 MsgPort) (pd_TC 346 Task) (pd_Stk 438 2048
. 1) (pd_Flags 2486 . 1) (pd_pad 2487 . 1) (pd_Preferences 2488 Preferences
) (pd_PWaitEnabled 2720 . 1))

(PrinterExtendedData (ped_PrinterName 0 byte . t) (ped_Init 4 (VOID) . t) (
ped_Expunge 8 (VOID) . t) (ped_Open 12 (int) . t) (ped_Close 16 (VOID) . t)
(ped_PrinterClass 20 . 1) (ped_ColorClass 21 . 1) (ped_MaxColumns 22 . 1) (
ped_NumCharSets 23 . 1) (ped_NumRows 24 . 2) (ped_MaxXDots 26 . 4) (
ped_MaxYDots 30 . 4) (ped_XDotsInch 34 . 2) (ped_YDotsInch 36 . 2) (
ped_Commands 38 byte . t) (ped_DoSpecial 42 (int) . t) (ped_Render 46 (int)
. t) (ped_TimeoutSecs 50 . 4) (ped_8BitChars 54 byte . t))

(PrinterSegment (ps_NextSegment 0 . 4) (ps_runAlert 4 . 4) (ps_Version 8 . 
2) (ps_Revision 10 . 2) (ps_PED 12 PrinterExtendedData))

