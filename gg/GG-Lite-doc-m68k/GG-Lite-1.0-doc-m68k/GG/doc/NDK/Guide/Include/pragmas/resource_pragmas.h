@DATABASE "gg:doc/NDK/Guide/Include/pragmas/resource_pragmas.h"
@MASTER   "gg:os-include/pragmas/resource_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:44
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/resource_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/resource_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/resource_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/resource_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/resource_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/resource_pragmas.h"
#ifndef PRAGMAS_RESOURCE_PRAGMAS_H
#define PRAGMAS_RESOURCE_PRAGMAS_H

/*
**      $VER: resource_pragmas.h 44.1 (17.5.1996)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/rexxsyslib_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/rexxsyslib_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/rexxsyslib_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_RESOURCE_PROTOS_H
#include <@{"clib/resource_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/resource_protos.h/File"}>
#endif /* CLIB_RESOURCE_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_OpenResource 1e A9803
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_CloseResource 24 801
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_NewObjectA 2a 90803
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_TAGCALL
 #ifdef __CLIB_PRAGMA_LIBCALL
  #pragma tagcall ResourceBase RL_NewObject 2a 90803
 #endif /* __CLIB_PRAGMA_LIBCALL */
#endif /* __CLIB_PRAGMA_TAGCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_DisposeObject 30 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_NewGroupA 36 90803
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_TAGCALL
 #ifdef __CLIB_PRAGMA_LIBCALL
  #pragma tagcall ResourceBase RL_NewGroup 36 90803
 #endif /* __CLIB_PRAGMA_LIBCALL */
#endif /* __CLIB_PRAGMA_TAGCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_DisposeGroup 3c 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_GetObjectArray 42 09803
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall ResourceBase RL_SetResourceScreen 48 9802
#endif /* __CLIB_PRAGMA_LIBCALL */

#endif /* PRAGMAS_RESOURCE_PRAGMAS_H */
@ENDNODE
