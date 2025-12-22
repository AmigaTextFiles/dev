/*
**      $VER: compiler.h 37.32 (12.5.98)
**
**      Compiler independent register (and SAS/C extensions) handling
**
**      (C) Copyright 1997-98 Andreas R. Kleinert
**      All Rights Reserved.
*/

#ifndef COMPILER_H
#define COMPILER_H

 /* There have been problems how to define the seglist pointer
    under AROS, AmigaOS or elsewhere. It may make sense to
    use a new, global type definition for it. This is done here. */

#ifndef _AROS
#include <dos/dos.h>
#define SEGLISTPTR BPTR
#else
typedef struct SegList * SEGLISTPTR;
#endif /* AROS */


/* Basically, Amiga C compilers must reach the goal to be
   as SAS/C compatible as possible. But on the other hand,
   when porting AmigaOS to other platforms, one perhaps
   can't expect GCC becoming fully SAS/C compatible...

   There are two ways to make your sources portable:

    - using non ANSI SAS/C statements and making these
      "available" to the other compilers (re- or undefining)
    - using replacements for SAS/C statements and smartly
      redefining these for any compiler

   The last mentioned is the most elegant, but may require to
   rewrite your source codes, so this compiler include file
   basically does offer both.

   For some compilers, this may have been done fromout project or
   makefiles for the first method (e.g. StormC) to ensure compileablity.

   Basically, you should include this header file BEFORE any other stuff.
*/

/* ********************************************************************* */
/* Method 1: redefining SAS/C keywords                                   */
/*                                                                       */
/* Sorry, this method does not work with register definitions for the
current gcc version (V2.7.2.1), as it expects register attributes after
the parameter description. (This is announced to be fixed with gcc V2.8.0).
Moreover the __asm keyword has another meaning with GCC. Therefore ASM
must be used.
*/

#ifdef __MAXON__  // ignore this switches of SAS/Storm
#define __aligned
#define __asm
#define __regargs
#define __saveds
#define __stdargs
#endif

#ifdef __GNUC__  // ignore this switches of SAS/Storm
#define __d0
#define __d1
#define __d2
#define __d3
#define __d4
#define __d5
#define __d6
#define __d7
#define __a0
#define __a1
#define __a2
#define __a3
#define __a4
#define __a5
#define __a6
#define __a7
#endif

#ifdef VBCC
#define __d0 __reg("d0")
#define __d1 __reg("d1")
#define __d2 __reg("d2")
#define __d3 __reg("d3")
#define __d4 __reg("d4")
#define __d5 __reg("d5")
#define __d6 __reg("d6")
#define __d7 __reg("d7")
#define __a0 __reg("a0")
#define __a1 __reg("a1")
#define __a2 __reg("a2")
#define __a3 __reg("a3")
#define __a4 __reg("a4")
#define __a5 __reg("a5")
#define __a6 __reg("a6")
#define __a7 __reg("a7")
#endif

 /* for SAS/C we don't need this, for StormC this is done in the
    makefile or projectfile */

/*                                                                       */
/* ********************************************************************* */


/* ********************************************************************* */
/* Method 2: defining our own keywords                                   */
/*                                                                       */
#ifdef __SASC

#  define REG(r)     register __ ## r
#  define GNUCREG(r)
#  define SAVEDS     __saveds
#  define ASM        __asm
#  define REGARGS    __regargs
#  define STDARGS    __stdargs
#  define ALIGNED    __aligned

#else
# ifdef __MAXON__

#  define REG(r)    register __ ## r
#  define GNUCREG(r)
#  define SAVEDS
#  define ASM
#  define REGARGS
#  define STDARGS
#  define ALIGNED

# else
#  ifdef __STORM__

#   define REG(r)  register __ ## r
#   define GNUCREG(r)
#   define SAVEDS  __saveds
#   define ASM
#   define REGARGS
#   define STDARGS
#   define ALIGNED

#  else
#   ifdef __GNUC__

#    define REG(r)
#    define GNUCREG(r)  __asm( #r )
#    define SAVEDS  __saveds
#    define ASM
#    define REGARGS __regargs
#    define STDARGS __stdargs
#    define ALIGNED __aligned

#   else
#    ifdef VBCC
/* VBCC ignore this switch */
#     define __aligned
#     define __asm
#     define __regargs
#     define __saveds
#     define __stdargs
#     define __register
#     define GNUCREG(r)
#     define REG(r)
#     define SAVEDS
#     define ASM
#     define REGARGS
#     define STDARGS
#     define ALIGNED

#    else
#     ifdef _DCC
#      define __aligned
#      define __stdargs
#      define GNUCREG(r)
#      define ASM

#     else  /* any other compiler, to be added here */

#      define REG(r)
#      define GNUCREG(r)
#      define SAVEDS
#      define ASM
#      define REGARGS
#      define STDARGS
#      define ALIGNED

#     endif /*   _DCC      */
#    endif /*   VBCC      */
#   endif /*  __GNUC__   */
#  endif /*  __STORM__  */
# endif /*  __MAXON__  */
#endif /*  __SASC     */
/*                                                                       */
/* ********************************************************************* */


/* Macros to define functions */

#define LIB_FCT_NAME(name) LIBFCTNAME ## _ ## name

#define LIB_FCT0(type, name) type __saveds ASM LIB_FCT_NAME(name) ( \
  )

#define LIB_FCT1(type, name, a1) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1 \
  )
#define LIB_FCT2(type, name, a1,a2) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2 \
  )
#define LIB_FCT3(type, name, a1,a2,a3) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3 \
  )
#define LIB_FCT4(type, name, a1,a2,a3,a4) type __saveds ASM name( \
  a1, \
  a2, \
  a3, \
  a4 \
  )
#define LIB_FCT5(type, name, a1,a2,a3,a4,a5) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5 \
  )
#define LIB_FCT6(type, name, a1,a2,a3,a4,a5,a6) type __saveds ASM name( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6 \
  )
#define LIB_FCT7(type, name, a1,a2,a3,a4,a5,a6,a7) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7 \
  )

#define LIB_FCT8(type, name, a1,a2,a3,a4,a5,a6,a7,a8) type __saveds ASM name( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8 \
  )
#define LIB_FCT9(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9 \
  )
#define LIB_FCT10(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10) type __saveds ASM name( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9, \
  a10 \
  )
#define LIB_FCT11(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9, \
  a10, \
  a11 \
  )
#define LIB_FCT12(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12) type __saveds ASM name( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9, \
  a10, \
  a11, \
  a12 \
  )
#define LIB_FCT13(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9, \
  a10, \
  a11, \
  a12, \
  a13 \
  )
#define LIB_FCT14(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14) type __saveds ASM name( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9, \
  a10, \
  a11, \
  a12, \
  a13, \
  a14 \
  )
#define LIB_FCT15(type, name, a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15) type __saveds ASM LIB_FCT_NAME(name) ( \
  a1, \
  a2, \
  a3, \
  a4, \
  a5, \
  a6, \
  a7, \
  a8, \
  a9, \
  a10, \
  a11, \
  a12, \
  a13, \
  a14, \
  a15 \
  )

#if LINKLIB != 1
#define LIB_FCT(type,name,reg) register __ ## reg type name GNUCREG(reg)
#define ASMREG LIB_FCT
#else
#define LIB_FCT(type,name,reg) type name
#endif

#endif /* COMPILER_H */
