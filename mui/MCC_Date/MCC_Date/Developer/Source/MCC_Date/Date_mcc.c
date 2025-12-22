/* Copyright © 1996-1997 Kai Hofmann. All rights reserved.
*****i* Date/--history-- ****************************************************
*
*   NAME
*	history -- Development history of the Date MUI custom class
*
*   VERSION
*	$VER: Date 12.0 (26.12.97)
*
*****************************************************************************
*
*
*/

/*
******* Date/--background-- *************************************************
*
*   NAME
*	Date -- ... (V12)
*
*   FUNCTION
*	Date is an abstract Custom Class of the Magic User Interface © by
*	Stefan Stuntz.
*	It's a subclass of notify-class and only usable for developers who
*	want to build subclasses of Date.mcc!
*
*	The idea of this class was born during developing my Gregor
*	application.
*
*	MUI abstract public custom class allowing easy handling of dates.
*	Because it is abstract it is only usefull for developers who are
*	working with classes that are based on Date.mcc (like
*	DateString.mcc), or who want to build their own classes based on
*	Date.mcc.
*
*   NOTES
*	None at the moment.
*
*****************************************************************************
*
*
*/

 #include "system.h"
 #include "Date_mcc.h"
 #include "Date_mcp.h"
 #include <proto/date.h>
 #include <proto/utility.h>
 #include <proto/intuition.h>
 #include <dos/dos.h>
 #include <proto/dos.h>
 #include <libraries/locale.h>
 #include <proto/locale.h>
 #include <libraries/mui.h>
 #include <proto/muimaster.h>
 #include <clib/alib_protos.h>
 #include <clib/alib_stdio_protos.h>


 #ifdef DEBUG
   void kprintf(UBYTE *fmt,...);
   #define debug(x)	kprintf(x "\n");
 #else
   #define debug(x)
 #endif


/*
******* Date/MUIA_Date_Day **************************************************
*
*   NAME
*	MUIA_Date_Day, USHORT [ISG] -- User selected day (V12)
*
*   SYNOPSIS
*	MUIA_Date_Day,	1,
*
*	\*result =*\ set(obj,MUIA_Date_Day,day);
*	\*result =*\ get(obj,MUIA_Date_Day,&day);
*
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Date_Day,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Date_Day attribute of a Date object is
*	triggered when a new object value is given.
*	Defaults to 0 if there was never a valid date value given!
*
*   INPUTS
*	day - Day of the date value
*	      Must be within the range 1-(last day of the month)
*
*   RESULT
*	day - Day of the date or 0
*
*   NOTES
*	Keep in mind that the day is related to MUIA_Date_Month
*	and MUIA_Date_Year! So it will be reset to 0 if you change
*	MUIA_Date_Month or MUIA_Date_Year.
*	If you set a wrong date or if the date is not within MinDate and
*	MaxDate then this attribute will be set back to its default!
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIA_Date_Month, MUIA_Date_Year
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIA_Date_Month ************************************************
*
*   NAME
*	MUIA_Date_Month, USHORT [ISG] -- Used month (V12)
*
*   SYNOPSIS
*	MUIA_Date_Month, 1,
*
*	\*result =*\ set(obj,MUIA_Date_Month,month);
*	\*result =*\ get(obj,MUIA_Date_Month,&month);
*
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Date_Month,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Date_Month attribute of a Date object is
*	triggered when a new object value is given.
*	Defaults to 0 if there was never a valid date value given!
*
*   INPUTS
*	month - Month of the date value
*	        Must be within the range 1-12
*
*   RESULT
*	month - Month of the date value or 0
*
*   NOTES
*	Keep in mind that the month is related to MUIA_Date_Year!
*	If you set a wrong date or if the date is not within MinDate and
*	MaxDate then this attribute will be set back to its default!
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIA_Date_Year, MUIA_Date_Day
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIA_Date_Year *************************************************
*
*   NAME
*	MUIA_Date_Year, LONG [ISG] -- Used year (V12)
*
*   SYNOPSIS
*	MUIA_Date_Year, 1997,
*
*	\*result =*\ set(obj,MUIA_Date_Year,year);
*	\*result =*\ get(obj,MUIA_Date_Year,&year);
*
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Date_Year,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Date_Year attribute of a Date object is
*	triggered when a new object value is given.
*	Defaults to 0 if there was never a valid date value given!
*
*   INPUTS
*	year - Year of the date value
*	       Must be within the range 8-8000
*
*   RESULT
*	year - Year of the date value or 0
*
*   NOTES
*	Always use full year numbers! I.e. use 1996 and *NOT* 96.
*	If you set a wrong date or if the date is not within MinDate and
*	MaxDate then this attribute will be set back to its default!
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIA_Date_Month, MUIA_Date_Day
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIA_Date_Country **********************************************
*
*   NAME
*	MUIA_Date_Country, Countries [I.G] -- ... (V12)
*
*   SYNOPSIS
*	MUIA_Date_Country, country,
*
*	\*result =*\ get(obj,MUIA_Date_Country,&country);
*
*   FUNCTION
*	With MUIA_Date_Country you can define the country to use
*	for the calendar reform.
*	Defaults to locale.library settings if present, else to
*	unknown.
*
*   INPUTS
*	country - Country to use for the calendar reform
*	   MUIV_Date_Country_Unknown
*	   MUIV_Date_Country_Italia
*	   MUIV_Date_Country_Deutschland
*	   MUIV_Date_Country_Schweiz
*	   MUIV_Date_Country_Danmark
*	   MUIV_Date_Country_Nederland
*	   MUIV_Date_Country_GreatBritain
*
*   RESULT
*	country - Country used for the calendar reform
*
*   NOTES
*	Keep in mind that this tag will overwrite the user prefs!
*
*	At the moment this is only a dummy attribut, because country support
*	for the date.library is still under construction.
*
*	Countries is defined in the date.library (Aminet:dev/c/date.lha) as
*	follows:
*	typedef enum {date_unknown,date_Italia,date_Deutschland,date_Schweiz,
*	   date_Danmark,date_Nederland,date_GreatBritain} date_Countries;
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIA_Date_FirstWeekday *****************************************
*
*   NAME
*	MUIA_Date_FirstWeekday, Weekdays [I.G] -- ... (V12)
*
*   SYNOPSIS
*	MUIA_Date_FirstWeekday, Monday,
*
*   FUNCTION
*	The MUIA_Date_FirstWeekday attribute makes it possible
*	to define which weekday is the first weekday in the week.
*	Defaults to locale.library setting if present, else it defaults to
*	Monday.
*
*   INPUTS
*	weekday - Weekday that is the first weekday of the week.
*	   MUIV_Date_Weekday_Monday
*	   MUIV_Date_Weekday_Tuesday
*	   MUIV_Date_Weekday_Wednesday
*	   MUIV_Date_Weekday_Thursday
*	   MUIV_Date_Weekday_Friday
*	   MUIV_Date_Weekday_Saturday
*	   MUIV_Date_Weekday_Sunday
*
*   NOTES
*	Keep in mind that this tag will overwrite the user prefs!
*	Weekdays is defined in the date.library (Aminet:dev/c/date.lha) as
*	follows:
*	typedef enum {date_dayerr,date_Monday,date_Tuesday,date_Wednesday,
*	   date_Thursday,date_Friday,date_Saturday,date_Sunday}
*	   date_Weekdays;
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIA_Date_Language *********************************************
*
*   NAME
*	MUIA_Date_Language, Languages [I.G] -- ... (V12)
*
*   SYNOPSIS
*	MUIA_Date_Language, language,
*
*   FUNCTION
*	With MUIA_Date_Language you can define the language to use
*	for the weekday/month names.
*	Defaults to locale.library settings if present, else to
*	ENGLISH
*
*   INPUTS
*	language - Language to use for the short weekday names
*	   MUIV_Date_Lang_Locale
*	   MUIV_Date_Lang_English
*	   MUIV_Date_Lang_Deutsch
*	   MUIV_Date_Lang_Français
*	   MUIV_Date_Lang_Español
*	   MUIV_Date_Lang_Português
*	   MUIV_Date_Lang_Dansk
*	   MUIV_Date_Lang_Italiano
*	   MUIV_Date_Lang_Nederlands
*	   MUIV_Date_Lang_Norsk
*	   MUIV_Date_Lang_Svenska
*	   MUIV_Date_Lang_Polski
*	   MUIV_Date_Lang_Suomi
*	   MUIV_Date_Lang_Magyar
*	   MUIV_Date_Lang_Greek
*	   MUIV_Date_Lang_Esperanto
*	   MUIV_Date_Lang_Latina
*	   MUIV_Date_Lang_Russian
*	   MUIV_Date_Lang_Czech
*	   MUIV_Date_Lang_Catalonian
*
*   NOTES
*	Keep in mind that this tag will overwrite the user prefs!
*	Languages is defined in the date.library (Aminet:dev/c/date.lha) as
*	follows:
*	typedef enum {date_Locale,date_ENGLISH,date_DEUTSCH,date_FRANCAIS,
*	   date_ESPANOL,date_PORTUGUES,date_DANSK,date_ITALIANO,
*	   date_NEDERLANDS,date_NORSK,date_SVENSKA,date_POLSKI,date_SUOMI,
*	   date_MAGYAR,date_GREEK,date_ESPERANTO,date_TURKCE,date_LATINA,
*	   date_RUSSIAN,plocale_CZECH,date_CATALONIAN} date_Languages;
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_SetCurrent *******************************************
*
*   NAME
*	MUIM_Date_SetCurrent -- Set the current date (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_SetCurrent);
*
*   FUNCTION
*	Set the current date.
*
*   NOTES
*	The date will be set to 0 when the current date is invalid.
*	When the current date exceeds the min or max limit, it will be
*	set to the belonging limit.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_IncreaseDays *****************************************
*
*   NAME
*	MUIM_Date_IncreaseDays -- Increase the date by days (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_IncreaseDays,days);
*
*   FUNCTION
*	Increases the date by days.
*
*   INPUTS
*	days - Days to add to the date.
*
*   NOTES
*	MUIM_Date_IncreaseDays considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_DecreaseDays, MUIM_Date_IncreaseMonths,
*	MUIM_Date_IncreaseYears, MUIM_Date_IncreaseToWeekday
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_DecreaseDays *****************************************
*
*   NAME
*	MUIM_Date_DecreaseDays -- Decrease the date by days (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_DecreaseDays,days);
*
*   FUNCTION
*	Decreases the date by days.
*
*   INPUTS
*	days - Days to subtract from the date.
*
*   NOTES
*	MUIM_Date_DecreaseDays considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_IncreaseDays, MUIM_Date_DecreaseMonths,
*	MUIM_Date_DecreaseYears, MUIM_Date_DecreaseToWeekday
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_IncreaseMonths ***************************************
*
*   NAME
*	MUIM_Date_IncreaseMonths -- Increase the date by months (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_IncreaseMonths,months);
*
*   FUNCTION
*	Increases the date by months.
*
*   INPUTS
*	months - Months to add to the date.
*
*   NOTES
*	MUIM_Date_IncreaseMonths considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_DecreaseMonths, MUIM_Date_IncreaseDays,
*	MUIM_Date_IncreaseYears, MUIM_Date_IncreaseToWeekday
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_DecreaseMonths ***************************************
*
*   NAME
*	MUIM_Date_DecreaseMonths -- Decrease the date by months (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_DecreaseMonths,months);
*
*   FUNCTION
*	Decreases the date by months.
*
*   INPUTS
*	months - Months to subtract from the date.
*
*   NOTES
*	MUIM_Date_DecreaseMonths considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_IncreaseMonths, MUIM_Date_DecreaseDays,
*	MUIM_Date_DecreaseYears, MUIM_Date_DecreaseToWeekday
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_IncreaseYears ****************************************
*
*   NAME
*	MUIM_Date_IncreaseYears -- Increase the date by years (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_IncreaseYears,years);
*
*   FUNCTION
*	Increases the date by years.
*
*   INPUTS
*	years - Years to add to the date.
*
*   NOTES
*	MUIM_Date_IncreaseYears considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_DecreaseYears, MUIM_Date_IncreaseDays,
*	MUIM_Date_IncreaseMonths, MUIM_Date_IncreaseToWeekday
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_DecreaseYears ****************************************
*
*   NAME
*	MUIM_Date_DecreaseYears -- Decrease the date by years (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_DecreaseYears,years);
*
*   FUNCTION
*	Decreases the date by years.
*
*   INPUTS
*	years - Years to subtract from the date.
*
*   NOTES
*	MUIM_Date_DecreaseYears considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_IncreaseYears, MUIM_Date_DecreaseDays,
*	MUIM_Date_DecreaseMonths, MUIM_Date_DecreaseToWeekday
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_IncreaseToWeekday ************************************
*
*   NAME
*	MUIM_Date_IncreaseToWeekday -- Increase the date upto a weekday (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_IncreaseToWeekday,weekday);
*
*   FUNCTION
*	Increases the date upto a weekday.
*
*   INPUTS
*	weekday - Weekday to increase to from the actual date.
*
*   NOTES
*	MUIM_Date_IncreaseToWeekday considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_DecreaseToWeekday, MUIM_Date_IncreaseDays,
*	MUIM_Date_IncreaseMonths, MUIM_Date_IncreaseYears
*
*****************************************************************************
*
*
*/

/*
******* Date/MUIM_Date_DecreaseToWeekday ************************************
*
*   NAME
*	MUIM_Date_DecreaseToWeekday -- Dec. the date downto a weekday (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Date_DecreaseToWeekday,weekday);
*
*   FUNCTION
*	Decreases the date downto a weekday.
*
*   INPUTS
*	weekday - Weekday to decrease to from the actual date.
*
*   NOTES
*	MUIM_Date_DecreaseToWeekday considers the Min- and MaxDate settings.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Date_IncreaseToWeekday, MUIM_Date_DecreaseDays,
*	MUIM_Date_DecreaseMonths, MUIM_Date_DecreaseYears
*
*****************************************************************************
*
*
*/



 #define CLASS			MUIC_Date
 #define SUPERCLASS		MUIC_Notify
 #define VERSION		12
 #define REVISION		0
 #define VERSIONSTR	        "12.0"
 #define AUTHOR			"Kai Hofmann"
 #define COPYRIGHT		"1996-1997"
 #define EXPORT_IMPORT_VERSION	1


 #define MINDAY	     1
 #define MINMONTH    1
 #define MINYEAR     8
 #define MAXDAY	    31
 #define MAXMONTH   12
 #define MAXYEAR  8000


 struct Data
  {
   UWORD day;
   UWORD month;
   LONG  year;
   date_Countries country;
   date_Languages language;
   date_Weekdays firstweekday;
   WORD attr_country;
   WORD attr_language;
   date_Weekdays attr_firstweekday;
  };

 /* ------------------------------------------------------------------------ */

 #include "MCCLib.c"

 /* ------------------------------------------------------------------------ */

 static ULONG STACKARGS DoSuperNew(struct IClass *const cl, Object *const obj, const ULONG tags, ...)
  {
   return(DoSuperMethod(cl,obj,OM_NEW,&tags,NULL));
  }

 /* --- data/type definitions ---------------------------------------------- */

 struct Library *DateBase;


 static date_Countries Country;
 static date_Weekdays  FirstWeekday;


 struct Export_Import
  {
   ULONG version;
   UWORD day;
   UWORD month;
   LONG  year;
  };

 /* --- Date --------------------------------------------------------------- */

 static ULONG SetCurrent(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_SetCurrent *const msg)
  {
   /*struct Data *data = (struct Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/
   struct DateStamp ds;
   UWORD day,month;
   LONG year;

   DateStamp(&ds);
   date_HeisDiffDate(1,1,1978,ds.ds_Days,&day,&month,&year);
   if (!date_ValidHeisDate(day,month,year))
    {
     day   = 0;
     month = 0;
     year  = 0;
    }
   /*result =*/ SetAttrs(obj,
                           MUIA_Date_Year,		year,
                           MUIA_Date_Month,		(ULONG)month,
                           MUIA_Date_Day,		(ULONG)day,
                         TAG_DONE
                        );
   return(TRUE);
  }


 static ULONG IncreaseDays(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_IncreaseDays *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month, day;
   LONG year;

   if (msg->days > 0)
    {
     date_HeisDiffDate(data->day,data->month,data->year,(long)msg->days,&day,&month,&year);
     /*result =*/ SetAttrs(obj,
                             MUIA_Date_Year,		year,
                             MUIA_Date_Month,		month,
                             MUIA_Date_Day,		day,
                           TAG_DONE
                          );
    }
   return(TRUE);
  }


 static ULONG DecreaseDays(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_DecreaseDays *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month, day;
   LONG year;

   if (msg->days > 0)
    {
     date_HeisDiffDate(data->day,data->month,data->year,-(long)msg->days,&day,&month,&year);
     /*result =*/ SetAttrs(obj,
                             MUIA_Date_Year,		year,
                             MUIA_Date_Month,		month,
                             MUIA_Date_Day,		day,
                           TAG_DONE
                          );
    }
   return(TRUE);
  }


 static ULONG IncreaseMonths(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_IncreaseMonths *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month = data->month, day = data->day;
   LONG year = data->year;
   BOOL change = FALSE;

   if (msg->months > 0)
    {
     month += msg->months;
     while (month > 12)
      {
       month -= 12;
       year++;
       change = TRUE;
      }
     if (!date_ValidHeisDate(day,month,year))
      {
       date_NextValidHeisDate(day,month,year,ARG(day),ARG(month),ARG(year));
       change = TRUE;
      }
     if (!change)
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Month,		month,
                             TAG_DONE
                            );
      }
     else
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Year,		year,
                               MUIA_Date_Month,		month,
                               MUIA_Date_Day,		day,
                             TAG_DONE
                            );
      }
    }
   return(TRUE);
  }


 static ULONG DecreaseMonths(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_DecreaseMonths *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month = data->month, day = data->day, months = msg->months;
   LONG year = data->year;
   BOOL change = FALSE;

   if (months > 0)
    {
     while (months > 12)
      {
       months -= 12;
       year--;
       change = TRUE;
      }
     if (months < month)
      {
       month -= months;
      }
     else
      {
       months -= month;
       month = 12;
       year--;
       month -= months;
      }
     if (!date_ValidHeisDate(day,month,year))
      {
       date_PreviousValidHeisDate(day,month,year,ARG(day),ARG(month),ARG(year));
       change = TRUE;
      }
     if (!change)
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Month,		month,
                             TAG_DONE
                            );
      }
     else
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Year,		year,
                               MUIA_Date_Month,		month,
                               MUIA_Date_Day,		day,
                             TAG_DONE
                            );
      }
    }
   return(TRUE);
  }


 static ULONG IncreaseYears(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_IncreaseYears *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month = data->month, day = data->day;
   LONG year = data->year;
   BOOL change = FALSE;

   if (msg->years > 0)
    {
     year += msg->years;
     if (!date_ValidHeisDate(day,month,year))
      {
       date_NextValidHeisDate(day,month,year,ARG(day),ARG(month),ARG(year));
       change = TRUE;
      }
     if (!change)
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Year,		year,
                             TAG_DONE
                            );
      }
     else
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Year,		year,
                               MUIA_Date_Month,		month,
                               MUIA_Date_Day,		day,
                             TAG_DONE
                            );
      }
    }
   return(TRUE);
  }


 static ULONG DecreaseYears(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_DecreaseYears *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month = data->month, day = data->day;
   LONG year = data->year;
   BOOL change = FALSE;

   if (msg->years > 0)
    {
     if (msg->years > year-MINYEAR)
      {
       return(FALSE);
      }
     year -= msg->years;
     if (!date_ValidHeisDate(day,month,year))
      {
       date_PreviousValidHeisDate(day,month,year,ARG(day),ARG(month),ARG(year));
       change = TRUE;
      }
     if (!change)
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Year,		year,
                             TAG_DONE
                            );
      }
     else
      {
       /*result =*/ SetAttrs(obj,
                               MUIA_Date_Year,		year,
                               MUIA_Date_Month,		month,
                               MUIA_Date_Day,		day,
                             TAG_DONE
                            );
      }
    }
   return(TRUE);
  }


 static ULONG IncreaseToWeekday(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_IncreaseToWeekday *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month, day, days;
   LONG year;

   if ((date_Weekdays)msg->weekday != date_dayerr)
    {
     days = date_HeisDaysAfterWeekday(data->day,data->month,data->year,(date_Weekdays)msg->weekday);
     if (days == 0)
      {
       days = 7;
      }
     date_HeisDiffDate(data->day,data->month,data->year,(long)days,&day,&month,&year);
     /*result =*/ SetAttrs(obj,
                             MUIA_Date_Year,		year,
                             MUIA_Date_Month,		month,
                             MUIA_Date_Day,		day,
                           TAG_DONE
                          );
     return(TRUE);
    }
   else
    {
     return(FALSE);
    }
  }


 static ULONG DecreaseToWeekday(const struct IClass *const cl, Object *const obj, const struct MUIP_Date_DecreaseToWeekday *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   UWORD month, day, days;
   LONG year;

   if ((date_Weekdays)msg->weekday != date_dayerr)
    {
     days = date_HeisDaysBeforeWeekday(data->day,data->month,data->year,(date_Weekdays)msg->weekday);
     if (days == 0)
      {
       days = 7;
      }
     date_HeisDiffDate(data->day,data->month,data->year,-(long)days,&day,&month,&year);
     /*result =*/ SetAttrs(obj,
                             MUIA_Date_Year,		year,
                             MUIA_Date_Month,		month,
                             MUIA_Date_Day,		day,
                           TAG_DONE
                          );
     return(TRUE);
    }
   else
    {
     return(FALSE);
    }
  }


 static ULONG Import(const struct IClass *const cl, Object *const obj, const struct MUIP_Import *const msg)
  {
   ULONG id;

   id = muiNotifyData(obj)->mnd_ObjectID;
   if (id != 0)
    {
     /*struct Data *data = (struct Data *)INST_DATA(cl,obj);*/
     /*ULONG result;*/
     struct Export_Import *import;

     import = (struct Export_Import *)DoMethod(msg->dataspace,MUIM_Dataspace_Find,id);
     if (import != NULL)
      {
       if (import->version >= EXPORT_IMPORT_VERSION)
        {
         /*result =*/ SetAttrs(obj,
                                 MUIA_Date_Year,  import->year,
                                 MUIA_Date_Month, (ULONG)import->month,
                                 MUIA_Date_Day,   (ULONG)import->day,
                               TAG_DONE
                              );
        }
       else
        {
         /* partial import */
         /*result =*/ SetAttrs(obj,
                                 MUIA_Date_Year,  import->year,
                                 MUIA_Date_Month, (ULONG)import->month,
                                 MUIA_Date_Day,   (ULONG)import->day,
                               TAG_DONE
                              );
        }
      }
    }
   return(0);
  }


 static ULONG Export(const struct IClass *const cl, Object *const obj, const struct MUIP_Export *const msg)
  {
   ULONG id;

   id = muiNotifyData(obj)->mnd_ObjectID;
   if (id != 0)
    {
     struct Data *data = (struct Data *)INST_DATA(cl,obj);
     /*ULONG result;*/
     struct Export_Import export;

     export.version = EXPORT_IMPORT_VERSION;
     export.day     = data->day;
     export.month   = data->month;
     export.year    = data->year;
     /*result =*/ DoMethod(msg->dataspace,MUIM_Dataspace_Add,&export,sizeof(struct Export_Import),id);
    }
   return(0);
  }


 static ULONG DragQuery(const struct IClass *const cl, Object *const obj, const struct MUIP_DragQuery *const msg)
  {
   /*struct Data *data = (struct Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/

   if (obj != msg->obj)
    {
     ULONG Year,Month,Day;

     if (get(msg->obj,MUIA_Date_Year,&Year) && get(msg->obj,MUIA_Date_Month,&Month) && get(msg->obj,MUIA_Date_Day,&Day))
      {
       if (date_ValidHeisDate((unsigned short)Day,(unsigned short)Month,(long)Year))
        {
         return(MUIV_DragQuery_Accept);
        }
      }
    }
   return(MUIV_DragQuery_Refuse);
  }


 static ULONG DragDrop(const struct IClass *const cl, Object *const obj, const struct MUIP_DragDrop *const msg)
  {
   /*struct Data *data = (struct Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/
   ULONG Day,Month,Year;

   /*result =*/ get(msg->obj,MUIA_Date_Year,&Year);
   /*result =*/ get(msg->obj,MUIA_Date_Month,&Month);
   /*result =*/ get(msg->obj,MUIA_Date_Day,&Day);
   if (date_ValidHeisDate((unsigned short)Day,(unsigned short)Month,(long)Year))
    {
     /*result =*/ SetAttrs(obj,
                             MUIA_Date_Year,	Year,
                             MUIA_Date_Month,	Month,
	  		     MUIA_Date_Day,	Day,
			   TAG_DONE
                          );
    }
   return(0);
  }


 static ULONG Set(struct IClass *const cl, Object *const obj, const struct opSet *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   struct TagItem *tags,*tag;
   UWORD day,month;
   LONG year;

   day = data->day;
   month = data->month;
   year = data->year;
   tags = msg->ops_AttrList;
   while (tag = NextTagItem(&tags))
    {
     switch (tag->ti_Tag)
      {
       case MUIA_Date_Day			: if (((UWORD)tag->ti_Data >= 1) && ((UWORD)tag->ti_Data <= 31))
						   {
						    day = (UWORD)tag->ti_Data;
						   }
						  break;
       case MUIA_Date_Month			: if (((UWORD)tag->ti_Data >= 1) && ((UWORD)tag->ti_Data <= 12))
					           {
						    month = (UWORD)tag->ti_Data;
						   }
						  break;
       case MUIA_Date_Year			: if (((LONG)tag->ti_Data >= 8) && ((LONG)tag->ti_Data <= 8000))
						   {
						    year = (LONG)tag->ti_Data;
						   }
						  break;
      }
    }

   if ((day != data->day) || (month != data->month) || (year != data->year))
    {
     data->day   = day;
     data->month = month;
     data->year  = year;
    }
   return(DoSuperMethodA(cl,obj,(Msg)msg));
  }


 static ULONG Get(struct IClass *const cl, Object *const obj, struct opGet *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);

   switch (msg->opg_AttrID)
    {
     case MUIA_Date_Day			: *(msg->opg_Storage) = (ULONG)data->day;
					  return(TRUE);
     case MUIA_Date_Month		: *(msg->opg_Storage) = (ULONG)data->month;
				 	  return(TRUE);
     case MUIA_Date_Year		: *(msg->opg_Storage) = (ULONG)data->year;
					  return(TRUE);
     case MUIA_Date_Country		: *(msg->opg_Storage) = (ULONG)data->country;
     					  return(TRUE);
     case MUIA_Date_FirstWeekday	: *(msg->opg_Storage) = (ULONG)data->firstweekday;
     					  return(TRUE);
     case MUIA_Date_Language		: *(msg->opg_Storage) = (ULONG)data->language;
     					  return(TRUE);
     case MUIA_Version			: *(msg->opg_Storage) = (ULONG)VERSION;
					  return(TRUE);
     case MUIA_Revision 		: *(msg->opg_Storage) = (ULONG)REVISION;
					  return(TRUE);
     default				: return(DoSuperMethodA(cl,obj,(Msg)msg));
    }
  }


 static ULONG Setup(struct IClass *const cl, Object *const obj, const struct MUIP_Setup *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   ULONG help;

   if (data->attr_country == -1)
    {
     if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_Date_Country,&help))
      {
       data->country = (date_Countries)(*(ULONG *)help);
      }
     else
      {
       data->country = Country;
      }
    }
   else
    {
     data->country = data->attr_country;
    }
   date_SetCountry(data->country);
   if (data->attr_language == -1)
    {
     if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_Date_Language,&help))
      {
       data->language = (date_Languages)(*(ULONG *)help);
      }
     else
      {
       data->language = date_Locale;
      }
    }
   else
    {
     data->language = data->attr_language;
    }
   if (data->attr_firstweekday == date_dayerr)
    {
     if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_Date_FirstWeekday,&help))
      {
       data->firstweekday = (date_Weekdays)(*(ULONG *)help);
      }
     else
      {
       data->firstweekday = date_dayerr;
      }
    }
   else
    {
     data->firstweekday = data->attr_firstweekday;
    }
   if (data->firstweekday == date_dayerr)
    {
     data->firstweekday = FirstWeekday;
    }
   date_SetFirstWeekday(data->firstweekday);
   return(DoSuperMethodA(cl,obj,(Msg)msg));
  }


 static ULONG New(struct IClass *const cl, Object *obj, const struct opSet *const msg)
  {
   /*ULONG result;*/
   struct TagItem *tags,*tag;

   obj = (Object *)DoSuperNew(cl,obj,
			      TAG_MORE, 		msg->ops_AttrList
			     );
   if (obj != NULL)
    {
     struct Data *data = (struct Data *)INST_DATA(cl,obj);
     /*ULONG result;*/

     data->day          = 0;
     data->month        = 0;
     data->year         = 0;
     data->country      = Country;

     data->attr_country = -1;
     data->attr_firstweekday = date_dayerr;
     data->attr_language = -1;

     tags = msg->ops_AttrList;
     while (tag = NextTagItem(&tags))
      {
       switch (tag->ti_Tag)
	{
	 case MUIA_Date_Day		: if (((UWORD)tag->ti_Data >= 1) && ((UWORD)tag->ti_Data <= 31))
					   {
					    data->day = (UWORD)tag->ti_Data;
					   }
					  break;
	 case MUIA_Date_Month 		: if (((UWORD)tag->ti_Data >= 1) && ((UWORD)tag->ti_Data <= 12))
					   {
					    data->month = (UWORD)tag->ti_Data;
					   }
					  break;
	 case MUIA_Date_Year		: if (((LONG)tag->ti_Data >= 8) && ((LONG)tag->ti_Data <= 8000))
					   {
					    data->year = (LONG)tag->ti_Data;
					   }
					  break;
	 case MUIA_Date_Country		: if ((date_Countries)tag->ti_Data < date_LASTCOUNTRY)
            				   {
					    data->attr_country = (WORD)tag->ti_Data;
         				    data->country = (date_Countries)data->attr_country;
         				    date_SetCountry(data->country);
         				   }
         				  break;
	 case MUIA_Date_FirstWeekday	: if (((date_Weekdays)tag->ti_Data >= date_Monday) && ((date_Weekdays)tag->ti_Data <= date_Sunday))
					   {
					    data->attr_firstweekday = (WORD)tag->ti_Data;
					    data->firstweekday = (date_Weekdays)tag->ti_Data;
					    date_SetFirstWeekday(data->firstweekday);
					   }
					  break;
	 case MUIA_Date_Language	: if ((date_Languages)tag->ti_Data < date_LASTLANGUAGE)
					   {
					    data->attr_language = (WORD)tag->ti_Data;
					    data->language = (date_Languages)tag->ti_Data;
					   }
					  break;
	}
      }
     if ((data->day != 0) && (data->month != 0) && (data->year != 0))
      {
       if (!date_ValidHeisDate(data->day,data->month,data->year))
        {
         data->day   = 0;
         data->month = 0;
         data->year  = 0;
        }
      }
    }
   return((ULONG)obj);
  }


 static ULONG SAVEDS_ASM Dispatcher(REG(A0) struct IClass *const cl, REG(A2) Object *const obj, REG(A1) const Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW			: return(New(cl,obj,(struct opSet *)msg));
     case OM_SET			: return(Set(cl,obj,(struct opSet *)msg));
     case OM_GET			: return(Get(cl,obj,(struct opGet *)msg));
     case MUIM_Setup			: return(Setup(cl,obj,(struct MUIP_Setup *)msg));;
     case MUIM_DragQuery		: return(DragQuery(cl,obj,(struct MUIP_DragQuery *)msg));
     case MUIM_DragDrop			: return(DragDrop(cl,obj,(struct MUIP_DragDrop *)msg));
     case MUIM_Export			: return(Export(cl,obj,(struct MUIP_Export *)msg));
     case MUIM_Import			: return(Import(cl,obj,(struct MUIP_Import *)msg));
     case MUIM_Date_SetCurrent		: return(SetCurrent(cl,obj,(struct MUIP_Date_SetCurrent *)msg));
     case MUIM_Date_IncreaseDays	: return(IncreaseDays(cl,obj,(struct MUIP_Date_IncreaseDays *)msg));
     case MUIM_Date_DecreaseDays	: return(DecreaseDays(cl,obj,(struct MUIP_Date_DecreaseDays *)msg));
     case MUIM_Date_IncreaseMonths	: return(IncreaseMonths(cl,obj,(struct MUIP_Date_IncreaseMonths *)msg));
     case MUIM_Date_DecreaseMonths	: return(DecreaseMonths(cl,obj,(struct MUIP_Date_DecreaseMonths *)msg));
     case MUIM_Date_IncreaseYears	: return(IncreaseYears(cl,obj,(struct MUIP_Date_IncreaseYears *)msg));
     case MUIM_Date_DecreaseYears	: return(DecreaseYears(cl,obj,(struct MUIP_Date_DecreaseYears *)msg));
     case MUIM_Date_IncreaseToWeekday	: return(IncreaseToWeekday(cl,obj,(struct MUIP_Date_IncreaseToWeekday *)msg));
     case MUIM_Date_DecreaseToWeekday	: return(DecreaseToWeekday(cl,obj,(struct MUIP_Date_DecreaseToWeekday *)msg));
     default				: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* ------------------------------------------------------------------------ */

 static BOOL ClassInitFunc(const struct Library *const base)
  {
   DateBase = OpenLibrary(DATE_NAME,33);
   if (DateBase != NULL)
    {
     if ((DateBase->lib_Version > 33) || ((DateBase->lib_Version == 33) && (DateBase->lib_Revision >= 290)))
      {
       struct Library *LocaleBase;

       LocaleBase = OpenLibrary("locale.library",0);
       if (LocaleBase != NULL)
        {
         struct Locale *locale;

         locale = OpenLocale(NULL);
         if (locale != NULL)
          {
           switch (locale->loc_CalendarType)
            {
             case CT_7SUN 	: FirstWeekday = date_Sunday;
                          	  break;
             case CT_7MON 	: FirstWeekday = date_Monday;
                          	  break;
             case CT_7TUE 	: FirstWeekday = date_Tuesday;
                          	  break;
             case CT_7WED 	: FirstWeekday = date_Wednesday;
                          	  break;
             case CT_7THU 	: FirstWeekday = date_Thursday;
                          	  break;
             case CT_7FRI 	: FirstWeekday = date_Friday;
                          	  break;
             case CT_7SAT 	: FirstWeekday = date_Saturday;
                          	  break;
             default      	: FirstWeekday = date_Monday;
            }
           switch (locale->loc_CountryCode)
            {
             case 1230258432	: Country = date_Italia;
             			  break;
             case 1140850688	: Country = date_Deutschland;
             			  break;
             case 1128792064	: Country = date_Schweiz;
             			  break;
             case 1145765888	: Country = date_Danmark;
             			  break;
	     case 1313603584	: Country = date_Nederland;
	     			  break;
	     case 1195507712	: Country = date_GreatBritain;
				  break;
             default		: Country = date_unknown;
            }
           CloseLocale(locale);
          }
         else
          {
           FirstWeekday = date_Monday;
           Country = date_unknown;
          }
         CloseLibrary(LocaleBase);
        }
       else
        {
         FirstWeekday = date_Monday;
         Country = date_unknown;
        }
       return(TRUE);
      }
     CloseLibrary(DateBase);
    }
   return(FALSE);
  }


 static VOID ClassExitFunc(const struct Library *const base)
  {
   if (DateBase != NULL)
    {
     CloseLibrary(DateBase);
    }
  }

 /* ------------------------------------------------------------------------ */
