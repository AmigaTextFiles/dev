#ifndef SPEEDBUTTON_MCC_H
#define SPEEDBUTTON_MCC_H

/*
**  $VER: SpeedButton_mcc.h 19.3 (30.6.2003)
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

#define MUIC_SpeedButton  "SpeedButton.mcc"
#define SpeedButtonObject MUI_NewObject(MUIC_SpeedButton

/***********************************************************************/

#define BTTAGBASE 0xF76B0100

/***********************************************************************/
/*
** Methods
*/

/***********************************************************************/
/*
** Methods structures
*/

/***********************************************************************/
/*
** Attributes
*/

#define MUIA_SpeedButton_Borderless       (BTTAGBASE+1)  /*  BOOL,              [I...] */
#define MUIA_SpeedButton_Image            (BTTAGBASE+2)  /*  struct MyBrush  *, [I...] */
#define MUIA_SpeedButton_Label            (BTTAGBASE+3)  /*  STRPTR,            [I...] */
#define MUIA_SpeedButton_ViewMode         (BTTAGBASE+4)  /*  ULONG,             [ISGN] */
#define MUIA_SpeedButton_Raising          (BTTAGBASE+5)  /*  BOOL,              [ISGN] */
#define MUIA_SpeedButton_MinWidth         (BTTAGBASE+6)  /*  BOOL,              [I.G.] */
#define MUIA_SpeedButton_NoClick          (BTTAGBASE+7)  /*  BOOL,              [I...] */
#define MUIA_SpeedButton_SpeedBar         (BTTAGBASE+8)  /*  Object *,          [ISG.] */
#define MUIA_SpeedButton_QuietNotify      (BTTAGBASE+9)  /*  BOOL               [.S..] */ /* PRIVATE */
#define MUIA_SpeedButton_ToggleMode       (BTTAGBASE+10) /*  BOOL,              [I...] */
#define MUIA_SpeedButton_ShowMe           (BTTAGBASE+11) /*  BOOL               [..G.] */ /* PRIVATE */
#define MUIA_SpeedButton_ImmediateMode    (BTTAGBASE+12) /*  BOOL,              [I...] */
#define MUIA_SpeedButton_StripUnderscore  (BTTAGBASE+13) /*  BOOL,              [I...] */
#define MUIA_SpeedButton_SmallImage       (BTTAGBASE+14) /*  BOOL,              [ISGN] */
#define MUIA_SpeedButton_Sunny            (BTTAGBASE+15) /*  BOOL,              [I...] */
#define MUIA_SpeedButton_MinHeight        (BTTAGBASE+16) /*  BOOL,              [I.G.] */
#define MUIA_SpeedButton_EnableUnderscore (BTTAGBASE+17) /*  BOOL,              [ISG.] */
#define MUIA_SpeedButton_MouseOver        (BTTAGBASE+18) /*  BOOL               [I...] */ /* PRIVATE */
#define MUIA_SpeedButton_LabelPosition    (BTTAGBASE+19) /*  UWORD,             [ISGN] */
#define MUIA_SpeedButton_InVirtgroup      (BTTAGBASE+20) /*  BOOL,              [I...] */

/***********************************************************************/
/*
** Attributes values
*/

/* MUIA_SpeedButton_ViewMode */
enum
{
    MUIV_SpeedButton_ViewMode_TextGfx,
    MUIV_SpeedButton_ViewMode_Gfx,
    MUIV_SpeedButton_ViewMode_Text,

    MUIV_SpeedButton_ViewMode_Last
};

/* MUIA_SpeedButton_LabelPosition */
enum
{
    MUIV_SpeedButton_LabelPosition_Bottom,
    MUIV_SpeedButton_LabelPosition_Top,
    MUIV_SpeedButton_LabelPosition_Right,
    MUIV_SpeedButton_LabelPosition_Left,

    MUIV_SpeedButton_LabelPosition_Last
};

/***********************************************************************/
/*
** Misc
*/

/* MUIA_SpeedButton_Label max size */
#define SB_MAXLABELLEN 40

#ifndef SPEEDBAR_MCC_H
/*
** MUIA_SpeedButton_Image is a
** pointer to this structure
**/
struct MyBrush
{
    UWORD         Width;
    UWORD         Height;
    struct BitMap *BitMap;
    ULONG         *Colors;
};
#endif

/***********************************************************************/

#endif /* SPEEDBUTTON_MCC_H */
