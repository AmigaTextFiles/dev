@DATABASE "gg:doc/NDK/Guide/Include/intuition/screens.h"
@MASTER   "gg:os-include/intuition/screens.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:19
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/screens.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/screens.h" LINK File}


@{b}Structures@{ub}

@{"DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66}      @{"ExtNewScreen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 513}  @{"NewScreen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 477}  @{"PubScreenNode" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 549}  @{"Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133}
@{"ScreenBuffer" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 645}  


@{b}#defines@{ub}

@{"AUTOSCROLL" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 217}        @{"BACKGROUNDPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 101}       @{"BARBLOCKPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 105}
@{"BARDETAILPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 104}      @{"BARTRIMPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 106}          @{"BEEPING" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 202}
@{"BLOCKPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 95}          @{"CUSTOMBITMAP" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 204}        @{"CUSTOMSCREEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 198}
@{"DETAILPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 94}         @{"DRI_VERSION" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 64}         @{"DRIF_NEWLOOK" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 91}
@{"FILLPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 99}           @{"FILLTEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 100}         @{"HIGHLIGHTTEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 102}
@{"MAXPUBSCREENNAME" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 564}  @{"NS_EXTENDED" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 214}         @{"NSTAG_EXT_VPMODE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 454}
@{"NUMDRIPENS" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 108}        @{"OSCAN_MAX" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 533}           @{"OSCAN_STANDARD" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 532}
@{"OSCAN_TEXT" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 531}        @{"OSCAN_VIDEO" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 534}         @{"OSERR_ATTACHFAIL" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 468}
@{"OSERR_NOCHIPMEM" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 464}   @{"OSERR_NOCHIPS" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 462}       @{"OSERR_NOMEM" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 463}
@{"OSERR_NOMONITOR" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 461}   @{"OSERR_NOTAVAILABLE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 469}  @{"OSERR_PUBNOTUNIQUE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 465}
@{"OSERR_TOODEEP" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 467}     @{"OSERR_UNKNOWNMODE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 466}   @{"PEN_C0" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 118}
@{"PEN_C1" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 117}            @{"PEN_C2" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 116}              @{"PEN_C3" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 115}
@{"PENSHARED" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 220}         @{"POPPUBSCREEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 568}        @{"PSNF_PRIVATE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 559}
@{"PUBLICSCREEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 197}      @{"SA_AutoScroll" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 319}       @{"SA_BackChild" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 419}
@{"SA_BackFill" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 377}       @{"SA_Behind" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 315}           @{"SA_BitMap" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 274}
@{"SA_BlockPen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 251}       @{"SA_ColorMapEntries" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 332}  @{"SA_Colors" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 254}
@{"SA_Colors32" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 391}       @{"SA_DClip" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 293}            @{"SA_Depth" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 247}
@{"SA_DetailPen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 249}      @{"SA_DisplayID" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 288}        @{"SA_Draggable" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 349}
@{"SA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 238}          @{"SA_ErrorCode" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 260}        @{"SA_Exclusive" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 356}
@{"SA_Font" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 262}           @{"SA_FrontChild" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 411}       @{"SA_FullPalette" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 325}
@{"SA_Height" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 245}         @{"SA_Interleaved" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 384}      @{"SA_Left" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 242}
@{"SA_LikeWorkbench" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 427}  @{"SA_MinimizeISG" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 438}      @{"SA_Obsolete1" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 309}
@{"SA_Overscan" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 297}       @{"SA_Parent" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 342}           @{"SA_Pens" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 321}
@{"SA_PubName" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 278}        @{"SA_PubSig" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 283}           @{"SA_PubTask" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 284}
@{"SA_Quiet" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 317}          @{"SA_Reserved" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 435}         @{"SA_SharePens" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 365}
@{"SA_ShowTitle" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 313}      @{"SA_SysFont" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 264}          @{"SA_Title" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 252}
@{"SA_Top" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 243}            @{"SA_Type" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 269}             @{"SA_VideoControl" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 404}
@{"SA_Width" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 244}          @{"SB_COPY_BITMAP" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 654}      @{"SB_SCREEN_BITMAP" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 653}
@{"SCREENBEHIND" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 206}      @{"SCREENHIRES" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 212}         @{"SCREENQUIET" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 209}
@{"SCREENTYPE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 194}        @{"SDEPTH_CHILDONLY" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 599}    @{"SDEPTH_INFAMILY" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 593}
@{"SDEPTH_TOBACK" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 592}     @{"SDEPTH_TOFRONT" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 591}      @{"SHADOWPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 98}
@{"SHANGHAI" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 567}          @{"SHINEPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 97}            @{"SHOWTITLE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 200}
@{"SPOS_ABSOLUTE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 625}     @{"SPOS_FORCEDRAG" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 634}      @{"SPOS_MAKEVISIBLE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 629}
@{"SPOS_RELATIVE" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 623}     @{"STDSCREENHEIGHT" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 225}     @{"STDSCREENWIDTH" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 226}
@{"TEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 96}           @{"WBENCHSCREEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 196}        

@ENDNODE
@NODE File "intuition/screens.h"
#ifndef INTUITION_SCREENS_H
#define INTUITION_SCREENS_H TRUE
/*
**  $VER: screens.h 38.25 (15.2.1993)
**  Includes Release 45.1
**
**  The Screen and NewScreen structures and attributes
**
**  (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif

#ifndef GRAPHICS_CLIP_H
#include <@{"graphics/clip.h" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File"}>
#endif

#ifndef GRAPHICS_VIEW_H
#include <@{"graphics/view.h" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File"}>
#endif

#ifndef GRAPHICS_RASTPORT_H
#include <@{"graphics/rastport.h" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File"}>
#endif

#ifndef GRAPHICS_LAYERS_H
#include <@{"graphics/layers.h" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*
 * NOTE:  @{"intuition/iobsolete.h" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File"} is included at the END of this file!
 */

/* ======================================================================== */
/* === DrawInfo ========================================================= */
/* ======================================================================== */

/* This is a packet of information for graphics rendering.  It originates
 * with a Screen, and is gotten using @{"GetScreenDrawInfo" LINK "gg:doc/NDK/Guide/intuition/GetScreenDrawInfo"}( screen );
 */

/* You can use the Intuition version number to tell which fields are
 * present in this structure.
 *
 * @{"DRI_VERSION" LINK File 64} of 1 corresponds to V37 release.
 * @{"DRI_VERSION" LINK File 64} of 2 corresponds to V39, and includes three new pens
 *      and the dri_CheckMark and dri_AmigaKey fields.
 *
 * Note that sometimes applications need to create their own DrawInfo
 * structures, in which case the @{"DRI_VERSION" LINK File 64} won't correspond exactly
 * to the OS version!!!
 */
#define DRI_VERSION     (2)

struct DrawInfo
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       dri_Version;    /* will be  @{"DRI_VERSION" LINK File 64}                 */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       dri_NumPens;    /* guaranteed to be >= 9                */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       *dri_Pens;      /* pointer to pen array                 */

    @{"struct TextFont" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 89}     *dri_Font;      /* screen default font          */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}       dri_Depth;      /* (initial) depth of screen bitmap     */

    struct      /* from DisplayInfo database for initial display mode */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   X;
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   Y;
    }           dri_Resolution;

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       dri_Flags;              /* defined below                */
/* New for V39: dri_CheckMark, dri_AmigaKey. */
    @{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705}        *dri_CheckMark; /* pointer to scaled checkmark image
                                         * Will be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} if @{"DRI_VERSION" LINK File 64} < 2
                                         */
    @{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705}        *dri_AmigaKey;  /* pointer to scaled Amiga-key image
                                         * Will be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} if @{"DRI_VERSION" LINK File 64} < 2
                                         */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       dri_Reserved[5];        /* avoid recompilation ;^)      */
};

#define DRIF_NEWLOOK    0x00000001L     /* specified @{"SA_Pens" LINK File 321}, full treatment */

/* rendering pen number indexes into DrawInfo.dri_Pens[]        */
#define DETAILPEN        (0x0000)       /* compatible Intuition rendering pens  */
#define BLOCKPEN         (0x0001)       /* compatible Intuition rendering pens  */
#define TEXTPEN          (0x0002)       /* text on background                   */
#define SHINEPEN         (0x0003)       /* bright edge on 3D objects            */
#define SHADOWPEN        (0x0004)       /* dark edge on 3D objects              */
#define FILLPEN          (0x0005)       /* active-window/selected-gadget fill   */
#define FILLTEXTPEN      (0x0006)       /* text over @{"FILLPEN" LINK File 99}                    */
#define BACKGROUNDPEN    (0x0007)       /* may not always be color 0            */
#define HIGHLIGHTTEXTPEN (0x0008)       /* special color text, on background    */
/* New for V39, only present if @{"DRI_VERSION" LINK File 64} >= 2: */
#define BARDETAILPEN     (0x0009)       /* text/detail in screen-bar/menus */
#define BARBLOCKPEN      (0x000A)       /* screen-bar/menus fill */
#define BARTRIMPEN       (0x000B)       /* trim under screen-bar */

#define NUMDRIPENS       (0x000C)


/* New for V39:  It is sometimes useful to specify that a pen value
 * is to be the complement of color zero to three.  The "magic" numbers
 * serve that purpose:
 */
#define PEN_C3          0xFEFC          /* Complement of color 3 */
#define PEN_C2          0xFEFD          /* Complement of color 2 */
#define PEN_C1          0xFEFE          /* Complement of color 1 */
#define PEN_C0          0xFEFF          /* Complement of color 0 */

/* ======================================================================== */
/* === Screen ============================================================= */
/* ======================================================================== */

/* VERY IMPORTANT NOTE ABOUT Screen->BitMap.  In the future, bitmaps
 * will need to grow.  The embedded instance of a bitmap in the screen
 * will no longer be large enough to hold the whole description of
 * the bitmap.
 *
 * YOU ARE STRONGLY URGED to use Screen->RastPort.BitMap in place of
 * &Screen->BitMap whenever and whereever possible.
 */

struct Screen
{
    struct Screen *NextScreen;          /* linked list of screens */
    @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *FirstWindow;         /* linked list Screen's Windows */

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} LeftEdge, TopEdge;             /* parameters of the screen */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} Width, Height;                 /* parameters of the screen */

    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} MouseY, MouseX;                /* position relative to upper-left */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} Flags;                        /* see definitions below */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *@{"Title" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_macros.h/File" 294};                       /* null-terminated Title text */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *DefaultTitle;                /* for Windows without ScreenTitle */

    /* Bar sizes for this Screen and all Window's in this Screen */
    /* Note that BarHeight is one less than the actual menu bar
     * height.  We're going to keep this in V36 for compatibility,
     * although V36 artwork might use that extra pixel
     *
     * Also, the title bar height of a window is calculated from the
     * screen's WBorTop field, plus the font height, plus one.
     */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} BarHeight, BarVBorder, BarHBorder, MenuVBorder, MenuHBorder;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} WBorTop, WBorLeft, WBorRight, WBorBottom;

    @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} *Font;              /* this screen's default font      */

    /* the display data structures for this Screen */
    @{"struct ViewPort" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 47} ViewPort;           /* describing the Screen's display */
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} RastPort;           /* describing Screen rendering     */
    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} BitMap;               /* SEE WARNING ABOVE!              */
    @{"struct Layer_Info" LINK "gg:doc/NDK/Guide/Include/graphics/layers.h/File" 31} LayerInfo;        /* each screen gets a LayerInfo    */

    /* Only system gadgets may be attached to a screen.
     *  You get the standard system Screen Gadgets automatically
     */
    @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *FirstGadget;

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} DetailPen, BlockPen;          /* for bar/border/gadget rendering */

    /* the following variable(s) are maintained by Intuition to support the
     * @{"DisplayBeep()" LINK "gg:doc/NDK/Guide/intuition/DisplayBeep"} color flashing technique
     */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} SaveColor0;

    /* This layer is for the Screen and Menu bars */
    @{"struct Layer" LINK "gg:doc/NDK/Guide/Include/graphics/clip.h/File" 27} *BarLayer;

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *ExtData;

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *UserData;    /* general-purpose pointer to User data extension */

    /**** Data below this point are SYSTEM PRIVATE ****/
};


/* --- FLAGS SET BY INTUITION --------------------------------------------- */
/* The @{"SCREENTYPE" LINK File 194} bits are reserved for describing various Screen types
 * available under Intuition.
 */
#define SCREENTYPE      0x000F  /* all the screens types available      */
/* --- the definitions for the Screen Type ------------------------------- */
#define WBENCHSCREEN    0x0001  /* identifies the Workbench screen      */
#define PUBLICSCREEN    0x0002  /* public shared (custom) screen        */
#define CUSTOMSCREEN    0x000F  /* original custom screens              */

#define SHOWTITLE       0x0010  /* this gets set by a call to @{"ShowTitle()" LINK "gg:doc/NDK/Guide/intuition/ShowTitle"} */

#define BEEPING         0x0020  /* set when Screen is beeping (private) */

#define CUSTOMBITMAP    0x0040  /* if you are supplying your own BitMap */

#define SCREENBEHIND    0x0080  /* if you want your screen to open behind
                                 * already open screens
                                 */
#define SCREENQUIET     0x0100  /* if you do not want Intuition to render
                                 * into your screen (gadgets, title)
                                 */
#define SCREENHIRES     0x0200  /* do not use lowres gadgets  (private) */

#define NS_EXTENDED     0x1000          /* ExtNewScreen.Extension is valid      */
/* V36 applications can use @{"OpenScreenTagList()" LINK "gg:doc/NDK/Guide/intuition/OpenScreenTagList"} instead of @{"NS_EXTENDED" LINK File 214}  */

#define AUTOSCROLL      0x4000  /* screen is to autoscoll               */

/* New for V39: */
#define PENSHARED       0x0400  /* Screen opener set {@{"SA_SharePens" LINK File 365},@{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}} */




#define STDSCREENHEIGHT -1      /* supply in NewScreen.Height           */
#define STDSCREENWIDTH -1       /* supply in NewScreen.Width            */

/*
 * Screen attribute tag ID's.  These are used in the ti_Tag field of
 * TagItem arrays passed to @{"OpenScreenTagList()" LINK "gg:doc/NDK/Guide/intuition/OpenScreenTagList"} (or in the
 * ExtNewScreen.Extension field).
 */

/* Screen attribute tags.  Please use these versions, not those in
 * iobsolete.h.
 */

#define SA_Dummy        (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 32)
/*
 * these items specify items equivalent to fields in NewScreen
 */
#define SA_Left         (@{"SA_Dummy" LINK File 238} + 0x0001)
#define SA_Top          (@{"SA_Dummy" LINK File 238} + 0x0002)
#define SA_Width        (@{"SA_Dummy" LINK File 238} + 0x0003)
#define SA_Height       (@{"SA_Dummy" LINK File 238} + 0x0004)
                        /* traditional screen positions and dimensions  */
#define SA_Depth        (@{"SA_Dummy" LINK File 238} + 0x0005)
                        /* screen bitmap depth                          */
#define SA_DetailPen    (@{"SA_Dummy" LINK File 238} + 0x0006)
                        /* serves as default for windows, too           */
#define SA_BlockPen     (@{"SA_Dummy" LINK File 238} + 0x0007)
#define SA_Title        (@{"SA_Dummy" LINK File 238} + 0x0008)
                        /* default screen title                         */
#define SA_Colors       (@{"SA_Dummy" LINK File 238} + 0x0009)
                        /* ti_Data is an array of @{"struct ColorSpec" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1446},
                         * terminated by ColorIndex = -1.  Specifies
                         * initial screen palette colors.
                         * Also see @{"SA_Colors32" LINK File 391} for use under V39.
                         */
#define SA_ErrorCode    (@{"SA_Dummy" LINK File 238} + 0x000A)
                        /* ti_Data points to @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} error code (values below)*/
#define SA_Font         (@{"SA_Dummy" LINK File 238} + 0x000B)
                        /* equiv. to NewScreen.Font                     */
#define SA_SysFont      (@{"SA_Dummy" LINK File 238} + 0x000C)
                        /* Selects one of the preferences system fonts:
                         *      0 - old DefaultFont, fixed-width
                         *      1 - WB Screen preferred font
                         */
#define SA_Type         (@{"SA_Dummy" LINK File 238} + 0x000D)
                        /* ti_Data is @{"PUBLICSCREEN" LINK File 197} or @{"CUSTOMSCREEN" LINK File 198}.  For other
                         * fields of NewScreen.Type, see individual tags,
                         * eg. @{"SA_Behind" LINK File 315}, @{"SA_Quiet" LINK File 317}.
                         */
#define SA_BitMap       (@{"SA_Dummy" LINK File 238} + 0x000E)
                        /* ti_Data is pointer to custom BitMap.  This
                         * implies type of @{"CUSTOMBITMAP" LINK File 204}
                         */
#define SA_PubName      (@{"SA_Dummy" LINK File 238} + 0x000F)
                        /* presence of this tag means that the screen
                         * is to be a public screen.  Please specify
                         * BEFORE the two tags below
                         */
#define SA_PubSig       (@{"SA_Dummy" LINK File 238} + 0x0010)
#define SA_PubTask      (@{"SA_Dummy" LINK File 238} + 0x0011)
                        /* Task ID and signal for being notified that
                         * the last window has closed on a public screen.
                         */
#define SA_DisplayID    (@{"SA_Dummy" LINK File 238} + 0x0012)
                        /* ti_Data is new extended display ID from
                         * <@{"graphics/displayinfo.h" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File"}> (V37) or from
                         * <@{"graphics/modeid.h" LINK "gg:doc/NDK/Guide/Include/graphics/modeid.h/File"}> (V39 and up)
                         */
#define SA_DClip        (@{"SA_Dummy" LINK File 238} + 0x0013)
                        /* ti_Data points to a rectangle which defines
                         * screen display clip region
                         */
#define SA_Overscan     (@{"SA_Dummy" LINK File 238} + 0x0014)
                        /* Set to one of the OSCAN_
                         * specifiers below to get a system standard
                         * overscan region for your display clip,
                         * screen dimensions (unless otherwise specified),
                         * and automatically centered position (partial
                         * support only so far).
                         * If you use this, you shouldn't specify
                         * @{"SA_DClip" LINK File 293}.  @{"SA_Overscan" LINK File 297} is for "standard"
                         * overscan dimensions, @{"SA_DClip" LINK File 293} is for
                         * your custom numeric specifications.
                         */
#define SA_Obsolete1    (@{"SA_Dummy" LINK File 238} + 0x0015)
                        /* obsolete S_MONITORNAME                       */

/** booleans **/
#define SA_ShowTitle    (@{"SA_Dummy" LINK File 238} + 0x0016)
                        /* boolean equivalent to flag @{"SHOWTITLE" LINK File 200}         */
#define SA_Behind       (@{"SA_Dummy" LINK File 238} + 0x0017)
                        /* boolean equivalent to flag @{"SCREENBEHIND" LINK File 206}      */
#define SA_Quiet        (@{"SA_Dummy" LINK File 238} + 0x0018)
                        /* boolean equivalent to flag @{"SCREENQUIET" LINK File 209}       */
#define SA_AutoScroll   (@{"SA_Dummy" LINK File 238} + 0x0019)
                        /* boolean equivalent to flag @{"AUTOSCROLL" LINK File 217}        */
#define SA_Pens         (@{"SA_Dummy" LINK File 238} + 0x001A)
                        /* pointer to ~0 terminated @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} array, as
                         * found in @{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66}
                         */
#define SA_FullPalette  (@{"SA_Dummy" LINK File 238} + 0x001B)
                        /* boolean: initialize color table to entire
                         *  preferences palette (32 for V36), rather
                         * than compatible pens 0-3, 17-19, with
                         * remaining palette as returned by @{"GetColorMap()" LINK "gg:doc/NDK/Guide/graphics/GetColorMap"}
                         */

#define SA_ColorMapEntries (@{"SA_Dummy" LINK File 238} + 0x001C)
                        /* New for V39:
                         * Allows you to override the number of entries
                         * in the ColorMap for your screen.  Intuition
                         * normally allocates (1<<depth) or 32, whichever
                         * is more, but you may require even more if you
                         * use certain V39 @{"graphics.library" LINK "gg:doc/NDK/Guide/graphics/MAIN"} features
                         * (eg. palette-banking).
                         */

#define SA_Parent       (@{"SA_Dummy" LINK File 238} + 0x001D)
                        /* New for V39:
                         * ti_Data is a pointer to a "parent" screen to
                         * attach this one to.  Attached screens slide
                         * and depth-arrange together.
                         */

#define SA_Draggable    (@{"SA_Dummy" LINK File 238} + 0x001E)
                        /* New for V39:
                         * Boolean tag allowing non-draggable screens.
                         * Do not use without good reason!
                         * (Defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}).
                         */

#define SA_Exclusive    (@{"SA_Dummy" LINK File 238} + 0x001F)
                        /* New for V39:
                         * Boolean tag allowing screens that won't share
                         * the display.  Use sparingly!  Starting with 3.01,
                         * attached screens may be @{"SA_Exclusive" LINK File 356}.  Setting
                         * @{"SA_Exclusive" LINK File 356} for each screen will produce an
                         * exclusive family.   (Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}).
                         */

#define SA_SharePens    (@{"SA_Dummy" LINK File 238} + 0x0020)
                        /* New for V39:
                         * For those pens in the screen's DrawInfo->dri_Pens,
                         * Intuition obtains them in shared mode (see
                         * @{"graphics.library/ObtainPen()" LINK "gg:doc/NDK/Guide/graphics/ObtainPen"}).  For compatibility,
                         * Intuition obtains the other pens of a public
                         * screen as @{"PEN_EXCLUSIVE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 233}.  Screens that wish to
                         * manage the pens themselves should generally set
                         * this tag to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.  This instructs Intuition to
                         * leave the other pens unallocated.
                         */

#define SA_BackFill     (@{"SA_Dummy" LINK File 238} + 0x0021)
                        /* New for V39:
                         * provides a "backfill hook" for your screen's
                         * Layer_Info.
                         * See @{"layers.library/InstallLayerInfoHook()" LINK "gg:doc/NDK/Guide/layers/InstallLayerInfoHook"}
                         */

#define SA_Interleaved  (@{"SA_Dummy" LINK File 238} + 0x0022)
                        /* New for V39:
                         * Boolean tag requesting that the bitmap
                         * allocated for you be interleaved.
                         * (Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}).
                         */

#define SA_Colors32     (@{"SA_Dummy" LINK File 238} + 0x0023)
                        /* New for V39:
                         * Tag to set the screen's initial palette colors
                         * at 32 bits-per-gun.  ti_Data is a pointer
                         * to a table to be passed to the
                         * @{"graphics.library/LoadRGB32()" LINK "gg:doc/NDK/Guide/graphics/LoadRGB32"} function.
                         * This format supports both runs of color
                         * registers and sparse registers.  See the
                         * autodoc for that function for full details.
                         * Any color set here has precedence over
                         * the same register set by @{"SA_Colors" LINK File 254}.
                         */

#define SA_VideoControl (@{"SA_Dummy" LINK File 238} + 0x0024)
                        /* New for V39:
                         * ti_Data is a pointer to a taglist that Intuition
                         * will pass to @{"graphics.library/VideoControl()" LINK "gg:doc/NDK/Guide/graphics/VideoControl"},
                         * upon opening the screen.
                         */

#define SA_FrontChild   (@{"SA_Dummy" LINK File 238} + 0x0025)
                        /* New for V39:
                         * ti_Data is a pointer to an already open screen
                         * that is to be the child of the screen being
                         * opened.  The child screen will be moved to the
                         * front of its family.
                         */

#define SA_BackChild    (@{"SA_Dummy" LINK File 238} + 0x0026)
                        /* New for V39:
                         * ti_Data is a pointer to an already open screen
                         * that is to be the child of the screen being
                         * opened.  The child screen will be moved to the
                         * back of its family.
                         */

#define SA_LikeWorkbench        (@{"SA_Dummy" LINK File 238} + 0x0027)
                        /* New for V39:
                         * Set ti_Data to 1 to request a screen which
                         * is just like the Workbench.  This gives
                         * you the same screen mode, depth, size,
                         * colors, etc., as the Workbench screen.
                         */

#define SA_Reserved             (@{"SA_Dummy" LINK File 238} + 0x0028)
                        /* Reserved for private Intuition use */

#define SA_MinimizeISG          (@{"SA_Dummy" LINK File 238} + 0x0029)
                        /* New for V40:
                         * For compatibility, Intuition always ensures
                         * that the inter-screen gap is at least three
                         * non-interlaced lines.  If your application
                         * would look best with the smallest possible
                         * inter-screen gap, set ti_Data to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.
                         * If you use the new graphics @{"VideoControl()" LINK "gg:doc/NDK/Guide/graphics/VideoControl"}
                         * @{"VC_NoColorPaletteLoad" LINK "gg:doc/NDK/Guide/Include/graphics/videocontrol.h/File" 100} tag for your screen's
                         * ViewPort, you should also set this tag.
                         */

/* this is an obsolete tag included only for compatibility with V35
 * interim release for the A2024 and Viking monitors
 */
#ifndef NSTAG_EXT_VPMODE
#define NSTAG_EXT_VPMODE (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} | 1)
#endif


/* @{"OpenScreen" LINK "gg:doc/NDK/Guide/intuition/OpenScreen"} error codes, which are returned in the (optional) @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}
 * pointed to by ti_Data for the @{"SA_ErrorCode" LINK File 260} tag item
 */
#define OSERR_NOMONITOR    (1)  /* named monitor spec not available     */
#define OSERR_NOCHIPS      (2)  /* you need newer custom chips          */
#define OSERR_NOMEM        (3)  /* couldn't get normal memory           */
#define OSERR_NOCHIPMEM    (4)  /* couldn't get chipmem                 */
#define OSERR_PUBNOTUNIQUE (5)  /* public screen name already used      */
#define OSERR_UNKNOWNMODE  (6)  /* don't recognize mode asked for       */
#define OSERR_TOODEEP      (7)  /* Screen deeper than HW supports       */
#define OSERR_ATTACHFAIL   (8)  /* Failed to attach screens             */
#define OSERR_NOTAVAILABLE (9)  /* Mode not available for other reason  */

/* ======================================================================== */
/* === NewScreen ========================================================== */
/* ======================================================================== */
/* note: to use the Extended field, you must use the
 * new ExtNewScreen structure, below
 */
struct NewScreen
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} LeftEdge, TopEdge, Width, Height, Depth;  /* screen dimensions */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} DetailPen, BlockPen;  /* for bar/border/gadget rendering      */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ViewModes;            /* the Modes for the ViewPort (and View) */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} Type;                 /* the Screen type (see defines above)  */

    @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} *Font;      /* this Screen's default text attributes */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *DefaultTitle;        /* the default title for this Screen    */

    @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *Gadgets;     /* UNUSED:  Leave this @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}             */

    /* if you are opening a @{"CUSTOMSCREEN" LINK File 198} and already have a BitMap
     * that you want used for your Screen, you set the flags @{"CUSTOMBITMAP" LINK File 204} in
     * the Type field and you set this variable to point to your BitMap
     * structure.  The structure will be copied into your Screen structure,
     * after which you may discard your own BitMap if you want
     */
    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *CustomBitMap;
};

/*
 * For compatibility reasons, we need a new structure for extending
 * NewScreen.  Use this structure is you need to use the new Extension
 * field.
 *
 * NOTE: V36-specific applications should use the
 * @{"OpenScreenTagList" LINK "gg:doc/NDK/Guide/intuition/OpenScreenTagList"}( newscreen, tags ) version of @{"OpenScreen()" LINK "gg:doc/NDK/Guide/intuition/OpenScreen"}.
 * Applications that want to be V34-compatible as well may safely use the
 * ExtNewScreen structure.  Its tags will be ignored by V34 Intuition.
 *
 */
struct ExtNewScreen
{
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} LeftEdge, TopEdge, Width, Height, Depth;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} DetailPen, BlockPen;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ViewModes;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} Type;
    @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} *Font;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *DefaultTitle;
    @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *Gadgets;
    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *CustomBitMap;

    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}      *Extension;
                                /* more specification data, scanned if
                                 * @{"NS_EXTENDED" LINK File 214} is set in NewScreen.Type
                                 */
};

/* === Overscan Types ===       */
#define OSCAN_TEXT      (1)     /* entirely visible     */
#define OSCAN_STANDARD  (2)     /* just past edges      */
#define OSCAN_MAX       (3)     /* as much as possible  */
#define OSCAN_VIDEO     (4)     /* even more than is possible   */


/* === Public Shared Screen Node ===    */

/* This is the representative of a public shared screen.
 * This is an internal data structure, but some functions may
 * present a copy of it to the calling application.  In that case,
 * be aware that the screen pointer of the structure can @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} be
 * used safely, since there is no guarantee that the referenced
 * screen will remain open and a valid data structure.
 *
 * Never change one of these.
 */

struct PubScreenNode    {
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}         psn_Node;       /* ln_Name is screen name */
    @{"struct Screen" LINK File 133}       *psn_Screen;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}               psn_Flags;      /* below                */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                psn_Size;       /* includes name buffer */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                psn_VisitorCount; /* how many visitor windows */
    @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24}         *psn_SigTask;   /* who to signal when visitors gone */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}               psn_SigBit;     /* which signal */
};

#define PSNF_PRIVATE    (0x0001)

/* NOTE: Due to a bug in @{"NextPubScreen()" LINK "gg:doc/NDK/Guide/intuition/NextPubScreen"}, make sure your buffer
 * actually has @{"MAXPUBSCREENNAME" LINK File 564}+1 characters in it!
 */
#define MAXPUBSCREENNAME        (139)   /* names no longer, please      */

/* pub screen modes     */
#define SHANGHAI        0x0001  /* put workbench windows on pub screen */
#define POPPUBSCREEN    0x0002  /* pop pub screen to front when visitor opens */

/* New for V39:  Intuition has new screen depth-arrangement and movement
 * functions called @{"ScreenDepth()" LINK "gg:doc/NDK/Guide/intuition/ScreenDepth"} and @{"ScreenPosition()" LINK "gg:doc/NDK/Guide/intuition/ScreenPosition"} respectively.
 * These functions permit the old behavior of @{"ScreenToFront()" LINK "gg:doc/NDK/Guide/intuition/ScreenToFront"},
 * @{"ScreenToBack()" LINK "gg:doc/NDK/Guide/intuition/ScreenToBack"}, and @{"MoveScreen()" LINK "gg:doc/NDK/Guide/intuition/MoveScreen"}.  @{"ScreenDepth()" LINK "gg:doc/NDK/Guide/intuition/ScreenDepth"} also allows
 * independent depth control of attached screens.  @{"ScreenPosition()" LINK "gg:doc/NDK/Guide/intuition/ScreenPosition"}
 * optionally allows positioning screens even though they were opened
 * {@{"SA_Draggable" LINK File 349},@{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}}.
 */

/* For @{"ScreenDepth()" LINK "gg:doc/NDK/Guide/intuition/ScreenDepth"}, specify one of @{"SDEPTH_TOFRONT" LINK File 591} or @{"SDEPTH_TOBACK" LINK File 592},
 * and optionally also @{"SDEPTH_INFAMILY" LINK File 593}.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * @{"SDEPTH_INFAMILY" LINK File 593}.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.  (Note that this is a style-behavior
 * requirement;  there is no technical requirement that the
 * task calling this function need be the task which opened
 * the screen).
 */

#define SDEPTH_TOFRONT                  (0)     /* Bring screen to front */
#define SDEPTH_TOBACK           (1)     /* Send screen to back */
#define SDEPTH_INFAMILY         (2)     /* Move an attached screen with
                                         * respect to other screens of
                                         * its family
                                         */

/* Here's an obsolete name equivalent to @{"SDEPTH_INFAMILY" LINK File 593}: */
#define SDEPTH_CHILDONLY        @{"SDEPTH_INFAMILY" LINK File 593}


/* For @{"ScreenPosition()" LINK "gg:doc/NDK/Guide/intuition/ScreenPosition"}, specify one of @{"SPOS_RELATIVE" LINK File 623}, @{"SPOS_ABSOLUTE" LINK File 625},
 * or @{"SPOS_MAKEVISIBLE" LINK File 629} to describe the kind of screen positioning you
 * wish to perform:
 *
 * @{"SPOS_RELATIVE" LINK File 623}: The x1 and y1 parameters to @{"ScreenPosition()" LINK "gg:doc/NDK/Guide/intuition/ScreenPosition"} describe
 *      the offset in coordinates you wish to move the screen by.
 * @{"SPOS_ABSOLUTE" LINK File 625}: The x1 and y1 parameters to @{"ScreenPosition()" LINK "gg:doc/NDK/Guide/intuition/ScreenPosition"} describe
 *      the absolute coordinates you wish to move the screen to.
 * @{"SPOS_MAKEVISIBLE" LINK File 629}: (x1,y1)-(x2,y2) describes a rectangle on the
 *      screen which you would like autoscrolled into view.
 *
 * You may additionally set @{"SPOS_FORCEDRAG" LINK File 634} along with any of the
 * above.  Set this if you wish to reposition an {@{"SA_Draggable" LINK File 349},@{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}}
 * screen that you opened.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * @{"SPOS_FORCEDRAG" LINK File 634}.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.
 */

#define SPOS_RELATIVE           (0)     /* Coordinates are relative */

#define SPOS_ABSOLUTE           (1)     /* Coordinates are expressed as
                                         * absolutes, not relatives.
                                         */

#define SPOS_MAKEVISIBLE        (2)     /* Coordinates describe a box on
                                         * the screen you wish to be
                                         * made visible by autoscrolling
                                         */

#define SPOS_FORCEDRAG          (4)     /* Move non-draggable screen */

/* New for V39: Intuition supports double-buffering in screens,
 * with friendly interaction with menus and certain gadgets.
 * For each buffer, you need to get one of these structures
 * from the @{"AllocScreenBuffer()" LINK "gg:doc/NDK/Guide/intuition/AllocScreenBuffer"} call.  Never allocate your
 * own ScreenBuffer structures!
 *
 * The sb_DBufInfo field is for your use.  See the @{"graphics.library" LINK "gg:doc/NDK/Guide/graphics/MAIN"}
 * @{"AllocDBufInfo()" LINK "gg:doc/NDK/Guide/graphics/AllocDBufInfo"} autodoc for details.
 */
struct ScreenBuffer
{
    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *sb_BitMap;           /* BitMap of this buffer */
    @{"struct DBufInfo" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 279} *sb_DBufInfo;       /* DBufInfo for this buffer */
};

/* These are the flags that may be passed to @{"AllocScreenBuffer()" LINK "gg:doc/NDK/Guide/intuition/AllocScreenBuffer"}.
 */
#define SB_SCREEN_BITMAP        1
#define SB_COPY_BITMAP          2

/* Include obsolete identifiers: */
#ifndef INTUITION_IOBSOLETE_H
#include <@{"intuition/iobsolete.h" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File"}>
#endif

#endif
@ENDNODE
