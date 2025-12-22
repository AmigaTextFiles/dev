#ifndef _INLINE_DISKFONT_H
#define _INLINE_DISKFONT_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct Library * DiskfontBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME DiskfontBase
#endif

static __inline LONG 
AvailFonts (BASE_PAR_DECL STRPTR buffer,long bufBytes,long flags)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = buffer;
  register long d0 __asm("d0") = bufBytes;
  register long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
DisposeFontContents (BASE_PAR_DECL struct FontContentsHeader *fontContentsHeader)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct FontContentsHeader *a1 __asm("a1") = fontContentsHeader;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a1 = *(char *)a1;
}
static __inline struct FontContentsHeader *
NewFontContents (BASE_PAR_DECL BPTR fontsLock,STRPTR fontName)
{
  BASE_EXT_DECL
  register struct FontContentsHeader * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register BPTR a0 __asm("a0") = fontsLock;
  register STRPTR a1 __asm("a1") = fontName;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct DiskFontHeader *
NewScaledDiskFont (BASE_PAR_DECL struct TextFont *sourceFont,struct TextAttr *destTextAttr)
{
  BASE_EXT_DECL
  register struct DiskFontHeader * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TextFont *a0 __asm("a0") = sourceFont;
  register struct TextAttr *a1 __asm("a1") = destTextAttr;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct TextFont *
OpenDiskFont (BASE_PAR_DECL struct TextAttr *textAttr)
{
  BASE_EXT_DECL
  register struct TextFont * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct TextAttr *a0 __asm("a0") = textAttr;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_DISKFONT_H */
