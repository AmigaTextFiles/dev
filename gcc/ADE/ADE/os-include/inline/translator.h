#ifndef _INLINE_TRANSLATOR_H
#define _INLINE_TRANSLATOR_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef TRANSLATOR_BASE_NAME
#define TRANSLATOR_BASE_NAME TranslatorBase
#endif

#define Translate(input, inputLen, output, outputLen) \
	LP4(0x1e, LONG, Translate, STRPTR, input, a0, LONG, inputLen, d0, STRPTR, output, a1, LONG, outputLen, d1, \
	, TRANSLATOR_BASE_NAME)

#define TranslateAs(input, inputLen, output, outputLen, language) \
	LP5(0x24, LONG, TranslateAs, STRPTR, input, a0, LONG, inputLen, d0, STRPTR, output, a1, LONG, outputLen, d1, STRPTR, language, a2, \
	, TRANSLATOR_BASE_NAME)

#define LoadAccent(name) \
	LP1(0x2a, LONG, LoadAccent, STRPTR, name, a0, \
	, TRANSLATOR_BASE_NAME)

#define SetAccent(name) \
	LP1(0x30, LONG, SetAccent, STRPTR, name, a0, \
	, TRANSLATOR_BASE_NAME)

#endif /*  _INLINE_TRANSLATOR_H  */
