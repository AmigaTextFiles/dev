#ifndef _INLINE_BUTTON_H
#define _INLINE_BUTTON_H

#ifndef CLIB_BUTTON_PROTOS_H
#define CLIB_BUTTON_PROTOS_H
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

#ifndef BUTTON_BASE_NAME
#define BUTTON_BASE_NAME ButtonBase
#endif

#define BUTTON_GetClass() \
	LP0(0x1e, Class *, BUTTON_GetClass, \
	, BUTTON_BASE_NAME)

#endif /*  _INLINE_BUTTON_H  */
