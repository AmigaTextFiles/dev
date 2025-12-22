/*
	Class3 Demo

	2000-2005 © Olivier LAVIALE <gofromiel@gofromiel.com>

*/

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/feelin.h>

#include <intuition/intuition.h>
#include <libraries/feelin.h>

struct  FeelinBase                 *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace                 *IFeelin;
#else

#define GfxBase                     FeelinBase->Graphics
 
#endif

// This is the instance data for our custom class.
 
struct LocalObjectData
{
	F_MEMBER_AREA_PUBLIC;
	
	int16                            x,y, sx,sy;
};

///mNew
F_METHOD(uint32,mNew)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	F_SAVE_AREA_PUBLIC;

	return IFEELIN F_SuperDo(Class, Obj, Method,

		FA_Area_Fillable, FALSE,

		TAG_MORE, Msg);
}
//+
/// mSetup
F_METHOD(uint32,mSetup)
{
	if (F_SUPERDO() == FALSE)
	{
		return FALSE;
	}

	IFEELIN F_Do(Obj, FM_Widget_ModifyEvents, FF_EVENT_KEY | FF_EVENT_BUTTON, 0);

	return TRUE;
}
//+
/// mCleanup
F_METHOD(uint32,mCleanup)
{
	IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,0,FF_EVENT_KEY | FF_EVENT_BUTTON);

	return F_SUPERDO();
}
//+
/// mAskMinMax
F_METHOD(uint32,mAskMinMax)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);

	_area_minw += 100; _area_minh +=  40;
	_area_maxw  = 500; _area_maxh  = 300;

	return F_SUPERDO();
}
//+
/// mDraw

/* Draw method is called whenever Feelin feels  (obviously  ;-))  we  should
render  our object. This usually happens after layout is finished. Note: You
may only render within the rectangle _mx(), _my(), _mx2(), _my2(). */

F_METHODM(void,mDraw,FS_Area_Draw)
{
	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	struct RastPort *rp = _area_rp;

	/* Let our superclass draw itself first, FC_Area  would  e.g.  draw  the
	frame and clear the whole region. What it does exactly depends on flags.
	*/

	F_SUPERDO();

	/* IF FF_Draw_Object isn't set, we shouldn't draw anything. Feelin  just
	wanted to update the frame or something like that. */

	if (Msg->Flags & FF_Draw_Update) // called from our input method
	{
		if (LOD->sx || LOD->sy)
		{
			_BPen(_area_pens[FV_Pen_Shine]);
			IGRAPHICS ScrollRaster(rp,LOD->sx,LOD->sy,_area_cx,_area_cy,_area_cx2,_area_cy2);
			_BPen(_area_pens[FV_Pen_Dark]);
			LOD->sx = 0;
			LOD->sy = 0;
		}
		else
		{
			_APen(_area_pens[FV_Pen_Shadow]);
			_Plot(LOD->x,LOD->y);
		}
	}
	else if (Msg->Flags & FF_Draw_Object)
	{
		_APen(_area_pens[FV_Pen_Shine]);
		_Boxf(_area_cx,_area_cy,_area_cx2,_area_cy2);
	}
}
//+
///mHandleEvent
/*
in mSetup() we said that we want get a  message  if  mousebuttons  or  keys
pressed so we have to define the input-handler

Note :

	This is really a good example, because it  shows  how  to  use  critical
	events carefully:

	FF_EVENT_MOTION is only needed when left-mousebutton is pressed,  so  we
	dont  request  this  until  we  get  a select down message and we reject
	FF_EVENT_MOTION immeditly after we get a select up message.

*/

F_METHODM(bits32,mHandleEvent,FS_Widget_HandleEvent)
{
	#define _between(a,x,b) ((x) >= (a) && (x) <= (b))
	#define _isinobject(x,y) (_between(_area_cx,(x),_area_cx2) && _between(_area_cy,(y),_area_cy2))

/*
Note on Arrows handling :

If you don't handle arrows return 0, this will allow Window object to  cycle
through  its  chain using arrows instead of tabulations (more confortable hu
?), else return FF_HandleEvent_Eat as usual. */

	struct LocalObjectData *LOD = F_LOD(Class,Obj);
	FEvent *fev = Msg->Event;

	if (fev->Key)
	{
		switch (fev->Key)
		{
			case FV_KEY_LEFT:  LOD->sx = -1; break;
			case FV_KEY_RIGHT: LOD->sx =  1; break;
			case FV_KEY_UP:    LOD->sy = -1; break;
			case FV_KEY_DOWN:  LOD->sy =  1; break;
			default:           return NULL;
		}

		IFEELIN F_Draw(Obj,FF_Draw_Update);

		return FF_HandleEvent_Eat; // Forbid arrow cycling, because *WE* handle key events.
	}
	else if (fev->Class == FF_EVENT_BUTTON)
	{
		if (fev->Code == FV_EVENT_BUTTON_SELECT && FF_EVENT_BUTTON_DOWN & fev->Flags)
		{
			if (_isinobject(fev->MouseX,fev->MouseY))
			{
				LOD->x = fev->MouseX;
				LOD->y = fev->MouseY;
				IFEELIN F_Draw(Obj,FF_Draw_Update);

				// Only request FF_EVENT_MOTION if we realy need it
				
				IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,FF_EVENT_MOTION,0);

				return FF_HandleEvent_Eat;
			}
		}
		else
		{
			// Reject FF_EVENT_MOTION because lmb is no longer pressed

			IFEELIN F_Do(Obj,FM_Widget_ModifyEvents,0,FF_EVENT_MOTION);
		}
	}
	else if (fev->Class == FF_EVENT_MOTION)
	{
		if (_isinobject(fev->MouseX,fev->MouseY))
		{
			LOD->x = fev->MouseX;
			LOD->y = fev->MouseY;

			IFEELIN F_Draw(Obj,FF_Draw_Update);

			return FF_HandleEvent_Eat;
		}
	}
	
	return 0;
}
//+

/// Main
int main(void)
{
	STATIC F_METHODS_ARRAY =
	{
		F_METHODS_OVERRIDE_STATIC(mNew,         FM_New),
		F_METHODS_OVERRIDE_STATIC(mSetup,       FM_Element_Setup),
		F_METHODS_OVERRIDE_STATIC(mCleanup,     FM_Element_Cleanup),
		F_METHODS_OVERRIDE_STATIC(mAskMinMax,   FM_Area_AskMinMax),
		F_METHODS_OVERRIDE_STATIC(mDraw,        FM_Area_Draw),
		F_METHODS_OVERRIDE_STATIC(mHandleEvent, FM_Widget_HandleEvent),

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
		/* Create the new custom class with a call to F_CreateClassA().

		This  function  returns  a  feelinClass  structure.  You  must  use
		Class->Name  to  create instance of your custom class. This Name is
		unique and made by F_CreateClassA() when FA_Class_Name is NULL. */

		FClass *cc = IFEELIN F_CreateClassA(NULL,F_TAGS_PTR);

		if (cc)
		{
			FObject app,win;

			app = AppObject,
				FA_Application_Title, "demo_Class1",
				FA_Application_Version, "$VER: Class1 02.00 (2005/07/22)",
				FA_Application_Copyright, "© 2000-2005 Olivier LAVIALE",
				FA_Application_Author, "Olivier LAVIALE - gofromiel@gofromiel.com",
				FA_Application_Description, "My first subclass",
				FA_Application_Base, "DEMOCLASS1",

				Child, win = WindowObject,
					FA_Element_Id, "win",
					FA_Element_Persist, "width height",
					FA_Window_Title, "My first subclass",
					FA_Window_Open, TRUE,

					Child, VGroup,
						Child, TextObject,
							FA_Element_Class, "textinfo",
							FA_Element_Style, "height: auto",
							//FA_Widget_SetMax, FV_Widget_SetHeight,
							FA_Widget_Chainable, FALSE,
							FA_Text_Contents, "<align=center><i>Paint</i> with <b>mouse</b>,<br><i>Scroll</i> with <b>cursor keys</b>.",
							End,

						Child, IFEELIN F_NewObj(cc->Name,
							FA_Element_Style, "border-frame: win-in",
							TAG_DONE),
					End,
				End,
			End;

			if (app != NULL)
			{
				IFEELIN F_Do(win,FM_Notify, FA_Window_CloseRequest,TRUE, app,FM_Application_Shutdown,0);
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
