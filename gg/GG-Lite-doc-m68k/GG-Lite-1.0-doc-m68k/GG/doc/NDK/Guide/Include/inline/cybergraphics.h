@DATABASE "gg:doc/NDK/Guide/Include/inline/cybergraphics.h"
@MASTER   "gg:os-include/inline/cybergraphics.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/cybergraphics.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/cybergraphics.h" LINK File}


@{b}#defines@{ub}

@{"AllocCModeListTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 42}      @{"AllocCModeListTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 47}
@{"BestCModeIDTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 24}         @{"BestCModeIDTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 29}
@{"CLIB_CYBERGRAPHICS_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 5}  @{"CModeRequestTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 33}
@{"CModeRequestTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 38}           @{"CVideoCtrlTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 104}
@{"CVideoCtrlTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 109}             @{"CYBERGRAPHICS_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 17}
@{"DoCDrawMethodTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 95}       @{"DoCDrawMethodTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 100}
@{"ExtractColor()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 135}               @{"FillPixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 91}
@{"FreeCModeList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 51}              @{"GetCyberIDAttr()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 63}
@{"GetCyberMapAttr()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 59}            @{"InvertPixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 87}
@{"IsCyberModeID()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 20}              @{"LockBitMapTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 113}
@{"LockBitMapTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 118}             @{"MovePixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 83}
@{"ReadPixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 75}             @{"ReadRGBPixel()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 67}
@{"ScalePixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 55}            @{"UnLockBitMap()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 122}
@{"UnLockBitMapTagList()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 126}        @{"UnLockBitMapTags()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 131}
@{"WriteLUTPixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 139}         @{"WritePixelArray()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 79}
@{"WriteRGBPixel()" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 71}              

@ENDNODE
@NODE File "inline/cybergraphics.h"
#ifndef _INLINE_CYBERGRAPHICS_H
#define _INLINE_CYBERGRAPHICS_H

#ifndef CLIB_CYBERGRAPHICS_PROTOS_H
#define CLIB_CYBERGRAPHICS_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef CYBERGRAPHICS_BASE_NAME
#define CYBERGRAPHICS_BASE_NAME CyberGfxBase
#endif

#define IsCyberModeID(displayID) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x36, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsCyberModeID" LINK File 20}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, displayID, d0, \\
        , @{"CYBERGRAPHICS_BASE_NAME" LINK File 17})

#define BestCModeIDTagList(BestModeIDTags) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x3c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"BestCModeIDTagList" LINK File 24}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, BestModeIDTags, a0, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define BestCModeIDTags(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"BestCModeIDTagList" LINK File 24}((@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define CModeRequestTagList(ModeRequest, ModeRequestTags) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x42, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"CModeRequestTagList" LINK File 33}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, ModeRequest, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, ModeRequestTags, a1, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CModeRequestTags(ModeRequest, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"CModeRequestTagList" LINK File 33}((ModeRequest), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define AllocCModeListTagList(ModeListTags) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x48, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, AllocCModeListTagList, struct TagItem *, ModeListTags, a1, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define AllocCModeListTags(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"AllocCModeListTagList" LINK File 42}((@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define FreeCModeList(ModeList) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x4e, @{"FreeCModeList" LINK File 51}, @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *, ModeList, a0, \\
        , CYBERGRAPHICS_BASE_NAME)

#define ScalePixelArray(srcRect, SrcW, SrcH, SrcMod, a1arg, DestX, DestY, DestW, DestH, SrcFormat) \\
        @{"LP10" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 824}(0x5a, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ScalePixelArray" LINK File 55}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, srcRect, a0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcW, d0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcH, d1, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcMod, d2, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, DestX, d3, UWORD, DestY, d4, UWORD, DestW, d5, UWORD, DestH, d6, UBYTE, SrcFormat, d7, \\
        , CYBERGRAPHICS_BASE_NAME)

#define GetCyberMapAttr(CyberGfxBitmap, CyberAttrTag) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x60, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetCyberMapAttr" LINK File 59}, @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *, CyberGfxBitmap, a0, ULONG, CyberAttrTag, d0, \\
        , CYBERGRAPHICS_BASE_NAME)

#define GetCyberIDAttr(CyberIDAttr, CyberDisplayModeID) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x66, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetCyberIDAttr" LINK File 63}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, CyberIDAttr, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, CyberDisplayModeID, d1, \\
        , @{"CYBERGRAPHICS_BASE_NAME" LINK File 17})

#define ReadRGBPixel(a1arg, x, y) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x6c, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReadRGBPixel" LINK File 67}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, x, d0, UWORD, y, d1, \\
        , CYBERGRAPHICS_BASE_NAME)

#define WriteRGBPixel(a1arg, x, y, argb) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x72, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"WriteRGBPixel" LINK File 71}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, x, d0, UWORD, y, d1, ULONG, argb, d2, \\
        , CYBERGRAPHICS_BASE_NAME)

#define ReadPixelArray(destRect, destX, destY, destMod, a1arg, SrcX, SrcY, SizeX, SizeY, DestFormat) \\
        @{"LP10" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 824}(0x78, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReadPixelArray" LINK File 75}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, destRect, a0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, destX, d0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, destY, d1, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, destMod, d2, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, SrcX, d3, UWORD, SrcY, d4, UWORD, SizeX, d5, UWORD, SizeY, d6, UBYTE, DestFormat, d7, \\
        , CYBERGRAPHICS_BASE_NAME)

#define WritePixelArray(srcRect, SrcX, SrcY, SrcMod, a1arg, DestX, DestY, SizeX, SizeY, SrcFormat) \\
        @{"LP10" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 824}(0x7e, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"WritePixelArray" LINK File 79}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, srcRect, a0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcX, d0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcY, d1, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcMod, d2, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, DestX, d3, UWORD, DestY, d4, UWORD, SizeX, d5, UWORD, SizeY, d6, UBYTE, SrcFormat, d7, \\
        , CYBERGRAPHICS_BASE_NAME)

#define MovePixelArray(SrcX, SrcY, a1arg, DestX, DestY, SizeX, SizeY) \\
        @{"LP7" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 596}(0x84, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"MovePixelArray" LINK File 83}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcX, d0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcY, d1, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, DestX, d2, UWORD, DestY, d3, UWORD, SizeX, d4, UWORD, SizeY, d5, \\
        , CYBERGRAPHICS_BASE_NAME)

#define InvertPixelArray(a1arg, DestX, DestY, SizeX, SizeY) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0x90, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"InvertPixelArray" LINK File 87}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, DestX, d0, UWORD, DestY, d1, UWORD, SizeX, d2, UWORD, SizeY, d3, \\
        , CYBERGRAPHICS_BASE_NAME)

#define FillPixelArray(a1arg, DestX, DestY, SizeX, SizeY, ARGB) \\
        @{"LP6" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 541}(0x96, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"FillPixelArray" LINK File 91}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, UWORD, DestX, d0, UWORD, DestY, d1, UWORD, SizeX, d2, UWORD, SizeY, d3, ULONG, ARGB, d4, \\
        , CYBERGRAPHICS_BASE_NAME)

#define DoCDrawMethodTagList(Hook, a1arg, TagList) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x9c, @{"DoCDrawMethodTagList" LINK File 95}, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, Hook, a0, struct RastPort *, a1arg, a1, struct TagItem *, TagList, a2, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DoCDrawMethodTags(Hook, a1arg, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"DoCDrawMethodTagList" LINK File 95}((Hook), (a1arg), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define CVideoCtrlTagList(ViewPort, TagList) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0xa2, @{"CVideoCtrlTagList" LINK File 104}, @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *, ViewPort, a0, struct TagItem *, TagList, a1, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define CVideoCtrlTags(ViewPort, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"CVideoCtrlTagList" LINK File 104}((ViewPort), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define LockBitMapTagList(BitMap, TagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0xa8, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"LockBitMapTagList" LINK File 113}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, BitMap, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, TagList, a1, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define LockBitMapTags(BitMap, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"LockBitMapTagList" LINK File 113}((BitMap), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define UnLockBitMap(Handle) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xae, @{"UnLockBitMap" LINK File 122}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, Handle, a0, \\
        , @{"CYBERGRAPHICS_BASE_NAME" LINK File 17})

#define UnLockBitMapTagList(Handle, TagList) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0xb4, @{"UnLockBitMapTagList" LINK File 126}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, Handle, a0, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, TagList, a1, \\
        , CYBERGRAPHICS_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define UnLockBitMapTags(Handle, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"UnLockBitMapTagList" LINK File 126}((Handle), (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define ExtractColor(a0arg, BitMap, Colour, SrcX, SrcY, Width, Height) \\
        @{"LP7" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 596}(0xba, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ExtractColor" LINK File 135}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a0arg, a0, struct BitMap *, BitMap, a1, ULONG, Colour, d0, ULONG, SrcX, d1, ULONG, SrcY, d2, ULONG, Width, d3, ULONG, Height, d4, \\
        , CYBERGRAPHICS_BASE_NAME)

#define WriteLUTPixelArray(srcRect, SrcX, SrcY, SrcMod, a1arg, ColorTab, DestX, DestY, SizeX, SizeY, CTFormat) \\
        @{"LP11" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 897}(0xc6, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"WriteLUTPixelArray" LINK File 139}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, srcRect, a0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcX, d0, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcY, d1, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, SrcMod, d2, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, a1arg, a1, APTR, ColorTab, a2, UWORD, DestX, d3, UWORD, DestY, d4, UWORD, SizeX, d5, UWORD, SizeY, d6, UBYTE, CTFormat, d7, \\
        , CYBERGRAPHICS_BASE_NAME)

#endif /*  _INLINE_CYBERGRAPHICS_H  */
@ENDNODE
