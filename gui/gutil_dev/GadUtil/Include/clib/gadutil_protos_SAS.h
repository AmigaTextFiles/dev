#ifndef CLIB_GADUTIL_PROTOS_H
#define CLIB_GADUTIL_PROTOS_H
/*------------------------------------------------------------------------**
**
**	$VER: gadutil_protos.h 37.10 (28.09.97)
**
**	Filename:	clib/gadutil_protos.h
**	Version:	37.10
**	Date:		28-Sep-97
**
**	GadUtil definitions, a dynamic gadget layout system.
**
**	© Copyright 1994-1997 by P-O Yliniemi and Staffan Hämälä.
**
**	All Rights Reserved.
**
**------------------------------------------------------------------------*/

#ifndef LIBRARIES_GADUTIL_H
#include <libraries/gadutil.h>
#endif

APTR GU_LayoutGadgetsA(struct Gadget **, struct LayoutGadget *, struct Screen *, struct TagItem *);
APTR GU_LayoutGadgets(struct Gadget **, struct LayoutGadget *, struct Screen *, Tag tag1, ... );
VOID GU_FreeLayoutGadgets(APTR);
struct Gadget *GU_CreateGadgetA(ULONG, struct Gadget *, struct NewGadget *, struct TagItem *);
struct Gadget *GU_CreateGadget(ULONG, struct Gadget *, struct NewGadget *, Tag tag1, ... );
VOID GU_SetGadgetAttrsA(struct Gadget *, struct Window *, struct Requester *, struct TagItem *);
VOID GU_SetGadgetAttrs(struct Gadget *, struct Window *, struct Requester *, Tag tag1, ... );
struct IntuiMessage *GU_GetIMsg(struct MsgPort *);
ULONG GU_CountNodes(struct List *);
WORD GU_GadgetArrayIndex(WORD, struct LayoutGadget *);
VOID GU_BlockInput(struct Window *);
VOID GU_FreeInput(struct Window *);

VOID GU_FreeGadgets(struct Gadget *);
VOID GU_SetGUGadAttrsA(APTR, struct Gadget *, struct Window *, struct TagItem *);
VOID GU_SetGUGadAttrs(APTR, struct Gadget *, struct Window *, Tag tag1, ... );
BOOL GU_CoordsInGadBox(ULONG, struct Gadget *);
APTR GU_GetGadgetPtr(UWORD, struct LayoutGadget *);
ULONG GU_TextWidth(STRPTR, struct TextAttr *);
STRPTR GU_GetLocaleStr(ULONG, struct Catalog *, struct AppString *);
struct Menu *GU_CreateLocMenuA(struct NewMenu *, APTR, struct TagItem *, struct TagItem *);
struct Menu *GU_CreateLocMenu(struct NewMenu *, APTR, struct TagItem *, Tag tag1, ... );
struct Catalog *GU_OpenCatalog(STRPTR, ULONG);
VOID GU_CloseCatalog(struct Catalog *);
VOID GU_DisableGadget(BOOL, struct Gadget *, struct Window *);
VOID GU_SetToggle(BOOL, struct Gadget *, struct Window *);
VOID GU_RefreshBoxes(struct Window *, APTR);
VOID GU_RefreshWindow(struct Window *, APTR);
struct TextFont *GU_OpenFont(struct TextAttr *);

VOID GU_NewList(struct List *);
VOID GU_ClearList(struct Gadget *, struct Window *, struct List *);
VOID GU_DetachList(struct Gadget *, struct Window *);
VOID GU_AttachList(struct Gadget *, struct Window *, struct List *);
BOOL GU_AddTail(struct Gadget *, STRPTR, struct List *);
VOID GU_ChangeStr(struct Gadget *, STRPTR, struct Window *);

struct Gadget *GU_CreateContext(struct Gadget **glistptr);
LONG GU_GetGadgetAttrsA(struct Gadget *, struct Window *, struct Requester *, struct TagItem *);
LONG GU_GetGadgetAttrs(struct Gadget *, struct Window *, struct Requester *, Tag tag1, ... );
struct Menu *GU_CreateMenusA(struct NewMenu *, struct TagItem *);
struct Menu *GU_CreateMenus(struct NewMenu *, Tag tag1, ... );
void GU_FreeMenus(struct Menu *);
BOOL GU_LayoutMenuItemsA(struct MenuItem *, APTR, struct TagItem *);
BOOL GU_LayoutMenuItems(struct MenuItem *, APTR, Tag tag1, ...);
BOOL GU_LayoutMenusA(struct Menu *, APTR, struct TagItem *);
BOOL GU_LayoutMenus(struct Menu *, APTR, Tag tag1, ... );
APTR GU_GetVisualInfoA(struct Screen *, struct TagItem *);
APTR GU_GetVisualInfo(struct Screen *, Tag tag1, ... );
void GU_FreeVisualInfo(APTR);
void GU_BeginRefresh(struct Window *);
void GU_EndRefresh(struct Window *, long);
struct IntuiMessage *GU_FilterIMsg(struct IntuiMessage *);
struct IntuiMessage *GU_PostFilterIMsg(struct IntuiMessage *);
void GU_ReplyIMsg(struct IntuiMessage *);
void GU_DrawBevelBoxA(struct RastPort *, long, long, long, long, struct TagItem *);
void GU_DrawBevelBox(struct RastPort *, long, long, long, long, Tag tag1, ... );

struct Node *GU_FindNode(struct List *, UWORD);
BOOL GU_NodeUp(struct Node *, struct List *);
BOOL GU_NodeDown(struct Node *, struct List *);

VOID GU_UpdateProgress(struct Window *, APTR, struct ProgressGad *);
VOID GU_SortList(struct List *, struct List *);
BOOL GU_CheckVersion(struct Library *, UWORD, UWORD);

VOID GU_ClearWindow(struct Window *, UWORD);
BOOL GU_SizeWindow(struct Window *, WORD DeltaX, WORD DeltaY);
VOID GU_CloseFont(struct TextFont *);

#endif /* CLIB_GADUTIL_PROTOS_H */
