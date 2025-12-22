/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_TRANSLATOR_H
#define _PPCINLINE_TRANSLATOR_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef TRANSLATOR_BASE_NAME
#define TRANSLATOR_BASE_NAME TranslatorBase
#endif /* !TRANSLATOR_BASE_NAME */

#define Translate(inputString, inputLength, outputBuffer, bufferSize) \
	LP4(0x1e, LONG, Translate, CONST_STRPTR, inputString, a0, LONG, inputLength, d0, STRPTR, outputBuffer, a1, LONG, bufferSize, d1, \
	, TRANSLATOR_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_TRANSLATOR_H */
