/*
   DnD Demo

   2000-2005 © Olivier LAVIALE <gofromiel@gofromiel.com>

*/

#include <intuition/intuition.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>
#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/feelin.h>

struct  FeelinBase    *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace    *IFeelin;
#endif

#ifdef __VBCC__
#undef GfxBase
struct GfxBase *GfxBase;
#endif

// This is the instance data for our custom class.

struct LocalObjectData
{
	FAreaPublic                    *AreaPublic;
};
 
///mNew
F_METHOD(uint32,mNew)
{
   struct LocalObjectData *LOD = F_LOD(Class,Obj);

   F_SAVE_AREA_PUBLIC;

   return IFEELIN F_SuperDo(Class,Obj,Method,
   
	   FA_Element_Class,    "textinfo",
	   FA_Element_Style,    "font-size: big",
	   FA_Text_VCenter,     TRUE,
	   FA_Text_HCenter,     TRUE,
	   FA_Widget_Dropable,         TRUE,
	   
	   TAG_MORE,Msg);
}
//+
/// mSetup
/*

   FM_Widget_ModifyEvents creates a FEventHandler on the  fly  depending  on  the
   resulting  modified  events. Using FM_Widget_ModifyEvents it's a piece of cake
   ot request events.

*/
F_METHOD(uint32,mSetup)
{
	IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,FF_EVENT_WBDROP,0);

	return F_SUPERDO();
}
//+
/// mCleanup
F_METHOD(uint32,mCleanup)
{
	IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,0,FF_EVENT_WBDROP);

	return F_SUPERDO();
}
//+
///mHandleEvent
/*

in FM_Setup we said that we want get a message if an object was droped from
the workbench, so we have to define the event-handler.

*/

F_METHODM(uint32,mHandleEvent,FS_Widget_HandleEvent)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	FEvent *fev = Msg -> Event;
  
	#define _between(a,x,b) ((x) >= (a) && (x) <= (b))
	#define _isinobject(x,y) (_between(_area_cx,(x),_area_cx2) && _between(_area_cy,(y),_area_cy2))

	if (fev -> Class == FF_EVENT_WBDROP)
	{
		if (_isinobject(fev -> MouseX,fev -> MouseY))
		{
			#if F_CODE_DEPRECATED
			uint32 narg = ((struct AppMessage *)(fev -> IMsg)) -> am_NumArgs;
			struct WBArg *arg = ((struct AppMessage *)(fev -> IMsg)) -> am_ArgList;
			STRPTR buf;
			
			if ((buf = IFEELIN F_New(1024)) != NULL)
			{
				while (narg--)
				{
					IDOS_ NameFromLock(arg -> wa_Lock,buf,1023);
					IDOS_ AddPart(buf,arg -> wa_Name,1023);
	  
					IFEELIN F_Log(0,"WBDrop (%s)(0x%08lx)",buf,arg -> wa_Lock);
					IDOS_ Printf("WBDrop (%s)(0x%08lx)\n",buf,arg -> wa_Lock);
				 
					arg++;
				}

				IFEELIN F_Dispose(buf);
			}
			#else
				
			if (fev->Special)
			{
				struct WBArg *e = fev->Special;
				STRPTR buf = IFEELIN F_New(1024);
 
				if (buf)
				{
					while (e->wa_Lock)
					{
						IDOS_ NameFromLock(e->wa_Lock,buf,1023);
						
						if (e->wa_Name) 
						{
							IDOS_ AddPart(buf,e->wa_Name,1023);
						}

						IFEELIN F_Log(0,"WBDrop (%s)(0x%08lx)", buf, e->wa_Lock);
						IDOS_ Printf("WBDrop (%s)(0x%08lx)\n", (int32) buf, e->wa_Lock);
						
						e++;
					}

					IFEELIN F_Dispose(buf);
				}
			}
			
			#endif

			return FF_HandleEvent_Eat;
		}
	}
	return F_SUPERDO();
}
//+
///mDnDDrop
F_METHODM(uint32,mDnDDrop,FS_Widget_DnDDrop)
{
	IFEELIN F_Log(0,"DnDDrop: Source %s{0x%08lx}",_object_classname(Msg -> Source), Msg->Source);
   
	return F_SUPERDO();
}
//+

STATIC F_METHODS_ARRAY =
{
	F_METHODS_OVERRIDE_STATIC(mNew,         FM_New),
	F_METHODS_OVERRIDE_STATIC(mSetup,       FM_Element_Setup),
	F_METHODS_OVERRIDE_STATIC(mCleanup,     FM_Element_Cleanup),
	F_METHODS_OVERRIDE_STATIC(mHandleEvent, FM_Widget_HandleEvent),
	F_METHODS_OVERRIDE_STATIC(mDnDDrop,     FM_Widget_DnDDrop),

	F_ARRAY_END
};

STATIC F_TAGS_ARRAY =
{
	F_TAGS_ADD_LOD,
	F_TAGS_ADD_SUPER(Text),
	F_TAGS_ADD_METHODS,

	F_ARRAY_END
};

/// Main
int main()
{
	FClass *cc;
	FObject app,win,myobj;

	if (F_FEELIN_OPEN)
	{
		#ifdef __VBCC__
		GfxBase = FeelinBase -> Graphics;
		#endif

		/* Create the new custom class with a call to F_CreateClassA().

		This function returns a FClass. You must use Class -> Name to  create
		instance  of  your  custom  class.  This  Name  is unique and made by
		F_CreateClassA(). */

		cc = IFEELIN F_CreateClassA(NULL, F_TAGS_PTR);
		
		if (cc)
		{
		   app = AppObject,
			  Child, win = WindowObject,
				 FA_Element_Id, "main",
				 FA_Window_Title, "Feelin : DnD Demo",
				 FA_Window_Open,   TRUE,

				 Child, VGroup,
					Child, TextObject,
						FA_Element_Class, "textinfo",
						FA_Widget_SetMax, FV_Widget_SetHeight,
						DontChain,
						FA_Text_Contents, "<align=center><b>Drag'n'Drop demo</b><br>You can also drop workbench objects !", End,
					
					Child, HGroup,
					   Child, IFEELIN F_MakeObj(FV_MakeObj_Button, "Drag Me",
					   		
							FA_Widget_Draggable, TRUE,
							FA_Widget_SetMax, FV_Widget_SetNone,
							FA_Text_VCenter, TRUE,

							TAG_DONE),

					   Child, myobj = IFEELIN F_NewObj(cc -> Name, FA_Text_Contents, "Drop on Me", TAG_DONE),
					End,
				 End,
			  End,
		   End;

		   if (app)
		   {
			  IFEELIN F_Do(win,FM_Notify,FA_Window_CloseRequest,TRUE, app,FM_Application_Shutdown,0);
			  IFEELIN F_Do(app,FM_Application_Run);
			  IFEELIN F_DisposeObj(app);
		   }

		   IFEELIN F_DeleteClass(cc);
		}
		else
		{
		   IDOS_ Printf("Could not create custom class.\n");
		}
		
		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("Failed to open feelin.library\n");
	}
	return 0;
}
//+
