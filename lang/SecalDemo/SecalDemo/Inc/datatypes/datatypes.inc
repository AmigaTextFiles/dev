include "inc/exec/types.inc";
include "inc/exec/lists.inc";
include "inc/exec/nodes.inc";
include "inc/exec/libraries.inc";
include "inc/libraries/iffparse.inc";
include "inc/dos/dos.inc";

struct DataTypeHeader is
  dth_Name:ulong;
  dth_BaseName:ulong;
  dth_Pattern:ulong;
  dth_Mask:ulong;
  dth_GroupID:ulong;
  dth_ID:ulong;
  dth_MaskLen:word;
  dth_Pad:word;
  dth_Flags:uword;
  dth_Priority:uword;
;

def DTHSIZE = sizeof(DataTypeHeader);

def DTF_TYPE_MASK = $000f;
def DTF_BINARY = $0000;
def DTF_ASCII = $0001;
def DTF_IFF = $0002;
def DTF_MISC = $0003;
def DTF_CASE = $0010;
def DTF_SYSTEM1 = $1000;

struct DTHookContext is
  dthc_SysBase:ulong;
  dthc_DOSBase:ulong;
  dthc_IFFParseBase:ulong;
  dthc_UtilityBase:ulong;
  dthc_Lock:long;
  dthc_FIB:ulong;
  dthc_FileHandle:long;
  dthc_IFF:ulong;
  dthc_Buffer:ulong;
  dthc_BufferLength:ulong;
;

struct Tool is
  tn_Which:uword;
  tn_Flags:uword;
  tn_Program:ulong;
;

def TSIZE = sizeof(Tool);

def TW_INFO = 1;
def TW_BROWSE = 2;
def TW_EDIT = 3;
def TW_PRINT = 4;
def TW_MAIL = 5;

def TF_LAUNCH_MASK = $000f;
def TF_SHELL = $0001;
def TF_WORKBENCH = $0002;
def TF_RX = $0003;

struct DataType is
  dtn_Node1:Node;
  dtn_Node2:Node;
  dtn_Header:ulong;
  dtn_ToolList:List;
  dtn_FunctionName:ulong;
  dtn_AttrList:ulong;
  dtn_Length:ulong;
;

def DTNSIZE = sizeof(DataType);

struct ToolNode is
  tn_Node:Node;
  tn_Tool:Tool;
  tn_Length:ulong;
;

def TNSIZE = sizeof(ToolNode);

def DTERROR_UNKNOWN_DATATYPE = 2000;
def DTERROR_COULDNT_SAVE = 2001;
def DTERROR_COULDNT_OPEN = 2002;
def DTERROR_COULDNT_SEND_MESSAGE = 2003;
def DTERROR_COULDNT_OPEN_CLIPBOARD = 2004;
def DTERROR_Reserved = 2005;
def DTERROR_UNKNOWN_COMPRESSION = 2006;
def DTERROR_NOT_ENOUGH_DATA = 2007;
def DTERROR_INVALID_DATA = 2008;

def DTMSG_TYPE_OFFSET = 2100;

