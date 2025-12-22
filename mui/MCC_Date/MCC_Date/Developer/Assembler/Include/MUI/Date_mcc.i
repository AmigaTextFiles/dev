**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Date_mcc.i 12.2 (22.12.97)
**

 IFND MUI_DATE_I
MUI_DATE_I	SET 1

** In case user forgets that this .i includes data

	bra	end_of_date_i

** Attributes

MUIA_Date_Day			EQU $81ee0001
MUIA_Date_Month			EQU $81ee0002
MUIA_Date_Year			EQU $81ee0003
MUIA_Date_FirstWeekday		EQU $81ee0004
MUIA_Date_Language		EQU $81ee0007
MUIA_Date_Country		EQU $81ee0008
MUIA_Date_Calendar		EQU $81ee0035
MUIA_Date_MinDay		EQU $81ee0041
MUIA_Date_MinMonth		EQU $81ee0042
MUIA_Date_MinYear		EQU $81ee0043
MUIA_Date_MaxDay		EQU $81ee0044
MUIA_Date_MaxMonth		EQU $81ee0045
MUIA_Date_MaxYear		EQU $81ee0046
MUIA_Date_JD			EQU $81ee0053
MUIA_Date_MJD			EQU $81ee0054
MUIA_Date_YDay			EQU $81ee0056
MUIA_Date_Week			EQU $81ee0057
MUIA_Date_Weekday		EQU $81ee0058

MUIM_Date_SetCurrent		EQU $81ee0048
MUIM_Date_IncreaseDays		EQU $81ee0049
MUIM_Date_DecreaseDays		EQU $81ee004a
MUIM_Date_IncreaseMonths	EQU $81ee004b
MUIM_Date_DecreaseMonths	EQU $81ee004c
MUIM_Date_IncreaseYears		EQU $81ee004d
MUIM_Date_DecreaseYears		EQU $81ee004e
MUIM_Date_IncreaseToWeekday	EQU $81ee004f
MUIM_Date_DecreaseToWeekday	EQU $81ee0052
MUIM_Date_Compare		EQU $81ee0055

MUIV_Date_Country_Unknown	SET 0
MUIV_Date_Country_Italia	SET 1
MUIV_Date_Country_Deutschland	SET 2
MUIV_Date_Country_Schweiz	SET 3
MUIV_Date_Country_Danmark	SET 4
MUIV_Date_Country_Nederland	SET 5
MUIV_Date_Country_GreatBritain	SET 6

MUIV_Date_Calendar_Julian	SET 0
MUIV_Date_Calendar_Gregorian	SET 1
MUIV_Date_Calendar_Heis		SET 2

MUIV_Date_Weekday_Monday	SET 1
MUIV_Date_Weekday_Tuesday	SET 2
MUIV_Date_Weekday_Wednesday	SET 3
MUIV_Date_Weekday_Thursday	SET 4
MUIV_Date_Weekday_Friday	SET 5
MUIV_Date_Weekday_Saturday	SET 6
MUIV_Date_Weekday_Sunday	SET 7

MUIV_Date_Lang_Locale		SET 0
MUIV_Date_Lang_English		SET 1
MUIV_Date_Lang_Deutsch		SET 2
MUIV_Date_Lang_Français		SET 3
MUIV_Date_Lang_Español		SET 4
MUIV_Date_Lang_Português	SET 5
MUIV_Date_Lang_Dansk		SET 6
MUIV_Date_Lang_Italiano		SET 7
MUIV_Date_Lang_Nederlands	SET 8
MUIV_Date_Lang_Norsk		SET 9
MUIV_Date_Lang_Svenska		SET 10
MUIV_Date_Lang_Polski		SET 11
MUIV_Date_Lang_Suomi		SET 12
MUIV_Date_Lang_Magyar		SET 13
MUIV_Date_Lang_Greek		SET 14
MUIV_Date_Lang_Esperanto	SET 15
MUIV_Date_Lang_Latina		SET 16
MUIV_Date_Lang_Russian		SET 17
MUIV_Date_Lang_Czech		SET 18
MUIV_Date_Lang_Catalonian	SET 19

MUIV_Date_Compare_Less		SET -1
MUIV_Date_Compare_Equal		SET  0
MUIV_Date_Compare_Greater	SET  1


	STRUCTURE MUIP_Date_SetCurrent,0
	  ULONG  MUIP_Date_SetCurrent_MethodID
	  LABEL MUIP_Date_SetCurrent_SIZE

	STRUCTURE MUIP_Date_IncreaseDays,0
	  ULONG  MUIP_Date_Increase_MethodID
	  ULONG  MUIP_Date_Increase_days
	  LABEL MUIP_Date_IncreaseDays_SIZE

	STRUCTURE MUIP_Date_DecreaseDays,0
	  ULONG  MUIP_Date_Decrease_MethodID
	  ULONG  MUIP_Date_Decrease_days
	  LABEL MUIP_Date_DecreaseDays_SIZE

	STRUCTURE MUIP_Date_IncreaseMonths,0
	  ULONG  MUIP_Date_Increase_MethodID
	  ULONG  MUIP_Date_Increase_months
	  LABEL MUIP_Date_IncreaseMonths_SIZE

	STRUCTURE MUIP_Date_DecreaseMonths,0
	  ULONG  MUIP_Date_Decrease_MethodID
	  ULONG  MUIP_Date_Decrease_months
	  LABEL MUIP_Date_DecreaseMonths_SIZE

	STRUCTURE MUIP_Date_IncreaseYears,0
	  ULONG  MUIP_Date_Increase_MethodID
	  ULONG  MUIP_Date_Increase_years
	  LABEL MUIP_Date_IncreaseYears_SIZE

	STRUCTURE MUIP_Date_DecreaseYears,0
	  ULONG  MUIP_Date_Decrease_MethodID
	  ULONG  MUIP_Date_Decrease_years
	  LABEL MUIP_Date_DecreaseYears_SIZE

	STRUCTURE MUIP_Date_IncreaseToWeekday,0
	  ULONG  MUIP_Date_Increase_MethodID
	  ULONG  MUIP_Date_Increase_weekday
	  LABEL MUIP_Date_IncreaseToWeekday_SIZE

	STRUCTURE MUIP_Date_DecreaseToWeekday,0
	  ULONG  MUIP_Date_Decrease_MethodID
	  ULONG  MUIP_Date_Decrease_weekday
	  LABEL MUIP_Date_DecreaseToWeekday_SIZE

	STRUCTURE MUIP_Date_Compare,0
	  ULONG  MUIP_Date_Compare_MethodID
	  APTR   MUIP_Date_Compate_obj
	  LABEL MUIP_Date_Compare_SIZE

** Pointers for strings

MUIC_Date	dc.l MUIC_Date_s

** Strings

MUIC_Date_s	dc.b "Date.mcc",0,0,0,0

end_of_date_i

 ENDC ; MUI_DATE_I
