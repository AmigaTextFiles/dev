#ifndef _INLINE_MATHIEEEDOUBTRANS_H
#define _INLINE_MATHIEEEDOUBTRANS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct MathIEEEBase * MathIeeeDoubTransBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MathIeeeDoubTransBase
#endif

BASE_EXT_DECL0

extern __inline DOUBLE 
IEEEDPAcos (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPAsin (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPAtan (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPCos (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPCosh (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPExp (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPFieee (BASE_PAR_DECL FLOAT single)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = single;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPLog (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPLog10 (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPPow (BASE_PAR_DECL DOUBLE exp,DOUBLE arg)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d2 __asm("d2") = exp;
  register DOUBLE d0 __asm("d0") = arg;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d2), "r" (d0)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPSin (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPSincos (BASE_PAR_DECL DOUBLE *pf2,DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE *a0 __asm("a0") = pf2;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPSinh (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPSqrt (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPTan (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline DOUBLE 
IEEEDPTanh (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEEDPTieee (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_MATHIEEEDOUBTRANS_H */
