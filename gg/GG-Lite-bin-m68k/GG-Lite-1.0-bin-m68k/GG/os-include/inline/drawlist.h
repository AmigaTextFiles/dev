#ifndef _INLINE_DRAWLIST_H
#define _INLINE_DRAWLIST_H

#ifndef CLIB_DRAWLIST_PROTOS_H
#define CLIB_DRAWLIST_PROTOS_H
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

#ifndef DRAWLIST_BASE_NAME
#define DRAWLIST_BASE_NAME DrawListBase
#endif

#define DRAWLIST_GetClass() \
	LP0(0x1e, Class *, DRAWLIST_GetClass, \
	, DRAWLIST_BASE_NAME)

#endif /*  _INLINE_DRAWLIST_H  */
