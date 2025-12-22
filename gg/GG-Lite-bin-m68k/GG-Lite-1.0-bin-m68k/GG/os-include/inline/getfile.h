#ifndef _INLINE_GETFILE_H
#define _INLINE_GETFILE_H

#ifndef CLIB_GETFILE_PROTOS_H
#define CLIB_GETFILE_PROTOS_H
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

#ifndef GETFILE_BASE_NAME
#define GETFILE_BASE_NAME GetFileBase
#endif

#define GETFILE_GetClass() \
	LP0(0x1e, Class *, GETFILE_GetClass, \
	, GETFILE_BASE_NAME)

#endif /*  _INLINE_GETFILE_H  */
