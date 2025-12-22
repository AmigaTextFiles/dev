@DATABASE "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h"
@MASTER   "gg:os-include/inline/mathieeesingbas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/mathieeesingbas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/mathieeesingbas.h" LINK File}


@{b}#defines@{ub}

@{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 10}  @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 17}  @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 13}  @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 14}

@ENDNODE
@NODE File "inline/mathieeesingbas.h"
#ifndef _INLINE_MATHIEEESINGBAS_H
#define _INLINE_MATHIEEESINGBAS_H

#include <sys/cdefs.h>
#include <@{"inline/stubs.h" LINK "gg:doc/NDK/Guide/Include/inline/stubs.h/File"}>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define @{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 10} extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}*  MathIeeeSingBasBase;
#endif
#ifndef BASE_PAR_DECL
#define @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 13}
#define @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 14} void
#endif
#ifndef BASE_NAME
#define @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 17} MathIeeeSingBasBase
#endif

extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPAbs (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPAdd (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = leftParm;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPCeil (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
IEEESPCmp (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = leftParm;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPDiv (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} dividend, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} divisor)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = dividend;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = divisor;
  __asm __volatile ("jsr a6@@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
IEEESPFix (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPFloor (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPFlt (@{"BASE_PAR_DECL" LINK File 13}  long integer)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  long d0 __asm("d0") = integer;
  __asm __volatile ("jsr a6@@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPMul (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = leftParm;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPNeg (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPSub (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = leftParm;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = rightParm;
  __asm __volatile ("jsr a6@@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
IEEESPTst (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
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

#endif /* _INLINE_MATHIEEESINGBAS_H */
@ENDNODE
