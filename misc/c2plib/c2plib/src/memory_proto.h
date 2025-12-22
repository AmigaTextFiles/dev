
#ifndef C2P_MEMORY_PROTO_H
#define C2P_MEMORY_PROTO_H

#include "sys_helpers_proto.h"





/*----------------
    PROTOTYPES
----------------*/

/* Private */

APTR AllocMemory(APTR mem_mgr, ULONG size, ULONG flags);
VOID ClearMemoryManager(APTR mem_mgr);
APTR CreateMemoryManager();
VOID DeleteMemoryManager(APTR mem_mgr);
VOID FreeMemory(APTR mem_mgr, APTR mem_ptr);
VOID InitMemoryManager(APTR mem_mgr);


#endif /* C2P_MEMORY_PROTO_H */
