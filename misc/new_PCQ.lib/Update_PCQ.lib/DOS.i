{
        DOS.i for PCQ Pascal

        Standard C header for AmigaDOS

 -- This is Include:dos/dos.i for PCQ-Pascal, revision from April 23, 1995
 -- ( NameFromFH corrected : Buffer is now direct String, no global VAR )

}

{$I   "Include:Exec/Types.i"}

Const

    DOSNAME     = "dos.library";

{ Predefined Amiga DOS global constants }

    DOSTRUE     = -1;
    DOSFALSE    = 0;

{ Mode parameter to Open() }

    MODE_OLDFILE        = 1005;         { Open existing file read/write
                                          positioned at beginning of file. }
    MODE_NEWFILE        = 1006;         { Open freshly created file (delete
                                          old file) read/write }
    MODE_READWRITE      = 1004;         { Open old file w/exclusive lock }

{ Relative position to Seek() }

    OFFSET_BEGINNING    = -1;           { relative to Begining Of File }
    OFFSET_CURRENT      = 0;            { relative to Current file position }
    OFFSET_END          = 1;            { relative to End Of File }

    BITSPERBYTE         = 8;
    BYTESPERLONG        = 4;
    BITSPERLONG         = 32;
    MAXINT              = $7FFFFFFF;
    MININT              = $80000000;

{ Passed as type to Lock() }

    SHARED_LOCK         = -2;           { File is readable by others }
    ACCESS_READ         = -2;           { Synonym }
    EXCLUSIVE_LOCK      = -1;           { No other access allowed }
    ACCESS_WRITE        = -1;           { Synonym }

Type

    FileHandle  = Address;
    FileLock    = Address;

    DateStampRec = record
        ds_Days         : Integer;      { Number of days since Jan. 1, 1978 }
        ds_Minute       : Integer;      { Number of minutes past midnight }
        ds_Tick         : Integer;      { Number of ticks past minute }
    end;
    DateStampPtr = ^DateStampRec;

Const

    TICKS_PER_SECOND    = 50;           { Number of ticks in one second }

Type

{ Returned by Examine() and ExInfo(), must be on a 4 byte boundary }

    FileInfoBlock = record
        fib_DiskKey     : Integer;
        fib_DirEntryType : Integer;
                        { Type of Directory. If < 0, then a plain file.
                          If > 0 a directory }
        fib_FileName    : Array [0..107] of Char;
                        { Null terminated. Max 30 chars used for now }
        fib_Protection  : Integer;
                        { bit mask of protection, rwxd are 3-0. }
        fib_EntryType   : Integer;
        fib_Size        : Integer;      { Number of bytes in file }
        fib_NumBlocks   : Integer;      { Number of blocks in file }
        fib_Date        : DateStampRec; { Date file last changed }
        fib_Comment     : Array [0..79] of Char;
                        { Null terminated comment associated with file }
        fib_Reserved    : Array [0..35] of Char;
    end;
    FileInfoBlockPtr = ^FileInfoBlock;


Const

{ FIB stands for FileInfoBlock }

{ FIBB are bit definitions, FIBF are field definitions }

    FIBB_SCRIPT         = 6;    { program is a script (execute) file }
    FIBB_PURE           = 5;    { program is reentrant and rexecutable}
    FIBB_ARCHIVE        = 4;    { cleared whenever file is changed }
    FIBB_READ           = 3;    { ignored by old filesystem }
    FIBB_WRITE          = 2;    { ignored by old filesystem }
    FIBB_EXECUTE        = 1;    { ignored by system, used by Shell }
    FIBB_DELETE         = 0;    { prevent file from being deleted }
    FIBF_SCRIPT         = 64;
    FIBF_PURE           = 32;
    FIBF_ARCHIVE        = 16;
    FIBF_READ           = 8;
    FIBF_WRITE          = 4;
    FIBF_EXECUTE        = 2;
    FIBF_DELETE         = 1;


Type

{ returned by Info(), must be on a 4 byte boundary }

    InfoData = record
        id_NumSoftErrors        : Integer;      { number of soft errors on disk }
        id_UnitNumber           : Integer;      { Which unit disk is (was) mounted on }
        id_DiskState            : Integer;      { See defines below }
        id_NumBlocks            : Integer;      { Number of blocks on disk }
        id_NumBlocksUsed        : Integer;      { Number of block in use }
        id_BytesPerBlock        : Integer;
        id_DiskType             : Integer;      { Disk Type code }
        id_VolumeNode           : BPTR;         { BCPL pointer to volume node }
        id_InUse                : Integer;      { Flag, zero if not in use }
    end;
    InfoDataPtr = ^InfoData;

Const

{ ID stands for InfoData }

        { Disk states }

    ID_WRITE_PROTECTED  = 80;   { Disk is write protected }
    ID_VALIDATING       = 81;   { Disk is currently being validated }
    ID_VALIDATED        = 82;   { Disk is consistent and writeable }

CONST
 ID_NO_DISK_PRESENT     = -1;
 ID_UNREADABLE_DISK     = $42414400;   { 'BAD\0' }
 ID_DOS_DISK            = $444F5300;   { 'DOS\0' }
 ID_FFS_DISK            = $444F5301;   { 'DOS\1' }
 ID_NOT_REALLY_DOS      = $4E444F53;   { 'NDOS'  }
 ID_KICKSTART_DISK      = $4B49434B;   { 'KICK'  }
 ID_MSDOS_DISK          = $4d534400;   { 'MSD\0' }

{ Errors from IoErr(), etc. }
 ERROR_NO_FREE_STORE              = 103;
 ERROR_TASK_TABLE_FULL            = 105;
 ERROR_BAD_TEMPLATE               = 114;
 ERROR_BAD_NUMBER                 = 115;
 ERROR_REQUIRED_ARG_MISSING       = 116;
 ERROR_KEY_NEEDS_ARG              = 117;
 ERROR_TOO_MANY_ARGS              = 118;
 ERROR_UNMATCHED_QUOTES           = 119;
 ERROR_LINE_TOO_LONG              = 120;
 ERROR_FILE_NOT_OBJECT            = 121;
 ERROR_INVALID_RESIDENT_LIBRARY   = 122;
 ERROR_NO_DEFAULT_DIR             = 201;
 ERROR_OBJECT_IN_USE              = 202;
 ERROR_OBJECT_EXISTS              = 203;
 ERROR_DIR_NOT_FOUND              = 204;
 ERROR_OBJECT_NOT_FOUND           = 205;
 ERROR_BAD_STREAM_NAME            = 206;
 ERROR_OBJECT_TOO_LARGE           = 207;
 ERROR_ACTION_NOT_KNOWN           = 209;
 ERROR_INVALID_COMPONENT_NAME     = 210;
 ERROR_INVALID_LOCK               = 211;
 ERROR_OBJECT_WRONG_TYPE          = 212;
 ERROR_DISK_NOT_VALIDATED         = 213;
 ERROR_DISK_WRITE_PROTECTED       = 214;
 ERROR_RENAME_ACROSS_DEVICES      = 215;
 ERROR_DIRECTORY_NOT_EMPTY        = 216;
 ERROR_TOO_MANY_LEVELS            = 217;
 ERROR_DEVICE_NOT_MOUNTED         = 218;
 ERROR_SEEK_ERROR                 = 219;
 ERROR_COMMENT_TOO_BIG            = 220;
 ERROR_DISK_FULL                  = 221;
 ERROR_DELETE_PROTECTED           = 222;
 ERROR_WRITE_PROTECTED            = 223;
 ERROR_READ_PROTECTED             = 224;
 ERROR_NOT_A_DOS_DISK             = 225;
 ERROR_NO_DISK                    = 226;
 ERROR_NO_MORE_ENTRIES            = 232;
{ added for 1.4 }
 ERROR_IS_SOFT_LINK               = 233;
 ERROR_OBJECT_LINKED              = 234;
 ERROR_BAD_HUNK                   = 235;
 ERROR_NOT_IMPLEMENTED            = 236;
 ERROR_RECORD_NOT_LOCKED          = 240;
 ERROR_LOCK_COLLISION             = 241;
 ERROR_LOCK_TIMEOUT               = 242;
 ERROR_UNLOCK_ERROR               = 243;

{ error codes 303-305 are defined in dosasl.h }

{ Values returned by SameLock() }
 LOCK_SAME             =  0;
 LOCK_SAME_HANDLER     =  1;       { actually same volume }
 LOCK_DIFFERENT        =  -1;

{ types for ChangeMode() }
 CHANGE_LOCK    = 0;
 CHANGE_FH      = 1;

{ Values for MakeLink() }
 LINK_HARD      = 0;
 LINK_SOFT      = 1;       { softlinks are not fully supported yet }

{ values returned by ReadItem }
 ITEM_EQUAL     = -2;              { "=" Symbol }
 ITEM_ERROR     = -1;              { error }
 ITEM_NOTHING   = 0;               { *N, ;, endstreamch }
 ITEM_UNQUOTED  = 1;               { unquoted item }
 ITEM_QUOTED    = 2;               { quoted item }

{ types for AllocDosObject/FreeDosObject }
 DOS_FILEHANDLE        =  0;       { few people should use this }
 DOS_EXALLCONTROL      =  1;       { Must be used to allocate this! }
 DOS_FIB               =  2;       { useful }
 DOS_STDPKT            =  3;       { for doing packet-level I/O }
 DOS_CLI               =  4;       { for shell-writers, etc }
 DOS_RDARGS            =  5;       { for ReadArgs if you pass it in }



Procedure DOSClose(filehand : FileHandle);
    External;

Function CreateDir(name : String) : FileLock;
    External;

Function CurrentDir(lock : FileLock) : FileLock;
    External;

Procedure DateStamp(var ds : DateStampRec);
    External;

Procedure Delay(ticks : Integer);
    External;

Function DeleteFile(name : String) : Boolean;
    External;

Function DupLock(lock : FileLock) : FileLock;
    External;

Function Examine(lock : FileLock; info : FileInfoBlockPtr) : Boolean;
    External;

Function Execute(command : String; InFile, OutFile : FileHandle) : Boolean;
    External;

Procedure DOSExit(code : Integer);
    External;

Function ExNext(lock : FileLock; info : FileInfoBlockPtr) : Boolean;
    External;

Function Info(lock : FileLock; params : InfoDataPtr) : Boolean;
    External;

Function IoErr : Integer;
    External;

Function DOSInput : FileHandle;
    External;

Function IsInteractive(f : FileHandle) : Boolean;
    External;

Function Lock(name : String; accessmode : Integer) : FileLock;
    External;

Function DOSOpen(name : String; accessmode : Integer) : FileHandle;
    External;

Function DOSOutput : FileHandle;
    External;

Function ParentDir(lock : FileLock) : FileLock;
    External;

Function DOSRead(f : FileHandle; buffer : Address; length : Integer) : Integer;
    External;

Function Rename(oldname, newname : String) : Boolean;
    External;

Function Seek(f : FileHandle; pos : Integer; mode : Integer) : Integer;
    External;

Function SetComment(name : String; comment : String) : Boolean;
    External;

Function SetProtection(name : String; mask : Integer) : Boolean;
    External;

Procedure UnLock(lock : FileLock);
    External;

Function WaitForChar(f : FileHandle; timeout : Integer) : Boolean;
    External;

Function DOSWrite(f : FileHandle; buffer : Address; len : Integer) : Integer;
    External;


{ OS2.0 }

FUNCTION AddBuffers(Name : String; Buffers : Integer) : Boolean;
    External;

FUNCTION AddPart(Path1, Path2 : String; Bytes : Integer) : Boolean;
    External;

FUNCTION AllocDosObject(ObjectType : Integer; Tags : Address) : Address;
    External;

FUNCTION AssignAdd(name : String; Datei : FileLock) : Boolean;
    External;

FUNCTION AssignLate(name1, name2 : String) : Boolean;
    External;

FUNCTION AssignLock(name : String; Datei : FileLock) : Boolean;
    External;

FUNCTION AssignPath(name1, name2 : String) : Boolean;
    External;

FUNCTION ChangeMode(Mode : Integer; Datei : Address; newMode : Integer) : Boolean;
    External;                       { Datei is a FileLock OR a FileHandle }

FUNCTION CheckSignal(Signal : Integer) : Integer;
    External;

FUNCTION CompareDates(First, Second : DateStampPtr) : Integer;
    External;

FUNCTION DupLockFromFH(Datei : FileHandle) : FileLock;
    External;

FUNCTION ErrorReport(ErrorCode, ReportType : Integer; Param : Address; HandlerID : Address) : Boolean;
    External;                                                          { HandlerID is a MsgPortPtr }

FUNCTION ExamineFH(Datei : FileHandle; FIB : FileInfoBlockPtr) : Boolean;
    External;

FUNCTION Fault(Code : Integer; Txt : String; VAR Buffer : String; BufferSize : Integer) : Integer;
    External;

FUNCTION FGetC(Datei : FileHandle) : Char;
    External;

FUNCTION FGets(Datei : FileHandle; VAR Buffer : String; BufferSize : Integer) : String;
    External;

FUNCTION FilePart(Path : String) : Char;
    External;

FUNCTION Flush(Datei : FileHandle) : Boolean;
    External;

FUNCTION Format(drive, name : String; DOSType : Integer) : Boolean;
    External;

FUNCTION FPutC(Datei : FileHandle; c : Char) : Integer;
    External;

FUNCTION FPuts(Datei : FileHandle; str : String) : Boolean;
    External;

FUNCTION FRead(Datei : FileHandle; Buffer : Address; BlockSize, Blocks : Integer) : Integer;
    External;

FUNCTION FWrite(Datei : FileHandle; Buffer : Address; BlockSize, Blocks : Integer) : Integer;
    External;

PROCEDURE FreeDosObject(ObjectType : Integer; Object : Address);
    External;

FUNCTION GetArgStr : String;
    External;

FUNCTION GetCurrentDirName(VAR Buffer : String; BufferSize : Integer) : Boolean;
    External;

FUNCTION GetProgramDir : FileLock;
    External;

FUNCTION GetProgramName(VAR Buffer : String; BufferSize : Integer) : Boolean;
    External;

FUNCTION GetPrompt(VAR Buffer : String; BufferSize : Integer) : Boolean;
    External;

FUNCTION Inhibit(device : String; mode : Boolean) : Boolean;
    External;

FUNCTION IsFileSystem(name : String) : Boolean;
    External;

FUNCTION MakeLink(name : String; datei : Address; LinkType : Integer) : Boolean;
    External;                   { LinkType=LINK_HARD : datei=FileLock
                                { LinkType=LINK_SOFT : Datei=String }

FUNCTION NameFromFH(Datei : FileHandle; Buffer : String; BufferSize : Integer) : Boolean;
    External;

FUNCTION NameFromLock(Datei : FileLock; VAR Buffer : String; BufferSize : Integer) : Boolean;
    External;

FUNCTION OpenFromLock(Datei : FileLock) : FileHandle;
    External;

FUNCTION ParentOfFH(Datei : FileHandle) : FileLock;
    External;

FUNCTION PathPart(Path : String) : Char;
    External;

FUNCTION PrintFault(error : Integer; Str : String) : Boolean;
    External;

FUNCTION PutStr(Str : String) : Boolean;
    External;

FUNCTION ReadLink(procID : Address; datei : FileLock; name : String;
                  VAR buffer : String; buffersize : Integer) : Boolean;
    External;     { procID is a MsgPortPtr }

FUNCTION Relabel(device : String; newname : String) : Boolean;
    External;

FUNCTION RemAssignList(name : String; datei : FileLock) : Boolean;
    External;

FUNCTION RunCommand(SL : Address; stacksize : Integer; param : String; paramlen : Integer) : Integer;
    External;

FUNCTION SameDevice(datei1, datei2 : FileLock) : Boolean;
    External;

FUNCTION SameLock(datei1, datei2 : FileLock) : Integer;
    External;

FUNCTION SelectInput(new : FileHandle) : FileHandle;
    External;

FUNCTION SelectOutput(new : FileHandle) : FileHandle;
    External;

FUNCTION SetArgStr(new : String) : String;
    External;

FUNCTION SetCurrentDirName(path : String) : Boolean;
    External;

FUNCTION SetFileDate(datei : String; date : DateStampPtr) : Boolean;
    External;

FUNCTION SetFileSize(datei : FileHandle; new, mode : Integer) : Boolean;
    External;

FUNCTION SetIoErr(new : Integer) : Integer;
    External;

FUNCTION SetMode(datei : FileHandle; new : Integer) : Boolean;
    External;

FUNCTION SetProgramDir(new : FileLock) : FileLock;
    External;

FUNCTION SetProgramName(new : String) : Boolean;
    External;

FUNCTION SetPrompt(prompt : String) : Boolean;
    External;

FUNCTION SetVBuf(datei : FileHandle; VAR Buffer : String; bufmode, buffersize : Integer) : Boolean;
    External;

FUNCTION SplitName(path : String; Separator : Char; VAR Buffer : String; start : Short; BufferSize : Integer) : Short;
    External;

FUNCTION StrToLong(Str : String; VAR L : Address) : Integer;
    External;

FUNCTION SystemTagList(command : String; tags : Address) : Integer;
    External;

FUNCTION UnGetC(Datei : FileHandle; c : Integer) : Integer;
    External;

FUNCTION VFPrintf(datei : FileHandle; str : String; objects : Address) : Integer;
    External;

FUNCTION VFWritef(datei : FileHandle; str : String; objects : Address) : Integer;
    External;

FUNCTION VPrintf(str : String; objects : Address) : Integer;
    External;

FUNCTION WriteChars(buffer : String; num : Integer) : Integer;
    External;



