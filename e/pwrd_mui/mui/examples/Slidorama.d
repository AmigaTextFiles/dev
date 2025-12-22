/*
** Demosource on how to use customclasses in D.
** Based on the C example 'Slidorama.c' by Stafan Stuntz.
** Translated to E by Sven Steiniger
** Translated to D by Martin <MarK> Kuchinka
*/

MODULE	'muimaster',
			'libraries/mui',
			'intuition/classes',
			'intuition/classusr',
			'intuition/screens',
			'intuition/intuition',
			'utility',
			'utility/tagitem',
			'lib/amiga'

CONST	MUIA_Mousepower_Direction=TAG_USER|$10001

OBJECT mousepowerdata
	decrease:INT,
	mousex:INT,
	mousey:INT,
	direction:INT

OBJECT ratingdata
  buf[20]:CHAR

OBJECT timedata
  buf[16]:CHAR

DEF	mousepowerclass=NIL:PTR TO MUI_CustomClass,
		ratingclass=NIL:PTR TO MUI_CustomClass,
		timebuttonclass=NIL:PTR TO MUI_CustomClass,
		timesliderclass=NIL:PTR TO MUI_CustomClass


/*****************************************************************************
** This is the Mousepower custom class, a sub class of Levelmeter.mui.
** It is quite simple and does nothing but add some input capabilities
** to its super class by implementing MUIM_HandleInput.
** Don't be afraid of writing sub classes!
******************************************************************************/
 
PROC MousePowerDispatcher(cl:PTR TO IClass IN a0,obj IN a2,msg:PTR TO Msg IN a1)(L)
	DEF	data:PTR TO mousepowerdata,
			m:PTR TO MUIP_HandleInput,
			delta

	SELECT msg.MethodID
	CASE OM_NEW
		IF obj:=DoSuperMethodA(cl,obj,msg)
			data:=INST_DATA(cl,obj)
			data.mousex:=-1
			data.direction:=GetTagData(MUIA_Mousepower_Direction,0,msg::OpSet.AttrList)
			set(obj,MUIA_Numeric_Max,1000)
		ENDIF
		RETURN obj
	CASE MUIM_Setup
		data:=INST_DATA(cl,obj)
		IFN DoSuperMethodA(cl,obj,msg) THEN RETURN FALSE
		data.mousex:=-1
		set(obj,MUIA_Numeric_Max,1000)
		MUI_RequestIDCMP(obj,IDCMP_MOUSEMOVE|IDCMP_INTUITICKS|IDCMP_INACTIVEWINDOW)
		RETURN MUI_TRUE
	CASE MUIM_Cleanup
		MUI_RejectIDCMP(obj,IDCMP_MOUSEMOVE|IDCMP_INTUITICKS|IDCMP_INACTIVEWINDOW)
		RETURN DoSuperMethodA(cl,obj,msg)
	CASE MUIM_HandleInput
		m:=msg
		data:=INST_DATA(cl,obj)
		IF m.imsg
			IF m.imsg.Class=IDCMP_MOUSEMOVE
				IF data.mousex<>-1
					IF data.direction=1
						delta:=Abs(data.mousex-m.imsg.MouseX)*2
					ELSEIF data.direction=2
						delta:=Abs(data.mousey-m.imsg.MouseY)*2
					ELSE
						delta:=Abs(data.mousex-m.imsg.MouseX)+Abs(data.mousey-m.imsg.MouseY)
					ENDIF
					IF data.decrease>0 THEN data.decrease:=data.decrease-1
					DoMethodA(obj,[MUIM_Numeric_Increase,delta/10])
				ENDIF
				data.mousex:=m.imsg.MouseX
				data.mousey:=m.imsg.MouseY
			ELSEIF m.imsg.Class=IDCMP_INTUITICKS
				DoMethodA(obj,[MUIM_Numeric_Decrease,data.decrease*data.decrease])
				IF data.decrease<50 THEN data.decrease++
			ELSEIF m.imsg.Class=IDCMP_INACTIVEWINDOW
				set(obj,MUIA_Numeric_Value,0)
			ENDIF
		ENDIF
		RETURN 0
	ENDSELECT
ENDPROC DoSuperMethodA(cl,obj,msg)


/*****************************************************************************
** This is the Rating custom class, a sub class of Slider.mui.
** It shows how to override the MUIM_Numeric_Stringify method
** to implement custom displays in a slider gadget. Nothing
** easier than that... :-)
******************************************************************************/

PROC RatingDispatcher(cl:PTR TO IClass IN a0,obj IN a2,msg:PTR TO Msg IN a1)(LONG)
	DEF	data:PTR TO ratingdata,
			m:PTR TO MUIP_Numeric_Stringify,
			r,l:PTR TO LONG

	SELECT msg.MethodID
	CASE MUIM_Numeric_Stringify
		data:=INST_DATA(cl,obj)
		m:=msg
		IF m.value=0
			StrCopy(data.buf,'You''re kidding!')
		ELSEIF m.value=100
			StrCopy(data.buf,'It''s magic!')
		ELSE
			l:=[':-((',':-(',':-|',':-)',':-))']:LONG
			r:=DoMethodA(obj,[MUIM_Numeric_ValueToScale,0,4 /*5 States, 0..4*/])
			StringF(data.buf,'\d[3] points. \s',m.value,l[r])
		ENDIF
		RETURN data.buf
	ENDSELECT
ENDPROC DoSuperMethodA(cl,obj,msg)


/*****************************************************************************
** A time slider custom class. Just like with the Rating class, we override
** the MUIM_Numeric_Stringify method. Wow... our classes get smaller and 
** smaller. This one only has about 10 lines of C code. :-)
** Note that we can use this TimeDispatcher as subclass of any of
** MUI's numeric classes. In Slidorama, we create a Timebutton class
** from MUIC_Numericbutton and Timeslider class for MUIC_Slider with
** the same dispatcher function.
******************************************************************************/

PROC TimeDispatcher(cl:PTR TO IClass IN a0,obj IN a2,msg:PTR TO Msg IN a1)(LONG)
	DEF	data:PTR TO timedata,
			m:PTR TO MUIP_Numeric_Stringify

	SELECT msg.MethodID
	CASE MUIM_Numeric_Stringify
		data:=INST_DATA(cl,obj)
		m:=msg
		StringF(data.buf,'\z\d[2]:\z\d[2]',m.value/60,m.value\60)
		RETURN data.buf
	ENDSELECT
ENDPROC DoSuperMethodA(cl,obj,msg)


/*****************************************************************************
** Main Program
******************************************************************************/

PROC CleanupClasses()
	IF mousepowerclass THEN MUI_DeleteCustomClass(mousepowerclass)
	IF ratingclass     THEN MUI_DeleteCustomClass(ratingclass)
	IF timebuttonclass THEN MUI_DeleteCustomClass(timebuttonclass)
	IF timesliderclass THEN MUI_DeleteCustomClass(timesliderclass)
ENDPROC

PROC CreateCustomClass(father,datasize,dispatcher)(PTR)
	DEF mcc
	mcc:=MUI_CreateCustomClass(NIL,father,NIL,datasize,dispatcher)
	IF mcc=NIL THEN Raise('Could not create custom class.')
ENDPROC mcc

PROC SetupClasses()
  mousepowerclass:=CreateCustomClass(MUIC_Levelmeter,SIZEOF_mousepowerdata,&MousePowerDispatcher)
  ratingclass    :=CreateCustomClass(MUIC_Slider,SIZEOF_ratingdata,&RatingDispatcher)
  timesliderclass:=CreateCustomClass(MUIC_Slider,SIZEOF_timedata,&TimeDispatcher)
  timebuttonclass:=CreateCustomClass(MUIC_Numericbutton,SIZEOF_timedata,&TimeDispatcher)
ENDPROC

DEF	MUIMasterBase,UtilityBase

PROC main()
	DEF	app=NIL,window,sigs=0

	IFN MUIMasterBase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN) THEN
		Raise('Failed TO open muimaster.library')
 
	IFN UtilityBase:=OpenLibrary('utility.library',0) THEN
		Raise('Failed TO open utility.library')

	SetupClasses()

	app := ApplicationObject,
		MUIA_Application_Title      , 'Slidorama',
		MUIA_Application_Version    , '$VER: Slidorama 12.10 (21.11.95)',
		MUIA_Application_Copyright  , '©1992-95, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Show different kinds OF sliders',
		MUIA_Application_Base       , 'SLIDORAMA',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Slidorama',
			MUIA_Window_ID   , "SLID",

			WindowContents, VGroup,

				Child, HGroup,

					Child, VGroup, GroupSpacing(0), GroupFrameT('Knobs'),
						Child, VSpace(0),
						Child, ColGroup(6),
							GroupSpacing(0),
							Child, VSpace(0),
							Child, HSpace(4),
							Child, CLabel('1'),
							Child, CLabel('2'),
							Child, CLabel('3'),
							Child, CLabel('4'),
							Child, VSpace(2),
							Child, VSpace(2),
							Child, VSpace(2),
							Child, VSpace(2),
							Child, VSpace(2),
							Child, VSpace(2),
							Child, Label('Volume:'),
							Child, HSpace(4),
							Child, NewKnobObject1(64,64),
							Child, NewKnobObject1(64,64),
							Child, NewKnobObject1(64,64),
							Child, NewKnobObject1(64,64),
							Child, Label('Bass:'),
							Child, HSpace(4),
							Child, NewKnobObject2(-100,100),
							Child, NewKnobObject2(-100,100),
							Child, NewKnobObject2(-100,100),
							Child, NewKnobObject2(-100,100),
							Child, Label('Treble:'),
							Child, HSpace(4),
							Child, NewKnobObject2(-100,100),
							Child, NewKnobObject2(-100,100),
							Child, NewKnobObject2(-100,100),
							Child, NewKnobObject2(-100,100),
						End,
						Child, VSpace(0),
					End,
					
					Child, VGroup,
						Child, VGroup, GroupFrameT('Levelmeter Displays'),
							Child, VSpace(0),
							Child, HGroup,
								Child, HSpace(0),
								Child, NewObject(mousepowerclass.Class,0,
											MUIA_Mousepower_Direction,1,
											MUIA_Levelmeter_Label,'Horizontal',
											TAG_DONE),
								Child, HSpace(0),
								Child, NewObject(mousepowerclass.Class,0,
											MUIA_Mousepower_Direction,2,
											MUIA_Levelmeter_Label,'Vertical',
											TAG_DONE),
								Child, HSpace(0),
								Child, NewObject(mousepowerclass.Class,0,
											MUIA_Mousepower_Direction,0,
											MUIA_Levelmeter_Label,'Total',
											TAG_DONE),
								Child, HSpace(0),
							End,
							Child, VSpace(0),
						End,
						Child, VGroup, GroupFrameT('Numeric Buttons'),
							Child, VSpace(0),
							Child, HGroup, GroupSpacing(0),
								Child, HSpace(0),
								Child, ColGroup(4), MUIA_Group_VertSpacing, 1,
									Child, VSpace(0),
									Child, CLabel('Left'),
									Child, CLabel('Right'),
									Child, CLabel('SPL'),
									Child, Label1('Low:'),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,30,99,'%2ld dB']),
									Child, Label1('Mid:'),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,30,99,'%2ld dB']),
									Child, Label1('High:'),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
									Child, MUI_MakeObjectA(MUIO_NumericButton,[NIL,30,99,'%2ld dB']),
								End,
								Child, HSpace(0),
							End,
							Child, VSpace(0),
						End,
					End,
				End,

				Child, VSpace(4),

				Child, ColGroup(2),
					Child, Label('Slidorama Rating:'),
					Child, NewObject(ratingclass.Class,0,MUIA_Numeric_Value,50,TAG_DONE),
				End,
			End,
		End,
	End

	IF app=NIL THEN Raise('Failed to create Application')
 
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
		IF sigs THEN sigs := Wait(sigs)
	ENDWHILE

	set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

EXCEPTDO
	IF app THEN MUI_DisposeObject(app)                /* dispose ALL objects. */
	CleanupClasses()
	IF UtilityBase THEN CloseLibrary(UtilityBase)     /* close library */
	IF MUIMasterBase THEN CloseLibrary(MUIMasterBase) /* close library */
	IF exception THEN PrintF('\s\n',exception)
ENDPROC

PROC NewKnobObject1(max,defi)(PTR) IS
	KnobObject,
		MUIA_Numeric_Max,max,
		MUIA_Numeric_Default,defi,
		MUIA_CycleChain,1,
	End

PROC NewKnobObject2(min,max)(PTR) IS
	KnobObject,
		MUIA_Numeric_Max,max,
		MUIA_Numeric_Min,min,
		MUIA_CycleChain,1,
	End

