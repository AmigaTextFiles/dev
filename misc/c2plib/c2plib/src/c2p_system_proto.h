
#ifndef C2P_SYSTEM_PROTO_H
#define C2P_SYSTEM_PROTO_H



#include <exec/execbase.h>
#include <exec/types.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>

#include "librarybase.h"





/*
    Generic return object, may be represents any kind of type
*/
typedef ULONG OBJECT;





/*----------------
    PROTOTYPES
----------------*/

GLOBAL VOID _C2P_CopyMem(__reg("a0") APTR src, __reg("a1") APTR dest, __reg("d0") LONG size);
GLOBAL OBJECT _C2P_GetSystemIndexedParameter(__reg("d0") ULONG parameter, __reg("d1") ULONG index, __reg("a6") struct LibraryBase *library_base);
GLOBAL OBJECT _C2P_GetSystemParameter(__reg("d0") ULONG parameter, __reg("a6") struct LibraryBase *library_base);





/* Private */

APTR _C2P_AkikoDetect(struct LibraryBase *library_base);
APTR _C2P_AllocMem_System(LONG bytesize, struct LibraryBase *library_base);
ULONG _C2P_CpuDetect(struct LibraryBase *library_base);
VOID _C2P_ExitLibrary(struct LibraryBase *library_base);
VOID _C2P_FreeMem_System(APTR memptr, struct LibraryBase *library_base);
ULONG _C2P_InitLibrary(struct LibraryBase *library_base);


#endif  /* C2P_SYSTEM_PROTO_H */
