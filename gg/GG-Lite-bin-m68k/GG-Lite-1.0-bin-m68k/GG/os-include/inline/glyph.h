#ifndef _INLINE_GLYPH_H
#define _INLINE_GLYPH_H

#ifndef CLIB_GLYPH_PROTOS_H
#define CLIB_GLYPH_PROTOS_H
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

#ifndef GLYPH_BASE_NAME
#define GLYPH_BASE_NAME GlyphBase
#endif

#define GLYPH_GetClass() \
	LP0(0x1e, Class *, GLYPH_GetClass, \
	, GLYPH_BASE_NAME)

#endif /*  _INLINE_GLYPH_H  */
