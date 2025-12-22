/*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Time_mcc.h 12.5 (18.10.97)
**
*/

 #ifndef MUI_TIME_MCC_H
   #include <intuition/classusr.h>

   #define MUIC_Time "Time.mcc"
   /*#define TimeObject	MUI_NewObject(MUIC_Time*/

   #define MUIA_Time_MidnightSecs	0x81ee0080
   #define MUIA_Time_Hour		0x81ee0081
   #define MUIA_Time_Minute		0x81ee0082
   #define MUIA_Time_Second		0x81ee0083
   #define MUIA_Time_MinHour		0x81ee0084
   #define MUIA_Time_MinMinute		0x81ee0085
   #define MUIA_Time_MinSecond		0x81ee0086
   #define MUIA_Time_MaxHour		0x81ee0087
   #define MUIA_Time_MaxMinute		0x81ee0088
   #define MUIA_Time_MaxSecond		0x81ee0089
   #define MUIA_Time_ZoneMinute		0x81ee008b
   #define MUIA_Time_NextDay		0x81ee008c
   #define MUIA_Time_PrevDay		0x81ee008d
   #define MUIA_Time_DaylightSaving	0x81ee008e
   #define MUIA_Time_ChangeHour		0x81ee008f
   #define MUIA_Time_ChangeDay		0x81ee0095

   #define MUIV_Time_ChangeDay_Normal		0
   #define MUIV_Time_ChangeDay_WinterToSummer	1
   #define MUIV_Time_ChangeDay_SummerToWinter	2

   #define MUIV_Time_Compare_Less		-1
   #define MUIV_Time_Compare_Equal		 0
   #define MUIV_Time_Compare_Greater		 1

   #define MUIM_Time_Increase		0x81ee0092
   #define MUIM_Time_Decrease		0x81ee0093
   #define MUIM_Time_SetCurrent		0x81ee0094
   #define MUIM_Time_Compare		0x81ee0096
   struct MUIP_Time_Increase   		{ULONG MethodID; ULONG seconds;};
   struct MUIP_Time_Decrease   		{ULONG MethodID; ULONG seconds;};
   struct MUIP_Time_SetCurrent 		{ULONG MethodID;};
   struct MUIP_Time_Compare 		{ULONG MethodID; Object *obj;};


   #define MUI_TIME_MCC_H
 #endif
