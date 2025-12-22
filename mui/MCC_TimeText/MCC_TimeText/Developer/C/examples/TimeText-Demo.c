/*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: TimeText-Demo.c 12.0 (26.12.97)
**
*/

 #define __MakeLib

 #include "system.h"
 #include <mui/Time_mcc.h>
 #include <mui/TimeText_mcc.h>
 #include <mui/Lamp_mcc.h>
 #include <proto/date.h>
 #include <libraries/mui.h>
 #include <proto/muimaster.h>
 #include <exec/libraries.h>
 #include <proto/exec.h>
 #include <proto/intuition.h>
 #include <devices/timer.h>
 #include <clib/alib_protos.h>


 #ifdef DEBUG
   void kprintf(UBYTE *fmt,...);
   #define debug(x)	kprintf(x "\n");
 #else
   #define debug(x)
 #endif


 #ifndef MAKE_ID
   #define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
 #endif


 #define MUIM_TT_SecTrigger	0x81ee8000


 struct MUI_CustomClass *App_CC=NULL,*Win_CC=NULL,*Str_CC=NULL,*TT_CC=NULL;


 struct Library *MUIMasterBase;
 struct Library *DateBase;
 static Object *App;

 struct TT_Data
  {
   struct MUI_InputHandlerNode ihnode;
  };

 /* ------------------------------------------------------------------------ */

 static ULONG STACKARGS DoSuperNew(struct IClass *cl, Object *obj, ULONG tags, ...)
  {
   return(DoSuperMethod(cl,obj,OM_NEW,&tags,NULL));
  }

 /* --- TT ----------------------------------------------------------------- */

 static ULONG TT_SecTrigger(struct IClass *cl, Object *obj, Msg msg)
  {
   /*struct TT_Data *data = (struct TT_Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/

   /*result =*/ DoMethod(obj,MUIM_Time_Increase,1UL);
   return(FALSE);
  }


 static ULONG TT_Setup(struct IClass *cl, Object *obj, struct MUIP_Setup *msg)
  {
   struct TT_Data *data = (struct TT_Data *)INST_DATA(cl,obj);
   /*ULONG result;*/

   if (!DoSuperMethodA(cl,obj,(Msg)msg))
    {
     return(FALSE);
    }
   /*result =*/ DoMethod(_app(obj),MUIM_Application_AddInputHandler,&data->ihnode);
   return(TRUE);
  }


 static ULONG TT_Cleanup(struct IClass *cl, Object *obj, Msg msg)
  {
   struct TT_Data *data = (struct TT_Data *)INST_DATA(cl,obj);
   /*ULONG result;*/

   /*result =*/ DoMethod(_app(obj),MUIM_Application_RemInputHandler,&data->ihnode);
   return(DoSuperMethodA(cl,obj,msg));
  }


 static ULONG TT_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   obj = (Object *)DoSuperNew(cl,obj,
                              TAG_MORE, msg->ops_AttrList
                             );
   if (obj != NULL)
    {
     struct TT_Data *data = (struct TT_Data *)INST_DATA(cl,obj);
     /*ULONG result;*/

     data->ihnode.ihn_Object  = obj;
     data->ihnode.ihn_Method  = MUIM_TT_SecTrigger;
     data->ihnode.ihn_Flags   = MUIIHNF_TIMER;
     data->ihnode.ihn_Millis  = 1000;
    }
   return((ULONG)obj);
  }


 static ULONG SAVEDS_ASM TT_Dispatcher(REG(A0) struct IClass *cl, REG(A2) Object *obj, REG(A1) Msg msg)
  {
   switch (msg->MethodID)
    {
     case OM_NEW			: return(TT_New(cl,obj,(struct opSet *)msg));
     case MUIM_Setup			: return(TT_Setup(cl,obj,(struct MUIP_Setup *)msg));
     case MUIM_Cleanup			: return(TT_Cleanup(cl,obj,(struct MUIP_Cleanup *)msg));
     case MUIM_TT_SecTrigger		: return(TT_SecTrigger(cl,obj,msg));
     default				: return(DoSuperMethodA(cl,obj,msg));
    }
  }

 /* --- String ------------------------------------------------------------- */

 static ULONG Str_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_String_Format,	MUIV_String_Format_Left,
                              MUIA_String_MaxLen,	30,
                              MUIA_Frame,		MUIV_Frame_String,
                              MUIA_Background,		MUII_TextBack,
                              TAG_MORE, msg->ops_AttrList
                             );
   return((ULONG)obj);
  }


 static ULONG Str_DragQuery(struct IClass *cl, Object *obj, struct MUIP_DragQuery *msg)
  {
   /*struct Str_Data *data = (struct Str_Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/
   ULONG Hour,Min,Sec;

   if (get(msg->obj,MUIA_Time_Hour,&Hour) && get(msg->obj,MUIA_Time_Minute,&Min) && get(msg->obj,MUIA_Time_Second,&Sec))
    {
     return(MUIV_DragQuery_Accept);
    }
   return(MUIV_DragQuery_Refuse);
  }


 static ULONG Str_DragDrop(struct IClass *cl, Object *obj, struct MUIP_DragDrop *msg)
  {
   /*struct Str_Data *data = (struct Str_Data *)INST_DATA(cl,obj);*/
   /*ULONG result;*/
   char str[9];
   ULONG Hour,Min,Sec;

   /*result =*/ get(msg->obj,MUIA_Time_Hour,&Hour);
   /*result =*/ get(msg->obj,MUIA_Time_Minute,&Min);
   /*result =*/ get(msg->obj,MUIA_Time_Second,&Sec);
   time_FormatTime("%H:%M:%S",time_Normal,2,FALSE,(unsigned short)Hour,(unsigned short)Min,(unsigned short)Sec,0,str);
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

 /* --- Window ------------------------------------------------------------- */

 static ULONG Win_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   Object *TimeText,*Hour,*Min,*Sec,*saveobj,*loadobj,*format,*MidnightSecs;

   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_Window_ID,			MAKE_ID('D','E','M','O'),
                              MUIA_Window_Title,		"TimeText-Demo",
                              MUIA_Window_ScreenTitle,		"TimeText-Demo V1.0",
                              MUIA_Window_RootObject,		VGroup,
                                MUIA_Group_SameWidth,		TRUE,
                                MUIA_Group_Child,		TimeText = NewObject(TT_CC->mcc_Class,NULL,
                                  MUIA_Frame,			MUIV_Frame_Text,
                                  MUIA_FrameTitle,		"TimeText.mcc",
                                  MUIA_Background,		MUII_TextBack,
                                  MUIA_Draggable,		TRUE,
                                  /*MUIA_Time_Hour,		17,*/
                                  /*MUIA_Time_Minute,		0,*/
                                  /*MUIA_Time_Second,		0,*/
                                  /*MUIA_Time_ZoneMinute,	60,*/
                                  /*MUIA_Time_DaylightSaving,	FALSE,*/
                                  /*MUIA_Time_ChangeDay,	MUIV_Time_ChangeDay_SummerToWinter,*/
                                  /*MUIA_TimeText_TimeFormat,	"%H:%M:%S",*/
                                  MUIA_ObjectID,		1,
                                End,
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Group_Child,		RectangleObject,
                                  End,
                                  MUIA_Group_Child,		Hour = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		0,
                                    MUIA_Numeric_Max,		23,
                                    MUIA_Numeric_Default,	0,
                                    /*MUIA_Numeric_Value,	21,*/
                                    MUIA_CycleChain,		1,
                                    MUIA_Font,			MUIV_Font_Button,
                                  End,
                                  MUIA_Group_Child,		Min = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		0,
                                    MUIA_Numeric_Max,		59,
                                    MUIA_Numeric_Default,	0,
                                    /*MUIA_Numeric_Value,	0,*/
                                    MUIA_CycleChain,		1,
                                    MUIA_Font,			MUIV_Font_Button,
                                  End,
                                  MUIA_Group_Child,		Sec = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		0,
                                    MUIA_Numeric_Max,		59,
                                    MUIA_Numeric_Default,	0,
                                    /*MUIA_Numeric_Value,	0,*/
                                    MUIA_CycleChain,		1,
                                    MUIA_Font,			MUIV_Font_Button,
                                  End,
                                  MUIA_Group_Child,		RectangleObject,
                                  End,
                                End,
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Background,		MUII_GroupBack,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Group_Child,		RectangleObject,
                                  End,
                                  MUIA_Group_Child,		MidnightSecs = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		0,
                                    MUIA_Numeric_Max,		86399,
                                    MUIA_Numeric_Default,	0,
                                    /*MUIA_Numeric_Value,	75600,*/
                                    MUIA_CycleChain,		1,
                                    MUIA_Font,			MUIV_Font_Button,
                                  End,
                                  MUIA_Group_Child,		RectangleObject,
                                  End,
                                End,
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Background,		MUII_GroupBack,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Group_Child,		Label2("Format:"),
                                  MUIA_Group_Child,		format = StringObject,
                                    MUIA_Frame,			MUIV_Frame_String,
                                    MUIA_Background,		MUII_TextBack,
                                    MUIA_String_Accept,		"%:., qHQIpMSRTXrhms0123fvloujzc",
                                    MUIA_String_Format,		MUIV_String_Format_Left,
                                    MUIA_String_MaxLen,		25,
                                    MUIA_CycleChain,		1,
                                  End,
                                End,
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Background,		MUII_GroupBack,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Group_Child,		Label2("Drop here:"),
                                  MUIA_Group_Child,		NewObject(Str_CC->mcc_Class,NULL,MUIA_Dropable,TRUE,TAG_DONE),
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
     /*struct Win_Data *data = (struct Win_Data *)INST_DATA(cl,obj);*/
     /*ULONG result;*/
     ULONG hour,min,sec,secs;
     STRPTR timeformat;

     /*result =*/ get(TimeText,MUIA_Time_Hour,&hour);
     /*result =*/ get(TimeText,MUIA_Time_Minute,&min);
     /*result =*/ get(TimeText,MUIA_Time_Second,&sec);
     /*result =*/ get(TimeText,MUIA_Time_MidnightSecs,&secs);
     /*result =*/ set(Hour,MUIA_Numeric_Value,hour);
     /*result =*/ set(Min,MUIA_Numeric_Value,min);
     /*result =*/ set(Sec,MUIA_Numeric_Value,sec);
     /*result =*/ set(MidnightSecs,MUIA_Numeric_Value,secs);

     /*result =*/ get(TimeText,MUIA_TimeText_TimeFormat,&timeformat);
     /*result =*/ set(format,MUIA_String_Contents,timeformat);

     /*result =*/ DoMethod(TimeText,MUIM_Notify,MUIA_Time_Hour,MUIV_EveryTime,Hour,3,MUIM_NoNotifySet,MUIA_Numeric_Value,MUIV_TriggerValue);
     /*result =*/ DoMethod(TimeText,MUIM_Notify,MUIA_Time_Minute,MUIV_EveryTime,Min,3,MUIM_NoNotifySet,MUIA_Numeric_Value,MUIV_TriggerValue);
     /*result =*/ DoMethod(TimeText,MUIM_Notify,MUIA_Time_Second,MUIV_EveryTime,Sec,3,MUIM_NoNotifySet,MUIA_Numeric_Value,MUIV_TriggerValue);
     /*result =*/ DoMethod(TimeText,MUIM_Notify,MUIA_Time_MidnightSecs,MUIV_EveryTime,MidnightSecs,3,MUIM_NoNotifySet,MUIA_Numeric_Value,MUIV_TriggerValue);

     /*result =*/ DoMethod(Hour,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,TimeText,3,MUIM_Set,MUIA_Time_Hour,MUIV_TriggerValue);
     /*result =*/ DoMethod(Min,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,TimeText,3,MUIM_Set,MUIA_Time_Minute,MUIV_TriggerValue);
     /*result =*/ DoMethod(Sec,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,TimeText,3,MUIM_Set,MUIA_Time_Second,MUIV_TriggerValue);
     /*result =*/ DoMethod(MidnightSecs,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,TimeText,3,MUIM_Set,MUIA_Time_MidnightSecs,MUIV_TriggerValue);

     /*result =*/ DoMethod(format,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,TimeText,3,MUIM_Set,MUIA_TimeText_TimeFormat,MUIV_TriggerValue);

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

 /* --- Application -------------------------------------------------------- */

 static ULONG App_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   Object *win1;

   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_Application_Title,           "TimeText-Demo",
                              MUIA_Application_Author,          "Kai Hofmann",
                              MUIA_Application_Copyright,       "© 1997 Kai Hofmann",
                              MUIA_Application_Version,         "$VER: TimeText-Demo 1.0 " __AMIGADATE__,
                              MUIA_Application_Description,     "TimeText demonstration program",
                              MUIA_Application_Base,            "TSDEMO",
                              MUIA_Application_SingleTask,      TRUE,
                              MUIA_Application_Active,          TRUE,
                              MUIA_Application_Window,		win1 = NewObject(Win_CC->mcc_Class,NULL,TAG_DONE),
                              TAG_MORE, 			msg->ops_AttrList
                             );
   if (obj != NULL)
    {
     /*struct App_Data *data = (struct App_Data *)INST_DATA(cl,obj);*/
     /*ULONG result;*/

     /*result =*/ DoMethod(win1,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,MUIV_Notify_Application,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
     set(win1,MUIA_Window_Open,TRUE);
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

 /* ------------------------------------------------------------------------ */

 static void OpenReq(char *const str)
  {
   struct EasyStruct req =
    {
     sizeof(struct EasyStruct),
     0,
     "TimeText-Demo",
     NULL,
     "OK",
    };

   req.es_TextFormat = str;
   EasyRequest(NULL,&req,NULL,(ULONG)MUIMASTER_VMIN);
  }

 /* ------------------------------------------------------------------------ */

 static int muiclasses_Init(void)
  {
   int retstat = RETURN_OK;

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
         TT_CC = MUI_CreateCustomClass(NULL,MUIC_TimeText,NULL,sizeof(struct TT_Data),TT_Dispatcher);
         if (TT_CC == NULL)
          {
           OpenReq("Can not create 'TT' privat custom class!");
           retstat = RETURN_ERROR;
          }
        }
      }
    }

   return(retstat);
  }


 static int muiclasses_Cleanup(void)
  {
   int retstat = RETURN_OK;

   if (TT_CC != NULL)
    {
     if (!MUI_DeleteCustomClass(TT_CC))
      {
       OpenReq("Can not delete 'TT' privat custom class!");
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

 /* ------------------------------------------------------------------------ */

 static int gui_Init(void)
  {
   int retstat;

   MUIMasterBase = OpenLibrary((UBYTE *)MUIMASTER_NAME,(unsigned long)MUIMASTER_VMIN);
   if (MUIMasterBase != NULL)
    {
     retstat = muiclasses_Init();
     if (retstat == RETURN_OK)
      {
       Object *tt;

       tt = MUI_NewObject(MUIC_TimeText,
                          TAG_DONE
                         );
       if (tt != NULL)
        {
         MUI_DisposeObject(tt);
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
         OpenReq("Missing TimeText.mcc!");
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


 static int gui_Cleanup(void)
  {
   int retstat = RETURN_OK;

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


 static void gui_MainLoop(void)
  {
   if (App != NULL)
    {
     ULONG signals=0;

     while (DoMethod(App,(unsigned long)MUIM_Application_NewInput,&signals) != MUIV_Application_ReturnID_Quit)
      {
       if (signals)
        {
         signals = Wait(signals | SIGBREAKF_CTRL_C);
         if (signals & SIGBREAKF_CTRL_C)
          {
           /*ULONG result;*/

           /*result =*/ DoMethod(App,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
          }
        }
      }
    }
  }

 /* ------------------------------------------------------------------------ */

 void main(void)
  {
   DateBase = OpenLibrary(DATE_NAME,33);
   if (DateBase != NULL)
    {
     if (((DateBase->lib_Version > 33)) || ((DateBase->lib_Version == 33) && (DateBase->lib_Revision >= 290)))
      {
       if (gui_Init() == RETURN_OK)
        {
         gui_MainLoop();
         /*result =*/ gui_Cleanup();
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
