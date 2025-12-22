/*
**	   E Source Code For The MUI Demo Program
**	   --------------------------------------
**
**    Original C Code written 1992-94 by Stefan Stuntz
**
**     Translation into E 1994 by Jan Hendrik Schulz
**
*/

/*
** Tell AmigaE v3.1 that we use macros.
*/

OPT PREPROCESS   /* remove this for AmigaE v2.1b */

/*
** Loading the needed MODULEs
*/

MODULE 'muimaster', 'libraries/mui'
MODULE 'utility/tagitem', 'utility/hooks'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'libraries/gadtools'


/*
** Defining CONSTs
*/

ENUM ID_ABOUT=1, ID_NEWVOL, ID_NEWBRI   /* for the menu definition */
ENUM ER_NON, ER_MUILIB, ER_APP          /* for the exception handling */


/*
** DEFining the var´s
*/

DEF lvt_Brian:PTR TO LONG
DEF menu
DEF in_Master, in_Notify, in_Frames, in_Images, in_Groups,
    in_Backfill, in_Listviews, in_Cycle, in_String
DEF cya_Computer, cya_Printer, cya_Display
/*
** For every object we want to refer later (e.g. for notification purposes)
** we need a pointer.
*/
DEF ap_Demo
DEF wi_Master,wi_Frames,wi_Images,wi_Notify,wi_Listviews,wi_Groups,wi_Backfill,wi_Cycle,wi_String
DEF bt_Notify,bt_Frames,bt_Images,bt_Groups,bt_Backfill,bt_Listviews,bt_Cycle,bt_String,bt_Quit
DEF pr_PropA,pr_PropH,pr_PropV,pr_PropL,pr_PropR,pr_PropT,pr_PropB
DEF lv_Volumes,lv_Directory,lv_Computer,lv_Brian
DEF cy_Computer,cy_Printer,cy_Display
DEF mt_Computer,mt_Printer,mt_Display
DEF st_Brian
DEF ga_Gauge1,ga_Gauge2,ga_Gauge3


/*
** main()
*/

PROC main() HANDLE

DEF signal, running, buf, result

/*
** Open the muimaster.library
*/

   IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

/*
** A little array definition:
*/

lvt_Brian := [	'Cheer up, Brian. You know what they say.',
		'Some things in life are bad,',
		'They can really make you mad.',
		'Other things just make you swear and curse.',
		'When you\are chewing on life\as grissle,',
		'Don\at grumble, give a whistle.',
		'And this\all help things turn out for the best,',
		'And...',
		'',
		'Always look on the bright side of life',
		'Always look on the light side of life',
		'',
		'If life seems jolly rotten,',
		'There\as something you\ave forgotten,',
		'And that\as to laugh, and smile, and dance, and sing.',
		'When you\are feeling in the dumps,',
		'Don\at be silly chumps,',
		'Just purse your lips and whistle, that\as the thing.',
		'And...',
		'',
		'Always look on the bright side of life, come on!',
		'Always look on the right side of life',
		'',
		'For life is quite absurd,',
		'And death\as the final word.',
		'You must always face the curtain with a bow.',
		'Forget about your sin,',
		'Give the audience a grin.',
		'Enjoy it, it\as your last chance anyhow,',
		'So...',
		'',
		'Always look on the bright side of death',
		'Just before you draw your terminal breath.',
		'',
		'Life\as a piece of shit,',
		'When you look at it.',
		'Life\as a laugh, and death\as a joke, it\as true.',
		'You\all see it\as all a show,',
		'Keep \aem laughing as you go,',
		'Just remember that the last laugh is on you.',
		'And...',
		'',
		'Always look on the bright side of life !',
		'',
		'...',
		'',
		'[Thanx to sprooney@unix1.tcd.ie and to M. Python]',
		NIL ]


/*
** Convetional GadTools NewMenu structure, a memory
** saving way of definig menus.
*/

menu := [ NM_TITLE,0, 'Project'  , 0 ,0,0,0,
	  NM_ITEM ,0, 'About...' ,'?',0,0,ID_ABOUT,
	  NM_ITEM ,0, NM_BARLABEL, 0 ,0,0,0,
	  NM_ITEM ,0, 'Quit'	 ,'Q',0,0,MUIV_Application_ReturnID_Quit,
	  NM_END  ,0, NIL	 , 0 ,0,0,0]:newmenu


/*
** Here are all the little info texts
** that appear at the top of each demo window.
*/

in_Master := '\tWelcome to the MUI demonstration program. ' +
   'This little toy will show you how easy it is to create graphical user interfaces ' +
   'with MUI and how powerful the results are.\n\tMUI is based on BOOPSI, Amiga\as ' +
   'basic object oriented programming system. For details about programming, see the ' +
   '\aReadMe\a file and the documented source code of this demo. Only one thing so far: ' +
   'it\as really easy!\n\tNow go on, click around and watch this demo. Or use your ' +
   'keyboard (TAB, Return, Cursor-Keys) if you like that better. Hint: play ' +
   'around with the MUI preferences program and customize every pixel to fit ' +
   'your personal taste.'

in_Notify := '\tMUI objects communicate with each other ' +
   'with the aid of a notifcation system. This system is frequently used in every ' +
   'MUI application. Binding an up and a down arrow to a prop gadget e.g. makes up ' +
   'a scrollbar, binding a scrollbar to a list makes up a listview. You can also ' +
   'bind windows to buttons, thus the window will be opened when the button is ' +
   'pressed.\n\tRemember: The main loop of this demo program simply consists of ' +
   'a Wait(). Once set up, MUI handles all user actions concerning the GUI ' +
   'automatically.'

in_Frames := '\tEvery MUI object can have a surrounding frame. ' +
   'Several types are available, all adjustable with the preferences program.'

in_Images := '\tMUI offers a vector image class, that allows ' +
   'images to be zoomed to any dimension. Every MUI image is transformed to match the ' +
   'current screens colors before displaying.\n\tThere are several standard images for ' +
   'often used GUI components (e.g. Arrows). These standard images can be defined via ' +
   'the preferences program.'

in_Groups := '\tGroups are very important for MUI. Their ' +
   'combinations determine how the GUI will look. A group may contain any number of ' +
   'child objects, which are positioned either horizontal or vertical.\n\tWhen a ' +
   'group is layouted, the available space is distributed between all of its ' +
   'children, depending on their minimum and maximum dimensions and on their ' +
   'weight.\n\tOf course, the children of a group may be other groups. There ' +
   'are no restrictions.'

in_Backfill := '\tEvery object can have its own background, ' +
   'if it wants to. MUI offers several standard backgrounds (e.g. one of the DrawInfo ' +
   'pens or one of the rasters below).\nThe prefs program allows defining a large number ' +
   'of backgrounds... try it!'

in_Listviews := '\tMUI\as list class is very flexible. A list can ' +
   'be made up of any number of columns containing formatted text or even images. Several ' +
   'subclasses of list class (e.g. a directory class and a volume class) are available. ' +
   'All MUI lists have the capability of multi selection, just by setting a single ' +
   'flag.\n\tThe small info texts at the top of each demo window are made with floattext ' +
   'class. This one just needs a character string as input and formats the text according ' +
   'to its width.'

in_Cycle := '\tCycle gadgets, radios buttons and simple lists ' +
   'can be used to let the user pick exactly one selection from a list of choices. In this ' +
   'example, all three possibilities are shown. Of course they are connected via notification, ' +
   'so every object will immediately be notified and updated when necessary.'

in_String := '\tOf course, MUI offers a standard string gadget class ' +
   'for text input. The gadget in this example is attached to the list, you can control the ' +
   'list cursor from within the gadget.'


/*
** This are the entries for the cycle gadgets and radio buttons.
*/

cya_Computer := [ 'Amiga 500','Amiga 600','Amiga 1000 :)','Amiga 1200','Amiga 2000',
		  'Amiga 3000','Amiga 4000', 'Amiga 4000T', 'Atari ST :(', NIL ]
cya_Printer :=  [ 'HP Deskjet','NEC P6','Okimate 20',NIL ]
cya_Display :=  [ 'A1081','NEC 3D','A2024','Eizo T660i',NIL ]


/*
** This is where it all begins...
**
** Every MUI application needs an application object
** which will hold general information and serve as
** a kind of anchor for user input, ARexx functions,
** commodities interface, etc.
**
** An application may have any number of SubWindows
** which can all be created in the same call or added
** later, according to your needs.
**
** Note that creating a window does not mean to
** open it, this will be done later by setting
** the windows open attribute.
*/

    ap_Demo := ApplicationObject,
	    MUIA_Application_Title,	  'MUI-Demo',
	    MUIA_Application_Version,	  '$VER: MUI-Demo 8.54E (12.07.94)',
	    MUIA_Application_Copyright,	  'Copyright ©1992-94, Stefan Stuntz',
	    MUIA_Application_Author,	  'Stefan Stuntz',
	    MUIA_Application_Description, 'Demonstrate the features of MUI.',
	    MUIA_Application_Base,	  'MUIDEMO',
	    MUIA_Application_Menustrip,	  Mui_MakeObjectA(MUIO_MenustripNM,[menu,0]),

	    SubWindow,
		wi_String := WindowObject,
		    MUIA_Window_Title, 'String',
		    MUIA_Window_ID, "STRG",
		    WindowContents, VGroup,
			Child, list(in_String),
			Child, lv_Brian := ListviewObject,
			    MUIA_Listview_Input, MUI_TRUE,
			    MUIA_Listview_List, ListObject,
				InputListFrame,
			    End,
			End,
			Child, st_Brian := StringObject,
			   StringFrame,
			End,
		    End,
		End,

	    SubWindow,
		wi_Cycle := WindowObject,
		    MUIA_Window_Title, 'Cycle Gadgets & RadioButtons',
		    MUIA_Window_ID, "CYCL",
		    WindowContents, VGroup,
			Child, list(in_Cycle),
			Child, HGroup,
			    Child, mt_Computer := Radio('Computer:',cya_Computer),
			    Child, VGroup,
				Child, mt_Printer := Radio('Printer:',cya_Printer),
				Child, VSpace(0),
				Child, mt_Display := Radio('Display:',cya_Display),
			    End,
			    Child, VGroup,
				Child, ColGroup(2),
				    GroupFrameT('Cycle Gadgets'),
				    Child, KeyLabel1('Computer:',"c"),
				    Child, cy_Computer := KeyCycle(cya_Computer,"c"),
				    Child, KeyLabel1('Printer:' ,"p"),
				    Child, cy_Printer  := KeyCycle(cya_Printer ,"p"),
				    Child, KeyLabel1('Display:' ,"d"),
				    Child, cy_Display  := KeyCycle(cya_Display ,"d"),
				End,
				Child, lv_Computer := ListviewObject,
				    MUIA_Listview_Input, MUI_TRUE,
				    MUIA_Listview_List, ListObject,
					InputListFrame,
				    End,
				End,
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Listviews := WindowObject,
		    MUIA_Window_Title, 'Listviews',
		    MUIA_Window_ID, "LIST",
		    WindowContents, VGroup,
			Child, list(in_Listviews),
			Child, HGroup,
			    GroupFrameT('Dir & Volume List'),
			    Child, lv_Directory := ListviewObject,
				MUIA_Listview_Input, MUI_TRUE,
				MUIA_Listview_MultiSelect, MUI_TRUE,
				MUIA_Listview_List, DirlistObject,
				    InputListFrame,
				    MUIA_Dirlist_Directory, 'ram:',
				    MUIA_List_Title, MUI_TRUE,
				End,
			    End,
			    Child, lv_Volumes := ListviewObject,
				MUIA_Weight, 20,
				MUIA_Listview_Input, MUI_TRUE,
				MUIA_Listview_List, VolumelistObject,
				    InputListFrame,
				    MUIA_Dirlist_Directory, "ram:",
				End,
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Notify := WindowObject,
		    MUIA_Window_Title, 'Notifying',
		    MUIA_Window_ID, "BRCA",
		    WindowContents, VGroup,
			Child, list(in_Notify),
			Child, HGroup,
			    GroupFrameT('Connections'),
			    Child, ga_Gauge1 := GaugeObject,
				GaugeFrame,
				MUIA_Gauge_Horiz, FALSE,
				MUIA_FixWidth, 16,
			    End,
			    Child, pr_PropL := vprop(),
			    Child, pr_PropR := vprop(),
			    Child, VGroup,
				Child, VSpace(0),
				Child, pr_PropA := hprop(),
				Child, HGroup,
				    Child, pr_PropH := hprop(),
				    Child, pr_PropV := hprop(),
				End,
				Child, VSpace(0),
				Child, VGroup,
				    GroupSpacing(1),
				    Child, ga_Gauge2 := GaugeObject,
					GaugeFrame,
					MUIA_Gauge_Horiz, MUI_TRUE,
				    End,
				    Child, ScaleObject,
					MUIA_Scale_Horiz, MUI_TRUE,
				    End,
				End,
				Child, VSpace(0),
			    End,
			    Child, pr_PropT := vprop(),
			    Child, pr_PropB := vprop(),
			    Child, ga_Gauge3 := GaugeObject,
				GaugeFrame,
				MUIA_Gauge_Horiz, FALSE,
				MUIA_FixWidth, 16,
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Backfill := WindowObject,
		    MUIA_Window_Title, 'Backfill',
		    MUIA_Window_ID, "BACK",
		    WindowContents, VGroup,
			Child, list(in_Backfill),
			Child, VGroup,
			    GroupFrameT('Standard Backgrounds'),
			    Child, HGroup,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_BACKGROUND,
				End,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_FILL,
				End,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_SHADOW,
				End,
			    End,
			    Child, HGroup,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_SHADOWBACK,
				End,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_SHADOWFILL,
				End,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_SHADOWSHINE,
				End,
			    End,
			    Child, HGroup,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_FILLBACK,
				End,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_SHINEBACK,
				End,
				Child, RectangleObject,
				    TextFrame,
				    MUIA_Background, MUII_FILLSHINE,
				End,
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Groups := WindowObject,
		    MUIA_Window_Title, 'Groups',
		    MUIA_Window_ID, "GRPS",
		    WindowContents, VGroup,
			Child, list(in_Groups),
			Child, HGroup,
			    GroupFrameT('Group Types'),
			    Child, HGroup,
				GroupFrameT('Horizontal'),
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
			    End,
			    Child, VGroup,
				GroupFrameT('Vertical'),
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
			    End,
			    Child, ColGroup(3),
				GroupFrameT('Array'),
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
				Child, RectangleObject, TextFrame, End,
			    End,
			End,
			Child, HGroup,
			    GroupFrameT('Different Weights'),
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ec25 kg',
				MUIA_Weight, 25,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ec50 kg',
				MUIA_Weight, 50,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ec75 kg',
				MUIA_Weight, 75,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ec100 kg',
				MUIA_Weight, 100,
			    End,
			End,
			Child, HGroup,
			    GroupFrameT('Fixed & Variable Sizes'),
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, 'fixed',
				MUIA_Text_SetMax, MUI_TRUE,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecfree',
				MUIA_Text_SetMax, FALSE,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, 'fixed',
				MUIA_Text_SetMax, MUI_TRUE,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecfree',
				MUIA_Text_SetMax, FALSE,
			    End,
			    Child, TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, 'fixed',
				MUIA_Text_SetMax, MUI_TRUE,
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Frames := WindowObject,
		    MUIA_Window_Title, 'Frames',
		    MUIA_Window_ID, "FRMS",
		    WindowContents, VGroup,
			Child, list(in_Frames),
			Child, ColGroup(2),
			    Child, TextObject,
				ButtonFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecButton',
			    End,
			    Child, TextObject,
				ImageButtonFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecImageButton',
			    End,
			    Child, TextObject,
				TextFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecText',
			    End,
			    Child, TextObject,
				StringFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecString',
			    End,
			    Child, TextObject,
				ReadListFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecReadList',
			    End,
			    Child, TextObject,
				InputListFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecInputList',
			    End,
			    Child, TextObject,
				PropFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecProp Gadget',
			    End,
			    Child, TextObject,
				GroupFrame,
				InnerSpacing(2,1),
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, '\ecGroup',
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Images := WindowObject,
		    MUIA_Window_Title, 'Images',
		    MUIA_Window_ID, "IMGS",
		    WindowContents, VGroup,
			Child, list(in_Images),
			Child, HGroup,
			    Child, ColGroup(2),
				GroupFrameT('Some Images'),
				Child, Label('ArrowUp:'),    Child, image(MUII_ArrowUp),
				Child, Label('ArrowDown:'),  Child, image(MUII_ArrowDown),
				Child, Label('ArrowLeft:'),  Child, image(MUII_ArrowLeft),
				Child, Label('ArrowRight:'), Child, image(MUII_ArrowRight),
				Child, Label('RadioButton:'),Child, image(MUII_RadioButton),
				Child, Label('File:'),       Child, image(MUII_PopFile),
				Child, Label('HardDisk:'),   Child, image(MUII_HardDisk),
				Child, Label('Disk:'),       Child, image(MUII_Disk),
				Child, Label('Chip:'),       Child, image(MUII_Chip),
				Child, Label('Drawer:'),     Child, image(MUII_Drawer),
			    End,
			    Child, VGroup,
				GroupFrameT('Scale Engine'),
				Child, VSpace(0),
				Child, HGroup,
				    Child, scaledImage(MUII_RadioButton,1,17, 9),
				    Child, scaledImage(MUII_RadioButton,1,20,12),
				    Child, scaledImage(MUII_RadioButton,1,23,15),
				    Child, scaledImage(MUII_RadioButton,1,26,18),
				    Child, scaledImage(MUII_RadioButton,1,29,21),
				End,
				Child, VSpace(0),
				Child, HGroup,
				    Child, scaledImage(MUII_CheckMark,1,13, 7),
				    Child, scaledImage(MUII_CheckMark,1,16,10),
				    Child, scaledImage(MUII_CheckMark,1,19,13),
				    Child, scaledImage(MUII_CheckMark,1,22,16),
				    Child, scaledImage(MUII_CheckMark,1,25,19),
				    Child, scaledImage(MUII_CheckMark,1,28,22),
				End,
				Child, VSpace(0),
				Child, HGroup,
				    Child, scaledImage(MUII_PopFile,0,12,10),
				    Child, scaledImage(MUII_PopFile,0,15,13),
				    Child, scaledImage(MUII_PopFile,0,18,16),
				    Child, scaledImage(MUII_PopFile,0,21,19),
				    Child, scaledImage(MUII_PopFile,0,24,22),
				    Child, scaledImage(MUII_PopFile,0,27,25),
				End,
				Child, VSpace(0),
			    End,
			End,
		    End,
		End,

	    SubWindow,
		wi_Master := WindowObject,
		    MUIA_Window_Title, 'MUI-Demo',
		    MUIA_Window_ID,    "MAIN",
		    WindowContents, VGroup,
			Child, TextObject,
			    GroupFrame,
			    MUIA_Background, MUII_SHADOWFILL,
			    MUIA_Text_Contents, '\ec\e8MUI - \ebM\enagic\ebU\enser\ebI\ennterface\nwritten 1992-94 by Stefan Stuntz',
			End,
			Child, list(in_Master),
			Child, VGroup,
			    GroupFrameT('Available Demos'),
			    Child, HGroup,
				MUIA_Group_SameWidth, MUI_TRUE,
				Child, bt_Groups    := SimpleButton('_Groups'),
				Child, bt_Frames    := SimpleButton('_Frames'),
				Child, bt_Backfill  := SimpleButton('_Backfill'),
			    End,
			    Child, HGroup,
				MUIA_Group_SameWidth, MUI_TRUE,
				Child, bt_Notify    := SimpleButton('_Notify'),
				Child, bt_Listviews := SimpleButton('_Listviews'),
				Child, bt_Cycle     := SimpleButton('_Cycle'),
			    End,
			    Child, HGroup,
				MUIA_Group_SameWidth, MUI_TRUE,
				Child, bt_Images    := SimpleButton('_Images'),
				Child, bt_String    := SimpleButton('_Strings'),
				Child, bt_Quit      := SimpleButton('_Quit'),
			    End,
			End,
		    End,
		End,
	    End


/*
** See if the application was created.
**
** Note that we do not need any
** error control for the sub objects since every error
** will automatically be forwarded to the parent object
** and cause this one to fail too.
*/

   IF ap_Demo=NIL THEN Raise(ER_APP)



/*
** Here comes the notifcation magic. Notifying means:
** When an attribute of an object changes, then please change
** another attribute of another object (accordingly) or send
** a method to another object.
*/

/*
** Lets bind the sub windows to the corresponding button
** of the master window.
*/

   doMethod(bt_Frames   ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Frames   ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Images   ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Images   ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Notify   ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Notify   ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Listviews,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Listviews,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Groups   ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Groups   ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Backfill ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Backfill ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Cycle    ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Cycle    ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_String   ,[MUIM_Notify,MUIA_Pressed,FALSE,wi_String   ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
   doMethod(bt_Quit     ,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Demo,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** Automagically remove a window when the user hits the close gadget.
*/

   doMethod(wi_Images   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Images   ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Frames   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Frames   ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Notify   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Notify   ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Listviews,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Listviews,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Groups   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Groups   ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Backfill ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Backfill ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_Cycle    ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Cycle    ,3,MUIM_Set,MUIA_Window_Open,FALSE])
   doMethod(wi_String   ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_String   ,3,MUIM_Set,MUIA_Window_Open,FALSE])


/*
** Closing the master window forces a complete shutdown of the application.
*/

   doMethod(wi_Master,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,ap_Demo,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** This connects the prop gadgets in the notification demo window.
*/

   doMethod(pr_PropA,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropH,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropA,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropV,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropH,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropL,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropH,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropR,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropV,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropT,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])
   doMethod(pr_PropV,[MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,pr_PropB,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue])

   doMethod(pr_PropA ,[MUIM_Notify,MUIA_Prop_First   ,MUIV_EveryTime,ga_Gauge2,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])
   doMethod(ga_Gauge2,[MUIM_Notify,MUIA_Gauge_Current,MUIV_EveryTime,ga_Gauge1,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])
   doMethod(ga_Gauge2,[MUIM_Notify,MUIA_Gauge_Current,MUIV_EveryTime,ga_Gauge3,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])


/*
** And here we connect cycle gadgets, radio buttons and the list in the
** cycle & radio window.
*/

   doMethod(cy_Computer,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mt_Computer,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])
   doMethod(cy_Printer ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mt_Printer ,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])
   doMethod(cy_Display ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mt_Display ,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])
   doMethod(mt_Computer,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,cy_Computer,3,MUIM_Set,MUIA_Cycle_Active,MUIV_TriggerValue])
   doMethod(mt_Printer ,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,cy_Printer ,3,MUIM_Set,MUIA_Cycle_Active,MUIV_TriggerValue])
   doMethod(mt_Display ,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,cy_Display ,3,MUIM_Set,MUIA_Cycle_Active,MUIV_TriggerValue])
   doMethod(mt_Computer,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,lv_Computer,3,MUIM_Set,MUIA_List_Active ,MUIV_TriggerValue])
   doMethod(lv_Computer,[MUIM_Notify,MUIA_List_Active ,MUIV_EveryTime,mt_Computer,3,MUIM_Set,MUIA_Radio_Active,MUIV_TriggerValue])


/*
** This one makes us receive input ids from several list views.
*/

   doMethod(lv_Volumes ,[MUIM_Notify,MUIA_Listview_DoubleClick,MUI_TRUE,ap_Demo,2,MUIM_Application_ReturnID,ID_NEWVOL])
   doMethod(lv_Brian   ,[MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,ap_Demo,2,MUIM_Application_ReturnID,ID_NEWBRI])


/*
** Now lets set the TAB cycle chain for some of our windows.
*/

   doMethod(wi_Master   ,[MUIM_Window_SetCycleChain,bt_Groups,bt_Frames,bt_Backfill,bt_Notify,bt_Listviews,bt_Cycle,bt_Images,bt_String,NIL])
   doMethod(wi_Listviews,[MUIM_Window_SetCycleChain,lv_Directory,lv_Volumes,NIL])
   doMethod(wi_Cycle    ,[MUIM_Window_SetCycleChain,mt_Computer,mt_Printer,mt_Display,cy_Computer,cy_Printer,cy_Display,lv_Computer,NIL])
   doMethod(wi_String   ,[MUIM_Window_SetCycleChain,st_Brian,NIL])


/*
** Set some start values for certain objects.
*/

   doMethod(lv_Computer,[MUIM_List_Insert,cya_Computer,-1,MUIV_List_Insert_Bottom])
   doMethod(lv_Brian   ,[MUIM_List_Insert,lvt_Brian,-1,MUIV_List_Insert_Bottom])
   set(lv_Computer,MUIA_List_Active,0)
   set(lv_Brian   ,MUIA_List_Active,0)
   set(st_Brian   ,MUIA_String_AttachedList,lv_Brian)


/*
** Everything's ready, lets launch the application. We will
** open the master window now.
*/

   set(wi_Master,MUIA_Window_Open,MUI_TRUE);


/*
** This is the main loop. As you can see, it does just nothing.
** Everything is handled by MUI, no work for the programmer.
**
** The only thing we do here is to react on a double click
** in the volume list (which causes an ID_NEWVOL) by setting
** a new directory name for the directory list. If you want
** to see a real file requester with MUI, wait for the
** next release of MFR :-)
*/


   running := TRUE  /* Not for MUI -> no need to use MUI_TRUE */

   WHILE running

      result := doMethod(ap_Demo, [MUIM_Application_Input, {signal} ])

      SELECT result

	 CASE MUIV_Application_ReturnID_Quit
	    running := FALSE

	 CASE ID_NEWVOL
	    doMethod(lv_Volumes, [MUIM_List_GetEntry, MUIV_List_GetEntry_Active, {buf} ])
	    set(lv_Directory, MUIA_Dirlist_Directory, buf)

	 CASE ID_NEWBRI
	    get(lv_Brian, MUIA_List_Active, {buf} )
	    set(st_Brian, MUIA_String_Contents, lvt_Brian[buf] )

	 CASE ID_ABOUT
	    Mui_RequestA(ap_Demo, wi_Master, 0, NIL, 'OK', 'MUI-Demo\n© 1992-94 by Stefan Stuntz',NIL)

      ENDSELECT

      IF signal THEN Wait(signal)

   ENDWHILE

/*
** Call the exception handling with ER_NON, this will dispose the
** application object, close "muimaster.library" and end the program.
*/

  Raise(ER_NON)

EXCEPT
  IF ap_Demo THEN Mui_DisposeObject(ap_Demo)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  
  SELECT exception
    CASE ER_MUILIB
      WriteF('Failed to open \s.\n',MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      WriteF('Failed to create application.\n')
      CleanUp(20)
      
  ENDSELECT
ENDPROC 0


/*
** Some PROCs as replacement for macros
*/

PROC list(ftxt)
    DEF obj
    obj :=  ListviewObject,
	MUIA_Weight, 50,
	MUIA_Listview_Input, FALSE,
	MUIA_Listview_List,FloattextObject,
	    MUIA_Frame, MUIV_Frame_ReadList,
	    MUIA_Floattext_Text, ftxt,
	    MUIA_Floattext_TabSize, 4,
	    MUIA_Floattext_Justify, MUI_TRUE,
	End,
    End
ENDPROC obj

PROC image(nr)
    DEF obj
    obj := ImageObject,
	MUIA_Image_Spec, nr,
    End
ENDPROC obj

PROC scaledImage(nr,s,x,y)
    DEF obj
    obj := ImageObject,
	MUIA_Image_Spec, nr,
	MUIA_FixWidth, x,
	MUIA_FixHeight,y,
	MUIA_Image_FreeHoriz, MUI_TRUE,
	MUIA_Image_FreeVert,  MUI_TRUE,
	MUIA_Image_State, s,
    End
ENDPROC obj

PROC hprop()
    DEF obj
    obj := PropObject,
	PropFrame,
	MUIA_Prop_Horiz, MUI_TRUE,
	MUIA_FixHeight, 8,
	MUIA_Prop_Entries, 111,
	MUIA_Prop_Visible, 10,
    End
ENDPROC obj

PROC vprop()
    DEF obj
    obj := PropObject,
	PropFrame,
	MUIA_Prop_Horiz, FALSE,
	MUIA_FixWidth , 8,
	MUIA_Prop_Entries, 111,
	MUIA_Prop_Visible, 10,
    End
ENDPROC obj


/*
** doMethod (written by Wouter van Oortmerssen)
*/

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

/*
** This is the end...
*/
