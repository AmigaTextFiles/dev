/* Automatically generated header! Do not edit! */

#ifndef _INLINE_GGDEBUG_H
#define _INLINE_GGDEBUG_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif /* !__INLINE_MACROS_H */
#include <stdarg.h>

#ifndef GGDEBUG_BASE_NAME
#define GGDEBUG_BASE_NAME GGDebugBase
#endif /* !GGDEBUG_BASE_NAME */

#define KCmpStr(string1, string2) \
	LP2(0x1e, LONG, KCmpStr, STRPTR, string1, a0, STRPTR, string2, a1, \
	, GGDEBUG_BASE_NAME)

#define KDoFmt(formatString, datastream, putChProc, putChData) \
	LP4FP(0x24, APTR, KDoFmt, STRPTR, formatString, a0, STRPTR, datastream, a1, __fpt, putChProc, a2, APTR, putChData, a3, \
	, GGDEBUG_BASE_NAME, void (*__fpt)())

#define KGetChar() \
	LP0(0x2a, LONG, KGetChar, \
	, GGDEBUG_BASE_NAME)

#define KMayGetChar() \
	LP0(0x30, LONG, KMayGetChar, \
	, GGDEBUG_BASE_NAME)

#define KPutChar(character) \
	LP1(0x36, LONG, KPutChar, LONG, character, d0, \
	, GGDEBUG_BASE_NAME)

#define KPutStr(string) \
	LP1NR(0x3c, KPutStr, STRPTR, string, a0, \
	, GGDEBUG_BASE_NAME)

#define VKPrintf(format, data) \
	LP2(0x42, APTR, VKPrintf, STRPTR, format, a0, APTR, data, a1, \
	, GGDEBUG_BASE_NAME)

#define KPrintf _KPrintf

static LONG _KPrintf(STRPTR format, ...)
{
	va_list ap;
	LONG ret;

	va_start(ap,format);
	ret=(LONG)VKPrintf(format,ap);
	va_end(ap);

	return ret;
}

#endif /* !_INLINE_GGDEBUG_H */
