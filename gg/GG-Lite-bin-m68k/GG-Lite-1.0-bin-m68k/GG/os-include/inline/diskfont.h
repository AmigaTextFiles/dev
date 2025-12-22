#ifndef _INLINE_DISKFONT_H
#define _INLINE_DISKFONT_H

#ifndef CLIB_DISKFONT_PROTOS_H
#define CLIB_DISKFONT_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  DOS_DOS_H
#include <dos/dos.h>
#endif
#ifndef  LIBRARIES_DISKFONT_H
#include <libraries/diskfont.h>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef DISKFONT_BASE_NAME
#define DISKFONT_BASE_NAME DiskfontBase
#endif

#define OpenDiskFont(textAttr) \
	LP1(0x1e, struct TextFont *, OpenDiskFont, struct TextAttr *, textAttr, a0, \
	, DISKFONT_BASE_NAME)

#define AvailFonts(buffer, bufBytes, flags) \
	LP3(0x24, LONG, AvailFonts, STRPTR, buffer, a0, LONG, bufBytes, d0, LONG, flags, d1, \
	, DISKFONT_BASE_NAME)

#define NewFontContents(fontsLock, fontName) \
	LP2(0x2a, struct FontContentsHeader *, NewFontContents, BPTR, fontsLock, a0, STRPTR, fontName, a1, \
	, DISKFONT_BASE_NAME)

#define DisposeFontContents(fontContentsHeader) \
	LP1NR(0x30, DisposeFontContents, struct FontContentsHeader *, fontContentsHeader, a1, \
	, DISKFONT_BASE_NAME)

#define NewScaledDiskFont(sourceFont, destTextAttr) \
	LP2(0x36, struct DiskFont *, NewScaledDiskFont, struct TextFont *, sourceFont, a0, struct TextAttr *, destTextAttr, a1, \
	, DISKFONT_BASE_NAME)

#define GetDiskFontCtrl(tagid) \
	LP1(0x3c, LONG, GetDiskFontCtrl, LONG, tagid, d0, \
	, DISKFONT_BASE_NAME)

#define SetDiskFontCtrlA(taglist) \
	LP1NR(0x42, SetDiskFontCtrlA, struct TagItem *, taglist, a0, \
	, DISKFONT_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetDiskFontCtrl(tags...) \
	({ULONG _tags[] = {tags}; SetDiskFontCtrlA((struct TagItem *) _tags);})
#endif

#endif /*  _INLINE_DISKFONT_H  */
