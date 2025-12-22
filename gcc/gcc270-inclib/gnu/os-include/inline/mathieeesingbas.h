#ifndef _INLINE_MATHIEEESINGBAS_H
#define _INLINE_MATHIEEESINGBAS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct MathIEEEBase * MathIeeeSingBasBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MathIeeeSingBasBase
#endif

BASE_EXT_DECL0

extern __inline FLOAT 
IEEESPAbs (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPAdd (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = leftParm;
  register FLOAT d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPCeil (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
IEEESPCmp (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = leftParm;
  register FLOAT d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPDiv (BASE_PAR_DECL FLOAT dividend,FLOAT divisor)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = dividend;
  register FLOAT d1 __asm("d1") = divisor;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
IEEESPFix (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPFloor (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPFlt (BASE_PAR_DECL long integer)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = integer;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPMul (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = leftParm;
  register FLOAT d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPNeg (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline FLOAT 
IEEESPSub (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = leftParm;
  register FLOAT d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
IEEESPTst (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathIEEEBase *a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x30)"
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

#endif /* _INLINE_MATHIEEESINGBAS_H */
