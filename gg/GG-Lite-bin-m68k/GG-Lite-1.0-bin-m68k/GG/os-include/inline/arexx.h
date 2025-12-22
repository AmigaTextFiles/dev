#ifndef _INLINE_AREXX_H
#define _INLINE_AREXX_H

#ifndef CLIB_AREXX_PROTOS_H
#define CLIB_AREXX_PROTOS_H
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

#ifndef AREXX_BASE_NAME
#define AREXX_BASE_NAME ARexxBase
#endif

#define AREXX_GetClass() \
	LP0(0x1e, Class *, AREXX_GetClass, \
	, AREXX_BASE_NAME)

#endif /*  _INLINE_AREXX_H  */
