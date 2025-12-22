@DATABASE "gg:doc/NDK/Guide/Include/clib/cybergraphics_protos.h"
@MASTER   "gg:os-include/clib/cybergraphics_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/cybergraphics_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/cybergraphics_protos.h" LINK File}

@ENDNODE
@NODE File "clib/cybergraphics_protos.h"
/*
**      $VER: cybergraphics_protos.h 41.18 (21.02.1998)
**
**      C prototypes for cybergraphics.library
**
**      Copyright © 1996-1998 by phase5 digital products
**      All Rights reserved.
**
*/

#ifndef CLIB_CYBERGRAPHICS_H
#define CLIB_CYBERGRAPHICS_H 1

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *AllocCModeListTagList(struct TagItem *);
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *AllocCModeListTags(Tag, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"BestCModeIDTagList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 24}(@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"BestCModeIDTags" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 29}(@{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"CModeRequestTagList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 33}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"CModeRequestTags" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 38}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, ...);
void         @{"CVideoCtrlTagList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 104}(@{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *, struct TagItem *);
void         @{"CVideoCtrlTags" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 109}(@{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} *, Tag tag1, ...);
void         @{"DoCDrawMethodTagList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 95}(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, struct RastPort *, struct TagItem *);
void         @{"DoCDrawMethodTags" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 100}(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, struct RastPort *, Tag, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"ExtractColor" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 135}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *,struct BitMap *,ULONG,ULONG,ULONG,ULONG,ULONG);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"FillPixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 91}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD, UWORD, UWORD, UWORD, ULONG);
void         @{"FreeCModeList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 51}(@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"GetCyberIDAttr" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 63}(@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52});
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"GetCyberMapAttr" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 59}(@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *, ULONG);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"InvertPixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 87}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD, UWORD, UWORD, UWORD);
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}         @{"IsCyberModeID" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 20}(@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52});
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}         @{"LockBitMapTagList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 113}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49},@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *);
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}         @{"LockBitMapTags" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 118}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, ...);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"MovePixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 83}(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD, UWORD, UWORD,
                            UWORD);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"ReadPixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 75}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD,
                            UWORD, UWORD, UWORD, UBYTE);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"ReadRGBPixel" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 67}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD, UWORD);
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}         @{"ScalePixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 55}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49},@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55},@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55},@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55},@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *,UWORD,
                             UWORD,UWORD,UWORD,UBYTE);
void         @{"UnLockBitMap" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 122}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49});
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"WritePixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 79}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD,
                             UWORD, UWORD, UWORD, UBYTE);
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        @{"WriteLUTPixelArray" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 139}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, APTR,
                                UWORD, UWORD, UWORD, UWORD, UBYTE);
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}         @{"WriteRGBPixel" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 71}(@{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *, UWORD, UWORD, ULONG);
void         @{"UnLockBitMapTagList" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 126}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *);
void         @{"UnLockBitMapTags" LINK "gg:doc/NDK/Guide/Include/inline/cybergraphics.h/File" 131}(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30}, ...);

#endif /* !CLIB_CYBERGRAPHICS_H */
@ENDNODE
