#ifndef _INLINE_GETSCREENMODE_H
#define _INLINE_GETSCREENMODE_H

#ifndef CLIB_GETSCREENMODE_PROTOS_H
#define CLIB_GETSCREENMODE_PROTOS_H
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

#ifndef GETSCREENMODE_BASE_NAME
#define GETSCREENMODE_BASE_NAME GetScreenModeBase
#endif

#define GETSCREENMODE_GetClass() \
	LP0(0x1e, Class *, GETSCREENMODE_GetClass, \
	, GETSCREENMODE_BASE_NAME)

#endif /*  _INLINE_GETSCREENMODE_H  */
