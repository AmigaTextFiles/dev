/*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Date_mcc.e 12.2 (22.12.97)
**
*/

 OPT MODULE
 OPT EXPORT
 OPT PREPROCESS

 #ifndef MUI_DATE_MCC_H
   #define MUI_DATE_MCC_H

   /*#define MUIC_Date	'Date.mcc'*/
   /*#define DateObject	Mui_NewObjectA(MUIC_Date,[TAG_IGNORE,0*/

   CONST MUIA_Date_Day                  = $81ee0001
   CONST MUIA_Date_Month                = $81ee0002
   CONST MUIA_Date_Year                 = $81ee0003
   CONST MUIA_Date_FirstWeekday		= $81ee0004
   CONST MUIA_Date_Language		= $81ee0007
   CONST MUIA_Date_Country		= $81ee0008
   CONST MUIA_Date_Calendar		= $81ee0035
   CONST MUIA_Date_MinDay		= $81ee0041
   CONST MUIA_Date_MinMonth		= $81ee0042
   CONST MUIA_Date_MinYear		= $81ee0043
   CONST MUIA_Date_MaxDay		= $81ee0044
   CONST MUIA_Date_MaxMonth		= $81ee0045
   CONST MUIA_Date_MaxYear		= $81ee0046
   CONST MUIA_Date_JD			= $81ee0053
   CONST MUIA_Date_MJD			= $81ee0054
   CONST MUIA_Date_YDay			= $81ee0056
   CONST MUIA_Date_Week			= $81ee0057
   CONST MUIA_Date_Weekday		= $81ee0058


   CONST MUIM_Date_SetCurrent		= $81ee0048
   CONST MUIM_Date_IncreaseDays		= $81ee0049
   CONST MUIM_Date_DecreaseDays		= $81ee004a
   CONST MUIM_Date_IncreaseMonths	= $81ee004b
   CONST MUIM_Date_DecreaseMonths	= $81ee004c
   CONST MUIM_Date_IncreaseYears	= $81ee004d
   CONST MUIM_Date_DecreaseYears	= $81ee004e
   CONST MUIM_Date_IncreaseToWeekday	= $81ee004f
   CONST MUIM_Date_DecreaseToWeekday	= $81ee0052
   CONST MUIM_Date_Compare		= $81ee0055


   OBJECT muip_date_setcurrent
     methodid	: LONG
   ENDOBJECT

   OBJECT muip_date_increasedays
     methodid	: LONG
     days	: LONG
   ENDOBJECT

   OBJECT muip_date_decreasedays
     methodid	: LONG
     days	: LONG
   ENDOBJECT

   OBJECT muip_date_increasemonths
     methodid	: LONG
     months	: LONG
   ENDOBJECT

   OBJECT muip_date_decreasemonths
     methodid	: LONG
     months	: LONG
   ENDOBJECT

   OBJECT muip_date_increaseyears
     methodid	: LONG
     years	: LONG
   ENDOBJECT

   OBJECT muip_date_decreaseyears
     methodid	: LONG
     years	: LONG
   ENDOBJECT

   OBJECT muip_date_increasetoweekday
     methodid	: LONG
     weekday	: LONG
   ENDOBJECT

   OBJECT muip_date_decreasetoweekday
     methodid	: LONG
     weekday	: LONG
   ENDOBJECT

   OBJECT muip_date_compare
     methodid   : LONG
     obj	: object
   ENDOBJECT


   #define MUIV_Date_Country_Unknown		0
   #define MUIV_Date_Country_Italia		1
   #define MUIV_Date_Country_Deutschland	2
   #define MUIV_Date_Country_Schweiz		3
   #define MUIV_Date_Country_Danmark		4
   #define MUIV_Date_Country_Nederland		5
   #define MUIV_Date_Country_GreatBritain	6

   #define MUIV_Date_Calendar_Julian		0
   #define MUIV_Date_Calendar_Gregorian		1
   #define MUIV_Date_Calendar_Heis		2

   #define MUIV_Date_Weekday_Monday		1
   #define MUIV_Date_Weekday_Tuesday		2
   #define MUIV_Date_Weekday_Wednesday		3
   #define MUIV_Date_Weekday_Thursday		4
   #define MUIV_Date_Weekday_Friday		5
   #define MUIV_Date_Weekday_Saturday		6
   #define MUIV_Date_Weekday_Sunday		7

   #define MUIV_Date_Lang_Locale		0
   #define MUIV_Date_Lang_English		1
   #define MUIV_Date_Lang_Deutsch		2
   #define MUIV_Date_Lang_Francais		3
   #define MUIV_Date_Lang_Espanol		4
   #define MUIV_Date_Lang_Portugues		5
   #define MUIV_Date_Lang_Dansk			6
   #define MUIV_Date_Lang_Italiano		7
   #define MUIV_Date_Lang_Nederlands		8
   #define MUIV_Date_Lang_Norsk			9
   #define MUIV_Date_Lang_Svenska		10
   #define MUIV_Date_Lang_Polski		11
   #define MUIV_Date_Lang_Suomi			12
   #define MUIV_Date_Lang_Magyar		13
   #define MUIV_Date_Lang_Greek			14
   #define MUIV_Date_Lang_Esperanto		15
   #define MUIV_Date_Lang_Latina		16
   #define MUIV_Date_Lang_Russian		17
   #define MUIV_Date_Lang_Czech			18
   #define MUIV_Date_Lang_Catalonian		19

   #define MUIV_Date_Compare_Less		-1
   #define MUIV_Date_Compare_Equal		 0
   #define MUIV_Date_Compare_Greater		 1

 #endif
