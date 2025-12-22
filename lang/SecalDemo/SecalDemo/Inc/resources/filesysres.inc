include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";
include "inc/dos/dos.inc";

def FSRNAME = "FileSystem.resource";

struct FileSysResource is
  fsr_Node:Node;
  fsr_Creator:ulong;
  fsr_FileSysEntries:List;
;

struct FileSysEntry is
  fse_Node:Node;
  fse_DosType:ulong;
  fse_Version:ulong;
  fse_PatchFlags:ulong;
  fse_Type:ulong;
  fse_Task:ulong;
  fse_Lock:long;
  fse_Handler:long;
  fse_StackSize:ulong;
  fse_Priority:long;
  fse_Startup:long;
  fse_SegList:long;
  fse_GlobalVec:long;
;

