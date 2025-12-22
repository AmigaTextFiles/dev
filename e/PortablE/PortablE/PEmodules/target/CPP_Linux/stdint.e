OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/libc-header-start'
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/wchar'
MODULE 'target/x86_64-linux-gnu/bits/wordsize'
/* Signed.  */
MODULE 'target/x86_64-linux-gnu/bits/stdint-intn'
/* Unsigned.  */
MODULE 'target/x86_64-linux-gnu/bits/stdint-uintn'
{#include <stdint.h>}
/* Copyright (C) 1997-2020 Free Software Foundation, Inc.
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

/*
 *	ISO C99: 7.18 Integer types <stdint.h>
 */

NATIVE {_STDINT_H}	CONST ->_STDINT_H	= 1

->NATIVE {__GLIBC_INTERNAL_STARTING_HEADER_IMPLEMENTATION} DEF

/* Exact integral types.  */


/* Small types.  */

/* Signed.  */
NATIVE {int_least8_t} OBJECT
->TYPE int_least8_t IS NATIVE {int_least8_t} __int_least8_t
NATIVE {int_least16_t} OBJECT
->TYPE int_least16_t IS NATIVE {int_least16_t} __int_least16_t
NATIVE {int_least32_t} OBJECT
->TYPE int_least32_t IS NATIVE {int_least32_t} __int_least32_t
NATIVE {int_least64_t} OBJECT
->TYPE int_least64_t IS NATIVE {int_least64_t} __int_least64_t

/* Unsigned.  */
NATIVE {uint_least8_t} OBJECT
->TYPE uint_least8_t IS NATIVE {uint_least8_t} __uint_least8_t
NATIVE {uint_least16_t} OBJECT
->TYPE uint_least16_t IS NATIVE {uint_least16_t} __uint_least16_t
NATIVE {uint_least32_t} OBJECT
->TYPE uint_least32_t IS NATIVE {uint_least32_t} __uint_least32_t
NATIVE {uint_least64_t} OBJECT
->TYPE uint_least64_t IS NATIVE {uint_least64_t} __uint_least64_t


/* Fast types.  */

/* Signed.  */
NATIVE {int_fast8_t} OBJECT
->TYPE int_fast8_t IS NATIVE {int_fast8_t} BYTE
NATIVE {int_fast16_t} OBJECT
->TYPE int_fast16_t IS NATIVE {int_fast16_t} CLONG
NATIVE {int_fast32_t} OBJECT
->TYPE int_fast32_t IS NATIVE {int_fast32_t} CLONG
NATIVE {int_fast64_t} OBJECT
->TYPE int_fast64_t IS NATIVE {int_fast64_t} CLONG

/* Unsigned.  */
NATIVE {uint_fast8_t} OBJECT
->TYPE uint_fast8_t IS NATIVE {uint_fast8_t} UBYTE
NATIVE {uint_fast16_t} OBJECT
->TYPE uint_fast16_t IS NATIVE {uint_fast16_t} UCLONG
NATIVE {uint_fast32_t} OBJECT
->TYPE uint_fast32_t IS NATIVE {uint_fast32_t} UCLONG
NATIVE {uint_fast64_t} OBJECT
->TYPE uint_fast64_t IS NATIVE {uint_fast64_t} UCLONG


/* Types for `void *' pointers.  */
NATIVE {intptr_t} OBJECT
TYPE INTPTR_T IS NATIVE {intptr_t} CLONG
  ->NATIVE {__intptr_t_defined} DEF
NATIVE {uintptr_t} OBJECT
->TYPE uintptr_t IS NATIVE {uintptr_t} UCLONG


/* Largest integral types.  */
NATIVE {intmax_t} OBJECT
->TYPE intmax_t IS NATIVE {intmax_t} __intmax_t
NATIVE {uintmax_t} OBJECT
->TYPE uintmax_t IS NATIVE {uintmax_t} __uintmax_t


  ->NATIVE {__INT64_C} PROC	->define __INT64_C(c)	c ## L
  ->NATIVE {__UINT64_C} PROC	->define __UINT64_C(c)	c ## UL

/* Limits of integral types.  */

/* Minimum of signed integral types.  */
 NATIVE {INT8_MIN}		CONST INT8_MIN		= (-128)
 NATIVE {INT16_MIN}		CONST INT16_MIN		= (-32767-1)
 NATIVE {INT32_MIN}		CONST INT32_MIN		= (-2147483647-1)
 NATIVE {INT64_MIN}		CONST ->INT64_MIN		= (-__INT64_C(9223372036854775807)-1)
/* Maximum of signed integral types.  */
 NATIVE {INT8_MAX}		CONST INT8_MAX		= (127)
 NATIVE {INT16_MAX}		CONST INT16_MAX		= (32767)
 NATIVE {INT32_MAX}		CONST INT32_MAX		= (2147483647)
 NATIVE {INT64_MAX}		CONST ->INT64_MAX		= (__INT64_C(9223372036854775807))

/* Maximum of unsigned integral types.  */
 NATIVE {UINT8_MAX}		CONST UINT8_MAX		= (255)
 NATIVE {UINT16_MAX}		CONST UINT16_MAX		= (65535)
 NATIVE {UINT32_MAX}		CONST ->UINT32_MAX		= (4294967295U)
 NATIVE {UINT64_MAX}		CONST ->UINT64_MAX		= (__UINT64_C(18446744073709551615))


/* Minimum of signed integral types having a minimum size.  */
 NATIVE {INT_LEAST8_MIN}		CONST INT_LEAST8_MIN		= (-128)
 NATIVE {INT_LEAST16_MIN}	CONST INT_LEAST16_MIN	= (-32767-1)
 NATIVE {INT_LEAST32_MIN}	CONST INT_LEAST32_MIN	= (-2147483647-1)
 NATIVE {INT_LEAST64_MIN}	CONST ->INT_LEAST64_MIN	= (-__INT64_C(9223372036854775807)-1)
/* Maximum of signed integral types having a minimum size.  */
 NATIVE {INT_LEAST8_MAX}		CONST INT_LEAST8_MAX		= (127)
 NATIVE {INT_LEAST16_MAX}	CONST INT_LEAST16_MAX	= (32767)
 NATIVE {INT_LEAST32_MAX}	CONST INT_LEAST32_MAX	= (2147483647)
 NATIVE {INT_LEAST64_MAX}	CONST ->INT_LEAST64_MAX	= (__INT64_C(9223372036854775807))

/* Maximum of unsigned integral types having a minimum size.  */
 NATIVE {UINT_LEAST8_MAX}	CONST UINT_LEAST8_MAX	= (255)
 NATIVE {UINT_LEAST16_MAX}	CONST UINT_LEAST16_MAX	= (65535)
 NATIVE {UINT_LEAST32_MAX}	CONST ->UINT_LEAST32_MAX	= (4294967295U)
 NATIVE {UINT_LEAST64_MAX}	CONST ->UINT_LEAST64_MAX	= (__UINT64_C(18446744073709551615))


/* Minimum of fast signed integral types having a minimum size.  */
 NATIVE {INT_FAST8_MIN}		CONST INT_FAST8_MIN		= (-128)
  NATIVE {INT_FAST16_MIN}	CONST ->INT_FAST16_MIN	= (-9223372036854775807-1)
  NATIVE {INT_FAST32_MIN}	CONST ->INT_FAST32_MIN	= (-9223372036854775807-1)
 NATIVE {INT_FAST64_MIN}		CONST ->INT_FAST64_MIN		= (-__INT64_C(9223372036854775807)-1)
/* Maximum of fast signed integral types having a minimum size.  */
 NATIVE {INT_FAST8_MAX}		CONST INT_FAST8_MAX		= (127)
  NATIVE {INT_FAST16_MAX}	CONST ->INT_FAST16_MAX	= (9223372036854775807)
  NATIVE {INT_FAST32_MAX}	CONST ->INT_FAST32_MAX	= (9223372036854775807)
 NATIVE {INT_FAST64_MAX}		CONST ->INT_FAST64_MAX		= (__INT64_C(9223372036854775807))

/* Maximum of fast unsigned integral types having a minimum size.  */
 NATIVE {UINT_FAST8_MAX}		CONST UINT_FAST8_MAX		= (255)
  NATIVE {UINT_FAST16_MAX}	CONST ->UINT_FAST16_MAX	= (18446744073709551615)
  NATIVE {UINT_FAST32_MAX}	CONST ->UINT_FAST32_MAX	= (18446744073709551615)
 NATIVE {UINT_FAST64_MAX}	CONST ->UINT_FAST64_MAX	= (__UINT64_C(18446744073709551615))


/* Values to test for integral types holding `void *' pointer.  */
  NATIVE {INTPTR_MIN}		CONST ->INTPTR_MIN		= (-9223372036854775807-1)
  NATIVE {INTPTR_MAX}		CONST ->INTPTR_MAX		= (9223372036854775807)
  NATIVE {UINTPTR_MAX}		CONST ->UINTPTR_MAX		= (18446744073709551615)


/* Minimum for largest signed integral type.  */
 NATIVE {INTMAX_MIN}		CONST ->INTMAX_MIN		= (-__INT64_C(9223372036854775807)-1)
/* Maximum for largest signed integral type.  */
 NATIVE {INTMAX_MAX}		CONST ->INTMAX_MAX		= (__INT64_C(9223372036854775807))

/* Maximum for largest unsigned integral type.  */
 NATIVE {UINTMAX_MAX}		CONST ->UINTMAX_MAX		= (__UINT64_C(18446744073709551615))


/* Limits of other integer types.  */

/* Limits of `ptrdiff_t' type.  */
  NATIVE {PTRDIFF_MIN}		CONST ->PTRDIFF_MIN		= (-9223372036854775807-1)
  NATIVE {PTRDIFF_MAX}		CONST ->PTRDIFF_MAX		= (9223372036854775807)

/* Limits of `sig_atomic_t'.  */
 NATIVE {SIG_ATOMIC_MIN}		CONST SIG_ATOMIC_MIN		= (-2147483647-1)
 NATIVE {SIG_ATOMIC_MAX}		CONST SIG_ATOMIC_MAX		= (2147483647)

/* Limit of `size_t' type.  */
  NATIVE {SIZE_MAX}		CONST ->SIZE_MAX		= (18446744073709551615)

/* Limits of `wchar_t'.  */
/* These constants might also be defined in <wchar.h>.  */
  NATIVE {WCHAR_MIN}		CONST WCHAR_MIN		= WCHAR_MIN__
  NATIVE {WCHAR_MAX}		CONST WCHAR_MAX		= WCHAR_MAX__

/* Limits of `wint_t'.  */
 NATIVE {WINT_MIN}		CONST WINT_MIN		= (0)
 NATIVE {WINT_MAX}		CONST ->WINT_MAX		= (4294967295)

/* Signed.  */
 NATIVE {INT8_C} CONST	->define INT8_C(c)	c
 NATIVE {INT16_C} CONST	->define INT16_C(c)	c
 NATIVE {INT32_C} CONST	->define INT32_C(c)	c
  NATIVE {INT64_C} CONST	->define INT64_C(c)	c ## L

/* Unsigned.  */
 NATIVE {UINT8_C} CONST	->define UINT8_C(c)	c
 NATIVE {UINT16_C} CONST	->define UINT16_C(c)	c
 NATIVE {UINT32_C} CONST	->define UINT32_C(c)	c ## U
  NATIVE {UINT64_C} CONST	->define UINT64_C(c)	c ## UL

/* Maximal type.  */
  NATIVE {INTMAX_C} CONST	->define INTMAX_C(c)	c ## L
  NATIVE {UINTMAX_C} CONST	->define UINTMAX_C(c)	c ## UL


NATIVE {INT8_WIDTH} CONST INT8_WIDTH = 8
 NATIVE {UINT8_WIDTH} CONST UINT8_WIDTH = 8
 NATIVE {INT16_WIDTH} CONST INT16_WIDTH = 16
 NATIVE {UINT16_WIDTH} CONST UINT16_WIDTH = 16
 NATIVE {INT32_WIDTH} CONST INT32_WIDTH = 32
 NATIVE {UINT32_WIDTH} CONST UINT32_WIDTH = 32
 NATIVE {INT64_WIDTH} CONST INT64_WIDTH = 64
 NATIVE {UINT64_WIDTH} CONST UINT64_WIDTH = 64

 NATIVE {INT_LEAST8_WIDTH} CONST INT_LEAST8_WIDTH = 8
 NATIVE {UINT_LEAST8_WIDTH} CONST UINT_LEAST8_WIDTH = 8
 NATIVE {INT_LEAST16_WIDTH} CONST INT_LEAST16_WIDTH = 16
 NATIVE {UINT_LEAST16_WIDTH} CONST UINT_LEAST16_WIDTH = 16
 NATIVE {INT_LEAST32_WIDTH} CONST INT_LEAST32_WIDTH = 32
 NATIVE {UINT_LEAST32_WIDTH} CONST UINT_LEAST32_WIDTH = 32
 NATIVE {INT_LEAST64_WIDTH} CONST INT_LEAST64_WIDTH = 64
 NATIVE {UINT_LEAST64_WIDTH} CONST UINT_LEAST64_WIDTH = 64

 NATIVE {INT_FAST8_WIDTH} CONST INT_FAST8_WIDTH = 8
 NATIVE {UINT_FAST8_WIDTH} CONST UINT_FAST8_WIDTH = 8
 NATIVE {INT_FAST16_WIDTH} CONST INT_FAST16_WIDTH = WORDSIZE__
 NATIVE {UINT_FAST16_WIDTH} CONST UINT_FAST16_WIDTH = WORDSIZE__
 NATIVE {INT_FAST32_WIDTH} CONST INT_FAST32_WIDTH = WORDSIZE__
 NATIVE {UINT_FAST32_WIDTH} CONST UINT_FAST32_WIDTH = WORDSIZE__
 NATIVE {INT_FAST64_WIDTH} CONST INT_FAST64_WIDTH = 64
 NATIVE {UINT_FAST64_WIDTH} CONST UINT_FAST64_WIDTH = 64

 NATIVE {INTPTR_WIDTH} CONST INTPTR_WIDTH = WORDSIZE__
 NATIVE {UINTPTR_WIDTH} CONST UINTPTR_WIDTH = WORDSIZE__

 NATIVE {INTMAX_WIDTH} CONST INTMAX_WIDTH = 64
 NATIVE {UINTMAX_WIDTH} CONST UINTMAX_WIDTH = 64

 NATIVE {PTRDIFF_WIDTH} CONST PTRDIFF_WIDTH = WORDSIZE__
 NATIVE {SIG_ATOMIC_WIDTH} CONST SIG_ATOMIC_WIDTH = 32
 NATIVE {SIZE_WIDTH} CONST SIZE_WIDTH = WORDSIZE__
 NATIVE {WCHAR_WIDTH} CONST WCHAR_WIDTH = 32
 NATIVE {WINT_WIDTH} CONST WINT_WIDTH = 32
