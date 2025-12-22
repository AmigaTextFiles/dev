@DATABASE "gg:doc/NDK/Guide/Include/intuition/imageclass.h"
@MASTER   "gg:os-include/intuition/imageclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:58
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/imageclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/imageclass.h" LINK File}


@{b}Structures@{ub}

@{"impDomainFrame" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 289}  @{"impDraw" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 224}  @{"impErase" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 247}  @{"impFrameBox" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 211}  @{"impHitTest" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 266}


@{b}#defines@{ub}

@{"AMIGAKEY" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 162}              @{"CHECKIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 158}            @{"CLOSEIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 152}
@{"CUSTOMIMAGEDEPTH" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 23}      @{"DEPTHIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 149}            @{"DOWNIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 157}
@{"FRAME_BUTTON" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 177}          @{"FRAME_DEFAULT" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 176}         @{"FRAME_ICONDROPBOX" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 179}
@{"FRAME_RIDGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 178}           @{"FRAMEF_SPECIFY" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 219}        @{"GADGET_BOX()" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 27}
@{"IA_ActivateKey" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 119}        @{"IA_APatSize" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 62}           @{"IA_APattern" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 61}
@{"IA_BGPen" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 40}              @{"IA_Data" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 42}               @{"IA_DoubleEmboss" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 67}
@{"IA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 33}              @{"IA_EdgesOnly" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 68}          @{"IA_FGPen" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 38}
@{"IA_Font" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 64}               @{"IA_FrameType" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 101}          @{"IA_Height" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 37}
@{"IA_HighlightPen" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 85}       @{"IA_Left" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 34}               @{"IA_LineWidth" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 46}
@{"IA_Mode" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 63}               @{"IA_Outline" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 65}            @{"IA_Pens" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 47}
@{"IA_Precision" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 130}          @{"IA_Recessed" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 66}           @{"IA_Resolution" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 54}
@{"IA_Scalable" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 113}           @{"IA_Screen" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 125}             @{"IA_ShadowPen" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 84}
@{"IA_SupportsDisable" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 92}    @{"IA_Top" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 35}                @{"IA_Underscore" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 108}
@{"IA_Width" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 36}              @{"IDOMAIN_MAXIMUM" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 303}       @{"IDOMAIN_MINIMUM" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 301}
@{"IDOMAIN_NOMINAL" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 302}       @{"IDS_BUSY" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 200}              @{"IDS_DISABLED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 199}
@{"IDS_INACTIVEDISABLED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 204}  @{"IDS_INACTIVENORMAL" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 202}    @{"IDS_INACTIVESELECTED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 203}
@{"IDS_INDETERMINANT" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 208}     @{"IDS_INDETERMINATE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 201}     @{"IDS_NORMAL" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 197}
@{"IDS_SELECTED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 198}          @{"IDS_SELECTEDDISABLED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 205}  @{"IM_BGPEN()" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 30}
@{"IM_BOX()" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 28}              @{"IM_DOMAINFRAME" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 192}        @{"IM_DRAW" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 183}
@{"IM_DRAWFRAME" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 188}          @{"IM_ERASE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 185}              @{"IM_ERASEFRAME" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 191}
@{"IM_FGPEN()" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 29}            @{"IM_FRAMEBOX" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 189}           @{"IM_HITFRAME" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 190}
@{"IM_HITTEST" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 184}            @{"IM_MOVE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 186}               @{"LEFTIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 154}
@{"MENUCHECK" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 161}             @{"MXIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 159}               @{"RIGHTIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 156}
@{"SDEPTHIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 153}           @{"SIZEIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 151}             @{"SYSIA_Depth" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 73}
@{"SYSIA_DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 79}        @{"SYSIA_Pens" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 83}            @{"SYSIA_ReferenceFont" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 88}
@{"SYSIA_Size" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 71}            @{"SYSIA_Which" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 77}           @{"SYSISIZE_HIRES" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 142}
@{"SYSISIZE_LOWRES" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 141}       @{"SYSISIZE_MEDRES" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 140}       @{"UPIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 155}
@{"ZOOMIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 150}             

@ENDNODE
@NODE File "intuition/imageclass.h"
#ifndef INTUITION_IMAGECLASS_H
#define INTUITION_IMAGECLASS_H
/*
**      $VER: imageclass.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      definitions for the system image classes
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/******************************************************/

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

/*
 * NOTE:  <@{"intuition/iobsolete.h" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File"}> is included at the END of this file!
 */

#define CUSTOMIMAGEDEPTH        (-1)
/* if image.Depth is this, it's a new Image class object */

/* some convenient macros and casts */
#define GADGET_BOX( g ) ( (@{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *) &((@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *)(g))->LeftEdge )
#define IM_BOX( im )    ( (@{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *) &((@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *)(im))->LeftEdge )
#define IM_FGPEN( im )  ( (im)->PlanePick )
#define IM_BGPEN( im )  ( (im)->PlaneOnOff )

/******************************************************/
#define IA_Dummy                (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 0x20000)
#define IA_Left                 (@{"IA_Dummy" LINK File 33} + 0x01)
#define IA_Top                  (@{"IA_Dummy" LINK File 33} + 0x02)
#define IA_Width                (@{"IA_Dummy" LINK File 33} + 0x03)
#define IA_Height               (@{"IA_Dummy" LINK File 33} + 0x04)
#define IA_FGPen                (@{"IA_Dummy" LINK File 33} + 0x05)
                    /* @{"IA_FGPen" LINK File 38} also means "PlanePick"  */
#define IA_BGPen                (@{"IA_Dummy" LINK File 33} + 0x06)
                    /* @{"IA_BGPen" LINK File 40} also means "PlaneOnOff" */
#define IA_Data                 (@{"IA_Dummy" LINK File 33} + 0x07)
                    /* bitplanes, for classic image,
                     * other image classes may use it for other things
                     */
#define IA_LineWidth            (@{"IA_Dummy" LINK File 33} + 0x08)
#define IA_Pens                 (@{"IA_Dummy" LINK File 33} + 0x0E)
                    /* pointer to @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pens[],
                     * ala DrawInfo.Pens, MUST be
                     * terminated by ~0.  Some classes can
                     * choose to have this, or @{"SYSIA_DrawInfo" LINK File 79},
                     * or both.
                     */
#define IA_Resolution           (@{"IA_Dummy" LINK File 33} + 0x0F)
                    /* packed uwords for x/y resolution into a longword
                     * ala DrawInfo.Resolution
                     */

/**** see class documentation to learn which    *****/
/**** classes recognize these                   *****/
#define IA_APattern             (@{"IA_Dummy" LINK File 33} + 0x10)
#define IA_APatSize             (@{"IA_Dummy" LINK File 33} + 0x11)
#define IA_Mode                 (@{"IA_Dummy" LINK File 33} + 0x12)
#define IA_Font                 (@{"IA_Dummy" LINK File 33} + 0x13)
#define IA_Outline              (@{"IA_Dummy" LINK File 33} + 0x14)
#define IA_Recessed             (@{"IA_Dummy" LINK File 33} + 0x15)
#define IA_DoubleEmboss         (@{"IA_Dummy" LINK File 33} + 0x16)
#define IA_EdgesOnly            (@{"IA_Dummy" LINK File 33} + 0x17)

/**** "sysiclass" attributes                    *****/
#define SYSIA_Size              (@{"IA_Dummy" LINK File 33} + 0x0B)
                    /* #define's below          */
#define SYSIA_Depth             (@{"IA_Dummy" LINK File 33} + 0x0C)
                    /* this is unused by Intuition.  @{"SYSIA_DrawInfo" LINK File 79}
                     * is used instead for V36
                     */
#define SYSIA_Which             (@{"IA_Dummy" LINK File 33} + 0x0D)
                    /* see #define's below      */
#define SYSIA_DrawInfo          (@{"IA_Dummy" LINK File 33} + 0x18)
                    /* pass to sysiclass, please */

/*****  obsolete: don't use these, use @{"IA_Pens" LINK File 47}  *****/
#define SYSIA_Pens              @{"IA_Pens" LINK File 47}
#define IA_ShadowPen            (@{"IA_Dummy" LINK File 33} + 0x09)
#define IA_HighlightPen         (@{"IA_Dummy" LINK File 33} + 0x0A)

/* New for V39: */
#define SYSIA_ReferenceFont     (@{"IA_Dummy" LINK File 33} + 0x19)
                    /* Font to use as reference for scaling
                     * certain sysiclass images
                     */
#define IA_SupportsDisable      (@{"IA_Dummy" LINK File 33} + 0x1a)
                    /* By default, Intuition ghosts gadgets itself,
                     * instead of relying on @{"IDS_DISABLED" LINK File 199} or
                     * @{"IDS_SELECTEDDISABLED" LINK File 205}.  An imageclass that
                     * supports these states should return this attribute
                     * as @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.  You cannot set or clear this attribute,
                     * however.
                     */

#define IA_FrameType            (@{"IA_Dummy" LINK File 33} + 0x1b)
                    /* Starting with V39, FrameIClass recognizes
                     * several standard types of frame.  Use one
                     * of the FRAME_ specifiers below.  Defaults
                     * to @{"FRAME_DEFAULT" LINK File 176}.
                     */

#define IA_Underscore           (@{"IA_Dummy" LINK File 33} + 0x1c)
                    /* V44, Indicate underscore keyboard shortcut for image labels.
                     * (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Defaults to '_'
                     */

#define IA_Scalable                     (@{"IA_Dummy" LINK File 33} + 0x1d)
                    /* V44, Attribute indicates this image is allowed
                         * to/can scale its rendering.
                     * (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}.
                     */

#define IA_ActivateKey                  (@{"IA_Dummy" LINK File 33} + 0x1e)
                    /* V44, Used to get an underscored label shortcut.
                     * Useful for labels attached to string gadgets.
                     * (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}.
                     */

#define IA_Screen                       (@{"IA_Dummy" LINK File 33} + 0x1f)
                    /* V44 Screen pointer, may be useful/required by certain classes.
                     * (@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *)
                     */

#define IA_Precision                    (@{"IA_Dummy" LINK File 33} + 0x20)
                    /* V44 Precision value, typically pen precision but may be
                     * used for similar custom purposes.
                     * (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})
                     */

/** next attribute: (@{"IA_Dummy" LINK File 33} + 0x21)   **/
/*************************************************/

/* data values for @{"SYSIA_Size" LINK File 71}   */
#define SYSISIZE_MEDRES (0)
#define SYSISIZE_LOWRES (1)
#define SYSISIZE_HIRES  (2)

/*
 * @{"SYSIA_Which" LINK File 77} tag data values:
 * Specifies which system gadget you want an image for.
 * Some numbers correspond to internal Intuition #defines
 */
#define DEPTHIMAGE      (0x00L) /* Window depth gadget image */
#define ZOOMIMAGE       (0x01L) /* Window zoom gadget image */
#define SIZEIMAGE       (0x02L) /* Window sizing gadget image */
#define CLOSEIMAGE      (0x03L) /* Window close gadget image */
#define SDEPTHIMAGE     (0x05L) /* Screen depth gadget image */
#define LEFTIMAGE       (0x0AL) /* Left-arrow gadget image */
#define UPIMAGE         (0x0BL) /* Up-arrow gadget image */
#define RIGHTIMAGE      (0x0CL) /* Right-arrow gadget image */
#define DOWNIMAGE       (0x0DL) /* Down-arrow gadget image */
#define CHECKIMAGE      (0x0EL) /* GadTools checkbox image */
#define MXIMAGE         (0x0FL) /* GadTools mutual exclude "button" image */
/* New for V39: */
#define MENUCHECK       (0x10L) /* Menu checkmark image */
#define AMIGAKEY        (0x11L) /* Menu Amiga-key image */

/* Data values for @{"IA_FrameType" LINK File 101} (recognized by FrameIClass)
 *
 * @{"FRAME_DEFAULT" LINK File 176}:  The standard V37-type frame, which has
 *      thin edges.
 * @{"FRAME_BUTTON" LINK File 177}:  Standard button gadget frames, having thicker
 *      sides and nicely edged corners.
 * @{"FRAME_RIDGE" LINK File 178}:  A ridge such as used by standard string gadgets.
 *      You can recess the ridge to get a groove image.
 * @{"FRAME_ICONDROPBOX" LINK File 179}: A broad ridge which is the standard imagery
 *      for areas in AppWindows where icons may be dropped.
 */

#define FRAME_DEFAULT           0
#define FRAME_BUTTON            1
#define FRAME_RIDGE             2
#define FRAME_ICONDROPBOX       3


/* image message id's   */
#define    IM_DRAW      0x202L  /* draw yourself, with "state" */
#define    IM_HITTEST   0x203L  /* return @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} if click hits image      */
#define    IM_ERASE     0x204L  /* erase yourself */
#define    IM_MOVE      0x205L  /* draw new and erase old, smoothly     */

#define    IM_DRAWFRAME 0x206L  /* draw with specified dimensions */
#define    IM_FRAMEBOX  0x207L  /* get recommended frame around some box*/
#define    IM_HITFRAME  0x208L  /* hittest with dimensions */
#define    IM_ERASEFRAME 0x209L /* erase with dimensions */
#define    IM_DOMAINFRAME       0x20AL  /* query image for its domain info (V44) */


/* image draw states or styles, for @{"IM_DRAW" LINK File 183} */
/* Note that they have no bitwise meanings (unfortunately) */
#define    IDS_NORMAL           (0L)
#define    IDS_SELECTED         (1L)    /* for selected gadgets     */
#define    IDS_DISABLED         (2L)    /* for disabled gadgets     */
#define    IDS_BUSY             (3L)    /* for future functionality */
#define    IDS_INDETERMINATE    (4L)    /* for future functionality */
#define    IDS_INACTIVENORMAL   (5L)    /* normal, in inactive window border */
#define    IDS_INACTIVESELECTED (6L)    /* selected, in inactive border */
#define    IDS_INACTIVEDISABLED (7L)    /* disabled, in inactive border */
#define    IDS_SELECTEDDISABLED (8L)    /* disabled and selected    */

/* oops, please forgive spelling error by jimm */
#define IDS_INDETERMINANT @{"IDS_INDETERMINATE" LINK File 201}

/* @{"IM_FRAMEBOX" LINK File 189}  */
struct impFrameBox {
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *imp_ContentsBox;       /* input: relative box of contents */
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *imp_FrameBox;          /* output: rel. box of encl frame  */
    @{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66}     *imp_DrInfo;    /* NB: May be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}       imp_FrameFlags;
};

#define @{"FRAMEF_SPECIFY" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 370}  (1<<0)  /* Make do with the dimensions of FrameBox
                                 * provided.
                                 */

/* @{"IM_DRAW" LINK File 183}, @{"IM_DRAWFRAME" LINK File 188}        */
struct impDraw
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}     *imp_RPort;
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    X;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Y;
    }                   imp_Offset;

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               imp_State;
    @{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66}     *imp_DrInfo;    /* NB: May be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} */

    /* these parameters only valid for @{"IM_DRAWFRAME" LINK File 188} */
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Width;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Height;
    }                   imp_Dimensions;
};

/* @{"IM_ERASE" LINK File 185}, @{"IM_ERASEFRAME" LINK File 191}      */
/* NOTE: This is a subset of impDraw    */
struct impErase
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}     *imp_RPort;
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    X;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Y;
    }                   imp_Offset;

    /* these parameters only valid for @{"IM_ERASEFRAME" LINK File 191} */
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Width;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Height;
    }                   imp_Dimensions;
};

/* @{"IM_HITTEST" LINK File 184}, @{"IM_HITFRAME" LINK File 190}      */
struct impHitTest
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    X;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Y;
    }                   imp_Point;

    /* these parameters only valid for @{"IM_HITFRAME" LINK File 190} */
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Width;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Height;
    }                   imp_Dimensions;
};


/* The @{"IM_DOMAINFRAME" LINK File 192} method is used to obtain the sizing
 * requirements of an image object within a layout group.
 */

/* @{"IM_DOMAINFRAME" LINK File 192} */
struct impDomainFrame
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                MethodID;
    @{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66}     *imp_DrInfo;    /* DrawInfo */
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}     *imp_RPort;     /* RastPort to layout for */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                 imp_Which;     /* what size - min/nominal/max */
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896}          imp_Domain;    /* Resulting domain */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}      *imp_Attrs;     /* Additional attributes */
};

/* Accepted vales for imp_Which.
 */
#define IDOMAIN_MINIMUM         (0)
#define IDOMAIN_NOMINAL         (1)
#define IDOMAIN_MAXIMUM         (2)

/* Include obsolete identifiers: */
#ifndef INTUITION_IOBSOLETE_H
#include <@{"intuition/iobsolete.h" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File"}>
#endif

#endif
@ENDNODE
