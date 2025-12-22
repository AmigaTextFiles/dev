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
#ifndef u4D
#define u4D
#define s0E 0xFF
#define b9P 0x00
#define m3R 0x01 
#define r9O 0x02 
#define z7V 0x00
#define z6Y 0x01
#define i7C 0x02
#define t3Db z6Y
typedef enum {
g0I = 1,
u4I,
j2M,
c2P,
e6B
} w3K;
#define z7O(W) ((char)( (W) - t3Db ))
#define f2V(W) ((char)( ((char)t2S( W )) + t3Db ))
#define y2Bn(W) ((char)( t3Db - ((W) - t3Db) ))
#define p3K(A) \
((r9O & ((A)->flags))?(s0E):(b9P))
#define b4Y(A) \
((m3R & ((A)->flags))?(s0E):(b9P))
typedef unsigned char f6W;
typedef void *f7P; 
typedef struct y2Z {
struct y2Z *b9H[ 3 ];
char k5O;
} c9M;
typedef c9M *l1Z; 
typedef int (*w7Nt)( f7P, l1Z );
typedef void (*c7W)( l1Z, void * );
typedef void (*r2L)( l1Z );
typedef struct {
l1Z k6P; 
unsigned long count; 
w7Nt m3Sk; 
unsigned char flags; 
} h3P;
typedef h3P *o4R; 
long t2S( long x );
l1Z u3Ny( l1Z y2B );
o4R q4C( o4R x8O,
w7Nt b2W,
unsigned char Flags );
f6W k2M( o4R x8O,
l1Z j4E,
f7P j7S,
l1Z *s3L );
l1Z v6T( o4R x8O,
l1Z b2L );
l1Z p2P( o4R x8O,
f7P m9X,
w3K w5Y );
l1Z f9B( o4R x8O,
f7P m9X );
l1Z l1X( l1Z P );
l1Z l7C( l1Z P );
l1Z o7R( l1Z P );
l1Z d4K( l1Z P );
l1Z g1V( o4R x8O,
f7P n8U,
l1Z p );
l1Z z5H( o4R x8O,
f7P n8U,
l1Z p );
f6W b6S( o4R x8O,
c7W d2L,
void *UserData );
f6W q1C( o4R x8O,
r2L q1P );
l1Z s6Y( l1Z f5Y );
int x0K( int c8H, char *list[] );
#define w7R f7P
#define y8K c9M
#define y5M l1Z
#define r2O h3P
#define s2A o4R
#define j6U w7Nt
#define a9H c7W
#define a9O r2L
#define m8E( x ) t2S( x )
#define t8Q( Np ) u3Ny( (l1Z)(Np) )
#define j5Pt( Rp, Cf, Fl ) \
q4C( (o4R)(Rp), (w7Nt)(Cf), (Fl) )
#define x2J( Rp, Nn, Ip, On ) \
k2M( (o4R)(Rp), (l1Z)(Nn), \
(f7P)(Ip), (l1Z *)(On) )
#define r3S( Rp, Dn ) \
v6T( (o4R)(Rp), (l1Z)(Dn) )
#define u8R( Rp, Ip, Op ) \
p2P( (o4R)(Rp), \
(f7P)(Ip), \
(w3K)(Op) )
#define e1N( Rp, Ip ) \
f9B( (o4R)(Rp), (f7P)(Ip) )
#define y6G( P ) l1X( (l1Z)(P) )
#define s0K( P ) l7C( (l1Z)(P) )
#define f1T( P ) o7R( (l1Z)(P) )
#define j4W( P ) d4K( (l1Z)(P) )
#define k6S( Rp, Ip, P ) \
g1V( (o4R)(Rp), \
(f7P)(Ip), \
(l1Z)(P) )
#define b4W( Rp, Ip, P ) \
z5H( (o4R)(Rp), \
(f7P)(Ip), \
(l1Z)(P) )
#define i2U( Rp, En, Ud ) \
b6S((o4R)(Rp), (c7W)(En), (void *)(Ud))
#define b4P( Rp, Fn ) \
q1C( (o4R)(Rp), (r2L)(Fn) )
#define e2X( Nd ) \
s6Y( (l1Z)(Nd) )
#define h2Q( s, l ) x0K( s, l )
#endif 
