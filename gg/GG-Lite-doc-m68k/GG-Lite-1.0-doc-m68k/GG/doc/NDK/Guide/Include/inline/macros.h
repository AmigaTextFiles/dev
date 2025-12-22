@DATABASE "gg:doc/NDK/Guide/Include/inline/macros.h"
@MASTER   "gg:os-include/inline/macros.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:15
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/macros.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/macros.h" LINK File}


@{b}Typedefs@{ub}

@{"fpt" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 131}


@{b}#defines@{ub}

@{"LP0()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}      @{"LP0NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}    @{"LP1()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}    @{"LP10()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 824}     @{"LP10NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 861}  @{"LP11()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 897}
@{"LP1A5()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 92}    @{"LP1A5FP()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 129}  @{"LP1NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}  @{"LP1NRA5()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 111}  @{"LP2()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}     @{"LP2FP()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 208}
@{"LP2NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}    @{"LP2UB()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 188}    @{"LP3()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}    @{"LP3FP()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 316}    @{"LP3NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}   @{"LP3NRFP()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 340}
@{"LP3NRUB()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 295}  @{"LP3UB()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 273}    @{"LP4()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}    @{"LP4FP()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 410}    @{"LP4NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 386}   @{"LP5()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}
@{"LP5A4()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 515}    @{"LP5FP()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 487}    @{"LP5NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 461}  @{"LP6()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 541}      @{"LP6NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 569}   @{"LP7()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 596}
@{"LP7A4()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 656}    @{"LP7NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 626}    @{"LP8()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 690}    @{"LP8NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 723}    @{"LP9()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 755}     @{"LP9NR()" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 790}

@ENDNODE
@NODE File "inline/macros.h"
#ifndef __INLINE_MACROS_H
#define __INLINE_MACROS_H

/*
   General macros for Amiga function calls. Not all the possibilities have
   been created - only the ones which exist in OS 3.1. Third party libraries
   and future versions of AmigaOS will maybe need some new ones...

   LPX - functions that take X arguments.

   Modifiers (variations are possible):
   NR - no return (void),
   A4, A5 - "a4" or "a5" is used as one of the arguments,
   UB - base will be given explicitly by user (see @{"cia.resource" LINK "gg:doc/NDK/Guide/cia/MAIN"}).
   FP - one of the parameters has type "pointer to function".

   "bt" arguments are not used - they are provided for backward compatibility
   only.
*/

#ifndef __INLINE_STUB_H
#include <@{"inline/stubs.h" LINK "gg:doc/NDK/Guide/Include/inline/stubs.h/File"}>
#endif

#define LP0(offs, rt, name, bt, bn)                             \\
({                                                              \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn)                                      \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP0NR(offs, name, bt, bn)                               \\
({                                                              \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn)                                      \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

#define LP1(offs, rt, name, t1, v1, r1, bt, bn)                 \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1)                           \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP1NR(offs, name, t1, v1, r1, bt, bn)                   \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1)                           \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"graphics.library/AttemptLockLayerRom()" LINK "gg:doc/NDK/Guide/graphics/AttemptLockLayerRom"} */
#define LP1A5(offs, rt, name, t1, v1, r1, bt, bn)               \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      __asm volatile ("exg d7,a5\\n\\tjsr a6@@(-"#offs":W)\\n\\texg d7,a5" \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1)                           \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Only @{"graphics.library/LockLayerRom()" LINK "gg:doc/NDK/Guide/graphics/LockLayerRom"} and @{"graphics.library/UnlockLayerRom()" LINK "gg:doc/NDK/Guide/graphics/UnlockLayerRom"} */
#define LP1NRA5(offs, name, t1, v1, r1, bt, bn)                 \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      __asm volatile ("exg d7,a5\\n\\tjsr a6@@(-"#offs":W)\\n\\texg d7,a5" \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1)                           \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"exec.library/Supervisor()" LINK "gg:doc/NDK/Guide/exec/Supervisor"} */
#define LP1A5FP(offs, rt, name, t1, v1, r1, bt, bn, @{"fpt" LINK File 131})        \\
({                                                              \\
   typedef @{"fpt" LINK "File" 210};                                                 \\
   t1 _##name##_v1 = (v1);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      __asm volatile ("exg d7,a5\\n\\tjsr a6@@(-"#offs":W)\\n\\texg d7,a5" \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1)                           \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP2(offs, rt, name, t1, v1, r1, t2, v2, r2, bt, bn)     \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2)                \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP2NR(offs, name, t1, v1, r1, t2, v2, r2, bt, bn)       \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2)                \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"cia.resource/AbleICR()" LINK "gg:doc/NDK/Guide/cia/AbleICR"} and @{"cia.resource/SetICR()" LINK "gg:doc/NDK/Guide/cia/SetICR"} */
#define LP2UB(offs, rt, name, t1, v1, r1, t2, v2, r2)           \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r"(_n1), "rf"(_n2)                                     \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Only @{"dos.library/InternalUnLoadSeg()" LINK "gg:doc/NDK/Guide/dos/InternalUnLoadSeg"} */
#define LP2FP(offs, rt, name, t1, v1, r1, t2, v2, r2, bt, bn, @{"fpt" LINK File 131}) \\
({                                                              \\
   typedef @{"fpt" LINK "File" 318};                                                 \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2)                \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP3(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3)     \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP3NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3)     \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"cia.resource/AddICRVector()" LINK "gg:doc/NDK/Guide/cia/AddICRVector"} */
#define LP3UB(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r"(_n1), "rf"(_n2), "rf"(_n3)                          \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Only @{"cia.resource/RemICRVector()" LINK "gg:doc/NDK/Guide/cia/RemICRVector"} */
#define LP3NRUB(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r"(_n1), "rf"(_n2), "rf"(_n3)                          \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"exec.library/SetFunction()" LINK "gg:doc/NDK/Guide/exec/SetFunction"} */
#define LP3FP(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, bt, bn, @{"fpt" LINK File 131}) \\
({                                                              \\
   typedef @{"fpt" LINK "File" 342};                                                 \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3)     \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Only @{"graphics.library/SetCollision()" LINK "gg:doc/NDK/Guide/graphics/SetCollision"} */
#define LP3NRFP(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, bt, bn, @{"fpt" LINK File 131}) \\
({                                                              \\
   typedef @{"fpt" LINK "File" 412};                                                 \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3)     \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

#define LP4(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP4NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"exec.library/RawDoFmt()" LINK "gg:doc/NDK/Guide/exec/RawDoFmt"} */
#define LP4FP(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, bt, bn, @{"fpt" LINK File 131}) \\
({                                                              \\
   typedef @{"fpt" LINK "File" 489};                                                 \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP5(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP5NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"exec.library/MakeLibrary()" LINK "gg:doc/NDK/Guide/exec/MakeLibrary"} */
#define LP5FP(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, bt, bn, @{"fpt" LINK File 131}) \\
({                                                              \\
   typedef @{"fpt" LINK "File" 131};                                                 \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Only reqtools.library/XXX() */
#define LP5A4(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      __asm volatile ("exg d7,a4\\n\\tjsr a6@@(-"#offs":W)\\n\\texg d7,a4" \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP6(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP6NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

#define LP7(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#define LP7NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"workbench.library/AddAppIconA()" LINK "gg:doc/NDK/Guide/wb/AddAppIconA"} */
#define LP7A4(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      __asm volatile ("exg d7,a4\\n\\tjsr a6@@(-"#offs":W)\\n\\texg d7,a4" \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Would you believe that there really are beasts that need more than 7
   arguments? :-) */

/* For example @{"intuition.library/AutoRequest()" LINK "gg:doc/NDK/Guide/intuition/AutoRequest"} */
#define LP8(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* For example @{"intuition.library/ModifyProp()" LINK "gg:doc/NDK/Guide/intuition/ModifyProp"} */
#define LP8NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* For example @{"layers.library/CreateUpfrontHookLayer()" LINK "gg:doc/NDK/Guide/layers/CreateUpfrontHookLayer"} */
#define LP9(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, t9, v9, r9, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   t9 _##name##_v9 = (v9);                                      \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      register t9 _n9 __asm(#r9) = _##name##_v9;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8), "rf"(_n9) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* For example @{"intuition.library/NewModifyProp()" LINK "gg:doc/NDK/Guide/intuition/NewModifyProp"} */
#define LP9NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, t9, v9, r9, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   t9 _##name##_v9 = (v9);                                      \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      register t9 _n9 __asm(#r9) = _##name##_v9;                \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8), "rf"(_n9) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Kriton Kyrimis <kyrimis@@cti.gr> says CyberGraphics needs the following */
#define LP10(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, t9, v9, r9, t10, v10, r10, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   t9 _##name##_v9 = (v9);                                      \\
   t10 _##name##_v10 = (v10);                                   \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      register t9 _n9 __asm(#r9) = _##name##_v9;                \\
      register t10 _n10 __asm(#r10) = _##name##_v10;            \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8), "rf"(_n9), "rf"(_n10) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

/* Only @{"graphics.library/BltMaskBitMapRastPort()" LINK "gg:doc/NDK/Guide/graphics/BltMaskBitMapRastPort"} */
#define LP10NR(offs, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, t9, v9, r9, t10, v10, r10, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   t9 _##name##_v9 = (v9);                                      \\
   t10 _##name##_v10 = (v10);                                   \\
   {                                                            \\
      register int _d0 __asm("d0");                             \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      register t9 _n9 __asm(#r9) = _##name##_v9;                \\
      register t10 _n10 __asm(#r10) = _##name##_v10;            \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_d0), "=r" (_d1), "=r" (_a0), "=r" (_a1)          \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8), "rf"(_n9), "rf"(_n10) \\
      : "fp0", "fp1", "cc", "memory");                          \\
   }                                                            \\
})

/* Only @{"graphics.library/BltBitMap()" LINK "gg:doc/NDK/Guide/graphics/BltBitMap"} */
#define LP11(offs, rt, name, t1, v1, r1, t2, v2, r2, t3, v3, r3, t4, v4, r4, t5, v5, r5, t6, v6, r6, t7, v7, r7, t8, v8, r8, t9, v9, r9, t10, v10, r10, t11, v11, r11, bt, bn) \\
({                                                              \\
   t1 _##name##_v1 = (v1);                                      \\
   t2 _##name##_v2 = (v2);                                      \\
   t3 _##name##_v3 = (v3);                                      \\
   t4 _##name##_v4 = (v4);                                      \\
   t5 _##name##_v5 = (v5);                                      \\
   t6 _##name##_v6 = (v6);                                      \\
   t7 _##name##_v7 = (v7);                                      \\
   t8 _##name##_v8 = (v8);                                      \\
   t9 _##name##_v9 = (v9);                                      \\
   t10 _##name##_v10 = (v10);                                   \\
   t11 _##name##_v11 = (v11);                                   \\
   ({                                                           \\
      register int _d1 __asm("d1");                             \\
      register int _a0 __asm("a0");                             \\
      register int _a1 __asm("a1");                             \\
      register rt _##name##_re __asm("d0");                     \\
      register void *const _##name##_bn __asm("a6") = (bn);     \\
      register t1 _n1 __asm(#r1) = _##name##_v1;                \\
      register t2 _n2 __asm(#r2) = _##name##_v2;                \\
      register t3 _n3 __asm(#r3) = _##name##_v3;                \\
      register t4 _n4 __asm(#r4) = _##name##_v4;                \\
      register t5 _n5 __asm(#r5) = _##name##_v5;                \\
      register t6 _n6 __asm(#r6) = _##name##_v6;                \\
      register t7 _n7 __asm(#r7) = _##name##_v7;                \\
      register t8 _n8 __asm(#r8) = _##name##_v8;                \\
      register t9 _n9 __asm(#r9) = _##name##_v9;                \\
      register t10 _n10 __asm(#r10) = _##name##_v10;            \\
      register t11 _n11 __asm(#r11) = _##name##_v11;            \\
      __asm volatile ("jsr a6@@(-"#offs":W)"                     \\
      : "=r" (_##name##_re), "=r" (_d1), "=r" (_a0), "=r" (_a1) \\
      : "r" (_##name##_bn), "rf"(_n1), "rf"(_n2), "rf"(_n3), "rf"(_n4), "rf"(_n5), "rf"(_n6), "rf"(_n7), "rf"(_n8), "rf"(_n9), "rf"(_n10), "rf"(_n11) \\
      : "fp0", "fp1", "cc", "memory");                          \\
      _##name##_re;                                             \\
   });                                                          \\
})

#endif /* __INLINE_MACROS_H */
@ENDNODE
