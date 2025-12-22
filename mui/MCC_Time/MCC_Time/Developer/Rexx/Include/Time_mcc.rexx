/*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Time_mcc.rexx 12.5 (18.10.97)
**
** Experimental version, please report bugs/improvements!
*/

MUIC_Time = "Time.mcc"
/*#define TimeObject	MUI_NewObject(MUIC_Time*/

MUIA_Time_MidnightSecs			= 0x81ee0080
MUIA_Time_Hour				= 0x81ee0081
MUIA_Time_Minute			= 0x81ee0082
MUIA_Time_Second			= 0x81ee0083
MUIA_Time_MinHour			= 0x81ee0084
MUIA_Time_MinMinute			= 0x81ee0085
MUIA_Time_MinSecond			= 0x81ee0086
MUIA_Time_MaxHour			= 0x81ee0087
MUIA_Time_MaxMinute			= 0x81ee0088
MUIA_Time_MaxSecond			= 0x81ee0089
MUIA_Time_ZoneMinute			= 0x81ee008b
MUIA_Time_NextDay			= 0x81ee008c
MUIA_Time_PrevDay			= 0x81ee008d
MUIA_Time_DaylightSaving		= 0x81ee008e
MUIA_Time_ChangeHour			= 0x81ee008f
MUIA_Time_ChangeDay			= 0x81ee0095

MUIV_Time_ChangeDay_Normal		= 0
MUIV_Time_ChangeDay_WinterToSummer	= 1
MUIV_Time_ChangeDay_SummerToWinter	= 2

MUIV_Time_Compare_Less			= -1
MUIV_Time_Compare_Equal			=  0
MUIV_Time_Compare_Greater		=  1

MUIM_Time_Increase		= 0x81ee0092 /* struct MUIP_Time_Increase {ULONG MethodID; ULONG seconds;}; */
MUIM_Time_Decrease		= 0x81ee0093 /* struct MUIP_Time_Decrease {ULONG MethodID; ULONG seconds;}; */
MUIM_Time_SetCurrent		= 0x81ee0094 /* struct MUIP_Time_SetCurrent {ULONG MethodID;}; */
MUIM_Time_Compare		= 0x81ee0096 /* struct MUIP_Time_Compare {ULONG MethodID; Object *obj;}; */
