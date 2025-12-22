/*
** MUI-Demosource in D.
**
** Based on the MUI-Demosource in E.
** Based on the C example 'Balancing.c' by Stefan Stuntz.
** Translated to E by Sven Steiniger
** Translated to D by Martin Kuchinka
*/

OPT	OPTIMIZE

MODULE	'muimaster',
			'libraries/mui',
			'intuition/classes',
			'intuition/classusr',
			'dos/dos',
			'utility/tagitem',
			'utility/hooks',
			'lib/amiga'

DEF	MUIMasterBase

PROC main()
	DEF	app=NIL,window,sigs=0

	IFN MUIMasterBase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN) THEN
		Raise('Couldn''t open muimaster.library')

	app:=ApplicationObject,
		MUIA_Application_Title,      'BalanceDemo',
		MUIA_Application_Version,    '$VER: BalanceDemo 12.10 (21.11.95)',
		MUIA_Application_Copyright,  '©1995, Stefan Stuntz',
		MUIA_Application_Author,     'Stefan Stuntz',
		MUIA_Application_Description,'Show balancing groups',
		MUIA_Application_Base,       'BALANCEDEMO',

		SubWindow, window:=WindowObject,
			MUIA_Window_Title, 'Balancing Groups',
			MUIA_Window_ID,    "BALA",
			MUIA_Window_Width ,MUIV_Window_Width_Screen(50),
			MUIA_Window_Height,MUIV_Window_Height_Screen(50),

			WindowContents,HGroup,

				Child,VGroup,GroupFrame,MUIA_Weight,15,
					Child,RectangleObject,TextFrame,MUIA_Weight,50,End,
					Child,RectangleObject,TextFrame,MUIA_Weight,100,End,
					Child,BalanceObject,End,
					Child,RectangleObject,TextFrame,MUIA_Weight,200,End,
				End,

				Child,BalanceObject,End,

				Child,VGroup,
					Child,HGroup,GroupFrame,
						Child,RectangleObject,TextFrame,MUIA_ObjectID,123,End,
						Child,BalanceObject,End,
						Child,RectangleObject,TextFrame,MUIA_ObjectID,456,End,
					End,
					Child,HGroup,GroupFrame,
						Child,RectangleObject,TextFrame,End,
						Child,BalanceObject,End,
						Child,RectangleObject,TextFrame,End,
						Child,BalanceObject,End,
						Child,RectangleObject,TextFrame,End,
						Child,BalanceObject,End,
						Child,RectangleObject,TextFrame,End,
						Child,BalanceObject,End,
						Child,RectangleObject,TextFrame,End,
					End,
					Child,HGroup,GroupFrame,
						Child,HGroup,
							Child,RectangleObject,TextFrame,End,
							Child,BalanceObject,End,
							Child,RectangleObject,TextFrame,End,
						End,
						Child,BalanceObject,End,
						Child,HGroup,
							Child,RectangleObject,TextFrame,End,
							Child,BalanceObject,End,
							Child,RectangleObject,TextFrame,End,
						End,
					End,
					Child,HGroup,GroupFrame,
						Child,RectangleObject,TextFrame,MUIA_Weight,50,End,
						Child,RectangleObject,TextFrame,MUIA_Weight,100,End,
						Child,BalanceObject,End,
						Child,RectangleObject,TextFrame,MUIA_Weight,200,End,
					End,
					Child,HGroup,GroupFrame,
						Child,SimpleButton('Also'),
						Child,BalanceObject,End,
						Child,SimpleButton('Try'),
						Child,BalanceObject,End,
						Child,SimpleButton('Sizing'),
						Child,BalanceObject,End,
						Child,SimpleButton('With'),
						Child,BalanceObject,End,
						Child,SimpleButton('Shift'),
					End,
				End,
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

	WHILEN DoMethod(app,MUIM_Application_NewInput,&sigs)=MUIV_Application_ReturnID_Quit
		IF sigs THEN sigs:=Wait(sigs)
	ENDWHILE

	set(window,MUIA_Window_Open,FALSE)


/*
** Shut down...
*/

EXCEPTDO
	IF app THEN MUI_DisposeObject(app)
	IF MUIMasterBase THEN CloseLibrary(MUIMasterBase)
	IF exception THEN PrintF('\s\n',exception)
ENDPROC
