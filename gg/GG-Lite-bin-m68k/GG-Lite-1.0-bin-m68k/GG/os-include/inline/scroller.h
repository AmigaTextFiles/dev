#ifndef _INLINE_SCROLLER_H
#define _INLINE_SCROLLER_H

#ifndef CLIB_SCROLLER_PROTOS_H
#define CLIB_SCROLLER_PROTOS_H
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

#ifndef SCROLLER_BASE_NAME
#define SCROLLER_BASE_NAME ScrollerBase
#endif

#define SCROLLER_GetClass() \
	LP0(0x1e, Class *, SCROLLER_GetClass, \
	, SCROLLER_BASE_NAME)

#endif /*  _INLINE_SCROLLER_H  */
