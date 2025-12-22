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
#include "ubi_AVLtree.h" 
#include <stdlib.h> 
static char f2A[] = "ubi_AVLtree\n\
\t$Revision: 2.5 $\n\
\t$Date: 1997/12/23 04:00:42 $\n\
\t$Author: crh $\n";
static h1G L1( h1G p )
{
h1G e0Y;
e0Y = p->b9H[i7C];
p->b9H[i7C] = e0Y->b9H[z7V];
e0Y->b9H[z7V] = p;
e0Y->b9H[z6Y] = p->b9H[z6Y];
e0Y->k5O = p->k5O;
if(e0Y->b9H[z6Y])
(e0Y->b9H[z6Y])->b9H[(int)(e0Y->k5O)] = e0Y;
p->b9H[z6Y] = e0Y;
p->k5O = z7V;
if( p->b9H[i7C] )
{
p->b9H[i7C]->b9H[z6Y] = p;
(p->b9H[i7C])->k5O = i7C;
}
p->h4S -= z7O( e0Y->h4S );
(e0Y->h4S)--;
return( e0Y );
} 
static h1G R1( h1G p )
{
h1G e0Y;
e0Y = p->b9H[z7V];
p->b9H[z7V] = e0Y->b9H[i7C];
e0Y->b9H[i7C] = p;
e0Y->b9H[z6Y] = p->b9H[z6Y];
e0Y->k5O = p->k5O;
if(e0Y->b9H[z6Y])
(e0Y->b9H[z6Y])->b9H[(int)(e0Y->k5O)] = e0Y;
p->b9H[z6Y] = e0Y;
p->k5O = i7C;
if(p->b9H[z7V])
{
p->b9H[z7V]->b9H[z6Y] = p;
p->b9H[z7V]->k5O = z7V;
}
p->h4S -= z7O( e0Y->h4S );
(e0Y->h4S)++;
return( e0Y );
} 
static h1G L2( h1G d2J )
{
h1G e0Y, g3Mw;
e0Y = d2J->b9H[i7C];
g3Mw = e0Y->b9H[z7V];
e0Y->b9H[z7V] = g3Mw->b9H[i7C];
g3Mw->b9H[i7C] = e0Y;
d2J->b9H[i7C] = g3Mw->b9H[z7V];
g3Mw->b9H[z7V] = d2J;
g3Mw->b9H[z6Y] = d2J->b9H[z6Y];
g3Mw->k5O = d2J->k5O;
d2J->b9H[z6Y] = g3Mw;
d2J->k5O = z7V;
e0Y->b9H[z6Y] = g3Mw;
e0Y->k5O = i7C;
if( d2J->b9H[i7C] )
{
d2J->b9H[i7C]->b9H[z6Y] = d2J;
d2J->b9H[i7C]->k5O = i7C;
}
if( e0Y->b9H[z7V] )
{
e0Y->b9H[z7V]->b9H[z6Y] = e0Y;
e0Y->b9H[z7V]->k5O = z7V;
}
if(g3Mw->b9H[z6Y])
g3Mw->b9H[z6Y]->b9H[(int)(g3Mw->k5O)] = g3Mw;
switch( g3Mw->h4S )
{
case z7V :
d2J->h4S = t3Db; e0Y->h4S = i7C; break;
case t3Db:
d2J->h4S = t3Db; e0Y->h4S = t3Db; break;
case i7C:
d2J->h4S = z7V; e0Y->h4S = t3Db; break;
}
g3Mw->h4S = t3Db;
return( g3Mw );
} 
static h1G R2( h1G d2J )
{
h1G e0Y, g3Mw;
e0Y = d2J->b9H[z7V];
g3Mw = e0Y->b9H[i7C];
e0Y->b9H[i7C] = g3Mw->b9H[z7V];
g3Mw->b9H[z7V] = e0Y;
d2J->b9H[z7V] = g3Mw->b9H[i7C];
g3Mw->b9H[i7C] = d2J;
g3Mw->b9H[z6Y] = d2J->b9H[z6Y];
g3Mw->k5O = d2J->k5O;
d2J->b9H[z6Y] = g3Mw;
d2J->k5O = i7C;
e0Y->b9H[z6Y] = g3Mw;
e0Y->k5O = z7V;
if( d2J->b9H[z7V] )
{
d2J->b9H[z7V]->b9H[z6Y] = d2J;
d2J->b9H[z7V]->k5O = z7V;
}
if( e0Y->b9H[i7C] )
{
e0Y->b9H[i7C]->b9H[z6Y] = e0Y;
e0Y->b9H[i7C]->k5O = i7C;
}
if(g3Mw->b9H[z6Y])
g3Mw->b9H[z6Y]->b9H[(int)(g3Mw->k5O)] = g3Mw;
switch( g3Mw->h4S )
{
case z7V :
d2J->h4S = i7C; e0Y->h4S = t3Db; break;
case t3Db :
d2J->h4S = t3Db; e0Y->h4S = t3Db; break;
case i7C :
d2J->h4S = t3Db; e0Y->h4S = z7V; break;
}
g3Mw->h4S = t3Db;
return( g3Mw );
} 
static h1G y3Y( h1G p, char o3T )
{
if( p->h4S != o3T )
p->h4S += z7O(o3T);
else
{
char b2P; 
b2P = p->b9H[(int)o3T]->h4S;
if( ( t3Db == b2P ) || ( p->h4S == b2P ) )
p = ( (z7V==o3T) ? R1(p) : L1(p) ); 
else
p = ( (z7V==o3T) ? R2(p) : L2(p) ); 
}
return( p );
} 
static h1G l2B( h1G f1B,
h1G z0G,
char o3T )
{
while( z0G )
{
z0G = y3Y( z0G, o3T );
if( z6Y == z0G->k5O )
return( z0G );
if( t3Db == z0G->h4S )
return( f1B );
o3T = z0G->k5O;
z0G = z0G->b9H[z6Y];
}
return( f1B );
} 
static h1G t4A( h1G f1B,
h1G z0G,
char o3T )
{
while( z0G )
{
z0G = y3Y( z0G, y2Bn(o3T) );
if( z6Y == z0G->k5O )
return( z0G );
if( t3Db != z0G->h4S )
return( f1B );
o3T = z0G->k5O;
z0G = z0G->b9H[z6Y];
}
return( f1B );
} 
static void l9H( h1G *e2L,
h1G k7H,
h1G t2M )
{
register int i;
register int s3U = sizeof( l3Q );
for( i = 0; i < s3U; i++ )
((unsigned char *)t2M)[i] = ((unsigned char *)k7H)[i];
(*e2L) = t2M;
if(k7H->b9H[z7V ] )
(k7H->b9H[z7V ])->b9H[z6Y] = t2M;
if(k7H->b9H[i7C] )
(k7H->b9H[i7C])->b9H[z6Y] = t2M;
} 
static void q7H( o4R x8O,
h1G v6L,
h1G h3D )
{
h1G *Parent;
l3Q u4M;
h1G v3O = &u4M;
if( v6L->b9H[z6Y] )
Parent = &((v6L->b9H[z6Y])->b9H[(int)(v6L->k5O)]);
else
Parent = (h1G *)&(x8O->k6P);
l9H( Parent, v6L, v3O );
if( h3D->b9H[z6Y] )
Parent = &((h3D->b9H[z6Y])->b9H[(int)(h3D->k5O)]);
else
Parent = (h1G *)&(x8O->k6P);
l9H( Parent, h3D, v6L );
if( v3O->b9H[z6Y] )
Parent = &((v3O->b9H[z6Y])->b9H[(int)(v3O->k5O)]);
else
Parent = (h1G *)&(x8O->k6P);
l9H( Parent, v3O, h3D );
} 
h1G v2G( h1G y2B )
{
(void)u3Ny( (l1Z)y2B );
y2B->h4S = t3Db;
return( y2B );
} 
f6W y6M( o4R x8O,
h1G j4E,
f7P j7S,
h1G *s3L )
{
h1G r9V;
if( !(s3L) ) s3L = &r9V;
if( k2M( x8O,
(l1Z)j4E,
j7S,
(l1Z *)s3L ) )
{
if( (*s3L) )
j4E->h4S = (*s3L)->h4S;
else
{
j4E->h4S = t3Db;
x8O->k6P = (l1Z)l2B( (h1G)x8O->k6P,
j4E->b9H[z6Y],
j4E->k5O );
}
return( s0E );
}
return( b9P ); 
} 
h1G y5R( o4R x8O,
h1G b2L )
{
l1Z p,
*t6Z;
if( (b2L->b9H[z7V]) && (b2L->b9H[i7C]) )
q7H( x8O, b2L, s0K( b2L ) );
if( b2L->b9H[z6Y] )
t6Z = (l1Z *)
&((b2L->b9H[z6Y])->b9H[(int)(b2L->k5O)]);
else
t6Z = &( x8O->k6P );
if( t3Db == b2L->h4S )
(*t6Z) = NULL;
else
{
p = (l1Z)(b2L->b9H[(int)(b2L->h4S)]);
p->b9H[z6Y] = (l1Z)b2L->b9H[z6Y];
p->k5O = b2L->k5O;
(*t6Z) = p;
}
x8O->k6P = (l1Z)t4A( (h1G)x8O->k6P,
b2L->b9H[z6Y],
b2L->k5O );
(x8O->count)--;
return( b2L );
} 
int p8M( int c8H, char *list[] )
{
if( c8H > 0 )
{
list[0] = f2A;
if( c8H > 1 )
return( 1 + x0K( --c8H, &(list[1]) ) );
return( 1 );
}
return( 0 );
} 
