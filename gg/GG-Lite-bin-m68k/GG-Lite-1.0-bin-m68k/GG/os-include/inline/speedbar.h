#ifndef _INLINE_SPEEDBAR_H
#define _INLINE_SPEEDBAR_H

#ifndef CLIB_SPEEDBAR_PROTOS_H
#define CLIB_SPEEDBAR_PROTOS_H
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

#ifndef SPEEDBAR_BASE_NAME
#define SPEEDBAR_BASE_NAME SpeedBarBase
#endif

#define SPEEDBAR_GetClass() \
	LP0(0x1e, Class *, SPEEDBAR_GetClass, \
	, SPEEDBAR_BASE_NAME)

#define AllocSpeedButtonNodeA(number, tags) \
	LP2(0x24, struct Node *, AllocSpeedButtonNodeA, ULONG, number, d0, struct TagItem *, tags, a0, \
	, SPEEDBAR_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocSpeedButtonNode(number, tags...) \
	({ULONG _tags[] = {tags}; AllocSpeedButtonNodeA((number), (struct TagItem *) _tags);})
#endif

#define FreeSpeedButtonNode(node) \
	LP1NR(0x2a, FreeSpeedButtonNode, struct Node *, node, a0, \
	, SPEEDBAR_BASE_NAME)

#define SetSpeedButtonNodeAttrsA(node, tags) \
	LP2NR(0x30, SetSpeedButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, SPEEDBAR_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetSpeedButtonNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; SetSpeedButtonNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define GetSpeedButtonNodeAttrsA(node, tags) \
	LP2NR(0x36, GetSpeedButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, SPEEDBAR_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetSpeedButtonNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; GetSpeedButtonNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_SPEEDBAR_H  */
