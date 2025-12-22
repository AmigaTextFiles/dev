#ifndef _INLINE_CHECKBOX_H
#define _INLINE_CHECKBOX_H

#ifndef CLIB_CHECKBOX_PROTOS_H
#define CLIB_CHECKBOX_PROTOS_H
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

#ifndef CHECKBOX_BASE_NAME
#define CHECKBOX_BASE_NAME CheckBoxBase
#endif

#define CHECKBOX_GetClass() \
	LP0(0x1e, Class *, CHECKBOX_GetClass, \
	, CHECKBOX_BASE_NAME)

#endif /*  _INLINE_CHECKBOX_H  */
