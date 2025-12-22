include "inc/exec/tasks.inc";
include "inc/exec/ports.inc";
include "inc/exec/libraries.inc";
include "inc/exec/semaphores.inc";
include "inc/devices/timer.inc";
include "inc/dos/dos.inc";

struct Process is
  pr_Task:Task;
  pr_MsgPort:MsgPort;
  pr_Pad:word;
  pr_SegList:long;
  pr_StackSize:long;
  pr_GlobVec:ulong;
  pr_TaskNum:long;
  pr_StackBase:long;
  pr_Result2:long;
  pr_CurrentDir:long;
  pr_CIS:long;
  pr_COS:long;
  pr_ConsoleTask:ulong;
  pr_FileSystemTask:ulong;
  pr_CLI:long;
  pr_ReturnAddr:ulong;
  pr_PktWait:ulong;
  pr_WindowPtr:ulong;
  pr_HomeDir:long;
  pr_Flags:long;
  pr_ExitCode:ulong;
  pr_ExitData:long;
  pr_Arguments:ulong;
  pr_LocalVars:MinList;
  pr_ShellPrivate:ulong;
  pr_CES:long;
;

def PRB_FREESEGLIST = 0;
def PRF_FREESEGLIST = 1;
def PRB_FREECURRDIR = 1;
def PRF_FREECURRDIR = 2;
def PRB_FREECLI = 2;
def PRF_FREECLI = 4;
def PRB_CLOSEINPUT = 3;
def PRF_CLOSEINPUT = 8;
def PRB_CLOSEOUTPUT = 4;
def PRF_CLOSEOUTPUT = 16;
def PRB_FREEARGS = 5;
def PRF_FREEARGS = 32;

struct FileHandle is
  fh_Link:ulong;
  fh_Port:ulong;
  fh_Type:ulong;
  fh_Buf:long;
  fh_Pos:long;
  fh_End:long;
  fh_Funcs:long;
  fh_Func2:long;
  fh_Func3:long;
  fh_Args:long;
  fh_Arg2:long;
;

def fh_Func1 = fh_Funcs;
def fh_Arg1 = fh_Args;

struct DosPacket is
  dp_Link:ulong;
  dp_Port:ulong;
  dp_Type:long;
  dp_Res1:long;
  dp_Res2:long;
  dp_Arg1:long;
  dp_Arg2:long;
  dp_Arg3:long;
  dp_Arg4:long;
  dp_Arg5:long;
  dp_Arg6:long;
  dp_Arg7:long;
;

def dp_Action = dp_Type;
def dp_Status = dp_Res1;
def dp_Status2 = dp_Res2;
def dp_BufAddr = dp_Arg1;

struct StandardPacket is
  sp_Msg:Message;
  sp_Pkt:DosPacket;
;

def ACTION_NIL = 0;
def ACTION_STARTUP = 0;
def ACTION_GET_BLOCK = 2;
def ACTION_SET_MAP = 4;
def ACTION_DIE = 5;
def ACTION_EVENT = 6;
def ACTION_CURRENT_VOLUME = 7;
def ACTION_LOCATE_OBJECT = 8;
def ACTION_RENAME_DISK = 9;
def ACTION_WRITE = 'W';
def ACTION_READ = 'R';
def ACTION_FREE_LOCK = 15;
def ACTION_DELETE_OBJECT = 16;
def ACTION_RENAME_OBJECT = 17;
def ACTION_MORE_CACHE = 18;
def ACTION_COPY_DIR = 19;
def ACTION_WAIT_CHAR = 20;
def ACTION_SET_PROTECT = 21;
def ACTION_CREATE_DIR = 22;
def ACTION_EXAMINE_OBJECT = 23;
def ACTION_EXAMINE_NEXT = 24;
def ACTION_DISK_INFO = 25;
def ACTION_INFO = 26;
def ACTION_FLUSH = 27;
def ACTION_SET_COMMENT = 28;
def ACTION_PARENT = 29;
def ACTION_TIMER = 30;
def ACTION_INHIBIT = 31;
def ACTION_DISK_TYPE = 32;
def ACTION_DISK_CHANGE = 33;
def ACTION_SET_DATE = 34;

def ACTION_SCREEN_MODE = 994;

def ACTION_READ_RETURN = 1001;
def ACTION_WRITE_RETURN = 1002;
def ACTION_SEEK = 1008;
def ACTION_FINDUPDATE = 1004;
def ACTION_FINDINPUT = 1005;
def ACTION_FINDOUTPUT = 1006;
def ACTION_END = 1007;
def ACTION_SET_FILE_SIZE = 1022;
def ACTION_WRITE_PROTECT = 1023;

def ACTION_SAME_LOCK = 40;
def ACTION_CHANGE_SIGNAL = 995;
def ACTION_FORMAT = 1020;
def ACTION_MAKE_LINK = 1021;

def ACTION_READ_LINK = 1024;
def ACTION_FH_FROM_LOCK = 1026;
def ACTION_IS_FILESYSTEM = 1027;
def ACTION_CHANGE_MODE = 1028;

def ACTION_COPY_DIR_FH = 1030;
def ACTION_PARENT_FH = 1031;
def ACTION_EXAMINE_ALL = 1033;
def ACTION_EXAMINE_FH = 1034;

def ACTION_LOCK_RECORD = 2008;
def ACTION_FREE_RECORD = 2009;

def ACTION_ADD_NOTIFY = 4097;
def ACTION_REMOVE_NOTIFY = 4098;

def ACTION_EXAMINE_ALL_END = 1035;
def ACTION_SET_OWNER = 1036;

def ACTION_SERIALIZE_DISK = 4200;

struct ErrorString is
  estr_Nums:ulong;
  estr_Strings:ulong;
;

struct DosLibBase is
  dl_lib:Library;
  dl_Root:ulong;
  dl_GV:ulong;
  dl_A2:long;
  dl_A5:long;
  dl_A6:long;
  dl_Errors:ulong;
  dl_TimeReq:ulong;
  dl_UtilityBase:ulong;
  dl_IntuitionBase:ulong;
;

struct RootNode is
  rn_TaskArray:long;
  rn_ConsoleSegment:long;
  rn_Time:DateStamp;
  rn_RestartSeg:long;
  rn_Info:long;
  rn_FileHandlerSegment:long;
  rn_CliList:MinList;
  rn_BootProc:ulong;
  rn_ShellSegment:long;
  rn_Flags:long;
;

def RNB_WILDSTAR = 24;
def RNF_WILDSTAR = (1<<24);
def RNB_PRIVATE1 = 1;
def RNF_PRIVATE1 = 2;

struct CliProcList is
  cpl_Node:MinNode;
  cpl_First:long;
  cpl_Array:ulong;
;

struct DosInfo is
  di_McName:long;
  di_DevInfo:long;
  di_Devices:long;
  di_Handlers:long;
  di_NetHand:ulong;
  di_DevLock:SignalSemaphore;
  di_EntryLock:SignalSemaphore;
  di_DeleteLock:SignalSemaphore;
;

def di_ResList = di_McName;

struct Segment is
  seg_Next:long;
  seg_UC:long;
  seg_Seg:long;
  seg_Name[4]:ubyte;
;

def CMD_SYSTEM = -1;
def CMD_INTERNAL = -2;
def CMD_DISABLED = -999;

struct CommandLineInterface is
  cli_Result2:long;
  cli_SetName:long;
  cli_CommandDir:long;
  cli_ReturnCode:long;
  cli_CommandName:long;
  cli_FailLevel:long;
  cli_Prompt:long;
  cli_StandardInput:long;
  cli_CurrentInput:long;
  cli_CommandFile:long;
  cli_Interactive:long;
  cli_Background:long;
  cli_CurrentOutput:long;
  cli_DefaultStack:long;
  cli_StandardOutput:long;
  cli_Module:long;
;

struct DeviceList is
  dl_Next:long;
  dl_Type:long;
  dl_Task:ulong;
  dl_Lock:long;
  dl_VolumeDate:DateStamp;
  dl_LockList:long;
  dl_DiskType:long;
  dl_unused:long;
  dl_Name:long;
;

struct DevInfo is
  dvi_Next:long;
  dvi_Type:long;
  dvi_Task:ulong;
  dvi_Lock:long;
  dvi_Handler:long;
  dvi_StackSize:long;
  dvi_Priority:long;
  dvi_Startup:long;
  dvi_SegList:long;
  dvi_GlobVec:long;
  dvi_Name:long;
;

struct DosList is
  dol_Next:long;
  dol_Type:long;
  dol_Task:ulong;
  dol_Lock:long;
  dol_misc:union is
    dol_handler:struct is
      dol_Handler:long;
      dol_StackSize:long;
      dol_Priority:long;
      dol_Startup:ulong;
      dol_SegList:long;
      dol_GlobVec:long;
    ;
    dol_volume:struct is
      dol_VolumeDate:DateStamp;
      dol_LockList:long;
      dol_DiskType:long;
    ;
    dol_assign:struct is
      dol_AssignName:ulong;
      dol_List:ulong;
    ;
  ;
  dol_Name:long;
;

struct AssignList is
  al_Next:ulong;
  al_Lock:long;
;

def DLT_DEVICE = 0;
def DLT_DIRECTORY = 1;
def DLT_VOLUME = 2;
def DLT_LATE = 3;
def DLT_NONBINDING = 4;
def DLT_PRIVATE = -1;

struct DevProc is
  dvp_Port:ulong;
  dvp_Lock:long;
  dvp_Flags:ulong;
  dvp_DevNode:ulong;
;

def DVPB_UNLOCK = 0;
def DVPF_UNLOCK = (1<<DVPB_UNLOCK);
def DVPB_ASSIGN = 1;
def DVPF_ASSIGN = (1<<DVPB_ASSIGN);

def LDB_DEVICES = 2;
def LDF_DEVICES = (1<<LDB_DEVICES);
def LDB_VOLUMES = 3;
def LDF_VOLUMES = (1<<LDB_VOLUMES);
def LDB_ASSIGNS = 4;
def LDF_ASSIGNS = (1<<LDB_ASSIGNS);
def LDB_ENTRY = 5;
def LDF_ENTRY = (1<<LDB_ENTRY);
def LDB_DELETE = 6;
def LDF_DELETE = (1<<LDB_DELETE);

def LDB_READ = 0;
def LDF_READ = (1<<LDB_READ);
def LDB_WRITE = 1;
def LDF_WRITE = (1<<LDB_WRITE);

def LDF_ALL = (LDF_DEVICES|LDF_VOLUMES|LDF_ASSIGNS);

struct FileLock is
  fl_Link:long;
  fl_Key:long;
  fl_Access:long;
  fl_Task:ulong;
  fl_Volume:long;
;

def REPORT_STREAM = 0;
def REPORT_TASK = 1;
def REPORT_LOCK = 2;
def REPORT_VOLUME = 3;
def REPORT_INSERT = 4;

def ABORT_DISK_ERROR = 296;
def ABORT_BUSY = 288;

def RUN_EXECUTE = -1;
def RUN_SYSTEM = -2;
def RUN_SYSTEM_ASYNCH = -3;

def ST_ROOT = 1;
def ST_USERDIR = 2;
def ST_SOFTLINK = 3;
def ST_LINKDIR = 4;
def ST_FILE = -3;
def ST_LINKFILE = -4;
def ST_PIPEFILE = -5;

