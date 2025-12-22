OPT OSVERSION=37
OPT PREPROCESS

MODULE	'libraries/mui',
	'muimaster',
	'dos/dos',
	'intuition/classes',
	'intuition/classusr',
	'utility/hooks',
	'utility/tagitem'

DEF 	cy_computer,cy_printer,cy_display,
	mt_computer,mt_printer,mt_display,
	lv_computer,
	bt_button[12]:STRING

DEF 	pages:PTR TO CHAR,
	text1:PTR TO CHAR,
	text2:PTR TO CHAR,
	text3:PTR TO CHAR

#define img(nr)  ImageObject, MUIA_Image_Spec, nr, End

#define MAKE_ID(a,b,c,d) ( Shl(a,24) OR Shl(b,16) OR Shl(c,8) OR d )

#define mytxt(txt)\
	TextObject,\
		MUIA_Text_Contents, '\ec'txt,\
		MUIA_Text_SetMax, MUI_TRUE,\
		End

#define ibt(i)\
	ImageObject,\
		ImageButtonFrame,\
		MUIA_Background, MUII_ButtonBack,\
		MUIA_InputMode , MUIV_InputMode_RelVerify,\
		MUIA_Image_Spec, i,\
		End

PROC makepage1()

DEF obj

	obj:=ScrollgroupObject,
		MUIA_Scrollgroup_Contents, VirtgroupObject,
			VirtualFrame,
			Child, TextObject,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, text1,
				End,
			End,
		End
ENDPROC obj

PROC makepage2()

DEF obj
	obj := ScrollgroupObject,
		MUIA_Scrollgroup_Contents, VGroupV, VirtualFrame,
			Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, text2,
				End,
			Child, HGroup,
				Child, ColGroup(2), GroupFrameT('Standard Images'),
					Child, Label('ArrowUp:'    ), Child, img(MUII_ArrowUp    ),
					Child, Label('ArrowDown:'  ), Child, img(MUII_ArrowDown  ),
					Child, Label('ArrowLeft:'  ), Child, img(MUII_ArrowLeft  ),
					Child, Label('ArrowRight:' ), Child, img(MUII_ArrowRight ),
					Child, Label('RadioButton:'), Child, img(MUII_RadioButton),
					Child, Label('File:'       ), Child, img(MUII_PopFile    ),
					Child, Label('HardDisk:'   ), Child, img(MUII_HardDisk   ),
					Child, Label('Disk:'       ), Child, img(MUII_Disk       ),
					Child, Label('Chip:'       ), Child, img(MUII_Chip       ),
					Child, Label('Drawer:'     ), Child, img(MUII_Drawer     ),
					End,
				Child, VGroup, GroupFrameT('Some Backgrounds'),
					Child, HGroup,
						Child, RectangleObject, TextFrame, MUIA_Background, MUII_BACKGROUND , MUIA_FixWidth, 30, End,
	      	   	Child, RectangleObject, TextFrame, MUIA_Background, MUII_FILL       , MUIA_FixWidth, 30, End,
	         		Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOW     , MUIA_FixWidth, 30, End,
						End,
					Child, HGroup,
		         	Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOWBACK , MUIA_FixWidth, 30, End,
	   	      	Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOWFILL , MUIA_FixWidth, 30, End,
	      	   	Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHADOWSHINE, MUIA_FixWidth, 30, End,
						End,
					Child, HGroup,
		         	Child, RectangleObject, TextFrame, MUIA_Background, MUII_FILLBACK   , MUIA_FixWidth, 30, End,
	   	      	Child, RectangleObject, TextFrame, MUIA_Background, MUII_SHINEBACK  , MUIA_FixWidth, 30, End,
	      	   	Child, RectangleObject, TextFrame, MUIA_Background, MUII_FILLSHINE  , MUIA_FixWidth, 30, End,
						End,
					End,
				End,
			Child, ColGroup(2), GroupFrame,
				Child, Label1('Gauge:'), Child, GaugeObject, GaugeFrame, MUIA_Gauge_Current, 66, MUIA_Gauge_Horiz, MUI_TRUE, End,
				Child, VSpace(0)       , Child, ScaleObject, End,
				End,
			End,
		End

ENDPROC obj

PROC makepage3()

DEF	obj

	obj := ScrollgroupObject,
		MUIA_Scrollgroup_Contents, VGroupV, VirtualFrame, 
			Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, text3,
				End,
			Child, VGroup,
				Child, HGroup,
					Child, mt_computer := Radio('Computer:',[ 'Amiga 500','Amiga 600','Amiga 1000 :)','Amiga 1200','Amiga 2000','Amiga 3000','Amiga 4000', 'Amiga 4000T', 'Atari ST :(', NIL ]),
					Child, VGroup,
						Child, mt_printer := Radio('Printer:',[ 'HP Deskjet','NEC P6','Okimate 20',NIL ]),
						Child, VSpace(0),
						Child, mt_display := Radio('Display:',[ 'A1081','NEC 3D','A2024','Eizo T660i',NIL ]),
						End,
					Child, VGroup,
						Child, ColGroup(2), GroupFrameT('Cycle Gadgets'),
							Child, KeyLabel1('Computer:',"c"), Child, cy_computer := KeyCycle([ 'Amiga 500','Amiga 600','Amiga 1000 :)','Amiga 1200','Amiga 2000','Amiga 3000','Amiga 4000', 'Amiga 4000T', 'Atari ST :(', NIL ],"c"),
							Child, KeyLabel1('Printer:' ,"p"), Child, cy_printer  := KeyCycle([ 'HP Deskjet','NEC P6','Okimate 20',NIL ],"p"),
							Child, KeyLabel1('Display:' ,"d"), Child, cy_display  := KeyCycle([ 'A1081','NEC 3D','A2024','Eizo T660i',NIL ] ,"d"),
							End,
						Child, lv_computer := ListviewObject,
							MUIA_Listview_Input, MUI_TRUE,
							MUIA_Listview_List, ListObject, InputListFrame, End,
							End,
						End,
					End,/*
				Child, ColGroup(4), GroupFrameT('Button Field'),
					Child, bt_button[ 0] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 1] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 2] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 3] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 4] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 5] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 6] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 7] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 8] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[ 9] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[10] := Mui_MakeObjectA(MUIO_Button,'Button'),
					Child, bt_button[11] := Mui_MakeObjectA(MUIO_Button,'Button'),
					End,*/
				End,
			End,
		End



	IF lv_computer THEN doMethod(lv_computer,[MUIM_List_Insert,[ 'Amiga 500','Amiga 600','Amiga 1000 :)','Amiga 1200','Amiga 2000','Amiga 3000','Amiga 4000', 'Amiga 4000T', 'Atari ST :(', NIL ],-1,MUIV_List_Insert_Bottom])

ENDPROC obj

->static char *x4Sex[]     = [ 'male','female',NIL ]

PROC makepage4()

DEF	bt1,bt2,bt3,bt4,gr,obj,pcy,pgr

	obj := ScrollgroupObject,
		MUIA_Scrollgroup_Contents, ColGroupV(3), VirtualFrame, 
			MUIA_Group_Spacing, 10,
			Child, VGroup, GroupFrame,
				Child, HGroup,
					Child, HSpace(0),
					Child, bt1 := ibt(MUII_ArrowUp),
					Child, HSpace(0),
					End,
				Child, HGroup,
					Child, bt2 := ibt(MUII_ArrowLeft),
					Child, bt3 := ibt(MUII_ArrowRight),
					End,
				Child, HGroup,
					Child, HSpace(0),
					Child, bt4 := ibt(MUII_ArrowDown),
					Child, HSpace(0),
					End,
				End,
			Child, mytxt('Ever wanted to see\na virtual group in\na virtual group?'),
			Child, HVSpace,
			Child, mytxt('Here it is!'),

			Child, ScrollgroupObject,
				MUIA_Scrollgroup_Contents, gr := VGroupV, VirtualFrame,
					Child, ColGroup(6), MUIA_Group_SameSize, MUI_TRUE,
						Child, SimpleButton('One'),
						Child, SimpleButton('Two'),
						Child, SimpleButton('Three'),
						Child, SimpleButton('Four'),
						Child, SimpleButton('Five'),
						Child, SimpleButton('Six'),
						Child, SimpleButton('Eighteen'),
						Child, mytxt('The'),
						Child, mytxt('red'),
						Child, mytxt('brown'),
						Child, mytxt('fox'),
						Child, SimpleButton('Seven'),
						Child, SimpleButton('Seventeen'),
						Child, mytxt('dog.'),
						Child, SimpleButton('Nineteen'),
						Child, SimpleButton('Twenty'),
						Child, mytxt('jumps'),
						Child, SimpleButton('Eight'),
						Child, SimpleButton('Sixteen'),
						Child, mytxt('lazy'),
						Child, mytxt('the'),
						Child, mytxt('over'),
						Child, mytxt('quickly'),
						Child, SimpleButton('Nine'),
						Child, SimpleButton('Fifteen'),
						Child, SimpleButton('Fourteen'),
						Child, SimpleButton('Thirteen'),
						Child, SimpleButton('Twelve'),
						Child, SimpleButton('Eleven'),
						Child, SimpleButton('Ten'),
						End,
					End,
				End,

			Child, mytxt('Do you like it? I hope...'),
			Child, HVSpace,
			Child, mytxt('I admit, it\as a\n bit crazy... :-)\nBut it demonstrates\nthe power of\n\ebobject oriented\en\nGUI design.'),

			Child, ScrollgroupObject,
				MUIA_Scrollgroup_Contents, VGroupV, VirtualFrame, InnerSpacing(4,4), 
					Child, VGroup,
						Child, pcy := Cycle([ 'Race','Class','Armors','Weapons','Levels',NIL ]),
						Child, pgr := PageGroup,
							Child, HCenter(Radio(NIL,[ 'Human','Elf','Dwarf','Hobbit','Gnome',NIL ])),
							Child, HCenter(Radio(NIL,[ 'Warrior','Rogue','Bard','Monk','Magician','Archmage',NIL ])),
							Child, HGroup,
								Child, HSpace(0),
								Child, ColGroup(2),
									Child, Label1('Cloak:' ), Child, CheckMark(MUI_TRUE),
									Child, Label1('Shield:'), Child, CheckMark(MUI_TRUE),
									Child, Label1('Gloves:'), Child, CheckMark(MUI_TRUE),
									Child, Label1('Helm:'  ), Child, CheckMark(MUI_TRUE),
									End,
								Child, HSpace(0),
								End,
							Child, HCenter(Radio(NIL,[ 'Staff','Dagger','Sword','Axe','Grenade',NIL ])),
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
				End,


			End,
		End

	IF obj
		doMethod(bt1,[MUIM_Notify,MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Top ,0])
		doMethod(bt2,[MUIM_Notify,MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Left,0])
		doMethod(bt3,[MUIM_Notify,MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Left,9999])
		doMethod(bt4,[MUIM_Notify,MUIA_Pressed,FALSE,gr,3,MUIM_Set,MUIA_Virtgroup_Top ,9999])

		doMethod(pcy,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,pgr,3,MUIM_Set,MUIA_Group_ActivePage,MUIV_TriggerValue])
	ENDIF

ENDPROC obj

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

PROC fail(app,str)

 IF app THEN Mui_DisposeObject(app)

 IF muimasterbase THEN CloseLibrary(muimasterbase)

    IF str
      WriteF(str)
      CleanUp(20)
    ENDIF

ENDPROC

PROC main()

DEF	app,window,sigs = 0

pages:=['Big Text Field','Different Objects','Input Accepting Objects','Completly Crazy',NIL]

	       text1 := '\eiHello User !\ec\n\n\n'+
			'This could be a very long text and you are looking\n'+
			'at it through a \euvirtual group\en. Please use the\n'+
			'scrollbars at the right and bottom of the group to\n'+
			'move the visible area either vertically or\n'+
			'horizontally. While holding down the small arrow\n'+
			'button between both scrollbars, the display will\n'+
			'follow your mouse moves.\n\n'+
			'If you click somewhere into a \euvirtual group\en and\n'+
			'move the mouse across one of its borders, the group will\n'+
			'start scrolling. If you are lucky and own a middle mouse\n'+
			'button, you may also want to press it and try moving.\n\n'+
			'When the surrounding window is big enough for the\n'+
			'complete virtual group to fit, the scrollers and\n'+
			'the move button get disabled.\n\n'+
			'Since this \euvirtual group\en does only contain a\n'/*+
			'single text object, it\as a rather simple example.\n'+
			'In fact, virtual groups are a lot more powerful,\n'+
			'they can contain any objects you like.\n\n'+
			'Note to 7MHz/68000 users: Sorry if you find this\n'+
			'thingy a bit slow. Clipping in virtual groups can\n'+
			'get quite complicated. Please don\at blame me,\n'+
			'blame your 'out of date' machine! :-)\n\n'+
			'\ei\ecHave fun, Stefan.\en'*/

       text2 := '\ecAs you can see, this virtual group contains a\n'+
		'lot of different objects. The (virtual) width\n'+
		'and height of the virtual group are automatically\n'+
		'calculated from the default width and height of\n'+
		'the virtual groups contents.'

	text3 := '\ecThe above pages only showed "read only" groups,\n'+
		'no user actions within them were possible. Of course,\n'+
		'handling user actions in a virtual group is not a\n'+
		'problem for MUI. As I promised on the first page,\n'+
		'you can use virtual groups with whatever objects\n'+
		'you want. Here\as a small example...\n\n'+
		'Note: Due to some limitations of the operating system,\n'+
		'it is not possible to clip gadgets depending on\n'+
		'intuition.library correctly. This affects the appearence\n'+
		'of string and proportional objects in virtual groups.\n'+
		'You will only be able to use these gadgets when they\n'+
		'are completely visible.\n\nPS: Also try TAB cycling here!'


IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)

	app := ApplicationObject,
		MUIA_Application_Title      , 'VirtualDemo',
		MUIA_Application_Version    , '$VER: VirtualDemo 12.9 (21.11.95)',
		MUIA_Application_Copyright  , '©1993, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Show virtual groups.',
		MUIA_Application_Base       , 'VIRTUALDEMO',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Virtual Groups',
			MUIA_Window_ID   , MAKE_ID("V","I","R","T"),
			WindowContents, ColGroup(2), GroupSpacing(8),
				Child, makepage1(),
				Child, makepage2(),
				Child, makepage3(),
				Child, makepage4(),
				End,
			End,
		End


	IF app=NIL THEN	fail(app,'Failed to create Application.')


	doMethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

	doMethod(window,[MUIM_Window_SetCycleChain,
		mt_computer,mt_printer,mt_display,
		cy_computer,cy_printer,cy_display,
		lv_computer,
		bt_button[ 0],bt_button[ 1],bt_button[ 2],bt_button[ 3],
		bt_button[ 4],bt_button[ 5],bt_button[ 6],bt_button[ 7],
		bt_button[ 8],bt_button[ 9],bt_button[10],bt_button[11],
		NIL])

/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

	set(window,MUIA_Window_Open,MUI_TRUE)

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

	fail(app,NIL)
ENDIF
ENDPROC
