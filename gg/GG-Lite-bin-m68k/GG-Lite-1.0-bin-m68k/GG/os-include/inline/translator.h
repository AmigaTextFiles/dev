#ifndef _INLINE_TRANSLATOR_H
#define _INLINE_TRANSLATOR_H

#ifndef CLIB_TRANSLATOR_PROTOS_H
#define CLIB_TRANSLATOR_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef TRANSLATOR_BASE_NAME
#define TRANSLATOR_BASE_NAME TranslatorBase
#endif

#define Translate(inputString, inputLength, outputBuffer, bufferSize) \
	LP4(0x1e, LONG, Translate, CONST_STRPTR, inputString, a0, LONG, inputLength, d0, STRPTR, outputBuffer, a1, LONG, bufferSize, d1, \
	, TRANSLATOR_BASE_NAME)

#endif /*  _INLINE_TRANSLATOR_H  */
