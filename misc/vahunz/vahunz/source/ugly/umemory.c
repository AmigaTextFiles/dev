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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utypes.h"
#define w5W
#include "umemory.h"
#define j7R 16
#if defined(AMIGA)
#define e0F 8 
#else
#define e0F 8
#endif
#ifndef a8L
#define a8L(x,by) ((by)*(((x)+(by-1))/(by)))
#endif
static j6V *q1N = NULL;
static UBYTE g4N[4] =
{0xDE, 0xAD, 0xBE, 0xEF}; 
static UBYTE v2S[4] =
{0xDE, 0xAD, 0xF0, 0x0D}; 
static UBYTE x6O = 0x81;
static ULONG x0M = 0; 
static ULONG i9S = 0; 
static ULONG b3N = 0; 
static ULONG u2N = 0; 
static ULONG e5Z = 0; 
static ULONG z6F = 0; 
static ULONG d9S = 0; 
static ULONG e8U = 0; 
static ULONG g5A = 0; 
static ULONG a1V = 0; 
void *p6U(size_t c8H);
static BOOL r3Z(j6V * r9D);
BOOL(*i5X) (size_t c8H) = NULL;
VOID s5F(char *msg, char *e9R, size_t p8T)
{
fprintf(stderr, "\n\n");
fprintf(stderr, "  I won't be a monkey in anyone's zoo\n");
fprintf(stderr, "  I won't get fazed whatever you do\n");
fprintf(stderr, "                   (Ride, \"Not Fazed\")\n\n");
fprintf(stderr, "** internal error: \"%s\" (%lu): %s\n", \
e9R, (unsigned long) p8T, msg);
exit(255);
}
static j6V *n5M(void *mem)
{
j6V *t8N = q1N;
j6V *r5W = NULL;
while (t8N && (!r5W))
{
if (t8N->ptr == mem)
{
r5W = t8N;
}
t8N = t8N->k0Z;
}
#if v2E==2
if (!r5W)
{
fprintf(stderr, "*memory* FIND_UMEM: couln't find %p\n", mem);
}
#endif
return (r5W);
}
static j6V *j8V(j6V * r9D)
{
j6V *prev = q1N;
j6V *g1U = NULL;
BOOL r5W = FALSE;
while (prev && (!r5W))
{
r5W = (prev == r9D);
if (!r5W)
{
g1U = prev;
prev = prev->k0Z;
}
}
return (g1U);
}
static void n6A(void *mem, size_t c8H, UBYTE value[4])
{
size_t i;
for (i = 0; i < c8H; i++)
{
(((UBYTE *) mem)[i]) = value[i % 4];
}
}
static void o0G(void *mem, size_t c8H, UBYTE value)
{
size_t i;
for (i = 0; i < c8H; i++)
{
(((UBYTE *) mem)[i]) = value;
}
}
static void m2K(j6V * r9D)
{
j6V *prev = j8V(r9D);
if (prev)
{
prev->k0Z = r9D->k0Z;
}
else
{
q1N = r9D->k0Z;
}
if (!r3Z(r9D))
{
n6A(r9D->t5L, r9D->c8H + 2 * j7R, g4N);
free(r9D->t5L);
}
r9D->t5L = NULL;
r9D->s9E = NULL;
r9D->c8H = 0;
r9D->e9R = NULL;
r9D->p8T = 0;
free(r9D);
}
static j6V *a3W(size_t f5P, STRPTR l8V, ULONG o8G)
{
j6V *g8O = (j6V *) malloc(sizeof(j6V));
if (g8O)
{
g8O->t5L = (UBYTE *) p6U(f5P
+ 2 * j7R);
if (g8O->t5L)
{
g8O->ptr = (void *) (g8O->t5L + j7R);
g8O->s9E = (g8O->t5L + j7R + f5P);
g8O->k0Z = q1N;
q1N = g8O;
g8O->c8H = f5P;
g8O->e9R = l8V;
g8O->p8T = o8G;
g8O->c2O = x6O;
n6A(g8O->ptr, f5P, v2S);
o0G(g8O->t5L, j7R, x6O);
o0G(g8O->s9E, j7R, x6O);
if (x6O == 0xff)
{
x6O = 0x81;
}
else
{
x6O++;
}
}
else
free(g8O);
}
return (g8O);
}
static void a3L(STRPTR msg)
{
fprintf(stderr, "%s\n", msg);
}
static void p2H(void *ptr, size_t c8H)
{
unsigned char *data = (unsigned char *) ptr;
if (c8H > 16)
{
c8H = 16;
}
fprintf(stderr, "  %p:", ptr);
if (data)
{
size_t i;
for (i = 0; i < c8H; i++)
{
if (!(i % 4))
{
fprintf(stderr, " ");
}
fprintf(stderr, "%02x", data[i]);
}
while (i < 16)
{
if (!(i % 4))
{
fprintf(stderr, " ");
}
fprintf(stderr, "  ");
i++;
}
fprintf(stderr, "  \"");
for (i = 0; i < c8H; i++)
{
if (data[i] < ' ' || ((data[i] > 128) && (data[i] < 160)))
{
fprintf(stderr, ".");
}
else
{
fprintf(stderr, "%c", data[i]);
}
}
fprintf(stderr, "\"\n");
}
else
fprintf(stderr, "NULL\n");
}
static void k5G(void *ptr, STRPTR e9R, ULONG p8T)
{
fprintf(stderr, "  %p: from \"%s\" (%lu)\n", ptr, e9R, p8T);
}
static void o7U(j6V * r9D)
{
fprintf(stderr, "  %p: %lu (0x%lx) bytes from \"%s\" (%lu)\n",
r9D->ptr, (ULONG) r9D->c8H, (ULONG) r9D->c8H,
r9D->e9R, r9D->p8T);
}
static STRPTR l3J(UBYTE i7B)
{
static d6X r0E[30];
UBYTE ch = i7B;
if (ch < 32)
ch = '.';
sprintf(r0E, "(0x%02x/#%d/`%c')", i7B, i7B, ch);
return (r0E);
}
static BOOL r3Z(j6V * r9D)
{
size_t i = 0;
BOOL n3P = FALSE;
while (!n3P && (i < j7R))
{
BOOL g9H = (r9D->t5L[i] != r9D->c2O);
BOOL q1Cj = (r9D->s9E[i] != r9D->c2O);
n3P = g9H || q1Cj;
if (n3P)
{
STRPTR g1M;
UBYTE value;
if (g9H)
{
g1M = "LOWER";
value = r9D->t5L[i];
}
else
{
g1M = "UPPER";
value = r9D->s9E[i];
}
fprintf(stderr, "*** MEMORY WALL DAMAGED!!!\n");
fprintf(stderr, "*** %s wall, byte#%lu is %s instead of 0x%02x\n",
g1M, (ULONG) i, l3J(value), r9D->c2O);
o7U(r9D);
p2H(r9D->ptr, r9D->c8H);
fprintf(stderr, "  * lower wall:\n");
p2H(r9D->t5L, j7R);
fprintf(stderr, "  * upper wall:\n");
p2H(r9D->s9E, j7R);
}
else
{
i++;
}
}
return (n3P);
}
VOID p4No(STRPTR msg, STRPTR e9R, ULONG p8T)
{
j6V *r9D = q1N;
if (r9D)
{
fprintf(stderr, "MEMORY WALL-CHECK (%s)", msg);
if (e9R)
fprintf(stderr, " from `%s' (%lu)", e9R, p8T);
fprintf(stderr, "\n");
while (r9D)
{
if (r9D->ptr)
{
r3Z(r9D);
r9D = r9D->k0Z;
}
else
{
r9D = NULL;
fprintf(stderr, "\n** PANIC: memory list trashed\n");
}
}
}
}
void r9C(STRPTR msg, STRPTR e9R, ULONG p8T, STRPTR date, STRPTR time)
{
j6V *r9D = q1N;
if (r9D)
{
fprintf(stderr, "MEMORY REPORT (%s)\n", msg);
if (e9R)
{
fprintf(stderr, "(\"%s\" (%lu), at %s, %s)\n",
e9R, p8T, date, time);
}
while (r9D)
{
if (r9D->ptr)
{
o7U(r9D);
p2H(r9D->ptr, r9D->c8H);
r9D = r9D->k0Z;
}
else
{
r9D = NULL;
fprintf(stderr, "##\n## panic: memory list trashed\n##\n");
}
}
}
}
void a9M(STRPTR msg, STRPTR e9R, ULONG p8T, STRPTR date, STRPTR time)
{
fprintf(stderr, "MEMORY STATISTICS (%s)\n", msg);
if (e9R)
{
fprintf(stderr, "(\"%s\" (%lu), at %s, %s)\n",
e9R, p8T, date, time);
}
fprintf(stderr, "  bytes used: %lu max: %lu/%lu  ",
z6F, d9S,
e5Z);
if (e5Z)
{
fprintf(stderr, "slack: %lu%%\n",
(100 * (d9S - e5Z))
/ e5Z);
}
else
{
fprintf(stderr, "no slack\n");
}
fprintf(stderr, "  nodes used: %lu (max: %lu)\n",
a1V, g5A);
fprintf(stderr, "  calls to: umalloc(%lu)   ufree(%lu)\n",
x0M, i9S);
}
void i0G(void)
{
ULONG f0A = z6F;
r9C("at exit:  MEMORY LEAK detected!",
NULL, 0, NULL, NULL);
a9M("[exit]", NULL, 0, NULL, NULL);
while (q1N)
{
m2K(q1N);
}
if (f0A)
{
fprintf(stderr, "\n%lu bytes of memory lost!\n", f0A);
}
}
void d7G(void)
{
}
void *p6U(size_t c8H)
{
void *mem;
BOOL o8R;
do
{
mem = malloc(c8H);
if (!mem && i5X)
{
o8R = (*i5X) (c8H);
if (!o8R)
{
exit(EXIT_FAILURE); 
}
}
else
{
o8R = FALSE;
}
}
while (o8R);
return (mem);
}
void *e3L(size_t c8H, STRPTR e9R, ULONG p8T)
{
void *mem = NULL;
j6V *r9D = NULL;
#if v2E==2
fprintf(stderr, "*memory* UMALLOC() from `%s' (%lu)\n", e9R, p8T);
#endif
if (c8H)
{
x0M++;
r9D = a3W(c8H, e9R, p8T);
if (r9D)
{
mem = r9D->ptr;
z6F += c8H;
e8U += a8L(c8H, e0F);
if (z6F > e5Z)
e5Z = z6F;
if (e8U > d9S)
d9S = e8U;
a1V++;
if (a1V > g5A)
g5A = a1V;
}
}
else
{
b3N++;
a3L("MALLOC: zero-sized allocation");
k5G(NULL, e9R, p8T);
}
return (mem);
}
void t2B(void *ptr, STRPTR e9R, ULONG p8T)
{
#if v2E==2
fprintf(stderr, "*memory* UFREE() from `%s' (%lu)\n", e9R, p8T);
#elif 0
fputc('.', stderr); 
fflush(stderr);
#endif
if (ptr)
{
j6V *r9D = n5M(ptr);
if (r9D)
{
i9S++;
z6F -= r9D->c8H;
e8U -= a8L(r9D->c8H, e0F);
m2K(r9D);
a1V--;
}
else
{
u2N++;
a3L("*** FREE: memory never allocated "
" or released twice");
k5G(ptr, e9R, p8T);
}
}
}
void *r4A(void *ptr, size_t c8H, STRPTR e9R, ULONG p8T)
{
void *h3Y = e3L(c8H, e9R, p8T);
j6V *r9D = n5M(ptr);
if (h3Y && r9D)
{
memcpy(h3Y, r9D->ptr, r9D->c8H);
t2B(ptr, e9R, p8T);
}
return (h3Y);
}
void *f7L(size_t count, size_t c8H, STRPTR e9R, ULONG p8T)
{
void *mem = e3L(count * c8H, e9R, p8T);
if (mem)
{
memset(mem, 0, c8H * count);
}
return (mem);
}
