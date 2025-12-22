#ifndef _INLINE_DISK_H
#define _INLINE_DISK_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct DiskBase*  DiskBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME DiskBase
#endif

static __inline BOOL 
AllocUnit (BASE_PAR_DECL long unitNum)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct DiskBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = unitNum;
  __asm __volatile ("jsr a6@(-0x6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
FreeUnit (BASE_PAR_DECL long unitNum)
{
  BASE_EXT_DECL
  register struct DiskBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = unitNum;
  __asm __volatile ("jsr a6@(-0xc)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
}
static __inline struct DiskResourceUnit *
GetUnit (BASE_PAR_DECL struct DiskResourceUnit *unitPointer)
{
  BASE_EXT_DECL
  register struct DiskResourceUnit * _res  __asm("d0");
  register struct DiskBase* a6 __asm("a6") = BASE_NAME;
  register struct DiskResourceUnit *a1 __asm("a1") = unitPointer;
  __asm __volatile ("jsr a6@(-0x12)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
GetUnitID (BASE_PAR_DECL long unitNum)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DiskBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = unitNum;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
GiveUnit (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct DiskBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x18)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1");
}
static __inline LONG 
ReadUnitID (BASE_PAR_DECL long unitNum)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct DiskBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = unitNum;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_DISK_H */
