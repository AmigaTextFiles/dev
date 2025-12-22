#ifndef _INLINE_BULLET_H
#define _INLINE_BULLET_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * BulletBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME BulletBase
#endif

BASE_EXT_DECL0

extern __inline void 
CloseEngine (BASE_PAR_DECL struct GlyphEngine *glyphEngine)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct GlyphEngine *a0 __asm("a0") = glyphEngine;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
ObtainInfoA (BASE_PAR_DECL struct GlyphEngine *glyphEngine,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct GlyphEngine *a0 __asm("a0") = glyphEngine;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define ObtainInfo(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; ObtainInfoA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct GlyphEngine *
OpenEngine (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct GlyphEngine * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
ReleaseInfoA (BASE_PAR_DECL struct GlyphEngine *glyphEngine,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct GlyphEngine *a0 __asm("a0") = glyphEngine;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define ReleaseInfo(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; ReleaseInfoA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
SetInfoA (BASE_PAR_DECL struct GlyphEngine *glyphEngine,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct GlyphEngine *a0 __asm("a0") = glyphEngine;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetInfo(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetInfoA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_BULLET_H */
