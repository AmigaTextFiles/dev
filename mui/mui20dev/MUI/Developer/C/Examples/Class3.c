#include "demo.h"


/***************************************************************************/
/* Here is the beginning of our simple new class...                        */
/***************************************************************************/

/*
** This is an example for the simplest possible MUI class. It's just some
** kind of custom image and supports only two methods:
** MUIM_AskMinMax and MUIM_Draw.
*/

/*
** This is the instance data for our custom class.
** Since it's a very simple class, it contains just a dummy entry.
*/

struct Data
{
	int x,y,sx,sy;
};


/*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*/

SAVEDS ULONG mAskMinMax(struct IClass *cl,Object *obj,struct MUIP_AskMinMax *msg)
{
	/*
	** let our superclass first fill in what it thinks about sizes.
	** this will e.g. add the size of frame and inner spacing.
	*/

	DoSuperMethodA(cl,obj,msg);

	/*
	** now add the values specific to our object. note that we
	** indeed need to *add* these values, not just set them!
	*/

	msg->MinMaxInfo->MinWidth  += 100;
	msg->MinMaxInfo->DefWidth  += 120;
	msg->MinMaxInfo->MaxWidth  += 500;

	msg->MinMaxInfo->MinHeight += 40;
	msg->MinMaxInfo->DefHeight += 90;
	msg->MinMaxInfo->MaxHeight += 300;

	return(0);
}


/*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*/

SAVEDS ULONG mDraw(struct IClass *cl,Object *obj,struct MUIP_Draw *msg)
{
	struct Data *data = INST_DATA(cl,obj);

	/*
	** let our superclass draw itself first, area class would
	** e.g. draw the frame and clear the whole region. What
	** it does exactly depends on msg->flags.
	*/

	DoSuperMethodA(cl,obj,msg);

	/*
	** if MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
	** MUI just wanted to update the frame or something like that.
	*/

	if (msg->flags & MADF_DRAWUPDATE) /* called from our input method */
	{
		if (data->sx || data->sy)
		{
			SetBPen(_rp(obj),_dri(obj)->dri_Pens[SHINEPEN]);
			ScrollRaster(_rp(obj),data->sx,data->sy,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj));
			SetBPen(_rp(obj),0);
			data->sx = 0;
			data->sy = 0;
		}
		else
		{
			SetAPen(_rp(obj),_dri(obj)->dri_Pens[SHADOWPEN]);
			WritePixel(_rp(obj),data->x,data->y);
		}
	}
	else if (msg->flags & MADF_DRAWOBJECT)
	{
		SetAPen(_rp(obj),_dri(obj)->dri_Pens[SHINEPEN]);
		RectFill(_rp(obj),_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj));
	}

	return(0);
}


SAVEDS ULONG mSetup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
	if (!(DoSuperMethodA(cl,obj,msg)))
		return(FALSE);

	MUI_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY);

	return(TRUE);
}


SAVEDS ULONG mCleanup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
	MUI_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY);
	return(DoSuperMethodA(cl,obj,msg));
}


SAVEDS ULONG mHandleInput(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
	#define _between(a,x,b) ((x)>=(a) && (x)<=(b))
	#define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) && _between(_mtop(obj),(y),_mbottom(obj)))

	struct Data *data = INST_DATA(cl,obj);

	if (msg->muikey)
	{
		switch (msg->muikey)
		{
			case MUIKEY_LEFT : data->sx=-1; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
			case MUIKEY_RIGHT: data->sx= 1; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
			case MUIKEY_UP   : data->sy=-1; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
			case MUIKEY_DOWN : data->sy= 1; MUI_Redraw(obj,MADF_DRAWUPDATE); break;
		}
	}

	if (msg->imsg)
	{
		switch (msg->imsg->Class)
		{
			case IDCMP_MOUSEBUTTONS:
			{
				if (msg->imsg->Code==SELECTDOWN)
				{
					if (_isinobject(msg->imsg->MouseX,msg->imsg->MouseY))
					{
						data->x = msg->imsg->MouseX;
						data->y = msg->imsg->MouseY;
						MUI_Redraw(obj,MADF_DRAWUPDATE);
						MUI_RequestIDCMP(obj,IDCMP_MOUSEMOVE);
					}
				}
				else
					MUI_RejectIDCMP(obj,IDCMP_MOUSEMOVE);
			}
			break;

			case IDCMP_MOUSEMOVE:
			{
				if (_isinobject(msg->imsg->MouseX,msg->imsg->MouseY))
				{
					data->x = msg->imsg->MouseX;
					data->y = msg->imsg->MouseY;
					MUI_Redraw(obj,MADF_DRAWUPDATE);
				}
			}
			break;
		}
	}

	return(0);
}


/*
** Here comes the dispatcher for our custom class. We only need to
** care about MUIM_AskMinMax and MUIM_Draw in this simple case.
** Unknown/unused methods are passed to the superclass immediately.
*/

SAVEDS ASM ULONG MyDispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)
{
	switch (msg->MethodID)
	{
		case MUIM_AskMinMax  : return(mAskMinMax  (cl,obj,(APTR)msg));
		case MUIM_Draw       : return(mDraw       (cl,obj,(APTR)msg));
		case MUIM_HandleInput: return(mHandleInput(cl,obj,(APTR)msg));
		case MUIM_Setup      : return(mSetup      (cl,obj,(APTR)msg));
		case MUIM_Cleanup    : return(mCleanup    (cl,obj,(APTR)msg));
	}

	return(DoSuperMethodA(cl,obj,msg));
}



/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

int main(int argc,char *argv[])
{
	APTR app,window,MyObj,SuperClass;
	struct IClass *MyClass;
	ULONG signals;
	BOOL running = TRUE;

	init();

	/* Get a pointer to the superclass. MUI will lock this */
	/* and prevent it from being flushed during you hold   */
	/* the pointer. When you're done, you have to call     */
	/* MUI_FreeClass() to release this lock.               */

	if (!(SuperClass=MUI_GetClass(MUIC_Area)))
		fail(NULL,"Superclass for the new class not found.");

	/* create the new class */
	if (!(MyClass = MakeClass(NULL,NULL,SuperClass,sizeof(struct Data),0)))
	{
		MUI_FreeClass(SuperClass);
		fail(NULL,"Failed to create class.");
	}

	/* set the dispatcher for the new class */
	MyClass->cl_Dispatcher.h_Entry    = (APTR)MyDispatcher;
	MyClass->cl_Dispatcher.h_SubEntry = NULL;
	MyClass->cl_Dispatcher.h_Data     = NULL;

	app = ApplicationObject,
		MUIA_Application_Title      , "Class3",
		MUIA_Application_Version    , "$VER: Class3 1.0 (01.12.93)",
		MUIA_Application_Copyright  , "©1993, Stefan Stuntz",
		MUIA_Application_Author     , "Stefan Stuntz",
		MUIA_Application_Description, "Demonstrate the use of custom classes.",
		MUIA_Application_Base       , "CLASS3",

		SubWindow, window = WindowObject,
			MUIA_Window_Title, "A rather complex custom class",
			MUIA_Window_ID   , MAKE_ID('C','L','S','3'),
			WindowContents, VGroup,

				Child, TextObject,
					TextFrame,
					MUIA_Background, MUII_TextBack,
					MUIA_Text_Contents, "\33cPaint with mouse,\nscroll with cursor keys.", 
					End,

				Child, MyObj = NewObject(MyClass,NULL,
					TextFrame,
					TAG_DONE),

				End,

			End,
		End;

	if (!app)
		fail(app,"Failed to create Application.");

	set(window,MUIA_Window_DefaultObject, MyObj);

	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);



/*
** Input loop...
*/

	set(window,MUIA_Window_Open,TRUE);

	while (running)
	{
		switch (DoMethod(app,MUIM_Application_Input,&signals))
		{
			case MUIV_Application_ReturnID_Quit:
				running = FALSE;
				break;
		}

		if (running && signals) Wait(signals);
	}

	set(window,MUIA_Window_Open,FALSE);


/*
** Shut down...
*/

	MUI_DisposeObject(app);     /* dispose all objects. */
	FreeClass(MyClass);         /* free our custom class. */
	MUI_FreeClass(SuperClass); /* release super class pointer. */
	fail(NULL,NULL);            /* exit, app is already disposed. */
}
