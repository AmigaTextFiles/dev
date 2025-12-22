@DATABASE "gg:doc/NDK/Guide/Include/pragmas/cardres_pragmas.h"
@MASTER   "gg:os-include/pragmas/cardres_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:16
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/cardres_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/cardres_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/cardres_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/cardres_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/cardres_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/cardres_pragmas.h"
#ifndef PRAGMAS_CARDRES_PRAGMAS_H
#define PRAGMAS_CARDRES_PRAGMAS_H

/*
**      $VER: cardres_pragmas.h 40.1 (17.5.1996)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/checkbox_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/checkbox_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/checkbox_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_CARDRES_PROTOS_H
#include <@{"clib/cardres_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/cardres_protos.h/File"}>
#endif /* CLIB_CARDRES_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource OwnCard 6 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource ReleaseCard c 0902
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource GetCardMap 12 00
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource BeginCardAccess 18 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource EndCardAccess 1e 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource ReadCardStatus 24 00
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardResetRemove 2a 0902
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardMiscControl 30 1902
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardAccessSpeed 36 0902
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardProgramVoltage 3c 0902
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardResetCard 42 901
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CopyTuple 48 018904
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource DeviceTuple 4e 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource IfAmigaXIP 54 A01
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardForceChange 5a 00
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardChangeCount 60 00
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall CardResource CardInterface 66 00
#endif /* __CLIB_PRAGMA_LIBCALL */

#endif /* PRAGMAS_CARDRES_PRAGMAS_H */
@ENDNODE
