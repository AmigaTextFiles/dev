/*
** The ShowHide demo shows how to hide and show objects.
*/
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

DEF	app,window,cm1,cm2,cm3,cm4,cm5,bt1,bt2,bt3,bt4,bt5, sigs = 0


IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)

	app := ApplicationObject,
		MUIA_Application_Title      , 'ShowHide',
		MUIA_Application_Version    , '$VER: ShowHide 12.10 (21.11.95)',
		MUIA_Application_Copyright  , '©1992/93, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Show object hiding.',
		MUIA_Application_Base       , 'SHOWHIDE',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Show & Hide',
			MUIA_Window_ID   , MAKE_ID("S","H","H","D"),

			WindowContents, HGroup,

				Child, VGroup, GroupFrame,

					Child, HGroup, MUIA_Weight, 0,
						Child, cm1 := CheckMark(TRUE),
						Child, cm2 := CheckMark(TRUE),
						Child, cm3 := CheckMark(TRUE),
						Child, cm4 := CheckMark(TRUE),
						Child, cm5 := CheckMark(TRUE),
						End,

					Child, VGroup,
						Child, bt1 := SimpleButton('Button 1'),
						Child, bt2 := SimpleButton('Button 2'),
						Child, bt3 := SimpleButton('Button 3'),
						Child, bt4 := SimpleButton('Button 4'),
						Child, bt5 := SimpleButton('Button 5'),
						Child, VSpace(0),
						End,

					End,
				End,
			End,
		End

	IF app=NIL THEN	fail(app,'Failed to create Application.')


/*
** Install notification events...
*/

	doMethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

	doMethod(cm1,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,bt1,3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
	doMethod(cm2,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,bt2,3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
	doMethod(cm3,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,bt3,3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
	doMethod(cm4,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,bt4,3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
	doMethod(cm5,[MUIM_Notify,MUIA_Selected,MUIV_EveryTime,bt5,3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])

	set(cm3,MUIA_Selected,FALSE)

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
