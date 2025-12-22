OPT NATIVE
{#include <stdint.h>}
/* ISO C9x  7.18  Integer types <stdint.h>
 * Based on ISO/IEC SC22/WG14 9899 Committee draft (SC22 N2794)
 *
 *  THIS SOFTWARE IS NOT COPYRIGHTED
 *
 *  Contributor: Danny Smith <danny_r_smith_2001@yahoo.co.nz>
 *
 *  This source code is offered for use in the public domain. You may
 *  use, modify or distribute it freely.
 *
 *  This code is distributed in the hope that it will be useful but
 *  WITHOUT ANY WARRANTY. ALL WARRANTIES, EXPRESS OR IMPLIED ARE HEREBY
 *  DISCLAIMED. This includes but is not limited to warranties of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 *  Date: 2000-12-02
 */


NATIVE {_STDINT_H} DEF

/* 7.18.1.1  Exact-width integer types */
NATIVE {int8_t} OBJECT
NATIVE {uint8_t} OBJECT
NATIVE {int16_t} OBJECT
NATIVE {uint16_t} OBJECT
NATIVE {int32_t} OBJECT
NATIVE {uint32_t} OBJECT
NATIVE {int64_t} OBJECT
NATIVE {uint64_t} OBJECT

/* 7.18.1.2  Minimum-width integer types */
NATIVE {int_least8_t} OBJECT
NATIVE {uint_least8_t} OBJECT
NATIVE {int_least16_t} OBJECT
NATIVE {uint_least16_t} OBJECT
NATIVE {int_least32_t} OBJECT
NATIVE {uint_least32_t} OBJECT
NATIVE {int_least64_t} OBJECT
NATIVE {uint_least64_t} OBJECT

/*  7.18.1.3  Fastest minimum-width integer types 
 *  Not actually guaranteed to be fastest for all purposes
 *  Here we use the exact-width types for 8 and 16-bit ints. 
 */
NATIVE {int_fast8_t} OBJECT
NATIVE {uint_fast8_t} OBJECT
NATIVE {int_fast16_t} OBJECT
NATIVE {uint_fast16_t} OBJECT
NATIVE {int_fast32_t} OBJECT
NATIVE {uint_fast32_t} OBJECT
NATIVE {int_fast64_t} OBJECT
NATIVE {uint_fast64_t} OBJECT

/* 7.18.1.4  Integer types capable of holding object pointers */
NATIVE {intptr_t} OBJECT
TYPE INTPTR_T IS NATIVE {intptr_t} PTR
NATIVE {uintptr_t} OBJECT
TYPE UINTPTR_T IS NATIVE {uintptr_t} PTR

/* 7.18.1.5  Greatest-width integer types */
NATIVE {intmax_t} OBJECT
NATIVE {uintmax_t} OBJECT

/* 7.18.2  Limits of specified-width integer types */
->#if !defined ( __cplusplus) || defined (__STDC_LIMIT_MACROS)

/* 7.18.2.1  Limits of exact-width integer types */
NATIVE {INT8_MIN} CONST INT8_MIN = (-128) 
NATIVE {INT16_MIN} CONST INT16_MIN = (-32768)
NATIVE {INT32_MIN} CONST INT32_MIN = (-2147483647 - 1)
NATIVE {INT64_MIN}  CONST ->INT64_MIN  = (-9223372036854775807 - 1)

NATIVE {INT8_MAX} CONST INT8_MAX = 127
NATIVE {INT16_MAX} CONST INT16_MAX = 32767
NATIVE {INT32_MAX} CONST INT32_MAX = 2147483647
NATIVE {INT64_MAX} CONST ->INT64_MAX = 9223372036854775807

NATIVE {UINT8_MAX} CONST UINT8_MAX = $ff /* 255U */
NATIVE {UINT16_MAX} CONST UINT16_MAX = $ffff /* 65535U */
NATIVE {UINT32_MAX} CONST UINT32_MAX = $ffffffff  /* 4294967295U */
NATIVE {UINT64_MAX} CONST ->UINT64_MAX = $ffffffffffffffff /* 18446744073709551615 */

/* 7.18.2.2  Limits of minimum-width integer types */
NATIVE {INT_LEAST8_MIN} CONST INT_LEAST8_MIN = INT8_MIN
NATIVE {INT_LEAST16_MIN} CONST INT_LEAST16_MIN = INT16_MIN
NATIVE {INT_LEAST32_MIN} CONST INT_LEAST32_MIN = INT32_MIN
NATIVE {INT_LEAST64_MIN} CONST ->INT_LEAST64_MIN = INT64_MIN

NATIVE {INT_LEAST8_MAX} CONST INT_LEAST8_MAX = INT8_MAX
NATIVE {INT_LEAST16_MAX} CONST INT_LEAST16_MAX = INT16_MAX
NATIVE {INT_LEAST32_MAX} CONST INT_LEAST32_MAX = INT32_MAX
NATIVE {INT_LEAST64_MAX} CONST ->INT_LEAST64_MAX = INT64_MAX

NATIVE {UINT_LEAST8_MAX} CONST UINT_LEAST8_MAX = UINT8_MAX
NATIVE {UINT_LEAST16_MAX} CONST UINT_LEAST16_MAX = UINT16_MAX
NATIVE {UINT_LEAST32_MAX} CONST UINT_LEAST32_MAX = UINT32_MAX
NATIVE {UINT_LEAST64_MAX} CONST ->UINT_LEAST64_MAX = UINT64_MAX

/* 7.18.2.3  Limits of fastest minimum-width integer types */
NATIVE {INT_FAST8_MIN} CONST INT_FAST8_MIN = INT8_MIN
NATIVE {INT_FAST16_MIN} CONST INT_FAST16_MIN = INT16_MIN
NATIVE {INT_FAST32_MIN} CONST INT_FAST32_MIN = INT32_MIN
NATIVE {INT_FAST64_MIN} CONST ->INT_FAST64_MIN = INT64_MIN

NATIVE {INT_FAST8_MAX} CONST INT_FAST8_MAX = INT8_MAX
NATIVE {INT_FAST16_MAX} CONST INT_FAST16_MAX = INT16_MAX
NATIVE {INT_FAST32_MAX} CONST INT_FAST32_MAX = INT32_MAX
NATIVE {INT_FAST64_MAX} CONST ->INT_FAST64_MAX = INT64_MAX

NATIVE {UINT_FAST8_MAX} CONST UINT_FAST8_MAX = UINT8_MAX
NATIVE {UINT_FAST16_MAX} CONST UINT_FAST16_MAX = UINT16_MAX
NATIVE {UINT_FAST32_MAX} CONST UINT_FAST32_MAX = UINT32_MAX
NATIVE {UINT_FAST64_MAX} CONST ->UINT_FAST64_MAX = UINT64_MAX

/* 7.18.2.4  Limits of integer types capable of holding
    object pointers */ 
NATIVE {INTPTR_MIN} CONST INTPTR_MIN = INT32_MIN
NATIVE {INTPTR_MAX} CONST INTPTR_MAX = INT32_MAX
NATIVE {UINTPTR_MAX} CONST UINTPTR_MAX = UINT32_MAX

/* 7.18.2.5  Limits of greatest-width integer types */
NATIVE {INTMAX_MIN} CONST ->INTMAX_MIN = INT64_MIN
NATIVE {INTMAX_MAX} CONST ->INTMAX_MAX = INT64_MAX
NATIVE {UINTMAX_MAX} CONST ->UINTMAX_MAX = UINT64_MAX

/* 7.18.3  Limits of other integer types */
NATIVE {PTRDIFF_MIN} CONST PTRDIFF_MIN = INT32_MIN
NATIVE {PTRDIFF_MAX} CONST PTRDIFF_MAX = INT32_MAX

NATIVE {SIG_ATOMIC_MIN} CONST SIG_ATOMIC_MIN = INT32_MIN
NATIVE {SIG_ATOMIC_MAX} CONST SIG_ATOMIC_MAX = INT32_MAX

NATIVE {SIZE_MAX} CONST SIZE_MAX = UINT32_MAX

->#ifndef WCHAR_MIN  /* also in wchar.h */ 
NATIVE {WCHAR_MIN} CONST WCHAR_MIN = 0
NATIVE {WCHAR_MAX} CONST WCHAR_MAX = $ffff /* UINT16_MAX */
->#endif

/*
 * wint_t is unsigned short for compatibility with MS runtime
 */
NATIVE {WINT_MIN} CONST WINT_MIN = 0
NATIVE {WINT_MAX} CONST WINT_MAX = $ffff /* UINT16_MAX */

->#endif /* !defined ( __cplusplus) || defined __STDC_LIMIT_MACROS */


/* 7.18.4  Macros for integer constants */
->#if !defined ( __cplusplus) || defined (__STDC_CONSTANT_MACROS)

/* 7.18.4.1  Macros for minimum-width integer constants

    Accoding to Douglas Gwyn <gwyn@arl.mil>:
	"This spec was changed in ISO/IEC 9899:1999 TC1; in ISO/IEC
	9899:1999 as initially published, the expansion was required
	to be an integer constant of precisely matching type, which
	is impossible to accomplish for the shorter types on most
	platforms, because C99 provides no standard way to designate
	an integer constant with width less than that of type int.
	TC1 changed this to require just an integer constant
	*expression* with *promoted* type."
*/

NATIVE {INT8_C} CONST	->INT8_C(val) ((int8_t) + (val))
NATIVE {UINT8_C} CONST	->UINT8_C(val) ((uint8_t) + (val##U))
NATIVE {INT16_C} CONST	->INT16_C(val) ((int16_t) + (val))
NATIVE {UINT16_C} CONST	->UINT16_C(val) ((uint16_t) + (val##U))

NATIVE {INT32_C} CONST	->INT32_C(val) val##L
NATIVE {UINT32_C} CONST	->UINT32_C(val) val##UL
NATIVE {INT64_C} CONST	->INT64_C(val) val##LL
NATIVE {UINT64_C} CONST	->UINT64_C(val) val##ULL

/* 7.18.4.2  Macros for greatest-width integer constants */
NATIVE {INTMAX_C} CONST	->INTMAX_C(val)  INT64_C(val)
NATIVE {UINTMAX_C} CONST	->UINTMAX_C(val) UINT64_C(val)

->#endif  /* !defined ( __cplusplus) || defined __STDC_CONSTANT_MACROS */
