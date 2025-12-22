#ifndef _INCLUDE_PRAGMA_DISKFONT_LIB_H
#define _INCLUDE_PRAGMA_DISKFONT_LIB_H

/*
**  $VER: diskfont_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_DISKFONT_PROTOS_H
#include <clib/diskfont_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(DiskfontBase, 0x1e, OpenDiskFont(a0))
#pragma amicall(DiskfontBase, 0x24, AvailFonts(a0,d0,d1))
#pragma amicall(DiskfontBase, 0x2a, NewFontContents(a0,a1))
#pragma amicall(DiskfontBase, 0x30, DisposeFontContents(a1))
#pragma amicall(DiskfontBase, 0x36, NewScaledDiskFont(a0,a1))

#ifdef __cplusplus
}
#endif

#endif
