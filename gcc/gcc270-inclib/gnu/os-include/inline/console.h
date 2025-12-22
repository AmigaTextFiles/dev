#ifndef _INLINE_CONSOLE_H
#define _INLINE_CONSOLE_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Device * ConsoleDevice;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME ConsoleDevice
#endif

BASE_EXT_DECL0

extern __inline struct InputEvent *
CDInputHandler (BASE_PAR_DECL struct InputEvent *events,struct Library *consoleDevice)
{
  BASE_EXT_DECL
  register struct InputEvent * _res  __asm("d0");
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct InputEvent *a0 __asm("a0") = events;
  register struct Library *a1 __asm("a1") = consoleDevice;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
RawKeyConvert (BASE_PAR_DECL struct InputEvent *events,STRPTR buffer,long length,struct KeyMap *keyMap)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Device *a6 __asm("a6") = BASE_NAME;
  register struct InputEvent *a0 __asm("a0") = events;
  register STRPTR a1 __asm("a1") = buffer;
  register long d1 __asm("d1") = length;
  register struct KeyMap *a2 __asm("a2") = keyMap;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_CONSOLE_H */
