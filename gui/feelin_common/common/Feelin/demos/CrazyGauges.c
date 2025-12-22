/*
   $VER: CrazyGauges 01.10 (2005/04/13) by Olivier LAVIALE.

   This example illustrare how to write a subclass using  a  methods  table
   instead of a dispatcher, and Dynamic IDs.
*/

///Header
#include <stdlib.h>

#include <intuition/intuition.h>
#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/feelin.h>

struct FeelinBase                  *FeelinBase;
#ifdef __amigaos4__
struct FeelinIFace                 *IFeelin;
#endif

/*** local object's data ***************************************************/

struct LocalObjectData
{
   BYTE                             Mode;
   BYTE                             Way;
};

/*** some useful macros ****************************************************/

#define CrazyObject  IFEELIN F_NewObj(cc->Name
#define Crazy(h,min,max,val,mode)            CrazyObject,                      \
											 "Min",          min,              \
											 "Max",          max,              \
											 "Value",        val,              \
											 "Mode",         mode,             \
											 End
//+

/*** Special values for FA_CrazyGauge_Mode *****************************************************/

enum    {

		FV_CrazyGauge_More,
		FV_CrazyGauge_Less,
		FV_CrazyGauge_TwoWays,
		FV_CrazyGauge_Crazy

		};

STATIC F_VALUES_ARRAY(Mode) =
{
	F_VALUES_ADD("More",    FV_CrazyGauge_More),
	F_VALUES_ADD("Less",    FV_CrazyGauge_Less),
	F_VALUES_ADD("TwoWays", FV_CrazyGauge_TwoWays),
	F_VALUES_ADD("Crazy",   FV_CrazyGauge_Crazy),
	
	F_ARRAY_END
};

/*** Attributes defined by my class ************************************************************/

enum    {

		FV_ATTRIBUTE_MODE

		};

STATIC F_ATTRIBUTES_ARRAY =
{
	F_ATTRIBUTES_ADD_VALUES("Mode", FV_TYPE_INTEGER, Mode),

	F_ARRAY_END
};

/*** Dynamic IDs from my superclasses (don't need auto resolve) ********************************/

enum  {

	  FV_RESOLVED_VALUE,
	  FV_RESOLVED_MIN,
	  FV_RESOLVED_MAX

	  };

STATIC F_RESOLVEDS_ARRAY =
{
	F_RESOLVEDS_ADD("FA_Numeric_Value"),
	F_RESOLVEDS_ADD("FA_Numeric_Min"),
	F_RESOLVEDS_ADD("FA_Numeric_Max"),

	F_ARRAY_END
};

/*** Methods handled by my class ***************************************************************/

///Crazy_New
F_METHODM(ULONG,Crazy_New,TagItem)
{
   struct LocalObjectData *LOD = F_LOD(Class,Obj);
   struct TagItem *Tags = Msg,item;

   LOD->Way = TRUE;

   while (IFEELIN F_DynamicNTI(&Tags,&item,Class))
   switch (item.ti_Tag)
   {
	  case FV_ATTRIBUTE_MODE:
	  {
		 LOD->Mode = item.ti_Data;
	  }
	  break;
   }

   return F_SUPERDO();
}
//+
///Crazy_Setup
F_METHOD(ULONG,Crazy_Setup)
{
   if (F_SUPERDO())
   {
	  IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,FF_EVENT_TICK,0);

	  return TRUE;
   }
   return FALSE;
}
//+
///Crazy_Cleanup
F_METHOD(void,Crazy_Cleanup)
{
   IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,0,FF_EVENT_TICK);

   F_SUPERDO();
}
//+
///Crazy_HandleEvent
F_METHODM(ULONG,Crazy_HandleEvent,FS_Widget_HandleEvent)
{
   struct LocalObjectData *LOD = F_LOD(Class,Obj);

   if (Msg->Event->Class == FF_EVENT_TICK)
   {
	  LONG val,max,min;

	  IFEELIN F_Do(Obj,FM_Get,
		 F_RESOLVED_ID(VALUE),  &val,
		 F_RESOLVED_ID(MAX),    &max,
		 F_RESOLVED_ID(MIN),    &min, TAG_DONE);

	  switch (LOD->Mode)
	  {
		 case FV_CrazyGauge_More:
		 {
			IFEELIN F_Set(Obj, F_RESOLVED_ID(VALUE),(val == max) ? min : val + 1);
		 }
		 break;

		 case FV_CrazyGauge_Less:
		 {
			IFEELIN F_Set(Obj,F_RESOLVED_ID(VALUE),(val == min) ? max : val - 1);
		 }
		 break;

		 case FV_CrazyGauge_TwoWays:
		 {
			if (LOD->Way)
			{
			   if (val == max)   LOD->Way = FALSE;
			   else              IFEELIN F_Set(Obj,F_RESOLVED_ID(VALUE),val + 1);
			}
			else
			{
			   if (val == min)   LOD->Way = TRUE;
			   else              IFEELIN F_Set(Obj,F_RESOLVED_ID(VALUE),val - 1);
			}
		 }
		 break;

		 case FV_CrazyGauge_Crazy:
		 {
			IFEELIN F_Set(Obj,F_RESOLVED_ID(VALUE),rand() % max);
		 }
		 break;
	  }
   }
   return 0;
}
//+

STATIC F_METHODS_ARRAY =
{
	F_METHODS_OVERRIDE_STATIC(Crazy_New, FM_New),
	F_METHODS_OVERRIDE_STATIC(Crazy_Setup, FM_Element_Setup),
	F_METHODS_OVERRIDE_STATIC(Crazy_Cleanup, FM_Element_Cleanup),
	F_METHODS_OVERRIDE_STATIC(Crazy_HandleEvent, FM_Widget_HandleEvent),

	F_ARRAY_END
};

STATIC F_TAGS_ARRAY =
{
	F_TAGS_ADD_SUPER(Gauge),
	F_TAGS_ADD_LOD,
	F_TAGS_ADD_METHODS,
	F_TAGS_ADD_ATTRIBUTES,
	F_TAGS_ADD_RESOLVEDS,

	F_ARRAY_END
};

/*** main **************************************************************************************/

///Main
int main()
{
	if (F_FEELIN_OPEN)
	{
		FClass *cc = IFEELIN F_CreateClassA(NULL, F_TAGS_PTR);

		if (cc)
		{
			FObject app,win, g,bal,b2;
			
			app = AppObject,
				FA_Application_Title,        "demo_CrazyGauges",
				FA_Application_Version,      "$VER: CrazyGauges 1.10 (2005/04/13)",
				FA_Application_Copyright,    "© 2000-2005 - Olivier LAVIALE",
				FA_Application_Author,       "Olivier LAVIALE (www.gofromiel.com)",
				FA_Application_Description,  "Show gauges & custom class",
				FA_Application_Base,         "CRAZYGAUGES",

				Child, win = WindowObject,
					FA_Element_Id, "win",
					FA_Element_Persist, "width height",
					FA_Window_Title,  "Feelin : Gauges",
					FA_Window_Open,   TRUE,

					Child, VGroup,
						Child, g = HGroup,
							Child, VGroup,
								Child, Gauge(TRUE,0,100,25),
								Child, Gauge(TRUE,0,100,50),
								Child, Gauge(TRUE,0,100,75),
								Child, Gauge(TRUE,0,100,100),
								Child, Crazy(TRUE,0,100,0,"Crazy"),
							End,

							Child, bal = BalanceObject, FA_Element_Id, "balance", FA_Element_Persist, "weights", End,

							Child, VGroup, FA_Widget_SetMax,FV_Widget_SetHeight,
								Child, Crazy(TRUE,0,100,  0,"TwoWays"),
								Child, Crazy(TRUE,0,100,100,"TwoWays"),
								Child, Crazy(TRUE,0,100,  0,"TwoWays"),
								Child, Crazy(TRUE,0,100,100,"TwoWays"),
							End,
						End,

						Child, BarObject, End,

						Child, HGroup,
							Child, HLabel("Quick Balance"),
							Child, b2 = Checkbox(FALSE),
						End,
					End,
				End,
			End;

			if (app)
			{
				IFEELIN F_Do(b2,FM_Notify,FA_Widget_Selected,FV_Notify_Always,bal,FM_Set,2,"FA_Balance_QuickDraw",FV_Notify_Value);
				IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE,app,FM_Application_Shutdown,0);

				IFEELIN F_Do(app,FM_Application_Run);

				IFEELIN F_DisposeObj(app);
			}
			else IDOS_ Printf("Unable to create application\n");

			IFEELIN F_DeleteClass(cc);
		}
		else IDOS_ Printf("Unable to create custom class\n");

		F_FEELIN_CLOSE;
	}
	else IDOS_ Printf("Unable to open feelin.library %ld\n",FV_FEELIN_VERSION);

	return 0;
}
//+
