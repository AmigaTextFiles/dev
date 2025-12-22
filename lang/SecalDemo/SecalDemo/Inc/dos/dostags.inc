include "inc/utility/tagitem.inc";

def SYS_Dummy = (TAG_USER+32);

def SYS_Input = (SYS_Dummy+1);
def SYS_Output = (SYS_Dummy+2);
def SYS_Asynch = (SYS_Dummy+3);
def SYS_UserShell = (SYS_Dummy+4);
def SYS_CustomShell = (SYS_Dummy+5);

def NP_Dummy = (TAG_USER+1000);

def NP_Seglist = (NP_Dummy+1);
def NP_FreeSeglist = (NP_Dummy+2);
def NP_Entry = (NP_Dummy+3);
def NP_Input = (NP_Dummy+4);
def NP_Output = (NP_Dummy+5);
def NP_CloseInput = (NP_Dummy+6);
def NP_CloseOutput = (NP_Dummy+7);
def NP_Error = (NP_Dummy+8);
def NP_CloseError = (NP_Dummy+9);
def NP_CurrentDir = (NP_Dummy+10);
def NP_StackSize = (NP_Dummy+11);
def NP_Name = (NP_Dummy+12);
def NP_Priority = (NP_Dummy+13);
def NP_ConsoleTask = (NP_Dummy+14);
def NP_WindowPtr = (NP_Dummy+15);
def NP_HomeDir = (NP_Dummy+16);
def NP_CopyVars = (NP_Dummy+17);
def NP_Cli = (NP_Dummy+18);
def NP_Path = (NP_Dummy+19);
def NP_CommandName = (NP_Dummy+20);
def NP_Arguments = (NP_Dummy+21);
def NP_NotifyOnDeath = (NP_Dummy+22);
def NP_Synchronous = (NP_Dummy+23);
def NP_ExitCode = (NP_Dummy+24);
def NP_ExitData = (NP_Dummy+25);

def ADO_Dummy = (TAG_USER+2000);
def ADO_FH_Mode = (ADO_Dummy+1);
def ADO_DirLen = (ADO_Dummy+2);
def ADO_CommNameLen = (ADO_Dummy+3);
def ADO_CommFileLen = (ADO_Dummy+4);
def ADO_PromptLen = (ADO_Dummy+5);

