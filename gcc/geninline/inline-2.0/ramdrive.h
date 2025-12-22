#ifndef _INLINE_RAMDRIVE_H
#define _INLINE_RAMDRIVE_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct RamdriveDevice*  RamdriveDevice;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME RamdriveDevice
#endif

static __inline STRPTR 
KillRAD (BASE_PAR_DECL unsigned long unit)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct RamdriveDevice* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = unit;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline STRPTR 
KillRAD0 (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct RamdriveDevice* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x2a)"
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

#endif /* _INLINE_RAMDRIVE_H */
