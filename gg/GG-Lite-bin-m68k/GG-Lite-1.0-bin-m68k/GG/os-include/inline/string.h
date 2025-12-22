#ifndef _INLINE_STRING_H
#define _INLINE_STRING_H

#ifndef CLIB_STRING_PROTOS_H
#define CLIB_STRING_PROTOS_H
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

#ifndef STRING_BASE_NAME
#define STRING_BASE_NAME StringBase
#endif

#define STRING_GetClass() \
	LP0(0x1e, Class *, STRING_GetClass, \
	, STRING_BASE_NAME)

#endif /*  _INLINE_STRING_H  */
