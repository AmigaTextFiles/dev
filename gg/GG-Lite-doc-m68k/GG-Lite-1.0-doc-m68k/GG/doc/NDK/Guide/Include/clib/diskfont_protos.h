@DATABASE "gg:doc/NDK/Guide/Include/clib/diskfont_protos.h"
@MASTER   "gg:os-include/clib/diskfont_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/diskfont_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/diskfont_protos.h" LINK File}

@ENDNODE
@NODE File "clib/diskfont_protos.h"
#ifndef  CLIB_DISKFONT_PROTOS_H
#define  CLIB_DISKFONT_PROTOS_H

/*
**      $VER: diskfont_protos.h 36.1 (1.5.1990)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  LIBRARIES_DISKFONT_H
#include <@{"libraries/diskfont.h" LINK "gg:doc/NDK/Guide/Include/libraries/diskfont.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
@{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} *OpenDiskFont( struct TextAttr *textAttr );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AvailFonts" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 30}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} bufBytes, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} flags );
/*--- functions in V34 or higher (Release 1.3) ---*/
@{"struct FontContentsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 53} *NewFontContents( BPTR fontsLock, STRPTR fontName );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeFontContents" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 38}( @{"struct FontContentsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 53} *fontContentsHeader );
/*--- functions in V36 or higher (Release 2.0) ---*/
struct DiskFont *NewScaledDiskFont( struct TextFont *sourceFont, struct TextAttr *destTextAttr );
/*--- functions in V45 or higher (Release 3.9) ---*/
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetDiskFontCtrl" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 46}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} tagid );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetDiskFontCtrlA" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 50}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *taglist );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetDiskFontCtrl" LINK "gg:doc/NDK/Guide/Include/inline/diskfont.h/File" 55}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} tag1, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DISKFONT_PROTOS_H */
@ENDNODE
