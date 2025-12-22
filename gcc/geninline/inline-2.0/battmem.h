#ifndef _INLINE_BATTMEM_H
#define _INLINE_BATTMEM_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct BattMemBase*  BattMemBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME BattMemBase
#endif

static __inline void 
ObtainBattSemaphore (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct BattMemBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x6)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1");
}
static __inline ULONG 
ReadBattMem (BASE_PAR_DECL APTR buffer,unsigned long offset,unsigned long length)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct BattMemBase* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = buffer;
  register unsigned long d0 __asm("d0") = offset;
  register unsigned long d1 __asm("d1") = length;
  __asm __volatile ("jsr a6@(-0x12)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
ReleaseBattSemaphore (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct BattMemBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xc)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1");
}
static __inline ULONG 
WriteBattMem (BASE_PAR_DECL APTR buffer,unsigned long offset,unsigned long length)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct BattMemBase* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = buffer;
  register unsigned long d0 __asm("d0") = offset;
  register unsigned long d1 __asm("d1") = length;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_BATTMEM_H */
