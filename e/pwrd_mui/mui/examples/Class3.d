/*
** Demosource on how to use customclasses in D.
** Based on the C example 'Class3.c' by Stafan Stuntz.
** Translated to E by Sven Steiniger
** Translated to D by Martin <MarK> Kuchinka
*/

OPT	OPTIMIZE

MODULE	'muimaster',
			'libraries/mui',
			'intuition/classes',
			'intuition/classusr',
			'intuition/screens',
			'intuition/intuition',
			'utility/tagitem',
			'lib/amiga'

/***************************************************************************/
/* Here is the beginning of our simple new class...                        */
/***************************************************************************/

/*
** This is the instance data for our custom class.
*/
 
OBJECT mydata
	x,y,sx,sy

/*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*/

PROC mAskMinMax(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO MUIP_AskMinMax)(L)

/*
** let our superclass first fill in what it thinks about sizes.
** this will e.g. add the size of frame and inner spacing.
*/

	DoSuperMethodA(cl,obj,msg)

/*
** now add the values specific to our object. note that we
** indeed need TO *add* these values, not just set them!
*/

	msg.MinMaxInfo.MinWidth+=100
	msg.MinMaxInfo.DefWidth+=120
	msg.MinMaxInfo.MaxWidth+=500

	msg.MinMaxInfo.MinHeight+=40
	msg.MinMaxInfo.DefHeight+=90
	msg.MinMaxInfo.MaxHeight+=300

ENDPROC 0


/*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*/

PROC mDraw(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO MUIP_Draw)(L)
	DEF	data:PTR TO mydata

	data:=INST_DATA(cl,obj)

/*
** let our superclass draw itself first, area class would
** e.g. draw the frame and clear the whole region. What
** it does exactly depends on msg.flags.
**
** Note: You *must* call the super method prior to do
** anything else, otherwise msg.flags will not be set
** properly !!!
*/

	DoSuperMethodA(cl,obj,msg)

/*
** IF MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
** MUI just wanted to update the frame or something like that.
*/

	IF msg.flags & MADF_DRAWUPDATE  /* called from our input method */
		IF data.sx|data.sy
			SetBPen(_rp(obj),_dri(obj).Pens[SHINEPEN])
			ScrollRaster(_rp(obj),data.sx,data.sy,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
			SetBPen(_rp(obj),0)
			data.sx:=0
			data.sy:=0
		ELSE
			SetAPen(_rp(obj),_dri(obj).Pens[SHADOWPEN])
			WritePixel(_rp(obj),data.x,data.y)
		ENDIF
	ELSEIF msg.flags & MADF_DRAWOBJECT
		SetAPen(_rp(obj),_dri(obj).Pens[SHINEPEN])
		RectFill(_rp(obj),_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
	ENDIF
ENDPROC 0


PROC mSetup(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO MUIP_HandleInput)(L)

	IFN DoSuperMethodA(cl,obj,msg) THEN RETURN FALSE
	MUI_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS | IDCMP_RAWKEY)

ENDPROC MUI_TRUE


PROC mCleanup(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO MUIP_HandleInput)(L)

	MUI_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS | IDCMP_RAWKEY)

ENDPROC DoSuperMethodA(cl,obj,msg)
 

/* in mSetup() we said that we want get a message IF mousebuttons or keys pressed
** so we have to define the input-handler
** Note : this is really a good example, because it shows how to use critical events
**        carefully:
**        IDCMP_MOUSEMOVE is only needed when left-mousebutton is pressed, so
**        we dont request this until we get a SELECTDOWN-message and we reject
**        IDCMP_MOUSEMOVE immeditly after we get a SELECTUP-message
*/

PROC mHandleInput(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO MUIP_HandleInput)(L)
#define _between(a,x,b) (((x)>=(a)) AND ((x)<=(b)))
#define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) AND _between(_mtop(obj),(y),_bottom(obj)))

	DEF	data:PTR TO mydata

	data:=INST_DATA(cl,obj)

	SELECT msg.muikey
	CASE MUIKEY_LEFT   ; data.sx:=-1; MUI_Redraw(obj,MADF_DRAWUPDATE)
	CASE MUIKEY_RIGHT  ; data.sx:= 1; MUI_Redraw(obj,MADF_DRAWUPDATE)
	CASE MUIKEY_UP     ; data.sy:=-1; MUI_Redraw(obj,MADF_DRAWUPDATE)
	CASE MUIKEY_DOWN   ; data.sy:= 1; MUI_Redraw(obj,MADF_DRAWUPDATE)
	ENDSELECT

	IF msg.imsg
		SELECT msg.imsg.Class
		CASE IDCMP_MOUSEBUTTONS
			IF msg.imsg.Code=SELECTDOWN
				IF _isinobject(msg.imsg.MouseX,msg.imsg.MouseY)
					data.x:=msg.imsg.MouseX
					data.y:=msg.imsg.MouseY
					MUI_Redraw(obj,MADF_DRAWUPDATE)

				    -> only request IDCMP_MOUSEMOVE if we realy need it
					MUI_RequestIDCMP(obj,IDCMP_MOUSEMOVE)
				ENDIF
			ELSE
				-> reject IDCMP_MOUSEMOVE because THEN lmb is no longer pressed
				MUI_RejectIDCMP(obj,IDCMP_MOUSEMOVE)
			ENDIF
		CASE IDCMP_MOUSEMOVE
			IF _isinobject(msg.imsg.MouseX,msg.imsg.MouseY)
				data.x:=msg.imsg.MouseX
				data.y:=msg.imsg.MouseY
				MUI_Redraw(obj,MADF_DRAWUPDATE)
			ENDIF
		ENDSELECT
	ENDIF

ENDPROC DoSuperMethodA(cl,obj,msg)

/*
** Here comes the dispatcher for our custom class.
** Unknown/unused methods are passed to the superclass immediately.
*/

PROC MyDispatcher(cl:PTR TO IClass IN a0,obj IN a2,msg:PTR TO Msg IN a1)(LONG)

	SELECT msg.MethodID
	CASE MUIM_AskMinMax    ;  RETURN mAskMinMax  (cl,obj,msg)
	CASE MUIM_Draw         ;  RETURN mDraw       (cl,obj,msg)
	CASE MUIM_HandleInput  ;  RETURN mHandleInput(cl,obj,msg)
	CASE MUIM_Setup        ;  RETURN mSetup      (cl,obj,msg)
	CASE MUIM_Cleanup      ;  RETURN mCleanup    (cl,obj,msg)
	ENDSELECT

ENDPROC DoSuperMethodA(cl,obj,msg)

DEF	MUIMasterBase

/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main()
	DEF	app=NIL,window,myobj,
			mcc=NIL:PTR TO MUI_CustomClass,
			sigs=0

	IFN MUIMasterBase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN) THEN
		Raise('Failed to open muimaster.library')


/* Create the new custom class with a call TO MUI_CreateCustomClass(). */
/* Caution: This function returns not a struct IClass, but a           */
/* struct MUI_CustomClass which contains a struct IClass to be         */
/* used with NewObject() calls.                                        */
/* Note well: MUI creates the dispatcher hook for you, you may         */
/* *not* use its h_Data field! If you need custom data, use the        */
/* cl_UserData OF the IClass structure!                                */

	IFN mcc:=MUI_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF_mydata,&MyDispatcher) THEN
		Raise('Could not create custom class.')

	app:=ApplicationObject,
		MUIA_Application_Title,      'Class3',
		MUIA_Application_Version,    '$VER: Class3 12.9 (21.11.95)',
		MUIA_Application_Copyright,  '©1995, Stefan Stuntz',
		MUIA_Application_Author,     'Stefan Stuntz',
		MUIA_Application_Description,'Demonstrate the use OF custom classes.',
		MUIA_Application_Base,       'CLASS3',
		SubWindow, window:=WindowObject,
			MUIA_Window_Title,'A rather complex custom class',
			MUIA_Window_ID,   "CLS3",
			WindowContents,VGroup,
				Child,TextObject,
					TextFrame,
					MUIA_Background,MUII_TextBack,
					MUIA_Text_Contents, '\ecPaint with mouse,\nscroll with cursor keys.',
				End,
				Child,myobj:=NewObject(mcc.Class,NIL,TextFrame,TAG_DONE),
			End,
		End,
	End

	IF app=NIL THEN Raise('Failed to create Application')

	set(window,MUIA_Window_DefaultObject,myobj)

	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit)


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

	set(window,MUIA_Window_Open,MUI_TRUE)

	WHILEN DoMethodA(app,[MUIM_Application_NewInput,&sigs])=MUIV_Application_ReturnID_Quit
		IF sigs THEN sigs:=Wait(sigs)
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
