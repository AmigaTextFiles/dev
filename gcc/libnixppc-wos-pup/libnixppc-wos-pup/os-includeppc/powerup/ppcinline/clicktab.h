/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_CLICKTAB_H
#define _PPCINLINE_CLICKTAB_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef CLICKTAB_BASE_NAME
#define CLICKTAB_BASE_NAME ClickTabBase
#endif /* !CLICKTAB_BASE_NAME */

#define AllocClickTabNodeA(tags) \
	LP1(0x24, struct Node *, AllocClickTabNodeA, struct TagItem *, tags, a0, \
	, CLICKTAB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocClickTabNode(tags...) \
	({ULONG _tags[] = { tags }; AllocClickTabNodeA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CLICKTAB_GetClass() \
	LP0(0x1e, Class *, CLICKTAB_GetClass, \
	, CLICKTAB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeClickTabNode(node) \
	LP1NR(0x2a, FreeClickTabNode, struct Node *, node, a0, \
	, CLICKTAB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetClickTabNodeAttrsA(node, tags) \
	LP2NR(0x36, GetClickTabNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CLICKTAB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetClickTabNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetClickTabNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SetClickTabNodeAttrsA(node, tags) \
	LP2NR(0x30, SetClickTabNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CLICKTAB_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetClickTabNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetClickTabNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_CLICKTAB_H */
