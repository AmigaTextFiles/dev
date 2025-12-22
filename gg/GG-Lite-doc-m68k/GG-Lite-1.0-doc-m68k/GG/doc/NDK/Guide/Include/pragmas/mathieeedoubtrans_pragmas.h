@DATABASE "gg:doc/NDK/Guide/Include/pragmas/mathieeedoubtrans_pragmas.h"
@MASTER   "gg:os-include/pragmas/mathieeedoubtrans_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/mathieeedoubtrans_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/mathieeedoubtrans_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathieeedoubtrans_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathieeedoubtrans_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathieeedoubtrans_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/mathieeedoubtrans_pragmas.h"
#ifndef PRAGMAS_MATHIEEEDOUBTRANS_PRAGMAS_H
#define PRAGMAS_MATHIEEEDOUBTRANS_PRAGMAS_H

/*
**      $VER: mathieeedoubtrans_pragmas.h 40.1 (17.5.1996)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathieeesingbas_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathieeesingbas_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/mathieeesingbas_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_MATHIEEEDOUBTRANS_PROTOS_H
#include <@{"clib/mathieeedoubtrans_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/mathieeedoubtrans_protos.h/File"}>
#endif /* CLIB_MATHIEEEDOUBTRANS_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPAtan 1e 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPSin 24 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPCos 2a 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPTan 30 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPSincos 36 0802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPSinh 3c 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPCosh 42 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPTanh 48 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPExp 4e 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPLog 54 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPPow 5a 0202
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPSqrt 60 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPTieee 66 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPFieee 6c 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPAsin 72 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPAcos 78 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall MathIeeeDoubTransBase IEEEDPLog10 7e 001
#endif /* __CLIB_PRAGMA_LIBCALL */

#endif /* PRAGMAS_MATHIEEEDOUBTRANS_PRAGMAS_H */
@ENDNODE
