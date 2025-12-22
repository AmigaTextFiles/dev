@DATABASE "gg:doc/NDK/Guide/Include/inline/mathtrans.h"
@MASTER   "gg:os-include/inline/mathtrans.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/mathtrans.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/mathtrans.h" LINK File}


@{b}#defines@{ub}

@{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 10}  @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 17}  @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 13}  @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathtrans.h/File" 14}

@ENDNODE
@NODE File "inline/mathtrans.h"
#ifndef _INLINE_MATHTRANS_H
#define _INLINE_MATHTRANS_H

#include <sys/cdefs.h>
#include <@{"inline/stubs.h" LINK "gg:doc/NDK/Guide/Include/inline/stubs.h/File"}>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define @{"BASE_EXT_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathffp.h/File" 10} extern struct MathTransBase*  MathTransBase;
#endif
#ifndef BASE_PAR_DECL
#define @{"BASE_PAR_DECL" LINK "gg:doc/NDK/Guide/Include/inline/mathffp.h/File" 13}
#define @{"BASE_PAR_DECL0" LINK "gg:doc/NDK/Guide/Include/inline/mathffp.h/File" 14} void
#endif
#ifndef BASE_NAME
#define @{"BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/mathffp.h/File" 17} MathTransBase
#endif

extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPAcos (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPAsin (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPAtan (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPCos (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPCosh (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPExp (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPFieee (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPLog (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPLog10 (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPPow (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} power, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} arg)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d1 __asm("d1") = power;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = arg;
  __asm __volatile ("jsr a6@@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPSin (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPSincos (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} *cosResult, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} *d1 __asm("d1") = cosResult;
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPSinh (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPSqrt (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPTan (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPTanh (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
  register  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} d0 __asm("d0") = parm;
  __asm __volatile ("jsr a6@@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}
SPTieee (@{"BASE_PAR_DECL" LINK File 13}  @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm)
{
  @{"BASE_EXT_DECL" LINK File 10}
  register @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89}  _res  __asm("d0");
  register struct MathTransBase* a6 __asm("a6") = @{"BASE_NAME" LINK File 17};
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

#endif /* _INLINE_MATHTRANS_H */
@ENDNODE
