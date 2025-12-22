/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_LIBRARY_MIXED_H
#define _PPCINLINE_LIBRARY_MIXED_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef LIBRARY_MIXED_BASE_NAME
#define LIBRARY_MIXED_BASE_NAME LibraryMixedBase
#endif /* !LIBRARY_MIXED_BASE_NAME */

#define m68k_div() \
	LP0(72, LONG , m68k_div, \
		, LIBRARY_MIXED_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define sysv_mul(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_MIXED_BASE_NAME) - 40))(__p0, __p1))

#define m68k_mul() \
	LP0(66, LONG , m68k_mul, \
		, LIBRARY_MIXED_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define sysv_add(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_MIXED_BASE_NAME) - 28))(__p0, __p1))

#define m68k_add() \
	LP0(54, LONG , m68k_add, \
		, LIBRARY_MIXED_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define sysv_sub(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_MIXED_BASE_NAME) - 34))(__p0, __p1))

#define sysv_output1(__p0, __p1, __p2) \
	(((VOID (*)(void *, struct MyLibrary *, LONG , LONG ))*(void**)((long)(LIBRARY_MIXED_BASE_NAME) - 76))((void*)(LIBRARY_MIXED_BASE_NAME), __p0, __p1, __p2))

#define m68k_sub() \
	LP0(60, LONG , m68k_sub, \
		, LIBRARY_MIXED_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define sysv_div(__p0, __p1) \
	(((LONG (*)(LONG , LONG ))*(void**)((long)(LIBRARY_MIXED_BASE_NAME) - 46))(__p0, __p1))

#define sysv_output2(__p0, __p1, __p2) \
	(((VOID (*)(LONG , LONG , struct MyLibrary *, void *))*(void**)((long)(LIBRARY_MIXED_BASE_NAME) - 82))(__p0, __p1, __p2, (void*)(LIBRARY_MIXED_BASE_NAME)))

#endif /* !_PPCINLINE_LIBRARY_MIXED_H */
