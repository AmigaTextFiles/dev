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
#ifndef q4F
#define q4F
#include "udebug.h"
#ifdef t5Z 
#include <exec/types.h>
#else
#ifndef APTR_TYPEDEF
#define APTR_TYPEDEF
typedef void *APTR; 
#endif
typedef long LONG; 
typedef unsigned long ULONG; 
typedef short WORD; 
typedef unsigned short UWORD; 
#if __STDC__
typedef signed char BYTE; 
#else
typedef char BYTE; 
#endif
typedef unsigned char UBYTE; 
#if 1
typedef char *STRPTR; 
#else
#if defined(__cplusplus) || defined(RISCOS)
typedef char *STRPTR; 
#else
typedef unsigned char *STRPTR; 
#endif
#endif
typedef void VOID;
#ifndef RISCOS
typedef short BOOL;
typedef unsigned char TEXT;
#else
typedef int BOOL;
typedef char TEXT;
#endif
#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif
#ifndef NULL
#define NULL 0L
#endif
#define BYTEMASK 0xFF
#define p2C 0xFFFF
#endif 
#if 1
typedef const char *t8B; 
typedef char d6X; 
typedef char CHAR; 
#else
#ifndef RISCOS
typedef const unsigned char *t8B; 
typedef unsigned char d6X; 
typedef unsigned char CHAR; 
#else
typedef const char *t8B; 
typedef char d6X; 
typedef char CHAR; 
#endif
#endif
typedef void *g6V; 
typedef int x2E(g6V y8W, g6V v7O);
typedef void m0B(g6V data);
#endif 
