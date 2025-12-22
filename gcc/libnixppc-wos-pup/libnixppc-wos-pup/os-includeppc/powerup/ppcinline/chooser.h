/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_CHOOSER_H
#define _PPCINLINE_CHOOSER_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef CHOOSER_BASE_NAME
#define CHOOSER_BASE_NAME ChooserBase
#endif /* !CHOOSER_BASE_NAME */

#define AllocChooserNodeA(tags) \
	LP1(0x24, struct Node *, AllocChooserNodeA, struct TagItem *, tags, a0, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocChooserNode(tags...) \
	({ULONG _tags[] = { tags }; AllocChooserNodeA((struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define CHOOSER_GetClass() \
	LP0(0x1e, Class *, CHOOSER_GetClass, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FreeChooserNode(node) \
	LP1NR(0x2a, FreeChooserNode, struct Node *, node, a0, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetChooserNodeAttrsA(node, tags) \
	LP2NR(0x36, GetChooserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetChooserNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetChooserNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define HideChooser(obj, win) \
	LP2NR(0x42, HideChooser, Object *, obj, a0, struct Window *, win, a1, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetChooserNodeAttrsA(node, tags) \
	LP2NR(0x30, SetChooserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetChooserNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetChooserNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define ShowChooser(obj, win, xpos, ypos) \
	LP4(0x3c, ULONG, ShowChooser, Object *, obj, a0, struct Window *, win, a1, ULONG, xpos, d0, ULONG, ypos, d1, \
	, CHOOSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_CHOOSER_H */
