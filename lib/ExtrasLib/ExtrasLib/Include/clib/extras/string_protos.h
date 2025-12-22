#ifndef CLIB_EXTRAS_STRING_PROTOS_H
#define CLIB_EXTRAS_STRING_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/* CopyString.o */
STRPTR CopyString(STRPTR Source,ULONG MemFlags);

/* IsWhiteSpace.o */
BOOL IsWhiteSpace(char Char);  

/* PhraseInStr.o */
STRPTR PhraseInStr(STRPTR InStr,STRPTR Phrase);

/* StrInStr.o */
STRPTR StrIStr(STRPTR InStr,STRPTR SearchStr);

/* Strip.o */
void Strip(STRPTR Str);

#endif /* CLIB_EXTRAS_STRING_PROTOS_H */
