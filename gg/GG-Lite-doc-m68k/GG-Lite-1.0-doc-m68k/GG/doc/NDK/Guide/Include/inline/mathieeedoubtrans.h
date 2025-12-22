@DATABASE "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h"
@MASTER   "gg:os-include/inline/mathieeedoubtrans.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/mathieeedoubtrans.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/mathieeedoubtrans.h" LINK File}


@{b}#defines@{ub}

@{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 10}  @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 17}  @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 13}  @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeedoubtrans.h/File" 14}

@ENDNODE
@NODE File "inline/mathieeedoubtrans.h"
#ifndef _INLINE_MATHIEEEDOUBTRANS_H
#define _INLINE_MATHIEEEDOUBTRANS_H

#include <sys/cdefs.h>
#include <@{"inline/stubs.h" LINK "gg:doc/NDK/Guide/Include/inline/stubs.h/File"}>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define @{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 10} extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}*  MathIeeeDoubTransBase;
#endif
#ifndef BASE_PAR_DECL
#define @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 13}
#define @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 14} void
#endif
#ifndef BASE_NAME
#define @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingbas.h/File" 17} MathIeeeDoubTransBase
#endif

extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPAcos (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPAsin (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPAtan (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPCos (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPCosh (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPExp (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPFieee (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} single)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = single;
  __asm __volatile ("jsr a6@@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPLog (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPLog10 (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPPow (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} arg)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d2 __asm("d2") = @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = arg;
  __asm __volatile ("jsr a6@@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d2), "r" (d0)
  : "a0","a1","d0","d1","d2","d3", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPSin (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPSincos (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} *pf2, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} *a0 __asm("a0") = pf2;
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPSinh (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
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
IEEEDPSqrt (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
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
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPTan (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}
IEEEDPTanh (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEEDPTieee (@{"BASE_PAR_DECL" LINK File 13}  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x66)"
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

#endif /* _INLINE_MATHIEEEDOUBTRANS_H */
@ENDNODE
