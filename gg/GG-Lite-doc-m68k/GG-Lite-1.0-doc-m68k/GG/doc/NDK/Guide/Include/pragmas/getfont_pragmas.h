@DATABASE "gg:doc/NDK/Guide/Include/pragmas/getfont_pragmas.h"
@MASTER   "gg:os-include/pragmas/getfont_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/getfont_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/getfont_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/getfont_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/getfont_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/getfont_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/getfont_pragmas.h"
#ifndef PRAGMAS_GETFONT_PRAGMAS_H
#define PRAGMAS_GETFONT_PRAGMAS_H

/*
**      $VER: getfont_pragmas.h 1.1 (6.10.1999)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/getscreenmode_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/getscreenmode_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/getscreenmode_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_GETFONT_PROTOS_H
#include <@{"clib/getfont_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/getfont_protos.h/File"}>
#endif /* CLIB_GETFONT_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall GetFontBase GETFONT_GetClass 1e 00
#endif /* __CLIB_PRAGMA_LIBCALL */

#endif /* PRAGMAS_GETFONT_PRAGMAS_H */
@ENDNODE
