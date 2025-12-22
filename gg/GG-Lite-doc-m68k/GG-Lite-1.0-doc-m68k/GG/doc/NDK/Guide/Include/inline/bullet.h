@DATABASE "gg:doc/NDK/Guide/Include/inline/bullet.h"
@MASTER   "gg:os-include/inline/bullet.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/bullet.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/bullet.h" LINK File}


@{b}#defines@{ub}

@{"BULLET_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 20}  @{"CLIB_BULLET_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 5}  @{"CloseEngine()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 27}  @{"ObtainInfo()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 45}
@{"ObtainInfoA()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 40}     @{"OpenEngine()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 23}          @{"ReleaseInfo()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 54}  @{"ReleaseInfoA()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 49}
@{"SetInfo()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 36}         @{"SetInfoA()" LINK "gg:doc/NDK/Guide/Include/inline/bullet.h/File" 31}            

@ENDNODE
@NODE File "inline/bullet.h"
#ifndef _INLINE_BULLET_H
#define _INLINE_BULLET_H

#ifndef CLIB_BULLET_PROTOS_H
#define CLIB_BULLET_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  DISKFONT_GLYPH_H
#include <@{"diskfont/glyph.h" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File"}>
#endif

#ifndef BULLET_BASE_NAME
#define BULLET_BASE_NAME BulletBase
#endif

#define @{"OpenEngine()" LINK "gg:doc/NDK/Guide/bullet/OpenEngine"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *, OpenEngine, \\
        , BULLET_BASE_NAME)

#define @{"CloseEngine" LINK "gg:doc/NDK/Guide/bullet/CloseEngine"}(glyphEngine) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"CloseEngine" LINK File 27}, @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *, glyphEngine, a0, \\
        , BULLET_BASE_NAME)

#define @{"SetInfoA" LINK "gg:doc/NDK/Guide/bullet/SetInfoA"}(glyphEngine, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"SetInfoA" LINK File 31}, @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *, glyphEngine, a0, struct TagItem *, tagList, a1, \\
        , BULLET_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetInfo" LINK "gg:doc/NDK/Guide/bullet/SetInfoA"}(glyphEngine, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetInfoA" LINK File 31}((glyphEngine), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"ObtainInfoA" LINK "gg:doc/NDK/Guide/bullet/ObtainInfoA"}(glyphEngine, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x30, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ObtainInfoA" LINK File 40}, @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *, glyphEngine, a0, struct TagItem *, tagList, a1, \\
        , BULLET_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"ObtainInfo" LINK "gg:doc/NDK/Guide/bullet/ObtainInfoA"}(glyphEngine, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"ObtainInfoA" LINK File 40}((glyphEngine), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"ReleaseInfoA" LINK "gg:doc/NDK/Guide/bullet/ReleaseInfoA"}(glyphEngine, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReleaseInfoA" LINK File 49}, @{"struct GlyphEngine" LINK "gg:doc/NDK/Guide/Include/diskfont/glyph.h/File" 26} *, glyphEngine, a0, struct TagItem *, tagList, a1, \\
        , BULLET_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"ReleaseInfo" LINK "gg:doc/NDK/Guide/bullet/ReleaseInfoA"}(glyphEngine, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"ReleaseInfoA" LINK File 49}((glyphEngine), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_BULLET_H  */
@ENDNODE
