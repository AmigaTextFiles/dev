#ifndef CLIB_EXTRAS_NNSTRING_PROTOS_H
#define CLIB_EXTRAS_NNSTRING_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXTRAS_NNSTRING_H
#include <extras/nnstring.h>
#endif

STRPTR nns_NextNNStr(STRPTR NNStr);
STRPTR nns_AddNNStr (STRPTR NNStr, STRPTR New);
LONG   nns_NNStrLen (STRPTR NNStr);
STRPTR nns_GetNNData(STRPTR NNStr, STRPTR Name, STRPTR DefVal);

#endif /* CLIB_EXTRAS_NNSTRING_PROTOS_H */
