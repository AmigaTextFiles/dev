OPT PREPROCESS

MODULE	'libraries/mui',
		'muimaster',
		'utility/tagitem',
		'tools/boopsi',
		'*example'

ENUM	ER_MUILIB=10,
		ER_APP

DEF		app,
		window,
		signal,
		running,
		result

PROC main() HANDLE

	IF (muimasterbase := OpenLibrary('muimaster.library',11))=NIL THEN Raise(ER_MUILIB)

	app:= ApplicationObject,
		MUIA_Application_Title      , 'Example',
		MUIA_Application_Version    , '1.0',
		MUIA_Application_Copyright  , '1999 ® BlaBla',
		MUIA_Application_Author     , 'Gonthar/subBlaBla',
		MUIA_Application_Description, '???',
		MUIA_Application_Base       , 'TEST',
		SubWindow, window:= WindowObject,
			MUIA_Window_Title, 'Example 1.0',
			MUIA_Window_ID   , "EX",
			WindowContents, VGroup,
				Child, imgAuthorObject(),
			End,
		End,
	End

	IF app=NIL THEN Raise(ER_APP)
	domethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
	set(window,MUIA_Window_Open,MUI_TRUE)
	running := TRUE  
	WHILE running
		result := domethod(app, [MUIM_Application_Input, {signal} ])
			SELECT result
				CASE MUIV_Application_ReturnID_Quit
				running := FALSE
			ENDSELECT
		IF signal THEN Wait(signal)
	ENDWHILE
EXCEPT DO
	IF app THEN Mui_DisposeObject(app)
	IF muimasterbase THEN CloseLibrary(muimasterbase)
	SELECT exception
		CASE ER_MUILIB
			WriteF('Failed to open Muimaster.library $VER 11+.\n')
			CleanUp(20)
		CASE ER_APP
			WriteF('Failed to create application.\n')
			CleanUp(20)
	ENDSELECT
ENDPROC 0
