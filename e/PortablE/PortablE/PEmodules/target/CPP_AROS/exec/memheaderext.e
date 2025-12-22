/* $Id: memheaderext.h 22869 2005-02-08 21:52:05Z falemagn $ */
OPT NATIVE
MODULE 'target/exec/memory'
MODULE 'target/exec/types'
{#include <exec/memheaderext.h>}
NATIVE {EXEC_MEMHEADEREXT_H} CONST

NATIVE {MemHeaderExt} OBJECT memheaderext
    {mhe_MemHeader}	memheader	:mh
            
    /* Let an external 'driver' manage this memory
       region opaquely.  */
       
    {mhe_UserData}	userdata	:PTR TO APTR
    
    {mhe_Alloc}	alloc	:NATIVE {APTR  (*)   (struct MemHeaderExt *, ULONG size, ULONG *flags)} PTR
    {mhe_Free}	free	:NATIVE {VOID  (*)    (struct MemHeaderExt *, APTR  mem,  ULONG  size)} PTR
    {mhe_AllocAbs}	allocabs	:NATIVE {APTR  (*)(struct MemHeaderExt *, ULONG size, APTR   addr)} PTR
    {mhe_ReAlloc}	realloc	:NATIVE {APTR  (*) (struct MemHeaderExt *, APTR  old,  ULONG  size)} PTR
    {mhe_Avail}	avail	:NATIVE {ULONG (*)   (struct MemHeaderExt *, ULONG flags)} PTR
ENDOBJECT

/* Indicates that the memory region is to be
   treated as an opaque object managed only through the
   functions whose pointers are in the extended mem header.  */
NATIVE {MEMF_MANAGED}  CONST MEMF_MANAGED  = $8000
