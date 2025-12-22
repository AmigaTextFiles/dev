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

#if defined(BROKEN_SPRINTF) && defined(HAVE_SNPRINTF)
# undef	 sprintf
# define sprintf(str, format, args...) snprintf(str, 256, format, ##args)
#endif								/* BROKEN_SPRINTF */

#ifdef	__GNUC__
# define __packed __attribute__ ((packed))
#else
# define __packed
#endif

#ifdef	PROFILE
# undef  inline
# define inline							/* no inlining while profiling */
# undef	 INLINE_BIGENDIAN
# ifndef NOASM
#  define NOASM							/* profile implies NOASM */
# endif
#endif

#ifdef	__STRICT_ANSI__
# undef  inline
# define inline							/* no inlining in ANSI-C */
# undef	 INLINE_BIGENDIAN
#endif

#ifdef	NOASM
# undef  __asm__
# define __asm__						/* no asm-statements while compiling */
# define staticvar
# define staticfnc
#else
# define staticvar static
# define staticfnc static
#endif
