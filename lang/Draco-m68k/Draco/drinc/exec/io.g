type
„Message_t=unknown20,

„IORequest_t=struct{
ˆMessage_tio_Message;
ˆ*Device_tio_Device;
ˆ*Unit_tio_Unit;
ˆuintio_Command;
ˆushortio_Flags;
ˆshortio_Error;
„},

„IOStdReq_t=struct{
ˆIORequest_tio_io;
ˆulongio_Actual;
ˆulongio_Length;
ˆ*byteio_Data;
ˆulongio_Offset;
„};

long
„DEV_BEGINIO=-30,
„DEV_ABORTIO=-36;

ushort
„IOB_QUICK=0,
„IOF_QUICK=1<<0;

uint
„CMD_INVALID=0,
„CMD_RESETƒ=1,
„CMD_READ„=2,
„CMD_WRITEƒ=3,
„CMD_UPDATE‚=4,
„CMD_CLEARƒ=5,
„CMD_STOP„=6,
„CMD_STARTƒ=7,
„CMD_FLUSHƒ=8,

„CMD_NONSTD‚=9;

extern
„AbortIO(*IORequest_tio)ulong,
„BeginIO(*IORequest_tio)void,
„CheckIO(*IORequest_tio)*IORequest_t,
„CloseDevice(*IORequest_tio)void,
„CreateExtIO(*MsgPort_tioReplyPort;ulongsize)*IORequest_t,
„CreateStdIO(*MsgPort_tioReplyPort)*IOStdReq_t,
„DeleteExtIO(*IORequest_tioExt;ulongsize)void,
„DeleteStdIO(*IOStdReq_tioStdReq)void,
„DoIO(*IORequest_tio)ulong,
„OpenDevice(*chardevName;ulongunitNo;*IORequest_tio;ulongflags)ulong,
„SendIO(*IORequest_tio)void,
„WaitIO(*IORequest_tio)ulong;
