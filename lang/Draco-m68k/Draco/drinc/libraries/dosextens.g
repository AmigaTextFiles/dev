type
„Task_t=unknown92,
„MsgPort_t=unknown34,
„Message_t=unknown20,
„Library_t=unknown34,
„BPTR=unknown4,
„Handle_t=unknown4,
„Lock_t=unknown4,
„Segment_t=unknown4,

„BSTR=ulong,

„Process_t=struct{
ˆTask_tpr_Task;
ˆMsgPort_tpr_MsgPort;
ˆuintpr_Pad;
ˆSegment_tpr_SegList;
ˆulongpr_StackSize;
ˆ*bytepr_GlobVec;
ˆulongpr_TaskNum;
ˆBPTRpr_StackBase;
ˆulongpr_Result2;
ˆLock_tpr_CurrentDir;
ˆHandle_tpr_CIS;
ˆHandle_tpr_COS;
ˆ*Process_tpr_ConsoleTask;
ˆ*Process_tpr_FileSystemTask;
ˆSegment_tpr_CLI;
ˆ*bytepr_ReturnAddr;
ˆ*bytepr_PktWait;
ˆ*Window_tpr_WindowPtr;
„},

„FileHandle_t=struct{
ˆ*Message_tfh_Link;
ˆ*MsgPort_tfh_Port;
ˆ*MsgPort_tfh_Type;
ˆBPTRfh_Buf;
ˆulongfh_Pos;
ˆulongfh_End;
ˆulongfh_Func1,fh_Func2,fh_Func3;
ˆulongfh_Arg1,fh_Arg2;
„},

„DosPacket_t=struct{
ˆ*Message_tdp_Link;
ˆ*MsgPort_tdp_Port;
ˆulongdp_Type;
ˆulongdp_Res1,dp_Res2;
ˆulongdp_Arg1,dp_Arg2,dp_Arg3,dp_Arg4,dp_Arg5,dp_Arg6,dp_Arg7;
„},

„StandardPacket_t=struct{
ˆMessage_tsp_Msg;
ˆDosPacket_tsp_Pkt;
„};

ulong
„ACTION_NIL’=0,
„ACTION_GET_BLOCKŒ=2,
„ACTION_SET_MAP=4,
„ACTION_DIE’=5,
„ACTION_EVENT=6,
„ACTION_CURRENT_VOLUME‡=7,
„ACTION_LOCATE_OBJECTˆ=8,
„ACTION_RENAME_DISKŠ=9,
„ACTION_WRITE='W'-'\e',
„ACTION_READ‘='R'-'\e',
„ACTION_FREE_LOCKŒ=15,
„ACTION_DELETE_OBJECTˆ=16,
„ACTION_RENAME_OBJECTˆ=17,

„ACTION_MORE_CACHE‹=18,

„ACTION_COPY_DIR=19,
„ACTION_WAIT_CHARŒ=20,
„ACTION_SET_PROTECTŠ=21,
„ACTION_CREATE_DIR‹=22,
„ACTION_EXAMINE_OBJECT‡=23,
„ACTION_EXAMINE_NEXT‰=24,
„ACTION_DISK_INFOŒ=25,
„ACTION_INFO‘=26,

„ACTION_FLUSH=27,

„ACTION_SET_COMMENTŠ=28,
„ACTION_PARENT=29,
„ACTION_TIMER=30,
„ACTION_INHIBIT=31,
„ACTION_DISK_TYPEŒ=32,
„ACTION_DISK_CHANGEŠ=33,

„ACTION_SET_DATE=34,

„ACTION_SCREEN_MODEŠ=994;

type
„DosLibrary_t=struct{
ˆLibrary_tdl_lib;
ˆ*RootNode_tdl_Root;
ˆ*bytedl_GV;
ˆulongdl_A2,dl_A5,dl_A6;
„},

„RootNode_t=struct{
ˆBPTRrn_TaskArray;
ˆSegment_trn_ConsoleSegment;
ˆDateStamp_trn_Time;
ˆSegment_trn_RestartSeg;
ˆBPTRrn_Info;
ˆSegment_trn_FileHandlerSegment;
„},

„DosInfo_t=struct{
ˆBPTRdi_McName;
ˆBPTRdi_DevInfo;
ˆBPTRdi_Devices;
ˆBPTRdi_Handlers;
ˆ*Process_tdi_NetHand;
„},

„CommandLineInterface_t=struct{
ˆulongcli_Result2;
ˆBSTRcli_SetName;
ˆLock_tcli_CommandDir;
ˆulongcli_ReturnCode;
ˆBSTRcli_CommandName;
ˆulongcli_FailLevel;
ˆBSTRcli_Prompt;
ˆHandle_tcli_StandardInput;
ˆHandle_tcli_CurrentInput;
ˆBSTRcli_CommandFile;
ˆulongcli_Interactive;
ˆulongcli_Background;
ˆHandle_tcli_CurrentOutput;
ˆulongcli_DefaultStack;
ˆHandle_tcli_StandardOutput;
ˆSegment_tcli_Module;
„},

„DeviceList_t=struct{
ˆBPTRdl_Next;
ˆulongdl_Type;
ˆ*MsgPort_tdl_Task;
ˆLock_tdl_Lock;
ˆDateStamp_tdl_VolumeDate;
ˆBPTRdl_LockList;
ˆulongdl_DiskType;
ˆulongdl_unused;
ˆBSTRdl_Name;
„};

ulong
„DLT_DEVICEŠ=0,
„DLT_DIRECTORY‡=1,
„DLT_VOLUMEŠ=2;

type
„FileLock_t=struct{
ˆBPTRfl_Link;
ˆulongfl_Key;
ˆlongfl_Access;
ˆ*MsgPort_tfl_Task;
ˆBPTRfl_Volume;
„};
