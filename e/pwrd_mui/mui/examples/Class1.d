/*
** Demosource on how to use customclasses in D.
** Based on the C example 'Class1.c'.
** Translated to E by Jan Hendrik Schulz
** Translated to D by Martin <MarK> Kuchinka
*/

MODULE	'muimaster',
			'libraries/mui',
			'lib/amiga',
			'intuition/classes',
			'intuition/classusr',
			'intuition/screens',
			'intuition/intuition',
			'utility/tagitem'

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

OBJECT mydata
    dummy:LONG


/*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*/

PROC AskMinMax(cl:PTR TO IClass,obj,msg:PTR TO MUIP_AskMinMax)

	/*
	** let our superclass first fill in what it thinks about sizes.
	** this will e.g. add the size of frame and inner spacing.
	*/

	DoSuperMethodA(cl,obj,msg)

	/*
	** now add the values specific to our object. note that we
	** indeed need to *add* these values, not just set them!
	*/

	msg.MinMaxInfo.MinWidth += 100
	msg.MinMaxInfo.DefWidth += 120
	msg.MinMaxInfo.MaxWidth += 500

	msg.MinMaxInfo.MinHeight += 40
	msg.MinMaxInfo.DefHeight += 90
	msg.MinMaxInfo.MaxHeight += 300

ENDPROC


/*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*/

-> Note2: The following 'obj' isn't really a 'PTR TO mydata',
->        but obj must be a 'PTR TO <someobject>' to use the
->        macros like _mleft() etc. (see comments in mui.e)
->        I hope Wouter will change this in a futur version
->        of E !

PROC mDraw(cl:PTR TO IClass,obj:PTR TO mydata,msg:PTR TO MUIP_Draw)

	DEF i

	/*
	** let our superclass draw itself first, area class would
	** e.g. draw the frame and clear the whole region. What
	** it does exactly depends on msg.flags.
	*/

	DoSuperMethodA(cl,obj,msg)

	/*
	** if MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
	** MUI just wanted to update the frame or something like that.
	*/

	IFN msg.flags & MADF_DRAWOBJECT THEN RETURN

	/*
	** ok, everything ready to render...
	*/

	SetAPen(_rp(obj),_dri(obj).Pens[TEXTPEN])

	FOR i:=_mleft(obj) TO _mright(obj) STEP 5
		Move(_rp(obj),_mleft(obj),_mbottom(obj))
		Draw(_rp(obj),i,_mtop(obj))
		Move(_rp(obj),_mright(obj),_mbottom(obj))
		Draw(_rp(obj),i,_mtop(obj))
	ENDFOR

ENDPROC


/*
** Here comes the dispatcher for our custom class. We only need to
** care about MUIM_AskMinMax and MUIM_Draw in this simple case.
** Unknown/unused methods are passed to the superclass immediately.
*/

PROC MyDispatcher(cl:PTR TO IClass IN a0,obj IN a2,msg:PTR TO Msg IN a1)(LONG)

	SELECT msg.MethodID
	CASE MUIM_AskMinMax; RETURN AskMinMax(cl,obj,msg)
	CASE MUIM_Draw     ; RETURN mDraw    (cl,obj,msg)
	ENDSELECT

	RETURN DoSuperMethodA(cl,obj,msg)
ENDPROC



/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/
DEF	MUIMasterBase

PROC main()

	DEF	app=NIL,window,myobj,sigs=0,
			mcc=NIL:PTR TO MUI_CustomClass

	IFN MUIMasterBase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN) THEN
		Raise('Failed to open muimaster.library')

	/* Create the new custom class with a call to MUI_CreateCustomClass().*/

	IFN mcc:=MUI_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF_mydata,&MyDispatcher) THEN
		Raise('Could not create custom class.')

	app:=ApplicationObject,
		MUIA_Application_Title      , 'Class1',
		MUIA_Application_Version    , '$VER: Class1 12.9E (26.11.95)',
		MUIA_Application_Copyright  , '©1993, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz & JHS',
		MUIA_Application_Description, 'Demonstrate the use of custom classes.',
		MUIA_Application_Base       , 'CLASS1',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'A Simple Custom Class',
			MUIA_Window_ID   , "CLS1",
			WindowContents, VGroup,

				Child, myobj := NewObject(mcc.Class,NIL,
					TextFrame,
					MUIA_Background, MUII_BACKGROUND,
					End,
				End,
			End,
		End

	IFN app THEN Raise('Failed to create Application.')

	DoMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

	set(window,MUIA_Window_Open,MUI_TRUE)

	WHILEN DoMethodA(app,[MUIM_Application_NewInput,&sigs])=MUIV_Application_ReturnID_Quit
		IF sigs THEN sigs := Wait(sigs)
	ENDWHILE

	set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

EXCEPTDO
	IF app THEN MUI_DisposeObject(app)                /* dispose all objects. */
	IF mcc THEN MUI_DeleteCustomClass(mcc)            /* delete the custom class. */
	IF MUIMasterBase THEN CloseLibrary(MUIMasterBase) /* close library */
	IF exception THEN PrintF('\s\n',exception)
ENDPROC
