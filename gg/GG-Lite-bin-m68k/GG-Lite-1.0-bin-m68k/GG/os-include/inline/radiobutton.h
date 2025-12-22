#ifndef _INLINE_RADIOBUTTON_H
#define _INLINE_RADIOBUTTON_H

#ifndef CLIB_RADIOBUTTON_PROTOS_H
#define CLIB_RADIOBUTTON_PROTOS_H
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

#ifndef RADIOBUTTON_BASE_NAME
#define RADIOBUTTON_BASE_NAME RadioButtonBase
#endif

#define RADIOBUTTON_GetClass() \
	LP0(0x1e, Class *, RADIOBUTTON_GetClass, \
	, RADIOBUTTON_BASE_NAME)

#define AllocRadioButtonNodeA(columns, tags) \
	LP2(0x24, struct Node *, AllocRadioButtonNodeA, ULONG, columns, d0, struct TagItem *, tags, a0, \
	, RADIOBUTTON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocRadioButtonNode(columns, tags...) \
	({ULONG _tags[] = {tags}; AllocRadioButtonNodeA((columns), (struct TagItem *) _tags);})
#endif

#define FreeRadioButtonNode(node) \
	LP1NR(0x2a, FreeRadioButtonNode, struct Node *, node, a0, \
	, RADIOBUTTON_BASE_NAME)

#define SetRadioButtonNodeAttrsA(node, tags) \
	LP2NR(0x30, SetRadioButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, RADIOBUTTON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetRadioButtonNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; SetRadioButtonNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#define GetRadioButtonNodeAttrsA(node, tags) \
	LP2NR(0x36, GetRadioButtonNodeAttrsA, struct Node *, node, a0, struct TagItem *, tags, a1, \
	, RADIOBUTTON_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define GetRadioButtonNodeAttrs(node, tags...) \
	({ULONG _tags[] = {tags}; GetRadioButtonNodeAttrsA((node), (struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_RADIOBUTTON_H  */
