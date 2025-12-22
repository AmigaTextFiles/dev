/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef	M68K_H
#define	M68K_H

#if defined(__mc68020__) && !defined(NOASM)
# define  LZWS
# include "LZW5b.h"
#endif								/* __mc68020__ */

#if defined(BASE_REGISTER) && !defined(NOASM)
# define	__memBase	register struct memory *bspMem __asm__ ("a6")
#endif								/* BASE_REGISTER */

#if defined(INLINE_BIGENDIAN_M68K) && !defined(NOASM)
#if defined(__STDC__) || defined(__cplusplus)
#define _DEFUN(name, args1, args2) name ( args2 )
#define _AND ,
#define _CONST const
#else
#define _DEFUN(name, args1, args2) name args1 args2;
#define _AND ;
#define _CONST
#endif

/*
 * define SWAPSHORT(i) (((i>>8)&0xff)|((i<<8)&0xff00))
 */
inline static _CONST unsigned short int _DEFUN(SwapShort, (i), unsigned short int i)
{
  __asm volatile ("		\
	ror%.w #8,%0		\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");

  return i;
}

/*
 * define SWAPINT(i) (((i>>24)&0xff)|((i>>8)&0xff00)|((i<<8)&0xff0000)|((i<<24)&0xff000000))
 */
inline static _CONST unsigned int _DEFUN(SwapInt, (i), unsigned int i)
{
  __asm volatile ("		\
	ror%.w #8,%0		\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");
  __asm volatile ("		\
	swap %0			\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");
  __asm volatile ("		\
	ror%.w #8,%0		\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");

  return i;
}

inline static _CONST float _DEFUN(SwapFloat, (i), float i)
{
  __asm volatile ("		\
	ror%.w #8,%0		\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");
  __asm volatile ("		\
	swap %0			\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");
  __asm volatile ("		\
	ror%.w #8,%0		\
	"
		  :"=d" (i)
		  :"0"(i)
		  :"cc");

  return i;
}

#undef _DEFUN
#undef _AND
#undef _CONST
#endif

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

#ifndef NOASM
#define	MATCH
#undef	Match
unsigned char Match(register struct rgb *rawpix __asm__("a0"), register struct rgb *Palette __asm__("a1"));
#endif

#endif
