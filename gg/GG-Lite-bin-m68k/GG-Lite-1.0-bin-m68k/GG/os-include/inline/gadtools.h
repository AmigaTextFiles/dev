#ifndef _INLINE_GADTOOLS_H
#define _INLINE_GADTOOLS_H

#ifndef CLIB_GADTOOLS_PROTOS_H
#define CLIB_GADTOOLS_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef  LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

#ifndef GADTOOLS_BASE_NAME
#define GADTOOLS_BASE_NAME GadToolsBase
#endif

#define CreateGadgetA(kind, gad, ng, taglist) \
	LP4(0x1e, struct Gadget *, CreateGadgetA, ULONG, kind, d0, struct Gadget *, gad, a0, const struct NewGadget *, ng, a1, const struct TagItem *, taglist, a2, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateGadget(kind, gad, ng, tags...) \
	({ULONG _tags[] = {tags}; CreateGadgetA((kind), (gad), (ng), (const struct TagItem *) _tags);})
#endif

#define FreeGadgets(gad) \
	LP1NR(0x24, FreeGadgets, struct Gadget *, gad, a0, \
	, GADTOOLS_BASE_NAME)

#define GT_SetGadgetAttrsA(gad, win, req, taglist) \
	LP4NR(0x2a, GT_SetGadgetAttrsA, struct Gadget *, gad, a0, struct Window *, win, a1, struct Requester *, req, a2, const struct TagItem *, taglist, a3, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GT_SetGadgetAttrs(gad, win, req, tags...) \
	({ULONG _tags[] = {tags}; GT_SetGadgetAttrsA((gad), (win), (req), (const struct TagItem *) _tags);})
#endif

#define CreateMenusA(newmenu, taglist) \
	LP2(0x30, struct Menu *, CreateMenusA, const struct NewMenu *, newmenu, a0, const struct TagItem *, taglist, a1, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CreateMenus(newmenu, tags...) \
	({ULONG _tags[] = {tags}; CreateMenusA((newmenu), (const struct TagItem *) _tags);})
#endif

#define FreeMenus(menu) \
	LP1NR(0x36, FreeMenus, struct Menu *, menu, a0, \
	, GADTOOLS_BASE_NAME)

#define LayoutMenuItemsA(firstitem, vi, taglist) \
	LP3(0x3c, BOOL, LayoutMenuItemsA, struct MenuItem *, firstitem, a0, APTR, vi, a1, const struct TagItem *, taglist, a2, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define LayoutMenuItems(firstitem, vi, tags...) \
	({ULONG _tags[] = {tags}; LayoutMenuItemsA((firstitem), (vi), (const struct TagItem *) _tags);})
#endif

#define LayoutMenusA(firstmenu, vi, taglist) \
	LP3(0x42, BOOL, LayoutMenusA, struct Menu *, firstmenu, a0, APTR, vi, a1, const struct TagItem *, taglist, a2, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define LayoutMenus(firstmenu, vi, tags...) \
	({ULONG _tags[] = {tags}; LayoutMenusA((firstmenu), (vi), (const struct TagItem *) _tags);})
#endif

#define GT_GetIMsg(iport) \
	LP1(0x48, struct IntuiMessage *, GT_GetIMsg, struct MsgPort *, iport, a0, \
	, GADTOOLS_BASE_NAME)

#define GT_ReplyIMsg(imsg) \
	LP1NR(0x4e, GT_ReplyIMsg, struct IntuiMessage *, imsg, a1, \
	, GADTOOLS_BASE_NAME)

#define GT_RefreshWindow(win, req) \
	LP2NR(0x54, GT_RefreshWindow, struct Window *, win, a0, struct Requester *, req, a1, \
	, GADTOOLS_BASE_NAME)

#define GT_BeginRefresh(win) \
	LP1NR(0x5a, GT_BeginRefresh, struct Window *, win, a0, \
	, GADTOOLS_BASE_NAME)

#define GT_EndRefresh(win, complete) \
	LP2NR(0x60, GT_EndRefresh, struct Window *, win, a0, LONG, complete, d0, \
	, GADTOOLS_BASE_NAME)

#define GT_FilterIMsg(imsg) \
	LP1(0x66, struct IntuiMessage *, GT_FilterIMsg, const struct IntuiMessage *, imsg, a1, \
	, GADTOOLS_BASE_NAME)

#define GT_PostFilterIMsg(imsg) \
	LP1(0x6c, struct IntuiMessage *, GT_PostFilterIMsg, struct IntuiMessage *, imsg, a1, \
	, GADTOOLS_BASE_NAME)

#define CreateContext(glistptr) \
	LP1(0x72, struct Gadget *, CreateContext, struct Gadget **, glistptr, a0, \
	, GADTOOLS_BASE_NAME)

#define DrawBevelBoxA(rport, left, top, width, height, taglist) \
	LP6NR(0x78, DrawBevelBoxA, struct RastPort *, rport, a0, LONG, left, d0, LONG, top, d1, LONG, width, d2, LONG, height, d3, const struct TagItem *, taglist, a1, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DrawBevelBox(rport, left, top, width, height, tags...) \
	({ULONG _tags[] = {tags}; DrawBevelBoxA((rport), (left), (top), (width), (height), (const struct TagItem *) _tags);})
#endif

#define GetVisualInfoA(screen, taglist) \
	LP2(0x7e, APTR, GetVisualInfoA, struct Screen *, screen, a0, const struct TagItem *, taglist, a1, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetVisualInfo(screen, tags...) \
	({ULONG _tags[] = {tags}; GetVisualInfoA((screen), (const struct TagItem *) _tags);})
#endif

#define FreeVisualInfo(vi) \
	LP1NR(0x84, FreeVisualInfo, APTR, vi, a0, \
	, GADTOOLS_BASE_NAME)

#define GT_GetGadgetAttrsA(gad, win, req, taglist) \
	LP4(0xae, LONG, GT_GetGadgetAttrsA, struct Gadget *, gad, a0, struct Window *, win, a1, struct Requester *, req, a2, const struct TagItem *, taglist, a3, \
	, GADTOOLS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GT_GetGadgetAttrs(gad, win, req, tags...) \
	({ULONG _tags[] = {tags}; GT_GetGadgetAttrsA((gad), (win), (req), (const struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_GADTOOLS_H  */
