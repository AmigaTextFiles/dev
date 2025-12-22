include "inc/exec/types.inc";
include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/exec/ports.inc";

def CBD_POST = (CMD_NONSTD+0);
def CBD_CURRENTREADID = (CMD_NONSTD+1);
def CBD_CURRENTWRITEID = (CMD_NONSTD+2);
def CBD_CHANGEHOOK = (CMD_NONSTD+3);

def CBERR_OBSOLETEID = 1;

struct ClipboardUnitPartial is
  cu_Node:Node;
  cu_UnitNum:ulong;
;

struct IOClipReq is
  io_Message:Message;
  io_Device:ulong;
  io_Unit:ulong;
  io_Command:uword;
  io_Flags:ubyte;
  io_Error:byte;
  io_Actual:ulong;
  io_Length:ulong;
  io_Data:ulong;
  io_Offset:ulong;
  io_ClipID:long;
;

def PRIMARY_CLIP = 0;

struct SatisfyMsg is
  sm_Msg:Message;
  sm_Unit:uword;
  sm_ClipID:long;
;

struct ClipHookMsg is
  chm_Type:ulong;
  chm_ChangeCmd:long;
  chm_ClipID:long;
;

