@DATABASE "gg:doc/NDK/Guide/Include/clib/bullet_protos.h"
@MASTER   "gg:os-include/clib/bullet_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/bullet_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/bullet_protos.h" LINK File}

@ENDNODE
@NODE File "clib/bullet_protos.h"
#ifndef  CLIB_BULLET_PROTOS_H
#define  CLIB_BULLET_PROTOS_H

/*
**      $VER: bullet_protos.h 7.1 (22.5.1992)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  DISKFONT_GLYPH_H
#include <@{"diskfont/glyph.h" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File"}>
#endif
@{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *OpenEngine( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"CloseEngine" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 27}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetInfoA" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 31}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine, struct TagItem *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetInfo" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 36}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine, Tag tag1, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ObtainInfoA" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 40}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine, struct TagItem *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ObtainInfo" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 45}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine, Tag tag1, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReleaseInfoA" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 49}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine, struct TagItem *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReleaseInfo" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 54}( @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *glyphEngine, Tag tag1, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_BULLET_PROTOS_H */
@ENDNODE
