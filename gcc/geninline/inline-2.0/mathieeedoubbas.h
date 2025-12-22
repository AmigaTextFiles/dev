#ifndef _INLINE_MATHIEEEDOUBBAS_H
#define _INLINE_MATHIEEEDOUBBAS_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct MathIeeeDoubBasBase*  MathIeeeDoubBasBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MathIeeeDoubBasBase
#endif

static __inline DOUBLE 
IEEEDPAbs (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline DOUBLE 
IEEEDPAdd (BASE_PAR_DECL DOUBLE leftParm,DOUBLE rightParm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = leftParm;
  register DOUBLE d2 __asm("d2") = rightParm;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline DOUBLE 
IEEEDPCeil (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
IEEEDPCmp (BASE_PAR_DECL DOUBLE leftParm,DOUBLE rightParm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = leftParm;
  register DOUBLE d2 __asm("d2") = rightParm;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline DOUBLE 
IEEEDPDiv (BASE_PAR_DECL DOUBLE dividend,DOUBLE divisor)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = dividend;
  register DOUBLE d2 __asm("d2") = divisor;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
IEEEDPFix (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline DOUBLE 
IEEEDPFloor (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline DOUBLE 
IEEEDPFlt (BASE_PAR_DECL long integer)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = integer;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline DOUBLE 
IEEEDPMul (BASE_PAR_DECL DOUBLE factor1,DOUBLE factor2)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = factor1;
  register DOUBLE d2 __asm("d2") = factor2;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline DOUBLE 
IEEEDPNeg (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline DOUBLE 
IEEEDPSub (BASE_PAR_DECL DOUBLE leftParm,DOUBLE rightParm)
{
  BASE_EXT_DECL
  register DOUBLE  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = leftParm;
  register DOUBLE d2 __asm("d2") = rightParm;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline LONG 
IEEEDPTst (BASE_PAR_DECL DOUBLE parm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathIeeeDoubBasBase* a6 __asm("a6") = BASE_NAME;
  register DOUBLE d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x30)"
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

#endif /* _INLINE_MATHIEEEDOUBBAS_H */
