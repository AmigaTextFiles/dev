	IFND LIBRARIES_TRITON_LIB_I
LIBRARIES_TRITON_LIB_I SET 1
**
**	$Filename: libraries/triton_lib.i $
**	$Release: 1.1 $
**
**	Translated to assembly language by Oskar Liljeblad
**
**	(C) Copyright 1991-1994 Stefan Zeiger
**	All Rights Reserved
**

	IFND    EXEC_TYPES_I
	include "exec/types.i"
	ENDC
	IFND    EXEC_NODES_I
	include "exec/nodes.i"
	ENDC
	IFND    EXEC_LISTS_I
	include "exec/lists.i"
	ENDC
	IFND    EXEC_LIBRARIES_I
	include "exec/libraries.i"
	ENDC

	LIBINIT

	LIBDEF _LVOTR_OpenProject
	LIBDEF _LVOTR_CloseProject
	LIBDEF _LVOTR_FirstOccurance
	LIBDEF _LVOTR_NumOccurances
	LIBDEF _LVOTR_GetErrorString
	LIBDEF _LVOTR_SetAttribute
	LIBDEF _LVOTR_GetAttribute
	LIBDEF _LVOTR_LockProject
	LIBDEF _LVOTR_UnlockProject
	LIBDEF _LVOTR_AutoRequest
	LIBDEF _LVOTR_EasyRequest
	LIBDEF _LVOTR_CreateApp
	LIBDEF _LVOTR_DeleteApp
	LIBDEF _LVOTR_GetMsg
	LIBDEF _LVOTR_ReplyMsg
	LIBDEF _LVOTR_Wait
	LIBDEF _LVOTR_CloseWindowSafely
	LIBDEF _LVOTR_GetLastError
	LIBDEF _LVOTR_LockScreen
	LIBDEF _LVOTR_UnlockScreen

	ENDC ; LIBRARIES_TRITON_LIB_I
