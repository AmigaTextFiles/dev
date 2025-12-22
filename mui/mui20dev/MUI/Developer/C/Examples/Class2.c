#include "demo.h"


/***************************************************************************/
/* Here is the beginning of our simple new class...                        */
/***************************************************************************/

/*
** This class is the same as within Class1.c except that it features
** a pen attribute.
*/

struct MyData
{
	LONG pen;
};


#define MYATTR_PEN 0x8022   /* tag value for the new attribute.            */
                            /* use 0x8000 | <yourregnumber> as upper word! */


SAVEDS ULONG mNew(struct IClass *cl,Object *obj,Msg msg)
{
	struct MyData *data;

	if (!(obj = (Object *)DoSuperMethodA(cl,obj,msg)))
		return(0);

	data = INST_DATA(cl,obj);

	/* parse initial taglist */

	data->pen = GetTagData(MYATTR_PEN, TEXTPEN, ((struct opSet *)msg)->ops_AttrList);

	return((ULONG)obj);
}



SAVEDS ULONG mDispose(struct IClass *cl,Object *obj,Msg msg)
{
	/* OM_NEW didnt allocates something, just do nothing here... */
	return(DoSuperMethodA(cl,obj,msg));
}


/*
** OM_SET method, we need to see if someone changed the pen attribute.
*/

SAVEDS ULONG mSet(struct IClass *cl,Object *obj,Msg msg)
{
	struct MyData *data = INST_DATA(cl,obj);
	struct TagItem *tags,*tag;

	for (tags=((struct opSet *)msg)->ops_AttrList;tag=NextTagItem(&tags);)
	{
		switch (tag->ti_Tag)
		{
			case MYATTR_PEN:
				data->pen = tag->ti_Data;         /* set the new value */
				MUI_Redraw(obj,MADF_DRAWOBJECT);  /* redraw ourselves completely */
				break;
		}
	}

	return(DoSuperMethodA(cl,obj,msg));
}


/*
** OM_GET method, see if someone wants to read the color.
*/

static ULONG mGet(struct IClass *cl,Object *obj,Msg msg)
{
	struct MyData *data = INST_DATA(cl,obj);
	ULONG *store = ((struct opGet *)msg)->opg_Storage;

	switch (((struct opGet *)msg)->opg_AttrID)
	{
		case MYATTR_PEN: *store = data->pen; return(TRUE);
	}

	return(DoSuperMethodA(cl,obj,msg));
}


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
	struct MyData *data = INST_DATA(cl,obj);
	int i;

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

	if (!(msg->flags & MADF_DRAWOBJECT))
		return(0);

	/*
	** ok, everything ready to render...
	*/

	SetAPen(_rp(obj),_dri(obj)->dri_Pens[data->pen]);

	for (i=_mleft(obj);i<=_mright(obj);i+=5)
	{
		Move(_rp(obj),_mleft(obj),_mbottom(obj));
		Draw(_rp(obj),i,_mtop(obj));
		Move(_rp(obj),_mright(obj),_mbottom(obj));
		Draw(_rp(obj),i,_mtop(obj));
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
		case OM_NEW        : return(mNew      (cl,obj,(APTR)msg));
		case OM_DISPOSE    : return(mDispose  (cl,obj,(APTR)msg));
		case OM_SET        : return(mSet      (cl,obj,(APTR)msg));
		case OM_GET        : return(mGet      (cl,obj,(APTR)msg));
		case MUIM_AskMinMax: return(mAskMinMax(cl,obj,(APTR)msg));
		case MUIM_Draw     : return(mDraw     (cl,obj,(APTR)msg));
	}

	return(DoSuperMethodA(cl,obj,msg));
}



/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

int main(int argc,char *argv[])
{
	APTR app,window,MyObj,SuperClass,cycle;
	struct IClass *MyClass;
	ULONG signals;
	BOOL running = TRUE;
	static char *penarray[] =
	{
		"Detailpen",
		"Blockpen",
		"Textpen",
		"Shinepen",
		"Shadowpen",
		"Fillpen",
		NULL
	};

	init();

	/* Get a pointer to the superclass. MUI will lock this */
	/* and prevent it from being flushed during you hold   */
	/* the pointer. When you're done, you have to call     */
	/* MUI_FreeClass() to release this lock.               */

	if (!(SuperClass=MUI_GetClass(MUIC_Area)))
		fail(NULL,"Superclass for the new class not found.");

	/* create the new class */
	if (!(MyClass = MakeClass(NULL,NULL,SuperClass,sizeof(struct MyData),0)))
	{
		MUI_FreeClass(SuperClass);
		fail(NULL,"Failed to create class.");
	}

	/* set the dispatcher for the new class */
	MyClass->cl_Dispatcher.h_Entry    = (APTR)MyDispatcher;
	MyClass->cl_Dispatcher.h_SubEntry = NULL;
	MyClass->cl_Dispatcher.h_Data     = NULL;

	app = ApplicationObject,
		MUIA_Application_Title      , "Class2",
		MUIA_Application_Version    , "$VER: Class2 1.0 (01.12.93)",
		MUIA_Application_Copyright  , "©1993, Stefan Stuntz",
		MUIA_Application_Author     , "Stefan Stuntz",
		MUIA_Application_Description, "Demonstrate the use of custom classes.",
		MUIA_Application_Base       , "CLASS2",

		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Another Custom Class",
			MUIA_Window_ID   , MAKE_ID('C','L','S','2'),
			WindowContents, VGroup,

				Child, cycle = KeyCycle(penarray,' '),

				Child, MyObj = NewObject(MyClass,NULL,
					TextFrame,
					MUIA_Background, MUII_BACKGROUND,
					TAG_DONE),

				End,

			End,
		End;

	if (!app)
		fail(app,"Failed to create Application.");

	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	DoMethod(cycle,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
		MyObj,3,MUIM_Set,MYATTR_PEN,MUIV_TriggerValue);

	set(cycle,MUIA_Cycle_Active,TEXTPEN);

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

	MUI_DisposeObject(app);      /* dispose all objects. */
	FreeClass(MyClass);          /* free our custom class. */
	MUI_FreeClass(SuperClass);  /* release super class pointer. */
	fail(NULL,NULL);             /* exit, app is already disposed. */
}
