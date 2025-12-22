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
#define String(contents,maxlen)\
	StringObject,\
		StringFrame,\
		MUIA_String_MaxLen  , maxlen,\
		MUIA_String_Contents, contents,\
		End

PROC main()

DEF	app,window,sigs = 0,
	sex,pages,races,classes

sex:=[ 'male','female',NIL ]
pages:=[ 'Race','Class','Armor','Level',NIL ]
races:=[ 'Human','Elf','Dwarf','Hobbit','Gnome',NIL ]
classes:=[ 'Warrior','Rogue','Bard','Monk','Magician','Archmage',NIL ]

IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)

	app := ApplicationObject,
		MUIA_Application_Title      , 'Pages-Demo',
		MUIA_Application_Version    , '$VER: Pages-Demo 12.9 (21.11.95)',
		MUIA_Application_Copyright  , '©1992/93, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Show MUIs Page Groups',
		MUIA_Application_Base       , 'PAGESDEMO',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Character Definition',
			MUIA_Window_ID   , MAKE_ID("P","A","G","E"),

			WindowContents, VGroup,

				Child, ColGroup(2),
					Child, Label2('Name:'), Child, String('Frodo',32),
					Child, Label1('Sex:' ), Child, Cycle(sex),
					End,

				Child, VSpace(2),

				Child, RegisterGroup(pages),
					MUIA_Register_Frame, TRUE,

					Child, HCenter(Radio(NIL,races)),

					Child, HCenter(Radio(NIL,classes)),

					Child, HGroup,
						Child, HSpace(0),
						Child, ColGroup(2),
							Child, Label1('Cloak:' ), Child, CheckMark(TRUE),
							Child, Label1('Shield:'), Child, CheckMark(TRUE),
							Child, Label1('Gloves:'), Child, CheckMark(TRUE),
							Child, Label1('Helmet:'), Child, CheckMark(TRUE),
							End,
						Child, HSpace(0),
						End,

					Child, ColGroup(2),
						Child, Label('Experience:'  ), Child, Slider(0,100, 3),
						Child, Label('Strength:'    ), Child, Slider(0,100,42),
						Child, Label('Dexterity:'   ), Child, Slider(0,100,24),
						Child, Label('Condition:'   ), Child, Slider(0,100,39),
						Child, Label('Intelligence:'), Child, Slider(0,100,74),
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
