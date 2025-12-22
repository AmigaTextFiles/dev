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
#include <errno.h>
#include <stdarg.h>
#include <time.h>
#ifdef AMIGA
#include <dos/dos.h>
#include <proto/dos.h>
#define t5Z 1
#endif
#include "ubiqx/ubi_AVLtree.h"
#include "ugly/utypes.h"
#define STRPTR char * 
#include "ugly/umemory.h"
#include "ugly/ustring.h"
#include "ugly/expstr.h"
#include "vahunz_rev.h"
#include "vahunz/keywords.c"
#define q4H 0
#define g0G 1
struct s3P
{
y8K Node; 
STRPTR p8K; 
STRPTR t7Y; 
ULONG t5S; 
char e7H; 
};
typedef struct s3P h8A;
void b4E(void)
{
#if q4H
fprintf(stderr, "*vahunz* [%d] ", errno);
#endif
}
void i2B(void)
{
#if q4H
fprintf(stderr, "\n");
#endif
}
void h4V(const char *format,...)
{
#if q4H
va_list r0V;
va_start(r0V, format);
b4E();
vfprintf(stderr, format, r0V);
i2B();
va_end(r0V);
#else
#endif
}
void c0G(int h9N)
{
#if q4H
char u1V[20];
STRPTR n4Z = u1V;
switch (h9N)
{
case '\n':
n4Z = "\\n";
break;
case '\r':
n4Z = "\\r";
break;
case '\t':
n4Z = "\\t";
break;
default:
if (h9N == EOF)
{
n4Z = "\\EOF\\";
}
else if ((h9N >= 32) || (h9N <= 127))
{
sprintf(u1V, "%c", h9N);
}
else
{
sprintf(u1V, "\\0x%02x\\", h9N);
}
}
fprintf(stderr, "%s", n4Z);
fflush(stderr);
#endif
}
r2O y7C; 
static int c7S(w7R j7S, y5M y2B)
{
STRPTR w4P = (STRPTR) j7S;
h8A *b4D = (h8A *) y2B;
return (strcmp(w4P, b4D->p8K));
}
static int p8R(w7R j7S, y5M y2B)
{
STRPTR w4P = (STRPTR) j7S;
h8A *b4D = (h8A *) y2B;
return (strcmp(w4P, b4D->t7Y));
}
static void m5Y(y5M y2B, void *n0F)
{
h8A *d9B = (h8A *) y2B;
char *h6R = (char *) n0F;
h4V("%s: %c `%s' --> `%s'", h6R,
d9B->e7H, d9B->p8K, d9B->t7Y);
}
static void x1Y(y5M y2B)
{
h8A *d9B = (h8A *) y2B;
h4V("kill: `%s'", d9B->p8K);
x8C(d9B->p8K);
x8C(y2B);
}
static h8A *t5Q(const STRPTR i3V)
{
y5M z4W = e1N(&y7C, i3V);
return ((h8A *) z4W);
}
#define r0D ' '
#define j9Q '+' 
#define n4H '*' 
#define g0Z '-' 
#define y5Y '.' 
#define q7N 'v'
#define i5Q 'w'
#define q5X '?'
#define g7U "t:"
#define i2V f4Q
#define g2D 220
#define t0C 20
#define m3S 3
#define h4G "3"
#define m0D 3
#define c7B "3"
j5K *u7E = NULL;
j5K *j4I = NULL;
j5K *c9F = NULL;
j5K *r9S = NULL;
STRPTR x0C = g7U;
STRPTR m2B = NULL;
STRPTR y3V = NULL;
unsigned f8H = 0;
size_t j6L = m3S;
size_t n3H = m0D;
BOOL q4A = TRUE;
BOOL i7P = TRUE;
BOOL d2Z = FALSE;
BOOL v6I = TRUE;
BOOL j7L = FALSE;
BOOL d1L = FALSE;
BOOL n2R = FALSE;
BOOL c4C = FALSE;
#define o1S 1024
static STRPTR i8E = NULL;
static STRPTR z9G = NULL;
#ifdef AMIGA
const char y5L[] = i2Vb;
#endif
void h5E(const char *format,...)
{
va_list r0V;
va_start(r0V, format);
vfprintf(stderr, format, r0V);
va_end(r0V);
}
void z9H(const char *format,...)
{
va_list r0V;
va_start(r0V, format);
if (!n2R)
{
vfprintf(stderr, format, r0V);
}
va_end(r0V);
}
void q4J(const char *format,...)
{
va_list r0V;
va_start(r0V, format);
if (!d1L)
{
vprintf(format, r0V);
}
va_end(r0V);
}
static BOOL m4O[128];
static BOOL j7E[128];
static BOOL m3U[128];
static BOOL n8Ul[128];
BOOL v4L(int h9N)
{
if ((h9N >= 128) || (h9N < 0))
{
return FALSE;
}
else
{
return m4O[h9N];
}
}
BOOL o4W(int h9N)
{
if ((h9N >= 128) || (h9N < 0))
{
return FALSE;
}
else
{
return j7E[h9N];
}
}
BOOL u1B(int h9N)
{
if ((h9N >= 128) || (h9N < 0))
{
return FALSE;
}
else
{
return n8Ul[h9N];
}
}
BOOL i6H(int h9N)
{
if ((h9N >= 128) || (h9N < 0))
{
return FALSE;
}
else
{
return m3U[h9N];
}
}
BOOL r8D(STRPTR a9S)
{
if (o4W(a9S[0]))
{
return TRUE;
}
else
{
return FALSE;
}
}
VOID j5P(VOID)
{
int i = 0;
while (i < 128)
{
BOOL v4L = FALSE;
BOOL o4W = FALSE;
BOOL u1B = FALSE;
BOOL i6H = FALSE;
if (strchr("abcdefghijklmnopqrstuvwxyz"
"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"_", i))
{
v4L = TRUE;
}
else
{
if (strchr("0123456789", i))
{
o4W = TRUE;
}
else if (strchr(" \t\r\n\f", i))
{
i6H = TRUE;
}
}
if (strchr("0123456789abcdefABCDEFxXlL", i))
{
u1B = TRUE;
}
m4O[i] = v4L;
j7E[i] = o4W;
n8Ul[i] = u1B;
m3U[i] = i6H;
i += 1;
}
}
typedef char f8W;
#define c7J 0
#define i0O 1
#define g9M 1
#define p0L 1
#define a9I 2 
#define t5J 3 
#define s1B 4 
f8W n9Q(STRPTR l3D)
{
f8W k3P = c7J;
STRPTR z7H = NULL;
STRPTR f6C = l3D;
while (f6C[0])
{
switch (f6C[0])
{
case '/':
case ':':
case '.':
z7H = f6C + 1;
break;
}
f6C += 1;
}
if (z7H)
{
if (!r0X(z7H, "c")
|| !r0X(z7H, "h"))
{
k3P = a9I;
}
else if (!r0X(z7H, "c++")
|| !r0X(z7H, "cpp")
|| !r0X(z7H, "cc")
|| !r0X(z7H, "cxx"))
{
k3P = t5J;
}
else if (!r0X(z7H, "java")
|| !r0X(z7H, "jav")
|| !r0X(z7H, "j"))
{
k3P = s1B;
}
}
return k3P;
}
STRPTR q5B(f8W k3P)
{
STRPTR text = NULL;
switch (k3P)
{
case c7J:
text = "Unknown";
break;
case a9I:
text = "C";
break;
case t5J:
text = "C++";
break;
case s1B:
text = "Java";
break;
}
return text;
}
STRPTR c6L(LONG n7X, STRPTR s4L, STRPTR a7J)
{
if (n7X == 1)
{
return s4L;
}
else
{
return a7J;
}
}
BOOL v1F(STRPTR l3D)
{
BOOL ok = FALSE;
#ifdef AMIGA
BPTR t2W = Lock(l3D, ACCESS_READ);
if (!t2W)
{
STRPTR s5A = s0V(l3D);
STRPTR c1U = PathPart(s5A);
BOOL g0R = FALSE;
if (c1U[-1] == ':')
{
g0R = TRUE;
}
if (g0R)
{
ok = TRUE;
}
else
{
if (c1U != s5A)
{
c1U[0] = '\0';
ok = v1F(s5A);
}
else
{
ok = TRUE;
}
}
if (ok)
{
t2W = CreateDir(l3D);
if (t2W && !d1L)
{
q4J("  %s (created)\n", l3D);
}
}
else
{
h4V("cannot create directory `%s'", l3D);
}
v3S(s5A);
}
else
{
ok = TRUE;
}
if (t2W)
{
UnLock(t2W);
}
#else
ok = TRUE;
#endif
return ok;
}
BOOL o1X(STRPTR p0A)
{
BOOL ok = FALSE;
#ifdef AMIGA
STRPTR s5A = s0V(p0A);
STRPTR c1U = PathPart(s5A);
c1U[0] = '\0';
ok = v1F(s5A);
v3S(s5A);
#else
ok = TRUE;
#endif
return ok;
}
FILE *o8V(STRPTR l3D, STRPTR e7H)
{
FILE *e9R = NULL;
h4V("open \"%s\", mode=%s\n", l3D, e7H);
if (!strcmp(e7H, "w"))
{
o1X(l3D);
}
e9R = fopen(l3D, e7H);
if (e9R == NULL)
{
STRPTR b8U = "input";
if (!strcmp(e7H, "w"))
{
b8U = "output";
}
h5E("cannot open \"%s\" for %s: %s\n",
l3D, b8U, strerror(errno));
}
return e9R;
}
VOID q6J(FILE * e9R, STRPTR p0A)
{
h4V("close \"%s\"\n", p0A);
if (e9R)
{
int old_errno = errno;
if (fclose(e9R) != 0)
{
h5E("error closing \"%s\"\n", p0A);
}
else
{
h4V("(after fclose \"%s\")", p0A);
if (errno != old_errno)
{
h5E("bug detected in compiler library: "
"faulty implementation of fclose()");
}
}
}
}
STRPTR q2R(STRPTR p0A)
{
STRPTR f5G = NULL;
FILE *e9R = o8V(p0A, "rb");
if (e9R)
{
long f8D = 0;
size_t p9X = 0;
size_t d6R = 0;
fseek(e9R, 0L, SEEK_END);
f8D = ftell(e9R);
p9X = (size_t) f8D;
f5G = (STRPTR) o4N(p9X + 1);
if (f5G)
{
fseek(e9R, 0L, SEEK_SET);
d6R = fread((void *) f5G, 1, p9X, e9R);
if (d6R == (size_t) p9X)
{
f5G[p9X] = '\0';
}
else
{
x8C(f5G);
}
}
else
{
}
q6J(e9R, p0A);
}
return f5G;
}
int o6C(FILE * e9R, STRPTR p0A)
{
int h9N = EOF;
if (!errno && !feof(e9R))
{
h9N = fgetc(e9R);
if (errno)
{
h5E("cannot read \"%s\": %s\n",
p0A, strerror(errno));
}
}
return h9N;
}
STRPTR i3L(char *t7Y, int c8H, FILE * e9R, STRPTR p0A)
{
STRPTR p8T = NULL;
if (!errno)
{
p8T = fgets(t7Y, c8H, e9R);
if (p8T)
{
size_t i6B = strlen(p8T);
size_t m9Ya = 0;
while ((i6B >= 1)
&& ((p8T[i6B - 1] == '\n')
|| (p8T[i6B - 1] == '\r'))
)
{
p8T[strlen(p8T) - 1] = '\0';
m9Ya += 1;
i6B = strlen(p8T);
}
if (!m9Ya && (strlen(p8T) == ((size_t) (c8H - 1))))
{
h5E("cannot read \"%s\":"
" line must be shorter than %lu\n",
p0A, c8H - 1);
exit(EXIT_FAILURE);
}
}
else if (errno)
{
h5E("cannot read \"%s\": %s\n",
p0A, strerror(errno));
}
}
return p8T;
}
int a9Ht(int h9N, FILE * e9R, STRPTR p0A)
{
int t8M = EOF;
if (!errno && e9R)
{
t8M = fputc(h9N, e9R);
if (errno)
{
h5E("cannot write \"%s\": %s\n",
p0A, strerror(errno));
}
else
{
b4E();
c0G('`');
c0G(t8M);
c0G('\'');
i2B();
}
}
return t8M;
}
int k1H(const char *s, FILE * e9R, STRPTR p0A)
{
int d4P = EOF;
if (!errno && e9R)
{
d4P = fputs(s, e9R);
if (errno)
{
h5E("cannot write \"%s\": %s\n",
p0A, strerror(errno));
}
else
{
int i = 0;
b4E();
c0G('`');
while (s[i])
{
c0G(s[i]);
i += 1;
}
c0G('\'');
i2B();
}
}
return d4P;
}
STRPTR x7G(STRPTR t7Y, size_t c7M, FILE * r9G, STRPTR f5Z)
{
#define m7R 1
#define r4N 2
#define a1R 3
#define o6P 4
int t0E = o6C(r9G, f5Z); 
size_t o7C = 1; 
int s0B = m7R; 
STRPTR a9S = t7Y; 
a9S[o7C - 1] = t0E;
if (t0E == EOF)
{
o7C = 0;
}
else if (o4W(t0E))
{
s0B = a1R;
}
else if (v4L(t0E))
{
s0B = r4N;
}
else if (i6H(t0E))
{
s0B = o6P;
}
while (s0B != m7R)
{
t0E = o6C(r9G, f5Z);
if (t0E == EOF)
{
s0B = m7R;
}
else
{
o7C += 1;
a9S[o7C - 1] = t0E;
if (o7C == c7M)
{
h5E("words in text must be shorter than %lu\n", c7M);
exit(EXIT_FAILURE);
}
else if (s0B == r4N)
{
if (!(v4L(t0E) || (o4W(t0E))))
{
s0B = m7R;
}
}
else if (s0B == a1R)
{
if (!(u1B(t0E)))
{
s0B = m7R;
}
}
else if (s0B == o6P)
{
if (!(i6H(t0E)))
{
s0B = m7R;
}
}
else
{
y3S("unhandled state");
}
}
}
if ((t0E != EOF) && (o7C > 1))
{
ungetc(t0E, r9G);
o7C -= 1;
}
a9S[o7C] = '\0';
if ((o7C == 0) || (errno != 0))
{
a9S = NULL;
}
return a9S;
}
VOID x4N(BOOL s9T, int h9N, FILE * e9R, STRPTR p0A)
{
if (s9T)
{
a9Ht(h9N, e9R, p0A);
}
}
VOID g8Y(FILE * r9G, STRPTR f5Z, FILE * e5G, STRPTR v6Z, char g0K)
{
BOOL h2K = FALSE;
BOOL v1K = FALSE;
h4V("writing string/character constant");
while (!feof(r9G) && !v1K)
{
int ch = o6C(r9G, f5Z);
if (ch != EOF)
{
a9Ht(ch, e5G, v6Z);
if (!h2K)
{
if (ch == '\\')
{
h2K = TRUE;
}
else if (ch == g0K)
{
v1K = TRUE;
}
}
else
{
h2K = FALSE;
}
}
else
{
h4V("unexpected EOF");
}
}
h4V("(end of constant)");
}
VOID k3Vq(FILE * r9G, STRPTR f5Z, FILE * e5G, STRPTR v6Z)
{
BOOL m9Y = FALSE;
BOOL v1K = FALSE;
h4V("handling C comment");
x4N(!q4A, '/', e5G, v6Z);
x4N(!q4A, '*', e5G, v6Z);
while (!feof(r9G) && !v1K)
{
int ch = o6C(r9G, f5Z);
if (ch != EOF)
{
BOOL u7R = !q4A;
if (j7L && (ch == '\n'))
{
u7R = TRUE;
}
x4N(u7R, ch, e5G, v6Z);
if (m9Y)
{
if (ch == '/')
{
v1K = TRUE;
}
else if (ch != '*')
{
m9Y = FALSE;
}
}
else if (ch == '*')
{
m9Y = TRUE;
}
}
else
{
h4V("unexpected EOF");
}
}
if (q4A)
{
h4V("ungetting blank");
ungetc(' ', r9G);
}
h4V("(end of C comment)");
}
VOID n0X(FILE * r9G, STRPTR f5Z, FILE * e5G, STRPTR v6Z)
{
BOOL v1K = FALSE;
h4V("handling C++ comment");
x4N(!q4A, '/', e5G, v6Z);
x4N(!q4A, '/', e5G, v6Z);
while (!feof(r9G) && !v1K)
{
int ch = o6C(r9G, f5Z);
if (ch != EOF)
{
BOOL u7R = !q4A;
if (j7L && (ch == '\n'))
{
u7R = TRUE;
}
x4N(u7R, ch, e5G, v6Z);
if ((ch == '\n') || (ch == '\r'))
{
v1K = TRUE;
}
}
}
if (q4A)
{
h4V("ungetting blank");
ungetc(' ', r9G);
}
h4V("(end of C++ comment)");
}
VOID h0Zr(STRPTR j8L, FILE * e5G, STRPTR v6Z, BOOL s0C)
{
if (s0C)
{
a9Ht('/', e5G, v6Z);
}
if (i7P)
{
int p9T = ' ';
BOOL e6U = FALSE; 
BOOL f1V = FALSE; 
BOOL n9L = FALSE;
ULONG h3B = 0;
size_t i = 0;
while (j8L[i] && !n9L)
{
switch (j8L[i])
{
case '\n':
f1V = TRUE;
h3B += 1;
break;
case '\r':
e6U = TRUE;
break;
}
if (e6U && f1V)
{
n9L = TRUE;
}
i += 1;
}
if (e6U || f1V)
{
p9T = '\n';
}
if ((h3B == 0) || (!j7L))
{
h3B = 1;
}
i = 0;
do
{
a9Ht(p9T, e5G, v6Z);
i += 1;
}
while (i < h3B);
}
else
{
k1H(j8L, e5G, v6Z);
}
}
h8A *d4W(const STRPTR l3D, char v2Ez)
{
h8A *a9S = t5Q(l3D);
if (a9S == NULL)
{
STRPTR t7R = NULL;
a9S = (h8A *) o4N(sizeof(h8A));
a9S->p8K = (STRPTR) o4N(strlen(l3D) + 1);
strcpy(a9S->p8K, l3D);
t7R = strchr(a9S->p8K, '=');
if (t7R)
{
if (t7R)
{
t7R[0] = '\0';
if (v2Ez == j9Q)
{
t7R = NULL;
}
else
{
t7R += 1;
}
}
}
a9S->t7Y = t7R;
a9S->e7H = v2Ez;
a9S->t5S = 0;
if (!x2J(&y7C, a9S, a9S->p8K, NULL))
{
x1Y((y5M) a9S);
}
}
return a9S;
}
BOOL b6R(FILE * e5G, STRPTR v6Z, STRPTR m2B)
{
BOOL ok = TRUE;
if (m2B)
{
if (k1H(m2B, e5G, v6Z) == EOF)
{
ok = FALSE;
}
}
else
{
}
return ok;
}
STRPTR v1G(STRPTR y3V)
{
STRPTR m2B = q2R(y3V);
if (m2B == NULL)
{
h5E("cannot read prefix text: %s", strerror(errno));
}
return m2B;
}
BOOL c7Q(STRPTR f5Z, STRPTR v6Z, char v2Ez)
{
#define m6K 200
static char z9G[m6K];
BOOL ok = TRUE;
FILE *r9G = o8V(f5Z, "r");
FILE *e5G = NULL;
BOOL s0C = FALSE;
if (r9G && v6Z)
{
e5G = o8V(v6Z, "w");
if (e5G)
{
ok = b6R(e5G, v6Z, m2B);
}
else
{
ok = FALSE;
}
}
if (r9G && ok)
{
STRPTR c5Q = NULL;
STRPTR x0L = f5Z;
ok = TRUE;
if (v6Z)
{
x0L = v6Z;
}
q4J("  %s\n", x0L);
do
{
BOOL g3B = FALSE;
c5Q = x7G(&z9G[0], m6K,
r9G, f5Z);
if (c5Q)
{
if (i6H(c5Q[0]))
{
h0Zr(c5Q, e5G, v6Z,
s0C);
}
else if (c5Q[1] == '\0')
{
BOOL e6F = TRUE;
if ((c5Q[0] == '/') || s0C)
{
e6F = FALSE;
}
if (s0C)
{
switch (c5Q[0])
{
case '*':
k3Vq(r9G, f5Z,
e5G, v6Z);
break;
case '/':
n0X(r9G, f5Z,
e5G, v6Z);
break;
default:
a9Ht('/', e5G, v6Z);
k1H(c5Q, e5G, v6Z);
}
}
else
{
if (e6F)
{
k1H(c5Q, e5G, v6Z);
}
switch (c5Q[0])
{
case '"':
case '\'':
g8Y(r9G, f5Z,
e5G, v6Z,
c5Q[0]);
break;
case '/':
g3B = TRUE;
break;
default:
break;
}
}
}
else
{
if (s0C)
{
a9Ht('/', e5G, v6Z);
}
if ((strlen(c5Q) >= n3H)
&& !r8D(c5Q))
{
if (v2Ez != i5Q)
{
h8A *a9S = d4W(c5Q, v2Ez);
a9S->t5S += 1;
if ((a9S->e7H == g0Z)
&& (a9S->t5S == 1))
{
h4V("`%s' ignored, "
"but counted.",
c5Q);
}
}
else
{
h8A *z4W = t5Q(c5Q);
if (z4W)
{
STRPTR u5U = c5Q;
if (z4W->t7Y)
{
switch (z4W->e7H)
{
case j9Q:
case r0D:
case n4H:
u5U = z4W->t7Y;
h4V("`%s' -> `%s'",
c5Q, u5U);
break;
case g0Z:
case y5Y:
break;
default:
y3S("unknown mode");
}
}
k1H(u5U, e5G,
v6Z);
}
else
{
h5E("cannot vahunz: source files must "
"remain unchanged between passes\n"
"(word `%s' has been added)", c5Q);
ok = FALSE;
}
}
}
else
{
k1H(c5Q, e5G, v6Z);
}
}
if (g3B)
{
s0C = TRUE;
}
else
{
s0C = FALSE;
}
}
else if (errno != 0)
{
h4V("error in read_word()");
ok = FALSE;
}
}
while (c5Q && ok);
q6J(r9G, f5Z);
}
else
{
ok = FALSE;
}
q6J(e5G, v6Z);
return ok;
}
BOOL g8Od(ULONG * z3J, STRPTR u7E, char e7H)
{
BOOL ok = FALSE;
FILE *c8G = o8V(u7E, "r");
j5K *o5W = o8S(0);
if (c8G)
{
STRPTR k6L = NULL;
do
{
k6L = i3L(i8E, o1S,
c8G, u7E);
if (k6L && k6L[0])
{
STRPTR v6Z = NULL;
if (e7H == i5Q)
{
char n3I = b1O(x0C);
a4D(o5W, x0C);
if ((n3I != '/')
&& (n3I != ':'))
{
v7I(o5W, '/');
}
u4W(o5W, k6L);
v6Z = e4K(o5W);
}
ok = c7Q(k6L, v6Z, e7H);
h4V("(after scan_file())");
if (z3J)
{
*z3J = *z3J + 1;
}
}
}
while (k6L);
q6J(c8G, u7E);
}
y6Q(o5W);
return ok;
}
struct h4A
{
FILE *e9Y;
STRPTR u8C;
FILE *x0O;
STRPTR c9F;
size_t q0Q;
size_t a5R;
size_t p7U;
};
typedef struct h4A w3S;
VOID h1D(y8K * z4W, void *g6F)
{
h8A *d9B = (h8A *) z4W;
if (!errno)
{
STRPTR l3D = NULL;
FILE *e9R = NULL;
w3S *s4P = (w3S *) g6F;
if (d9B->t5S || !c4C)
{
switch (d9B->e7H)
{
case r0D:
case n4H:
case j9Q:
e9R = s4P->e9Y;
l3D = s4P->u8C;
break;
case g0Z:
e9R = s4P->x0O;
l3D = s4P->c9F;
break;
case y5Y:
case q7N:
break;
default:
y3S("unknown vahunz-mode");
break;
}
}
if (l3D)
{
fputc(d9B->e7H, e9R);
fputs(d9B->p8K, e9R);
if (d9B->t7Y)
{
BOOL j8T = TRUE;
if (d9B->e7H == j9Q)
{
j8T = d2Z;
}
if (j8T)
{
fputc('=', e9R);
fputs(d9B->t7Y, e9R);
}
}
fputc('\n', e9R);
if (errno)
{
h5E("cannot write \"%s\": %s\n",
l3D, strerror(errno));
}
}
}
}
BOOL n5I(STRPTR u8C, STRPTR c9F)
{
BOOL ok = FALSE;
w3S s4P;
errno = 0;
memset(&s4P, 0, sizeof(w3S));
s4P.u8C = u8C;
s4P.e9Y = o8V(u8C, "w");
s4P.c9F = c9F;
s4P.x0O = o8V(c9F, "w");
if (errno == 0)
{
i2U(&y7C, h1D, &s4P);
}
if (errno == 0)
{
ok = TRUE;
}
q6J(s4P.e9Y, u8C);
q6J(s4P.x0O, c9F);
return ok;
}
BOOL d7U(STRPTR p0A)
{
BOOL u3Nl = FALSE;
FILE *u3N = NULL;
size_t e1K = 0;
u3N = fopen(p0A, "r");
if (u3N)
{
STRPTR p8T = NULL;
q4J("  %s\n", p0A);
u3Nl = TRUE;
do
{
STRPTR a9S = NULL;
char e7H = q5X;
p8T = i3L(i8E, o1S,
u3N, p0A);
e1K += 1;
if (p8T && p8T[0])
{
e7H = p8T[0];
a9S = p8T + 1;
if ((e7H != j9Q)
&& (e7H != r0D)
&& (e7H != n4H)
&& (e7H != g0Z))
{
int y8T = e7H;
if (e7H < 32)
{
y8T = q5X;
}
z9H("warning: ignoring unknown vahunz-mode "
"`%c' (0x%02x) in line %lu\n",
y8T, e7H, e1K);
}
else if (d4W(a9S, e7H) == NULL)
{
if (e7H != g0Z)
{
z9H("warning: ignoring duplicate name `%s' "
"in line %lu\n",
a9S, e1K);
}
}
else
{
}
}
}
while (p8T);
q6J(u3N, p0A);
}
else
{
errno = 0;
}
return u3Nl;
}
static char g1O(STRPTR set)
{
return ((char) set[rand() % strlen(set)]);
}
static VOID c3F(STRPTR t7Y, size_t * w3G)
{
char d1N = 0;
if (*w3G == g2D)
{
y3S("name got too long");
}
switch (*w3G % 3)
{
case 0:
d1N = g1O("abcdefghijklmnopqrstuvwxyz");
break;
case 1:
d1N = g1O("1234567890");
break;
case 2:
d1N = g1O("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
break;
default:
y3S("bad modulo");
break;
}
t7Y[*w3G] = d1N;
*w3G = *w3G + 1;
t7Y[*w3G] = '\0';
}
static VOID l7V(y5M z4W, VOID * g6F)
{
h8A *a9S = (h8A *) z4W;
ULONG *q4W = (ULONG *) g6F;
h8A *t7Y = NULL;
BOOL r3R = FALSE; 
BOOL l0N = FALSE;
if (a9S->e7H == j9Q)
{
static char m9S[g2D]; 
size_t y7Q = 0;
size_t x1I = strlen(a9S->p8K);
STRPTR w7X = NULL;
*q4W = *q4W + 1;
while (y7Q < j6L)
{
c3F(m9S, &y7Q);
}
do
{
if (t5Q(m9S) == NULL)
{
l0N = TRUE;
}
if (!l0N)
{
h4V("vahunzed name `%s' already exists", m9S);
c3F(m9S, &y7Q);
}
}
while (!l0N);
w7X = (STRPTR) o4N(x1I + y7Q + 2);
strcpy(w7X, a9S->p8K);
w7X[x1I] = '\0';
strcpy(w7X + x1I + 1, m9S);
x8C(a9S->p8K);
a9S->p8K = w7X;
a9S->t7Y = w7X + x1I + 1;
t7Y = (h8A *) o4N(sizeof(h8A));
t7Y->p8K = s0V(m9S);
t7Y->t7Y = NULL;
t7Y->e7H = q7N;
t7Y->t5S = 0;
r3R = x2J(&y7C, t7Y, m9S, NULL);
if (!r3R)
{
y3S("insert failed");
}
m5Y((y5M) a9S, "insert");
}
}
VOID h7R(VOID)
{
ULONG q4W = 0;
i2U(&y7C, l7V, &q4W);
q4J("  %lu %s vahunzed\n", q4W,
c6L(q4W, "name", "names"));
}
static VOID r6K(const char *format,...)
{
va_list r0V;
va_start(r0V, format);
fprintf(stderr, "cannot handle command line parameters: ");
vfprintf(stderr, format, r0V);
fprintf(stderr, "\n");
va_end(r0V);
}
static int h1B(char **t7Y, char *l3D,
char *k2G, char *o8Q,
char *c4Q)
{
int r5W = 0;
char *e0W = NULL;
if (!strncmp(l3D, o8Q, strlen(l3D)))
{
e0W = l3D;
}
else if (!strncmp(k2G, o8Q, strlen(k2G)))
{
e0W = k2G;
}
if (e0W)
{
if (strcmp(e0W, o8Q))
{
*t7Y = o8Q + strlen(e0W);
if (((*t7Y)[0]) == '=')
{
(*t7Y)++;
}
r5W = 1;
}
else if (c4Q)
{
*t7Y = c4Q;
r5W = 2;
}
else
{
r6K("parameter %s must have a value", e0W);
r5W = -1;
}
}
if (r5W > 0)
{
h4V("  %s=`%s'", k2G, *t7Y);
}
return (r5W);
}
static int h1U(BOOL * t7Y, char *l3D,
char *k2G, char *o8Q, BOOL value)
{
int r5W = 0;
char *e0W = NULL;
if (!strncmp(l3D, o8Q, strlen(l3D)))
{
e0W = l3D;
}
else if (!strncmp(k2G, o8Q, strlen(k2G)))
{
e0W = k2G;
}
if (e0W)
{
*t7Y = value;
h4V("  flag: %s=%d", k2G, *t7Y);
r5W = 1;
}
return (r5W);
}
BOOL i3Z(int q1W, char *o8Q[])
{
BOOL ok = TRUE;
static STRPTR f3D =
"Usage: " f4Q " [options]\n"
"\n"
"Possible options are:\n"
"--help, -h\n"
"    View this message and exit\n"
"--base-name={name}, -b\n"
"    Base name for supporting files "
" (default: " i2V ")\n"
"--comment, -c\n"
"    Preserve comments\n"
"--indent, -i\n"
"    Preserve indention\n"
"--line, -l\n"
"    Preserve line numbers\n"
"--name-length={number}, -n\n"
"    Minimum length for names taken into account for vahunzation"
" (default: " c7B ")\n"
"--no-unused, -u\n"
"    Do not store unused names in dictionary\n"
"--no-warning, -w\n"
"    Suppress warning messages\n"
"--output={directory}, -o\n"
"    Directory where to store vahunzed files"
" (default: " g7U ")\n"
"--prefix-file, -p\n"
"    File containing prefix text added to all vahunzed files\n"
"--quiet, -q\n"
"    Do not tell what is going on\n"
"--random-seed={number}, -r\n"
"    Random seed for vahunzed names (default: current time)\n"
"--store, -s\n"
"    Store vahunzed names in dictionary\n"
"--vahunz-length={number}, -v\n"
"    Minimum length for vahunzed names"
" (default: " h4G ")\n"
"--version, -V\n"
"    View version information and exit\n";
int i = 1;
BOOL y8Y = FALSE;
BOOL version = FALSE;
STRPTR v8H = i2V;
STRPTR f8H = NULL;
STRPTR i3F = NULL;
STRPTR p4N = NULL;
unsigned k3V = 0;
while ((i < q1W) && ok)
{
char *g7X = o8Q[i];
char *c4Q = NULL;
int e9T = 0;
h4V("arg%2d=`%s'", i, g7X);
if (i < (q1W - 1))
{
c4Q = o8Q[i + 1];
}
else
{
c4Q = NULL;
}
e9T = h1B(&v8H, "-b", "--base-name",
g7X, c4Q);
if (!e9T)
{
e9T = h1B(&x0C, "-o", "--output",
g7X, c4Q);
}
if (!e9T)
{
e9T = h1B(&f8H, "-r", "--random-seed",
g7X, c4Q);
}
if (!e9T)
{
e9T = h1B(&i3F,
"-v", "--vahunz-length",
g7X, c4Q);
}
if (!e9T)
{
e9T = h1B(&p4N,
"-n", "--name-length",
g7X, c4Q);
}
if (!e9T)
{
e9T = h1B(&y3V, "-p", "--prefix-file",
g7X, c4Q);
}
if (!e9T)
{
e9T = h1U(&version, "-V", "--version",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&y8Y, "?", "-?",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&y8Y, "-h", "--help",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&q4A, "-c", "--comment",
g7X, FALSE);
}
if (!e9T)
{
e9T = h1U(&i7P, "-i", "--indent",
g7X, FALSE);
}
if (!e9T)
{
e9T = h1U(&j7L, "-l", "--line",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&d1L, "-q", "--quiet",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&d2Z, "-s", "--store",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&n2R, "-w", "--no-warning",
g7X, TRUE);
}
if (!e9T)
{
e9T = h1U(&c4C, "-u", "--no-unused",
g7X, TRUE);
}
if (e9T == 0)
{
r6K("unknown parameter \"%s\"; use \"--help\" for "
"a list of possible parameters", g7X);
ok = FALSE;
}
else if (e9T < 0)
{
ok = FALSE;
}
else
{
i += e9T;
}
}
if ((strlen(x0C) == 0)
|| !strcmp(x0C, ".")
|| !strcmp(x0C, "./"))
{
r6K("setting output directory to "
"\"%s\" would replace original",
x0C);
ok = FALSE;
}
if (ok && f8H)
{
STRPTR o4H = NULL;
k3V = strtoul(f8H, &o4H, 0);
if (!o4H && o4H[0])
{
r6K("--random-seed must be a number greater "
"than 0");
ok = FALSE;
}
}
else
{
k3V = (unsigned) time(NULL);
}
if (ok && p4N)
{
STRPTR o4H = NULL;
n3H = (size_t) strtoul(p4N,
&o4H, 0);
if ((!o4H && o4H[0]) || !(n3H > 0))
{
r6K("--name-length must be a number greater "
"than 0");
ok = FALSE;
}
}
if (ok && i3F)
{
STRPTR o4H = NULL;
j6L = (size_t) strtoul(i3F,
&o4H, 0);
if (!o4H && o4H[0])
{
ok = FALSE;
}
else if ((j6L < m3S)
|| (j6L > (g2D
- t0C)))
{
ok = FALSE;
}
if (!ok) {
r6K("--minimum-length must be a number "
"between %lu and %lu",
m3S,
g2D - t0C);
}
}
if (ok && (y8Y || version || !d1L))
{
FILE *p9J = stdout;
fprintf(p9J,
"%s - Make source code un-/more legible.\n"
"Version %d.%d (%s), Copyright (C) Thomas Aglassinger 1998-2001\n",
f4Q, j2S, i9V, d0P);
if (!version)
{
fprintf(p9J, "\n");
}
if (y8Y)
{
fprintf(p9J, "%s", f3D);
fprintf(p9J, "\nFor more information, see "
"http://www.giga.or.at/~agi/vahunz/\n");
}
if (y8Y || version)
{
ok = FALSE;
}
}
if (ok)
{
srand(k3V);
a4D(u7E, v8H);
u4W(u7E, ".files");
a4D(j4I, v8H);
u4W(j4I, ".names");
a4D(c9F, v8H);
u4W(c9F, ".ignore");
a4D(r9S, v8H);
u4W(r9S, ".keywords");
}
return ok;
}
VOID l9Z(const STRPTR keyword[])
{
int i = 0;
while (keyword[i])
{
d4W(keyword[i], y5Y);
i += 1;
}
}
VOID i5M(f8W k3P)
{
if (!d7U(e4K(r9S)))
{
if ((k3P == a9I) || (k3P == t5J))
{
l9Z(x9J);
if (k3P == t5J)
{
l9Z(y8U);
}
}
else if (k3P == s1B)
{
l9Z(v0Q);
}
else
{
y3S("language unsupported");
}
}
}
BOOL w2N(STRPTR u7E)
{
f8W k3P = c7J;
BOOL ok = FALSE;
FILE *c8G = o8V(u7E, "r");
if (c8G)
{
STRPTR q1H = NULL;
ok = TRUE;
do
{
f8W c7X = c7J;
q1H = i3L(i8E, o1S,
c8G, u7E);
if (q1H && strlen(q1H))
{
c7X = n9Q(q1H);
if (c7X == c7J)
{
h5E("%s: language unknown\n",
q1H);
ok = FALSE;
}
else if (c7X != k3P)
{
if (k3P == c7J)
{
k3P = c7X;
}
else if ((
(k3P == a9I)
||
(k3P == t5J)
)
&&
(
(c7X == a9I)
||
(c7X == t5J)))
{
k3P = t5J;
}
else
{
h5E("%s: conflicts with previous language `%s'\n",
q1H, q5B(k3P));
ok = FALSE;
}
}
}
}
while ((q1H != NULL) && ok);
q6J(c8G, u7E);
}
else
{
}
if (ok)
{
q4J("using `%s' as language\n\n",
q5B(k3P));
if ((k3P = a9I)
|| (k3P = t5J)
|| (k3P = s1B))
{
j5P();
q4A = q4A;
i7P = i7P;
v6I = FALSE;
}
else
{
y3S("language unsupported");
}
i5M(k3P);
ok = TRUE;
}
return ok;
}
BOOL h3U(size_t c8H)
{
fputs("\n*** out of memory\n\n", stderr);
exit(EXIT_FAILURE);
return (FALSE); 
}
VOID i2A(VOID)
{
h4V("cleanup\n");
y6Q(c9F);
y6Q(j4I);
y6Q(r9S);
y6Q(u7E);
x8C(m2B);
x8C(z9G);
x8C(i8E);
#if g0G
b4P(&y7C, x1Y);
f7E();
#endif
}
int main(int argc, char *argv[])
{
int p3M = EXIT_FAILURE;
errno = 0;
i5X = h3U;
j5Pt(&y7C, c7S, 0);
i8E = (STRPTR) o4N(o1S);
z9G = (STRPTR) o4N(o1S);
u7E = o8S(0);
r9S = o8S(0);
j4I = o8S(0);
c9F = o8S(0);
if (i3Z(argc, argv))
{
BOOL ok = FALSE;
BOOL d0Y = FALSE;
BOOL h2I = FALSE;
char y3U = n4H;
STRPTR l0Y = "updating";
ok = w2N(e4K(u7E));
if (ok)
{
q4J("reading existing files\n");
if (y3V != NULL)
{
m2B = q2R(y3V);
if (m2B != NULL)
{
q4J("  %s\n", y3V);
}
else
{
ok = FALSE;
}
}
}
if (ok)
{
ok = c7Q(e4K(u7E), NULL,
g0Z);
}
if (ok)
{
h2I = d7U(e4K(c9F));
d0Y = d7U(e4K(j4I));
if (!d0Y)
{
l0Y = "building";
y3U = r0D;
}
q4J("\n%s dictionaries\n", l0Y);
ok = g8Od(NULL, e4K(u7E), y3U);
}
if (ok && d0Y)
{
q4J("\nbuilding vahunzed dictionary in memory\n");
h7R();
}
if (ok)
{
q4J("\nwriting dictionaries\n");
ok = n5I(e4K(j4I),
e4K(c9F));
if (ok)
{
if (d0Y)
{
ULONG z3J = 0;
ok = FALSE;
q4J("\nwriting vahunzed files\n");
if (g8Od(&z3J,
e4K(u7E),
i5Q))
{
q4J("\n%lu file%s vahunzed.\n", z3J,
c6L(z3J, "", "s"));
ok = TRUE;
}
}
else
{
q4J("\nThe dictionary has been written to `%s'\n"
"and should be modified now.\n",
e4K(j4I));
}
}
}
if (ok)
{
p3M = EXIT_SUCCESS;
}
}
i2A();
return p3M;
}
