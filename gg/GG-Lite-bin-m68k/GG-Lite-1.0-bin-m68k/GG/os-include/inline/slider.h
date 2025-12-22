#ifndef _INLINE_SLIDER_H
#define _INLINE_SLIDER_H

#ifndef CLIB_SLIDER_PROTOS_H
#define CLIB_SLIDER_PROTOS_H
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

#ifndef SLIDER_BASE_NAME
#define SLIDER_BASE_NAME SliderBase
#endif

#define SLIDER_GetClass() \
	LP0(0x1e, Class *, SLIDER_GetClass, \
	, SLIDER_BASE_NAME)

#endif /*  _INLINE_SLIDER_H  */
