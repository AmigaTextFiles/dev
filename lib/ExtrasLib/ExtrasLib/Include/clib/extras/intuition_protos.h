#ifndef CLIB_EXTRAS_INTUITION_PROTOS_H
#define CLIB_EXTRAS_INTUITION_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

LONG EZReq(struct Window *Win,
           ULONG *IDCMP_ptr,
           STRPTR Title,
           STRPTR Text,
           STRPTR ButtonText,
           ULONG Arg, ...);

#endif /* CLIB_EXTRAS_INTUITION_PROTOS_H */
