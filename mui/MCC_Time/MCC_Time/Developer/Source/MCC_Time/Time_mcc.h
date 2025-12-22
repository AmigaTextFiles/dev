/*
**
** Copyright © 1996 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Time_mcc.h 12.0 (20.12.96)
**
*/

 #ifndef MUI_TIME_MCC_H

   #define MUIC_Time "Time.mcc"
   /*#define TimeObject	MUI_NewObject(MUIC_Time*/

   #define MUIA_Time_Hour		0x81ee0081
   #define MUIA_Time_Minute		0x81ee0082
   #define MUIA_Time_Second		0x81ee0083
   #define MUIA_Time_NextDay		0x81ee008c
   #define MUIA_Time_PrevDay		0x81ee008d

   #define MUIM_Time_Increase		0x81ee0092
   #define MUIM_Time_Decrease		0x81ee0093
   #define MUIM_Time_SetCurrent		0x81ee0094
   struct MUIP_Time_Increase   		{ULONG MethodID; ULONG seconds;};
   struct MUIP_Time_Decrease   		{ULONG MethodID; ULONG seconds;};
   struct MUIP_Time_SetCurrent 		{ULONG MethodID;};


   #define MUI_TIME_MCC_H
 #endif
