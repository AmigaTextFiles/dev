OPT NATIVE
->MODULE 'target/x86_64-linux-gnu/bits/typesizes'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/types/__sigset_t'	->guessed
MODULE 'target/linux/posix_types'	->guessed
MODULE 'target/features'
/* Get definition of needed basic types.  */
MODULE 'target/x86_64-linux-gnu/bits/types'
/* Get __FD_* definitions.  */
MODULE 'target/x86_64-linux-gnu/bits/select'
/* Get sigset_t.  */
MODULE 'target/x86_64-linux-gnu/bits/types/sigset_t'
/* Get definition of timer specification structures.  */
MODULE 'target/x86_64-linux-gnu/bits/types/time_t'
MODULE 'target/x86_64-linux-gnu/bits/types/struct_timeval'
 MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'
{#include <x86_64-linux-gnu/sys/select.h>}
/* `fd_set' type and related macros, and `select'/`pselect' declarations.
   Copyright (C) 1996-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

/*	POSIX 1003.1g: 6.2 Select from File Descriptor Sets <sys/select.h>  */

NATIVE {_SYS_SELECT_H}	CONST ->_SYS_SELECT_H	= 1

/*
#ifndef __suseconds_t_defined
NATIVE {suseconds_t} OBJECT
->TYPE suseconds_t IS NATIVE {suseconds_t} SUSECONDS_T__
 ->NATIVE {__suseconds_t_defined} DEF
#endif
*/


/* The fd_set member is required to be an array of longs.  */

TYPE FD_MASK__ IS NATIVE {__fd_mask} CLONG

/* Some versions of <linux/posix_types.h> define this macros.  */
/* It's easier to assume 8-bit bytes than to get CHAR_BIT.  */
NATIVE {__NFDBITS}	CONST NFDBITS__	= (8 * SIZEOF FD_MASK__)
->NATIVE {__FD_ELT} PROC	->define __FD_ELT(d)	((d) / NFDBITS__)
->NATIVE {__FD_MASK} PROC	->define __FD_MASK(d)	((FD_MASK__) (1UL << ((d) % NFDBITS__)))

/* fd_set for select and pselect.  */
NATIVE {fd_set Typedef} OBJECT fd_set
    {fds_bits} bits[FD_SETSIZE__ / NFDBITS__]:ARRAY OF FD_MASK__
ENDOBJECT
NATIVE {__FDS_BITS} PROC
-># define __FDS_BITS(set) ((set).fds_bits)

/* Maximum number of file descriptors in `fd_set'.  */
NATIVE {FD_SETSIZE}		CONST FD_SETSIZE		= FD_SETSIZE__

/* Sometimes the fd_set member is assumed to have this type.  */
NATIVE {fd_mask} OBJECT
->TYPE fd_mask IS NATIVE {fd_mask} FD_MASK__

/* Number of bits per word of `fd_set' (some code assumes this is 32).  */
 NATIVE {NFDBITS}		CONST NFDBITS		= NFDBITS__


/* Access macros for `fd_set'.  */
NATIVE {FD_SET} CONST	->define FD_SET(fd, fdsetp)	__FD_SET (fd, fdsetp)
PROC fd_set(fd, fdsetp:PTR TO fd_set) IS NATIVE {FD_SET(} fd {,} fdsetp {)} ENDNATIVE
NATIVE {FD_CLR} CONST	->define FD_CLR(fd, fdsetp)	__FD_CLR (fd, fdsetp)
PROC fd_clr(fd, fdsetp:PTR TO fd_set) IS NATIVE {FD_CLR(} fd {,} fdsetp {)} ENDNATIVE
NATIVE {FD_ISSET} CONST	->define FD_ISSET(fd, fdsetp)	__FD_ISSET (fd, fdsetp)
PROC fd_isset(fd, fdsetp:PTR TO fd_set) IS NATIVE {(-FD_ISSET(} fd {,} fdsetp {))} ENDNATIVE !!BOOL
NATIVE {FD_ZERO} CONST	->define FD_ZERO(fdsetp)		__FD_ZERO (fdsetp)
PROC fd_zero(fdsetp:PTR TO fd_set) IS NATIVE {FD_ZERO(} fdsetp {)} ENDNATIVE


/* Check the first NFDS descriptors each in READFDS (if not NULL) for read
   readiness, in WRITEFDS (if not NULL) for write readiness, and in EXCEPTFDS
   (if not NULL) for exceptional conditions.  If TIMEOUT is not NULL, time out
   after waiting the interval specified therein.  Returns the number of ready
   descriptors, or -1 for errors.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {select} PROC
PROC select(__nfds:VALUE, __readfds:PTR TO fd_set,
		   __writefds:PTR TO fd_set,
		   __exceptfds:PTR TO fd_set,
		   __timeout:PTR TO timeval) IS NATIVE {select( (int) } __nfds {,} __readfds {,} __writefds {,} __exceptfds {,} __timeout {)} ENDNATIVE !!VALUE

/* Same as above only that the TIMEOUT value is given with higher
   resolution and a sigmask which is been set temporarily.  This version
   should be used.

   This function is a cancellation point and therefore not marked with
   __THROW.  */
NATIVE {pselect} PROC
PROC pselect(__nfds:VALUE, __readfds:PTR TO fd_set,
		    __writefds:PTR TO fd_set,
		    __exceptfds:PTR TO fd_set,
		    __timeout:PTR TO timespec,
		    __sigmask:PTR TO __sigset_t) IS NATIVE {pselect( (int) } __nfds {,} __readfds {,} __writefds {,} __exceptfds {,} __timeout {,} __sigmask {)} ENDNATIVE !!VALUE
