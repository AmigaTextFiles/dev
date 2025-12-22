#ifndef _VBCCINLINE_ICONOBJECT_H
#define _VBCCINLINE_ICONOBJECT_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct Iconobject *  __NewIconObject(__reg("a0") APTR Name,__reg("a1") APTR Taglist ,__reg("a6") void *)="\tjsr\t-30(a6)";
#define NewIconObject(x1,x2) __NewIconObject((x1),(x2),IconobjectBase)
void                         __DisposeIconObject(__reg("a0") struct Iconobject *iconobject ,__reg("a6") void *)="\tjsr\t-36(a6)";
#define DisposeIconObject(x1) __DisposeIconObject((x1),IconobjectBase)
struct Iconobject *  __GetDefIconObject(__reg("d0") ULONG IconType,__reg("a0") APTR TagList ,__reg("a6") void *)="\tjsr\t-42(a6)";
#define GetDefIconObject(x1,x2) __GetDefIconObject((x1),(x2),IconobjectBase)
void                         __PutIconObject(__reg("a0") struct Iconobject *iconobject,__reg("a1") APTR path,__reg("a2") APTR TagList ,__reg("a6") void *)="\tjsr\t-48(a6)";
#define PutIconObject(x1,x2,x3) __PutIconObject((x1),(x2),(x3),IconobjectBase)
ULONG                        __IsIconName(__reg("a0") APTR filename ,__reg("a6") void *)="\tjsr\t-54(a6)";
#define IsIconName(x1) __IsIconName((x1),IconobjectBase)
struct Iconobject *  __Convert2IconObject(__reg("a0") struct DiskObject *diskobject ,__reg("a6") void *)="\tjsr\t-60(a6)";
#define Convert2IconObject(x1) __Convert2IconObject((x1),IconobjectBase)

#endif /* _VBCCINLINE_ICONOBJECT_H */

