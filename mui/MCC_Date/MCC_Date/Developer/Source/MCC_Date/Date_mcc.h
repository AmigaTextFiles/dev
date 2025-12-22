/*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: Date_mcc.h 12.0 (28.03.97)
**
*/

 #ifndef MUI_DATE_MCC_H
   #define MUI_DATE_MCC_H

   #define MUIC_Date	"Date.mcc"
   /*#define DateObject	MUI_NewObject(MUIC_Date*/

   #define MUIA_Date_Day		0x81ee0001
   #define MUIA_Date_Month		0x81ee0002
   #define MUIA_Date_Year		0x81ee0003
   #define MUIA_Date_FirstWeekday	0x81ee0004
   #define MUIA_Date_Language		0x81ee0007
   #define MUIA_Date_Country		0x81ee0008

   #define MUIV_Date_Country_Unknown		0
   #define MUIV_Date_Country_Italia		1
   #define MUIV_Date_Country_Deutschland	2
   #define MUIV_Date_Country_Schweiz		3
   #define MUIV_Date_Country_Danmark		4
   #define MUIV_Date_Country_Nederland		5
   #define MUIV_Date_Country_GreatBritain	6

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
   #define MUIV_Date_Lang_Français		3
   #define MUIV_Date_Lang_Español		4
   #define MUIV_Date_Lang_Português		5
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

   #define MUIM_Date_SetCurrent		0x81ee0048
   #define MUIM_Date_IncreaseDays	0x81ee0049
   #define MUIM_Date_DecreaseDays	0x81ee004a
   #define MUIM_Date_IncreaseMonths	0x81ee004b
   #define MUIM_Date_DecreaseMonths	0x81ee004c
   #define MUIM_Date_IncreaseYears	0x81ee004d
   #define MUIM_Date_DecreaseYears	0x81ee004e
   #define MUIM_Date_IncreaseToWeekday	0x81ee004f
   #define MUIM_Date_DecreaseToWeekday	0x81ee0052
   struct MUIP_Date_SetCurrent 		{ULONG MethodID;};
   struct MUIP_Date_IncreaseDays	{ULONG MethodID; ULONG days;};
   struct MUIP_Date_DecreaseDays	{ULONG MethodID; ULONG days;};
   struct MUIP_Date_IncreaseMonths	{ULONG MethodID; ULONG months;};
   struct MUIP_Date_DecreaseMonths	{ULONG MethodID; ULONG months;};
   struct MUIP_Date_IncreaseYears	{ULONG MethodID; ULONG years;};
   struct MUIP_Date_DecreaseYears	{ULONG MethodID; ULONG years;};
   struct MUIP_Date_IncreaseToWeekday	{ULONG MethodID; UWORD weekday;};
   struct MUIP_Date_DecreaseToWeekday	{ULONG MethodID; UWORD weekday;};

 #endif
