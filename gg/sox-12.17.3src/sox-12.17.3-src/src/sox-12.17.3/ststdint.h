#ifndef _STSTDINT_H
#define _STSTDINT_H 1
#ifndef _GENERATED_STDINT_H
#define _GENERATED_STDINT_H " "
/* generated using a gnu compiler version 2.95.3 */

#include <stddef.h>
#include <sys/types.h>


/* int8_t int16_t int32_t defined by inet code, redeclare the u_intXX types */
typedef u_int8_t uint8_t;
typedef u_int16_t uint16_t;
typedef u_int32_t uint32_t;

/* glibc compatibility */
#ifndef __int8_t_defined
#define __int8_t_defined
#endif

/* -------------------- 64 BIT GENERIC SECTION -------------------- */
/* here are some common heuristics using compiler runtime specifics */
#if defined __STDC_VERSION__ && defined __STDC_VERSION__ > 199901L

#ifndef _HAVE_UINT64_T
#define _HAVE_UINT64_T
typedef long long int64_t;
typedef unsigned long long uint64_t;
#endif

#elif !defined __STRICT_ANSI__
#if defined _MSC_VER || defined __WATCOMC__ || defined __BORLANDC__

#ifndef _HAVE_UINT64_T
#define _HAVE_UINT64_T
typedef __int64 int64_t;
typedef unsigned __int64 uint64_t;
#endif

#elif defined __GNUC__ || defined __MWERKS__ || defined __ELF__

#if !defined _NO_LONGLONG
#ifndef _HAVE_UINT64_T
#define _HAVE_UINT64_T
typedef long long int64_t;
typedef unsigned long long uint64_t;
#endif
#endif

#elif defined __alpha || (defined __mips && defined _ABIN32)

#if !defined _NO_LONGLONG
#ifndef _HAVE_UINT64_T
#define _HAVE_UINT64_T
typedef long int64_t;
typedef unsigned long uint64_t;
#endif
#endif
  /* compiler/cpu type ... or just ISO C99 */
#endif
#endif
/* NOTE: */
/* the configure-checks for the basic types did not make us believe */
/* that we could add a fallback to a 'long long' typedef to int64_t */

/* -------------------------- INPTR SECTION --------------------------- */
/* we tested sizeof(void*) to be of 4 chars, hence we declare it 32-bit */

typedef uint32_t uintptr_t;
typedef  int32_t  intptr_t;

/* --------------GENERIC INT_LEAST / INTMAX SECTION ------------------ */

typedef  int8_t    int_least8_t;
typedef  int16_t   int_least16_t;
typedef  int32_t   int_least32_t;

typedef uint8_t   uint_least8_t;
typedef uint16_t  uint_least16_t;
typedef uint32_t  uint_least32_t;

#ifdef _HAVE_INT64_T
typedef int64_t        intmax_t;
typedef uint64_t      uintmax_t;
#else
typedef long int       intmax_t;
typedef unsigned long uintmax_t;
#endif

  /* once */
#endif
#endif
