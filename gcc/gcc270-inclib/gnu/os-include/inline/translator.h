#ifndef _INLINE_TRANSLATOR_H
#define _INLINE_TRANSLATOR_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * TranslatorBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME TranslatorBase
#endif

BASE_EXT_DECL0

extern __inline LONG 
Translate (BASE_PAR_DECL STRPTR inputString,long inputLength,STRPTR outputBuffer,long bufferSize)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = inputString;
  register long d0 __asm("d0") = inputLength;
  register STRPTR a1 __asm("a1") = outputBuffer;
  register long d1 __asm("d1") = bufferSize;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_TRANSLATOR_H */
