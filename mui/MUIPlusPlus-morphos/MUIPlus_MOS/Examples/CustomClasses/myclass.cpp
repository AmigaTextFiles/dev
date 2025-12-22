/* Krashans example changed by Kaczus to C++
*/
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/muimaster.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <mui/HTMLtext_mcc.hpp>
#include <iostream>
#include <clib/debug_protos.h>
using namespace std;
//#include <fastmath.h>

#include <libraries/mui.hpp>



#define OBJ_WINDOW  123456      /* identyfikator przydatny do odszukania obiektu */
                                /* okna w funkcji MainLoop() i SetNotifications */

struct Library *MUIMasterBase, *UtilityBase;
struct GfxBase *GfxBase;
struct IntuitionBase *IntuitionBase;
CMUI_Application App;
CMUI_Window Win;

class MouseArrowClass :public Custom_Class_Area
{///

	public:
  	short DeltaX;
  	short DeltaY;
  	struct MUI_EventHandlerNode EHNode;
    
    long mAskMinMax (Class *cl, Object *obj, Msg msg);
    long mDraw (Class *cl, Object *obj, Msg msg);
    long mSetup (Class *cl, Object *obj, Msg msg);
    long mCleanup (Class *cl, Object *obj, Msg msg);
    long mHandleEvent (Class *cl, Object *obj, Msg msg);


  	MouseArrowClass():Custom_Class_Area ("mousearrowclass")
  	{

	}
   MouseArrowClass (Tag tag, ...);
   DECLARE_CCLASS(MouseArrowClass)
    
};///-


BEGIN_DEF_CCLASS(MouseArrowClass)
	DECLARE_EVENT(MUIM_AskMinMax,mAskMinMax)
	DECLARE_EVENT(MUIM_Draw,mDraw)
	DECLARE_EVENT(MUIM_Setup,mSetup)
   DECLARE_EVENT(MUIM_Cleanup,mCleanup)
   DECLARE_EVENT(MUIM_HandleEvent,mHandleEvent)
END_DEF_CCLASS
inline MouseArrowClass::MouseArrowClass (Tag tag, ...) :Custom_Class_Area ("mousearrowclass")
{///
	va_list va;
  	ULONG i;
  	ULONG *array;
  	ULONG Count;
   int a;
   
   va_start(va,tag);
  	Count=0;
   i=tag;
   while((i&&(i!=TAG_DONE))||(Count&1))
   {
         if ((i==TAG_MORE)&&((Count&1)==0))
         {
         	Count+=va_arg(va,ULONG)+1;
            i=0;
         }
         else
         {
         	i=va_arg(va,ULONG);
         	Count++;
         }

  	}
  	va_end(va);
  	array=(ULONG *)AllocVecPooled(poolHeader,(sizeof(ULONG)*(Count+1)));
   object=NULL;
   if (array)
   {

      array[0]=tag;
     	va_start(va,tag);
     	for (i=1;i<=Count;i++)
     	{
     	  	array[i]=va_arg(va,ULONG);
     	}
     	va_end(va);
     
     	object = (Object *)NewObjectA (mcc_Class, NULL,(struct TagItem *)array);//va->overflow_arg_area);//(struct TagItem *)&tag1);
      if (object)
      {
     		REGISTER_CCLASS(MouseArrowClass,mcc_Class,object)
      }
   	FreeVecPooled(poolHeader,array);
   }
    
#ifdef MUIPP_DEBUG
	if (object == NULL)
		_MUIPPWarning ("Could not create a MyCustom object\n");
#endif
}///-


/* ============== TU ZACZYNA SIË KOD KLASY ====================== */

/* dane obiektu */


/* metoda AskMinMax */

long MouseArrowClass::mAskMinMax (Class *cl, Object *obj, Msg msg)
{///
  DoSuperMethodA (cl, obj, msg);
  ((struct MUIP_AskMinMax *) msg)->MinMaxInfo->MinWidth += 40;
  ((struct MUIP_AskMinMax *)msg)->MinMaxInfo->DefWidth += 40;
  ((struct MUIP_AskMinMax *)msg)->MinMaxInfo->MaxWidth += 40;
  ((struct MUIP_AskMinMax *)msg)->MinMaxInfo->MinHeight += 40;
  ((struct MUIP_AskMinMax *)msg)->MinMaxInfo->DefHeight += 40;
  ((struct MUIP_AskMinMax *)msg)->MinMaxInfo->MaxHeight += 40;
  return 0;
}///-

/* metoda Draw */

#define RADIUS 18   /* promieï strzaîki */

long MouseArrowClass::mDraw (Class *cl, Object *obj, Msg msg)
{///
  short big_radius;
  long dx, dy;
  struct RastPort *rp = _rp(obj);
  DoSuperMethodA (cl, obj, msg);
  big_radius = (short)sqrt (DeltaX * DeltaX + DeltaY * DeltaY);
  if (big_radius != 0)
   {
    dx = (DeltaX * RADIUS) / big_radius;
    dy = (DeltaY * RADIUS) / big_radius;
   }
  else
   {
    dx = 0;
    dy = 0;
   }
  SetAPen (rp, 1);
  Move (rp, _mleft(obj) + 20 + dx, _mtop(obj) + 20 + dy);
  Draw (rp, _mleft(obj) + 20 - dx, _mtop(obj) + 20 - dy);
  SetAPen (rp, 2);
  WritePixel (rp, _mleft(obj) + 20 + dx, _mtop(obj) + 20 + dy);
  WritePixel (rp, _mleft(obj) + 21 + dx, _mtop(obj) + 20 + dy);
  WritePixel (rp, _mleft(obj) + 20 + dx, _mtop(obj) + 21 + dy);
  WritePixel (rp, _mleft(obj) + 19 + dx, _mtop(obj) + 20 + dy);
  WritePixel (rp, _mleft(obj) + 20 + dx, _mtop(obj) + 19 + dy);
  return 0;
}///-

/* metoda Setup */

long MouseArrowClass::mSetup (Class *cl, Object *obj, Msg msg)
{///
  if (DoSuperMethodA (cl, obj, msg))
   {
     EHNode.ehn_Priority = 0;
     EHNode.ehn_Flags = 0;
     EHNode.ehn_Object = obj;
     EHNode.ehn_Class = cl;
     EHNode.ehn_Events = IDCMP_MOUSEMOVE;
    DoMethod (_win(obj), MUIM_Window_AddEventHandler, &EHNode);
    return TRUE;
   }
  return FALSE;
}///-

/* metoda Cleanup */

long MouseArrowClass::mCleanup (Class *cl, Object *obj, Msg msg)
{///
  //struct MouseArrow *data = INST_DATA(cl,obj);
  DoMethod (_win(obj), MUIM_Window_RemEventHandler, &EHNode);
}///-

/* metoda HandleEvent */

long MouseArrowClass::mHandleEvent (Class *cl, Object *obj, Msg msg)
{///
  //struct MouseArrow *data = INST_DATA(cl,obj);
  if (((struct MUIP_HandleEvent *)msg)->imsg)
   {
    if (((struct MUIP_HandleEvent *)msg)->imsg->Class == IDCMP_MOUSEMOVE)
     {
      DeltaX = ((struct MUIP_HandleEvent *)msg)->imsg->MouseX - _mleft(obj) - 20;
      DeltaY = ((struct MUIP_HandleEvent *)msg)->imsg->MouseY - _mtop(obj) - 20;
      MUI_Redraw (obj, MADF_DRAWOBJECT);
     }
   }
  return 0;
}///-

/* dispatcher */

/* ============= KONIEC KODU KLASY =============================*/


/* Ustawienie notyfikacji na zamkniëcie okna */

void SetNotifications (void)
{///
  
   Win.Notify( MUIA_Window_CloseRequest, MUIV_EveryTime,
                  App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

  //return;
}///-

/* pëtla gîówna programu */

void MainLoop (void)
{///
  unsigned long int signals;

  Win.SetOpen(TRUE);
  while (App.NewInput(&signals) != MUIV_Application_ReturnID_Quit)
   {
    if (signals)
     {
      signals = Wait (signals | SIGBREAKF_CTRL_C);
      if (signals & SIGBREAKF_CTRL_C) break;
     }
   }

  Win.SetOpen(FALSE);
  return;
}///-
 
/* otwieranie bibliotek hurtem */

long OpenLibs (void)
{///
  if (!(IntuitionBase = (struct IntuitionBase*)OpenLibrary ("intuition.library", 39))) return FALSE;
  if (!(GfxBase = (struct GfxBase *)OpenLibrary ("graphics.library", 39))) return FALSE;
  if (!(UtilityBase = OpenLibrary ("utility.library", 39))) return FALSE;
  if (!(MUIMasterBase = OpenLibrary ("muimaster.library", 19))) return FALSE;
  return TRUE;
}///-

/* zamykanie bibliotek hurtem */

void CloseLibs (void)
{///
  if (MUIMasterBase) CloseLibrary (MUIMasterBase);
  if (UtilityBase) CloseLibrary (UtilityBase);
  if (GfxBase) CloseLibrary ((struct Library *)GfxBase);
  if (IntuitionBase) CloseLibrary ((struct Library *)IntuitionBase);
  return;
}///-

/* gîówna funkcja programu */

int main ()
{///

	int s;
   if (OpenLibs ());
   {
      if (INITMuiPlus())
      {

    		
         App = CMUI_Application (
      		MUIA_Application_Author, "Krashan/BlaBla & Kaczus/BlaBla ",
      		MUIA_Application_Base, "PRZYKLAD12A w c++",
      		MUIA_Application_Copyright, "© 2004 by BlaBla Corp.",
      		MUIA_Application_Description, "Przykîad 12a do kursu MUI w ACS przerobiony jako przyklad dla MUI++",
      		MUIA_Application_Title, "Przykîad12a",
      		MUIA_Application_Version, "$VER: przykîad12a 2.0 (01.5.2004) BLABLA PRODUCT",
      		MUIA_Application_Window, (Object *)(Win = CMUI_Window
            (
       			MUIA_Window_Title, "Przykîad 12a",
       			MUIA_Window_ID, 0x50525A4B,
       			//MUIA_UserData, OBJ_WINDOW,
       			WindowContents,(Object *) (CMUI_VGroup
               (
        				
                  

                  MUIA_Group_Child, (Object *) (CMUI_VGroup
                  (

         				MUIA_Group_Columns, 3,
         				MUIA_Group_Child, (Object *) (MouseArrowClass
                     (
          					MUIA_Frame, MUIV_Frame_Text,
          					MUIA_Background, MUII_TextBack,
         					TAG_DONE
                     )),
         			   MUIA_Group_Child, (Object *)(CMUI_Rectangle ((ULONG)TAG_DONE)),
         				MUIA_Group_Child, (Object *)(MouseArrowClass
                     (
          					MUIA_Frame, MUIV_Frame_Text,
          					MUIA_Background, MUII_TextBack,
         					TAG_DONE
                     )),
         			   MUIA_Group_Child, (Object *)(CMUI_Rectangle ((ULONG)TAG_DONE)),
         			   MUIA_Group_Child, (Object *)(CMUI_Rectangle ((ULONG)TAG_DONE)),
         			   MUIA_Group_Child, (Object *)(CMUI_Rectangle ((ULONG)TAG_DONE)),
         				MUIA_Group_Child, (Object *)(MouseArrowClass
                     (
          					MUIA_Frame, MUIV_Frame_Text,
          					MUIA_Background, MUII_TextBack,
         					TAG_DONE
                     )),
         			   MUIA_Group_Child, (Object *)(CMUI_Rectangle ((ULONG)TAG_DONE)),
         				MUIA_Group_Child, (Object *)(MouseArrowClass
                     (
          					MUIA_Frame, MUIV_Frame_Text,
          					MUIA_Background, MUII_TextBack,
         					TAG_DONE
                     )),
        					TAG_DONE
                  )),
       				TAG_DONE
               )),
      			TAG_DONE
            )),
     			TAG_DONE);
         if (App.IsValid())
          {
           
           SetNotifications ();
           
           MainLoop ();
           
           App.Dispose();
         }

   	}
      DisposeMuiPlus();
   }

  CloseLibs ();

  return 0;
}///-
