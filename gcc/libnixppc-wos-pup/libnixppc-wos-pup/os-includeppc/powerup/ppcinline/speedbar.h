/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_SPEEDBAR_H
#define _PPCINLINE_SPEEDBAR_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef SPEEDBAR_BASE_NAME
#define SPEEDBAR_BASE_NAME SpeedBarBase
#endif /* !SPEEDBAR_BASE_NAME */

#define AllocSpeedButtonNodeA(number, tags) \
	LP2(0x24, struct Node *, AllocSpeedButtonNodeA, UWORD, number, d0, struct TagItem *, tags, a0, \
	, SPEEDBAR_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocSpeedButtonNode(a0, tags...) \
	({ULONG _tags[] = { tags }; AllocSpeedButtonNodeA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define FreeSpeedButtonNode(node) \
	LP1NR(0x2a, FreeSpeedButtonNode, struct Node *, node, a0, \
	, SPEEDBAR_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetSpeedButtonNodeAttrsA(node, tags) \
	LP2NR(0x36, GetSpeedButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, SPEEDBAR_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetSpeedButtonNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetSpeedButtonNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define SPEEDBAR_GetClass() \
	LP0(0x1e, Class *, SPEEDBAR_GetClass, \
	, SPEEDBAR_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetSpeedButtonNodeAttrsA(node, tags) \
	LP2NR(0x30, SetSpeedButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, SPEEDBAR_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetSpeedButtonNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetSpeedButtonNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_SPEEDBAR_H */
