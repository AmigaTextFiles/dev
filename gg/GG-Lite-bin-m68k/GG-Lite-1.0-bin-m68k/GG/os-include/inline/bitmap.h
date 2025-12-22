#ifndef _INLINE_BITMAP_H
#define _INLINE_BITMAP_H

#ifndef CLIB_BITMAP_PROTOS_H
#define CLIB_BITMAP_PROTOS_H
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

#ifndef BITMAP_BASE_NAME
#define BITMAP_BASE_NAME BitMapBase
#endif

#define BITMAP_GetClass() \
	LP0(0x1e, Class *, BITMAP_GetClass, \
	, BITMAP_BASE_NAME)

#endif /*  _INLINE_BITMAP_H  */
