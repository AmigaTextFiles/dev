#ifndef _INLINE_TIMER_H
#define _INLINE_TIMER_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct Device * TimerBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME TimerBase
#endif

static __inline void 
AddTime (BASE_PAR_DECL struct timeval *dest,struct timeval *src)
{
  BASE_EXT_DECL
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct timeval *a0 __asm("a0") = dest;
  register struct timeval *a1 __asm("a1") = src;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline LONG 
CmpTime (BASE_PAR_DECL struct timeval *dest,struct timeval *src)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct timeval *a0 __asm("a0") = dest;
  register struct timeval *a1 __asm("a1") = src;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
GetSysTime (BASE_PAR_DECL struct timeval *dest)
{
  BASE_EXT_DECL
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct timeval *a0 __asm("a0") = dest;
  __asm __volatile ("jsr a6@(-0x48)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline ULONG 
ReadEClock (BASE_PAR_DECL struct EClockVal *dest)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct EClockVal *a0 __asm("a0") = dest;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
SubTime (BASE_PAR_DECL struct timeval *dest,struct timeval *src)
{
  BASE_EXT_DECL
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct timeval *a0 __asm("a0") = dest;
  register struct timeval *a1 __asm("a1") = src;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_TIMER_H */
