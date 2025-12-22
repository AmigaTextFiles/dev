#ifndef _INLINE_CIA_H
#define _INLINE_CIA_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

extern __inline WORD 
AbleICR (struct Library *resource,long mask)
{
  register WORD  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = mask;
  __asm __volatile ("jsr a6@(-0x12)"
  : "=r" (_res)
  : "r" (a6), "r" (a6), "r" (d0)
  : "a0","a1","a6","d0","d1", "memory");
  return _res;
}
extern __inline struct Interrupt *
AddICRVector (struct Library *resource,long iCRBit,struct Interrupt *interrupt)
{
  register struct Interrupt * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = iCRBit;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0x6)"
  : "=r" (_res)
  : "r" (a6), "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","a6","d0","d1", "memory");
  return _res;
}
extern __inline void 
RemICRVector (struct Library *resource,long iCRBit,struct Interrupt *interrupt)
{
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = iCRBit;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0xc)"
  : /* no output */
  : "r" (a6), "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","a6","d0","d1", "memory");
}
extern __inline WORD 
SetICR (struct Library *resource,long mask)
{
  register WORD  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = mask;
  __asm __volatile ("jsr a6@(-0x18)"
  : "=r" (_res)
  : "r" (a6), "r" (a6), "r" (d0)
  : "a0","a1","a6","d0","d1", "memory");
  return _res;
}

__END_DECLS

#endif /* _INLINE_CIA_H */
