
#include    <exec/types.h>
#include    <exec/memory.h>
#include    <clib/exec_protos.h>
#include    <pragmas/exec_pragmas.h>

ULONG __saveds __asm LIBslre_match( register __a0 APTR regexp, register __a1 APTR s, register __d0 ULONG s_len,
                                    register __a2 APTR caps, register __d1 ULONG num_caps, register __d2 ULONG flags);