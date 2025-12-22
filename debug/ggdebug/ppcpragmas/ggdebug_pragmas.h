/* Automatically generated header! Do not edit! */

#ifndef _PPCPRAGMA_GGDEBUG_H
#define _PPCPRAGMA_GGDEBUG_H
#ifdef __GNUC__
#ifndef _PPCINLINE__GGDEBUG_H
#include <powerup/ppcinline/ggdebug.h>
#endif
#else

#include <stdarg.h>
#include <stdio.h>

#ifndef POWERUP_PPCLIB_INTERFACE_H
#include <powerup/ppclib/interface.h>
#endif

#ifndef POWERUP_GCCLIB_PROTOS_H
#include <powerup/gcclib/powerup_protos.h>
#endif

#ifndef NO_PPCINLINE_STDARG
#define NO_PPCINLINE_STDARG
#endif/* SAS C PPC inlines */

#ifndef GGDEBUG_BASE_NAME
#define GGDEBUG_BASE_NAME GGDebugBase
#endif /* !GGDEBUG_BASE_NAME */

#define	KCmpStr(string1, string2)	_KCmpStr(GGDEBUG_BASE_NAME, string1, string2)

static __inline LONG
_KCmpStr(void *GGDebugBase, STRPTR string1, STRPTR string2)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) string1;
	MyCaos.a1		=(ULONG) string2;
	MyCaos.caos_Un.Offset	=	(-30);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return((LONG)PPCCallOS(&MyCaos));
}

#define	KDoFmt(formatString, datastream, putChProc, putChData)	_KDoFmt(GGDEBUG_BASE_NAME, formatString, datastream, putChProc, putChData)

static __inline APTR
_KDoFmt(void *GGDebugBase, STRPTR formatString, STRPTR datastream, void (*putChProc)(), APTR putChData)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) formatString;
	MyCaos.a1		=(ULONG) datastream;
	MyCaos.a2		=(ULONG) putChProc;
	MyCaos.a3		=(ULONG) putChData;
	MyCaos.caos_Un.Offset	=	(-36);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return((APTR)PPCCallOS(&MyCaos));
}

#define	KGetChar()	_KGetChar(GGDEBUG_BASE_NAME)

static __inline LONG
_KGetChar(void *GGDebugBase)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.caos_Un.Offset	=	(-42);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return((LONG)PPCCallOS(&MyCaos));
}

#define	KMayGetChar()	_KMayGetChar(GGDEBUG_BASE_NAME)

static __inline LONG
_KMayGetChar(void *GGDebugBase)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.caos_Un.Offset	=	(-48);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return((LONG)PPCCallOS(&MyCaos));
}

#define	KPutChar(character)	_KPutChar(GGDEBUG_BASE_NAME, character)

static __inline LONG
_KPutChar(void *GGDebugBase, LONG character)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.d0		=(ULONG) character;
	MyCaos.caos_Un.Offset	=	(-54);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return((LONG)PPCCallOS(&MyCaos));
}

#define	KPutStr(string)	_KPutStr(GGDEBUG_BASE_NAME, string)

static __inline VOID
_KPutStr(void *GGDebugBase, STRPTR string)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) string;
	MyCaos.caos_Un.Offset	=	(-60);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	PPCCallOS(&MyCaos);
}

#define	VKPrintf(format, data)	_VKPrintf(GGDEBUG_BASE_NAME, format, data)

#ifndef NO_PPCINLINE_STDARG
#define KPrintf(a0, tags...) \
	{ULONG _tags[] = { tags }; VKPrintf((a0), (APTR)_tags);}
#endif /* !NO_PPCINLINE_STDARG */

static __inline APTR
_VKPrintf(void *GGDebugBase, STRPTR format, APTR data)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.a0		=(ULONG) format;
	MyCaos.a1		=(ULONG) data;
	MyCaos.caos_Un.Offset	=	(-66);
	MyCaos.a6		=(ULONG) GGDebugBase;	
	return((APTR)PPCCallOS(&MyCaos));
}

#define KPrintf _KPrintf

static __inline LONG _KPrintf(STRPTR format, ...)
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

#endif /* SASC Pragmas */
#endif /* !_PPCPRAGMA_GGDEBUG_H */
