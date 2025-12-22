#ifndef _INLINE_GETFONT_H
#define _INLINE_GETFONT_H

#ifndef CLIB_GETFONT_PROTOS_H
#define CLIB_GETFONT_PROTOS_H
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

#ifndef GETFONT_BASE_NAME
#define GETFONT_BASE_NAME GetFontBase
#endif

#define GETFONT_GetClass() \
	LP0(0x1e, Class *, GETFONT_GetClass, \
	, GETFONT_BASE_NAME)

#endif /*  _INLINE_GETFONT_H  */
