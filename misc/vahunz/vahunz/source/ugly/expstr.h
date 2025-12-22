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
#ifndef s0N
#define s0N
#include <stddef.h>
#include "utypes.h"
#define e4Y 96
#define h7L 8 
#ifndef m4R
#define m4R(x,by) ((by)*(((x)+(by))/(by)))
#endif
#define j9O(es) ((es)->r1C)
#define p1R(es) ((es)->r0H - 1)
typedef struct
{
STRPTR r1C; 
size_t r0H; 
size_t p3Q; 
size_t x6G; 
}
j5K;
#ifndef m1N
extern j5K *o0J(size_t g9W, STRPTR e9R, ULONG p8T);
extern j5K *u5Y(size_t g9W);
extern void y6Q(j5K * es);
extern BOOL k7N(j5K * es);
extern BOOL v2V(j5K * es, STRPTR e9R, ULONG p8T);
extern BOOL c9U(j5K * es, t8B s, size_t n);
extern BOOL f8T(j5K * es, t8B s);
extern BOOL n4X(j5K * es, int ch);
extern BOOL d1R(j5K * es, t8B s);
extern BOOL n4J(j5K * es, t8B s, STRPTR e9R, ULONG p8T);
extern BOOL w9I(j5K * es, int ch, STRPTR e9R, ULONG p8T);
extern BOOL n2K(j5K * es, t8B s, STRPTR e9R, ULONG p8T);
extern STRPTR p1W(j5K * es);
extern size_t y1C(j5K * es);
extern BOOL k6F(j5K * dest, j5K * src);
extern BOOL j0P(j5K * dest, j5K * src);
extern BOOL w2K(j5K * dest, j5K * src, size_t k5L, size_t num);
extern BOOL h3M(j5K * dest, j5K * src, size_t num);
extern BOOL i2T(j5K * dest, j5K * src, size_t num);
#endif 
#if j1Y
#define y8L( es, c8H ) h0Z( es, c8H, __FILE__, __LINE__ )
#define a4D( es, s ) n4J( es, s, __FILE__, __LINE__ )
#define v7I( es, ch ) w9I( es, ch, __FILE__, __LINE__ )
#define u4W( es, s ) n2K( es, s, __FILE__, __LINE__ )
#define o8S( s ) o0J( s, __FILE__, __LINE__ )
#define h3A( s ) v2V( s, __FILE__, __LINE__ )
#define e4K( s ) p1W( s )
#define i5C( s ) y1C( s )
#else
#define y8L( es, c8H ) f2B( es, c8H )
#define a4D( es, s ) f8T( es, s )
#define v7I( es, ch ) n4X( es, ch )
#define u4W( es, s ) d1R( es, s )
#define o8S( s ) u5Y( s )
#define h3A( s ) k7N( s )
#define e4K( s ) j9O( s )
#define i5C( s ) p1R( s )
#endif
#endif 
