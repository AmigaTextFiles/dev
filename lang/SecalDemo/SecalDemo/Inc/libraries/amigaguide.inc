include "inc/exec/types.inc";
include "inc/exec/lists.inc";
include "inc/exec/nodes.inc";
include "inc/exec/semaphores.inc";
include "inc/intuition/intuition.inc";
include "inc/intuition/screens.inc";
include "inc/intuition/classusr.inc";
include "inc/dos/dos.inc";
include "inc/utility/tagitem.inc";

def APSH_TOOL_ID = 11000;
def StartupMsgID = (APSH_TOOL_ID+1);
def LoginToolID = (APSH_TOOL_ID+2);
def LogoutToolID = (APSH_TOOL_ID+3);
def ShutdownMsgID = (APSH_TOOL_ID+4);
def ActivateToolID = (APSH_TOOL_ID+5);
def DeactivateToolID = (APSH_TOOL_ID+6);
def ActiveToolID = (APSH_TOOL_ID+7);
def InactiveToolID = (APSH_TOOL_ID+8);
def ToolStatusID = (APSH_TOOL_ID+9);
def ToolCmdID = (APSH_TOOL_ID+10);
def ToolCmdReplyID = (APSH_TOOL_ID+11);
def ShutdownToolID = (APSH_TOOL_ID+12);

def AGA_Dummy = (TAG_USER);
def AGA_Path = (AGA_Dummy+1);
def AGA_XRefList = (AGA_Dummy+2);
def AGA_Activate = (AGA_Dummy+3);
def AGA_Context = (AGA_Dummy+4);
def AGA_HelpGroup = (AGA_Dummy+5);
def AGA_Reserved1 = (AGA_Dummy+6);
def AGA_Reserved2 = (AGA_Dummy+7);
def AGA_Reserved3 = (AGA_Dummy+8);
def AGA_ARexxPort = (AGA_Dummy+9);
def AGA_ARexxPortName = (AGA_Dummy+10);

struct AmigaGuideMsg is
  agm_Msg:Message;
  agm_Type:ulong;
  agm_Data:ulong;
  agm_DSize:ulong;
  agm_DType:ulong;
  agm_Pri_Ret:ulong;
  agm_Sec_Ret:ulong;
  agm_System1:ulong;
  agm_System2:ulong;
;

struct NewAmigaGuide is
  nag_Lock:long;
  nag_Name:ulong;
  nag_Screen:ulong;
  nag_PubScreen:ulong;
  nag_HostPort:ulong;
  nag_ClientPort:ulong;
  nag_BaseName:ulong;
  nag_Flags:ulong;
  nag_Context:ulong;
  nag_Node:ulong;
  nag_Line:long;
  nag_Extens:ulong;
  nag_Client:ulong;
;

def HTF_LOAD_INDEX = (1<<0);
def HTF_LOAD_ALL = (1<<1);
def HTF_CACHE_NODE = (1<<2);
def HTF_CACHE_DB = (1<<3);
def HTF_UNIQUE = (1<<15);
def HTF_NOACTIVATE = (1<<16);

def HTFC_SYSGADS = $80000000;

def HTH_OPEN = 0;
def HTH_CLOSE = 1;

def HTERR_NOT_ENOUGH_MEMORY = 100;
def HTERR_CANT_OPEN_DATABASE = 101;
def HTERR_CANT_FIND_NODE = 102;
def HTERR_CANT_OPEN_NODE = 103;
def HTERR_CANT_OPEN_WINDOW = 104;
def HTERR_INVALID_COMMAND = 105;
def HTERR_CANT_COMPLETE = 106;
def HTERR_PORT_CLOSED = 107;
def HTERR_CANT_CREATE_PORT = 108;
def HTERR_KEYWORD_NOT_FOUND = 113;

struct XRef is
  xr_Node:Node;
  xr_Pad:uword;
  xr_DF:ulong;
  xr_File:ulong;
  xr_Name:ulong;
  xr_Line:long;
;

def XRSIZE = (sizeof(XRef));

def XR_GENERIC = 0;
def XR_FUNCTION = 1;
def XR_COMMAND = 2;
def XR_INCLUDE = 3;
def XR_MACRO = 4;
def XR_STRUCT = 5;
def XR_FIELD = 6;
def XR_TYPEDEF = 7;
def XR_DEFINE = 8;

struct AmigaGuideHost is
  agh_Dispatcher:Hook;
  agh_Reserved:ulong;
  agh_Flags:ulong;
  agh_UseCnt:ulong;
  agh_SystemData:ulong;
  agh_UserData:ulong;
;

def HM_FINDNODE = 1;
def HM_OPENNODE = 2;
def HM_CLOSENODE = 3;
def HM_EXPUNGE = 10;

struct opFindHost is
  MethodID:ulong;
  ofh_Attrs:ulong;
  ofh_Node:ulong;
  ofh_TOC:ulong;
  ofh_Title:ulong;
  ofh_Next:ulong;
  ofh_Prev:ulong;
;

struct opNodeIO is
  MethodID:ulong;
  onm_Attrs:ulong;
  onm_Node:ulong;
  onm_FileName:ulong;
  onm_DocBuffer:ulong;
  onm_BuffLen:ulong;
  onm_Flags:ulong;
;

def HTNF_KEEP = (1<<0);
def HTNF_RESERVED1 = (1<<1);
def HTNF_RESERVED2 = (1<<2);
def HTNF_ASCII = (1<<3);
def HTNF_RESERVED3 = (1<<4);
def HTNF_CLEAN = (1<<5);
def HTNF_DONE = (1<<6);

def HTNA_Dummy = (TAG_USER);

def HTNA_Screen = (HTNA_Dummy+1);
def HTNA_Pens = (HTNA_Dummy+2);
def HTNA_Rectangle = (HTNA_Dummy+3);

def HTNA_HelpGroup = (HTNA_Dummy+5);

struct opExpungeNode is
  MethodID:ulong;
  oen_Attrs:ulong;
;

