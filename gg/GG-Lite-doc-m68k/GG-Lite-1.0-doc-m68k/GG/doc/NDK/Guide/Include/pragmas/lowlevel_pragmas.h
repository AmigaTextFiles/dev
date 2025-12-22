@DATABASE "gg:doc/NDK/Guide/Include/pragmas/lowlevel_pragmas.h"
@MASTER   "gg:os-include/pragmas/lowlevel_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:38
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/lowlevel_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/lowlevel_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/lowlevel_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/lowlevel_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/lowlevel_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/lowlevel_pragmas.h"
#ifndef PRAGMAS_LOWLEVEL_PRAGMAS_H
#define PRAGMAS_LOWLEVEL_PRAGMAS_H

/*
**      $VER: lowlevel_pragmas.h 40.1 (17.5.1996)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathffp_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathffp_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathffp_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_LOWLEVEL_PROTOS_H
#include <@{"clib/lowlevel_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/lowlevel_protos.h/File"}>
#endif /* CLIB_LOWLEVEL_PROTOS_H */

/*--- functions in V40 or higher (Release 3.1) ---*/

/* CONTROLLER HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase ReadJoyPort 1e 001
#endif /* __CLIB_PRAGMA_LIBCALL */

/* LANGUAGE HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase GetLanguageSelection 24 00
#endif /* __CLIB_PRAGMA_LIBCALL */

/* KEYBOARD HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase GetKey 30 00
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase QueryKeys 36 1802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase AddKBInt 3c 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase RemKBInt 42 901
#endif /* __CLIB_PRAGMA_LIBCALL */

/* SYSTEM HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase SystemControlA 48 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_TAGCALL
 #ifdef __CLIB_PRAGMA_LIBCALL
  #pragma tagcall LowLevelBase SystemControl 48 901
 #endif /* __CLIB_PRAGMA_LIBCALL */
#endif /* __CLIB_PRAGMA_TAGCALL */

/* TIMER HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase AddTimerInt 4e 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase RemTimerInt 54 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase StopTimerInt 5a 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase StartTimerInt 60 10903
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase ElapsedTime 66 801
#endif /* __CLIB_PRAGMA_LIBCALL */

/* VBLANK HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase AddVBlankInt 6c 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase RemVBlankInt 72 901
#endif /* __CLIB_PRAGMA_LIBCALL */

/* MORE CONTROLLER HANDLING */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall LowLevelBase SetJoyPortAttrsA 84 9002
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_TAGCALL
 #ifdef __CLIB_PRAGMA_LIBCALL
  #pragma tagcall LowLevelBase SetJoyPortAttrs 84 9002
 #endif /* __CLIB_PRAGMA_LIBCALL */
#endif /* __CLIB_PRAGMA_TAGCALL */

#endif /* PRAGMAS_LOWLEVEL_PRAGMAS_H */
@ENDNODE
