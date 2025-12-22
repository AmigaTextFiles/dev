@DATABASE "gg:doc/NDK/Guide/Include/pragmas/virtual_pragmas.h"
@MASTER   "gg:os-include/pragmas/virtual_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:48
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/virtual_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/virtual_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/virtual_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/virtual_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/virtual_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/virtual_pragmas.h"
#ifndef PRAGMAS_VIRTUAL_PRAGMAS_H
#define PRAGMAS_VIRTUAL_PRAGMAS_H

/*
**      $VER: virtual_pragmas.h 1.1 (6.10.1999)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Stephan Rupprecht
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/wb_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/wb_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/wb_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_VIRTUAL_PROTOS_H
#include <@{"clib/virtual_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/virtual_protos.h/File"}>
#endif /* CLIB_VIRTUAL_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall VirtualBase VIRTUAL_GetClass 1e 00
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall VirtualBase RefreshVirtualGadget 24 BA9804
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall VirtualBase RethinkVirtualSize 2a 0BA9805
#endif /* __CLIB_PRAGMA_LIBCALL */

#endif /* PRAGMAS_VIRTUAL_PRAGMAS_H */
@ENDNODE
