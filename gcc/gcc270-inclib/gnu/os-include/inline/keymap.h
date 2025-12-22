#ifndef _INLINE_KEYMAP_H
#define _INLINE_KEYMAP_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * KeymapBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME KeymapBase
#endif

BASE_EXT_DECL0

extern __inline struct KeyMap *
AskKeyMapDefault (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct KeyMap * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
MapANSI (BASE_PAR_DECL STRPTR string,long count,STRPTR buffer,long length,struct KeyMap *keyMap)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = string;
  register long d0 __asm("d0") = count;
  register STRPTR a1 __asm("a1") = buffer;
  register long d1 __asm("d1") = length;
  register struct KeyMap *a2 __asm("a2") = keyMap;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1), "r" (d1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline WORD 
MapRawKey (BASE_PAR_DECL struct InputEvent *event,STRPTR buffer,long length,struct KeyMap *keyMap)
{
  BASE_EXT_DECL
  register WORD  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct InputEvent *a0 __asm("a0") = event;
  register STRPTR a1 __asm("a1") = buffer;
  register long d1 __asm("d1") = length;
  register struct KeyMap *a2 __asm("a2") = keyMap;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetKeyMapDefault (BASE_PAR_DECL struct KeyMap *keyMap)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct KeyMap *a0 __asm("a0") = keyMap;
  __asm __volatile ("jsr a6@(-0x1e)"
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

#endif /* _INLINE_KEYMAP_H */
