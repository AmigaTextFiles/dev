#ifndef _INLINE_BEVEL_H
#define _INLINE_BEVEL_H

#ifndef CLIB_BEVEL_PROTOS_H
#define CLIB_BEVEL_PROTOS_H
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

#ifndef BEVEL_BASE_NAME
#define BEVEL_BASE_NAME BevelBase
#endif

#define BEVEL_GetClass() \
	LP0(0x1e, Class *, BEVEL_GetClass, \
	, BEVEL_BASE_NAME)

#endif /*  _INLINE_BEVEL_H  */
