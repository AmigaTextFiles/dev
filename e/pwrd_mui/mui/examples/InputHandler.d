OPT MUI

MODULE 'devices/timer','lib/amiga','libraries/mui'


/* Instance Data */

OBJECT MyData
	port:PTR TO MsgPort,
	req:PTR TO TimeRequest,
	ihnode:MUI_InputHandlerNode,
	index:LONG


/* Attributes and methods for the custom class */

CONST	MUISERIALNR_STUNTZI=1,
		TAGBASE_STUNTZI=TAG_USER | MUISERIALNR_STUNTZI << 16,
		MUIM_Class5_Trigger=TAGBASE_STUNTZI | $0001


/* IO macros */

#define IO_SIGBIT(req)  (req.IO.MN.ReplyPort.SigBit)
#define IO_SIGMASK(req) (1<<IO_SIGBIT(req))


/* Some strings to display */

DEF	LifeOfBrian=[
        'Cheer up, Brian. You know what they say.',
        'Some things in life are bad,',
        'They can really make you mad.',
        'Other things just make you swear and curse.',
        'When you\are chewing on life\as grissle,',
        'Don\at grumble, give a whistle.',
        'And this\all help things turn out for the best,',
        'And...',
        'Always look on the bright side of life',
        'Always look on the light side of life',
        'If life seems jolly rotten,',
        'There\as something you\ave forgotten,',
        'And that\as to laugh, and smile, and dance, and sing.',
        'When you\are feeling in the dumps,',
        'Don\at be silly chumps,',
        'Just purse your lips and whistle, that\as the thing.',
        'And...',
        'Always look on the bright side of life, come on!',
        'Always look on the right side of life',
        'For life is quite absurd,',
        'And death\as the final word.',
        'You must always face the curtain with a bow.',
        'Forget about your sin,',
        'Give the audience a grin.',
        'Enjoy it, it\as your last chance anyhow,',
        'So...',
        'Always look on the bright side of death',
        'Just before you draw your terminal breath.',
        'Life\as a piece of shit,',
        'When you look at it.',
        'Life\as a laugh, and death\as a joke, it\as true.',
        'You\all see it\as all a show,',
        'Keep \aem laughing as you go,',
        'Just remember that the last laugh is on you.',
        'And...',
        'Always look on the bright side of life !',
        '...',
        '*** THE END ***',
        '',
        NIL]



/***************************************************************************/
/* Here is the beginning of our new class...                               */
/***************************************************************************/


PROC mNew(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO Msg)(ULONG)
	DEF	data:PTR TO MyData

	IFN obj:=DoSuperMethodA(cl,obj,msg) THEN RETURN 0

	data := INST_DATA(cl,obj)

	IF data.port := CreateMsgPort()
		IF data.req := CreateIORequest(data.port,SIZEOF_TimeRequest)
			IFN OpenDevice(TIMERNAME,UNIT_VBLANK,data.req,0)

				data.ihnode.Object  := obj
				data.ihnode.Signals := IO_SIGMASK(data.req)
				data.ihnode.Method  := MUIM_Class5_Trigger
				data.ihnode.Flags   := 0

				data.index := 0

				RETURN obj
			ENDIF
		ENDIF
	ENDIF

	CoerceMethodA(cl,obj,OM_DISPOSE)
ENDPROC 0


PROC mDispose(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO Msg)(ULONG)
	DEF	data:PTR TO MyData

	data := INST_DATA(cl,obj)

	IF data.req
		IF data.req.IO.Device THEN CloseDevice(data.req)
		DeleteIORequest(data.req)
	ENDIF

	IF data.port THEN DeleteMsgPort(data.port)
ENDPROC DoSuperMethodA(cl,obj,msg)


PROC mSetup(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO Msg)(ULONG)
	DEF	data:PTR TO MyData

	data := INST_DATA(cl,obj)

	IFN DoSuperMethodA(cl,obj,msg) THEN RETURN FALSE

	data.req.IO.Command := TR_ADDREQUEST
	data.req.Time.Secs  := 1
	data.req.Time.Micro := 0
	SendIO(data.req)

	DoMethod(_app(obj),MUIM_Application_AddInputHandler,data.ihnode)

ENDPROC TRUE

PROC mCleanup(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO Msg)(ULONG)
	DEF	data:PTR TO MyData

	data := INST_DATA(cl,obj)

	DoMethod(_app(obj),MUIM_Application_RemInputHandler,data.ihnode)

	IFN CheckIO(data.req) THEN AbortIO(data.req)
	WaitIO(data.req)

ENDPROC DoSuperMethodA(cl,obj,msg)

PROC mTrigger(cl:PTR TO IClass,obj:PTR TO _Object,msg:PTR TO Msg)(ULONG)
	DEF	data:PTR TO MyData

	data := INST_DATA(cl,obj)

	IF CheckIO(data.req)
		WaitIO(data.req)
		data.req.IO.Command := TR_ADDREQUEST
		data.req.Time.Secs  := 1
		data.req.Time.Micro := 0
		SendIO(data.req)

		set(obj,MUIA_Text_Contents,LifeOfBrian[data.index])

		IFN LifeOfBrian[++data.index] THEN data.index := 0

		RETURN TRUE
	ENDIF

ENDPROC FALSE


/*
** Here comes the dispatcher for our custom class.
*/

PROC MyDispatcher(cl:PTR TO IClass IN a0,obj IN a2,msg:PTR TO Msg IN a1)(LONG)

	SELECT msg.MethodID
	CASE OM_NEW              ; RETURN mNew    (cl,obj,msg)
	CASE OM_DISPOSE          ; RETURN mDispose(cl,obj,msg)
	CASE MUIM_Setup          ; RETURN mSetup  (cl,obj,msg)
	CASE MUIM_Cleanup        ; RETURN mCleanup(cl,obj,msg)
	CASE MUIM_Class5_Trigger ; RETURN mTrigger(cl,obj,msg)
	ENDSELECT

ENDPROC DoSuperMethodA(cl,obj,msg)


/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main()
	DEF	app:PTR TO _Object,window:PTR TO _Object,MyObj:PTR TO _Object
	DEF	mcc:PTR TO MUI_CustomClass
	DEFUL	sigs

	/* Create the new custom class with a call to MUI_CreateCustomClass(). */
	/* Caution: This function returns not a struct IClass, but a           */
	/* struct MUI_CustomClass which contains a struct IClass to be         */
	/* used with NewObject() calls.                                        */
	/* Note well: MUI creates the dispatcher hook for you, you may         */
	/* *not* use its h_Data field! If you need custom data, use the        */
	/* cl_UserData of the IClass structure!                                */

	IFN mcc := MUI_CreateCustomClass(NIL,MUIC_Text,NIL,SIZEOF_MyData,&MyDispatcher) THEN Raise('Could not create custom class.')

	app := ApplicationObject,
		MUIA_Application_Title      , 'Class5',
		MUIA_Application_Version    , '$VER: Class5 19.5 (12.02.97)',
		MUIA_Application_Copyright  , '©1993, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Demonstrate the use of custom classes.',
		MUIA_Application_Base       , 'Class5',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Input Handler Class',
			MUIA_Window_ID   , "CLS5",
			WindowContents, VGroup,
				Child, TextObject,
					TextFrame,
					MUIA_Background, MUII_TextBack,
					MUIA_Text_Contents, '\ecDemonstration of a class that reacts on\nevents (here: timer signals) automatically.',
				End,
				Child, MyObj := NewObject(mcc.Class,NIL,
					TextFrame,
					MUIA_Background, MUII_BACKGROUND,
					MUIA_Text_PreParse, '\ec',
				TAG_DONE),
			End,
		End,
	End

	IFN app THEN Raise('Failed to create Application.')

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

	WHILE (DoMethod(app,MUIM_Application_NewInput,&sigs) <> MUIV_Application_ReturnID_Quit)
		IF sigs THEN sigs:=Wait(sigs)
	ENDWHILE

	set(window,MUIA_Window_Open,FALSE)

EXCEPTDO
/*
** Shut down...
*/
	IF app THEN MUI_DisposeObject(app)     /* dispose all objects. */
	IF mcc THEN MUI_DeleteCustomClass(mcc) /* delete the custom class. */
	IF exception THEN PrintF('\s\n',exception)
ENDPROC
