	IFND	VMEMORY_BASE_I
VMEMORY_BASE_I	SET	1

	IFND	EXEC_TYPES_I
	include exec/types.i
	ENDC
	
	IFND	EXEC_LISTS_I
	include	exec/lists.i
	ENDC

	IFND	EXEC_LIBRARIES_I
	include	exec/libraries.i
	ENDC

	STRUCTURE VMemoryBase,LIB_SIZE
	ULONG	sb_SysLib
	ULONG	sb_DosLib
	APTR	sb_TBase
	ULONG	sb_TCount
	APTR	sb_NEntry
	ULONG	sb_NIndex
	ULONG	sb_OldIndex
	APTR	sb_PagePath
	APTR	sb_RenPath
	APTR	sb_PageName
	ULONG	sb_SegList
	UBYTE	sb_Flags
	UBYTE	sb_pad
	LABEL	VMemoryBase_SIZEOF


VMemoryname	MACRO
	dc.b	'vmemory.library',0
	ENDM
	ENDC

