/*
 * $RCSfile: EAGUI_protos.h,v $
 *
 * $Author: marcel $
 *
 * $Revision: 3.0 $
 *
 * $Date: 1994/10/27 19:38:56 $
 *
 * $Locker: marcel $
 *
 * $State: Exp $
 */

#ifndef EAGUI_PROTOS_H
#define EAGUI_PROTOS_H

VOID ea_GetMinSizes(struct ea_Object *);
VOID ea_LayoutObjects(struct ea_Object *);
LONG ea_GetObjectLeft(struct ea_Object *, struct ea_Object *);
LONG ea_GetObjectTop(struct ea_Object *, struct ea_Object *);
LONG ea_CreateGadgetList(struct ea_Object *, struct Gadget **, APTR, struct DrawInfo *);
VOID ea_FreeGadgetList(struct ea_Object *, struct Gadget *);
struct ea_Object *ea_NewObjectA(ULONG, struct TagItem *);
struct ea_Object *ea_NewObject(ULONG, ULONG, ...);
LONG ea_TextLength(struct TextAttr *, STRPTR, UBYTE);
LONG ea_TextHeight(struct TextAttr *);
VOID ea_PrintObjects(struct ea_Object *);
VOID ea_DisposeObject(struct ea_Object *);
VOID ea_RenderObjects(struct ea_Object *, struct RastPort *);
LONG ea_NewRelationA(struct ea_Object *, struct Hook *, struct TagItem *);
LONG ea_NewRelation(struct ea_Object *, struct Hook *, ULONG, ...);
ULONG ea_GetAttrsA(struct ea_Object *, struct TagItem *);
ULONG ea_GetAttrs(struct ea_Object *, ULONG, ...);
ULONG ea_SetAttrsA(struct ea_Object *, struct TagItem *);
ULONG ea_SetAttrs(struct ea_Object *, ULONG, ...);
ULONG ea_GetAttr(struct ea_Object *, ULONG);
ULONG ea_SetAttr(struct ea_Object *, ULONG, ULONG);

#endif /* EAGUI_PROTOS_H */
