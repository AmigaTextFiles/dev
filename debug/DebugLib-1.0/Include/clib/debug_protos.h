#ifndef  CLIB_DEBUG_PROTOS_H
#define  CLIB_DEBUG_PROTOS_H

/*
**	$VER: debug_protos.h 37.1 (10.5.96)
**
**	C prototypes. For use with 32 bit integers only.
**
*/

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

/* Debugging support functions */
LONG KStrCmp( STRPTR string1, STRPTR string2 );
LONG KGetChar( VOID );
LONG KMayGetChar( VOID );
LONG KPutChar( LONG outChar );
VOID KPutStr( STRPTR string);
APTR KDoFmt( STRPTR format, STRPTR data, void (*putProc)(), APTR putData );
APTR VKPrintf( STRPTR format, APTR data );
APTR KPrintf(STRPTR format, ... );

#endif	 /* CLIB_ALIB_PROTOS_H */
