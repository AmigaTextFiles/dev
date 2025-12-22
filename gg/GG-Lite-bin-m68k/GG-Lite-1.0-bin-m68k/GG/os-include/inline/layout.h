#ifndef _INLINE_LAYOUT_H
#define _INLINE_LAYOUT_H

#ifndef CLIB_LAYOUT_PROTOS_H
#define CLIB_LAYOUT_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif
#ifndef  GADGETS_LAYOUT_H
#include <gadgets/layout.h>
#endif

#ifndef LAYOUT_BASE_NAME
#define LAYOUT_BASE_NAME LayoutBase
#endif

#define LAYOUT_GetClass() \
	LP0(0x1e, Class *, LAYOUT_GetClass, \
	, LAYOUT_BASE_NAME)

#define ActivateLayoutGadget(gadget, window, requester, object) \
	LP4(0x24, BOOL, ActivateLayoutGadget, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, ULONG, object, d0, \
	, LAYOUT_BASE_NAME)

#define FlushLayoutDomainCache(gadget) \
	LP1NR(0x2a, FlushLayoutDomainCache, struct Gadget *, gadget, a0, \
	, LAYOUT_BASE_NAME)

#define RethinkLayout(gadget, window, requester, refresh) \
	LP4(0x30, BOOL, RethinkLayout, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, LONG, refresh, d0, \
	, LAYOUT_BASE_NAME)

#define LayoutLimits(gadget, limits, font, screen) \
	LP4NR(0x36, LayoutLimits, struct Gadget *, gadget, a0, struct LayoutLimits *, limits, a1, struct TextFont *, font, a2, struct Screen *, screen, a3, \
	, LAYOUT_BASE_NAME)

#define PAGE_GetClass() \
	LP0(0x3c, Class *, PAGE_GetClass, \
	, LAYOUT_BASE_NAME)

#define SetPageGadgetAttrsA(gadget, object, window, requester, tags) \
	LP5A4(0x42, ULONG, SetPageGadgetAttrsA, struct Gadget *, gadget, a0, Object *, object, a1, struct Window *, window, a2, struct Requester *, requester, a3, struct TagItem *, tags, d7, \
	, LAYOUT_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetPageGadgetAttrs(gadget, object, window, requester, tags...) \
	({ULONG _tags[] = {tags}; SetPageGadgetAttrsA((gadget), (object), (window), (requester), (struct TagItem *) _tags);})
#endif

#define RefreshPageGadget(gadget, object, window, requester) \
	LP4NR(0x48, RefreshPageGadget, struct Gadget *, gadget, a0, Object *, object, a1, struct Window *, window, a2, struct Requester *, requester, a3, \
	, LAYOUT_BASE_NAME)

#endif /*  _INLINE_LAYOUT_H  */
