#ifndef _INLINE_MATHTRANS_H
#define _INLINE_MATHTRANS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct MathTransBase*  MathTransBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MathTransBase
#endif

static __inline FLOAT 
SPAcos (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPAsin (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPAtan (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPCos (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPCosh (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPExp (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPFieee (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPLog (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPLog10 (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPPow (BASE_PAR_DECL FLOAT power,FLOAT arg)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = power;
  register FLOAT d0 __asm("d0") = arg;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPSin (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPSincos (BASE_PAR_DECL FLOAT *cosResult,FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT *d1 __asm("d1") = cosResult;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPSinh (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPSqrt (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPTan (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPTanh (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPTieee (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_MATHTRANS_H */
