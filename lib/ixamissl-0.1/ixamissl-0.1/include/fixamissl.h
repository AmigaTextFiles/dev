/*
 * fixamissl.h - stuff that can really save the day
 * version 0.1 megacz@usa.com
 *
 * Include after 'openssl/ssl.h' or 'proto/amissl.h'.
 *
*/



#ifndef __FIXAMISSL_H__
#define __FIXAMISSL_H__

#include <openssl/x509.h>



typedef struct X509_name_st STACK_OF_X509_NAME;

/* Amiga - this inline is broken in 3.5 */
#ifdef SSL_CTX_set_cipher_list
#undef SSL_CTX_set_cipher_list
#define SSL_CTX_set_cipher_list(ctx, str) \
	LP2(0x200a, int, SSL_CTX_set_cipher_list, SSL_CTX *, ctx, a0, const char *, str, a1, \
	, AMISSL_BASE_NAME)
#endif

/* Amiga - no more fear cuz missing macros are here */
#ifndef LP1NRFP
#define LP1NRFP(offs, name, t1, v1, r1, bt, bn, fpt) 		\
({								\
   typedef fpt;							\
   t1 _##name##_v1 = (v1);					\
   {								\
      register int _d0 __asm("d0");				\
      register int _d1 __asm("d1");				\
      register int _a0 __asm("a0");				\
      register int _a1 __asm("a1");				\
      register struct Library *const _##name##_bn __asm("a6") = (struct Library*)(bn); \
      register t1 _n1 __asm(#r1) = _##name##_v1;		\
      __asm volatile ("jsr a6@(-"#offs":W)" 			\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)		\
      : "r" (_##name##_bn), "rf"(_n1)				\
      : "fp0", "fp1", "cc", "memory");				\
   }								\
})
#endif
#ifndef LP2NRFP
#define LP2NRFP(offs, name, t1, v1, r1, t2, v2, r2, bt, bn, fpt) \
({								\
   typedef fpt;							\
   t1 _##name##_v1 = (v1);					\
   t2 _##name##_v2 = (v2);					\
   {								\
      register int _d0 __asm("d0");				\
      register int _d1 __asm("d1");				\
      register int _a0 __asm("a0");				\
      register int _a1 __asm("a1");				\
      register struct Library *const _##name##_bn __asm("a6") = (struct Library*)(bn); \
      register t1 _n1 __asm(#r1) = _##name##_v1;		\
      register t2 _n2 __asm(#r2) = _##name##_v2;		\
      __asm volatile ("jsr a6@(-"#offs":W)"			\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)		\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2)		\
      : "fp0", "fp1", "cc", "memory");				\
   }								\
})
#endif
#ifdef LP1
#undef LP1
#define LP1(offs, rt, name, t1, v1, r1, bt, bn)			\
({								\
   t1 _##name##_v1 = (v1);					\
   rt _##name##_re2 =						\
   ({								\
      register int _d1 __asm("d1");				\
      register int _a0 __asm("a0");				\
      register int _a1 __asm("a1");				\
      register rt _##name##_re __asm("d0");			\
      register void *const _##name##_bn __asm("a6") = (bn);	\
      register t1 _n1 __asm(#r1) = _##name##_v1;		\
      __asm volatile ("jsr a6@(-"#offs":W)"			\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1)	\
      : "r" (_##name##_bn), "rf"(_n1)				\
      : "fp0", "fp1", "cc", "memory");				\
      _##name##_re;						\
   });								\
   _##name##_re2;						\
})
#endif
#ifdef LP2
#undef LP2
#define LP2(offs, rt, name, t1, v1, r1, t2, v2, r2, bt, bn)	\
({								\
   t1 _##name##_v1 = (v1);					\
   t2 _##name##_v2 = (v2);					\
   rt _##name##_re2 =						\
   ({								\
      register int _d1 __asm("d1");				\
      register int _a0 __asm("a0");				\
      register int _a1 __asm("a1");				\
      register rt _##name##_re __asm("d0");			\
      register void *const _##name##_bn __asm("a6") = (bn);	\
      register t1 _n1 __asm(#r1) = _##name##_v1;		\
      register t2 _n2 __asm(#r2) = _##name##_v2;		\
      __asm volatile ("jsr a6@(-"#offs":W)"			\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1)	\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2)		\
      : "fp0", "fp1", "cc", "memory");				\
      _##name##_re;						\
   });								\
   _##name##_re2;						\
})
#endif

#endif
