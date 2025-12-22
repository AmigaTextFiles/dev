#ifndef _INLINE_CLICKTAB_H
#define _INLINE_CLICKTAB_H

#ifndef CLIB_CLICKTAB_PROTOS_H
#define CLIB_CLICKTAB_PROTOS_H
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

#ifndef CLICKTAB_BASE_NAME
#define CLICKTAB_BASE_NAME ClickTabBase
#endif

#define CLICKTAB_GetClass() \
	LP0(0x1e, Class *, CLICKTAB_GetClass, \
	, CLICKTAB_BASE_NAME)

#define AllocClickTabNodeA(tags) \
	LP1(0x24, struct Node *, AllocClickTabNodeA, struct TagItem *, tags, a0, \
	, CLICKTAB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocClickTabNode(tags...) \
	({ULONG _tags[] = {tags}; AllocClickTabNodeA((struct TagItem *) _tags);})
#endif

#define FreeClickTabNode(node) \
	LP1NR(0x2a, FreeClickTabNode, struct Node *, node, a0, \
	, CLICKTAB_BASE_NAME)

#define SetClickTabNodeAttrsA(node, tags) \
	LP2NR(0x30, SetClickTabNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CLICKTAB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetClickTabNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; SetClickTabNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define GetClickTabNodeAttrsA(node, tags) \
	LP2NR(0x36, GetClickTabNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CLICKTAB_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetClickTabNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; GetClickTabNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_CLICKTAB_H  */
