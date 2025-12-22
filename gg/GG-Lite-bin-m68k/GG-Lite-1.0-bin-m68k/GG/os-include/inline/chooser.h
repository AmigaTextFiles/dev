#ifndef _INLINE_CHOOSER_H
#define _INLINE_CHOOSER_H

#ifndef CLIB_CHOOSER_PROTOS_H
#define CLIB_CHOOSER_PROTOS_H
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

#ifndef CHOOSER_BASE_NAME
#define CHOOSER_BASE_NAME ChooserBase
#endif

#define CHOOSER_GetClass() \
	LP0(0x1e, Class *, CHOOSER_GetClass, \
	, CHOOSER_BASE_NAME)

#define AllocChooserNodeA(tags) \
	LP1(0x24, struct Node *, AllocChooserNodeA, struct TagItem *, tags, a0, \
	, CHOOSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocChooserNode(tags...) \
	({ULONG _tags[] = {tags}; AllocChooserNodeA((struct TagItem *) _tags);})
#endif

#define FreeChooserNode(node) \
	LP1NR(0x2a, FreeChooserNode, struct Node *, node, a0, \
	, CHOOSER_BASE_NAME)

#define SetChooserNodeAttrsA(node, tags) \
	LP2NR(0x30, SetChooserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CHOOSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetChooserNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; SetChooserNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define GetChooserNodeAttrsA(node, tags) \
	LP2NR(0x36, GetChooserNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, CHOOSER_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetChooserNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; GetChooserNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_CHOOSER_H  */
