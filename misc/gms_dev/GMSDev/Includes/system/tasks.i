	IFND SYSTEM_TASKS_I
SYSTEM_TASKS_I  SET  1

**
**  $VER: tasks.i
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND	DPKERNEL_I
	include	'dpkernel/dpkernel.i'
	ENDC

*****************************************************************************
* Task object.

VER_TASK  = 2
TAGS_TASK = ((ID_SPCTAGS<<16)|ID_TASK)

    STRUCTURE	DPKTask,HEAD_SIZEOF
	APTR	GT_UserData        ;[RW] Pointer to user data, no restrictions.
	APTR	GT_Name            ;[RI] Name of the task if specified. (READ ONLY)
	APTR	GT_MasterPrefs     ;[--] Master preferences.
	APTR	GT_ScreenPrefs     ;[--] Screen preferences.
	APTR	GT_SoundPrefs      ;[--] Sound preferences.
	APTR	GT_BlitterPrefs    ;[--] Blitter preferences.
	APTR	GT_ResourceChain   ;[--] The resource chain, private.
	LONG	GT_ReqStatus       ;[--] Used internally.
	LONG	GT_BlitKey         ;[--] Used to store resource key.
	LONG	GT_AudioKey        ;[--] Used to store resource key.
	LONG	GT_ExecNode        ;[--] Task's exec node.
	APTR	GT_DestructStack   ;[--] Pointer to self destruct exit stack.
	APTR	GT_DestructCode    ;[--] Pointer to self destruct exit code.
	BYTE	GT_AlertState      ;[--] On/Off.
	BYTE	GT_Switched        ;[--] Set if task is in Switch().
	WORD	GT_DebugStep       ;[--] Debug tree stepping position.
	BYTE	GT_AwakeSig        ;[--] Signal for waking this task.
	BYTE	GT_Pad             ;[--] Reserved.
	WORD	GT_DPKTable        ;[-I] Type of jump table for dpkernel.
	LONG	GT_TotalData       ;[R-] Total data memory in use.
	LONG	GT_TotalVideo      ;[R-] Total video memory in use.
	LONG	GT_TotalSound      ;[R-] Total sound memory in use.
	LONG	GT_TotalBlit       ;[R-] Total blitter memory in use.
	APTR	GT_Code            ;[-I] Start of program.
	APTR	GT_Preferences     ;[--] Preferences directory.
	APTR	GT_DPKBase         ;[R-] DPKBase.
	APTR	GT_Author          ;[RI] Who wrote the program.
	APTR	GT_Date            ;[RI] Date of compilation.
	APTR	GT_Copyright       ;[RI] Copyright details.
	APTR	GT_Short           ;[RI] Short description of program.
	WORD	GT_MinDPKVersion   ;[R-] Minimum required DPKernel version.
	WORD	GT_MinDPKRevision  ;[R-] Minimum required DPKernel revision.
	APTR	GT_GVBase          ;[R-] GVBase.
	APTR	GT_Args            ;[RI] Pointer to argument string.
	APTR	GT_Source          ;[RI] Where to load the task details from.
	APTR	GT_prvName         ;[--]
	WORD	GT_DebugState      ;[RW] Debug On/Off

TSK_Name      = (TAPTR|GT_Name)
TSK_DPKTable  = (TWORD|GT_DPKTable)
TSK_Code      = (TAPTR|GT_Code)
TSK_Author    = (TAPTR|GT_Author)
TSK_Date      = (TAPTR|GT_Date)
TSK_Copyright = (TAPTR|GT_Copyright)
TSK_Short     = (TAPTR|GT_Short)
TSK_Args      = (TAPTR|GT_Args)
TSK_Source    = (TAPTR|GT_Source)

CS_OCS =  0
CS_ECS =  1
CS_AGA =  2

  ENDC	;SYSTEM_TASKS_I
