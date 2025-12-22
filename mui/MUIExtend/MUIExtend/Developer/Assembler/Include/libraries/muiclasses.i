****************************************************************************
** $VER: muiclasses.i V3.8 (21.8.97) Same as supported MUI version.
****************************************************************************
**
** This is a class tree. If you want to put your own classes in here then
** you can, *but* only official (+custom) classes will be put in the
** distribution.
**
** NOTE: You *MUST* put the subclasses before the classes - this allows the
** optimisation to work.
**
****************************************************************************

****************************************************************************
** Privat# Custom Classes - put here and the installer (when I write it)  **
**  will preserve the information. Remember that if you don't use a class **
**  then it will not be used, and only 12 bytes will be taken up if you   **
**  use a sub-class.                                                      **
****************************************************************************

;Example:
;	MUIClass	DnDGroup,MUIC_Group,privat#,MUIC_Area,MUIA_Group_Child
;As the installer searches for the word "privat#" I have used "#"="e"

****************************************************************************
** End of Privat# Custom Classes                                          **
****************************************************************************

****************************************************************************
**	I don't know where these go, but as the're private it shouldn't matter **
****************************************************************************
	MUIClass	Colorpanel,0,"Colorpanel.mui"
	MUIClass	Cclist,0,"Cclist.mui"
****************************************************************************

			MUIClass	Configdata,MUIC_Dataspace,"Configdata.mui"
		MUIClass	Dataspace,MUIC_Semaphore,"Dataspace.mui"
		MUIClass	Applist,MUIC_Semaphore,"Applist.mui"
	MUIClass	Semaphore,MUIC_Rootclass,"Semaphore.mui"
			MUIClass	Aboutmui,MUIC_Window,"Aboutmui.mui"
		MUIClass	Window,MUIC_Notify,"Window.mui",MUIC_Menustrip,MUIA_Window_Menustrip,MUIC_Group,MUIA_Window_RootObject
			MUIClass	TimeText,MUIC_Time,"Timetext.mcc"		;Also MUIC_Text
			MUIClass	TimeString,MUIC_Time,"Timestring.mcc"	;Also MUIC_String
		MUIClass	Time,MUIC_Notify,"Time.mcc"
			MUIClass	Menustrip,MUIC_Family,"Menustrip.mui",MUIC_Menu,MUIA_Family_Child
			MUIClass	Menuitem,MUIC_Family,"Menuitem.mui",MUIC_Menuitem,MUIA_Family_Child
			MUIClass	Menu,MUIC_Family,"Menu.mui",MUIC_Menuitem,MUIA_Family_Child
		MUIClass	Family,MUIC_Notify,"Family.mui",MUIC_Any,MUIA_Family_Child
			MUIClass	Text,MUIC_Area,"Text.mui"
			MUIClass	Scale,MUIC_Area,"Scale.mui"
			MUIClass	Rectangle,MUIC_Area,"Rectangle.mui"
				MUIClass	Poppen,MUIC_Pendisplay,"Poppen.mui"
			MUIClass	Pendisplay,MUIC_Area,"Pendisplay.mui"
				MUIClass	Slider,MUIC_Numeric,"Slider.mui"
				MUIClass	Numericbutton,MUIC_Numeric,"Numericbutton.mui"
				MUIClass	Levelmeter,MUIC_Numeric,"Levelmeter.mui"
				MUIClass	Knob,MUIC_Numeric,"Knob.mui"
			MUIClass	Numeric,MUIC_Area,"Numeric.mui"
				MUIClass	NFloattext,MUIC_NList,"NFloattext.mcc"
			MUIClass	NList,MUIC_Area,"NList.mcc"
				MUIClass	Volumelist,MUIC_List,"Volumelist.mui"
				MUIClass	Scrmodelist,MUIC_List,"Scrmodelist.mui"
				MUIClass	Listtree,MUIC_List,"Listtree.mcc"
				MUIClass	Floattext,MUIC_List,"Floattext.mui"
				MUIClass	Dirlist,MUIC_List,"Dirlist.mui"
			MUIClass	List,MUIC_Area,"List.mui"
			MUIClass	Lamp,MUIC_Area,"Lamp.mcc"
				MUIClass	Popimage,MUIC_Image,"Popimage.mui"
			MUIClass	Imagedisplay,MUIC_Area,"Imagedisplay.mui"
			MUIClass	Image,MUIC_Area,"Image.mui"
			MUIClass	Icon,MUIC_Area,"Icon.mcc"
				MUIClass	Virtgroup,MUIC_Group,"Virtgroup.mui"
				MUIClass	Settingsgroup,MUIC_Group,"Settingsgroup.mui"
				MUIClass	Settings,MUIC_Group,"Settings.mui"
				MUIClass	Scrollgroup,MUIC_Group,"Scrollgroup.mui",MUIC_Virtgroup,MUIA_Scrollgroup_Contents
				MUIClass	Scrollbar,MUIC_Group,"Scrollbar.mui"
					MUIClass	Penadjust,MUIC_Register,"Penadjust.mui"
				MUIClass	Register,MUIC_Group,"Register.mui"
				MUIClass	Radio,MUIC_Group,"Radio.mui"
						MUIClass	Poplist,MUIC_Popobject,"Poplist.mui"
						MUIClass	Pophotkey,MUIC_Popobject,"Pophotkey.mcc"
						MUIClass	Popport,MUIC_Popobject,"Popport.mcc"
						MUIClass	Popposition,MUIC_Popobject,"Popposition.mcc"
						MUIClass	Popscreen,MUIC_Popobject,"Popscreen.mui"
					MUIClass	Popobject,MUIC_Popstring,"Popobject.mui",MUIC_Area,MUIA_Popobject_Object
					MUIClass	Popasl,MUIC_Popstring,"Popasl.mui"
				MUIClass	Popstring,MUIC_Group,"Popstring.mui",MUIC_String,MUIA_Popstring_String,MUIC_Area,MUIA_Popstring_Button
				MUIClass	Palette,MUIC_Group,"Palette.mui"
				MUIClass	NListview,MUIC_Group,"NListview.mcc",MUIC_NList,MUIA_NListview_NList
				MUIClass	MonthNavigator,MUIC_Group,"Monthnavigator.mcc"
				MUIClass	Mccprefs,MUIC_Group,"Mccprefs.mui"
				MUIClass	Listview,MUIC_Group,"Listview.mui",MUIC_List,MUIA_Listview_List
				MUIClass	Imageadjust,MUIC_Group,"Imageadjust.mui"
				MUIClass	Frameadjust,MUIC_Group,"Frameadjust.mui"
				MUIClass	Cycle,MUIC_Group,"Cycle.mui"
				MUIClass	Coloradjust,MUIC_Group,"Coloradjust.mui"
			MUIClass	Group,MUIC_Area,"Group.mui",MUIC_Area,MUIA_Group_Child
			MUIClass	Gauge,MUIC_Area,"Gauge.mui"
					MUIClass	MathString,MUIC_Gadget,"Mathstring.mcc"
				MUIClass	String,MUIC_Gadget,"String.mui"
				MUIClass	Prop,MUIC_Gadget,"Prop.mui"
				MUIClass	Boopsi,MUIC_Gadget,"Boopsi.mui"
			MUIClass	Gadget,MUIC_Area,"Gadget.mui"
				MUIClass	Popframe,MUIC_Framedisplay,"Popframe.mui"
			MUIClass	Framedisplay,MUIC_Area,"Framedisplay.mui"
			MUIClass	Dtpic,MUIC_Area,"Dtpic.mui"
			MUIClass	Colorfield,MUIC_Area,"Colorfield.mui"
				MUIClass	Bodychunk,MUIC_Bitmap,"Bodychunk.mui"
			MUIClass	Bitmap,MUIC_Area,"Bitmap.mui"
			MUIClass	Balance,MUIC_Area,"Balance.mui"
		MUIClass	Area,MUIC_Notify,"Area.mui"
		MUIClass	Application,MUIC_Notify,"Application.mui",MUIC_Window,MUIA_Application_Window,MUIC_Menustrip,MUIA_Application_Menustrip
	MUIClass	Notify,MUIC_Rootclass,"Notify.mui"
MUIC_Rootclass		EQU	0	;Use this for rootclass parents

