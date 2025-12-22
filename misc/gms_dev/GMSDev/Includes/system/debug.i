	IFND SYSTEM_DEBUG_I
SYSTEM_DEBUG_I  SET  1

**
**  $VER: debug.i
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

*****************************************************************************

DBG_Message =   3

;DBG_END =	46

STEP  =	1<<31	;Function stepping for tree look.

   STRUCTURE	DB,0
	APTR	DB_Unhook
	APTR	DB_Detach
	APTR	DB_Reset
	APTR	DB_DPKOpened
	APTR	DB_DPKClosed
	APTR	DB_AddSysEvent
	APTR	DB_AddInputHandler
	APTR	DB_AllocAudio
	APTR	DB_AllocBlitter
	APTR	DB_AllocBlitMem
	APTR	DB_AllocMemBlock
	APTR	DB_AllocSoundMem
	APTR	DB_AllocVideoMem
	APTR	DB_Awaken
	APTR	DB_BlankOff
	APTR	DB_BlankOn
	APTR	DB_CopyStructure
	APTR	DB_CreateMasks
	APTR	DB_Display
	APTR	DB_RemSysEvent
	APTR	DB_FingerOfDeath
	APTR	DB_Free
	APTR	DB_FreeAudio
	APTR	DB_FreeBlitter
	APTR	DB_FreeMemBlock
	APTR	DB_Get
	APTR	DB_GetFileObject
	APTR	DB_GetFileObjectList
	APTR	DB_Hide
	APTR	DB_Init
	APTR	DB_InitDestruct
	APTR	DB_Load
	APTR	DB_MoveToBack
	APTR	DB_MoveToFront
	APTR	DB_OpenFile
	APTR	DB_RemInputHandler
	APTR	DB_ReturnDisplay
	APTR	DB_SetBobFrames
	APTR	DB_SelfDestruct
	APTR	DB_Switch
	APTR	DB_TakeDisplay
	APTR	DB_Flush
	APTR	DB_SaveToFile
	APTR	DB_CallEventList
	APTR	DB_Read
	APTR	DB_Write

  ENDC	;SYSTEM_DEBUG_I
