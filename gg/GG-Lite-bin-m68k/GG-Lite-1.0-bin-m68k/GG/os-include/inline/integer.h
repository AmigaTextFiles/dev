#ifndef _INLINE_INTEGER_H
#define _INLINE_INTEGER_H

#ifndef CLIB_INTEGER_PROTOS_H
#define CLIB_INTEGER_PROTOS_H
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

#ifndef INTEGER_BASE_NAME
#define INTEGER_BASE_NAME IntegerBase
#endif

#define INTEGER_GetClass() \
	LP0(0x1e, Class *, INTEGER_GetClass, \
	, INTEGER_BASE_NAME)

#endif /*  _INLINE_INTEGER_H  */
