Unit WBStart;
(*
 * WBStart.h   V1.4
 *
 * WBStart-Handler data structure definition
 *
 * (c) 1991-93 by Stefan Becker
 *
 * WBStart.PAS -- HSPascal unit of WBStart.
 *
 *)
 
INTERFACE

USES 
	Exec, AmigaDos, Workbench;

TYPE
	{ Structure to send to the WBStart-Handler message port                   }
	{ - wbsm_Name should be relative to wbsm_DirLock                          }
	{ - wbsm_Stack is used as return field (TRUE == program has been started) }
	tWBStartMsg = Record
		wbsm_Msg     : tMessage;
		wbsm_Name    : STRPTR;    { Name of the program  }
		wbsm_DirLock : BPTR;      { Directory lock       }
		wbsm_Stack   : LONG;      { Stack size           }
		wbsm_Prio    : LONG;      { Process priority     }
		wbsm_NumArgs : LONG;      { # of Args in ArgList }
		wbsm_ArgList : pWBArg;    { Pointer to Arguments }
	End;
	
CONST
	{ Name of the handler message port }
	WBS_PORTNAME : String[21] = 'WBStart-Handler Port'#0;
	{ Default name for the WBStart-Handler binary }
	WBS_LOADNAME : String[18] = 'L:WBStart-Handler'#0;

IMPLEMENTATION
End.