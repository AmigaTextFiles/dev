/*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Date_mcc.rexx 12.2 (22.12.97)
**
** Experimental version, please report bugs/improvements!
*/

MUIC_Date = "Date.mcc"
/*#define DateObject	MUI_NewObject(MUIC_Date*/

MUIA_Date_Day			= 0x81ee0001
MUIA_Date_Month			= 0x81ee0002
MUIA_Date_Year			= 0x81ee0003
MUIA_Date_FirstWeekday		= 0x81ee0004
MUIA_Date_Language		= 0x81ee0007
MUIA_Date_Country		= 0x81ee0008
MUIA_Date_Calendar		= 0x81ee0035
MUIA_Date_MinDay		= 0x81ee0041
MUIA_Date_MinMonth		= 0x81ee0042
MUIA_Date_MinYear		= 0x81ee0043
MUIA_Date_MaxDay		= 0x81ee0044
MUIA_Date_MaxMonth		= 0x81ee0045
MUIA_Date_MaxYear		= 0x81ee0046
MUIA_Date_JD			= 0x81ee0053
MUIA_Date_MJD			= 0x81ee0054
MUIA_Date_YDay			= 0x81ee0056
MUIA_Date_Week			= 0x81ee0057
MUIA_Date_Weekday		= 0x81ee0058

MUIV_Date_Country_Unknown	= 0
MUIV_Date_Country_Italia	= 1
MUIV_Date_Country_Deutschland	= 2
MUIV_Date_Country_Schweiz	= 3
MUIV_Date_Country_Danmark	= 4
MUIV_Date_Country_Nederland	= 5
MUIV_Date_Country_GreatBritain	= 6

MUIV_Date_Calendar_Julian	= 0
MUIV_Date_Calendar_Gregorian	= 1
MUIV_Date_Calendar_Heis		= 2

MUIV_Date_Weekday_Monday	= 1
MUIV_Date_Weekday_Tuesday	= 2
MUIV_Date_Weekday_Wednesday	= 3
MUIV_Date_Weekday_Thursday	= 4
MUIV_Date_Weekday_Friday	= 5
MUIV_Date_Weekday_Saturday	= 6
MUIV_Date_Weekday_Sunday	= 7

MUIV_Date_Lang_Locale		= 0
MUIV_Date_Lang_English		= 1
MUIV_Date_Lang_Deutsch		= 2
MUIV_Date_Lang_Français		= 3
MUIV_Date_Lang_Español		= 4
MUIV_Date_Lang_Português	= 5
MUIV_Date_Lang_Dansk		= 6
MUIV_Date_Lang_Italiano		= 7
MUIV_Date_Lang_Nederlands	= 8
MUIV_Date_Lang_Norsk		= 9
MUIV_Date_Lang_Svenska		= 10
MUIV_Date_Lang_Polski		= 11
MUIV_Date_Lang_Suomi		= 12
MUIV_Date_Lang_Magyar		= 13
MUIV_Date_Lang_Greek		= 14
MUIV_Date_Lang_Esperanto	= 15
MUIV_Date_Lang_Latina		= 16
MUIV_Date_Lang_Russian		= 17
MUIV_Date_Lang_Czech		= 18
MUIV_Date_Lang_Catalonian	= 19

MUIV_Date_Compare_Less		= -1
MUIV_Date_Compare_Equal		=  0
MUIV_Date_Compare_Greater	=  1

MUIM_Date_SetCurrent		= 0x81ee0048 /* struct MUIP_Date_SetCurrent {ULONG MethodID;}; */
MUIM_Date_IncreaseDays		= 0x81ee0049 /* struct MUIP_Date_IncreaseDays {ULONG MethodID; ULONG days;}; */
MUIM_Date_DecreaseDays		= 0x81ee004a /* struct MUIP_Date_DecreaseDays {ULONG MethodID; ULONG days;}; */
MUIM_Date_IncreaseMonths	= 0x81ee004b /* struct MUIP_Date_IncreaseMonths {ULONG MethodID; ULONG months;}; */
MUIM_Date_DecreaseMonths	= 0x81ee004c /* struct MUIP_Date_DecreaseMonths {ULONG MethodID; ULONG months;}; */
MUIM_Date_IncreaseYears		= 0x81ee004d /* struct MUIP_Date_IncreaseYears {ULONG MethodID; ULONG years;}; */
MUIM_Date_DecreaseYears		= 0x81ee004e /* struct MUIP_Date_DecreaseYears {ULONG MethodID; ULONG years;}; */
MUIM_Date_IncreaseToWeekday	= 0x81ee004f /* struct MUIP_Date_IncreaseToWeekday {ULONG MethodID; date_Weekdays weekday;}; */
MUIM_Date_DecreaseToWeekday	= 0x81ee0052 /* struct MUIP_Date_DecreaseToWeekday {ULONG MethodID; date_Weekdays weekday;}; */
MUIM_Date_Compare		= 0x81ee0055 /* struct MUIP_Date_Compare {ULONG MethodID; Object *obj;}; */
