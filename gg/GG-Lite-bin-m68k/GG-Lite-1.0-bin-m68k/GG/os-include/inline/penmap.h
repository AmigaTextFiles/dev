#ifndef _INLINE_PENMAP_H
#define _INLINE_PENMAP_H

#ifndef CLIB_PENMAP_PROTOS_H
#define CLIB_PENMAP_PROTOS_H
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

#ifndef PENMAP_BASE_NAME
#define PENMAP_BASE_NAME PenMapBase
#endif

#define PENMAP_GetClass() \
	LP0(0x1e, Class *, PENMAP_GetClass, \
	, PENMAP_BASE_NAME)

#endif /*  _INLINE_PENMAP_H  */
