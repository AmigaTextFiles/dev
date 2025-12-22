/*
**
** $VER: Pkb_mcc.h V14.6 (23-05-1999)
** Copyright © 1999 Calogero CALI'. All rights reserved.
**
*/

#ifndef PKB_MCC_H
#define PKB_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

#define MUIC_Pkb  "Pkb.mcc"
#define PkbObject MUI_NewObject(MUIC_Pkb


/* PUBLIC METHODS */
#define MUIM_Pkb_Reset              0xfec1001a
#define MUIM_Pkb_Refresh            0xfec1001b
#define MUIM_Pkb_Range              0xfec1001c
#define MUIM_Pkb_Range_Reset        0xfec1001d
#define MUIM_Pkb_Range_Refresh      0xfec1001e
#define MUIM_Pkb_Jump               0xfec1001f

/*** Method structs ***/
struct MUIP_Range                  {ULONG MethodID; ULONG start,end; };
struct MUIP_Jump                   {ULONG MethodID; ULONG ncode;     };


/* PUBLIC ATTRIBUTES */
#define MUIA_Pkb_Mode               0xfec10020
#define MUIA_Pkb_AutoRelease        0xfec10021
#define MUIA_Pkb_Current            0xfec10022
#define MUIA_Pkb_Quiet              0xfec10023
#define MUIA_Pkb_Pool               0xfec10024
#define MUIA_Pkb_PoolPuddleSize     0xfec10025
#define MUIA_Pkb_PoolThreshSize     0xfec10026
#define MUIA_Pkb_Octv_Name          0xfec10027
#define MUIA_Pkb_Octv_Base          0xfec10028
#define MUIA_Pkb_Octv_Range         0xfec10029
#define MUIA_Pkb_Octv_Start         0xfec1002a
#define MUIA_Pkb_Key_Release        0xfec1002b
#define MUIA_Pkb_Key_Press          0xfec1002c
#define MUIA_Pkb_Range_Head         0xfec1002d
#define MUIA_Pkb_Range_Start        0xfec1002e
#define MUIA_Pkb_Range_End          0xfec1002f
#define MUIA_Pkb_Low                0xfec10030
#define MUIA_Pkb_High               0xfec10031
#define MUIA_Pkb_ExcludeLow         0xfec10038
#define MUIA_Pkb_ExcludeHigh        0xfec10039
#define MUIA_Pkb_InputEnable        0xfec1003a
#define MUIA_Pkb_Type               0xfec1003b

/*** Special attribute values ***/
#define MUIV_Pkb_Mode_NORMAL         0
#define MUIV_Pkb_Mode_RANGE          1
#define MUIV_Pkb_Mode_SPECIAL        2

#define MUIV_Pkb_Range_Head_OFF      0
#define MUIV_Pkb_Range_Head_TOP      1
#define MUIV_Pkb_Range_Head_BOT      2

#define MUIV_Pkb_Type_NORMAL         0   // 105 x 50
#define MUIV_Pkb_Type_SMALL          1   //  70 x 39


#endif /* PKB_MCC_H */

