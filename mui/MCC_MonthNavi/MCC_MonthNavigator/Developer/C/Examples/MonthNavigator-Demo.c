/*
**
** Copyright © 1996-1999 Dipl.-Inform. Kai Hofmann. All rights reserved.
** Demo for a registered MUI custom class!
**
** $VER: MonthNavigator-Demo.c 16.7 (12.12.99)
**
*/

 #define __MakeLib

 #include "system.h"
 #include <mui/Date_mcc.h>
 #include <libraries/mui.h>
 #include <mui/MonthNavigator_mcc.h>
 #include <proto/date.h>
 #include <proto/muimaster.h>
 #include <utility/tagitem.h>
 #include <proto/utility.h>
 #include <exec/libraries.h>
 #include <exec/memory.h>
 #include <proto/exec.h>
 #include <proto/dos.h>
 #include <proto/intuition.h>
 #include <clib/alib_protos.h>
 #include <string.h>


 #ifndef MAKE_ID
   #define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
 #endif


 #define VERSIONSTR	"16.7"
 #define COPYRIGHT	"1996-1999"


 struct MUI_CustomClass *App_CC=NULL,*Win_CC=NULL,*Str_CC=NULL,*MN_CC=NULL,*DateNavigator_CC=NULL;


 struct Library *DateBase;
 struct Library *MUIMasterBase;
 static Object *App;


 #define MUIA_Win_InputMode		((TAG_USER | 494 << 16) | 0x8001)
 #define MUIA_Win_DNObjectID		((TAG_USER | 494 << 16) | 0x8002)

 #define MUIA_DateNavigator_ObjectID	((TAG_USER | 494 << 16) | 0x8003)
 #define MUIM_DateNavigator_Update	((TAG_USER | 494 << 16) | 0x8004)
 #define MUIM_DateNavigator_UpdateDay	((TAG_USER | 494 << 16) | 0x8005)
 #define MUIM_DateNavigator_MonthUpdate	((TAG_USER | 494 << 16) | 0x8006)

 struct MUIP_DateNavigator_MonthUpdate	{ULONG MethodID; ULONG Month;};


 struct DateNavigator_Data
  {
   Object *monthnavigator;
   Object *month,*year,*day;
  };


 struct MN_Data
  {
   STRPTR TodayPreParse;
   STRPTR TodayShortHelp;
   LONG   TodayBackground;
   WORD   InputMode;
  };


 struct Calendar_Entry
  {
   UWORD  Day,Month;
   LONG   Year;
   STRPTR ShortHelp;
  };


 struct Calendar_List
  {
   struct Calendar_List  *Prev;
   struct Calendar_List  *Next;
   struct Calendar_Entry  Entry;
  };


 static APTR mempool = NULL;
 static char *months[13];
 static struct Calendar_List *root = NULL;

 /* ------------------------------------------------------------------------ */

 static ULONG STACKARGS DoSuperNew(struct IClass *cl, Object *obj, ULONG tags, ...)
  {
   return(DoSuperMethod(cl,obj,OM_NEW,&tags,NULL));
  }

 /* --- Calendar list managment -------------------------------------------- */

 static struct Calendar_Entry *calendar_search(const UWORD Day, const UWORD Month, const LONG Year)
  {
   struct Calendar_List *p = root;

   while (p != NULL)
    {
     if ((Year == p->Entry.Year) && (Month == p->Entry.Month) && (Day == p->Entry.Day))
      {
       return(&(p->Entry));
      }
     p = p->Next;
    }
   return(NULL);
  }


 static struct Calendar_Entry *calendar_insert(const UWORD Day, const UWORD Month, const LONG Year, const STRPTR ShortHelp)
  {
   if ((ShortHelp != NULL) && (ShortHelp[0] != '\0'))
    {
     struct Calendar_List *l;

     l = (struct Calendar_List *)LibAllocPooled(mempool,sizeof(struct Calendar_List));
     if (l != NULL)
      {
       l->Prev            = NULL;
       l->Next            = NULL;
       l->Entry.Day       = Day;
       l->Entry.Month     = Month;
       l->Entry.Year      = Year;
       l->Entry.ShortHelp = (STRPTR)LibAllocPooled(mempool,(ULONG)strlen(ShortHelp)+1);
       if (l->Entry.ShortHelp != NULL)
        {
         strcpy(l->Entry.ShortHelp,ShortHelp);
         if (root == NULL)
          {
           root = l;
          }
         else
          {
           l->Next = root;
           root->Prev = l;
           root = l;
          }
         return(&(l->Entry));
        }
       else
        {
         LibFreePooled(mempool,l,sizeof(struct Calendar_List));
        }
      }
    }
   return(NULL);
  }

 /* --- String class ------------------------------------------------------- */

 static ULONG Str_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   /* subclass string gadget for MN drag&drop support */
   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_String_Format,	MUIV_String_Format_Left,
                              MUIA_String_MaxLen,	30,
                              MUIA_Frame,		MUIV_Frame_String,
                              MUIA_Background,		MUII_TextBack,
                              TAG_MORE, 		msg->ops_AttrList
                             );
   return((ULONG)obj);
  }


 static ULONG Str_DragQuery(struct IClass *cl, Object *obj, struct MUIP_DragQuery *msg)
  {
   /*struct Str_Data *data = (struct Str_Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/
   ULONG Year,Month,Day;

   /* Test if the dropped object was an MN object */
   if (get(msg->obj,MUIA_Date_Year,&Year) && get(msg->obj,MUIA_Date_Month,&Month) && get(msg->obj,MUIA_Date_Day,&Day))
    {
     if (Day > 0)
      {
       return(MUIV_DragQuery_Accept);
      }
    }
   return(MUIV_DragQuery_Refuse);
  }


 static ULONG Str_DragDrop(struct IClass *cl, Object *obj, struct MUIP_DragDrop *msg)
  {
   /*struct Str_Data *data = (struct Str_Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/
   char str[13];
   ULONG Day,Month,Year;

   /* get date from MN object that was dropped onto the string gadget */
   /*result =*/ get(msg->obj,MUIA_Date_Year,&Year);
   /*result =*/ get(msg->obj,MUIA_Date_Month,&Month);
   /*result =*/ get(msg->obj,MUIA_Date_Day,&Day);
   /* Format as ISO8601 string and set */
   date_FormatDate("%Y-%Dmv-%Ddv",(unsigned short)Day,(unsigned short)Month,(long)Year,date_Locale,str);
   /*result =*/ set(obj,MUIA_String_Contents,(ULONG)str);
   return(0);
  }


 static ULONG SAVEDS_ASM Str_Dispatcher(REG(A0) struct IClass *cl, REG(A2) Object *obj, REG(A1) Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW			: return(Str_New(cl,obj,(struct opSet *)msg));
     case MUIM_DragQuery		: return(Str_DragQuery(cl,obj,(struct MUIP_DragQuery *)msg));
     case MUIM_DragDrop			: return(Str_DragDrop(cl,obj,(struct MUIP_DragDrop *)msg));
     default				: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* --- MonthNavigator class ----------------------------------------------- */

 static ULONG MN_Mark(struct IClass *cl, Object *obj, struct MUIP_MonthNavigator_Mark *msg)
  {
   struct MN_Data *data = (struct MN_Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   struct Calendar_Entry *e;

   /* Hook to mark Kai Hofmann's birthdays and display a bubble help */
   if (e = calendar_search((UWORD)msg->Day,(UWORD)msg->Month,msg->Year))
    {
     /*result =*/ SetAttrs(msg->dayobj,
     			     MUIA_Text_PreParse,	"\033c\0338\033n",
     			     MUIA_ShortHelp,		e->ShortHelp,
     			   TAG_DONE
			  );
    }
   else if ((msg->Year >= 1970) && (msg->Month == 9) && (msg->Day == 18))
    {
     /*result =*/ SetAttrs(msg->dayobj,
     			     MUIA_Text_PreParse,	"\033c\0338\033n",
     			     MUIA_ShortHelp,		"Kai's birthday",
     			   TAG_DONE
			  );
    }
   else
    {
     struct DateStamp ds;
     UWORD Day,Month;
     LONG Year;

     DateStamp(&ds);
     date_HeisDiffDate(1,1,1978,ds.ds_Days,&Day,&Month,&Year);
     if ((Year == msg->Year) && (Month == msg->Month) && (Day == msg->Day))
      {
       /*result =*/ SetAttrs(msg->dayobj,
     			       MUIA_Text_PreParse,	data->TodayPreParse,
     			       /*MUIA_Background,	data->TodayBackground,*/
     			       MUIA_ShortHelp,		data->TodayShortHelp,
     			     TAG_DONE
			    );
      }
    }
   return(0);
  }


 static ULONG MN_DragQuery(struct IClass *cl, Object *obj, struct MUIP_MonthNavigator_DragQuery *msg)
  {
   struct MN_Data *data = (struct MN_Data *)INST_DATA(cl,obj);

   if (data->InputMode != MUIV_MonthNavigator_InputMode_None)
    {
     if (calendar_search((UWORD)msg->Day,(UWORD)msg->Month,msg->Year) == NULL)
      {
       /*ULONG result;*/
       ULONG Year,Month,Day;
       STRPTR str;

       /* Test if the dragged object is of a specified type */
       if (get(msg->obj,MUIA_Date_Year,&Year) && get(msg->obj,MUIA_Date_Month,&Month) && get(msg->obj,MUIA_Date_Day,&Day))
        {
         if (date_ValidHeisDate((unsigned short)Day,(unsigned short)Month,(long)Year))
          {
           return(MUIV_DragQuery_Accept);
          }
        }
       else if (get(obj,MUIA_Text_Contents,&str) || get(obj,MUIA_String_Contents,&str))
        {
         long year,ayear;
         unsigned short day,month,aday,amonth;
         date_Languages plang;
         struct DateStamp ds;

         DateStamp(&ds);
         date_HeisDiffDate(1,1,1978,ds.ds_Days,&aday,&amonth,&ayear);
         if (date_ParseDate(NULL,str,date_Locale,date_Heis,date_HeisToJD(aday,amonth,ayear),&day,&month,&year,NULL,&plang) == 0)
          {
           return(MUIV_DragQuery_Accept);
          }
        }
      }
    }
   return(MUIV_DragQuery_Refuse);
  }


 static ULONG MN_DragDrop(struct IClass *cl, Object *obj, struct MUIP_MonthNavigator_DragDrop *msg)
  {
   /*ULONG result;*/
   ULONG Day,Month,Year;

   /* Drag&Drop method that allows to drop a date object onto a day button
      (will be highlighted and shown via bubble help)
   */
   if (!(get(msg->obj,MUIA_Date_Year,&Year) && get(msg->obj,MUIA_Date_Month,&Month) && get(msg->obj,MUIA_Date_Day,&Day)))
    {
     STRPTR str;

     if (get(msg->obj,MUIA_Text_Contents,&str) || get(msg->obj,MUIA_String_Contents,&str))
      {
       long year,ayear;
       unsigned short day,month,aday,amonth;
       date_Languages plang;
       struct DateStamp ds;

       DateStamp(&ds);
       date_HeisDiffDate(1,1,1978,ds.ds_Days,&aday,&amonth,&ayear);
       if (date_ParseDate(NULL,str,date_Locale,date_Heis,date_HeisToJD(aday,amonth,ayear),&day,&month,&year,NULL,&plang) != 0)
        {
         return(FALSE);
        }
       Year = (ULONG)year;
       Month = (ULONG)month;
       Day = (ULONG)day;
      }
     else
      {
       return(FALSE);
      }
    }
   if (date_ValidHeisDate((unsigned short)Day,(unsigned short)Month,(long)Year))
    {
     struct Calendar_Entry *e;
     static char date[13];

     date_FormatDate("%Y-%Dmf-%Ddf",(unsigned short)Day,(unsigned short)Month,(long)Year,date_Locale,date);
     e = calendar_insert((UWORD)msg->Day,(UWORD)msg->Month,msg->Year,date);
     if (e != NULL)
      {
       /*result =*/ SetAttrs(msg->dayobj,
     			       MUIA_Text_PreParse,	"\033c\0338\033n",
     			       MUIA_ShortHelp,		e->ShortHelp,
     			     TAG_DONE
			    );
       return(TRUE);
      }
    }
   return(FALSE);
  }


 static ULONG MN_Setup(struct IClass *const cl, Object *const obj, const struct MUIP_Setup *const msg)
  {
   struct MN_Data *data = (struct MN_Data *)INST_DATA(cl,obj);
   /*ULONG result;*/
   ULONG help;
   char preparse[31];

   /*
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayBackground,&help))
    {
     data->TodayBackground = (LONG)(*(ULONG *)help);
    }
   else
    {
     data->TodayBackground = -1;
    }
   */
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayShortHelp,&help))
    {
     data->TodayShortHelp = (STRPTR)help;
    }
   else
    {
     data->TodayShortHelp = NULL;
    }

   /* create PreParse string */
   strcpy(preparse,"\033n");
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayAlignment,&help))
    {
     switch ((BOOL)(*(ULONG *)help))
      {
       case 0 : strcat(preparse,"\033l");
                break;
       case 1 : strcat(preparse,"\033c");
                break;
       case 2 : strcat(preparse,"\033r");
                break;
      }
    }
   else
    {
     strcat(preparse,"\033c");
    }
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayPen,&help))
    {
     if (((*(ULONG *)help) >= 2) && ((*(ULONG *)help) <= 9))
      {
       char str[2];

       str[0] = (char)('0'+(*(ULONG *)help));
       str[1] = '\0';
       strcat(preparse,"\033");
       strcat(preparse,str);
      }
    }
   else
    {
     strcat(preparse,"\0338");
    }
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayUnderline,&help))
    {
     if ((BOOL)(*(ULONG *)help))
      {
       strcat(preparse,"\033u");
      }
    }
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayBold,&help))
    {
     if ((BOOL)(*(ULONG *)help))
      {
       strcat(preparse,"\033b");
      }
    }
   if (DoMethod(obj,MUIM_GetConfigItem,MUICFG_MonthNavigator_TodayItalic,&help))
    {
     if ((BOOL)(*(ULONG *)help))
      {
       strcat(preparse,"\033i");
      }
    }
   data->TodayPreParse = AllocMem((ULONG)strlen(preparse)+1,MEMF_PUBLIC);
   if (data->TodayPreParse != NULL)
    {
     strcpy(data->TodayPreParse,preparse);
    }

   return(DoSuperMethodA(cl,obj,(Msg)msg));
  }


 static ULONG MN_Cleanup(struct IClass *const cl, Object *const obj, const Msg msg)
  {
   struct MN_Data *data = (struct MN_Data *)INST_DATA(cl,obj);
   /*ULONG result;*/

   if (data->TodayPreParse != NULL)
    {
     FreeMem(data->TodayPreParse,(unsigned long)strlen(data->TodayPreParse)+1);
    }
   return(DoSuperMethodA(cl,obj,msg));
  }


 static ULONG MN_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   obj = (Object *)DoSuperNew(cl,obj,
                              TAG_MORE, 		msg->ops_AttrList
                             );
   if (obj != NULL)
    {
     struct MN_Data *data = (struct MN_Data *)INST_DATA(cl,obj);
     struct TagItem *tags,*tag;

     tags = msg->ops_AttrList;
     while (tag = NextTagItem(&tags))
      {
       switch (tag->ti_Tag)
        {
         case MUIA_MonthNavigator_InputMode	: data->InputMode = (UWORD)tag->ti_Data;
                                    	  	  break;
        }
      }
    }
   return((ULONG)obj);
  }


 static ULONG SAVEDS_ASM MN_Dispatcher(REG(A0) struct IClass *cl, REG(A2) Object *obj, REG(A1) Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW			: return(MN_New(cl,obj,(struct opSet *)msg));
     case MUIM_Setup			: return(MN_Setup(cl,obj,(struct MUIP_Setup *)msg));
     case MUIM_Cleanup			: return(MN_Cleanup(cl,obj,msg));
     case MUIM_MonthNavigator_Mark	: return(MN_Mark(cl,obj,(struct MUIP_MonthNavigator_Mark *)msg));
     case MUIM_MonthNavigator_DragQuery	: return(MN_DragQuery(cl,obj,(struct MUIP_MonthNavigator_DragQuery *)msg));
     case MUIM_MonthNavigator_DragDrop	: return(MN_DragDrop(cl,obj,(struct MUIP_MonthNavigator_DragDrop *)msg));
     default				: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* --- DateNavigator class ------------------------------------------------ */

 static ULONG DateNavigator_Update(struct IClass *cl, Object *obj, Msg msg)
  {
   struct DateNavigator_Data *data = (struct DateNavigator_Data *)INST_DATA(cl,obj);
   ULONG year,month;

   /* Update the Monthnavigator with the new month/year values */
   get(data->month,MUIA_Cycle_Active,&month);
   month++;
   get(data->year,MUIA_Numeric_Value,&year);
   SetAttrs(data->monthnavigator,
              MUIA_Date_Month,	month,
              MUIA_Date_Year,	year,
            TAG_DONE
           );
   /* set day to 0, because the user has not selected something within the new month/year */
   if (data->day != NULL)
    {
     set(data->day,MUIA_Text_Contents,"0");
    }
   return(0);
  }


 static ULONG DateNavigator_UpdateDay(struct IClass *cl, Object *obj, Msg msg)
  {
   struct DateNavigator_Data *data = (struct DateNavigator_Data *)INST_DATA(cl,obj);
   ULONG day;
   char daystr[5];

   /* Update the text day object with MonthNavigators actual day */
   get(data->monthnavigator,MUIA_Date_Day,&day);
   date_FormatDate("%Ddv",(unsigned short)day,0,0,date_Locale,daystr);
   set(data->day,MUIA_Text_Contents,daystr);
   return(0);
  }


 static ULONG DateNavigator_MonthUpdate(struct IClass *cl, Object *obj, struct MUIP_DateNavigator_MonthUpdate *msg)
  {
   struct DateNavigator_Data *data = (struct DateNavigator_Data *)INST_DATA(cl,obj);
   /*ULONG result;*/

   /* Update the month cycle gadget with MonthNavigators actual month */
   /*result =*/ DoMethod(data->month,MUIM_NoNotifySet,MUIA_Cycle_Active,msg->Month-1);
   return(0);
  }


 static ULONG DateNavigator_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   struct TagItem *tags,*tag;
   ULONG inputmode,objectid=0;
   Object *monthnavigator,*monthobj,*yearobj,*pyearobj,*myearobj,
	  *dayobj = NULL;

   inputmode = MUIV_MonthNavigator_InputMode_None;
   /* Read new message attributes */
   tags = msg->ops_AttrList;
   while (tag = NextTagItem(&tags))
    {
     switch (tag->ti_Tag)
      {
       case MUIA_MonthNavigator_InputMode	: inputmode = (ULONG)tag->ti_Data;
                                  	  	  break;
       case MUIA_DateNavigator_ObjectID 	: objectid = (ULONG)tag->ti_Data;
                                                  break;
      }
    }
   /* Create DateNavigator object */
   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_Group_Horiz, 		FALSE,
                              MUIA_Group_SameWidth,		TRUE,
                              MUIA_Background,			MUII_GroupBack,
                              MUIA_Group_Child,			HGroup,
                                MUIA_Frame,			MUIV_Frame_Group,
                                MUIA_Background,		MUII_GroupBack,
                                MUIA_Group_SameHeight,		TRUE,
                                MUIA_Group_Child,		RectangleObject,
                                  MUIA_HorizWeight,		(inputmode == MUIV_MonthNavigator_InputMode_RelVerify) ? 100 : 50,
                                End,
                                MUIA_Group_Child,		(inputmode == MUIV_MonthNavigator_InputMode_RelVerify) ? dayobj = TextObject,
                                  MUIA_Text_PreParse,		"\33r",
                                  MUIA_Frame,			MUIV_Frame_Text,
                                  MUIA_Background,		MUII_TextBack,
                                  MUIA_FixWidthTxt,		"MM",
                                End :
                                RectangleObject,
                                  MUIA_HorizWeight,		50,
                                End,
                                MUIA_Group_Child,		monthobj = CycleObject,
                                  MUIA_Cycle_Entries,		months,
                                  MUIA_Font,			MUIV_Font_Button,
                                  MUIA_CycleChain,		1,
                                End,
                                MUIA_Group_Child,		yearobj = NumericbuttonObject,
                                  MUIA_Numeric_Format,		"%lu",
                                  MUIA_Numeric_Min,		8,
                                  MUIA_Numeric_Max,		8000,
                                  MUIA_Font,			MUIV_Font_Button,
                                  MUIA_CycleChain,		1,
                                End,
                                MUIA_Group_Child,		myearobj = ImageObject,
                                  MUIA_Frame,           	MUIV_Frame_Button,
                                  MUIA_InputMode,       	MUIV_InputMode_RelVerify,
                                  MUIA_Image_Spec,      	MUII_ArrowLeft,
                                  MUIA_Image_FreeVert,  	TRUE,
                                  MUIA_Background,      	MUII_ButtonBack,
                                  MUIA_ShowSelState,    	FALSE,
                                End,
                                MUIA_Group_Child,		pyearobj = ImageObject,
                                  MUIA_Frame,           	MUIV_Frame_Button,
                                  MUIA_InputMode,       	MUIV_InputMode_RelVerify,
                                  MUIA_Image_Spec,      	MUII_ArrowRight,
                                  MUIA_Image_FreeVert,  	TRUE,
                                  MUIA_Background,      	MUII_ButtonBack,
                                  MUIA_ShowSelState,    	FALSE,
                                End,
                                MUIA_Group_Child,		RectangleObject,
                                End,
                              End,
                              MUIA_Group_Child,			monthnavigator = NewObject(MN_CC->mcc_Class,NULL,
                                MUIA_Frame,			MUIV_Frame_Group,
                                MUIA_FrameTitle,		"MonthNavigator.mcc",
                                MUIA_Background,		MUII_GroupBack,
                                MUIA_MonthNavigator_InputMode,	inputmode,
                                MUIA_MonthNavigator_Draggable,	TRUE,
                                MUIA_ObjectID,			objectid,
                                MUIA_Dropable,				inputmode == MUIV_MonthNavigator_InputMode_None ? FALSE : TRUE,
                                MUIA_MonthNavigator_Dropable,		inputmode == MUIV_MonthNavigator_InputMode_None ? FALSE : TRUE,
                                MUIA_CycleChain,		1,
                                /*MUIA_Font,			MUIV_Font_Tiny,*/
                                /*MUIA_MonthNavigator_ShowLastMonthDays,	0, */
                                /*MUIA_MonthNavigator_ShowNextMonthDays,	0, */
                              End,
                              MUIA_Group_Child,			RectangleObject,
                              End,
                              TAG_MORE, 			msg->ops_AttrList
                             );
   if (obj != NULL)
    {
     struct DateNavigator_Data *data = (struct DateNavigator_Data *)INST_DATA(cl,obj);
     ULONG month,year,day;
     char daystr[5];
     /*ULONG result;*/

     /* Save pointers to sub-objects for later usage */
     data->monthnavigator = monthnavigator;
     data->month = monthobj;
     data->year = yearobj;
     data->day = dayobj;

     /* Init month/year/day with MonthNavigator values */
     /*result =*/ DoMethod(monthnavigator,MUIM_Date_SetCurrent);
     get(monthnavigator,MUIA_Date_Month,&month);
     set(monthobj,MUIA_Cycle_Active,month-1);
     get(monthnavigator,MUIA_Date_Year,&year);
     set(yearobj,MUIA_Numeric_Default,year);
     set(yearobj,MUIA_Numeric_Value,year);
     if (dayobj != NULL)
      {
       get(monthnavigator,MUIA_Date_Day,&day);
       date_FormatDate("%Ddv",(unsigned short)day,0,0,date_Locale,daystr);
       set(dayobj,MUIA_Text_Contents,daystr);
       /*result =*/ DoMethod(monthnavigator,MUIM_Notify,MUIA_Date_Day,MUIV_EveryTime,obj,1,MUIM_DateNavigator_UpdateDay);
      }
     /* Set notifies for interaction */
     /*result =*/ DoMethod(monthobj,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,obj,1,MUIM_DateNavigator_Update);
     /*result =*/ DoMethod(yearobj,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,obj,1,MUIM_DateNavigator_Update);
     /*result =*/ DoMethod(myearobj,MUIM_Notify,MUIA_Pressed,FALSE,yearobj,2,MUIM_Numeric_Decrease,1);
     /*result =*/ DoMethod(pyearobj,MUIM_Notify,MUIA_Pressed,FALSE,yearobj,2,MUIM_Numeric_Increase,1);
     /*result =*/ DoMethod(monthnavigator,MUIM_Notify,MUIA_Date_Year,MUIV_EveryTime,yearobj,3,MUIM_NoNotifySet,MUIA_Numeric_Value,MUIV_TriggerValue);
     /*result =*/ DoMethod(monthnavigator,MUIM_Notify,MUIA_Date_Month,MUIV_EveryTime,obj,2,MUIM_DateNavigator_MonthUpdate,MUIV_TriggerValue);
    }
   return((ULONG)obj);
  }


 static ULONG SAVEDS_ASM DateNavigator_Dispatcher(REG(A0) struct IClass *cl, REG(A2) Object *obj, REG(A1) Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW				: return(DateNavigator_New(cl,obj,(struct opSet *)msg));
     case MUIM_DateNavigator_Update		: return(DateNavigator_Update(cl,obj,msg));
     case MUIM_DateNavigator_UpdateDay		: return(DateNavigator_UpdateDay(cl,obj,msg));
     case MUIM_DateNavigator_MonthUpdate	: return(DateNavigator_MonthUpdate(cl,obj,(struct MUIP_DateNavigator_MonthUpdate *)msg));
     default					: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* --- Window class ------------------------------------------------------- */

 static ULONG Win_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   struct TagItem *tags,*tag;
   ULONG type = MUIV_MonthNavigator_InputMode_None,objectid=0;
   Object *saveobj,*loadobj;

   /* Read new message attributes */
   tags = msg->ops_AttrList;
   while (tag = NextTagItem(&tags))
    {
     switch (tag->ti_Tag)
      {
       case MUIA_Win_InputMode	: type = (ULONG)tag->ti_Data;
                                  break;
       case MUIA_Win_DNObjectID : objectid = (ULONG)tag->ti_Data;
                                  break;
      }
    }
   /* create window object */
   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_Window_ID,			MAKE_ID('D','E','M','0'+type),
                              MUIA_Window_Title,		(type == MUIV_MonthNavigator_InputMode_None) ? "ReadOnly" : ((type == MUIV_MonthNavigator_InputMode_RelVerify) ? "RelVerify" : "Immediate"),
                              MUIA_Window_ScreenTitle,		"MonthNavigator-Demo V" VERSIONSTR,
                              MUIA_Window_RootObject,		VGroup,
                                MUIA_Group_SameWidth,		TRUE,
                                MUIA_Background,		MUII_GroupBack,
                                MUIA_Group_Child,		NewObject(DateNavigator_CC->mcc_Class,NULL,
									    MUIA_MonthNavigator_InputMode,	type,
									    MUIA_DateNavigator_ObjectID,	objectid,
									  TAG_DONE
								         ),
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Background,		MUII_GroupBack,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Group_Child,		Label2("Drop here:"),
                                  MUIA_Group_Child,		NewObject(Str_CC->mcc_Class,NULL,
				    MUIA_Dropable,		TRUE,
				    MUIA_Draggable,		TRUE,
				  TAG_DONE),
                                End,
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Background,		MUII_GroupBack,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Group_Child,		loadobj = TextObject,
                                    MUIA_Frame,			MUIV_Frame_Button,
                                    MUIA_Background,		MUII_ButtonBack,
                                    MUIA_Font,			MUIV_Font_Button,
                                    MUIA_Text_PreParse,		"\33c",
                                    MUIA_InputMode,		MUIV_InputMode_RelVerify,
                                    MUIA_Text_Contents,		"Load",
                                    MUIA_Text_HiChar,		'L',
                                    MUIA_ControlChar,		'l',
                                    MUIA_CycleChain,		1,
                                  End,
                                  MUIA_Group_Child,		saveobj = TextObject,
                                    MUIA_Frame,			MUIV_Frame_Button,
                                    MUIA_Background,		MUII_ButtonBack,
                                    MUIA_Font,			MUIV_Font_Button,
                                    MUIA_Text_PreParse,		"\33c",
                                    MUIA_InputMode,		MUIV_InputMode_RelVerify,
                                    MUIA_Text_Contents,		"Save",
                                    MUIA_Text_HiChar,		'S',
                                    MUIA_ControlChar,		's',
                                    MUIA_CycleChain,		1,
                                  End,
                                End,
                              End,
                              TAG_MORE, msg->ops_AttrList
                             );
   if (obj != NULL)
    {
     /*ULONG result;*/

     /* Set notify for application load/save buttons */
     /*result =*/ DoMethod(loadobj,MUIM_Notify,MUIA_Pressed,FALSE,MUIV_Notify_Application,2,MUIM_Application_Load,MUIV_Application_Load_ENV);
     /*result =*/ DoMethod(saveobj,MUIM_Notify,MUIA_Pressed,FALSE,MUIV_Notify_Application,2,MUIM_Application_Save,MUIV_Application_Save_ENV);
    }
   return((ULONG)obj);
  }


 static ULONG SAVEDS_ASM Win_Dispatcher(REG(A0) struct IClass *cl, REG(A2) Object *obj, REG(A1) Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW			: return(Win_New(cl,obj,(struct opSet *)msg));
     default				: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* --- Application class -------------------------------------------------- */

 static ULONG App_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   Object *win1,*win2,*win3;

   /* Create application object with three different windows and open windows */
   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_Application_Title,           "MonthNavigator-Demo",
                              MUIA_Application_Author,          "Dipl.-Inform. Kai Hofmann",
                              MUIA_Application_Copyright,       "© " COPYRIGHT " Dipl.-Inform. Kai Hofmann",
                              MUIA_Application_Version,         "$VER: MonthNavigator-Demo " VERSIONSTR " " __AMIGADATE__,
                              MUIA_Application_Description,     "MonthNavigator demonstration program",
                              MUIA_Application_Base,            "MNDEMO",
                              MUIA_Application_SingleTask,      TRUE,
                              MUIA_Application_Active,          TRUE,
                              MUIA_Application_Window,		win1 = NewObject(Win_CC->mcc_Class,NULL,
										   MUIA_Win_InputMode,	MUIV_MonthNavigator_InputMode_None,
										   MUIA_Win_DNObjectID,	1,
										 TAG_DONE
										),
                              MUIA_Application_Window,		win2 = NewObject(Win_CC->mcc_Class,NULL,
										   MUIA_Win_InputMode,	MUIV_MonthNavigator_InputMode_RelVerify,
										   MUIA_Win_DNObjectID,	2,
										 TAG_DONE
										),
                              MUIA_Application_Window,		win3 = NewObject(Win_CC->mcc_Class,NULL,
										   MUIA_Win_InputMode,	MUIV_MonthNavigator_InputMode_Immediate,
										   MUIA_Win_DNObjectID,	3,
										 TAG_DONE
										),
                              TAG_MORE, msg->ops_AttrList
                             );
   if (obj != NULL)
    {
     /*struct App_Data *data = (struct App_Data *)INST_DATA(cl,obj);*/
     /*ULONG result;*/

     /*result =*/ DoMethod(win1,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
     set(win1,MUIA_Window_Open,TRUE);
     /*result =*/ DoMethod(win2,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
     set(win2,MUIA_Window_Open,TRUE);
     /*result =*/ DoMethod(win3,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
     set(win3,MUIA_Window_Open,TRUE);
    }
   return((ULONG)obj);
  }


 static ULONG SAVEDS_ASM App_Dispatcher(REG(A0) struct IClass *cl, REG(A2) Object *obj, REG(A1) Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW			: return(App_New(cl,obj,(struct opSet *)msg));
     default				: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* --- Simple error requester --------------------------------------------- */

 static void OpenReq(char *const str)
  {
   struct EasyStruct req =
    {
     sizeof(struct EasyStruct),
     0,
     "MonthNavigator-Demo",
     NULL,
     "OK",
    };

   req.es_TextFormat = str;
   EasyRequest(NULL,&req,NULL,(ULONG)MUIMASTER_VMIN);
  }

 /* --- Initialization/Cleanup of privat custom classes -------------------- */

 long muiclasses_Init(void)
  {
   long retstat = RETURN_OK;

   /* create privat custom classes: Application, Window, String, DateNavigator */
   App_CC = MUI_CreateCustomClass(NULL,MUIC_Application,NULL,0,App_Dispatcher);
   if (App_CC == NULL)
    {
     OpenReq("Can not create 'App' privat custom class!");
     retstat = RETURN_ERROR;
    }
   else
    {
     Win_CC = MUI_CreateCustomClass(NULL,MUIC_Window,NULL,0,Win_Dispatcher);
     if (Win_CC == NULL)
      {
       OpenReq("Can not create 'Win' privat custom class!");
       retstat = RETURN_ERROR;
      }
     else
      {
       Str_CC = MUI_CreateCustomClass(NULL,MUIC_String,NULL,0,Str_Dispatcher);
       if (Str_CC == NULL)
        {
         OpenReq("Can not create 'Str' privat custom class!");
         retstat = RETURN_ERROR;
        }
       else
        {
         MN_CC = MUI_CreateCustomClass(NULL,MUIC_MonthNavigator,NULL,sizeof(struct MN_Data),MN_Dispatcher);
         if (MN_CC == NULL)
          {
           OpenReq("Can not create 'MN' privat custom class!");
           retstat = RETURN_ERROR;
          }
         else
          {
           DateNavigator_CC = MUI_CreateCustomClass(NULL,MUIC_Group,NULL,sizeof(struct DateNavigator_Data),DateNavigator_Dispatcher);
           if (DateNavigator_CC == NULL)
            {
             OpenReq("Can not create 'DateNavigator' privat custom class!");
             retstat = RETURN_ERROR;
            }
          }
        }
      }
    }
   return(retstat);
  }


 long muiclasses_Cleanup(void)
  {
   long retstat = RETURN_OK;

   if (DateNavigator_CC != NULL)
    {
     if (!MUI_DeleteCustomClass(DateNavigator_CC))
      {
       OpenReq("Can not delete 'DateNavigator' privat custom class!");
       retstat = RETURN_ERROR;
      }
    }
   if (MN_CC != NULL)
    {
     if (!MUI_DeleteCustomClass(MN_CC))
      {
       OpenReq("Can not delete 'MN' privat custom class!");
       retstat = RETURN_ERROR;
      }
    }
   if (Str_CC != NULL)
    {
     if (!MUI_DeleteCustomClass(Str_CC))
      {
       OpenReq("Can not delete 'Str' privat custom class!");
       retstat = RETURN_ERROR;
      }
    }
   if (Win_CC != NULL)
    {
     if (!MUI_DeleteCustomClass(Win_CC))
      {
       OpenReq("Can not delete 'Win' privat custom class!");
       retstat = RETURN_ERROR;
      }
    }
   if (App_CC != NULL)
    {
     if (!MUI_DeleteCustomClass(App_CC))
      {
       OpenReq("Can not delete 'App' privat custom class!");
       retstat = RETURN_ERROR;
      }
    }
   return(retstat);
  }

 /* --- Initialization/Cleanup and main GUI loop --------------------------- */

 long gui_Init(void)
  {
   long retstat;

   MUIMasterBase = OpenLibrary((UBYTE *)MUIMASTER_NAME,(unsigned long)MUIMASTER_VMIN);
   if (MUIMasterBase != NULL)
    {
     retstat = muiclasses_Init();
     if (retstat == RETURN_OK)
      {
       Object *mn;

       /* test if MonthNavigator custom class is installed */
       mn = MUI_NewObject(MUIC_MonthNavigator,
                          TAG_DONE
                         );
       if (mn != NULL)
        {
         MUI_DisposeObject(mn);
         /* create private application object */
         App = NewObject(App_CC->mcc_Class,NULL,TAG_DONE);
         if (App == NULL)
          {
           /*retstat =*/ muiclasses_Cleanup();
           CloseLibrary(MUIMasterBase);
           OpenReq("Can not create application object!");
           retstat = RETURN_FAIL;
          }
        }
       else
        {
         /*retstat =*/ muiclasses_Cleanup();
         CloseLibrary(MUIMasterBase);
         OpenReq("Missing MonthNavigator.mcc!");
         retstat = RETURN_FAIL;
        }
      }
     else
      {
       /*retstat =*/ muiclasses_Cleanup();
       CloseLibrary(MUIMasterBase);
      }
    }
   else
    {
     OpenReq("Can not open muimaster.library V%lu!");
     retstat = RETURN_FAIL;
    }
   return(retstat);
  }


 long gui_Cleanup(void)
  {
   long retstat = RETURN_OK;

   if (MUIMasterBase != NULL)
    {
     if (App != NULL)
      {
       MUI_DisposeObject(App);
      }
     retstat = muiclasses_Cleanup();
     if (retstat == RETURN_OK)
      {
       CloseLibrary(MUIMasterBase);
      }
     else
      {
       OpenReq("Can not close muimaster.library!");
       retstat = RETURN_FAIL;
      }
    }
   return(retstat);
  }


 void gui_MainLoop(void)
  {
   if (App != NULL) /* Optimized MUI main loop runs until application quit recived */
    {
     ULONG signals=0;

     while (DoMethod(App,(unsigned long)MUIM_Application_NewInput,&signals) != MUIV_Application_ReturnID_Quit)
      {
       if (signals)
        {
         signals = Wait(signals | SIGBREAKF_CTRL_C); /* CTRL-C test */
         if (signals & SIGBREAKF_CTRL_C)
          {
           /*ULONG result;*/

           /* send application quit method for shutdown */
           /*result =*/ DoMethod(App,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
          }
        }
      }
    }
  }

 /* ------------------------------------------------------------------------ */

 void main(void)
  {
   BOOL error = FALSE;

   DateBase = OpenLibrary(DATE_NAME,33); /* Open date.library minimum 33.315 */
   if (DateBase != NULL)
    {
     if (((DateBase->lib_Version > 33)) || ((DateBase->lib_Version == 33) && (DateBase->lib_Revision >= 315)))
      {
       short i;
       char mn[15];

       mempool = LibCreatePool(MEMF_PUBLIC,24*(12+10*2),24);
       if (mempool != NULL)
        {
         for (i=0;i<12;i++) /* Get the month names from date.library for the local language */
          {
           date_MonthText(i+1,mn,date_Locale);
           months[i] = (char *)LibAllocPooled(mempool,(ULONG)strlen(mn)+1);
           if (months[i] != NULL)
            {
             strcpy(months[i],mn);
            }
           else /* error -> cleanup */
            {
             OpenReq("Out of memory error!");
             error = TRUE;
             break;
            }
          }
         if (!error)
          {
           months[12] = NULL;
           if (gui_Init() == RETURN_OK) /* Init GUI */
            {
             gui_MainLoop(); /* GUI main loop */
             /*retstat =*/ gui_Cleanup(); /* Cleanup GUI */
            }
          }
         LibDeletePool(mempool);
        }
      }
     else
      {
       OpenReq("Can not open date.library V33.290");
      }
     CloseLibrary(DateBase);
    }
   else
    {
     OpenReq("Can not open date.library V33");
    }
  }
