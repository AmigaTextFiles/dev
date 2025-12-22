#ifndef _INLINE_INPUT_H
#define _INLINE_INPUT_H

#ifndef CLIB_INPUT_PROTOS_H
#define CLIB_INPUT_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INPUT_BASE_NAME
#define INPUT_BASE_NAME InputBase
#endif

#define PeekQualifier() \
	LP0(0x2a, UWORD, PeekQualifier, \
	, INPUT_BASE_NAME)

#endif /*  _INLINE_INPUT_H  */
