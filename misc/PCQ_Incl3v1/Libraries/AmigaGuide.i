
{$I "Include:Exec/Types.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:exec/Semaphores.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/Screens.i"}
{$I "Include:Intuition/ClassUsr.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:Utility/TagItem.i"}


Var AmigaGuideBase : Address;

const
 APSH_TOOL_ID           = 11000;
 StartupMsgID           = (APSH_TOOL_ID+1) ;      { Startup message }
 LoginToolID            = (APSH_TOOL_ID+2) ;      { Login a tool SIPC port }
 LogoutToolID           = (APSH_TOOL_ID+3) ;      { Logout a tool SIPC port }
 ShutdownMsgID          = (APSH_TOOL_ID+4) ;      { Shutdown message }
 ActivateToolID         = (APSH_TOOL_ID+5) ;      { Activate tool }
 DeactivateToolID       = (APSH_TOOL_ID+6) ;      { Deactivate tool }
 ActiveToolID           = (APSH_TOOL_ID+7) ;      { Tool Active }
 InactiveToolID         = (APSH_TOOL_ID+8) ;      { Tool Inactive }
 ToolStatusID           = (APSH_TOOL_ID+9) ;      { Status message }
 ToolCmdID              = (APSH_TOOL_ID+10);      { Tool command message }
 ToolCmdReplyID         = (APSH_TOOL_ID+11);      { Reply to tool command }
 ShutdownToolID         = (APSH_TOOL_ID+12);      { Shutdown tool }

{ Attributes accepted by GetAmigaGuideAttr() }
 AGA_Dummy              = (TAG_USER)   ;
 AGA_Path               = (AGA_Dummy+1);
 AGA_XRefList           = (AGA_Dummy+2);
 AGA_Activate           = (AGA_Dummy+3);
 AGA_Context            = (AGA_Dummy+4);

 AGA_HelpGroup          = (AGA_Dummy+5);
    { (ULONG) Unique identifier }

 AGA_Reserved1          = (AGA_Dummy+6);
 AGA_Reserved2          = (AGA_Dummy+7);
 AGA_Reserved3          = (AGA_Dummy+8);

 AGA_ARexxPort          = (AGA_Dummy+9);
    { (struct MsgPort *) Pointer to the ARexx message port (V40) }

 AGA_ARexxPortName      = (AGA_Dummy+10);
   { (STRPTR) Used to specify the ARexx port name (V40) (not copied) }

Type
    AMIGAGUIDECONTEXT = Address;

 AmigaGuideMsg = Record
    agm_Msg     : Message;                      { Embedded Exec message structure }
    agm_Type    : Integer;                      { Type of message }
    agm_Data    : APTR;                         { Pointer to message data }
    agm_DSize,                                  { Size of message data }
    agm_DType,                                  { Type of message data }
    agm_Pri_Ret,                                { Primary return value }
    agm_Sec_Ret : Integer;                      { Secondary return value }
    agm_System1,
    agm_System2 : APTR;
 end;
 AmigaGuideMsgPtr = ^AmigaGuideMsg;

{ Allocation description structure }
  NewAmigaGuide = Record
    nag_Lock  : BPTR;                           { Lock on the document directory }
    nag_Name  : String;                         { Name of document file }
    nag_Screen : ScreenPtr;                     { Screen to place windows within }
    nag_PubScreen,                              { Public screen name to open on }
    nag_HostPort,                               { Application's ARexx port name }
    nag_ClientPort,                             { Name to assign to the clients ARexx port }
    nag_BaseName  : String;                     { Base name of the application }
    nag_Flags  : Integer;                       { Flags }
    nag_Context: Address;                       { NULL terminated context table }
    nag_Node   : String;                        { Node to align on first (defaults to Main) }
    nag_Line   : Integer;                       { Line to align on }
    nag_Extens : Address;                       { Tag array extension }
    nag_Client : Address;                       { Private! MUST be NULL }
  END;
  NewAmigaGuidePtr = ^NewAmigaGuide;

CONST
{ public Client flags }
    HTF_LOAD_INDEX = 0;                 { Force load the index at init time }
    HTF_LOAD_ALL   = 2;                 { Force load the entire database at init }
    HTF_CACHE_NODE = 3;                 { Cache each node as visited }
    HTF_CACHE_DB   = 8;                 { Keep the buffers around UNTIL expunge }
    HTF_UNIQUE     = 32768;             { Unique ARexx port name }
    HTF_NOACTIVATE = 65536;             { Don't activate window }

    HTFC_SYSGADS   = $80000000;

{ Callback function ID's }
    HTH_OPEN       = 0;
    HTH_CLOSE      = 1;

    HTERR_NOT_ENOUGH_MEMORY       =  100;
    HTERR_CANT_OPEN_DATABASE      =  101;
    HTERR_CANT_FIND_NODE          =  102;
    HTERR_CANT_OPEN_NODE          =  103;
    HTERR_CANT_OPEN_WINDOW        =  104;
    HTERR_INVALID_COMMAND         =  105;
    HTERR_CANT_COMPLETE           =  106;
    HTERR_PORT_CLOSED             =  107;
    HTERR_CANT_CREATE_PORT        =  108;
    HTERR_KEYWORD_NOT_FOUND       =  113;

Type
{ Cross reference node }
  XRef = Record
    xr_Node   : Node;             { Embedded node }
    xr_Pad    : WORD;             { Padding }
    xr_DF     : Address;          { Document defined in }
    xr_File,                      { Name of document file }
    xr_Name   : String;           { Name of item }
    xr_Line   : Integer;          { Line defined at }
   END;
   XRefPtr = ^XRef;

CONST
{ Types of cross reference nodes }
    XR_GENERIC     = 0;
    XR_FUNCTION    = 1;
    XR_COMMAND     = 2;
    XR_INCLUDE     = 3;
    XR_MACRO       = 4;
    XR_STRUCT      = 5;
    XR_FIELD       = 6;
    XR_TYPEDEF     = 7;
    XR_DEFINE      = 8;

Type
{ Callback handle }
   AmigaGuideHost = Record
    agh_Dispatcher  : Hook;         { Dispatcher }
    agh_Reserved,                 { Must be 0 }
    agh_Flags,
    agh_UseCnt      : Integer;                   { Number of open nodes }
    agh_SystemData,                        { Reserved for system use }
    agh_UserData    : APTR;                  { Anything you want... }
   END;
   AmigaGuideHostPtr = ^AmigaGuideHost;

CONST
{ Methods }
    HM_FindNode    = 1 ;
    HM_OpenNode    = 2 ;
    HM_CloseNode   = 3 ;
    HM_Expunge     = 10;              { Expunge DataBase }

Type
{ HM_FindNode }
   opFindHost = Record
    MethodID  : Integer;
    ofh_Attrs : Address;           {  R: Additional attributes }
    ofh_Node,                    {  R: Name of node }
    ofh_TOC,                     {  W: Table of Contents }
    ofh_Title,                   {  W: Title to give to the node }
    ofh_Next,                    {  W: Next node to browse to }
    ofh_Prev  : String;                    {  W: Previous node to browse to }
   END;
   opFindHostPtr = ^opFindHost;

{ HM_OpenNode, HM_CloseNode }
   opNodeIO = Record
    MethodID  : Integer;
    onm_Attrs : Address;          {  R: Additional attributes }
    onm_Node,                    {  R: Node name AND arguments }
    onm_FileName,                {  W: File name buffer }
    onm_DocBuffer : String;               {  W: Node buffer }
    onm_BuffLen : Integer;                  {  W: Size of buffer }
    onm_Flags : Integer;                    { RW: Control flags }
   END;
   opNodeIOPtr = ^opNodeIO;

CONST
{ onm_Flags }
    HTNF_KEEP      = 0; { Don't flush this node UNTIL database is
                                 * closed. }
    HTNF_Reserved1 = 2 ; { Reserved for system use }
    HTNF_Reserved2 = 4 ; { Reserved for system use }
    HTNF_ASCII     = 8 ; { Node is straight ASCII }
    HTNF_Reserved3 = 16; { Reserved for system use }
    HTNF_CLEAN     = 32; { Remove the node from the database }
    HTNF_DONE      = 64; { Done with node }

{ onm_Attrs }
    HTNA_Dummy     = TAG_USER;
    HTNA_Screen    = (TAG_USER + 1);  { Screen that window resides in }
    HTNA_Pens      = (TAG_USER + 2);  { Pen array (from DrawInfo) }
    HTNA_Rectangle = (TAG_USER + 3);  { Window box }

    HTNA_HelpGroup = (HTNA_Dummy+5);  { (ULONG) unique identifier }


Type
{ HM_Expunge }
  opExpungeNode = Record
    MethodID  : Integer;
    oen_Attrs : Address;          {  R: Additional attributes }
  END;
  opExpungeNodePtr = ^opExpungeNode;

{ --- functions in V40 or higher (Release 3.1) --- }

FUNCTION LockAmigaGuideBase(handle : Address ) : Integer;
    External;

PROCEDURE UnlockAmigaGuideBase(key : Integer);
    External;

FUNCTION OpenAmigaGuideA(nag : NewAmigaGuidePtr; TagList : Address) : AmigaGuideContext;
    External;

FUNCTION OpenAmigaGuideAsyncA(nag : NewAmigaGuidePtr; TagList : Address) : AmigaGuideContext;
    External;

PROCEDURE CloseAmigaGuide(cl : AmigaGuideContext);
    External;

FUNCTION AmigaGuideSignal(cl : AmigaGuideContext) : Integer;
    External;

FUNCTION GetAmigaGuideMsg(cl : AmigaGuideContext) : AmigaGuideMsgPtr;
    External;

PROCEDURE ReplyAmigaGuideMsg(amsg : AmigaGuideMsgPtr);
    External;

FUNCTION SetAmigaGuideContextA(cl : AmigaGuideContext; ID : Integer; TagList : Address;) : Integer;
    External;

FUNCTION SendAmigaGuideContextA(cl, TagList : Address) : Integer;
    External;

FUNCTION SendAmigaGuideCmdA(cl : AmigaGuideContext; cmd : String; TagList : Address) : Integer;
    External;

FUNCTION SetAmigaGuideAttrsA(cl : AmigaGuideContext; TagList : Address) : Integer;
    External;

FUNCTION GetAmigaGuideAttr(T : Tag;cl : AmigaGuideContext; Storage : Address) : Integer;
    External;

FUNCTION LoadXRef(l : Address; Name : String) : Integer;
    External;

PROCEDURE ExpungeXRef;
    External;

FUNCTION AddAmigaGuideHostA(h : HookPtr; name : String; TagList : Address) : Address;
    External;

FUNCTION RemoveAmigaGuideHostA(hh : Address; TagList : Address ) : Integer;
    External;

FUNCTION GetAmigaGuideString( ID : Integer ) : String;
    External;




