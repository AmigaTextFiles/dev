#ifndef _INLINE_REALTIME_H
#define _INLINE_REALTIME_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct RealTimeBase * RealTimeBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME RealTimeBase
#endif

BASE_EXT_DECL0

extern __inline struct Player *
CreatePlayerA (BASE_PAR_DECL struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct Player * _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define CreatePlayer(tags...) \
  ({ struct TagItem _tags[] = { tags }; CreatePlayerA (_tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
DeletePlayer (BASE_PAR_DECL struct Player *player)
{
  BASE_EXT_DECL
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct Player *a0 __asm("a0") = player;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
ExternalSync (BASE_PAR_DECL struct Player *player,long minTime,long maxTime)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct Player *a0 __asm("a0") = player;
  register long d0 __asm("d0") = minTime;
  register long d1 __asm("d1") = maxTime;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Conductor *
FindConductor (BASE_PAR_DECL STRPTR name)
{
  BASE_EXT_DECL
  register struct Conductor * _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetPlayerAttrsA (BASE_PAR_DECL struct Player *player,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct Player *a0 __asm("a0") = player;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GetPlayerAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GetPlayerAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline APTR 
LockRealTime (BASE_PAR_DECL unsigned long lockType)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = lockType;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Conductor *
NextConductor (BASE_PAR_DECL struct Conductor *previousConductor)
{
  BASE_EXT_DECL
  register struct Conductor * _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct Conductor *a0 __asm("a0") = previousConductor;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
SetConductorState (BASE_PAR_DECL struct Player *player,unsigned long state,long time)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct Player *a0 __asm("a0") = player;
  register unsigned long d0 __asm("d0") = state;
  register long d1 __asm("d1") = time;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
SetPlayerAttrsA (BASE_PAR_DECL struct Player *player,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register struct Player *a0 __asm("a0") = player;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetPlayerAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetPlayerAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
UnlockRealTime (BASE_PAR_DECL APTR lock)
{
  BASE_EXT_DECL
  register struct RealTimeBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = lock;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_REALTIME_H */
