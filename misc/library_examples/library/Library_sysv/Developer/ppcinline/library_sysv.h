/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_LIBRARY_SYSV_H
#define _PPCINLINE_LIBRARY_SYSV_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef LIBRARY_SYSV_BASE_NAME
#define LIBRARY_SYSV_BASE_NAME LibrarySysVBase
#endif /* !LIBRARY_SYSV_BASE_NAME */

#define sysv_mul(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_SYSV_BASE_NAME) - 40))(__p0, __p1))

#define sysv_add(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_SYSV_BASE_NAME) - 28))(__p0, __p1))

#define sysv_sub(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_SYSV_BASE_NAME) - 34))(__p0, __p1))

#define sysv_div(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_SYSV_BASE_NAME) - 46))(__p0, __p1))

#endif /* !_PPCINLINE_LIBRARY_SYSV_H */
