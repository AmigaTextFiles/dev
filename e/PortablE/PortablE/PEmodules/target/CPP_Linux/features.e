OPT NATIVE
/* Get definitions of __STDC_* predefined macros, if the compiler has
   not preincluded this header automatically.  */
MODULE 'target/stdc-predef'
/* This is here only because every header file already includes this one.
   Get the definitions of all the appropriate `__stub_FUNCTION' symbols.
   <gnu/stubs.h> contains `#define __stub_FUNCTION' when FUNCTION is a stub
   that will always return failure (and set errno to ENOSYS).  */
MODULE 'target/x86_64-linux-gnu/gnu/stubs'
{#include <features.h>}
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
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

NATIVE {_FEATURES_H}	CONST ->_FEATURES_H	= 1

/* These are defined by the user (or the compiler)
   to specify the desired environment:

   __STRICT_ANSI__	ISO Standard C.
   _ISOC99_SOURCE	Extensions to ISO C89 from ISO C99.
   _ISOC11_SOURCE	Extensions to ISO C99 from ISO C11.
   _ISOC2X_SOURCE	Extensions to ISO C99 from ISO C2X.
   __STDC_WANT_LIB_EXT2__
			Extensions to ISO C99 from TR 27431-2:2010.
   __STDC_WANT_IEC_60559_BFP_EXT__
			Extensions to ISO C11 from TS 18661-1:2014.
   __STDC_WANT_IEC_60559_FUNCS_EXT__
			Extensions to ISO C11 from TS 18661-4:2015.
   __STDC_WANT_IEC_60559_TYPES_EXT__
			Extensions to ISO C11 from TS 18661-3:2015.

   _POSIX_SOURCE	IEEE Std 1003.1.
   _POSIX_C_SOURCE	If ==1, like _POSIX_SOURCE; if >=2 add IEEE Std 1003.2;
			if >=199309L, add IEEE Std 1003.1b-1993;
			if >=199506L, add IEEE Std 1003.1c-1995;
			if >=200112L, all of IEEE 1003.1-2004
			if >=200809L, all of IEEE 1003.1-2008
   _XOPEN_SOURCE	Includes POSIX and XPG things.  Set to 500 if
			Single Unix conformance is wanted, to 600 for the
			sixth revision, to 700 for the seventh revision.
   _XOPEN_SOURCE_EXTENDED XPG things and X/Open Unix extensions.
   _LARGEFILE_SOURCE	Some more functions for correct standard I/O.
   _LARGEFILE64_SOURCE	Additional functionality from LFS for large files.
   _FILE_OFFSET_BITS=N	Select default filesystem interface.
   _ATFILE_SOURCE	Additional *at interfaces.
   _GNU_SOURCE		All of the above, plus GNU extensions.
   _DEFAULT_SOURCE	The default set of features (taking precedence over
			__STRICT_ANSI__).

   _FORTIFY_SOURCE	Add security hardening to many library functions.
			Set to 1 or 2; 2 performs stricter checks than 1.

   _REENTRANT, _THREAD_SAFE
			Obsolete; equivalent to _POSIX_C_SOURCE=199506L.

   The `-ansi' switch to the GNU C compiler, and standards conformance
   options such as `-std=c99', define __STRICT_ANSI__.  If none of
   these are defined, or if _DEFAULT_SOURCE is defined, the default is
   to have _POSIX_SOURCE set to one and _POSIX_C_SOURCE set to
   200809L, as well as enabling miscellaneous functions from BSD and
   SVID.  If more than one of these are defined, they accumulate.  For
   example __STRICT_ANSI__, _POSIX_SOURCE and _POSIX_C_SOURCE together
   give you ISO C, 1003.1, and 1003.2, but nothing else.

   These are defined by this file and are used by the
   header files to decide what to declare or define:

   __GLIBC_USE (F)	Define things from feature set F.  This is defined
			to 1 or 0; the subsequent macros are either defined
			or undefined, and those tests should be moved to
			__GLIBC_USE.
   __USE_ISOC11		Define ISO C11 things.
   __USE_ISOC99		Define ISO C99 things.
   __USE_ISOC95		Define ISO C90 AMD1 (C95) things.
   __USE_ISOCXX11	Define ISO C++11 things.
   __USE_POSIX		Define IEEE Std 1003.1 things.
   __USE_POSIX2		Define IEEE Std 1003.2 things.
   __USE_POSIX199309	Define IEEE Std 1003.1, and .1b things.
   __USE_POSIX199506	Define IEEE Std 1003.1, .1b, .1c and .1i things.
   __USE_XOPEN		Define XPG things.
   __USE_XOPEN_EXTENDED	Define X/Open Unix things.
   __USE_UNIX98		Define Single Unix V2 things.
   __USE_XOPEN2K        Define XPG6 things.
   __USE_XOPEN2KXSI     Define XPG6 XSI things.
   __USE_XOPEN2K8       Define XPG7 things.
   __USE_XOPEN2K8XSI    Define XPG7 XSI things.
   __USE_LARGEFILE	Define correct standard I/O things.
   __USE_LARGEFILE64	Define LFS things with separate names.
   __USE_FILE_OFFSET64	Define 64bit interface as default.
   __USE_MISC		Define things from 4.3BSD or System V Unix.
   __USE_ATFILE		Define *at interfaces and AT_* constants for them.
   __USE_GNU		Define GNU extensions.
   __USE_FORTIFY_LEVEL	Additional security measures used, according to level.

   The macros `__GNU_LIBRARY__', `__GLIBC__', and `__GLIBC_MINOR__' are
   defined by this file unconditionally.  `__GNU_LIBRARY__' is provided
   only for compatibility.  All new code should use the other symbols
   to test for features.

   All macros listed above as possibly being defined by this file are
   explicitly undefined if they are not explicitly defined.
   Feature-test macros that are not defined by the user or compiler
   but are implied by the other feature-test macros defined (or by the
   lack of any definitions) are defined by the file.

   ISO C feature test macros depend on the definition of the macro
   when an affected header is included, not when the first system
   header is included, and so they are handled in
   <bits/libc-header-start.h>, which does not have a multiple include
   guard.  Feature test macros that can be handled from the first
   system header included are handled here.  */


/* Undefine everything, so we get a clean slate.  */

/* Suppress kernel-name space pollution unless user expressedly asks
   for it.  */
 ->NATIVE {__KERNEL_STRICT_NAMES} DEF

/* Convenience macro to test the version of gcc.
   Use like this:
   #if __GNUC_PREREQ (2,8)
   ... code requiring gcc 2.8 or later ...
   #endif
   Note: only works for GCC 2.0 and later, because __GNUC_MINOR__ was
   added in 2.0.  */
 ->NATIVE {__GNUC_PREREQ} PROC	->define __GNUC_PREREQ(maj, min) ((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))

/* Similarly for clang.  Features added to GCC after version 4.2 may
   or may not also be available in clang, and clang's definitions of
   __GNUC(_MINOR)__ are fixed at 4 and 2 respectively.  Not all such
   features can be queried via __has_extension/__has_feature.  */
 ->NATIVE {__glibc_clang_prereq} PROC	->define __glibc_clang_prereq(maj, min) 0

/* Whether to use feature set F.  */
->NATIVE {__GLIBC_USE} PROC	->define __GLIBC_USE(F)	__GLIBC_USE_ ## F

/* _BSD_SOURCE and _SVID_SOURCE are deprecated aliases for
   _DEFAULT_SOURCE.  If _DEFAULT_SOURCE is present we do not
   issue a warning; the expectation is that the source is being
   transitioned to use the new macro.  */

/* If _GNU_SOURCE was defined by the user, turn on all the other features.  */
 NATIVE {_ISOC95_SOURCE}	CONST ->_ISOC95_SOURCE	= 1
 NATIVE {_ISOC99_SOURCE}	CONST ->_ISOC99_SOURCE	= 1
 NATIVE {_ISOC11_SOURCE}	CONST ->_ISOC11_SOURCE	= 1
 NATIVE {_ISOC2X_SOURCE}	CONST ->_ISOC2X_SOURCE	= 1
 NATIVE {_POSIX_SOURCE}	CONST ->_POSIX_SOURCE	= 1
 NATIVE {_POSIX_C_SOURCE}	CONST ->_POSIX_C_SOURCE	= 200809L
 NATIVE {_XOPEN_SOURCE}	CONST ->_XOPEN_SOURCE	= 700
 NATIVE {_XOPEN_SOURCE_EXTENDED}	CONST ->_XOPEN_SOURCE_EXTENDED	= 1
 NATIVE {_LARGEFILE64_SOURCE}	CONST ->_LARGEFILE64_SOURCE	= 1
 NATIVE {_DEFAULT_SOURCE}	CONST ->_DEFAULT_SOURCE	= 1
 NATIVE {_ATFILE_SOURCE}	CONST ->_ATFILE_SOURCE	= 1

/* If nothing (other than _GNU_SOURCE and _DEFAULT_SOURCE) is defined,
   define _DEFAULT_SOURCE.  */
-> NATIVE {_DEFAULT_SOURCE}	CONST ->_DEFAULT_SOURCE	= 1

/* This is to enable the ISO C2X extension.  */
 ->NATIVE {__GLIBC_USE_ISOC2X}	CONST __GLIBC_USE_ISOC2X	= 1

/* This is to enable the ISO C11 extension.  */
 ->NATIVE {__USE_ISOC11}	CONST __USE_ISOC11	= 1

/* This is to enable the ISO C99 extension.  */
 ->NATIVE {__USE_ISOC99}	CONST __USE_ISOC99	= 1

/* This is to enable the ISO C90 Amendment 1:1995 extension.  */
 ->NATIVE {__USE_ISOC95}	CONST __USE_ISOC95	= 1

/* This is to enable compatibility for ISO C++17.  */
/*
 #if __cplusplus >= 201703L
  ->NATIVE {__USE_ISOC11}	CONST __USE_ISOC11	= 1
 #endif
*/
/* This is to enable compatibility for ISO C++11.
   Check the temporary macro for now, too.  */
  ->NATIVE {__USE_ISOCXX11}	CONST __USE_ISOCXX11	= 1
  ->NATIVE {__USE_ISOC99}	CONST __USE_ISOC99	= 1

/* If none of the ANSI/POSIX macros are defined, or if _DEFAULT_SOURCE
   is defined, use POSIX.1-2008 (or another version depending on
   _XOPEN_SOURCE).  */
/*
 #if !defined _POSIX_SOURCE && !defined _POSIX_C_SOURCE
  ->NATIVE {__USE_POSIX_IMPLICITLY}	CONST __USE_POSIX_IMPLICITLY	= 1
 #endif
*/
-> NATIVE {_POSIX_SOURCE}	CONST ->_POSIX_SOURCE	= 1
-> NATIVE {_POSIX_C_SOURCE}	CONST ->_POSIX_C_SOURCE	= 200809

/*
#if ((!defined __STRICT_ANSI__ || (defined _XOPEN_SOURCE && (_XOPEN_SOURCE - 0) >= 500)) && !defined _POSIX_SOURCE && !defined _POSIX_C_SOURCE)
 NATIVE {_POSIX_SOURCE}	CONST ->_POSIX_SOURCE	= 1
 #if defined _XOPEN_SOURCE && (_XOPEN_SOURCE - 0) < 500
  NATIVE {_POSIX_C_SOURCE}	CONST ->_POSIX_C_SOURCE	= 2
 #elif defined _XOPEN_SOURCE && (_XOPEN_SOURCE - 0) < 600
  NATIVE {_POSIX_C_SOURCE}	CONST ->_POSIX_C_SOURCE	= 199506L
 #elif defined _XOPEN_SOURCE && (_XOPEN_SOURCE - 0) < 700
  NATIVE {_POSIX_C_SOURCE}	CONST ->_POSIX_C_SOURCE	= 200112L
 #else
  NATIVE {_POSIX_C_SOURCE}	CONST ->_POSIX_C_SOURCE	= 200809L
 #endif
 ->NATIVE {__USE_POSIX_IMPLICITLY}	CONST __USE_POSIX_IMPLICITLY	= 1
#endif
*/

/* Some C libraries once required _REENTRANT and/or _THREAD_SAFE to be
   defined in all multithreaded code.  GNU libc has not required this
   for many years.  We now treat them as compatibility synonyms for
   _POSIX_C_SOURCE=199506L, which is the earliest level of POSIX with
   comprehensive support for multithreaded code.  Using them never
   lowers the selected level of POSIX conformance, only raises it.  */
/*
#if ((!defined _POSIX_C_SOURCE || (_POSIX_C_SOURCE - 0) < 199506L) && (defined _REENTRANT || defined _THREAD_SAFE))
 NATIVE {_POSIX_SOURCE}   CONST ->_POSIX_SOURCE   = 1
 NATIVE {_POSIX_C_SOURCE} CONST ->_POSIX_C_SOURCE = 199506L
#endif
*/

 ->NATIVE {__USE_POSIX}	CONST __USE_POSIX	= 1

 ->NATIVE {__USE_POSIX2}	CONST __USE_POSIX2	= 1

 ->NATIVE {__USE_POSIX199309}	CONST __USE_POSIX199309	= 1

 ->NATIVE {__USE_POSIX199506}	CONST __USE_POSIX199506	= 1

 ->NATIVE {__USE_XOPEN2K}		CONST __USE_XOPEN2K		= 1
 ->NATIVE {__USE_ISOC95}		CONST __USE_ISOC95		= 1
 ->NATIVE {__USE_ISOC99}		CONST __USE_ISOC99		= 1

 ->NATIVE {__USE_XOPEN2K8}		CONST __USE_XOPEN2K8		= 1
-> NATIVE {_ATFILE_SOURCE}	CONST ->_ATFILE_SOURCE	= 1

 ->NATIVE {__USE_XOPEN}	CONST __USE_XOPEN	= 1
  ->NATIVE {__USE_XOPEN_EXTENDED}	CONST __USE_XOPEN_EXTENDED	= 1
  ->NATIVE {__USE_UNIX98}	CONST __USE_UNIX98	= 1
  NATIVE {_LARGEFILE_SOURCE}	CONST ->_LARGEFILE_SOURCE	= 1
    ->NATIVE {__USE_XOPEN2K8}	CONST __USE_XOPEN2K8	= 1
    ->NATIVE {__USE_XOPEN2K8XSI}	CONST __USE_XOPEN2K8XSI	= 1
   ->NATIVE {__USE_XOPEN2K}	CONST __USE_XOPEN2K	= 1
   ->NATIVE {__USE_XOPEN2KXSI}	CONST __USE_XOPEN2KXSI	= 1
   ->NATIVE {__USE_ISOC95}		CONST __USE_ISOC95		= 1
   ->NATIVE {__USE_ISOC99}		CONST __USE_ISOC99		= 1

 ->NATIVE {__USE_LARGEFILE}	CONST __USE_LARGEFILE	= 1

 ->NATIVE {__USE_LARGEFILE64}	CONST __USE_LARGEFILE64	= 1

/*
#if defined _FILE_OFFSET_BITS && _FILE_OFFSET_BITS == 64
 ->NATIVE {__USE_FILE_OFFSET64}	CONST __USE_FILE_OFFSET64	= 1
#endif
*/

 ->NATIVE {__USE_MISC}	CONST __USE_MISC	= 1

 ->NATIVE {__USE_ATFILE}	CONST __USE_ATFILE	= 1

 ->NATIVE {__USE_GNU}	CONST __USE_GNU	= 1

 ->NATIVE {__USE_FORTIFY_LEVEL} CONST __USE_FORTIFY_LEVEL = 0

/* The function 'gets' existed in C89, but is impossible to use
   safely.  It has been removed from ISO C11 and ISO C++14.  Note: for
   compatibility with various implementations of <cstdio>, this test
   must consider only the value of __cplusplus when compiling C++.  */
 ->NATIVE {__GLIBC_USE_DEPRECATED_GETS} CONST __GLIBC_USE_DEPRECATED_GETS = 0

/* GNU formerly extended the scanf functions with modified format
   specifiers %as, %aS, and %a[...] that allocate a buffer for the
   input using malloc.  This extension conflicts with ISO C99, which
   defines %a as a standalone format specifier that reads a floating-
   point number; moreover, POSIX.1-2008 provides the same feature
   using the modifier letter 'm' instead (%ms, %mS, %m[...]).

   We now follow C99 unless GNU extensions are active and the compiler
   is specifically in C89 or C++98 mode (strict or not).  For
   instance, with GCC, -std=gnu11 will have C99-compliant scanf with
   or without -D_GNU_SOURCE, but -std=c89 -D_GNU_SOURCE will have the
   old extension.  */
 ->NATIVE {__GLIBC_USE_DEPRECATED_SCANF} CONST __GLIBC_USE_DEPRECATED_SCANF = 0


/* This macro indicates that the installed library is the GNU C Library.
   For historic reasons the value now is 6 and this will stay from now
   on.  The use of this variable is deprecated.  Use __GLIBC__ and
   __GLIBC_MINOR__ now (see below) when you want to test for a specific
   GNU C library version and use the values in <gnu/lib-names.h> to get
   the sonames of the shared libraries.  */
->NATIVE {__GNU_LIBRARY__} CONST __GNU_LIBRARY__ = 6

/* Major and minor version number of the GNU C library package.  Use
   these macros to test for features in specific releases.  */
->NATIVE {__GLIBC__}	CONST __GLIBC__	= 2
->NATIVE {__GLIBC_MINOR__}	CONST __GLIBC_MINOR__	= 31

->NATIVE {__GLIBC_PREREQ} PROC	->define __GLIBC_PREREQ(maj, min) ((__GLIBC__ << 16) + __GLIBC_MINOR__ >= ((maj) << 16) + (min))

/* This is here only because every header file already includes this one.  */
/*
 #ifndef _SYS_CDEFS_H
  MODULE 'target/sys/cdefs'
 #endif
*/

/* If we don't have __REDIRECT, prototypes will be missing if
   __USE_FILE_OFFSET64 but not __USE_LARGEFILE[64]. */
/*
#if defined __USE_FILE_OFFSET64 && !defined __REDIRECT
  ->NATIVE {__USE_LARGEFILE}	CONST __USE_LARGEFILE	= 1
  ->NATIVE {__USE_LARGEFILE64}	CONST __USE_LARGEFILE64	= 1
 #endif
*/


/* Decide whether we can define 'extern inline' functions in headers.  */
/*
#if __GNUC_PREREQ (2, 7) && defined __OPTIMIZE__ && !defined __OPTIMIZE_SIZE__ && !defined __NO_INLINE__ && defined __extern_inline
 ->NATIVE {__USE_EXTERN_INLINES}	CONST __USE_EXTERN_INLINES	= 1
#endif
*/

