	IFND LIBRARIES_PATCH_TAGS_I
LIBRARIES_PATCH_TAGS_I SET 1
**
**	Filename:	libraries/patchtags.i
**	Release:	6.0 Beta
**	Date:		29.01.97
**
**	(C) Copyright 1993-97 Stefan Fuchs
**	All rights reserved
**
**      definition of patch.library tags


	IFND UTILITY_TAGITEM_I
	INCLUDE "utility/tagitem.i"
	ENDC

;-------------------------------------------------------------------------
;I: InstallPatchTags()
;R: RemovePatchTags()
;F: FindPatchTags()
;S: SetPatch()
;G: GetPatch()

	ENUM TAG_USER+$5000

	EITEM PATT_LibraryName		;I:  STRPTR Pointer to a library name
	EITEM PATT_DeviceName		;I:  STRPTR Pointer to a device name
	EITEM PATT_LibraryBase		;I:  (struct Library *) Pointer to a library,
					;    device or resource base structure

	EITEM PATT_LibVersion		;I:  ULONG Versionnumber for exec.library/OpenLibrary
					;    Default: NULL (any version)
	EITEM PATT_Reserved01		;as it says
	EITEM PATT_DevFlags		;I:  ULONG Flags for exec.library/OpenDevice()
					;    Default: NULL
	EITEM PATT_DevUnit		;I:  ULONG Unit for exec.library/OpenDevice()
					;    Default: NULL
	EITEM PATT_PatchName		;IF: STRPTR Pointer to an IDString for the patch
					;    Default: No ID-String
					;G:  BOOL
					;    TRUE: Return the name of the patch
	EITEM PATT_Priority		;I:  BYTE Priority (-127...+126) of the patch
					;    Positive priorities indicate that the patchcode will be run before the Original
					;    Negative priorities indicate that the patchcode will be run after the Original
					;    the priority NULL (default) indicates that the patchcode will be run
					;    instead of the Original
					;    Default: NULL
					;N:  BYTE (V5) Priority for notifying other tasks
					;    Default: NULL
					;S:  BYTE (V5) Priority (-127...+126) of the patch
					;G:  BOOL (V5)
					;    TRUE: Get the priority of a patch
	EITEM PATT_NewCodeSize		;I:  ULONG Size of code in bytes starting at funcEntry
					;    Default: NULL (no copy)
	EITEM PATT_Result2		;IG: ULONG* Pointer to longword for errorcodes
					;    (see patch.h)

	EITEM PATT_CreateTaskList	;IS: ULONG (V3)
					;    Create a TaskList of the given type
					;    (TL_TYPE_INCLUDE / TL_TYPE_EXCLUDE)
					;    (see patch.h)
	EITEM PATT_DeleteTaskList	;IS: BOOL (V3)
					;    TRUE: Delete any existing TaskList
					;    This will be done implicitly, when a patch is removed
	EITEM PATT_AddTaskID		;IS: (struct Task *) (V3)
					;    Add a task address to the patch TaskList
	EITEM PATT_AddTaskName		;IS: STRPTR (V3)
					;    Add a task of the given name to the patch TaskList
	EITEM PATT_AddTaskPattern	;IS: STRPTR (V5)
					;    Add a pattern of tasknames to the patch TaskList
	EITEM PATT_RemTaskID		;S:  (struct Task *) (V3)
					;    Remove a task address from the patch TaskList
	EITEM PATT_RemTaskName		;S:  STRPTR (V3)
					;    Remove a task of the given name from the
					;    patch TaskList
	EITEM PATT_TaskListType		;G:  BOOL (V3)
					;    TRUE: Get the type of the TaskList
	EITEM PATT_TaskList		;G:  BOOL (V3)
					;    TRUE: Return a taglist containing all TaskIDs and
					;          TaskNames attached to a patch

	EITEM PATT_Disabled		;IS: BOOL (V4)
					;    TRUE: Disable a patch
					;    FALSE: Enable a patch
					;G:  BOOL (V4)
					;    TRUE: Return the disable nesting counter
					;          0: Means enabled
	EITEM PATT_NoCase		;F:  BOOL (V4)
					;    TRUE: Compare case-independent
	EITEM PATT_AddRemoveHook	;S:  (struct Hook *) (V4)
					;    Add a Hook, which is called by patch.library
					;    whenever a patch is removed from memory
	EITEM PATT_RemRemoveHook	;S:  (struct Hook *) (V4)
					;    Remove a Hook installed with PATT_AddRemoveTag

;********************************************************************************
;**                                                                            **
;** WARNING: The tag PATT_SaveRegisters has been dropped in V5                 **
;**          PATT_UseXResult can achieve the same result now                   **
;**                                                                            **
;**                                                                            **
;** This tag was only documented here (not in the autodocs)                    **
;** The use of this tag was never reliable and could cause crashes             **
;** So I think no one ever used it.                                            **
;** It also wasted performance for all patches, even those not using this tag  **
;**                                                                            **
;********************************************************************************
;;;	EITEM PATT_SaveRegisters	;I:  ULONG (V4) Register Mask
	EITEM PATT_Reserved02		;    Save all registers specified in the register mask
					;    before entering the patchcode and
					;    restore them when it has completed. This tag
					;    has been mainly implemented to improve support
					;    for programming languages other than Assembler,
					;    which destroy the contents of the registers d0/d1/a0/a1,
					;    when executing functions.
					;    WARNING: This tag does not currently work together
					;    with the Assembler macro FALLBACK!
	EITEM PATT_ProjectID		;I:  APTR (V4) pointer to project the patch belongs to
					;G:  BOOL (V4) if true, return ProjectID of a patch
	EITEM PATT_LastObject		;F:  APTR (V4) Pointer to an object after which
					;    the search starts. This object must be of the
					;    same type as the object normally returned.
	EITEM PATT_ProjectName		;F:  APTR (V4) Find project with the given name

	EITEM PATT_UserData		;S:  ULONG (V5) Add UserData to patch structure
					;G:  BOOL (V5) if true, return UserData
	EITEM PATT_RemTaskPattern	;S:  STRPTR (V5)
					;    Remove a pattern of tasknames from the patch TaskList

;**	ENUM TAG_USER+$5000+30 */

	EITEM PATT_TimeOut		;R:  ULONG Number of ticks (1/50 seconds)
					;    the function should keep trying to remove
					;    the patch, if another task is running in the
					;    patchcode.
					;    Default: NULL
	EITEM PATT_DelayedExpunge	;R:  BOOL Default: TRUE
					;    TRUE: If a non-patch.library patch
					;    was installed after the patch.library
					;    patch for a specific library function
					;    the specified patch will nevertheless
					;    be removed.
					;    BUT some resources will still be kept
					;    allocated by patch.library (e.g.: the
					;    Library Offset Vector will not be 
					;    restored to it's old state).
					;    Patch.library will try to deallocate
					;    those resources automatically, if the
					;    system is getting low on memory or
					;    if you call a patch.library function
					;    that removes or installs patches.
	EITEM PATT_StackSize		;S:  ULONG (V5) Minimum stacksize (in bytes) your function
					;    requires. This value should be a multiple of 4.
					;    If a taskpattern (see PATT_AddtaskPattern) is active,
					;    at least 1500 Bytes should be specified.
					;    DO NOT USE this tag, if you patch one of the following
					;    exec-functions: FindTask(), AllocMem(), FreeMem() or
					;    StackSwap()
					;    Default: NULL:  Do not extend stack
	EITEM PATT_UseXResult		;I:  BOOL (V5) Use the patch.library extended result system.
					;    As many high-level languages do not support changes at
					;    register level, patches with this tag set to TRUE return
					;    a structure with all changed registers in D0.
					;    Default: FALSE: Do not use PatchXResult structures
	EITEM PATT_Original		;I:  *((* )()) (V6) Pointer to a longword or NULL
					;    If you specify this tag you indicate, that you want to
					;    call the original function from within your patchcode.
					;    You may get this pointer by specifying a pointer
					;    to a longword, which will be used in your patchcode to
					;    call the original function (e.g.: jsr LongWord).
					;    If you specify NULL with this tag you can get the
					;    pointer to the original function by a later call to
					;    GetPatch(). See the documentation for more info!!!
					;G:  BOOL (V6) if true, return a pointer to the original
					;    function. Only possible, if patch was installed with
					;    PATT_Original


;-------------------------------------------------------------------------
; types for PATT_CreateTaskList:
TL_TYPE_INCLUDE		= 1	;Type of TaskList is include 
				;(all specified tasks will use the patchroutine, all others will ignore it)
TL_TYPE_EXCLUDE		= 2	;Type of TaskList is exclude
				;(all specified tasks will ignore the patchroutine, all others will use it)
;-------------------------------------------------------------------------

	ENDC	;LIBRARIES_PATCH_TAGS_I
