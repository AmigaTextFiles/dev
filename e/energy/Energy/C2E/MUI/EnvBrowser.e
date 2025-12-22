OPT OSVERSION=37
OPT PREPROCESS

MODULE	'libraries/mui',
	'muimaster',
	'dos/var',
	'intuition/classes',
	'intuition/classusr',
	'utility/hooks',
	'utility/tagitem'

#define MAKE_ID(a,b,c,d) ( Shl(a,24) OR Shl(b,16) OR Shl(c,8) OR d )

#define ID_DISPLAY 1
#define ID_EDIT    2
#define ID_DELETE  3
#define ID_SAVE    4

PROC main()

DEF	app,wi_browser,bt_edit, bt_delete, bt_save, lv_vars, lv_show,
	buffer[2048]:STRING,
	var:PTR TO CHAR,
	running = TRUE,
	signal,msg

IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)

	app := ApplicationObject,
		MUIA_Application_Title      , 'EnvBrowser',
		MUIA_Application_Version    , '$VER: EnvBrowser 12.9 (21.11.95)',
		MUIA_Application_Copyright  , '©1992/93, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'View environment variables.',
		MUIA_Application_Base       , 'ENVBROWSER',
		SubWindow, wi_browser := WindowObject,
			MUIA_Window_ID, MAKE_ID("M","A","I","N"),
			MUIA_Window_Title, 'Environment Browser',
			WindowContents, VGroup,
				Child, HGroup,
					Child, lv_vars := ListviewObject,
						MUIA_Listview_List, DirlistObject,
							InputListFrame,
							MUIA_Dirlist_Directory      , 'env:',
							MUIA_Dirlist_FilterDrawers, TRUE,
							MUIA_List_Format          , 'COL=0',
							End,
						End,
					Child, lv_show := ListviewObject,
						MUIA_Listview_List, FloattextObject,
							ReadListFrame,
							MUIA_Font, MUIV_Font_Fixed,
							End,
						End,
					End,
				Child, HGroup, MUIA_Group_SameSize, TRUE,
					Child, bt_edit   := SimpleButton('_Edit'  ),
					Child, bt_delete := SimpleButton('_Delete'),
					Child, bt_save   := SimpleButton('_Save'  ),
					End,
				End,
			End,
		End

	IF app=NIL THEN fail(app,'Failed to create Application.')

	doMethod(wi_browser,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
	doMethod(lv_vars   ,[MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,app,2,MUIM_Application_ReturnID,ID_DISPLAY])
	doMethod(lv_vars   ,[MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,app,2,MUIM_Application_ReturnID,ID_EDIT])
	doMethod(bt_delete ,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,ID_DELETE])
	doMethod(bt_save   ,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,ID_SAVE  ])
	doMethod(bt_edit   ,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,ID_EDIT ])

	doMethod(wi_browser,[MUIM_Window_SetCycleChain,lv_vars,lv_show,bt_edit,bt_delete,bt_save,NIL])

	set(wi_browser,MUIA_Window_Open,TRUE)

	WHILE running

		msg:=doMethod(app,[MUIM_Application_Input,{signal}])

		SELECT msg
		
			CASE MUIV_Application_ReturnID_Quit
				running := FALSE

			CASE ID_DISPLAY
			
				get(lv_vars,MUIA_Dirlist_Path,{var})
				IF var AND GetVar(var,buffer,StrLen(buffer),GVF_GLOBAL_ONLY OR GVF_BINARY_VAR)<>-1
					set(lv_show,MUIA_Floattext_Text,buffer)
				ELSE
					DisplayBeep(0)
				ENDIF

			CASE ID_DELETE

				get(lv_vars,MUIA_Dirlist_Path,{var})
				IF var
					set(lv_show,MUIA_Floattext_Text,NIL)
					DeleteFile(var)
					doMethod(lv_vars,[MUIM_List_Remove,MUIV_List_Remove_Active])
 				ELSE
					DisplayBeep(0)
				ENDIF

			CASE ID_SAVE

				get(lv_vars,MUIA_Dirlist_Path,{var})
				IF var
					set(app,MUIA_Application_Sleep,TRUE)
					StringF(buffer,'copy env:\s envarc:\s',FilePart(var),FilePart(var))
					Execute(buffer,0,0)
					set(app,MUIA_Application_Sleep,FALSE)
				ELSE
					DisplayBeep(0)
				ENDIF

			CASE ID_EDIT

				get(lv_vars,MUIA_Dirlist_Path,{var})
				IF var
					set(app,MUIA_Application_Sleep,TRUE)
					StringF(buffer,'ed -sticky \\"\s\\"',var)
					Execute(buffer,0,0)
					set(app,MUIA_Application_Sleep,FALSE)
					doMethod(wi_browser,[MUIM_Window_ScreenToFront])
				ELSE
					DisplayBeep(0)
				ENDIF
		ENDSELECT

		IF (running AND signal) THEN Wait(signal)
	ENDWHILE

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
