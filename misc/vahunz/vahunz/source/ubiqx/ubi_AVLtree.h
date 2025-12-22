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
#ifndef z0O
#define z0O
#include "ubi_BinTree.h" 
typedef struct k0E {
struct k0E
*b9H[3]; 
char k5O; 
char h4S; 
} l3Q;
typedef l3Q *h1G; 
h1G v2G( h1G y2B );
f6W y6M( o4R x8O,
h1G j4E,
f7P j7S,
h1G *s3L );
h1G y5R( o4R x8O,
h1G b2L );
int p8M( int c8H, char *list[] );
#undef y8K
#undef y5M
#define y8K l3Q
#define y5M h1G
#undef t8Q
#define t8Q( Np ) v2G( (h1G)(Np) )
#undef x2J
#define x2J( Rp, Nn, Ip, On ) \
y6M( (o4R)(Rp), (h1G)(Nn), \
(f7P)(Ip), (h1G *)(On) )
#undef r3S
#define r3S( Rp, Dn ) \
y5R( (o4R)(Rp), (h1G)(Dn) )
#undef u8R
#define u8R( Rp, Ip, Op ) \
(h1G)p2P( (o4R)(Rp), \
(f7P)(Ip), \
(w3K)(Op) )
#undef e1N
#define e1N( Rp, Ip ) \
(h1G)f9B( (o4R)(Rp), (f7P)(Ip) )
#undef y6G
#define y6G( P ) (h1G)l1X( (l1Z)(P) )
#undef s0K
#define s0K( P ) (h1G)l7C( (l1Z)(P) )
#undef f1T
#define f1T( P ) (h1G)o7R( (l1Z)(P) )
#undef j4W
#define j4W( P ) (h1G)d4K( (l1Z)(P) )
#undef k6S
#define k6S( Rp, Ip, P ) \
(h1G)g1V( (o4R)(Rp), \
(f7P)(Ip), \
(l1Z)(P) )
#undef b4W
#define b4W( Rp, Ip, P ) \
(h1G)z5H( (o4R)(Rp), \
(f7P)(Ip), \
(l1Z)(P) )
#undef e2X
#define e2X( Nd ) \
(h1G)s6Y( (l1Z)(Nd) )
#undef h2Q
#define h2Q( s, l ) p8M( s, l )
#endif 
