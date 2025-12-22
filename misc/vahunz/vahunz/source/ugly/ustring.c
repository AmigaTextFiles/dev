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
#include <errno.h>
#include "utypes.h"
#include "umemory.h"
#define i2K
#include "ustring.h"
int b1O(STRPTR s)
{
size_t b1B = strlen(s);
int ch = 0;
if (b1B)
{
ch = s[b1B - 1];
}
else
{
ch = 0;
}
return ch;
}
STRPTR v3N(t8B k0Q, STRPTR e9R, ULONG p8T)
{
STRPTR t7H = NULL;
if (k0Q)
{
#if v2E
t7H = (STRPTR) e3L(strlen(k0Q) + 1, e9R, p8T);
#else
t7H = (STRPTR) o4N(strlen(k0Q) + 1);
#endif
if (t7H) 
strcpy(t7H, k0Q); 
}
return (t7H); 
}
STRPTR c3X(STRPTR s)
{
STRPTR e3N = s;
if (s)
for (; *s != '\0'; s++)
*s = toupper(*s);
return e3N;
}
int r0X(t8B s1, t8B s2)
{
#define c2J 1
#if !c2J
int b7N; 
#endif
unsigned char c1, c2; 
size_t i = 0; 
do
{
c1 = toupper(s1[i]);
c2 = toupper(s2[i]);
i++;
}
while (c1 && c2 && (c1 == c2));
#if c2J
return (c2 - c1);
#else
if (c1 < c2)
b7N = -1; 
else if (c1 > c2)
b7N = +1; 
else
b7N = 0; 
return (b7N); 
#endif
}
int s8K(t8B s1, t8B s2, size_t n)
{
int b7N; 
unsigned char c1, c2; 
size_t i = 0; 
do
{
c1 = toupper(s1[i]);
c2 = toupper(s2[i]);
i++;
}
while (c1 && c2 && (c1 == c2) && (i < n));
if (c1 < c2)
b7N = -1; 
else if (c1 > c2)
b7N = +1; 
else
b7N = 0; 
return (b7N); 
}
STRPTR f4F(t8B s1, t8B s2)
{
const char *c1;
const char *c2;
do
{
c1 = s1;
c2 = s2;
while (*c1 != '\0' && (toupper(c1[0]) == toupper(c2[0])))
{
c1++;
c2++;
}
if (*c2 == '\0')
{
return (char *) s1;
}
}
while (*s1++ != '\0');
return NULL;
}
void n4Y(STRPTR s, STRPTR e9R, ULONG p8T)
{
#if v2E
t2B(s, e9R, p8T);
#else
x8C(s);
#endif
}
void j6C(STRPTR * k0Q, t8B t7H, STRPTR e9R, ULONG p8T)
{
#if v2E
n4Y(*k0Q, e9R, p8T); 
*k0Q = v3N(t7H, e9R, p8T); 
#else
x8C(*k0Q); 
*k0Q = s0V(t7H); 
#endif
}
STRPTR t7V(const char ch)
{
static char j2T[2]; 
j2T[0] = ch;
j2T[1] = '\0';
return j2T;
}
STRPTR m6X(t8B str, t8B set)
{
size_t i;
STRPTR result = NULL;
if (str)
{
i = strlen(str) - 1;
while ((i) && (strchr(set, str[i]) == NULL))
i--;
if (strchr(set, str[i]))
result = (STRPTR) & (str[i]);
}
return result;
}
BOOL w8T(STRPTR s, LONG * num)
{
BOOL t8L = FALSE;
errno = 0;
*num = strtol(s, NULL, 10);
if (errno == 0)
{
t8L = TRUE;
}
return t8L;
}
STRPTR k2T(LONG num)
{
static char g6J[10]; 
STRPTR s6T = NULL;
if (sprintf(g6J, "%d", (int) num))
{
s6T = g6J;
}
return s6T;
}
LONG a9B(STRPTR str, STRPTR set, char c0Z, BYTE d1A)
{
STRPTR s = s0V(set);
LONG r5W = 0;
if (s)
{
STRPTR z1W = strtok(s, t7V(c0Z));
LONG count = 1;
while (!r5W && z1W)
{
if (d1A & k3S)
{
if (!r0X(str, z1W))
r5W = count;
}
else if (!strcmp(str, z1W))
r5W = count;
count++;
z1W = strtok(NULL, t7V(c0Z));
}
v3S(s);
}
else
r5W = -1;
return (r5W);
}
