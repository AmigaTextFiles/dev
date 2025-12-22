#ifndef  CLIB_VMEM_PROTOS_H
#define  CLIB_VMEM_PROTOS_H
/*
**	$Filename: clib/vmem_protos.h $
**	$Release: 0.9 Includes, V0.9 $
**	$Revision: 0.9 $
**	$Date: 92/03/05 $
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1992 Ch. Schneider, Relog AG
**	    All Rights Reserved
*/
#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_VMEM_H
#include <libraries/vmem.h>
#endif
/*--- functions in V0.9 or higher ---*/

APTR VMAllocMem( unsigned long byteSize, unsigned long requirements, unsigned long flags );
void VMFreeMem( APTR memoryBlock, unsigned long byteSize );
ULONG VMAvailMem( unsigned long requirements, unsigned long flags );
BOOL VMTypeOfMem( APTR address );
ULONG VMGetPageSize( void );
APTR VMAllocVec( unsigned long byteSize, unsigned long requirements, unsigned long flags );
void VMFreeVec( APTR memoryBlock );
#endif	 /* CLIB_VMEML_PROTOS_H */
