#ifndef _INLINE_BATTCLOCK_H
#define _INLINE_BATTCLOCK_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct BattClockBase*  BattClockBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME BattClockBase
#endif

static __inline ULONG 
ReadBattClock (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct BattClockBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0xc)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
ResetBattClock (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct BattClockBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x6)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1");
}
static __inline void 
WriteBattClock (BASE_PAR_DECL unsigned long time)
{
  BASE_EXT_DECL
  register struct BattClockBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = time;
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

#endif /* _INLINE_BATTCLOCK_H */
