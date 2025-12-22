/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_DISKFONT_H
#define _PPCINLINE_DISKFONT_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef DISKFONT_BASE_NAME
#define DISKFONT_BASE_NAME DiskfontBase
#endif /* !DISKFONT_BASE_NAME */

#define AvailFonts(buffer, bufBytes, flags) \
	LP3(0x24, LONG, AvailFonts, STRPTR, buffer, a0, LONG, bufBytes, d0, LONG, flags, d1, \
	, DISKFONT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define DisposeFontContents(fontContentsHeader) \
	LP1NR(0x30, DisposeFontContents, struct FontContentsHeader *, fontContentsHeader, a1, \
	, DISKFONT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define NewFontContents(fontsLock, fontName) \
	LP2(0x2a, struct FontContentsHeader *, NewFontContents, BPTR, fontsLock, a0, STRPTR, fontName, a1, \
	, DISKFONT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define NewScaledDiskFont(sourceFont, destTextAttr) \
	LP2(0x36, struct DiskFont *, NewScaledDiskFont, struct TextFont *, sourceFont, a0, struct TextAttr *, destTextAttr, a1, \
	, DISKFONT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenDiskFont(textAttr) \
	LP1(0x1e, struct TextFont *, OpenDiskFont, struct TextAttr *, textAttr, a0, \
	, DISKFONT_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_DISKFONT_H */
