#ifndef _INLINE_MATHFFP_H
#define _INLINE_MATHFFP_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct MathBase*  MathBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MathBase
#endif

static __inline FLOAT 
SPAbs (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPAdd (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = leftParm;
  register FLOAT d0 __asm("d0") = rightParm;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPCeil (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline LONG 
SPCmp (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = leftParm;
  register FLOAT d0 __asm("d0") = rightParm;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPDiv (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = leftParm;
  register FLOAT d0 __asm("d0") = rightParm;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline LONG 
SPFix (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPFloor (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPFlt (BASE_PAR_DECL long integer)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = integer;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPMul (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = leftParm;
  register FLOAT d0 __asm("d0") = rightParm;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPNeg (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline FLOAT 
SPSub (BASE_PAR_DECL FLOAT leftParm,FLOAT rightParm)
{
  BASE_EXT_DECL
  register FLOAT  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = leftParm;
  register FLOAT d0 __asm("d0") = rightParm;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
static __inline LONG 
SPTst (BASE_PAR_DECL FLOAT parm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct MathBase* a6 __asm("a6") = BASE_NAME;
  register FLOAT d1 __asm("d1") = parm;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_MATHFFP_H */
