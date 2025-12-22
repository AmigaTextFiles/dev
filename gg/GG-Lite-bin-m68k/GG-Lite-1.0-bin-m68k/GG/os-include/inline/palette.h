#ifndef _INLINE_PALETTE_H
#define _INLINE_PALETTE_H

#ifndef CLIB_PALETTE_PROTOS_H
#define CLIB_PALETTE_PROTOS_H
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

#ifndef PALETTE_BASE_NAME
#define PALETTE_BASE_NAME PaletteBase
#endif

#define PALETTE_GetClass() \
	LP0(0x1e, Class *, PALETTE_GetClass, \
	, PALETTE_BASE_NAME)

#endif /*  _INLINE_PALETTE_H  */
