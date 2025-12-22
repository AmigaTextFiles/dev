#ifndef _INLINE_COLORWHEEL_H
#define _INLINE_COLORWHEEL_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * ColorWheelBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME ColorWheelBase
#endif

BASE_EXT_DECL0

extern __inline void 
ConvertHSBToRGB (BASE_PAR_DECL struct ColorWheelHSB *hsb,struct ColorWheelRGB *rgb)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct ColorWheelHSB *a0 __asm("a0") = hsb;
  register struct ColorWheelRGB *a1 __asm("a1") = rgb;
  __asm __volatile ("jsr a6@(-0x1e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ConvertRGBToHSB (BASE_PAR_DECL struct ColorWheelRGB *rgb,struct ColorWheelHSB *hsb)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct ColorWheelRGB *a0 __asm("a0") = rgb;
  register struct ColorWheelHSB *a1 __asm("a1") = hsb;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_COLORWHEEL_H */
