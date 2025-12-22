#ifndef _INLINE_WINDOW_H
#define _INLINE_WINDOW_H

#ifndef CLIB_WINDOW_PROTOS_H
#define CLIB_WINDOW_PROTOS_H
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

#ifndef WINDOW_BASE_NAME
#define WINDOW_BASE_NAME WindowBase
#endif

#define WINDOW_GetClass() \
	LP0(0x1e, Class *, WINDOW_GetClass, \
	, WINDOW_BASE_NAME)

#endif /*  _INLINE_WINDOW_H  */
