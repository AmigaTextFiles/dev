OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/libraries/mui', 'target/utility/tagitem',
       'target/intuition/classusr', 'target/intuition/classes', 'target/graphics/gfx'
{#include <mui/TheBar_mcc.h>}
NATIVE {THEBAR_MCC_H} CONST

/*
** TheBar.mcc - Next Generation Toolbar MUI Custom Class
** Copyright (C) 2003-2008 Alfonso Ranieri
**
** TheBar is developed by TheBar.mcc Open Source Team
**
** This library is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License as published by the Free Software Foundation; either
** version 2.1 of the License, or (at your option) any later version.
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
** Lesser General Public License for more details.
**
** TheBar class Support Site: http://www.sf.net/projects/thebar
**
** $Id: TheBar_mcc.h 295 2009-05-23 12:02:04Z marust $
** $URL: https://thebar.svn.sourceforge.net/svnroot/thebar/trunk/include/mui/TheBar_mcc.h $
**
**/

NATIVE {MUIC_TheButton}     CONST
#define MUIC_TheButton muic_thebutton
STATIC muic_thebutton = 'TheButton.mcc'
NATIVE {MUIC_TheBar}     CONST
#define MUIC_TheBar muic_thebar
STATIC muic_thebar = 'TheBar.mcc'
NATIVE {MUIC_TheBarVirt}     CONST
#define MUIC_TheBarVirt muic_thebarvirt
STATIC muic_thebarvirt = 'TheBarVirt.mcc'

/*#if defined(__AROS__) && !defined(NO_INLINE_STDARG)
#define TheButtonObject   MUIOBJMACRO_START(MUIC_TheButton)
#define TheBarObject      MUIOBJMACRO_START(MUIC_TheBar)
#define TheBarVirtObject  MUIOBJMACRO_START(MUIC_TheBarVirt)
#else*/
NATIVE {TheButtonObject} CONST
#define TheButtonObject   Mui_NewObject(MUIC_TheButton
NATIVE {TheBarObject} CONST
#define TheBarObject      Mui_NewObject(MUIC_TheBar
NATIVE {TheBarVirtObject} CONST
#define TheBarVirtObject  Mui_NewObject(MUIC_TheBarVirt
->#endif

NATIVE {THEBAR_VERSION}     CONST THEBAR_VERSION     =21
NATIVE {THEBARVIRT_VERSION} CONST THEBARVIRT_VERSION =21
NATIVE {THEBUTTON_VERSION}  CONST THEBUTTON_VERSION  =21
        
/***********************************************************************/

NATIVE {TBUTTAGBASE} CONST TBUTTAGBASE =$F76B01C8
NATIVE {TBTAGBASE}   CONST TBTAGBASE   =$F76B022C

/***********************************************************************/
/*
** TheBar.mcc Methods
*/

NATIVE {MUIM_TheBar_Rebuild}      CONST MUIM_TheBar_Rebuild        = (TBTAGBASE+0)   /* v11 PRIVATE */
NATIVE {MUIM_TheBar_DeActivate}   CONST MUIM_TheBar_DeActivate     = (TBTAGBASE+2)   /* v11 PRIVATE */
NATIVE {MUIM_TheBar_AddButton}    CONST MUIM_TheBar_AddButton      = (TBTAGBASE+3)   /* v11         */
NATIVE {MUIM_TheBar_AddSpacer}    CONST MUIM_TheBar_AddSpacer      = (TBTAGBASE+4)   /* v11 PRIVATE */
NATIVE {MUIM_TheBar_GetObject}    CONST MUIM_TheBar_GetObject      = (TBTAGBASE+5)   /* v11         */
NATIVE {MUIM_TheBar_DoOnButton}   CONST MUIM_TheBar_DoOnButton     = (TBTAGBASE+6)   /* v11         */
NATIVE {MUIM_TheBar_SetAttr}      CONST MUIM_TheBar_SetAttr        = (TBTAGBASE+7)   /* v11         */
NATIVE {MUIM_TheBar_GetAttr}      CONST MUIM_TheBar_GetAttr        = (TBTAGBASE+8)   /* v11         */
NATIVE {MUIM_TheBar_Clear}        CONST MUIM_TheBar_Clear          = (TBTAGBASE+9)   /* v11         */
NATIVE {MUIM_TheBar_Sort}         CONST MUIM_TheBar_Sort           = (TBTAGBASE+10)  /* v11         */
NATIVE {MUIM_TheBar_Remove}       CONST MUIM_TheBar_Remove         = (TBTAGBASE+11)  /* v11         */
NATIVE {MUIM_TheBar_GetDragImage} CONST MUIM_TheBar_GetDragImage   = (TBTAGBASE+12)  /* v11         */
NATIVE {MUIM_TheBar_Notify}       CONST MUIM_TheBar_Notify         = (TBTAGBASE+13)  /* v21         */
NATIVE {MUIM_TheBar_KillNotify}   CONST MUIM_TheBar_KillNotify     = (TBTAGBASE+14)  /* v21         */

/***********************************************************************/
/*
** TheBar.mcc Methods structures
*/

NATIVE {MUIP_TheBar_AddButton}    OBJECT  muip_thebar_addbutton
 {MethodID} methodid:ULONG
 {button} button:PTR TO muis_thebar_button
ENDOBJECT
NATIVE {MUIP_TheBar_AddSpacer}    OBJECT  muip_thebar_addspacer
 {MethodID} methodid:ULONG
 {ID} id:ULONG
 {type} type:ULONG
ENDOBJECT
NATIVE {MUIP_TheBar_GetObject}    OBJECT  muip_thebar_getobject
 {MethodID} methodid:ULONG
 {ID} id:ULONG
ENDOBJECT
NATIVE {MUIP_TheBar_DoOnButton}   OBJECT  muip_thebar_doonbutton
 {MethodID} methodid:ULONG
 {ID} id:ULONG
 {method} method:ULONG
 /* ...args... */
ENDOBJECT
NATIVE {MUIP_TheBar_SetAttr}      OBJECT  muip_thebar_setattr
 {MethodID} methodid:ULONG
 {ID} id:ULONG
 {attr} attr:TAG
 {value} value:ULONG
ENDOBJECT
NATIVE {MUIP_TheBar_GetAttr}      OBJECT  muip_thebar_getattr
 {MethodID} methodid:ULONG
 {ID} id:ULONG
 {attr} attr:TAG
 {storage} storage:PTR TO ULONG
ENDOBJECT
NATIVE {MUIP_TheBar_Sort}         OBJECT  muip_thebar_sort
 {MethodID} methodid:ULONG
 {obj} obj[1]:ARRAY OF LONG
ENDOBJECT
NATIVE {MUIP_TheBar_Remove}       OBJECT  muip_thebar_remove
 {MethodID} methodid:ULONG
 {ID} id:ULONG
ENDOBJECT
NATIVE {MUIP_TheBar_GetDragImage} OBJECT  muip_thebar_getdragimage
 {MethodID} methodid:ULONG
 {horiz} horiz:ULONG
 {flags} flags:ULONG
ENDOBJECT
NATIVE {MUIP_TheBar_Notify}       OBJECT  muip_thebar_notify
 {MethodID} methodid:ULONG
 {ID} id:ULONG
 {attr} attr:TAG
 {value} value:ULONG
 {dest} dest:PTR TO INTUIOBJECT
 {followParams} followParams:ULONG
 /* ... */
ENDOBJECT
NATIVE {MUIP_TheBar_KillNotify}   OBJECT  muip_thebar_killnotify
 {MethodID} methodid:ULONG
 {ID} id:ULONG
 {attr} attr:TAG
 {dest} dest:PTR TO INTUIOBJECT
ENDOBJECT

/* MUIM_TheBar_SetAttr, MUIM_TheBar_GetAttr attributes */
NATIVE {MUIV_TheBar_Attr_Hide}     CONST  MUIV_TheBar_Attr_Hide     = (TBTAGBASE+0) /* v11 */
NATIVE {MUIV_TheBar_Attr_Sleep}    CONST  MUIV_TheBar_Attr_Sleep    = (TBTAGBASE+1) /* v11 */
NATIVE {MUIV_TheBar_Attr_Disabled} CONST  MUIV_TheBar_Attr_Disabled = (TBTAGBASE+2) /* v11 */
NATIVE {MUIV_TheBar_Attr_Selected} CONST  MUIV_TheBar_Attr_Selected = (TBTAGBASE+3) /* v11 */

/***********************************************************************/
/*
** TheBar.mcc Attributes
*/

NATIVE {MUIA_TheBar_MinVer}                CONST MUIA_TheBar_MinVer               = (TBTAGBASE+10)  /* v11 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_Buttons}               CONST MUIA_TheBar_Buttons              = (TBTAGBASE+11)  /* v11 struct MUIS_TheBar_Button *,   [I...]   */
NATIVE {MUIA_TheBar_Images}                CONST MUIA_TheBar_Images               = (TBTAGBASE+12)  /* v11 struct MUIS_TheBar_Brush **,   [I.G.]   */
NATIVE {MUIA_TheBar_Pics}                  CONST MUIA_TheBar_Pics                 = (TBTAGBASE+13)  /* v11 STRTR *,                       [I...]   */
NATIVE {MUIA_TheBar_PicsDrawer}            CONST MUIA_TheBar_PicsDrawer           = (TBTAGBASE+14)  /* v11 STRTR,                         [I...]   */
NATIVE {MUIA_TheBar_ViewMode}              CONST MUIA_TheBar_ViewMode             = (TBTAGBASE+15)  /* v11 UINT,                         [ISGN]   */
NATIVE {MUIA_TheBar_Borderless}            CONST MUIA_TheBar_Borderless           = (TBTAGBASE+16)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_Raised}                CONST MUIA_TheBar_Raised               = (TBTAGBASE+17)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_Sunny}                 CONST MUIA_TheBar_Sunny                = (TBTAGBASE+18)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_Scaled}                CONST MUIA_TheBar_Scaled               = (TBTAGBASE+19)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_SpacerIndex}           CONST MUIA_TheBar_SpacerIndex          = (TBTAGBASE+20)  /* v11 ULONG,                         [I.G.]   */
NATIVE {MUIA_TheBar_Strip}                 CONST MUIA_TheBar_Strip                = (TBTAGBASE+21)  /* v11 STRPTR,                        [I...]   */
NATIVE {MUIA_TheBar_StripBrush}            CONST MUIA_TheBar_StripBrush           = (TBTAGBASE+22)  /* v11 struct MUIS_TheBar_Brush *,    [I...]   */
NATIVE {MUIA_TheBar_EnableKeys}            CONST MUIA_TheBar_EnableKeys           = (TBTAGBASE+23)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_TextOnly}              CONST MUIA_TheBar_TextOnly             = (TBTAGBASE+24)  /* v11 BOOL,                          [..G.]   */
NATIVE {MUIA_TheBar_LabelPos}              CONST MUIA_TheBar_LabelPos             = (TBTAGBASE+25)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_BarPos}                CONST MUIA_TheBar_BarPos               = (TBTAGBASE+26)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_DragBar}               CONST MUIA_TheBar_DragBar              = (TBTAGBASE+27)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_Frame}                 CONST MUIA_TheBar_Frame                = (TBTAGBASE+28)  /* v11 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_Limbo}                 CONST MUIA_TheBar_Limbo                = (TBTAGBASE+29)  /* v11 BOOL,                          [.S..]   */
NATIVE {MUIA_TheBar_Active}                CONST MUIA_TheBar_Active               = (TBTAGBASE+30)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_Columns}               CONST MUIA_TheBar_Columns              = (TBTAGBASE+31)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_Rows}                  CONST MUIA_TheBar_Rows                 = (TBTAGBASE+32)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_FreeHoriz}             CONST MUIA_TheBar_FreeHoriz            = (TBTAGBASE+33)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_FreeVert}              CONST MUIA_TheBar_FreeVert             = (TBTAGBASE+34)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_Free}                  CONST MUIA_TheBar_Free                 = (TBTAGBASE+35)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_BarSpacer}             CONST MUIA_TheBar_BarSpacer            = (TBTAGBASE+36)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_RemoveSpacers}         CONST MUIA_TheBar_RemoveSpacers        = (TBTAGBASE+37)  /* v11 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_SelImages}             CONST MUIA_TheBar_SelImages            = (TBTAGBASE+39)  /* v12 struct MUIS_TheBar_Brush **,   [I.G.]   */
NATIVE {MUIA_TheBar_DisImages}             CONST MUIA_TheBar_DisImages            = (TBTAGBASE+40)  /* v12 struct MUIS_TheBar_Brush **,   [I.G.]   */
NATIVE {MUIA_TheBar_SelPics}               CONST MUIA_TheBar_SelPics              = (TBTAGBASE+41)  /* v12 STRTR *,                       [I...]   */
NATIVE {MUIA_TheBar_DisPics}               CONST MUIA_TheBar_DisPics              = (TBTAGBASE+42)  /* v12 STRTR *,                       [I...]   */
NATIVE {MUIA_TheBar_SelStrip}              CONST MUIA_TheBar_SelStrip             = (TBTAGBASE+43)  /* v12 STRPTR,                        [I...]   */
NATIVE {MUIA_TheBar_DisStrip}              CONST MUIA_TheBar_DisStrip             = (TBTAGBASE+44)  /* v12 STRPTR,                        [I...]   */
NATIVE {MUIA_TheBar_SelStripBrush}         CONST MUIA_TheBar_SelStripBrush        = (TBTAGBASE+45)  /* v12 struct MUIS_TheBar_Brush *,    [I...]   */
NATIVE {MUIA_TheBar_DisStripBrush}         CONST MUIA_TheBar_DisStripBrush        = (TBTAGBASE+46)  /* v12 struct MUIS_TheBar_Brush *,    [I...]   */
NATIVE {MUIA_TheBar_StripRows}             CONST MUIA_TheBar_StripRows            = (TBTAGBASE+47)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_StripCols}             CONST MUIA_TheBar_StripCols            = (TBTAGBASE+48)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_StripHSpace}           CONST MUIA_TheBar_StripHSpace          = (TBTAGBASE+49)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_StripVSpace}           CONST MUIA_TheBar_StripVSpace          = (TBTAGBASE+50)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_HorizSpacing}          CONST MUIA_TheBar_HorizSpacing         = (TBTAGBASE+51)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_VertSpacing}           CONST MUIA_TheBar_VertSpacing          = (TBTAGBASE+52)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_BarSpacerSpacing}      CONST MUIA_TheBar_BarSpacerSpacing     = (TBTAGBASE+53)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_HorizInnerSpacing}     CONST MUIA_TheBar_HorizInnerSpacing    = (TBTAGBASE+54)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_TopInnerSpacing}       CONST MUIA_TheBar_TopInnerSpacing      = (TBTAGBASE+55)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_BottomInnerSpacing}    CONST MUIA_TheBar_BottomInnerSpacing   = (TBTAGBASE+56)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_LeftBarFrameSpacing}   CONST MUIA_TheBar_LeftBarFrameSpacing  = (TBTAGBASE+57)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_RightBarFrameSpacing}  CONST MUIA_TheBar_RightBarFrameSpacing = (TBTAGBASE+58)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_TopBarFrameSpacing}    CONST MUIA_TheBar_TopBarFrameSpacing   = (TBTAGBASE+59)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_BottomBarFrameSpacing} CONST MUIA_TheBar_BottomBarFrameSpacing= (TBTAGBASE+60)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_HorizTextGfxSpacing}   CONST MUIA_TheBar_HorizTextGfxSpacing  = (TBTAGBASE+61)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_VertTextGfxSpacing}    CONST MUIA_TheBar_VertTextGfxSpacing   = (TBTAGBASE+62)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_Precision}             CONST MUIA_TheBar_Precision            = (TBTAGBASE+63)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_Scale}                 CONST MUIA_TheBar_Scale                = (TBTAGBASE+65)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_DisMode}               CONST MUIA_TheBar_DisMode              = (TBTAGBASE+66)  /* v12 ULONG,                         [I...]   */
NATIVE {MUIA_TheBar_SpecialSelect}         CONST MUIA_TheBar_SpecialSelect        = (TBTAGBASE+67)  /* v12 BOOL,                          [I...]   */
NATIVE {MUIA_TheBar_TextOverUseShine}      CONST MUIA_TheBar_TextOverUseShine     = (TBTAGBASE+68)  /* v12 BOOL,                          [I...]   */
NATIVE {MUIA_TheBar_IgnoreSelImages}       CONST MUIA_TheBar_IgnoreSelImages      = (TBTAGBASE+69)  /* v12 BOOL,                          [I...]   */
NATIVE {MUIA_TheBar_IgnoreDisImages}       CONST MUIA_TheBar_IgnoreDisImages      = (TBTAGBASE+70)  /* v12 BOOL,                          [I...]   */
NATIVE {MUIA_TheBar_DontMove}              CONST MUIA_TheBar_DontMove             = (TBTAGBASE+71)  /* v15 BOOL,                          [I...]   */
NATIVE {MUIA_TheBar_MouseOver}             CONST MUIA_TheBar_MouseOver            = (TBTAGBASE+72)  /* v18 ULONG,                         [ISGN]   */
NATIVE {MUIA_TheBar_NtRaiseActive}         CONST MUIA_TheBar_NtRaiseActive        = (TBTAGBASE+73)  /* v18 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_SpacersSize}           CONST MUIA_TheBar_SpacersSize          = (TBTAGBASE+74)  /* v18 BOOL,                          [ISGN]   */
NATIVE {MUIA_TheBar_Appearance}            CONST MUIA_TheBar_Appearance           = (TBTAGBASE+75)  /* v19 struct MUIS_TheBar_Appearance, [..G.]   */
NATIVE {MUIA_TheBar_IgnoreAppearance}      CONST MUIA_TheBar_IgnoreAppearance     = (TBTAGBASE+76)  /* v19 BOOL                           [ISGN]   */

/***********************************************************************/
/*
** TheBar.mcc Attributes values
*/

/* MUIA_TheBar_ViewMode */
NATIVE {MUIV_TheBar_ViewMode_TextGfx} CONST
NATIVE {MUIV_TheBar_ViewMode_Gfx} CONST
NATIVE {MUIV_TheBar_ViewMode_Text} CONST
NATIVE {MUIV_TheBar_ViewMode_Last} CONST
ENUM MUIV_TheBar_ViewMode_TextGfx,
  MUIV_TheBar_ViewMode_Gfx,
  MUIV_TheBar_ViewMode_Text,
  MUIV_TheBar_ViewMode_Last

/* MUIA_TheBar_LabelPos */
NATIVE {MUIV_TheBar_LabelPos_Bottom} CONST
NATIVE {MUIV_TheBar_LabelPos_Top} CONST
NATIVE {MUIV_TheBar_LabelPos_Right} CONST
NATIVE {MUIV_TheBar_LabelPos_Left} CONST
NATIVE {MUIV_TheBar_LabelPos_Last} CONST
ENUM MUIV_TheBar_LabelPos_Bottom,
  MUIV_TheBar_LabelPos_Top,
  MUIV_TheBar_LabelPos_Right,
  MUIV_TheBar_LabelPos_Left,
  MUIV_TheBar_LabelPos_Last 

/* MUIA_TheBar_BarPos */
NATIVE {MUIV_TheBar_BarPos_Left} CONST
NATIVE {MUIV_TheBar_BarPos_Center} CONST
NATIVE {MUIV_TheBar_BarPos_Right} CONST
NATIVE {MUIV_TheBar_BarPos_Last} CONST
ENUM MUIV_TheBar_BarPos_Left,
  MUIV_TheBar_BarPos_Center,
  MUIV_TheBar_BarPos_Right,
  MUIV_TheBar_BarPos_Last  

NATIVE {MUIV_TheBar_BarPos_Up} CONST
#define MUIV_TheBar_BarPos_Up   MUIV_TheBar_BarPos_Left
NATIVE {MUIV_TheBar_BarPos_Down} CONST
#define  MUIV_TheBar_BarPos_Down MUIV_TheBar_BarPos_Right

/* MUIA_TheBar_RemoveSpacers */
NATIVE {MUIV_TheBar_RemoveSpacers_Bar}    CONST MUIV_TheBar_RemoveSpacers_Bar    = 1 SHL 0 /* v11 */
NATIVE {MUIV_TheBar_RemoveSpacers_Button} CONST MUIV_TheBar_RemoveSpacers_Button = 1 SHL 1 /* v11 */
NATIVE {MUIV_TheBar_RemoveSpacers_Image}  CONST MUIV_TheBar_RemoveSpacers_Image  = 1 SHL 2 /* v11 */
NATIVE {MUIV_TheBar_RemoveSpacers_All}    CONST MUIV_TheBar_RemoveSpacers_All    = MUIV_TheBar_RemoveSpacers_Bar OR MUIV_TheBar_RemoveSpacers_Button OR MUIV_TheBar_RemoveSpacers_Image

/* MUIA_TheBar_Precision */
NATIVE {MUIV_TheBar_Precision_GUI} CONST
NATIVE {MUIV_TheBar_Precision_Icon} CONST
NATIVE {MUIV_TheBar_Precision_Image} CONST
NATIVE {MUIV_TheBar_Precision_Exact} CONST
NATIVE {MUIV_TheBar_Precision_Last} CONST
ENUM MUIV_TheBar_Precision_GUI,
  MUIV_TheBar_Precision_Icon,
  MUIV_TheBar_Precision_Image,
  MUIV_TheBar_Precision_Exact,
  MUIV_TheBar_Precision_Last 

/* MUIA_TheBar_DisMode */
NATIVE {MUIV_TheBar_DisMode_Shape} CONST
NATIVE {MUIV_TheBar_DisMode_Grid} CONST
NATIVE {MUIV_TheBar_DisMode_FullGrid} CONST
NATIVE {MUIV_TheBar_DisMode_Sunny} CONST
NATIVE {MUIV_TheBar_DisMode_Blend} CONST
NATIVE {MUIV_TheBar_DisMode_BlendGrey} CONST
NATIVE {MUIV_TheBar_DisMode_Last} CONST
ENUM MUIV_TheBar_DisMode_Shape,
  MUIV_TheBar_DisMode_Grid,
  MUIV_TheBar_DisMode_FullGrid,
  MUIV_TheBar_DisMode_Sunny,
  MUIV_TheBar_DisMode_Blend,
  MUIV_TheBar_DisMode_BlendGrey,
  MUIV_TheBar_DisMode_Last     

/* MUIA_TheBar_SpacersSize */
NATIVE {MUIV_TheBar_SpacersSize_Quarter} CONST
NATIVE {MUIV_TheBar_SpacersSize_Half} CONST
NATIVE {MUIV_TheBar_SpacersSize_One} CONST
NATIVE {MUIV_TheBar_SpacersSize_None} CONST
NATIVE {MUIV_TheBar_SpacersSize_OnePoint} CONST
NATIVE {MUIV_TheBar_SpacersSize_TwoPoint} CONST
NATIVE {MUIV_TheBar_SpacersSize_Last} CONST
ENUM MUIV_TheBar_SpacersSize_Quarter,
  MUIV_TheBar_SpacersSize_Half,
  MUIV_TheBar_SpacersSize_One,
  MUIV_TheBar_SpacersSize_None,
  MUIV_TheBar_SpacersSize_OnePoint,
  MUIV_TheBar_SpacersSize_TwoPoint,
  MUIV_TheBar_SpacersSize_Last    

/* These are private for now */
NATIVE {MUIV_TheBar_SpacersSize_PointsFlag} CONST MUIV_TheBar_SpacersSize_PointsFlag = $40

NATIVE {MUIV_TheBar_SpacersSize_Points} CONST
#define MUIV_TheBar_SpacersSize_Points(x)    (MUIV_TheBar_SpacersSize_PointsFlag OR ((x!!ULONG) AND $3f))
NATIVE {MUIV_TheBar_SpacersSize_GetPoints} CONST
#define MUIV_TheBar_SpacersSize_GetPoints(x) ((x)!!ULONG AND $3f)
NATIVE {MUIV_TheBar_SpacersSize_IsValid} CONST
#define MUIV_TheBar_SpacersSize_IsValid(x)   (IF ((x)!!ULONG AND MUIV_TheBar_SpacersSize_PointsFlag) THEN (((x)!!ULONG AND $ffffffbf)<=$3f) ELSE ((x)!!ULONG<MUIV_TheBar_SpacersSize_Last))

NATIVE {MUIV_TheBar_SkipPic} CONST
#define MUIV_TheBar_SkipPic ((STRPTR)(-1))

/***********************************************************************/
/*
** Structures
*/

/*
** MUIA_TheButton_Image is a pointer to this.
** MUIA_TheBar_Images is an array of pointers to this.
**/
NATIVE {MUIS_TheBar_Brush} OBJECT  muis_thebar_brush
  {data}  data:APTR             /* Source data - actually it may be only a UBYTE *            */
  {dataWidth} dataWidth:UINT        /* Width of data                                              */
  {dataHeight} dataHeight:UINT       /* Height of data                                             */
  {dataTotalWidth} dataTotalWidth:UINT   /* Total width of data                                        */
  {left} left:UINT             /* Left offset in data of this brush                          */
  {top} top:UINT              /* Top offset in data of this brush                           */
  {width} width:UINT            /* Width of this brush                                        */
  {height} height:UINT           /* Height of this brush                                       */
  {colors} colors:ARRAY OF ULONG          /* R,G,B or $00RRGGBB ULONG table                            */
  {numColors} numColors:ULONG        /* Number of colors in colors                                 */
  {trColor} trColor:ULONG          /* Transparent color number; 0<=trColor<256 !                 */
  {compressedSize} compressedSize:ULONG   /* If data is byte run 1 compressed, it is its POSITIVE size  */
  {flags} flags:ULONG            /* As it says                                                 */
  {reserved} reserved[4]:ARRAY OF ULONG      /* Avoid recompilation                                        */
ENDOBJECT

NATIVE {BRFLG_ARGB}       CONST BRFLG_ARGB      = 1 SHL 0
NATIVE {BRFLG_AlphaMask}  CONST BRFLG_AlphaMask = 1 SHL 1
NATIVE {BRFLG_ColorRGB8}  CONST BRFLG_ColorRGB8 = 1 SHL 2
NATIVE {BRFLG_EmptyAlpha} CONST BRFLG_EmptyAlpha = 1 SHL 16

/*
** MUIA_TheButton_Strip is a pointer to this.
**/
NATIVE {MUIS_TheBar_Strip} OBJECT  muis_thebar_strip
  {normalBM} normalbm:PTR TO bitmap   /* Normal BitMap        */
  {greyBM} greybm:PTR TO bitmap     /* Grey normal BitMap   */
  {mask} mask:PTR TO bitmap       /* Normal mask          */

  {snormalBM} snormalbm:PTR TO bitmap  /* Selected BitMap      */
  {sgreyBM} sgreybm:PTR TO bitmap    /* Selected grey BitMap */
  {smask} smask:PTR TO bitmap      /* Selected mask        */

  {dnormalBM} dnormalbm:PTR TO bitmap  /* Disabled BitMap      */
  {dgreyBM} dgreybm:PTR TO bitmap    /* Grey disabled BitMap */
  {dmask} dmask:PTR TO bitmap      /* Grey mask            */

  {nchunky}	nchunky:ARRAY OF UBYTE
  {gchunky}	gchunky:ARRAY OF UBYTE
  {snchunky} snchunky:ARRAY OF UBYTE
  {sgchunky} sgchunky:ARRAY OF UBYTE
  {dnchunky} dnchunky:ARRAY OF UBYTE
  {dgchunky} dgchunky:ARRAY OF UBYTE
ENDOBJECT

/*
** MUIA_TheBar_Buttons is an array of this.
*/
NATIVE {MUIS_TheBar_Button} OBJECT  muis_thebar_button
  {img}  img:ULONG     /* Image index                                          */
  {ID}   id:ULONG      /* Button ID                                            */
  {text} text:PTR TO CHAR  /* Button label (max TB_MAXLABELLEN) not copied!        */
  {help} help:PTR TO CHAR  /* Button help not copied!                              */
  {flags}         flags:ULONG   /* See below                                            */
  {exclude}         exclude:ULONG /* Exclude mask                                         */
  {_class} _class:PTR TO iclass/* Easy way of getting a bar of subclassed buttons      */
  {obj}        obj:PTR TO INTUIOBJECT    /* Filled when the button is created                    */
ENDOBJECT

/* flags */
NATIVE {MUIV_TheBar_ButtonFlag_NoClick}   CONST MUIV_TheBar_ButtonFlag_NoClick   = 1 SHL 0 /* v11 MUIA_InputMode is MUIV_InputMode_None      */
NATIVE {MUIV_TheBar_ButtonFlag_Immediate} CONST MUIV_TheBar_ButtonFlag_Immediate = 1 SHL 1 /* v11 MUIA_InputMode is MUIV_InputMode_Immediate */
NATIVE {MUIV_TheBar_ButtonFlag_Toggle}    CONST MUIV_TheBar_ButtonFlag_Toggle    = 1 SHL 2 /* v11 MUIA_InputMode is MUIV_InputMode_Toggle    */
NATIVE {MUIV_TheBar_ButtonFlag_Disabled}  CONST MUIV_TheBar_ButtonFlag_Disabled  = 1 SHL 3 /* v11 MUIA_Disabled is TRUE                      */
NATIVE {MUIV_TheBar_ButtonFlag_Selected}  CONST MUIV_TheBar_ButtonFlag_Selected  = 1 SHL 4 /* v11 MUIA_Selected is TRUE                      */
NATIVE {MUIV_TheBar_ButtonFlag_Sleep}     CONST MUIV_TheBar_ButtonFlag_Sleep     = 1 SHL 5 /* v11 MUIA_ShowMe is FALSE                       */
NATIVE {MUIV_TheBar_ButtonFlag_Hide}      CONST MUIV_TheBar_ButtonFlag_Hide      = 1 SHL 6 /* v11 MUIA_ShowMe is FALSE                       */

/* Special img values */
NATIVE {MUIV_TheBar_End}          CONST MUIV_TheBar_End           = (-1) /* v11 Ends a MUIS_TheBar_Button array    */
NATIVE {MUIV_TheBar_BarSpacer}    CONST MUIV_TheBar_BarSpacer     = (-2) /* v11 Add a spacer                       */
NATIVE {MUIV_TheBar_ButtonSpacer} CONST MUIV_TheBar_ButtonSpacer  = (-3) /* v11 Add a space spacer                 */
NATIVE {MUIV_TheBar_ImageSpacer}  CONST MUIV_TheBar_ImageSpacer   = (-4) /* v11 Add an image  spacer               */

/* Returned by MUIM_TheBar_GetDragImage */
NATIVE {MUIS_TheBar_DragImage} OBJECT  muis_thebar_dragimage
  {width}                width:ULONG
  {height}                height:ULONG
  {bitMap} bitmap:PTR TO bitmap
  {di} di:PTR ->TO mui_dragimage      /* Defined in MUIundoc.h */
  {dummy}                dummy[8]:ARRAY OF ULONG  /* Avoid recompilation   */
ENDOBJECT

/* MUIA_TheBar_Appearance */
NATIVE {MUIS_TheBar_Appearance} OBJECT  muis_thebar_appearance
  {viewMode} viewMode:ULONG
  {flags} flags:ULONG
  {labelPos} labelPos:ULONG
  {dummy} dummy[2]:ARRAY OF ULONG
ENDOBJECT

/* flags */
NATIVE {MUIV_TheBar_Appearance_Borderless} CONST MUIV_TheBar_Appearance_Borderless = 1 SHL 0
NATIVE {MUIV_TheBar_Appearance_Raised}     CONST MUIV_TheBar_Appearance_Raised     = 1 SHL 1
NATIVE {MUIV_TheBar_Appearance_Sunny}      CONST MUIV_TheBar_Appearance_Sunny      = 1 SHL 2
NATIVE {MUIV_TheBar_Appearance_Scaled}     CONST MUIV_TheBar_Appearance_Scaled     = 1 SHL 3
NATIVE {MUIV_TheBar_Appearance_BarSpacer}  CONST MUIV_TheBar_Appearance_BarSpacer  = 1 SHL 4
NATIVE {MUIV_TheBar_Appearance_EnableKeys} CONST MUIV_TheBar_Appearance_EnableKeys = 1 SHL 5

/***********************************************************************/
/*
** Methods
*/

NATIVE {MUIM_TheButton_Build}      CONST MUIM_TheButton_Build              = (TBUTTAGBASE+0)   /* v13         */
NATIVE {MUIM_TheButton_SendNotify} CONST MUIM_TheButton_SendNotify         = (TBUTTAGBASE+1)   /* v21 PRIVATE */
        
NATIVE {MUIP_TheButton_SendNotify} OBJECT  muip_thebutton_sendnotify
  {MethodID} methodid:ULONG
  {notify} notify:APTR
  {trigVal} trigVal:ULONG
ENDOBJECT

/***********************************************************************/
/*
** TheButton.mcc Attributes
*/

NATIVE {MUIA_TheButton_MinVer}              CONST MUIA_TheButton_MinVer             = (TBUTTAGBASE+0)   /* v11  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_MouseOver}           CONST MUIA_TheButton_MouseOver          = (TBUTTAGBASE+1)   /* v11  BOOL                           [I...]    */ /* PRIVATE */
NATIVE {MUIA_TheButton_Quiet}               CONST MUIA_TheButton_Quiet              = (TBUTTAGBASE+2)   /* v11  BOOL                           [.S..]    */
NATIVE {MUIA_TheButton_Spacer}              CONST MUIA_TheButton_Spacer             = (TBUTTAGBASE+3)   /* v11  BOOL                           [I.G.]    */ /* PRIVATE */
NATIVE {MUIA_TheButton_TheBar}              CONST MUIA_TheButton_TheBar             = (TBUTTAGBASE+4)   /* v11  Object *,                      [ISG.]    */
NATIVE {MUIA_TheButton_Image}               CONST MUIA_TheButton_Image              = (TBUTTAGBASE+5)   /* v11  struct MUIS_TheBar_Brush  *,   [I...]    */
NATIVE {MUIA_TheButton_Label}               CONST MUIA_TheButton_Label              = (TBUTTAGBASE+6)   /* v11  STRPTR,                        [I...]    */
NATIVE {MUIA_TheButton_InVirtgroup}         CONST MUIA_TheButton_InVirtgroup        = (TBUTTAGBASE+7)   /* v11  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_ViewMode}            CONST MUIA_TheButton_ViewMode           = (TBUTTAGBASE+8)   /* v11  ULONG,                         [ISGN]    */
NATIVE {MUIA_TheButton_Borderless}          CONST MUIA_TheButton_Borderless         = (TBUTTAGBASE+9)   /* v11  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_Raised}              CONST MUIA_TheButton_Raised             = (TBUTTAGBASE+10)  /* v11  BOOL,                          [ISGN]    */
NATIVE {MUIA_TheButton_Sunny}               CONST MUIA_TheButton_Sunny              = (TBUTTAGBASE+11)  /* v11  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_Scaled}              CONST MUIA_TheButton_Scaled             = (TBUTTAGBASE+12)  /* v11  BOOL,                          [ISGN]    */
NATIVE {MUIA_TheButton_NoClick}             CONST MUIA_TheButton_NoClick            = (TBUTTAGBASE+13)  /* v11  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_Toggle}              CONST MUIA_TheButton_Toggle             = (TBUTTAGBASE+14)  /* v11  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_Immediate}           CONST MUIA_TheButton_Immediate          = (TBUTTAGBASE+15)  /* v11  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_EnableKey}           CONST MUIA_TheButton_EnableKey          = (TBUTTAGBASE+16)  /* v11  BOOL,                          [ISG.]    */
NATIVE {MUIA_TheButton_LabelPos}            CONST MUIA_TheButton_LabelPos           = (TBUTTAGBASE+17)  /* v11  ULONG,                         [ISGN]    */
NATIVE {MUIA_TheButton_SelImage}            CONST MUIA_TheButton_SelImage           = (TBUTTAGBASE+18)  /* v12  struct MUIS_TheBar_Brush  *,   [I...]    */
NATIVE {MUIA_TheButton_DisImage}            CONST MUIA_TheButton_DisImage           = (TBUTTAGBASE+19)  /* v12  struct MUIS_TheBar_Brush  *,   [I...]    */
NATIVE {MUIA_TheButton_HorizTextGfxSpacing} CONST MUIA_TheButton_HorizTextGfxSpacing= (TBUTTAGBASE+20)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_VertTextGfxSpacing}  CONST MUIA_TheButton_VertTextGfxSpacing = (TBUTTAGBASE+21)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_HorizInnerSpacing}   CONST MUIA_TheButton_HorizInnerSpacing  = (TBUTTAGBASE+22)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_TopInnerSpacing}     CONST MUIA_TheButton_TopInnerSpacing    = (TBUTTAGBASE+23)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_BottomInnerSpacing}  CONST MUIA_TheButton_BottomInnerSpacing = (TBUTTAGBASE+24)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_Precision}           CONST MUIA_TheButton_Precision          = (TBUTTAGBASE+25)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_Event}               CONST MUIA_TheButton_Event              = (TBUTTAGBASE+26)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_Scale}               CONST MUIA_TheButton_Scale              = (TBUTTAGBASE+27)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_DisMode}             CONST MUIA_TheButton_DisMode            = (TBUTTAGBASE+28)  /* v12  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_SpecialSelect}       CONST MUIA_TheButton_SpecialSelect      = (TBUTTAGBASE+29)  /* v12  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_TextOverUseShine}    CONST MUIA_TheButton_TextOverUseShine   = (TBUTTAGBASE+30)  /* v12  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_IgnoreSelImages}     CONST MUIA_TheButton_IgnoreSelImages    = (TBUTTAGBASE+31)  /* v12  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_IgnoreDisImages}     CONST MUIA_TheButton_IgnoreDisImages    = (TBUTTAGBASE+32)  /* v12  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_Strip}               CONST MUIA_TheButton_Strip              = (TBUTTAGBASE+33)  /* v13  struct MUIS_TheBar_Strip *,    [I...]    */
NATIVE {MUIA_TheButton_DontMove}            CONST MUIA_TheButton_DontMove           = (TBUTTAGBASE+34)  /* v15  BOOL,                          [I...]    */
NATIVE {MUIA_TheButton_ID}                  CONST MUIA_TheButton_ID                 = (TBUTTAGBASE+35)  /* v18  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_NtRaiseActive}       CONST MUIA_TheButton_NtRaiseActive      = (TBUTTAGBASE+36)  /* v18  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_StripRows}           CONST MUIA_TheButton_StripRows          = (TBUTTAGBASE+37)  /* v20  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_StripCols}           CONST MUIA_TheButton_StripCols          = (TBUTTAGBASE+38)  /* v20  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_StripHorizSpace}     CONST MUIA_TheButton_StripHorizSpace    = (TBUTTAGBASE+39)  /* v20  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_StripVertSpace}      CONST MUIA_TheButton_StripVertSpace     = (TBUTTAGBASE+40)  /* v20  ULONG,                         [I...]    */
NATIVE {MUIA_TheButton_NotifyList}          CONST MUIA_TheButton_NotifyList         = (TBUTTAGBASE+41)  /* v21  struct MinList *,              [..G.]    */ /* PRIVATE */

/***********************************************************************/
/*
** TheButton.mcc Attributes values
*/

/* MUIA_TheButton_ViewMode */
NATIVE {MUIV_TheButton_ViewMode_TextGfx} CONST
NATIVE {MUIV_TheButton_ViewMode_Gfx} CONST
NATIVE {MUIV_TheButton_ViewMode_Text} CONST
NATIVE {MUIV_TheButton_ViewMode_Last} CONST
ENUM MUIV_TheButton_ViewMode_TextGfx,
  MUIV_TheButton_ViewMode_Gfx,
  MUIV_TheButton_ViewMode_Text,
  MUIV_TheButton_ViewMode_Last

/* MUIA_TheButton_LabelPos */
NATIVE {MUIV_TheButton_LabelPos_Bottom} CONST
NATIVE {MUIV_TheButton_LabelPos_Top} CONST
NATIVE {MUIV_TheButton_LabelPos_Right} CONST
NATIVE {MUIV_TheButton_LabelPos_Left} CONST
NATIVE {MUIV_TheButton_LabelPos_Last} CONST
ENUM MUIV_TheButton_LabelPos_Bottom,
  MUIV_TheButton_LabelPos_Top,
  MUIV_TheButton_LabelPos_Right,
  MUIV_TheButton_LabelPos_Left,
  MUIV_TheButton_LabelPos_Last 

/* MUIA_TheButton_Spacer */
NATIVE {MUIV_TheButton_Spacer_None} CONST
NATIVE {MUIV_TheButton_Spacer_Bar} CONST
NATIVE {MUIV_TheButton_Spacer_Button} CONST
NATIVE {MUIV_TheButton_Spacer_Image} CONST
NATIVE {MUIV_TheButton_Spacer_DragBar} CONST
ENUM MUIV_TheButton_Spacer_None,
  MUIV_TheButton_Spacer_Bar,
  MUIV_TheButton_Spacer_Button,
  MUIV_TheButton_Spacer_Image,
  MUIV_TheButton_Spacer_DragBar

/* MUICFG_TheButton_FrameStyle */
NATIVE {MUIV_TheButton_FrameStyle_Recessed} CONST
NATIVE {MUIV_TheButton_FrameStyle_Normal} CONST
ENUM MUIV_TheButton_FrameStyle_Recessed,
  MUIV_TheButton_FrameStyle_Normal

/* MUIA_TheButton_Event */
NATIVE {MUIV_TheButton_Event_IntuiTicks} CONST
NATIVE {MUIV_TheButton_Event_MouseMove} CONST
NATIVE {MUIV_TheButton_Event_MouseObject} CONST
NATIVE {MUIV_TheButton_Event_Last} CONST
ENUM MUIV_TheButton_Event_IntuiTicks,
  MUIV_TheButton_Event_MouseMove,
  MUIV_TheButton_Event_MouseObject,
  MUIV_TheButton_Event_Last       

/* MUIA_TheButton_Precision */
NATIVE {MUIV_TheButton_Precision_GUI} CONST
NATIVE {MUIV_TheButton_Precision_Icon} CONST
NATIVE {MUIV_TheButton_Precision_Image} CONST
NATIVE {MUIV_TheButton_Precision_Exact} CONST
NATIVE {MUIV_TheButton_Precision_Last} CONST
ENUM MUIV_TheButton_Precision_GUI,
  MUIV_TheButton_Precision_Icon,
  MUIV_TheButton_Precision_Image,
  MUIV_TheButton_Precision_Exact,
  MUIV_TheButton_Precision_Last 

/* MUIA_TheButton_DisMode */
NATIVE {MUIV_TheButton_DisMode_Shape} CONST
NATIVE {MUIV_TheButton_DisMode_Grid} CONST
NATIVE {MUIV_TheButton_DisMode_FullGrid} CONST
NATIVE {MUIV_TheButton_DisMode_Sunny} CONST
NATIVE {MUIV_TheButton_DisMode_Blend} CONST
NATIVE {MUIV_TheButton_DisMode_BlendGrey} CONST
NATIVE {MUIV_TheButton_DisMode_Last} CONST
ENUM MUIV_TheButton_DisMode_Shape,
  MUIV_TheButton_DisMode_Grid,
  MUIV_TheButton_DisMode_FullGrid,
  MUIV_TheButton_DisMode_Sunny,
  MUIV_TheButton_DisMode_Blend,
  MUIV_TheButton_DisMode_BlendGrey,
  MUIV_TheButton_DisMode_Last     

/***********************************************************************/
/*
** TheButton.mcc Misc
*/

/* MUIA_TheButton_Label max size */
NATIVE {TB_MAXLABELLEN} CONST TB_MAXLABELLEN =32

