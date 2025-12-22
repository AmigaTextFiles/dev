/*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Time_mcc.e 12.5 (18.10.97)
**
*/

 OPT MODULE
 OPT EXPORT
 OPT PREPROCESS


 MODULE 'intuition/classes'


 #ifndef MUI_TIME_MCC_H
   #define MUI_TIME_MCC_H

   /*#define MUIC_Time	'Time.mcc'*/
   /*#define TimeObject	Mui_NewObjectA(MUIC_Time,[TAG_IGNORE,0*/

   CONST MUIA_Time_MidnightSecs			= $81ee0080
   CONST MUIA_Time_Hour				= $81ee0081
   CONST MUIA_Time_Minute			= $81ee0082
   CONST MUIA_Time_Second			= $81ee0083
   CONST MUIA_Time_MinHour			= $81ee0084
   CONST MUIA_Time_MinMinute			= $81ee0085
   CONST MUIA_Time_MinSecond			= $81ee0086
   CONST MUIA_Time_MaxHour			= $81ee0087
   CONST MUIA_Time_MaxMinute			= $81ee0088
   CONST MUIA_Time_MaxSecond			= $81ee0089
   CONST MUIA_Time_ZoneMinute			= $81ee008b
   CONST MUIA_Time_NextDay			= $81ee008c
   CONST MUIA_Time_PrevDay			= $81ee008d
   CONST MUIA_Time_DaylightSaving		= $81ee008e
   CONST MUIA_Time_ChangeHour			= $81ee008f
   CONST MUIA_Time_ChangeDay			= $81ee0095


   CONST MUIV_Time_ChangeDay_Normal		= 0
   CONST MUIV_Time_ChangeDay_WinterToSummer	= 1
   CONST MUIV_Time_ChangeDay_SummerToWinter	= 2


   CONST MUIV_Time_Compare_Less			= -1
   CONST MUIV_Time_Compare_Equal		=  0
   CONST MUIV_Time_Compare_Greater		=  1


   CONST MUIM_Time_Increase			= $81ee0092
   CONST MUIM_Time_Decrease			= $81ee0093
   CONST MUIM_Time_SetCurrent			= $81ee0094
   CONST MUIM_Time_Compare			= $81ee0096


   OBJECT muip_time_increase
     methodid	: LONG
     seconds	: LONG
   ENDOBJECT

   OBJECT muip_time_decrease
     methodid	: LONG
     seconds	: LONG
   ENDOBJECT

   OBJECT muip_time_setcurrent
     methodid   : LONG
   ENDOBJECT

   OBJECT muip_time_compare
     methodid   : LONG
     obj	: object
   ENDOBJECT

 #endif
