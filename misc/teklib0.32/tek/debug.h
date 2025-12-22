
#ifndef _TEK_DEBUG_H
#define _TEK_DEBUG_H 1

/* 
**	debugging
*/

#include <tek/type.h>

#ifdef TDEBUG
	#define	tdbprintf(l,x)		{if (l > 0 && l >= TDEBUG) platform_dbprintf(x);}
	#define	tdbprintf1(l,x,a)	{if (l > 0 && l >= TDEBUG) platform_dbprintf1(x,a);}
	#define	tdbprintf2(l,x,a,b)	{if (l > 0 && l >= TDEBUG) platform_dbprintf2(x,a,b);}
#else
	#define	tdbprintf(l,x)
	#define	tdbprintf1(l,x,a)
	#define	tdbprintf2(l,x,a,b)
#endif


#endif
