{$I "Include:Tasks.i" }
{$I "Include:Ports.i" }

TYPE
Process=Record
   pr_Task       : Task;
   pr_MsgPort    : MsgPort;
   pr_Pad        : Short;
   pr_SegList    : Address;
   pr_StackSize  : Integer;
   pr_GlobVec    : Address;
   pr_TaskNum    : Integer;
   pr_StackBase  : Address;
   pr_Result2    : Integer;
   pr_CurrentDir,
   pr_CIS,
   pr_COS        : Address;
   pr_ConsoleTask,
   pr_FileSystemTask : Address;
   pr_CLI        : Address;
   pr_ReturnAddr,
   pr_PktWait,
   pr_WindowPtr  : Address;
End;
ProcessPtr=^Process;
