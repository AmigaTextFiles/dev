#ifndef _INLINE_LABEL_H
#define _INLINE_LABEL_H

#ifndef CLIB_LABEL_PROTOS_H
#define CLIB_LABEL_PROTOS_H
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

#ifndef LABEL_BASE_NAME
#define LABEL_BASE_NAME LabelBase
#endif

#define LABEL_GetClass() \
	LP0(0x1e, Class *, LABEL_GetClass, \
	, LABEL_BASE_NAME)

#endif /*  _INLINE_LABEL_H  */
