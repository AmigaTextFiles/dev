OPT OSVERSION=37
OPT PREPROCESS

MODULE	'libraries/mui',
	'muimaster',
	'dos/dos',
	'utility',
	'libraries/asl',
	'intuition/classes',
	'intuition/classusr',
	'utility/hooks',
	'utility/tagitem'

#define MAKE_ID(a,b,c,d) ( Shl(a,24) OR Shl(b,16) OR Shl(c,8) OR d )

PROC strobjFunc(pop,str)

DEF	x:PTR TO CHAR,s:PTR TO CHAR,i=0

	get(str,MUIA_String_Contents,{s})

		doMethod(pop,[MUIM_List_GetEntry,i,{x}])
		IF x=NIL

			set(pop,MUIA_List_Active,MUIV_List_Active_Off)

		ELSEIF Stricmp(x,s)=NIL

			set(pop,MUIA_List_Active,i)

		ENDIF
	INC i
ENDPROC TRUE


PROC objstrFunc(pop,str)

DEF	x:PTR TO CHAR
	doMethod(pop,[MUIM_List_GetEntry,MUIV_List_GetEntry_Active,{x}])
	set(str,MUIA_String_Contents,x)
ENDPROC


PROC windowFunc(pop,win) IS set(win,MUIA_Window_DefaultObject,pop)

PROC main()

DEF	strobjHook:hook,
	objstrHook:hook,
	windowHook:hook,
	app,window,pop1,pop2,pop3,pop4,pop5,plist,
	signals,active,i,
	running = TRUE

strobjHook.entry:={strobjFunc}
objstrHook.entry:={objstrFunc}
windowHook.entry:={windowFunc}

IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)
IF utilitybase := OpenLibrary('utility.library',0)
	app := ApplicationObject,
		MUIA_Application_Title      , 'Popup-Demo',
		MUIA_Application_Version    , '$VER: Popup-Demo 12.9 (21.11.95)',
		MUIA_Application_Copyright  , '©1993, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Demostrate popup objects.',
		MUIA_Application_Base       , 'POPUP',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Popup Objects',
			MUIA_Window_ID   , MAKE_ID("P","O","P","P"),
			WindowContents, VGroup,

				Child, ColGroup(2),

					Child, KeyLabel2('File:',"f"),
					Child, pop1 := PopaslObject,
						MUIA_Popstring_String, KeyString(0,256,"f"),
						MUIA_Popstring_Button, PopButton(MUII_PopFile),
						ASLFR_TITLETEXT, 'Please select a file...',
						End,

					Child, KeyLabel2('Drawer:',"d"),
					Child, pop2 := PopaslObject,
						MUIA_Popstring_String, KeyString(0,256,"d"),
						MUIA_Popstring_Button, PopButton(MUII_PopDrawer),
						ASLFR_TITLETEXT  , 'Please select a drawer...',
						ASLFR_DRAWERSONLY, TRUE,
						End,

					Child, KeyLabel2('Font:',"o"),
					Child, pop3 := PopaslObject,
						MUIA_Popstring_String, KeyString(0,80,"o"),
						MUIA_Popstring_Button, PopButton(MUII_PopUp),
						MUIA_Popasl_Type , ASL_FONTREQUEST,
						ASLFO_TITLETEXT  , 'Please select a font...',
						End,

					Child, KeyLabel2('Fixed Font:',"i"),
					Child, pop4 := PopaslObject,
						MUIA_Popstring_String, KeyString(0,80,"i"),
						MUIA_Popstring_Button, PopButton(MUII_PopUp),
						MUIA_Popasl_Type , ASL_FONTREQUEST,
						ASLFO_TITLETEXT  , 'Please select a fixed font...',
						ASLFO_FIXEDWIDTHONLY, TRUE,
						End,

					Child, KeyLabel2('Thanks To:',"n"),
					Child, pop5 := PopobjectObject,
						MUIA_Popstring_String, KeyString(0,60,"n"),
						MUIA_Popstring_Button, PopButton(MUII_PopUp),
						MUIA_Popobject_StrObjHook, {strobjHook},
						MUIA_Popobject_ObjStrHook, {objstrHook},
						MUIA_Popobject_WindowHook, {windowHook},
						MUIA_Popobject_Object, plist := ListviewObject,
							MUIA_Listview_List, ListObject,
								InputListFrame,
								MUIA_List_SourceArray, ['Stefan Becker',
											'Martin Berndt',
											'Dirk Federlein',
											'Georg Heﬂmann',
											'Martin Horneffer',
											'Martin Huttenloher',
											'Kai Iske',
											'Oliver Kilian',
											'Franke Mariak',
											'Klaus Melchior',
											'Armin Sander',
											'Matthias Scheler',
											'Andreas Schildbach',
											'Wolfgang Schildbach',
											'Christian Scholz',
											'Stefan Sommerfeld',
											'Markus Stipp',
											'Henri Veistera',
											'Albert Weinert',
											'Michael-W. Hohmann', 
											NIL],
								End,
							End,
						End,
					End,
				End,
			End,
		End

	IF app=NIL THEN fail(app,'Failed to create Application.')

	doMethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

	doMethod(window,[MUIM_Window_SetCycleChain,pop1,pop2,pop3,pop4,pop5,NIL])

	/* A double click terminates the popping list with a successful return value. */
	doMethod(plist,[MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,
		pop5,2,MUIM_Popstring_Close,TRUE])


/*
** Input loop...
*/

	set(window,MUIA_Window_Open,TRUE)

	WHILE running

		i:= doMethod(app,[MUIM_Application_Input,{signals}])
		SELECT i
			CASE MUIV_Application_ReturnID_Quit

 				get(pop1,MUIA_Popasl_Active,{active})
				IF active=NIL THEN get(pop2,MUIA_Popasl_Active,{active})
				IF active=NIL THEN get(pop3,MUIA_Popasl_Active,{active})
				IF active=NIL THEN get(pop4,MUIA_Popasl_Active,{active})

				IF (active)
					Mui_RequestA(app,window,0,NIL,'OK','Cannot quit now, still\nsome asl popups opened.',NIL)
				ELSE
					running := FALSE
				ENDIF
		ENDSELECT

		IF (running AND signals) THEN Wait(signals)
	ENDWHILE

	set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

	fail(app,NIL)
ENDIF
ENDIF
ENDPROC

PROC fail(app,str)

 IF app THEN Mui_DisposeObject(app)

 IF muimasterbase THEN CloseLibrary(muimasterbase)
 IF utilitybase THEN CloseLibrary(utilitybase)

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
