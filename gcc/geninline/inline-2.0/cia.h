#ifndef _INLINE_CIA_H
#define _INLINE_CIA_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct cia_protosBase*  cia_protosBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME cia_protosBase
#endif

static __inline WORD 
AbleICR (BASE_PAR_DECL struct Library *resource,long mask)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct cia_protosBase* a6 __asm("a6") = BASE_NAME;
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = mask;
  __asm __volatile ("jsr a6@(-0x12)"
  : "=r" (_res)
  : "r" (a6), "r" (a6), "r" (d0)
  : "a0","a1","a6","d0","d1");
  return _res;
}
static __inline struct Interrupt *
AddICRVector (BASE_PAR_DECL struct Library *resource,long iCRBit,struct Interrupt *interrupt)
{
  BASE_EXT_DECL
  register struct Interrupt * _res  __asm("d0");
  register struct cia_protosBase* a6 __asm("a6") = BASE_NAME;
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = iCRBit;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0x6)"
  : "=r" (_res)
  : "r" (a6), "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","a6","d0","d1");
  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
RemICRVector (BASE_PAR_DECL struct Library *resource,long iCRBit,struct Interrupt *interrupt)
{
  BASE_EXT_DECL
  register struct cia_protosBase* a6 __asm("a6") = BASE_NAME;
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = iCRBit;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0xc)"
  : /* no output */
  : "r" (a6), "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","a6","d0","d1");
  *(char *)a1 = *(char *)a1;
}
static __inline WORD 
SetICR (BASE_PAR_DECL struct Library *resource,long mask)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct cia_protosBase* a6 __asm("a6") = BASE_NAME;
  register struct Library *a6 __asm("a6") = resource;
  register long d0 __asm("d0") = mask;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a6), "r" (d0)
  : "a0","a1","a6","d0","d1");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_CIA_H */
