  { Only V39+ }

{***************************************************************************}

{$I "Include:exec/Types.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Libraries/IFFParse.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/Classes.i"}
{$I "Include:Intuition/ClassUsr.i"}
{$I "Include:Intuition/GadgetClass.i"}
{$I "Include:Utility/TagItem.i"}
{$I "Include:DataTypes/DataTypesClass.i"}
{$I "Include:Rexx/Storage.i"}

const
{***************************************************************************}

 ID_DTYP = 1146378576;

{***************************************************************************}

 ID_DTHD = 1146374212;

Type
 DataTypeHeader = Record
    dth_Name,                                         { Descriptive name of the data type }
    dth_BaseName,                                     { Base name of the data type }
    dth_Pattern  : String;                            { Match pattern for file name. }
    dth_Mask : Address;                               { Comparision mask }
    dth_GroupID,                                      { Group that the DataType is in }
    dth_ID   : Integer;                               { ID for DataType (same as IFF FORM type) }
    dth_MaskLen,                                      { Length of comparision mask }
    dth_Pad,                                          { Unused at present (must be 0) }
    dth_Flags,                                        { Flags }
    dth_Priority  : WORD;                             { Priority }
 end;
 DataTypeHeaderPtr = ^DataTypeHeader;

const
 DTHSIZE = 32;

{***************************************************************************}

{ Basic type }
 DTF_TYPE_MASK  = $000F;
 DTF_BINARY     = $0000;
 DTF_ASCII      = $0001;
 DTF_IFF        = $0002;
 DTF_MISC       = $0003;

{ Set if case is important }
 DTF_CASE       = $0010;

{ Reserved for system use }
 DTF_SYSTEM1    = $1000;

{****************************************************************************
 *
 * GROUP ID and ID
 *
 * This is used for filtering out objects that you don't want.  For
 * example, you could make a filter for the ASL file requester so
 * that it only showed the files that were pictures, or even to
 * narrow it down to only show files that were ILBM pictures.
 *
 * Note that the Group ID's are in lower case, and always the first
 * four characters of the word.
 *
 * For ID's; If it is an IFF file, then the ID is the same as the
 * FORM type.  If it isn't an IFF file, then the ID would be the
 * first four characters of name for the file type.
 *
 ****************************************************************************}

{ System file, such as; directory, executable, library, device, font, etc. }
 GID_SYSTEM      = 1937339252;

{ Formatted or unformatted text }
 GID_TEXT        = 1952807028;

{ Formatted text with graphics or other DataTypes }
 GID_DOCUMENT    = 1685021557;

{ Sound }
 GID_SOUND       = 1936684398;

{ Musical instruments used for musical scores }
 GID_INSTRUMENT  = 1768846196;

{ Musical score }
 GID_MUSIC       = 1836413801;

{ Still picture }
 GID_PICTURE     = 1885954932;

{ Animated picture }
 GID_ANIMATION   = 1634625901;

{ Animation with audio track }
 GID_MOVIE       = 1836021353;

{***************************************************************************}

{ A code chunk contains an embedded executable that can be loaded
 * with InternalLoadSeg. }
 ID_CODE = 1146372932;

Type
{ DataTypes comparision hook context (Read-Only).  This is the
 * argument that is passed to a custom comparision routine. }
 DTHookContext = Record
    { Libraries that are already opened for your use }
    dthc_SysBase,
    dthc_DOSBase,
    dthc_IFFParseBase,
    dthc_UtilityBase             : LibraryPtr;

    { File context }
    dthc_Lock                    : BPTR;                { Lock on the file }
    dthc_FIB                     : FileInfoBlockPtr;    { Pointer to a FileInfoBlock }
    dthc_FileHandle              : BPTR;                { Pointer to the file handle (may be NULL) }
    dthc_IFF                     : IFFHandlePtr;        { Pointer to an IFFHandle (may be NULL) }
    dthc_Buffer                  : String;              { Buffer }
    dthc_BufferLength            : Integer;             { Length of the buffer }
 end;
 DTHookContextPtr = ^DTHookContext;

{***************************************************************************}

const
 ID_TOOL = 1146377292;

Type
 Tool = Record
    tn_Which,                                      { Which tool is this }
    tn_Flags  : WORD;                              { Flags }
    tn_Program : String;                           { Application to use }
 end;
 ToolPtr = ^Tool;

const
 TSIZE = 8;

{ defines for tn_Which }
 TW_INFO               =  1;
 TW_BROWSE             =  2;
 TW_EDIT               =  3;
 TW_PRINT              =  4;
 TW_MAIL               =  5;

{ defines for tn_Flags }
 TF_LAUNCH_MASK        =  $000F;
 TF_SHELL              =  $0001;
 TF_WORKBENCH          =  $0002;
 TF_RX                 =  $0003;

{***************************************************************************}

 ID_TAGS = 1146377287;

{***************************************************************************}

Type
 DataType = Record
    dtn_Node1,                      { Reserved for system use }
    dtn_Node2   : Node;             { Reserved for system use }
    dtn_Header  : DataTypeHeaderPtr;{ Pointer to the DataTypeHeader }
    dtn_ToolList: List;             { List of tool nodes }
    dtn_FunctionName : String;      { Name of comparision routine }
    dtn_AttrList : Address;         { Object creation tags }
    dtn_Length : Integer;           { Length of the memory block }
 end;
 DataTypePtr = ^DataType;

{***************************************************************************}

 ToolNode = Record
    tn_Node   : Node;                               { Embedded node }
    tn_Tool   : Tool;                               { Embedded tool }
    tn_Length : Integer;                            { Length of the memory block }
 end;
 ToolNodePtr = ^ToolNode;

{***************************************************************************}

const
 ID_NAME = 1312902469;

{***************************************************************************}

{ text ID's }
 DTERROR_UNKNOWN_DATATYPE              =  2000;
 DTERROR_COULDNT_SAVE                  =  2001;
 DTERROR_COULDNT_OPEN                  =  2002;
 DTERROR_COULDNT_SEND_MESSAGE          =  2003;

{ new for V40 }
 DTERROR_COULDNT_OPEN_CLIPBOARD        =  2004;
 DTERROR_Reserved                      =  2005;
 DTERROR_UNKNOWN_COMPRESSION           =  2006;
 DTERROR_NOT_ENOUGH_DATA               =  2007;
 DTERROR_INVALID_DATA                  =  2008;

{ Offset for types }
 DTMSG_TYPE_OFFSET                     =  2100;

{***************************************************************************}

FUNCTION ObtainDataTypeA(typ : Integer; handle : Address; attrs : Address) : DataTypePtr;
    External;

PROCEDURE ReleaseDataType(dt : DataTypePtr);
    External;

FUNCTION NewDTObjectA(name : Address; attrs : Address) : ObjectPtr;
    External;

PROCEDURE DisposeDTObject(o : ObjectPtr);
    External;

FUNCTION SetDTAttrsA(o : ObjectPtr; win : WindowPtr; req : RequesterPtr; attrs : Address) : Integer;
    External;

FUNCTION GetDTAttrsA(o : ObjectPtr; attrs : Address) : Integer;
    External;

FUNCTION AddDTObject(Win : WindowPtr; Req : RequesterPtr; o : ObjectPtr; Pos : Integer;) : Integer;
    External;

PROCEDURE RefreshDTObjectA(o : ObjectPtr; Win : WindowPtr; Req : RequesterPtr; Attrs : Address);
    External;

FUNCTION DoAsyncLayout(o : ObjectPtr; gpl : gpLayoutPtr) : Integer;
    External;

FUNCTION DoDTMethodA(o : ObjectPtr; Win : WindowPtr; Req : RequesterPtr; Data : Integer) : Integer;
    External;

FUNCTION RemoveDTObject(Win : WindowPtr; o : ObjectPtr) : Integer;
    External;

FUNCTION GetDTMethods(o : ObjectPtr) : Address;
    External;

FUNCTION GetDTTriggerMethods(o : ObjectPtr) : dtMethodPtr;
    External;

FUNCTION PrintDTObjectA(o : ObjectPtr; Win : WindowPtr; Req : RequesterPtr; Msg : dtPrintPtr) : Integer;
    External;

FUNCTION GetDTString(id : Integer) : String;
    External;


