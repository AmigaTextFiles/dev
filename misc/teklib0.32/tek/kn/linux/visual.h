
#ifndef _TEK_KERNEL_LINUX_VISUAL_H
#define _TEK_KERNEL_LINUX_VISUAL_H

#ifdef KNVISDEBUG
	#include <stdio.h>
	#include <errno.h>
	#include <assert.h>
	#define	dbvprintf(l,x)			{if (l >= KNVISDEBUG) fprintf(stderr, x);}
	#define	dbvprintf1(l,x,a)		{if (l >= KNVISDEBUG) fprintf(stderr, x,a);}
	#define	dbvprintf2(l,x,a,b)		{if (l >= KNVISDEBUG) fprintf(stderr, x,a,b);}
#else
	#define	dbvprintf(l,x)
	#define	dbvprintf1(l,x,a)
	#define	dbvprintf2(l,x,a,b)
#endif


#endif
