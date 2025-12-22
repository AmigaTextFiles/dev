/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_LIBRARY_M68K_H
#define _PPCINLINE_LIBRARY_M68K_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef LIBRARY_M68K_BASE_NAME
#define LIBRARY_M68K_BASE_NAME LibraryM68KBase
#endif /* !LIBRARY_M68K_BASE_NAME */

#define m68k_div(__p0, __p1) \
	LP2(48, LONG , m68k_div, \
		LONG , __p0, d0, \
		LONG , __p1, d1, \
		, LIBRARY_M68K_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define m68k_mul(__p0, __p1) \
	LP2(42, LONG , m68k_mul, \
		LONG , __p0, d0, \
		LONG , __p1, d1, \
		, LIBRARY_M68K_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define m68k_add(__p0, __p1) \
	LP2(30, LONG , m68k_add, \
		LONG , __p0, d0, \
		LONG , __p1, d1, \
		, LIBRARY_M68K_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define m68k_sub(__p0, __p1) \
	LP2(36, LONG , m68k_sub, \
		LONG , __p0, d0, \
		LONG , __p1, d1, \
		, LIBRARY_M68K_BASE_NAME, 0, 0, 0, 0, 0, 0)

#endif /* !_PPCINLINE_LIBRARY_M68K_H */
