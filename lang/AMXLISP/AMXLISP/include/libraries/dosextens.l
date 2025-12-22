(Process (pr_Task 0 Task) (pr_MsgPort 92 MsgPort) (pr_Pad 126 . 2) (
pr_SegList 128 . 4) (pr_StackSize 132 . 4) (pr_GlobVec 136 byte . t) (
pr_TaskNum 140 . 4) (pr_StackBase 144 . 4) (pr_Result2 148 . 4) (
pr_CurrentDir 152 . 4) (pr_CIS 156 . 4) (pr_COS 160 . 4) (pr_ConsoleTask 
164 byte . t) (pr_FileSystemTask 168 byte . t) (pr_CLI 172 . 4) (
pr_ReturnAddr 176 byte . t) (pr_PktWait 180 byte . t) (pr_WindowPtr 184 
byte . t))

(FileHandle (fh_Link 0 Message . t) (fh_Port 4 MsgPort . t) (fh_Type 8 
MsgPort . t) (fh_Buf 12 . 4) (fh_Pos 16 . 4) (fh_End 20 . 4) (fh_Funcs 24 .
4) (fh_Func2 28 . 4) (fh_Func3 32 . 4) (fh_Args 36 . 4) (fh_Arg2 40 . 4))

(DosPacket (dp_Link 0 Message . t) (dp_Port 4 MsgPort . t) (dp_Type 8 . 4) 
(dp_Res1 12 . 4) (dp_Res2 16 . 4) (dp_Arg1 20 . 4) (dp_Arg2 24 . 4) (
dp_Arg3 28 . 4) (dp_Arg4 32 . 4) (dp_Arg5 36 . 4) (dp_Arg6 40 . 4) (dp_Arg7
44 . 4))

(StandardPacket (sp_Msg 0 Message) (sp_Pkt 20 DosPacket))

(DosLibrary (dl_lib 0 Library) (dl_Root 34 byte . t) (dl_GV 38 byte . t) (
dl_A2 42 . 4) (dl_A5 46 . 4) (dl_A6 50 . 4))

(RootNode (rn_TaskArray 0 . 4) (rn_ConsoleSegment 4 . 4) (rn_Time 8 
DateStamp) (rn_RestartSeg 20 . 4) (rn_Info 24 . 4) (rn_FileHandlerSegment 
28 . 4))

(DosInfo (di_McName 0 . 4) (di_DevInfo 4 . 4) (di_Devices 8 . 4) (
di_Handlers 12 . 4) (di_NetHand 16 byte . t))

(CommandLineInterface (cli_Result2 0 . 4) (cli_SetName 4 . 4) (
cli_CommandDir 8 . 4) (cli_ReturnCode 12 . 4) (cli_CommandName 16 . 4) (
cli_FailLevel 20 . 4) (cli_Prompt 24 . 4) (cli_StandardInput 28 . 4) (
cli_CurrentInput 32 . 4) (cli_CommandFile 36 . 4) (cli_Interactive 40 . 4) 
(cli_Background 44 . 4) (cli_CurrentOutput 48 . 4) (cli_DefaultStack 52 . 4
) (cli_StandardOutput 56 . 4) (cli_Module 60 . 4))

(DeviceList (dl_Next 0 . 4) (dl_Type 4 . 4) (dl_Task 8 MsgPort . t) (
dl_Lock 12 . 4) (dl_VolumeDate 16 DateStamp) (dl_LockList 28 . 4) (
dl_DiskType 32 . 4) (dl_unused 36 . 4) (dl_Name 40 long . t))

(FileLock (fl_Link 0 . 4) (fl_Key 4 . 4) (fl_Access 8 . 4) (fl_Task 12 
MsgPort . t) (fl_Volume 16 . 4))

