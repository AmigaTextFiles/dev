#ifndef _INLINE_POPCYCLE_H
#define _INLINE_POPCYCLE_H

#ifndef CLIB_POPCYCLE_PROTOS_H
#define CLIB_POPCYCLE_PROTOS_H
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

#ifndef POPCYCLE_BASE_NAME
#define POPCYCLE_BASE_NAME PopCycleBase
#endif

#define POPCYCLE_GetClass() \
	LP0(0x1e, Class *, POPCYCLE_GetClass, \
	, POPCYCLE_BASE_NAME)

#define AllocPopCycleNodeA(tags) \
	LP1(0x24, struct Node *, AllocPopCycleNodeA, struct TagItem *, tags, a0, \
	, POPCYCLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocPopCycleNode(tags...) \
	({ULONG _tags[] = {tags}; AllocPopCycleNodeA((struct TagItem *) _tags);})
#endif

#define FreePopCycleNode(node) \
	LP1NR(0x2a, FreePopCycleNode, struct Node *, node, a0, \
	, POPCYCLE_BASE_NAME)

#define SetPopCycleNodeAttrsA(node, tags) \
	LP2NR(0x30, SetPopCycleNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, POPCYCLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetPopCycleNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; SetPopCycleNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define GetPopCycleNodeAttrsA(node, tags) \
	LP2NR(0x36, GetPopCycleNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, POPCYCLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetPopCycleNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; GetPopCycleNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_POPCYCLE_H  */
