	IFND	SYSTEM_GLOBALBASE_I
SYSTEM_GLOBALBASE_I  SET 1

**
**  $VER: globalbase.i V2.1
**
**  Definition of the dpkernel global base structure.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
**

    IFND    EXEC_LIBRARIES_I
    INCDIR  'INCLUDES:'
    include 'exec/libraries.i'
    ENDC

    ;This is completely private, only modules can access these values.

    STRUCTURE	GVBaseV1,LIB_SIZE
	WORD	gb_ScreenFlip       ;Reserved.
	LONG	gb_SegList          ;Private.
	APTR	gb_DPrintF          ;References DPrintF in Icebreaker.
	WORD	gb_ded3             ;Private.
	WORD	gb_OwnBlitter       ;0 = FALSE, 1 = TRUE.
	WORD	gb_VBLPosition      ;Private.
	BYTE	gb_ScrSwitch        ;Private.
	BYTE	gb_Destruct         ;Private.
	LONG	gb_RandomSeed       ;Random seed.  No need to alter.
	WORD	gb_BlitterUsed      ;0 = Free, 1 = Grabbed.
	WORD	gb_BlitterPriority  ;0 = NoPriority, 1 = Priority.
	APTR	gb_CurrentScreen    ;
	LONG	gb_Ticks            ;Vertical blank ticks counter.
	WORD	gb_HSync            ;Private.
	APTR	gb_SysObjects       ;System object list (master).
	BYTE	gb_DebugActive      ;Set if debugger is currently active.
	BYTE	gb_ScrBlanked       ;Set if screen is currently blanked.
	WORD	gb_Version          ;The version of this GMS.
	WORD	gb_Revision         ;The revision of this GMS.
	APTR	gb_ScreenList       ;List of shown screens, starting from back.
	APTR	gb_ChildSysObjects  ;System object list (hidden & children).
	APTR	gb_SystemTask       ;System Task.
	APTR	gb_ReferenceList    ;List of object references.
	APTR	gb_ScreensModule    ;Pointer to module.
	APTR	gb_BlitterModule    ;Pointer to module.
	APTR	gb_FileModule       ;Pointer to module.
	APTR	gb_KeyModule        ;Required by monitor modules.
	APTR	gb_ScreensBase      ;Module base.
	APTR	gb_BlitterBase      ;Module base.
	APTR	gb_FileBase         ;Module base.
	APTR	gb_KeyBase          ;Required by monitor modules.
	APTR	gb_SoundModule      ;Pointer to module.
	APTR	gb_SoundBase        ;Module base.
	APTR	gb_ModList          ;List of modules.
	APTR	gb_EventArray       ;Array of event nodes.
	LONG	gb_FlipSignal       ;Signal mask.
	APTR	gb_UserFocus        ;Task that has the user focus.
	APTR	gb_Debug            ;Debug routines.
	APTR	gb_TaskList         ;Main task list.
	APTR	gb_ConfigModule     ;Pointer to module.
	LABEL	DPKBASE_SIZEOF

   STRUCTURE	SScreen,0
	APTR	SS_Next             ;Pointer to screen in front of this one.
	APTR	SS_Screen           ;Pointer to this screen's data structure.
	LABEL	SS_SIZEOF

  ENDC ;SYSTEM_GLOBALBASE_I
