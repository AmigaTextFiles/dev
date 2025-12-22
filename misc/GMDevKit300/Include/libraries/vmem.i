	IFND	LIBRARIES_VMEM_I
LIBRARIES_VMEM_I	SET	1
**
**	$Filename: libraries/vmem.i $
**	$Release: 1.0 Includes, V1.0 $
**	$Revision: 1.0 $
**	$Date: 21-04-92 $
**
**	External definitions for vmem.library
**
**	(C) Copyright 1992 Ch. Schneider, Relog AG
**	    All Rights Reserved
**

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC	;EXEC_TYPES_I



VMEMNAME	MACRO
		dc.b	'vmem.library',0
		ENDM


;----- Memory Requirement Types ---------------------------
;----- See the VMAllocMem() documentation for details -----

	BITDEF  VMEM,VIRTUAL,0		; Force virtual memory
	BITDEF  VMEM,VIRTPRI,16		; Preferably virtual memory
	BITDEF  VMEM,PHYSPRI,17		; Preferably physical memory
	BITDEF  VMEM,ALIGN,18		; Try to align to page base


;----- Function calls
	LIBINIT
	LIBDEF	_LVOVMAllocMem
	LIBDEF	_LVOVMFreeMem
	LIBDEF	_LVOVMAvailMem
	LIBDEF	_LVOVMTypeOfMem
	LIBDEF	_LVOVMGetPageSize
	LIBDEF	_LVOVMAllocVec
	LIBDEF	_LVOVMFreeVec

	ENDC	;LIBRARIES_VMEM_I
