/* Automatically generated header! Do not edit! */

#ifndef _PPCPRAGMA_SMARTBITMAP_H
#define _PPCPRAGMA_SMARTBITMAP_H
#ifdef __GNUC__
#ifndef _PPCINLINE__SMARTBITMAP_H
#include <ppcinline/smartbitmap.h>
#endif
#else

#ifndef POWERUP_PPCLIB_INTERFACE_H
#include <powerup/ppclib/interface.h>
#endif

#ifndef POWERUP_GCCLIB_PROTOS_H
#include <powerup/gcclib/powerup_protos.h>
#endif

#ifndef NO_PPCINLINE_STDARG
#define NO_PPCINLINE_STDARG
#endif/* SAS C PPC inlines */

#ifndef SMARTBITMAP_BASE_NAME
#define SMARTBITMAP_BASE_NAME SmartBitMapBase
#endif /* !LISTVIEW_BASE_NAME */

#define	GetSmartBitMapClass()	_GetSmartBitMapClass(SMARTBITMAP_BASE_NAME)

static __inline Class *
_GetSmartBitMapClass(void *SmartBitMapBase)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.caos_Un.Offset	=	(-30);
	MyCaos.a6		=(ULONG) SmartBitMapBase;	
	return((Class *)PPCCallOS(&MyCaos));
}

#endif /* SASC Pragmas */
#endif /* !_PPCPRAGMA_SMARTBITMAP_H */
