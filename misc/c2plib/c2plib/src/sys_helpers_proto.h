
#ifndef C2P_SYS_HELPERS_PROTO_H
#define C2P_SYS_HELPERS_PROTO_H



#include <exec/types.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>

#include "librarybase.h"





/*----------------
    PROTOTYPES
----------------*/

IMPORT APTR SYS_AddTail(__reg("a0") APTR list, __reg("a1") APTR node);
IMPORT APTR SYS_AllocMem(__reg("d0") ULONG byte_size, __reg("d1") ULONG attributes);
IMPORT VOID SYS_CloseLibrary(__reg("a1") APTR library);
IMPORT VOID SYS_DisownBlitter(__reg("a6") APTR gfx_base);
IMPORT VOID SYS_FreeMem(__reg("a1") APTR memory_block, __reg("d0") ULONG byte_size);
IMPORT VOID SYS_InitBitMap(__reg("a0") APTR bitmap, __reg("d0") BYTE depth, __reg("d1") UWORD width, __reg("d2") UWORD height, __reg("a6") APTR gfx_base);
IMPORT APTR SYS_OpenLibrary(__reg("a1") STRPTR lib_name, __reg("d0") ULONG version);
IMPORT VOID SYS_OwnBlitter(__reg("a6") APTR gfx_base);
IMPORT VOID SYS_Remove(__reg("a1") APTR node);
IMPORT VOID SYS_WaitBlit(__reg("a6") APTR gfx_base);


#endif  /* C2P_SYS_HELPERS_PROTO_H */
