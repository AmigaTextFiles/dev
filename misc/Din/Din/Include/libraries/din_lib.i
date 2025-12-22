	IFND	LIBRARIES_DIN_LIB_I
LIBRARIES_DIN_LIB_I SET	1
**
**	$Filename: libraries/din_lib.i $
**	$Release: 1.0 revision 3 $
**
**	© Copyright 1990 Jorrit Tyberghein
**	  All Rights Reserved
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

	LIBDEF _LVONotifyDinLinks
	LIBDEF _LVOResetDinLinkFlags
	LIBDEF _LVOMakeDinObject
	LIBDEF _LVOEnableDinObject
	LIBDEF _LVODisableDinObject
	LIBDEF _LVOPropagateDinObject
	LIBDEF _LVORemoveDinObject
	LIBDEF _LVOLockDinObject
	LIBDEF _LVOUnlockDinObject
	LIBDEF _LVOFindDinObject
	LIBDEF _LVOMakeDinLink
	LIBDEF _LVORemoveDinLink
	LIBDEF _LVOReadLockDinObject
	LIBDEF _LVOReadUnlockDinObject
	LIBDEF _LVOWriteLockDinObject
	LIBDEF _LVOWriteUnlockDinObject
	LIBDEF _LVOLockDinBase
	LIBDEF _LVOUnlockDinBase
	LIBDEF _LVOInfoDinObject
	LIBDEF _LVOFreeInfoDinObject

	ENDC	; LIBRARIES_DIN_LIB_I
