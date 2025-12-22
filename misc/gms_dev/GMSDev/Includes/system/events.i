	IFND SYSTEM_EVENTS_I
SYSTEM_EVENTS_I  SET  1

**
**	$VER: events.i
**
**	(C) Copyright 1996-1998 DreamWorld Productions.
**	    All Rights Reserved
**

	IFND	DPKERNEL_I
	include	'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* Event Object.

TAGS_EVENT = ((ID_SPCTAGS<<16)|ID_EVENT)
VER_EVENT  = 1

    STRUCTURE	OBJEvent,HEAD_SIZEOF
	APTR	EVT_Next      ;Next event node.
	APTR	EVT_Prev      ;Previous event node.
	APTR	EVT_Args      ;Event arguments.
	WORD	EVT_Priority  ;Sets position in the event chain.
	WORD	EVT_Type      ;Event number.
	LONG	EVT_Flags     ;Special flags.
	APTR	EVT_Routine   ;Pointer to the routine that executes.
	APTR	EVT_Task      ;Used for EVF_Task.

EVA_Args     = (TAPTR|EVT_Args)
EVA_Priority = (TWORD|EVT_Priority)
EVA_Type     = (TWORD|EVT_Type)
EVA_Flags    = (TLONG|EVT_Flags)
EVA_Routine  = (TAPTR|EVT_Routine)

******************************************************************************
* Event->Flags

EVF_GLOBAL = $00000001  ;Always call if event occurs (default).
EVF_TASK   = $00000002  ;Only call if I am the active task.

******************************************************************************
* Return flags that can be returned by Event->Routine(), these are acted on
* by CallEventList()

EVR_BREAK = $00000001  ;Do not execute any more events.
EVR_FAIL  = $00000002  ;Return immediately (failure).

******************************************************************************
* Event->Types.

EVT_OnNewTask       = 1   ;A new task is appearing.
EVT_OnRemTask       = 2   ;An existing task is being removed.
EVT_ScreenToFront   = 3   ;Args: <Screen>
EVT_ScreenToBack    = 4   ;Args: <Screen>
EVT_ScreenDisplayed = 5   ;Args: <Screen>
EVT_ScreenHidden    = 6   ;Args: <Screen>
EVT_DiskInsert      = 7   ;Disk inserted by user.
EVT_DiskRemove      = 8   ;Disk removed by user.
EVT_SelfDestruct    = 9   ;Receives: <Task>
EVT_LowMemory       = 10  ;Args: <PercentageLeft>
EVT_SystemDisable   = 11  ;Switching between operating systems.
EVT_SystemEnable    = 12  ;Switching between operating systems.
EVT_UserFocus       = 13  ;When the user focuses on a new task.

EVT_END     = 100    ;Maximum amount of events for this version.

  ENDC	;SYSTEM_EVENTS_I
