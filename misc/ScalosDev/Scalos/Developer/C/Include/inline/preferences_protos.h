#ifndef _VBCCINLINE_PREFERENCES_H
#define _VBCCINLINE_PREFERENCES_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct PrefsStruct * __AllocPrefsHandle(__reg("a0") APTR Name ,__reg("a6") void *)="\tjsr\t-30(a6)";
#define AllocPrefsHandle(x1) __AllocPrefsHandle((x1),PreferencesBase)
VOID                 __FreePrefsHandle(__reg("a0") struct PrefsStruct *PrefsStruct ,__reg("a6") void *)="\tjsr\t-36(a6)";
#define FreePrefsHandle(x1) __FreePrefsHandle((x1),PreferencesBase)
VOID                 __SetPrefs(__reg("a0") struct PrefsStruct *,__reg("d0") ULONG ID,__reg("d1") ULONG Tag,__reg("a1") APTR Struct,__reg("d2") UWORD Struct_Size ,__reg("a6") void *)="\tjsr\t-42(a6)";
#define SetPrefs(x1,x2,x3,x4,x5) __SetPrefs((x1),(x2),(x3),(x4),(x5),PreferencesBase)
ULONG                __GetPrefs(__reg("a0") struct PrefsStruct *,__reg("d0") ULONG ID,__reg("d1") ULONG Tag,__reg("a1") APTR Struct,__reg("d2") UWORD Struct_Size ,__reg("a6") void *)="\tjsr\t-48(a6)";
#define GetPrefs(x1,x2,x3,x4,x5) __GetPrefs((x1),(x2),(x3),(x4),(x5),PreferencesBase)
VOID                 __ReadPrefsHandle(__reg("a0") struct PrefsStruct *,__reg("a1") APTR Filename ,__reg("a6") void *)="\tjsr\t-54(a6)";
#define ReadPrefsHandle(x1,x2) __ReadPrefsHandle((x1),(x2),PreferencesBase)
VOID                 __WritePrefsHandle(__reg("a0") struct PrefsStruct *,__reg("a1") APTR Filename ,__reg("a6") void *)="\tjsr\t-60(a6)";
#define WritePrefsHandle(x1,x2) __WritePrefsHandle((x1),(x2),PreferencesBase)
struct PrefsStruct * __FindPrefs(__reg("a0") struct PrefsStruct *,__reg("d0") ULONG ID,__reg("d1") ULONG Tag ,__reg("a6") void *)="\tjsr\t-66(a6)";
#define FindPrefs(x1,x2,x3) __FindPrefs((x1),(x2),(x3),PreferencesBase)
VOID                 __SetEntry(__reg("a0") struct PrefsStruct *,__reg("d0") ULONG ID,__reg("d1") ULONG Tag,__reg("a1") APTR Struct,__reg("d2") UWORD Struct_Size,__reg("d3") ULONG Entry ,__reg("a6") void *)="\tjsr\t-72(a6)";
#define SetEntry(x1,x2,x3,x4,x5,x6) __SetEntry((x1),(x2),(x3),(x4),(x5),(x6),PreferencesBase)
ULONG                __GetEntry(__reg("a0") struct PrefsStruct *,__reg("d0") ULONG ID,__reg("d1") ULONG Tag,__reg("a1") APTR Struct,__reg("d2") UWORD Struct_Size,__reg("d3") ULONG Entry ,__reg("a6") void *)="\tjsr\t-78(a6)";
#define GetEntry(x1,x2,x3,x4,x5,x6) __GetEntry((x1),(x2),(x3),(x4),(x5),(x6),PreferencesBase)
BOOL                 __RemEntry(__reg("a0") struct PrefsStruct *,__reg("d0") ULONG ID,__reg("d1") ULONG Tag,__reg("d2") ULONG Entry ,__reg("a6") void *)="\tjsr\t-84(a6)";
#define RemEntry(x1,x2,x3,x4) __RemEntry((x1),(x2),(x3),(x4),PreferencesBase)

#endif /* _VBCCINLINE_PREFERENCES_H */

