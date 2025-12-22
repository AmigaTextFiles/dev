/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_LAYOUT_H
#define _PPCINLINE_LAYOUT_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef LAYOUT_BASE_NAME
#define LAYOUT_BASE_NAME LayoutBase
#endif /* !LAYOUT_BASE_NAME */

#define ActivateLayoutGadget(gadget, window, requester, object) \
	LP4(0x24, BOOL, ActivateLayoutGadget, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, ULONG, object, d0, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FlushLayoutDomainCache(gadget) \
	LP1NR(0x2a, FlushLayoutDomainCache, struct Gadget *, gadget, a0, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LAYOUT_GetClass() \
	LP0(0x1e, Class *, LAYOUT_GetClass, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LayoutLimits(gadget, limits, font, screen) \
	LP4NR(0x36, LayoutLimits, struct Gadget *, gadget, a0, struct LayoutLimits *, limits, a1, struct TextFont *, font, a2, struct Screen *, screen, a3, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PAGE_GetClass() \
	LP0(0x3c, Class *, PAGE_GetClass, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RefreshPageGadget(gadget, object, window, requester) \
	LP4NR(0x48, RefreshPageGadget, struct Gadget *, gadget, a0, Object *, object, a1, struct Window *, window, a2, struct Requester *, requester, a3, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RethinkLayout(gadget, window, requester, refresh) \
	LP4(0x30, BOOL, RethinkLayout, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, LONG, refresh, d0, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetPageGadgetAttrsA(gadget, object, window, requester, tags) \
	LP5A4(0x42, ULONG, SetPageGadgetAttrsA, struct Gadget *, gadget, a0, Object *, object, a1, struct Window *, window, a2, struct Requester *, requester, a3, struct TagItem *, tags, d7, \
	, LAYOUT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetPageGadgetAttrs(a0, a1, a2, a3, tags...) \
	({ULONG _tags[] = { tags }; SetPageGadgetAttrsA((a0), (a1), (a2), (a3), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_LAYOUT_H */
