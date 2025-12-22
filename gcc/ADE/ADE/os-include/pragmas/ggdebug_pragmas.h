#ifdef __PPC__
#include <ppcpragmas/ggdebug_pragmas.h>
#else
#pragma libcall GGDebugBase KCmpStr 1e 9802
#pragma libcall GGDebugBase KDoFmt 24 ba9804
#pragma libcall GGDebugBase KGetChar 2a 0
#pragma libcall GGDebugBase KMayGetChar 30 0
#pragma libcall GGDebugBase KPutChar 36 001
#pragma libcall GGDebugBase KPutStr 3c 801
#pragma libcall GGDebugBase VKPrintf 42 9802
#pragma tagcall GGDebugBase KPrintf 42 9802
#endif
