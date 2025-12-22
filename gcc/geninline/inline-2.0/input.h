#ifndef _INLINE_INPUT_H
#define _INLINE_INPUT_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct InputBase*  InputBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME InputBase
#endif

static __inline UWORD 
PeekQualifier (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct InputBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_INPUT_H */
