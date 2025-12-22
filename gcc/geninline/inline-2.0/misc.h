#ifndef _INLINE_MISC_H
#define _INLINE_MISC_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct MiscBase*  MiscBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MiscBase
#endif

static __inline UBYTE *
AllocMiscResource (BASE_PAR_DECL unsigned long unitNum,UBYTE *name)
{
  BASE_EXT_DECL
  register UBYTE * _res  __asm("d0");
  register struct MiscBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = unitNum;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
FreeMiscResource (BASE_PAR_DECL unsigned long unitNum)
{
  BASE_EXT_DECL
  register struct MiscBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = unitNum;
  __asm __volatile ("jsr a6@(-0x12)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_MISC_H */
