OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/intuition/classusr'
{#include <mui/Lamp_mcc.h>}
NATIVE {LAMP_MCC_H} CONST

NATIVE {MUIC_Lamp} CONST
#define MUIC_Lamp muic_lamp
STATIC muic_lamp = 'Lamp.mcc'

NATIVE {LampObject} CONST
#define LampObject Mui_NewObject(MUIC_Lamp

NATIVE {MUIA_Lamp_Type}      CONST MUIA_Lamp_Type      = $85b90001 /* [ISG]  ULONG                */
NATIVE {MUIA_Lamp_Color}     CONST MUIA_Lamp_Color     = $85b90002 /* [ISG]  ULONG *              */
NATIVE {MUIA_Lamp_ColorType} CONST MUIA_Lamp_ColorType = $85b90003 /* [..G]  ULONG                */
NATIVE {MUIA_Lamp_Red}       CONST MUIA_Lamp_Red       = $85b90004 /* [ISG]  ULONG                */
NATIVE {MUIA_Lamp_Green}     CONST MUIA_Lamp_Green     = $85b90005 /* [ISG]  ULONG                */
NATIVE {MUIA_Lamp_Blue}      CONST MUIA_Lamp_Blue      = $85b90006 /* [ISG]  ULONG                */
NATIVE {MUIA_Lamp_PenSpec}   CONST MUIA_Lamp_PenSpec   = $85b90007 /* [ISG]  struct MUI_PenSpec * */

NATIVE {MUIM_Lamp_SetRGB}    CONST MUIM_Lamp_SetRGB = $85b90008

NATIVE {MUIV_Lamp_Type_Tiny}   CONST MUIV_Lamp_Type_Tiny   = 0
NATIVE {MUIV_Lamp_Type_Small}  CONST MUIV_Lamp_Type_Small  = 1
NATIVE {MUIV_Lamp_Type_Medium} CONST MUIV_Lamp_Type_Medium = 2
NATIVE {MUIV_Lamp_Type_Big}    CONST MUIV_Lamp_Type_Big    = 3
NATIVE {MUIV_Lamp_Type_Huge}   CONST MUIV_Lamp_Type_Huge   = 4

NATIVE {MUIV_Lamp_ColorType_UserDefined} CONST MUIV_Lamp_ColorType_UserDefined = 0
NATIVE {MUIV_Lamp_ColorType_Color}       CONST MUIV_Lamp_ColorType_Color       = 1
NATIVE {MUIV_Lamp_ColorType_PenSpec}     CONST MUIV_Lamp_ColorType_PenSpec     = 2

NATIVE {MUIV_Lamp_Color_Off}           CONST MUIV_Lamp_Color_Off           = 0
NATIVE {MUIV_Lamp_Color_Ok}            CONST MUIV_Lamp_Color_Ok            = 1
NATIVE {MUIV_Lamp_Color_Warning}       CONST MUIV_Lamp_Color_Warning       = 2
NATIVE {MUIV_Lamp_Color_Error}         CONST MUIV_Lamp_Color_Error         = 3
NATIVE {MUIV_Lamp_Color_FatalError}    CONST MUIV_Lamp_Color_FatalError    = 4
NATIVE {MUIV_Lamp_Color_Processing}    CONST MUIV_Lamp_Color_Processing    = 5
NATIVE {MUIV_Lamp_Color_LookingUp}     CONST MUIV_Lamp_Color_LookingUp     = 6
NATIVE {MUIV_Lamp_Color_Connecting}    CONST MUIV_Lamp_Color_Connecting    = 7
NATIVE {MUIV_Lamp_Color_SendingData}   CONST MUIV_Lamp_Color_SendingData   = 8
NATIVE {MUIV_Lamp_Color_ReceivingData} CONST MUIV_Lamp_Color_ReceivingData = 9
NATIVE {MUIV_Lamp_Color_LoadingData}   CONST MUIV_Lamp_Color_LoadingData   = 10
NATIVE {MUIV_Lamp_Color_SavingData}    CONST MUIV_Lamp_Color_SavingData    = 11

NATIVE {MUIP_Lamp_SetRGB} OBJECT muip_lamp_setrgb OF msg
-> {MethodID} methodid:ULONG
  {red} red
  {green} green
  {blue} blue
ENDOBJECT
