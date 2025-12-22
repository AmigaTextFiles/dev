#ifndef CLIB_GGDEBUG_PROTOS_H
#define CLIB_GGDEBUG_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

LONG KCmpStr(STRPTR,STRPTR);
APTR KDoFmt(STRPTR, STRPTR, void (*)(), APTR);
LONG KGetChar(VOID);
LONG KMayGetChar(VOID);
LONG KPutChar(LONG);
VOID KPutStr(STRPTR);
APTR VKPrintf(STRPTR, APTR );
LONG KPrintf( STRPTR, ... );

#endif
