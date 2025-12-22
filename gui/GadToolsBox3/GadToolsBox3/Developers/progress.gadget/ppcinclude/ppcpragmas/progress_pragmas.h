/* Automatically generated header! Do not edit! */

#ifndef _PPCPRAGMA_PROGRESS_H
#define _PPCPRAGMA_PROGRESS_H
#ifdef __GNUC__
#ifndef _PPCINLINE__PROGRESS_H
#include <ppcinline/progress.h>
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

#ifndef PROGRESS_BASE_NAME
#define PROGRESS_BASE_NAME ProgressBase
#endif /* !LISTVIEW_BASE_NAME */

#define	GetProgressClass()	_GetProgressClass(LISTVIEW_BASE_NAME)

static __inline Class *
_GetProgressClass(void *ProgressBase)
{
struct Caos	MyCaos;
	MyCaos.M68kCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.M68kStart	=	NULL;
//	MyCaos.M68kSize		=	0;
	MyCaos.PPCCacheMode	=	IF_CACHEFLUSHALL;
//	MyCaos.PPCStart		=	NULL;
//	MyCaos.PPCSize		=	0;
	MyCaos.caos_Un.Offset	=	(-30);
	MyCaos.a6		=(ULONG) ProgressBase;	
	return((Class *)PPCCallOS(&MyCaos));
}

#endif /* SASC Pragmas */
#endif /* !_PPCPRAGMA_PROGRESS_H */
