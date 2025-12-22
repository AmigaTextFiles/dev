/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_POPCYCLE_H
#define _PPCINLINE_POPCYCLE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef POPCYCLE_BASE_NAME
#define POPCYCLE_BASE_NAME PopCycleBase
#endif /* !POPCYCLE_BASE_NAME */

#define AllocPopCycleNodeA(tags) \
	LP1(0x24, struct Node *, AllocPopCycleNodeA, struct TagItem *, tags, a0, \
	, POPCYCLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocPopCycleNode(tags...) \
	({ULONG _tags[] = { tags }; AllocPopCycleNodeA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define FreePopCycleNode(node) \
	LP1NR(0x2a, FreePopCycleNode, struct Node *, node, a0, \
	, POPCYCLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetPopCycleNodeAttrsA(node, tags) \
	LP2NR(0x36, GetPopCycleNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, POPCYCLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetPopCycleNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetPopCycleNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define POPCYCLE_GetClass() \
	LP0(0x1e, Class *, POPCYCLE_GetClass, \
	, POPCYCLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetPopCycleNodeAttrsA(node, tags) \
	LP2NR(0x30, SetPopCycleNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, POPCYCLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetPopCycleNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetPopCycleNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_POPCYCLE_H */
