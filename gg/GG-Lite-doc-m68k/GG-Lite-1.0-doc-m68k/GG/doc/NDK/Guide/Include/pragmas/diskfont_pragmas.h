@DATABASE "gg:doc/NDK/Guide/Include/pragmas/diskfont_pragmas.h"
@MASTER   "gg:os-include/pragmas/diskfont_pragmas.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:20
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "pragmas/diskfont_pragmas.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"pragmas/diskfont_pragmas.h" LINK File}


@{b}#defines@{ub}

@{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/diskfont_pragmas.h/File" 19}  @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/diskfont_pragmas.h/File" 15}  @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/diskfont_pragmas.h/File" 25}

@ENDNODE
@NODE File "pragmas/diskfont_pragmas.h"
#ifndef PRAGMAS_DISKFONT_PRAGMAS_H
#define PRAGMAS_DISKFONT_PRAGMAS_H

/*
**      $VER: diskfont_pragmas.h 36.1 (1.5.1990)
**
**      Direct ROM interface (pragma) definitions.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#if defined(LATTICE) || defined(__SASC) || defined(_DCC)
#ifndef __CLIB_PRAGMA_LIBCALL
#define @{"__CLIB_PRAGMA_LIBCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/dos_pragmas.h/File" 15}
#endif /* __CLIB_PRAGMA_LIBCALL */
#else /* __MAXON__, __STORM__ or AZTEC_C */
#ifndef __CLIB_PRAGMA_AMICALL
#define @{"__CLIB_PRAGMA_AMICALL" LINK "gg:doc/NDK/Guide/Include/pragmas/dos_pragmas.h/File" 19}
#endif /* __CLIB_PRAGMA_AMICALL */
#endif /* */

#if defined(__SASC) || defined(__STORM__)
#ifndef __CLIB_PRAGMA_TAGCALL
#define @{"__CLIB_PRAGMA_TAGCALL" LINK "gg:doc/NDK/Guide/Include/pragmas/dos_pragmas.h/File" 25}
#endif /* __CLIB_PRAGMA_TAGCALL */
#endif /* __MAXON__, __STORM__ or AZTEC_C */

#ifndef CLIB_DISKFONT_PROTOS_H
#include <@{"clib/diskfont_protos.h" LINK "gg:doc/NDK/Guide/Include/clib/diskfont_protos.h/File"}>
#endif /* CLIB_DISKFONT_PROTOS_H */

#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase OpenDiskFont 1e 801
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase AvailFonts 24 10803
#endif /* __CLIB_PRAGMA_LIBCALL */
/*--- functions in V34 or higher (Release 1.3) ---*/
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase NewFontContents 2a 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase DisposeFontContents 30 901
#endif /* __CLIB_PRAGMA_LIBCALL */
/*--- functions in V36 or higher (Release 2.0) ---*/
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase NewScaledDiskFont 36 9802
#endif /* __CLIB_PRAGMA_LIBCALL */
/*--- functions in V45 or higher (Release 3.9) ---*/
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase GetDiskFontCtrl 3c 001
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_LIBCALL
 #pragma libcall DiskfontBase SetDiskFontCtrlA 42 801
#endif /* __CLIB_PRAGMA_LIBCALL */
#ifdef __CLIB_PRAGMA_TAGCALL
 #ifdef __CLIB_PRAGMA_LIBCALL
  #pragma tagcall DiskfontBase SetDiskFontCtrl 42 801
 #endif /* __CLIB_PRAGMA_LIBCALL */
#endif /* __CLIB_PRAGMA_TAGCALL */

#endif /* PRAGMAS_DISKFONT_PRAGMAS_H */
@ENDNODE
