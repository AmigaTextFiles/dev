#ifndef _INLINE_MATHIEEESINGTRANS_H
#define _INLINE_MATHIEEESINGTRANS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct MathIeeeSingTransBase*  MathIeeeSingTransBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MathIeeeSingTransBase
#endif

static __inline FLOAT 
IEEESPAcos (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPAsin (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPAtan (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPCos (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPCosh (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPExp (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPFieee (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPLog (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPLog10 (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPPow (BASE_PAR_DECL FLOAT exp,FLOAT arg)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = exp;
  register FLOAT d0 __asm("d0") = arg;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPSin (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPSincos (BASE_PAR_DECL FLOAT *cosptr,FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT *a0 __asm("a0") = cosptr;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline FLOAT 
IEEESPSinh (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPSqrt (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPTan (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPTanh (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline FLOAT 
IEEESPTieee (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIeeeSingTransBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_MATHIEEESINGTRANS_H */
