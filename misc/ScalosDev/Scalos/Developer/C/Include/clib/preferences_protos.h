#ifndef CLIB_PREFERENCES_PROTOS_H
#define CLIB_PREFERENCES_PROTOS_H

/*
**  $VER: preferences_protos.h 39.5 (05.06.2000)
**
**  C prototypes. For use with 32 bit integers only
**
**  Copyright © 2000 Satanic Dreams Software
**      All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef SCALOS_PREFERENCES_H
#include <scalos/preferences.h>
#endif

APTR                      AllocPrefsHandle(STRPTR name);
void                      FreePrefsHandle(APTR PrefsHandle);
void                      SetPreferences(APTR PrefsHandle, ULONG ID, ULONG Tag, APTR Struct, UWORD Struct_Size);
ULONG                     GetPreferences(APTR PrefsHandle, ULONG ID, ULONG Tag, APTR Struct, UWORD Struct_Size);
void                      ReadPrefsHandle(APTR PrefsHandle, STRPTR Filename);
void                      WritePrefsHandle(APTR PrefsHandle, STRPTR Filename);
struct PrefsStruct  *     FindPreferences(APTR PrefsHandle, ULONG ID, ULONG Tag);
void                      SetEntry(APTR PrefsHandle, ULONG ID, ULONG Tag, APTR Struct, UWORD Struct_Size, ULONG Entry);
ULONG                     GetEntry(APTR PrefsHandle, ULONG ID, ULONG Tag, APTR Struct, UWORD Struct_Size, ULONG Entry);
ULONG                     RemEntry(APTR PrefsHandle, ULONG ID, ULONG Tag, ULONG Entry);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* CLIB_PREFERENCES_PROTOS_H */

