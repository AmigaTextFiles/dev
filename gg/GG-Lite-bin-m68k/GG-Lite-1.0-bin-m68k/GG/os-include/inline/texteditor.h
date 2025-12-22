#ifndef _INLINE_TEXTEDITOR_H
#define _INLINE_TEXTEDITOR_H

#ifndef CLIB_TEXTEDITOR_PROTOS_H
#define CLIB_TEXTEDITOR_PROTOS_H
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

#ifndef TEXTEDITOR_BASE_NAME
#define TEXTEDITOR_BASE_NAME TextFieldBase
#endif

#define TEXTEDITOR_GetClass() \
	LP0(0x1e, Class *, TEXTEDITOR_GetClass, \
	, TEXTEDITOR_BASE_NAME)

#endif /*  _INLINE_TEXTEDITOR_H  */
