@DATABASE "gg:doc/NDK/Guide/Include/inline/diskfont.h"
@MASTER   "gg:os-include/inline/diskfont.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:40
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/diskfont.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/diskfont.h" LINK File}


@{b}#defines@{ub}

@{"AvailFonts()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 30}           @{"CLIB_DISKFONT_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 5}  @{"DISKFONT_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 23}
@{"DisposeFontContents()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 38}  @{"GetDiskFontCtrl()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 46}       @{"NewFontContents()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 34}
@{"NewScaledDiskFont()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 42}    @{"OpenDiskFont()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 26}          @{"SetDiskFontCtrl()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 55}
@{"SetDiskFontCtrlA()" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 50}     

@ENDNODE
@NODE File "inline/diskfont.h"
#ifndef _INLINE_DISKFONT_H
#define _INLINE_DISKFONT_H

#ifndef CLIB_DISKFONT_PROTOS_H
#define CLIB_DISKFONT_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  LIBRARIES_DISKFONT_H
#include <@{"libraries/diskfont.h" LINK "gg:doc/NDK/Guide/Include/libraries/diskfont.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef DISKFONT_BASE_NAME
#define DISKFONT_BASE_NAME DiskfontBase
#endif

#define @{"OpenDiskFont" LINK "gg:doc/NDK/Guide/diskfont/OpenDiskFont"}(textAttr) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x1e, @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *, OpenDiskFont, struct TextAttr *, textAttr, a0, \\
        , DISKFONT_BASE_NAME)

#define @{"AvailFonts" LINK "gg:doc/NDK/Guide/diskfont/AvailFonts"}(buffer, bufBytes, flags) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x24, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"AvailFonts" LINK File 30}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, buffer, a0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, bufBytes, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, flags, d1, \\
        , @{"DISKFONT_BASE_NAME" LINK File 23})

#define @{"NewFontContents" LINK "gg:doc/NDK/Guide/diskfont/NewFontContents"}(fontsLock, fontName) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"struct FontContentsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 53} *, NewFontContents, BPTR, fontsLock, a0, STRPTR, fontName, a1, \\
        , DISKFONT_BASE_NAME)

#define @{"DisposeFontContents" LINK "gg:doc/NDK/Guide/diskfont/DisposeFontContents"}(fontContentsHeader) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x30, @{"DisposeFontContents" LINK File 38}, @{"struct FontContentsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 53} *, fontContentsHeader, a1, \\
        , DISKFONT_BASE_NAME)

#define @{"NewScaledDiskFont" LINK "gg:doc/NDK/Guide/diskfont/NewScaledDiskFont"}(sourceFont, destTextAttr) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, struct DiskFont *, NewScaledDiskFont, struct TextFont *, sourceFont, a0, struct TextAttr *, destTextAttr, a1, \\
        , DISKFONT_BASE_NAME)

#define @{"GetDiskFontCtrl" LINK "gg:doc/NDK/Guide/diskfont/GetDiskFontCtrl"}(tagid) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x3c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GetDiskFontCtrl" LINK File 46}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, tagid, d0, \\
        , @{"DISKFONT_BASE_NAME" LINK File 23})

#define @{"SetDiskFontCtrlA" LINK "gg:doc/NDK/Guide/diskfont/SetDiskFontCtrlA"}(taglist) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x42, @{"SetDiskFontCtrlA" LINK File 50}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, taglist, a0, \\
        , DISKFONT_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetDiskFontCtrl" LINK "gg:doc/NDK/Guide/diskfont/SetDiskFontCtrlA"}(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetDiskFontCtrlA" LINK File 50}((@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_DISKFONT_H  */
@ENDNODE
