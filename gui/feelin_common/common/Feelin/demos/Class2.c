/*
   2000-2004 © Olivier LAVIALE <gofromiel@gofromiel.com>

   This example illustrate how to writte a custom class using an  array  of
   methods instead of a dispatcher.
*/

#include <stdlib.h>

#include <libraries/feelin.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/feelin.h>

struct FeelinBase *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace *IFeelin;
#endif

#ifdef __VBCC__
#undef GfxBase
struct GfxBase *GfxBase;
#endif

/* Here is the beginning of our simple new class... */

struct LocalObjectData
{
	F_MEMBER_AREA_PUBLIC;

   	APTR                            timer_handler;
};

enum  {

	  FV_METHOD_STROBO

	  };

/// mNew
F_METHOD(uint32,mNew)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	F_SAVE_AREA_PUBLIC;

	return IFEELIN F_SuperDo(Class, Obj, Method,

		FA_Element_Style, "border-frame: win-in;",
		FA_Area_Fillable, FALSE,
		FA_Widget_Chainable, FALSE,

		TAG_MORE, Msg);
}
//+
/// mShow
F_METHOD(bool32,mShow)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (F_SUPERDO() == FALSE)
	{
		return FALSE;
	}

	if (LOD->timer_handler == NULL)
	{
		LOD->timer_handler = (APTR) IFEELIN F_Do
		(
			_area_app, FM_Application_CreateSignalHandler,

			FA_SignalHandler_Target, Obj,
			FA_SignalHandler_Method, F_METHOD_ID(STROBO),
			FA_SignalHandler_Micros, 30000,

			TAG_DONE
		);
	}

	if (LOD->timer_handler == NULL)
	{
		return FALSE;
	}

	return TRUE;
}
//+
/// mHide
F_METHOD(uint32,mHide)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	if (LOD->timer_handler != NULL)
	{
		IFEELIN F_Do(_area_app, FM_Application_DeleteSignalHandler, LOD->timer_handler);

		LOD->timer_handler = NULL;
	}

	return F_SUPERDO();
}
//+
/// mAskMinMax
/*
AskMinMax method will be called before the  window  is  opened  and  before
layout  takes place. We need to tell Feelin the minimum and maximum size of
our object. Note that we indeed need to *add* these values,  not  just  set
them !
*/
F_METHOD(uint32,mAskMinMax)
{
   struct LocalObjectData *LOD = F_LOD(Class,Obj);

   _area_minw += 30;
   _area_minh += 30;

/*
Now call our superclass. FC_Area will handle everything,  taking  care  of
FA_FixedXxx, FA_MinXxx and FA_MaxXxx.
*/

   return F_SUPERDO();
}
//+
/// mDraw
/*
Draw method is called whenever  Feelin  feels  (obviously  ;-))  we  should
render our object. This usually happens after layout is finished. Note: You
may  only  render  within  the  rectangle  _mx(Obj),  _my(Obj),  _mx2(Obj),
_my2(Obj).
*/
F_METHOD(void,mDraw)
{
   struct LocalObjectData *LOD = F_LOD(Class,Obj);
   struct RastPort *rp = _area_rp;

/*
let our superclass draw itself first, Area class would e.g. draw the  frame
and clear the whole region. What it does exactly depends on flags.
*/

   F_SUPERDO();

   _APen(rand() % (1 << rp->BitMap->Depth));
   _Boxf(_area_cx,_area_cy,_area_cx2,_area_cy2);
}
//+
///mStrobo
F_METHOD(int32,mStrobo)
{
   IFEELIN F_Draw(Obj,FF_Draw_Update);
   return TRUE; // If we return FALSE the timer event won't be requested again
}
//+

///Main
int main(void)
{
	FClass *cc;
	FObject app,win;

 /*
	Methods handled by the class.
 */

	STATIC F_METHODS_ARRAY =
	{
		F_METHODS_ADD(mStrobo, "Stobo"),

		F_METHODS_OVERRIDE_STATIC(mNew,       FM_New),
		F_METHODS_OVERRIDE_STATIC(mShow,      FM_Area_Show),
		F_METHODS_OVERRIDE_STATIC(mHide,      FM_Area_Hide),
		F_METHODS_OVERRIDE_STATIC(mAskMinMax, FM_Area_AskMinMax),
		F_METHODS_OVERRIDE_STATIC(mDraw,      FM_Area_Draw),

		F_ARRAY_END
	};
	
	STATIC F_TAGS_ARRAY =
	{
		F_TAGS_ADD_SUPER(Widget),
		F_TAGS_ADD_LOD,
		F_TAGS_ADD_METHODS,

		F_ARRAY_END
	};

	if (F_FEELIN_OPEN)
	{
		#ifdef __VBCC__
		GfxBase = FeelinBase->Graphics;
		#endif

		/* Create the new custom class with a call to F_CreateClassA().

		This function returns a struct FeelinClass. You must use cc -> Name
		to create instance of your custom class. This Name is unique and made
		by F_CreateClassA(). */

		if ((cc = IFEELIN F_CreateClassA(NULL, F_TAGS_PTR)) != NULL)
		{
			app = AppObject,
			   FA_Application_Title,        "demo_Class2",
			   FA_Application_Version,      "$VER: Class2 1.2 (2006/07/25)",
			   FA_Application_Copyright,    "© 2000-2003 Olivier LAVIALE",
			   FA_Application_Author,       "Olivier LAVIALE - gofromiel@gofromiel.com",
			   FA_Application_Description,  "FM_Application_CreateSignalHandler",
			   FA_Application_Base,         "CLASS2",

			   Child, win = WindowObject,
				  FA_Element_Id, "windows.main",
				  FA_Element_Persist, "width height",
				  FA_Window_Title, "Crazy colors",
				  FA_Window_Open,   TRUE,
				  
				  Child, RowGroup(2),
					 Child, IFEELIN F_NewObj(cc->Name, TAG_DONE),
					 Child, IFEELIN F_NewObj(cc->Name, TAG_DONE),
					 Child, IFEELIN F_NewObj(cc->Name, TAG_DONE),
					 Child, IFEELIN F_NewObj(cc->Name, TAG_DONE),
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
			IDOS_ Printf("Unable to create custom class.\n");
		}
		
		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("Failed to open feelin.library.\n");
	}
	return 0;
}
//+
