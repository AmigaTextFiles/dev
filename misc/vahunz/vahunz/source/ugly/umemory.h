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
#ifndef d9E
#define d9E 
#include <stdlib.h>
#include "utypes.h"
struct z1U
{
struct z1U *k0Z;
void *ptr; 
UBYTE *t5L; 
UBYTE *s9E; 
size_t c8H; 
STRPTR e9R; 
ULONG p8T; 
UBYTE c2O; 
};
typedef struct z1U j6V;
#if v2E
#define o4N(c8H) e3L( c8H, __FILE__, __LINE__ )
#define x8C(ptr) if ( ptr ) { t2B( ptr, __FILE__, __LINE__ ); ptr = NULL; }
#define c0Y(ptr,c8H) r4A( ptr, c8H, __FILE__, __LINE__ );
#define z5K(count,c8H) f7L( count,c8H,__FILE__,__LINE__ );
#define n7Ug(msg) r9C( msg, __FILE__, __LINE__, __DATE__, __TIME__ )
#define o1M(msg) a9M( msg, __FILE__, __LINE__, __DATE__, __TIME__ )
#define d6O(msg) p4No( msg, __FILE__, __LINE__ )
#define f7E i0G
#else
#define o4N(c8H) p6U(c8H)
#define x8C(ptr) if ( ptr ) { free(ptr); ptr=NULL; } 
#define c0Y(ptr,c8H) realloc( ptr, c8H );
#define z5K(count,c8H) calloc( count,c8H )
#define n7Ug(msg) 
#define o1M(msg) 
#define d6O(msg) 
#define f7E d7G
#endif 
#ifndef w5W
extern VOID s5F(char *msg, char *e9R, size_t p8T);
extern void *e3L(size_t c8H, STRPTR e9R, ULONG p8T);
extern void *p6U(size_t c8H);
extern void t2B(void *ptr, STRPTR e9R, ULONG p8T);
extern void *r4A(void *ptr, size_t c8H, STRPTR e9R, ULONG p8T);
extern void *f7L(size_t count, size_t c8H, STRPTR e9R, ULONG p8T);
extern void a9M(STRPTR msg, STRPTR e9R, ULONG p8T, STRPTR date, STRPTR time);
extern void r9C(STRPTR msg, STRPTR e9R, ULONG p8T, STRPTR date, STRPTR time);
extern void p4No(STRPTR msg, STRPTR e9R, ULONG p8T);
extern void f7E(void);
extern BOOL(*i5X) (size_t c8H);
#endif
#endif
