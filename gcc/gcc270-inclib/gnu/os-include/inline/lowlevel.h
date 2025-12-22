#ifndef _INLINE_LOWLEVEL_H
#define _INLINE_LOWLEVEL_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * LowLevelBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME LowLevelBase
#endif

BASE_EXT_DECL0

extern __inline APTR 
AddKBInt (BASE_PAR_DECL APTR intRoutine,APTR intData)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = intRoutine;
  register APTR a1 __asm("a1") = intData;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AddTimerInt (BASE_PAR_DECL APTR intRoutine,APTR intData)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = intRoutine;
  register APTR a1 __asm("a1") = intData;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AddVBlankInt (BASE_PAR_DECL APTR intRoutine,APTR intData)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = intRoutine;
  register APTR a1 __asm("a1") = intData;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
ElapsedTime (BASE_PAR_DECL struct EClockVal *context)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct EClockVal *a0 __asm("a0") = context;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetKey (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UBYTE 
GetLanguageSelection (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
QueryKeys (BASE_PAR_DECL struct KeyQuery *queryArray,unsigned long arraySize)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct KeyQuery *a0 __asm("a0") = queryArray;
  register unsigned long d1 __asm("d1") = arraySize;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
ReadJoyPort (BASE_PAR_DECL unsigned long port)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = port;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
RemKBInt (BASE_PAR_DECL APTR intHandle)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = intHandle;
  __asm __volatile ("jsr a6@(-0x42)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemTimerInt (BASE_PAR_DECL APTR intHandle)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = intHandle;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemVBlankInt (BASE_PAR_DECL APTR intHandle)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = intHandle;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
SetJoyPortAttrsA (BASE_PAR_DECL unsigned long portNumber,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = portNumber;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetJoyPortAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetJoyPortAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
StartTimerInt (BASE_PAR_DECL APTR intHandle,unsigned long timeInterval,long continuous)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = intHandle;
  register unsigned long d0 __asm("d0") = timeInterval;
  register long d1 __asm("d1") = continuous;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
StopTimerInt (BASE_PAR_DECL APTR intHandle)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = intHandle;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
SystemControlA (BASE_PAR_DECL struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SystemControl(tags...) \
  ({ struct TagItem _tags[] = { tags }; SystemControlA (_tags); })
#endif /* not NO_INLINE_STDARG */

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_LOWLEVEL_H */
