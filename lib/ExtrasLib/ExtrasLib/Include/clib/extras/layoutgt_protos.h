#ifndef CLIB_EXTRAS_LAYOUTGT_PROTOS_H
#define CLIB_EXTRAS_LAYOUTGT_PROTOS_H

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

#ifndef EXTRAS_LAYOUTGT_H
#include <extras/layoutgt.h>
#endif 

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

struct LG_Control * LG_CreateGadgets(Tag Tags, ...);
struct LG_Control * LG_CreateGadgetsA(struct TagItem *TagList);

void   LG_FreeGadgets(struct LG_Control *Con);

void   LG_AddGadgets(struct Window *Win, struct LG_Control *Con);

void   LG_RemoveGadgets(struct LG_Control *Con);

struct Gadget *LG_GetGadget(struct LG_Control *Con, ULONG GadID);

struct Gadget *LG_FindGadget(ULONG GadID, ULONG ConCount, struct LG_Control **Con, ... );

BOOL   LG_SetGadgetAttrs(struct LG_Control *Con, ULONG GadID, Tag Tags, ...);

ULONG  LG_GetGadgetAttrs(struct LG_Control *Con, ULONG GadID, Tag Tags, ...);

BOOL   LG_GadForKey(struct LG_Control *Control, UBYTE Key, ULONG *GadID, ULONG *Code);

struct LG_GadgetIndex *LG_GetGI(struct LG_Control *Con, ULONG GadID);
WORD   LG_FigureLeftEdge(struct LG_Control *Con, ULONG Code, struct IBox *Bounds, struct lg_DimInfo *Data);
WORD   LG_FigureWidth   (struct LG_Control *Con, ULONG Code, struct IBox *Bounds, WORD LeftEdge, struct lg_DimInfo *Data);
WORD   LG_FigureTopEdge (struct LG_Control *Con, ULONG Code, struct IBox *Bounds, struct lg_DimInfo *Data);
WORD   LG_FigureHeight  (struct LG_Control *Con, ULONG Code, struct IBox *Bounds, WORD TopEdge, struct lg_DimInfo *Data);
void LG_AddLGControl(struct LG_Control *Parent, struct LG_Control *Child);
BOOL LG_RemoveLGControl(struct LG_Control *Parent, struct LG_Control *Child);



#endif /* CLIB_EXTRAS_LAYOUTGT_PROTOS_H */
