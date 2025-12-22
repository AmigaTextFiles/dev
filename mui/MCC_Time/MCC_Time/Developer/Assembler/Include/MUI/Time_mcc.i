**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Time_mcc.i 12.5 (18.10.97)
**

 IFND MUI_TIME_I
MUI_TIME_I	SET 1

** In case user forgets that this .i includes data

*	bra	end_of_time_i

** Attributes

MUIA_Time_MidnightSecs			EQU $81ee0080
MUIA_Time_Hour				EQU $81ee0081
MUIA_Time_Minute			EQU $81ee0082
MUIA_Time_Second			EQU $81ee0083
MUIA_Time_MinHour			EQU $81ee0084
MUIA_Time_MinMinute			EQU $81ee0085
MUIA_Time_MinSecond			EQU $81ee0086
MUIA_Time_MaxHour			EQU $81ee0087
MUIA_Time_MaxMinute			EQU $81ee0088
MUIA_Time_MaxSecond			EQU $81ee0089
MUIA_Time_ZoneMinute			EQU $81ee008b
MUIA_Time_NextDay			EQU $81ee008c
MUIA_Time_PrevDay			EQU $81ee008d
MUIA_Time_DaylightSaving		EQU $81ee008e
MUIA_Time_ChangeHour			EQU $81ee008f
MUIA_Time_ChangeDay			EQU $81ee0095


MUIV_Time_ChangeDay_Normal		EQU 0
MUIV_Time_ChangeDay_WinterToSummer	EQU 1
MUIV_Time_ChangeDay_SummerToWinter	EQU 2


MUIV_Time_Compare_Less			EQU -1
MUIV_Time_Compare_Equal			EQU  0
MUIV_Time_Compare_Greater		EQU  1


MUIM_Time_Increase			EQU $81ee0092
MUIM_Time_Decrease			EQU $81ee0093
MUIM_Time_SetCurrent			EQU $81ee0094
MUIM_Time_Compare			EQU $81ee0096


	STRUCTURE MUIP_Time_Increase,0
	  ULONG  MUIP_Time_Increase_MethodID
	  ULONG  MUIP_Time_Increase_seconds
	  LABEL MUIP_Time_Increase_SIZE

	STRUCTURE MUIP_Time_Decrease,0
	  ULONG  MUIP_Time_Decrease_MethodID
	  ULONG  MUIP_Time_Decrease_seconds
	  LABEL MUIP_Time_Decrease_SIZE

	STRUCTURE MUIP_Time_SetCurrent,0
	  ULONG  MUIP_Time_SetCurrent_MethodID
	  LABEL MUIP_Time_SetCurrent_SIZE

	STRUCTURE MUIP_Time_Compare,0
	  ULONG  MUIP_Time_Compare_MethodID
	  APTR   MUIP_Time_Compare_obj
	  LABEL MUIP_Time_Compare_SIZE

** Pointers for strings

*MUIC_Time	dc.l MUIC_Time_s

** Strings

*MUIC_Time_s	dc.b "Time.mcc",0,0,0,0

*end_of_time_i

   ENDC ; MUI_TIME_I
