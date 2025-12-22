#ifndef _INLINE_POTGO_H
#define _INLINE_POTGO_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct Library * PotgoBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME PotgoBase
#endif

static __inline UWORD 
AllocPotBits (BASE_PAR_DECL unsigned long bits)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = bits;
  __asm __volatile ("jsr a6@(-0x6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
FreePotBits (BASE_PAR_DECL unsigned long bits)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = bits;
  __asm __volatile ("jsr a6@(-0xc)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
}
static __inline void 
WritePotgo (BASE_PAR_DECL unsigned long word,unsigned long mask)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = word;
  register unsigned long d1 __asm("d1") = mask;
  __asm __volatile ("jsr a6@(-0x18)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_POTGO_H */
