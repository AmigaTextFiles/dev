/*
 * Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
 * Written by Steve Byrne.
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 1, or (at your option) any later 
 * version.  GNU Smalltalk is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General 
 * Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
 */


/* Define this on machines in which the most significant byte of a long
 * integer has the lowest address, remove it for machines on which the
 * least significant byte of a long integer occurs at the lowest
 * address.
 */
#define BIG_ENDIAN

#define BSD_SIGNALS
#define UNIX
#define BSD
#ifndef FOR_MAKE

/* This is the return type of routines that are declarable as signal handlers.
 * may be void for some implementations
 */
typedef void	signalType;

/* use gcc's builtin alloca */
#define alloca 		__builtin_alloca

#include <stdlib.h>
#include <stddef.h>
#include <string.h>
/*#include <unixlib.h>*/
#include <stdio.h>

/* use superOptimized bcopy() instead of memcpy() */
#define memcpy(to, from, n)	bcopy((from), (to), (n))

#endif /* FOR_MAKE */
