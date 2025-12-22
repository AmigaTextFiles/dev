#ifndef FEELIN_COMPILER_H
#define FEELIN_COMPILER_H

/*
**  Compilers hidding stuff.
**  Should be included before any other Feelin include.
**
**  2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 09.01 (2005/09/28)

    Added support for AmigaOS4.

$VER: 09.00 (2005/07/27)

    Disabled 'OFFSET' macro. It was interfering with the 'OFFSET' macro defined in
    exec/initializers.h

$VER: 08.01 (2005/06/20)

    [GROG] Change version and date (2004!) for MorphOS port.

************************************************************************************************/

#ifndef __amigaos4__

#ifdef __MORPHOS__
#include <emul/emulregs.h>
#endif /* __MORPHOS__ */

#ifdef ASM
#undef ASM
#endif
#ifdef REG
#undef REG
#endif
#ifdef LREG
#undef LREG
#endif
#ifdef CONST
#undef CONST
#endif
#ifdef SAVEDS
#undef SAVEDS
#endif
#ifdef INLINE
#undef INLINE
#endif
#ifdef STDARGS
#undef STDARGS
#endif

#if defined(__VBCC__)
    #define STDARGS
    #define STACKEXT
    #define REGARGS
    #define INLINE
    #define REG(reg,arg)                        __reg(#reg) arg
#elif defined(__STORM__)
    #define STDARGS
    #define STACKEXT
    #define REGARGS
    #define SAVEDS
    #define INLINE                              inline
#elif defined(__SASC)
    #define ASM(arg)                            __asm arg
#elif defined(__GNUC__)
    #define REG(reg,arg)                        arg __asm(#reg)
    #define INLINE                              inline
#elif defined(_DCC)
    #define STDARGS                             __stkargs
    #define STACKEXT                            __stkcheck
    #define SAVEDS                              __geta4
    #define INLINE                              static
    #define REG(reg,arg)                        __##reg arg
#endif


/*** common usage ***/

#if !defined(ASM)
#define ASM(arg)                                arg
#endif
#if !defined(REG)
#define REG(reg,arg)                            register __##reg arg
#endif
#if !defined(LREG)
#define LREG(reg,arg)                           register arg
#endif
#if !defined(CONST)
#define CONST                                   const
#endif
#if !defined(SAVEDS)
#define SAVEDS                                  __saveds
#endif
#if !defined(INLINE)
#define INLINE                                  __inline
#endif
#if !defined(REGARGS)
#define REGARGS                                 __regargs
#endif
#if !defined(STDARGS)
#define STDARGS                                  __stdargs
#endif
#if !defined(STACKEXT)
#define STACKEXT                                __stackext
#endif
#if !defined(VAARGS68K)
#define VAARGS68K
#endif

/* GOFROMIEL: I've redefined SAVEDS, REG  and  ASM  for  AOS4  too,  classic
macros can be used instead of writting AOS4 specific ones */

#if defined(__MORPHOS__) || defined(__AROS__) || defined (__amigaos4__)

#undef SAVEDS   
#define SAVEDS
#undef REG
#define REG(reg,arg)                            arg
#undef ASM
#define ASM(arg)                                arg

#endif

#endif /* __amigaos4__ */

#endif /* FEELIN_COMPILER_H */
