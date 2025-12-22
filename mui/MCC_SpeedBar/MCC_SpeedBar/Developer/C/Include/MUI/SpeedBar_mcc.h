#ifndef SPEEDBAR_MCC_H
#define SPEEDBAR_MCC_H

/*
**  $VER: SpeedBar_mcc.h 19.3 (30.6.2003)
**  Includes Release 19.3
**
**  (C) Copyright 2000-2003 Alfonso [alfie] Ranieri <alforan@tin.it>
**      Originally written by Simone Tellini
**      All rights reserved
*/

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

/***********************************************************************/

#define MUIC_SpeedBar  "SpeedBar.mcc"
#define SpeedBarObject MUI_NewObject(MUIC_SpeedBar

#define MUIC_SpeedBarVirt  "SpeedBarVirt.mcc"
#define SpeedBarVirtObject MUI_NewObject(MUIC_SpeedBarVirt

/***********************************************************************/

#define SBTAGBASE 0xF76B00A0

/***********************************************************************/
/*
** Methods
*/

#define MUIM_SpeedBar_AddButton       (SBTAGBASE+1)
#define MUIM_SpeedBar_AddButtonObject (SBTAGBASE+2)   /*  PRIVATE  */
#define MUIM_SpeedBar_AddSpacer       (SBTAGBASE+3)
#define MUIM_SpeedBar_Clear           (SBTAGBASE+4)
#define MUIM_SpeedBar_Rebuild         (SBTAGBASE+5)
#define MUIM_SpeedBar_AddNotify       (SBTAGBASE+6)   /*  PRIVATE  */
#define MUIM_SpeedBar_GetObject       (SBTAGBASE+7)
#define MUIM_SpeedBar_DoOnButton      (SBTAGBASE+8)
#define MUIM_SpeedBar_DeActivate      (SBTAGBASE+9)   /*  PRIVATE  */
#define MUIM_SpeedBar_GetDragImage    (SBTAGBASE+10)
#define MUIM_SpeedBar_Sort            (SBTAGBASE+11)
#define MUIM_SpeedBar_Remove          (SBTAGBASE+12)

/***********************************************************************/
/*
** Methods structures
*/

struct MUIP_SpeedBar_AddButton       { ULONG MethodID; struct MUIS_SpeedBar_Button *Button; };
struct MUIP_SpeedBar_AddButtonObject { ULONG MethodID; Object *Button; };
struct MUIP_SpeedBar_AddNotify       { ULONG MethodID; Object *Dest; struct MUIP_Notify *Msg; };
struct MUIP_SpeedBar_GetObject       { ULONG MethodID; ULONG Object; };
struct MUIP_SpeedBar_DoOnButton      { ULONG MethodID; ULONG Button; ULONG Method; /* ...args... */ };
struct MUIP_SpeedBar_GetDragImage    { ULONG MethodID; ULONG Horiz; ULONG Flags; };
struct MUIP_SpeedBar_Sort            { ULONG MethodID; LONG Buttons[1]; };
struct MUIP_SpeedBar_Remove          { ULONG MethodID; ULONG Button; };

/***********************************************************************/
/*
** Attributes
*/

#define MUIA_SpeedBar_Borderless       (SBTAGBASE+1)  /*  BOOL,               [ISGN]            */
#define MUIA_SpeedBar_Images           (SBTAGBASE+2)  /*  struct MyBrush ** , [I.G.]            */
#define MUIA_SpeedBar_SpacerIndex      (SBTAGBASE+3)  /*  UWORD,              [I.G.]            */
#define MUIA_SpeedBar_RaisingFrame     (SBTAGBASE+4)  /*  BOOL,               [ISGN]            */
#define MUIA_SpeedBar_Buttons          (SBTAGBASE+5)  /*  struct MUIS_SpeedBar_Button *, [I...] */
#define MUIA_SpeedBar_ViewMode         (SBTAGBASE+6)  /*  UWORD,              [ISGN]            */
#define MUIA_SpeedBar_SameWidth        (SBTAGBASE+7)  /*  BOOL,               [I...]            */
#define MUIA_SpeedBar_Spread           (SBTAGBASE+8)  /*  BOOL,               [I...]            */
#define MUIA_SpeedBar_StripUnderscore  (SBTAGBASE+9)  /*  BOOL,               [I...]            */
#define MUIA_SpeedBar_SmallImages      (SBTAGBASE+10) /*  BOOL,               [ISGN]            */
#define MUIA_SpeedBar_Sunny            (SBTAGBASE+11) /*  BOOL,               [ISGN]            */
#define MUIA_SpeedBar_SameHeight       (SBTAGBASE+12) /*  BOOL,               [I...]            */
#define MUIA_SpeedBar_EnableUnderscore (SBTAGBASE+13) /*  BOOL,               [IS..]            */
#define MUIA_SpeedBar_Pics             (SBTAGBASE+14) /*  STRTR *,            [I...]            */
#define MUIA_SpeedBar_PicsDrawer       (SBTAGBASE+15) /*  STRTR,              [I...]            */
#define MUIA_SpeedBar_TextOnly         (SBTAGBASE+16) /*  BOOL,               [..G.]            */
#define MUIA_SpeedBar_BarSpacer        (SBTAGBASE+17) /*  BOOL,               [ISGN]            */
#define MUIA_SpeedBar_Strip            (SBTAGBASE+19) /*  STRPTR,             [I...]            */
#define MUIA_SpeedBar_StripBrush       (SBTAGBASE+20) /*  STRPTR,             [I...]            */
#define MUIA_SpeedBar_StripButtons     (SBTAGBASE+21) /*  UWORD,              [I...]            */
#define MUIA_SpeedBar_LabelPosition    (SBTAGBASE+22) /*  UWORD,              [ISGN]            */
#define MUIA_SpeedBar_Layout           (SBTAGBASE+23) /*  ULONG,              [ISGN]            */
#define MUIA_SpeedBar_DBar             (SBTAGBASE+24) /*  BOOL,               [I...]            */
#define MUIA_SpeedBar_Framed           (SBTAGBASE+25) /*  BOOL,               [I...]            */
#define MUIA_SpeedBar_Limbo            (SBTAGBASE+26) /*  BOOL,               [.S..]            */

/***********************************************************************/
/*
** Attributes values
*/

/* MUIA_SpeedBar_ViewMode */
enum
{
    MUIV_SpeedBar_ViewMode_TextGfx,
    MUIV_SpeedBar_ViewMode_Gfx,
    MUIV_SpeedBar_ViewMode_Text,

    MUIV_SpeedBar_ViewMode_Last

};

/* MUIA_SpeedBar_LabelPosition */
enum
{
    MUIV_SpeedBar_LabelPosition_Bottom,
    MUIV_SpeedBar_LabelPosition_Top,
    MUIV_SpeedBar_LabelPosition_Right,
    MUIV_SpeedBar_LabelPosition_Left,

    MUIV_SpeedBar_LabelPosition_Last,
};

/* MUIA_SpeedBar_Layout */
enum
{
    MUIV_SpeedBar_Layout_None,
    MUIV_SpeedBar_Layout_Left,
    MUIV_SpeedBar_Layout_Center,
    MUIV_SpeedBar_Layout_Right,
};

#define MUIV_SpeedBar_Layout_Up   MUIV_SpeedBar_Layout_Left
#define MUIV_SpeedBar_Layout_Down MUIV_SpeedBar_Layout_Right

/***********************************************************************/
/*
** Structures
*/

#ifndef SPEEDBUTTON_MCC_H
/*
** MUIA_SpeedBar_Images is an array
** of pointers to this structure
**/
struct MyBrush
{
    UWORD         Width;
    UWORD         Height;
    struct BitMap *BitMap;
    ULONG         *Colors;
};
#endif

/*
** MUIA_SpeedBar_Buttons is
** an array of this structure
*/
struct MUIS_SpeedBar_Button
{
    ULONG         Img;     /* Image index                                          */
    STRPTR        Text;    /* Button label (MAX SB_MAXLABELLEN - 40 chars -)       */
    STRPTR        Help;    /* Button help                                          */
    UWORD         Flags;   /* See below                                            */
    struct IClass *Class;  /* Easy way of getting a toolbar of subclassed buttons  */
    Object        *Object; /* Filled after init                                    */
};

/* Special Img values */
#define MUIV_SpeedBar_Spacer ((ULONG)-1) /* Add a spacer                       */
#define MUIV_SpeedBar_End    ((ULONG)-2) /* Ends a MUIS_SpeedBar_Button array  */

/* Flags */
enum
{
    MUIV_SpeedBar_ButtonFlag_Immediate = 1<<0,
    MUIV_SpeedBar_ButtonFlag_Disabled  = 1<<1,
    MUIV_SpeedBar_ButtonFlag_Selected  = 1<<2,
    MUIV_SpeedBar_ButtonFlag_Toggle    = 1<<3,
};

struct MUIS_SpeedBar_DragImage
{
    ULONG                Width;
    ULONG                Height;
    struct BitMap        *BitMap;
    APTR                 Priv1;
    ULONG                Priv2[4];
};

/***********************************************************************/

#endif /* SPEEDBAR_MCC_H */
