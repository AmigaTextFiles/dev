@DATABASE "gg:doc/NDK/Guide/Include/inline/mathieeedoubbas.h"
@MASTER   "gg:os-include/inline/mathieeedoubbas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:27
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/mathieeedoubbas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/mathieeedoubbas.h" LINK File}


@{b}#defines@{ub}

@{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubbas.h/File" 10}  @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubbas.h/File" 17}  @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubbas.h/File" 13}  @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubbas.h/File" 14}

@ENDNODE
@NODE File "inline/mathieeedoubbas.h"
#ifndef _INLINE_MATHIEEEDOUBBAS_H
#define _INLINE_MATHIEEEDOUBBAS_H

#include <sys/cdefs.h>
#include <@{"inline/stubs.h" LINK "gg:doc/NDK/Guide/Include/inline/stubs.h/File"}>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define @{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 10} extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}*  MathIeeeDoubBasBase;
#endif
#ifndef BASE_PAR_DECL
#define @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 13}
#define @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 14} void
#endif
#ifndef BASE_NAME
#define @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 17} MathIeeeDoubBasBase
#endif

extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPAbs (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPAdd (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} leftParm, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = leftParm;
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d2 __asm("d2") = rightParm;
  __asm __volatile ("jsr a6@@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPCeil (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
IEEEDPCmp (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} leftParm, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = leftParm;
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d2 __asm("d2") = rightParm;
  __asm __volatile ("jsr a6@@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPDiv (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} dividend, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} divisor)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = dividend;
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d2 __asm("d2") = divisor;
  __asm __volatile ("jsr a6@@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
IEEEDPFix (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPFloor (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPFlt (@{"BASE_PAR_DECL" LINK File 13}  long integer)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  long d0 __asm("d0") = integer;
  __asm __volatile ("jsr a6@@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPMul (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} factor1, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} factor2)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = factor1;
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d2 __asm("d2") = factor2;
  __asm __volatile ("jsr a6@@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPNeg (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPSub (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} leftParm, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = leftParm;
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d2 __asm("d2") = rightParm;
  __asm __volatile ("jsr a6@@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d2)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
IEEEDPTst (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x30)"
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

#endif /* _INLINE_MATHIEEEDOUBBAS_H */
@ENDNODE
