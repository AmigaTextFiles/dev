/*
 * This source file is part of Vahunz,
 * a tool to make source code un-/more legible.
 *
 *--------------------------------------------------------------------------
 *
 * Vahunz and the Ugly library are Copyright (C) 1998 by
 * Thomas Aglassinger <agi@giga.or.at>
 *
 * All rights reserved.
 *
 * Refer to the manual for more information.
 *
 *--------------------------------------------------------------------------
 *
 * Ubiqx library is Copyright (C) 1991-1998 by
 * Christopher R. Hertel <crh@ubiqx.mn.org>
 *
 * Ubiqx library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 */
#ifndef r5G
#define r5G
#include <stddef.h>
#include "utypes.h"
#define v7G( s ) n4Y(s,__FILE__,__LINE__)
#define v3S( s ) v7G(s),s=NULL
#define s0V( s ) v3N(s,__FILE__,__LINE__)
#define b8Y( o,n ) j6C(o,n,__FILE__,__LINE__)
#define b7C 0 
#define k3S 1 
#ifndef i2K
extern STRPTR c3X(STRPTR s);
extern int r0X(t8B s1, t8B s2);
extern int s8K(t8B s1, t8B s2, size_t n);
extern STRPTR f4F(t8B s1, t8B s2);
extern void n4Y(STRPTR s, STRPTR e9R, ULONG p8T);
extern STRPTR v3N(t8B k0Q, STRPTR e9R, ULONG p8T);
extern void j6C(STRPTR * k0Q, t8B t7H, STRPTR e9R, ULONG p8T);
extern STRPTR m6X(t8B str, t8B set);
extern LONG a9B(STRPTR str, STRPTR set, char c0Z, BYTE d1A);
extern int b1O(STRPTR s);
extern STRPTR t7V(const char ch);
extern BOOL w8T(STRPTR s, LONG * num);
extern STRPTR k2T(LONG num);
#endif 
#endif 
