@DATABASE "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h"
@MASTER   "gg:os-include/inline/mathieeesingtrans.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/mathieeesingtrans.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/mathieeesingtrans.h" LINK File}


@{b}#defines@{ub}

@{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 10}  @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 17}  @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 13}  @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathieeesingtrans.h/File" 14}

@ENDNODE
@NODE File "inline/mathieeesingtrans.h"
#ifndef _INLINE_MATHIEEESINGTRANS_H
#define _INLINE_MATHIEEESINGTRANS_H

#include <sys/cdefs.h>
#include <@{"inline/stubs.h" LINK "gg:doc/NDK/Guide/Include/inline/stubs.h/File"}>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define @{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 10} extern @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}*  MathIeeeSingTransBase;
#endif
#ifndef BASE_PAR_DECL
#define @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 13}
#define @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 14} void
#endif
#ifndef BASE_NAME
#define @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 17} MathIeeeSingTransBase
#endif

extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPAcos (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPAsin (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPAtan (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPCos (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPCosh (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPExp (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPFieee (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPLog (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPLog10 (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPPow (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} arg)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = arg;
  __asm __volatile ("jsr a6@@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPSin (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPSincos (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} *cosptr, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} *a0 __asm("a0") = cosptr;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPSinh (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
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
IEEESPSqrt (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
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
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPTan (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPTanh (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
IEEESPTieee (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register @{"struct MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
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

#endif /* _INLINE_MATHIEEESINGTRANS_H */
@ENDNODE
