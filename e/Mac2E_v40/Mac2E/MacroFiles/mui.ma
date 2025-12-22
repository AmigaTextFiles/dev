****************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993 by Stefan Stuntz
**
** Main Header File
**
****************************************************************************
**
** This file is a modified version of the orginal mui.h file (provided with
** MUI v2.2) in order to be used in E programs.
**
** '$VER: mui_e 1.4 (27.08.94)'
**
** August 1994, Lionel Vintenat
**
****************************************************************************
** Class Tree
****************************************************************************
**
** rootclass			 (BOOPSI's base class)
** +--Notify			 (implements notification mechanism)
**    +--Family 	   (handles multiple children)
**    !  +--Menustrip		 (describes a complete menu strip)
**    !  +--Menu	   (describes a single menu)
**    !  \--Menuitem		(describes a single menu item)
**    +--Application		(main class for all applications)
**    +--Window 	   (handles intuition window related topics)
**    +--Area		   (base class for all GUI elements)
**	 +--Rectangle	   (creates (empty) rectangles)
**	 +--Image		(creates images)
**	 +--Text	   (creates some text)
**	 +--String		 (creates a string gadget)
**	 +--Prop	   (creates a proportional gadget)
**	 +--Gauge		(creates a fule gauge)
**	 +--Scale		(creates a percentage scale)
**	 +--Boopsi		 (interface to BOOPSI gadgets)
**	 +--Colorfield	   (creates a field with changeable color)
**	 +--List	   (creates a line-oriented list)
**	 !  +--Floattext   (special list with floating text)
**	 !  +--Volumelist  (special list with volumes)
**	 !  +--Scrmodelist (special list with screen modes)
**	 !  \--Dirlist	   (special list with files)
**	 +--Group		(groups other GUI elements)
**	    +--Register    (handles page groups with titles)
**	    +--Virtgroup   (handles virtual groups)
**	    +--Scrollgroup (handles virtual groups with scrollers)
**	    +--Scrollbar   (creates a scrollbar)
**	    +--Listview    (creates a listview)
**	    +--Radio	   (creates radio buttons)
**	    +--Cycle	   (creates cycle gadgets)
**	    +--Slider	   (creates slider gadgets)
**	    +--Coloradjust (creates some RGB sliders)
**	    +--Palette	   (creates a complete palette gadget)
**	    +--Colorpanel  (creates a panel of colors)
**	    +--Popstring   (base class for popups)
**		  +--Popobject(popup a MUI object in a window)
**		  \--Popasl   (popup an asl requester)
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** All macro and structure definitions follow these rules:
**
** Name 			Meaning
**
** MUIC_<class> 	      Name of a class
** MUIM_<class>_<method>      Method
** MUIP_<class>_<method>      Methods parameter structure
** MUIV_<class>_<method>_<x>  Special method value
** MUIA_<class>_<attrib>      Attribute
** MUIV_<class>_<attrib>_<x>  Special attribute value
** MUIE_<error> 	      Error return code from MUI_Error()
** MUII_<name>		      Standard MUI image
** MUIX_<code>		      Control codes for text strings
** MUIO_<name>		      Object type for MUI_MakeObject()
**
** MUIA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** Items marked with "Custom Class" are for use in custom classes only!
**



***************************************************************************
** Library specification
***************************************************************************

#define MUIMASTER_NAME 'muimaster.library'



****************************************************************************
** Control codes for text strings
****************************************************************************

#define MUIX_R	'\er'	-> right justified
#define MUIX_C	'\ec'	-> centered
#define MUIX_L	'\el'	-> left justified

#define MUIX_N	'\en'	-> normal
#define MUIX_B	'\eb'	-> bold
#define MUIX_I	'\ei'	-> italic
#define MUIX_U	'\eu'	-> underlined

#define MUIX_PT	'\e2'	-> text pen
#define MUIX_PH	'\e8'	-> highlight text pen



***************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below.
**
***************************************************************************

***************************************************************************
**
** Object Generation
** -----------------
**
** The xxxObject (and xChilds) macros generate new instances of MUI classes.
** Every xxxObject can be followed by tagitems specifying initial create
** time attributes for the new object and must be terminated with the
** End macro:
**
** obj = StringObject,
**			MUIA_String_Contents, "foo",
**			MUIA_String_MaxLen	, 40,
**			End;
**
** With the Child, SubWindow and WindowContents shortcuts you can
** construct a complete GUI within one command:
**
** app = ApplicationObject,
**
**			...
**
**			SubWindow, WindowObject,
**				WindowContents, VGroup,
**					Child, String("foo",40),
**					Child, String("bar",50),
**					Child, HGroup,
**					 Child, CheckMark(TRUE),
**					 Child, CheckMark(FALSE),
**					 End,
**					End,
**				End,
**
**			SubWindow, WindowObject,
**				WindowContents, HGroup,
**					Child, ...,
**					Child, ...,
**					End,
**				End,
**
**			...
**
**			End;
**
***************************************************************************

#define MenustripObject		Mui_NewObjectA(MUIC_Menustrip,[TAG_IGNORE,0
#define MenuObject		Mui_NewObjectA(MUIC_Menu,[TAG_IGNORE,0
#define MenuObjectT(name)	Mui_NewObjectA(MUIC_Menu,[MUIA_Menu_Title,name
#define MenuitemObject		Mui_NewObjectA(MUIC_Menuitem,[TAG_IGNORE,0
#define WindowObject		Mui_NewObjectA(MUIC_Window,[TAG_IGNORE,0
#define ImageObject		Mui_NewObjectA(MUIC_Image,[TAG_IGNORE,0
#define BitmapObject		Mui_NewObjectA(MUIC_Bitmap,[TAG_IGNORE,0
#define BodychunkObject		Mui_NewObjectA(MUIC_Bodychunk,[TAG_IGNORE,0
#define NotifyObject		Mui_NewObjectA(MUIC_Notify,[TAG_IGNORE,0
#define ApplicationObject	Mui_NewObjectA(MUIC_Application,[TAG_IGNORE,0
#define TextObject		Mui_NewObjectA(MUIC_Text,[TAG_IGNORE,0
#define RectangleObject		Mui_NewObjectA(MUIC_Rectangle,[TAG_IGNORE,0
#define ListObject		Mui_NewObjectA(MUIC_List,[TAG_IGNORE,0
#define PropObject		Mui_NewObjectA(MUIC_Prop,[TAG_IGNORE,0
#define StringObject		Mui_NewObjectA(MUIC_String,[TAG_IGNORE,0
#define ScrollbarObject		Mui_NewObjectA(MUIC_Scrollbar,[TAG_IGNORE,0
#define ListviewObject		Mui_NewObjectA(MUIC_Listview,[TAG_IGNORE,0
#define RadioObject		Mui_NewObjectA(MUIC_Radio,[TAG_IGNORE,0
#define VolumelistObject	Mui_NewObjectA(MUIC_Volumelist,[TAG_IGNORE,0
#define FloattextObject		Mui_NewObjectA(MUIC_Floattext,[TAG_IGNORE,0
#define DirlistObject		Mui_NewObjectA(MUIC_Dirlist,[TAG_IGNORE,0
#define SliderObject		Mui_NewObjectA(MUIC_Slider,[TAG_IGNORE,0
#define CycleObject		Mui_NewObjectA(MUIC_Cycle,[TAG_IGNORE,0
#define GaugeObject		Mui_NewObjectA(MUIC_Gauge,[TAG_IGNORE,0
#define ScaleObject		Mui_NewObjectA(MUIC_Scale,[TAG_IGNORE,0
#define BoopsiObject		Mui_NewObjectA(MUIC_Boopsi,[TAG_IGNORE,0
#define ColorfieldObject	Mui_NewObjectA(MUIC_Colorfield,[TAG_IGNORE,0
#define ColorpanelObject	Mui_NewObjectA(MUIC_Colorpanel,[TAG_IGNORE,0
#define ColoradjustObject	Mui_NewObjectA(MUIC_Coloradjust,[TAG_IGNORE,0
#define PaletteObject		Mui_NewObjectA(MUIC_Palette,[TAG_IGNORE,0
#define GroupObject		Mui_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define RegisterObject		Mui_NewObjectA(MUIC_Register,[TAG_IGNORE,0
#define VirtgroupObject		Mui_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define ScrollgroupObject	Mui_NewObjectA(MUIC_Scrollgroup,[TAG_IGNORE,0
#define PopstringObject		Mui_NewObjectA(MUIC_Popstring,[TAG_IGNORE,0
#define PopobjectObject		Mui_NewObjectA(MUIC_Popobject,[TAG_IGNORE,0
#define PoplistObject		Mui_NewObjectA(MUIC_Poplist,[TAG_IGNORE,0
#define PopaslObject		Mui_NewObjectA(MUIC_Popasl,[TAG_IGNORE,0
#define ScrmodelistObject	Mui_NewObjectA(MUIC_Scrmodelist,[TAG_IGNORE,0
#define VGroup			Mui_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define HGroup			Mui_NewObjectA(MUIC_Group,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroup(cols)		Mui_NewObjectA(MUIC_Group,[MUIA_Group_Columns,(cols)
#define RowGroup(rows)		Mui_NewObjectA(MUIC_Group,[MUIA_Group_Rows   ,(rows)
#define PageGroup		Mui_NewObjectA(MUIC_Group,[MUIA_Group_PageMode,MUI_TRUE
#define VGroupV			Mui_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define HGroupV			Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroupV(cols)		Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Columns,(cols)
#define RowGroupV(rows)		Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Rows   ,(rows)
#define PageGroupV		Mui_NewObjectA(MUIC_Virtgroup,[MUIA_Group_PageMode,MUI_TRUE
#define RegisterGroup(t)	Mui_NewObjectA(MUIC_Register,[MUIA_Register_Titles,(t)
#define End			TAG_DONE])

#define Child		MUIA_Group_Child
#define SubWindow	MUIA_Application_Window
#define WindowContents	MUIA_Window_RootObject



***************************************************************************
**
** Frame Types
** -----------
**
** These macros may be used to specify one of MUI's different frame types.
** Note that every macro consists of one { ti_Tag, ti_Data } pair.
**
** GroupFrameT() is a special kind of frame that contains a centered
** title text.
**
** HGroup, GroupFrameT("Horiz Groups"),
**	  Child, RectangleObject, TextFrame  , End,
**	  Child, RectangleObject, StringFrame, End,
**	  Child, RectangleObject, ButtonFrame, End,
**	  Child, RectangleObject, ListFrame  , End,
**	  End,
**
***************************************************************************

#define NoFrame			MUIA_Frame, MUIV_Frame_None
#define ButtonFrame		MUIA_Frame, MUIV_Frame_Button
#define ImageButtonFrame	MUIA_Frame, MUIV_Frame_ImageButton
#define TextFrame		MUIA_Frame, MUIV_Frame_Text
#define StringFrame		MUIA_Frame, MUIV_Frame_String
#define ReadListFrame		MUIA_Frame, MUIV_Frame_ReadList
#define InputListFrame		MUIA_Frame, MUIV_Frame_InputList
#define PropFrame		MUIA_Frame, MUIV_Frame_Prop
#define SliderFrame		MUIA_Frame, MUIV_Frame_Slider
#define GaugeFrame		MUIA_Frame, MUIV_Frame_Gauge
#define VirtualFrame		MUIA_Frame, MUIV_Frame_Virtual
#define GroupFrame		MUIA_Frame, MUIV_Frame_Group
#define GroupFrameT(s)		MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s



***************************************************************************
**
** Spacing Macros
** --------------
**
***************************************************************************

#define HVSpace			Mui_NewObjectA(MUIC_Rectangle,[TAG_DONE])
#define HSpace(x)		Mui_MakeObjectA(MUIO_HSpace,[x])
#define VSpace(x)		Mui_MakeObjectA(MUIO_VSpace,[x])
#define HCenter(obj)		(HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End)
#define VCenter(obj)		(VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End)
#define InnerSpacing(h,v)	MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x)		MUIA_Group_Spacing,x



***************************************************************************
**
** String-Object
** -------------
**
** The following macro creates a simple string gadget.
**
***************************************************************************
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		!!!!! Be careful, I renamed String macro to StringMUI, to avoid conflicts with E String() function !!!!!
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#define StringMUI(contents,maxlen)\
	StringObject,\
		StringFrame,\
		MUIA_String_MaxLen  , maxlen,\
		MUIA_String_Contents, contents,\
		End

#define KeyString(contents,maxlen,controlchar)\
	StringObject,\
		StringFrame,\
		MUIA_ControlChar    , controlchar,\
		MUIA_String_MaxLen  , maxlen,\
		MUIA_String_Contents, contents,\
		End



***************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following macro creates a checkmark gadget.
**
***************************************************************************

#define CheckMark(selected)\
	ImageObject,\
		ImageButtonFrame,\
		MUIA_InputMode     , MUIV_InputMode_Toggle,\
		MUIA_Image_Spec    , MUII_CheckMark,\
		MUIA_Image_FreeVert, MUI_TRUE,\
		MUIA_Selected	   , selected,\
		MUIA_Background	   , MUII_ButtonBack,\
		MUIA_ShowSelState  , FALSE,\
		End

#define KeyCheckMark(selected,control)\
	ImageObject,\
		ImageButtonFrame,\
		MUIA_InputMode     , MUIV_InputMode_Toggle,\
		MUIA_Image_Spec    , MUII_CheckMark,\
		MUIA_Image_FreeVert, MUI_TRUE,\
		MUIA_Selected      , selected,\
		MUIA_Background    , MUII_ButtonBack,\
		MUIA_ShowSelState  , FALSE,\
		MUIA_ControlChar   , control,\
		End



***************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**		 KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
***************************************************************************

#define SimpleButton(label) Mui_MakeObjectA(MUIO_Button,[label])

#define KeyButton(name,key)\
	TextObject,\
		ButtonFrame,\
		MUIA_Text_Contents, name,\
		MUIA_Text_PreParse, '\ec',\
		MUIA_Text_HiChar  , key,\
		MUIA_ControlChar  , key,\
		MUIA_InputMode	  , MUIV_InputMode_RelVerify,\
		MUIA_Background   , MUII_ButtonBack,\
		End



***************************************************************************
**
** Cycle-Object
** ------------
**
***************************************************************************

#define Cycle(entries)	      CycleObject, MUIA_Cycle_Entries, entries, End
#define KeyCycle(entries,key) CycleObject, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End



***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************

#define Radio(name,array)\
	RadioObject,\
		GroupFrameT(name),\
		MUIA_Radio_Entries,array,\
		End

#define KeyRadio(name,array,key)\
	RadioObject,\
		GroupFrameT(name),\
		MUIA_Radio_Entries,array,\
		MUIA_ControlChar, key,\
		End



***************************************************************************
**
** Slider-Object
** -------------
**
***************************************************************************

#define Slider(min,max,level)\
	SliderObject,\
		MUIA_Slider_Min  , min,\
		MUIA_Slider_Max  , max,\
		MUIA_Slider_Level, level,\
		End

#define KeySlider(min,max,level,key)\
	SliderObject,\
		MUIA_Slider_Min  , min,\
		MUIA_Slider_Max  , max,\
		MUIA_Slider_Level, level,\
		MUIA_ControlChar , key,\
		End



****************************************************************************
**
** Button to be used for popup objects
**
****************************************************************************

#define PopButton(img) Mui_MakeObjectA(MUIO_PopButton,[img])



***************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**	 Small: |foo   |
**	Normal: |bar   |
**	   Big: |foobar|
**	  Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2),
**		Child, Label2("Small:" ),
**	  Child, StringObject, End,
**		Child, Label2("Normal:"),
**	  Child, StringObject, End,
**		Child, Label2("Big:"   ),
**	  Child, StringObject, End,
**		Child, Label2("Huge:"  ),
**	  Child, StringObject, End,
**	  End,
**
** Note that we have three versions of the label macro, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These macros ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
***************************************************************************

#define Label(label)	Mui_MakeObjectA(MUIO_Label,[label,0])
#define Label1(label)	Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_SingleFrame])
#define Label2(label)	Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_DoubleFrame])
#define LLabel(label)	Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned])
#define LLabel1(label)	Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned OR MUIO_Label_SingleFrame])
#define LLabel2(label)	Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned OR MUIO_Label_DoubleFrame])

#define KeyLabel(label,key)	Mui_MakeObjectA(MUIO_Label,[label,key])
#define KeyLabel1(label,key)	Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_SingleFrame,key)])
#define KeyLabel2(label,key)	Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_DoubleFrame,key)])
#define KeyLLabel(label,key)	Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned,key)])
#define KeyLLabel1(label,key)	Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned OR MUIO_Label_SingleFrame,key)])
#define KeyLLabel2(label,key)	Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned OR MUIO_Label_DoubleFrame,key)])



***************************************************************************
**
** Controlling Objects
** -------------------
**
** set() and get() are two short stubs for BOOPSI GetAttr() and SetAttrs()
** calls:
**
** {
**	  char *x;
**
**	  set(obj,MUIA_String_Contents,"foobar");
**	  get(obj,MUIA_String_Contents,&x);
**
**	  printf("gadget contains '%s'\n",x);
** }
**
***************************************************************************

#define get(obj,attr,store)	GetAttr(attr,obj,store)
#define set(obj,attr,value)	SetAttrsA(obj,[obj-obj+(attr),value,TAG_DONE])
#define nnset(obj,attr,value)	SetAttrsA(obj,[MUIA_NoNotify,MUI_TRUE,obj-obj+(attr),value,TAG_DONE])

#define setmutex(obj,n)		set(obj,MUIA_Radio_Active,n)
#define setcycle(obj,n)		set(obj,MUIA_Cycle_Active,n)
#define setstring(obj,s)	set(obj,MUIA_String_Contents,s)
#define setcheckmark(obj,b)	set(obj,MUIA_Selected,b)
#define setslider(obj,l)	set(obj,MUIA_Slider_Level,l)



****************************************************************************
**
** For Boopsi Image Implementors Only:
**
** If MUI is using a boopsi image object, it will send a special method
** immediately after object creation. This method has a parameter structure
** where the boopsi can fill in its minimum and maximum size and learn if
** its used in a horizontal or vertical context.
**
** The boopsi image must use the method id (MUIM_BoopsiQuery) as return
** value. That's how MUI sees that the method is implemented.
**
** Note: MUI does not depend on this method. If the boopsi image doesn't
**       implement it, minimum size will be 0 and maximum size unlimited.
**
****************************************************************************

#define MUIP_BoopsiQuery MUI_BoopsiQuery	-> old structure name



****************************************************************************
** Macros to hide object names						  **
****************************************************************************

#define MUIC_Notify		'Notify.mui'
#define MUIC_Family		'Family.mui'
#define MUIC_Menustrip		'Menustrip.mui'
#define MUIC_Menu		'Menu.mui'
#define MUIC_Menuitem		'Menuitem.mui'
#define MUIC_Application	'Application.mui'
#define MUIC_Window		'Window.mui'
#define MUIC_Area		'Area.mui'
#define MUIC_Rectangle		'Rectangle.mui'
#define MUIC_Image		'Image.mui'
#define MUIC_Bitmap		'Bitmap.mui'
#define MUIC_Bodychunk		'Bodychunk.mui'
#define MUIC_Text		'Text.mui'
#define MUIC_String		'String.mui'
#define MUIC_Prop		'Prop.mui'
#define MUIC_Gauge		'Gauge.mui'
#define MUIC_Scale		'Scale.mui'
#define MUIC_Boopsi		'Boopsi.mui'
#define MUIC_Colorfield		'Colorfield.mui'
#define MUIC_List		'List.mui'
#define MUIC_Floattext		'Floattext.mui'
#define MUIC_Volumelist		'Volumelist.mui'
#define MUIC_Scrmodelist	'Scrmodelist.mui'
#define MUIC_Dirlist		'Dirlist.mui'
#define MUIC_Group		'Group.mui'
#define MUIC_Register		'Register.mui'
#define MUIC_Virtgroup		'Virtgroup.mui'
#define MUIC_Scrollgroup	'Scrollgroup.mui'
#define MUIC_Scrollbar		'Scrollbar.mui'
#define MUIC_Listview		'Listview.mui'
#define MUIC_Radio		'Radio.mui'
#define MUIC_Cycle		'Cycle.mui'
#define MUIC_Slider		'Slider.mui'
#define MUIC_Coloradjust	'Coloradjust.mui'
#define MUIC_Palette		'Palette.mui'
#define MUIC_Colorpanel		'Colorpanel.mui'
#define MUIC_Popstring		'Popstring.mui'
#define MUIC_Popobject		'Popobject.mui'
#define MUIC_Poplist		'Poplist.mui'
#define MUIC_Popasl		'Popasl.mui'



****************************************************************************
** Window																  **
****************************************************************************

#define MUIV_Window_AltHeight_MinMax(p)		(0-(p))
#define MUIV_Window_AltHeight_Visible(p)	(-100-(p))
#define MUIV_Window_AltHeight_Screen(p)		(-200-(p))
#define MUIV_Window_AltTopEdge_Delta(p)		(-3-(p))
#define MUIV_Window_AltWidth_MinMax(p)		(0-(p))
#define MUIV_Window_AltWidth_Visible(p)		(-100-(p))
#define MUIV_Window_AltWidth_Screen(p)		(-200-(p))
#define MUIV_Window_Height_MinMax(p)		(0-(p))
#define MUIV_Window_Height_Visible(p)		(-100-(p))
#define MUIV_Window_Height_Screen(p)		(-200-(p))
#define MUIV_Window_TopEdge_Delta(p)		(-3-(p))
#define MUIV_Window_Width_MinMax(p)		(0-(p))
#define MUIV_Window_Width_Visible(p)		(-100-(p))
#define MUIV_Window_Width_Screen(p)		(-200-(p))
