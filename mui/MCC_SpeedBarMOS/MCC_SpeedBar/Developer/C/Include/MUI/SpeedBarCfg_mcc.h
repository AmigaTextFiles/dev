#ifndef SPEEDBARCFG_MCC_H
#define SPEEDBARCFG_MCC_H

/*
**  $VER: SpeedBarCfg_mcc.h 19.3 (30.6.2003)
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

#define MUIC_SpeedBarCfg  "SpeedBarCfg.mcc"
#define SpeedBarCfgObject MUI_NewObject(MUIC_SpeedBarCfg

/***********************************************************************/

#define SBCTAGBASE 0xF76B00A0

/***********************************************************************/
/*
** Methods
*/

#define MUIM_SpeedBarCfg_GetCfg (SBCTAGBASE+1) /*  PRIVATE  */
#define MUIM_SpeedBarCfg_SetCfg (SBCTAGBASE+2) /*  PRIVATE  */

/***********************************************************************/
/*
** Attributes
*/

#define MUIA_SpeedBarCfg_Config (SBCTAGBASE+1) /* MUIS_SpeedBarCfg_Config *, [ISG.] */

/***********************************************************************/
/*
** Structures
*/

struct MUIS_SpeedBarCfg_Config
{
    UWORD ViewMode;
    ULONG Flags;
};

/* Flags */
enum
{
    MUIV_SpeedBarCfg_Borderless   = 1<<0,
    MUIV_SpeedBarCfg_Raising      = 1<<1,
    MUIV_SpeedBarCfg_SmallButtons = 1<<2,
    MUIV_SpeedBarCfg_Sunny        = 1<<3,
};

/***********************************************************************/

#endif /* SPEEDBARCFG_MCC_H */
