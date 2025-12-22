include "inc/exec/types.inc";
include "inc/exec/ports.inc";
include "inc/dos/dos.inc";

struct WBStartup is
  sm_Message:Message;
  sm_Process:ulong;
  sm_Segment:long;
  sm_NumArgs:long;
  sm_ToolWindow:ulong;
  sm_ArgList:ulong;
;

struct WBArg is
  wa_Lock:long;
  wa_Name:ulong;
;

