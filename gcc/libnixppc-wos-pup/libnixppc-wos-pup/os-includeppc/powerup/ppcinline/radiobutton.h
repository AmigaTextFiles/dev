/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_RADIOBUTTON_H
#define _PPCINLINE_RADIOBUTTON_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef RADIOBUTTON_BASE_NAME
#define RADIOBUTTON_BASE_NAME RadioButtonBase
#endif /* !RADIOBUTTON_BASE_NAME */

#define AllocRadioButtonNodeA(columns, tags) \
	LP2(0x24, struct Node *, AllocRadioButtonNodeA, UWORD, columns, d0, struct TagItem *, tags, a0, \
	, RADIOBUTTON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define AllocRadioButtonNode(a0, tags...) \
	({ULONG _tags[] = { tags }; AllocRadioButtonNodeA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define FreeRadioButtonNode(node) \
	LP1NR(0x2a, FreeRadioButtonNode, struct Node *, node, a0, \
	, RADIOBUTTON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define GetRadioButtonNodeAttrsA(node, tags) \
	LP2NR(0x36, GetRadioButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, RADIOBUTTON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define GetRadioButtonNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; GetRadioButtonNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#define RADIOBUTTON_GetClass() \
	LP0(0x1e, Class *, RADIOBUTTON_GetClass, \
	, RADIOBUTTON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetRadioButtonNodeAttrsA(node, tags) \
	LP2NR(0x30, SetRadioButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, RADIOBUTTON_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#ifndef NO_PPCINLINE_STDARG
#define SetRadioButtonNodeAttrs(a0, tags...) \
	({ULONG _tags[] = { tags }; SetRadioButtonNodeAttrsA((a0), (struct TagItem *)_tags);})
#endif /* !NO_PPCINLINE_STDARG */

#endif /* !_PPCINLINE_RADIOBUTTON_H */
