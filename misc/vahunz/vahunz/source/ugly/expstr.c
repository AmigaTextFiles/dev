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
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "utypes.h"
#include "ustring.h"
#include "umemory.h"
#define c6D
#include "expstr.h"
#if j1Y
#define D(x) x
#define q3R "*expstr* "
#else
#define D(x) 
#endif
VOID n7U(VOID)
{
j5K *t0I = o8S(0); 
j5K *o5J = o8S(0); 
BOOL ok = ((BOOL) (t0I && o5J)); 
if (ok)
{
ok &= a4D(t0I, "sepp"); 
ok &= a4D(o5J, "hugo");
ok &= u4W(t0I, ". "); 
ok &= u4W(o5J, " and ");
ok &= j0P(o5J, t0I); 
ok &= h3A(t0I); 
}
if (ok)
{
if (strcmp(e4K(t0I), "hugo and sepp.") || i5C(t0I))
{
fprintf(stderr, "error in test_expstr: data mismatch\n");
ok = FALSE;
}
}
else
{
perror("error in test_expstr:");
}
y6Q(o5J); 
y6Q(t0I);
if (!ok)
{
abort();
}
}
static void i8A(STRPTR t5W, STRPTR e9R, ULONG p8T)
{
fprintf(stderr, "\n##\n## panic: es=NULL in %s()\n##   called from %s (%lu)\n##\n",
t5W, e9R, p8T);
}
static void s4Z(STRPTR t5W, STRPTR e9R, ULONG p8T)
{
fprintf(stderr, "\n##\n## panic: string=NULL in %s()\n##   called from %s (%lu)\n##\n",
t5W, e9R, p8T);
}
static BOOL w7N(j5K * es, STRPTR k8A, size_t l6N)
{
BOOL ok = TRUE;
if (k8A)
{
#if j1Y == 2
D(fprintf(stderr, q3R "set to %lu (%p->%p)\n",
l6N, es->r1C, k8A));
#endif
es->p3Q = l6N;
es->r1C = k8A;
}
else
ok = FALSE;
return (ok);
}
BOOL f2B(j5K * es, size_t l6N)
{
return (w7N(es, (STRPTR) o4N(l6N), l6N));
}
BOOL h0Z(j5K * es, size_t l6N, STRPTR e9R, ULONG p8T)
{
BOOL ok = FALSE;
if (!es)
i8A("set_estr_mem", e9R, p8T);
else
{
ok = w7N(es,
(STRPTR) e3L(l6N, e9R, p8T),
l6N);
}
return (ok);
}
BOOL f8T(j5K * es, t8B s)
{
BOOL ok = FALSE;
size_t f3S = strlen(s) + 1;
STRPTR j3P = es->r1C;
if ((es->p3Q == es->x6G)
&& (es->p3Q > f3S))
{
strcpy(es->r1C, s); 
es->r0H = f3S; 
ok = TRUE;
}
else if (y8L(es, m4R(f3S, es->x6G)))
{
strcpy(es->r1C, s); 
v3S(j3P);
es->r0H = f3S; 
ok = TRUE;
}
return (ok);
}
BOOL n4J(j5K * es, t8B s, STRPTR e9R, ULONG p8T)
{
BOOL ok = FALSE;
if (!es)
i8A("set_estr_mem", e9R, p8T);
else if (!s)
s4Z("set_estr_mem", e9R, p8T);
else
{
size_t f3S = strlen(s) + 1;
STRPTR j3P = es->r1C;
#if j1Y == 2
p4No("setestr()", e9R, p8T);
#endif
if ((es->p3Q == es->x6G)
&& (es->p3Q > f3S))
{
strcpy(es->r1C, s); 
es->r0H = f3S; 
ok = TRUE;
}
else if (h0Z(es, m4R(f3S, es->x6G), e9R, p8T))
{
strcpy(es->r1C, s); 
x8C(j3P);
es->r0H = f3S; 
ok = TRUE;
}
#if j1Y == 2
p4No("setestr()", e9R, p8T);
#endif
}
return (ok);
}
BOOL k7N(j5K * es)
{
return (a4D(es, ""));
}
BOOL v2V(j5K * es, STRPTR e9R, ULONG p8T)
{
#if j1Y == 2
STRPTR s = es->r1C;
if (!s)
s = "<null>";
fprintf(stderr, q3R "clr_estr(%p,`%s')\n", es, s);
p4No("clr_estr()", e9R, p8T);
#endif
return (n4J(es, "", e9R, p8T));
}
BOOL c9U(j5K * es, t8B s, size_t n)
{
BOOL ok = FALSE;
STRPTR s1 = NULL;
size_t b1B = strlen(s);
if (n > b1B)
n = b1B;
s1 = (STRPTR) o4N(n + 1);
if (s1)
{
memcpy(s1, s, n);
s1[n] = 0;
ok = a4D(es, s1);
x8C(s1);
}
return (ok);
}
j5K *o0J(size_t g9W, STRPTR e9R, ULONG p8T)
{
j5K *es = (j5K *) e3L(sizeof(j5K), e9R, p8T);
if (es)
{
if (g9W < h7L)
g9W = h7L;
es->r1C = NULL;
es->p3Q = 0;
es->x6G = g9W;
if (!h3A(es))
{
x8C(es);
es = NULL;
}
}
return (es);
}
j5K *u5Y(size_t g9W)
{
j5K *es = (j5K *) o4N(sizeof(j5K));
if (es)
{
if (g9W < h7L)
g9W = h7L;
es->r1C = NULL;
es->p3Q = 0;
es->x6G = g9W;
if (!h3A(es))
{
x8C(es);
es = NULL;
}
}
return (es);
}
VOID y6Q(j5K * es)
{
#if j1Y
if (es)
{
if (es->r1C)
{
#if j1Y == 2
d6X s[17];
strncpy(s, es->r1C, 17);
s[16] = 0;
D(fprintf(stderr, q3R "del_estr(%p,`%s')\n", es, s));
d6O("del_estr()");
#endif
}
else
{
D(fprintf(stderr, q3R "attempt to free null-data-estr\n"));
}
}
else
{
#if j1Y == 2
D(fprintf(stderr, q3R "attempt to free null-estr\n"));
#endif
}
#endif
if (es)
{
x8C(es->r1C);
es->r0H = 0;
es->p3Q = 0;
es->x6G = 0;
x8C(es);
}
}
BOOL n4X(j5K * es, int ch)
{
BOOL ok = TRUE;
if (es->r0H >= es->p3Q)
{ 
STRPTR j3P = es->r1C; 
if (y8L(es,
es->p3Q + es->x6G))
{ 
strcpy(es->r1C, 
j3P);
x8C(j3P); 
}
else
{
ok = FALSE;
}
}
if (ok)
{
STRPTR s;
s = es->r1C;
s[es->r0H - 1] = ch; 
s[es->r0H] = 0;
es->r0H++; 
}
return (ok);
}
BOOL w9I(j5K * es, int ch, STRPTR e9R, ULONG p8T)
{
BOOL ok = TRUE;
if (!es)
{
i8A("app_estrch", e9R, p8T);
ok = FALSE;
}
else if (es->r0H >= es->p3Q)
{ 
STRPTR j3P = es->r1C; 
if (h0Z(es,
es->p3Q + es->x6G, e9R, p8T))
{
strcpy(es->r1C, 
j3P);
x8C(j3P); 
}
else
{ 
ok = FALSE;
}
}
if (ok)
{
STRPTR s;
s = es->r1C;
s[es->r0H - 1] = ch; 
s[es->r0H] = 0;
es->r0H++; 
}
return (ok);
}
BOOL d1R(j5K * es, t8B s)
{
BOOL ok = TRUE;
size_t x0E = strlen(s);
ok = TRUE;
if ((es->r0H + x0E - 1) >= es->p3Q)
{ 
STRPTR j3P = es->r1C; 
if (f2B(es,
m4R(es->r0H + x0E + 1, es->x6G)))
{
strcpy(es->r1C, 
j3P);
x8C(j3P); 
}
else
{ 
ok = FALSE;
}
}
if (ok)
{
STRPTR ds;
ds = es->r1C + (es->r0H - 1);
strcat(ds, s);
es->r0H += x0E; 
es->r1C[es->r0H - 1] = 0;
}
return (ok);
}
BOOL n2K(j5K * es, t8B s, STRPTR e9R, ULONG p8T)
{
BOOL ok = FALSE;
if (!es)
i8A("app_estr", e9R, p8T);
else if (!s)
s4Z("app_estr", e9R, p8T);
else
{
size_t x0E = strlen(s);
ok = TRUE;
if ((es->r0H + x0E - 1) >= es->p3Q)
{ 
STRPTR j3P = es->r1C; 
if (h0Z(es,
m4R(es->r0H + x0E + 1, es->x6G), e9R, p8T))
{ 
strcpy(es->r1C, 
j3P);
x8C(j3P); 
}
else
{ 
ok = FALSE;
}
}
if (ok)
{
STRPTR ds;
ds = es->r1C + (es->r0H - 1);
strcat(ds, s);
es->r0H += x0E; 
es->r1C[es->r0H - 1] = 0;
}
}
return (ok);
}
BOOL w2K(j5K * dest, j5K * src, size_t k5L, size_t num)
{
BOOL ok = FALSE;
j5K *e0Y = o8S(dest->x6G);
if (e0Y)
{
STRPTR j3P = e0Y->r1C;
if (k5L >= src->r0H)
k5L = src->r0H - 1;
if (k5L + num >= src->r0H)
num = src->r0H - k5L - 1;
ok = y8L(e0Y, m4R(num + 1, e0Y->x6G));
if (ok)
{
strncpy(e4K(e0Y), e4K(src) + k5L, num);
e0Y->r1C[num] = 0;
e0Y->r0H = num + 1;
x8C(j3P);
ok = k6F(dest, e0Y);
}
y6Q(e0Y);
}
return (ok);
}
BOOL h3M(j5K * dest, j5K * src, size_t num)
{
if (num >= src->r0H)
num = src->r0H - 1;
return (w2K(dest, src, (src->r0H - num - 1), num));
}
BOOL i2T(j5K * dest, j5K * src, size_t num)
{
return (w2K(dest, src, 0, num));
}
STRPTR p1W(j5K * es)
{
return (es->r1C);
}
size_t y1C(j5K * es)
{
return (es->r0H - 1);
}
BOOL k6F(j5K * dest, j5K * src)
{
return (a4D(dest, e4K(src)));
}
BOOL j0P(j5K * dest, j5K * src)
{
return (u4W(dest, e4K(src)));
}
