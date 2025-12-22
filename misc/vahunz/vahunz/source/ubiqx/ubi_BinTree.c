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
#include "ubi_BinTree.h" 
#include <stdlib.h> 
static char f2A[] = "ubi_BinTree\n\
\t$Revision: 2.5 $\n\
\t$Date: 1997/12/23 03:56:29 $\n\
\t$Author: crh $\n";
static l1Z l4I( w7Nt m3Sk,
f7P m9X,
register l1Z p )
{
long e0Y;
while( p && (( e0Y = f2V((*m3Sk)(m9X, p)) ) != t3Db) )
p = p->b9H[e0Y];
return( p );
} 
static l1Z p7Q( f7P j3I,
l1Z p,
l1Z *t6Z,
char *k5O,
w7Nt q6X )
{
register l1Z t6V = p;
l1Z x2Ez = NULL;
int h1J = t3Db;
int t1W;
while( t6V
&& (t3Db != (t1W = f2V((*q6X)(j3I, t6V)))) )
{
x2Ez = t6V; 
h1J = t1W; 
t6V = t6V->b9H[t1W]; 
}
*t6Z = x2Ez; 
*k5O = h1J;
return( t6V );
} 
static void l9H( l1Z *e2L,
l1Z k7H,
l1Z t2M )
{
register int i;
register int g4D = sizeof( c9M );
for( i = 0; i < g4D; i++ ) 
((unsigned char *)t2M)[i] = ((unsigned char *)k7H)[i];
(*e2L) = t2M; 
if( k7H->b9H[z7V] )
(k7H->b9H[z7V])->b9H[z6Y] = t2M;
if( k7H->b9H[i7C] )
(k7H->b9H[i7C])->b9H[z6Y] = t2M;
} 
static void q7H( o4R x8O,
l1Z v6L,
l1Z h3D )
{
l1Z *Parent;
c9M u4M;
l1Z v3O = &u4M;
if( v6L->b9H[z6Y] )
Parent = &((v6L->b9H[z6Y])->b9H[(int)(v6L->k5O)]);
else
Parent = &(x8O->k6P);
l9H( Parent, v6L, v3O );
if( h3D->b9H[z6Y] )
Parent = &((h3D->b9H[z6Y])->b9H[(int)(h3D->k5O)]);
else
Parent = &(x8O->k6P);
l9H( Parent, h3D, v6L );
if( v3O->b9H[z6Y] )
Parent = &((v3O->b9H[z6Y])->b9H[(int)(v3O->k5O)]);
else
Parent = &(x8O->k6P);
l9H( Parent, v3O, h3D );
} 
static l1Z b7K( register l1Z P,
register int i8L )
{
l1Z Q = NULL;
while( P )
{
Q = P;
P = P->b9H[ i8L ];
}
return( Q );
} 
static l1Z u9X( register l1Z P,
register int i8L )
{
if( P )
{
if( P->b9H[ i8L ] )
return( b7K( P->b9H[ i8L ], (char)y2Bn(i8L) ) );
else
while( P->b9H[ z6Y ] )
{
if( (P->b9H[ z6Y ])->b9H[ i8L ] == P )
P = P->b9H[ z6Y ];
else
return( P->b9H[ z6Y ] );
}
}
return( NULL );
} 
static l1Z Border( o4R x8O,
f7P m9X,
l1Z p,
int i8L )
{
register l1Z q;
if( !p3K( x8O ) || (z6Y == i8L) )
return( p );
q = p->b9H[z6Y];
while( q && (t3Db == f2V( (*(x8O->m3Sk))(m9X, q) )) )
{
p = q;
q = p->b9H[z6Y];
}
q = p->b9H[i8L];
while( q )
{
q = l4I( x8O->m3Sk, m9X, q );
if( q )
{
p = q;
q = p->b9H[i8L];
}
}
return( p );
} 
long t2S( register long x )
{
return( (x)?((x>0)?(1):(-1)):(0) );
} 
l1Z u3Ny( l1Z y2B )
{
y2B->b9H[ z7V ] = NULL;
y2B->b9H[ z6Y ] = NULL;
y2B->b9H[ i7C ] = NULL;
y2B->k5O = t3Db;
return( y2B );
} 
o4R q4C( o4R x8O,
w7Nt b2W,
unsigned char Flags )
{
if( x8O )
{
x8O->k6P = NULL;
x8O->count = 0L;
x8O->m3Sk = b2W;
x8O->flags = (Flags & r9O) ? r9O : Flags;
} 
return( x8O );
} 
f6W k2M( o4R x8O,
l1Z j4E,
f7P j7S,
l1Z *s3L )
{
l1Z r9V,
e2L = NULL;
char e0Y;
if( !(s3L) ) 
s3L = &r9V;
(void)u3Ny( j4E ); 
*s3L = p7Q(j7S, (x8O->k6P), &e2L, &e0Y, (x8O->m3Sk));
if (!(*s3L)) 
{
if (!(e2L))
x8O->k6P = j4E;
else
{
e2L->b9H[(int)e0Y] = j4E;
j4E->b9H[z6Y] = e2L;
j4E->k5O = e0Y;
}
(x8O->count)++;
return( s0E );
}
if( p3K(x8O) ) 
{
l1Z q;
e0Y = i7C;
q = (*s3L);
*s3L = NULL;
while( q )
{
e2L = q;
if( e0Y == t3Db )
e0Y = i7C;
q = q->b9H[(int)e0Y];
if ( q )
e0Y = f2V( (*(x8O->m3Sk))(j7S, q) );
}
e2L->b9H[(int)e0Y] = j4E;
j4E->b9H[z6Y] = e2L;
j4E->k5O = e0Y;
(x8O->count)++;
return( s0E );
}
if( b4Y(x8O) ) 
{
if (!(e2L))
l9H( &(x8O->k6P), *s3L, j4E );
else
l9H( &(e2L->b9H[(int)((*s3L)->k5O)]),
*s3L, j4E );
return( s0E );
}
return( b9P ); 
} 
l1Z v6T( o4R x8O,
l1Z b2L )
{
l1Z p,
*t6Z;
int e0Y;
if( (b2L->b9H[z7V]) && (b2L->b9H[i7C]) )
q7H( x8O, b2L, l7C( b2L ) );
if (b2L->b9H[z6Y])
t6Z = &((b2L->b9H[z6Y])->b9H[(int)(b2L->k5O)]);
else
t6Z = &( x8O->k6P );
e0Y = ((b2L->b9H[z7V])?z7V:i7C);
p = (b2L->b9H[e0Y]);
if( p )
{
p->b9H[z6Y] = b2L->b9H[z6Y];
p->k5O = b2L->k5O;
}
(*t6Z) = p;
(x8O->count)--;
return( b2L );
} 
l1Z p2P( o4R x8O,
f7P m9X,
w3K w5Y )
{
register l1Z p;
l1Z e2L;
char p4Ny;
p = p7Q( m9X,
x8O->k6P,
&e2L,
&p4Ny,
x8O->m3Sk );
if( p ) 
{
switch( w5Y )
{
case g0I: 
p = Border( x8O, m9X, p, z7V );
return( u9X( p, z7V ) );
case e6B: 
p = Border( x8O, m9X, p, i7C );
return( u9X( p, i7C ) );
default:
p = Border( x8O, m9X, p, z7V );
return( p );
}
}
if( j2M == w5Y ) 
return( NULL ); 
if( (g0I == w5Y) || (u4I == w5Y) )
return( (z7V == p4Ny) ? u9X( e2L, p4Ny ) : e2L );
else
return( (i7C == p4Ny) ? u9X( e2L, p4Ny ) : e2L );
} 
l1Z f9B( o4R x8O,
f7P m9X )
{
return( l4I( x8O->m3Sk, m9X, x8O->k6P ) );
} 
l1Z l1X( l1Z P )
{
return( u9X( P, i7C ) );
} 
l1Z l7C( l1Z P )
{
return( u9X( P, z7V ) );
} 
l1Z o7R( l1Z P )
{
return( b7K( P, z7V ) );
} 
l1Z d4K( l1Z P )
{
return( b7K( P, i7C ) );
} 
l1Z g1V( o4R x8O,
f7P n8U,
l1Z p )
{
if( !p || f2V( (*(x8O->m3Sk))( n8U, p ) != t3Db ) )
return( NULL );
return( Border( x8O, n8U, p, z7V ) );
} 
l1Z z5H( o4R x8O,
f7P n8U,
l1Z p )
{
if( !p || f2V( (*(x8O->m3Sk))( n8U, p ) != t3Db ) )
return( NULL );
return( Border( x8O, n8U, p, i7C ) );
} 
f6W b6S( o4R x8O,
c7W d2L,
void *UserData )
{
l1Z p;
if( !(p = o7R( x8O->k6P )) ) return( b9P );
while( p )
{
(*d2L)( p, UserData );
p = l1X( p );
}
return( s0E );
} 
f6W q1C( o4R x8O,
r2L q1P )
{
l1Z p, q;
if( !(x8O) || !(q1P) )
return( b9P );
p = o7R( x8O->k6P );
while( p )
{
q = p;
while( q->b9H[i7C] )
q = b7K( q->b9H[i7C], z7V );
p = q->b9H[z6Y];
if( p )
p->b9H[ ((p->b9H[z7V] == q)?z7V:i7C) ] = NULL;
(*q1P)((void *)q);
}
(void)q4C( x8O,
x8O->m3Sk,
x8O->flags );
return( s0E );
} 
l1Z s6Y( l1Z f5Y )
{
l1Z x1M = NULL;
int i8L = z7V;
while( NULL != f5Y )
{
x1M = f5Y;
f5Y = x1M->b9H[ i8L ];
if( NULL == f5Y )
{
i8L = y2Bn( i8L );
f5Y = x1M->b9H[ i8L ];
}
}
return( x1M );
} 
int x0K( int c8H, char *list[] )
{
if( c8H > 0 )
{
list[0] = f2A;
if( c8H > 1 )
list[1] = NULL;
return( 1 );
}
return( 0 );
} 
