****************************************************************************
** MUIExtend Macros for MUI V3.8
****************************************************************************

	IFND	MUIEXTEND_MACROS_I
MUIEXTEND_MACROS_I	SET	1

 IFND	LIBRARIES_MUIEXTEND_I
	INCLUDE	"muiextend.i"
 ENDC	;LIBRARIES_MUIEXTEND_I

****************************************************************************
**
** Standard classes
**
****************************************************************************

AboutmuiObject	MACRO
	Object	MUIC_Aboutmui,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ApplicationObject	MACRO
	Object	MUIC_Application,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
AreaObject	MACRO
	Object	MUIC_Area,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
BalanceObject	MACRO
	Object	MUIC_Balance,\1,NULL,TAG_END	;No children, no tags
 ENDM
BitmapObject	MACRO
	Object	MUIC_Bitmap,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
BodychunkObject	MACRO
	Object	MUIC_Bodychunk,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
BoopsiObject	MACRO
	Object	MUIC_Boopsi,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ColoradjustObject	MACRO
	Object	MUIC_Coloradjust,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ColorfieldObject	MACRO
	Object	MUIC_Colorfield,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
CycleObject	MACRO
	Object	MUIC_Cycle,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
DataspaceObject	MACRO
	Object	MUIC_Dataspace,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
DirlistObject	MACRO
	Object	MUIC_Dirlist,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
FamilyObject	MACRO
	Object	MUIC_Family,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
FloattextObject	MACRO
	Object	MUIC_Floattext,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
GadgetObject	MACRO
	Object	MUIC_Gadget,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
GuageObject	MACRO
	Object	MUIC_Guage,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
GroupObject	MACRO
	Object	MUIC_Group,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ImageObject	MACRO
	Object	MUIC_Image,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
KnobObject	MACRO
	Object	MUIC_Knob,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
LevelmeterObject	MACRO
	Object	MUIC_Levelmeter,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ListObject	MACRO
	Object	MUIC_List,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ListviewObject	MACRO
	Object	MUIC_Listview,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
MenuObject	MACRO
	Object	MUIC_Menu,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
MenuitemObject	MACRO
	Object	MUIC_Menuitem,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
MenustripObject	MACRO
	Object	MUIC_Menustrip,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
NotifyObject	MACRO
	Object	MUIC_Notify,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
NumericObject	MACRO
	Object	MUIC_Numeric,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
NumericbuttonObject	MACRO
	Object	MUIC_Numericbutton,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PaletteObject	MACRO
	Object	MUIC_Palette,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PendisplayObject	MACRO
	Object	MUIC_Pendisplay,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PopaslObject	MACRO
	Object	MUIC_Popasl,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PoplistObject	MACRO
	Object	MUIC_Poplist,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PopobjectObject	MACRO
	Object	MUIC_Popobject,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PoppenObject	MACRO
	Object	MUIC_Poppen,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PopstringObject	MACRO
	Object	MUIC_Popstring,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PropObject	MACRO
	Object	MUIC_Prop,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
RadioObject	MACRO
	Object	MUIC_Radio,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
RectangleObject	MACRO
	Object	MUIC_Rectangle,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
RegisterObject	MACRO
	Object	MUIC_Register,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ScaleObject	MACRO
	Object	MUIC_Scale,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ScrollbarObject	MACRO
	Object	MUIC_Scrollbar,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ScrollgroupObject	MACRO
	Object	MUIC_Scrollgroup,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
SemaphoreObject	MACRO
	Object	MUIC_Semaphore,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
SettingsgroupObject	MACRO
	Object	MUIC_Settingsgroup,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
SliderObject	MACRO
	Object	MUIC_Slider,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
StringObject	MACRO
	Object	MUIC_String,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
TextObject	MACRO
	Object	MUIC_Text,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
VirtgroupObject	MACRO
	Object	MUIC_Virtgroup,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
VolumelistObject	MACRO
	Object	MUIC_Volumelist,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
WindowObject	MACRO
	Object	MUIC_Window,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM

****************************************************************************
**
** Macros with some tags already defined.
**
****************************************************************************

MenuObjectT	MACRO
	Object	MUIC_Menu,\1,\2,MUIA_Menu_Title,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
VGroup	MACRO
	Object	MUIC_Group,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
HGroup	MACRO
	Object	MUIC_Group,\1,\2,MUIA_Group_Horiz,TRUE,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ColGroup	MACRO
	Object	MUIC_Group,\1,\2,MUIA_Group_Columns,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
RowGroup	MACRO
	Object	MUIC_Group,\1,\2,MUIA_Grop_Rows,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PageGroup	MACRO
	Object	MUIC_Group,\1,\2,MUIA_Group_Pagemode,TRUE,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
VGroupV	MACRO
	Object	MUIC_Virtgroup,\1,\2,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
HGroupV	MACRO
	Object	MUIC_Virtgroup,\1,\2,MUIA_Group_Horiz,TRUE,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
ColGroupV	MACRO
	Object	MUIC_Virtgroup,\1,\2,MUIA_Group_Columns,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
RowGroupV	MACRO
	Object	MUIC_Virtgroup,\1,\2,MUIA_Group_Rows,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
PageGroupV	MACRO
	Object	MUIC_Virtgroup,\1,\2,MUIA_Group_Pagemode,TRUE,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM
RegisterGroup	MACRO
	Object	MUIC_Register,\1,\2,MUIA_Register_Titles,\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
 ENDM

****************************************************************************
**
** Frame types.
**
****************************************************************************

NoFrame  MACRO
	TagItem  MUIA_Frame,MUIV_Frame_None
 ENDM
ButtonFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Button
 ENDM
ImageButtonFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_ImageButton
 ENDM
TextFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Text
 ENDM
StringFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_String
 ENDM
ReadListFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_ReadList
 ENDM
InputListFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_InputList
 ENDM
PropFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Prop
 ENDM
GaugeFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Gauge
 ENDM
GroupFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Group
 ENDM
GroupFrameT MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Group,MUIA_Frame_Title,\1
 ENDM
VirtualFrame MACRO
	TagItem  MUIA_Frame,MUIV_Frame_Virtual
 ENDM

****************************************************************************
**
** Spacing Macros.
**
****************************************************************************

HVSpace	MACRO
	RectangleObject	\1,\2,TAG_END
 ENDM
HSpace	MACRO
	RectangleObject	\1,\2,MUIA_FixHeight,\3,TAG_END
 ENDM
VSpace	MACRO
	RectangleObject	\1,\2,MUIA_FixWidth,\3,TAG_END
 ENDM
;HCenter	MACRO			?????????? Help ??????????
;	HGroup
;	HSpace
;	\1
;	HSpace
; ENDM
;VCenter	MACRO			?????????? Help ??????????
;	VGroup
;	VSpace
;	\1
;	VSpace
; ENDM
InnerSpacing	MACRO
	TagItem  MUIA_InnerLeft,\1,MUIA_InnerRight,\1,MUIA_InnerTop,\2,MUIA_InnerBottom,\2
 ENDM
GroupSpacing MACRO
	Tagitem  MUIA_Group_Spacing,\1
 ENDM

****************************************************************************
**
** String-Object
** The following macro creates a simple string gadget.
**
****************************************************************************

String	MACRO
	StringObject	\1,0
	StringFrame
	TagItem  MUIA_String_MaxLen,\3
	TagItem  MUIA_String_Contents,\2
	TagEnd
 ENDM
KeyString MACRO
	StringObject	\1,0
	StringFrame
	TagItem  MUIA_ControlChar,\4
	TagItem  MUIA_String_MaxLen,\3
	TagItem  MUIA_String_Contents,\2
	TagEnd
 ENDM

****************************************************************************
**
** CheckMark-Object
** The following macro creates a checkmark gadget.
**
****************************************************************************

CheckMark MACRO
	ImageObject	\1,0,MUIA_Selected,\2
	ImageButtonFrame
	TagItem  MUIA_InputMode,MUIV_InputMode_Toggle
	TagItem  MUIA_Image_Spec,MUII_CheckMark
	TagItem  MUIA_Image_FreeVert,TRUE
	TagItem  MUIA_Background,MUII_ButtonBack
	TagItem  MUIA_ShowSelState,FALSE
	TagEnd
 ENDM
KeyCheckMark MACRO
	ImageObject	\1,0,MUIA_Selected,\2,MUIA_ControlChar,\3
	ImageButtonFrame
	TagItem  MUIA_InputMode,MUIV_InputMode_Toggle
	TagItem  MUIA_Image_Spec,MUII_CheckMark
	TagItem  MUIA_Image_FreeVert,TRUE
	TagItem  MUIA_Background,MUII_ButtonBack
	TagItem  MUIA_ShowSelState,FALSE
	TagEnd
 ENDM

****************************************************************************
**
** Button-Objects
** Note: Use small letters for KeyButtons, e.g.
** 		KeyButton "Cancel",'c' and not  KeyButton "Cancel",'C' !!
**
****************************************************************************

SimpleButton MACRO
	TextObject	\1,0,MUIA_Text_Contents,\2
	ButtonFrame
	TagItem	MUIA_Text_PreParse,PreParse
	TagItem	MUIA_Text_SetMax,FALSE
	TagItem	MUIA_InputMode,MUIV_InputMode_RelVerify
	TagItem	MUIA_Background,MUII_ButtonBack
	TagEnd
 ENDM
KeyButton MACRO
	TextObject	\1,0,MUIA_Text_Contents,\2,MUIA_Text_HiChar,\3,MUIA_ControlChar,\3
	ButtonFrame
	TagItem  MUIA_Text_PreParse,PreParse
	TagItem  MUIA_Text_SetMax,FALSE
	TagItem  MUIA_InputMode,MUIV_InputMode_RelVerify
	TagItem  MUIA_Background,MUII_ButtonBack
	TagEnd
 ENDM

****************************************************************************
**
** Cycle-Object
**
****************************************************************************

Cycle MACRO
	CycleObject	\1,0,MUIA_Cycle_Entries,\2,TAG_END
 ENDM
KeyCycle MACRO
	CycleObject	\1,0,MUIA_Cycle_Entries,\1,MUIA_ControlChar,\2,TAG_END
 ENDM

****************************************************************************
**
** Popup Object
**
****************************************************************************

PopButton MACRO
	ImageObject	\1,0
	ButtonFrame
	TagItem	MUIA_Image_Spec,\2,MUIA_Background,MUII_ButtonBack,MUIA_InputMode,MUIV_InputMode_RelVerify
	TagEnd
 ENDM

****************************************************************************
**
** Labeling Objects
** Called	Label Next,*string[,???Frame]	(macro)
** Called	KeyLabel Next,*string,key[,???Frame] (macro)
**
****************************************************************************

Label MACRO
	TextObject	\1,0,MUIA_Text_Contents,\2
	TagItem  MUIA_Text_PreParse,PreParse2
	TagItem  MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0
	IFNC	'\3',''
		\3
		TagItem	MUIA_FramePhantomHoriz,TRUE
	ENDC
	TagEnd
 ENDM
KeyLabel MACRO
	TextObject	\1,0,MUIA_Text_Contents,\2
	TagItem  MUIA_Text_PreParse,PreParse2
	TagItem  MUIA_Weight,0,MUIA_InnerLeft,0,MUIA_InnerRight,0,
	TagItem  MUIA_Text_HiChar,\3
	IFNC	'\4',''
		\4
		TagItem	MUIA_FramePhantomHoriz,TRUE
	ENDC
	TagEnd
 ENDM

***************************************************************************
**
** Radio-Object
**
***************************************************************************

Radio MACRO
	RadioObject	\1,0
	GroupFrameT \2
	TagItem  MUIA_Radio_Entries,\3
	TagEnd
 ENDM
KeyRadio MACRO
	RadioObject	\1,0
	GroupFrameT \2
	TagItem  MUIA_Radio_Entries,\3
	TagItem  MUIA_ControlChar,\4
	TagEnd
 ENDM

***************************************************************************
**
** Slider-Object
**
***************************************************************************

Slider	MACRO
	SliderObject	\1,0
	TagItem  MUIA_Slider_Min,\2
	TagItem  MUIA_Slider_Max,\3
	TagItem  MUIA_Slider_Level,\4
	TagEnd
 ENDM
KeySlider MACRO
	SliderObject	\1,0
	TagItem  MUIA_Slider_Min, \2
	TagItem  MUIA_Slider_Max, \3
	TagItem  MUIA_Slider_Level, \4
	TagItem  MUIA_ControlChar, \5
	TagEnd
 ENDM




	ENDC	;MUIEXTEND_MACROS_I
