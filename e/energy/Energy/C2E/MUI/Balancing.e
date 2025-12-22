OPT OSVERSION=37
OPT PREPROCESS

MODULE	'libraries/mui',
	'muimaster',
	'dos/dos',
	'intuition/classes',
	'intuition/classusr',
	'utility/hooks',
	'utility/tagitem'

#define MAKE_ID(a,b,c,d) ( Shl(a,24) OR Shl(b,16) OR Shl(c,8) OR d )

PROC main()

DEF	app,window,sigs = 0


IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)


	app := ApplicationObject,
		MUIA_Application_Title      , 'BalanceDemo',
		MUIA_Application_Version    , '$VER: BalanceDemo 12.10 (21.11.95)',
		MUIA_Application_Copyright  , '©1995, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Show balancing groups',
		MUIA_Application_Base       , 'BALANCEDEMO',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Balancing Groups',
			MUIA_Window_ID   , MAKE_ID("B","A","L","A"),
			MUIA_Window_Width , MUIV_Window_Width_Screen(50),
			MUIA_Window_Height, MUIV_Window_Height_Screen(50),

			WindowContents, HGroup,

				Child, VGroup, GroupFrame, MUIA_Weight, 15,
					Child, RectangleObject, TextFrame, MUIA_Weight,  50, End,
					Child, RectangleObject, TextFrame, MUIA_Weight, 100, End,
					Child, BalanceObject, End,
					Child, RectangleObject, TextFrame, MUIA_Weight, 200, End,
					End,

				Child, BalanceObject, End,

				Child, VGroup,
					Child, HGroup, GroupFrame,
						Child, RectangleObject, TextFrame, MUIA_ObjectID, 123, End,
						Child, BalanceObject, End,
						Child, RectangleObject, TextFrame, MUIA_ObjectID, 456, End,
						End,
					Child, HGroup, GroupFrame,
						Child, RectangleObject, TextFrame, End,
						Child, BalanceObject, End,
						Child, RectangleObject, TextFrame, End,
						Child, BalanceObject, End,
						Child, RectangleObject, TextFrame, End,
						Child, BalanceObject, End,
						Child, RectangleObject, TextFrame, End,
						Child, BalanceObject, End,
						Child, RectangleObject, TextFrame, End,
						End,
					Child, HGroup, GroupFrame,
						Child, HGroup,
							Child, RectangleObject, TextFrame, End,
							Child, BalanceObject, End,
							Child, RectangleObject, TextFrame, End,
							End,
						Child, BalanceObject, End,
						Child, HGroup,
							Child, RectangleObject, TextFrame, End,
							Child, BalanceObject, End,
							Child, RectangleObject, TextFrame, End,
							End,
						End,
					Child, HGroup, GroupFrame,
						Child, RectangleObject, TextFrame, MUIA_Weight,  50, End,
						Child, RectangleObject, TextFrame, MUIA_Weight, 100, End,
						Child, BalanceObject, End,
						Child, RectangleObject, TextFrame, MUIA_Weight, 200, End,
						End,
					Child, HGroup, GroupFrame,
						Child, SimpleButton('Also'),
						Child, BalanceObject, End,
						Child, SimpleButton('Try'),
						Child, BalanceObject, End,
						Child, SimpleButton('Sizing'),
						Child, BalanceObject, End,
						Child, SimpleButton('With'),
						Child, BalanceObject, End,
						Child, SimpleButton('Shift'),
						End,
					End,
				End,
			End,

		End

	IF app=NIL THEN fail(app,'Failed to create Application.')

	doMethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

	set(window,MUIA_Window_Open,TRUE)

		WHILE doMethod(app,[MUIM_Application_NewInput,{sigs}]) <> MUIV_Application_ReturnID_Quit

			IF sigs
				sigs := Wait(sigs OR SIGBREAKF_CTRL_C)
				IF (sigs AND SIGBREAKF_CTRL_C)
					set(window,MUIA_Window_Open,FALSE)
					fail(app,NIL)
				ENDIF
			ENDIF
		ENDWHILE

	set(window,MUIA_Window_Open,FALSE)


/*
** Shut down...
*/

	fail(app,NIL)
ENDIF
ENDPROC

PROC fail(app,str)

 IF app THEN Mui_DisposeObject(app)

 IF muimasterbase THEN CloseLibrary(muimasterbase)

    IF str
      WriteF(str)
      CleanUp(20)
    ENDIF

ENDPROC

PROC doMethod( obj:PTR TO object, msg:PTR TO msg )

	DEF h:PTR TO hook, o:PTR TO object, dispatcher

	IF obj
		o := obj-SIZEOF object	/* instance data is to negative offset */
		h := o.class
		dispatcher := h.entry	/* get dispatcher from hook in iclass */
		MOVEA.L h,A0
		MOVEA.L msg,A1
		MOVEA.L obj,A2		/* probably should use CallHookPkt, but the */
		MOVEA.L dispatcher,A3	/*   original code (DoMethodA()) doesn't. */
		JSR (A3)		/* call classDispatcher() */
		MOVE.L D0,o
		RETURN o
	ENDIF
ENDPROC NIL
