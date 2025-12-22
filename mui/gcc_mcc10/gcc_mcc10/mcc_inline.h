#ifndef _INLINE_SIMPLELIB_H
#define _INLINE_SIMPLELIB_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL /*extern struct Library *SimpleBase;*/
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME SimpleBase
#endif

extern struct Library* SimpleBase;

  __inline ULONG MCC_Query( BASE_PAR_DECL LONG which)
{
  BASE_EXT_DECL
  register LONG res __asm("d0");
  register struct Library* a6 __asm("a6") = BASE_NAME;
  register LONG d0 __asm("d0")=which;

  __asm volatile ("
  jsr a6@(-0x1E)"
  : "=r" (res)
  : "r" (a6), "r" (d0)
  : "d0", "d1", "a0", "a1" );
  return res;
}

#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_SIMPLELIB_H */


