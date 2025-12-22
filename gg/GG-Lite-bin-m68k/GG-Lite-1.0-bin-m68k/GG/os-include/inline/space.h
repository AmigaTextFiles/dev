#ifndef _INLINE_SPACE_H
#define _INLINE_SPACE_H

#ifndef CLIB_SPACE_PROTOS_H
#define CLIB_SPACE_PROTOS_H
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

#ifndef SPACE_BASE_NAME
#define SPACE_BASE_NAME SpaceBase
#endif

#define SPACE_GetClass() \
	LP0(0x1e, Class *, SPACE_GetClass, \
	, SPACE_BASE_NAME)

#endif /*  _INLINE_SPACE_H  */
