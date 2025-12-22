/*
**
** Copyright © 1997-1998 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: DateText-Demo.c 12.0 (03.01.98)
**
*/

 #define __MakeLib


 #include "system.h"
 #include <mui/Date_mcc.h>
 #include <mui/DateText_mcc.h>
 #include <libraries/mui.h>
 #include <proto/muimaster.h>
 #include <proto/date.h>
 #include <exec/libraries.h>
 #include <exec/memory.h>
 #include <proto/exec.h>
 #include <proto/intuition.h>
 #include <utility/tagitem.h>
 #include <proto/utility.h>
 #include <clib/alib_protos.h>
 #include <string.h>


 #ifdef DEBUG
   void kprintf(UBYTE *fmt,...);
   #define debug(x)	kprintf(x "\n");
 #else
   #define debug(x)
 #endif


 #ifndef MAKE_ID
   #define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
 #endif


 struct MUI_CustomClass *App_CC=NULL,*Win_CC=NULL,*Str_CC=NULL;


 struct Library *DateBase;
 struct Library *MUIMasterBase;
 static Object *App;

 static char *months[13];

 /* ------------------------------------------------------------------------ */

 static ULONG STACKARGS DoSuperNew(struct IClass *const cl, Object *const obj, ULONG tags, ...)
  {
   return(DoSuperMethod(cl,obj,OM_NEW,&tags,NULL));
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
   ULONG Year,Month,Day;

   if (get(msg->obj,MUIA_Date_Year,&Year) && get(msg->obj,MUIA_Date_Month,&Month) && get(msg->obj,MUIA_Date_Day,&Day))
    {
     if (date_ValidHeisDate((unsigned short)Day,(unsigned short)Month,(long)Year))
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

   /*result =*/ get(msg->obj,MUIA_Date_Year,&Year);
   /*result =*/ get(msg->obj,MUIA_Date_Month,&Month);
   /*result =*/ get(msg->obj,MUIA_Date_Day,&Day);
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

 /* --- Window ------------------------------------------------------------- */

 static ULONG Win_New(struct IClass *cl, Object *obj, struct opSet *msg)
  {
   Object *DateText,*Day,*Month,*Year,*saveobj,*loadobj,*format;

   obj = (Object *)DoSuperNew(cl,obj,
                              MUIA_Window_ID,			MAKE_ID('D','E','M','O'),
                              MUIA_Window_Title,		"DateText-Demo",
                              MUIA_Window_ScreenTitle,		"DateText-Demo V12.0",
                              MUIA_Window_RootObject,		VGroup,
                                MUIA_Group_SameWidth,		TRUE,
                                MUIA_Group_Child,		DateText = DateTextObject,
                  		  MUIA_Frame,			MUIV_Frame_Text,
                  		  MUIA_FrameTitle,		"DateText.mcc",
                  		  MUIA_Background,		MUII_TextBack,
                  		  MUIA_Draggable,		TRUE,
                  		  MUIA_ObjectID,		1,
                		End,
                                MUIA_Group_Child,		HGroup,
                                  MUIA_Group_SameHeight,	TRUE,
                                  MUIA_Frame,			MUIV_Frame_Group,
                                  MUIA_Group_Child,		RectangleObject,
                                  End,
                                  MUIA_Group_Child,		Day = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		1,
                                    MUIA_Numeric_Max,		31,
                                    MUIA_Numeric_Default,	1,
                                    /*MUIA_Numeric_Value,	6,*/
                                    MUIA_CycleChain,		1,
                                    MUIA_Font,			MUIV_Font_Button,
                                  End,
                                  MUIA_Group_Child,		Month = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		1,
                                    MUIA_Numeric_Max,		12,
                                    MUIA_Numeric_Default,	1,
                                    /*MUIA_Numeric_Value,	6,*/
                                    MUIA_CycleChain,		1,
                                    MUIA_Font,			MUIV_Font_Button,
                                  End,
                                  MUIA_Group_Child,		Year = NumericbuttonObject,
                                    MUIA_Numeric_Format,	"%lu",
                                    MUIA_Numeric_Min,		8,
                                    MUIA_Numeric_Max,		8000,
                                    MUIA_Numeric_Default,	1997,
                                    /*MUIA_Numeric_Value,	1997,*/
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
                                    MUIA_String_Accept,		"%.-/, edBbhmyYjwaAUWxDJfvs24nM",
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
                                  MUIA_Group_Child,		NewObject(Str_CC->mcc_Class,NULL,
				    MUIA_Dropable,		TRUE,
				  End,
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
     ULONG day,month,year;
     STRPTR dateformat;

     /*result =*/ DoMethod(DateText,MUIM_Date_SetCurrent);

     /*result =*/ get(DateText,MUIA_Date_Day,&day);
     /*result =*/ get(DateText,MUIA_Date_Month,&month);
     /*result =*/ get(DateText,MUIA_Date_Year,&year);
     /*result =*/ set(Day,MUIA_Numeric_Value,day);
     /*result =*/ set(Month,MUIA_Numeric_Value,month);
     /*result =*/ set(Year,MUIA_Numeric_Value,year);

     /*result =*/ get(DateText,MUIA_DateText_DateFormat,&dateformat);
     /*result =*/ set(format,MUIA_String_Contents,dateformat);

     /*result =*/ DoMethod(Day,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,DateText,3,MUIM_Set,MUIA_Date_Day,MUIV_TriggerValue);
     /*result =*/ DoMethod(Month,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,DateText,3,MUIM_Set,MUIA_Date_Month,MUIV_TriggerValue);
     /*result =*/ DoMethod(Year,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,DateText,3,MUIM_Set,MUIA_Date_Year,MUIV_TriggerValue);

     /*result =*/ DoMethod(format,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,DateText,3,MUIM_Set,MUIA_DateText_DateFormat,MUIV_TriggerValue);

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
                              MUIA_Application_Title,           "DateText-Demo",
                              MUIA_Application_Author,          "Kai Hofmann",
                              MUIA_Application_Copyright,       "© 1997-1998 Kai Hofmann",
                              MUIA_Application_Version,         "$VER: DateText-Demo 12.0 " __AMIGADATE__,
                              MUIA_Application_Description,     "DateText demonstration program",
                              MUIA_Application_Base,            "DSDEMO",
                              MUIA_Application_SingleTask,      TRUE,
                              MUIA_Application_Active,          TRUE,
                              MUIA_Application_Window,		win1 = NewObject(Win_CC->mcc_Class,NULL,TAG_DONE),
                              TAG_MORE, msg->ops_AttrList
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
     "DateText-Demo",
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
      }
    }

   return(retstat);
  }


 static int muiclasses_Cleanup(void)
  {
   int retstat = RETURN_OK;

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
       Object *ds;

       ds = MUI_NewObject(MUIC_DateText,
                          TAG_DONE
                         );
       if (ds != NULL)
        {
         MUI_DisposeObject(ds);
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
         OpenReq("Missing DateText.mcc!");
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
   BOOL error = FALSE;

   DateBase = OpenLibrary(DATE_NAME,33);
   if (DateBase != NULL)
    {
     if (((DateBase->lib_Version > 33)) || ((DateBase->lib_Version == 33) && (DateBase->lib_Revision >= 290)))
      {
       short i;
       char mn[15];
       APTR mempool;

       mempool = LibCreatePool(MEMF_PUBLIC,180,15);
       if (mempool != NULL)
        {
         for (i=0;i<12;i++)
          {
           date_MonthText(i+1,mn,date_Locale);
           months[i] = (char *)LibAllocPooled(mempool,(ULONG)strlen(mn)+1);
           if (months[i] != NULL)
            {
             strcpy(months[i],mn);
            }
           else
            {
             OpenReq("Out of memory error!");
             error = TRUE;
             break;
            }
          }
         if (!error)
          {
           months[12] = NULL;
           if (gui_Init() == RETURN_OK)
            {
             gui_MainLoop();
             /*result =*/ gui_Cleanup();
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
