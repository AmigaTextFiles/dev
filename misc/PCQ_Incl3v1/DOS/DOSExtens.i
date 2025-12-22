{
        DOSExtens.i for PCQ Pascal

        DOS structures not needed for the casual AmigaDOS user
}

{$I   "Include:Exec/Tasks.i"}
{$I   "Include:Exec/Ports.i"}
{$I   "Include:Exec/Libraries.i"}
{$I   "Include:Exec/Semaphores.i"}
{$I   "Include:Devices/Timer.i"}
{$I   "Include:DOS/DOS.i"}


Type

{ All DOS processes have this structure }
{ Create and Device Proc returns pointer to the MsgPort in this structure }
{ dev_proc = Address(Integer(DeviceProc()) - SizeOf(Task)) }

    Process = record
        pr_Task         : Task;
        pr_MsgPort      : MsgPort;      { This is BPTR address from DOS functions  }
        pr_Pad          : Short;        { Remaining variables on 4 byte boundaries }
        pr_SegList      : BPTR;         { Array of seg lists used by this process  }
        pr_StackSize    : Integer;      { Size of process stack in bytes            }
        pr_GlobVec      : Address;      { Global vector for this process (BCPL)    }
        pr_TaskNum      : Integer;      { CLI task number of zero if not a CLI      }
        pr_StackBase    : BPTR;         { Ptr to high memory end of process stack  }
        pr_Result2      : Integer;      { Value of secondary result from last call }
        pr_CurrentDir   : BPTR;         { Lock associated with current directory   }
        pr_CIS          : BPTR;         { Current CLI Input Stream                  }
        pr_COS          : BPTR;         { Current CLI Output Stream                 }
        pr_ConsoleTask  : Address;      { Console handler process for current window}
        pr_FileSystemTask : Address;    { File handler process for current drive   }
        pr_CLI          : BPTR;         { pointer to ConsoleLineInterpreter         }
        pr_ReturnAddr   : Address;      { pointer to previous stack frame           }
        pr_PktWait      : Address;      { Function to be called when awaiting msg  }
        pr_WindowPtr    : Address;      { Window for error printing }
        { following definitions are new with 2.0 }
        pr_HomeDir      : BPTR;         { Home directory of executing program      }
        pr_Flags        : Integer;      { flags telling dos about process          }
        pr_ExitCode     : Address;      { code to call on exit of program OR NULL  }
        pr_ExitData     : Integer;      { Passed as an argument to pr_ExitCode.    }
        pr_Arguments    : String;       { Arguments passed to the process at start }
        pr_LocalVars    : MinList;      { Local environment variables             }
        pr_ShellPrivate : Integer;      { for the use of the current shell         }
        pr_CES          : BPTR;         { Error stream - IF NULL, use pr_COS       }
    end;
    ProcessPtr = ^Process;

{
 * Flags for pr_Flags
 }
CONST
 PRB_FREESEGLIST       =  0 ;
 PRF_FREESEGLIST       =  1 ;
 PRB_FREECURRDIR       =  1 ;
 PRF_FREECURRDIR       =  2 ;
 PRB_FREECLI           =  2 ;
 PRF_FREECLI           =  4 ;
 PRB_CLOSEINPUT        =  3 ;
 PRF_CLOSEINPUT        =  8 ;
 PRB_CLOSEOUTPUT       =  4 ;
 PRF_CLOSEOUTPUT       =  16;
 PRB_FREEARGS          =  5 ;
 PRF_FREEARGS          =  32;


{ The long word address (BPTR) of this structure is returned by
 * Open() and other routines that return a file.  You need only worry
 * about this struct to do async io's via PutMsg() instead of
 * standard file system calls }

Type

    FileHandleRec = record
        fh_Link         : MessagePtr;   { EXEC message        }
        fh_Port         : MsgPortPtr;   { Reply port for the packet }
        fh_Type         : MsgPortPtr;   { Port to do PutMsg() to
                                          Address is negative if a plain file }
        fh_Buf          : Integer;
        fh_Pos          : Integer;
        fh_End          : Integer;
        fh_Func1        : Integer;
        fh_Func2        : Integer;
        fh_Func3        : Integer;
        fh_Arg1         : Integer;
        fh_Arg2         : Integer;
    end;
    FileHandlePtr = ^FileHandleRec;

{ This is the extension to EXEC Messages used by DOS }

    DOSPacket = record
        dp_Link : MessagePtr;   { EXEC message        }
        dp_Port : MsgPortPtr;   { Reply port for the packet }
                                { Must be filled in each send. }
        dp_Type : Integer;      { See ACTION_... below and
                                * 'R' means Read, 'W' means Write to the
                                * file system }
        dp_Res1 : Integer;      { For file system calls this is the result
                                * that would have been returned by the
                                * function, e.g. Write ('W') returns actual
                                * length written }
        dp_Res2 : Integer;      { For file system calls this is what would
                                * have been returned by IoErr() }
        dp_Arg1 : Integer;
        dp_Arg2 : Integer;
        dp_Arg3 : Integer;
        dp_Arg4 : Integer;
        dp_Arg5 : Integer;
        dp_Arg6 : Integer;
        dp_Arg7 : Integer;
    end;
    DOSPacketPtr = ^DOSPacket;


{ A Packet does not require the Message to be before it in memory, but
 * for convenience it is useful to associate the two.
 * Also see the function init_std_pkt for initializing this structure }


    StandardPacket = record
        sp_Msg          : Message;
        sp_Pkt          : DOSPacket;
    end;
    StandardPacketPtr = ^StandardPacket;


Const

{ Packet types }
    ACTION_NIL                  = 0;
    ACTION_GET_BLOCK            = 2;    { OBSOLETE }
    ACTION_SET_MAP              = 4;
    ACTION_DIE                  = 5;
    ACTION_EVENT                = 6;
    ACTION_CURRENT_VOLUME       = 7;
    ACTION_LOCATE_OBJECT        = 8;
    ACTION_RENAME_DISK          = 9;
    ACTION_WRITE                = $57;  { 'W' }
    ACTION_READ                 = $52;  { 'R' }
    ACTION_FREE_LOCK            = 15;
    ACTION_DELETE_OBJECT        = 16;
    ACTION_RENAME_OBJECT        = 17;
    ACTION_MORE_CACHE           = 18;
    ACTION_COPY_DIR             = 19;
    ACTION_WAIT_CHAR            = 20;
    ACTION_SET_PROTECT          = 21;
    ACTION_CREATE_DIR           = 22;
    ACTION_EXAMINE_OBJECT       = 23;
    ACTION_EXAMINE_NEXT         = 24;
    ACTION_DISK_INFO            = 25;
    ACTION_INFO                 = 26;
    ACTION_FLUSH                = 27;
    ACTION_SET_COMMENT          = 28;
    ACTION_PARENT               = 29;
    ACTION_TIMER                = 30;
    ACTION_INHIBIT              = 31;
    ACTION_DISK_TYPE            = 32;
    ACTION_DISK_CHANGE          = 33;
    ACTION_SET_DATE             = 34;

    ACTION_SCREEN_MODE          = 994;

    ACTION_READ_RETURN          = 1001;
    ACTION_WRITE_RETURN         = 1002;
    ACTION_SEEK                 = 1008;
    ACTION_FINDUPDATE           = 1004;
    ACTION_FINDINPUT            = 1005;
    ACTION_FINDOUTPUT           = 1006;
    ACTION_END                  = 1007;
    ACTION_TRUNCATE             = 1022; { fast file system only }
    ACTION_WRITE_PROTECT        = 1023; { fast file system only }

{ new 2.0 packets }
    ACTION_SAME_LOCK       = 40;
    ACTION_CHANGE_SIGNAL   = 995;
    ACTION_FORMAT          = 1020;
    ACTION_MAKE_LINK       = 1021;
{}
{}
    ACTION_READ_LINK       = 1024;
    ACTION_FH_FROM_LOCK    = 1026;
    ACTION_IS_FILESYSTEM   = 1027;
    ACTION_CHANGE_MODE     = 1028;
{}
    ACTION_COPY_DIR_FH     = 1030;
    ACTION_PARENT_FH       = 1031;
    ACTION_EXAMINE_ALL     = 1033;
    ACTION_EXAMINE_FH      = 1034;

    ACTION_LOCK_RECORD     = 2008;
    ACTION_FREE_RECORD     = 2009;

    ACTION_ADD_NOTIFY      = 4097;
    ACTION_REMOVE_NOTIFY   = 4098;

{
 * A structure for holding error messages - stored as array with error == 0
 * for the last entry.
 }
Type
       ErrorString = Record
        estr_Nums     : Address;
        estr_Strings  : Address;
       END;
       ErrorStringPtr = ^ErrorString;


{ DOS library node structure.
 * This is the data at positive offsets from the library node.
 * Negative offsets from the node is the jump table to DOS functions
 * node = (struct DosLibrary *) OpenLibrary( "dos.library" .. )      }

Type

    DOSLibrary = record
        dl_lib          : Library;
        dl_Root         : Address;      { Pointer to RootNode, described below }
        dl_GV           : Address;      { Pointer to BCPL global vector       }
        dl_A2           : Integer;      { Private register dump of DOS        }
        dl_A5           : Integer;
        dl_A6           : Integer;
        dl_Errors       : ErrorStringPtr;  { pointer to array of error msgs }
        dl_TimeReq      : TimeRequestPtr;  { private pointer to timer request }
        dl_UtilityBase  : LibraryPtr;      { private ptr to utility library }

    end;
    DOSLibraryPtr = ^DOSLibrary;

    RootNode = record
        rn_TaskArray    : BPTR;         { [0] is max number of CLI's
                                          [1] is APTR to process id of CLI 1
                                          [n] is APTR to process id of CLI n }
        rn_ConsoleSegment : BPTR;       { SegList for the CLI }
        rn_Time         : DateStampRec; { Current time }
        rn_RestartSeg   : Integer;      { SegList for the disk validator process }
        rn_Info         : BPTR;         { Pointer ot the Info structure }
        rn_FileHandlerSegment : BPTR;   { segment for a file handler }
        rn_CliList      : MinList;      { new list of all CLI processes }
                                        { the first cpl_Array is also rn_TaskArray }
        rn_BootProc     : MsgPortPtr;   { private ptr to msgport of boot fs      }
        rn_ShellSegment : BPTR;         { seglist for Shell (for NewShell)         }
        rn_Flags        : Integer;      { dos flags }
    end;
    RootNodePtr = ^RootNode;

CONST
 RNB_WILDSTAR   = 24;
 RNF_WILDSTAR   = 16777216;
 RNB_PRIVATE1   = 1;       { private for dos }
 RNF_PRIVATE1   = 2;

Type
    DOSInfo = record
        di_McName       : BPTR; { Network name of this machine; currently 0 }
        di_DevInfo      : BPTR; { Device List }
        di_Devices      : BPTR; { Currently zero }
        di_Handlers     : BPTR; { Currently zero }
        di_NetHand      : Address;      { Network handler processid; currently zero }
        di_DevLock,                      { do NOT access directly! }
        di_EntryLock,                    { do NOT access directly! }
        di_DeleteLock : SignalSemaphore; { do NOT access directly! }
    end;
    DOSInfoPtr = ^DOSInfo;

{ ONLY to be allocated by DOS! }
       CliProcList = Record
        cpl_Node   : MinNode;
        cpl_First  : Integer;      { number of first entry in array }
        cpl_Array  : Array[0..0] of MsgPortPtr;
                             { [0] is max number of CLI's in this entry (n)
                              * [1] is CPTR to process id of CLI cpl_First
                              * [n] is CPTR to process id of CLI cpl_First+n-1
                              }
       END;
       CliProcListPtr = ^CliProcList;

{ structure for the Dos resident list.  Do NOT allocate these, use       }
{ AddSegment(), and heed the warnings in the autodocs!                   }

Type
       Segment = Record
        seg_Next  : BPTR;
        seg_UC    : Integer;
        seg_Seg   : BPTR;
        seg_Name  : Array[0..3] of Char;      { actually the first 4 chars of BSTR name }
       END;
       SegmentPtr = ^Segment;

CONST
 CMD_SYSTEM    =  -1;
 CMD_INTERNAL  =  -2;
 CMD_DISABLED  =  -999;


{ DOS Processes started from the CLI via RUN or NEWCLI have this additional
 * set to data associated with them }
Type
    CommandLineInterface = record
        cli_Result2     : Integer;      { Value of IoErr from last command }
        cli_SetName     : BSTR;         { Name of current directory }
        cli_CommandDir  : BPTR;         { Lock associated with command directory }
        cli_ReturnCode  : Integer;      { Return code from last command }
        cli_CommandName : BSTR;         { Name of current command }
        cli_FailLevel   : Integer;      { Fail level (set by FAILAT) }
        cli_Prompt      : BSTR;         { Current prompt (set by PROMPT) }
        cli_StandardInput : BPTR;       { Default (terminal) CLI input }
        cli_CurrentInput : BPTR;        { Current CLI input }
        cli_CommandFile : BSTR;         { Name of EXECUTE command file }
        cli_Interactive : Integer;      { Boolean; True if prompts required }
        cli_Background  : Integer;      { Boolean; True if CLI created by RUN }
        cli_CurrentOutput : BPTR;       { Current CLI output }
        cli_DefaultStack : Integer;     { Stack size to be obtained in long words }
        cli_StandardOutput : BPTR;      { Default (terminal) CLI output }
        cli_Module      : BPTR;         { SegList of currently loaded command }
    end;
    CommandLineInterfacePtr = ^CommandLineInterface;

{ This structure can take on different values depending on whether it is
 * a device, an assigned directory, or a volume.  Below is the structure
 * reflecting volumes only.  Following that is the structure representing
 * only devices.
 }

{ structure representing a volume }

    DeviceList = record
        dl_Next         : BPTR;         { bptr to next device list }
        dl_Type         : Integer;      { see DLT below }
        dl_Task         : MsgPortPtr;   { ptr to handler task }
        dl_Lock         : BPTR;         { not for volumes }
        dl_VolumeDate   : DateStampRec; { creation date }
        dl_LockList     : BPTR;         { outstanding locks }
        dl_DiskType     : Integer;      { 'DOS', etc }
        dl_unused       : Integer;
        dl_Name         : BSTR;         { bptr to bcpl name }
    end;
    DeviceListPtr = ^DeviceList;

{ device structure (same as the DeviceNode structure in filehandler.h) }

    DevInfo = record
        dvi_Next        : BPTR;
        dvi_Type        : Integer;
        dvi_Task        : Address;
        dvi_Lock        : BPTR;
        dvi_Handler     : BSTR;
        dvi_StackSize   : Integer;
        dvi_Priority    : Integer;
        dvi_Startup     : Integer;
        dvi_SegList     : BPTR;
        dvi_GlobVec     : BSTR;
        dvi_Name        : BSTR;
    end;
    DevInfoPtr = ^DevInfo;

{    structure used for multi-directory assigns. AllocVec()ed. }

       AssignList = Record
        al_Next : ^AssignList;
        al_Lock : BPTR;
       END;
       AssignListPtr = ^AssignList;


{ combined structure for devices, assigned directories, volumes }

    dol_Handler = Record
     dol_Handler    : String;    {    file name to load IF seglist is null }
     dol_StackSize,              {    stacksize to use when starting process }
     dol_Priority,               {    task priority when starting process }
     dol_Startup    : Integer;   {    startup msg: FileSysStartupMsg for disks }
     dol_SegList,                {    already loaded code for new task }
     dol_GlobVec    : BPTR;      {    BCPL global vector to use when starting
                                 * a process. -1 indicates a C/Assembler
                                 * program. }
    END;
    dol_HandlerPtr = ^dol_Handler;

    dol_Volume = Record
     dol_VolumeDate : DateStampRec;  {    creation date }
     dol_LockList   : BPTR;       {    outstanding locks }
     dol_DiskType   : Integer;    {    'DOS', etc }
    END;
    dol_VolumePtr = ^dol_Volume;

    dol_assign = Record
        dol_AssignName  : String;        {    name for non-OR-late-binding assign }
        dol_List        : AssignListPtr; {    for multi-directory assigns (regular) }
    END;
    dol_AssignPtr = ^dol_assign;


   DosList = Record
    dol_Next            : BPTR;           {    bptr to next device on list }
    dol_Type            : Integer;        {    see DLT below }
    dol_Task            : MsgPortPtr;     {    ptr to handler task }
    dol_Lock            : BPTR;
    dol_Misc            : Array[0..23] of Byte;
    dol_Name            : String;         {    bptr to bcpl name }
   END;
   DosListPtr = ^DosList;

Const

{ definitions for dl_Type }

    DLT_DEVICE          = 0;
    DLT_DIRECTORY       = 1;
    DLT_VOLUME          = 2;
    DLT_LATE            = 3;       {    late-binding assign }
    DLT_NONBINDING      = 4;       {    non-binding assign }
    DLT_PRIVATE         = -1;      {    for internal use only }

{    structure return by GetDeviceProc() }
Type
       DevProc = Record
        dvp_Port        : MsgPortPtr;
        dvp_Lock        : BPTR;
        dvp_Flags       : Integer;
        dvp_DevNode     : DosListPtr;    {    DON'T TOUCH OR USE! }
       END;
       DevProcPtr = ^DevProc;

CONST
{    definitions for dvp_Flags }
     DVPB_UNLOCK   =  0;
     DVPF_UNLOCK   =  1;
     DVPB_ASSIGN   =  1;
     DVPF_ASSIGN   =  2;

{    Flags to be passed to LockDosList(), etc }
     LDB_DEVICES   =  2;
     LDF_DEVICES   =  4;
     LDB_VOLUMES   =  3;
     LDF_VOLUMES   =  8;
     LDB_ASSIGNS   =  4;
     LDF_ASSIGNS   =  16;
     LDB_ENTRY     =  5;
     LDF_ENTRY     =  32;
     LDB_DELETE    =  6;
     LDF_DELETE    =  64;

{    you MUST specify one of LDF_READ or LDF_WRITE }
     LDB_READ      =  0;
     LDF_READ      =  1;
     LDB_WRITE     =  1;
     LDF_WRITE     =  2;

{    actually all but LDF_ENTRY (which is used for internal locking) }
     LDF_ALL       =  (LDF_DEVICES+LDF_VOLUMES+LDF_ASSIGNS);

{    error report types for ErrorReport() }
     REPORT_STREAM          = 0;       {    a stream }
     REPORT_TASK            = 1;       {    a process - unused }
     REPORT_LOCK            = 2;       {    a lock }
     REPORT_VOLUME          = 3;       {    a volume node }
     REPORT_INSERT          = 4;       {    please insert volume }

{    Special error codes for ErrorReport() }
     ABORT_DISK_ERROR       = 296;     {    Read/write error }
     ABORT_BUSY             = 288;     {    You MUST replace... }

{    types for initial packets to shells from run/newcli/execute/system. }
{    For shell-writers only }
     RUN_EXECUTE           =  -1;
     RUN_SYSTEM            =  -2;
     RUN_SYSTEM_ASYNCH     =  -3;

{    Types for fib_DirEntryType.  NOTE that both USERDIR and ROOT are      }
{    directories, and that directory/file checks should use <0 and >=0.    }
{    This is not necessarily exhaustive!  Some handlers may use other      }
{    values as needed, though <0 and >=0 should remain as supported as     }
{    possible.                                                             }
     ST_ROOT       =  1 ;
     ST_USERDIR    =  2 ;
     ST_SOFTLINK   =  3 ;      {    looks like dir, but may point to a file! }
     ST_LINKDIR    =  4 ;      {    hard link to dir }
     ST_FILE       =  -3;      {    must be negative for FIB! }
     ST_LINKFILE   =  -4;      {    hard link to file }


Type

{ a lock structure, as returned by Lock() or DupLock() }

    FileLockRec = record
        fl_Link         : BPTR;         { bcpl pointer to next lock }
        fl_Key          : Integer;      { disk block number }
        fl_Access       : Integer;      { exclusive or shared }
        fl_Task         : MsgPortPtr;   { handler task's port }
        fl_Volume       : BPTR;         { bptr to a DeviceList }
    end;
    FileLockPtr = ^FileLockRec;

PROCEDURE AbortPkt(P : MsgPortPtr; Packet : DOSPacketPtr);
    External;

Function CreateProc(name : String; pri : Integer;
                        segment : BPTR; stackSize : Integer) : ProcessPtr;
    External;

Function DeviceProc(name : String) : ProcessPtr;
    External;

FUNCTION CreateNewProc(Tags : Address) : ProcessPtr;
    External;

FUNCTION DoPkt(ID : MsgPortPtr; Action, Param1, Param2, Param3, Param4, Param5 : Integer) : Integer;
    External;  

Function LoadSeg(name : String) : BPTR;
    External;

Procedure UnLoadSeg(segment : BPTR);
    External;

FUNCTION AddDosEntry(DL : DosList) : Boolean;
    External;

FUNCTION AttemptLockDosList(flags : Integer) : DosListPtr;
    External;

FUNCTION Cli : CommandLineInterfacePtr;
    External;

FUNCTION CliInitNewcli(Packet : DOSPacketPtr) : Integer;
    External;

FUNCTION CliInitRun(Packet : DOSPacketPtr) : Integer;  
    External;

FUNCTION FindDosEntry(initial : DosList; name : String; flags : Integer) : DosListPtr;
    External;

FUNCTION FindSegment(name : String; entry : SegmentPtr; System : Integer) : SegmentPtr;
    External;

PROCEDURE FreeDeviceProc(Dv : DevProcPtr);
    External;

PROCEDURE FreeDosEntry(Entry : DosListPtr);
    External;

FUNCTION FindCliProc(num : Integer) : ProcessPtr;
    External;

FUNCTION GetConsoleTask : MsgPortPtr;
    External;

FUNCTION GetDeviceProc(name : String; result : DevProcPtr) : DevProcPtr;
    External;

FUNCTION GetFileSysTask : MsgPortPtr;
    External;

PROCEDURE UnLockDosList(flags : Integer);
    External;

FUNCTION LockDosList(value : Integer) : DosListPtr;
    External;

FUNCTION InternalLoadSeg(SegList : BPTR; HunkTable : BPTR; FunctionArray : Address; StackSize : Integer) : BPTR;
    External;

FUNCTION InternalUnLoadSeg(SegList : BPTR; func : Address) : Boolean;
    External;

FUNCTION SetConsoleTask(n : MsgPortPtr) : MsgPortPtr;
    External;

FUNCTION SetFileSystemTask(new : MsgPortPtr) : MsgPortPtr;
    External;

PROCEDURE SendPkt(packet : DOSPacketPtr; port, replyport : MsgPortPtr);
    External;

FUNCTION WaitPkt : DosPacketPtr;
    External;

FUNCTION RemDosEntry(DL : DosListPtr) : Boolean;
    External;

FUNCTION RemSegment(entry : SegmentPtr) : Boolean;
    External;

PROCEDURE ReplyPkt(packet : DOSPacketPtr; res1, res2 : Integer);
    External;

FUNCTION NewLoadSeg(name : String; Tags : Address) : BPTR;
    External;

FUNCTION NextDosEntry(DL : DosListPtr; descriptor : Integer) : DosListPtr;
    External;

FUNCTION MaxCli : Integer;
    External;

FUNCTION MakeDosEntry(name : String; EntryType : Integer) : DosListPtr;
    External;

FUNCTION AddSegment(name : String; SegList : BPTR; EntryType : Integer) : Boolean;
    External;

