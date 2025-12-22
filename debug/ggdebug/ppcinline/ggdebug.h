/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_GGDEBUG_H
#define _PPCINLINE_GGDEBUG_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef GGDEBUG_BASE_NAME
#define GGDEBUG_BASE_NAME GGDebugBase
#endif /* !GGDEBUG_BASE_NAME */

#define KCmpStr(string1, string2) \
	LP2(0x1e, LONG, KCmpStr, STRPTR, string1, a0, STRPTR, string2, a1, \
	, GGDEBUG_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KDoFmt(formatString, datastream, putChProc, putChData) \
	LP4FP(0x24, APTR, KDoFmt, STRPTR, formatString, a0, STRPTR, datastream, a1, __fpt, putChProc, a2, APTR, putChData, a3, \
	, GGDEBUG_BASE_NAME, void (*__fpt)(), IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KGetChar() \
	LP0(0x2a, LONG, KGetChar, \
	, GGDEBUG_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KMayGetChar() \
	LP0(0x30, LONG, KMayGetChar, \
	, GGDEBUG_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KPutChar(character) \
	LP1(0x36, LONG, KPutChar, LONG, character, d0, \
	, GGDEBUG_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KPutStr(string) \
	LP1NR(0x3c, KPutStr, STRPTR, string, a0, \
	, GGDEBUG_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define VKPrintf(format, data) \
	LP2(0x42, APTR, VKPrintf, STRPTR, format, a0, APTR, data, a1, \
	, GGDEBUG_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define KPrintf _KPrintf

static LONG _KPrintf(STRPTR format, ...)
{
	va_list ap;
	struct Caos MyCaos;
	char buffer[256];

	va_start(ap,format);
	vsprintf(buffer,format,ap);
	va_end(ap);
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) buffer;
	MyCaos.caos_Un.Offset	=	(-60);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return (LONG)PPCCallOS(&MyCaos);
}

#endif /* !_PPCINLINE_GGDEBUG_H */
