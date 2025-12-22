#ifndef _VBCCINLINE_SCALOS_H
#define _VBCCINLINE_SCALOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

BOOL                     __SCA_WBStart(__reg("a0") APTR ArgArray ,__reg("a1") APTR Taglist,__reg("d0") ULONG NumArgs ,__reg("a6") void *)="\tjsr\t-30(a6)";
#define SCA_WBStart(x1,x2,x3) __SCA_WBStart((x1),(x2),(x3),ScalosBase)
void                     __SCA_SortNodes(__reg("a0") struct ScalosNodeList *nodelist,__reg("a1") struct Hook *,__reg("d0") ULONG SortType ,__reg("a6") void *)="\tjsr\t-36(a6)";
#define SCA_SortNodes(x1,x2,x3) __SCA_SortNodes((x1),(x2),(x3),ScalosBase)
struct AppObject        * __SCA_NewAddAppIcon(__reg("d0") ULONG ID,__reg("d1") ULONG UserData,__reg("a0") struct Iconobject *,__reg("a1") struct MessagePort *,__reg("a2") APTR Taglist ,__reg("a6") void *)="\tjsr\t-42(a6)";
#define SCA_NewAddAppIcon(x1,x2,x3,x4,x5) __SCA_NewAddAppIcon((x1),(x2),(x3),(x4),(x5),ScalosBase)
BOOL                     __SCA_RemoveAppObject(__reg("a0") struct AppObject * ,__reg("a6") void *)="\tjsr\t-48(a6)";
#define SCA_RemoveAppObject(x1) __SCA_RemoveAppObject((x1),ScalosBase)
struct AppObject        * __SCA_NewAddAppWindow(__reg("d0") ULONG ID,__reg("d1") ULONG UserData,__reg("a0") struct Window *,__reg("a1") struct MessagePort *,__reg("a2") APTR Taglist ,__reg("a6") void *)="\tjsr\t-54(a6)";
#define SCA_NewAddAppWindow(x1,x2,x3,x4,x5) __SCA_NewAddAppWindow((x1),(x2),(x3),(x4),(x5),ScalosBase)
struct AppObject        * __SCA_NewAddAppMenuItem(__reg("d0") ULONG ID,__reg("d1") ULONG UserData,__reg("a0") APTR Text,__reg("a1") struct MessagePort *,__reg("a2") APTR Taglist ,__reg("a6") void *)="\tjsr\t-60(a6)";
#define SCA_NewAddAppMenuItem(x1,x2,x3,x4,x5) __SCA_NewAddAppMenuItem((x1),(x2),(x3),(x4),(x5),ScalosBase)
struct MinNode      * __SCA_AllocStdNode(__reg("a0") struct ScalosNodeList *,__reg("d0") ULONG NodeType ,__reg("a6") void *)="\tjsr\t-66(a6)";
#define SCA_AllocStdNode(x1,x2) __SCA_AllocStdNode((x1),(x2),ScalosBase)
struct MinNode      * __SCA_AllocNode(__reg("a0") struct ScalosNodeList *,__reg("d0") ULONG Size ,__reg("a6") void *)="\tjsr\t-72(a6)";
#define SCA_AllocNode(x1,x2) __SCA_AllocNode((x1),(x2),ScalosBase)
void                     __SCA_FreeNode(__reg("a0") struct ScalosNodeList *,__reg("a1") struct MinNode * ,__reg("a6") void *)="\tjsr\t-78(a6)";
#define SCA_FreeNode(x1,x2) __SCA_FreeNode((x1),(x2),ScalosBase)
void                     __SCA_FreeAllNodes(__reg("a0") struct ScalosNodeList * ,__reg("a6") void *)="\tjsr\t-84(a6)";
#define SCA_FreeAllNodes(x1) __SCA_FreeAllNodes((x1),ScalosBase)
void                     __SCA_MoveNode(__reg("a0") struct ScalosNodeList *,__reg("a1") struct ScalosNodeList *,__reg("d0") struct MinNode * ,__reg("a6") void *)="\tjsr\t-90(a6)";
#define SCA_MoveNode(x1,x2,x3) __SCA_MoveNode((x1),(x2),(x3),ScalosBase)
void                     __SCA_SwapNodes(__reg("a0") struct MinNode *,__reg("a1") struct MinNode *,__reg("a2") struct ScalosNodeList * ,__reg("a6") void *)="\tjsr\t-96(a6)";
#define SCA_SwapNodes(x1,x2,x3) __SCA_SwapNodes((x1),(x2),(x3),ScalosBase)
BOOL                     __SCA_OpenIconWindow(__reg("a0") APTR taglist ,__reg("a6") void *)="\tjsr\t-102(a6)";
#define SCA_OpenIconWindow(x1) __SCA_OpenIconWindow((x1),ScalosBase)
struct ScaWindowList    * __SCA_LockWindowList(__reg("d0") LONG accessmode ,__reg("a6") void *)="\tjsr\t-108(a6)";
#define SCA_LockWindowList(x1) __SCA_LockWindowList((x1),ScalosBase)
void                     __SCA_UnLockWindowList(__reg("a6") void *)="\tjsr\t-114(a6)";
#define SCA_UnLockWindowList() __SCA_UnLockWindowList(ScalosBase)
struct ScalosMessage    * __SCA_AllocMessage(__reg("d0") ULONG messagetype,__reg("d1") UWORD additional_size ,__reg("a6") void *)="\tjsr\t-120(a6)";
#define SCA_AllocMessage(x1,x2) __SCA_AllocMessage((x1),(x2),ScalosBase)
void                     __SCA_FreeMessage(__reg("a1") struct ScalosMessage *message ,__reg("a6") void *)="\tjsr\t-126(a6)";
#define SCA_FreeMessage(x1) __SCA_FreeMessage((x1),ScalosBase)
struct DragHandle       * __SCA_InitDrag(__reg("a0") struct Screen *screen ,__reg("a6") void *)="\tjsr\t-132(a6)";
#define SCA_InitDrag(x1) __SCA_InitDrag((x1),ScalosBase)
void                     __SCA_EndDrag(__reg("a0") struct DragHandle *DragHandle ,__reg("a6") void *)="\tjsr\t-138(a6)";
#define SCA_EndDrag(x1) __SCA_EndDrag((x1),ScalosBase)
BOOL                     __SCA_AddBob(__reg("a0") struct DragHandle *DragHandle,__reg("a1") struct Bitmap *,__reg("a2") APTR Mask,__reg("d0") ULONG Width,__reg("d1") ULONG Height,__reg("d2") LONG XOffset,__reg("d3") LONG YOffset ,__reg("a6") void *)="\tjsr\t-144(a6)";
#define SCA_AddBob(x1,x2,x3,x4,x5,x6,x7) __SCA_AddBob((x1),(x2),(x3),(x4),(x5),(x6),(x7),ScalosBase)
void                     __SCA_DrawDrag(__reg("a0") struct DragHandle *DragHandle,__reg("d0") LONG X,__reg("d1") LONG Y,__reg("d2") ULONG Flags ,__reg("a6") void *)="\tjsr\t-150(a6)";
#define SCA_DrawDrag(x1,x2,x3,x4) __SCA_DrawDrag((x1),(x2),(x3),(x4),ScalosBase)
void                     __SCA_UpdateIcon(__reg("d0") UBYTE WindowType,__reg("a0") APTR UpdateIconStruct,__reg("d1") ULONG ui_SIZE ,__reg("a6") void *)="\tjsr\t-156(a6)";
#define SCA_UpdateIcon(x1,x2,x3) __SCA_UpdateIcon((x1),(x2),(x3),ScalosBase)
ULONG                __SCA_MakeWBArgs(__reg("a0") APTR Buffer,__reg("a1") struct ScaIconNode *,__reg("d0") ULONG ArgsSize ,__reg("a6") void *)="\tjsr\t-162(a6)";
#define SCA_MakeWBArgs(x1,x2,x3) __SCA_MakeWBArgs((x1),(x2),(x3),ScalosBase)
void                     __SCA_FreeWBArgs(__reg("a0") APTR Buffer,__reg("d0") ULONG Number,__reg("d1") ULONG Flags ,__reg("a6") void *)="\tjsr\t-168(a6)";
#define SCA_FreeWBArgs(x1,x2,x3) __SCA_FreeWBArgs((x1),(x2),(x3),ScalosBase)
void                     __SCA_RemapBitmap(__reg("a0") struct Bitmap *SrcBitmap,__reg("a1") struct Bitmap *DestBitmap,__reg("a2") APTR PenArray ,__reg("a6") void *)="\tjsr\t-174(a6)";
#define SCA_RemapBitmap(x1,x2,x3) __SCA_RemapBitmap((x1),(x2),(x3),ScalosBase)
void                     __SCA_ScreenTitleMsg(__reg("a0") APTR Format,__reg("a1") APTR Args ,__reg("a6") void *)="\tjsr\t-180(a6)";
#define SCA_ScreenTitleMsg(x1,x2) __SCA_ScreenTitleMsg((x1),(x2),ScalosBase)
struct ScalosClass      * __SCA_MakeScalosClass(__reg("a0") APTR ClassName,__reg("a1") APTR SuperClassName,__reg("a2") UWORD InstSize,__reg("d0") APTR DispFunc ,__reg("a6") void *)="\tjsr\t-186(a6)";
#define SCA_MakeScalosClass(x1,x2,x3,x4) __SCA_MakeScalosClass((x1),(x2),(x3),(x4),ScalosBase)
BOOL                     __SCA_FreeScalosClass(__reg("a0") struct ScalosClass *ScalosClass ,__reg("a6") void *)="\tjsr\t-192(a6)";
#define SCA_FreeScalosClass(x1) __SCA_FreeScalosClass((x1),ScalosBase)
struct Object           * __SCA_NewScalosObject(__reg("a0") APTR ClassName,__reg("a1") APTR TagList ,__reg("a6") void *)="\tjsr\t-198(a6)";
#define SCA_NewScalosObject(x1,x2) __SCA_NewScalosObject((x1),(x2),ScalosBase)
void                     __SCA_DisposeScalosObject(__reg("a0") struct Object *Object ,__reg("a6") void *)="\tjsr\t-204(a6)";
#define SCA_DisposeScalosObject(x1) __SCA_DisposeScalosObject((x1),ScalosBase)

#endif

