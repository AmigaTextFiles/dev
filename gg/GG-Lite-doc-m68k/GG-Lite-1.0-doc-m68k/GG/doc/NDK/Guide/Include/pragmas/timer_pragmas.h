@DATABASE "gg:doc/NDK/Guide/Include/pragmas/timer_pragmas.h"
@MASTER   "gg:os-include/pragmas/timer_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:46
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/timer_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/timer_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/timer_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/timer_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/timer_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/timer_pragmas.h"
#ifndef PRAGMAS_TIMER_PRAGMAS_H
#define PRAGMAS_TIMER_PRAGMAS_H

/*
**      $VER: timer_pragmas.h 40.1 (17.5.1996)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/translator_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/translator_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/translator_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_TIMER_PROTOS_H
#include <@{"clib/timer_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/timer_protos.h/File"}>
#endif /* CLIB_TIMER_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall TimerBase AddTime 2a 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall TimerBase SubTime 30 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall TimerBase CmpTime 36 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall TimerBase ReadEClock 3c 801
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall TimerBase GetSysTime 42 801
#endif /* __CLIB_PRAGMA_LIBCALL */

#endif /* PRAGMAS_TIMER_PRAGMAS_H */
@ENDNODE
