@DATABASE "gg:doc/NDK/Guide/Include/diskfont/diskfont.h"
@MASTER   "gg:os-include/diskfont/diskfont.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:47
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "diskfont/diskfont.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"diskfont/diskfont.h" LINK File}


@{b}Structures@{ub}

@{"AvailFonts" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 96}          @{"AvailFontsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 106}  @{"DiskFontHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 63}  @{"FontContents" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 27}
@{"FontContentsHeader" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 53}  @{"TAvailFonts" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 101}       @{"TFontContents" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 34}   


@{b}#defines@{ub}

@{"AFB_BITMAP" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 90}  @{"AFB_DISK" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 86}     @{"AFB_MEMORY" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 84}  @{"AFB_SCALED" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 88}   @{"AFB_TAGGED" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 93}
@{"AFF_BITMAP" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 91}  @{"AFF_DISK" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 87}     @{"AFF_MEMORY" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 85}  @{"AFF_SCALED" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 89}   @{"AFF_TAGGED" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 94}
@{"DFH_ID" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 60}      @{"dfh_TagList" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 81}  @{"FCH_ID" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 48}      @{"MAXFONTNAME" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 61}  @{"MAXFONTPATH" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 25}
@{"OFCH_ID" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 50}     @{"TFCH_ID" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 49}      

@ENDNODE
@NODE File "diskfont/diskfont.h"
#ifndef DISKFONT_DISKFONT_H
#define DISKFONT_DISKFONT_H
/*
**      $VER: diskfont.h 38.0 (18.6.1992)
**      Includes Release 45.1
**
**      diskfont library definitions
**
**      (C) Copyright 1990 Robert R. Burns
**          All Rights Reserved
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef     EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef     EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef     GRAPHICS_TEXT_H
#include <@{"graphics/text.h" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File"}>
#endif

#define     MAXFONTPATH 256   /* including null terminator */

struct FontContents {
    char    fc_FileName[@{"MAXFONTPATH" LINK File 25}];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   fc_YSize;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   fc_Style;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   fc_Flags;
};

struct TFontContents {
    char    tfc_FileName[@{"MAXFONTPATH" LINK File 25}-2];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tfc_TagCount;       /* including the @{"TAG_DONE" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 39} tag */
    /*
     *  if tfc_TagCount is non-zero, tfc_FileName is overlayed with
     *  Text Tags starting at:  (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *)
     *      &tfc_FileName[@{"MAXFONTPATH" LINK File 25}-(tfc_TagCount*sizeof(@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}))]
     */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   tfc_YSize;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tfc_Style;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   tfc_Flags;
};


#define  FCH_ID         0x0f00  /* FontContentsHeader, then FontContents */
#define  TFCH_ID        0x0f02  /* FontContentsHeader, then TFontContents */
#define  OFCH_ID        0x0f03  /* FontContentsHeader, then TFontContents,
                                 * associated with outline font */

struct FontContentsHeader {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   fch_FileID;         /* @{"FCH_ID" LINK File 48} */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   fch_NumEntries;     /* the number of FontContents elements */
    /* @{"struct FontContents" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 27} fch_FC[], or @{"struct TFontContents" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 34} fch_TFC[]; */
};


#define  DFH_ID         0x0f80
#define  MAXFONTNAME    32      /* font name including ".font\\0" */

struct DiskFontHeader {
    /* the following 8 bytes are not actually considered a part of the  */
    /* DiskFontHeader, but immediately preceed it. The NextSegment is   */
    /* supplied by the linker/loader, and the ReturnCode is the code    */
    /* at the beginning of the font in case someone runs it...          */
    /*   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} dfh_NextSegment;                 \\* actually a @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}      */
    /*   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} dfh_ReturnCode;                  \\* MOVEQ #0,D0 : RTS    */
    /* here then is the official start of the DiskFontHeader...         */
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} dfh_DF;         /* node to link disk fonts */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dfh_FileID;         /* @{"DFH_ID" LINK File 60} */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dfh_Revision;       /* the font revision */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dfh_Segment;        /* the segment address when loaded */
    char    dfh_Name[@{"MAXFONTNAME" LINK File 61}]; /* the font name (null terminated) */
    @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89} dfh_TF;     /* loaded TextFont structure */
};

/* unfortunately, this needs to be explicitly typed */
/* used only if dfh_TF.tf_Style @{"FSB_TAGGED" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 38} bit is set */
#define dfh_TagList     dfh_Segment     /* destroyed during loading */


#define     AFB_MEMORY  0
#define     AFF_MEMORY  0x0001
#define     AFB_DISK    1
#define     AFF_DISK    0x0002
#define     AFB_SCALED  2
#define     AFF_SCALED  0x0004
#define     AFB_BITMAP  3
#define     AFF_BITMAP  0x0008

#define     AFB_TAGGED  16      /* return TAvailFonts */
#define     AFF_TAGGED  0x10000L

struct AvailFonts {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   af_Type;            /* MEMORY, DISK, or SCALED */
    @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} af_Attr;    /* text attributes for font */
};

struct TAvailFonts {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   taf_Type;           /* MEMORY, DISK, or SCALED */
    @{"struct TTextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 72} taf_Attr;  /* text attributes for font */
};

struct AvailFontsHeader {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   afh_NumEntries;      /* number of @{"AvailFonts" LINK "gg:doc/NDK/Guide/diskfont/AvailFonts"} elements */
    /* @{"struct AvailFonts" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 96} afh_AF[], or @{"struct TAvailFonts" LINK "gg:doc/NDK/Guide/Include/diskfont/diskfont.h/File" 101} afh_TAF[]; */
};

#endif  /* DISKFONT_DISKFONT_H */
@ENDNODE
