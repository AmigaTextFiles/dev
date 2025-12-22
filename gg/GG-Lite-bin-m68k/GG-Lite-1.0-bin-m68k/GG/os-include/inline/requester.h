#ifndef _INLINE_REQUESTER_H
#define _INLINE_REQUESTER_H

#ifndef CLIB_REQUESTER_PROTOS_H
#define CLIB_REQUESTER_PROTOS_H
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

#ifndef REQUESTER_BASE_NAME
#define REQUESTER_BASE_NAME RequesterBase
#endif

#define REQUESTER_GetClass() \
	LP0(0x1e, Class *, REQUESTER_GetClass, \
	, REQUESTER_BASE_NAME)

#endif /*  _INLINE_REQUESTER_H  */
