/* Copyright © 1996-1997 Kai Hofmann. All rights reserved.
*****i* Time/--history-- ****************************************************
*
*   NAME
*	history -- Development history of the Time MUI custom class
*
*   VERSION
*	$VER: Time 12.0 (26.12.97)
*
*****************************************************************************
*
*
*/

/*
******* Time/--background-- *************************************************
*
*   NAME
*	Time -- ... (V12)
*
*   FUNCTION
*	Time is an abstract Custom Class of the Magic User Interface © by
*	Stefan Stuntz.
*	It's a subclass of notify-class and only usable for developers who
*	want to build subclasses of Time.mcc!
*
*	The idea of this class was born during developing my Gregor
*	application.
*
*	MUI abstract public custom class that allowing easy handling of time.
*	Because it is abstract it is only usefull for developers working with
*	classes that are based on Time.mcc (like TimeString.mcc), or those
*	who want to build their own Time.mcc based classes.
*
*   NOTES
*	None at the moment.
*
*****************************************************************************
*
*
*/

 #include <system.h>
 #include <mui/Time_mcc.h>
 #include <proto/date.h>
 #include <proto/utility.h>
 #include <libraries/locale.h>
 #include <proto/locale.h>
 #include <proto/intuition.h>
 #include <dos/dos.h>
 #include <proto/dos.h>
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
******* Time/MUIA_Time_Hour *************************************************
*
*   NAME
*	MUIA_Time_Hour, UWORD [ISG] -- User selected hour (V12)
*
*   SYNOPSIS
*	MUIA_Time_Hour,	0,
*
*	\*result =*\ set(obj,MUIA_Time_Hour,hour);
*	\*result =*\ get(obj,MUIA_Time_Hour,&hour);
*
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Time_Hour,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Time_Hour attribute of a Time object is
*	triggered when a new object value is given.
*	Defaults to 0 if there was never a valid time value given!
*
*   INPUTS
*	hour - Hour of the time value
*
*   RESULT
*	hour - Hour of the time value
*
*   NOTES
*	The hour is always in 24h format!
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIA_Time_Minute, MUIA_Time_Second
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIA_Time_Minute ***********************************************
*
*   NAME
*	MUIA_Time_Minute, UWORD [ISG] -- Used minute (V12)
*
*   SYNOPSIS
*	MUIA_Time_Minute, 0,
*
*	\*result =*\ set(obj,MUIA_Time_Minute,minute);
*	\*result =*\ get(obj,MUIA_Time_Minute,&minute);
*
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Time_Minute,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Time_Minute attribute of a Time object is
*	triggered when a new value is given.
*	Defaults to 0 if there was never a valid time value given!
*
*   INPUTS
*	minute - Minute of the time value
*
*   RESULT
*	minute - Minute of the time value
*
*   NOTES
*	None.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIA_Time_Hour, MUIA_Time_Second
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIA_Time_Second ***********************************************
*
*   NAME
*	MUIA_Time_Second, UWORD [ISG] -- Used second (V12)
*
*   SYNOPSIS
*	MUIA_Time_Second, 0,
*
*	\*result =*\ set(obj,MUIA_Time_Second,second);
*	\*result =*\ get(obj,MUIA_Time_Second,&second);
*
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Time_Second,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Time_Second attribute of a Time object is
*	triggered when a new value is given.
*	Defaults to 0 if there was never a valid time value given!
*
*   INPUTS
*	second - Second of the time value
*
*   RESULT
*	second - Second of the time value
*
*   NOTES
*	None.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIA_Time_Hour, MUIA_Time_Minute
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIA_Time_NextDay **********************************************
*
*   NAME
*	MUIA_Time_NextDay, UWORD [..G] -- The next day has begun (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Time_NextDay,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Time_NextDay attribute of a Time object will be triggered
*	when the time changes from 23:59:59 to 00:00:00
*	Defaults to 0.
*
*   RESULT
*	nextday - Triggered when the next day begins.
*
*   NOTES
*	None.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Time_Increase
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIA_Time_PrevDay **********************************************
*
*   NAME
*	MUIA_Time_PrevDay, UWORD [..G] -- Changed to previous day (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Notify,MUIA_Time_PrevDay,
*	    MUIV_EveryTime,STRINGOBJ,2,MUIM_String_Integer,MUIV_TriggerValue);
*
*   FUNCTION
*	The MUIA_Time_PrevDay attribute of a Time object will be triggered
*	when the time changes from 00:00:00 to 23:59:59
*	Defaults to 0.
*
*   RESULT
*	prevday - Triggered when changed to the previous day.
*
*   NOTES
*	None.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Time_Decrease
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIM_Time_Increase *********************************************
*
*   NAME
*	MUIM_Time_Increase -- Increase the time (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Time_Increase,seconds);
*
*   FUNCTION
*	Increases the time by seconds.
*
*   INPUTS
*	seconds - Seconds to add to the time.
*
*   NOTES
*	None.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Time_Decrease, MUIA_Time_NextDay
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIM_Time_Decrease *********************************************
*
*   NAME
*	MUIM_Time_Decrease -- Decrease the time (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Time_Decrease,seconds);
*
*   FUNCTION
*	Decreases the time by seconds.
*
*   INPUTS
*	seconds - Seconds to sub from the time.
*
*   NOTES
*	None.
*
*   BUGS
*	No known bugs.
*
*   SEE ALSO
*	MUIM_Time_Increase, MUIA_Time_PrevDay
*
*****************************************************************************
*
*
*/

/*
******* Time/MUIM_Time_SetCurrent *******************************************
*
*   NAME
*	MUIM_Time_SetCurrent -- Set the current time (V12)
*
*   SYNOPSIS
*	\*result =*\ DoMethod(obj,MUIM_Time_SetCurrent);
*
*   FUNCTION
*	Set the current time including the users time zone.
*
*   NOTES
*	None.
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


 #define CLASS			MUIC_Time
 #define SUPERCLASS		MUIC_Notify
 #define VERSION		12
 #define REVISION		0
 #define VERSIONSTR	        "12.0"
 #define AUTHOR			"Kai Hofmann"
 #define COPYRIGHT		"1996-1997"
 #define EXPORT_IMPORT_VERSION	1


 struct Data
  {
   UWORD hour;
   UWORD minute;
   UWORD second;
   UWORD nextday;
   UWORD prevday;
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


 struct Export_Import
  {
   ULONG version;
   UWORD hour;
   UWORD minute;
   UWORD second;
  };

 /* --- Time --------------------------------------------------------------- */

 static ULONG Increase(struct IClass *const cl, Object *const obj, const struct MUIP_Time_Increase *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   ULONG secs,addsecs;
   UWORD days = 0,hour,minute,second;

   secs = time_TimeToSec(data->hour,data->minute,data->second);
   addsecs = msg->seconds;
   while (addsecs > 86399)
    {
     addsecs -= 86400;
     days++;
    }
   secs += addsecs;
   if (secs > 86399)
    {
     secs -= 86400;
     days++;
    }
   time_SecToTime(secs,&hour,&minute,&second);
   data->prevday = 0;
   data->nextday = days;
   /*result =*/ SetAttrs(obj,
                           MUIA_Time_Hour,	(ULONG)hour,
                           MUIA_Time_Minute,	(ULONG)minute,
                           MUIA_Time_Second,	(ULONG)second,
                           (days > 0) ? MUIA_Time_NextDay : TAG_IGNORE,	(ULONG)days,
                         TAG_DONE
                        );
   return(TRUE);
  }


 static ULONG Decrease(struct IClass *const cl, Object *const obj, const struct MUIP_Time_Decrease *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   ULONG secs,subsecs;
   UWORD days = 0,hour,minute,second;

   secs = time_TimeToSec(data->hour,data->minute,data->second);
   subsecs = msg->seconds;
   while (subsecs > 86399)
    {
     subsecs -= 86400;
     days++;
    }
   if (subsecs > secs)
    {
     subsecs -= secs;
     secs = 86400 - subsecs;
     days++;
    }
   else
    {
     secs -= subsecs;
    }
   time_SecToTime((ULONG)secs,&hour,&minute,&second);
   data->nextday = 0;
   data->prevday = days;
   /*result =*/ SetAttrs(obj,
                           MUIA_Time_Hour,	(ULONG)hour,
                           MUIA_Time_Minute,	(ULONG)minute,
                           MUIA_Time_Second,	(ULONG)second,
                           (days > 0) ? MUIA_Time_PrevDay : TAG_IGNORE,	(ULONG)days,
                         TAG_DONE
                        );
   return(TRUE);
  }


 static ULONG SetCurrent(const struct IClass *const cl, Object *const obj, const struct MUIP_Time_SetCurrent *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   struct DateStamp ds;
   ULONG hour,minute,second;

   DateStamp(&ds);
   hour   = (ULONG)(ds.ds_Minute / 60);
   minute = (ULONG)(ds.ds_Minute - (hour * 60));
   second = (ULONG)(ds.ds_Tick / TICKS_PER_SECOND);
   data->nextday = 0;
   data->prevday = 0;
   /*result =*/ SetAttrs(obj,
                           MUIA_Time_Hour,	hour,
                           MUIA_Time_Minute,	minute,
                           MUIA_Time_Second,	second,
                         TAG_DONE
                        );
   return(TRUE);
  }


 static ULONG Import(const struct IClass *const cl, Object *const obj, const struct MUIP_Import *const msg)
  {
   ULONG id;

   id = muiNotifyData(obj)->mnd_ObjectID;
   if (id != 0)
    {
     struct Data *data = (struct Data *)INST_DATA(cl,obj);
     /*ULONG result;*/
     struct Export_Import *import;

     import = (struct Export_Import *)DoMethod(msg->dataspace,MUIM_Dataspace_Find,id);
     if (import != NULL)
      {
       data->nextday = 0;
       data->prevday = 0;
       if (import->version >= EXPORT_IMPORT_VERSION)
        {
         /*result =*/ SetAttrs(obj,
                                 MUIA_Time_Hour,		(ULONG)import->hour,
                                 MUIA_Time_Minute,		(ULONG)import->minute,
                                 MUIA_Time_Second,		(ULONG)import->second,
                               TAG_DONE
                              );
        }
       else
        {
         /* partial import */
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

     export.version        = EXPORT_IMPORT_VERSION;
     export.hour           = data->hour;
     export.minute         = data->minute;
     export.second         = data->second;
     /*result =*/ DoMethod(msg->dataspace,MUIM_Dataspace_Add,&export,sizeof(struct Export_Import),id);
    }
   return(0);
  }


 static ULONG DragQuery(const struct IClass *const cl, Object *const obj, const struct MUIP_DragQuery *const msg)
  {
   /*struct Data *data = (struct Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/

   if (msg->obj != obj)
    {
     ULONG Hour,Min,Sec;

     if (get(msg->obj,MUIA_Time_Hour,&Hour) && get(msg->obj,MUIA_Time_Minute,&Min) && get(msg->obj,MUIA_Time_Second,&Sec))
      {
       if (time_ValidTime((unsigned short)Hour,(unsigned short)Min,(unsigned short)Sec))
        {
         return(MUIV_DragQuery_Accept);
        }
      }
    }
   return(MUIV_DragQuery_Refuse);
  }


 static ULONG DragDrop(const struct IClass *const cl, Object *const obj, const struct MUIP_DragDrop *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   ULONG Hour,Min,Sec;

   /*result =*/ get(msg->obj,MUIA_Time_Hour,&Hour);
   /*result =*/ get(msg->obj,MUIA_Time_Minute,&Min);
   /*result =*/ get(msg->obj,MUIA_Time_Second,&Sec);
   if (time_ValidTime((unsigned short)Hour,(unsigned short)Min,(unsigned short)Sec))
    {
     data->nextday = 0;
     data->prevday = 0;
     /*result =*/ SetAttrs(obj,
			     MUIA_Time_Hour,		Hour,
                             MUIA_Time_Minute,		Min,
                             MUIA_Time_Second,		Sec,
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
   UWORD hour,minute,second;

   hour   = data->hour;
   minute = data->minute;
   second = data->second;
   tags = msg->ops_AttrList;
   while (tag = NextTagItem(&tags))
    {
     switch (tag->ti_Tag)
      {
       case MUIA_Time_Hour			: hour = (UWORD)tag->ti_Data;
                                                  if (hour > 23)
                                                   {
                                                    hour = 0; /* error */
                                                   }
						  break;
       case MUIA_Time_Minute			: minute = (UWORD)tag->ti_Data;
                                                  if (minute > 59)
                                                   {
                                                    minute = 0; /* error */
                                                   }
						  break;
       case MUIA_Time_Second			: second = (UWORD)tag->ti_Data;
                                                  if (second > 59)
                                                   {
                                                    second = 0; /* error */
                                                   }
						  break;
      }
    }
   data->hour = hour;
   data->minute = minute;
   data->second = second;
   return(DoSuperMethodA(cl,obj,(Msg)msg));
  }


 static ULONG Get(struct IClass *const cl, Object *const obj, struct opGet *const msg)
  {
   struct Data *data = (struct Data *)INST_DATA(cl,obj);

   switch (msg->opg_AttrID)
    {
     case MUIA_Time_Hour			: *(msg->opg_Storage) = (ULONG)data->hour;
						  return(TRUE);
     case MUIA_Time_Minute			: *(msg->opg_Storage) = (ULONG)data->minute;
						  return(TRUE);
     case MUIA_Time_Second			: *(msg->opg_Storage) = (ULONG)data->second;
						  return(TRUE);
     case MUIA_Time_NextDay			: *(msg->opg_Storage) = (ULONG)data->nextday;
     						  data->nextday = 0;
						  return(TRUE);
     case MUIA_Time_PrevDay			: *(msg->opg_Storage) = (ULONG)data->prevday;
     						  data->prevday = 0;
						  return(TRUE);
     case MUIA_Version				: *(msg->opg_Storage) = (ULONG)VERSION;
						  return(TRUE);
     case MUIA_Revision 			: *(msg->opg_Storage) = (ULONG)REVISION;
						  return(TRUE);
     default					: return(DoSuperMethodA(cl,obj,(Msg)msg));
    }
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
     BOOL settime = FALSE;

     data->hour   = 0;
     data->minute = 0;
     data->second = 0;
     data->nextday = 0;
     data->prevday = 0;

     tags = msg->ops_AttrList;
     while (tag = NextTagItem(&tags))
      {
       switch (tag->ti_Tag)
	{
	 case MUIA_Time_Hour				: if ((UWORD)tag->ti_Data <= 23)
							   {
							    data->hour = (UWORD)tag->ti_Data;
							    settime = TRUE;
							   }
							  break;
	 case MUIA_Time_Minute 				: if ((UWORD)tag->ti_Data <= 59)
							   {
							    data->minute = (UWORD)tag->ti_Data;
							   }
							  break;
	 case MUIA_Time_Second				: if ((UWORD)tag->ti_Data <= 59)
							   {
							    data->second = (UWORD)tag->ti_Data;
							   }
							  break;
	}
      }
     if (!settime)
      {
       /*result =*/ DoMethod(obj,MUIM_Time_SetCurrent);
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
     case MUIM_DragQuery		: return(DragQuery(cl,obj,(struct MUIP_DragQuery *)msg));
     case MUIM_DragDrop			: return(DragDrop(cl,obj,(struct MUIP_DragDrop *)msg));
     case MUIM_Export			: return(Export(cl,obj,(struct MUIP_Export *)msg));
     case MUIM_Import			: return(Import(cl,obj,(struct MUIP_Import *)msg));
     case MUIM_Time_Increase		: return(Increase(cl,obj,(struct MUIP_Time_Increase *)msg));
     case MUIM_Time_Decrease		: return(Decrease(cl,obj,(struct MUIP_Time_Decrease *)msg));
     case MUIM_Time_SetCurrent		: return(SetCurrent(cl,obj,(struct MUIP_Time_SetCurrent *)msg));
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
